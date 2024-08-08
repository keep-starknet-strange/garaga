#[cfg(test)]
mod msm_tests {
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1, MSMHint, DerivePointFromXHint};


    #[test]
    fn test_msm_BN254_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xdba9141392494965279d5fc1,
                    limb1: 0x7f038aebe4e601f0044c585d,
                    limb2: 0x14b530fa23f4dfc,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x6e1ebebf8da2cecf9fb5939a,
                    limb1: 0x252396582fa19cf4c5949262,
                    limb2: 0xf8d10b1f1e1e926,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x86444122063b61adfccdf2a0a25437e7, high: 0x21cabafad50361b4cd3fe85f50c3b9d0
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                    ]
                        .span(),
                    array![
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
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
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
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
                    limb0: 0xc56e9604d38d2bcb64c6432c,
                    limb1: 0x67d5ce1ab04b92b0802d4de1,
                    limb2: 0x2115056b9d625a00,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x81b836e25e0b4f212fbeb4bd,
                    limb1: 0x43b2397e35fe1298a6863634,
                    limb2: 0x2a560219627894ba,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xa05790d0b5f6b403d806fabf,
                    limb1: 0xca3cbbfe303ec15641645174,
                    limb2: 0x232b658013b22657,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xa788848de0dcb7c1c5de6c88,
                    limb1: 0xfa22acff433e3e942c34523e,
                    limb2: 0x18ed5ad102db9942,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xa28e76113741638635b3b8ad,
                    limb1: 0x7abdd2cc1b6244e70e737463,
                    limb2: 0x6c616f1bcec6020,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xe3c62dcd26e3a99028f1ec00,
                    limb1: 0xf23bd4d9f4e7d955f0d6de63,
                    limb2: 0x2b66fe1467df41e5,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x380060d18c5526e86161399a,
                        limb1: 0xc3d81fe0d1a1687faba05cdd,
                        limb2: 0x186c3f12d99b0038,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf60289ad3d8b0266282ea164, limb1: 0x2bc2b99b, limb2: 0x0, limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x8411735aff841c17eb59c69f,
                        limb1: 0x6da2fc89d96b3d4c79fa4971,
                        limb2: 0x1b7b6ca8fb7d0904,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc75a2074d64a16e64c195a5a,
                        limb1: 0xd176ecafec4fc3bd1307c451,
                        limb2: 0xe03f5f7a18ff82c,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x45924b4e766658935c0bbda4,
                        limb1: 0xd565c3dc00423b25b2af4fcc,
                        limb2: 0x2a1848d120b01ad4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8244ce32ecdb9964859e6097,
                        limb1: 0xc4738325542ce15e4f47ccee,
                        limb2: 0xbd66f13529ba9fe,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfa90987204900dc92f01e1b7,
                        limb1: 0x1857dfaa9b51d329218f3950,
                        limb2: 0x237a8509f6528701,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x23c28f83c26bc830e9905696,
                        limb1: 0x9098afe70ac05f87d66d71c3,
                        limb2: 0x220df78811457ae3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x560e615e82de44b2e44c0f0e,
                        limb1: 0x7464c60fc4ef4b3739174cf5,
                        limb2: 0x2a0be1e6e4afe886,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x8411735aff841c17eb59c69f,
                        limb1: 0x6da2fc89d96b3d4c79fa4971,
                        limb2: 0x1b7b6ca8fb7d0904,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc75a2074d64a16e64c195a5a,
                        limb1: 0xd176ecafec4fc3bd1307c451,
                        limb2: 0xe03f5f7a18ff82c,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x5e6ca3f2880bb6716baf5995,
                        limb1: 0xe9a58082305edf62136c4327,
                        limb2: 0x9c0c6bf54435c5b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb9ccf9745be8556afc2223bb,
                        limb1: 0xdc2822db40c0ac2eb79953c9,
                        limb2: 0x183227397098d014,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x959aec968987eafb805e17e7,
                        limb1: 0xa4e5d246b792cc65dfe6c921,
                        limb2: 0x29b6bf33f792800e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xec7125a8f3e08eadd8d8a2c7,
                        limb1: 0x6f0ffecc6c5c951751d0c0be,
                        limb2: 0xbed95e32b402bd5,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x1df61f4391c9e7d1171da91e,
                        limb1: 0xb4a4942ccf8f1957fe241177,
                        limb2: 0x2d2e8a22ddd0553b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc0d3e4aeede7d724032221ed,
                        limb1: 0x6433d7dd1e9e55d1dbd51d73,
                        limb2: 0x1dc64d43c4cd87fd,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xaeee5c792f9c0df166b4d3d6,
                        limb1: 0xa36c8cfdac8077f775311c45,
                        limb2: 0x1f98806f56d27620,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xefed30a92456a8c4d0204d27,
                        limb1: 0x7e10eb6723b5b47670b18641,
                        limb2: 0x1c5ba0b624543fd8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc55370fadba1ac098a89e855,
                        limb1: 0x4d2ffc654515bf45f572423c,
                        limb2: 0x23c8c1a981c08380,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x959aec968987eafb805e17e7,
                        limb1: 0xa4e5d246b792cc65dfe6c921,
                        limb2: 0x29b6bf33f792800e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xec7125a8f3e08eadd8d8a2c7,
                        limb1: 0x6f0ffecc6c5c951751d0c0be,
                        limb2: 0xbed95e32b402bd5,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x7eb80f8e4a6af9072d4b8ee,
                        limb1: 0x194a8f447369018319370f0b,
                        limb2: 0x2e8602c48f616eed,
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
                        limb0: 0x2c90bd5454ad51f7cc36f604,
                        limb1: 0xfa580734ce9fed6551f215d6,
                        limb2: 0x150d7385ad047647,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x258bc3ab4ee8748ccac249db,
                        limb1: 0x7355b6ec35e0522047a9a4b9,
                        limb2: 0x672d201109319b1,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xe5636f2f69c88f643777554a,
                        limb1: 0xd6d5a81a268c3d3c5ded1c5,
                        limb2: 0x1f7e574e96d4400d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x788215cd7370c8caead2dcc3,
                        limb1: 0xa8bdddd00739323b662a433f,
                        limb2: 0x19858713162ade10,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x55ce24a2897cbd33b3dc37fa,
                        limb1: 0xf79174e1eae50ec9a367d2e3,
                        limb2: 0xf2f6e7962e65650,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x1d406d6fc1e769d08c27e4c5,
                        limb1: 0x36b7cfe7ea5e6fd25e54d6f1,
                        limb2: 0xec40c1e25dbc2ae,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x70a34b01ecb95da66046dd91,
                        limb1: 0x5a0124c4a1a0f660d6fcee2b,
                        limb2: 0x1358760331b94d14,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x2c90bd5454ad51f7cc36f604,
                        limb1: 0xfa580734ce9fed6551f215d6,
                        limb2: 0x150d7385ad047647,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x258bc3ab4ee8748ccac249db,
                        limb1: 0x7355b6ec35e0522047a9a4b9,
                        limb2: 0x672d201109319b1,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xe65807d61876659f06f63500,
                limb1: 0xe5ac17f01008431f8dcd677,
                limb2: 0x6ac9812e44a6bdc,
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
                    limb0: 0x59a099ea9b68dc4d4c6b349f,
                    limb1: 0x4fc2f4328c6eaba5aee9fe26,
                    limb2: 0x6177929cb766f1e,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x4a6bb9e774cbdc3ac0bfd9de,
                    limb1: 0xf94adcc630107b1f11c8d407,
                    limb2: 0x3ac19af4587536a,
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
                    limb0: 0xf86717c8839474a582a503a9,
                    limb1: 0xb071e4ead9e6361b1e640ddf,
                    limb2: 0x84b14defa7adea7d1027aa6a,
                    limb3: 0x13625c3097cf35a9384490cd
                },
                y: u384 {
                    limb0: 0xe030479f9aa3b04b63d0911a,
                    limb1: 0xb3c7e59a728079c289da4adc,
                    limb2: 0xe5db131dec5c9322d6ebae6f,
                    limb3: 0xd9dc9c26a13ae7841c46f1d
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x6f5b9743d32d1f53aca1abefdd230c5d, high: 0x2f19a6fd127822ecf99430eb1577648d
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                    ]
                        .span(),
                    array![
                        0x1,
                        0x0,
                        0x0,
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
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
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
                    ]
                        .span()
                ),
            ]
                .span()
        );
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xc01878f1b71b4e61f0290136,
                    limb1: 0x3ab854105c30b86650e111e7,
                    limb2: 0x22b363a77cb19493ce7dcd62,
                    limb3: 0xc4ed1e27d07067702f20f78
                },
                y: u384 {
                    limb0: 0xb033d5a0b4be4f5fb3bd7d2d,
                    limb1: 0x10175c35e151119aac751d33,
                    limb2: 0xba3c55feb101d3103e437311,
                    limb3: 0x9ad28c1697aa89a4ddb1d4f
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x494cb488dc629a9b1b9b1696,
                    limb1: 0x11e16e4b437c7b061e4d6479,
                    limb2: 0xc7477e325c87c17dd89aa0a4,
                    limb3: 0x1261c71efeb7000cc0a08a7d
                },
                y: u384 {
                    limb0: 0x3d1b51534e37c3a2a6b2ac04,
                    limb1: 0xd2cf905f953474ea19edff31,
                    limb2: 0x34127a2b36dfcf3ea54688bf,
                    limb3: 0x1679c71f995fa3111d5f7a87
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x3fbfff5ffe4baf8afa882728,
                    limb1: 0x93cea98ae64592725f01e469,
                    limb2: 0xd246034a7bde2fdf23bfda5e,
                    limb3: 0x154224ccde5498710abbb22
                },
                y: u384 {
                    limb0: 0x1b97476fb190af4e9ee1a87c,
                    limb1: 0xbfdb8e0922f2d6f6c7c70f18,
                    limb2: 0xc1411d400040f38c976cb3ee,
                    limb3: 0xe7b8742b849166e49e5ae9b
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xcba9cfe787a29bd64c0ef209,
                        limb1: 0x64bf89408a5cd1d4dc0ca20f,
                        limb2: 0x92e7301a9ae8d757f2d6faa,
                        limb3: 0x1130c43a0059b75de85da0ed
                    },
                    u384 {
                        limb0: 0x62fdd1592ab9d61ee3988a7e, limb1: 0x37ac2fdf, limb2: 0x0, limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x5f16be4cf154a801f75b777d,
                        limb1: 0xa945e5da916ba0332ff51617,
                        limb2: 0x961393a5b3eefb634f4d9eb5,
                        limb3: 0x178a950d948ce306baf026be
                    },
                    u384 {
                        limb0: 0xaa286f45394e3cf88d315077,
                        limb1: 0xe3376c46b74afdc6ce12e035,
                        limb2: 0xdf32a817a48f17f90864adb1,
                        limb3: 0x1450f5c15e2991145b00af26
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x6e8d6a29e25ce1739e660204,
                        limb1: 0xdb9ae42599f81e083b097e00,
                        limb2: 0xd5028a9624975b74872cb6f8,
                        limb3: 0x116f3b521ea67755dde79eb9
                    },
                    u384 {
                        limb0: 0xdce195630d3ace5e11c70613,
                        limb1: 0x3ddec39f6c3f66bff74a47cc,
                        limb2: 0xebf34bc1191f19b6a4342778,
                        limb3: 0x158ce97ebbd5131aaaee035d
                    },
                    u384 {
                        limb0: 0x2d9028582d8e4c837f2bbc9,
                        limb1: 0xc83defb97630ce44d676b5b2,
                        limb2: 0xae5e07bc0801a2e16a2a02b9,
                        limb3: 0xfee6ec5541b7efdf940873b
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x685ef9349755a007dd6eddf3,
                        limb1: 0x6f851f87619b9e6063d05861,
                        limb2: 0x8e6b4810a2560afe62a74298,
                        limb3: 0x10271e77a5b3d84c0a6da3d7
                    },
                    u384 {
                        limb0: 0x94a5bd15b73bf3e234c641db,
                        limb1: 0x574b3937f91914aedc4780da,
                        limb2: 0xb2e799d864d67d5547037e89,
                        limb3: 0x340a146cc2690828aafc578
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x5f16be4cf154a801f75b777d,
                        limb1: 0xa945e5da916ba0332ff51617,
                        limb2: 0x961393a5b3eefb634f4d9eb5,
                        limb3: 0x178a950d948ce306baf026be
                    },
                    u384 {
                        limb0: 0xaa286f45394e3cf88d315077,
                        limb1: 0xe3376c46b74afdc6ce12e035,
                        limb2: 0xdf32a817a48f17f90864adb1,
                        limb3: 0x1450f5c15e2991145b00af26
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xdc8b3b55bb7480a540f8ca54,
                        limb1: 0xd863fde67cab37b5561142,
                        limb2: 0x3a2b33b4d2b2bf0d18e3c211,
                        limb3: 0xf52d4b0d2906034e18bdf5d
                    },
                    u384 {
                        limb0: 0x45df3c76127a91c52e2ffba4,
                        limb1: 0x6730d2a0f6b0f62410b296e2,
                        limb2: 0x434bacd764774b84f38512bf,
                        limb3: 0x1a0111ea397fe69a4b1ba7b6
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xf8c2cb5146967eef612a6b8e,
                        limb1: 0x71c72a98d907be274cb5316c,
                        limb2: 0x468b9b6f9e1108cd01a92086,
                        limb3: 0x1c6cced834cd1567d3ea26f
                    },
                    u384 {
                        limb0: 0x20f433ae1406f0bf61bf3b17,
                        limb1: 0xc0e520bcfff3b2700a68da4,
                        limb2: 0x3a9e8d8cc4b8eb0efe47da70,
                        limb3: 0xe3e0084dc79977e9d523421
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xce3cc380cc1f6f437ac9a3f7,
                        limb1: 0xccf704d48b94e65537af16a7,
                        limb2: 0xe852f886874c7706ef4fcc9e,
                        limb3: 0x55ab12db3ff671885290684
                    },
                    u384 {
                        limb0: 0x3a1891cac4732582ac381fe7,
                        limb1: 0x3cb98ecd82de5bc911e71319,
                        limb2: 0xab6affca7a1f841b7194d778,
                        limb3: 0xc0b92df8101895e7a2ef55b
                    },
                    u384 {
                        limb0: 0x214e05bbcc5c95d00849bb84,
                        limb1: 0xb140dd8b833239a30090fc53,
                        limb2: 0xcea771f45bb049e1ff99034c,
                        limb3: 0x17c4261bc1b7ca0915562775
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xe30b2d451a59fbbd84a9ae38,
                        limb1: 0xc71caa63641ef89d32d4c5b3,
                        limb2: 0x1a2e6dbe7844233406a48219,
                        limb3: 0x71b33b60d334559f4fa89bd
                    },
                    u384 {
                        limb0: 0x2128ceb8dc1dc2fd86fd9706,
                        limb1: 0x61d7a2ed529b0053c5423693,
                        limb2: 0x63e2dc8449f5153212154441,
                        limb3: 0x4f5de3efee690c5df118118
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xf8c2cb5146967eef612a6b8e,
                        limb1: 0x71c72a98d907be274cb5316c,
                        limb2: 0x468b9b6f9e1108cd01a92086,
                        limb3: 0x1c6cced834cd1567d3ea26f
                    },
                    u384 {
                        limb0: 0x20f433ae1406f0bf61bf3b17,
                        limb1: 0xc0e520bcfff3b2700a68da4,
                        limb2: 0x3a9e8d8cc4b8eb0efe47da70,
                        limb3: 0xe3e0084dc79977e9d523421
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x85226755115f5da41f40ff83,
                        limb1: 0xa5faf308ba7008e186cb1354,
                        limb2: 0x241f45c8c6c4024cfe85d422,
                        limb3: 0xf9d2326f6530ea3f7f066de
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
                        limb0: 0x6ceac8dff17ea0afb5d416ec,
                        limb1: 0x5516b401c19f777da66640,
                        limb2: 0xe6cbe7eb71cae10dad2e3eb3,
                        limb3: 0x17065e56c0f5b810bba19992
                    },
                    u384 {
                        limb0: 0x28474c16df50b5d9e9dc6ced,
                        limb1: 0xc180bacacceee8aba15cb71c,
                        limb2: 0xa9be2b5a8c115a27f72a97bc,
                        limb3: 0x64b287e6ce39d0679cf6215
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x626b8297281027f8c18a7e18,
                        limb1: 0xda82665f70eeb63ed03c17e8,
                        limb2: 0x41cbb91a792003a75a9567ba,
                        limb3: 0x2d675c0d7b1d49e17229c21
                    },
                    u384 {
                        limb0: 0xb4dae8ab55f609a1ce3f1416,
                        limb1: 0xdb86274cb4b6995e3847e615,
                        limb2: 0xc9db6da7e91562327eb3463,
                        limb3: 0x1102f16bb895c9d3c6736309
                    },
                    u384 {
                        limb0: 0x59a9aeca6fb808de761f0379,
                        limb1: 0x97bb9e9d5ff27b6306a45d94,
                        limb2: 0x84bc71c12031d2a6f4fdb4e4,
                        limb3: 0xfede13ea9228ea9dc7587e5
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x9faf238097fd82bed7515baf,
                        limb1: 0xcbc1e2ed22f39b719a959905,
                        limb2: 0xd14c992799c5a1a7da29c28d,
                        limb3: 0xe16439c57572c740d336f28
                    },
                    u384 {
                        limb0: 0xa11d305b7d42d767a771b3b4,
                        limb1: 0x602eb2b33bba2ae8572dc70,
                        limb2: 0xa6f8ad6a3045689fdcaa5ef3,
                        limb3: 0x192ca1f9b38e7419e73d8856
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x6ceac8dff17ea0afb5d416ec,
                        limb1: 0x5516b401c19f777da66640,
                        limb2: 0xe6cbe7eb71cae10dad2e3eb3,
                        limb3: 0x17065e56c0f5b810bba19992
                    },
                    u384 {
                        limb0: 0x28474c16df50b5d9e9dc6ced,
                        limb1: 0xc180bacacceee8aba15cb71c,
                        limb2: 0xa9be2b5a8c115a27f72a97bc,
                        limb3: 0x64b287e6ce39d0679cf6215
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x76457d02e4e5390cf62da7eb,
                limb1: 0x70e3ce483c3d962ebc1e758a,
                limb2: 0x6c96d95a41fdaf8e80f59342,
                limb3: 0x43a938bf6ee3c78eb88435e
            },
            g_rhs_sqrt: array![],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 1
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x3ad756cd065125907eaa2b06,
                    limb1: 0xc484ce85f17a46fe99a085f,
                    limb2: 0xa8fc8c3d6945779b2bcb37e,
                    limb3: 0xf80b3385236a001e3103a19
                },
                y: u384 {
                    limb0: 0x79959697e972854d060707db,
                    limb1: 0xaa3b8119611bca26ca4e0072,
                    limb2: 0xadee86ec814ae7bdb3a3b489,
                    limb3: 0xc2e3c1464438b6b19f05595
                }
            }
        );
    }


    #[test]
    fn test_msm_SECP256R1_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xa28e6b3c7c9bf5af784b5150,
                    limb1: 0xed1efb608ef5a6fa9ddb1556,
                    limb2: 0x332688c0d369201e,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x63f8316bafb96d94e3a41eb0,
                    limb1: 0xacc256b1cc99913e2650e837,
                    limb2: 0x619356f73792b612,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x4fbca90e82ab55a624213cacd08dbe0f, high: 0xe7630d872049433b7e96a2e69f27ac17
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                    ]
                        .span(),
                    array![
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
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
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
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
                        0x1,
                        0x1,
                        0x1,
                        0x0,
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
                    limb0: 0xb6a43e55a5262f3b7643714e,
                    limb1: 0x97314f906618fc07bf66318a,
                    limb2: 0xffbd1f509d7e5ccf,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x4bfcd58abc4bad3135b3c52d,
                    limb1: 0x76c34b40881831a5d57c1f6f,
                    limb2: 0xb684ca2804558495,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x871f6356c72c9269e94492d6,
                    limb1: 0x85f9dd8887f18e3dd667309c,
                    limb2: 0xaba6c8946bdde1fc,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xcb05d0e289a8b7fe059f5418,
                    limb1: 0xa79a365aa2f16202de2caee5,
                    limb2: 0x9c4a2b724b5eff6,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x7e055f5aa22597e3f03b022b,
                    limb1: 0xe5affe84e06cf3ee5a386fbd,
                    limb2: 0xfa3fa6dae3bfd0b5,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xed1c2f36fd6d2d5067ba8da9,
                    limb1: 0xec7489ff3ad0d6385fc64c32,
                    limb2: 0xb263ac7a623cfcbe,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x65df19440b7513cdd3cf9651,
                        limb1: 0x36636f6b3561cbc046444ce7,
                        limb2: 0xee02e83ca10e4f4e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x209da0b8af3296304d360616, limb1: 0x23c000bb, limb2: 0x0, limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xf0ecdfad8162395adb7da58b,
                        limb1: 0x13e60f3c32a7627775c99c23,
                        limb2: 0x41b0859f013983f3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa6cd566dde3ddb1511713d60,
                        limb1: 0x7bafb50f0af15cfda2beb920,
                        limb2: 0xcd1c57ec8f188313,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x6687dd36ef7ee3430758cf88,
                        limb1: 0xc0c4c74f2063e4fd1b72b75b,
                        limb2: 0x968efe0d1928c507,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1add507cc6160f7ed612b600,
                        limb1: 0x95a30fbcb2dc5ad92aa81f8f,
                        limb2: 0x2148466a2682f66c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7fff17b632a3f4e71947049d,
                        limb1: 0xaa92b654dd77df302372c753,
                        limb2: 0x51eded5e92a54308,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x8c6f23579df9a57516de54a6,
                        limb1: 0xb868cb9e28c5afb9e67972f2,
                        limb2: 0x9ba65d14e2f849f6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf190dca2be06de5849dca9ba,
                        limb1: 0x733d34a22dbb1ea4ff885217,
                        limb2: 0xe0dc8d8531735eb8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd7ebadaca114aafef37ea828,
                        limb1: 0x40dc9e2855c46fc37ce0db51,
                        limb2: 0xf3712e0ffcf10ab0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf0ecdfad8162395adb7da588,
                        limb1: 0x13e60f3c32a7627775c99c23,
                        limb2: 0x41b0859f013983f3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa6cd566dde3ddb1511713d60,
                        limb1: 0x7bafb50f0af15cfda2beb920,
                        limb2: 0xcd1c57ec8f188313,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xa9292df1af6cda9206816f50,
                        limb1: 0x891d67f3fe6af70cd66596ad,
                        limb2: 0x5fa39db4175b12d4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x73e435b1f6c4766fae340e65,
                        limb1: 0xffffffffffffffff95756b0a,
                        limb2: 0xffffffff00000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x7e71186417ea21eb4c020688,
                        limb1: 0x58bbe4ec05817a33f9982cd4,
                        limb2: 0xe55e25d5ec1fc649,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd652316cbc3777e69e701bd9,
                        limb1: 0x8ce72716e918cac78bbdba0d,
                        limb2: 0x2132aea9c0b8fde5,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x91c6c9690a1e5e0b111700fd,
                        limb1: 0x3067ef3bc771b4e8e00553a3,
                        limb2: 0xdd37a2d51b764870,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x4790b7af4978b63bf6d3875c,
                        limb1: 0xb6cb25b0daac5592b7811b98,
                        limb2: 0x9b47fa9055aed90b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf14c2ef1d21a6403ced1313b,
                        limb1: 0x7a584cef022cf60ecf01fd9f,
                        limb2: 0xc5155f6a0fe6ba59,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x82711b6725c786baa41beeb9,
                        limb1: 0x8a1824d256899b5a9be576f7,
                        limb2: 0x7cf79aa22d078cf4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xcd52480cfa004a63eb23c88a,
                        limb1: 0xe13dbf92bf0d018274043208,
                        limb2: 0xa6ac3b8482ac2757,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x495d1cb00727d48a4c820cbf,
                        limb1: 0xd364810bb4e2665c1e3d888,
                        limb2: 0xf72e29da680f9a38,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7e71186417ea21eb4c020685,
                        limb1: 0x58bbe4ec05817a33f9982cd4,
                        limb2: 0xe55e25d5ec1fc649,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd652316cbc3777e69e701bd9,
                        limb1: 0x8ce72716e918cac78bbdba0d,
                        limb2: 0x2132aea9c0b8fde5,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x5cf9da1d9255f3e6717d14b,
                        limb1: 0x36ebee22b3846d1ff7c676b2,
                        limb2: 0xcb3f892509d39e95,
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
                        limb0: 0xd864399c5366b460c265394d,
                        limb1: 0x855f95ce1865a46be727c717,
                        limb2: 0x78f8be759f59ebd5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfadb3d4e96add5b226806afd,
                        limb1: 0x945623f297a17dd3cf605fa7,
                        limb2: 0x5a19908eb0624d4f,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x4bfd561fba12924932152f81,
                        limb1: 0xe5a454cbc79e48d378a7bcd2,
                        limb2: 0xa201268c2c988f9f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x89b29139287aa0b3374ca71b,
                        limb1: 0x91c1288bc725f310cfd76226,
                        limb2: 0xd910e296c8ee5459,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x347eb3405ae894844a8f209a,
                        limb1: 0x8d75ebd35eca068ae3b5a30b,
                        limb2: 0xce185100edab2091,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xf2f2705d81a8f7b80280633a,
                        limb1: 0xb20781d57404c521ce943b08,
                        limb2: 0x1417b08fe3a1ed25,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xeae7b4a8b8c82218ffa40deb,
                        limb1: 0x24f1cdf8af8cce56d8393225,
                        limb2: 0xe9e241186250e3c5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xdbc1f90a77c4bb27b4511f53,
                        limb1: 0xf6e9517dafb40d40f6fbe7b9,
                        limb2: 0x4c79842b9913abf9,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd864399c5366b460c265394a,
                        limb1: 0x855f95ce1865a46be727c717,
                        limb2: 0x78f8be759f59ebd5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfadb3d4e96add5b226806afd,
                        limb1: 0x945623f297a17dd3cf605fa7,
                        limb2: 0x5a19908eb0624d4f,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x9629527254155645c4fca7ff,
                limb1: 0x9fd6ad70d8898e9172caf8e9,
                limb2: 0x4e6c7230cc98a9c2,
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
                    limb0: 0xe63cb25d32a021386f21c2a0,
                    limb1: 0x3dfe2caee4c7a9d45f643efd,
                    limb2: 0x15de95c5b7760ac0,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xef5669227985d218f25a8703,
                    limb1: 0xf2340c9aeb96116da5d3dfdd,
                    limb2: 0x129f4267b7c4f56b,
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
                    limb0: 0x9314c7221a1e175cefbe0655,
                    limb1: 0xf6a524b60f9dcd92789d0877,
                    limb2: 0xc439d9425c247649,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x969cfd93df1c2cd4edaba105,
                    limb1: 0x6e8335bf7f2d8c591aba1630,
                    limb2: 0x94553c8f04c68ded,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xe29bf188c77847a8a93126db40d5e950, high: 0xead91914299fd6c3edd9fe7aa0fdb097
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        -0x1,
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
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
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
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
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
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
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
                    limb0: 0x7a3503d59f18e785ab5e979f,
                    limb1: 0x31d71979236f60228e4f1da6,
                    limb2: 0x72e0339c3b845225,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xff8ef23ff871c37d07101683,
                    limb1: 0x2b8102232ae75179483a47e7,
                    limb2: 0xa2d5d6cd038099e7,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x6298d9a9cd01c503f89e9ad4,
                    limb1: 0xf7b723288e2cbc3d1ce77b74,
                    limb2: 0xd6389ba3fd326b5,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xb944c519029ddfa7f186233e,
                    limb1: 0x68fc847269c1af2953ad67cf,
                    limb2: 0xffc156f9ea1937c5,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xcf636ef66f93b8be1461bda5,
                    limb1: 0x61ceb365ba5c92bb7f7deec1,
                    limb2: 0x265284ecf3eb92ce,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x17094bdf279bc6ed98779c5,
                    limb1: 0xf734c540c7c47aab2c171154,
                    limb2: 0x5f26ce84a211450d,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xb9aa8ddc82c93e3af4d02975,
                        limb1: 0xd71d1ffde73f847ceee697dc,
                        limb2: 0x37c360014972a89,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfff5d10e315a31d19f0c9562,
                        limb1: 0xffffffffffffffff8ecc8aaa,
                        limb2: 0x7fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x2ae377aa658bd29c4b974f97,
                        limb1: 0x7cc17630d1d3f8ce8de62290,
                        limb2: 0x8a04aff1436ebd24,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf2b6350846c9011b64e35a6a,
                        limb1: 0xd783c1d0ccf2d24af913d9e1,
                        limb2: 0xc8e5f32168573790,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xc022b84f76dd95d8834f1f87,
                        limb1: 0xcdb117ebf722058d8b364c3,
                        limb2: 0x8f791d2a7252b5bf,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xee6a85c50e6fd38e2526ecc5,
                        limb1: 0x2b9e6e84da18d1cabd679ab0,
                        limb2: 0x2b15e185132b2ca6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x34d6201e4bc92bb5b6db02f2,
                        limb1: 0xb919f3a054c37db5147e5827,
                        limb2: 0x56700f06931d14b6,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x2c3845a8c6d2c24911233894,
                        limb1: 0x694a3b55bccbcda5e14af1f1,
                        limb2: 0xc620cf98d8072bff,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa2fb7339ef7f07c4c2378bfb,
                        limb1: 0xe49a4cb59aa3c00ccf8af52d,
                        limb2: 0x7e49a5e9da6284f5,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x2ae377aa658bd29c4b974f97,
                        limb1: 0x7cc17630d1d3f8ce8de62290,
                        limb2: 0x8a04aff1436ebd24,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf2b6350846c9011b64e35a6a,
                        limb1: 0xd783c1d0ccf2d24af913d9e1,
                        limb2: 0xc8e5f32168573790,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x757e2bd486faed1434e9e4e6,
                        limb1: 0x4bc1246f0bdb317f7896698c,
                        limb2: 0xaa9b649db4ce537,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3891eed363a0401be05ec842,
                        limb1: 0xffffffffffffffff97070816,
                        limb2: 0xffffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x6067a90926a9a5b9f7fd12f9,
                        limb1: 0x9a52a2f38a64f7098a612369,
                        limb2: 0x1d9103d14e4a0bba,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa525f3418e0239e17a35b06,
                        limb1: 0x11a3b821623576306a7b7c14,
                        limb2: 0x2e629d0364086300,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xccf1366cc1bc7393a013557f,
                        limb1: 0x88765500d8bb5b2c0c81bbf,
                        limb2: 0x78bfaf0dfa021bc3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8e8ecb9ed5409921c340d86,
                        limb1: 0x59d7487b1afee34527399ea0,
                        limb2: 0xf99a51a5ffac9c13,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf48e1e4737c4b475508f8b58,
                        limb1: 0x3ec278c48c46d86b7f5c3b9a,
                        limb2: 0x8b7895f4aa9ac3f7,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xa2d59f400ea38815c7eb84cf,
                        limb1: 0x384274a8c8c2c142c8a7f7e1,
                        limb2: 0xcef71ab92406521a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x48409a6cae20f953a57780fb,
                        limb1: 0x7b7a08e9af763b52e960648c,
                        limb2: 0x44b24b17bc3ab500,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x6067a90926a9a5b9f7fd12f9,
                        limb1: 0x9a52a2f38a64f7098a612369,
                        limb2: 0x1d9103d14e4a0bba,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa525f3418e0239e17a35b06,
                        limb1: 0x11a3b821623576306a7b7c14,
                        limb2: 0x2e629d0364086300,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x78d12195d883005e39a852ec,
                        limb1: 0x1295f290c6c9f624144b1d8f,
                        limb2: 0x4784134c561fe7b4,
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
                        limb0: 0x26a50b710059772b974c681f,
                        limb1: 0xceeb4cc53221f861fc728c6f,
                        limb2: 0x557482c61c334d99,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xce03b75fc36a823cf2ffa3b6,
                        limb1: 0xa67a2971b776b107639a95c9,
                        limb2: 0xcc49f158cc41467b,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xf12255640dcc0fa4f1c8f5bb,
                        limb1: 0x707ff277706b3c2b03e3a367,
                        limb2: 0x31130be2b86fad71,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb86520a80b0274f58cf6e8b4,
                        limb1: 0x46eacc8ab49ffdc786bd1bce,
                        limb2: 0x459e18d203dad7f5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x515a52004b9d192e6d697357,
                        limb1: 0xe39a0e6770ab13552445c413,
                        limb2: 0xd42afa426c994136,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xe835017027242332316e07b,
                        limb1: 0xa86f19645eedcaade721d70a,
                        limb2: 0x562f936ac5671f34,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa21a039e57e98fafa4fd8d0f,
                        limb1: 0x8d57221c043ed733b93a1884,
                        limb2: 0x9605996d95c8ed61,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x26a50b710059772b974c681f,
                        limb1: 0xceeb4cc53221f861fc728c6f,
                        limb2: 0x557482c61c334d99,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xce03b75fc36a823cf2ffa3b6,
                        limb1: 0xa67a2971b776b107639a95c9,
                        limb2: 0xcc49f158cc41467b,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xb37ccc537f7fffe14b4900e9,
                limb1: 0xb2a4269a928591f152d31629,
                limb2: 0x62711fc3411ca583,
                limb3: 0x0
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x4dd504ab560d82ef912a3275,
                    limb1: 0x380d7d0c55400d0c7f2aab6f,
                    limb2: 0x23ef027fd5f4b48,
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
                    limb0: 0x3d5ed7a403875a5b15ac6e3,
                    limb1: 0x26e658192d89f5bfb27bb257,
                    limb2: 0xa948357c60744c80,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x2a5e0fadb62f496fb1ba911e,
                    limb1: 0x9b2266c57aa7671ca9e4c676,
                    limb2: 0xd2d8d1f83952c9e5,
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
                    limb0: 0x34660dac70af4fbb71332169,
                    limb1: 0xd94e401c58dc0f195834136b,
                    limb2: 0x3ea1a9b6742ec450,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x8ff499ddde4a8b5121e87647,
                    limb1: 0xaa2ee1285d3580816e817d7a,
                    limb2: 0x67fd36553f602e78,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xcdff9cb11b8466791f6b457b4999decc, high: 0x7565e86b1a16dd5be59402707033cac
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
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
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
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
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
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
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
                    limb0: 0x96765946c8a3f34f7184a3b7,
                    limb1: 0x30a3087bfe22f85b5476ea0,
                    limb2: 0x60aa8cf7336f761d,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x83763389e80c14d9401d54b4,
                    limb1: 0xa8e4ff4f2a0757bbc49b0561,
                    limb2: 0x1eeb135d7cf4c8a9,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xdef6221a07ce657df21191e7,
                    limb1: 0xbca897006e8576be5c8e7150,
                    limb2: 0x537ed4cb95fc91b0,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xe908ab162cc856b99c926536,
                    limb1: 0xfc32281e427fc3c280520823,
                    limb2: 0x7ea695de642962fc,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x332e7d5a6b180ff50307120d,
                    limb1: 0x34ff168d6ec620b5b6420c38,
                    limb2: 0x29e6458444995a68,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xaf3ea911375ff749991a494d,
                    limb1: 0x7f74c60a5289a25b2efbb31f,
                    limb2: 0x599f7fd5ca31beb8,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x2a8258a8415cf0430079f62a,
                        limb1: 0x817d12559199ade9f2420e7b,
                        limb2: 0x1b4ece6b04d0522f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6700f27c6e7399924ceea27e,
                        limb1: 0xffffffffffffffff94e6814d,
                        limb2: 0x3fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x2d1c5b601588af88baa26592,
                        limb1: 0x1ccea67263d58ccad78662c,
                        limb2: 0x377f908cbe884f3a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3523990cc6acbcf51d483aba,
                        limb1: 0x23a78f5be741c160f2847df4,
                        limb2: 0x60b3c9525861c592,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xee974226b08cabcc9f2d2145,
                        limb1: 0x78c6e8ae559277ccf5adaab8,
                        limb2: 0x146cdb1be197187e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc07b03d1a6929d9d496b2ea5,
                        limb1: 0x91c5ce09ba86d98d9810ccd4,
                        limb2: 0x3e69c2dbfae2230a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3c6dc8a28ec5b6662a205f33,
                        limb1: 0xe8ed067dc883bbfc138aa17b,
                        limb2: 0xa9131cb078bc02c,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x710ab3382870dd9fd04e6dca,
                        limb1: 0xa42b46dd7ce731d56256ebc,
                        limb2: 0x3fdd243f40726fc8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x951ef4d8489196ec85540ab9,
                        limb1: 0x76b99620389142c968791e12,
                        limb2: 0x4ce5647647185e23,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2362b8376df57db4ee6739c3,
                        limb1: 0x5724f72c170f02a0e6aa2e3c,
                        limb2: 0x417497908cd1576e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x39c18657c1fa9117b35e7cd2,
                        limb1: 0x3364cb7487b896a319311c89,
                        limb2: 0x14ce3d6064420e20,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3523990cc6acbcf51d483aba,
                        limb1: 0x23a78f5be741c160f2847df4,
                        limb2: 0x60b3c9525861c592,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xb48d0b6eddfee975ec59fefb,
                        limb1: 0xf5e6b0d38cfc1e5a9db2f7ec,
                        limb2: 0x55189ae4607e42d9,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfcfcd6be272811126bee065a,
                        limb1: 0x495ccb5,
                        limb2: 0x4000000000000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x7b48e7a5ab1c1b4e62c18178,
                        limb1: 0x5212d3ca56b0fc261c417e9f,
                        limb2: 0x223401901b32f26d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xeca3d03987824ac69cbb4c8a,
                        limb1: 0x6a0928e3389e7a284b3d7b43,
                        limb2: 0x6ddf817df5d4a9fe,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x7f940401a177e148e2428e7,
                        limb1: 0x16439e55ff626f1ac6348b30,
                        limb2: 0x210f717a32d83a7,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xfc80e6023a48a2ff0067a20a,
                        limb1: 0x91d54bd0f44aa05a24b350e0,
                        limb2: 0x486a65bc9c93b608,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc41be1f01378b06f32f428de,
                        limb1: 0x7bc15c1c3e92c9edd77a43f3,
                        limb2: 0x4e4a34acbc0e656a,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x17ba861aeb068f5550a1661,
                        limb1: 0xfa9c100b6b2a525a6bd2b303,
                        limb2: 0x3aa548bc6f8a09f6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7e3b6e83739d3255ec1948d4,
                        limb1: 0x512d7c0376be40250aa4c7f4,
                        limb2: 0x18577db756be25a7,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x90fd21e6cb1b8f07260def5d,
                        limb1: 0xfc159579d56bf7eb25969402,
                        limb2: 0x500692f5e797cdf4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x87ee129d578dfcdd5b7d98a5,
                        limb1: 0x83aab4d7b82c39fc87fa34fc,
                        limb2: 0x7f82ae63c0ecb153,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xeca3d03987824ac69cbb4c8a,
                        limb1: 0x6a0928e3389e7a284b3d7b43,
                        limb2: 0x6ddf817df5d4a9fe,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xc1bf6587371b09a394462ee5,
                        limb1: 0x58297d7fe0b2880806f9423f,
                        limb2: 0x2c47ff8c4f93d8c8,
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
                        limb0: 0xa0bbbcdb51f052b848ce70c6,
                        limb1: 0xec4e63b2d93dc6643715e6c9,
                        limb2: 0x54b33a492f5c9923,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xeddb608b8d198a8d0ae75bf9,
                        limb1: 0xe58527222b4688bed2f8276,
                        limb2: 0x29ae5b0256a13e7,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x993e2cbf7bb60395a009509e,
                        limb1: 0x5ace23be36d70bd490288811,
                        limb2: 0x195d7725c23be0da,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x73eb75fc184d993beeb48bb9,
                        limb1: 0x5ed1386736d568abc5f9d6c8,
                        limb2: 0x74b646b10f9cd1b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7e882210d45d8a5ef5ec3f36,
                        limb1: 0xe419b6e6318e125d6f98d7cf,
                        limb2: 0x3921d2bd315028bf,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x60dfeb0161d1cd38d10ec4b6,
                        limb1: 0xcaafea133003842086afa0f4,
                        limb2: 0x3ba8c762bfe0aff,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf175ae4ddc48d8c32830014a,
                        limb1: 0xff7c3e84991d9b50a5346d80,
                        limb2: 0x49abf0f9f2426446,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x968adc4750f09dd258dc1f5e,
                        limb1: 0x9983f1748e2679e334598f88,
                        limb2: 0x548d48b2346707e3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xad60e7d2fe623447418a8806,
                        limb1: 0x1de644c03ab9043aa2ce9d26,
                        limb2: 0x3201e71cd516580a,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xeddb608b8d198a8d0ae75bf9,
                        limb1: 0xe58527222b4688bed2f8276,
                        limb2: 0x29ae5b0256a13e7,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x7ed8b18f7e6b2803f7da2997,
                limb1: 0x3e2d5376122f83d2405bdca0,
                limb2: 0x27d076489cde6d57,
                limb3: 0x0
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xefe325a215305f1171236702,
                    limb1: 0x5d48e7e3196a9120a1af7e83,
                    limb2: 0x79dadcef12699d1,
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
                    limb0: 0x31fa27de19ee3c1758668835,
                    limb1: 0x926985f02bb519fd6bee8463,
                    limb2: 0x447cd76c826e6203,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x914391693133f0cdd1e787ff,
                    limb1: 0x177ddf41bd7390052116b39c,
                    limb2: 0x664ddd4ac560ed53,
                    limb3: 0x0
                }
            }
        );
    }
}
