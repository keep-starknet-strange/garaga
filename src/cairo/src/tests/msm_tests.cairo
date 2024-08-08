#[cfg(test)]
mod msm_tests {
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1, MSMHint, DerivePointFromXHint};


    #[test]
    fn test_msm_BN254_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x55953d3d37c3589a1fba47c5,
                    limb1: 0x498edbf984a7b512c575155f,
                    limb2: 0x28a245d709a0a20,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xbd63aba561b17e41e1673864,
                    limb1: 0x3859e8ceda5e3ddab45334f7,
                    limb2: 0x1306c789cf87514,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x587d94add9d7f7d0460c217056a32f8e, high: 0x15ccfc60978e3741949a602779b0c798
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                    ]
                        .span(),
                    array![
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
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
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
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
                    limb0: 0xef33c82ee88bca93aaece237,
                    limb1: 0x5eab6a12badb1784b2f25ccf,
                    limb2: 0xf2020727d81dad9,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x457f3c26e0b0327147ec3052,
                    limb1: 0x647d5f67227a460e6a122adb,
                    limb2: 0x50b40559898c804,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x82f90539274bd7e567a1817b,
                    limb1: 0x2cfe346bcf011167c8b87cc3,
                    limb2: 0xf54c7057976201b,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x2db608b0370a46562bcb5661,
                    limb1: 0x3bb98f2ffe21d000984e309a,
                    limb2: 0x9bb3413baad837a,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x79304fda8141dcb82d00b201,
                    limb1: 0x7a3e511574b1353b0d7a6bda,
                    limb2: 0xcec1886d6fca6da,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xba60d756c39bd441cd72b221,
                    limb1: 0x9fa9435105daa5c4f934bd0,
                    limb2: 0x2528e3371423ba2c,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xdab67ecee28b9ae4b3cc9d71,
                        limb1: 0x4f0673104e17614797223435,
                        limb2: 0x183b87e4d0b6ead1,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfee59329414bc3cdd743dcf0,
                        limb1: 0xdc2822db40c0ac2ef78a308d,
                        limb2: 0x183227397098d014,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x20a860106aed22f056732bcd,
                        limb1: 0xf896208599b7d4c94bdbb4ac,
                        limb2: 0x25942b0c09bd2652,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x23a8c5211bd168e90dd5d34b,
                        limb1: 0x1015ffaa41fe8bc61f19f862,
                        limb2: 0x1eba09a2f315bb30,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x1699e1a171206211b0d3fa7,
                        limb1: 0x2a77f4f9973ed0d2d88d8137,
                        limb2: 0xde8705072f38746,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa209da44ba8711017cd24eb2,
                        limb1: 0xca76acea96abac6e39d28c2a,
                        limb2: 0x1585738430d2c365,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xde43b388d24e7beb83a5ac22,
                        limb1: 0xbe9c4f33d4914cea60f67409,
                        limb2: 0x27117d10b325ef87,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x91158b16c88650a3525f88d9,
                        limb1: 0x7921d623ca24cda0b49048e1,
                        limb2: 0xff3e43e5ad432a5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x28884d61753aea451047c9a,
                        limb1: 0x77f1b948447a4af4c5cc7e95,
                        limb2: 0x2bc9ce75f80f9166,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x20a860106aed22f056732bcd,
                        limb1: 0xf896208599b7d4c94bdbb4ac,
                        limb2: 0x25942b0c09bd2652,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x23a8c5211bd168e90dd5d34b,
                        limb1: 0x1015ffaa41fe8bc61f19f862,
                        limb2: 0x1eba09a2f315bb30,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x1a95f6288e7d08d9476fbc8f,
                        limb1: 0xe952a20d789397af61a2fd8,
                        limb2: 0x2641690796314496,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa10c13e5aa09a5e1f6e77c39,
                        limb1: 0xdc2822db40c0ac2ebe1b27b6,
                        limb2: 0x183227397098d014,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x5e545dc8b2029aba53ed6f33,
                        limb1: 0xd7b42d6f59559220b1be8e26,
                        limb2: 0x1386c88e1d305a3b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8fe38816dd115b9751213407,
                        limb1: 0x41c335512dd891e30953d86e,
                        limb2: 0x1e85630ff72175ee,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x3a3ab5231b0134c268426df1,
                        limb1: 0xadfd81db8641e284745f13a4,
                        limb2: 0x2d66b6d9b03df056,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa6d4573844de06bb67216845,
                        limb1: 0x5df8b65fcc89eddb2913175b,
                        limb2: 0x1bb37d85413d22d4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb5b94fc8f1fb7ea5f940dba3,
                        limb1: 0x27a57ce5661ac7940a80c90f,
                        limb2: 0x2c8dba598afb4ce2,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xb28b4eccd9e74418234b5052,
                        limb1: 0xcecc42978a7f5e047dba3fe1,
                        limb2: 0xa300b37765f6e89,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x4738cdb75b1386af1ae69ece,
                        limb1: 0xcf95a3d08085d4b847a1eba,
                        limb2: 0x2b2bdabd0432c1a1,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x5e545dc8b2029aba53ed6f33,
                        limb1: 0xd7b42d6f59559220b1be8e26,
                        limb2: 0x1386c88e1d305a3b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8fe38816dd115b9751213407,
                        limb1: 0x41c335512dd891e30953d86e,
                        limb2: 0x1e85630ff72175ee,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x4a7de7cc0448f28152a7f21f,
                        limb1: 0xe0162c07a7bd3379c05af561,
                        limb2: 0x148ab567570ff03e,
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
                        limb0: 0x1605c250501881c92e5cadf6,
                        limb1: 0x2cc2064dbb2ee93d461f3caf,
                        limb2: 0x1ca0b888d6250410,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6c4875799392d77943dac9cb,
                        limb1: 0x1113c0353dcf11bac14e81f3,
                        limb2: 0x14236ee690bed934,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x421847589fd4220aedf271fa,
                        limb1: 0xcd38111c2407bdd59cd5254a,
                        limb2: 0x25430363076d063,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2a21fb65020fa19cfaaa0984,
                        limb1: 0x530cd3c7380e031fcd5a1738,
                        limb2: 0x2633fe41f0d69d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x70bfbfd7bd41d3c41a2cdd9a,
                        limb1: 0x95a1ab9b29a61f0f3d340669,
                        limb2: 0x4c37b1619a8f5e8,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xd99f7c63b428f944b2990c9b,
                        limb1: 0xcdf5cd32b00b635a3adc4b7b,
                        limb2: 0x257ddb27a13d6c06,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xdc6795df7e97fa54f313601a,
                        limb1: 0x7aeafae937ebdcd2ac6a1b48,
                        limb2: 0xc05fe40d10aeb72,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x1605c250501881c92e5cadf6,
                        limb1: 0x2cc2064dbb2ee93d461f3caf,
                        limb2: 0x1ca0b888d6250410,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6c4875799392d77943dac9cb,
                        limb1: 0x1113c0353dcf11bac14e81f3,
                        limb2: 0x14236ee690bed934,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x50ab05f99b99427fe3b6ae0d,
                limb1: 0x67454dfd7943a7a6e724a59f,
                limb2: 0xc67006753e7fba9,
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
                    limb0: 0xc4349d56f94feb84895f2e58,
                    limb1: 0xe7ca6f292c3fdd288f03c165,
                    limb2: 0x11f8570e50631c46,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x6ab4aef855a2e2767b911810,
                    limb1: 0x36fd982d7fb05a2514ccd2f5,
                    limb2: 0x150a35618e4f66b8,
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
                    limb0: 0xb67e7210fe920637c99d47f,
                    limb1: 0xbe254a41ad68840cab2db95d,
                    limb2: 0x531625f6e92cbf0abc9b343c,
                    limb3: 0x9d0cdab788b6398ef5224a2
                },
                y: u384 {
                    limb0: 0x956fd76f9fe01afa9e5b012d,
                    limb1: 0xa549c18da17df3cf7bdf73d4,
                    limb2: 0x96a93227f6fd5276e9b8a5d,
                    limb3: 0x68f0496392d189b14287117
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x8db2824c6a146c9681d2827f1a0cc039, high: 0x554fc3496076386f3b4a97aa9f3ab3b5
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
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
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
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
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
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
                    limb0: 0x7dc89a516f2fe2437f6f682b,
                    limb1: 0xfc478650d52ab1b89ee44f78,
                    limb2: 0xe20da93c084f379e7ba806ef,
                    limb3: 0x11abc641ff7d3bf6f14d43b3
                },
                y: u384 {
                    limb0: 0x25af0a8cbe971aa7df1f9885,
                    limb1: 0x60b2eb341433946083a53160,
                    limb2: 0x538a7e9263ddfc437f61776d,
                    limb3: 0x645082ca3f8ccdbce95f825
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x2ad431069372bc85f6dbcf67,
                    limb1: 0x7073c5abbb839a88a93dd7c9,
                    limb2: 0x87cf9bc31870a3d89816f5b8,
                    limb3: 0xfd84c4d5981139747899e83
                },
                y: u384 {
                    limb0: 0x99e113ae9e8cc9d56e90c231,
                    limb1: 0xbac12839608bf19439e262c3,
                    limb2: 0xb794a19ae7a952ec7a9ed479,
                    limb3: 0x1292eb795a76157feebfad95
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x3caac405c8d342b97cf42a19,
                    limb1: 0x623cc883d77768da3ff68666,
                    limb2: 0x332e875b7a448f2eac25c38a,
                    limb3: 0x18476931f32d2eeed8092985
                },
                y: u384 {
                    limb0: 0xfdc1ae51d09a20e377569913,
                    limb1: 0x33dcc59341b4dae44d703217,
                    limb2: 0xd637ad7f56c29c007328a090,
                    limb3: 0x9f8973d7239495d63608be0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x95a949c2cb5e418cc5e7a1b6,
                        limb1: 0xe52b6b0ac44e29259f179c7a,
                        limb2: 0x6766a5effde4f233da490c9f,
                        limb3: 0x60dd586637baeda575f3a3e
                    },
                    u384 {
                        limb0: 0x682c981c0f9fc4d796363c61, limb1: 0x29b99f46, limb2: 0x0, limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xf33942f69dc7fbe6a1e0017d,
                        limb1: 0xfd6bb458cb87f1b0dfa69f7b,
                        limb2: 0xbae25e5ae899c5dda1174612,
                        limb3: 0x1161ed8a1d457afff3553c7e
                    },
                    u384 {
                        limb0: 0xd9777e8cf4e4fd5903f618ac,
                        limb1: 0x13f4d4af6aceb682f345f727,
                        limb2: 0x51738a7bd772a060aec6ea52,
                        limb3: 0x18858fe6faf72da4b597e716
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x26ead89fab7955dd9097c7af,
                        limb1: 0xbd2abf3294246d05bbf68859,
                        limb2: 0xa63300e43d41337d7ec9000b,
                        limb3: 0x2309848fbec0af9a3d2500f
                    },
                    u384 {
                        limb0: 0x7694bc2c2891ac9e7416a014,
                        limb1: 0xed669293b445ab3fdf96fbef,
                        limb2: 0xa4c5937db99ca358e46c4d05,
                        limb3: 0x1994c8ea0ab900fc592c514c
                    },
                    u384 {
                        limb0: 0x1efa0e2ca53f079372ccddc4,
                        limb1: 0xf6601b72a92218a363d2d833,
                        limb2: 0xedc4d6c30f29493d0f94485e,
                        limb3: 0xe609cd6d31c64c3afe527c5
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x6a3d0bdb0321ef9a8780b09e,
                        limb1: 0x274d2c2140bdda7b41427df2,
                        limb2: 0x64f21fbcd978806c9d52f2cd,
                        limb3: 0x1185925402161ecb371da28e
                    },
                    u384 {
                        limb0: 0x51e1fa34a596f5640fd962af,
                        limb1: 0x1a40dadac727f79f7113dca3,
                        limb2: 0x7beb236930649ef3e08c710a,
                        limb3: 0x141309dd3f5d02c3f50ca536
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xf33942f69dc7fbe6a1e0017d,
                        limb1: 0xfd6bb458cb87f1b0dfa69f7b,
                        limb2: 0xbae25e5ae899c5dda1174612,
                        limb3: 0x1161ed8a1d457afff3553c7e
                    },
                    u384 {
                        limb0: 0xd9777e8cf4e4fd5903f618ac,
                        limb1: 0x13f4d4af6aceb682f345f727,
                        limb2: 0x51738a7bd772a060aec6ea52,
                        limb3: 0x18858fe6faf72da4b597e716
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x57352d0484e3d81c830ef271,
                        limb1: 0x5705ae2dec83083b9e646f7f,
                        limb2: 0x766a3ed452fc553e38243c26,
                        limb3: 0x14d44bf32853f76e81594dfb
                    },
                    u384 {
                        limb0: 0x242de43ed34876166ed9c0ea, limb1: 0x2bfaaef9, limb2: 0x0, limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x8af03541c8e845ee200b9348,
                        limb1: 0x601ca978fd38cef5328d1c96,
                        limb2: 0xf4f9ae5cbe547abb29672685,
                        limb3: 0xf2051e8386b4f3252e6ffdd
                    },
                    u384 {
                        limb0: 0x7b17e7d816a323168c8a06c5,
                        limb1: 0x3897c2b38dc4d78eca406ed8,
                        limb2: 0x6865eb1d62d9e8a19ed2e8ca,
                        limb3: 0x57f7f167736f6a143fe490
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xc9192ee9fa21d2fd992e7e07,
                        limb1: 0x68782b027e5eb4fde18bbd50,
                        limb2: 0xb294e17311debc12f24f1cae,
                        limb3: 0xd9c831653d45eaab0c8e5a
                    },
                    u384 {
                        limb0: 0xf12c8317c97038374e5e520c,
                        limb1: 0x7757ffb7fcdb30d587da5ac2,
                        limb2: 0xac4fd714ef788424509b5d76,
                        limb3: 0x80e19e4250f792ce19c88cc
                    },
                    u384 {
                        limb0: 0x99a156289dde1f5c986d97d1,
                        limb1: 0x33a1db11cfa6a0fbc405eecc,
                        limb2: 0x75bb7ff71a16b02533a2dd4a,
                        limb3: 0xa91ff8f2f73b92f4edab71e
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xc918d507afa317b8802ef7ca,
                        limb1: 0xb21100a207814f8c8cdc725c,
                        limb2: 0x4d4f5fc4306353e2be927496,
                        limb3: 0x87f23cc6ead6f94b564b00b
                    },
                    u384 {
                        limb0: 0xec5f9f605a8c8c5a32281b14,
                        limb1: 0xe25f0ace37135e3b2901bb61,
                        limb2: 0xa197ac758b67a2867b4ba328,
                        limb3: 0x15fdfc59dcdbda850ff9241
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x8af03541c8e845ee200b9348,
                        limb1: 0x601ca978fd38cef5328d1c96,
                        limb2: 0xf4f9ae5cbe547abb29672685,
                        limb3: 0xf2051e8386b4f3252e6ffdd
                    },
                    u384 {
                        limb0: 0x7b17e7d816a323168c8a06c5,
                        limb1: 0x3897c2b38dc4d78eca406ed8,
                        limb2: 0x6865eb1d62d9e8a19ed2e8ca,
                        limb3: 0x57f7f167736f6a143fe490
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x2fccbf6c4015668a13e9da16,
                        limb1: 0xe460a147f28136ed036b8955,
                        limb2: 0x1b8acd3caa3f4d1f4d4b86a1,
                        limb3: 0x36fb0e93b43ac9b3e787c63
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
                        limb0: 0xdae61c83b59d567d80b20c1d,
                        limb1: 0x4fb46fba2b600bec0fa0a14c,
                        limb2: 0x1d9f2420191efe126bf5b3c2,
                        limb3: 0x16503d493deba2e1a08b8198
                    },
                    u384 {
                        limb0: 0xfb290af317b800c08c2f5bd6,
                        limb1: 0xfbb117125a66e8e55423a1cd,
                        limb2: 0xcb99369036396402a2cd6c3b,
                        limb3: 0xbe26e5526518aae76a48763
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x6514b19c8838807728831d68,
                        limb1: 0xa9e933ba2b6366f61635ff79,
                        limb2: 0x2ea20ac21bad91f0f138d456,
                        limb3: 0xfe6189b243be1a26080aabc
                    },
                    u384 {
                        limb0: 0x2900d80ceec439f2438b11e,
                        limb1: 0x2f97c4b221339b231ae18e92,
                        limb2: 0x6f82ef5ae96ed5e5ee37464c,
                        limb3: 0xfd2e9670de589f3e8458d15
                    },
                    u384 {
                        limb0: 0xe51e5c21a63e275ced5a16c3,
                        limb1: 0xbc8aaeda829f772d32a99b5f,
                        limb2: 0xc6df8e535f684d7f8c1da955,
                        limb3: 0x408e02e9ec13c11004cad1f
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x579c720fa87859f602c93073,
                        limb1: 0x93f4705c96d4d43e27e8537,
                        limb2: 0xac9989fa371615bad54796cb,
                        limb3: 0xb3dbf664b2ed7b7a0db0f3d
                    },
                    u384 {
                        limb0: 0x3b502bcca4e1030230bdc4ad,
                        limb1: 0x879389a872eaad7131e28739,
                        limb2: 0xeb192d69746e448597b09e30,
                        limb3: 0x1588a76a5fc6441f8f7675d8
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xdae61c83b59d567d80b20c1d,
                        limb1: 0x4fb46fba2b600bec0fa0a14c,
                        limb2: 0x1d9f2420191efe126bf5b3c2,
                        limb3: 0x16503d493deba2e1a08b8198
                    },
                    u384 {
                        limb0: 0xfb290af317b800c08c2f5bd6,
                        limb1: 0xfbb117125a66e8e55423a1cd,
                        limb2: 0xcb99369036396402a2cd6c3b,
                        limb3: 0xbe26e5526518aae76a48763
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x7fc7b37e57b58b14a97cbf4e,
                limb1: 0x3bceb6f23bdbfcf00a19fc3b,
                limb2: 0xbd77fbb393bd11a6ea140170,
                limb3: 0x557cdb7c0a94d89e55f890
            },
            g_rhs_sqrt: array![],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 1
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xa4e818e8aa8e2f15a81ca4bf,
                    limb1: 0xe0e3bfbc8af3941b5de5b4e,
                    limb2: 0x33b8f5e62ceaf58ffac777c1,
                    limb3: 0x10ecabd21a1df5852d04ad0a
                },
                y: u384 {
                    limb0: 0x8c8cb0c9d54df35b3b9341f,
                    limb1: 0x84677a9d3d9a42ed63e7eb52,
                    limb2: 0x3d5a59111c69dc844725f951,
                    limb3: 0x18395d3b52c697551d5d6931
                }
            }
        );
    }


    #[test]
    fn test_msm_SECP256R1_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5effbfaf29950691f4c77a2f,
                    limb1: 0x7c62ba2491e2d63fb534193c,
                    limb2: 0x7cb1c5314c093d3a,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x289a147f70f271d49f82966e,
                    limb1: 0x670e6b87d17887c3e0e457a5,
                    limb2: 0x680823c792429550,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x849e77948f3369690dae3a3f164bc158, high: 0x3331f31364371df338841603189d639
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
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
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
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                    ]
                        .span(),
                    array![
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
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
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
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
                    limb0: 0x11ae4ca79872dd3e839fe8e2,
                    limb1: 0x2f087a9e648fcc1eb4f5d342,
                    limb2: 0x4eee1fa1f1a0db20,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x4e85500c2cf5503506d158e3,
                    limb1: 0xea58a8b98515f3bd7c5afb9b,
                    limb2: 0xaf24dc6d104fd494,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xdb6d5ab35773f34fb64e8f70,
                    limb1: 0x38b43f435ba3eb508fb80e7c,
                    limb2: 0x1b6d0173f564ad7b,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x2c3c29e3a085cf5e3ce70e42,
                    limb1: 0x3750e43a45b17b8fb5dac977,
                    limb2: 0x200e55e13bc9ce6d,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xd5d99f1df536c11a40eea753,
                    limb1: 0xa1949a8acca10dbffb1b74ae,
                    limb2: 0xf306ff9d1796b7ea,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x70f44a002220015dbb5c242c,
                    limb1: 0xfca09a1198eab2a311bd37af,
                    limb2: 0x3cc847e7ff0cabec,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x622a390e3c5c031ebb1db887,
                        limb1: 0xf7e3232e5e90f23353db4fca,
                        limb2: 0xd518b0acb1588d17,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfbe13c85b9c23de7784d3569,
                        limb1: 0x800000000000000029b31aa1,
                        limb2: 0x7fffffff80000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x5971045a018a7682399e1bea,
                        limb1: 0xd1fe8e2cf8e62a35658f4ba8,
                        limb2: 0x23f729b69bfc0455,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8f51f3a93df81c2f87989cee,
                        limb1: 0x5494cb3d098d5da195d61382,
                        limb2: 0x34601b2bc255e7a6,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x4b88970380162a8b95212dc4,
                        limb1: 0x4544294503fec790be8be8e4,
                        limb2: 0xb414735da4f1ad46,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8fcc8e7be18ac8f99f5e65d,
                        limb1: 0xcf725b75d66dc7204b26c7db,
                        limb2: 0xae8272f05568d068,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x971f5afb8dbe4865a498c945,
                        limb1: 0x2a6a136aa57955cf39a4aefb,
                        limb2: 0xa6ded1448c710df4,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xe9d79fd426e64a04079393f8,
                        limb1: 0x4dd98487eeb88639d0a5f841,
                        limb2: 0x19d88904e1466bf3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xcec0e055d536e2d5ad7a5b73,
                        limb1: 0x9b37cfd7336b4bc8be727631,
                        limb2: 0xeb88187ecad08610,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1e5dd5fa81e5e7af91088980,
                        limb1: 0xb62d5b9e59f06dd7a39acc2a,
                        limb2: 0xbda5e4546338dcf5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5971045a018a7682399e1be7,
                        limb1: 0xd1fe8e2cf8e62a35658f4ba8,
                        limb2: 0x23f729b69bfc0455,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8f51f3a93df81c2f87989cee,
                        limb1: 0x5494cb3d098d5da195d61382,
                        limb2: 0x34601b2bc255e7a6,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x8768df1c4e5c749bd16cdbb,
                        limb1: 0xdb25add4533ef7d2f990f554,
                        limb2: 0x339e6f4c9e89c744,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8f5a5d5b4ddec020df08d042,
                        limb1: 0xfffffffffffffffffe65877a,
                        limb2: 0xffffffff00000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xeec775c7530525befd91f447,
                        limb1: 0xa7a91cb12ea581334509dc9f,
                        limb2: 0xbc61cd00973d80cc,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc592e59d7ef7061e54e9f660,
                        limb1: 0x4ae9069812793e6fbb13d847,
                        limb2: 0x67e13959be92154b,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xe5741517809036d9b64e7f97,
                        limb1: 0x2bf2e35c0d48fc29eba46c91,
                        limb2: 0xfabcafbc3a19e3bc,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf58e07e9db0ba74a1e06df7f,
                        limb1: 0xe75700a5b6e93e69113f4a9f,
                        limb2: 0xde131d52ea628b37,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc9dd5b02127369d172eb42fb,
                        limb1: 0x91205abcc4f642071b0bd4d7,
                        limb2: 0xdcd35a5cc11d2c55,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x4748a2862cbc711682a7caad,
                        limb1: 0x9814c0dc1d901ae82c419f42,
                        limb2: 0x2401647a7273c124,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb109d979439a18ed34f5b728,
                        limb1: 0xee2336f7d2a1e24096d74704,
                        limb2: 0x3b7476a816ba5bca,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7b9b001dbee929e329147d2a,
                        limb1: 0xd330a98d3f2ccb6d33e17dda,
                        limb2: 0x232289ca6e845406,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xeec775c7530525befd91f444,
                        limb1: 0xa7a91cb12ea581334509dc9f,
                        limb2: 0xbc61cd00973d80cc,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc592e59d7ef7061e54e9f660,
                        limb1: 0x4ae9069812793e6fbb13d847,
                        limb2: 0x67e13959be92154b,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x78aa766f2eacb23d4027a373,
                        limb1: 0xfe197fd750dd9bbb9a6a1ed1,
                        limb2: 0x15935f8dbac2eb32,
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
                        limb0: 0x1faf9a57b1dbdae8aa8c2238,
                        limb1: 0xf87f566b31f351b9797ed080,
                        limb2: 0x8e4069b8534efbfc,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x4eb9062eb3554b9608c2c93b,
                        limb1: 0x25b72631d7bb06ef752c7cd6,
                        limb2: 0xf18bfeecf3049a9c,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xc7df17ad9a3b7f001c85f685,
                        limb1: 0x6c53576bdb89ddce4bc2f7dc,
                        limb2: 0x3bc0f73f8c8384f9,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf91c2c0085f925a33c16b96e,
                        limb1: 0xc11d809096f228739111ab78,
                        limb2: 0x3e023da7e3b03279,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfa87b8f5c30a70b1ec7e78dc,
                        limb1: 0xf013a233eba959bed1c8d1b3,
                        limb2: 0x1b0bdc838ab7ed0f,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x42e8d44b1aa401e56d6578ed,
                        limb1: 0xa14d315e0b7b5c5c949a29f3,
                        limb2: 0x3938dc60886f85b6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x4d09de70e691c7236ab0801f,
                        limb1: 0x8a449141db404c34bd427597,
                        limb2: 0xb5719566c7de8b93,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xe0289e6a21ce597c0d8a0497,
                        limb1: 0x42c64abfef6771ee05979030,
                        limb2: 0x8622390ed12cc416,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1faf9a57b1dbdae8aa8c2235,
                        limb1: 0xf87f566b31f351b9797ed080,
                        limb2: 0x8e4069b8534efbfc,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x4eb9062eb3554b9608c2c93b,
                        limb1: 0x25b72631d7bb06ef752c7cd6,
                        limb2: 0xf18bfeecf3049a9c,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x2641c4727ef6d685314d44d5,
                limb1: 0xa38fbefee58cf4d0f0f7ea18,
                limb2: 0x796ca482734b4e13,
                limb3: 0x0
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x99307a6c0305fe2a421a2091,
                    limb1: 0x309d614a48bf5b5a1e0c6083,
                    limb2: 0x2c3146dcce6d3659,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x3648f001c404be7716b3ac8d,
                    limb1: 0x394d856066f0f18c38b485d3,
                    limb2: 0x4439cafb6511d4a6,
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
                    limb0: 0xe36a0d8aa696635257af6415,
                    limb1: 0x2a66d3a926fc7358f35484dc,
                    limb2: 0x286047c04375f266,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x7a9f3f539403decd0e88632e,
                    limb1: 0x2b43dc004658d3876d5c8fc3,
                    limb2: 0xc455a3f40ca3c6a7,
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
                    limb0: 0x76bd91741b6dab605fef43c0,
                    limb1: 0x39fa14613a0ca005c5673035,
                    limb2: 0x45f66a149946a803,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x934be792b9d72ba2f9e999ca,
                    limb1: 0xe93803336ebf1f94e528c93e,
                    limb2: 0x6f67dfe647bf8df5,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xc569c41b6a02379e7c5e18f94d143a27, high: 0xf3fec9b8eb235f4b717435de1761a72
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
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
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
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
                    limb0: 0x95c786874ee045db67d3bd9,
                    limb1: 0x1994a72cd2ec9b12ad110243,
                    limb2: 0x5d5a2729bbef04de,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x8d25b58ac5a1b40c44f6e4a,
                    limb1: 0x804adbea03c5749f47464418,
                    limb2: 0xeed57e4c48aca542,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xcc73577f69502d732e9a15df,
                    limb1: 0x91927cc12a8f1a67b2329354,
                    limb2: 0xb19a99f44d2da16c,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x3ec7b78c76cbf22abb0a50cd,
                    limb1: 0x38c5d1f731a6a247f0a89737,
                    limb2: 0xc8ecc03431897247,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x42ecf1f44a3121d6bf91dbb0,
                    limb1: 0x7e4e3039e8c2de407a2f594e,
                    limb2: 0xf9038ceb7a4dffe7,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xeceef09488c63be1b24714c6,
                    limb1: 0x85dfd05c549a586be69b8a1b,
                    limb2: 0x2bbd49fbc6ce293,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x86aabc9d3a0f327287e95e8f,
                        limb1: 0x403ec8b666287f17bd066bb3,
                        limb2: 0x4b8e0dac109b9eb7,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x25118171c88a0b9263c873d8,
                        limb1: 0xffffffffffffffff8446d9c7,
                        limb2: 0xffffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x2290df0926a5d730df37ce11,
                        limb1: 0x44b556364f85cca545351dad,
                        limb2: 0xd837bbb209ecb6f3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7fe5f6236fa45040e9937c96,
                        limb1: 0xac714471f306c4e78d87cd87,
                        limb2: 0x5caf6ec1aaca531e,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x142e328a43fe889aeb8d87d9,
                        limb1: 0x44f0d87f7d4573b2b8efa768,
                        limb2: 0xa6eed9cf25237726,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7adaed9858f84bcca77de738,
                        limb1: 0x641aa27ce9975ffd7326ec5,
                        limb2: 0xc2ecbd5238a4d4b5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xced7932e438d77e80e8ab76b,
                        limb1: 0xef24556617627ecbe60dbe5e,
                        limb2: 0xd55515c1591e7c34,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xf1f619400e88e25b1a86b58c,
                        limb1: 0xe0f55b7c2ca89884e473cfbb,
                        limb2: 0xe98621de457900a6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7f49baf80d7e31c863086fbc,
                        limb1: 0xb718df1da52f6254deb69eb4,
                        limb2: 0x88cc074bab8845d6,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x2290df0926a5d730df37ce11,
                        limb1: 0x44b556364f85cca545351dad,
                        limb2: 0xd837bbb209ecb6f3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7fe5f6236fa45040e9937c96,
                        limb1: 0xac714471f306c4e78d87cd87,
                        limb2: 0x5caf6ec1aaca531e,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x452c7b6f048f49b0b5f7a995,
                        limb1: 0x85f4338247022a3e9063a573,
                        limb2: 0x523c1b745012cb26,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x185114f4379277c40a9ed65b,
                        limb1: 0x4e11ded,
                        limb2: 0x8000000000000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xa2067ad749a82a268c563f74,
                        limb1: 0xf9acbc9ffe62bfdc72761633,
                        limb2: 0x50667b8f19d33468,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xbccf170c7b42272b7176a290,
                        limb1: 0x34736edd9b64459288663c75,
                        limb2: 0x86efbf7198bb690,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x23f3e73c5564c9dc1bf94f55,
                        limb1: 0x6bd7ab3e9e676fe6e1539699,
                        limb2: 0xa9585795bcb7d2a0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa2934c789cda05202800fe20,
                        limb1: 0x2c9561abf479df5d73fe4a8b,
                        limb2: 0xe976ccd94e942c54,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x215d913c6416d3af2936f507,
                        limb1: 0xda8b4c9cb11f5f56fb3f1127,
                        limb2: 0x283b68babd8f5594,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x6e2d5be30399270fd65bc3ce,
                        limb1: 0xd3b9285ff4b33f07213a9b69,
                        limb2: 0x32cd60e9b4c66ede,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x29a9a1575ecf12301a3e71f0,
                        limb1: 0x6f28080f3fbde701bacba738,
                        limb2: 0x3b08e3c1b2d1fdf1,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xa2067ad749a82a268c563f74,
                        limb1: 0xf9acbc9ffe62bfdc72761633,
                        limb2: 0x50667b8f19d33468,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xbccf170c7b42272b7176a290,
                        limb1: 0x34736edd9b64459288663c75,
                        limb2: 0x86efbf7198bb690,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xe71375da014f4237a6adb160,
                        limb1: 0xa2e1753c8ee53bf5984b53de,
                        limb2: 0x62af43fc4a679be1,
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
                        limb0: 0x736949083943aaa197285395,
                        limb1: 0x789ca7c20c5f283dad3f6da6,
                        limb2: 0xb075747114907506,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf09fb68c4c7eb0b411d406cf,
                        limb1: 0xf01f5304ecae0757d39e135c,
                        limb2: 0x5561d92038845eab,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x41d88a74400f52d0b099b519,
                        limb1: 0x2ee9d22b92ae56034ccaad1a,
                        limb2: 0xfcd789f2b30dc926,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xe867f5359dd42beff962cd23,
                        limb1: 0x646dc45812f3da4e4973c910,
                        limb2: 0xe108bc1ef6ee6111,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8183e447a695fe05572a0680,
                        limb1: 0x140998074b0519ca102d5659,
                        limb2: 0xd7a9dda2e23f2ed6,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x27e0ff3990d9aa6f221a5857,
                        limb1: 0x4c48964e569a19afbcbbff8d,
                        limb2: 0xd3362f178ff3332d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x945dfdd61776d4ee7ccc374b,
                        limb1: 0x90db452278c23366c952878a,
                        limb2: 0x55acefe18b9e96b3,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x736949083943aaa197285395,
                        limb1: 0x789ca7c20c5f283dad3f6da6,
                        limb2: 0xb075747114907506,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf09fb68c4c7eb0b411d406cf,
                        limb1: 0xf01f5304ecae0757d39e135c,
                        limb2: 0x5561d92038845eab,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x4baaaf79e501aaaa6a3a4043,
                limb1: 0x710398ff60148f859ea390a8,
                limb2: 0x62c465b969ab46b5,
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
                    limb0: 0xad2ac2636e78abc7fc8d41a2,
                    limb1: 0xc841035dce7a03ecad2c0026,
                    limb2: 0x3b57bbfdcd645e52,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xb284c97263668f8327c0defe,
                    limb1: 0xf8d117a4e7852ecffd046dfb,
                    limb2: 0x5683203310d4309c,
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
                    limb0: 0x5463cfa442bf666db8d751a4,
                    limb1: 0x3e74aa7f4a4107c99b820d09,
                    limb2: 0x26096fe5639e190a,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x6dd42a73f195a205e22ac984,
                    limb1: 0x37e527f69f3e291e926b2f45,
                    limb2: 0x49c5653fb361354d,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xc34f160b6d0bff2a8d3e36f26dc5c80, high: 0x472690f5cc47c84dbf2cfc299410e3d
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
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
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
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                    ]
                        .span(),
                    array![
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
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
                    limb0: 0xc104c83fedd3a507ae73dadb,
                    limb1: 0x9def0d559a3e1400a3091cee,
                    limb2: 0x6a9aa0b77cb9a363,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xe540164fd69c7c6689b344a3,
                    limb1: 0x356427ed5d5847795392c57f,
                    limb2: 0x78fd9093df50f578,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x356123e4d7740be398c587fb,
                    limb1: 0x8515734e8fb06ea56e0d5bcd,
                    limb2: 0x426eb061af29cb38,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x578c6bfb2f568c0619ac7050,
                    limb1: 0x224ca6a390828fdfa502166d,
                    limb2: 0x5e668af71881ce6a,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x99d87ee4f8a09d21cd9e632e,
                    limb1: 0x493298b0a427c3478c55875b,
                    limb2: 0x5e80a5eba55f07ff,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x67258aed015d0712a80b5048,
                    limb1: 0xb25867dcd662f1edebc3e39a,
                    limb2: 0x6d7a6bf9033fd6a,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xa068bea3eb48efc2f35602cc,
                        limb1: 0x1ac2843712fc1bd4f01bb240,
                        limb2: 0x39c00f781d6a7846,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc885bd63df56eb0c6acab772,
                        limb1: 0x6408e7e,
                        limb2: 0x4000000000000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x1339b0c05bb92b60925d9419,
                        limb1: 0x4c8eada871b1fa502684a751,
                        limb2: 0x76b51f8eb8e7a2ce,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xea97681bcf6cf48a98b4d35b,
                        limb1: 0x239c482b1b80e435c174d607,
                        limb2: 0x6f5bef631fa84392,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x19c2fd5e796024ce6b86ebbb,
                        limb1: 0xfd7d62393d9d5b4745edd433,
                        limb2: 0x7ea4c313bf5df134,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xbb962915df628bec4c1ca233,
                        limb1: 0xd4da028a848cff945e3207ff,
                        limb2: 0x4bf89733b569873b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa044dff5ea590bc9f8e22a74,
                        limb1: 0x40bbf161ad45a588e44d971b,
                        limb2: 0x25ed2712bd80c009,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x6a417c9d0481647ef8d17efe,
                        limb1: 0x7657961b9a45bfed53b170d7,
                        limb2: 0x1afe4bea78831db,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc8c29ecdc82b656964f23d77,
                        limb1: 0xaf24a4e27c4e5144fc331082,
                        limb2: 0x535e6f9f2e4a518d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf03b875a2375d8b0ac0a8b53,
                        limb1: 0x1c5ae41257101ce2c547241b,
                        limb2: 0x1b5e5047bd072695,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1fdedbb8082b0cef8b19ab59,
                        limb1: 0x7e268eb5d32d3826923d5dae,
                        limb2: 0x5403cc625ea161b4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xea97681bcf6cf48a98b4d35b,
                        limb1: 0x239c482b1b80e435c174d607,
                        limb2: 0x6f5bef631fa84392,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xaefea966db310fa6661de6cd,
                        limb1: 0x7358fd9db859906c7b4982af,
                        limb2: 0x3d6aa0b709f50968,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x278bbf86b7b75ffa6626d4ef,
                        limb1: 0xfffffffffffffffffdcb2b07,
                        limb2: 0x7fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x4f0ad7b70cdf1d1dcae1260d,
                        limb1: 0x597de57d71ac0d4b4674adc5,
                        limb2: 0x2c1d1e8563e59701,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x763b0c76e5cc8daeae63264e,
                        limb1: 0x3c75e232260e8990f6709729,
                        limb2: 0x1787dfb8ed381bbd,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x9d9420fbab07ca4e03d93a6d,
                        limb1: 0x27dbefbd2c45e5b8697c9956,
                        limb2: 0x4e1d004541684bc4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x55221879902e4088932aec60,
                        limb1: 0x91f09735a91b60f57e094189,
                        limb2: 0x6227f00dd35a9e9,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x842dc8289e281be07e365c26,
                        limb1: 0xca92b6aa31a12d12957fda37,
                        limb2: 0x17da7f4635e16860,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x9ace8fb3fb76a505cff4b184,
                        limb1: 0xe4ab94cc6065485cc2294be6,
                        limb2: 0x3f316aa0afb87566,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3a103921ae3fa5fe1cd36385,
                        limb1: 0x1ed97bf58287a842342f5d42,
                        limb2: 0x34dc7453303dc505,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6c9285ab08f0332d00c66dbd,
                        limb1: 0xdf7cecd0e36cf473473b735a,
                        limb2: 0x322d4bfc15bab5b9,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x5bb002aeb950feacc39d3d4d,
                        limb1: 0x8b15c68ad3274b21b22d6422,
                        limb2: 0x96bcb59099f55e7,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x763b0c76e5cc8daeae63264e,
                        limb1: 0x3c75e232260e8990f6709729,
                        limb2: 0x1787dfb8ed381bbd,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x9445e3f042a55827b25766be,
                        limb1: 0x57d8a4a66fe869d981e6cdc8,
                        limb2: 0x6ede1201ffdb5865,
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
                        limb0: 0x26086065710870373b14c3e4,
                        limb1: 0x62d3c52b8cbe1947be725a27,
                        limb2: 0x7ba6ec3ba157bef4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x30c65d362feb56fa999c14b1,
                        limb1: 0x31b7f400cc27ce13059d1cd7,
                        limb2: 0x5f10a9b2ab772cc8,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x6d22b7fb63afc23bf42f5,
                        limb1: 0x19f33ec37b89e418004ed410,
                        limb2: 0x2873ee1bb1825fd7,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6f4dd8746075ea6717051054,
                        limb1: 0x71e8d7bac342f7522a2a7a0d,
                        limb2: 0x7fa81af161c92ac1,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd12d547865bf5451c05e089f,
                        limb1: 0xd53b452e19e05b07e95b26cf,
                        limb2: 0x21f95d7e39daa4cb,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x2138c52fae6f391b01fbf3fb,
                        limb1: 0xc23f8ff728dfd90334b282bd,
                        limb2: 0x1322d266e70d6773,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2ceea81b59de9c8557647607,
                        limb1: 0x99ffcb8fda8b97cba343ef99,
                        limb2: 0x6231f95bf92e03ee,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xea256de7ad522542c68bef41,
                        limb1: 0x381bc419f75bb299fea7df07,
                        limb2: 0x27d9f9a5b073f820,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x32ad8b5d1d7a51c633d0db24,
                        limb1: 0x946ba638ee39571e2a2b1084,
                        limb2: 0x58f5990f47117dda,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x30c65d362feb56fa999c14b1,
                        limb1: 0x31b7f400cc27ce13059d1cd7,
                        limb2: 0x5f10a9b2ab772cc8,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xe9da40dfd02a3aa0a46003a0,
                limb1: 0x320b007df9c8130c6b84cdfa,
                limb2: 0x20a22caaecc75eb7,
                limb3: 0x0
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x9c87e89721d1db3d7e63fba2,
                    limb1: 0x4fbc0f367c6034c0ad8c8b6d,
                    limb2: 0x74b39de58e8a950,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x4de8d25070a167d507639f9d,
                    limb1: 0x43b065801a6812f08b5a6c16,
                    limb2: 0x3325491190b0f8dc,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0xe53c983b109a534f7fc0b407,
                    limb1: 0x56c6073412d4c7ae7df34d26,
                    limb2: 0x3e8a5a4362f9cd66,
                    limb3: 0x0
                },
                u384 {
                    limb0: 0x9c9ea1ac692c8287aa59bfb9,
                    limb1: 0x925b4ce2a55af86ba2123dd,
                    limb2: 0x17d41b46591a3d83,
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
                    limb0: 0xbe58cf22768dd799873f82b8,
                    limb1: 0x6f2c32c47a3bd37d974e3634,
                    limb2: 0x3467bd8c7f72e7d4,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x8cd4150bfa856952a7a4d839,
                    limb1: 0x974cbe00e04bb04986b731ba,
                    limb2: 0x61b7a2f44e6acdbf,
                    limb3: 0x0
                }
            }
        );
    }
}
