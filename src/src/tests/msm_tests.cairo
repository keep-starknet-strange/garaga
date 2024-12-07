#[cfg(test)]
mod msm_tests {
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1, MSMHint, DerivePointFromXHint};


    #[test]
    fn test_msm_BN254_1P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xb4b30030d604f094d3602296,
                limb1: 0xa0e983b28babaffaeaa2a062,
                limb2: 0x471c9e526d4e91e,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_BN254_2P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x4438dbd4fc537b19aa9029a1,
                limb1: 0x71338662165803d1aeba36ff,
                limb2: 0x8463adc2f6b3ff5,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x75937bc3dba286ad2bd8fe5,
                    limb1: 0x575d166325014e975405464f,
                    limb2: 0x1437873db8d7dca1,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x772ca79c580e121ca148fe75,
                    limb1: 0xce2f55e418ca01b3d6d1014b,
                    limb2: 0x2884b1dc4e84e30f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x967d0cae6f4590b9a164106cf6a659e,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_BN254_3P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x5b9b511a35490c4f05d6e4e7,
                    limb1: 0xf11ec8642a0df9cb0b8f2cdd,
                    limb2: 0x2b568cd4a3e221ca,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb45c3680d8359a0fdb47de6f,
                    limb1: 0x4c17fe1c96f237095df8c737,
                    limb2: 0x118fc0474955ac2b,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x47bec5e5e1f295cdcd7689e9,
                    limb1: 0xcb171283d651071401630545,
                    limb2: 0xa401c0298cd5f83,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe5d2831c05e61956d8725b57,
                    limb1: 0x6bb84991518471727263fde0,
                    limb2: 0x15e82f62ee3caf32,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xd15f8e23aaf3af13ab5ba169,
                    limb1: 0xb0ff9631870f189040aec289,
                    limb2: 0x1c77509b88d3bab7,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb620e3716b30b1003beab421,
                    limb1: 0x1d6aad1137155249c5d4f785,
                    limb2: 0xbf95d2db0be45f9,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xbba74f84d6d3a3c60dc3cd41,
                        limb1: 0xf36f80b4b1a3f69f44ab1b6a,
                        limb2: 0x16adf9385577d09,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe3748a5201028055d851d0da,
                        limb1: 0x7d4d0c483a8050c66e35c6e1,
                        limb2: 0xe58ca0d31a6a8d2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa59f084b703ac17683ca07f9,
                        limb1: 0x7f1a924087f5442a95a66068,
                        limb2: 0x284cb90ec99aa375,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1c72c56de666104df8056a9f,
                        limb1: 0x3b0db6cd914b52831fc41396,
                        limb2: 0x1953864f49cc904c,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x36208c0885fb7058abddd334,
                        limb1: 0x3db412a5e6005a05ab374adf,
                        limb2: 0x2b398812b30eb292,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdf68dc78906c44847536a23d,
                        limb1: 0xa6bbd9ceb18275da98d88a68,
                        limb2: 0x11b898e607064ade,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6f0aaf5b805720e403eddcdc,
                        limb1: 0x11afb25fbfae966d38aea0d6,
                        limb2: 0xc14f6e4a6a37797,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x712f22263ef5e91c488b0722,
                        limb1: 0xbf68443cfd66208b1f0a2b4e,
                        limb2: 0x19990ced3afb3faa,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x210edfad5881dc6bf8ec5f58,
                        limb1: 0x3c354ff8e0cba98c03e7c606,
                        limb2: 0x1d8c9c28e2545384,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x95055f0bf55a751df0f89316,
                        limb1: 0x652b61b3a2e6073c3af64fcc,
                        limb2: 0x23080aa3e59e0cc4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9e36b036fbad71c308a43548,
                        limb1: 0x5261fa4f1b50b2519194e556,
                        limb2: 0x218c5e7ffb07ea5e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc8285d3649f36c8f5daaa331,
                        limb1: 0x3f053e816c7552d20ecadbc7,
                        limb2: 0x2527827f86516567,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7b5fb11b84d5950d23c96fa4,
                        limb1: 0xe2b051a2b9c1cc88b1d77617,
                        limb2: 0x1edee19e79e4e9ad,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xd17e0eff19b138dc529f7f0e,
                        limb1: 0x487bac84aefe5d55d2a30b7a,
                        limb2: 0x20e3fb5256c8d763,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x35c8cadc752441768726e970,
                        limb1: 0x3be347b593060932330834a9,
                        limb2: 0x4c57c3f33e14072,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4d200e12810562ac0bc99694,
                        limb1: 0x350f171f3f0bc347aa0be283,
                        limb2: 0x243ee4adf3ea66c5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb8ca5d60ca9c137fd484ee0c,
                        limb1: 0xb4c53efdb300aebd952f7a7,
                        limb2: 0x173c11f4a19d313f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdf68dc78906c44847536a240,
                        limb1: 0xa6bbd9ceb18275da98d88a68,
                        limb2: 0x11b898e607064ade,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6f0aaf5b805720e403eddcdc,
                        limb1: 0x11afb25fbfae966d38aea0d6,
                        limb2: 0xc14f6e4a6a37797,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x712f22263ef5e91c488b0722,
                        limb1: 0xbf68443cfd66208b1f0a2b4e,
                        limb2: 0x19990ced3afb3faa,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x48c8946a24cb60456d420600,
                limb1: 0x9ed381bdd7c9eeb7bafa2d1,
                limb2: 0xa24e6a0b6a74206,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x772ca79c580e121ca148fe75,
                    limb1: 0xce2f55e418ca01b3d6d1014b,
                    limb2: 0x2884b1dc4e84e30f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x536c985db33c69f7c242e07a,
                    limb1: 0xfc531bccffafcf1e59d91fb9,
                    limb2: 0x2585e4f8a31664cb,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x57fa42444057cf0c1d62ae3c,
                    limb1: 0x4f48d341183118d68ea41313,
                    limb2: 0x1d2d2799db056ed1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0x1521f387af19922ad9b8a714e61a441c,
            },
            u256 {
                low: 0x5a92118719c78df48f4ff31e78de5857, high: 0x28fcb26f9c6316b950f244556f25e2a2,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x21725fdb9f487676e547051,
                    limb1: 0xc23930e4f96498a77a316418,
                    limb2: 0x1244cb13309195ed,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x6251c487cf0f5a44ac24a45b,
                    limb1: 0xf1db336c10ce7fae206dd8dd,
                    limb2: 0x1da9c56792006d76,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_BN254_4P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x86e063fb7ec25be43b131a81,
                    limb1: 0x93e844015403a8f7dfeb5c28,
                    limb2: 0x174a5493e74a2d09,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x91ca263218101c0d60b53319,
                    limb1: 0x581ed6a4a31cb7fd061d99c,
                    limb2: 0x183999b303e135fd,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x5fb5769b3e3c1bee7a6b6b29,
                    limb1: 0x280d5e368d6965bfb181f8,
                    limb2: 0x2bc047bf3c906ee2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9f898b2cb0c81f1d4a2a4c9a,
                    limb1: 0xb0c4c460d5242da7f633b58e,
                    limb2: 0x2549f8d91404e768,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x8b78590174dbcc2cf125bf4b,
                    limb1: 0xa8cd83cf722816e54bfa0fbb,
                    limb2: 0x27b3d85c8cce1408,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xfefa5a6be30e6517c9b94ab2,
                    limb1: 0xfeb01666b69919f6d14354de,
                    limb2: 0x272bba280082a072,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x10653f25355172f2b59cbf35,
                        limb1: 0x16204d144a204943c8017a47,
                        limb2: 0x2822d209fec25092,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4cfca469f7a9822e50e36b5a,
                        limb1: 0xc3f46941ddabaa8cbb689c42,
                        limb2: 0x1374b756ad9c9440,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x98f11ef381dd5eb584ef514e,
                        limb1: 0xb6d8e147457c8d1cd0921955,
                        limb2: 0x265f23aa5e301d6e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd1e7b211d3dceb70a2774954,
                        limb1: 0x265e66c92d517355fda266fb,
                        limb2: 0xb4be994c3b86b76,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf9a9747f12dd5d02cd7c78ab,
                        limb1: 0x1c5aa525d6badff4c4b8697a,
                        limb2: 0x21d738a06dcecde0,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xa3fae32284a6972d7cb48e32,
                        limb1: 0xa4e8d508356939ad6189656e,
                        limb2: 0xf91cbdf43c143c1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x46697efd43932c85bddf65f3,
                        limb1: 0xcc792d12aaaaaeade8e226fe,
                        limb2: 0x27558e7858562ec9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1438f28b6b63d8d34f8201c7,
                        limb1: 0x95965262c7f2fe8269f31bcf,
                        limb2: 0x238630bc5b425bd8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5fef6b65cce65e0fc1bfedd7,
                        limb1: 0x5de645663c9a80d910098353,
                        limb2: 0x1121af8eb6730ea3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb8dfb50dddbe4c02558da23e,
                        limb1: 0xfcdd9dc3eeef382e73e86de,
                        limb2: 0x29b726259cec4822,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xb1ba457a40b838cc3935b303,
                        limb1: 0x5880c0dde5efe6ff2fa10316,
                        limb2: 0x19714f8ecee0a27,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x212c9ddbe1b486faef94b7e6,
                        limb1: 0x9b3cf26fae656955c53ed091,
                        limb2: 0x7b0ade90081f8a9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc531edc6eb7c3ab58be56d3f,
                        limb1: 0xab2dc1c0faf76c4238982240,
                        limb2: 0x3f026d8f93ffbc9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6ea716efdb75d98c88481c9f,
                        limb1: 0xc9d75f20c417032f04e98e61,
                        limb2: 0x2088ba8374a047de,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdaac2161587237b0f39e4104,
                        limb1: 0xd516f4267341e2a6802dc6df,
                        limb2: 0x1b0ceeb10939ebe5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x135a19517a18d73b51553204,
                        limb1: 0x41fb136ee3dd9ca2f24fad97,
                        limb2: 0x2ce73a6d92a329f4,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xebf0a9678df3c588761daa96,
                        limb1: 0xeeba7f18a03bad08249c304b,
                        limb2: 0x2eb5639dcb43cb44,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x258e7dd52786d6388a4374b,
                        limb1: 0xf4cafbcafcfd5b4e8ba39fd8,
                        limb2: 0x15380e83469f4c09,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6bc74287c9ea724c3d8c0ac7,
                        limb1: 0x50226bbb54d64acc0ed67e4a,
                        limb2: 0x9c9f54f4f63d336,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5b575ac6af392545e9775a70,
                        limb1: 0x64b5f8469b763dafa2484d7,
                        limb2: 0x12928c1885e8cf82,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x37b33e7f286c6c48351154d8,
                        limb1: 0xd2f1e983e2f3801dd8197be6,
                        limb2: 0x134e15908b8626b2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1438f28b6b63d8d34f8201ca,
                        limb1: 0x95965262c7f2fe8269f31bcf,
                        limb2: 0x238630bc5b425bd8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5fef6b65cce65e0fc1bfedd7,
                        limb1: 0x5de645663c9a80d910098353,
                        limb2: 0x1121af8eb6730ea3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb8dfb50dddbe4c02558da23e,
                        limb1: 0xfcdd9dc3eeef382e73e86de,
                        limb2: 0x29b726259cec4822,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x6b1128c39bc35c7a224a4682,
                limb1: 0x4152437e9909950bf363dd99,
                limb2: 0x129d1cec2df75972,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x772ca79c580e121ca148fe75,
                    limb1: 0xce2f55e418ca01b3d6d1014b,
                    limb2: 0x2884b1dc4e84e30f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x536c985db33c69f7c242e07a,
                    limb1: 0xfc531bccffafcf1e59d91fb9,
                    limb2: 0x2585e4f8a31664cb,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x57fa42444057cf0c1d62ae3c,
                    limb1: 0x4f48d341183118d68ea41313,
                    limb2: 0x1d2d2799db056ed1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x236ca9312dad3661a37f2d6f,
                    limb1: 0x98424c01caad7592315715d1,
                    limb2: 0x795b9fd941b23c4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc7ab5834609a54b8993ffd79,
                    limb1: 0xe81cd490528b814ca632aace,
                    limb2: 0x2d9ff53d3009e6f7,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x5a92118719c78df48f4ff31e78de5857, high: 0x28fcb26f9c6316b950f244556f25e2a2,
            },
            u256 {
                low: 0x8d723104f77383c13458a748e9bb17bc, high: 0x215ddba6dd84f39e71545a137a1d5006,
            },
            u256 {
                low: 0xeb2083e6ce164dba0ff18e0242af9fc3, high: 0x5f82a8f03983ca8ea7e9d498c778ea6,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x788e687dfb0b523192cc5507,
                    limb1: 0x6f7b3482a11f4cce1bffaf09,
                    limb2: 0x225f8689ecb156c4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x2ccf8a4cb742cbcef2f9ac6a,
                    limb1: 0x518ede2a1e12372316e8442b,
                    limb2: 0x4ad79f70e4de756,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_BN254_10P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x68bfb16794e5817b6b448ffe,
                    limb1: 0x111b7282dbeffcce7b3f715,
                    limb2: 0x246bed5ddc3c74a9,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc91f291a147b3b57a00196a7,
                    limb1: 0x8839341dbd54ad6d21e0e0ef,
                    limb2: 0x18889d68d755b621,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x635439e16fcbfe5eeba3ecf3,
                    limb1: 0x45b96bc19418f65e9d7aa491,
                    limb2: 0x305fbc2daa6baee9,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x4368a16fa3c73077c4f3cd6,
                    limb1: 0xd363f026c2e38686d22c3585,
                    limb2: 0x291cf0bebd9202c1,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xb3b7d4349ed18bd82925ef84,
                    limb1: 0x3cd4cdba2a8676b60e52962c,
                    limb2: 0x2bc5ba2338a53b6c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x866ec014b98838760c368ee6,
                    limb1: 0xfdaac7c202634518f73544ed,
                    limb2: 0x2206a4deafdc7284,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xaf7d125ec32f3ba4431d34de,
                        limb1: 0x6f6e20dab8c0dd8932d8f416,
                        limb2: 0x131f236e5a54f8f8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6c190fa7d984a10a336b8702,
                        limb1: 0xf15a35d34520ad579fea9ca8,
                        limb2: 0x29d11bbb968291f4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xad49dd65067671eecbd328f4,
                        limb1: 0xf99f002d460830ac3b9d4a06,
                        limb2: 0x230469a97e1cf12b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x813040ff88b8392f4de91fa3,
                        limb1: 0xe6aabfd5906788e0cf0847fb,
                        limb2: 0x230c50b158c5bd02,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x39fec5792abad9e7d5940278,
                        limb1: 0xe00f7c3a3ea02095f9c013f5,
                        limb2: 0xa187cc10921e90d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa9de001b53b9d39940663a7f,
                        limb1: 0x1436fe71dd83c7169a0f688c,
                        limb2: 0xca18cdd95521457,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfb8d963e4a3b935a06a75e10,
                        limb1: 0xbe59423894ed1450eb9b0d7a,
                        limb2: 0x1f70ecd9cf661258,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd4904ee2748bbfd354abe64e,
                        limb1: 0x43a70351700daf536df38af8,
                        limb2: 0x216318598a21a0cc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3606d31e1682d1a58e068c5a,
                        limb1: 0xc961b5b62212acd12cc2071,
                        limb2: 0xf63cf2fea5176a7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfeaab7486ca2d72c5619aad2,
                        limb1: 0x821014ecbf475af3ad66b3ad,
                        limb2: 0x2a560f4b5eaad07d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x79e2452c302e3f47c9a8a5c3,
                        limb1: 0xd7be1bb764e3bec0e530fbc,
                        limb2: 0x2cf3882aa937b27b,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x4657b0ebee16dd56181b833,
                        limb1: 0x4ae45fa6363575978ee85d8c,
                        limb2: 0x1c4c473df9542fc3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x286b06a32b7399c2e855b3dc,
                        limb1: 0x10b6ed16c7a46caa05c43a62,
                        limb2: 0x26381abf7c928fb5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5e80814091b75c9539e9f5ed,
                        limb1: 0xf9ebfe9bf47e7d04f15be012,
                        limb2: 0x2eba43e70fad05c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3d9d5a6d0d12fec793934d59,
                        limb1: 0xe906381cb5254093ca653bdf,
                        limb2: 0x21b2197fa81de661,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf07de23476b4a3b887d78a06,
                        limb1: 0xc465ce4bd051101ac3e236c5,
                        limb2: 0x13d9cfe5bd03c3b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x85c99955212cb97badbd1ee6,
                        limb1: 0x53bb40f728b999ff0f35ddaf,
                        limb2: 0x3e6879ee587ba75,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe35d73f99e215c35c9d02de4,
                        limb1: 0xcb98db2dec568868e5f1c4c1,
                        limb2: 0x5ece7a4e72e7075,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf410ffec6570f047b7d48469,
                        limb1: 0x37439bbbff8ebbdd0b914270,
                        limb2: 0x13551edecfe046ad,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x64b011628f66bcdd0ed7e8ac,
                        limb1: 0x5987f609cf8cde7dcf38fab5,
                        limb2: 0x129ff152124ba7b5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeda08ed68e799589a61f9933,
                        limb1: 0x430f9a4dbbe908b574cd7190,
                        limb2: 0x19b09c080149debb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x62cec2278f875def236a8b50,
                        limb1: 0x41047f4ad11ebba884867a57,
                        limb2: 0x8a0491ff32a9050,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x87a064e177fa6cdfff374b8c,
                        limb1: 0xfff9f19724b56aafdd024032,
                        limb2: 0x983b0db79c74404,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc6156abc969464bffd55ccc7,
                        limb1: 0x6d801d95e54a85a7615cdc5e,
                        limb2: 0x309415d6d92169c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa9eb0487ef56247ac74c1161,
                        limb1: 0xb99afc1c75042badc372f1cd,
                        limb2: 0x2a1919a9f6d080c0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1748cb45e2e4593ce47d95cd,
                        limb1: 0x80487ac2813f1f92870145dc,
                        limb2: 0xdf579d06b0776ba,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9568400694c54fa02800834b,
                        limb1: 0x46e49ddb516cb3675ffb418f,
                        limb2: 0xc07475bc87d046f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x55c5208f6d4ce82cc69659b0,
                        limb1: 0x5bcf66f7ceb8e092199638a5,
                        limb2: 0x2aad8b2aca8af6aa,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9c0ec7b6b30a9d2087709e6,
                        limb1: 0xb863d12b618ffb1ac6e3f7ff,
                        limb2: 0x25dabffb8491d6b5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1a6b5724aa6a48dde922fc1e,
                        limb1: 0x422be8178679f65821626e35,
                        limb2: 0x1b54f591aa000bfd,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb54d6d8cffb7c0a0ea3546f8,
                        limb1: 0xad443543cc62c5e9ac28fe40,
                        limb2: 0x3fc20009db226be,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x64585c6aa766dcda2a66105f,
                        limb1: 0x46eb099328d5af08bb110388,
                        limb2: 0x740549b430965e6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3178402d4aa0406533e2df06,
                        limb1: 0xcf47b3e982fadf26a6646e81,
                        limb2: 0xe1fc8c46b7d18b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x65879edc94735271c8430a8a,
                        limb1: 0xae233af91cbefd1cb4d45b00,
                        limb2: 0x9e299a455e329d4,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xa4bea69f0083bd694c082b52,
                        limb1: 0x285cd93c211f08691537ae12,
                        limb2: 0x248087470acaef20,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa85d7ecf0a19b51b08072106,
                        limb1: 0xc1843bd753ea9542e249da03,
                        limb2: 0x11dfb358b3546ecb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1b8183c1b52615bfadbde1c7,
                        limb1: 0xedc3fbd3dd7b770ed413a037,
                        limb2: 0x8c2ecbb52f07116,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xec59f53b6dd951fe6b41a5b0,
                        limb1: 0x95567c8f52a28697bf153c06,
                        limb2: 0x2099f6d72f4aa295,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2901182617506cbecee25760,
                        limb1: 0xed47cc8d3594ec3f22680991,
                        limb2: 0xfced8af13a9a8b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xefdd4d3ff53d89084321529f,
                        limb1: 0xf51dc1816eab4b021efd7920,
                        limb2: 0xe9f3b1b2191ffbc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7f43ebccab5687521886d9be,
                        limb1: 0x938083eff8a78170e4b91f93,
                        limb2: 0x31481fb7c779799,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x643f176c6ae6e878d6d819fa,
                        limb1: 0xb1e05bc94d7beb544f149387,
                        limb2: 0x1d74de0f4b72f796,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4b6802ef934063fc01c7dba3,
                        limb1: 0xa802dd5e15dedd1ae55f633e,
                        limb2: 0xb620d223b39116b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x43cd55f00d6d90bbe3b1fc36,
                        limb1: 0xdc7764609e904a2bacd8aee3,
                        limb2: 0x229a6d4a09da6c7d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1c7d466314070a1522142659,
                        limb1: 0xfa51199c72eaeed69924b177,
                        limb2: 0x2d35fa3ea95ff79d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x64b011628f66bcdd0ed7e8af,
                        limb1: 0x5987f609cf8cde7dcf38fab5,
                        limb2: 0x129ff152124ba7b5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeda08ed68e799589a61f9933,
                        limb1: 0x430f9a4dbbe908b574cd7190,
                        limb2: 0x19b09c080149debb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x62cec2278f875def236a8b50,
                        limb1: 0x41047f4ad11ebba884867a57,
                        limb2: 0x8a0491ff32a9050,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xf68598a29ed4f5908a0ce3e0,
                limb1: 0x7c13f04bf820695fc6988663,
                limb2: 0x159c215cc697b53b,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x3d8d2155f32b2afd581e52ef,
                    limb1: 0x3c6ae4ef100a84d6a4ca3d9b,
                    limb2: 0x11d745ac5fb8e6cb,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x772ca79c580e121ca148fe75,
                    limb1: 0xce2f55e418ca01b3d6d1014b,
                    limb2: 0x2884b1dc4e84e30f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x536c985db33c69f7c242e07a,
                    limb1: 0xfc531bccffafcf1e59d91fb9,
                    limb2: 0x2585e4f8a31664cb,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x57fa42444057cf0c1d62ae3c,
                    limb1: 0x4f48d341183118d68ea41313,
                    limb2: 0x1d2d2799db056ed1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x236ca9312dad3661a37f2d6f,
                    limb1: 0x98424c01caad7592315715d1,
                    limb2: 0x795b9fd941b23c4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc7ab5834609a54b8993ffd79,
                    limb1: 0xe81cd490528b814ca632aace,
                    limb2: 0x2d9ff53d3009e6f7,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x163df40cafbf585ca5b2ab44,
                    limb1: 0xb4752e4666c88dbbe23783a0,
                    limb2: 0x1a801462ac9cb657,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xac9b557d7ca8625d957263c6,
                    limb1: 0xdc6f75fa8339a78b998ae54a,
                    limb2: 0x28683293b6494d9f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5c4f5dca0c973b7f70bfff9,
                    limb1: 0x188c2afab11eef5d48ecda3c,
                    limb2: 0xc2fed35d36c49f1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9d7244ea10697ca42e2e066b,
                    limb1: 0xfe18a519c7d68770dc48dbf9,
                    limb2: 0x149bb528db998529,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xffc057151b06c496e6fdd440,
                    limb1: 0x5a01bae0c7441f08c7af1cf9,
                    limb2: 0x274e0e02529e6d26,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x65ceb8977413bc9798681ecb,
                    limb1: 0x19ffb287b45234f0c28fd1a7,
                    limb2: 0x28dbbd2f9267be76,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcfcdbfdb2056ff1a64bf1d47,
                    limb1: 0xf26fe2dae9f693d9b4aab2e6,
                    limb2: 0x12d66ad4802d841e,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe6e34ebfa2e18dce86cadbdc,
                    limb1: 0x7ce096238b3d4b1b8fba6a55,
                    limb2: 0x2e0a660b1549800c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd2dd03b29d58d045656ecf33,
                    limb1: 0xeddac3cf7a123aae2180739b,
                    limb2: 0x215bec6e0a03c924,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe5201e51828eb11589d8619f,
                    limb1: 0xa6563c760aa3a2c9d15af235,
                    limb2: 0x7ed0c9b2e7811fb,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xc33ac21c67b06a9994457b4c,
                    limb1: 0xa9aa5573bf7a92aab85366eb,
                    limb2: 0x1a407281e1d92e91,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5a306649d971b115d71a78b1,
                    limb1: 0xa70687a9b5132e26b2cfbb37,
                    limb2: 0x2031920af5d6c9db,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0x5d67b7072ae22448b0163c1cd9d2b7d,
            },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x1f507980eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x154bc8ce8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x2305d1699a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x144a7edf6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x21c38572fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0x2b70369e16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x522c9d6d7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0xdc5dba1d977e9933c49d76fcfc6e625,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x308fd6b45a63e49bf708e96,
                    limb1: 0x9b97a3363c95c209e8fab620,
                    limb2: 0x1ae699a4de6d9998,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x6966fe3425872dc23fd55404,
                    limb1: 0xa8be5375eb482c4e7d2ad043,
                    limb2: 0x12572137d2078244,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_BN254_11P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x90b45d7a39843ae2cf8649e4,
                    limb1: 0x4f3f05fe6a82257db5ef4638,
                    limb2: 0x2e5317b879b4f67d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb5aec8ffa005f236cb86d08f,
                    limb1: 0x7c11b27ce9c06cee3fa3793,
                    limb2: 0x13abbc2cb5a70d04,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x6c7780a212a34f79a5a4984,
                    limb1: 0xd2b9f43370853e82b6e280f3,
                    limb2: 0x49098e1fef9ff1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf16e5ea4fa4507af42f9148f,
                    limb1: 0x67e653350524a43c52475d47,
                    limb2: 0x1ff99fb3e2fe4ead,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xc18d4af2d637781faf364b80,
                    limb1: 0x43beee7449f92708853e95de,
                    limb2: 0x3072f460ce59704,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x1dddbd01de2320fae30a9244,
                    limb1: 0xf6111cd106dc6a17348c4d58,
                    limb2: 0xc922fcf80c6b390,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xdaa07b8ea27df5d1897869ab,
                        limb1: 0xc54cfbc31ef45543d8150b19,
                        limb2: 0xbd0fab73eb85d0d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x34ccddfaf7b3ed235213dcab,
                        limb1: 0xd44c1b1736d255429671ad73,
                        limb2: 0x21a878cbd6b4b0cc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xea4beeaf9a6c80a232bcb7c,
                        limb1: 0x61df2bfedf4cf60173a01060,
                        limb2: 0x10cafaf408f1feb4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x82c167316625a7c71992f944,
                        limb1: 0x1297c4a01bed568ea8024c36,
                        limb2: 0x15e5cfb62a197016,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3cbb929ea01eff89f7a7d264,
                        limb1: 0x536189ed828464cba924402e,
                        limb2: 0x1d63ba349b38c92e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa85430a52d73648889dec774,
                        limb1: 0x82f33760c0aea35622a39e8f,
                        limb2: 0xf131a326cccad50,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3b0b143c868d76090291fea,
                        limb1: 0xfbf4ce4ddb3968b4515381c9,
                        limb2: 0xc7eb57c34de5192,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb5ef5e7f9a0c505455748f4d,
                        limb1: 0x2f03e3a14ef0257209cdf5c5,
                        limb2: 0x14c6ea2d819a9191,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x542bf714c3ba733218bfc42d,
                        limb1: 0xbfc0393702606c1b1925759,
                        limb2: 0x3017d9c6d45c7119,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfb6db671319cae936cb97ee6,
                        limb1: 0xa134730e601654d2f9df2df5,
                        limb2: 0x51be0a515dcb23f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x74bd8d9913e9f913db684c80,
                        limb1: 0x8c0641a00b734d0c44d981b8,
                        limb2: 0x27e21e34a7c8df85,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5245d0fa49135afb2e9d9528,
                        limb1: 0xe1549e6f5162fc621bf6b811,
                        limb2: 0x2f9d4afbf992c91c,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xd406531fcfc930a8da2591f,
                        limb1: 0x7a2a0e244b1042a04f820ea4,
                        limb2: 0x2c2a21242f357f14,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x39212c5b805d6d02fc128588,
                        limb1: 0x752d1a1c891743ada97b81e3,
                        limb2: 0x1b36bfa25b177de2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x631d827be967a2b6d92b01a3,
                        limb1: 0x77965466ee60d2942e3ac977,
                        limb2: 0x2efeed6528498957,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc1b739bffbe567911b00dbd9,
                        limb1: 0x6de34c2d9b8b330ed4201f99,
                        limb2: 0x2bbd58c828bf1ddc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x966426b62d820c84bc009043,
                        limb1: 0x79fd779094c2189e76513033,
                        limb2: 0x30374730630961c8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa73c5d0fb756c9e673cb9f9,
                        limb1: 0x747fb574c160541c61e4a47d,
                        limb2: 0xb46ebbfc16228f1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7e7efb718864394098bc3db2,
                        limb1: 0x6c88d9f47c549e1c60a8d0df,
                        limb2: 0x1567cf53183200cc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x54c40c59c8eca86888da1c4d,
                        limb1: 0xf6ee957be08f25764ac1b5c8,
                        limb2: 0x1775414c829c052c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xaac7b9996bac577258eb942c,
                        limb1: 0xcdb642c2342ab601e6624514,
                        limb2: 0x10ac61f1c8598fb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1191df60919977f7a5bc5544,
                        limb1: 0x2bef369b4095ecf2650b07c9,
                        limb2: 0x29f678a0387dbac3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x37710199f53b2af34a9437e6,
                        limb1: 0x24984368bc304c5ad084a7a5,
                        limb2: 0x24173b96ce0217c4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc87bc7ffb5c4df50832dcf8e,
                        limb1: 0xc6ac740037cc028da2540454,
                        limb2: 0x15d9510e8ff821a9,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x70c5ed0de13f7015a416f085,
                        limb1: 0xc1d1c25f362c8d805cfbaf71,
                        limb2: 0x23d5b3c77c8c2f20,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb1726996ae2316b39a719f9,
                        limb1: 0x4fe9cd6b54ad6b1aa7b396ad,
                        limb2: 0x1f02dd17520f6e7f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x22501b7b623ea1614501ccbb,
                        limb1: 0x30aa9870bf709f7fd14e65bd,
                        limb2: 0xc502ae99bd0a484,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x983e9ed2c26a331fccc6755,
                        limb1: 0xf52ffceb76113b3d8d0b4a31,
                        limb2: 0x7a0c834e064b3ba,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1a2eea53a5ba3367b77d83e2,
                        limb1: 0xbc1c163f3fa99038c93f79bf,
                        limb2: 0x11eece5d709cfc86,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9cb401f315d26491728f8da6,
                        limb1: 0x9b6bdbae00611d8c0841871c,
                        limb2: 0xdc098398cf7cd6f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdc70a9ef6033c959d9ece67e,
                        limb1: 0x1328d87e5aa260e4da44463,
                        limb2: 0xa4e71a95fd93274,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x930f95dcfde08de3f9b0a87b,
                        limb1: 0xe9f0b050d24677eadd7b93d1,
                        limb2: 0xe64d906ad933a12,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbfd540222d27a2c073a44e4a,
                        limb1: 0x489ffd503b2abb17ea19f1ef,
                        limb2: 0x20064a93c0cbd712,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc996baf343cc475b7043bf33,
                        limb1: 0xf644323b86977747bb48aff2,
                        limb2: 0x5c49f46056bd7a2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf4afa5e4e02cdd3337f72a6e,
                        limb1: 0xaf71ee1f94a4548d13d98426,
                        limb2: 0x2f577c3289c4b91b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3e29cdb8b5fffe9f33d7e4,
                        limb1: 0x40e4abcf3b602887d9b63d0a,
                        limb2: 0x645ad7894e3228b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9720ecd478a5cd4536d55133,
                        limb1: 0x5bd670d4a398a39be295165c,
                        limb2: 0x4e55fc3394e06cf,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x56dd9a7b7eb4a0f1f7ed10cf,
                        limb1: 0xfddd9effde2e1725bf8356c9,
                        limb2: 0x23b5c686cb3d3ce9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x42f1ba8544f7baf21bba9351,
                        limb1: 0xa737089f19c472ab64f11b18,
                        limb2: 0x213ff0743014d97d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5874f25943f5cff6da870a5b,
                        limb1: 0xf62271c7c81fc7015bad8743,
                        limb2: 0x2c342b49b6795bb2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1910b2ca3c4b2579552df4d5,
                        limb1: 0x9ae32189992dd2b4055e2dbd,
                        limb2: 0x1e35402405ddf82c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc2f840d65481ee4ca69d3e7c,
                        limb1: 0xba34afaac2d9847045ead2c9,
                        limb2: 0x1aafa9dae09ec2be,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1a0709619fa75c7b36643247,
                        limb1: 0x1cc52f0eb100768bbc674c5d,
                        limb2: 0x206f62318b3e6402,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6c5096fa1cd0fb25343b9a61,
                        limb1: 0x42dd4e9e0d865ca8c717bd15,
                        limb2: 0xb2c29dbaef1dfee,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc3ccb6a91006ed90a594ea9c,
                        limb1: 0xee28ac97336cd84627937c69,
                        limb2: 0x15ce6e30287a30fb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xacaf29d3e7a72f571ff767d,
                        limb1: 0xdda27dbb5de07622150b73bb,
                        limb2: 0xe673e1d16f2f3e4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x79df39eb88cefce3007a45a9,
                        limb1: 0xc765aca2b9925bdac945a886,
                        limb2: 0x21e4ddb1e165098,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2a337c0d305d1114b79cc971,
                        limb1: 0xf416d449121d59cb8d4cd795,
                        limb2: 0x22f2572b2a3f0c25,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9bc9470b50da694d09f8058f,
                        limb1: 0x696b590c5a0d654d35dce781,
                        limb2: 0x12326ad7eb3c5dcf,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1191df60919977f7a5bc5547,
                        limb1: 0x2bef369b4095ecf2650b07c9,
                        limb2: 0x29f678a0387dbac3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x37710199f53b2af34a9437e6,
                        limb1: 0x24984368bc304c5ad084a7a5,
                        limb2: 0x24173b96ce0217c4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc87bc7ffb5c4df50832dcf8e,
                        limb1: 0xc6ac740037cc028da2540454,
                        limb2: 0x15d9510e8ff821a9,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x7ee07edccd5185fb30be9dcb,
                limb1: 0x199e43be870abb34b24b4c6,
                limb2: 0x76032cd35742b9b,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x6fa4dbf36a0761e2ddf07d4c,
                    limb1: 0x9764947c15a86e1190692c84,
                    limb2: 0x6b032fadf23f449,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x772ca79c580e121ca148fe75,
                    limb1: 0xce2f55e418ca01b3d6d1014b,
                    limb2: 0x2884b1dc4e84e30f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x536c985db33c69f7c242e07a,
                    limb1: 0xfc531bccffafcf1e59d91fb9,
                    limb2: 0x2585e4f8a31664cb,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x57fa42444057cf0c1d62ae3c,
                    limb1: 0x4f48d341183118d68ea41313,
                    limb2: 0x1d2d2799db056ed1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x236ca9312dad3661a37f2d6f,
                    limb1: 0x98424c01caad7592315715d1,
                    limb2: 0x795b9fd941b23c4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc7ab5834609a54b8993ffd79,
                    limb1: 0xe81cd490528b814ca632aace,
                    limb2: 0x2d9ff53d3009e6f7,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x163df40cafbf585ca5b2ab44,
                    limb1: 0xb4752e4666c88dbbe23783a0,
                    limb2: 0x1a801462ac9cb657,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xac9b557d7ca8625d957263c6,
                    limb1: 0xdc6f75fa8339a78b998ae54a,
                    limb2: 0x28683293b6494d9f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5c4f5dca0c973b7f70bfff9,
                    limb1: 0x188c2afab11eef5d48ecda3c,
                    limb2: 0xc2fed35d36c49f1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9d7244ea10697ca42e2e066b,
                    limb1: 0xfe18a519c7d68770dc48dbf9,
                    limb2: 0x149bb528db998529,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xffc057151b06c496e6fdd440,
                    limb1: 0x5a01bae0c7441f08c7af1cf9,
                    limb2: 0x274e0e02529e6d26,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x65ceb8977413bc9798681ecb,
                    limb1: 0x19ffb287b45234f0c28fd1a7,
                    limb2: 0x28dbbd2f9267be76,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcfcdbfdb2056ff1a64bf1d47,
                    limb1: 0xf26fe2dae9f693d9b4aab2e6,
                    limb2: 0x12d66ad4802d841e,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe6e34ebfa2e18dce86cadbdc,
                    limb1: 0x7ce096238b3d4b1b8fba6a55,
                    limb2: 0x2e0a660b1549800c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd2dd03b29d58d045656ecf33,
                    limb1: 0xeddac3cf7a123aae2180739b,
                    limb2: 0x215bec6e0a03c924,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe5201e51828eb11589d8619f,
                    limb1: 0xa6563c760aa3a2c9d15af235,
                    limb2: 0x7ed0c9b2e7811fb,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xc33ac21c67b06a9994457b4c,
                    limb1: 0xa9aa5573bf7a92aab85366eb,
                    limb2: 0x1a407281e1d92e91,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5a306649d971b115d71a78b1,
                    limb1: 0xa70687a9b5132e26b2cfbb37,
                    limb2: 0x2031920af5d6c9db,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x58a3cea1103f16402eb74c08,
                    limb1: 0xdfefcd91df2f4295ec21e03a,
                    limb2: 0x1150bcc09ac40007,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x57ed7d356f91abcef751889f,
                    limb1: 0x5c668cded3599c9af5a7e5fa,
                    limb2: 0x2ccf74197cb9bc13,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x1f507980eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x154bc8ce8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x2305d1699a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x144a7edf6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x21c38572fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0x2b70369e16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x522c9d6d7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0xdc5dba1d977e9933c49d76fcfc6e625,
            },
            u256 {
                low: 0xd344749096fd35d0adf20806e5214606, high: 0x119d0dd09466e4726b5f5241f323ca74,
            },
            u256 {
                low: 0x5306f3f5151665705b7c709acb175a5a, high: 0x2592a1c37c879b741d878f9f9cdf5a86,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x2f70823545198bb774dfb985,
                    limb1: 0x363546466fd4c023b72f21aa,
                    limb2: 0x2c5558596fa0905f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x50096f8b9d63643890d31c51,
                    limb1: 0x9e514bcb711d8e6edd2033e2,
                    limb2: 0x1436325ffa32a10,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_BN254_12P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xc3a31070a7d9ebd554d3a065,
                    limb1: 0xb9109b898885a0dc6fad5069,
                    limb2: 0x1078e59157543192,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x2f84df2e544b7106b7650ad5,
                    limb1: 0xfbe6bc68eb7b3ce9d0921d3a,
                    limb2: 0x1b6201f18ce1978b,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x69e5b9c91819ad621d92f585,
                    limb1: 0x1f4dce0d4ef79a593fca55f5,
                    limb2: 0x2ab6b6fdf389efe1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc5045bbf844632ca4df04976,
                    limb1: 0xbffb033e8ec5f6c914bf9cee,
                    limb2: 0x2bde1f40aae349c3,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x160c2a4f26366c842c4fbc30,
                    limb1: 0x721ae82df8c46c7080ac4d92,
                    limb2: 0x21f7cd237e1c9b32,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x2fd1353df407c3cde1804d5b,
                    limb1: 0x1e4a97ad0ea11589cde85f6a,
                    limb2: 0xf143fae3f3561cd,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x55241f714dcf4b67b987f4a5,
                        limb1: 0x352f234e9d8b499e8c3ef1f7,
                        limb2: 0x7c10656dacdfdc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe3c3d4f88d7340be46893f23,
                        limb1: 0xa48cc2c977b65663c8b9bcb6,
                        limb2: 0x14a9ed07232efcdc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8e305783d377c71e4f2c65cf,
                        limb1: 0x644c4b418a8a765dc4ff9010,
                        limb2: 0x13007725fb52dd24,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5084f2be8e02844c64d14eca,
                        limb1: 0x942a4f1e84babf96f932e96f,
                        limb2: 0x6a73478d723677b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe50e5e320470c1519ea99381,
                        limb1: 0x2bfd243b7f459407f74aaf90,
                        limb2: 0x1256dfb34b1ae64e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfa67ca1dbb377f015e575470,
                        limb1: 0x8f619e72ce7936e06faf4595,
                        limb2: 0x1b60d344801f66e8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9fdc2f13c1d72b9bc0ced27a,
                        limb1: 0x1222c3262674c047841c47cb,
                        limb2: 0x15f0f7b57fe1f9b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x586efd7b0ee7bd12e92f856b,
                        limb1: 0x19b80a9e7b3184825af36202,
                        limb2: 0x234967cb57696280,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1bf4dfbe24aae54e980f4d68,
                        limb1: 0x39161a15c21266ea9c52df43,
                        limb2: 0x2f1370df8a086d46,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa7a7a862134e67b40a885917,
                        limb1: 0x56f445ba65d7c0cd6ad5c798,
                        limb2: 0x11c64bd6e07968c2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbd8de30071aaa143c12554d5,
                        limb1: 0xa80fa261d0050d84bae7d229,
                        limb2: 0x68b944a2df2140a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9362af65372af80e9ad538a,
                        limb1: 0x16c54fc05b7e70c1d36aa5cd,
                        limb2: 0x11a2259d06557a0c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfa525745f06b7c814d223ba3,
                        limb1: 0x51af74f6df1603ac69c9c776,
                        limb2: 0x25da23922ac82f4a,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xc67504fbbc340097b8394cf5,
                        limb1: 0x82aee884d20cfd395f7af1ac,
                        limb2: 0x1a49ea3de57fb294,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc895e2ab6e6665334d105f5e,
                        limb1: 0x99dc7780d758adaaed4b0e20,
                        limb2: 0xad16d8b5f039ed5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xce951c84a2c59c31fca68bfa,
                        limb1: 0x2d511a61b60939228c26beb0,
                        limb2: 0x235d0cb882b94b61,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeaa671d78704e16def64c8e6,
                        limb1: 0x4caf023bd4433ed509ac332e,
                        limb2: 0x173cef661af54813,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xce0fb29033f877a30f174fa9,
                        limb1: 0x25a166893914f754bbb29187,
                        limb2: 0xed6178bf1f72e22,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcbc4cefacfddca564fceb291,
                        limb1: 0x1e0962b94fd4a677767fc12,
                        limb2: 0x121a7d5b6f82f037,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1781ad0688c7abe6f53f5ed4,
                        limb1: 0x4ad9e5cc07995f8f31347398,
                        limb2: 0x4a10e95763dd144,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc93abaee99a61f53b85112d,
                        limb1: 0xde86e5d2eb5352af5c27fed1,
                        limb2: 0x2ef07047b13225e0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc6bfcd138d3b44e28bd49711,
                        limb1: 0xb68f5efcd724352b0b8bf79f,
                        limb2: 0x8b7ed7562c96d56,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x69fd548b8bd52650431e3525,
                        limb1: 0x778815b21c7340ee9d54870f,
                        limb2: 0x56816cfeac1235f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf45da46dd47f1587bdaedb08,
                        limb1: 0x55df8ab732c7dba27f8f2a6,
                        limb2: 0x18ff64bee85b2ed9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2d90893ad2cbaaccbe7c1937,
                        limb1: 0x2704fa7348ea70ad392191d8,
                        limb2: 0x8448f6d3cbc7cdb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5c427025e72f64a5cecb9cbd,
                        limb1: 0xe809cf5486134c1f896c919,
                        limb2: 0x29921854df4f78fc,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xea677ad22602654bd48b2083,
                        limb1: 0x591e17981959d4ea70a3051e,
                        limb2: 0x277621d45ad9bd17,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3541d037da592cb0633c4b3f,
                        limb1: 0x40ccfa7849b39ce2462f0ef6,
                        limb2: 0x18faa270f504c52e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x94a88588ce0bcb9a7a644a05,
                        limb1: 0xaf1ab0ae1aa5f256f574e034,
                        limb2: 0x1b1729055acaeb25,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x79c52bf10ea2d64010a5cffc,
                        limb1: 0x2cc7d14b334eb968cdb6850f,
                        limb2: 0xefb17a093402b71,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1b64204962a2c40e048e30f4,
                        limb1: 0xa6581c0cca342943faef6737,
                        limb2: 0x1e8e08fa23f54b24,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x29decb7c8572ce95c5687778,
                        limb1: 0xe4fdc9cd2401c4f10fa8c1e1,
                        limb2: 0x2db960118d650536,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd0642ba0896dcd947311f140,
                        limb1: 0xe36aa96d903c1475d7db5fbb,
                        limb2: 0x1efa122f9661807,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7687868fa8dcf2291421e3c5,
                        limb1: 0x708cdfe67eb3f9699b3b53d5,
                        limb2: 0x36a2f93d58844b4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x643ade0618ff65144dd23f21,
                        limb1: 0xaa0b6a69961737aca0cabf27,
                        limb2: 0x282f14bd7b1d67d2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe97b347a6716edb68e66c0fd,
                        limb1: 0xc94fee89438058bc8ad4b344,
                        limb2: 0x1fa74a628d5542ab,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfb7cc2a57271d736931f9232,
                        limb1: 0x8c03d59b0b05ad7a4cab268a,
                        limb2: 0x203801a8f7c8cf12,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc19f9febb60658d15d1346ea,
                        limb1: 0x2120b309d4784764147de5f4,
                        limb2: 0x217855d177178011,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x89ef90aa0c60b3a26ee5fda8,
                        limb1: 0x3112808b52d0db2c57b9b936,
                        limb2: 0x2f8fce05510a7670,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xea275cd9804fe2004fbca2c0,
                        limb1: 0x736dd7b9ee248045aab98c3a,
                        limb2: 0x23ea925a5a65e2a7,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xeaed4465f87b75b0502ee998,
                        limb1: 0xcfbc73d7f4a59f4e86ef6a74,
                        limb2: 0x1e797046cf4d7793,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x59c1a8024b332f99e7311e1a,
                        limb1: 0xcd956682860a0900c7e12a62,
                        limb2: 0x207448a21d0adc80,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9adbc073700fbc6844f9a960,
                        limb1: 0x1752c3b81f18faac757166ef,
                        limb2: 0x94e8943c5c8a1d0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1df68ff5152218caadeaaa60,
                        limb1: 0xb06ba981cd55615ae4fe20a8,
                        limb2: 0x2f9c69fd552deaa4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xca532fcece2f4005a1d95112,
                        limb1: 0x5270656601163b4b88e15826,
                        limb2: 0x6ef65bc53b78912,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc971bee7d63e6f1e1395a666,
                        limb1: 0x7aa2972df37fbffb5add4857,
                        limb2: 0x29483657f0107bdc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x312b78eb215be522cf22e562,
                        limb1: 0x2d3cb39feb0f5d829d498df7,
                        limb2: 0x25201b267daebbe0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xba7555f53c65f93e382f8b5b,
                        limb1: 0x984546de768ae64a09a64e46,
                        limb2: 0xa7a7d0a61f8bf47,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x20043635778f98fdf34c77c4,
                        limb1: 0x258eb3221a69e9e89a0be2f2,
                        limb2: 0x2c4245bb97df383b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5579aaa92c471ed7be99fe43,
                        limb1: 0xb17226e25cf3225b093208c6,
                        limb2: 0x14d9530536813b62,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x18c903ddeed68a5ec397a7b7,
                        limb1: 0x7e00446841d61b22a51001a3,
                        limb2: 0x1926019ea7e07218,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4f7168c4059e4548c748e2b6,
                        limb1: 0x2b9e4e56b1e38732b6f0ad28,
                        limb2: 0x21859bbd18fee3e8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xade10fe2c9223c13fe8710ce,
                        limb1: 0x32696124f2942e7958160d38,
                        limb2: 0x2155c2e8c64c4e00,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf45da46dd47f1587bdaedb0b,
                        limb1: 0x55df8ab732c7dba27f8f2a6,
                        limb2: 0x18ff64bee85b2ed9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2d90893ad2cbaaccbe7c1937,
                        limb1: 0x2704fa7348ea70ad392191d8,
                        limb2: 0x8448f6d3cbc7cdb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5c427025e72f64a5cecb9cbd,
                        limb1: 0xe809cf5486134c1f896c919,
                        limb2: 0x29921854df4f78fc,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x792dbdaa2d584aeb48b437da,
                limb1: 0xaa1be30232f57c8193dd2601,
                limb2: 0x678e6a64c106c81,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x970b349c842cb2ed5fa2f223,
                    limb1: 0x49dee76f6d6e741377b89f6b,
                    limb2: 0x261ef0ed6077e5e,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x24bbac76118942d6a70c05c2,
                    limb1: 0xb6e3c2bf241f9a2ed272a053,
                    limb2: 0x13ababe6aaee6ea8,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x772ca79c580e121ca148fe75,
                    limb1: 0xce2f55e418ca01b3d6d1014b,
                    limb2: 0x2884b1dc4e84e30f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x536c985db33c69f7c242e07a,
                    limb1: 0xfc531bccffafcf1e59d91fb9,
                    limb2: 0x2585e4f8a31664cb,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x57fa42444057cf0c1d62ae3c,
                    limb1: 0x4f48d341183118d68ea41313,
                    limb2: 0x1d2d2799db056ed1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x236ca9312dad3661a37f2d6f,
                    limb1: 0x98424c01caad7592315715d1,
                    limb2: 0x795b9fd941b23c4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc7ab5834609a54b8993ffd79,
                    limb1: 0xe81cd490528b814ca632aace,
                    limb2: 0x2d9ff53d3009e6f7,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x163df40cafbf585ca5b2ab44,
                    limb1: 0xb4752e4666c88dbbe23783a0,
                    limb2: 0x1a801462ac9cb657,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xac9b557d7ca8625d957263c6,
                    limb1: 0xdc6f75fa8339a78b998ae54a,
                    limb2: 0x28683293b6494d9f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5c4f5dca0c973b7f70bfff9,
                    limb1: 0x188c2afab11eef5d48ecda3c,
                    limb2: 0xc2fed35d36c49f1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9d7244ea10697ca42e2e066b,
                    limb1: 0xfe18a519c7d68770dc48dbf9,
                    limb2: 0x149bb528db998529,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xffc057151b06c496e6fdd440,
                    limb1: 0x5a01bae0c7441f08c7af1cf9,
                    limb2: 0x274e0e02529e6d26,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x65ceb8977413bc9798681ecb,
                    limb1: 0x19ffb287b45234f0c28fd1a7,
                    limb2: 0x28dbbd2f9267be76,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcfcdbfdb2056ff1a64bf1d47,
                    limb1: 0xf26fe2dae9f693d9b4aab2e6,
                    limb2: 0x12d66ad4802d841e,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe6e34ebfa2e18dce86cadbdc,
                    limb1: 0x7ce096238b3d4b1b8fba6a55,
                    limb2: 0x2e0a660b1549800c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd2dd03b29d58d045656ecf33,
                    limb1: 0xeddac3cf7a123aae2180739b,
                    limb2: 0x215bec6e0a03c924,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe5201e51828eb11589d8619f,
                    limb1: 0xa6563c760aa3a2c9d15af235,
                    limb2: 0x7ed0c9b2e7811fb,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xc33ac21c67b06a9994457b4c,
                    limb1: 0xa9aa5573bf7a92aab85366eb,
                    limb2: 0x1a407281e1d92e91,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5a306649d971b115d71a78b1,
                    limb1: 0xa70687a9b5132e26b2cfbb37,
                    limb2: 0x2031920af5d6c9db,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x58a3cea1103f16402eb74c08,
                    limb1: 0xdfefcd91df2f4295ec21e03a,
                    limb2: 0x1150bcc09ac40007,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x57ed7d356f91abcef751889f,
                    limb1: 0x5c668cded3599c9af5a7e5fa,
                    limb2: 0x2ccf74197cb9bc13,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x529118e291927516dfbcba2d,
                    limb1: 0x440af959472c61e99aac7977,
                    limb2: 0x218bbc79509b59ce,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x226044f7331ccf82af7afb39,
                    limb1: 0xc1953da25a89d084dcfaea76,
                    limb2: 0x1042fdc36b43dac3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x154bc8ce8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x2305d1699a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x144a7edf6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x21c38572fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0x2b70369e16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x522c9d6d7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0xdc5dba1d977e9933c49d76fcfc6e625,
            },
            u256 {
                low: 0xd344749096fd35d0adf20806e5214606, high: 0x119d0dd09466e4726b5f5241f323ca74,
            },
            u256 {
                low: 0x5306f3f5151665705b7c709acb175a5a, high: 0x2592a1c37c879b741d878f9f9cdf5a86,
            },
            u256 {
                low: 0x30bcab0ed857010255d44936a1515607, high: 0x1158af9fbb42e0b20426465e3e37952d,
            },
            u256 {
                low: 0x5f3f563838701a14b490b6081dfc8352, high: 0x1b45bb86552116dd2ba4b180cb69ca38,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x5c3a06447a0996b0a92f9931,
                    limb1: 0xbe6a2eedc8ef87e71e9ec66f,
                    limb2: 0x226eea38486e086b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc880fabdc7f0d4cc409b1a40,
                    limb1: 0x14008cf49435dbd34779e8,
                    limb2: 0x2fd9b0fb62c9320e,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_1P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x64c9ef86686ed7cb0fa42251,
                limb1: 0x17c282e8624e1788ff8fbc5b,
                limb2: 0x712b5be5bb66eb8f72af3c9c,
                limb3: 0xc182b0f0e8d6cf017feeb4d,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x5c35d2ca01541a34fb66d844,
                    limb1: 0xda7b85c12db291e5c2c802b2,
                    limb2: 0x5987ec0b8e681de8e6dd0e3c,
                    limb3: 0x1d4ef28e7e9c0cae8144b52,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_2P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xa9125be5f17f34ce6de5896b,
                limb1: 0x77ff67ddaf6b61c4088ee57a,
                limb2: 0xb4940789dbaf29c60e3ae417,
                limb3: 0xbab38248ecf0eb99f06ac59,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xe4f817e54aede0613c17035c,
                    limb1: 0xdff1f15010392a6da1f95a6,
                    limb2: 0xbed78d3d341e911d49f15454,
                    limb3: 0x18154782ce0913b21588066d,
                },
                y: u384 {
                    limb0: 0x3d77d61326ef5a9a5a681757,
                    limb1: 0xd3070afd4f0e121de7fcee60,
                    limb2: 0xdf9ef4088763fe611fb85858,
                    limb3: 0x11a612bdd0bc09562856a70,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x12cfa194e6f4590b9a164106cf6a659e,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_3P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xf6a31a9a41fd0378150dc360,
                    limb1: 0x7a355df87079a4cf4c78fd36,
                    limb2: 0xbd92b81f9f87a14ded17256e,
                    limb3: 0x1259b26908470ad4f6be037c,
                },
                y: u384 {
                    limb0: 0xfbe2abbd7e05b561703438fe,
                    limb1: 0x892d1cc404bcc0c000d206cf,
                    limb2: 0x962b60138682dd48428b2a8d,
                    limb3: 0xa68b20ba71d8fde199d485b,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x7c866be61fbaed5ef7d1122e,
                    limb1: 0x7fed89acb87ce49d38175a6f,
                    limb2: 0x30dbb6ee5876fa6873045668,
                    limb3: 0x60c4285948cc11859881060,
                },
                y: u384 {
                    limb0: 0x5a931aaa036da6ee08c49738,
                    limb1: 0x1c92b3a560ce474174cfa275,
                    limb2: 0xa4f783dad6c9da34040c6553,
                    limb3: 0x8d9752128e5b2be6254e2b,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x663acbe46ab1edf9e0302ddb,
                    limb1: 0x133eafb6b82660d39354a91b,
                    limb2: 0xec9146f8b18f4ccfa8f938e,
                    limb3: 0x1127139158d2558af3ede6c1,
                },
                y: u384 {
                    limb0: 0x2e2dc7b89be127d3eee7e15f,
                    limb1: 0xb9b688b1096640c721587415,
                    limb2: 0xd09f1d870e1c2d4e08674d2b,
                    limb3: 0x12308a0685f2c08876496459,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xeb35755831b8b274a72187ca,
                        limb1: 0x619d73fdc8ca106f251bb23f,
                        limb2: 0x83526e9a98267e300003744c,
                        limb3: 0x74e843f7fd9b3c1eb4f8a71,
                    },
                    u384 {
                        limb0: 0x263294ccc2a97ffb2ec76a8e,
                        limb1: 0xd158f356f93267263354d7e2,
                        limb2: 0x714889219b424296b85139b5,
                        limb3: 0xa8f3019b0a505d2ffd1caac,
                    },
                    u384 {
                        limb0: 0xbf917add7208b045d906ff3f,
                        limb1: 0xcd23d9673211a97506787efc,
                        limb2: 0x7179e6dc54430c65b26530b3,
                        limb3: 0x17bb9453c160e11d98066ff9,
                    },
                    u384 {
                        limb0: 0xebd56ed5f538ae24aa8dc0e2,
                        limb1: 0x3ba413917f065ec7e45c2721,
                        limb2: 0xa9b1360228e4503e35364d2b,
                        limb3: 0x1301d2f14e9626ee2309422,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x9b4aac8938de0d6d29299aec,
                        limb1: 0xed00b7c2b8d648ca0d5cb5bc,
                        limb2: 0xa052f33dafe080f320f1ff8e,
                        limb3: 0xa83d431853448de44c440fa,
                    },
                    u384 {
                        limb0: 0xc5a014c4a628fb418afdc431,
                        limb1: 0xff1bc5487dcfd4fac800f591,
                        limb2: 0xf09802d0f98c9a1e7d8b3326,
                        limb3: 0x125f173ee992bebf294f042f,
                    },
                    u384 {
                        limb0: 0xb9100f1617268243b95b9208,
                        limb1: 0xb1f5e20e709d1d7cf3b2d087,
                        limb2: 0x39c86f0b79ca465e49a95325,
                        limb3: 0x1269c9e792e7575a1b407349,
                    },
                    u384 {
                        limb0: 0x2cb2b76ffc0a57eef2f100c5,
                        limb1: 0x8c7ae8ef5688c4968d0ade85,
                        limb2: 0xf0719994ff5b34265dca49d0,
                        limb3: 0x141860f0e8a032121ffd28c2,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xda7bc5a089fc35de52b5ab6d,
                        limb1: 0x374d31abeda2bc7d1fa3314b,
                        limb2: 0xdc9b575368802cb064ea215d,
                        limb3: 0x586829f9bf69e05abd324e6,
                    },
                    u384 {
                        limb0: 0xdf7cbeaa6d31e6304e21b449,
                        limb1: 0x98191ab75477b88d9100a3b0,
                        limb2: 0xaccec7142afafc55a16d5a5d,
                        limb3: 0x2145b524c0790e06e301e66,
                    },
                    u384 {
                        limb0: 0xc03bb07a666edb299db815a6,
                        limb1: 0xfc9f8e6a16f220fde529492c,
                        limb2: 0xa907065eb5bf6b0eb40cf236,
                        limb3: 0x1149cca478baba09dee1d533,
                    },
                    u384 {
                        limb0: 0x8e5d1fd64b21b819208b11ea,
                        limb1: 0x66e777b31da1abe09cc24423,
                        limb2: 0x426e7a0bf850c1501a08cee7,
                        limb3: 0x7dbacd73a097db82eaceab9,
                    },
                    u384 {
                        limb0: 0x7b6589cb116ffb6c5cd73707,
                        limb1: 0xa62d2451aecbbdb4a8c8ed99,
                        limb2: 0xca0de292aeae27f922326d89,
                        limb3: 0xd8a62ad9db2e6794979a947,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xbbd6b225297935b4a4a6c105,
                        limb1: 0x4cd20c69eca82d0416c6d6f3,
                        limb2: 0x3e00201f5b0ab8479042eb7c,
                        limb3: 0x100e3edbdb513cdec7f55c34,
                    },
                    u384 {
                        limb0: 0xb3d8531324a5ed062bf7bb6e,
                        limb1: 0x2e0d6fe009dd67a2e2abd649,
                        limb2: 0x3bc8b1951d43d1700f22a71d,
                        limb3: 0x157a3927334b2dc80f04c153,
                    },
                    u384 {
                        limb0: 0x81983c58e89c090ee56ef2ca,
                        limb1: 0xf975e2f7d51289ab91734221,
                        limb2: 0x608a627f1e3a826f3f9b2717,
                        limb3: 0x15a503c9d89d9033d6ca7db8,
                    },
                    u384 {
                        limb0: 0x3a198a49fb0a6d28f4ee9dff,
                        limb1: 0xe959e39d2ee678b7e5842fd5,
                        limb2: 0x9836530b7fe76efdbd8bee92,
                        limb3: 0xce222367b355d57e365ece3,
                    },
                    u384 {
                        limb0: 0xc5a014c4a628fb418afdc435,
                        limb1: 0xff1bc5487dcfd4fac800f591,
                        limb2: 0xf09802d0f98c9a1e7d8b3326,
                        limb3: 0x125f173ee992bebf294f042f,
                    },
                    u384 {
                        limb0: 0xb9100f1617268243b95b9208,
                        limb1: 0xb1f5e20e709d1d7cf3b2d087,
                        limb2: 0x39c86f0b79ca465e49a95325,
                        limb3: 0x1269c9e792e7575a1b407349,
                    },
                    u384 {
                        limb0: 0x2cb2b76ffc0a57eef2f100c5,
                        limb1: 0x8c7ae8ef5688c4968d0ade85,
                        limb2: 0xf0719994ff5b34265dca49d0,
                        limb3: 0x141860f0e8a032121ffd28c2,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xdd789d7c02428dc60246d081,
                limb1: 0xc9de1388dd3a5eaff5de8784,
                limb2: 0x6eac6c37a0a90e65dd33fbc8,
                limb3: 0x89f38f13155da73ef366afc,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xe4f817e54aede0613c17035c,
                    limb1: 0xdff1f15010392a6da1f95a6,
                    limb2: 0xbed78d3d341e911d49f15454,
                    limb3: 0x18154782ce0913b21588066d,
                },
                y: u384 {
                    limb0: 0x3d77d61326ef5a9a5a681757,
                    limb1: 0xd3070afd4f0e121de7fcee60,
                    limb2: 0xdf9ef4088763fe611fb85858,
                    limb3: 0x11a612bdd0bc09562856a70,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xde4f62a6588c9401ffefbd3,
                    limb1: 0x9bb5f797ac6d3395b71420b5,
                    limb2: 0xdc39e973aaf31de52219df08,
                    limb3: 0x105dcc4dce3960447d21d3c1,
                },
                y: u384 {
                    limb0: 0xaefd0d854043fd325dd3c34f,
                    limb1: 0x9b63c98d9a7845c52e1e2b0f,
                    limb2: 0x9db0be660d847ccc58358f3f,
                    limb3: 0x17cb6c41f0c4e1a7394ab62a,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0x2a43e70faf19922ad9b8a714e61a441c,
            },
            u256 {
                low: 0x5a92118719c78df48f4ff31e78de5857, high: 0x51f964df9c6316b950f244556f25e2a2,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x2b828af1f5fe30bbe7a1074a,
                    limb1: 0x5669beaa69827b52dc874c9f,
                    limb2: 0x648af2c24d82a5a758c96b8e,
                    limb3: 0x188bc245620ae6b6afec9dc3,
                },
                y: u384 {
                    limb0: 0xdc96192f803ef92f56d59758,
                    limb1: 0xfc6139925c05a030065d564,
                    limb2: 0xb24447300bec56efec94dcf4,
                    limb3: 0x156f97e5d31055c0a5fe154d,
                },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_4P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xcf5bc4cf513273a64b43540a,
                    limb1: 0x6613974b3587de6a0421a52b,
                    limb2: 0x9f11261324f0125289a51c4,
                    limb3: 0x90308470b416ca1aff0c5e3,
                },
                y: u384 {
                    limb0: 0x3102ea48c94f20f4ccebc9c3,
                    limb1: 0x4d6ae4a26c0e0350d12814d5,
                    limb2: 0x2dc8ffb6c7db29c2dacd756a,
                    limb3: 0x9cf7dc9d86166897fb4c3ce,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x36952716073ad3a0784c804b,
                    limb1: 0x925ddef3c85fe6d3a513b55f,
                    limb2: 0xd670ae77446cb42ba15c358,
                    limb3: 0x1164ae8fe1dc44c74a1279b,
                },
                y: u384 {
                    limb0: 0x83e4d47d929ded88adf56ff5,
                    limb1: 0x45a6caccd5bc61c52fd977a9,
                    limb2: 0xf2c35142e28cb439cb9f42e8,
                    limb3: 0x6cdaf0c31bac5372c41228e,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x36feccbcf8718c917cc04cd3,
                    limb1: 0x4f3ced9cd8d2f9e58751adaa,
                    limb2: 0xcf671555118dadc2f708f1ca,
                    limb3: 0x8619de3ffa219bbdfc07acc,
                },
                y: u384 {
                    limb0: 0xfd78095a60ed4f6c2023e653,
                    limb1: 0x88a7c4412c34745f062cb8f1,
                    limb2: 0xdb50e0b5ab8899e15fcc908b,
                    limb3: 0x1419343e534a2c7643769e8,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x43a00827599bc871ec052095,
                        limb1: 0x907735b0474cdfbd9390d604,
                        limb2: 0x889b5bdff11ae2993129a716,
                        limb3: 0xe372a6f429fb24f3b9deae6,
                    },
                    u384 {
                        limb0: 0x385e6104753a95acfe139495,
                        limb1: 0x74df1cd8671d8327df93cf9d,
                        limb2: 0xb8ea1142bab645e5a990dd79,
                        limb3: 0x10d92f59780bc557b755a053,
                    },
                    u384 {
                        limb0: 0xcbc698aeb485594d43e567d6,
                        limb1: 0x2d57e9f6fbcb8f4153694dff,
                        limb2: 0xac5158e9565ce000c634ba2,
                        limb3: 0x5094f041c205f3c3695a85a,
                    },
                    u384 {
                        limb0: 0x137442d577c99ccf464870ef,
                        limb1: 0x3d642c3c20be1aa2050d3439,
                        limb2: 0x66bc485c48c8613ba550b4ee,
                        limb3: 0xfc9ce51a31ec61dbbed9c,
                    },
                    u384 {
                        limb0: 0xf614a35af5ed6b410a97ec33,
                        limb1: 0x4b36373d59ba1d3d2f8827a0,
                        limb2: 0xde4b3f4208f854c6bc31b7a5,
                        limb3: 0x131bb09f172cef7f4d2b7cc6,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xf6dbe3a230f7367f8b1c1175,
                        limb1: 0xe976f0f71a8893db76d1e666,
                        limb2: 0x2251d49fd76cf06a6c1aabb3,
                        limb3: 0xd613e96ca587c2c00940f68,
                    },
                    u384 {
                        limb0: 0x24ca88ca77f97fd047cebbb3,
                        limb1: 0xb66c98612e42f6fa469d0bc1,
                        limb2: 0x2670232bd6612190dfeccaab,
                        limb3: 0x6671fa691f30f885a88565,
                    },
                    u384 {
                        limb0: 0x1756c8bc75e505ea8da2c840,
                        limb1: 0xe618b0bbc9c0212e2504def9,
                        limb2: 0xad0ff64d30ce8b7794e76929,
                        limb3: 0x65627fb311b4ee0ef4193cd,
                    },
                    u384 {
                        limb0: 0x6ef0391091b40aa751cd4eb5,
                        limb1: 0x7eb32afdfc7d049ecceaaff4,
                        limb2: 0xa9151550836d48c1fcdb2ccb,
                        limb3: 0xea06515d280872e0099be8,
                    },
                    u384 {
                        limb0: 0xf9a13ba7c1034faf113dc74f,
                        limb1: 0xf2b60a48c371e81ba98f2cfb,
                        limb2: 0x5526884ac8d84a613fe36fee,
                        limb3: 0x19cd8432e0eb8098da1800cf,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xf2ba59c8a815789212473586,
                        limb1: 0x2f00a7dd448d61e14aa80546,
                        limb2: 0xc73c42a891ec77f7078b204d,
                        limb3: 0x1d295a821fff16e352f04b4,
                    },
                    u384 {
                        limb0: 0xfa8cb51c148d5c12fc38903,
                        limb1: 0x541e5cfea2be5d679100a7fd,
                        limb2: 0xbcdf8232793879015ff1c684,
                        limb3: 0x40ddbb67f91aeeb1a0c4ce6,
                    },
                    u384 {
                        limb0: 0x4db9d221ee5d02905ffb7c3c,
                        limb1: 0x3918238862bd821cd8b03e6e,
                        limb2: 0x518f477beb6d4ddd0132cb8b,
                        limb3: 0x18d4717988c33aeec3cab94,
                    },
                    u384 {
                        limb0: 0x711fed82af3085408e7e5de3,
                        limb1: 0x99c3707d8d890c7bf3f76631,
                        limb2: 0x12e60a5898f01f1d27fd876d,
                        limb3: 0x15b77932d15ecf8821a93f31,
                    },
                    u384 {
                        limb0: 0xf376ea6c76506fb9f0664910,
                        limb1: 0x18e015d09e84f43622496178,
                        limb2: 0x37325694d25fddfd0eba0973,
                        limb3: 0xc34b19dcf0d30d7fe62377a,
                    },
                    u384 {
                        limb0: 0x2c8dc32fe764b8a9d7c0f22c,
                        limb1: 0x8fe7965aee936a0f740951fd,
                        limb2: 0xd8131ec40b90a5939d46936a,
                        limb3: 0x53a1e0725ff676f66b2244,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x78c78e894fded9fe2c70f07e,
                        limb1: 0xd77a1e9a7cc063259def999e,
                        limb2: 0x2aff8d094c52a9fc9608950,
                        limb3: 0x182d686b662237b6c18ee34,
                    },
                    u384 {
                        limb0: 0x932a2329dfe5ff411f3aeecc,
                        limb1: 0xd9b26184b90bdbe91a742f04,
                        limb2: 0x99c08caf598486437fb32aae,
                        limb3: 0x199c7e9a47cc3e216a21594,
                    },
                    u384 {
                        limb0: 0x5d5b22f1d79417aa368b2100,
                        limb1: 0x9862c2ef270084b894137be4,
                        limb2: 0xb43fd934c33a2dde539da4a7,
                        limb3: 0x19589fecc46d3b83bd064f36,
                    },
                    u384 {
                        limb0: 0xb29cc7e477c7611cd2514c49,
                        limb1: 0xe4439cef0c7ca656aa7ca638,
                        limb2: 0xc6a629e1e52213725f875ee1,
                        limb3: 0x110957dc3ef89df780ba7f0a,
                    },
                    u384 {
                        limb0: 0xf753776a4e09be8c8cc6d8ee,
                        limb1: 0x4bb249a157f7b4fc90d5bfb4,
                        limb2: 0xb1273dd0cc5c688704eb5229,
                        limb3: 0x19994d07404d7f8d0cb5917f,
                    },
                    u384 {
                        limb0: 0x1756c8bc75e505ea8da2c844,
                        limb1: 0xe618b0bbc9c0212e2504def9,
                        limb2: 0xad0ff64d30ce8b7794e76929,
                        limb3: 0x65627fb311b4ee0ef4193cd,
                    },
                    u384 {
                        limb0: 0x6ef0391091b40aa751cd4eb5,
                        limb1: 0x7eb32afdfc7d049ecceaaff4,
                        limb2: 0xa9151550836d48c1fcdb2ccb,
                        limb3: 0xea06515d280872e0099be8,
                    },
                    u384 {
                        limb0: 0xf9a13ba7c1034faf113dc74f,
                        limb1: 0xf2b60a48c371e81ba98f2cfb,
                        limb2: 0x5526884ac8d84a613fe36fee,
                        limb3: 0x19cd8432e0eb8098da1800cf,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xa18a13bacab32867702ab75b,
                limb1: 0x795ac015c21f1cf4f8b9a159,
                limb2: 0x72bf60b2860e4052729bafb8,
                limb3: 0xfa167d77bd8f62e17dd612,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xa8c0f76621f85d0d5f09f3e4,
                    limb1: 0xa2d8a1fb70981bd906551e4f,
                    limb2: 0x2877f951cc18a5847f0e7c27,
                    limb3: 0xc32f38705bba10b41f82b8e,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xe4f817e54aede0613c17035c,
                    limb1: 0xdff1f15010392a6da1f95a6,
                    limb2: 0xbed78d3d341e911d49f15454,
                    limb3: 0x18154782ce0913b21588066d,
                },
                y: u384 {
                    limb0: 0x3d77d61326ef5a9a5a681757,
                    limb1: 0xd3070afd4f0e121de7fcee60,
                    limb2: 0xdf9ef4088763fe611fb85858,
                    limb3: 0x11a612bdd0bc09562856a70,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xde4f62a6588c9401ffefbd3,
                    limb1: 0x9bb5f797ac6d3395b71420b5,
                    limb2: 0xdc39e973aaf31de52219df08,
                    limb3: 0x105dcc4dce3960447d21d3c1,
                },
                y: u384 {
                    limb0: 0xaefd0d854043fd325dd3c34f,
                    limb1: 0x9b63c98d9a7845c52e1e2b0f,
                    limb2: 0x9db0be660d847ccc58358f3f,
                    limb3: 0x17cb6c41f0c4e1a7394ab62a,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcf86158ab69213388e721bb7,
                    limb1: 0x5f7812269d790797cad9aa15,
                    limb2: 0xb1c3622a0177001d9ed8e25f,
                    limb3: 0x115cf429f459884785c6ba46,
                },
                y: u384 {
                    limb0: 0x1e81341e2f3f988ff115dda3,
                    limb1: 0xad22946489db6ee4954fa5e1,
                    limb2: 0x83bed94412e19d92b73cc763,
                    limb3: 0x2074c7bceff87d0d41edba1,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x5a92118719c78df48f4ff31e78de5857, high: 0x51f964df9c6316b950f244556f25e2a2,
            },
            u256 {
                low: 0x8d723104f77383c13458a748e9bb17bc, high: 0x42bbb74ddd84f39e71545a137a1d5006,
            },
            u256 {
                low: 0xeb2083e6ce164dba0ff18e0242af9fc3, high: 0xbf0551e03983ca8ea7e9d498c778ea6,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x565ae56adf7b971b0ce04f43,
                    limb1: 0x7605de48d1513332bde03447,
                    limb2: 0x47735c7081fba830eb5d056,
                    limb3: 0x99dd8907656b77fed7fdbb9,
                },
                y: u384 {
                    limb0: 0x7e2426bdb634f1fc715d795c,
                    limb1: 0x3780edcc7f3bf5dbf54b578,
                    limb2: 0x973c69d9a9020e1f731e4837,
                    limb3: 0x114a8f415fb1d913dce9456a,
                },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_10P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x625c53bcdd3dedd0838beff1,
                    limb1: 0xcb07e15a10d4575bc015205c,
                    limb2: 0x2d427eeeb94d8dc9f8735c62,
                    limb3: 0x172bcbe199c9d8a12b9389c7,
                },
                y: u384 {
                    limb0: 0xeafcb601f648817e1959e01c,
                    limb1: 0x6bd0b06d7fd2c766caf6ec5b,
                    limb2: 0xe1bfd50ac038928b2571d10e,
                    limb3: 0x11d9e1ad8577f4db1ef6b668,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xedb9846df215a6a54b23692b,
                    limb1: 0x5f8b753d0b0f6a923b86bd3,
                    limb2: 0xf6b0c0878664ed75179fa99c,
                    limb3: 0x1172f8ba63ad84e04422505a,
                },
                y: u384 {
                    limb0: 0x79199cd6ac1258b0434b39ec,
                    limb1: 0x8d390ace52602684311b314,
                    limb2: 0x4e38c74bd0ff18deeac5f3b0,
                    limb3: 0xa3e7183ee7f841987aebb01,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x761b1eefd28e95ed15b39509,
                    limb1: 0xcb46c3daf5eb3a2666d9c59e,
                    limb2: 0xd5af01e7fbf829a132533307,
                    limb3: 0x1928ae276500d4c516350a1d,
                },
                y: u384 {
                    limb0: 0xa5a5bb48ca9892a49b6ac9fa,
                    limb1: 0x846dfec893cc4c8bdb0e834b,
                    limb2: 0x3bd7ed60d4c4f329754c8a4e,
                    limb3: 0x802baf75f1ba64c907b58be,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x8ab1cf70b5e29614ef9b84ca,
                        limb1: 0x3cd1a085277eac3827732f84,
                        limb2: 0x71346fb4a85ee6d0b4603a7d,
                        limb3: 0x16d0ea724e2ae2e53c73fe7d,
                    },
                    u384 {
                        limb0: 0x69d199dca01ef0118d1dcdf,
                        limb1: 0x3a4b1ca9c39babc0f5797ad4,
                        limb2: 0x69514497620d13e636dba78c,
                        limb3: 0x878dd33920dcdb0d599fc56,
                    },
                    u384 {
                        limb0: 0x201d6a04f8269990f37f7eb5,
                        limb1: 0xed85433dbaa9cb18881938ac,
                        limb2: 0xfdb55248f94f601f2f101af7,
                        limb3: 0x191b3586c4b8f4b9734b0aa5,
                    },
                    u384 {
                        limb0: 0x1996b6a634b398f3758c43dd,
                        limb1: 0x64cfe52d2bcc5ed53ccf19e0,
                        limb2: 0x624a49f44a0e0591d3978fbd,
                        limb3: 0xdf6528087b815a43c82248,
                    },
                    u384 {
                        limb0: 0x172bd1b76a05538a6e252432,
                        limb1: 0x47138bff2a3e8807923d0664,
                        limb2: 0x771f433dda70518e0e798c91,
                        limb3: 0x171b0203a2fcc50e74654c54,
                    },
                    u384 {
                        limb0: 0xbb519c77ca4671e47f3cb302,
                        limb1: 0x613337c9ff525866bd0fc521,
                        limb2: 0x46e48af3a92946d00eca0700,
                        limb3: 0xf33efe3eec79a0edc8bc9eb,
                    },
                    u384 {
                        limb0: 0xa9a0094345f13c9387f2fa64,
                        limb1: 0x4bc863850d2bc539c734914c,
                        limb2: 0xd845cd5c81f19abc1932c4a7,
                        limb3: 0x19691e5d70a8f9796d7c2256,
                    },
                    u384 {
                        limb0: 0x22e425a247e7621705b1f68a,
                        limb1: 0xc7ba16ba72f2b3623eff2cde,
                        limb2: 0xf373d63621a96d47fe26d943,
                        limb3: 0x184ac35f8d8518289e158911,
                    },
                    u384 {
                        limb0: 0x9e0c7385c2f6fb0e8fcf5550,
                        limb1: 0x620b7502f7aa1ccb5df6d9cb,
                        limb2: 0x60b3001bf5178198f73304ef,
                        limb3: 0x139b6612cf08581fc98293bc,
                    },
                    u384 {
                        limb0: 0xebc1f38e0dfe03419a64637b,
                        limb1: 0x30ee469cba4e02a0c46d24f2,
                        limb2: 0xf316d00c2a85a4b30e1d0cb9,
                        limb3: 0x8a60743c4a10f659bae5ed6,
                    },
                    u384 {
                        limb0: 0x81ffbf396e187da10cb114f2,
                        limb1: 0xa692b8772574cb0de39ac128,
                        limb2: 0xe509f2f1c05665c720e81c29,
                        limb3: 0x3fea10d9e17e73241990525,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xd186dcd427ebe6f00297a15a,
                        limb1: 0x27fb9c2c9a28eae521f7af75,
                        limb2: 0x63f0ee96d7340dc10924a1a3,
                        limb3: 0x160ea91d1d7cefa621595a77,
                    },
                    u384 {
                        limb0: 0xeefe8b2b9b14ff5baa85b499,
                        limb1: 0x93fa6ad7f7c2610447e933f5,
                        limb2: 0x164ad6925c851087fa40b287,
                        limb3: 0x5d7c13c5ba5e89674056428,
                    },
                    u384 {
                        limb0: 0x96c452392a0704f66b616b91,
                        limb1: 0xf8abbd34e634b6d471658a51,
                        limb2: 0xffa725a34255fd860665add1,
                        limb3: 0x1620cfcd602bd62512f59cee,
                    },
                    u384 {
                        limb0: 0x3a4e8d0b919aac9a857a14b3,
                        limb1: 0xc6e0b44f8fff20ed3843ed53,
                        limb2: 0x9724c5b64f35f2299a19c522,
                        limb3: 0x97a2a53bd9ae392c8522e0b,
                    },
                    u384 {
                        limb0: 0xe5bfbd8b17b1d62eb1202094,
                        limb1: 0x51f1a48e0a485cbb4e911b42,
                        limb2: 0x13349ddace1ae9924a83d07c,
                        limb3: 0x143b26dc1731e7fa75f76e48,
                    },
                    u384 {
                        limb0: 0xfb34269230379fc03a9dcb56,
                        limb1: 0x6d3408de9ea4ff4ae2a34539,
                        limb2: 0x1c6707f081e5d0f9953ded2b,
                        limb3: 0xb1e600bdb7f72ca91777301,
                    },
                    u384 {
                        limb0: 0x9c21d885fa8c568659065b24,
                        limb1: 0xd0e1b8bfb0cbec3a483a5c96,
                        limb2: 0x9dc95e7cb3a9a161ddbeb53a,
                        limb3: 0x68e1798fe700920f6f5ef04,
                    },
                    u384 {
                        limb0: 0x160706cd5dbe4f2db69bf1c0,
                        limb1: 0x672c16258eda4f3836b14bef,
                        limb2: 0x170d05309f7bf9c526847711,
                        limb3: 0x14acc91d9913de2bcaff15a,
                    },
                    u384 {
                        limb0: 0x94f7676badbe63cf9305494a,
                        limb1: 0xfb574eb82a38560aafcf445a,
                        limb2: 0xfb0ac03457d113c9bdefc8fc,
                        limb3: 0x1434ccd56b75015e32c82e4,
                    },
                    u384 {
                        limb0: 0xf1c6e9211b48344f132d339,
                        limb1: 0xf97aeccb5581c7cb73cdcb0d,
                        limb2: 0x69976546f0460586790971c,
                        limb3: 0x6005db9e2f7924e4987641c,
                    },
                    u384 {
                        limb0: 0x295648946a104c338d1f612,
                        limb1: 0x452ceae1e36e06147f21f551,
                        limb2: 0x85604960283cf1286d4c90e,
                        limb3: 0x15c367b8cdb02274df9b23a4,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xa7da4c70a1b9f31d169dec38,
                        limb1: 0xda917ca73530c04e211d9ca3,
                        limb2: 0x2b02374392fe2d98fb0e78fe,
                        limb3: 0xb7a58eac59d9da9671140e2,
                    },
                    u384 {
                        limb0: 0x84b22c5af9a9e3e157ccae50,
                        limb1: 0x12895c43cc8b3d54c4bc8165,
                        limb2: 0x3c35dc714160a33ed6609440,
                        limb3: 0x11fa82e6d6f20786ac9dad1,
                    },
                    u384 {
                        limb0: 0xecea39c95e382b53560f7fa1,
                        limb1: 0x756729d4ab92391969340ac2,
                        limb2: 0xe74182fd817492bbf2dcf0c3,
                        limb3: 0xdbef1f88d401500673a12db,
                    },
                    u384 {
                        limb0: 0x3ca989a7b56b2c7f75a4d9bb,
                        limb1: 0xb02cf9ec98af1017311331d,
                        limb2: 0xeb59530380f1a63e621f498c,
                        limb3: 0x92ce7be9bd021b8717378f2,
                    },
                    u384 {
                        limb0: 0xadce7fed71c794347fae057e,
                        limb1: 0x571cd70fd4b7e21376053d8c,
                        limb2: 0x2d7bd027a3760fa4f8196066,
                        limb3: 0x54c03b338ee928dae63fba4,
                    },
                    u384 {
                        limb0: 0xddadc8e7d517eb12fa85aa1b,
                        limb1: 0x1cf051aff9ff7acc545847e7,
                        limb2: 0xe1a530a0d04e7b50337ddc66,
                        limb3: 0x1506607336c0e2cf0c9b323e,
                    },
                    u384 {
                        limb0: 0xb8386ed7968db3e348aa451e,
                        limb1: 0xbeaf14353dad9f07bcf8f066,
                        limb2: 0x5fd1d550543702fbf4940b3a,
                        limb3: 0x248fcce7d952c72b4f7c2d2,
                    },
                    u384 {
                        limb0: 0x766876e1358bcc5655504501,
                        limb1: 0x93f0ba80107a39792bc32769,
                        limb2: 0x263a7a1e7dba4b5c2821f315,
                        limb3: 0x16593ad95a3a398271ee58e8,
                    },
                    u384 {
                        limb0: 0xd9611049bdb20dc7a273a9c9,
                        limb1: 0x25bd15916eb3ebf61ce88ffd,
                        limb2: 0x6a08fff8bbff6b1af40cf8c4,
                        limb3: 0x145841a44f8eb6456ce7efd7,
                    },
                    u384 {
                        limb0: 0x156c8fe29205764463145cd5,
                        limb1: 0x50eed5270a5ffc8ea0a43307,
                        limb2: 0x257d95b1ffdba8b09f116af6,
                        limb3: 0x67bb7f215c7fe4b2d9d8c7e,
                    },
                    u384 {
                        limb0: 0x1b53ecca59368e3873fec13c,
                        limb1: 0xc5e7a5240562018fc56aa4f0,
                        limb2: 0xa713556ec8f3a00460ef75ec,
                        limb3: 0xe0aba43427f653ba472cea1,
                    },
                    u384 {
                        limb0: 0x94e9adbdaa2a84e894a2281b,
                        limb1: 0xe9458eaa3dc58d3838ee6ba2,
                        limb2: 0x62ca42f023be5c9421f3a0b8,
                        limb3: 0x17991ca4164d969b413e7747,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x321f735171b29bc00a5f8567,
                        limb1: 0x6a5bf8cf8490c9282bdabddb,
                        limb2: 0xc5e0b3d52f6a54754a034e4e,
                        limb3: 0xa376eb5c9740ac9a41272ba,
                    },
                    u384 {
                        limb0: 0xbbfa2cae6c53fd6eaa16d264,
                        limb1: 0x4fe9ab5fdf0984111fa4cfd7,
                        limb2: 0x592b5a497214421fe902ca1e,
                        limb3: 0x175f04f16e97a259d01590a0,
                    },
                    u384 {
                        limb0: 0x471548e57a1f13d9ad86ae43,
                        limb1: 0xad1c7cf0b4bff8e56992294a,
                        limb2: 0x34b99006dbf213893f077f09,
                        limb3: 0xa800976d42fa4c56a837c99,
                    },
                    u384 {
                        limb0: 0x58191102fa58995a18809ed0,
                        limb1: 0x751cc828ecc38251c5af64c5,
                        limb2: 0x39ecabc14b1d3f5d8a8190af,
                        limb3: 0x7f52e97a0e8b0bcac6ac339,
                    },
                    u384 {
                        limb0: 0x72018158cbdf58166f0736e8,
                        limb1: 0xa62e852d3cd0f1852629a105,
                        limb2: 0x993a4777678ad44249c0bc3a,
                        limb3: 0x8c126ee0bedd4b16a902625,
                    },
                    u384 {
                        limb0: 0x20ecec8276e783f755d94393,
                        limb1: 0xdf1a3b6d7366c7b7be9a9f3c,
                        limb2: 0xeaabebb680feaa6274533d00,
                        limb3: 0xe982c285b29d41ac29c1986,
                    },
                    u384 {
                        limb0: 0xf981ef23c1cd06b3e993d698,
                        limb1: 0xa336c4ad5c7ddbb23a815fae,
                        limb2: 0xcafe92d1b9652c2c1d8f874e,
                        limb3: 0x9b176cd7ddb217c590e4267,
                    },
                    u384 {
                        limb0: 0x3ddbd8c08eab12e58b8fe794,
                        limb1: 0xeea1fd2445b1999c29564aff,
                        limb2: 0x6f68b29d4c0ad0a6e495acc1,
                        limb3: 0x196659237d76df8568b733b0,
                    },
                    u384 {
                        limb0: 0x4f11c440e7312efe86b2f07e,
                        limb1: 0x5a9143bf47865775a1e056a4,
                        limb2: 0x89208c1e12a20208cfd111f,
                        limb3: 0x102b9341365cb3221e297e95,
                    },
                    u384 {
                        limb0: 0x273f92ce875f639a1dd1fd5d,
                        limb1: 0x4f9c994c10221543f8c588cc,
                        limb2: 0x74e38af70b43d73e887bfeef,
                        limb3: 0x48e7c9650ce6bbfd1f7d7be,
                    },
                    u384 {
                        limb0: 0xc6098f34a45623a99e4ca07,
                        limb1: 0x464d49ca387f851dd7352137,
                        limb2: 0x6e8211027c2553806748630c,
                        limb3: 0xa5535b663d213e759c988c7,
                    },
                    u384 {
                        limb0: 0x94f7676badbe63cf9305494e,
                        limb1: 0xfb574eb82a38560aafcf445a,
                        limb2: 0xfb0ac03457d113c9bdefc8fc,
                        limb3: 0x1434ccd56b75015e32c82e4,
                    },
                    u384 {
                        limb0: 0xf1c6e9211b48344f132d339,
                        limb1: 0xf97aeccb5581c7cb73cdcb0d,
                        limb2: 0x69976546f0460586790971c,
                        limb3: 0x6005db9e2f7924e4987641c,
                    },
                    u384 {
                        limb0: 0x295648946a104c338d1f612,
                        limb1: 0x452ceae1e36e06147f21f551,
                        limb2: 0x85604960283cf1286d4c90e,
                        limb3: 0x15c367b8cdb02274df9b23a4,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x27301d1d2721a53329d1df5,
                limb1: 0x2467201387763c5c75a93064,
                limb2: 0xbb35ba06d1626d6fd0e984b,
                limb3: 0xabac5a5d470a027cad4fd71,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xe4f817e54aede0613c17035c,
                    limb1: 0xdff1f15010392a6da1f95a6,
                    limb2: 0xbed78d3d341e911d49f15454,
                    limb3: 0x18154782ce0913b21588066d,
                },
                y: u384 {
                    limb0: 0x3d77d61326ef5a9a5a681757,
                    limb1: 0xd3070afd4f0e121de7fcee60,
                    limb2: 0xdf9ef4088763fe611fb85858,
                    limb3: 0x11a612bdd0bc09562856a70,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xde4f62a6588c9401ffefbd3,
                    limb1: 0x9bb5f797ac6d3395b71420b5,
                    limb2: 0xdc39e973aaf31de52219df08,
                    limb3: 0x105dcc4dce3960447d21d3c1,
                },
                y: u384 {
                    limb0: 0xaefd0d854043fd325dd3c34f,
                    limb1: 0x9b63c98d9a7845c52e1e2b0f,
                    limb2: 0x9db0be660d847ccc58358f3f,
                    limb3: 0x17cb6c41f0c4e1a7394ab62a,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcf86158ab69213388e721bb7,
                    limb1: 0x5f7812269d790797cad9aa15,
                    limb2: 0xb1c3622a0177001d9ed8e25f,
                    limb3: 0x115cf429f459884785c6ba46,
                },
                y: u384 {
                    limb0: 0x1e81341e2f3f988ff115dda3,
                    limb1: 0xad22946489db6ee4954fa5e1,
                    limb2: 0x83bed94412e19d92b73cc763,
                    limb3: 0x2074c7bceff87d0d41edba1,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xe2955c55da59eba4b7b57d3d,
                    limb1: 0x1e6629b0431bce67cf28c22,
                    limb2: 0x1c35b7efd5b67f87221b8bfc,
                    limb3: 0x3e53df9e3488a9e42acd87e,
                },
                y: u384 {
                    limb0: 0x2e089afa726154d40dd12102,
                    limb1: 0x5391613ecf49db2bcf1cad86,
                    limb2: 0x84a2abb2de6b3a6e09026a50,
                    limb3: 0x19557a3a3c1d62a205d5dc87,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x490bf40774926e8b279947c,
                    limb1: 0xeabab6aef9e9d2a4f64f4e7d,
                    limb2: 0x3e309fe1b1c8247abab20d7e,
                    limb3: 0x79c527862917f69ac58fcc4,
                },
                y: u384 {
                    limb0: 0xacb18f2da2b425c2ff50dafd,
                    limb1: 0x7623850d87e279a8a30f31ff,
                    limb2: 0x777564c7291d95fa80203ade,
                    limb3: 0x1764ce0e7fb626109b63789b,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x42f2f3f4f6b9d2c2b73a361f,
                    limb1: 0xcd78c070c184c38b1e5716aa,
                    limb2: 0x72cbc24cd90da89e0e3cefe4,
                    limb3: 0x19485e1c46d0dce75f8b192b,
                },
                y: u384 {
                    limb0: 0xb56b3539074b3c47b3f504d9,
                    limb1: 0x2c229530bddedd8851b03dcc,
                    limb2: 0xc93eef8474c4e18d6378e7f0,
                    limb3: 0x173d36f17a3c9ae77a2acc25,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5fbf29cf20556a11621a6639,
                    limb1: 0xdfda5b7dbf0b226822094787,
                    limb2: 0x4a3b059e521b4b0445df96d5,
                    limb3: 0x333988c2c09f5af061cdfb,
                },
                y: u384 {
                    limb0: 0x13d3570be6d27d1d588b22fc,
                    limb1: 0x20c763e58d4df3e4990cdae9,
                    limb2: 0x2c3301367f400c31f4bded26,
                    limb3: 0x16a6c25d133fba74b4c55972,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcb24d12438557639f52df5fd,
                    limb1: 0x4a6a46feebe8a88a8062bd0e,
                    limb2: 0x65f04211af4b168b1e25787d,
                    limb3: 0x17935d6f4fa575744ca46f75,
                },
                y: u384 {
                    limb0: 0x644f324be8a5c152625a5b8a,
                    limb1: 0x501e52e8c5707d7a3a77ee18,
                    limb2: 0x9636c463c14c5b85c2e6d3b1,
                    limb3: 0x1939b6f297f7b5b7fd0ac458,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xde1d8e2670532ec5bba60ade,
                    limb1: 0x1154f5064f7dd38656f7f82b,
                    limb2: 0xc9bec68372b7d07dcf66270c,
                    limb3: 0x315ced00b3153219bbd430,
                },
                y: u384 {
                    limb0: 0xc48b3bc110e208d827b13f4d,
                    limb1: 0x87d82592699bca3dbf847c2b,
                    limb2: 0xff04f0f2c8be12365aa73443,
                    limb3: 0x1739c8c450ac994a5326c809,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0xbacf6e172ae22448b0163c1cd9d2b7d,
            },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x3ea0f301eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x2a97919d8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x460ba2d39a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x2894fdbe6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x43870ae2fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0x56e06d3d16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0xa4593acd7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0xd450fe4aec4f217bb306d1a8e5eeac76, high: 0x6b3f2afe642bfa42aef9c00b8a64c1b9,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x75b33668139cf598c76976ae,
                    limb1: 0xb57555c5f811f5932d2d664f,
                    limb2: 0x3dc0a463f21f628f6dd61035,
                    limb3: 0x13a7f85cd448414d544b7ba9,
                },
                y: u384 {
                    limb0: 0xedc098375876a9807b6eda05,
                    limb1: 0x650b70683fc239e28e6697c5,
                    limb2: 0x368e2ab0d50c091cf0be6938,
                    limb3: 0xcd0881f2458dd277af780b3,
                },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_11P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xda9cdde4e5c188233d85ff60,
                    limb1: 0x94bff3ad03f3cd34b48043c2,
                    limb2: 0x25a858c0f2c2ce6d9c1bcf02,
                    limb3: 0x1832d91c2c3f9a6f969b267e,
                },
                y: u384 {
                    limb0: 0x96f189a68bc1acf589e8ee8,
                    limb1: 0x4a1949d57a1cd60710138159,
                    limb2: 0x10f87bc3adcbbcafeb091948,
                    limb3: 0x1519173fd0ddb592b2a9438f,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xe28783905041626972027b5d,
                    limb1: 0x209a7185e3d7dcf824cd318,
                    limb2: 0xedea887527ba8825337cc658,
                    limb3: 0xa097cd7b1cf6b4244b0d234,
                },
                y: u384 {
                    limb0: 0x8a8dfb95bbd5a3372759b0de,
                    limb1: 0x59df5374722393631e53b53,
                    limb2: 0x96fc6de10523745e115d47e4,
                    limb3: 0x399551a8a5d335850b49e6a,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x28f1d7db996ba62dbf84ef85,
                    limb1: 0xdd4f6c28e044fec88359238c,
                    limb2: 0x3dc00b6d0c79ca704e025684,
                    limb3: 0x18cd5498819252b01053293c,
                },
                y: u384 {
                    limb0: 0x78e32d74881ba0a29e12561,
                    limb1: 0x6587f89c3b6e577301996b36,
                    limb2: 0x84c0912c12022d68336ec3d5,
                    limb3: 0x18587691602430b0d4f1defe,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xa0de26ff3ae146fc47f83584,
                        limb1: 0x66c358a7e7f26cc7fdcf7132,
                        limb2: 0x5360dcccc62402b4b04905b,
                        limb3: 0x6843a1421bc106828db9abc,
                    },
                    u384 {
                        limb0: 0x3da5c8b5f504f4615c5fffc7,
                        limb1: 0x8ee50683716614477c06f07c,
                        limb2: 0x244794c48ed63afbc5718469,
                        limb3: 0x121495b4d959bda9a0b070d3,
                    },
                    u384 {
                        limb0: 0xca5b3523df67af59d1deea9d,
                        limb1: 0x3125b2a9b3d3e9cb1052672a,
                        limb2: 0xa7178caa89eb8a42c47af224,
                        limb3: 0x19323af8da8195ead57ceae0,
                    },
                    u384 {
                        limb0: 0xe8a2665119e069c59b355589,
                        limb1: 0x54ee3e285f612bc6f98f2d74,
                        limb2: 0x7842f877114cb228214eb801,
                        limb3: 0x1785e840369f9334cec71eb4,
                    },
                    u384 {
                        limb0: 0xf5adae6dbf861782fe58e737,
                        limb1: 0x82fc0fce43bb596809599942,
                        limb2: 0xb7643672e7df1bf21f062fea,
                        limb3: 0x1073daa278cf27984e4717c2,
                    },
                    u384 {
                        limb0: 0x67ea56bd43e2f893a6f7731d,
                        limb1: 0x241c71d2f6f771deecfb1832,
                        limb2: 0xeed4c7464710128c06093c75,
                        limb3: 0x377b5d86720e49cdd9838ec,
                    },
                    u384 {
                        limb0: 0xc0b0ab6915cf0301a1c84bfc,
                        limb1: 0xd59d28f7f4ba9166b5930c4e,
                        limb2: 0x3ee95d9a38e14da969e37aa,
                        limb3: 0xfdf955dd6483888954894bd,
                    },
                    u384 {
                        limb0: 0x7c4ccca1918ccac71abc8c39,
                        limb1: 0x24091a5c272863907fbcf935,
                        limb2: 0xd992be27ca37a93856126f99,
                        limb3: 0x2c3e32bc4fa36bbd3dc5b2,
                    },
                    u384 {
                        limb0: 0x30f87dd5f990ecb57c81849,
                        limb1: 0xd3b8b99264298a42e954f2e4,
                        limb2: 0xa9f8a4151ec0ae3c84ca5c43,
                        limb3: 0x7d996bbe558835277196984,
                    },
                    u384 {
                        limb0: 0xd2dd52b5c9c166d2d4721b4f,
                        limb1: 0x96c097b9e4114a18a682a61a,
                        limb2: 0x1fba06be2b9b7153b1712d21,
                        limb3: 0x10de0cdca0acf11ab3f243f3,
                    },
                    u384 {
                        limb0: 0x595f0e14beadf504e2c268e7,
                        limb1: 0x7df2941a0bd66bf652eeb509,
                        limb2: 0xe5e8b6910404cbfef716ef66,
                        limb3: 0x148ee8e638b3da1ada5e126a,
                    },
                    u384 {
                        limb0: 0x5fbed78121bb281f9e06ee57,
                        limb1: 0xaa584b71beaeb2747ca28652,
                        limb2: 0x94f74cab2c96fb8f98432256,
                        limb3: 0x2d47f20f9a4fb46578b2270,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xc54379d1d4882196b227013a,
                        limb1: 0xe3ea061981f3320f30f18572,
                        limb2: 0xd3324f96a5bc30b2c374c8f,
                        limb3: 0x7edcb8dc454c462c9b0d620,
                    },
                    u384 {
                        limb0: 0x449e39141a6f6292d38e5ac5,
                        limb1: 0xefee812a94942f15997e3e3f,
                        limb2: 0x3de66730439f12804ec6b70b,
                        limb3: 0x7f73f2e7ac14bf40d65f33e,
                    },
                    u384 {
                        limb0: 0x9e49a7773b9e93676619e71b,
                        limb1: 0x812d1d28111e84ef2a01435e,
                        limb2: 0x24412b589e48d3d4ab781243,
                        limb3: 0x3b5ccd5ad908dfc5382e727,
                    },
                    u384 {
                        limb0: 0x653289348e6d2f0c6134b191,
                        limb1: 0xda84d117951e9a09d3ead25,
                        limb2: 0x1fd934065ca3ec46aa7f68d9,
                        limb3: 0x684e417efc9e14735a2624e,
                    },
                    u384 {
                        limb0: 0xbafe62692435da9ce3ae9bff,
                        limb1: 0xc245d834a417cad9e6fb7a93,
                        limb2: 0x3e48a5636389aee58d5f905d,
                        limb3: 0x11c3b4382904a87f48de3d26,
                    },
                    u384 {
                        limb0: 0xce255687ee36849660d4b4cc,
                        limb1: 0xc0e2bbf1bf3af13b03fa72d5,
                        limb2: 0xd4ec0b7897faf9efe73fcb1d,
                        limb3: 0x125a3d63361fb72c2b23f45a,
                    },
                    u384 {
                        limb0: 0x3a6075a0fd00fadb4a8cc34e,
                        limb1: 0x74c672e0e7b0a6daf6c3ca95,
                        limb2: 0xff58e474183a41553d3c342a,
                        limb3: 0x1235933aeb4f7e80fe25e9b5,
                    },
                    u384 {
                        limb0: 0x37bf28feafffbe9afdafbaf7,
                        limb1: 0xee92ebaeb68122b615ed9a96,
                        limb2: 0x6f50a38969d02e06b084b868,
                        limb3: 0x1458fa0962c7da337405c77d,
                    },
                    u384 {
                        limb0: 0xcf70e4382bb71c56eab0350d,
                        limb1: 0xabe42464b4b2621e3ed747bf,
                        limb2: 0x691b22e793a9f6c3d02342a0,
                        limb3: 0x12332dcf9adf1b88db5a335,
                    },
                    u384 {
                        limb0: 0xf5dfff3c9a9cef0aaae0b2ea,
                        limb1: 0xc35a3adaaa4f24dd045bd647,
                        limb2: 0x6bbd54791dcb5234fab435ee,
                        limb3: 0xfe15ecd270510b56db93cc7,
                    },
                    u384 {
                        limb0: 0xaf7d73d2e42fdf4bbeffa923,
                        limb1: 0xf60ba815c146aab2e50d64de,
                        limb2: 0xc60ec2a5401909dbaf49170e,
                        limb3: 0x13d85386b3c411d2c960c91a,
                    },
                    u384 {
                        limb0: 0x59ab6b05bc03531797486b1f,
                        limb1: 0x25bc5f3e2e9a640b9b76e662,
                        limb2: 0x6aec23b51d03c51b78d57644,
                        limb3: 0x9c1cb8ee8e2d316bb7acf54,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xda8a2f0d428647f8e27c9b98,
                        limb1: 0x26f53596e709fc6a01ed5b20,
                        limb2: 0xa08ca78af7fb58d25da0eb77,
                        limb3: 0xf66483819faebf98f918d30,
                    },
                    u384 {
                        limb0: 0xa0f94bd44355f022b0457c6c,
                        limb1: 0x3422f352b5469aec68b52391,
                        limb2: 0xebd8b22fb4513f07fc58263,
                        limb3: 0xaf0770c6154b5ed034c3b52,
                    },
                    u384 {
                        limb0: 0x4423ff15f439dc9f1fce82c1,
                        limb1: 0x38fabcb8bead5afbe00fbb60,
                        limb2: 0xacbb14806994a7272b40a8a0,
                        limb3: 0x1bb5bb3169c4b3c117c0b7e,
                    },
                    u384 {
                        limb0: 0xac336ad029466aff2981dbd,
                        limb1: 0x121a2563932f4e81a708df34,
                        limb2: 0x65b1a653fcebfc6d66dbe951,
                        limb3: 0x11c6e82bababdd5cdd0c6b50,
                    },
                    u384 {
                        limb0: 0x3ab916386071436ea1f5a076,
                        limb1: 0xbd886a792fccec6cc7dc8bb6,
                        limb2: 0xbfde16f7c76678af04b792d3,
                        limb3: 0x1210820e6e5db64ff248f6b7,
                    },
                    u384 {
                        limb0: 0x7ab5e102a7a6e02691d366a2,
                        limb1: 0x7f178772c86e2fc943868f23,
                        limb2: 0xe6949991ad106a8409ae2ab6,
                        limb3: 0x1907390fff3003f73e455c87,
                    },
                    u384 {
                        limb0: 0xa5615b0d8f3f950b34fdd036,
                        limb1: 0x4e6831abe02b7d4ae76d1a8,
                        limb2: 0x86280cc4bed22db5bf171e7c,
                        limb3: 0xffa4877c036843e46cb4b5c,
                    },
                    u384 {
                        limb0: 0x75904650a2d4f765d603a75,
                        limb1: 0xccb8ee0710d5187cf94a1e36,
                        limb2: 0x3190b86ad254d60045859368,
                        limb3: 0x164c5823e26a9806160fc80c,
                    },
                    u384 {
                        limb0: 0xf5f2515df61a97a8e6d726b5,
                        limb1: 0x89da2f47383a89e10ffb0afb,
                        limb2: 0xf69e07c295600a5b63489a38,
                        limb3: 0x18e4c716a2edf9f2ca859b1c,
                    },
                    u384 {
                        limb0: 0xf93eb8d83a9f22c93acfefc0,
                        limb1: 0xcf83f9586c260c6d5eb52c99,
                        limb2: 0xc80a14e9023debdb3b01a38,
                        limb3: 0xe2e084e135811e5c34acd25,
                    },
                    u384 {
                        limb0: 0xf0f1efcff2d0554435715bef,
                        limb1: 0x485982a09c996bde1716f56,
                        limb2: 0xc152b050340d67419cc59ef6,
                        limb3: 0x18298f7e03dc105b681ed6fe,
                    },
                    u384 {
                        limb0: 0xbbf3bf6a13f08745301578ff,
                        limb1: 0xb4147b839403505f27096d89,
                        limb2: 0x719b76f5befba08abe905253,
                        limb3: 0x13926f3403adfc34236de708,
                    },
                    u384 {
                        limb0: 0x6a0ec684ba298f1f3b41f681,
                        limb1: 0xa0682761fb58506aac226df4,
                        limb2: 0x51b4bce7c8fba8c44bed59f4,
                        limb3: 0xb4aafde248fb3b9baaaa7da,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x63b9e7479821865ac89c5a3d,
                        limb1: 0x287745c5111bd218a51a15cc,
                        limb2: 0xf180e70e44f7c0a7bd581f80,
                        limb3: 0x5b61c4cd7d32af0dba7b0c9,
                    },
                    u384 {
                        limb0: 0x6124e450afbe8a4b4e39c069,
                        limb1: 0x588932095b9fc632474cf8fe,
                        limb2: 0xb44defe9aa04fe7c4795c970,
                        limb3: 0x5dbeacfb1854935ea7c2542,
                    },
                    u384 {
                        limb0: 0x79269ddcee7a4d9d98679c6c,
                        limb1: 0x4b474a0447a13bca8050d7a,
                        limb2: 0x9104ad6279234f52ade0490e,
                        limb3: 0xed73356b64237f14e0b9c9c,
                    },
                    u384 {
                        limb0: 0xa8b99ea4543dddc836fa1cd3,
                        limb1: 0xb35a67be7089e26d87403a09,
                        limb2: 0x494c483b787428a0e2afdd34,
                        limb3: 0x8004a0349fc62e5551eb7a2,
                    },
                    u384 {
                        limb0: 0x1c9bc2b97d49cd066249cac0,
                        limb1: 0xc3736a1a40e07810d9682892,
                        limb2: 0x6d25f637a45feb87a9b5c044,
                        limb3: 0x102da5072543a224f8bf0b4,
                    },
                    u384 {
                        limb0: 0x74370197807aa5c0e96d64f5,
                        limb1: 0xb65667ad20a85d92fc930eb8,
                        limb2: 0xf159ff8c3546248a616d193b,
                        limb3: 0x191c9e8e130f9d7869db6925,
                    },
                    u384 {
                        limb0: 0x3ab85fb954741a798b68bec8,
                        limb1: 0xab2fa0b23401a2a01c49d77e,
                        limb2: 0x5359bf5090270f0cc4e10144,
                        limb3: 0x157fb44f088277c4ce71203,
                    },
                    u384 {
                        limb0: 0x85ff0664b637d508da6e87da,
                        limb1: 0x46ff0f0c9a097345e2ade4f0,
                        limb2: 0x31a82d02dd64847174e339c3,
                        limb3: 0x1524669f07a45d7e37a263f9,
                    },
                    u384 {
                        limb0: 0xbe8e7689d12f5f20b958900,
                        limb1: 0x70734d84920479b3ff5791d5,
                        limb2: 0x79589716e6a2d4ff27ccd5a0,
                        limb3: 0x16e708d71cd77e0e61fa8130,
                    },
                    u384 {
                        limb0: 0xfde472943977b705f6108ef5,
                        limb1: 0x4c9ce668acda57e2ac2f23b8,
                        limb2: 0xe46b2fd26201a79a4d7dd3a7,
                        limb3: 0x3b7d8b0dae40d87d3b7e5b0,
                    },
                    u384 {
                        limb0: 0xe1b8f84b12c23bc9f9af5f82,
                        limb1: 0x912f1422d788eb154e1f2e14,
                        limb2: 0xbda8a7983cce72e69319dc66,
                        limb3: 0x15b7126585586dafb835f4c5,
                    },
                    u384 {
                        limb0: 0x84ca904f61c568b547d236de,
                        limb1: 0xdba4cebc786afc288e06e14a,
                        limb2: 0xd18004e4a341bfacbff408f1,
                        limb3: 0xe294f2e63b95779308538d0,
                    },
                    u384 {
                        limb0: 0xf5dfff3c9a9cef0aaae0b2ee,
                        limb1: 0xc35a3adaaa4f24dd045bd647,
                        limb2: 0x6bbd54791dcb5234fab435ee,
                        limb3: 0xfe15ecd270510b56db93cc7,
                    },
                    u384 {
                        limb0: 0xaf7d73d2e42fdf4bbeffa923,
                        limb1: 0xf60ba815c146aab2e50d64de,
                        limb2: 0xc60ec2a5401909dbaf49170e,
                        limb3: 0x13d85386b3c411d2c960c91a,
                    },
                    u384 {
                        limb0: 0x59ab6b05bc03531797486b1f,
                        limb1: 0x25bc5f3e2e9a640b9b76e662,
                        limb2: 0x6aec23b51d03c51b78d57644,
                        limb3: 0x9c1cb8ee8e2d316bb7acf54,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x9243454eb54346e6236cf51b,
                limb1: 0xa1644de81217068da9794eb9,
                limb2: 0x76794330d97c2f5e56337a24,
                limb3: 0x31f72ef661df842d9ebbd0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xe4f817e54aede0613c17035c,
                    limb1: 0xdff1f15010392a6da1f95a6,
                    limb2: 0xbed78d3d341e911d49f15454,
                    limb3: 0x18154782ce0913b21588066d,
                },
                y: u384 {
                    limb0: 0x3d77d61326ef5a9a5a681757,
                    limb1: 0xd3070afd4f0e121de7fcee60,
                    limb2: 0xdf9ef4088763fe611fb85858,
                    limb3: 0x11a612bdd0bc09562856a70,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xde4f62a6588c9401ffefbd3,
                    limb1: 0x9bb5f797ac6d3395b71420b5,
                    limb2: 0xdc39e973aaf31de52219df08,
                    limb3: 0x105dcc4dce3960447d21d3c1,
                },
                y: u384 {
                    limb0: 0xaefd0d854043fd325dd3c34f,
                    limb1: 0x9b63c98d9a7845c52e1e2b0f,
                    limb2: 0x9db0be660d847ccc58358f3f,
                    limb3: 0x17cb6c41f0c4e1a7394ab62a,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcf86158ab69213388e721bb7,
                    limb1: 0x5f7812269d790797cad9aa15,
                    limb2: 0xb1c3622a0177001d9ed8e25f,
                    limb3: 0x115cf429f459884785c6ba46,
                },
                y: u384 {
                    limb0: 0x1e81341e2f3f988ff115dda3,
                    limb1: 0xad22946489db6ee4954fa5e1,
                    limb2: 0x83bed94412e19d92b73cc763,
                    limb3: 0x2074c7bceff87d0d41edba1,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xe2955c55da59eba4b7b57d3d,
                    limb1: 0x1e6629b0431bce67cf28c22,
                    limb2: 0x1c35b7efd5b67f87221b8bfc,
                    limb3: 0x3e53df9e3488a9e42acd87e,
                },
                y: u384 {
                    limb0: 0x2e089afa726154d40dd12102,
                    limb1: 0x5391613ecf49db2bcf1cad86,
                    limb2: 0x84a2abb2de6b3a6e09026a50,
                    limb3: 0x19557a3a3c1d62a205d5dc87,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x490bf40774926e8b279947c,
                    limb1: 0xeabab6aef9e9d2a4f64f4e7d,
                    limb2: 0x3e309fe1b1c8247abab20d7e,
                    limb3: 0x79c527862917f69ac58fcc4,
                },
                y: u384 {
                    limb0: 0xacb18f2da2b425c2ff50dafd,
                    limb1: 0x7623850d87e279a8a30f31ff,
                    limb2: 0x777564c7291d95fa80203ade,
                    limb3: 0x1764ce0e7fb626109b63789b,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x42f2f3f4f6b9d2c2b73a361f,
                    limb1: 0xcd78c070c184c38b1e5716aa,
                    limb2: 0x72cbc24cd90da89e0e3cefe4,
                    limb3: 0x19485e1c46d0dce75f8b192b,
                },
                y: u384 {
                    limb0: 0xb56b3539074b3c47b3f504d9,
                    limb1: 0x2c229530bddedd8851b03dcc,
                    limb2: 0xc93eef8474c4e18d6378e7f0,
                    limb3: 0x173d36f17a3c9ae77a2acc25,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5fbf29cf20556a11621a6639,
                    limb1: 0xdfda5b7dbf0b226822094787,
                    limb2: 0x4a3b059e521b4b0445df96d5,
                    limb3: 0x333988c2c09f5af061cdfb,
                },
                y: u384 {
                    limb0: 0x13d3570be6d27d1d588b22fc,
                    limb1: 0x20c763e58d4df3e4990cdae9,
                    limb2: 0x2c3301367f400c31f4bded26,
                    limb3: 0x16a6c25d133fba74b4c55972,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcb24d12438557639f52df5fd,
                    limb1: 0x4a6a46feebe8a88a8062bd0e,
                    limb2: 0x65f04211af4b168b1e25787d,
                    limb3: 0x17935d6f4fa575744ca46f75,
                },
                y: u384 {
                    limb0: 0x644f324be8a5c152625a5b8a,
                    limb1: 0x501e52e8c5707d7a3a77ee18,
                    limb2: 0x9636c463c14c5b85c2e6d3b1,
                    limb3: 0x1939b6f297f7b5b7fd0ac458,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xde1d8e2670532ec5bba60ade,
                    limb1: 0x1154f5064f7dd38656f7f82b,
                    limb2: 0xc9bec68372b7d07dcf66270c,
                    limb3: 0x315ced00b3153219bbd430,
                },
                y: u384 {
                    limb0: 0xc48b3bc110e208d827b13f4d,
                    limb1: 0x87d82592699bca3dbf847c2b,
                    limb2: 0xff04f0f2c8be12365aa73443,
                    limb3: 0x1739c8c450ac994a5326c809,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x8904b74d5d114b5416df0ed6,
                    limb1: 0x479ee13e49cde067742c2655,
                    limb2: 0x45b9359bfa338dd432ca9ff1,
                    limb3: 0x12bf6460e7a42942be6c16a0,
                },
                y: u384 {
                    limb0: 0x3a8b37aacb2f620bc41c6109,
                    limb1: 0x91f68edf90b5947273b0aadf,
                    limb2: 0x265d48695a73800b7404124c,
                    limb3: 0x141e3d99b3ab683bdb0ce70f,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x3ea0f301eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x2a97919d8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x460ba2d39a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x2894fdbe6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x43870ae2fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0x56e06d3d16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0xa4593acd7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0xd450fe4aec4f217bb306d1a8e5eeac76, high: 0x6b3f2afe642bfa42aef9c00b8a64c1b9,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0x1b8bb742d977e9933c49d76fcfc6e625,
            },
            u256 {
                low: 0xd344749096fd35d0adf20806e5214606, high: 0x233a1ba09466e4726b5f5241f323ca74,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x9ec142be39a5f52851d40011,
                    limb1: 0xa2c6a9a59c2e5cc721418300,
                    limb2: 0xf1b002b6ff0a802aa11d79f1,
                    limb3: 0x4ef0f37cba80a70d0645e6d,
                },
                y: u384 {
                    limb0: 0xb7eadd19764cdf407fce674a,
                    limb1: 0xcd0f0fe2c23c44035093a0e2,
                    limb2: 0xb99254d6476ffdbaf7f749d0,
                    limb3: 0xd20d67685607fa1d8542a6,
                },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_12P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x3e97d2180b8d9becdeecbc4,
                    limb1: 0x22464786b5e8678d30ea566d,
                    limb2: 0x460842529ef02457631e7075,
                    limb3: 0x9d08075235f7e786a2c8610,
                },
                y: u384 {
                    limb0: 0xad8b261cae9ca9c1ce60a5ad,
                    limb1: 0x49ed6d249b5433c2925f4a11,
                    limb2: 0xd21d53fd1765d52afd70bf35,
                    limb3: 0x19de584d836f54db00d356c4,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xdaebc752ad2b8ffff7549f07,
                    limb1: 0xd413863791b7a8f0c34eb3c6,
                    limb2: 0x9c92f45c88f9f47f20f4f8fc,
                    limb3: 0x145230516d9fe61cff157933,
                },
                y: u384 {
                    limb0: 0xe31cca49cb02ec5099286e72,
                    limb1: 0x299af97f18ac81739c305e01,
                    limb2: 0xc5d74563760466c83734d9d6,
                    limb3: 0xd65e4b6d9b871273837279d,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xf247311021189eaad71dc07a,
                    limb1: 0x95ea7c5761ce3305b72b3d27,
                    limb2: 0x4ed7e368cc21a3e659c373bb,
                    limb3: 0xa8a70d7ede8f711ca032c1a,
                },
                y: u384 {
                    limb0: 0x45f584bb123ee417f69a22ba,
                    limb1: 0xdf04ffc9dc515c574699e709,
                    limb2: 0x619bd5d8e446e7653d287f52,
                    limb3: 0xebda39b41cb789b69e9d1c1,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x437e8fc534671071816399e9,
                        limb1: 0xaf08f39b342539198cd7ed85,
                        limb2: 0x6449e42f325a8652ffe36766,
                        limb3: 0x196cbb2f666f2c0db7e43575,
                    },
                    u384 {
                        limb0: 0x7b7a202aa51f1d63a061f8b6,
                        limb1: 0x9213e6c007f1f28fe4e4fe35,
                        limb2: 0x2cc4e67ea6d8a596a37ae06d,
                        limb3: 0xef3d3b58dd930951d80b7c7,
                    },
                    u384 {
                        limb0: 0xb039ec0e9d5bdf7c2cac1e4e,
                        limb1: 0x74b5a0eecb682030e217c2db,
                        limb2: 0x810eff782a27e15a87e40481,
                        limb3: 0xf0e85fb407ad7e125964809,
                    },
                    u384 {
                        limb0: 0x8e60db19bf58f84c816c081b,
                        limb1: 0x94272ace538d766961dbdcdd,
                        limb2: 0x6b987a601725f1169b67a86e,
                        limb3: 0x170dbf89e85757541b1a8704,
                    },
                    u384 {
                        limb0: 0x3e50ec154708a45f4194dc00,
                        limb1: 0x4a0b0ff233b8b958650d831a,
                        limb2: 0xa2eeb1118d8425e41af41341,
                        limb3: 0x697b189c8717b2010040028,
                    },
                    u384 {
                        limb0: 0xca671dc0bc05bee59e6909e5,
                        limb1: 0xaae4bc6fc052c2507e721591,
                        limb2: 0x1f5ca76c84a80e82e7e94e89,
                        limb3: 0x11646a39ca1488f00c7ecffd,
                    },
                    u384 {
                        limb0: 0xc7c665fa374c37794a4ee7d0,
                        limb1: 0xc06cb2edc1297f99ccc9a21d,
                        limb2: 0x3b5d4e4906c847120de714c3,
                        limb3: 0x6e7b6da1dfd75c7b7d4df45,
                    },
                    u384 {
                        limb0: 0x70c6bb8ed397ace30662f7d1,
                        limb1: 0x7199e517f1f7f8921021c69,
                        limb2: 0x4e5154d03f3f14ecc28b1864,
                        limb3: 0x41dd293168c90092a2c52a9,
                    },
                    u384 {
                        limb0: 0xc884e6fe0da7fc594bf3c97e,
                        limb1: 0xc533dc056eb56c5edd3ce1d1,
                        limb2: 0x642491087d7b1d776d8d84d,
                        limb3: 0x784c3b315832fee5f5c7b3b,
                    },
                    u384 {
                        limb0: 0xd5066a622996dd6873bca73,
                        limb1: 0x714102cb79cd7ef2a8115bb5,
                        limb2: 0x53d797d22e26c6194643ff5,
                        limb3: 0x145afdbbf18d0a9d5fa1ddd4,
                    },
                    u384 {
                        limb0: 0xf54173da2c89b84aa7ab695,
                        limb1: 0x410a7d631e2af402b73e0710,
                        limb2: 0x929fa87adeeeeac6f57b0294,
                        limb3: 0x1306a69386002ac56840852a,
                    },
                    u384 {
                        limb0: 0x12f397494be887c83fa40a0a,
                        limb1: 0xed2c5aa8be0bcde944cbb725,
                        limb2: 0x3e06908c581e2add12bfe3d5,
                        limb3: 0x1153210a52c001866a4cddc2,
                    },
                    u384 {
                        limb0: 0x64053212bfd416d46cc1749f,
                        limb1: 0xb089fcf37d28024ff3449dfe,
                        limb2: 0xf8789874a3749100aad75f51,
                        limb3: 0x14a505af73f4cd942fcafd45,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x3f470e967c1812c91ba00625,
                        limb1: 0x5898baadb215593d61694ef6,
                        limb2: 0xe8f3828778e05e5348ee0505,
                        limb3: 0xf838e8d4a39179a761cd728,
                    },
                    u384 {
                        limb0: 0xd7f4c82fd960ab60fb43c8d5,
                        limb1: 0xed7bc1eab1178272db633743,
                        limb2: 0xc2f622f7411edc7970301065,
                        limb3: 0x5842dc9f1ab4c0d45dc9687,
                    },
                    u384 {
                        limb0: 0xde8c86cd47e19c4a8452151e,
                        limb1: 0x33b09b3409ecb225f52276aa,
                        limb2: 0x46083d82962eda5484437364,
                        limb3: 0x3e6341845b9c35e75035290,
                    },
                    u384 {
                        limb0: 0x1eeddf7c4f736be9013e4fc,
                        limb1: 0x4a5038bbc27aa564bdf16281,
                        limb2: 0xac9f375b498127eabaa4f215,
                        limb3: 0x80cc8ce0a28039e79fc5d1d,
                    },
                    u384 {
                        limb0: 0x49162e37200e5db0b30a5504,
                        limb1: 0x2bd00b70868d221de191dccb,
                        limb2: 0x4c74ef7b81c27dedf4ba9e00,
                        limb3: 0x53330773725ce5a45d406c6,
                    },
                    u384 {
                        limb0: 0x83a5b931bbc25bdf30af04c2,
                        limb1: 0xf80c1e9d9af273377311916b,
                        limb2: 0x84cae1eeb3cbaed85ce90f8f,
                        limb3: 0x19cfc137b238d58bd4d6ac1e,
                    },
                    u384 {
                        limb0: 0xf1d1fef85e933935d7ff1d4c,
                        limb1: 0x1d4094a0fa2569b37c66c2d5,
                        limb2: 0xed8a200dece3eb3ad7c7a6d7,
                        limb3: 0x14409a9fcdce151e4237eab4,
                    },
                    u384 {
                        limb0: 0xb1c307ecdbf3596fb4bb7154,
                        limb1: 0xc75d86f52d4d3e2ca5853c8e,
                        limb2: 0x286bec9ee51894c79b294e09,
                        limb3: 0x247c6853ccfdefbbcea3d1d,
                    },
                    u384 {
                        limb0: 0x1733ea6ddab782ec85ae70d,
                        limb1: 0xf0a75e2340d7451f9cc917bc,
                        limb2: 0x5a4afa8c4f66d386c3e60b35,
                        limb3: 0x1794d4e1563e890d948e8176,
                    },
                    u384 {
                        limb0: 0x106902960d79982e39d154ba,
                        limb1: 0xa750e52747588f86995607aa,
                        limb2: 0x72174997524606e217c58c90,
                        limb3: 0x19a65a84307841b6f8db85d9,
                    },
                    u384 {
                        limb0: 0xf3cc7d754b973b75560a6cff,
                        limb1: 0x8b8657b1a59f8814d0ed1771,
                        limb2: 0x299fa8bf2da443a7bf6d26c1,
                        limb3: 0xcc70f1e4ceb1a1b1b61cfda,
                    },
                    u384 {
                        limb0: 0x39545508bafa1850fc38962a,
                        limb1: 0x850eaf3c0eb3a07b5a726a7,
                        limb2: 0x89a45f95d4cc7f1658a88cd4,
                        limb3: 0xb1b5908818cd28e1fafb22f,
                    },
                    u384 {
                        limb0: 0x1377eaf94203c80067ff382,
                        limb1: 0xcef824f14631f71fa26068d3,
                        limb2: 0x7a17c2c5f91a5c4a0d69a320,
                        limb3: 0xae7ea0cdceaab5c035dd12f,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xcd595a1a13d89cc93a4fa0b,
                        limb1: 0xa5328a18c385034770d4bc02,
                        limb2: 0x576f337400e64ad299715fd9,
                        limb3: 0xf8ce5e28e5d5e6d9d6ee68a,
                    },
                    u384 {
                        limb0: 0xe423c22b6bc884771c0342f5,
                        limb1: 0xce6ceb2a7aee720c61b18c43,
                        limb2: 0x12cdeb7014bcf4cf09346050,
                        limb3: 0x9618400d34202073e91b38f,
                    },
                    u384 {
                        limb0: 0xdbab401e8ba6b04e6072b4a,
                        limb1: 0xb7d5ce6310f66c3c081317d3,
                        limb2: 0xc362c8151a0d69cbce2b512e,
                        limb3: 0x3febcb189efdef75074d8f8,
                    },
                    u384 {
                        limb0: 0x20d4f6281e54905ac5831f4d,
                        limb1: 0xcbf95fb8102cefe2c80e8d30,
                        limb2: 0x274fa8067ce1d23afdff052e,
                        limb3: 0x19bca2c183eb739a11a78e79,
                    },
                    u384 {
                        limb0: 0x73e85e52251ec9a8d5050752,
                        limb1: 0x1e04a7dfda71c5d30164b90e,
                        limb2: 0x11371418b2571b9ebf511137,
                        limb3: 0x8fa51a9ecb230973c49ba39,
                    },
                    u384 {
                        limb0: 0x10d214527b6acc4aa3b54889,
                        limb1: 0x706b255aece16d264cbe09e8,
                        limb2: 0xb2d2f0bddf309eb4f2584d53,
                        limb3: 0x1539e21b24d4459113f5dee0,
                    },
                    u384 {
                        limb0: 0xccf8aaaa16dcb16abb636011,
                        limb1: 0xf320f5eeb4e2c72b76d7543b,
                        limb2: 0xb8ace6dbbc0c1f0a9301c3c3,
                        limb3: 0x8bf109613fcbedbd1f6eb54,
                    },
                    u384 {
                        limb0: 0x5db0e505f0d4c17b70ede742,
                        limb1: 0xebf02faa2b1369c35293c278,
                        limb2: 0x1580684a19424b874676f1d6,
                        limb3: 0x432a6e9f63d4f3fd7751b27,
                    },
                    u384 {
                        limb0: 0xcc6bfca6ed3d085a948bf76f,
                        limb1: 0xd4e5ea9a096e5a2876582762,
                        limb2: 0x6b6031124befcce336edcd11,
                        limb3: 0x4d6fcb104e4f995783df55a,
                    },
                    u384 {
                        limb0: 0xeb4beb9c6bea6906be096a0d,
                        limb1: 0x58cbd0fdd942ab6f6ca38afc,
                        limb2: 0xa6f8a43cb124f43c47458c3,
                        limb3: 0xdd1097916b8d344c8786b6b,
                    },
                    u384 {
                        limb0: 0x8e3622a7bd32b02b9b9596d0,
                        limb1: 0x9b22515cd79ca9f459bcaee,
                        limb2: 0x59b48afbf51bcd276cd79e7b,
                        limb3: 0x51d85d10a9d19d98c992693,
                    },
                    u384 {
                        limb0: 0x86fd9f4c66ef7abaf2829b98,
                        limb1: 0xf3301e19baf1564cde179dc5,
                        limb2: 0x6139bd4b9efe34a8d9808497,
                        limb3: 0xd33b412ca6955c511ee13e7,
                    },
                    u384 {
                        limb0: 0xb0027eef2a7727d06aa449a5,
                        limb1: 0xa736907d9496cd93f41ee2cd,
                        limb2: 0x3116d3b02d559c178b41f5cb,
                        limb3: 0x149df0480c3df6ec6bb30c2a,
                    },
                    u384 {
                        limb0: 0x9504daf42dff0e6a5f36a1b6,
                        limb1: 0xc9935fa3930f2253e1f7926a,
                        limb2: 0x849319a1b07bd3ee8eb93cc3,
                        limb3: 0xa43850bb2e3f7688bdcc6aa,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x9a743a5a7c624b246e80c33e,
                        limb1: 0x94014574daf378ad484d3bdb,
                        limb2: 0x1d36b06f1a92e2433cadee96,
                        limb3: 0xa0c1660b5e49135423c0d37,
                    },
                    u384 {
                        limb0: 0x5fd320bf6582ad83ed0f2354,
                        limb1: 0xb5ef07aac45e09cb6d8cdd0f,
                        limb2: 0xbd88bdd047b71e5c0c04197,
                        limb3: 0x1610b727c6ad303517725a1f,
                    },
                    u384 {
                        limb0: 0x7a321b351f86712a11485478,
                        limb1: 0xcec26cd027b2c897d489daab,
                        limb2: 0x1820f60a58bb6952110dcd90,
                        limb3: 0xf98d06116e70d79d40d4a41,
                    },
                    u384 {
                        limb0: 0x95ae8675d5f5edc35befef6a,
                        limb1: 0x1aa8cafbc54ef8ac3a82d8fb,
                        limb2: 0x5824b31d3a6db2793ffcba9b,
                        limb3: 0x15b59fdb39593f7a12f2a3e9,
                    },
                    u384 {
                        limb0: 0x4af9810c9f9b2223c76d723a,
                        limb1: 0x358b1d0bd49b14c642feaa72,
                        limb2: 0xb17e340de3b188ac4f9575a7,
                        limb3: 0x4fddbc94c29edc121109ea,
                    },
                    u384 {
                        limb0: 0x27d36b954eef0bc7470f7d7a,
                        limb1: 0x771dcb269af2a67346b8bc5e,
                        limb2: 0x4c0511dfd38067a229d366a6,
                        limb3: 0x320f14e289d7f249bef6431,
                    },
                    u384 {
                        limb0: 0xb53ad9da11471b95f0115a2b,
                        limb1: 0x89c0135cc6fd69c653886ddc,
                        limb2: 0x98e4b10ccfaaf2473f345533,
                        limb3: 0xb0bfd8e94e0a448a18910ce,
                    },
                    u384 {
                        limb0: 0x10224dea8fdbc36f85f81a54,
                        limb1: 0x494627453bc21ad077a6cf06,
                        limb2: 0xee24a1f71624d10c615fd627,
                        limb3: 0xe524a8c2a654a49397cfb3a,
                    },
                    u384 {
                        limb0: 0xc422b3ce4a743c9a521bf64a,
                        limb1: 0x1de64ca6c38baf256b85f060,
                        limb2: 0xe0c818c25f89cedf9e6cf16a,
                        limb3: 0x101ecd1425335f58faa2131e,
                    },
                    u384 {
                        limb0: 0x6e260951ac7d99eebf45c588,
                        limb1: 0x1dc0deba3cc3cf3d670ee183,
                        limb2: 0xa8b8930da41ed8af68c98e1c,
                        limb3: 0x12d5bd07a9af8190f9376341,
                    },
                    u384 {
                        limb0: 0x1e4cfdc2965247450ce5cffa,
                        limb1: 0x27154079d6697237abe19a59,
                        limb2: 0x485335ecd2bb0c5cb1d3c391,
                        limb3: 0x161df29fd7c7a33943a2d19,
                    },
                    u384 {
                        limb0: 0x841c92ca5595d972b93dea5f,
                        limb1: 0x438964b0572240f6360db25b,
                        limb2: 0xfa451f34d9aa38d63f7e1907,
                        limb3: 0x1000152ee97206117d15fac7,
                    },
                    u384 {
                        limb0: 0xb29efd54e9fc8a2e53d1cd6c,
                        limb1: 0x14cfd3aa72be7fbce57faaf8,
                        limb2: 0xd3defb006dc0e1006661f395,
                        limb3: 0x1143dee3312321f2701b7b2a,
                    },
                    u384 {
                        limb0: 0xf3cc7d754b973b75560a6d03,
                        limb1: 0x8b8657b1a59f8814d0ed1771,
                        limb2: 0x299fa8bf2da443a7bf6d26c1,
                        limb3: 0xcc70f1e4ceb1a1b1b61cfda,
                    },
                    u384 {
                        limb0: 0x39545508bafa1850fc38962a,
                        limb1: 0x850eaf3c0eb3a07b5a726a7,
                        limb2: 0x89a45f95d4cc7f1658a88cd4,
                        limb3: 0xb1b5908818cd28e1fafb22f,
                    },
                    u384 {
                        limb0: 0x1377eaf94203c80067ff382,
                        limb1: 0xcef824f14631f71fa26068d3,
                        limb2: 0x7a17c2c5f91a5c4a0d69a320,
                        limb3: 0xae7ea0cdceaab5c035dd12f,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xed007f95472ddb9f25de9275,
                limb1: 0x917b584d5245ae55a6ca381b,
                limb2: 0xbcabb3a1e87aa361a3e037c,
                limb3: 0xb43cd9a512cd7f1a24b7498,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xe4f817e54aede0613c17035c,
                    limb1: 0xdff1f15010392a6da1f95a6,
                    limb2: 0xbed78d3d341e911d49f15454,
                    limb3: 0x18154782ce0913b21588066d,
                },
                y: u384 {
                    limb0: 0x3d77d61326ef5a9a5a681757,
                    limb1: 0xd3070afd4f0e121de7fcee60,
                    limb2: 0xdf9ef4088763fe611fb85858,
                    limb3: 0x11a612bdd0bc09562856a70,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xde4f62a6588c9401ffefbd3,
                    limb1: 0x9bb5f797ac6d3395b71420b5,
                    limb2: 0xdc39e973aaf31de52219df08,
                    limb3: 0x105dcc4dce3960447d21d3c1,
                },
                y: u384 {
                    limb0: 0xaefd0d854043fd325dd3c34f,
                    limb1: 0x9b63c98d9a7845c52e1e2b0f,
                    limb2: 0x9db0be660d847ccc58358f3f,
                    limb3: 0x17cb6c41f0c4e1a7394ab62a,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcf86158ab69213388e721bb7,
                    limb1: 0x5f7812269d790797cad9aa15,
                    limb2: 0xb1c3622a0177001d9ed8e25f,
                    limb3: 0x115cf429f459884785c6ba46,
                },
                y: u384 {
                    limb0: 0x1e81341e2f3f988ff115dda3,
                    limb1: 0xad22946489db6ee4954fa5e1,
                    limb2: 0x83bed94412e19d92b73cc763,
                    limb3: 0x2074c7bceff87d0d41edba1,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xe2955c55da59eba4b7b57d3d,
                    limb1: 0x1e6629b0431bce67cf28c22,
                    limb2: 0x1c35b7efd5b67f87221b8bfc,
                    limb3: 0x3e53df9e3488a9e42acd87e,
                },
                y: u384 {
                    limb0: 0x2e089afa726154d40dd12102,
                    limb1: 0x5391613ecf49db2bcf1cad86,
                    limb2: 0x84a2abb2de6b3a6e09026a50,
                    limb3: 0x19557a3a3c1d62a205d5dc87,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x490bf40774926e8b279947c,
                    limb1: 0xeabab6aef9e9d2a4f64f4e7d,
                    limb2: 0x3e309fe1b1c8247abab20d7e,
                    limb3: 0x79c527862917f69ac58fcc4,
                },
                y: u384 {
                    limb0: 0xacb18f2da2b425c2ff50dafd,
                    limb1: 0x7623850d87e279a8a30f31ff,
                    limb2: 0x777564c7291d95fa80203ade,
                    limb3: 0x1764ce0e7fb626109b63789b,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x42f2f3f4f6b9d2c2b73a361f,
                    limb1: 0xcd78c070c184c38b1e5716aa,
                    limb2: 0x72cbc24cd90da89e0e3cefe4,
                    limb3: 0x19485e1c46d0dce75f8b192b,
                },
                y: u384 {
                    limb0: 0xb56b3539074b3c47b3f504d9,
                    limb1: 0x2c229530bddedd8851b03dcc,
                    limb2: 0xc93eef8474c4e18d6378e7f0,
                    limb3: 0x173d36f17a3c9ae77a2acc25,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5fbf29cf20556a11621a6639,
                    limb1: 0xdfda5b7dbf0b226822094787,
                    limb2: 0x4a3b059e521b4b0445df96d5,
                    limb3: 0x333988c2c09f5af061cdfb,
                },
                y: u384 {
                    limb0: 0x13d3570be6d27d1d588b22fc,
                    limb1: 0x20c763e58d4df3e4990cdae9,
                    limb2: 0x2c3301367f400c31f4bded26,
                    limb3: 0x16a6c25d133fba74b4c55972,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xcb24d12438557639f52df5fd,
                    limb1: 0x4a6a46feebe8a88a8062bd0e,
                    limb2: 0x65f04211af4b168b1e25787d,
                    limb3: 0x17935d6f4fa575744ca46f75,
                },
                y: u384 {
                    limb0: 0x644f324be8a5c152625a5b8a,
                    limb1: 0x501e52e8c5707d7a3a77ee18,
                    limb2: 0x9636c463c14c5b85c2e6d3b1,
                    limb3: 0x1939b6f297f7b5b7fd0ac458,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xde1d8e2670532ec5bba60ade,
                    limb1: 0x1154f5064f7dd38656f7f82b,
                    limb2: 0xc9bec68372b7d07dcf66270c,
                    limb3: 0x315ced00b3153219bbd430,
                },
                y: u384 {
                    limb0: 0xc48b3bc110e208d827b13f4d,
                    limb1: 0x87d82592699bca3dbf847c2b,
                    limb2: 0xff04f0f2c8be12365aa73443,
                    limb3: 0x1739c8c450ac994a5326c809,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x8904b74d5d114b5416df0ed6,
                    limb1: 0x479ee13e49cde067742c2655,
                    limb2: 0x45b9359bfa338dd432ca9ff1,
                    limb3: 0x12bf6460e7a42942be6c16a0,
                },
                y: u384 {
                    limb0: 0x3a8b37aacb2f620bc41c6109,
                    limb1: 0x91f68edf90b5947273b0aadf,
                    limb2: 0x265d48695a73800b7404124c,
                    limb3: 0x141e3d99b3ab683bdb0ce70f,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x6d6db022a8549ee86374b69a,
                    limb1: 0x3e98f7258170733507d8709b,
                    limb2: 0x10b4337a56d4cd17ab2fe1d5,
                    limb3: 0x11366a6fecb124757076f4b6,
                },
                y: u384 {
                    limb0: 0x77b25b600d3baa1a2f54f826,
                    limb1: 0x924c3c1a699e9b27b3612246,
                    limb2: 0x6a253cae0097b1955d4f0cfd,
                    limb3: 0xd2bd6591140d2faabafefac,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x2a97919d8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x460ba2d39a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x2894fdbe6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x43870ae2fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0x56e06d3d16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0xa4593acd7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0xd450fe4aec4f217bb306d1a8e5eeac76, high: 0x6b3f2afe642bfa42aef9c00b8a64c1b9,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0x1b8bb742d977e9933c49d76fcfc6e625,
            },
            u256 {
                low: 0xd344749096fd35d0adf20806e5214606, high: 0x233a1ba09466e4726b5f5241f323ca74,
            },
            u256 {
                low: 0x5306f3f5151665705b7c709acb175a5a, high: 0x4b2543867c879b741d878f9f9cdf5a86,
            },
            u256 {
                low: 0x30bcab0ed857010255d44936a1515607, high: 0x22b15f3fbb42e0b20426465e3e37952d,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xc0fae85730816663a083b3ff,
                    limb1: 0x8eeeb4d636a81006cac603ad,
                    limb2: 0xf0f40dc24542dd2f9caf4878,
                    limb3: 0x124bec083e5a23bb11859569,
                },
                y: u384 {
                    limb0: 0x8666d8ee624f5a3d425b3bae,
                    limb1: 0x2299908d21f6475fc69fed83,
                    limb2: 0x78f769e47d3af619393f077e,
                    limb3: 0x11cd8088ab13c9943e7ddf7,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_1P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x3ca5552c96ec2a5049d28426,
                limb1: 0xc8669717174b973f4de5a646,
                limb2: 0x4fbfb38ec0c14e6e,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_2P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xcab2bdb49d36853afc772e84,
                limb1: 0x9388d6adcd576a1b6ae83895,
                limb2: 0x4a4640dc5b206990,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xa65fee3201baba3b9c2f59b5,
                    limb1: 0x1ff3274e058360d6b1e64db3,
                    limb2: 0x2af2ec2fe4bf31ee,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0xda5e742b60f13ba9478a5085,
                    limb1: 0x4ef5a3a77cc1f80dedc41ae6,
                    limb2: 0x511bc713034c93d4,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x113c8d620e3745e45e4389b8,
                    limb1: 0x85b8ff52d905fd02fe191c3f,
                    limb2: 0xf5d132d685201517,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x60c0ba1b358f375b2362662e,
                    limb1: 0x6abfc829d93e09aa5174ec04,
                    limb2: 0x7bc4637aca93cb5a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xeb1167b367a9c3787c65c1e582e2e662, high: 0xf7c1bd874da5e709d4713d60c8a70639,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_3P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xf831856624736393b3b76d11,
                    limb1: 0xc165a27df5b76589fe2ce1e2,
                    limb2: 0x2a23444ace6bef77,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa6bbeec6fb0369c3de339579,
                    limb1: 0xd394f6a5704d1de2da06048,
                    limb2: 0xe8057073c0fde87b,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x3b1d72dc227f75f02874e08b,
                    limb1: 0xd395fa7c14d6ff33d03e1baf,
                    limb2: 0xbf16fcc65f95b486,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe2461ebbe7a5b4d76dbef92b,
                    limb1: 0x3eecb75c5315cd3d2d0b9456,
                    limb2: 0x8192517353bc6523,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xcff970bda4db69dac06ebad8,
                    limb1: 0xdee4204cca252abd67132509,
                    limb2: 0xa79c0006b6ca7fab,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x759642b853dd01b9d2d7bb18,
                    limb1: 0xe1e1d2f8bf0f2f5b463bfae0,
                    limb2: 0xbc3c71be130f204d,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x9103bd16e2232359c067051c,
                        limb1: 0x47056dacf5ebc26121584255,
                        limb2: 0x510b978b1c20d16d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3866c583186023310ae6006f,
                        limb1: 0x94b09aee6293fdcebd256a74,
                        limb2: 0xe9964a385943e6e7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4e66f352e983f05cd787905a,
                        limb1: 0x23e4fc7f433c2785b079f227,
                        limb2: 0x6b71075ebbeffe51,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8d716d3dc708179fd42941cc,
                        limb1: 0xd8e4a54aef03a57c0c4a1845,
                        limb2: 0xed1182498b974526,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x32f47eb672f5bb330a73bb4a,
                        limb1: 0x1a8091c6f1f3893bc55d0fa5,
                        limb2: 0x8f7089d778e965c2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc7a8f052fc045a7c4ceff3e,
                        limb1: 0x8b14021f73a80543f9ad14a3,
                        limb2: 0x508a2680c93698e4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfc72a135b2aaa8dee44f9400,
                        limb1: 0x9f66c7f22c15ecf4bac82c86,
                        limb2: 0x6724ac9ffc3487b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x28b8828023437a8d6e45900c,
                        limb1: 0x490cdc11b822023a5eedbb11,
                        limb2: 0xcf427b32bdfa36c7,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xc31b8bfe95c99a953dfbeabd,
                        limb1: 0xe63b42304b4dc475c331d5ac,
                        limb2: 0x499b1e200475197c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf166baa3bc64785c42f2e9eb,
                        limb1: 0xd575ea7fa8f28aaa7a9b0f64,
                        limb2: 0x128864b271e1ebf2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x116db906aee291051c9ce08,
                        limb1: 0x2943633ba402debefac3b9a0,
                        limb2: 0x36d5e25b3ef465fb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x525c3dbd1864649780b5a73e,
                        limb1: 0x65b5ed8ec92dd969aa336caa,
                        limb2: 0x3f69b099f8b6619c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdcb8bc014e35c6d4febb77c9,
                        limb1: 0x25ffc8096d6e87b1e76b8e6e,
                        limb2: 0x45eaa89a67cda802,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xbeada704feb34546e4301ab0,
                        limb1: 0x5b533141bf8fd64c6afe4bd9,
                        limb2: 0x4e4368ec25ed3c45,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1a26c33296a4cf0e96b4d599,
                        limb1: 0x27f1e1d4a919a68c6edaf9df,
                        limb2: 0x7e1cc39a4fc825b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa37d8288f41c6ce32ecb17e2,
                        limb1: 0x56f36c3517bd230fefdbda97,
                        limb2: 0xde1b03a23f8bb59e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9d3ed76f0cda7c44b1892480,
                        limb1: 0xad525772678432d3dd0efe6,
                        limb2: 0x1e5683ea757beea2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5ea4b87b01c4123da1d0af63,
                        limb1: 0x63d92b3fc1da85514200ea22,
                        limb2: 0x3d88eabf39828878,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfc72a135b2aaa8dee44f93fd,
                        limb1: 0x9f66c7f22c15ecf4bac82c86,
                        limb2: 0x6724ac9ffc3487b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x28b8828023437a8d6e45900c,
                        limb1: 0x490cdc11b822023a5eedbb11,
                        limb2: 0xcf427b32bdfa36c7,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x4d4cd96c2a9c3eeb03a36099,
                limb1: 0x68066c4db63f81f0b9abcbb6,
                limb2: 0x3cf75d802ff73183,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x113c8d620e3745e45e4389b8,
                    limb1: 0x85b8ff52d905fd02fe191c3f,
                    limb2: 0xf5d132d685201517,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x60c0ba1b358f375b2362662e,
                    limb1: 0x6abfc829d93e09aa5174ec04,
                    limb2: 0x7bc4637aca93cb5a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd3ff147ff0ee4213f51f677d,
                    limb1: 0x431366a7732a6e4a6b942255,
                    limb2: 0x9fe743b25d39a591,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7f8bb562ff60a902ef14bcb0,
                    limb1: 0xeb9420089fa531db62e806a6,
                    limb2: 0xfd028df433dfd5cc,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xe443df789558867f5ba91faf7a024204, high: 0x23a7711a8133287637ebdcd9e87a1613,
            },
            u256 {
                low: 0x1846d424c17c627923c6612f48268673, high: 0xfcbd04c340212ef7cca5a5a19e4d6e3c,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x33ee7695471a03192ef22266,
                    limb1: 0xb449dd8cfd0c3438e14a718c,
                    limb2: 0x1fbb33f079b828e2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb411f97aeec2eae6044122ec,
                    limb1: 0xcdce180b60667260d7ce284e,
                    limb2: 0xa73a7381dd3b07c,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_4P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xddb5a889b8b2286c5d1124ca,
                    limb1: 0xe3db8af7035bf63b788d1b86,
                    limb2: 0x2e193b7cafebcfe6,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x519a5d47cdb177063c1665a5,
                    limb1: 0x4f72ccaf2e61bf1ca5909e56,
                    limb2: 0x5a4c815353430f54,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x7471395483d3edfae9b6f108,
                    limb1: 0xdc3612b8c1cff114d0097f61,
                    limb2: 0xf3cd0f7bac63576e,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7546388b69b878a6a1808495,
                    limb1: 0xc57e063ce6a1619ab7f4a8c9,
                    limb2: 0x876dcde507c5b206,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x7be10be31458fbb2b84ad1cf,
                    limb1: 0xc6c7c5315901dfe6df3b4e86,
                    limb2: 0x245ced58428a76b2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x59d7d6bf1a2a69e2c0c680f9,
                    limb1: 0x35c6a2e80821772c88ce7405,
                    limb2: 0x4859fbcef0a50f54,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xd7ff76082d220594fd9c796d,
                        limb1: 0x64173827dd21d0cdf2cef5eb,
                        limb2: 0x4fc2048e40193666,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x209add35046d7fa733e876e9,
                        limb1: 0x7b2bcc2548c94f5ca9cf63ec,
                        limb2: 0x71ae8b1209d0569b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x31375be21ebc3e1f47899477,
                        limb1: 0x5875347782c05d42c8426c4e,
                        limb2: 0xaa82204a9da2be3c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4b44f3411db6c71be2d2feca,
                        limb1: 0xdfca92d047d9087ec7303593,
                        limb2: 0xd33f82983b9a359c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x77c0ca5779540bd110c72c4d,
                        limb1: 0x58cef6df7a49e4f18e9b9f3b,
                        limb2: 0xb7086c7f110ad9bf,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x224a7f10c430261fd46a2cbc,
                        limb1: 0x95a48f0fea77443974ef772,
                        limb2: 0x1f01781aa21478b0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd69f441418c65cd0a28ea4,
                        limb1: 0x5b90bd8b06bb760f4b0ce8d2,
                        limb2: 0xe833a95fe714f4f9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd405f15d194e8ff56446eabd,
                        limb1: 0x8066d26cf0bbd6ab89ef10ae,
                        limb2: 0x83f465891e451597,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x235ec499538d5c0d4873ec3b,
                        limb1: 0xf5346e44643e39bdb3df520,
                        limb2: 0x50155054a5948369,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x174acbc7c20961018a885e29,
                        limb1: 0x8be69f64facd0f57ce6161b,
                        limb2: 0xefa8c3ce74e07aca,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x2f443c999ca90b0c45e0d244,
                        limb1: 0xe160ce246344edbf4f5cc01d,
                        limb2: 0x66ee00f7147970f8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x801db4ead91ea5eb5e2980a,
                        limb1: 0xb8f3d9c5e373b5c3683dcf85,
                        limb2: 0xb42c74c87261ae3f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6f08d5a954d30c948d9f4ade,
                        limb1: 0x3c3e2add03e75101b514a41d,
                        limb2: 0xc4e5f7cfb618df9e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6fb79df036f0c7bf6720921,
                        limb1: 0x98ab7a9231ba525ffe259758,
                        limb2: 0xa06fb2cb7172bde9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1de67f3f1d796ad3f303d459,
                        limb1: 0xc6df8e0f12480df3325cc65,
                        limb2: 0xcdd030c391a0c0e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x96d45112a0cbb486074b1531,
                        limb1: 0xb1782d551e3a8be2ef9d6db8,
                        limb2: 0xa843060ce9ab59e0,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x3370605526a1bcc7247a4bb1,
                        limb1: 0xe7e333b77b2dd26060ba952,
                        limb2: 0x50909e4a7b51bc4d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x90b316c91247756be086acbc,
                        limb1: 0x2f45c3232936442869d434df,
                        limb2: 0x34d2dbf6441376c7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5046835dfc5b747c1daf0e1b,
                        limb1: 0xb7c0e22fd16216471feca621,
                        limb2: 0x8083c8e0735e0075,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbf9ffe123c33fd394188990c,
                        limb1: 0xd11dad765f2eba62bf6692dc,
                        limb2: 0xb6e5bda8e22c9ace,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2fa280474cb1cd5ea09a7379,
                        limb1: 0xf3351b39b4c55ce71b04c83c,
                        limb2: 0x798ac53193184455,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5a793efc0f00a92eec80308b,
                        limb1: 0x1a1751df784dea877859d510,
                        limb2: 0xfc04ff469de3923,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x235ec499538d5c0d4873ec38,
                        limb1: 0xf5346e44643e39bdb3df520,
                        limb2: 0x50155054a5948369,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x174acbc7c20961018a885e29,
                        limb1: 0x8be69f64facd0f57ce6161b,
                        limb2: 0xefa8c3ce74e07aca,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x2de931db10ecad445f8ceb39,
                limb1: 0xc77af0d450eca1971425bbc0,
                limb2: 0x7e99f3c47d9dc2f0,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x113c8d620e3745e45e4389b8,
                    limb1: 0x85b8ff52d905fd02fe191c3f,
                    limb2: 0xf5d132d685201517,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x60c0ba1b358f375b2362662e,
                    limb1: 0x6abfc829d93e09aa5174ec04,
                    limb2: 0x7bc4637aca93cb5a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd3ff147ff0ee4213f51f677d,
                    limb1: 0x431366a7732a6e4a6b942255,
                    limb2: 0x9fe743b25d39a591,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7f8bb562ff60a902ef14bcb0,
                    limb1: 0xeb9420089fa531db62e806a6,
                    limb2: 0xfd028df433dfd5cc,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x46ae31f6fc294ad0814552b6,
                    limb1: 0x2d54cc811efaf988efb3de23,
                    limb2: 0x2a2cc02b8f0c419f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xaec889b9d8ce51c4a2c3586f,
                    limb1: 0xa2b07874c333bfee9f78e13e,
                    limb2: 0xc445de21be8d8709,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x1846d424c17c627923c6612f48268673, high: 0xfcbd04c340212ef7cca5a5a19e4d6e3c,
            },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x259f4329e6f4590b9a164106cf6a659e,
            },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0x5487ce1eaf19922ad9b8a714e61a441c,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xb2a60bc0dd8b8ee13a6c1fb1,
                    limb1: 0xd694821758e9d16d0d548853,
                    limb2: 0x6ba86041669b4d29,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x3ff4aad67ae0150cc663ba71,
                    limb1: 0x20491f6ec9a09b3a65f78e23,
                    limb2: 0x755517c39d1215c2,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_10P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x25d1a3c893718047539eb6e1,
                    limb1: 0x9b4041cff07fd2dbe9da2b60,
                    limb2: 0xd309a45be3d5092a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x30d69755292ed509791ee5a,
                    limb1: 0x5f4ea127722eae987f32fe53,
                    limb2: 0x591da7462a9198a5,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x2ae5492e7c640788f25d9247,
                    limb1: 0xe0c327d25b75d88ef0a263eb,
                    limb2: 0x6378fee63621654a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xfdd5c97a0eaaf1d76bc49ba9,
                    limb1: 0x6fc6dc7aa6a9ea75bbf1dbc,
                    limb2: 0xe0b69dabeddce211,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x6e4319cf45817544b4bd3e70,
                    limb1: 0xf042dc4ac606cb47341d59f4,
                    limb2: 0xc01a1b2c3961b092,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf5974a787c8b7db33323bc11,
                    limb1: 0x3d7dee392e99de8c61a5250d,
                    limb2: 0x8e1253c4a6653eb1,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x18783b840e510a80b1f61eb9,
                        limb1: 0x916aad7c5c3afd125d87d30d,
                        limb2: 0xffbf7713f04ebdd2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3af87e0dfe475a72a63bf678,
                        limb1: 0x72e78618b2b2263f2d59c8dc,
                        limb2: 0x44175ee83d8c0c86,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd88a71b8ffb0ca2969d48f93,
                        limb1: 0xbaf68e35eb1788674593a67e,
                        limb2: 0x6603fdc4a2518de0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc6343e35a9e5ea883e0f62bf,
                        limb1: 0x8a4168de0cd36609407d4160,
                        limb2: 0xe6174eaff4723582,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xce57855fad3ff7e570a4d7,
                        limb1: 0x832e894c46cf9569b38c27d9,
                        limb2: 0xf0aa092811f78a62,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x95a1a37890ca5bb22e63961b,
                        limb1: 0x927ab093878fc005c6ec79d8,
                        limb2: 0xb3a560d31e3dbcd9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf5be70a3e416fc97b910004e,
                        limb1: 0x14e5a9bdcbf55c749d0ab83,
                        limb2: 0xf2aea1a5c76ae606,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7cf810198cc2b283c9a7b49d,
                        limb1: 0x9196223e63bc38155b98ae58,
                        limb2: 0x64cde81aae3311a6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1f21559bb9485146ccb659c6,
                        limb1: 0xd18320c647ceee93eee3bc28,
                        limb2: 0xb5aceb377f15c542,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6067049ade175734b20bf3b1,
                        limb1: 0xcdd62d72ed614989a349c586,
                        limb2: 0xa83179886511cf4d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6d62b519a5e39b5cb5e8334c,
                        limb1: 0x31e7815a2b207a73bbbfefae,
                        limb2: 0x3a1d4c9e55edee58,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xb7941c4941766af24e4012c9,
                        limb1: 0x962d3321429cc01a1557e8d8,
                        limb2: 0x1e5ff6cf9837b874,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x454a7f6f3fe521749ee5e878,
                        limb1: 0x1b2ff57f37f05bd6a7b7058a,
                        limb2: 0xc0bc0338a7dbc76,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe02f4a10e904193e97f2067d,
                        limb1: 0x8bfb4f44c2772cc04c48148a,
                        limb2: 0x82b73d49c2424826,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x675ee4c2ba60b10a2c464a7b,
                        limb1: 0xe67d15a24cbbaec51144de02,
                        limb2: 0x9371a44820b515af,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb15a239bfd27bdaf4449f8e,
                        limb1: 0x7bf46be9a070200f9a2fb6e,
                        limb2: 0xb96430d1456fb3b3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8f58c3045e3f4b3a74bc8808,
                        limb1: 0x39d19930c1cc7e5c808325dc,
                        limb2: 0xe705811e051bc860,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3b3a649877eed87afa06600c,
                        limb1: 0xf20257210d403079b838b287,
                        limb2: 0x153214fc79048352,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6a2280ec6adc1eae811ca2b7,
                        limb1: 0x493c782bbb261e0f1d626b00,
                        limb2: 0xaf6b3fcf8184f7aa,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa857f8bf59953a96bf47cdb3,
                        limb1: 0x83ea3353c9390146d945d270,
                        limb2: 0x30309fa08e91cc89,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x725e3cdf7d683fdbe2972b59,
                        limb1: 0xb6d0d8d6a47a550468caeae2,
                        limb2: 0x32f6672ca26aa471,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6e187b5f20d022bdd9722fff,
                        limb1: 0xa97841b7c56a8a307537a2ff,
                        limb2: 0x1d99bd4414644830,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xf7780aa1a6a57a6269163a09,
                        limb1: 0xd831e8a8cb25935ae27c2b52,
                        limb2: 0x3fa707d158fc6f5a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6249a4fa79efde0c10f813ee,
                        limb1: 0x76b4e5c5f9ecdbf3c7972c3d,
                        limb2: 0x5737bf41d6b5cc25,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x701cce382949545c4dbfb21b,
                        limb1: 0x10ae57a4d81689042a14b759,
                        limb2: 0x30ba0339d09b7199,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa612d84dd5bc00495a11d7b4,
                        limb1: 0x2d267a2e897320b83f985a01,
                        limb2: 0xdb7945fdf37c8a1d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x21a74bab10a853378dc76737,
                        limb1: 0x183ebc9a53d1c5470523d7eb,
                        limb2: 0x18105aac93cec5ba,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb72986756831e48a51e9e29e,
                        limb1: 0x88b4d14dc1bc39766c03508a,
                        limb2: 0x33d26771820d5eb5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7957572d6e3012f9c543fdf4,
                        limb1: 0xb62bb2bdc5ffe0def7d0e7f3,
                        limb2: 0xf29b7464230b0363,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6244a8a148f1359aef7f8dd9,
                        limb1: 0xfd755fa4bc962afcd1cf30a5,
                        limb2: 0x7df7f680c4efd89e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdb5996ca2e0b75ca84fbb923,
                        limb1: 0x8dc1dd7aba927975f1cc8c93,
                        limb2: 0x6ca541359707d575,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1f189286d703f6112e3a65a3,
                        limb1: 0xffaec7f3d5170182bde41763,
                        limb2: 0x177445275cf06d37,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf29f37ae81b353e4ff081e54,
                        limb1: 0xce1bf4b3dc7b7adde4ec8636,
                        limb2: 0xbeee0e15b0a62207,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xca4131c9e1a7ce44c20654e4,
                        limb1: 0xcf285b17fc86cb52bd8be21b,
                        limb2: 0xaaaacd9c4f8d33e1,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x468ea597e4d3de7bc66b89cc,
                        limb1: 0x8936a8404a2ec78409c799c6,
                        limb2: 0x3f07039153a133f9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa656e9bbcc709030190a59e5,
                        limb1: 0xcf0e9849bf51c2c2bb4a3389,
                        limb2: 0xe69edd8c1b9aa64,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x38fd28913548ae96bf49205a,
                        limb1: 0x1c8716a071f3222038ddecff,
                        limb2: 0x5666387bb156f7cf,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9fa3ab330c10e5f453818957,
                        limb1: 0x287cc0db05713d24dc078d2f,
                        limb2: 0xeb04283d10d13cdc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x47768825f3ca708bb062a8c3,
                        limb1: 0x6a2611a29f47fe9a9ae328dc,
                        limb2: 0xab0d507c80f03465,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9ea968f3b3ecf751b3daae22,
                        limb1: 0xd701d508961a63e6dade1618,
                        limb2: 0xd798949899c472d5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe28e108f80fd5a27854b419a,
                        limb1: 0xe1d143cd4bece57d80ec7096,
                        limb2: 0xeefb65efb2481ea4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x277eef526fdb3d8162d60a0c,
                        limb1: 0x491395c830384483de7eb9ce,
                        limb2: 0xed791025dc519807,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x77abd5504ea054894d89ae37,
                        limb1: 0x9fe810854c2d9265bdf2d225,
                        limb2: 0x178f1b4b7d2bea99,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6089f2e0e0adf2b0b7ae4410,
                        limb1: 0x1148a4e6a1326d0cd86253fd,
                        limb2: 0x7dadf2538ba7a069,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2e4a6ebf98a381903b1f0d18,
                        limb1: 0xfe06b085faa734d315a65f52,
                        limb2: 0x525262d450cb77c4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2a62379832f30e9b5ac39e01,
                        limb1: 0x3b6d2b81ef91e971debbf023,
                        limb2: 0x32299dacfb9f87df,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x725e3cdf7d683fdbe2972b56,
                        limb1: 0xb6d0d8d6a47a550468caeae2,
                        limb2: 0x32f6672ca26aa471,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6e187b5f20d022bdd9722fff,
                        limb1: 0xa97841b7c56a8a307537a2ff,
                        limb2: 0x1d99bd4414644830,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xa36bdee3b2de39ccc87aab3b,
                limb1: 0x1d24bed7e1b562486a9e8fbc,
                limb2: 0x2b060face89cccda,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x37cec7561349bd53ad1bb5af,
                    limb1: 0x5f9600122670117fa09d06d0,
                    limb2: 0xfe3876259c50320,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0xba653f1c5b50436b97a42c5c,
                    limb1: 0x78ed8fe1c682d789effc44d8,
                    limb2: 0x4b0c454044ba9294,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x22f2f9953d5b3b7ef1c60d31,
                    limb1: 0xbaeeb9b7d5a4c1d0ab458e09,
                    limb2: 0x7ba81189bb9ba8a2,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x113c8d620e3745e45e4389b8,
                    limb1: 0x85b8ff52d905fd02fe191c3f,
                    limb2: 0xf5d132d685201517,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x60c0ba1b358f375b2362662e,
                    limb1: 0x6abfc829d93e09aa5174ec04,
                    limb2: 0x7bc4637aca93cb5a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd3ff147ff0ee4213f51f677d,
                    limb1: 0x431366a7732a6e4a6b942255,
                    limb2: 0x9fe743b25d39a591,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7f8bb562ff60a902ef14bcb0,
                    limb1: 0xeb9420089fa531db62e806a6,
                    limb2: 0xfd028df433dfd5cc,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x46ae31f6fc294ad0814552b6,
                    limb1: 0x2d54cc811efaf988efb3de23,
                    limb2: 0x2a2cc02b8f0c419f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xaec889b9d8ce51c4a2c3586f,
                    limb1: 0xa2b07874c333bfee9f78e13e,
                    limb2: 0xc445de21be8d8709,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x7e47d1c2d19c21b2f6870259,
                    limb1: 0xe701b40af42001c38bca00db,
                    limb2: 0xd87ea1720d4dd3d6,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5b1d6cc74985ce49a1f737fe,
                    limb1: 0xb9127c572c3f091c031c249c,
                    limb2: 0x1392711e1576aa6f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xb71f95ea692ed186e06e4c37,
                    limb1: 0x807276cd9cc59718bb11dbe9,
                    limb2: 0x10756a25836d67ca,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xd34211b3520c83c5f9be99af,
                    limb1: 0x8f19a28ceef67bbda102ffe7,
                    limb2: 0x7ac2b92030d351cc,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x411bb5d0fbe844f025c7178c,
                    limb1: 0xcf603787227b7ac499d6d1c4,
                    limb2: 0x5f6b2479862eb2f8,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xce60303cfcb98726ff64a1e5,
                    limb1: 0xa64534c614754b3527588d25,
                    limb2: 0x44f75e245622181,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x8a703177da18d4ede707c057,
                    limb1: 0x7d6c11e754ab6fbe73deea43,
                    limb2: 0xdf9787168190a047,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x2e6585ab5f125a34fef37875,
                    limb1: 0xb70e9f02ce7744197172a117,
                    limb2: 0x60e305f9fe6f2298,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x712f72f3929408ff68af059d,
                    limb1: 0x4f72cea12cd115dc1c8639f5,
                    limb2: 0xc6d5ae1b897ffe77,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xfcf91f56bad0659142668837,
                    limb1: 0xa15458b49bcdad6c870e3889,
                    limb2: 0x81a1342e70b1b765,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x461d7579f9613d3168fc6220,
                    limb1: 0x7626024a6195fe0eafcea08b,
                    limb2: 0x32e91b268a032443,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xcdc7ae298071a741aafd4035,
                    limb1: 0x9a9bdfbdb824dc1278457a10,
                    limb2: 0x17fbec3713dfd145,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb5d32b1666194cb1d71037d1b83e90ec, high: 0xa0116be5ab0c1681c8f8e3d0d3290a4c,
            },
            u256 {
                low: 0xd3fbf47a7e5b1e7f9ca5499d004ae545, high: 0xbaf3897a3e70f16a55485822de1b372a,
            },
            u256 {
                low: 0x101fbcccded733e8b421eaeb534097ca, high: 0x38c1962e9148624feac1c14f30e9c5cc,
            },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0x1759edc372ae22448b0163c1cd9d2b7d,
            },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x7d41e602eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x552f233a8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x8c1745a79a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x5129fb7c6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x870e15c2fcd81b5d24bace4307bf326,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x617117bf1151fd79fc71b779,
                    limb1: 0x4e2f6459c4115850de36db63,
                    limb2: 0x3e7e9f9d44a05b03,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf05f55006d626fa5d91a695d,
                    limb1: 0xd2cf263e6037971f0c923d96,
                    limb2: 0x5cffe1dc97fa2157,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_11P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x396217fb094172485ed71701,
                    limb1: 0x86d8b0c7d1a5e4c7a5f9bc6d,
                    limb2: 0x71f625cb03b8ef6e,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe98177c6d14f501e14485170,
                    limb1: 0x1a7ca5a7ace37e332a4c11f6,
                    limb2: 0x983fcff92b02e21,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xb2a7ea53b9538de66e7e743,
                    limb1: 0xd60f5b3e71a8f46db68ceef2,
                    limb2: 0x9c1ad67a074850c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x2dd4f91dabff063662e0d3a3,
                    limb1: 0xf06ae0503f3f8ea7bde84f8e,
                    limb2: 0x5e760d2ef3c9e447,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x2f71d6eb303b3bf480fc702d,
                    limb1: 0x68910d569e6682c2fa1032ee,
                    limb2: 0x82845286591c8fd2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x73d8aa453b7a7f95d4951130,
                    limb1: 0x73e64c911c98638f780f7279,
                    limb2: 0xee21dbae9f50d5d7,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x5b43dead7c65ea98ccbc2312,
                        limb1: 0x9ebf6071884aef4be20dbb49,
                        limb2: 0xcc075f01a5ea7905,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8f341214716c7cb17fa697a1,
                        limb1: 0x442e4a02d84c48ff8e6aac5,
                        limb2: 0xf5b9d926250bb677,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfe802087433fa7d6b14f9760,
                        limb1: 0x117c80fadea0d2aaa9ff3f7f,
                        limb2: 0x589397cb421dbfae,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf951e47ed9e72c3d1130590c,
                        limb1: 0xa65e0872b29b1c0c9b0a3e89,
                        limb2: 0xa11a256d36a40010,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7c33d5664fbac990d120e65d,
                        limb1: 0xc9f28026503f21ad0560ef9a,
                        limb2: 0xb84107bb212b89f2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4006e68fdb6f9682265b2867,
                        limb1: 0x85c0b9e2b6a8b25b664c53b5,
                        limb2: 0xfeed2b06f6a88196,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x527ae201f9e17ea928ca54d1,
                        limb1: 0x2aabfbf74df6a42c387e75cb,
                        limb2: 0x423029c5db06b3ad,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa8d26ecae02f354edda2b195,
                        limb1: 0x8dc6849ba01b7c59c4b36ccb,
                        limb2: 0xd94ecd291fdaeb33,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa81bb716ebb4879fcd366809,
                        limb1: 0x8b23d814a61765ec50a7b97e,
                        limb2: 0x1f8e392eb422c09,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf8c81e965c463ddf19204654,
                        limb1: 0xfd226d397f3e62db4187e9aa,
                        limb2: 0x1b9cd28544e2b2e7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x81c7c8843186f5cc9ca92d0b,
                        limb1: 0xc1a5f270f0111329e609647d,
                        limb2: 0x6f6fefa0d8cb0374,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x798667c33aa4fa51b1534ffa,
                        limb1: 0xae7a5b2c9c3803f67d94a22f,
                        limb2: 0x6feb69d2c7a8c219,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x9e931b5525c73cd842af75f1,
                        limb1: 0xabf5875c1edcba891053689a,
                        limb2: 0x6e9a79cb841b9239,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc40b58faac5eb4486a6fc73d,
                        limb1: 0x6841e347269a398ba4a134ba,
                        limb2: 0xf38d14a0132c2b9c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x26862957dc293a92353b00a0,
                        limb1: 0xd0ff27beb3b75a810043b700,
                        limb2: 0xf7535c57e1283f9a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x69aa124dca994cf366d3838a,
                        limb1: 0x2aeb9d3dbc40f1f6c445bd9d,
                        limb2: 0xbedee89854bb95b1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa9ef9fbb104f01fdb70327c0,
                        limb1: 0xc25b7d667900531fe553b8a1,
                        limb2: 0x7f9dfe45ff266ec4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x95c690e1e54ed97bd58236d4,
                        limb1: 0xdf765f4aee023fd99c8f39c8,
                        limb2: 0x516b23c9b8d0e7c8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x119a86a7f3aa39cae97f77fe,
                        limb1: 0x5de7700696e2c13b71ae9a5c,
                        limb2: 0xa07f83f793ba613e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbaf39c2e9ef6de6ecb985127,
                        limb1: 0xe8df9b6099aec9c09cd86846,
                        limb2: 0x80cbc86c17e00579,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x112b8a49f760ad0c6693c819,
                        limb1: 0x2467467c969b79e80bc91f01,
                        limb2: 0xa4f9b073748970e7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x88262d83e9378fe0954de545,
                        limb1: 0x23765643c094e5c97c84ba20,
                        limb2: 0x8082d4e9745c4911,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8526a7351189b50070afeba,
                        limb1: 0xc1978bf96a07b0b8332c25f4,
                        limb2: 0xcba1944ccd956fe5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1d8f0f54cd2b66747d49ea46,
                        limb1: 0xfe79b6accf8be0b472f6f202,
                        limb2: 0xf622362e5706004f,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xff7b1d4b4475a219f7b51cfc,
                        limb1: 0x1b7ac389edffd607397c367e,
                        limb2: 0x92d64b4f9dfbb889,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x18d318de778fb65427ac72a5,
                        limb1: 0x9e69f420b1c9392318339209,
                        limb2: 0xb2caaf2d41662950,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbee6267bcefed599fffcaaec,
                        limb1: 0xe8a9a16294781446ae1724c1,
                        limb2: 0x96694349f365ce96,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe14d705f78a00b747f40052c,
                        limb1: 0xd0792ab4c582f8b8f790e27c,
                        limb2: 0xdcabf614e0d72d08,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbec6e0ee3696ffa3c9006976,
                        limb1: 0x3694189e57e16288c36f7f50,
                        limb2: 0x8dcb42063b7d1367,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xde861e54940f99c496d4ae53,
                        limb1: 0xe43768be7282e166995a7767,
                        limb2: 0x5d4fe5e2ef8f93dc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x904395d30763a609da03bede,
                        limb1: 0x8e3503557c00cdd781da11d9,
                        limb2: 0xc857beae1a7f82f4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3eed73b2d48a10c34804c73,
                        limb1: 0x3584195ef40e1853ead3a3fc,
                        limb2: 0xfde044925cc7bb96,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe76a7f0dc5a786b60262921b,
                        limb1: 0xfbddb75924d2e9b5d2db47ad,
                        limb2: 0x9ec0e9ad8d63430e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc62c7f347bdf461aed81c065,
                        limb1: 0x26d2ff6490102b059d7f035c,
                        limb2: 0xe30656515c1eb0b3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe351ede2c9119da3ec8a0417,
                        limb1: 0xd5857540b70bb98e5e4c9c5d,
                        limb2: 0x8bfa6c92b7f53c40,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8bb579f8b822e4375f7b8f74,
                        limb1: 0xa83a723a54550155e0bcc5fa,
                        limb2: 0xa0ae383534223b37,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1f939a57a0f100b6d56ffdef,
                        limb1: 0x7b80f15e8b41dc8d58de119d,
                        limb2: 0x954e6d0266da1c23,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x941f20bfad0184a26df4347f,
                        limb1: 0x8df53aa1361817ad6d89350d,
                        limb2: 0xec401f870d3b72fe,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa346eaf82a64114c4db1b241,
                        limb1: 0xe63c793cee8d93d643eb58b5,
                        limb2: 0x7fbf1dfd819dbb10,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xee172e52c81c0edb444976b9,
                        limb1: 0x7ac1bc406ed74482f72924f2,
                        limb2: 0x8ba356a2d101eba3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x77b94c9e7404be5ce6c445dd,
                        limb1: 0x8b9ab52baf7d36489a5ddde4,
                        limb2: 0xa008087da733ca66,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbd6f0fa4eb0d7f5ac2b9ff49,
                        limb1: 0x5337556532318900ba3e7e63,
                        limb2: 0x20dc39209f3cfb3b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xde723640217e0086e4c4b70a,
                        limb1: 0xb4f9a3622783eb45de1d2db7,
                        limb2: 0x3d2771e797228e07,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5843508b43df60725f1510e5,
                        limb1: 0x4f39f5229c57841ad72f34f1,
                        limb2: 0x5ebae739f32ba4bc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x38f2780226655da345285772,
                        limb1: 0x90c4fe97b531cc910a7a5ac8,
                        limb2: 0x400bf4f11729443b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb170fa317a87b881a8176224,
                        limb1: 0x9101c644b36f79f66654d643,
                        limb2: 0xc651060573f40ac7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb5348a10665ff677833850cf,
                        limb1: 0xf0e0ce9feddb09ad04641378,
                        limb2: 0x7b2ef41d7872fda9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8d3d2fa06bad404f38a8b74a,
                        limb1: 0x104599949efb24b0cf844537,
                        limb2: 0x79320477f3b9730e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x19c1e90fa0229b37f6434e24,
                        limb1: 0xeb8710fb199cca4ea9c54d1e,
                        limb2: 0xff07d4bbc68d3917,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfbccb07bbd8398c1454286bb,
                        limb1: 0xdbf4ef92c889ca6888bceacd,
                        limb2: 0xf8e268341984dc0b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8526a7351189b50070afeb7,
                        limb1: 0xc1978bf96a07b0b8332c25f4,
                        limb2: 0xcba1944ccd956fe5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1d8f0f54cd2b66747d49ea46,
                        limb1: 0xfe79b6accf8be0b472f6f202,
                        limb2: 0xf622362e5706004f,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x728937c331f0e317e2c0c291,
                limb1: 0xf4c42e9dea42934af6e9bafe,
                limb2: 0x175301903d6c10b7,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xd74e9ca0de0647951d260796,
                    limb1: 0x299388cd8bede92bf915fed3,
                    limb2: 0x21a63bc411cd2784,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x2ccba3a81218419485459fb,
                    limb1: 0xc5854ba32cbafaa6114c4e06,
                    limb2: 0x4ca9990c51d8a6e9,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x113c8d620e3745e45e4389b8,
                    limb1: 0x85b8ff52d905fd02fe191c3f,
                    limb2: 0xf5d132d685201517,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x60c0ba1b358f375b2362662e,
                    limb1: 0x6abfc829d93e09aa5174ec04,
                    limb2: 0x7bc4637aca93cb5a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd3ff147ff0ee4213f51f677d,
                    limb1: 0x431366a7732a6e4a6b942255,
                    limb2: 0x9fe743b25d39a591,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7f8bb562ff60a902ef14bcb0,
                    limb1: 0xeb9420089fa531db62e806a6,
                    limb2: 0xfd028df433dfd5cc,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x46ae31f6fc294ad0814552b6,
                    limb1: 0x2d54cc811efaf988efb3de23,
                    limb2: 0x2a2cc02b8f0c419f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xaec889b9d8ce51c4a2c3586f,
                    limb1: 0xa2b07874c333bfee9f78e13e,
                    limb2: 0xc445de21be8d8709,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x7e47d1c2d19c21b2f6870259,
                    limb1: 0xe701b40af42001c38bca00db,
                    limb2: 0xd87ea1720d4dd3d6,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5b1d6cc74985ce49a1f737fe,
                    limb1: 0xb9127c572c3f091c031c249c,
                    limb2: 0x1392711e1576aa6f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xb71f95ea692ed186e06e4c37,
                    limb1: 0x807276cd9cc59718bb11dbe9,
                    limb2: 0x10756a25836d67ca,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xd34211b3520c83c5f9be99af,
                    limb1: 0x8f19a28ceef67bbda102ffe7,
                    limb2: 0x7ac2b92030d351cc,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x411bb5d0fbe844f025c7178c,
                    limb1: 0xcf603787227b7ac499d6d1c4,
                    limb2: 0x5f6b2479862eb2f8,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xce60303cfcb98726ff64a1e5,
                    limb1: 0xa64534c614754b3527588d25,
                    limb2: 0x44f75e245622181,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x8a703177da18d4ede707c057,
                    limb1: 0x7d6c11e754ab6fbe73deea43,
                    limb2: 0xdf9787168190a047,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x2e6585ab5f125a34fef37875,
                    limb1: 0xb70e9f02ce7744197172a117,
                    limb2: 0x60e305f9fe6f2298,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x712f72f3929408ff68af059d,
                    limb1: 0x4f72cea12cd115dc1c8639f5,
                    limb2: 0xc6d5ae1b897ffe77,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xfcf91f56bad0659142668837,
                    limb1: 0xa15458b49bcdad6c870e3889,
                    limb2: 0x81a1342e70b1b765,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x461d7579f9613d3168fc6220,
                    limb1: 0x7626024a6195fe0eafcea08b,
                    limb2: 0x32e91b268a032443,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xcdc7ae298071a741aafd4035,
                    limb1: 0x9a9bdfbdb824dc1278457a10,
                    limb2: 0x17fbec3713dfd145,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x9b85054533e9d24310265ee0,
                    limb1: 0x51cbb79b2625c435ba43bbef,
                    limb2: 0x1fd81fcb136c629b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x96378a2e47ab50246a9cf131,
                    limb1: 0x4d0f08867537268cf39eae04,
                    limb2: 0x4eeb60396f3e5f52,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xd3fbf47a7e5b1e7f9ca5499d004ae545, high: 0xbaf3897a3e70f16a55485822de1b372a,
            },
            u256 {
                low: 0x101fbcccded733e8b421eaeb534097ca, high: 0x38c1962e9148624feac1c14f30e9c5cc,
            },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0x1759edc372ae22448b0163c1cd9d2b7d,
            },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x7d41e602eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x552f233a8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x8c1745a79a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x5129fb7c6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x870e15c2fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0xadc0da7a16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x148b2758d7ab792809e469e6ec62b2c8,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x8bb75ba627234dc63e79a70b,
                    limb1: 0xf80598ab2773419027b1531f,
                    limb2: 0xcf5ff5f040bbf9f9,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x74e9046434afc5dcf31ffcca,
                    limb1: 0x7a10638d5630b338c33f51f4,
                    limb2: 0x581c177d075c1692,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_12P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x63c70f94dcf043039d5b06fd,
                    limb1: 0xaea5b5d016d780fc3268e4c0,
                    limb2: 0xaab7cc308e570714,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x2ccddde18a7ebaea35b7e5a6,
                    limb1: 0x77890d800c548f0895b91ba5,
                    limb2: 0x38f62d852b001d58,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xb8703d4eb1e2bfd5d9961829,
                    limb1: 0x1842a9aca84733324c506a00,
                    limb2: 0x4d0d88487505dfdb,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x3ed04afc6933b3f7805988f7,
                    limb1: 0x52d3fe01f66a332d0085908c,
                    limb2: 0xfdb0892e58dcbc1b,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xa03532a10c75403f0d217fb8,
                    limb1: 0x3e4656ee3a4f973d11c76c19,
                    limb2: 0x29c888c3b44f0160,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x3a168c8dac103d557d99273,
                    limb1: 0xf0dc9ffb09bdf06ec71bc3ad,
                    limb2: 0x9acb520c6222d492,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x5e0e35cf57f429925396b22a,
                        limb1: 0xfbc747ef3623ebe10088dd4,
                        limb2: 0x9f2c62f3ed82ea23,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1f49f0e347e86caceb5638f6,
                        limb1: 0xd0e33c1d59bc0b50a4b909ff,
                        limb2: 0x3c59f6937bc979b0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x511aa58e8f10261b3f9da79b,
                        limb1: 0x636f28e0b30e734474e1fa98,
                        limb2: 0xa9c813bf744ae154,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcf1f2ee3da521c79ebf539f8,
                        limb1: 0xdef4738a892d89f76d6683f3,
                        limb2: 0xb35f68bda8391af,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x59af5cb1b9933d283e796d75,
                        limb1: 0x8d16c6407a09c56cfaac686f,
                        limb2: 0xc9336e2e6cad0d5d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x64db07d816b52730a3b18ba0,
                        limb1: 0x71cd99a3cb57f37d36f87afb,
                        limb2: 0x6ac3ad562fe31d33,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeffde34f92e6c8a43d6ce468,
                        limb1: 0xd2524db4ead9560e868c26ea,
                        limb2: 0xb064ba32486a641d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x90a782679875c97089cb1705,
                        limb1: 0x3d08e4c4fbbefb1c993bad32,
                        limb2: 0xf93d10e17ef4a5e7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4830938921feb8be81ba4ce5,
                        limb1: 0x6db6b4217ed67161edb59be4,
                        limb2: 0x503514f6dfcdb951,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xabd36bc9d5ef45e41ea86f9e,
                        limb1: 0xc72d45d0c2ec75c8df97a3ef,
                        limb2: 0xd746b72e83b0b9c8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xad287cc8f5e520cc3bb456ed,
                        limb1: 0x573017dc5907a402599c34e,
                        limb2: 0x5d794378e142445,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x59c976d14fc2ee27661e2f0d,
                        limb1: 0x2759e1ac470a2032e7ee3bab,
                        limb2: 0x9b57c5e636591a0c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1f7f2f797e70e2557bfd58b2,
                        limb1: 0xe873f81a3d93383097ad1c5b,
                        limb2: 0x2c0c09e76d922149,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xc6e2d83c3c62034eb89b11b4,
                        limb1: 0x8c22943bd9f5d99ddcb92e2,
                        limb2: 0xde88d2cbc52310be,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x92204ed8c1c804b6232a825a,
                        limb1: 0xf4812d9fc84fade1270cdc7b,
                        limb2: 0x2ff64e8ab996c214,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5dfe9f4cc01db63be10aca45,
                        limb1: 0xf2c8ff40fc0f537d6759e14a,
                        limb2: 0xd88bb825f41da256,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8567fb39257fa9d5efb733dc,
                        limb1: 0x60d78d59586ea7241badffcd,
                        limb2: 0xf740316549d820a5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd3881aab6ebc02474f77d892,
                        limb1: 0xade274e2a453b0e33e617496,
                        limb2: 0x9192b54fd304ceb7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4039058624067149bc7466,
                        limb1: 0x4dd5ca3214d418853f6a0501,
                        limb2: 0x66b2ea4e882320b0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x84bbf80d53a7189ea03900c0,
                        limb1: 0xca50ec872a12c935c32905fe,
                        limb2: 0xf377e18626b8c35d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x39b95c95c374bd6c6e63f17c,
                        limb1: 0x139179d6bfae5add96458cae,
                        limb2: 0xf6e91eecc1fce8e2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd8b4f48c9783c42470c30897,
                        limb1: 0x6533e9a01c8d593bac99418e,
                        limb2: 0xba1826d2f8a9a2d1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x729d11f0edb140c9d3e4c730,
                        limb1: 0x8cbdd00e15c622d18443c326,
                        limb2: 0x3166e3687e0c88ea,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdecf4a4efc4ccb94a97a4ce0,
                        limb1: 0x8cdd156d9a3f9e1cc90ecc58,
                        limb2: 0xea3d1d228489a0e5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc59a3f14b4701e6953c4ef25,
                        limb1: 0xfea883f8c414a012611672b6,
                        limb2: 0x54390333e2faa173,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x86879c87a4abbac628cda084,
                        limb1: 0xfdc91440d17c1a950d683aee,
                        limb2: 0x52c65cc23b04d7bd,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x5c7a1c33f3310fe4300109a4,
                        limb1: 0x31c1c1621a27c167ac80f8ff,
                        limb2: 0x3dbf2f32847d5a5d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x74261a1473ad43b568a4d86b,
                        limb1: 0x236c40e5236e9535796d9d0d,
                        limb2: 0x7f1362dd1179ebdd,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x26129fe49ee4acffbc39266,
                        limb1: 0x250bdb0c3982aeb8b9c52fe4,
                        limb2: 0x40d79965e048efdc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa019a3a638f34de5a8965732,
                        limb1: 0x73409552833f9beebcd77d2d,
                        limb2: 0xb49fe9249058a063,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9a3d09a3efec4e720146cb4a,
                        limb1: 0x38c05e93674950449a256dc9,
                        limb2: 0x3f4464e643508182,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe0ec7f3746fd833763ff3869,
                        limb1: 0xc526e6bf2c5ae3fa754440b7,
                        limb2: 0xc2263fe9436d8238,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9ea14702bb4df8f6b7f21341,
                        limb1: 0x565d68df22f1deee3fbfb4cc,
                        limb2: 0xbfceec57c00aa92,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x880c59687bc85e88104a8c6d,
                        limb1: 0x7da9dffe4ce096c404a7997c,
                        limb2: 0xe7ed89c27d74ab9d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9e6e818239557ac9a79fed7e,
                        limb1: 0x4b7ebc1eac198afa58fcd54f,
                        limb2: 0x8adac28de8bffdfa,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x234f3310b67bf69a2194bff1,
                        limb1: 0x3c54a5bb9b620b3f688f7670,
                        limb2: 0x5a7dfc32fe6a8a3c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa5fdb328c1a7f9250113798,
                        limb1: 0x4b383f8c9a8293d7f674106,
                        limb2: 0x7cf6ed7d7c0c6c09,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xaac21cc39f82c284c53e1ac1,
                        limb1: 0x135fc1c7386227076df82c15,
                        limb2: 0x17f738e974b9333a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x495459197825e901c3ec3883,
                        limb1: 0x5290f46ab30fe547c785720e,
                        limb2: 0x96ef0e9e01ade446,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8ac15ea4119a081606a0e3de,
                        limb1: 0x8533d932cadfbf624f3a27aa,
                        limb2: 0xbf998a558b9db190,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x9f05dc5d470f5c9e6290e154,
                        limb1: 0xba0c8ee1714c34986191002f,
                        limb2: 0xc42a80bff61f4d12,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5f8293d6f1bee7fe9b06eaa7,
                        limb1: 0xc68a27ce0a1db20cd07a7912,
                        limb2: 0x5a06efc12fa0faca,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9083633aeb0b02cf00aa1994,
                        limb1: 0xa7a3f08999e675cf48e5df43,
                        limb2: 0x62a4c4ae302be59,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xed931f13d4f3fb6c5275d29a,
                        limb1: 0x3a945a206381b33bb84a24b0,
                        limb2: 0x2af92f88458fabcc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x83225f961e7849c657397985,
                        limb1: 0x9200ae7fddf126bfd02f9140,
                        limb2: 0xc371922c72a34e09,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xadf2a24115d8fcacaa5b2d5f,
                        limb1: 0x17f158df2b582c97def91095,
                        limb2: 0xbf6bb1531176f2a9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x377287608080562576f402f8,
                        limb1: 0x3210a613ea42624cb0eceb2c,
                        limb2: 0xc7ced8560e7e05d8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5569d24409fc20f1b88bd15b,
                        limb1: 0xa37add23d7c1450842093f8a,
                        limb2: 0xee73bfc63c2abc9a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x737b5d8876926a0de12169a8,
                        limb1: 0xe7a8226f6fd8e8a43f5b283d,
                        limb2: 0xda87e523d568b952,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7d43a9fb2994daf6cf41e2de,
                        limb1: 0x2282200387e1ce60d91318d8,
                        limb2: 0xa55fe3cb80f2e5b2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdaccf548e71627abdfe988f,
                        limb1: 0xc02f814fe220b8c6a76dce9c,
                        limb2: 0xbc6b046ec3a18fa0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc0b2d0e5ae95910ff3308d7f,
                        limb1: 0x944e6c1a67438c5ca5ba7988,
                        limb2: 0x765d8cd545e96f6d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7f10412db0a83643bda37082,
                        limb1: 0x5f0d1a1a47153c987e6b3d0b,
                        limb2: 0x3dd4b5a101fee7c0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x178c25ae4a17d78056e3cb9f,
                        limb1: 0x476d96009c63d51a05f3223e,
                        limb2: 0x4cb03cb47db5ad93,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc59a3f14b4701e6953c4ef22,
                        limb1: 0xfea883f8c414a012611672b6,
                        limb2: 0x54390333e2faa173,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x86879c87a4abbac628cda084,
                        limb1: 0xfdc91440d17c1a950d683aee,
                        limb2: 0x52c65cc23b04d7bd,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x51b092f473a847f3fe883430,
                limb1: 0x14ac7c9defb67b39cec4fa29,
                limb2: 0x62802a4ff11935e6,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x80829f83f1e0a0bc5a900efe,
                    limb1: 0x7baa3eecb3a2da9d8e428675,
                    limb2: 0xf644d29dcbb96b8,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x63e510c507762055f7a31794,
                    limb1: 0x7591a061cc81a9d2e1e940b3,
                    limb2: 0x8b7e896e0f143bd,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x8dd572f508a4297974cd2e31,
                    limb1: 0x9167ced8f744d149d51d4afe,
                    limb2: 0xba4da59074cb098,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x5ad6d1393cfe577e5d2ba30a,
                    limb1: 0x49ec800b44b25b88a8b69bce,
                    limb2: 0x17a9dc91e727bd78,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0xe279da393a00bc39a643465c,
                    limb1: 0x6418a054094a38df754e5b,
                    limb2: 0x18263d7bdc45805a,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x113c8d620e3745e45e4389b8,
                    limb1: 0x85b8ff52d905fd02fe191c3f,
                    limb2: 0xf5d132d685201517,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x60c0ba1b358f375b2362662e,
                    limb1: 0x6abfc829d93e09aa5174ec04,
                    limb2: 0x7bc4637aca93cb5a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd3ff147ff0ee4213f51f677d,
                    limb1: 0x431366a7732a6e4a6b942255,
                    limb2: 0x9fe743b25d39a591,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7f8bb562ff60a902ef14bcb0,
                    limb1: 0xeb9420089fa531db62e806a6,
                    limb2: 0xfd028df433dfd5cc,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x46ae31f6fc294ad0814552b6,
                    limb1: 0x2d54cc811efaf988efb3de23,
                    limb2: 0x2a2cc02b8f0c419f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xaec889b9d8ce51c4a2c3586f,
                    limb1: 0xa2b07874c333bfee9f78e13e,
                    limb2: 0xc445de21be8d8709,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x7e47d1c2d19c21b2f6870259,
                    limb1: 0xe701b40af42001c38bca00db,
                    limb2: 0xd87ea1720d4dd3d6,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5b1d6cc74985ce49a1f737fe,
                    limb1: 0xb9127c572c3f091c031c249c,
                    limb2: 0x1392711e1576aa6f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xb71f95ea692ed186e06e4c37,
                    limb1: 0x807276cd9cc59718bb11dbe9,
                    limb2: 0x10756a25836d67ca,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xd34211b3520c83c5f9be99af,
                    limb1: 0x8f19a28ceef67bbda102ffe7,
                    limb2: 0x7ac2b92030d351cc,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x411bb5d0fbe844f025c7178c,
                    limb1: 0xcf603787227b7ac499d6d1c4,
                    limb2: 0x5f6b2479862eb2f8,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xce60303cfcb98726ff64a1e5,
                    limb1: 0xa64534c614754b3527588d25,
                    limb2: 0x44f75e245622181,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x8a703177da18d4ede707c057,
                    limb1: 0x7d6c11e754ab6fbe73deea43,
                    limb2: 0xdf9787168190a047,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x2e6585ab5f125a34fef37875,
                    limb1: 0xb70e9f02ce7744197172a117,
                    limb2: 0x60e305f9fe6f2298,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x712f72f3929408ff68af059d,
                    limb1: 0x4f72cea12cd115dc1c8639f5,
                    limb2: 0xc6d5ae1b897ffe77,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xfcf91f56bad0659142668837,
                    limb1: 0xa15458b49bcdad6c870e3889,
                    limb2: 0x81a1342e70b1b765,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x461d7579f9613d3168fc6220,
                    limb1: 0x7626024a6195fe0eafcea08b,
                    limb2: 0x32e91b268a032443,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xcdc7ae298071a741aafd4035,
                    limb1: 0x9a9bdfbdb824dc1278457a10,
                    limb2: 0x17fbec3713dfd145,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x9b85054533e9d24310265ee0,
                    limb1: 0x51cbb79b2625c435ba43bbef,
                    limb2: 0x1fd81fcb136c629b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x96378a2e47ab50246a9cf131,
                    limb1: 0x4d0f08867537268cf39eae04,
                    limb2: 0x4eeb60396f3e5f52,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x4e9960d402494fb117251955,
                    limb1: 0xc0fb055de656d6ac2ba4da86,
                    limb2: 0x800a21e8619f448f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x21ba9af739425b664464e3d5,
                    limb1: 0xd09194888c2ffcf16e93e0c9,
                    limb2: 0x5d4d3cd0684b6cd1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x101fbcccded733e8b421eaeb534097ca, high: 0x38c1962e9148624feac1c14f30e9c5cc,
            },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0x1759edc372ae22448b0163c1cd9d2b7d,
            },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x7d41e602eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x552f233a8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x8c1745a79a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x5129fb7c6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x870e15c2fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0xadc0da7a16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x148b2758d7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0xd450fe4aec4f217bb306d1a8e5eeac76, high: 0xd67e55fd642bfa42aef9c00b8a64c1b9,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0x37176e84d977e9933c49d76fcfc6e625,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xef4b4e197306579c6764d18d,
                    limb1: 0xcad67ed94cd304765c5ef1d0,
                    limb2: 0x3aaf8e6e9efeb7a8,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xaa6037d51b7470230cec4f93,
                    limb1: 0x65094a2650b8285563a053b4,
                    limb2: 0x312f741cf953042d,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_1P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x69588367250041f054620d3b,
                limb1: 0x1174ea4879bb0b580868e8e8,
                limb2: 0x7ea9eb687089d547,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_2P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x862bbbc7625bb23fe3ee10f0,
                limb1: 0x868baf0626c044f9a077a0ca,
                limb2: 0x155e74b122885e85,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x610f7ffe1889436670829e43,
                    limb1: 0xb1f2329808ffbbfd2a7fce4c,
                    limb2: 0x56c9e223dae04be9,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xeb1167b367a9c3787c65c1e582e2e662, high: 0xf7c1bd874da5e709d4713d60c8a70639,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_3P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x81f93764cd87ff5af9aad87f,
                    limb1: 0x8aa0792747a5b8ca16b9e369,
                    limb2: 0xce30fe4be7b17451,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5b77703ae4639b17cfca6124,
                    limb1: 0x86b771c3a15eee8b1ca9feaa,
                    limb2: 0x5acc99b6152d28a4,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xff8927eca139c99d7960c8ef,
                    limb1: 0xec91eee7a0301418e07f41fc,
                    limb2: 0xb49b07479d1c26aa,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe496c28fbc13ed8a0324b632,
                    limb1: 0x2d5583856241be833fec7c9d,
                    limb2: 0xff1c723bbb39f40b,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x3efedfaf5b7ce0a80c4fa5a1,
                    limb1: 0x2c16205bc2efe9dcc6eefa9a,
                    limb2: 0x3f2cefb8efbcc695,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc3eeedd13fa2c621a214d57,
                    limb1: 0x5e42015603c2cf1a184c7bdb,
                    limb2: 0x8ab02685472a4433,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x20a01cfce8a5bce328cd8cb6,
                        limb1: 0x611f3fb42b516f17cb0584f8,
                        limb2: 0x763b2c950e4c198e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x462d15939fcd221751c6ac8b,
                        limb1: 0x946592683858eab6a9652826,
                        limb2: 0xa1544fca41ad8c11,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x31f0a0eca245552ecd7315f8,
                        limb1: 0xf2429ee89609dddcb454a01b,
                        limb2: 0x2c1624c1c090dd7d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc709d17953074ae5eadde9bc,
                        limb1: 0xeb446dc59a11fc094796dd40,
                        limb2: 0x47408b85eea80d47,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xb491b2471055bcbdd1dbef77,
                        limb1: 0xb90603fde64b1a2ce0b61eca,
                        limb2: 0xb4aaae5c76b88642,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3eba2b268c80681c5c311e90,
                        limb1: 0xf11a024b8e0531687340bd0b,
                        limb2: 0xc1b2df975bb5b863,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2eaecbac827c9f309771dbcd,
                        limb1: 0x4f246630ea9180999a632579,
                        limb2: 0x39f4d03f54586bae,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4180fbf542589c18eb2d7044,
                        limb1: 0xced4c189fdc0356f499c8870,
                        limb2: 0x7b2973b1222292cb,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x875809d83e33cb3b603309aa,
                        limb1: 0x6ad6d4a704b31d0441fad306,
                        limb2: 0xe478235415e659d5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc29722eb23a6c51f15c5b6b7,
                        limb1: 0xcaad40fc21df62667f2f7c9f,
                        limb2: 0x283d3160bb315f86,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4524bfca28d2a6c6ba96c39,
                        limb1: 0xa35f0c26665675ff32ee3a9c,
                        limb2: 0x92cb938207ec8ab2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x151c89d4b8f7c9e45b67a274,
                        limb1: 0x5a281d2133f588c400ee55b1,
                        limb2: 0x53876cce8038fdba,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7ac4deddb182928226db63f1,
                        limb1: 0xb766e28c02e373347c52e9b0,
                        limb2: 0x4a7ea9b2ab26031a,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xeffbdff172582934bd039b85,
                        limb1: 0xf2a1bf14c0db73a24fad78a,
                        limb2: 0xf0aac4873f0babd3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb7172e0dd782d8cb8557e905,
                        limb1: 0x97b61010e22459db26c52b4e,
                        limb2: 0x4be41d2381f80abb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x46c791b791685a55241d066c,
                        limb1: 0x29fecb5669fa843338b60650,
                        limb2: 0x95b1b1bb4e6af1c4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7f1895fbe0c20170401a1097,
                        limb1: 0x60d74ec3d68c9037e3fdd9dc,
                        limb2: 0x12ccd83465aa89d5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3eba2b268c80681c5c311e97,
                        limb1: 0xf11a024b8e0531687340bd0b,
                        limb2: 0xc1b2df975bb5b863,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2eaecbac827c9f309771dbcd,
                        limb1: 0x4f246630ea9180999a632579,
                        limb2: 0x39f4d03f54586bae,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4180fbf542589c18eb2d7044,
                        limb1: 0xced4c189fdc0356f499c8870,
                        limb2: 0x7b2973b1222292cb,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x2c77bb8f219c4f86d830378a,
                limb1: 0x7762e343071b3889761f79fb,
                limb2: 0x96e3952b500641,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x9d1cd65376303ffbede41478,
                    limb1: 0xc58c82a3af69a89f7f34d76,
                    limb2: 0x4446aa183d69a768,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xfdfdc509f368ba4395773d3a,
                    limb1: 0x8de2b60b577a13d0f83b578e,
                    limb2: 0xc2dd970269530ba2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x589fa250d638e35400c12ddf,
                    limb1: 0xb3aac19fcb5095808402aa7f,
                    limb2: 0xed6de6590d0195d1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xe443df789558867f5ba91faf7a024204, high: 0x23a7711a8133287637ebdcd9e87a1613,
            },
            u256 {
                low: 0x1846d424c17c627923c6612f48268673, high: 0xfcbd04c340212ef7cca5a5a19e4d6e3c,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x55909ba28af82ea934a4b85d,
                    limb1: 0x4bf448ca5d57fb119c843e0a,
                    limb2: 0x6a2275491b991ee3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5bf4bf0cefc9553422e60eb0,
                    limb1: 0x178d55925d3d72f44783f626,
                    limb2: 0xe13a21d7302f8139,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_4P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x8d0166bbf7e071295729418b,
                    limb1: 0xdd542b48fa7df1e7e4e9d09d,
                    limb2: 0xa21f38683fe17143,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x700402df5c88156eeeba2331,
                    limb1: 0x5e608cc7fd03942d78c3d40c,
                    limb2: 0xc8e85b1af8bfc00d,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x657faa148353381fc9ac1d0c,
                    limb1: 0x4a7ef201b9db61fbb9c9495d,
                    limb2: 0x1e87a915d7439340,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x70e1a8484ebeb69366e77b38,
                    limb1: 0xd7ccd4a605455a2bf8f36b6e,
                    limb2: 0x993c64100bc56c8a,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x2c45ea101d19f12cad40ffe8,
                    limb1: 0xbbfb500f69aac418d22f893c,
                    limb2: 0x75f7dcfb2d65ce2d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf94b1079627a99b6e7f182c7,
                    limb1: 0xd1b1c151888d2b8b4cd9ed17,
                    limb2: 0xac00455a2a419172,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xbbfd91160f1137a819814c41,
                        limb1: 0xb8c72d518683f02ec6ad0801,
                        limb2: 0xe1c5047d3b64bfe6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xab10d9e1799035d1ebba5662,
                        limb1: 0x2cb032fdb5301af5eb620366,
                        limb2: 0xfb19dd3218f7d066,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8cf5274d4c502946c34d070a,
                        limb1: 0x8cd43a3f8b49f41ec81353a4,
                        limb2: 0x984c68c944a658e0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x95a762e79cd07580e6967ef4,
                        limb1: 0x9ef7dd54a627f4698488d390,
                        limb2: 0x7751907e2c6d7ff6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7f2d5f441b3b91eb08da060b,
                        limb1: 0x3e64bef215332a1f1f7b4358,
                        limb2: 0xc6da47f9ca6ac46d,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x22d44575d84bdeaf7dd1fd74,
                        limb1: 0xb65c0ede5ffdf4cb0a151934,
                        limb2: 0x583dc69852d07b1a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe8b93bd973ccf034ce10e6f2,
                        limb1: 0x2dbf36223ec817c3a02d7a90,
                        limb2: 0xd9eee174bb8964ca,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8e69374db145e2b6ecf93288,
                        limb1: 0x34b1b6902a61ec72c01e2a5,
                        limb2: 0xbad632b4cbe07b88,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6c4b654436374481f9ab681b,
                        limb1: 0x8f1dd28caa0dd14f2276d2e8,
                        limb2: 0xecf4cd348a10d48b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb9d551618829c3bcf5c67060,
                        limb1: 0x5a6c883b07c66955946979ab,
                        limb2: 0x10fcee769eec49f3,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xf7001257f7b133467ba3e31b,
                        limb1: 0x6fd1b723cde5d3e56f2b9172,
                        limb2: 0x31577ee1d048691b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x295353bdfaaf49c441ba4588,
                        limb1: 0x7f1d9bd75873b0dab6b549f1,
                        limb2: 0x3925bed489cbca7a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x73a58136c0a534ce62aea09d,
                        limb1: 0xe9a45d654517882820fda93,
                        limb2: 0xd7abf0e4f9c5b073,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x61ee5c016f4c07be54fb28c9,
                        limb1: 0xf7d2d91253e6fc0ab7f95177,
                        limb2: 0x67bdb9539fa57feb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7c29625088633bf4ed063960,
                        limb1: 0xa64e1678630bbf9d9cf464cc,
                        limb2: 0x300be8294b647820,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1af97fc9c3a2422ba6b3b23,
                        limb1: 0xfc7fe2e950b56d452afaaf52,
                        limb2: 0x53a300c966283854,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xf3cde638ea1316ce70bdf5ce,
                        limb1: 0xfc8468149ff1b18d4693b06c,
                        limb2: 0x69b06e2a43b35dba,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5d10a2f22a9a9176a27663b3,
                        limb1: 0x403a7aefb778a659613e59f6,
                        limb2: 0xf5882a3120c1c187,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe4e0831fd8e933057ad074cd,
                        limb1: 0x170dbfdf128ad772340d3286,
                        limb2: 0x1bdb62f1932360b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x18e40a5353cebe435181ed17,
                        limb1: 0xa02cd0b7065eadf4fb54dd8f,
                        limb2: 0xd2ef630819464aeb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfd8e75842cf14a60867dfd63,
                        limb1: 0xa6b6efbf7534f91aaf0fce42,
                        limb2: 0x50d966b313ff6a71,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8e69374db145e2b6ecf9328f,
                        limb1: 0x34b1b6902a61ec72c01e2a5,
                        limb2: 0xbad632b4cbe07b88,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6c4b654436374481f9ab681b,
                        limb1: 0x8f1dd28caa0dd14f2276d2e8,
                        limb2: 0xecf4cd348a10d48b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb9d551618829c3bcf5c67060,
                        limb1: 0x5a6c883b07c66955946979ab,
                        limb2: 0x10fcee769eec49f3,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x4ebe6b4cafc8aa610f56a569,
                limb1: 0xdfa776e024208427b7e8de56,
                limb2: 0x6ba436ffd643ab46,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xfdfdc509f368ba4395773d3a,
                    limb1: 0x8de2b60b577a13d0f83b578e,
                    limb2: 0xc2dd970269530ba2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x589fa250d638e35400c12ddf,
                    limb1: 0xb3aac19fcb5095808402aa7f,
                    limb2: 0xed6de6590d0195d1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x2965eeb3ec1fe786a6abe874,
                    limb1: 0x33e2545f82bb6add02788b8e,
                    limb2: 0xf586bc0db335d7b8,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x155b35991489db2fdf4de620,
                    limb1: 0xf24ce461346a182d67eeccf0,
                    limb2: 0xb4122bb4b37cc7d5,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x1846d424c17c627923c6612f48268673, high: 0xfcbd04c340212ef7cca5a5a19e4d6e3c,
            },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x259f4329e6f4590b9a164106cf6a659e,
            },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0x5487ce1eaf19922ad9b8a714e61a441c,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x6bd8241f742b28cb66aa56f2,
                    limb1: 0x24d0ea2018173320c8f31889,
                    limb2: 0x9163c7b68d703c1e,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x50b9bcebc2b4fc80224f5146,
                    limb1: 0x756704c3a78f9ab2c60ececd,
                    limb2: 0x9ecbe5fd68546ab7,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_10P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x4afd2ec2a6643712421d0683,
                    limb1: 0x11cef224f19a309e96679abb,
                    limb2: 0xcffd675843f0be43,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf5ae7a1fdb6de2954712a3fd,
                    limb1: 0x71fe17f155aa123b146132b8,
                    limb2: 0xb35f7d31dd603448,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x53307d00341d76bbf188df94,
                    limb1: 0xd91bee3612e221fb6683efa1,
                    limb2: 0xa0bbd123c52b1348,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x2cfa22fc764c5f4080fb4f30,
                    limb1: 0x9cb2f17fc11214eb4fbaa9cc,
                    limb2: 0xef04c79d8aebbaec,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x670172a1e64a26ed422d2b12,
                    limb1: 0xd73418d6e8577e0dbcb65dea,
                    limb2: 0xfbcb3aac9382ad3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb12045b32e75ce2d977fca84,
                    limb1: 0x98bf7be3e9b1c1c9364d70d6,
                    limb2: 0x87549411a3123384,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x3f1bf262f1ce488c6b7b83f1,
                        limb1: 0xdf56a93968937e509685107d,
                        limb2: 0xe6c9074b82d790d2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6745de629e075a9dbbb143c7,
                        limb1: 0x1bd5223cd7ddff8f97707ec5,
                        limb2: 0xf4080bea94632658,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8d9d573ac3bc350cc0fba533,
                        limb1: 0x5c08ad2c1875d72c75afd5bc,
                        limb2: 0x55e7b6c12658a972,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x50a777b81c9acfed0deb2fb8,
                        limb1: 0x7dc595e96f3c70c015771aa7,
                        limb2: 0x8090ab3d5e863c74,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8be929bb240bb9ed719299fa,
                        limb1: 0xd85dc3d499a088cb605b3d0a,
                        limb2: 0x6f2371a84118a9bb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa3cb747845d46071f75808bc,
                        limb1: 0xd77e33379dd2df7b7e34339f,
                        limb2: 0x95a3d9117e10c1f2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x40e63c7ef139c8fae441f7f5,
                        limb1: 0x2bfd369fb464b333c07ec42d,
                        limb2: 0x59febecdff390791,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x43f9167bf64f07c3edb4c0b2,
                        limb1: 0xc25831fee1ab8f51ccdfb00e,
                        limb2: 0xcd7bc65c89ba8c75,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x247b5c58340fd28a36c048d1,
                        limb1: 0x6a2b823cb6bd058c30206bed,
                        limb2: 0x1ba2c214491482f8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x627aa297724f8501733f100a,
                        limb1: 0x6ffe33f5cf40193a39260e79,
                        limb2: 0xcc48fc7ee6e6f519,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x33deec6013376f6f6f816966,
                        limb1: 0x9b32a62cc5156dc4ba3298cf,
                        limb2: 0x6245391498e6e6db,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xf64ffe172948329e2fcbc603,
                        limb1: 0xdf8d87b2544b6a2850611151,
                        limb2: 0x9e210b6545f4c3d1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc9fad7123b7ae4f05cf228d5,
                        limb1: 0x604e4521dbaed4af0fa8a1c5,
                        limb2: 0x668676e80e912153,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2a38b63293c292a550534ec,
                        limb1: 0x9b8a3cdc59b3ca87397e5909,
                        limb2: 0x333ea6225ba1f71b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf72296c8c78689d8c97ffc5e,
                        limb1: 0xfdf4dfaf216e35dafb8bdbe3,
                        limb2: 0x28ec546fdc1d5da1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbb968a55b7dc197bce6335f5,
                        limb1: 0xf9cd6947f7ffdf493ec49f29,
                        limb2: 0x861a8b32c623bcd4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xaf4b95ae1714c6e4c09bbb68,
                        limb1: 0xd3b9d743d285fbd3807f4f1c,
                        limb2: 0x7ecc3066d3efb1a7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2d6b9c319d4168de03b743ce,
                        limb1: 0x283fd75def839ca4307bcf7f,
                        limb2: 0x318e2135071739ee,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xda0f6ae3be484183e704928c,
                        limb1: 0x86d730e781f413256c35efff,
                        limb2: 0x1b4509904e96af9b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3143a9241e38b62956ebb29a,
                        limb1: 0xc0480770d8e97de2bc76377d,
                        limb2: 0x2defefe2f3397dc1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc359d0b08a20fd2ce8979f78,
                        limb1: 0x731e866b7c42217f5209cf41,
                        limb2: 0x59fe76d6ea2fe21c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbdee89e23d2b145ee8340c70,
                        limb1: 0x4aea390f4f28f12be406cd17,
                        limb2: 0xb49c9089b47d2e01,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x3f5cf6f7b7ca75386e2797e4,
                        limb1: 0xe8ece87f0d37f65b91f870f2,
                        limb2: 0xa4f50c6382ad9682,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4295c3f21d65991d286b4bd1,
                        limb1: 0x1c96777b918eb189e9205c19,
                        limb2: 0x395b2bafc2948923,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x83499a1d14f3c23073522f5,
                        limb1: 0xa22fb01cf34b0cee20a8cbd4,
                        limb2: 0x22d0b405df12e488,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5917a4f0784060456ea3b0ce,
                        limb1: 0x2312d057a791285ae79c22ca,
                        limb2: 0xd19c511d69762f5e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8dbac454fb152e5c809d163e,
                        limb1: 0xe01590a5c01df50842cb7f1,
                        limb2: 0x7a7a7b86711cbc21,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x48e829943911323e2d3cff60,
                        limb1: 0xf0be3520ac7110ceeded6464,
                        limb2: 0xc89502c5cf180910,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xef8b4de36559336799d2974d,
                        limb1: 0x84fc814b5e9592ed2799bc89,
                        limb2: 0xad85084575a3521b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x365fbe490b5fba569fd512a3,
                        limb1: 0xd3ba4fafe794228fd6ac8cf7,
                        limb2: 0xf5dd29a6f122891f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8c8fce6ec0c08a83f11e1e54,
                        limb1: 0xe2231561434a12b19400aef6,
                        limb2: 0xb9401ac6cb0b0d8e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x643d21afcabdcd113ac22ab7,
                        limb1: 0x5731be1e8cf43ae4b045362a,
                        limb2: 0xb92e9eb89a3617e8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc8abfeb28cf147831ffe94a6,
                        limb1: 0x67d152c1448befba6838de7e,
                        limb2: 0xf51b75bc08cbb50,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe6abd077702fff54ff3504f5,
                        limb1: 0xfaf28084044493a2b55cee9,
                        limb2: 0xb18c2c80a403fbc6,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xbc2ff2a220f962574e927959,
                        limb1: 0x1cdeb5e04e0fe71a32a7793d,
                        limb2: 0x52e74fc4e9b15abd,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x85dbe17fa05c42948a9f2575,
                        limb1: 0xa223e3ed01c7d0c96d9c6c68,
                        limb2: 0xcdad405865f7e947,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1278cfb620a5202953247645,
                        limb1: 0x40c7aa0673ea89b292746f3f,
                        limb2: 0x66b68af0816dc1c1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb8421d949df5f78cb24bb066,
                        limb1: 0xd13fa57c3e4ee3253134148d,
                        limb2: 0xbc975a744ac2533f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeb189f6a427f975701a8b1cc,
                        limb1: 0x34ec2619a3adefafc708fbe9,
                        limb2: 0x1140454b798b4b26,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcdb4a325cacd996e99476037,
                        limb1: 0x659f1fb71b5dad4fbcf982d1,
                        limb2: 0xaad3f8f2272fd2b2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3513dc24145067ebe382dad1,
                        limb1: 0x17b3c340ae077e584eee885e,
                        limb2: 0x83cf3ce30dbff325,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb202768febd5e4181f833b9a,
                        limb1: 0xa9afbf9c85ac654f343e2f28,
                        limb2: 0x44fdce24ec428a15,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x82535aaeaa1c207210da16f,
                        limb1: 0x15b20b59c0e86d06a7bad389,
                        limb2: 0xc05bbf9b7a8221f4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x84e051056428551a5fdca7b8,
                        limb1: 0x4e15844e5552871f6ec07a4b,
                        limb2: 0xa78361156e6668b5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb9530136a75d0214070fcb1,
                        limb1: 0x933ec052ac12ab58a8658ba6,
                        limb2: 0xb8cfd543e02f1a4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3143a9241e38b62956ebb2a1,
                        limb1: 0xc0480770d8e97de2bc76377d,
                        limb2: 0x2defefe2f3397dc1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc359d0b08a20fd2ce8979f78,
                        limb1: 0x731e866b7c42217f5209cf41,
                        limb2: 0x59fe76d6ea2fe21c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbdee89e23d2b145ee8340c70,
                        limb1: 0x4aea390f4f28f12be406cd17,
                        limb2: 0xb49c9089b47d2e01,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x44da36e3bd84a51984e90ce3,
                limb1: 0xd44147e23c7cb8155c9deb4d,
                limb2: 0x65b13a4678620b98,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xfdfdc509f368ba4395773d3a,
                    limb1: 0x8de2b60b577a13d0f83b578e,
                    limb2: 0xc2dd970269530ba2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x589fa250d638e35400c12ddf,
                    limb1: 0xb3aac19fcb5095808402aa7f,
                    limb2: 0xed6de6590d0195d1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x2965eeb3ec1fe786a6abe874,
                    limb1: 0x33e2545f82bb6add02788b8e,
                    limb2: 0xf586bc0db335d7b8,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x155b35991489db2fdf4de620,
                    limb1: 0xf24ce461346a182d67eeccf0,
                    limb2: 0xb4122bb4b37cc7d5,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x12815740835b12f70b96c66f,
                    limb1: 0xbfa76a8b80aec9f2e31c40cc,
                    limb2: 0xcd8a26d17d33c7c1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9a8f496f09402b8fd6beb89b,
                    limb1: 0x28e48918dad2123d7f202bef,
                    limb2: 0xcdd11b6ffb3f8614,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xb5076be8537cff2a42c6db68,
                    limb1: 0x1066d40cbd01a3752e4e069c,
                    limb2: 0x123ec2fd302cb0f9,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc85f5e5efdf415f8081bf53f,
                    limb1: 0xadc5010e9d9ac6c64000d33d,
                    limb2: 0xf81314011d8852e4,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd5915098d3d2001310b0b935,
                    limb1: 0x88bb4507ebf1be82cfba2397,
                    limb2: 0x8a463f1c00ce885f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x414858f8a83f9d4498890137,
                    limb1: 0xa09c4658c47ace74c42cdb60,
                    limb2: 0x8aaf300ff3ab7d98,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x1772eb803ddc8a82e23b1c05,
                    limb1: 0xc26baeb89b03fd69eb64b337,
                    limb2: 0x4ea7131b2d873a45,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc9d16330db15efd90235eed9,
                    limb1: 0x1b586ef360673d36baa16189,
                    limb2: 0xee652d2b848ad111,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x68f9e7942638253f3b596f1f,
                    limb1: 0xb37e6153d9accd97a344f384,
                    limb2: 0xda48eae9ff614551,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc58be8ed857035b34f51c620,
                    limb1: 0x3b14ed53116cb7c1db000006,
                    limb2: 0x7dfa292fe99b77dd,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xf7f7bd2513c1b31de932bbd2,
                    limb1: 0x627e2fa74b7ac891f7d555c7,
                    limb2: 0x7f8a094f818e7192,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9b47b9326b668e62071faf18,
                    limb1: 0xe21058cb6937afa89be6931a,
                    limb2: 0x21a4bfb4cce2ac8c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb5d32b1666194cb1d71037d1b83e90ec, high: 0xa0116be5ab0c1681c8f8e3d0d3290a4c,
            },
            u256 {
                low: 0xd3fbf47a7e5b1e7f9ca5499d004ae545, high: 0xbaf3897a3e70f16a55485822de1b372a,
            },
            u256 {
                low: 0x101fbcccded733e8b421eaeb534097ca, high: 0x38c1962e9148624feac1c14f30e9c5cc,
            },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0x1759edc372ae22448b0163c1cd9d2b7d,
            },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x7d41e602eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x552f233a8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x8c1745a79a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x5129fb7c6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x870e15c2fcd81b5d24bace4307bf326,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x2950159ef4b04fdc0dc934a9,
                    limb1: 0x9e463011388a15f56d6f38f4,
                    limb2: 0xef8d0de25e526f1c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x93ff053c58374ab5fd2530ab,
                    limb1: 0xb09af339bdbe0090a3d72802,
                    limb2: 0xd7d9e3078702fe93,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_11P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x74408414d91a69f35f61bc6b,
                    limb1: 0xb4948f35f0aba81a568e7a8b,
                    limb2: 0x9d9c716f70218bbc,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x18f14196f216ed9367a2698a,
                    limb1: 0xe422cce7320bc65f4959ae9f,
                    limb2: 0xc1e171c2a4df7f1e,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x7028fdc386b9c76dc3c4a0c8,
                    limb1: 0x63bfc9828a51db91045c2a84,
                    limb2: 0x52713bd3cf273e01,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x573f68d756aa76e18879cd7f,
                    limb1: 0xdc646d36c276f220bd9bf719,
                    limb2: 0xe7ffb91a35ad131c,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x346aac78eda91ff42e459dd4,
                    limb1: 0x1f7e2485a95b04359515aa5a,
                    limb2: 0x720a7b0cb20237a7,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9f608d816585bb091fe579d,
                    limb1: 0x295f0370475510aaad79a2f,
                    limb2: 0x10674a790fac2d80,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x59cf96d109450f9f6bf64b60,
                        limb1: 0xe17e9763ffb0b0a7d8a34705,
                        limb2: 0xf811c8020ee9354c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6c6ddf4bfee1d3419a702192,
                        limb1: 0xe3631280d0e952f60b0960,
                        limb2: 0xfb103c34bb967495,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x54455d4c5236c1a01a8fd2ec,
                        limb1: 0x9d6c9cd854f6e7046ee699ba,
                        limb2: 0x5cf974632d9c365b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2871948055bdc19572e22d25,
                        limb1: 0x39cf537b7df5f9a3361d015c,
                        limb2: 0xd121add03ee0f44c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcc89c7d8dc40b4741d7f3ccb,
                        limb1: 0xb234053d442371a8ea49305a,
                        limb2: 0xe5784e6863c79766,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe3511b2cd3d4b6cd0a467e09,
                        limb1: 0x5cfe950eaa9650fe941e8502,
                        limb2: 0x1be1d7559281b14b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8f1d6db1dc633e5065071349,
                        limb1: 0xbf2d2356f7b49ac54d5f23a,
                        limb2: 0x4ad9aa4654f8269,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfb91710ada5a1221b80720,
                        limb1: 0x56c9a1a6bfd0cf75d7bf22cb,
                        limb2: 0xbca01cc9883c9fc8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3c8102a642bf169f9b8e109b,
                        limb1: 0xe2702813457351c891f9497e,
                        limb2: 0xad282059d7e00bb9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe85bca8f0d9ed42c4fa3259c,
                        limb1: 0x3cb93906b77052d09482d8d,
                        limb2: 0x93acbb8c2a33d2c3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x10b9a1acd39a7d843c66c9ce,
                        limb1: 0xb3dc13616ff36a2b20b9f3bf,
                        limb2: 0x2eb403689248d7b0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x62c4d76dd3906cfaa7a5f51,
                        limb1: 0x64121c21527c917705cb49b8,
                        limb2: 0x683d0b58b8ddcb5e,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x9786ae87968fec1ecf6d7306,
                        limb1: 0x9f7094a663f8ec412a9837bb,
                        limb2: 0x8eb277b470c70452,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x651cb5773f6260850355dde7,
                        limb1: 0x75c8db72cb0920037072334c,
                        limb2: 0x30ab1b852b536639,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe41a87d844bbec4092c0e97d,
                        limb1: 0xfb87b5eef068989894626f1b,
                        limb2: 0xa466cfb75eee78a6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x49e15764a064cf615e458153,
                        limb1: 0xc5bab3ef9e4c62af92a34243,
                        limb2: 0x52f705b6b0b2e940,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdb9975c7900350d62d79833d,
                        limb1: 0x1a05ff22452f3f60131257b4,
                        limb2: 0x88b38d63ed980800,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4d5dd792fc765ba409d7f15e,
                        limb1: 0xc10e115f5dccf21e5d9f8622,
                        limb2: 0x9d6442211cc085ac,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x32b0e6e6752f5dd6e11b8c09,
                        limb1: 0x2616abbcb122eabdd29e6dbd,
                        limb2: 0xe3a19608be4afed8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2edd747273fe614a64f0c150,
                        limb1: 0xd00e6ed878e753d3f58c15ee,
                        limb2: 0x129b7a35da7e62a3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc39dc077f41a655200a39e90,
                        limb1: 0xaff7a4a33471bb7b37cc02c0,
                        limb2: 0x4aa53dd4d8b74288,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8cb2a0bdf333fad4ab749cc5,
                        limb1: 0x81439512af167dacc6ce65f4,
                        limb2: 0x38221d558c7e1a59,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9fec8485f09389afffce169d,
                        limb1: 0xcf3546b3f198c78aa4b506f9,
                        limb2: 0xf401fe854780f05,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfafea51ddaf6e6b9f7d1a426,
                        limb1: 0x273eac3ab92dcb592f615623,
                        limb2: 0xabe5fd423d09448e,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x9d9f24b0a4f14d45847c317a,
                        limb1: 0x9de605232a6b3672a9642c39,
                        limb2: 0xefdff29c976ae041,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb3e90055c16a34a07e0388be,
                        limb1: 0x576c01052293a220513bbd32,
                        limb2: 0xa72eb49613bc0ef4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1282a127d856ee505ed9bbc0,
                        limb1: 0xd056593149b3ef729af6ac02,
                        limb2: 0x82a0a2bf431bfd05,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x33590516accd0777bc8aa4a7,
                        limb1: 0x2dbf0eb2f3d7fe3978455096,
                        limb2: 0x143cfb63582c14a2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6a447db658704f9528255e07,
                        limb1: 0xc9d336c3f802ab3e115c0803,
                        limb2: 0xfde4b58826cb223c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcf83b92fa680c35db5837531,
                        limb1: 0x6e440d3c2942cade0eb99004,
                        limb2: 0x3f32960adff56bca,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8282f7d8bab3ec2af461433f,
                        limb1: 0xa061b169e2497b5f22a96a78,
                        limb2: 0x65a8b438429f4be0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5e6524b3726b09d02788e105,
                        limb1: 0xd901df85467c80290aa55de6,
                        limb2: 0x9d9306afdb1fc541,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x94ae0d3f7f7ecb9ab95c2c1f,
                        limb1: 0xc427bbea84c50a9f6ca39446,
                        limb2: 0x1f12def472e3bbbc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3fc3d9c851f3ca1713d59d22,
                        limb1: 0x20b54bcf862d0dd868a61282,
                        limb2: 0x50f32383ccb28012,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x39a23c24d7961d46ec9bfcfd,
                        limb1: 0xd821e97648649be76b0b793d,
                        limb2: 0x8a2a4901505e01b3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2080fdb1b23c12261e11d802,
                        limb1: 0x2d30af7e6e51cf61a772c1ba,
                        limb2: 0x85fc03e91ff8ad66,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x60efead885cc6b65f0c76e63,
                        limb1: 0x19680d56c5ea36a23b07030a,
                        limb2: 0xad0bcd690693a4fc,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x24aec5b51def74daabfe309d,
                        limb1: 0x5c14108cbbce75c82a298621,
                        limb2: 0xe6e145ef15711e42,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc3c8f642bbb0a3a417591522,
                        limb1: 0x387e00238d3fe018131f6716,
                        limb2: 0x54adc0a42f47cb92,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3cb9b6e9e12375c8034671af,
                        limb1: 0xe0b5f98892dc2c2c0eb109c3,
                        limb2: 0x7ecfae0398854c90,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9cb01247f95197ca635403ed,
                        limb1: 0x78b8033b80f9f0e2d0f0792,
                        limb2: 0xd3739fb345ab6518,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x664eedec2f79966341a88005,
                        limb1: 0x2bf2d562af53dba3f5f2993e,
                        limb2: 0xed93f940aa7b9e3a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1ab6cdd2bf86dc0d7a89253,
                        limb1: 0x42ea2f8a8103376d23bf1a0c,
                        limb2: 0xf2249e9f28322060,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xacb7a7b1d4b0604786066c78,
                        limb1: 0xd05966187640cde054f8426f,
                        limb2: 0x8c621ff3e4bfe129,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x23a7a4e8bbf7f9dff00ed03e,
                        limb1: 0xca6b070d93828a2bc9e6f138,
                        limb2: 0xaf3e4dce70cba7a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa6ae1adaa92f20e40e514ef0,
                        limb1: 0x90d391d5cce9127ce4339967,
                        limb2: 0xa7e8f2f309c35769,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb934c181b9b39a9914bdd0e,
                        limb1: 0xaeefbf3f7ac05a774243376d,
                        limb2: 0x6c90635f95bdb74a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8e55141c0807251a63935f9b,
                        limb1: 0x7a835dc41414c89e767f46c1,
                        limb2: 0x7d5c599029c6cbcc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa0944448f0dab46bc75f2ade,
                        limb1: 0xc2ae5a3e44b24aeb83755dbc,
                        limb2: 0xfdef2aa483f8226b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8cb2a0bdf333fad4ab749ccc,
                        limb1: 0x81439512af167dacc6ce65f4,
                        limb2: 0x38221d558c7e1a59,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9fec8485f09389afffce169d,
                        limb1: 0xcf3546b3f198c78aa4b506f9,
                        limb2: 0xf401fe854780f05,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfafea51ddaf6e6b9f7d1a426,
                        limb1: 0x273eac3ab92dcb592f615623,
                        limb2: 0xabe5fd423d09448e,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x6cc8902279ec1dccf25660af,
                limb1: 0x60ce213d05e2e7e6160de0d8,
                limb2: 0x7ac2776fc8934f7,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xfdfdc509f368ba4395773d3a,
                    limb1: 0x8de2b60b577a13d0f83b578e,
                    limb2: 0xc2dd970269530ba2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x589fa250d638e35400c12ddf,
                    limb1: 0xb3aac19fcb5095808402aa7f,
                    limb2: 0xed6de6590d0195d1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x2965eeb3ec1fe786a6abe874,
                    limb1: 0x33e2545f82bb6add02788b8e,
                    limb2: 0xf586bc0db335d7b8,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x155b35991489db2fdf4de620,
                    limb1: 0xf24ce461346a182d67eeccf0,
                    limb2: 0xb4122bb4b37cc7d5,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x12815740835b12f70b96c66f,
                    limb1: 0xbfa76a8b80aec9f2e31c40cc,
                    limb2: 0xcd8a26d17d33c7c1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9a8f496f09402b8fd6beb89b,
                    limb1: 0x28e48918dad2123d7f202bef,
                    limb2: 0xcdd11b6ffb3f8614,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xb5076be8537cff2a42c6db68,
                    limb1: 0x1066d40cbd01a3752e4e069c,
                    limb2: 0x123ec2fd302cb0f9,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc85f5e5efdf415f8081bf53f,
                    limb1: 0xadc5010e9d9ac6c64000d33d,
                    limb2: 0xf81314011d8852e4,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd5915098d3d2001310b0b935,
                    limb1: 0x88bb4507ebf1be82cfba2397,
                    limb2: 0x8a463f1c00ce885f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x414858f8a83f9d4498890137,
                    limb1: 0xa09c4658c47ace74c42cdb60,
                    limb2: 0x8aaf300ff3ab7d98,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x1772eb803ddc8a82e23b1c05,
                    limb1: 0xc26baeb89b03fd69eb64b337,
                    limb2: 0x4ea7131b2d873a45,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc9d16330db15efd90235eed9,
                    limb1: 0x1b586ef360673d36baa16189,
                    limb2: 0xee652d2b848ad111,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x68f9e7942638253f3b596f1f,
                    limb1: 0xb37e6153d9accd97a344f384,
                    limb2: 0xda48eae9ff614551,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc58be8ed857035b34f51c620,
                    limb1: 0x3b14ed53116cb7c1db000006,
                    limb2: 0x7dfa292fe99b77dd,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xf7f7bd2513c1b31de932bbd2,
                    limb1: 0x627e2fa74b7ac891f7d555c7,
                    limb2: 0x7f8a094f818e7192,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9b47b9326b668e62071faf18,
                    limb1: 0xe21058cb6937afa89be6931a,
                    limb2: 0x21a4bfb4cce2ac8c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xaf4ad4d7d582b10b14c97e6c,
                    limb1: 0xadf808c85e766e997e470fd0,
                    limb2: 0x2714571e587ce46d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x86a7815dad7e8a53b19fee2,
                    limb1: 0x1922fc1efcc51e68146ffa1b,
                    limb2: 0x9e19b7c1f886488e,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xd3fbf47a7e5b1e7f9ca5499d004ae545, high: 0xbaf3897a3e70f16a55485822de1b372a,
            },
            u256 {
                low: 0x101fbcccded733e8b421eaeb534097ca, high: 0x38c1962e9148624feac1c14f30e9c5cc,
            },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0x1759edc372ae22448b0163c1cd9d2b7d,
            },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x7d41e602eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x552f233a8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x8c1745a79a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x5129fb7c6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x870e15c2fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0xadc0da7a16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x148b2758d7ab792809e469e6ec62b2c8,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xfd3ebb89d10fe461e552fc52,
                    limb1: 0xec1cd433c40d59e89a0a67c6,
                    limb2: 0x718e281769552f5,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5765daf8dcb6b393eba165cd,
                    limb1: 0x106a5fd0eb158dcde70d802e,
                    limb2: 0xe30701a5d0fa2198,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_12P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x1d36d633760b3c55c81a8d8c,
                    limb1: 0xd079c33f8b0673c89e3a9bd0,
                    limb2: 0x70ff81f33501ba92,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xcff3e05d854ed659f6cd040c,
                    limb1: 0x33f2728d006bc9e70866e303,
                    limb2: 0x2f4943938395998b,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x1db4213156986f28879aba6b,
                    limb1: 0x5a33215ee31af0cdd996b80a,
                    limb2: 0x62cfcf2de05e2009,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa9552c8f1c96a1c163a43cae,
                    limb1: 0x6230406918f0da360db56e32,
                    limb2: 0x35ace69b06cd8541,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x5942b3e3f39ff916f02cf401,
                    limb1: 0xa8740c9f663c8f149c7f7be4,
                    limb2: 0x6f066ce3dd1f0f5,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x4aa3daffc076e92ff6b946d1,
                    limb1: 0x3818f620414525abc495e44b,
                    limb2: 0xae70f24112363941,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x4b261f125f932b2df22a9f52,
                        limb1: 0x561f742375e347c8fc3d21a2,
                        limb2: 0x4b163bd0d2bed359,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcffc531f2c930d4b1ce2e421,
                        limb1: 0x942db8b5929e88749c170c00,
                        limb2: 0x4f132af4fc1366ed,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x41349ca1d6c96ca0bc46e7d7,
                        limb1: 0x5a16a159fc62985bdc7966f,
                        limb2: 0xd6f92168a0acd2a7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcbf815d3501b99626c79b193,
                        limb1: 0xedaa2841baff32ba1d0f3828,
                        limb2: 0x63ff6a873797193d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe4a29637202964e1e224f23c,
                        limb1: 0x97bdb40a78f4bdac4216e4a5,
                        limb2: 0x39108033dfef5e9b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5ca10a4175716d893a21be97,
                        limb1: 0xfdbbe1a376b455a13408e4de,
                        limb2: 0x3a8b16e053ddb367,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf36b6c99d2f4b3707547036c,
                        limb1: 0xd20ff9749e0eadc70178b920,
                        limb2: 0x8a35cce356fbd58e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9d6acd5fa00cd2a83a84bbd2,
                        limb1: 0xe041b214f7e300850e6e33e6,
                        limb2: 0x5fda551bea2bf93d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf2424e2ef2aeb4f97929bfa3,
                        limb1: 0xa7de1c574c6d38e2add73486,
                        limb2: 0xe189c927e5fc4694,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf631583f3d2ce3042cc1e7d9,
                        limb1: 0x1ab1db16591bfedff7135f14,
                        limb2: 0x6f39a8db1fff6807,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6220a748217837c9dc87d4ab,
                        limb1: 0xd912dc06f4ba96da3491fb62,
                        limb2: 0xcb83a489b8d61820,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x25a6b151a3a8a2de89881ba9,
                        limb1: 0x5a7b76d17a62476e51bfa178,
                        limb2: 0x1ce40107e2f2770e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfaf168c765a509a9e17061bc,
                        limb1: 0x50106331e4ef06bdf33cd366,
                        limb2: 0xd6be8b578252bfe9,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xbd72378ba182a4282d70ae7f,
                        limb1: 0x235ac337803f7d004e1142d8,
                        limb2: 0x5104f6032d403f94,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x26cc6c990857c99bfacda25a,
                        limb1: 0xcabaec2171b94ba5d4f1babb,
                        limb2: 0x95e5b2ef262c001f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd0d4e38ebb69e4532d9efeba,
                        limb1: 0x44c3e38e9e7967b8008caa17,
                        limb2: 0x58b61a760babc9d6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9d9e89cbdfa6f4bea402c974,
                        limb1: 0x9dbe82a503384a9e6db9d8dd,
                        limb2: 0x54172c64568da814,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9849891f7d4b9fea5cc36950,
                        limb1: 0x191f92f08bfc15df518c83fd,
                        limb2: 0x3ba0e596d1437f6c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x27cd80d1c358af6ca751d260,
                        limb1: 0x7a42ade21a471e526004b19,
                        limb2: 0xd2b9562ed16f48f8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xda313f4670a7fa4152a62c91,
                        limb1: 0xf7131497b0fd4d3d58a50f88,
                        limb2: 0xde7ec8705a2e8720,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x33c717b5e23eda3363b2e464,
                        limb1: 0xfd2f9211711dc9be10d3e971,
                        limb2: 0x7008ca982a9b79a0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb23731a7eaf5636bd9942130,
                        limb1: 0xd48183290fa77582be98339d,
                        limb2: 0xe02b363ca58821d6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x95b132a6f14cb12ba5c2b8f7,
                        limb1: 0x7b6070deebe486d8d8ee4d31,
                        limb2: 0x75051a53ef78b836,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x55dd6a28bb25257316c4af63,
                        limb1: 0x3728e42109f277cb35fc2a1e,
                        limb2: 0x18a104dc8e2b9b56,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x39b351e37b8e9d31b8b8cb39,
                        limb1: 0x8b69164c6a40aff97159ee44,
                        limb2: 0x7d2f6656b0369ca7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x67e8b3625f17794ee71189ae,
                        limb1: 0x96f1d8c12def6c88bb93cc91,
                        limb2: 0xfe079f9eb1c4501e,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x38cda0a8f13de55d488e4d6b,
                        limb1: 0x446eb3df79a734adf4def1a5,
                        limb2: 0x19b9e5c133ae29d5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x35171069eae34a9c782da66c,
                        limb1: 0xd1844eb8a16fd39e6bc1425b,
                        limb2: 0xb79876e46d9b13f6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb328f6db826e8cc995cd07cb,
                        limb1: 0x26f27a96f38f690c329fa1b0,
                        limb2: 0xff42c7ac457dcc99,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbf2c475e4e2e288f0216bcfc,
                        limb1: 0xb3fef48999d1e5c48555c364,
                        limb2: 0x29a8ec8790ba5081,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x778094cf0fdc66024dd1d82,
                        limb1: 0xf7c4bcacc7a7351bcfa4272e,
                        limb2: 0x6e23e468cd3313fd,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa83dc7cec0b839144a326c14,
                        limb1: 0x27151329c8a3abae16b9276c,
                        limb2: 0x6b59fce2d5efd4fc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xad6163d83fc04ed8eccb265a,
                        limb1: 0xd0e169707bb6d9cfb2b76bcd,
                        limb2: 0x904851a79aed1964,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf754afb043cfbf180398edb3,
                        limb1: 0xa88d5f4765abaa9eb94b48a4,
                        limb2: 0x4e0c39de2fa7d63a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8a5007b9bee9d33e90747c99,
                        limb1: 0xb85d397d5b249108dfdb7a29,
                        limb2: 0x4b983f4446235b76,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x483983813861fb8afede3b50,
                        limb1: 0xc9a7eb123521d2a87ff332b8,
                        limb2: 0x807f9e3d1aaefdf6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc41fc815a7c8f45f65808f30,
                        limb1: 0x311ec6ae75d79a76c26d7c6f,
                        limb2: 0xfcd9374ba0f8453a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa04fbd4a8d5d0d61f20e9f6c,
                        limb1: 0x2dee29f2e218c15ab53bd4fd,
                        limb2: 0xb781415b14d572ea,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6e292a1187c5c1a971b10e54,
                        limb1: 0x8cd396a0c3fcf65d308acc82,
                        limb2: 0x617898635da6d644,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf8cf29c80f4ebf4478cd8be0,
                        limb1: 0x3971ec3ccf65681ca7dc2e15,
                        limb2: 0xfcfe13c91cd6688b,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x2e1f84d16a927d1b3e14cd1b,
                        limb1: 0xf77b568481bc6b022278d3ed,
                        limb2: 0x3722ba163cc1bd0c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf96f82f3a668347db9f7fba,
                        limb1: 0x8b1c74ea1c111188d29c1b1e,
                        limb2: 0x1947e48a0b3400de,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb5d238e71fe53e483f58feb8,
                        limb1: 0xe15b38e65551d60803d8a6a6,
                        limb2: 0x6cfab93a51b284db,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcc7fc1ebf135560a984384d,
                        limb1: 0x739055ba96c987554e2630e8,
                        limb2: 0x9da72cc18b1fd824,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x50cf2c757569290684258b2c,
                        limb1: 0x7a97f0b5459de4c10fc956aa,
                        limb2: 0x374bfa0edf047c14,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe773694b12d6b051c0dbd640,
                        limb1: 0x7a410fa189f884fc0a8eb7c7,
                        limb2: 0x1bc775bdc5b6c89e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x94f744b8f43ecc8de68e1851,
                        limb1: 0x5f4412cada25674bda3d459b,
                        limb2: 0x698ea776cdd359fb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2bb2f18ad03975516a7b37f,
                        limb1: 0x56c916aa3cc9a11c757e616,
                        limb2: 0x4bde6fbffb83d2d3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x74fdc69300e67659a5ed196,
                        limb1: 0xd72ec0fd8f38a8785c29b469,
                        limb2: 0xf3e7d1d7582835d7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf209a1d709c0d276daf94a96,
                        limb1: 0x56b62ab0243cfd2b47292be3,
                        limb2: 0x11a280bbe67b909e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8cd4fed30042e05a0313b3ea,
                        limb1: 0x7f4dcef8b6bf104c8ab91045,
                        limb2: 0x1c6feca00dccb8fc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x461e6ee04bdbafcbe6a1bf03,
                        limb1: 0xa4611f3ff76c4554d80db77b,
                        limb2: 0x4c77029b77066a6b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6d0e1a578af1025af73d9770,
                        limb1: 0x9bfd5e272d707e95f9f8e52b,
                        limb2: 0x673a77aacbd6e90c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x55dd6a28bb25257316c4af6a,
                        limb1: 0x3728e42109f277cb35fc2a1e,
                        limb2: 0x18a104dc8e2b9b56,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x39b351e37b8e9d31b8b8cb39,
                        limb1: 0x8b69164c6a40aff97159ee44,
                        limb2: 0x7d2f6656b0369ca7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x67e8b3625f17794ee71189ae,
                        limb1: 0x96f1d8c12def6c88bb93cc91,
                        limb2: 0xfe079f9eb1c4501e,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xed6d926b80859b9361bdc00f,
                limb1: 0x46199293ad99cbc962bf5e92,
                limb2: 0x3791d3704355e2b5,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xfdfdc509f368ba4395773d3a,
                    limb1: 0x8de2b60b577a13d0f83b578e,
                    limb2: 0xc2dd970269530ba2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x589fa250d638e35400c12ddf,
                    limb1: 0xb3aac19fcb5095808402aa7f,
                    limb2: 0xed6de6590d0195d1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x2965eeb3ec1fe786a6abe874,
                    limb1: 0x33e2545f82bb6add02788b8e,
                    limb2: 0xf586bc0db335d7b8,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x155b35991489db2fdf4de620,
                    limb1: 0xf24ce461346a182d67eeccf0,
                    limb2: 0xb4122bb4b37cc7d5,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x12815740835b12f70b96c66f,
                    limb1: 0xbfa76a8b80aec9f2e31c40cc,
                    limb2: 0xcd8a26d17d33c7c1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9a8f496f09402b8fd6beb89b,
                    limb1: 0x28e48918dad2123d7f202bef,
                    limb2: 0xcdd11b6ffb3f8614,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xb5076be8537cff2a42c6db68,
                    limb1: 0x1066d40cbd01a3752e4e069c,
                    limb2: 0x123ec2fd302cb0f9,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc85f5e5efdf415f8081bf53f,
                    limb1: 0xadc5010e9d9ac6c64000d33d,
                    limb2: 0xf81314011d8852e4,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd5915098d3d2001310b0b935,
                    limb1: 0x88bb4507ebf1be82cfba2397,
                    limb2: 0x8a463f1c00ce885f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x414858f8a83f9d4498890137,
                    limb1: 0xa09c4658c47ace74c42cdb60,
                    limb2: 0x8aaf300ff3ab7d98,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x1772eb803ddc8a82e23b1c05,
                    limb1: 0xc26baeb89b03fd69eb64b337,
                    limb2: 0x4ea7131b2d873a45,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc9d16330db15efd90235eed9,
                    limb1: 0x1b586ef360673d36baa16189,
                    limb2: 0xee652d2b848ad111,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x68f9e7942638253f3b596f1f,
                    limb1: 0xb37e6153d9accd97a344f384,
                    limb2: 0xda48eae9ff614551,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc58be8ed857035b34f51c620,
                    limb1: 0x3b14ed53116cb7c1db000006,
                    limb2: 0x7dfa292fe99b77dd,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xf7f7bd2513c1b31de932bbd2,
                    limb1: 0x627e2fa74b7ac891f7d555c7,
                    limb2: 0x7f8a094f818e7192,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9b47b9326b668e62071faf18,
                    limb1: 0xe21058cb6937afa89be6931a,
                    limb2: 0x21a4bfb4cce2ac8c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xaf4ad4d7d582b10b14c97e6c,
                    limb1: 0xadf808c85e766e997e470fd0,
                    limb2: 0x2714571e587ce46d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x86a7815dad7e8a53b19fee2,
                    limb1: 0x1922fc1efcc51e68146ffa1b,
                    limb2: 0x9e19b7c1f886488e,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x17bc74c409191a2b2249d987,
                    limb1: 0xf4fe5f79db38f3064f7d093e,
                    limb2: 0x3536ce04295e2a42,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb1d36a10f008c1c24de1ad7d,
                    limb1: 0xa4f2190c71ee5e0ff07c48f8,
                    limb2: 0x21c1a2d4cfff3233,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x101fbcccded733e8b421eaeb534097ca, high: 0x38c1962e9148624feac1c14f30e9c5cc,
            },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0x1759edc372ae22448b0163c1cd9d2b7d,
            },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x7d41e602eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x552f233a8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x8c1745a79a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x5129fb7c6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x870e15c2fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0xadc0da7a16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x148b2758d7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0xd450fe4aec4f217bb306d1a8e5eeac76, high: 0xd67e55fd642bfa42aef9c00b8a64c1b9,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0x37176e84d977e9933c49d76fcfc6e625,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x25e0ae5146eead827adbb1d,
                    limb1: 0x609aab8b2f94654f9d6cac6,
                    limb2: 0x853097dfea39f246,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x25fd09e456853bffe637add8,
                    limb1: 0x44330f663f6d9da943dbb0df,
                    limb2: 0x31632aa05863e742,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_1P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x1e98736cf961394cfa6dfe5e,
                limb1: 0xd7fb6593bc4d484738ba5ff9,
                limb2: 0x3133b3e2100f63a6,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x785094dfbbba459c666beaef,
                    limb1: 0x55c307610d1a86f697251ba6,
                    limb2: 0x3a9bf57c2d1f3f50,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_2P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x732ddc8e2cc76b36024c51f4,
                limb1: 0xc4691da0ba50feaacb01549d,
                limb2: 0x3b4ce309a9762fe,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xeb61555ff2e8eab1c46d48bd,
                    limb1: 0x470b0eae7200060f8562df1c,
                    limb2: 0x1e45be405dcbf244,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0xf4bfa5b3cc5f0d550830ebba,
                    limb1: 0x60db6b1216fe71b94bfc06f8,
                    limb2: 0x253e2357d973bcd8,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7238f02b9f20e09c2181a557,
                    limb1: 0x2cedcc5b0be371c337fd7e9e,
                    limb2: 0x41f3bbeb280fe8a2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf046f8cd6e5a75fca71dd19b,
                    limb1: 0x892b4613ef5c58df4ef692a4,
                    limb2: 0x7527fa36f5738847,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x4b3e865e6f4590b9a164106cf6a659e,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_3P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x6889d75e36c152c1cc46f152,
                    limb1: 0xab6c91609cc41b1c6148652e,
                    limb2: 0x6d04cda48b959e7b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xd12689aa4a75942f20369ac5,
                    limb1: 0x5d6ae4c0a9977c4e19538008,
                    limb2: 0x101fd900dd268a39,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x4cf7cf1e83ac6ddeb4c0d88,
                    limb1: 0xdf032c7d359dec2b1b30b922,
                    limb2: 0x1b4e7ef7358304ab,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x90887d2f101702d94aa5377f,
                    limb1: 0x3fdfadebd967a872d02af758,
                    limb2: 0x2ea0b09931ec6dc4,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x506c121a6c7fd9aa60e121a3,
                    limb1: 0x23b636b641b29ef8bdd1c639,
                    limb2: 0x791b6ec60b5f8598,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x59f9c615c1fecf831ca3b5fc,
                    limb1: 0x2f6fb1f6358caa9cb6f8c9f7,
                    limb2: 0x6e62064b941a23df,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xe69974737b88f1268fe9aaae,
                        limb1: 0x8c1559e40bcf30fa0bd7903c,
                        limb2: 0x4b532cae5bfa2c57,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfa9035e798d15baf399b3b7d,
                        limb1: 0x8e289acf0c43e298455b089c,
                        limb2: 0x5e626a1eb94c848c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x654e97c8202baacafd347411,
                        limb1: 0xbbc95eee2c80600c3e370615,
                        limb2: 0x125df9e9282cba82,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x183a985c65551f6ba3d83980,
                        limb1: 0x134ad9dbc6c8c9ef9842342a,
                        limb2: 0x3a6b860a6754781f,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xe1dd890ca42bb6787953ac8e,
                        limb1: 0xd1043346a7687fcd1c173684,
                        limb2: 0x25ac41ef53a8b264,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1a927f53bc1929ea47a340ce,
                        limb1: 0x1d066482260ad25a944af22a,
                        limb2: 0x5099f019034be8fe,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdd8253ada22de2f45fdf5202,
                        limb1: 0x5441006694aef1a85b444399,
                        limb2: 0x235d0862dfa6cdf4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbf55f655e635b433fffa06df,
                        limb1: 0x9529a92891026d5feaca56b6,
                        limb2: 0x66f328ef9578380b,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xff4a7e8b7f2cfcdbcee5a4b1,
                        limb1: 0xe12c1714e746fb90fbaacda2,
                        limb2: 0x74e32598c1f69b37,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xec4097839b45ff546026a0c2,
                        limb1: 0xae7581a88eae4a5053b8f9dc,
                        limb2: 0x39c19c5066a7bb2b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe66b928f5f906da6b564a19,
                        limb1: 0xe6eb535ca7ed037f82d2c152,
                        limb2: 0x71e49573bad6c71d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3c366ce7ca838787367666b9,
                        limb1: 0xe4fe0f13556bcdf6e6ed8414,
                        limb2: 0x7242e8cce5ff3b6f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc199caa040b67c0c31530366,
                        limb1: 0x862fb1b3977b470bdf71fa33,
                        limb2: 0x56f64010ec27341b,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x5c9b04b3b245e09a4194094c,
                        limb1: 0xdd37f3697ab22b9010a7a63,
                        limb2: 0x5128c8fdc31f7a9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x823a7a3274ed4f8afd3da5ad,
                        limb1: 0x97bab3dd38c5e707cb7b2c8,
                        limb2: 0x5a9b9fb5a904e5b7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x136a754b8e6ef4fbbdb2c19c,
                        limb1: 0xccb7829961063c89b98962cb,
                        limb2: 0x72b6443d8587b85b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4d61d2ba560cb6cdace82b43,
                        limb1: 0x4ec094a713c7dd9c57d2239e,
                        limb2: 0x6d86d878336d2975,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x64419bccfa5228f31d1d0868,
                        limb1: 0x3d89f6514c52a71529d25b3e,
                        limb2: 0x6282237340916256,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xea277ea54e9fc483589b6942,
                        limb1: 0x85d8e173f62a2f7ec6fcf9f6,
                        limb2: 0xabb53685608cda,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbf55f655e635b433fffa06df,
                        limb1: 0x9529a92891026d5feaca56b6,
                        limb2: 0x66f328ef9578380b,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x6fd4e3f593a17ba71159d847,
                limb1: 0x1118616a869823a48ad75add,
                limb2: 0x15473f9ff2346518,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7238f02b9f20e09c2181a557,
                    limb1: 0x2cedcc5b0be371c337fd7e9e,
                    limb2: 0x41f3bbeb280fe8a2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf046f8cd6e5a75fca71dd19b,
                    limb1: 0x892b4613ef5c58df4ef692a4,
                    limb2: 0x7527fa36f5738847,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x82e4a33f8e4e5881e791d86b,
                    limb1: 0xbcb062435ae8ec5fdaeac4bf,
                    limb2: 0x179e1bae9e0f9f34,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x19657783ba5660e255c21849,
                    limb1: 0x7ed7474bcea7551fc71e46bc,
                    limb2: 0x596c0a76b75f4756,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0xa90f9c3af19922ad9b8a714e61a441c,
            },
            u256 {
                low: 0xeb2083e6ce164dba0ff18e0242af9fc3, high: 0x2fc154703983ca8ea7e9d498c778ea6,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xf7d884feff5aba51d9990dce,
                    limb1: 0x999f1d302046c6266257ff5,
                    limb2: 0x7f9caa5ee5815899,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x6d71279424538e87f8ecf2cc,
                    limb1: 0x8a8a1d74581da5996a52bbaf,
                    limb2: 0x29acff692eccea25,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_4P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x4294ed9005d37292f5249462,
                    limb1: 0xb9dea23ee010208506806803,
                    limb2: 0x16031442f6384311,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7fa969c45724b811994c64c0,
                    limb1: 0xf428138bac627a290dd35105,
                    limb2: 0x3da98277c2dd5c48,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x87cbb10853f51a0d7e8a9269,
                    limb1: 0xebcb43a99df5add16574dccf,
                    limb2: 0x1b8613d1c8f4df23,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x686cbe3acd25538efa3b9366,
                    limb1: 0xbe1fcf5f60e8d7d953189e25,
                    limb2: 0x4a1d28d3efde830a,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xdb595542dfeb4f13942824b7,
                    limb1: 0xd68b7cd8156fbe5dd6a83d78,
                    limb2: 0x3060395777cff710,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xef83f2592b0828d47429e8b5,
                    limb1: 0x6af76f6b2e1231c02a5b3e78,
                    limb2: 0x4319a9f39260d0e7,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x1245190a92f354fb39135014,
                        limb1: 0x2356c2873853a0c30f1981a5,
                        limb2: 0x4bea14241c4648bf,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7161430369f11ad91cafaa09,
                        limb1: 0x3c362a37f9eae052453c1baf,
                        limb2: 0xf653332221e6bed,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x830813297b8e4af8a48f15a,
                        limb1: 0xf95bc4e7a0f6cb17fc03fa2,
                        limb2: 0x42149201470d712d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeed49d5e8852ee80c47f8756,
                        limb1: 0x352599d2881847f573797a63,
                        limb2: 0x7505f28aca05a877,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6c108e3cf17d739abe2e5b52,
                        limb1: 0xec1abdec66af37713ef5fa0c,
                        limb2: 0x7a98469eaf19c90c,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xc3f2bcf0634113aab168f16b,
                        limb1: 0xacece764e432e9a362270873,
                        limb2: 0x553f156657701585,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x132784a5fa8542cd2b13e915,
                        limb1: 0x9c6be3686e0be6a93f659967,
                        limb2: 0x5c4a93274bad5556,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x11fc6f6dff141670dade42b8,
                        limb1: 0x42bcf0b6d084414f6d5233,
                        limb2: 0x2026aaa1e7249ef5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xab822761217de62211b1bc7c,
                        limb1: 0xd543e6a9f4fb52cf6a95b072,
                        limb2: 0x69adae066d530a1c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x30de39ed3965d44c28c9418b,
                        limb1: 0xd58fca201fc52c751bf1deaa,
                        limb2: 0x1bb6cb2566ea35e4,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xc35a0dd5134b1c20a50cd68e,
                        limb1: 0x9616cabc4d9e6333e11402e1,
                        limb2: 0x64b51ca8d6ba3923,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa194688fc458cc14dcf0305e,
                        limb1: 0x56ff7a483a7c0e1161566560,
                        limb2: 0x25e2e19cb813454,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7f27868bc80ece088387f817,
                        limb1: 0xff6245179ef3f2af1891195,
                        limb2: 0x639fda52a62704a0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd9d9eabe33272dce5eedf1b7,
                        limb1: 0x2edc1591d2f1b9abe09f34cb,
                        limb2: 0xa76b4552c437e46,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x29af65a1a07435e9af5abcb1,
                        limb1: 0x83845e0ed474d5f5dbe1eb71,
                        limb2: 0x9885213567cc2d4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x23dad12875c267eacf012596,
                        limb1: 0xd7e084fba8956bdd30c5b2b0,
                        limb2: 0x3a4d0dc33b4d4422,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xbaae60c51c20bb7b9eccd6f5,
                        limb1: 0xfa62a673ac9873f2df7b85bd,
                        limb2: 0x25b6aec1e0c93c18,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x43a3d232f8215733421ea32d,
                        limb1: 0x9a36dfd476d79bfc3a5ecdf2,
                        limb2: 0xaf9fb27179ac73a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfc6522fca2e80e4a2861d77d,
                        limb1: 0x370368d9bc35d525bcf700b6,
                        limb2: 0x79e34017092cb11d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x19191017a5d86b1481147c75,
                        limb1: 0x9da168e46e58f4b527200f6,
                        limb2: 0x2526e15ff84302bf,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8b31993617c145fe7a9f52b6,
                        limb1: 0xf9957de16671919f3998c2ae,
                        limb2: 0x33911c89d1dab5e2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2b4f66ee5babf1d3ab430a7a,
                        limb1: 0x83cd22a0952e6a109a0ed7ec,
                        limb2: 0x41db7964e0059019,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb8275258cdefc7b10a6dd3bc,
                        limb1: 0x6dbc7b7567690a5d64e66cf,
                        limb2: 0x46fc5ada130cc903,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x30de39ed3965d44c28c9418b,
                        limb1: 0xd58fca201fc52c751bf1deaa,
                        limb2: 0x1bb6cb2566ea35e4,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x15505ddd857847cc97bc932c,
                limb1: 0x967506820b8939decb014cf5,
                limb2: 0x1e1976cd733cac42,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x41f4fb8dfd4016a6fbcd1dfa,
                    limb1: 0x856a5141ccb93613b344415c,
                    limb2: 0x70e4850b14e402e,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7238f02b9f20e09c2181a557,
                    limb1: 0x2cedcc5b0be371c337fd7e9e,
                    limb2: 0x41f3bbeb280fe8a2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf046f8cd6e5a75fca71dd19b,
                    limb1: 0x892b4613ef5c58df4ef692a4,
                    limb2: 0x7527fa36f5738847,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x82e4a33f8e4e5881e791d86b,
                    limb1: 0xbcb062435ae8ec5fdaeac4bf,
                    limb2: 0x179e1bae9e0f9f34,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x19657783ba5660e255c21849,
                    limb1: 0x7ed7474bcea7551fc71e46bc,
                    limb2: 0x596c0a76b75f4756,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xa6832ef7fe97f77de7cd9a62,
                    limb1: 0xf18a70dbf1dc5a76c685da4a,
                    limb2: 0x6ac1b7bfc409119f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7751161b1a9ef600b865a5af,
                    limb1: 0xed28aad4835a39a9e8318ceb,
                    limb2: 0x572e95c429f0e07a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xeb2083e6ce164dba0ff18e0242af9fc3, high: 0x2fc154703983ca8ea7e9d498c778ea6,
            },
            u256 {
                low: 0x101fbcccded733e8b421eaeb534097ca, high: 0x71832c59148624feac1c14f30e9c5cc,
            },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0x2eb3db872ae22448b0163c1cd9d2b7d,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xc90d60304c5ae1ed8e6a7452,
                    limb1: 0x9b1adf93edd9e9d89e46bb66,
                    limb2: 0x2354b27669ad10ec,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xaeb348edde7fa116aa741cc1,
                    limb1: 0x401b6f0f1099439b965ba00c,
                    limb2: 0x165e684174b4ed0b,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_10P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xc6a2dadd7bfa3f0e246e658b,
                    limb1: 0x35fef39b5deb611ff2012432,
                    limb2: 0x69111c4bba88905b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf8f8b650214ea0042241e1af,
                    limb1: 0x9c0c86816e5b32d3958069ab,
                    limb2: 0x4f7c96eef9002e62,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xfdd785e0b0c8c7cc6c9d28de,
                    limb1: 0x8122f1bdba903598618e0cc8,
                    limb2: 0x1cee60d8a8b3f4b1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x76aab4f568a16f049413f213,
                    limb1: 0x69ce55459d82821adb310e48,
                    limb2: 0x6491ade0e5fcad87,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x7f4c4fae4ccc048a1ec31085,
                    limb1: 0xc699c0ce71f1b1891d539ca3,
                    limb2: 0x6cec90835491d044,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb956cd0696fbe12afef76c13,
                    limb1: 0x91ab61eaed3055a23afad034,
                    limb2: 0x24109e0f46a426c1,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xde0eccee19a7e1c02da7749,
                        limb1: 0x720111429cd793328d5eb90d,
                        limb2: 0x1aded618573ad7c8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2490d569119a906df97f7268,
                        limb1: 0x9271757a53d1a05e0d4846fd,
                        limb2: 0x61c2345e5f452da9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb1e9f7137010f65ca3aed573,
                        limb1: 0xf891300ceef0f5293cf9ff8c,
                        limb2: 0x64b2b3997f8985d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe3f00a12f62b88af4c065bdc,
                        limb1: 0x1cec25a223cee045fa1eb1d1,
                        limb2: 0x196b55f16087f1ed,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd1b71e19fb05670c2232b0d4,
                        limb1: 0xe8e7cb8f33657568df7f9aab,
                        limb2: 0x1691a7853d3d6d34,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x72e1884b5c65d17e26cdc854,
                        limb1: 0x3046571d00d86ac453a9d91f,
                        limb2: 0x55e47961b0020227,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc03a13e638d9812cbcf309dc,
                        limb1: 0x75ba7389c891ba0761b0914a,
                        limb2: 0x763b0b03461a7f80,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd65156e0c7a756baa9a4ad0f,
                        limb1: 0x75d804139d3dfadf8b0d50b4,
                        limb2: 0x6b81e245f66f08a1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xee4d755ef35acd1008234a86,
                        limb1: 0x96af6acb6745a090bdf4ff84,
                        limb2: 0x29193da4184abf0b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe20d2f0c0ede49351c05bd4e,
                        limb1: 0x61e7cb003971e397ab2199a5,
                        limb2: 0x1235b5be8a26b4c3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8abc060f09ce716484e39ae0,
                        limb1: 0x53d0da4a8192940ff15bd192,
                        limb2: 0x6ad3c1f370737302,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xf5f70f0243a0077afe6f7a80,
                        limb1: 0xf61ba838f96e5dbe54b8fbc8,
                        limb2: 0x7bfe1917e9814460,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb4cd93de8458053f6d02b8a7,
                        limb1: 0x411c32b5b880cd7f6bbd0ee0,
                        limb2: 0x276a1fcdb03a1dda,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9911457a134ca92cabaf0813,
                        limb1: 0xa46e97d642de505bd1e1b05e,
                        limb2: 0x709058365bde688e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1d7de26ecc807fc690e4e43d,
                        limb1: 0xa7cad88664e5d6a8e920893f,
                        limb2: 0x1bf69c542060d564,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5d02aaadd49697e8ceefc4f0,
                        limb1: 0xb80fc82b600fbc38a166ae05,
                        limb2: 0x2108c0d78c34a933,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xde8cc89609d395d3857b526c,
                        limb1: 0x8d27f6bd911dca4e4e35338d,
                        limb2: 0x6ed28ec1f40b2a80,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7f332aa618294143cc99c8ea,
                        limb1: 0x7f16b45e266bd698bfe7db10,
                        limb2: 0x37e1f193f25bd8e7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf5e9e49f0b69cefcbe984cfc,
                        limb1: 0xe3481300898ef46ba1612a32,
                        limb2: 0x18fc9a3d7ecff724,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xba5a045ed8b4c7839e9fd785,
                        limb1: 0xdee8651114919a7d9938f7e4,
                        limb2: 0x15a3ac4e2161fb37,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5c99d5cbc050ad147353fc3c,
                        limb1: 0x371f51b73f89600818bc1c14,
                        limb2: 0x50280f3a2db789ab,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfbad18a3a60d2d4f4ba17994,
                        limb1: 0x9131eab5dfff09ae22c4f26a,
                        limb2: 0x696e276b49ed8226,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x4be00c2b686f54e2cb14cb18,
                        limb1: 0x55c57eef2d613f91460146da,
                        limb2: 0x5e0ff25fc14a27e5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xea8e14144bad5b00e62eb5cb,
                        limb1: 0x75235fa505bff996f5190012,
                        limb2: 0x2df2e1c15bdd6cb1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbedb58e5a8fd58c85a8279ae,
                        limb1: 0x981426d7de32d35d2eda758c,
                        limb2: 0x2f5d40e2f6cdebe8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa4ce0c373f701cb77d5bec87,
                        limb1: 0x1b14022e9805bde47057d4a1,
                        limb2: 0x5b2fd3cb2b749bde,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc74d385623f39508a8b82ca7,
                        limb1: 0xa9cd07a695cd51652eba897f,
                        limb2: 0x72af1478903ba58b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbabb46d08a914aa63f81aa8e,
                        limb1: 0x3ee14f4d6726efd58b504beb,
                        limb2: 0x354b0d3de8d2c8e0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe3548c3dd4a70d2066a408ea,
                        limb1: 0xc8d2aad767b01f8b057f3caa,
                        limb2: 0x2bbaabf71fe42e51,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcc2ddfbc2b96d5c5c16e12ac,
                        limb1: 0xce4d27849ade7d3397c4746b,
                        limb2: 0x47372937fee9ef7d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x182999273d99a6cccc0b94a2,
                        limb1: 0xc6b0524dd1da33875937593f,
                        limb2: 0x42dcc15f6bb92f96,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x178ebd04708ffc65f255de7e,
                        limb1: 0x8211fea129e7ef192efbca,
                        limb2: 0xe66793bada5bede,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa2cf6ee5e3e8cfd4a6e996f1,
                        limb1: 0xe2bf87ec79548fa4b585b6ed,
                        limb2: 0x5842e47b90b7c3ab,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5866c894c0452a9dc6f2d9f2,
                        limb1: 0xd03c914c3824fa3009130903,
                        limb2: 0x6c5c8b0312255b16,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x6aba2a81ef70460d420d1b17,
                        limb1: 0x58ab7c099f87a66f48cf36f7,
                        limb2: 0x7e6ae6755d528dd3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf1eecdf77b964c711d9337a1,
                        limb1: 0x44d52315b66561885c50d76f,
                        limb2: 0x36e83e804a278969,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x89fa3412c438e08a6daa92d,
                        limb1: 0xbb9a6ff84d64d12a1d218cbb,
                        limb2: 0x2ff96687e2ece132,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb0fb6300671c9a0091969f56,
                        limb1: 0x1cbfe1bfd3e1339bff858e47,
                        limb2: 0x4b2786d9b4c8fa6b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3128ea0d6c4fbe24d836cc54,
                        limb1: 0x64829f8a5026023871f4b1ef,
                        limb2: 0x281fd6287c0765fa,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4a47011452a47a6fe69e82c0,
                        limb1: 0xdf4aee00a8f9412cf7f793a8,
                        limb2: 0x2de0cdee70d20aab,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa26e1cafa9089fe0a2bae9c3,
                        limb1: 0x6863265ef801bdab75f3fd0f,
                        limb2: 0x392b26962a417f04,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x12d57884d5ebd40773ffd5db,
                        limb1: 0x542c81414255dd612e6f234,
                        limb2: 0x1dd669d98b2427e0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x65646871fd400bf8dac19646,
                        limb1: 0xa906550da44746b5093b8e1d,
                        limb2: 0x7e8fb9fb236d059f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xedffe0fa31c014ff973311a0,
                        limb1: 0x30781bbaeece86331e7908e8,
                        limb2: 0x371a2cd40e3e6415,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xce90aa658d2c289d98c68707,
                        limb1: 0xa1ac66c827180a87cf47b684,
                        limb2: 0x4b4dffa3ba322213,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7ce8ac9682b828d53ae6d67b,
                        limb1: 0xc1a025f07355e8808660bb56,
                        limb2: 0x13e54ed6edcc7476,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x693f00c36cc28ea36c10137c,
                        limb1: 0x68b732c4a1049dde8474d271,
                        limb2: 0x2d76bc0dd3714891,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfbad18a3a60d2d4f4ba17994,
                        limb1: 0x9131eab5dfff09ae22c4f26a,
                        limb2: 0x696e276b49ed8226,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x81ec98c9fa009603acb8e347,
                limb1: 0xfba93f564697f066a290c713,
                limb2: 0x6f5cf5e56e524b8,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7238f02b9f20e09c2181a557,
                    limb1: 0x2cedcc5b0be371c337fd7e9e,
                    limb2: 0x41f3bbeb280fe8a2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf046f8cd6e5a75fca71dd19b,
                    limb1: 0x892b4613ef5c58df4ef692a4,
                    limb2: 0x7527fa36f5738847,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x82e4a33f8e4e5881e791d86b,
                    limb1: 0xbcb062435ae8ec5fdaeac4bf,
                    limb2: 0x179e1bae9e0f9f34,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x19657783ba5660e255c21849,
                    limb1: 0x7ed7474bcea7551fc71e46bc,
                    limb2: 0x596c0a76b75f4756,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xa6832ef7fe97f77de7cd9a62,
                    limb1: 0xf18a70dbf1dc5a76c685da4a,
                    limb2: 0x6ac1b7bfc409119f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7751161b1a9ef600b865a5af,
                    limb1: 0xed28aad4835a39a9e8318ceb,
                    limb2: 0x572e95c429f0e07a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5e71d0fc5d1c016834779173,
                    limb1: 0xadd002dfc0ebf1b25c23c252,
                    limb2: 0x40a868d928ae5233,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x423fa293418d6e3f59c2e830,
                    limb1: 0x7a4bcf26f93e71ffd903e68e,
                    limb2: 0x7837b851ad8da6e3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5907087f8e8e4dacdd039371,
                    limb1: 0xc390e2073b4e64b9ede0570d,
                    limb2: 0x6b039a85962f1594,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc45eefa03155b8f7eb780b42,
                    limb1: 0x3db57eb22f9b0394a4d7b78e,
                    limb2: 0x6cf45b6d90883f60,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x60dd8ed0a614b596fb37eb1f,
                    limb1: 0xabb99f371be41e26ec2d8e4b,
                    limb2: 0x187ecd72c40f159d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7b66c9263de5e1663622985d,
                    limb1: 0x118b032cc27a1d6dd192eca6,
                    limb2: 0x312fb405788616e8,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xf4ac3e1f1f068dd64c86fdda,
                    limb1: 0x24594e591d82a7f964b5ec9f,
                    limb2: 0x6ca311b5421c57fc,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x42745cd7b146012455434d0f,
                    limb1: 0x6aa4f552b7bdc93a613bd9df,
                    limb2: 0x5832a065d7199c7a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x341786b7854e3e0104e2e416,
                    limb1: 0xbb368441c295043bee7b1d2f,
                    limb2: 0x35c88542e11463b4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x3c36e7fcc4e2fde28308132,
                    limb1: 0xf58043d0e3d1a36d1f8137fc,
                    limb2: 0x58c1508fbe8868a8,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x560a37951d69a6c8d7138239,
                    limb1: 0x462d454a509846714184ef71,
                    limb2: 0x3aaf8fb4f60e3e9c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb70cea4e13db5322899753f9,
                    limb1: 0x6c62656b6d7ffb5c2af44fd5,
                    limb2: 0x4b5ae4567dc6a7c0,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x10e1c2b2fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x29164ebd7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0x6e2edd0d977e9933c49d76fcfc6e625,
            },
            u256 {
                low: 0xd344749096fd35d0adf20806e5214606, high: 0x8ce86e89466e4726b5f5241f323ca74,
            },
            u256 {
                low: 0x30bcab0ed857010255d44936a1515607, high: 0x8ac57cfbb42e0b20426465e3e37952d,
            },
            u256 {
                low: 0x5f3f563838701a14b490b6081dfc8352, high: 0xda2ddc3552116dd2ba4b180cb69ca38,
            },
            u256 {
                low: 0xc87a746319c16a0d0febd845d0dfae43, high: 0x7003168b29a8b06daf66c5f2577bffa,
            },
            u256 {
                low: 0x176ea1b164264cd51ea45cd69371a71f, high: 0x3b6a666fb0323a1d576d4155ec17dbe,
            },
            u256 {
                low: 0x9edfa3da6cf55b158b53031d05d51433, high: 0x23d79a9428a1c22d5fdb76a19fbeb1d,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x953e7b69bc51afd0e8ee14e8,
                    limb1: 0x88f2a3f463abe0e4d99ed2b4,
                    limb2: 0x282277c34990a0db,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc4b37aaf5a797b777a89ebc3,
                    limb1: 0xec1836313170e0d9647efdf3,
                    limb2: 0x63f08f0867a4694d,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_11P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xf7f73668ed31827e6a25b1e8,
                    limb1: 0xa31457d7a2c542bbf3b3c13,
                    limb2: 0x7d799610c8f16ab4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x6c03502900d94323a740e874,
                    limb1: 0xc399c691ef16e90aa7f2e45a,
                    limb2: 0x6c1d54069d32fa1e,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x9f5046b366b4e82578ea7cfd,
                    limb1: 0x5657ceee8f185b72bd049708,
                    limb2: 0x53c3ed1e985a9f2a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf14204086006b6971e3d450,
                    limb1: 0x8c84b71627d8b4bd5d0713cc,
                    limb2: 0x13f218899f7041e4,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x25b995ad06874ea339c7afd3,
                    limb1: 0x68f3a5868e23705dbaa50f78,
                    limb2: 0x2a0c6e906ba7ad96,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x1135152280c1d9643c6ae557,
                    limb1: 0xf2529e96d78f463c1cf0d966,
                    limb2: 0x6b61d89001e0d390,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x2e742f3d9cbdefdd73113073,
                        limb1: 0x67fe8ffbea3c17f5a002eedd,
                        limb2: 0xe506536da7bf16e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd126cb3cd730b818de2624bc,
                        limb1: 0x8b751c7c64c6aaa38b98601c,
                        limb2: 0x2e8714c387fd6f82,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe555573b080a984b0ddfd5b7,
                        limb1: 0xc8f02fa06451530e73be6f63,
                        limb2: 0x39bcdb5b56883e9a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1798726c819c7783ab7f038f,
                        limb1: 0xe788b5ea9c47e1826090898e,
                        limb2: 0x13ec5f23c8b5bc43,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8cc0da6a6236ef707bda54b8,
                        limb1: 0x10a3b1ad2a34798976966a53,
                        limb2: 0x136193a2885eccd0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9186b9521e2d6f1ece443b58,
                        limb1: 0x87c456fb5d8489efe4d7509b,
                        limb2: 0x78293def00ee1577,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x41601c2865a912db7c8ac9c9,
                        limb1: 0xb7b885823e953ca30f6a77cd,
                        limb2: 0x78ce2847f63ec245,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x558c0309f34095a5fe799977,
                        limb1: 0xc1391d44788ef596587bf63a,
                        limb2: 0x6e904194151f085e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd99813daa943071c30475839,
                        limb1: 0xe062f33ade676b0aa9a897e4,
                        limb2: 0x411a45534b170b7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa8a468151642d97b8a6cecd1,
                        limb1: 0x22578b4c1029bee6f4578ff8,
                        limb2: 0x478a7690da534a58,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x794dbe931d56a7939a061049,
                        limb1: 0x31e7a3b41d762eafbf4f5dae,
                        limb2: 0x5a988b05b1f64236,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc022279cf32a8b05c80e6a62,
                        limb1: 0x9b6fc2bd314c187b5f1cd6ce,
                        limb2: 0x1b483b2da7027421,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x9cda2e302366377171cc82a6,
                        limb1: 0xe3e3dad3bdeaa33063fddc6,
                        limb2: 0x4329fbf9c026acea,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3770918da7441cb0ab4196f7,
                        limb1: 0x2d2f16fd65dbbd5c10cd75a2,
                        limb2: 0x17ff3edc194d68b6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x391373027457fdc75d4444b2,
                        limb1: 0x5f4bcbc3bc90f4ee8ea015f9,
                        limb2: 0x6926f31aadd8ec3f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x320ea95d2516fdf758d23671,
                        limb1: 0xd5023c332d003ff97758bfd1,
                        limb2: 0x7db2fe4b91bf5870,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x66c5c34e88ce615c6cb290a0,
                        limb1: 0x4cfedd0c32af5cd2d30761b9,
                        limb2: 0x4cb66588dedde84a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6acaa0a007d782b1f43b6bc3,
                        limb1: 0x81b46d1da5e337db7372f479,
                        limb2: 0x1e1e7516f1548702,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe9c4cdc8e7ea4eb45fdf792e,
                        limb1: 0xf058d29c9c57cf1087ae8cc,
                        limb2: 0x3cf7669396f0898e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8fd6406980cc1513e3e70bb,
                        limb1: 0x301de9cb700fcb44f0834303,
                        limb2: 0x1230985ecf8ec3b3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x291d1ebdcccec5063d394648,
                        limb1: 0xd1873d2257f45fc052784cff,
                        limb2: 0x2f8c26f8e4f4c6fd,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc6516ff2a21c364dedafac02,
                        limb1: 0xed140f7803ed0f768d900597,
                        limb2: 0x50b5051c47a60371,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x499fd02245dca6202fd54521,
                        limb1: 0x6280a650a5f4c94fa8c10d03,
                        limb2: 0x19470e3f920d110b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd205e9921108aa553f45b75a,
                        limb1: 0x776f5ac2b8cbd09c55bc0fee,
                        limb2: 0x1e3efb0c587fbf57,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x93ad4b9763b0de0fc0c0844e,
                        limb1: 0xd518af12b6e63e2c7bd54e2,
                        limb2: 0x72cc0485b6ed657a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9b764061d9098e862f8cd4a8,
                        limb1: 0xeaad0e30d30091cd364a4cad,
                        limb2: 0x763f590fa9389c9d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdd2eeb3978979aba4d02c944,
                        limb1: 0xdb699a680afdbcd70a1651c9,
                        limb2: 0x376757ee3a1fac9f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5c86da72aedf5b98305a365,
                        limb1: 0x5d74aa401fd4f539512c23f6,
                        limb2: 0x165018b95032b2fc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x25a98febef34ad7480b7b529,
                        limb1: 0xeab5cb6e32f485662d583196,
                        limb2: 0x721453673c96d326,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe745c9baa70ee618755c7fd4,
                        limb1: 0xf82eff8dd6332652787b6b86,
                        limb2: 0x306d0d5a7a2d978d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x74aa65ccd9252aa8a84465d5,
                        limb1: 0xfb6056154834c19887b891eb,
                        limb2: 0x12fb4eddd947ddef,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6fe1fbddac1a39d990a2067c,
                        limb1: 0xf3683dbbe173344764f7505a,
                        limb2: 0x1a2e3eda21b0ebe,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x280be09493f5a8b91bb1b6a7,
                        limb1: 0x1f95f721eec5c731026cb4e0,
                        limb2: 0x6d542e5bf042b94d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe7cfb9f1d99def11b0233390,
                        limb1: 0x79954b3cac6c7e339af268a2,
                        limb2: 0x4e97add6c732166,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3ce90a9542916b32952b82bb,
                        limb1: 0xa8c0339320480164d1512b55,
                        limb2: 0x3eece52f40b4681c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7ed13ab720c15ed86e6e6e61,
                        limb1: 0x1635d187018bd92ade2a5bc9,
                        limb2: 0x66f7975dcc19630a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfa9e6cabae8b56b48f983853,
                        limb1: 0x26eeb471d00e1aa629a3d351,
                        limb2: 0x25afb6f5c9f9fa5,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x7789a937a1bce0e5d0e3847,
                        limb1: 0x69ffbf6df08ea603182cb143,
                        limb2: 0x47f7faef3d5b9e2c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6f41440f1a825a594286b43d,
                        limb1: 0x811124125910aca02374b18f,
                        limb2: 0x5f7d10700d0e580a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4a65f9be094f9ab8d3851649,
                        limb1: 0xbce603238b381116f4957645,
                        limb2: 0xdb46c1a5b4948d6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5284ed62f63b70f5e656c5e0,
                        limb1: 0x65b8f31d47b89defc245bfaf,
                        limb2: 0x7f3d15c11345bb3b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5b35440d0cbd4d01c1b2ebc9,
                        limb1: 0x2fd64a4cc840e16f23de1f0a,
                        limb2: 0x4c614d91bf42dc01,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe1d31429454ed8b3ecefc67c,
                        limb1: 0x366d0c3b1ab432aab2ed6c7e,
                        limb2: 0x3364cdedc20c8f30,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6abe7d3bafe0312bc3929fd7,
                        limb1: 0x43c0dea9724dd31936a39328,
                        limb2: 0x1c2c0c85b2bf229b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x217ec2ffca7cc593364532f0,
                        limb1: 0x242fdb8aafd09bec78a7143a,
                        limb2: 0x75b3566b974acb9c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfcc3abd1fc0b7f1f289df44b,
                        limb1: 0x87c919b0e10a7a0b5b9dd2d9,
                        limb2: 0x8686ce11fd1724d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x54b31f1351a94e1886070e4b,
                        limb1: 0xa75325315d1fc66c112bc40a,
                        limb2: 0x5925f7d4025073b7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeb04a4df264f94a640ccc985,
                        limb1: 0x416e98ad4fa5488ca54c66d4,
                        limb2: 0x1449e7f9bc3a7f43,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7d9bb529995917ef940de5ff,
                        limb1: 0x1534686a0f9e98335b3da8ae,
                        limb2: 0x8ee7000cd3da1f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1fd7e65d4b6df32ef5e8c9f,
                        limb1: 0x6813c2e9ee4edc8747844577,
                        limb2: 0x710c1abc39ccd151,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5644fb19f24e87af28915c4e,
                        limb1: 0x9418875e077007261479c360,
                        limb2: 0x7695bb1337c6cff1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd205e9921108aa553f45b75a,
                        limb1: 0x776f5ac2b8cbd09c55bc0fee,
                        limb2: 0x1e3efb0c587fbf57,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xc60200a5e3dd769d410ff97b,
                limb1: 0xcbebb6afca6d06b305602a19,
                limb2: 0x390c4955f0f30842,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7238f02b9f20e09c2181a557,
                    limb1: 0x2cedcc5b0be371c337fd7e9e,
                    limb2: 0x41f3bbeb280fe8a2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf046f8cd6e5a75fca71dd19b,
                    limb1: 0x892b4613ef5c58df4ef692a4,
                    limb2: 0x7527fa36f5738847,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x82e4a33f8e4e5881e791d86b,
                    limb1: 0xbcb062435ae8ec5fdaeac4bf,
                    limb2: 0x179e1bae9e0f9f34,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x19657783ba5660e255c21849,
                    limb1: 0x7ed7474bcea7551fc71e46bc,
                    limb2: 0x596c0a76b75f4756,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xa6832ef7fe97f77de7cd9a62,
                    limb1: 0xf18a70dbf1dc5a76c685da4a,
                    limb2: 0x6ac1b7bfc409119f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7751161b1a9ef600b865a5af,
                    limb1: 0xed28aad4835a39a9e8318ceb,
                    limb2: 0x572e95c429f0e07a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5e71d0fc5d1c016834779173,
                    limb1: 0xadd002dfc0ebf1b25c23c252,
                    limb2: 0x40a868d928ae5233,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x423fa293418d6e3f59c2e830,
                    limb1: 0x7a4bcf26f93e71ffd903e68e,
                    limb2: 0x7837b851ad8da6e3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5907087f8e8e4dacdd039371,
                    limb1: 0xc390e2073b4e64b9ede0570d,
                    limb2: 0x6b039a85962f1594,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc45eefa03155b8f7eb780b42,
                    limb1: 0x3db57eb22f9b0394a4d7b78e,
                    limb2: 0x6cf45b6d90883f60,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x60dd8ed0a614b596fb37eb1f,
                    limb1: 0xabb99f371be41e26ec2d8e4b,
                    limb2: 0x187ecd72c40f159d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7b66c9263de5e1663622985d,
                    limb1: 0x118b032cc27a1d6dd192eca6,
                    limb2: 0x312fb405788616e8,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xf4ac3e1f1f068dd64c86fdda,
                    limb1: 0x24594e591d82a7f964b5ec9f,
                    limb2: 0x6ca311b5421c57fc,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x42745cd7b146012455434d0f,
                    limb1: 0x6aa4f552b7bdc93a613bd9df,
                    limb2: 0x5832a065d7199c7a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x341786b7854e3e0104e2e416,
                    limb1: 0xbb368441c295043bee7b1d2f,
                    limb2: 0x35c88542e11463b4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x3c36e7fcc4e2fde28308132,
                    limb1: 0xf58043d0e3d1a36d1f8137fc,
                    limb2: 0x58c1508fbe8868a8,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x560a37951d69a6c8d7138239,
                    limb1: 0x462d454a509846714184ef71,
                    limb2: 0x3aaf8fb4f60e3e9c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb70cea4e13db5322899753f9,
                    limb1: 0x6c62656b6d7ffb5c2af44fd5,
                    limb2: 0x4b5ae4567dc6a7c0,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xb06cccb4b425d5179f528270,
                    limb1: 0xce017c281a3861570706cd86,
                    limb2: 0x42d14846dc4860ab,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x646bf486f6e77663c597ece8,
                    limb1: 0xd87c8c36a430a6fe42305b88,
                    limb2: 0x7964c7742b6f13da,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x29164ebd7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0x6e2edd0d977e9933c49d76fcfc6e625,
            },
            u256 {
                low: 0xd344749096fd35d0adf20806e5214606, high: 0x8ce86e89466e4726b5f5241f323ca74,
            },
            u256 {
                low: 0x30bcab0ed857010255d44936a1515607, high: 0x8ac57cfbb42e0b20426465e3e37952d,
            },
            u256 {
                low: 0x5f3f563838701a14b490b6081dfc8352, high: 0xda2ddc3552116dd2ba4b180cb69ca38,
            },
            u256 {
                low: 0xc87a746319c16a0d0febd845d0dfae43, high: 0x7003168b29a8b06daf66c5f2577bffa,
            },
            u256 {
                low: 0x176ea1b164264cd51ea45cd69371a71f, high: 0x3b6a666fb0323a1d576d4155ec17dbe,
            },
            u256 {
                low: 0x9edfa3da6cf55b158b53031d05d51433, high: 0x23d79a9428a1c22d5fdb76a19fbeb1d,
            },
            u256 {
                low: 0x4d125e7fa59cec98126cbc8f38884479, high: 0x1f40f472e2950656fa231e959acdd98,
            },
            u256 {
                low: 0x98b33c6e0a14b90a7795e98680ee526e, high: 0xc8555a9fcfcfa81b306d70019d5f970,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x9689eff36e40c5d4f7aa9e26,
                    limb1: 0x4fca2ba1936adf005148db8e,
                    limb2: 0x61682ebc3050d122,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x8c505d80ce528ebd36300c7b,
                    limb1: 0xad9bf81c921211418dd07111,
                    limb2: 0x228d83528b2b7ad0,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_12P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x12d1b444ec39ae839807573c,
                    limb1: 0x50cb70680dcb8804e2a1c6cb,
                    limb2: 0x5d529b896d65150a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf0fbd5d96b7a64beee6206b7,
                    limb1: 0x6982ef15e68d6f6c204de74a,
                    limb2: 0x12537fc27fadb2bf,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x5a69deb6f89b3673b868547b,
                    limb1: 0x4bff35db66fccba1976a7225,
                    limb2: 0x77f294fd97e3f80d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x9d0b7c8c5ae15973adfe68fd,
                    limb1: 0xdcfad41176059fc275b3c281,
                    limb2: 0x56e82a35fc7cab60,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x9e594e333ff5e969a7e67fe2,
                    limb1: 0x6f1c567b169fb2641e9523af,
                    limb2: 0x5f281f6b0b94ae25,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xfcf298a0835b6605577aba8d,
                    limb1: 0xcbc74b0c4dd9416799ec7c87,
                    limb2: 0x2bc94fc7f719122c,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xffecbce3b121b61e3a57f55b,
                        limb1: 0x5e6bfbfb7b574c128eb240a1,
                        limb2: 0x2bc9be23492bcad7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe0196ab9ccdd78fdf5ef245,
                        limb1: 0x1ba34dfb4627182d469d5d56,
                        limb2: 0x775a03c7cc2703c8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x235a3a02324481f4df62710d,
                        limb1: 0x5b2e992df083497642154e73,
                        limb2: 0x34fd6cd3a82c5c48,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd06187c8a1d0376a5f000d9,
                        limb1: 0x68d90153c1e8d7a7ee899c34,
                        limb2: 0x6aedcb7e52cbcb5e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb94f7efe60a13f7f5962d92c,
                        limb1: 0xa34c5108ee4161db1e497d8e,
                        limb2: 0x72a24aea2ebaa210,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5a9df54c263239333ab644fa,
                        limb1: 0x6124f61660a22d2341fdf5a,
                        limb2: 0x72a6f4d9cd5fbf35,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x72f29c59e6ea900a1d85ae34,
                        limb1: 0x482643cf2b12a5734b2e17fa,
                        limb2: 0x3bac234f4e4a138f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb77fa7636d51eb2343438d65,
                        limb1: 0xe4e3805368a9ce4981c64bfb,
                        limb2: 0x7d272e264bc9d02,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4483a338e345c4b861d0dc80,
                        limb1: 0xc08a11e883dfb6475bafc3ae,
                        limb2: 0x33264c490729f9b4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xaa339804960b019881d23878,
                        limb1: 0xfe2fdec8bbba1d4e60076c62,
                        limb2: 0x535e585bb632c906,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8882b0fdc437cfb58dbaa4c3,
                        limb1: 0xa5877b1ca8ad42ea12efa2a7,
                        limb2: 0x5d4263824619549a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xde92947601ea0c23d920cd45,
                        limb1: 0x221050bd14536c12823673b8,
                        limb2: 0x3c76165d4494108f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6a2ac381735f9520b8d3e487,
                        limb1: 0xfbd4b1dceecb9329a8b0df79,
                        limb2: 0x342677d07b838035,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xb442043f2dd169cb9f9e8d72,
                        limb1: 0xef8d7c1088054da15cb3220,
                        limb2: 0x19d4ec5188918bed,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x56c7048885523c4ceb181873,
                        limb1: 0xd86fa1e82c2b6b594ac1513a,
                        limb2: 0x45bd08a012b8f10d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2bf497607588487997e50892,
                        limb1: 0x5e41bda23b95bca24f89a4da,
                        limb2: 0x787ce84ba33784a4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbd9e9cd5b04f5b78530e320f,
                        limb1: 0x9a00b0073e3d256cc8a18611,
                        limb2: 0x60fbcec6847c3bf2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7347ade9ac9b92d7f86554ec,
                        limb1: 0x18f252c46d5f218070a956e3,
                        limb2: 0x54c6a9a8e8629e8b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x958c45a19341e4062d1bd308,
                        limb1: 0xdd6bd4b65c0c8ce183ac23e9,
                        limb2: 0x454f22d5cb9bd4f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x11137d2de8923838b19dd603,
                        limb1: 0xa79d4603ddd85ab4367cbc08,
                        limb2: 0x496cf7bba9bfdc01,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbd6480d88107d06896005ba5,
                        limb1: 0x2659f0135f6184e7eca0b6b4,
                        limb2: 0x1ed73aad3ef8c330,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc2eee205a96e240001143a42,
                        limb1: 0x8264f7e173eac7264eff3c41,
                        limb2: 0x53db64ec15475bd0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3d3b91ef5607b2d47be4b87c,
                        limb1: 0xa1df8d81703f144d77347631,
                        limb2: 0x6818feb8ecb0d46e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6a48daf6f303d53ce5e97319,
                        limb1: 0x45277035b39e7e5c264d1b7d,
                        limb2: 0x6bc39abb3ab0eaf3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x784ca0b979984062a03cdee4,
                        limb1: 0x6bcea28c476eb635ebcec93f,
                        limb2: 0x2ef058f42d482d29,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x30ad938acd85cc182e3509f4,
                        limb1: 0x21efbaf20d88c8824a3ab8b2,
                        limb2: 0x5414d4a72bb09b38,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x43e7029d069a5f1fb92af1fc,
                        limb1: 0xceb43171d1fe7247c35ca21a,
                        limb2: 0x6f50926b9de1db2f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x613a9e92167baa9c907fe071,
                        limb1: 0x1521f98e126eeab77278ac5f,
                        limb2: 0x4814a779588a7ff1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xef5acd63333377c18ab4abe8,
                        limb1: 0xfc5e6d86e3db7b2adb5e0f0b,
                        limb2: 0x36eef4965f7429b9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x54a5f0de4d02d39b5d02a85f,
                        limb1: 0xa1daaf026f649aaf5450c14,
                        limb2: 0x74aa9cdbdd9bc48,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb59e56842f3b2045d388c59f,
                        limb1: 0x8e7c2f30f823d27d1afe32ec,
                        limb2: 0x35c5495669061993,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x22b6c28d47f9fe23ea98cc0f,
                        limb1: 0x9352a8fddb42e3af57a1db5b,
                        limb2: 0x57e46fe6f26721eb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6ac322985e5cbd757a26c312,
                        limb1: 0xb72e4d7a3d3133605b29eef4,
                        limb2: 0x667a9f508e4c31a7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x138da36f8db83531b8bfe35a,
                        limb1: 0xff7f7ad2e6074e3f382af432,
                        limb2: 0x7ea13422f0a3ade4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc25397638998cfbd1f112b2,
                        limb1: 0x9452ee4e8cdbbba4a9544644,
                        limb2: 0x3a8575017a1b496d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeaa2b73f3c4d41a518c09910,
                        limb1: 0x2a58a7215ca86758f559e51f,
                        limb2: 0x7e39c2d53f220d48,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5cd98181a39cf81f142d8e12,
                        limb1: 0xa09d1ed85bd0b4ff2d591f00,
                        limb2: 0x1fa3ee2c543656fc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x604d49c963cbb242ae4699cc,
                        limb1: 0x4120430346cf35eb0cdcdcea,
                        limb2: 0x379089f50b55d75f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x953a6c905b8c17a590b257e,
                        limb1: 0xbb4d9708aa18caf5412b0b12,
                        limb2: 0xab9f2fa1e6ca8f7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x85e23a73156e071ec56c4243,
                        limb1: 0x26618a13a93d3db4a8727078,
                        limb2: 0x5595e4ff55323198,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xd80911ca9d9c52cf5007b2d4,
                        limb1: 0xa988a21876e7f3f6f1cffbf0,
                        limb2: 0x5e56ba88bda584c2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf12c577c8cff913b30424c7f,
                        limb1: 0x69b8e77f5b8a593e133d4705,
                        limb2: 0x61c5a60d9ce47d20,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe2413379f703b8ed14571e04,
                        limb1: 0xa2ae3de9491abb55d2939105,
                        limb2: 0x3a16c004915abf60,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x738ea03ade03ad171d97bd9b,
                        limb1: 0xcc2687e0678e260a4ae9b61b,
                        limb2: 0x73694049c683b2ef,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x280a445d65d47cfb27eb0b23,
                        limb1: 0xefd8c69d8d1e1629ff1d8e4b,
                        limb2: 0x4462fdb993b637bd,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7d4a2bd9258173630361d048,
                        limb1: 0xb860d494e52ca141055e3a55,
                        limb2: 0x1d50d030cd0b3f22,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2d64035a28db7775b974b615,
                        limb1: 0xce1ea0fc572351ab986decc4,
                        limb2: 0x34ae3e33014c6c03,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x206f1a49ca2bdb9de5036245,
                        limb1: 0x9c5578633b811d1a992e45ae,
                        limb2: 0x48f33526b6808e2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc821849124d4456aeb06b504,
                        limb1: 0xd62fc35444a18345870d819f,
                        limb2: 0x154da4487ac33d97,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd224f8876e6673cd74f74f91,
                        limb1: 0x44b8d3909dfe86be97cc8080,
                        limb2: 0x6ab6f249a134c42e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x244793cf806308769ed032f9,
                        limb1: 0x151791bb5831430f944639b8,
                        limb2: 0x5f81773a904186df,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x22f81119ece42751eefbc7fe,
                        limb1: 0x5cacdebb5662860e787cac4d,
                        limb2: 0x1d309e6a341431e6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2870678e739aba01be2bba3e,
                        limb1: 0x3a9bb539c332fdac2d6d5017,
                        limb2: 0x49d609dc01ea2eb9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa2d7603688a72b0868a7535e,
                        limb1: 0xd235f1124858ef82b7acd5d8,
                        limb2: 0x647cc238e6dcef1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x84f1cbb1260a21f198f8f624,
                        limb1: 0x9d668399a8e9f40c57877f9c,
                        limb2: 0xc3f05c7d301ec0f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x30ad938acd85cc182e3509f4,
                        limb1: 0x21efbaf20d88c8824a3ab8b2,
                        limb2: 0x5414d4a72bb09b38,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x64c3a97434138b47cdb949a6,
                limb1: 0xa03ceda5529dfec13d8af56e,
                limb2: 0x10e5f7624aac3ed3,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7238f02b9f20e09c2181a557,
                    limb1: 0x2cedcc5b0be371c337fd7e9e,
                    limb2: 0x41f3bbeb280fe8a2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf046f8cd6e5a75fca71dd19b,
                    limb1: 0x892b4613ef5c58df4ef692a4,
                    limb2: 0x7527fa36f5738847,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x82e4a33f8e4e5881e791d86b,
                    limb1: 0xbcb062435ae8ec5fdaeac4bf,
                    limb2: 0x179e1bae9e0f9f34,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x19657783ba5660e255c21849,
                    limb1: 0x7ed7474bcea7551fc71e46bc,
                    limb2: 0x596c0a76b75f4756,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xa6832ef7fe97f77de7cd9a62,
                    limb1: 0xf18a70dbf1dc5a76c685da4a,
                    limb2: 0x6ac1b7bfc409119f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7751161b1a9ef600b865a5af,
                    limb1: 0xed28aad4835a39a9e8318ceb,
                    limb2: 0x572e95c429f0e07a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5e71d0fc5d1c016834779173,
                    limb1: 0xadd002dfc0ebf1b25c23c252,
                    limb2: 0x40a868d928ae5233,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x423fa293418d6e3f59c2e830,
                    limb1: 0x7a4bcf26f93e71ffd903e68e,
                    limb2: 0x7837b851ad8da6e3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x5907087f8e8e4dacdd039371,
                    limb1: 0xc390e2073b4e64b9ede0570d,
                    limb2: 0x6b039a85962f1594,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc45eefa03155b8f7eb780b42,
                    limb1: 0x3db57eb22f9b0394a4d7b78e,
                    limb2: 0x6cf45b6d90883f60,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x60dd8ed0a614b596fb37eb1f,
                    limb1: 0xabb99f371be41e26ec2d8e4b,
                    limb2: 0x187ecd72c40f159d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7b66c9263de5e1663622985d,
                    limb1: 0x118b032cc27a1d6dd192eca6,
                    limb2: 0x312fb405788616e8,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xf4ac3e1f1f068dd64c86fdda,
                    limb1: 0x24594e591d82a7f964b5ec9f,
                    limb2: 0x6ca311b5421c57fc,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x42745cd7b146012455434d0f,
                    limb1: 0x6aa4f552b7bdc93a613bd9df,
                    limb2: 0x5832a065d7199c7a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x341786b7854e3e0104e2e416,
                    limb1: 0xbb368441c295043bee7b1d2f,
                    limb2: 0x35c88542e11463b4,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x3c36e7fcc4e2fde28308132,
                    limb1: 0xf58043d0e3d1a36d1f8137fc,
                    limb2: 0x58c1508fbe8868a8,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x560a37951d69a6c8d7138239,
                    limb1: 0x462d454a509846714184ef71,
                    limb2: 0x3aaf8fb4f60e3e9c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb70cea4e13db5322899753f9,
                    limb1: 0x6c62656b6d7ffb5c2af44fd5,
                    limb2: 0x4b5ae4567dc6a7c0,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xb06cccb4b425d5179f528270,
                    limb1: 0xce017c281a3861570706cd86,
                    limb2: 0x42d14846dc4860ab,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x646bf486f6e77663c597ece8,
                    limb1: 0xd87c8c36a430a6fe42305b88,
                    limb2: 0x7964c7742b6f13da,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x52c487a17925c92335926072,
                    limb1: 0x13155d04b743220ba9c4dd31,
                    limb2: 0x1106c832e8e52057,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xbc69df5aa9a21ba08f160d5f,
                    limb1: 0xc207c95ac5d454f546b05fc3,
                    limb2: 0x574515b32b35f440,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0x6e2edd0d977e9933c49d76fcfc6e625,
            },
            u256 {
                low: 0xd344749096fd35d0adf20806e5214606, high: 0x8ce86e89466e4726b5f5241f323ca74,
            },
            u256 {
                low: 0x30bcab0ed857010255d44936a1515607, high: 0x8ac57cfbb42e0b20426465e3e37952d,
            },
            u256 {
                low: 0x5f3f563838701a14b490b6081dfc8352, high: 0xda2ddc3552116dd2ba4b180cb69ca38,
            },
            u256 {
                low: 0xc87a746319c16a0d0febd845d0dfae43, high: 0x7003168b29a8b06daf66c5f2577bffa,
            },
            u256 {
                low: 0x176ea1b164264cd51ea45cd69371a71f, high: 0x3b6a666fb0323a1d576d4155ec17dbe,
            },
            u256 {
                low: 0x9edfa3da6cf55b158b53031d05d51433, high: 0x23d79a9428a1c22d5fdb76a19fbeb1d,
            },
            u256 {
                low: 0x4d125e7fa59cec98126cbc8f38884479, high: 0x1f40f472e2950656fa231e959acdd98,
            },
            u256 {
                low: 0x98b33c6e0a14b90a7795e98680ee526e, high: 0xc8555a9fcfcfa81b306d70019d5f970,
            },
            u256 {
                low: 0xebe2136898c752051e01a934402d0baf, high: 0x6c2a492cc0f859aa6524ab713b7e05,
            },
            u256 {
                low: 0x637e0edc5b6e4ae7a62081434fbaecc0, high: 0x4e8c1e4403d1f83a859890cd670f668,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x7c410eb46bef1f4bbd9bc435,
                    limb1: 0xf8e9e58aa621db96880b0f17,
                    limb2: 0xd09eb5f2667189b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xdc7785ceb6c9231f86e4b328,
                    limb1: 0xa8f46608017bf64838b1e72f,
                    limb2: 0x5a4e1c9619ed8aa3,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_1P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xd1047f7150ec5100a6e49ee9,
                limb1: 0xc2e7d792c40dc5b460e86d57,
                limb2: 0x7b3f189f2f960a5,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xac5aa8d6d49297a36aaf986f,
                    limb1: 0x7947b09c6620f2fdeb6c05b0,
                    limb2: 0x8f24f2607ad197e,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x7cca3f48d7a850ac077aa53a,
                    limb1: 0xfc0367c309acf4dcb9b6023c,
                    limb2: 0x1389ccb9283ad6bc,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x9be267945cadfa270fe33fea,
                    limb1: 0x53629b1877e276ef9c05b645,
                    limb2: 0x5f3a5c7c506992f,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_2P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x5799d0a4be76c4179913ad19,
                limb1: 0x86201acbfee2c5bb1e120b24,
                limb2: 0x167b9aeffb401b8c,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x746895ac8d85fdcc78a517dc,
                    limb1: 0x439607b706d6b787a329afcc,
                    limb2: 0x122c8ade7aa1ea89,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x86b402ce02e7c7ca81f13d51,
                    limb1: 0x39493672733a9289a36020c1,
                    limb2: 0x7f40d91dc5413d3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x371e7b6a5c01505bd4334e81,
                    limb1: 0x2f596ae4492a87c66f7bda1a,
                    limb2: 0x9dffb4dcdb94df9,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x967d0cae6f4590b9a164106cf6a659e,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_3P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x37c9a46b0612fc1b353fe24a,
                    limb1: 0xeb374db12bd7d7711f2705b4,
                    limb2: 0x253453fe507b50b6,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x33cd021aeba5ea18a2e20a56,
                    limb1: 0x3e392b55f320a528391fcef8,
                    limb2: 0x14fbdf9fd7fbfcdd,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x60e6980f95d8e5261423f38e,
                    limb1: 0x3079cdd992636bb28a5984df,
                    limb2: 0x14368ee41c0e5576,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa3597535ddd5b8336fde7418,
                    limb1: 0xc0329958cee690ca2b691fb,
                    limb2: 0x2a11389e1b5a9b57,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xc294148f233ee2e2eb301899,
                    limb1: 0xe1d7d7726b8c2ea638d0879e,
                    limb2: 0x1599a751984c9cbc,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xfb70f5613f53701f0d60d44f,
                    limb1: 0x1bc69554d8e00e30700a9bad,
                    limb2: 0x1e3d7a04c2e60b68,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x8d1ac407b0b68a1dab34b0ea,
                        limb1: 0x28583648ea41a8369d9266ea,
                        limb2: 0x5bd7a61cafde77f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2e2d64b34628cd5121e61d8b,
                        limb1: 0x3c9160edd20418993dc03a9c,
                        limb2: 0x14935bf5b97aaf31,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6d828690264f9647a8a849f1,
                        limb1: 0xaa4db7f1d471f2660eea1a53,
                        limb2: 0xdf52f48a4714b89,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x22b173b10b3e7c4fac032098,
                        limb1: 0x4f28a503f922c55da227f373,
                        limb2: 0x4654b1125198233,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xb2266081a22d892a905aac07,
                        limb1: 0xe29e40ff84bf386a075c2912,
                        limb2: 0x2bdae940ecd05238,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbc07a73baca9200621b30a,
                        limb1: 0x9feb152fd5380add8bfeb65d,
                        limb2: 0x27611e103ee6cd84,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc58abb3148d1b699a1cd566b,
                        limb1: 0x427ed6a0de410a4bb7ae367a,
                        limb2: 0x1710b0370e12ff29,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x77c7f1279f442e1fefa35cbe,
                        limb1: 0x39ad28fd9578c20b1b049f7b,
                        limb2: 0x80860ed167627c,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x36d43362167f95a6c7ab3efb,
                        limb1: 0xf1b335d8f724e2f00d074209,
                        limb2: 0x4210b05774c00d8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfcfb832a114ffcbb88fd9872,
                        limb1: 0x14d78d0b3eb673c7a7bcc78a,
                        limb2: 0x272e013c16236c86,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3e4ab9a1f92275723f292c08,
                        limb1: 0x750afa16be5a64b2272b368,
                        limb2: 0x2bb352e1f4120313,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcabd610b2776514a16c4ca00,
                        limb1: 0xe2528b2f5dd72dcf9738f4f0,
                        limb2: 0x2ca5cb95ab68ee73,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6ead72438d38a9b6bbb87e01,
                        limb1: 0x65951ccceba1f98566e26518,
                        limb2: 0x2a904cec00cee003,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xc70aa07879193d6b69fa9399,
                        limb1: 0x78820a704762c6c8061fca49,
                        limb2: 0x1cbb69de59448cd4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9ba7a5d6bfe432f6b7c31c64,
                        limb1: 0x75c767cdec5a1c61e6ec97c9,
                        limb2: 0x8094b3423631c79,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x294e86d58d0481ffb15d42ee,
                        limb1: 0x106632bbcb3a6c3f37418c65,
                        limb2: 0x2b6b0e61fb7bafba,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbddf5ce00ea6790ba6818369,
                        limb1: 0xe1e882897ba55ad3c0d91df,
                        limb2: 0x2352024504f2c7f9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbc07a73baca9200621b2f9,
                        limb1: 0x9feb152fd5380add8bfeb65d,
                        limb2: 0x27611e103ee6cd84,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc58abb3148d1b699a1cd566b,
                        limb1: 0x427ed6a0de410a4bb7ae367a,
                        limb2: 0x1710b0370e12ff29,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x77c7f1279f442e1fefa35cbe,
                        limb1: 0x39ad28fd9578c20b1b049f7b,
                        limb2: 0x80860ed167627c,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xb4d724fe09e4d0654dff3b97,
                limb1: 0x5a5d54ab4d5e104be31a68a5,
                limb2: 0x227e7025667ec33,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x86b402ce02e7c7ca81f13d51,
                    limb1: 0x39493672733a9289a36020c1,
                    limb2: 0x7f40d91dc5413d3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x371e7b6a5c01505bd4334e81,
                    limb1: 0x2f596ae4492a87c66f7bda1a,
                    limb2: 0x9dffb4dcdb94df9,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x20669ef12954f8e3bbc8b4d3,
                    limb1: 0x396a6f7243c27ce553121ee3,
                    limb2: 0x11438ca2ec259aed,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa560a5759c90985fde99aca0,
                    limb1: 0xc5b21186cc6dcd0421026513,
                    limb2: 0x21fb1f47c6ac55b3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0x1521f387af19922ad9b8a714e61a441c,
            },
            u256 {
                low: 0x5a92118719c78df48f4ff31e78de5857, high: 0x28fcb26f9c6316b950f244556f25e2a2,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xf47b4ee8eecf8576c38173d8,
                    limb1: 0x755d90a26c30d7d6fb33afd3,
                    limb2: 0x5e835e05fdb55c5,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x990d5f4767a8d057f8695e4e,
                    limb1: 0x5f8dd4e272c268c0d2ce4a39,
                    limb2: 0x1704905427d31a82,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_4P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x7fca404cf28b7c01bc2a273c,
                    limb1: 0x21b13979cfab5b2c39925bc7,
                    limb2: 0x25c83abfb9a6cf23,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xbbd55bc3ba04437bce8521a9,
                    limb1: 0xf464d5315dd920e277df247b,
                    limb2: 0x8144b996cb87869,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xafef69f2e967ce258ede0fab,
                    limb1: 0x3bded90a47a831e62a8312d8,
                    limb2: 0x23fcbf1035f058be,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x4bf0c01fe73cdbbc883c9ac9,
                    limb1: 0x8eb8106c85aa9de02e07517a,
                    limb2: 0x1b5257e9e2a9db7c,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x93eac8ab0434b3dc0c76ec25,
                    limb1: 0x695c9f3078b835272ecde3f0,
                    limb2: 0x84e3b8cc47abe19,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb271bb87ca31ff4bc3dcbbb7,
                    limb1: 0x499ee0e5ba9f5da55bc7654c,
                    limb2: 0x1b425a934de04557,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x98a6d2f5c3591bbdfc1d1952,
                        limb1: 0x883631916ffc1bbf1324fbf0,
                        limb2: 0x79627cde765b8a1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcbc115fabd892702d682fae,
                        limb1: 0x2f42aa426412ea771c5213f3,
                        limb2: 0x200e1e5ba269dd47,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd52bc43a9010d3906bcaec77,
                        limb1: 0x30535c0d573b131ad625a818,
                        limb2: 0x2a944afc1e1a0077,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x78bb6fc35dcb53116b2e555c,
                        limb1: 0x83820c28413ec921f231f9c7,
                        limb2: 0x8d966c289675192,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x529e068c155b9a3235e3ef58,
                        limb1: 0x6e63c43daeafc32a09c0578b,
                        limb2: 0x12bcbe94cf5d70ca,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x366988318c0fd37cae5c7a01,
                        limb1: 0x1d1db654c5e1f6ae3a804e12,
                        limb2: 0x1d59845a5f89653f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbe8bf151b60ae8b001939f48,
                        limb1: 0x8dddea28757c4cb1ef3fac24,
                        limb2: 0x49bbb5b78a0f560,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x965d1debe0f443a3bdef565c,
                        limb1: 0x426610e686cfbaa612d0f608,
                        limb2: 0x1db26b2f30bccfd6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8c1d1fb00c4d27c0bc31237,
                        limb1: 0xf18cb4b94d88e0dc8493c726,
                        limb2: 0x27c0a2053947e879,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4cfa4ad87abe325ce09fe0ae,
                        limb1: 0x6bce834269e687d980bafa51,
                        limb2: 0x5e9e552b6eae557,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xcd4d64cecabc90847e71b0ff,
                        limb1: 0x8d354cdaaa16e1d2172b8cca,
                        limb2: 0x17896dafdc2e0947,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7ab80a06de9bf18a2b023deb,
                        limb1: 0x573bb53778fef3c274697727,
                        limb2: 0x2a2dbe4ee4dad0a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe6166ee75bb90966b71382da,
                        limb1: 0x16d67511f930c23f8115e19c,
                        limb2: 0x79b7627b4afe571,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x50987597db64239b394094a3,
                        limb1: 0x2b418f5f765077b80057e5e7,
                        limb2: 0x26179d60f93e31dc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf507d39166a26fbb49d1b67d,
                        limb1: 0xe527101fce215afbe80d353e,
                        limb2: 0x1ada2b4452b75467,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1a20b1e93cf5d9e5e4f7ce6d,
                        limb1: 0x7fb8879744b1a746ef1035de,
                        limb2: 0x1f80ea77de175a16,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x9df5caf39da88213bbdbe5fa,
                        limb1: 0xfc79e3366c8d6a6ed7b5cbe7,
                        limb2: 0x215d94ef55022899,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4c27dab5710a7777c5326c3a,
                        limb1: 0x4e3febd35c198e96d2d6220,
                        limb2: 0x12712bd2bfb2f4ea,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3ec8d993fa7d0f7bb31b43ef,
                        limb1: 0x82abdf889cc366f97a5aa48b,
                        limb2: 0x1b7640cd70981490,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x49aebe783559475706684468,
                        limb1: 0x27298601b4dddd219f86c882,
                        limb2: 0x1f0b0c49e279b76e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x955fda14172d7bacf6f5b3bc,
                        limb1: 0xd5c7be2c702ff7fab33cdd4f,
                        limb2: 0xdc1dc3156afae5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x965d1debe0f443a3bdef564b,
                        limb1: 0x426610e686cfbaa612d0f608,
                        limb2: 0x1db26b2f30bccfd6,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8c1d1fb00c4d27c0bc31237,
                        limb1: 0xf18cb4b94d88e0dc8493c726,
                        limb2: 0x27c0a2053947e879,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4cfa4ad87abe325ce09fe0ae,
                        limb1: 0x6bce834269e687d980bafa51,
                        limb2: 0x5e9e552b6eae557,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xe325935833fd7f17898d871a,
                limb1: 0xc9d0d50ed7634aa265e25247,
                limb2: 0x1381ee552ec864a6,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x86b402ce02e7c7ca81f13d51,
                    limb1: 0x39493672733a9289a36020c1,
                    limb2: 0x7f40d91dc5413d3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x371e7b6a5c01505bd4334e81,
                    limb1: 0x2f596ae4492a87c66f7bda1a,
                    limb2: 0x9dffb4dcdb94df9,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x20669ef12954f8e3bbc8b4d3,
                    limb1: 0x396a6f7243c27ce553121ee3,
                    limb2: 0x11438ca2ec259aed,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa560a5759c90985fde99aca0,
                    limb1: 0xc5b21186cc6dcd0421026513,
                    limb2: 0x21fb1f47c6ac55b3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x3c26f4ff476ab777dc184776,
                    limb1: 0xbccb2cba46cf421f11eb4d14,
                    limb2: 0x27ec44064c727a3d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa893636703904fcbe984618c,
                    limb1: 0x73b210a224190b9b7b28784c,
                    limb2: 0x20f05486689dff6c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x5a92118719c78df48f4ff31e78de5857, high: 0x28fcb26f9c6316b950f244556f25e2a2,
            },
            u256 {
                low: 0x8d723104f77383c13458a748e9bb17bc, high: 0x215ddba6dd84f39e71545a137a1d5006,
            },
            u256 {
                low: 0xeb2083e6ce164dba0ff18e0242af9fc3, high: 0x5f82a8f03983ca8ea7e9d498c778ea6,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xdd8f608cce44f84812570bb4,
                    limb1: 0x1a14a31827612753a0030aa0,
                    limb2: 0x92f0e5ea352aed1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb58c06876e2333cf38a0f096,
                    limb1: 0xbc1d90983cae6462c10cfeed,
                    limb2: 0x202c74ee1cf90bb5,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_10P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x9dfcd92715b6222cbb098482,
                    limb1: 0xd3945047066b23989eb3b9e3,
                    limb2: 0x116d66e83f4b4495,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xfbf94312b77c49728e67e899,
                    limb1: 0x970271de43b7f68191de9797,
                    limb2: 0x1a988f8bf089fe6a,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x16b97231d5c9925069156e4d,
                    limb1: 0xdf3469ceab36997946976963,
                    limb2: 0x1fb5fa1943c43e59,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x8dbab6d460f7c22922c55eb8,
                    limb1: 0xddd8c23ff5d4a05087728205,
                    limb2: 0x29eb2a49e3284dae,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x492c80f514e1a11f6b2b259e,
                    limb1: 0x458bc23a5411c8ce5922154b,
                    limb2: 0x51efbcd4e49ad5a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xff461ad6ee2ad825beaa8216,
                    limb1: 0xc1b2fdb212af7469ee8b1721,
                    limb2: 0x3d032fcfa6958e9,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xac74a2c2e3b807cae77a89ef,
                        limb1: 0x33bd1d6afbf16cb134f45e2c,
                        limb2: 0x2df8379a8d2e05ec,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2c104157862b6df41afbb636,
                        limb1: 0xdc7ce7062197c8517dd198a1,
                        limb2: 0x29d14b4a9229bda7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x11eb702a84e0799bbe64b9cd,
                        limb1: 0x2fab5e40ff5b7390b61a2f96,
                        limb2: 0x50c095f019d0f8d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7322b2193ed97bc7d96ee0a7,
                        limb1: 0x1f2751a7963ef6adc9ad21f2,
                        limb2: 0x2ae4e6aa11d6698a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb3ec0e25cbac9550f3b7dc71,
                        limb1: 0xb51df9680976f5cae7a83421,
                        limb2: 0x3cc4bd5b2185ffb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc16817779d29a7eed75e7780,
                        limb1: 0xa1998227aaa9277433ab957d,
                        limb2: 0x2f8e847094138684,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x791244f1e74bcb88ad39471f,
                        limb1: 0x82bc48a6e0e0da34157bf095,
                        limb2: 0x173c9ec4775dbb71,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1019a79c4a81cac0dc97548,
                        limb1: 0x67d6235b455f0378896c0d57,
                        limb2: 0x16afdd2b60518816,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x12a858b153fd4e7c53d32a82,
                        limb1: 0xa8563eb1a8ca3f5d98228699,
                        limb2: 0x158449f0bf9fd72a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcac3edb4a41d91547568a4fd,
                        limb1: 0x7096d25800607392fd2b2304,
                        limb2: 0x5e2f534d11a11a0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdb2dae1039671cd4fc43836d,
                        limb1: 0x5bd80edc2a817e97c3bb8f7d,
                        limb2: 0x2518efadcfdf74c6,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x3004d2fcafd1230fa1db7885,
                        limb1: 0x23de6c8d3c6c6a9bd340d29f,
                        limb2: 0x18ffd03f447d8d80,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xefc87c2cbb85a3520334da1e,
                        limb1: 0x1c885705970ee7cedcc44eb3,
                        limb2: 0xada6b4f551e8a2e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x37487e76b34a0b42c10a4c5a,
                        limb1: 0xc0dd5e49982ea25b015f0b09,
                        limb2: 0x220f8e4f032f56af,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x24c758e3c1ee7919d5a03c10,
                        limb1: 0x93bbb2bceb91f534f5c7553a,
                        limb2: 0x1845680f23bc3389,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7d7b0e866e46079935589052,
                        limb1: 0xe75f8f709d43c461a477fc89,
                        limb2: 0x287482803c897f09,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x27ab4a01e3e65f79f3651a1e,
                        limb1: 0xddb9a5573f9b1b7f4c841148,
                        limb2: 0x244e9b75c053dfcf,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe5c5151a700a84cd9f6b9490,
                        limb1: 0xcecb8fac0649e90174c670ba,
                        limb2: 0x9b3dfc95739384b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x509d0f9ed97bda5e25570937,
                        limb1: 0xee242516971561a70800a43b,
                        limb2: 0x19238f90553881b4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe0a4d6b07c812590d369e9f8,
                        limb1: 0xe92244f1f7b608630b5de9cd,
                        limb2: 0x2f4ebad8a02172d1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6c3669f6b783e2d9c97e6baa,
                        limb1: 0xaeb9b793524e9a38a7bbe0a9,
                        limb2: 0x1e4169c4ef3e6459,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa48791b611cbe11d8d1ac657,
                        limb1: 0xee39cfde9281e4eccd9e72ad,
                        limb2: 0x1bc9751e5a378ceb,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x2156da4c71c603ed31d60826,
                        limb1: 0x945560e4e0e58b509605dc58,
                        limb2: 0x27fdc5c3621aaca4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x70d1516872e60c63aa810484,
                        limb1: 0xa6db623a9d70fd7714332330,
                        limb2: 0x287009e73804f4e7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7909e2463ef4ea0d095310c3,
                        limb1: 0xa458a1fdb6f51056e7c306df,
                        limb2: 0x54da99123228348,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbe7b3468432aee2b22443dd6,
                        limb1: 0xd53f94c2ee3f8df9721e6863,
                        limb2: 0x225842f0e0f02a9a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe69b6231fe5756f621765c8c,
                        limb1: 0x7feb17c2440d00ea7fda1364,
                        limb2: 0x185465c10b0f3da9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfa3f0d5dc91f613785efb5bf,
                        limb1: 0x115f4c7517dfb3616fbab01,
                        limb2: 0x1034eefa9977a3d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x15eb5b5e659f1d5e4182d3d7,
                        limb1: 0x7105667a5313534bca7eaaea,
                        limb2: 0x11316173961119dd,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe061eafade1bf05e783f3f76,
                        limb1: 0x7efc7ed46abdd72441961640,
                        limb2: 0x108e0f85e34a24b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2cd7ad84558507429f2bf35f,
                        limb1: 0xe228c36926cc0b22067fd1c4,
                        limb2: 0xe865bd1e9bfbad7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8da5b0113027a11fdea68175,
                        limb1: 0x997e8e33b98f425d8378ca3d,
                        limb2: 0x274d36464591c81b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf7a9f1cc893536e34e63133a,
                        limb1: 0x25e69a87690868936a3438a8,
                        limb2: 0x25d1eafc626ecf20,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x825638c005439e8cf8646ef9,
                        limb1: 0x5c814ed8f3471571bfb97b7,
                        limb2: 0x11ae3b0c1d5cba3c,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x1732f253b60e4e29b06cff34,
                        limb1: 0x190d3e098a5906ed62852dfa,
                        limb2: 0xa89edd65e683bf5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfa95834c9ba7fddd897d8406,
                        limb1: 0xfc334f7afe07fcb7f7c6672e,
                        limb2: 0x9101986ddbf5396,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8e0e0ed46acc3806e50ee12,
                        limb1: 0xd51001aaf6f75c52cb1f27c9,
                        limb2: 0x1ab3a23582ec048,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x64ce0f831ecba8be2377b7e,
                        limb1: 0xcf3a016c25473d5dead7544f,
                        limb2: 0x2feaa947cfbcc2d4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x42c0ad311f3a903c985344ba,
                        limb1: 0xd393a0863aa1b26b23a33d89,
                        limb2: 0x9a0b13a0b3dccd,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc3534bb703772cacc7539069,
                        limb1: 0x639cedc2f2734ba1f73cb0ec,
                        limb2: 0x2def3752ad229c00,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4fdd43d61ce1882e0f7b5e83,
                        limb1: 0x127f974052d8533ad3591aa,
                        limb2: 0x4807708fc8456fe,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf0d889841c1c33f83a90f3b3,
                        limb1: 0xd97b46a4a0e30b335e0c56dc,
                        limb2: 0x3a6d819d55e353,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd850115ddd723a1ae95c90b6,
                        limb1: 0xe7776cade49a12be0e860f23,
                        limb2: 0x6591a413135427a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf11fe1f62afe01b28e066e51,
                        limb1: 0x1fe95dbb1fa0773f0b878097,
                        limb2: 0x1bab38a521367022,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x24dac83451c57f2f268fdd7a,
                        limb1: 0x4f70106feb82a190f2821988,
                        limb2: 0x24add909237867ab,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe0a4d6b07c812590d369e9e7,
                        limb1: 0xe92244f1f7b608630b5de9cd,
                        limb2: 0x2f4ebad8a02172d1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6c3669f6b783e2d9c97e6baa,
                        limb1: 0xaeb9b793524e9a38a7bbe0a9,
                        limb2: 0x1e4169c4ef3e6459,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa48791b611cbe11d8d1ac657,
                        limb1: 0xee39cfde9281e4eccd9e72ad,
                        limb2: 0x1bc9751e5a378ceb,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xf740cf3833dbafd6d6baee48,
                limb1: 0x4a12ed77229700a79166872c,
                limb2: 0x6b87b91ce1ff08c,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x40bcce2f9a29e91035b96217,
                    limb1: 0xec48e3cddc5674b77b1c672d,
                    limb2: 0x1ea02af609bb028,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x86b402ce02e7c7ca81f13d51,
                    limb1: 0x39493672733a9289a36020c1,
                    limb2: 0x7f40d91dc5413d3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x371e7b6a5c01505bd4334e81,
                    limb1: 0x2f596ae4492a87c66f7bda1a,
                    limb2: 0x9dffb4dcdb94df9,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x20669ef12954f8e3bbc8b4d3,
                    limb1: 0x396a6f7243c27ce553121ee3,
                    limb2: 0x11438ca2ec259aed,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa560a5759c90985fde99aca0,
                    limb1: 0xc5b21186cc6dcd0421026513,
                    limb2: 0x21fb1f47c6ac55b3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x3c26f4ff476ab777dc184776,
                    limb1: 0xbccb2cba46cf421f11eb4d14,
                    limb2: 0x27ec44064c727a3d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa893636703904fcbe984618c,
                    limb1: 0x73b210a224190b9b7b28784c,
                    limb2: 0x20f05486689dff6c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x74f2a24c1853d803c1b9e310,
                    limb1: 0x9e78bb9233603b686b9d27,
                    limb2: 0x1d13a84fbcd96e81,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe5bc08950f2f1accd92245f4,
                    limb1: 0x3b653bbe7b6cfd9074b07f89,
                    limb2: 0x1638a8a07b89463b,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x549a4dee31909bd274709d7c,
                    limb1: 0x2628a928b4ed90e98d5de1f,
                    limb2: 0x1f2c2eeb200495b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xbae71f4f781675cce1119290,
                    limb1: 0x18995b20b8d0966bac7f5c23,
                    limb2: 0x1f7a255155ab7785,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x616d2877cb47206e625b0076,
                    limb1: 0xa7255531af3575b0a682d6df,
                    limb2: 0xdd4a0db8187661d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xea99c54030edacb739c9ad0f,
                    limb1: 0x1e2e84792f7a12b330406ecd,
                    limb2: 0x70f1e1a9673a240,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x4ca9473b8cae66da0baf8eca,
                    limb1: 0x9ca627187edabffeb80da281,
                    limb2: 0xda800cad866dc3c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x6dcd62554ccd88a00f3e90b3,
                    limb1: 0x141b8118cd6873dc9ac01a64,
                    limb2: 0x19146bc96fa6a4bd,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd21eca6170588371cf0fef12,
                    limb1: 0x2aae89b6d1784d7fe5d6f233,
                    limb2: 0x2fa67b7cd137898c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb20856046d39da92c0a6898a,
                    limb1: 0xc9dba030db3ed937e781ae4d,
                    limb2: 0x695a8c76fb0f771,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x919e8724022c5bd17875261b,
                    limb1: 0x3a2b09cc9362be43a8573a0,
                    limb2: 0x2cf4abb949016ad7,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x89062bf5adf784b526337420,
                    limb1: 0xf710d8fb0beb9551fe0e08f3,
                    limb2: 0x1577b6c8f024c52d,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x247a8333f7b0b7d2cda8056c3d15eef7, high: 0x5d67b7072ae22448b0163c1cd9d2b7d,
            },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x1f507980eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x154bc8ce8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x2305d1699a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x144a7edf6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x21c38572fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0x2b70369e16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x522c9d6d7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0xdc5dba1d977e9933c49d76fcfc6e625,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x5bffd2a2faf5d4a0c935d50c,
                    limb1: 0x4084090271d00764d84b3590,
                    limb2: 0x20a4daac223feb77,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5203a8edfe99a9265bfa3dee,
                    limb1: 0x69203f1c5320e35ca80b2090,
                    limb2: 0x2e2f28500b094e1d,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_11P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x37243e17b19c5ae4501ece31,
                    limb1: 0xfc13e3ef3c2d5605613146e6,
                    limb2: 0x1dc6a0e8ab0189de,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5a82fd507de47e929ea6cb37,
                    limb1: 0x9391446bbd2773952a6649ca,
                    limb2: 0x4afdf8374d166b3,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x328fbcfc7cae89b5c5fa4257,
                    limb1: 0xb1e9494927ed755e4d392933,
                    limb2: 0x2590494945eb8046,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa0aa4dbec89f522c15d53a9c,
                    limb1: 0xfef9a4cd94f4a608443a99ec,
                    limb2: 0x2cde3d7d5e8ed3a4,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x115cd91340716f078055dddb,
                    limb1: 0x54ee1a8df9774ca8c7a346fe,
                    limb2: 0x2841bb0bd2eb6b5d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x95a7710a3d1483bcd6242af2,
                    limb1: 0x74b72028d41b6280f8685d53,
                    limb2: 0xe324254b42ffbe9,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xb03c86f66ef15aa5d1de3be1,
                        limb1: 0xb21d48bae45c900613146ea7,
                        limb2: 0x1b580c766f86c7e9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7d3f13fbfe85b72a001fc3e4,
                        limb1: 0xc2f14c79617f4678e6bc631,
                        limb2: 0x2fed4d8c3a646908,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x71e581beb80344247eb417b7,
                        limb1: 0xe3a56b660ecf8feb921ac1aa,
                        limb2: 0x17986837f774f894,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe614aef6772c33ced471c504,
                        limb1: 0x54fd0631acd5439ceee49f5d,
                        limb2: 0x58228a1eb97d36c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x84d394b6603ef0550904c9aa,
                        limb1: 0xda509dc247e2f7b7864b1745,
                        limb2: 0x1a482d1b15b97f64,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x483b92edd910f231076c5045,
                        limb1: 0x56e05ae29ed6e5feba697eff,
                        limb2: 0x828e2d10a6ed754,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x23c22ad1d25dcc45ab9c121d,
                        limb1: 0x4cfa97358c01dddf66b4700b,
                        limb2: 0x6b76004a39c24f0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2ec0b66e50858f00e3e4a578,
                        limb1: 0x261ffafd829cc5220766b4a3,
                        limb2: 0xa80eb6642cd3197,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xde213bc12464493cf6197d08,
                        limb1: 0xe402e2c2b520d075596354ff,
                        limb2: 0x1f3bb948533da010,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x263dfc622dec89dfbfa2cbd0,
                        limb1: 0xe3facd8432ae7a7faf180379,
                        limb2: 0x2bdc3bcf06cf92f4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcd476c153f2c5a79524c0ed,
                        limb1: 0xff4c7bd66a92f3d39d667e3b,
                        limb2: 0x11ab0d23ffd41c37,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x58920c472163998b4e35788f,
                        limb1: 0xa0d38dde3a3753f29df4d189,
                        limb2: 0xba97a52902fb18d,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x1cebcb4e4ab650bbdaba642,
                        limb1: 0x43f3b243b32fe86dc2b68b38,
                        limb2: 0x149be990deda3544,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf2d959612d19097697efb49c,
                        limb1: 0xb83b817de49b22d09807b694,
                        limb2: 0x4aa4aabfbd9c584,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x31eac0772505cd58a4dcefb0,
                        limb1: 0xc4a78096f2b5d5731bcf07cd,
                        limb2: 0x2b42d40f53546c9f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xade02479bd219ee9804835c8,
                        limb1: 0x14f3eceab635246f71065f95,
                        limb2: 0x129cdf6aaf60a091,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6373b36c86fd7d358ed18ce7,
                        limb1: 0x8387db3d0668144d4650c4a3,
                        limb2: 0x130053f776dc74d9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5be784936a0788d480e11593,
                        limb1: 0x6cb3e0b510cf723b19b0d9a,
                        limb2: 0xf70766c6bf642d3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5dd9f8d1ec3a85646312467d,
                        limb1: 0xd927fc821bfb2aad6645e2d5,
                        limb2: 0x1043cf0644286a17,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6c101c9e38c7a01ca863ab1f,
                        limb1: 0x799159a950a029f39439f991,
                        limb2: 0x70f2153426da6ed,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdc922f1f0d69f429f2b94414,
                        limb1: 0xf2b9848c7c02d4d8f224f981,
                        limb2: 0x1268999a2f5672d1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc4c5d302b257be4b0cd56d37,
                        limb1: 0xf19b386e9b1fe3277d746ff4,
                        limb2: 0x107cb878d662d431,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2fa72e905124b8bf31f61d0c,
                        limb1: 0xd677bbd613857cd70f42de4c,
                        limb2: 0x2747e5a28a8756e3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x745c32357901742e736d79c0,
                        limb1: 0x5d07d83b36013ac72daaaccf,
                        limb2: 0xae16a71717bcd4d,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x7a92bccb327543d089820b80,
                        limb1: 0xc6a32b3b434084ba409b13a8,
                        limb2: 0x120d88b83c190aca,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe97119efb7be540131258096,
                        limb1: 0xde0cf501763d351a9bb61a34,
                        limb2: 0x2472f73ac3fddfd9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xba79a5ae4e23b25816d8632d,
                        limb1: 0xa1fac3bec1997e67f0ba1158,
                        limb2: 0x304c476ae7f22548,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa4774637937e89c3b1395e50,
                        limb1: 0xde7841bfe6e24288b8a5ea96,
                        limb2: 0x23a677284fd0b626,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc3c3fe76fb20e2c93a241623,
                        limb1: 0xd1bc3705a1a094aab9ebf42f,
                        limb2: 0x9ddfecf5fa8f8d1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1a15ddbafe7f625a667fbf28,
                        limb1: 0xb88778a6760619af394ca1f4,
                        limb2: 0x1b7d3326c7e0f852,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb55d40bf076b976d6358590a,
                        limb1: 0x7d7e0c58941f3c3b7d2bf542,
                        limb2: 0xcb330a9273523bc,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x23e638ef90b1c3356ed766f6,
                        limb1: 0x55f9566b8fd8243b1a57a57,
                        limb2: 0x11c83146c209caad,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7b3f81bcc65eb6eafe01d7b1,
                        limb1: 0x7b902b1b4d611829d4f5369b,
                        limb2: 0x13316c86092d821b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9af747babe2defe57d89dafe,
                        limb1: 0x7991f40eb7cfbed6258166e7,
                        limb2: 0xf8875a505b44d29,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3cc77139c386d0d01cf0bcb5,
                        limb1: 0x302da794c889b7f74976556c,
                        limb2: 0x27973a292da3f3ea,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc134aad509e078752160106e,
                        limb1: 0x58f0c4566312e4b8320cb2a9,
                        limb2: 0x2716f48bd97dbe9b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd3f335826979b0899480a04b,
                        limb1: 0x8b317da027fdcf8ee8ffb573,
                        limb2: 0x2f39a5110ae6f34f,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xaf10fc86efadf6d7e799f5a6,
                        limb1: 0x3f53573525dc539f5380038b,
                        limb2: 0x24c7f0f83d0f77c5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd303f1ae891a4a47c91501a6,
                        limb1: 0x34acf210d4b560e037e4b0ac,
                        limb2: 0x1179a77a08ed2283,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4b00412ac8bcb65c0d541560,
                        limb1: 0x75e4d161fa02592daa7effe7,
                        limb2: 0x26d4d2298a7ecbff,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc9fe6498309d8e95c8e01401,
                        limb1: 0xe9f2deab2431e7935ab58c42,
                        limb2: 0x2aef389f61caecc5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xac3c832511716ff3ac05594c,
                        limb1: 0x667da6e023b343b061601b6,
                        limb2: 0x1462dc613f916437,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x782a25836def831fc5ea80f2,
                        limb1: 0xeab9be67186025e61986a9f7,
                        limb2: 0x16c07f1a8df21d6c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4cbf41f0a48a84b68c118781,
                        limb1: 0xfb2dca8de38f611a9799c11d,
                        limb2: 0x2075f6b16fdb55f5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa38e1e9e8d61bc0a30332fdb,
                        limb1: 0x99d1b82230495437e712ead4,
                        limb2: 0x2c2c08c8b1293f91,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa44777c612c0916f2939046,
                        limb1: 0xf2ab58b49f663f47b691d5f6,
                        limb2: 0x293c68536f940405,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x270f990babb2a3e028e605dc,
                        limb1: 0x1fbadf70d7e5273d02c1e547,
                        limb2: 0x1a5565b14ec213c1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xea1a2cfa8bb2c981770bbd61,
                        limb1: 0x5001b06d19d5b4c3c39fea78,
                        limb2: 0x10c52bd06027a414,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9589bd713d9136408742e58,
                        limb1: 0xa6753f77ebf34f138a9f20dd,
                        limb2: 0x1b01c1dd2ae45155,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc4c5d302b257be4b0cd56d26,
                        limb1: 0xf19b386e9b1fe3277d746ff4,
                        limb2: 0x107cb878d662d431,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2fa72e905124b8bf31f61d0c,
                        limb1: 0xd677bbd613857cd70f42de4c,
                        limb2: 0x2747e5a28a8756e3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x745c32357901742e736d79c0,
                        limb1: 0x5d07d83b36013ac72daaaccf,
                        limb2: 0xae16a71717bcd4d,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xff959b0a00585a23db373d51,
                limb1: 0x611294def9c8f1fee0855042,
                limb2: 0x4c7f1a0a55ac31e,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x86b402ce02e7c7ca81f13d51,
                    limb1: 0x39493672733a9289a36020c1,
                    limb2: 0x7f40d91dc5413d3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x371e7b6a5c01505bd4334e81,
                    limb1: 0x2f596ae4492a87c66f7bda1a,
                    limb2: 0x9dffb4dcdb94df9,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x20669ef12954f8e3bbc8b4d3,
                    limb1: 0x396a6f7243c27ce553121ee3,
                    limb2: 0x11438ca2ec259aed,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa560a5759c90985fde99aca0,
                    limb1: 0xc5b21186cc6dcd0421026513,
                    limb2: 0x21fb1f47c6ac55b3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x3c26f4ff476ab777dc184776,
                    limb1: 0xbccb2cba46cf421f11eb4d14,
                    limb2: 0x27ec44064c727a3d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa893636703904fcbe984618c,
                    limb1: 0x73b210a224190b9b7b28784c,
                    limb2: 0x20f05486689dff6c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x74f2a24c1853d803c1b9e310,
                    limb1: 0x9e78bb9233603b686b9d27,
                    limb2: 0x1d13a84fbcd96e81,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe5bc08950f2f1accd92245f4,
                    limb1: 0x3b653bbe7b6cfd9074b07f89,
                    limb2: 0x1638a8a07b89463b,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x549a4dee31909bd274709d7c,
                    limb1: 0x2628a928b4ed90e98d5de1f,
                    limb2: 0x1f2c2eeb200495b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xbae71f4f781675cce1119290,
                    limb1: 0x18995b20b8d0966bac7f5c23,
                    limb2: 0x1f7a255155ab7785,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x616d2877cb47206e625b0076,
                    limb1: 0xa7255531af3575b0a682d6df,
                    limb2: 0xdd4a0db8187661d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xea99c54030edacb739c9ad0f,
                    limb1: 0x1e2e84792f7a12b330406ecd,
                    limb2: 0x70f1e1a9673a240,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x4ca9473b8cae66da0baf8eca,
                    limb1: 0x9ca627187edabffeb80da281,
                    limb2: 0xda800cad866dc3c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x6dcd62554ccd88a00f3e90b3,
                    limb1: 0x141b8118cd6873dc9ac01a64,
                    limb2: 0x19146bc96fa6a4bd,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd21eca6170588371cf0fef12,
                    limb1: 0x2aae89b6d1784d7fe5d6f233,
                    limb2: 0x2fa67b7cd137898c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb20856046d39da92c0a6898a,
                    limb1: 0xc9dba030db3ed937e781ae4d,
                    limb2: 0x695a8c76fb0f771,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x919e8724022c5bd17875261b,
                    limb1: 0x3a2b09cc9362be43a8573a0,
                    limb2: 0x2cf4abb949016ad7,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x89062bf5adf784b526337420,
                    limb1: 0xf710d8fb0beb9551fe0e08f3,
                    limb2: 0x1577b6c8f024c52d,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x2cb6c8386e51647e028876a2,
                    limb1: 0x3eeb71e38623705690872fa1,
                    limb2: 0xbf610b0d76e1a8f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x92f468ac225e9f9a2b52929d,
                    limb1: 0x28e7d79e30f3f4d4abf38c05,
                    limb2: 0x2e2ba523e6456871,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xe005b86051ef1922fe43c49e149818d1, high: 0x1f507980eece328bff7b118e820865d6,
            },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x154bc8ce8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x2305d1699a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x144a7edf6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x21c38572fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0x2b70369e16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x522c9d6d7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0xdc5dba1d977e9933c49d76fcfc6e625,
            },
            u256 {
                low: 0xd344749096fd35d0adf20806e5214606, high: 0x119d0dd09466e4726b5f5241f323ca74,
            },
            u256 {
                low: 0x5306f3f5151665705b7c709acb175a5a, high: 0x2592a1c37c879b741d878f9f9cdf5a86,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x76eba6c48fca7e67a1167f1b,
                    limb1: 0x99d1cf8af0d7925a391bf9a3,
                    limb2: 0x15af0f993a050918,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5e9e86e4463f32715e203759,
                    limb1: 0xfd925ca59f135f0fcf8d28a6,
                    limb2: 0x17f65bbc426d8da,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_12P() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xad8494e8136779204b79fdb0,
                    limb1: 0x1106e0faf7acbea85d7ccbc4,
                    limb2: 0x221173968566d58b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5d010b2ab18b8fd6aef2f88c,
                    limb1: 0xce45390beb6526076f61cc3e,
                    limb2: 0x3d0ba79090b4d5e,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x4e37d4acce2bf823caff1a12,
                    limb1: 0x66f9c676be7d9688dde7314f,
                    limb2: 0x1719179a1a7ad9d0,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x548f444afdaa53322be5c4f9,
                    limb1: 0xa4c1c68ebd65cb1ac4dac08,
                    limb2: 0xdb6596c070650a,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xe69d4894cb24aa574eeaa5fd,
                    limb1: 0xf22c899b13bb294507d3dcf2,
                    limb2: 0x216a1fcb358c5922,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x4f39b540b4a015c9056195a9,
                    limb1: 0x2a12714697de632f568353ad,
                    limb2: 0x13e9719e40183499,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xc8984ed1c9048744c0da2f08,
                        limb1: 0xe1edcf6673cb8c455a931f34,
                        limb2: 0xf057e55fecde5d0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa01e471d6f06aff5fd1eabc0,
                        limb1: 0xf584194a7ff86d2d95ac571b,
                        limb2: 0x2f4b73d75ee41c5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd8011455e97193aed8b1c1bb,
                        limb1: 0x937f8cef9b240c3d204fca7b,
                        limb2: 0x2f68f2741d7f4445,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x165c4553a728135f9aef1fe4,
                        limb1: 0x6af7c4f2592fb5e1057dfdfb,
                        limb2: 0x1a02cd03339a76f9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x53660c295aec30fa90c6fa0e,
                        limb1: 0x5f607f1f675e6d55d651c867,
                        limb2: 0x291e754beb700568,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdee8109e622259c36c03e664,
                        limb1: 0x3db405394b1c2ed9b24aa052,
                        limb2: 0x20c5666720990e60,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd259afa90fdca0fdc6347210,
                        limb1: 0xbc8dd9c40ace294b660c590,
                        limb2: 0x233d776d99b3ac7d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf5e54933542bc971aecfe947,
                        limb1: 0x9e560f8312c7f191017d6bd9,
                        limb2: 0x2b6f03c9a9f4460b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3db41c090e9798eeca0bb7a0,
                        limb1: 0xda90c8e83b9bd27a91c53456,
                        limb2: 0x1402648f89a8f1c4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xd2f58d9515525a7102be68a9,
                        limb1: 0xc639949f5665436c2b74c966,
                        limb2: 0xadfbb9088d48d0a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc16a50af8579f6cfeed89217,
                        limb1: 0xe4138762a1a3af8109b4e6f6,
                        limb2: 0x136028c5f9d98859,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xce7257ef8c4c9389f7409ee4,
                        limb1: 0x909ab5aa3b4d4eaa470618b4,
                        limb2: 0x149984b21ec5523d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb13ee311bdfd849f0a5aa22c,
                        limb1: 0xc5b4206332c80d5a868b7d8a,
                        limb2: 0x2792a43b8bfd7b1b,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x6412d2a0ccae48da749b7700,
                        limb1: 0xaa36b72e10c7dc83cff19a4c,
                        limb2: 0x38983bbfdb87d7d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4c8dff492d2d0c8c3c204a9e,
                        limb1: 0x61a9ef832012325cd7be87f8,
                        limb2: 0x1b9d2d8b6bb89ae0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5ab11fce8b05e8048ab6fbb0,
                        limb1: 0xeda6d484fbf4c378dc43f587,
                        limb2: 0x1b7e28eeca2c3bd5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x902a572b7f1dd4d36549525a,
                        limb1: 0x6331a73d4725689dab57e47b,
                        limb2: 0x7c34b9c2189b04a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfac77772f8974bd0de3ef85,
                        limb1: 0xc39665a05fe95aacb17f273,
                        limb2: 0x207272fba3a3ac85,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfa1ade6ea73e543ec841faf7,
                        limb1: 0xfb127e77063aee02a4b8fd36,
                        limb2: 0x234f04815c7f587,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa3cbede5f60b6ed6b9feaefc,
                        limb1: 0x587dd97710febf43387cdab5,
                        limb2: 0x1830d0efe2c6434,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xec95dc72e78e61280e131218,
                        limb1: 0x3c92cd0b3b14ea663f4b9395,
                        limb2: 0x1bbcbc4d59c3a3b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5e07a1f36f7300f331b0a680,
                        limb1: 0x2f5f5a5729d0400db338e125,
                        limb2: 0x9212e71eb80b208,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf8d00981ee1e3fef3307e8bc,
                        limb1: 0xdc25d55dbeeb05d3d6fe7dff,
                        limb2: 0xbe3738994ad444,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x51d12168722662e6e63468a4,
                        limb1: 0x6ba3832ff676a32be60b8807,
                        limb2: 0xeb518b44a426381,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4dedb8f5aa9bdd9d1c622663,
                        limb1: 0x9f8945e552befe9823d59f32,
                        limb2: 0x27240626be4255a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x91149f3262891eca1a94f564,
                        limb1: 0xe479f46718ebe457020cba45,
                        limb2: 0x946c85929a487c3,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x40a87c070296a0743a5ac764,
                        limb1: 0x42e735b576c0cd8e24d6b170,
                        limb2: 0x79e3172b5932fa3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeb051cf7ee82da292687372a,
                        limb1: 0x29994c80ddc623f2645706a8,
                        limb2: 0x679e2a97a19fabe,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4215498758a542265a315065,
                        limb1: 0x339146403472b95c0afbd15b,
                        limb2: 0x1b0af0f7b57aa605,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x957a9aceefc98128b4d7a46a,
                        limb1: 0x8de52603f06a955d0f9d5249,
                        limb2: 0x2efd135ad630ac5f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe8c699ec4bd64d23468aadbf,
                        limb1: 0xd3e242d9ff3dc34297590d27,
                        limb2: 0x148a92e64c6959a9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2880c171c42e92c5c84df775,
                        limb1: 0x136f417ad8abf05fec6b772a,
                        limb2: 0xd1d310769729e7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe576c76a44694204be004927,
                        limb1: 0xe047ada2f45d2f4cdec4e6bf,
                        limb2: 0x1b20d495653e1744,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x43839feda0f12745f2b049ac,
                        limb1: 0x508a174b885b57c57328d2c2,
                        limb2: 0x3340f14e0ae4dd4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xeb1fd39b88739c4417e695d,
                        limb1: 0xbeaa19ac4d6f97d4a5e9dff7,
                        limb2: 0x218b8d693efa1598,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7508864bf2da74d04be4e731,
                        limb1: 0x782d6471e70417ac4fae1b85,
                        limb2: 0x2f63840e74d1bb01,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5ff95c60191d3e9e3eadc99b,
                        limb1: 0x13ef952e0a0c5ee4b246e2be,
                        limb2: 0x808444cab9658b5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x30912ca8894fa17dc5935495,
                        limb1: 0x6ec1f69a51829139c9ba8af9,
                        limb2: 0x2bacb7f944974db1,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x39605a06375c797eb14c97f6,
                        limb1: 0x6caeed343ca1af143e9648a6,
                        limb2: 0x2807959e5dbba12a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc379cbc31e5a06a62031e2fe,
                        limb1: 0x7b2fe339e35b370011dec36f,
                        limb2: 0x9781b2632cdd622,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x4e32e474f03114a621ad1902,
                        limb1: 0x22fe615de5bd0bf9815c917e,
                        limb2: 0x24a6dd69e922eafb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xabd071d0a6d5c27761db0b8c,
                        limb1: 0xb6d9d16bedd81b793e600b57,
                        limb2: 0xe7b0a3aa4adf8ba,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbb7b48f56b6f2f7a29d9495a,
                        limb1: 0x6b0e9c4c53cc789cf183c4d7,
                        limb2: 0x108a58a15f00486c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3e6f5a712759078c8abcff09,
                        limb1: 0x3cdb6d3fdbcff322e7b726f1,
                        limb2: 0x10be69b66728a90a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7d11e69cefc1d9599ffd62d4,
                        limb1: 0x7d4d22604ab90e0615626971,
                        limb2: 0x852e9c53afc07d5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x38a1cb06b3c4456d2e55514a,
                        limb1: 0xf9bcb454138c4da9142f0d29,
                        limb2: 0x265e829839168df7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2958fb776c3d6e24fb5fb39f,
                        limb1: 0x3b267c0ba7bc0d84134146b4,
                        limb2: 0x1e73bc1021c8a8fa,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1af7398275e898db7e9fbbf7,
                        limb1: 0x399c81bc28a87884291a3853,
                        limb2: 0x2cd5025579960eea,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa27edf8950231a683b86ec7b,
                        limb1: 0xb6fe9587456c0e8e5ec1aadd,
                        limb2: 0x28921482f702a3a3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x97b4bcd669eb258846783a81,
                        limb1: 0x724af3f3e4e4b48f19ca64fe,
                        limb2: 0x2545b0bfb165ebcb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xde51d759a66b9bb674981f39,
                        limb1: 0xb048736c64bace4dc18b1483,
                        limb2: 0x13aba092d15328f0,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xaaf7ca345efb3f183f2c19ee,
                        limb1: 0x4f91fbd32ca2b0507a3d3716,
                        limb2: 0xfef365ba28bd72d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3d57396e728b0ad32f239d1c,
                        limb1: 0x914db15f1d463d8154f5c083,
                        limb2: 0x249c23185a2450e9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x51d12168722662e6e6346893,
                        limb1: 0x6ba3832ff676a32be60b8807,
                        limb2: 0xeb518b44a426381,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4dedb8f5aa9bdd9d1c622663,
                        limb1: 0x9f8945e552befe9823d59f32,
                        limb2: 0x27240626be4255a,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x91149f3262891eca1a94f564,
                        limb1: 0xe479f46718ebe457020cba45,
                        limb2: 0x946c85929a487c3,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x24d12184caf3529014dfc09b,
                limb1: 0x2f1cf63492c98e99a390fce9,
                limb2: 0x933fba0e3dda29c,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x86b402ce02e7c7ca81f13d51,
                    limb1: 0x39493672733a9289a36020c1,
                    limb2: 0x7f40d91dc5413d3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x371e7b6a5c01505bd4334e81,
                    limb1: 0x2f596ae4492a87c66f7bda1a,
                    limb2: 0x9dffb4dcdb94df9,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x20669ef12954f8e3bbc8b4d3,
                    limb1: 0x396a6f7243c27ce553121ee3,
                    limb2: 0x11438ca2ec259aed,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa560a5759c90985fde99aca0,
                    limb1: 0xc5b21186cc6dcd0421026513,
                    limb2: 0x21fb1f47c6ac55b3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x3c26f4ff476ab777dc184776,
                    limb1: 0xbccb2cba46cf421f11eb4d14,
                    limb2: 0x27ec44064c727a3d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa893636703904fcbe984618c,
                    limb1: 0x73b210a224190b9b7b28784c,
                    limb2: 0x20f05486689dff6c,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x74f2a24c1853d803c1b9e310,
                    limb1: 0x9e78bb9233603b686b9d27,
                    limb2: 0x1d13a84fbcd96e81,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe5bc08950f2f1accd92245f4,
                    limb1: 0x3b653bbe7b6cfd9074b07f89,
                    limb2: 0x1638a8a07b89463b,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x549a4dee31909bd274709d7c,
                    limb1: 0x2628a928b4ed90e98d5de1f,
                    limb2: 0x1f2c2eeb200495b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xbae71f4f781675cce1119290,
                    limb1: 0x18995b20b8d0966bac7f5c23,
                    limb2: 0x1f7a255155ab7785,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x616d2877cb47206e625b0076,
                    limb1: 0xa7255531af3575b0a682d6df,
                    limb2: 0xdd4a0db8187661d,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xea99c54030edacb739c9ad0f,
                    limb1: 0x1e2e84792f7a12b330406ecd,
                    limb2: 0x70f1e1a9673a240,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x4ca9473b8cae66da0baf8eca,
                    limb1: 0x9ca627187edabffeb80da281,
                    limb2: 0xda800cad866dc3c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x6dcd62554ccd88a00f3e90b3,
                    limb1: 0x141b8118cd6873dc9ac01a64,
                    limb2: 0x19146bc96fa6a4bd,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd21eca6170588371cf0fef12,
                    limb1: 0x2aae89b6d1784d7fe5d6f233,
                    limb2: 0x2fa67b7cd137898c,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb20856046d39da92c0a6898a,
                    limb1: 0xc9dba030db3ed937e781ae4d,
                    limb2: 0x695a8c76fb0f771,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x919e8724022c5bd17875261b,
                    limb1: 0x3a2b09cc9362be43a8573a0,
                    limb2: 0x2cf4abb949016ad7,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x89062bf5adf784b526337420,
                    limb1: 0xf710d8fb0beb9551fe0e08f3,
                    limb2: 0x1577b6c8f024c52d,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x2cb6c8386e51647e028876a2,
                    limb1: 0x3eeb71e38623705690872fa1,
                    limb2: 0xbf610b0d76e1a8f,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x92f468ac225e9f9a2b52929d,
                    limb1: 0x28e7d79e30f3f4d4abf38c05,
                    limb2: 0x2e2ba523e6456871,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x7bfeb500d87c8d6a89e3b500,
                    limb1: 0x114bfa8db0c1f0065e73cf9a,
                    limb2: 0x129e9c5a3641b28e,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x755ef61cf917721bfef36992,
                    limb1: 0x8f3d6b6348b89a2c0cfa9d3f,
                    limb2: 0x272de7db2186fd11,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x4a84eb038d1fd9b74d2b9deb1beb3711, high: 0x154bc8ce8c25166a1ff39849b4e1357d,
            },
            u256 {
                low: 0x3405095c8a5006c1ec188efbd080e66e, high: 0x2305d1699a6a5f92cca74147f6be1f72,
            },
            u256 {
                low: 0x1775336d71eacd0549a3e80e966e1277, high: 0x144a7edf6288e1a5cc45782198a6416d,
            },
            u256 {
                low: 0x2f1205544a5308cc3dfabc08935ddd72, high: 0x21c38572fcd81b5d24bace4307bf326,
            },
            u256 {
                low: 0x42930b33a81ad477fb3675b89cdeb3e6, high: 0x2b70369e16febaa011af923d79fdef7c,
            },
            u256 {
                low: 0x2648ee38e07405eb215663abc1f254b8, high: 0x522c9d6d7ab792809e469e6ec62b2c8,
            },
            u256 {
                low: 0x85940927468ff53d864a7a50b48d73f1, high: 0xdc5dba1d977e9933c49d76fcfc6e625,
            },
            u256 {
                low: 0xd344749096fd35d0adf20806e5214606, high: 0x119d0dd09466e4726b5f5241f323ca74,
            },
            u256 {
                low: 0x5306f3f5151665705b7c709acb175a5a, high: 0x2592a1c37c879b741d878f9f9cdf5a86,
            },
            u256 {
                low: 0x30bcab0ed857010255d44936a1515607, high: 0x1158af9fbb42e0b20426465e3e37952d,
            },
            u256 {
                low: 0x5f3f563838701a14b490b6081dfc8352, high: 0x1b45bb86552116dd2ba4b180cb69ca38,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x58e8c62727bd58b1847d5e1d,
                    limb1: 0x20564e0613740967122967a3,
                    limb2: 0xc7c708c96cd0b25,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xd893400d48ccf8414624fb95,
                    limb1: 0xc289afa9c3e752bb82dd8543,
                    limb2: 0x4f5b298e2aaddef,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_BN254_1P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xb4b30030d604f094d3602296,
                limb1: 0xa0e983b28babaffaeaa2a062,
                limb2: 0x471c9e526d4e91e,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_BN254_2P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x4438dbd4fc537b19aa9029a1,
                limb1: 0x71338662165803d1aeba36ff,
                limb2: 0x8463adc2f6b3ff5,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x75937bc3dba286ad2bd8fe5,
                    limb1: 0x575d166325014e975405464f,
                    limb2: 0x1437873db8d7dca1,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x772ca79c580e121ca148fe75,
                    limb1: 0xce2f55e418ca01b3d6d1014b,
                    limb2: 0x2884b1dc4e84e30f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x967d0cae6f4590b9a164106cf6a659e,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_BN254_3P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x5b9b511a35490c4f05d6e4e7,
                    limb1: 0xf11ec8642a0df9cb0b8f2cdd,
                    limb2: 0x2b568cd4a3e221ca,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb45c3680d8359a0fdb47de6f,
                    limb1: 0x4c17fe1c96f237095df8c737,
                    limb2: 0x118fc0474955ac2b,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x47bec5e5e1f295cdcd7689e9,
                    limb1: 0xcb171283d651071401630545,
                    limb2: 0xa401c0298cd5f83,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe5d2831c05e61956d8725b57,
                    limb1: 0x6bb84991518471727263fde0,
                    limb2: 0x15e82f62ee3caf32,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xd15f8e23aaf3af13ab5ba169,
                    limb1: 0xb0ff9631870f189040aec289,
                    limb2: 0x1c77509b88d3bab7,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb620e3716b30b1003beab421,
                    limb1: 0x1d6aad1137155249c5d4f785,
                    limb2: 0xbf95d2db0be45f9,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xbba74f84d6d3a3c60dc3cd41,
                        limb1: 0xf36f80b4b1a3f69f44ab1b6a,
                        limb2: 0x16adf9385577d09,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe3748a5201028055d851d0da,
                        limb1: 0x7d4d0c483a8050c66e35c6e1,
                        limb2: 0xe58ca0d31a6a8d2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa59f084b703ac17683ca07f9,
                        limb1: 0x7f1a924087f5442a95a66068,
                        limb2: 0x284cb90ec99aa375,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1c72c56de666104df8056a9f,
                        limb1: 0x3b0db6cd914b52831fc41396,
                        limb2: 0x1953864f49cc904c,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x36208c0885fb7058abddd334,
                        limb1: 0x3db412a5e6005a05ab374adf,
                        limb2: 0x2b398812b30eb292,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdf68dc78906c44847536a23d,
                        limb1: 0xa6bbd9ceb18275da98d88a68,
                        limb2: 0x11b898e607064ade,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6f0aaf5b805720e403eddcdc,
                        limb1: 0x11afb25fbfae966d38aea0d6,
                        limb2: 0xc14f6e4a6a37797,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x712f22263ef5e91c488b0722,
                        limb1: 0xbf68443cfd66208b1f0a2b4e,
                        limb2: 0x19990ced3afb3faa,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x210edfad5881dc6bf8ec5f58,
                        limb1: 0x3c354ff8e0cba98c03e7c606,
                        limb2: 0x1d8c9c28e2545384,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x95055f0bf55a751df0f89316,
                        limb1: 0x652b61b3a2e6073c3af64fcc,
                        limb2: 0x23080aa3e59e0cc4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9e36b036fbad71c308a43548,
                        limb1: 0x5261fa4f1b50b2519194e556,
                        limb2: 0x218c5e7ffb07ea5e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc8285d3649f36c8f5daaa331,
                        limb1: 0x3f053e816c7552d20ecadbc7,
                        limb2: 0x2527827f86516567,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7b5fb11b84d5950d23c96fa4,
                        limb1: 0xe2b051a2b9c1cc88b1d77617,
                        limb2: 0x1edee19e79e4e9ad,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xd17e0eff19b138dc529f7f0e,
                        limb1: 0x487bac84aefe5d55d2a30b7a,
                        limb2: 0x20e3fb5256c8d763,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x35c8cadc752441768726e970,
                        limb1: 0x3be347b593060932330834a9,
                        limb2: 0x4c57c3f33e14072,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4d200e12810562ac0bc99694,
                        limb1: 0x350f171f3f0bc347aa0be283,
                        limb2: 0x243ee4adf3ea66c5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb8ca5d60ca9c137fd484ee0c,
                        limb1: 0xb4c53efdb300aebd952f7a7,
                        limb2: 0x173c11f4a19d313f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdf68dc78906c44847536a240,
                        limb1: 0xa6bbd9ceb18275da98d88a68,
                        limb2: 0x11b898e607064ade,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6f0aaf5b805720e403eddcdc,
                        limb1: 0x11afb25fbfae966d38aea0d6,
                        limb2: 0xc14f6e4a6a37797,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x712f22263ef5e91c488b0722,
                        limb1: 0xbf68443cfd66208b1f0a2b4e,
                        limb2: 0x19990ced3afb3faa,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x48c8946a24cb60456d420600,
                limb1: 0x9ed381bdd7c9eeb7bafa2d1,
                limb2: 0xa24e6a0b6a74206,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x772ca79c580e121ca148fe75,
                    limb1: 0xce2f55e418ca01b3d6d1014b,
                    limb2: 0x2884b1dc4e84e30f,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x536c985db33c69f7c242e07a,
                    limb1: 0xfc531bccffafcf1e59d91fb9,
                    limb2: 0x2585e4f8a31664cb,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x57fa42444057cf0c1d62ae3c,
                    limb1: 0x4f48d341183118d68ea41313,
                    limb2: 0x1d2d2799db056ed1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0x1521f387af19922ad9b8a714e61a441c,
            },
            u256 {
                low: 0x5a92118719c78df48f4ff31e78de5857, high: 0x28fcb26f9c6316b950f244556f25e2a2,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 0,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x21725fdb9f487676e547051,
                    limb1: 0xc23930e4f96498a77a316418,
                    limb2: 0x1244cb13309195ed,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x6251c487cf0f5a44ac24a45b,
                    limb1: 0xf1db336c10ce7fae206dd8dd,
                    limb2: 0x1da9c56792006d76,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_1P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x64c9ef86686ed7cb0fa42251,
                limb1: 0x17c282e8624e1788ff8fbc5b,
                limb2: 0x712b5be5bb66eb8f72af3c9c,
                limb3: 0xc182b0f0e8d6cf017feeb4d,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x5c35d2ca01541a34fb66d844,
                    limb1: 0xda7b85c12db291e5c2c802b2,
                    limb2: 0x5987ec0b8e681de8e6dd0e3c,
                    limb3: 0x1d4ef28e7e9c0cae8144b52,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_2P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xa9125be5f17f34ce6de5896b,
                limb1: 0x77ff67ddaf6b61c4088ee57a,
                limb2: 0xb4940789dbaf29c60e3ae417,
                limb3: 0xbab38248ecf0eb99f06ac59,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xe4f817e54aede0613c17035c,
                    limb1: 0xdff1f15010392a6da1f95a6,
                    limb2: 0xbed78d3d341e911d49f15454,
                    limb3: 0x18154782ce0913b21588066d,
                },
                y: u384 {
                    limb0: 0x3d77d61326ef5a9a5a681757,
                    limb1: 0xd3070afd4f0e121de7fcee60,
                    limb2: 0xdf9ef4088763fe611fb85858,
                    limb3: 0x11a612bdd0bc09562856a70,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x12cfa194e6f4590b9a164106cf6a659e,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_BLS12_381_3P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xf6a31a9a41fd0378150dc360,
                    limb1: 0x7a355df87079a4cf4c78fd36,
                    limb2: 0xbd92b81f9f87a14ded17256e,
                    limb3: 0x1259b26908470ad4f6be037c,
                },
                y: u384 {
                    limb0: 0xfbe2abbd7e05b561703438fe,
                    limb1: 0x892d1cc404bcc0c000d206cf,
                    limb2: 0x962b60138682dd48428b2a8d,
                    limb3: 0xa68b20ba71d8fde199d485b,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x7c866be61fbaed5ef7d1122e,
                    limb1: 0x7fed89acb87ce49d38175a6f,
                    limb2: 0x30dbb6ee5876fa6873045668,
                    limb3: 0x60c4285948cc11859881060,
                },
                y: u384 {
                    limb0: 0x5a931aaa036da6ee08c49738,
                    limb1: 0x1c92b3a560ce474174cfa275,
                    limb2: 0xa4f783dad6c9da34040c6553,
                    limb3: 0x8d9752128e5b2be6254e2b,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x663acbe46ab1edf9e0302ddb,
                    limb1: 0x133eafb6b82660d39354a91b,
                    limb2: 0xec9146f8b18f4ccfa8f938e,
                    limb3: 0x1127139158d2558af3ede6c1,
                },
                y: u384 {
                    limb0: 0x2e2dc7b89be127d3eee7e15f,
                    limb1: 0xb9b688b1096640c721587415,
                    limb2: 0xd09f1d870e1c2d4e08674d2b,
                    limb3: 0x12308a0685f2c08876496459,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xeb35755831b8b274a72187ca,
                        limb1: 0x619d73fdc8ca106f251bb23f,
                        limb2: 0x83526e9a98267e300003744c,
                        limb3: 0x74e843f7fd9b3c1eb4f8a71,
                    },
                    u384 {
                        limb0: 0x263294ccc2a97ffb2ec76a8e,
                        limb1: 0xd158f356f93267263354d7e2,
                        limb2: 0x714889219b424296b85139b5,
                        limb3: 0xa8f3019b0a505d2ffd1caac,
                    },
                    u384 {
                        limb0: 0xbf917add7208b045d906ff3f,
                        limb1: 0xcd23d9673211a97506787efc,
                        limb2: 0x7179e6dc54430c65b26530b3,
                        limb3: 0x17bb9453c160e11d98066ff9,
                    },
                    u384 {
                        limb0: 0xebd56ed5f538ae24aa8dc0e2,
                        limb1: 0x3ba413917f065ec7e45c2721,
                        limb2: 0xa9b1360228e4503e35364d2b,
                        limb3: 0x1301d2f14e9626ee2309422,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x9b4aac8938de0d6d29299aec,
                        limb1: 0xed00b7c2b8d648ca0d5cb5bc,
                        limb2: 0xa052f33dafe080f320f1ff8e,
                        limb3: 0xa83d431853448de44c440fa,
                    },
                    u384 {
                        limb0: 0xc5a014c4a628fb418afdc431,
                        limb1: 0xff1bc5487dcfd4fac800f591,
                        limb2: 0xf09802d0f98c9a1e7d8b3326,
                        limb3: 0x125f173ee992bebf294f042f,
                    },
                    u384 {
                        limb0: 0xb9100f1617268243b95b9208,
                        limb1: 0xb1f5e20e709d1d7cf3b2d087,
                        limb2: 0x39c86f0b79ca465e49a95325,
                        limb3: 0x1269c9e792e7575a1b407349,
                    },
                    u384 {
                        limb0: 0x2cb2b76ffc0a57eef2f100c5,
                        limb1: 0x8c7ae8ef5688c4968d0ade85,
                        limb2: 0xf0719994ff5b34265dca49d0,
                        limb3: 0x141860f0e8a032121ffd28c2,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xda7bc5a089fc35de52b5ab6d,
                        limb1: 0x374d31abeda2bc7d1fa3314b,
                        limb2: 0xdc9b575368802cb064ea215d,
                        limb3: 0x586829f9bf69e05abd324e6,
                    },
                    u384 {
                        limb0: 0xdf7cbeaa6d31e6304e21b449,
                        limb1: 0x98191ab75477b88d9100a3b0,
                        limb2: 0xaccec7142afafc55a16d5a5d,
                        limb3: 0x2145b524c0790e06e301e66,
                    },
                    u384 {
                        limb0: 0xc03bb07a666edb299db815a6,
                        limb1: 0xfc9f8e6a16f220fde529492c,
                        limb2: 0xa907065eb5bf6b0eb40cf236,
                        limb3: 0x1149cca478baba09dee1d533,
                    },
                    u384 {
                        limb0: 0x8e5d1fd64b21b819208b11ea,
                        limb1: 0x66e777b31da1abe09cc24423,
                        limb2: 0x426e7a0bf850c1501a08cee7,
                        limb3: 0x7dbacd73a097db82eaceab9,
                    },
                    u384 {
                        limb0: 0x7b6589cb116ffb6c5cd73707,
                        limb1: 0xa62d2451aecbbdb4a8c8ed99,
                        limb2: 0xca0de292aeae27f922326d89,
                        limb3: 0xd8a62ad9db2e6794979a947,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xbbd6b225297935b4a4a6c105,
                        limb1: 0x4cd20c69eca82d0416c6d6f3,
                        limb2: 0x3e00201f5b0ab8479042eb7c,
                        limb3: 0x100e3edbdb513cdec7f55c34,
                    },
                    u384 {
                        limb0: 0xb3d8531324a5ed062bf7bb6e,
                        limb1: 0x2e0d6fe009dd67a2e2abd649,
                        limb2: 0x3bc8b1951d43d1700f22a71d,
                        limb3: 0x157a3927334b2dc80f04c153,
                    },
                    u384 {
                        limb0: 0x81983c58e89c090ee56ef2ca,
                        limb1: 0xf975e2f7d51289ab91734221,
                        limb2: 0x608a627f1e3a826f3f9b2717,
                        limb3: 0x15a503c9d89d9033d6ca7db8,
                    },
                    u384 {
                        limb0: 0x3a198a49fb0a6d28f4ee9dff,
                        limb1: 0xe959e39d2ee678b7e5842fd5,
                        limb2: 0x9836530b7fe76efdbd8bee92,
                        limb3: 0xce222367b355d57e365ece3,
                    },
                    u384 {
                        limb0: 0xc5a014c4a628fb418afdc435,
                        limb1: 0xff1bc5487dcfd4fac800f591,
                        limb2: 0xf09802d0f98c9a1e7d8b3326,
                        limb3: 0x125f173ee992bebf294f042f,
                    },
                    u384 {
                        limb0: 0xb9100f1617268243b95b9208,
                        limb1: 0xb1f5e20e709d1d7cf3b2d087,
                        limb2: 0x39c86f0b79ca465e49a95325,
                        limb3: 0x1269c9e792e7575a1b407349,
                    },
                    u384 {
                        limb0: 0x2cb2b76ffc0a57eef2f100c5,
                        limb1: 0x8c7ae8ef5688c4968d0ade85,
                        limb2: 0xf0719994ff5b34265dca49d0,
                        limb3: 0x141860f0e8a032121ffd28c2,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xdd789d7c02428dc60246d081,
                limb1: 0xc9de1388dd3a5eaff5de8784,
                limb2: 0x6eac6c37a0a90e65dd33fbc8,
                limb3: 0x89f38f13155da73ef366afc,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0xe4f817e54aede0613c17035c,
                    limb1: 0xdff1f15010392a6da1f95a6,
                    limb2: 0xbed78d3d341e911d49f15454,
                    limb3: 0x18154782ce0913b21588066d,
                },
                y: u384 {
                    limb0: 0x3d77d61326ef5a9a5a681757,
                    limb1: 0xd3070afd4f0e121de7fcee60,
                    limb2: 0xdf9ef4088763fe611fb85858,
                    limb3: 0x11a612bdd0bc09562856a70,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xde4f62a6588c9401ffefbd3,
                    limb1: 0x9bb5f797ac6d3395b71420b5,
                    limb2: 0xdc39e973aaf31de52219df08,
                    limb3: 0x105dcc4dce3960447d21d3c1,
                },
                y: u384 {
                    limb0: 0xaefd0d854043fd325dd3c34f,
                    limb1: 0x9b63c98d9a7845c52e1e2b0f,
                    limb2: 0x9db0be660d847ccc58358f3f,
                    limb3: 0x17cb6c41f0c4e1a7394ab62a,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0x2a43e70faf19922ad9b8a714e61a441c,
            },
            u256 {
                low: 0x5a92118719c78df48f4ff31e78de5857, high: 0x51f964df9c6316b950f244556f25e2a2,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 1,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x2b828af1f5fe30bbe7a1074a,
                    limb1: 0x5669beaa69827b52dc874c9f,
                    limb2: 0x648af2c24d82a5a758c96b8e,
                    limb3: 0x188bc245620ae6b6afec9dc3,
                },
                y: u384 {
                    limb0: 0xdc96192f803ef92f56d59758,
                    limb1: 0xfc6139925c05a030065d564,
                    limb2: 0xb24447300bec56efec94dcf4,
                    limb3: 0x156f97e5d31055c0a5fe154d,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_1P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x3ca5552c96ec2a5049d28426,
                limb1: 0xc8669717174b973f4de5a646,
                limb2: 0x4fbfb38ec0c14e6e,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_2P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xcab2bdb49d36853afc772e84,
                limb1: 0x9388d6adcd576a1b6ae83895,
                limb2: 0x4a4640dc5b206990,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xa65fee3201baba3b9c2f59b5,
                    limb1: 0x1ff3274e058360d6b1e64db3,
                    limb2: 0x2af2ec2fe4bf31ee,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0xda5e742b60f13ba9478a5085,
                    limb1: 0x4ef5a3a77cc1f80dedc41ae6,
                    limb2: 0x511bc713034c93d4,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x113c8d620e3745e45e4389b8,
                    limb1: 0x85b8ff52d905fd02fe191c3f,
                    limb2: 0xf5d132d685201517,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x60c0ba1b358f375b2362662e,
                    limb1: 0x6abfc829d93e09aa5174ec04,
                    limb2: 0x7bc4637aca93cb5a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xeb1167b367a9c3787c65c1e582e2e662, high: 0xf7c1bd874da5e709d4713d60c8a70639,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_SECP256R1_3P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0xf831856624736393b3b76d11,
                    limb1: 0xc165a27df5b76589fe2ce1e2,
                    limb2: 0x2a23444ace6bef77,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa6bbeec6fb0369c3de339579,
                    limb1: 0xd394f6a5704d1de2da06048,
                    limb2: 0xe8057073c0fde87b,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x3b1d72dc227f75f02874e08b,
                    limb1: 0xd395fa7c14d6ff33d03e1baf,
                    limb2: 0xbf16fcc65f95b486,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe2461ebbe7a5b4d76dbef92b,
                    limb1: 0x3eecb75c5315cd3d2d0b9456,
                    limb2: 0x8192517353bc6523,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xcff970bda4db69dac06ebad8,
                    limb1: 0xdee4204cca252abd67132509,
                    limb2: 0xa79c0006b6ca7fab,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x759642b853dd01b9d2d7bb18,
                    limb1: 0xe1e1d2f8bf0f2f5b463bfae0,
                    limb2: 0xbc3c71be130f204d,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x9103bd16e2232359c067051c,
                        limb1: 0x47056dacf5ebc26121584255,
                        limb2: 0x510b978b1c20d16d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3866c583186023310ae6006f,
                        limb1: 0x94b09aee6293fdcebd256a74,
                        limb2: 0xe9964a385943e6e7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4e66f352e983f05cd787905a,
                        limb1: 0x23e4fc7f433c2785b079f227,
                        limb2: 0x6b71075ebbeffe51,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x8d716d3dc708179fd42941cc,
                        limb1: 0xd8e4a54aef03a57c0c4a1845,
                        limb2: 0xed1182498b974526,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0x32f47eb672f5bb330a73bb4a,
                        limb1: 0x1a8091c6f1f3893bc55d0fa5,
                        limb2: 0x8f7089d778e965c2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc7a8f052fc045a7c4ceff3e,
                        limb1: 0x8b14021f73a80543f9ad14a3,
                        limb2: 0x508a2680c93698e4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfc72a135b2aaa8dee44f9400,
                        limb1: 0x9f66c7f22c15ecf4bac82c86,
                        limb2: 0x6724ac9ffc3487b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x28b8828023437a8d6e45900c,
                        limb1: 0x490cdc11b822023a5eedbb11,
                        limb2: 0xcf427b32bdfa36c7,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xc31b8bfe95c99a953dfbeabd,
                        limb1: 0xe63b42304b4dc475c331d5ac,
                        limb2: 0x499b1e200475197c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xf166baa3bc64785c42f2e9eb,
                        limb1: 0xd575ea7fa8f28aaa7a9b0f64,
                        limb2: 0x128864b271e1ebf2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x116db906aee291051c9ce08,
                        limb1: 0x2943633ba402debefac3b9a0,
                        limb2: 0x36d5e25b3ef465fb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x525c3dbd1864649780b5a73e,
                        limb1: 0x65b5ed8ec92dd969aa336caa,
                        limb2: 0x3f69b099f8b6619c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdcb8bc014e35c6d4febb77c9,
                        limb1: 0x25ffc8096d6e87b1e76b8e6e,
                        limb2: 0x45eaa89a67cda802,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xbeada704feb34546e4301ab0,
                        limb1: 0x5b533141bf8fd64c6afe4bd9,
                        limb2: 0x4e4368ec25ed3c45,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1a26c33296a4cf0e96b4d599,
                        limb1: 0x27f1e1d4a919a68c6edaf9df,
                        limb2: 0x7e1cc39a4fc825b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xa37d8288f41c6ce32ecb17e2,
                        limb1: 0x56f36c3517bd230fefdbda97,
                        limb2: 0xde1b03a23f8bb59e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9d3ed76f0cda7c44b1892480,
                        limb1: 0xad525772678432d3dd0efe6,
                        limb2: 0x1e5683ea757beea2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x5ea4b87b01c4123da1d0af63,
                        limb1: 0x63d92b3fc1da85514200ea22,
                        limb2: 0x3d88eabf39828878,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfc72a135b2aaa8dee44f93fd,
                        limb1: 0x9f66c7f22c15ecf4bac82c86,
                        limb2: 0x6724ac9ffc3487b8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x28b8828023437a8d6e45900c,
                        limb1: 0x490cdc11b822023a5eedbb11,
                        limb2: 0xcf427b32bdfa36c7,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x4d4cd96c2a9c3eeb03a36099,
                limb1: 0x68066c4db63f81f0b9abcbb6,
                limb2: 0x3cf75d802ff73183,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x113c8d620e3745e45e4389b8,
                    limb1: 0x85b8ff52d905fd02fe191c3f,
                    limb2: 0xf5d132d685201517,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x60c0ba1b358f375b2362662e,
                    limb1: 0x6abfc829d93e09aa5174ec04,
                    limb2: 0x7bc4637aca93cb5a,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xd3ff147ff0ee4213f51f677d,
                    limb1: 0x431366a7732a6e4a6b942255,
                    limb2: 0x9fe743b25d39a591,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x7f8bb562ff60a902ef14bcb0,
                    limb1: 0xeb9420089fa531db62e806a6,
                    limb2: 0xfd028df433dfd5cc,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xe443df789558867f5ba91faf7a024204, high: 0x23a7711a8133287637ebdcd9e87a1613,
            },
            u256 {
                low: 0x1846d424c17c627923c6612f48268673, high: 0xfcbd04c340212ef7cca5a5a19e4d6e3c,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 3,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x33ee7695471a03192ef22266,
                    limb1: 0xb449dd8cfd0c3438e14a718c,
                    limb2: 0x1fbb33f079b828e2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xb411f97aeec2eae6044122ec,
                    limb1: 0xcdce180b60667260d7ce284e,
                    limb2: 0xa73a7381dd3b07c,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_1P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x69588367250041f054620d3b,
                limb1: 0x1174ea4879bb0b580868e8e8,
                limb2: 0x7ea9eb687089d547,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_2P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x862bbbc7625bb23fe3ee10f0,
                limb1: 0x868baf0626c044f9a077a0ca,
                limb2: 0x155e74b122885e85,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x610f7ffe1889436670829e43,
                    limb1: 0xb1f2329808ffbbfd2a7fce4c,
                    limb2: 0x56c9e223dae04be9,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xeb1167b367a9c3787c65c1e582e2e662, high: 0xf7c1bd874da5e709d4713d60c8a70639,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_SECP256K1_3P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x81f93764cd87ff5af9aad87f,
                    limb1: 0x8aa0792747a5b8ca16b9e369,
                    limb2: 0xce30fe4be7b17451,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5b77703ae4639b17cfca6124,
                    limb1: 0x86b771c3a15eee8b1ca9feaa,
                    limb2: 0x5acc99b6152d28a4,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0xff8927eca139c99d7960c8ef,
                    limb1: 0xec91eee7a0301418e07f41fc,
                    limb2: 0xb49b07479d1c26aa,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xe496c28fbc13ed8a0324b632,
                    limb1: 0x2d5583856241be833fec7c9d,
                    limb2: 0xff1c723bbb39f40b,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x3efedfaf5b7ce0a80c4fa5a1,
                    limb1: 0x2c16205bc2efe9dcc6eefa9a,
                    limb2: 0x3f2cefb8efbcc695,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xc3eeedd13fa2c621a214d57,
                    limb1: 0x5e42015603c2cf1a184c7bdb,
                    limb2: 0x8ab02685472a4433,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x20a01cfce8a5bce328cd8cb6,
                        limb1: 0x611f3fb42b516f17cb0584f8,
                        limb2: 0x763b2c950e4c198e,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x462d15939fcd221751c6ac8b,
                        limb1: 0x946592683858eab6a9652826,
                        limb2: 0xa1544fca41ad8c11,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x31f0a0eca245552ecd7315f8,
                        limb1: 0xf2429ee89609dddcb454a01b,
                        limb2: 0x2c1624c1c090dd7d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc709d17953074ae5eadde9bc,
                        limb1: 0xeb446dc59a11fc094796dd40,
                        limb2: 0x47408b85eea80d47,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xb491b2471055bcbdd1dbef77,
                        limb1: 0xb90603fde64b1a2ce0b61eca,
                        limb2: 0xb4aaae5c76b88642,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3eba2b268c80681c5c311e90,
                        limb1: 0xf11a024b8e0531687340bd0b,
                        limb2: 0xc1b2df975bb5b863,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2eaecbac827c9f309771dbcd,
                        limb1: 0x4f246630ea9180999a632579,
                        limb2: 0x39f4d03f54586bae,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4180fbf542589c18eb2d7044,
                        limb1: 0xced4c189fdc0356f499c8870,
                        limb2: 0x7b2973b1222292cb,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x875809d83e33cb3b603309aa,
                        limb1: 0x6ad6d4a704b31d0441fad306,
                        limb2: 0xe478235415e659d5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc29722eb23a6c51f15c5b6b7,
                        limb1: 0xcaad40fc21df62667f2f7c9f,
                        limb2: 0x283d3160bb315f86,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4524bfca28d2a6c6ba96c39,
                        limb1: 0xa35f0c26665675ff32ee3a9c,
                        limb2: 0x92cb938207ec8ab2,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x151c89d4b8f7c9e45b67a274,
                        limb1: 0x5a281d2133f588c400ee55b1,
                        limb2: 0x53876cce8038fdba,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7ac4deddb182928226db63f1,
                        limb1: 0xb766e28c02e373347c52e9b0,
                        limb2: 0x4a7ea9b2ab26031a,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xeffbdff172582934bd039b85,
                        limb1: 0xf2a1bf14c0db73a24fad78a,
                        limb2: 0xf0aac4873f0babd3,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xb7172e0dd782d8cb8557e905,
                        limb1: 0x97b61010e22459db26c52b4e,
                        limb2: 0x4be41d2381f80abb,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x46c791b791685a55241d066c,
                        limb1: 0x29fecb5669fa843338b60650,
                        limb2: 0x95b1b1bb4e6af1c4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x7f1895fbe0c20170401a1097,
                        limb1: 0x60d74ec3d68c9037e3fdd9dc,
                        limb2: 0x12ccd83465aa89d5,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3eba2b268c80681c5c311e97,
                        limb1: 0xf11a024b8e0531687340bd0b,
                        limb2: 0xc1b2df975bb5b863,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2eaecbac827c9f309771dbcd,
                        limb1: 0x4f246630ea9180999a632579,
                        limb2: 0x39f4d03f54586bae,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4180fbf542589c18eb2d7044,
                        limb1: 0xced4c189fdc0356f499c8870,
                        limb2: 0x7b2973b1222292cb,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x2c77bb8f219c4f86d830378a,
                limb1: 0x7762e343071b3889761f79fb,
                limb2: 0x96e3952b500641,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x9d1cd65376303ffbede41478,
                    limb1: 0xc58c82a3af69a89f7f34d76,
                    limb2: 0x4446aa183d69a768,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0xfdfdc509f368ba4395773d3a,
                    limb1: 0x8de2b60b577a13d0f83b578e,
                    limb2: 0xc2dd970269530ba2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x589fa250d638e35400c12ddf,
                    limb1: 0xb3aac19fcb5095808402aa7f,
                    limb2: 0xed6de6590d0195d1,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xe443df789558867f5ba91faf7a024204, high: 0x23a7711a8133287637ebdcd9e87a1613,
            },
            u256 {
                low: 0x1846d424c17c627923c6612f48268673, high: 0xfcbd04c340212ef7cca5a5a19e4d6e3c,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 2,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0x55909ba28af82ea934a4b85d,
                    limb1: 0x4bf448ca5d57fb119c843e0a,
                    limb2: 0x6a2275491b991ee3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x5bf4bf0cefc9553422e60eb0,
                    limb1: 0x178d55925d3d72f44783f626,
                    limb2: 0xe13a21d7302f8139,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_1P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x1e98736cf961394cfa6dfe5e,
                limb1: 0xd7fb6593bc4d484738ba5ff9,
                limb2: 0x3133b3e2100f63a6,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x785094dfbbba459c666beaef,
                    limb1: 0x55c307610d1a86f697251ba6,
                    limb2: 0x3a9bf57c2d1f3f50,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_2P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x732ddc8e2cc76b36024c51f4,
                limb1: 0xc4691da0ba50feaacb01549d,
                limb2: 0x3b4ce309a9762fe,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xeb61555ff2e8eab1c46d48bd,
                    limb1: 0x470b0eae7200060f8562df1c,
                    limb2: 0x1e45be405dcbf244,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0xf4bfa5b3cc5f0d550830ebba,
                    limb1: 0x60db6b1216fe71b94bfc06f8,
                    limb2: 0x253e2357d973bcd8,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7238f02b9f20e09c2181a557,
                    limb1: 0x2cedcc5b0be371c337fd7e9e,
                    limb2: 0x41f3bbeb280fe8a2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf046f8cd6e5a75fca71dd19b,
                    limb1: 0x892b4613ef5c58df4ef692a4,
                    limb2: 0x7527fa36f5738847,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x4b3e865e6f4590b9a164106cf6a659e,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_ED25519_3P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x6889d75e36c152c1cc46f152,
                    limb1: 0xab6c91609cc41b1c6148652e,
                    limb2: 0x6d04cda48b959e7b,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xd12689aa4a75942f20369ac5,
                    limb1: 0x5d6ae4c0a9977c4e19538008,
                    limb2: 0x101fd900dd268a39,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x4cf7cf1e83ac6ddeb4c0d88,
                    limb1: 0xdf032c7d359dec2b1b30b922,
                    limb2: 0x1b4e7ef7358304ab,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x90887d2f101702d94aa5377f,
                    limb1: 0x3fdfadebd967a872d02af758,
                    limb2: 0x2ea0b09931ec6dc4,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0x506c121a6c7fd9aa60e121a3,
                    limb1: 0x23b636b641b29ef8bdd1c639,
                    limb2: 0x791b6ec60b5f8598,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x59f9c615c1fecf831ca3b5fc,
                    limb1: 0x2f6fb1f6358caa9cb6f8c9f7,
                    limb2: 0x6e62064b941a23df,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0xe69974737b88f1268fe9aaae,
                        limb1: 0x8c1559e40bcf30fa0bd7903c,
                        limb2: 0x4b532cae5bfa2c57,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfa9035e798d15baf399b3b7d,
                        limb1: 0x8e289acf0c43e298455b089c,
                        limb2: 0x5e626a1eb94c848c,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x654e97c8202baacafd347411,
                        limb1: 0xbbc95eee2c80600c3e370615,
                        limb2: 0x125df9e9282cba82,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x183a985c65551f6ba3d83980,
                        limb1: 0x134ad9dbc6c8c9ef9842342a,
                        limb2: 0x3a6b860a6754781f,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xe1dd890ca42bb6787953ac8e,
                        limb1: 0xd1043346a7687fcd1c173684,
                        limb2: 0x25ac41ef53a8b264,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x1a927f53bc1929ea47a340ce,
                        limb1: 0x1d066482260ad25a944af22a,
                        limb2: 0x5099f019034be8fe,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xdd8253ada22de2f45fdf5202,
                        limb1: 0x5441006694aef1a85b444399,
                        limb2: 0x235d0862dfa6cdf4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbf55f655e635b433fffa06df,
                        limb1: 0x9529a92891026d5feaca56b6,
                        limb2: 0x66f328ef9578380b,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0xff4a7e8b7f2cfcdbcee5a4b1,
                        limb1: 0xe12c1714e746fb90fbaacda2,
                        limb2: 0x74e32598c1f69b37,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xec4097839b45ff546026a0c2,
                        limb1: 0xae7581a88eae4a5053b8f9dc,
                        limb2: 0x39c19c5066a7bb2b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xe66b928f5f906da6b564a19,
                        limb1: 0xe6eb535ca7ed037f82d2c152,
                        limb2: 0x71e49573bad6c71d,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3c366ce7ca838787367666b9,
                        limb1: 0xe4fe0f13556bcdf6e6ed8414,
                        limb2: 0x7242e8cce5ff3b6f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc199caa040b67c0c31530366,
                        limb1: 0x862fb1b3977b470bdf71fa33,
                        limb2: 0x56f64010ec27341b,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0x5c9b04b3b245e09a4194094c,
                        limb1: 0xdd37f3697ab22b9010a7a63,
                        limb2: 0x5128c8fdc31f7a9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x823a7a3274ed4f8afd3da5ad,
                        limb1: 0x97bab3dd38c5e707cb7b2c8,
                        limb2: 0x5a9b9fb5a904e5b7,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x136a754b8e6ef4fbbdb2c19c,
                        limb1: 0xccb7829961063c89b98962cb,
                        limb2: 0x72b6443d8587b85b,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x4d61d2ba560cb6cdace82b43,
                        limb1: 0x4ec094a713c7dd9c57d2239e,
                        limb2: 0x6d86d878336d2975,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x64419bccfa5228f31d1d0868,
                        limb1: 0x3d89f6514c52a71529d25b3e,
                        limb2: 0x6282237340916256,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xea277ea54e9fc483589b6942,
                        limb1: 0x85d8e173f62a2f7ec6fcf9f6,
                        limb2: 0xabb53685608cda,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbf55f655e635b433fffa06df,
                        limb1: 0x9529a92891026d5feaca56b6,
                        limb2: 0x66f328ef9578380b,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x6fd4e3f593a17ba71159d847,
                limb1: 0x1118616a869823a48ad75add,
                limb2: 0x15473f9ff2346518,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x7238f02b9f20e09c2181a557,
                    limb1: 0x2cedcc5b0be371c337fd7e9e,
                    limb2: 0x41f3bbeb280fe8a2,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xf046f8cd6e5a75fca71dd19b,
                    limb1: 0x892b4613ef5c58df4ef692a4,
                    limb2: 0x7527fa36f5738847,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x82e4a33f8e4e5881e791d86b,
                    limb1: 0xbcb062435ae8ec5fdaeac4bf,
                    limb2: 0x179e1bae9e0f9f34,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x19657783ba5660e255c21849,
                    limb1: 0x7ed7474bcea7551fc71e46bc,
                    limb2: 0x596c0a76b75f4756,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0xa90f9c3af19922ad9b8a714e61a441c,
            },
            u256 {
                low: 0xeb2083e6ce164dba0ff18e0242af9fc3, high: 0x2fc154703983ca8ea7e9d498c778ea6,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 4,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xf7d884feff5aba51d9990dce,
                    limb1: 0x999f1d302046c6266257ff5,
                    limb2: 0x7f9caa5ee5815899,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x6d71279424538e87f8ecf2cc,
                    limb1: 0x8a8a1d74581da5996a52bbaf,
                    limb2: 0x29acff692eccea25,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_1P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xd1047f7150ec5100a6e49ee9,
                limb1: 0xc2e7d792c40dc5b460e86d57,
                limb2: 0x7b3f189f2f960a5,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0xac5aa8d6d49297a36aaf986f,
                    limb1: 0x7947b09c6620f2fdeb6c05b0,
                    limb2: 0x8f24f2607ad197e,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x7cca3f48d7a850ac077aa53a,
                    limb1: 0xfc0367c309acf4dcb9b6023c,
                    limb2: 0x1389ccb9283ad6bc,
                    limb3: 0x0,
                },
                u384 {
                    limb0: 0x9be267945cadfa270fe33fea,
                    limb1: 0x53629b1877e276ef9c05b645,
                    limb2: 0x5f3a5c7c506992f,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![u256 { low: 0x0, high: 0x0 }].span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_2P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            Q_high_shifted: G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0x5799d0a4be76c4179913ad19,
                limb1: 0x86201acbfee2c5bb1e120b24,
                limb2: 0x167b9aeffb401b8c,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![
                u384 {
                    limb0: 0x746895ac8d85fdcc78a517dc,
                    limb1: 0x439607b706d6b787a329afcc,
                    limb2: 0x122c8ade7aa1ea89,
                    limb3: 0x0,
                },
            ]
                .span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x86b402ce02e7c7ca81f13d51,
                    limb1: 0x39493672733a9289a36020c1,
                    limb2: 0x7f40d91dc5413d3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x371e7b6a5c01505bd4334e81,
                    limb1: 0x2f596ae4492a87c66f7bda1a,
                    limb2: 0x9dffb4dcdb94df9,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0xb4862b21fb97d43588561712e8e5216a, high: 0x967d0cae6f4590b9a164106cf6a659e,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_msm_GRUMPKIN_3P_edge_case() {
        let scalars_digits_decompositions = Option::None;
        let msm_hint = MSMHint {
            Q_low: G1Point {
                x: u384 {
                    limb0: 0x37c9a46b0612fc1b353fe24a,
                    limb1: 0xeb374db12bd7d7711f2705b4,
                    limb2: 0x253453fe507b50b6,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x33cd021aeba5ea18a2e20a56,
                    limb1: 0x3e392b55f320a528391fcef8,
                    limb2: 0x14fbdf9fd7fbfcdd,
                    limb3: 0x0,
                },
            },
            Q_high: G1Point {
                x: u384 {
                    limb0: 0x60e6980f95d8e5261423f38e,
                    limb1: 0x3079cdd992636bb28a5984df,
                    limb2: 0x14368ee41c0e5576,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa3597535ddd5b8336fde7418,
                    limb1: 0xc0329958cee690ca2b691fb,
                    limb2: 0x2a11389e1b5a9b57,
                    limb3: 0x0,
                },
            },
            Q_high_shifted: G1Point {
                x: u384 {
                    limb0: 0xc294148f233ee2e2eb301899,
                    limb1: 0xe1d7d7726b8c2ea638d0879e,
                    limb2: 0x1599a751984c9cbc,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xfb70f5613f53701f0d60d44f,
                    limb1: 0x1bc69554d8e00e30700a9bad,
                    limb2: 0x1e3d7a04c2e60b68,
                    limb3: 0x0,
                },
            },
            RLCSumDlogDiv: FunctionFelt {
                a_num: array![
                    u384 {
                        limb0: 0x8d1ac407b0b68a1dab34b0ea,
                        limb1: 0x28583648ea41a8369d9266ea,
                        limb2: 0x5bd7a61cafde77f,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x2e2d64b34628cd5121e61d8b,
                        limb1: 0x3c9160edd20418993dc03a9c,
                        limb2: 0x14935bf5b97aaf31,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6d828690264f9647a8a849f1,
                        limb1: 0xaa4db7f1d471f2660eea1a53,
                        limb2: 0xdf52f48a4714b89,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x22b173b10b3e7c4fac032098,
                        limb1: 0x4f28a503f922c55da227f373,
                        limb2: 0x4654b1125198233,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                a_den: array![
                    u384 {
                        limb0: 0xb2266081a22d892a905aac07,
                        limb1: 0xe29e40ff84bf386a075c2912,
                        limb2: 0x2bdae940ecd05238,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbc07a73baca9200621b30a,
                        limb1: 0x9feb152fd5380add8bfeb65d,
                        limb2: 0x27611e103ee6cd84,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc58abb3148d1b699a1cd566b,
                        limb1: 0x427ed6a0de410a4bb7ae367a,
                        limb2: 0x1710b0370e12ff29,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x77c7f1279f442e1fefa35cbe,
                        limb1: 0x39ad28fd9578c20b1b049f7b,
                        limb2: 0x80860ed167627c,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_num: array![
                    u384 {
                        limb0: 0x36d43362167f95a6c7ab3efb,
                        limb1: 0xf1b335d8f724e2f00d074209,
                        limb2: 0x4210b05774c00d8,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xfcfb832a114ffcbb88fd9872,
                        limb1: 0x14d78d0b3eb673c7a7bcc78a,
                        limb2: 0x272e013c16236c86,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x3e4ab9a1f92275723f292c08,
                        limb1: 0x750afa16be5a64b2272b368,
                        limb2: 0x2bb352e1f4120313,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xcabd610b2776514a16c4ca00,
                        limb1: 0xe2528b2f5dd72dcf9738f4f0,
                        limb2: 0x2ca5cb95ab68ee73,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x6ead72438d38a9b6bbb87e01,
                        limb1: 0x65951ccceba1f98566e26518,
                        limb2: 0x2a904cec00cee003,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
                b_den: array![
                    u384 {
                        limb0: 0xc70aa07879193d6b69fa9399,
                        limb1: 0x78820a704762c6c8061fca49,
                        limb2: 0x1cbb69de59448cd4,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x9ba7a5d6bfe432f6b7c31c64,
                        limb1: 0x75c767cdec5a1c61e6ec97c9,
                        limb2: 0x8094b3423631c79,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x294e86d58d0481ffb15d42ee,
                        limb1: 0x106632bbcb3a6c3f37418c65,
                        limb2: 0x2b6b0e61fb7bafba,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbddf5ce00ea6790ba6818369,
                        limb1: 0xe1e882897ba55ad3c0d91df,
                        limb2: 0x2352024504f2c7f9,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xbc07a73baca9200621b2f9,
                        limb1: 0x9feb152fd5380add8bfeb65d,
                        limb2: 0x27611e103ee6cd84,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0xc58abb3148d1b699a1cd566b,
                        limb1: 0x427ed6a0de410a4bb7ae367a,
                        limb2: 0x1710b0370e12ff29,
                        limb3: 0x0,
                    },
                    u384 {
                        limb0: 0x77c7f1279f442e1fefa35cbe,
                        limb1: 0x39ad28fd9578c20b1b049f7b,
                        limb2: 0x80860ed167627c,
                        limb3: 0x0,
                    },
                    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                ]
                    .span(),
            },
        };
        let derive_point_from_x_hint = DerivePointFromXHint {
            y_last_attempt: u384 {
                limb0: 0xb4d724fe09e4d0654dff3b97,
                limb1: 0x5a5d54ab4d5e104be31a68a5,
                limb2: 0x227e7025667ec33,
                limb3: 0x0,
            },
            g_rhs_sqrt: array![].span(),
        };
        let points = array![
            G1Point {
                x: u384 {
                    limb0: 0x86b402ce02e7c7ca81f13d51,
                    limb1: 0x39493672733a9289a36020c1,
                    limb2: 0x7f40d91dc5413d3,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x371e7b6a5c01505bd4334e81,
                    limb1: 0x2f596ae4492a87c66f7bda1a,
                    limb2: 0x9dffb4dcdb94df9,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 {
                    limb0: 0x20669ef12954f8e3bbc8b4d3,
                    limb1: 0x396a6f7243c27ce553121ee3,
                    limb2: 0x11438ca2ec259aed,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0xa560a5759c90985fde99aca0,
                    limb1: 0xc5b21186cc6dcd0421026513,
                    limb2: 0x21fb1f47c6ac55b3,
                    limb3: 0x0,
                },
            },
            G1Point {
                x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        ]
            .span();
        let scalars = array![
            u256 { low: 0x0, high: 0x0 },
            u256 {
                low: 0x12e0c8b2bad640fb19488dec4f65d4d9, high: 0x1521f387af19922ad9b8a714e61a441c,
            },
            u256 {
                low: 0x5a92118719c78df48f4ff31e78de5857, high: 0x28fcb26f9c6316b950f244556f25e2a2,
            },
        ]
            .span();

        let res = msm_g1(
            scalars_digits_decompositions, msm_hint, derive_point_from_x_hint, points, scalars, 5,
        );
        assert!(
            res == G1Point {
                x: u384 {
                    limb0: 0xf47b4ee8eecf8576c38173d8,
                    limb1: 0x755d90a26c30d7d6fb33afd3,
                    limb2: 0x5e835e05fdb55c5,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x990d5f4767a8d057f8695e4e,
                    limb1: 0x5f8dd4e272c268c0d2ce4a39,
                    limb2: 0x1704905427d31a82,
                    limb3: 0x0,
                },
            },
        );
    }
}
