#[cfg(test)]
mod msm_tests {
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1, MSMHint, DerivePointFromXHint};


    #[test]
    fn test_msm_BN254_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x50a938a59cb338ca85fa7901,
                    limb1: 0xb159c43070a413bbbe5b2015,
                    limb2: 0x2bd3a0bb0e1c927d,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x7a9a9cf41c65435563214195,
                    limb1: 0x623b0c562274700749a85e24,
                    limb2: 0x1bcfc60c9160690b,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x6a72dfd4339780a91632f180b607f65a, high: 0x29aa7b0456336e86bc840d7e49b0a28f
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
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
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
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
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
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                    ]
                        .span(),
                    array![
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
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
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
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
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
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
                    limb0: 0x4f2212985f884c4fb0360e3b,
                    limb1: 0x8fd2ab9a8bf0f5ed12de8d20,
                    limb2: 0x8680844bf950fda,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x146dab00671028bc47623a5b,
                    limb1: 0xac3e80ade63b9dbac0683eb8,
                    limb2: 0x1a08011e8ab1065f,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xd41c9d579ecd7bab1987d4e0,
                    limb1: 0x7282b6dcf1b1957fae432619,
                    limb2: 0x110894eb2b3d1376,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xf1b8adcd017422e65be0d3d9,
                    limb1: 0xcced0892f9adbc97db92e53,
                    limb2: 0x1d71d23991188c9e,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xd16738da6b31de6436a81b3c,
                    limb1: 0xa0211ffa502cbb3749670bf2,
                    limb2: 0x203866661bdaafa3,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x51bd117b3f229b072a4c5ada,
                    limb1: 0x9cea429aa7be0456f55f73b3,
                    limb2: 0x1183be8d4c1f7adf,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x19ded209aa501b7e66e1a98,
                        limb1: 0x57eb32824dc1bdf002b31c69,
                        limb2: 0x12a66dd4dfe23ec8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb090383c3fa47ecd9a298f0d,
                        limb1: 0xdc2822db40c0ac2f012597bf,
                        limb2: 0x183227397098d014,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xf8cf552205a4e176033bbd08,
                        limb1: 0xed26e7a41e7ac7adca1ac0e0,
                        limb2: 0x1c4d7b2053dcf823,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x311849dc7c0593137ac97352,
                        limb1: 0x2f741ba2066da7125dc927ed,
                        limb2: 0x2c8cf3e5f4b19dfb,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x1997e0d7801f855e629f7afa,
                        limb1: 0x890d82ed856686137bec6098,
                        limb2: 0x127494d081a3edd5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1acc26c89a6ac899a767ff41,
                        limb1: 0xbab40d2021267fd14533081f,
                        limb2: 0x2f9f117a2dfaa903,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2f0c8ee8d26553089cdee7ef,
                        limb1: 0xb448e1b0a6a16ac417c45a98,
                        limb2: 0x210e15334ba6dbe7,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x81fc34d8d4ce184b313639d1,
                        limb1: 0xf247135d9eefeabc6ced811,
                        limb2: 0x248422ee1a654842,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc265487afbcfa10cbf625f68,
                        limb1: 0x1dbbc7791046447bea58a2a4,
                        limb2: 0x24de3ecc1bb1999e,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xf8cf552205a4e176033bbd08,
                        limb1: 0xed26e7a41e7ac7adca1ac0e0,
                        limb2: 0x1c4d7b2053dcf823,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x311849dc7c0593137ac97352,
                        limb1: 0x2f741ba2066da7125dc927ed,
                        limb2: 0x2c8cf3e5f4b19dfb,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xa3c426d4d12500a0a803fcc5,
                        limb1: 0x4c412ee835e1a1437c6ce807,
                        limb2: 0xf3c4c8fd70a4322,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf6a5ed3cc4566f2686d4ce13,
                        limb1: 0xb85045b68181585d82b0919e,
                        limb2: 0x30644e72e131a029,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x3e55a0220253e09d51998cf,
                        limb1: 0x26dc30f861d5f1ef38a1f454,
                        limb2: 0x15295b2ec98d42ee,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xac1dbf1d3cc063b81177acad,
                        limb1: 0x4cc4105fa0ad077fc2648ef3,
                        limb2: 0x23ec673f89099a5f,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xc32fb84648dc61eee83f365a,
                        limb1: 0xc7d31bf5016e869eb6ef3d90,
                        limb2: 0x190c27b35cb866a1,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6733137b79138be47db4633f,
                        limb1: 0xdaa92401e4704400eeea4e11,
                        limb2: 0x14b13d215705dd71,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x59393eed3a1b1b0466983c1f,
                        limb1: 0x969eead426d0ea47627b6e2a,
                        limb2: 0x17899cc06111631,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xa33e4379244f2e06a6cfcd26,
                        limb1: 0xbc444d32a4007d701264726a,
                        limb2: 0xf17c3197b7628a0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3375a83d3e0012fa836d0b79,
                        limb1: 0x75aba5b1df0465c4182ad7b8,
                        limb2: 0xafc98d8d8b98eca,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x3e55a0220253e09d51998cf,
                        limb1: 0x26dc30f861d5f1ef38a1f454,
                        limb2: 0x15295b2ec98d42ee,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xac1dbf1d3cc063b81177acad,
                        limb1: 0x4cc4105fa0ad077fc2648ef3,
                        limb2: 0x23ec673f89099a5f,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x111147ab824b22de997878f6,
                        limb1: 0xb9f1a2647093d8f609a6a818,
                        limb2: 0x166fad31f1255503,
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
                        limb0: 0xf1e1b11b1cf6e8c00d142f62,
                        limb1: 0x911a5079914d676000a80816,
                        limb2: 0x29b989d7aec09f07,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2b5fbee86e41be1e60ca0a72,
                        limb1: 0x5dfcb495c12460043758a316,
                        limb2: 0x2f87a1947b4b7d39,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xe5279ff6ff2c604833258076,
                        limb1: 0x7fc9cb150fe61403e0e7c5b1,
                        limb2: 0x2d36a054256680e5,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa0cb67416c719dc346862dbe,
                        limb1: 0x89a9ccc924ac32c67dacc6b,
                        limb2: 0x201feb688244207c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x43d59773400896ce17391bdb,
                        limb1: 0xc5fabbfb7efddf167c2a9c0d,
                        limb2: 0x296e146e6f24ac1c,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x4c17e36dea3a21276429398,
                        limb1: 0x42ae65ffb0e58564d2f54322,
                        limb2: 0x1c6400a149de9cc3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb13ba79ed284222d716424c8,
                        limb1: 0xa9559254406a6f517707141f,
                        limb2: 0x2dce47d7af7f3758,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x3, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xf1e1b11b1cf6e8c00d142f62,
                        limb1: 0x911a5079914d676000a80816,
                        limb2: 0x29b989d7aec09f07,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2b5fbee86e41be1e60ca0a72,
                        limb1: 0x5dfcb495c12460043758a316,
                        limb2: 0x2f87a1947b4b7d39,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x4414988438d582c8c16e2cdf,
                limb1: 0xf6519239e708935f75b04c60,
                limb2: 0xb01d31dc96cd260,
                limb3: 0x0
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x93b4778a017e410f624f31,
                    limb1: 0x620f8b4243ed3ea663d200c,
                    limb2: 0xc817329abfca7d3,
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
                    limb0: 0xed78dba56578677a2be63339,
                    limb1: 0x6183789ce3b475ee25bb3233,
                    limb2: 0x48c3437493a1746,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xac52f9dd44f452f510297bc7,
                    limb1: 0x9ab4f44ad7c77752152007bf,
                    limb2: 0x47a7a0adf21bb06,
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
                    limb0: 0xe42078542e67ef865fbaa799,
                    limb1: 0xa87c7210fd7897f4cb1bed29,
                    limb2: 0x5fda33ab82a17b5c25d1165e,
                    limb3: 0xee82ae7cdb0a6f935699b87
                },
                y: u384 {
                    limb0: 0x3f94261960b917d9cdee056,
                    limb1: 0xf1c70d4e8939a461cff5bfa4,
                    limb2: 0x733eb2589f007079f6f93086,
                    limb3: 0x1530e186e7dea6b20b614aec
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xcd7bfb17160b493b791058ac73a4854, high: 0x4c221f925687a729d4eabce017b95601
            },
        ]
            .span();
        let scalars_digits_decompositions = Option::Some(
            array![
                (
                    array![
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                    ]
                        .span(),
                    array![
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
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
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
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
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
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
                    limb0: 0x2d61cb0b77de8ee40cc6cb32,
                    limb1: 0xd4144f1c37813bac5b80e2a5,
                    limb2: 0x8f582b9ae125876140e9eecd,
                    limb3: 0x590664c44259cea5b7a3820
                },
                y: u384 {
                    limb0: 0xea26c10ff906c797c7b210d1,
                    limb1: 0x21d3ec9defe7a37014f42b40,
                    limb2: 0xf0779db5cca09d9d59ff97e1,
                    limb3: 0x35dc9e95a653e41b97479f
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xef8a6e8faa0e219598e2442f,
                    limb1: 0x51a5a61b5324949240cd8ebd,
                    limb2: 0x45ea83c36e29218c41020696,
                    limb3: 0x43aba9689003f9cfc2bd15
                },
                y: u384 {
                    limb0: 0x68a68df54dc1c62c42c69965,
                    limb1: 0x4b44346e1b8d3539e88a902c,
                    limb2: 0x975aa777b34da398fb51786c,
                    limb3: 0xf4fc0f86f87e1ad5cf82a1f
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xafd2d06989ebcb8b4610459d,
                    limb1: 0x18618f1c9dd31f100644575c,
                    limb2: 0xe2784df5515127007154fe3c,
                    limb3: 0x898e0c7cce75dfc7ca277b
                },
                y: u384 {
                    limb0: 0x2f83a272dee492fbc680b2be,
                    limb1: 0x9235fa05f44fe882dc1dc1d3,
                    limb2: 0xf1a2b43145808a93199f09c4,
                    limb3: 0x9972e86d554d773f8688dfe
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x406a8745d430c63cb194124d,
                        limb1: 0xee97554bcc14ef36caf2c4d3,
                        limb2: 0xc9b645bf1f90bb9ff84e2911,
                        limb3: 0xc20c82ed511724bd56322da
                    },
                    u384 {
                        limb0: 0xf8e30609d1b5b4317dd60af2,
                        limb1: 0xb39869507b587b1215440c80,
                        limb2: 0x21a5d66bb23ba5c279c2895f,
                        limb3: 0xd0088f51cbff34d258dd3db
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xd1bcc8e3bf75f35df61527bf,
                        limb1: 0xcdd2d8dc913789c2ebf51718,
                        limb2: 0xb81bdc6b4df835bb017b86b8,
                        limb3: 0x16fdb011839c3d26838a097d
                    },
                    u384 {
                        limb0: 0x9fd1bca013b88195937e37e0,
                        limb1: 0xeaa01173c1b72282f80f302f,
                        limb2: 0x54194d9100b048c78cca0d92,
                        limb3: 0x58880b627a9a2b6ba37d40e
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xd1a5f3770893e9d160cf8856,
                        limb1: 0x449bc09417e664ca6ce3fb9,
                        limb2: 0x6c94da7a44729d35d9a68b25,
                        limb3: 0x1892297e805d840b5ac6882b
                    },
                    u384 {
                        limb0: 0x23ec5a78b1c971cad72281ed,
                        limb1: 0x2b3feafadc6ec787d65ec3e3,
                        limb2: 0x7da979b87ad31555247df4b1,
                        limb3: 0x692d1a50417788e83726bb7
                    },
                    u384 {
                        limb0: 0x946ade566c18c583ac24b94e,
                        limb1: 0x75bab9d225eaef9bcf4c529c,
                        limb2: 0x29160626fabcba13adb18627,
                        limb3: 0x22ddcf2baf6b2d87bf14fde
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x32f7238fcfdacd77d8559efb,
                        limb1: 0x1b8eb8f60cb449f53d05c67,
                        limb2: 0x168c6b270a7af45d2b5ee2a5,
                        limb3: 0xdf38a8761f140cb2cd52ed4
                    },
                    u384 {
                        limb0: 0x7f46f2804ee206564df8df80,
                        limb1: 0xaa8045cf06dc8a0be03cc0be,
                        limb2: 0x5065364402c1231e3328364b,
                        limb3: 0x162202d89ea68adae8df5039
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xd1bcc8e3bf75f35df61527bf,
                        limb1: 0xcdd2d8dc913789c2ebf51718,
                        limb2: 0xb81bdc6b4df835bb017b86b8,
                        limb3: 0x16fdb011839c3d26838a097d
                    },
                    u384 {
                        limb0: 0x9fd1bca013b88195937e37e0,
                        limb1: 0xeaa01173c1b72282f80f302f,
                        limb2: 0x54194d9100b048c78cca0d92,
                        limb3: 0x58880b627a9a2b6ba37d40e
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x23f21df8fae2f9d0c61b9a0,
                        limb1: 0xf621e88950813a99d99dd536,
                        limb2: 0x1714af3867639f09f4d071d2,
                        limb3: 0xbd993c13885bee4bd0f6db2
                    },
                    u384 {
                        limb0: 0x3e0f0b472a57e691395dec2e, limb1: 0x259bbbd0, limb2: 0x0, limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x9e5c506ef56d4f454839faf9,
                        limb1: 0xd3f7d9bdbf789fe21dd1d58,
                        limb2: 0x9905e3352af62da7923564,
                        limb3: 0x118047cb6aaf6da49fd8f20a
                    },
                    u384 {
                        limb0: 0xdda9191be188eee40762bee3,
                        limb1: 0x6d0eba74a613c99d12c28416,
                        limb2: 0x9d86f56873acae9c8cb1f5ca,
                        limb3: 0xad53b59033f3ba745ef4f19
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x9f25b9f67c60cb2150e4c8fa,
                        limb1: 0xfbf96d91aec626ad23089a9,
                        limb2: 0xc3d2369f784de89bda4713ac,
                        limb3: 0x8d2d04306f9ade973494bcd
                    },
                    u384 {
                        limb0: 0xb97b7c687be463494a289d5f,
                        limb1: 0xb9cc8c85db303da967d7e4f9,
                        limb2: 0xea8a7157302fb6f6f18b76a,
                        limb3: 0xab8641a714774a59819ef3a
                    },
                    u384 {
                        limb0: 0x56d356a87744a26faab5c1a3,
                        limb1: 0x4256a15e7ded4c9e3b249996,
                        limb2: 0x95de895137ed7e229435fb78,
                        limb3: 0x147a7c57ee1a41f8e1fac22
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x16c941bc61b73d1520e8968e,
                        limb1: 0x669c512d827c3bb04a1c7565,
                        limb2: 0x7bccbdde0bbd41acb73eb011,
                        limb3: 0x11fefb5937bde95de92c78bb
                    },
                    u384 {
                        limb0: 0xc550646fcc24bb901d8b50e1,
                        limb1: 0x4d0a1731a19e30502c5e105c,
                        limb2: 0x32d028ca6a3b6eed3f42c46a,
                        limb3: 0x1153db79d37d0802cca194b0
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x9e5c506ef56d4f454839faf9,
                        limb1: 0xd3f7d9bdbf789fe21dd1d58,
                        limb2: 0x9905e3352af62da7923564,
                        limb3: 0x118047cb6aaf6da49fd8f20a
                    },
                    u384 {
                        limb0: 0xdda9191be188eee40762bee3,
                        limb1: 0x6d0eba74a613c99d12c28416,
                        limb2: 0x9d86f56873acae9c8cb1f5ca,
                        limb3: 0xad53b59033f3ba745ef4f19
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xf260975b400c859647477bab,
                        limb1: 0x506a317202b8a09546b432d1,
                        limb2: 0xd59a1836e328587bac8b58f7,
                        limb3: 0x4d75b8347a03123b7089ab
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
                        limb0: 0x4f8647755147eb72a0483a57,
                        limb1: 0xb22737924a49b6c7aa5e492f,
                        limb2: 0xa721675557a295a1a5fe7bee,
                        limb3: 0x154cbd76849ed78ffced59bb
                    },
                    u384 {
                        limb0: 0x11f6c106860512df210d20df,
                        limb1: 0xfd299d6905b94281d79a19e4,
                        limb2: 0x1ae8db1ea4fd02f8412e0dec,
                        limb3: 0x1933d83454216cc0b38ec325
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xe368570aee44b432a94c3cb9,
                        limb1: 0x9a3b7aa05c794cc666f7ab1,
                        limb2: 0xd7d4a440f1722c5e7ea5c47e,
                        limb3: 0x17a6291971baf22dc9fa990a
                    },
                    u384 {
                        limb0: 0xafab9615d4d0aa5330338953,
                        limb1: 0x71fb049b2550be64f2f6bc5a,
                        limb2: 0x62a982c2d41d5dda359bc7a2,
                        limb3: 0xbf7b1a91ba3e49c2d9edf65
                    },
                    u384 {
                        limb0: 0x7ba100368f2e807cbbc40cb6,
                        limb1: 0xd1e32d204452b0ca940e73c8,
                        limb2: 0x72789005b013d04583384981,
                        limb3: 0x97eb14c8ab084732aee2255
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x2a1d1dd61722adca8121e95b,
                        limb1: 0x930a66664513f8b24d7524c1,
                        limb2: 0xd2a296cf312473f7bd6ab77c,
                        limb3: 0x72fc01b65fbaa7112626fcb
                    },
                    u384 {
                        limb0: 0x33df041aea174b7c8435837b,
                        limb1: 0xbf13fdc132d2279b02646794,
                        limb2: 0xa1c065f4668e29522a28ff75,
                        limb3: 0x16cc2b12a405ff33ece81571
                    },
                    u384 { limb0: 0x4, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x4f8647755147eb72a0483a57,
                        limb1: 0xb22737924a49b6c7aa5e492f,
                        limb2: 0xa721675557a295a1a5fe7bee,
                        limb3: 0x154cbd76849ed78ffced59bb
                    },
                    u384 {
                        limb0: 0x11f6c106860512df210d20df,
                        limb1: 0xfd299d6905b94281d79a19e4,
                        limb2: 0x1ae8db1ea4fd02f8412e0dec,
                        limb3: 0x1933d83454216cc0b38ec325
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x8a1625e61f8f19ec49e2e0c8,
                limb1: 0x4313e1317a6eed3aa3ef5466,
                limb2: 0xc21e4b48776a00d6f4c8fc28,
                limb3: 0x9c79eb8c6cd18a0ba7abe15
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x86d040e1cbe90b977be7b710,
                    limb1: 0x2f304063d6da5105942f0a34,
                    limb2: 0x1cbc35c33924c9f6ac90c866,
                    limb3: 0xa0eb930218cfd698ead81a7
                }
            ],
        };
        let res = msm_g1(
            points, scalars, scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, 1
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x76409f468113906b39572816,
                    limb1: 0x6f6f4a6a7154a02effb40613,
                    limb2: 0x474e4c5e30267a2ca45b738a,
                    limb3: 0xf8238837df8fb11a112876
                },
                y: u384 {
                    limb0: 0xbc29301d2322054b28e5894e,
                    limb1: 0x9d9e3b90055688f568913949,
                    limb2: 0xa589cf4e1d4367ca83a03907,
                    limb3: 0x196fba2bda433d995afb82d0
                }
            }
        );
    }


    #[test]
    fn test_msm_SECP256R1_1P() {
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x6a07610f557d848a1aff61a3,
                    limb1: 0x46dc770661cb6b3ce8cf6275,
                    limb2: 0x90f43447e8143b08,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xad65fbe04c7aa17b592768e2,
                    limb1: 0xa6872f0b1ca68cf01ce03b1c,
                    limb2: 0x88efa098cc095a51,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x1a73b9f80406a4cdec8ce52e473fc11, high: 0x90c747d60a81e102c2edeb12840c0d52
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
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
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
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
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
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
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
                        -0x1,
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
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
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
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
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
                    limb0: 0x71496a23bb2b2961f98ea84,
                    limb1: 0xe775d4ba34bac0053109ec06,
                    limb2: 0x376dc229592eb476,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x44f708062abd8d6e53fc7752,
                    limb1: 0xcd987068e119a4527138609a,
                    limb2: 0x14ff2d6973ea956f,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x94f1ecdb08fbbe35f82713fa,
                    limb1: 0x6148cc3490bf5d674ffbf5fe,
                    limb2: 0x76a14025bdd3129f,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x998e5a4de2beece076a29ad8,
                    limb1: 0xa7d8cc992c823e1218a61349,
                    limb2: 0xf9bdf10f0ab7d891,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x7e497f71aa32886d4c3461a3,
                    limb1: 0x6c300157d7f1abcc81ca039d,
                    limb2: 0x76751d42728332e8,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x7e0e72b43417a46c3b2397a6,
                    limb1: 0x4b832f47112797f421d4a328,
                    limb2: 0x417fa70e3f879ad,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x6dc3b1be9735b0e954a6d727,
                        limb1: 0x80c933c8c146e19fd831add7,
                        limb2: 0xc3627ec1da810aff,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1933e2d3bd1fc4bba24aeff7, limb1: 0x8a618c, limb2: 0x0, limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xae3dd93ae593aa89aa07dda,
                        limb1: 0x3a023d579736cfdc22bcc22d,
                        limb2: 0xf1ffdfe7c8963267,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8ee4084e6ecfc8dfc567b3d8,
                        limb1: 0xd1adb43f6979d4bde626b185,
                        limb2: 0x379e098dbebd1081,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x48aa1a834e079e4e9e1083a3,
                        limb1: 0x965f757d774fe485d977291e,
                        limb2: 0xba4fd51eb0e16d52,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x816be25f1302f083cdd4e007,
                        limb1: 0x853450590544d5426c8d2db5,
                        limb2: 0x10eaaf6b5efe20a0,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xe256cd1fee6fa40f1d251679,
                        limb1: 0x865918e03b73615314e45c35,
                        limb2: 0x985e09fbe6d15687,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x82246a244d56832178996543,
                        limb1: 0xf143161463899bcc712e3aec,
                        limb2: 0x61449387e0f6443f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7f8b073283de745e46862b6d,
                        limb1: 0x50a057a16c442210dfd9b66,
                        limb2: 0x4fb9cc5d8cd6e80c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1fa7980aef5ee19ed79b44c2,
                        limb1: 0x3ee2a0973a2b0882b2a8f221,
                        limb2: 0xb3ec192e6e036263,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xae3dd93ae593aa89aa07dd7,
                        limb1: 0x3a023d579736cfdc22bcc22d,
                        limb2: 0xf1ffdfe7c8963267,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8ee4084e6ecfc8dfc567b3d8,
                        limb1: 0xd1adb43f6979d4bde626b185,
                        limb2: 0x379e098dbebd1081,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x40d2618d2825b0a8843421d4,
                        limb1: 0x6a177cfb31ad0d5caa6a3827,
                        limb2: 0xd1deb52703ff0a2b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc49e8a127572f9177b44f12d,
                        limb1: 0x800000000000000022dc5e33,
                        limb2: 0x7fffffff80000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xd51749f139c24ccc37c4ca7d,
                        limb1: 0x47394252e1d79051b99ce6bc,
                        limb2: 0x6c55f9b4d84dda94,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x106b215a186bd3fecd98a61,
                        limb1: 0x57dabcc50d75375bc734a78e,
                        limb2: 0xf86a8b905a18b25a,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x1e2d40a57a75395f49d817c4,
                        limb1: 0x79979c0ff9b55a98aebad9c9,
                        limb2: 0xebd7d45bc420292b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x64c427f9ea9858c6777243d6,
                        limb1: 0xd9df5b20f6a5266cbb4c1546,
                        limb2: 0xe1f702891ee95c34,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x10b997d3ad1087dfed3c298e,
                        limb1: 0x28a7d2404300f7246f2e1c65,
                        limb2: 0x5d51e65c6a10116b,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x2dcedcd8b386586a643e0c3,
                        limb1: 0xcb5ce9302029a64dedfc22ad,
                        limb2: 0x479ac2cf97611f55,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xe7546dbf896bf9105b31c4b2,
                        limb1: 0x269007bcc672076a7f1f6fe8,
                        limb2: 0x1a75f8f93adbaa2d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc93f9ab5573a047e6145c125,
                        limb1: 0xac5b87064e38e0a90f7f1009,
                        limb2: 0x718693249bf07cdb,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd51749f139c24ccc37c4ca7a,
                        limb1: 0x47394252e1d79051b99ce6bc,
                        limb2: 0x6c55f9b4d84dda94,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x106b215a186bd3fecd98a61,
                        limb1: 0x57dabcc50d75375bc734a78e,
                        limb2: 0xf86a8b905a18b25a,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x1cba2d6659c95a16097e9fd,
                        limb1: 0xc94f064f0e29ad0d695d0f6b,
                        limb2: 0xcb08ecf43d7c3e85,
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
                        limb0: 0xb06040d5c04db2cdf3c6c93f,
                        limb1: 0xf4a009aa85454f7cefa625b8,
                        limb2: 0x8bd5d14041129c53,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xecc493b34cd1b95cbba48a62,
                        limb1: 0x32873273974ef6cc2e3a0664,
                        limb2: 0x12e9a296cfa9ba79,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x9645eed56d4d46e41a2ef82a,
                        limb1: 0x69db542c47e31e468d854945,
                        limb2: 0x1287dabd352755f6,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x22c7fb84e6380d3026d40dd,
                        limb1: 0xe8de0ed3208a0f808d2817cc,
                        limb2: 0x1014a240dcdd430d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7ace462957f6c9ffc70e22dd,
                        limb1: 0xe95503a27ae304ac3733f653,
                        limb2: 0x491e925fe02cfc66,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x9329e3d484e0d952d71c6c18,
                        limb1: 0x8c3eebbbed0afc8ba9a9d860,
                        limb2: 0xa4d87773472354d8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x55416d294ca29b9cd0ab93e,
                        limb1: 0x2ee349cb60a0081e17ddaa84,
                        limb2: 0x9aa45f2029dde5e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x605f5dc55591027f4e4c125,
                        limb1: 0x1c5625fab0aba257da6ef382,
                        limb2: 0x22094e143b3d647c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb06040d5c04db2cdf3c6c93c,
                        limb1: 0xf4a009aa85454f7cefa625b8,
                        limb2: 0x8bd5d14041129c53,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xecc493b34cd1b95cbba48a62,
                        limb1: 0x32873273974ef6cc2e3a0664,
                        limb2: 0x12e9a296cfa9ba79,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xea27e92406e071de4e3fa3f4,
                limb1: 0x9b4762126fe22b68953cd18d,
                limb2: 0x4010114fab825a51,
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
                    limb0: 0xbbc6164f854c550d3e62c1c5,
                    limb1: 0xe452e332362a47c42947c05e,
                    limb2: 0x21e55fe5cf9d7588,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x55231a8fbb77138c3b4eaae7,
                    limb1: 0xf39310dbcc8c4f9f1ef0a3b,
                    limb2: 0xfdc31750c22e5d61,
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
                    limb0: 0x84e1698a7cb94dae670c3d82,
                    limb1: 0xc836dea1bd53b6b6ca7903ce,
                    limb2: 0x4976538f860b8391,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x1b0e16c0f324c69dd8199e6,
                    limb1: 0xfcd006d57eb194aa0c73c2d6,
                    limb2: 0x7383e10460ab1913,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0x390961c256a72fdbd36c2e6e44d202d2, high: 0x835b8f68b135ceec2835683445016d9e
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
                        0x1,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
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
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                    ]
                        .span(),
                    array![
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
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
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
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
                    limb0: 0x690287e8b138e6b53b7a7eb7,
                    limb1: 0xd6f833463056935aff25ca05,
                    limb2: 0xfff30b7320293e34,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x5f72b249bb30a4347899462e,
                    limb1: 0xaeacc57e88c4fdd0b0290aa3,
                    limb2: 0x846e886f7d0ed927,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x365abf83683a69b406641df4,
                    limb1: 0xa6776d4e4f01197abf11cd5b,
                    limb2: 0x142e715cbf6efbb5,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xe0a81673a11e95a5ee2dd314,
                    limb1: 0x7fa7a7a9ac161a120e4fc813,
                    limb2: 0x48ae210182357acb,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x9f25e393ef5a8506db861fcd,
                    limb1: 0x974b7fbd5e0e6635872309dc,
                    limb2: 0x8eeb09a1970c63b7,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x974391b23d17089f73af3ee,
                    limb1: 0x3a2781b2bbbae24b666aa2d6,
                    limb2: 0xec88277930a1945d,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x6a393753d278b0ba7dc35103,
                        limb1: 0x127b04a35c19bc9397b4e858,
                        limb2: 0xc71e3c236708f65d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x20036e0dccfb5a4cb8dee7a7,
                        limb1: 0x2909a1eb,
                        limb2: 0x8000000000000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x76b8fe535db3e58b85c77aea,
                        limb1: 0xbb13cb03bc2133a490b05283,
                        limb2: 0xd1a92a9da6521ade,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x121c0e8cd20dcb9a5d793c25,
                        limb1: 0x60d0ee181255b5ee3661322c,
                        limb2: 0xb696a0fd59cb3e39,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xeb1b7ca8cb5a15a369380fbf,
                        limb1: 0xbaf54b076dc264c2958c4974,
                        limb2: 0xf525b8e7296b66e4,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xcfd42757c8bc5a1082b29a99,
                        limb1: 0x2d2681fc1cdf4426308de334,
                        limb2: 0x43c999a7b2be1df3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x11c68ccd3545eec3a4811b6b,
                        limb1: 0x2d0fc851b52eb4097a12702e,
                        limb2: 0x6f8351333f728393,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x3f0ef4478feb46d5a8746f7b,
                        limb1: 0x1d8a8d1a24e8697ff4d24198,
                        limb2: 0xbba02a4f8c3ebc17,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7ec465d9be60913c8e50b447,
                        limb1: 0xa5b682a88057f9837ca85f34,
                        limb2: 0xfe1e66ed748eb391,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0x76b8fe535db3e58b85c77aea,
                        limb1: 0xbb13cb03bc2133a490b05283,
                        limb2: 0xd1a92a9da6521ade,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x121c0e8cd20dcb9a5d793c25,
                        limb1: 0x60d0ee181255b5ee3661322c,
                        limb2: 0xb696a0fd59cb3e39,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xc561b1c80c06d060189dfb99,
                        limb1: 0xde0a4e3f03d7d79f2e6cc967,
                        limb2: 0xdd38621e509c7600,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa1eb0a655527eeb528b96a44,
                        limb1: 0x28f65895,
                        limb2: 0x8000000000000000,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xc0677a7a7bd1a8075df17134,
                        limb1: 0xc1e378f4d8aee7c5b2d62bf4,
                        limb2: 0x9f766aa4eebe3cd2,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x44c3d6f21b0c489c928fa0b9,
                        limb1: 0x9151b40ff3ab2fce76752ed6,
                        limb2: 0xa25b3b13ba8580b8,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xce230c15108de9df79a4a8e4,
                        limb1: 0xe79ff56bf3aa7074fbe6a1fc,
                        limb2: 0x4ee969cbe408a1de,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x4c0b861ccb39c38910c6422e,
                        limb1: 0x49d00b408dab7516487ebb01,
                        limb2: 0x53a4f5ab8929327b,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x675dec3db86508081637050c,
                        limb1: 0xa9cf366f3dffefbb665f0e4,
                        limb2: 0xf7be1f1971d23e0b,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x42d4595962bb9837919a27b0,
                        limb1: 0x4d384eb1ecc85667e3db33b1,
                        limb2: 0x5c3cea828733a9c3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xe15ae09ebd55fc4c01ed7453,
                        limb1: 0xf93bec6fa9ae4ea53d3447db,
                        limb2: 0x707e9d8a19a6850b,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xc0677a7a7bd1a8075df17134,
                        limb1: 0xc1e378f4d8aee7c5b2d62bf4,
                        limb2: 0x9f766aa4eebe3cd2,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x44c3d6f21b0c489c928fa0b9,
                        limb1: 0x9151b40ff3ab2fce76752ed6,
                        limb2: 0xa25b3b13ba8580b8,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x6ad249cde6729658e0a10b65,
                        limb1: 0x23c6ff8270387f7f1038afb0,
                        limb2: 0x550ffb091e79fd66,
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
                        limb0: 0xbce5f5e20ee92ce04f4bb6ff,
                        limb1: 0x4b5a8b0c2a193487025a8114,
                        limb2: 0x6479d1b95a005312,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2a7f5ce8a86b11441e15be6e,
                        limb1: 0xc23d12f452f0804fb9cb28c8,
                        limb2: 0x5ce68501a984a092,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xa5011b34b18b5dfef58ba5f2,
                        limb1: 0xeffe449a9de3d899415cbda2,
                        limb2: 0x80c29a14371c49da,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x91762a01101336c1f3ad8fb7,
                        limb1: 0xdda81f9007d05aca53bf76fc,
                        limb2: 0x932c644b50333a0e,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2c3a23ae72f1deefc8e93f9f,
                        limb1: 0xe80bb74c6b0449cdfa4a3dd0,
                        limb2: 0xf64a2c4413d2a565,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x2a49b92e68603a242b12089b,
                        limb1: 0xf79cd5526b06fb110798791,
                        limb2: 0xbf54bc1176024580,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x297b8a5c9aed78ded2983ca4,
                        limb1: 0x4fab84ae4493822e148e1d79,
                        limb2: 0x8a4da30ba2a06403,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x7, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 {
                        limb0: 0xbce5f5e20ee92ce04f4bb6ff,
                        limb1: 0x4b5a8b0c2a193487025a8114,
                        limb2: 0x6479d1b95a005312,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x2a7f5ce8a86b11441e15be6e,
                        limb1: 0xc23d12f452f0804fb9cb28c8,
                        limb2: 0x5ce68501a984a092,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x63433eb7c1c11992a9934e7f,
                limb1: 0xbbcf77a3dc88f46ec193a757,
                limb2: 0x47e9acd6aaf8123e,
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
                    limb0: 0xbb20d2255dc512aa89440d92,
                    limb1: 0x76ad8c6c4afe404451484772,
                    limb2: 0xc3e7a9966c0120a5,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x31651b665e15b22e66696248,
                    limb1: 0x3b1c47efc5d6a45a79e02810,
                    limb2: 0x8964886a275379fe,
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
                    limb0: 0x4d27874d66467022fc29465f,
                    limb1: 0x6c285f4fe00f130a05e1d05a,
                    limb2: 0x7ac161abf30faa0d,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x6f5115b1944f39891cad02a7,
                    limb1: 0x3d57baca90d65b0c63ca0e40,
                    limb2: 0x357c552c3d96f942,
                    limb3: 0x0
                }
            },
        ]
            .span();
        let scalars = array![
            u256 {
                low: 0xd8672940ac92dd2cbc87cf3248f8bbff, high: 0x4aa789fb8dff65d82dc0899c214a1a1
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
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
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
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x0,
                        -0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
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
                        -0x1,
                        -0x1,
                    ]
                        .span(),
                    array![
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
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
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x1,
                        -0x1,
                        0x0,
                        -0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        -0x1,
                        0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x0,
                        0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        -0x1,
                        0x1,
                        -0x1,
                        0x0,
                        0x0,
                        0x1,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
                        0x0,
                        0x1,
                        0x0,
                        -0x1,
                        -0x1,
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
                    limb0: 0x7558ad7f07d490a06bfcd80d,
                    limb1: 0xd7052c1c8db0a62ddfc63d00,
                    limb2: 0x6d11328300e8cc04,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x7d03a0920700d8924178376d,
                    limb1: 0x5de91c1c981331af16318c26,
                    limb2: 0x1d840889223df0f0,
                    limb3: 0x0
                }
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x48b3deba1b86d48e05d23878,
                    limb1: 0xed20164ff6ed2e7fe746ab01,
                    limb2: 0x1c334b719c0ccd61,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xa29b7099c271be6ef12da26c,
                    limb1: 0x5b4f811154cfc4b08660469b,
                    limb2: 0x3fbeed07d247b6ac,
                    limb3: 0x0
                }
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x789942d3d6d5f447e577157f,
                    limb1: 0x9ad34914ec8ce08fce4570fc,
                    limb2: 0x1ea7372c6911dcdd,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xe34e5acb1241c703ec3a330f,
                    limb1: 0x13b831ae4a00234534846ed,
                    limb2: 0x19e311ec4ec71573,
                    limb3: 0x0
                }
            },
            SumDlogDivLow: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x7546894ffd11407e78e70607,
                        limb1: 0x9ce045d39b2707065b551408,
                        limb2: 0x5363b5a52cdc1575,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc6b9af5ee65778bd7bb4a7aa,
                        limb1: 0xffffffffffffffff8f2bbec9,
                        limb2: 0x7fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x127064c4e7dec29508aa87a3,
                        limb1: 0x9ca2a61f4cb4c6f9c8db96aa,
                        limb2: 0x3d615a7046debb5f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3d7fcb3391e4ff3c97d9e16e,
                        limb1: 0xbcd27493924046c81a57f2a5,
                        limb2: 0x182d6bd10c0789ed,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x4debfe332cf30856aae8d3e8,
                        limb1: 0xe90613dbff55427759240bdf,
                        limb2: 0x2a801497b6ae28c3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xf30aec52182dec19c9739478,
                        limb1: 0x7ea3248c9b43e29305b8cb13,
                        limb2: 0x1b33f4e51853b7d2,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc64b1c2529620581cbfdcd73,
                        limb1: 0x314fca3dccaa0e962f624204,
                        limb2: 0x1a2039f0404bf3c6,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xab305a876ac7e12f3b0f8c68,
                        limb1: 0x5c5e1d4e15b613b46ba23ca1,
                        limb2: 0x127af056e0509378,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7863731ee956f2c745905b1,
                        limb1: 0x9f59dedbf1e1df1e31cc2342,
                        limb2: 0x13afd01bc12c5e7,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3efe71f68e02cb170b888bb,
                        limb1: 0x6fecc9cd6354134b722a16ae,
                        limb2: 0x87fa7d5e7859c09,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x1f158fbc9450a42401669ee3,
                        limb1: 0xce3a872cae3004d034944d07,
                        limb2: 0x1ab00743ec987a45,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3d7fcb3391e4ff3c97d9e16e,
                        limb1: 0xbcd27493924046c81a57f2a5,
                        limb2: 0x182d6bd10c0789ed,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHigh: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xa7b0ef36363fce73954e8672,
                        limb1: 0x89c92a9f2defa79b2a93789e,
                        limb2: 0x299e2a62326949fb,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb5e589460b7601ce61f63813,
                        limb1: 0xfffffffffffffffffdc4a313,
                        limb2: 0x7fffffffffffffff,
                        limb3: 0x0
                    }
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xfb006e90e9f3c12d451d06db,
                        limb1: 0xcdb3efd8387bfa2edca8de39,
                        limb2: 0x6c3a253214d990e8,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6a2499f87e32bb4efe048103,
                        limb1: 0xa6b78a602903be7612d784a4,
                        limb2: 0x690b52e270e38890,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x19f180e7f6acac876d590af6,
                        limb1: 0x6113d8d83bb54daa8f60d514,
                        limb2: 0x3ba6810e55df63f9,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xd563a94da85d2e1982a2a7c3,
                        limb1: 0x33938102869b437ab7f63ad5,
                        limb2: 0x33f9e7902cc0e3d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xa44e0b2959368639e968bebe,
                        limb1: 0x7822bc5d1024811175a8128e,
                        limb2: 0x8b852690ba23b2f,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xb8fbbaabccbba225e676853e,
                        limb1: 0x656c53cca8fe19cb319bc036,
                        limb2: 0x61f56036315b349c,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x8b662a6ce24f9fcf2a69198c,
                        limb1: 0xc72814404b9b9cb30f333930,
                        limb2: 0x4c7b45f7f1eaf6ce,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xbcaa11a26c8f2f5711d20743,
                        limb1: 0xf8c3d958490ad02eb2763475,
                        limb2: 0x37f478a253245e32,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x7a599889665a2bc3dd91e1b,
                        limb1: 0xff4bd0e599f7380548619497,
                        limb2: 0x4988d205ba934fce,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x6a2499f87e32bb4efe048103,
                        limb1: 0xa6b78a602903be7612d784a4,
                        limb2: 0x690b52e270e38890,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
            SumDlogDivHighShifted: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xf9fc3717dd010ee751fdfb7a,
                        limb1: 0xc088322f4a748ab3ca0161e0,
                        limb2: 0x397cce4802f5fe8,
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
                        limb0: 0xcfd706013f5b8f30609c1b99,
                        limb1: 0x87a04d3de52c397a4096d179,
                        limb2: 0x3d435d706ea78cfd,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3eb2de720da3372a14b6b1f6,
                        limb1: 0x780ca09b1c85f0f04a73e402,
                        limb2: 0x45257d61fae155c0,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xdee1b99b24d3ef48e0ff4245,
                        limb1: 0xeaa660841ed67d4dd6d7be7c,
                        limb2: 0x13d350a219d4921f,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xc5953678d9aa5a8af23450a6,
                        limb1: 0x9f77e1a5811a1f32a85790ba,
                        limb2: 0x59e3ca1643d1b3b3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x875b05b3d61e1f4be6c7d588,
                        limb1: 0xafdd97cb8c7d62d100e92946,
                        limb2: 0x5a4fe0f67e0bfc03,
                        limb3: 0x0
                    }
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x3fc86490f90feb02b744ca09,
                        limb1: 0x1cc436a91c4189e4ee8d3c53,
                        limb2: 0x5a61bc562912c696,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xb42d7f66340515a3757c63c0,
                        limb1: 0x431c2376c5d365c0ed33d5,
                        limb2: 0x5bc1c57f7573b303,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x68288fde2d41273dd7187fb0,
                        limb1: 0x632fd5bb3e0ec93f8655f8e1,
                        limb2: 0x1a2d0a96b0dea67d,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0xdc7c30f8ebcd70bf595832d9,
                        limb1: 0xb9382e4b46a77750ac4f87d6,
                        limb2: 0x1a920a4414614be3,
                        limb3: 0x0
                    },
                    u384 {
                        limb0: 0x3eb2de720da3372a14b6b1f6,
                        limb1: 0x780ca09b1c85f0f04a73e402,
                        limb2: 0x45257d61fae155c0,
                        limb3: 0x0
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                ]
                    .span()
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xc240b7291f6939c8a711c563,
                limb1: 0xc48b377fad7e231aa302c8d0,
                limb2: 0x2f42b1522ccc05e8,
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
                    limb0: 0xf9b4c947318bea7e9dcc38b8,
                    limb1: 0x8bd5a69db34c98483cbb2516,
                    limb2: 0x7cd350d72ed673fb,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0x774d07c68a1f49382d277363,
                    limb1: 0x96cecf3ccadb0e867d2d9aa4,
                    limb2: 0x5fd9f6edc2c767b9,
                    limb3: 0x0
                }
            }
        );
    }
}
