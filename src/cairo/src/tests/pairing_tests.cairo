#[cfg(test)]
mod pairing_tests {
    use garaga::pairing::{
        G1G2Pair, G1Point, G2Point, E12D, MillerLoopResultScalingFactor,
        multi_pairing_check_bn254_2_pairs, multi_pairing_check_bls12_381_2_pairs, u384,
        E12DMulQuotient
    };

    #[test]
    fn BN254_mpcheck_2P() {
        let pair0: G1G2Pair = G1G2Pair {
            p: G1Point {
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
            q: G2Point {
                x0: u384 {
                    limb0: 0xa30b422f34656d6c94e40be,
                    limb1: 0x83069b5050fd7194c7e35d0c,
                    limb2: 0xf0e8184945e8d34,
                    limb3: 0x0
                },
                x1: u384 {
                    limb0: 0xde9079ee8fa5e15901dfef27,
                    limb1: 0xdb602cf367841e5047ffab14,
                    limb2: 0x1752c7b6b35af45,
                    limb3: 0x0
                },
                y0: u384 {
                    limb0: 0x4dafbd7f615fd2aa9f5a0acc,
                    limb1: 0x35c8bbffe201ffd56deb5dea,
                    limb2: 0xa822a5ba029a283,
                    limb3: 0x0
                },
                y1: u384 {
                    limb0: 0xec6d9e4fafec17b8404c0341,
                    limb1: 0x17fe961ad4b8ee3bf2ade626,
                    limb2: 0x1228147f83e3ea5,
                    limb3: 0x0
                }
            }
        };
        let pair1: G1G2Pair = G1G2Pair {
            p: G1Point {
                x: u384 {
                    limb0: 0x5c724369afbc772d02aed58e,
                    limb1: 0x2cd3bc838c66439a3d6160b,
                    limb2: 0x72f26b55fb56be1,
                    limb3: 0x0
                },
                y: u384 {
                    limb0: 0xf14522f0e41279fa3733fed2,
                    limb1: 0xea20efd268b756a9c0b06945,
                    limb2: 0x7df9c9692acbd19,
                    limb3: 0x0
                }
            },
            q: G2Point {
                x0: u384 {
                    limb0: 0xa30b422f34656d6c94e40be,
                    limb1: 0x83069b5050fd7194c7e35d0c,
                    limb2: 0xf0e8184945e8d34,
                    limb3: 0x0
                },
                x1: u384 {
                    limb0: 0xde9079ee8fa5e15901dfef27,
                    limb1: 0xdb602cf367841e5047ffab14,
                    limb2: 0x1752c7b6b35af45,
                    limb3: 0x0
                },
                y0: u384 {
                    limb0: 0x4dafbd7f615fd2aa9f5a0acc,
                    limb1: 0x35c8bbffe201ffd56deb5dea,
                    limb2: 0xa822a5ba029a283,
                    limb3: 0x0
                },
                y1: u384 {
                    limb0: 0xec6d9e4fafec17b8404c0341,
                    limb1: 0x17fe961ad4b8ee3bf2ade626,
                    limb2: 0x1228147f83e3ea5,
                    limb3: 0x0
                }
            }
        };
        let lambda_root = E12D {
            w0: u384 {
                limb0: 0x7b012eeba411e7545c404bbe,
                limb1: 0xa754caf0589c24909e590228,
                limb2: 0x13d296c9e213feb6,
                limb3: 0x0
            },
            w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w2: u384 {
                limb0: 0xf922eeaae57369160eed3935,
                limb1: 0x3f2dc8035f4fcb812493ecf5,
                limb2: 0x2592f4cb693ff488,
                limb3: 0x0
            },
            w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w4: u384 {
                limb0: 0xaaa473d1dfe6dc52d8739f32,
                limb1: 0xb2943e6803563bd7a19c3e52,
                limb2: 0x1ef946e5c253a585,
                limb3: 0x0
            },
            w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w6: u384 {
                limb0: 0x22154af4f7326b5f6c5c441d,
                limb1: 0x13dcedb3932e6170da976a55,
                limb2: 0x10788fdd560077ba,
                limb3: 0x0
            },
            w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w8: u384 {
                limb0: 0xddcab5a98707253769c5f208,
                limb1: 0xd4c4e5476c43a742cdb6a8d9,
                limb2: 0x1214863b5a385761,
                limb3: 0x0
            },
            w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w10: u384 {
                limb0: 0x466cc661c364df53da613fd3,
                limb1: 0x220477644169a23e4da44be,
                limb2: 0x2d834f48c82ae9c3,
                limb3: 0x0
            },
            w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        };
        let lambda_root_inverse = E12D {
            w0: u384 {
                limb0: 0xe1f18dc463f422b115091e4e,
                limb1: 0x9e002a8978058f9e7a63f300,
                limb2: 0x228c0387c56429e2,
                limb3: 0x0
            },
            w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w2: u384 {
                limb0: 0xbcf34ef6b05b42018a8e4244,
                limb1: 0x2b5379dda123d70585dfe1d3,
                limb2: 0x4c1c380be5a7918,
                limb3: 0x0
            },
            w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w4: u384 {
                limb0: 0x60b5d0e527d9fe47f237c679,
                limb1: 0xfe2f8ac89fa4d2940d5a4751,
                limb2: 0x1596985fc21a9bc0,
                limb3: 0x0
            },
            w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w6: u384 {
                limb0: 0xcf1b962ea7f8d0d64ef46698,
                limb1: 0x8b92e9881848e8ce17e27b94,
                limb2: 0x2f89e304609a097e,
                limb3: 0x0
            },
            w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w8: u384 {
                limb0: 0xfa540d084ab4f7ed9aa82621,
                limb1: 0xbba5da375416c55a9f3074d3,
                limb2: 0x1dd999f8df8a24b7,
                limb3: 0x0
            },
            w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w10: u384 {
                limb0: 0xe3c99364c56a5ade4584af1a,
                limb1: 0x9feab9c263b0ff02f3b07928,
                limb2: 0x12fc2d7015dfb5e,
                limb3: 0x0
            },
            w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        };
        let w: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w2: u384 {
                limb0: 0xc2778d80388a54eae80e565b,
                limb1: 0xf25dc130d86b34cb0fbe750e,
                limb2: 0x2d47bdc1ad79a2d8,
                limb3: 0x0
            },
            w4: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w6: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w8: u384 {
                limb0: 0xa228aa43fdb7f215226ece12,
                limb1: 0x22463bd8b6519b59af036109,
                limb2: 0x10bd041a04b54229,
                limb3: 0x0
            },
            w10: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        };
        let Ris: Array<E12D> = array![
            E12D {
                w0: u384 {
                    limb0: 0xd556ad868e1c8a23018de366,
                    limb1: 0xf6dd7eb3a4ca3a1e7ef76eee,
                    limb2: 0x10e7de936a1df313,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xe7ca2e7173a67b8cb964f987,
                    limb1: 0x6bba2dc3b0895b39ac88180d,
                    limb2: 0x16af72cdbb761501,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x63c29ac15aefde57ee30edba,
                    limb1: 0x8d94e1db488db17b83adcd5e,
                    limb2: 0x1c2577ff6a784372,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x896aab8d1dd49764e3ff579e,
                    limb1: 0x2e9f8b1d93bc3b4bfb95244e,
                    limb2: 0x263785964f541a4,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x62c45e6c7376294e8f8debf1,
                    limb1: 0x83f823a2b1f4e0ee3deabf72,
                    limb2: 0x257fb4016329f43a,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x5749cc0e075399a582f69903,
                    limb1: 0x2d72d91c384593d887898b98,
                    limb2: 0x65c188e9bc00fa5,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x5089c3d2e45db42368e1ce48,
                    limb1: 0xca45ed5e074dd5414bcb8b97,
                    limb2: 0x7bc6435b16e58e5,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x232990bad722d9db55141074,
                    limb1: 0x6b285822ae913cc01bf48292,
                    limb2: 0xd5e51d681fbef1d,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xfdb731f822af5dd59f0f25dc,
                    limb1: 0x9b6f3d408e0d9d5a48776040,
                    limb2: 0x21153a518ba7f11d,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x18339d7a32feff4a429fa252,
                    limb1: 0xf1cba1fbd807474aa0757188,
                    limb2: 0xc9044ede7dc2972,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xe36e7364dcd19cce82abe496,
                    limb1: 0xee027e6e9ce61240b9e3fb9f,
                    limb2: 0x2aeaa027c88b1f27,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xb857fcbab3e82c5a0f3c755f,
                    limb1: 0x1a1fcf78b01830fa0ee88d4b,
                    limb2: 0x2a8546a248dc800f,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x3cb6bc6f3cfee4c3f9783146,
                    limb1: 0x965d67a3d9d01d461511292c,
                    limb2: 0xf0d40a38ddcaab3,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x30d556ac1d5b1fc7647350e,
                    limb1: 0x1b515c801676f189844c5a74,
                    limb2: 0x17d295b15f7f8c1a,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x1e1f95f6d0afbe119d2269b6,
                    limb1: 0xc6913a3dd6312566c011cc6d,
                    limb2: 0x2c33d0bc81ae8312,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x7de228c64d05d857cdb31343,
                    limb1: 0x20dc680dafc7737469a945d0,
                    limb2: 0x2a98ae5b5b2fd3fc,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xcff868bf68c8a6d94ab52c49,
                    limb1: 0x59db1ba8e5f7e7236dd3f63e,
                    limb2: 0x1510aa992cc556db,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xcdf246cd412112f7027aa07d,
                    limb1: 0xd8f32bba1d6b187f67c4eebe,
                    limb2: 0x18f26eb941739472,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x7fb3b84ef775a993bfdd09f0,
                    limb1: 0xcd0c7111312c941393548e7b,
                    limb2: 0x1cf06f00842440c1,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x7fb0ee39fd9c4724c737182e,
                    limb1: 0xc5d096de8d49a10b763109be,
                    limb2: 0x2be8e578c6670b0b,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x7ac775d7c637e32c92393ae,
                    limb1: 0xfcc730760f8f872fdf4f371d,
                    limb2: 0x284de99ad0be6309,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x58b92d2ecd2a2d5029a33fb8,
                    limb1: 0x9dac67372abb2dda66572884,
                    limb2: 0xf8233797514202a,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xd9f2d3cd53c621258cec66e1,
                    limb1: 0x36a6f4b16abf4fe10aa7183a,
                    limb2: 0x2c7eb01da97edadc,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xa3e3bf89dd0695b9b10a2c82,
                    limb1: 0xb8eef1f3e0e4aa86a2bb0889,
                    limb2: 0x2159164cf99a18e2,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x1cc952350e673d4f5b07716d,
                    limb1: 0xb2c57e08af807a7afea0e93b,
                    limb2: 0x1460a8f6e75d1f23,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x8994b58c42d391cf8b150719,
                    limb1: 0x58e1076265c31e0e46d977cc,
                    limb2: 0x264c02bbd313eff8,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xd1eafbfe3881f1a433c0b655,
                    limb1: 0x2b15b10246ddb5f3116a9f51,
                    limb2: 0x2c46dc7d501f761,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x4af42684ea84d31c0a940891,
                    limb1: 0x6d2ece721e83bd932aee1141,
                    limb2: 0x21958ab4a2074aca,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x88917ef208e05825cc9f2129,
                    limb1: 0x9055ddf9b8d868e3bf91da8c,
                    limb2: 0x8627546b7fb3cdf,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x3857ea0a05fc673e22eb08c1,
                    limb1: 0x484183c8c8324c17f765a426,
                    limb2: 0x2fea348db4145319,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xe8c31c46a133375b97510904,
                    limb1: 0xfaef300d6e976c0dbe6ecdbc,
                    limb2: 0x2e1ef14a067cca94,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x6a36d41e67245dcdefaceac5,
                    limb1: 0xd9bf09aad345166d484d4be,
                    limb2: 0x3f1247ac5e369ef,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x4eb5ee737aad432fe0a11a7e,
                    limb1: 0xda0a6862efb37debbfbcf68e,
                    limb2: 0x2488d805d2eb6f6c,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x8ca7ac13d4e448946d421e84,
                    limb1: 0x9df1e0125c036e67d2af9446,
                    limb2: 0x16e4239f0fc3bbd9,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x697da60ee61ed371ce5f0ead,
                    limb1: 0xf5aaa4efb8db17c041528e85,
                    limb2: 0x27f1442457994913,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x1705b340d23bd624fe855a7e,
                    limb1: 0x407ed945576a63657055b03d,
                    limb2: 0x22536525ba3d6db3,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xdb0dff27a490b25f5ba188d2,
                    limb1: 0x82a6a8f80908da6c42a92775,
                    limb2: 0x2561973eaa8ac016,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xe21e8711780aa1a58f5660c8,
                    limb1: 0x6007401570a38734b27c188f,
                    limb2: 0x2cd70ad8aa59de6d,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x37f180baee038e71d5d068a7,
                    limb1: 0x28529b3d13c1fddb0d07f6d4,
                    limb2: 0x1f4e9112a0d14873,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xe94fba629c424c99531a2508,
                    limb1: 0x26e077d71fe414db02571457,
                    limb2: 0x1f9e1f02d377827b,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x3fe1fbd087f921b9b45039c5,
                    limb1: 0x399576ff097634bef3a36087,
                    limb2: 0x218a5ecfd22ce30f,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x26d1188f4a1550af9110366c,
                    limb1: 0xaf8d50ff033f911449e10c52,
                    limb2: 0x1c5b4fa0905edd26,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x8f764ee0359c3a5186a8c6cd,
                    limb1: 0xfbd2f1c239037ca59726e45c,
                    limb2: 0x2d135aefbb7cf95a,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xf00b6fdcba502a90c3a0a9de,
                    limb1: 0xf60d2711e18905115fddff45,
                    limb2: 0x1a728af3133558c7,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x8a27ebecb537b83d34dfe0b5,
                    limb1: 0x75bf91e9f74a220d5da637f7,
                    limb2: 0x103aae86fd6c6b74,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xb0a3b0fb7444a1dfac7508f6,
                    limb1: 0xf2b9cc21dbb934b8a5a47a2d,
                    limb2: 0x1a8993891c93608,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xad86ff4f85e25347f133726f,
                    limb1: 0x7cf0df3d94fd0e593d91658a,
                    limb2: 0x1939650f4d3b1eea,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x52ffb3d98e2ab4ce00ada4c3,
                    limb1: 0x77bdfe82c9681151a9b923af,
                    limb2: 0x21854b6696bb976d,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xf62fc0257122a7dc48587b9d,
                    limb1: 0x4a1c4b86e044f326d837627d,
                    limb2: 0x18af117b15727a5,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xd784d65416f0ee51680db29f,
                    limb1: 0x2f3ab4af9c0b536663aff09c,
                    limb2: 0x2fd4e2f6eba629f7,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x67d46e23b0766e94fc6b79c1,
                    limb1: 0x312d526fd720ab405b1cf4b1,
                    limb2: 0x1ce4c55a7a848b84,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x26aeb18757f0444375c646c6,
                    limb1: 0xbbfa2641667bf969b10fea38,
                    limb2: 0x4d36fdab7f2e723,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xf468fffb4bf05747a4685533,
                    limb1: 0xd4fd8a6300e2ee087f502129,
                    limb2: 0xda942784b2b3411,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xa0ae06e13fe1d9e864afc0d8,
                    limb1: 0x45ddd46752f01e5812b489de,
                    limb2: 0x2699829223ccb332,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x35a1559510e8184d01bd0100,
                    limb1: 0xe5e2879f17737565c76c5a6b,
                    limb2: 0x61d0d3e76fc4d36,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x9471d1241364d18039236d5e,
                    limb1: 0xec97a822c0fcfadb703e8e49,
                    limb2: 0x2f68c9d741cb94ec,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x26241c10b91ac4b0b0f380ca,
                    limb1: 0x4949bbb6f44de961a0400bae,
                    limb2: 0x1ad84a67489fef40,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x6de0655e02e9772a3cc4b1d5,
                    limb1: 0x2d4a1c0b7d84fbfa47d17713,
                    limb2: 0x24004cd388efd0ce,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x950e9f56a52acec9bd874e6,
                    limb1: 0x22dce48c65e6d60cb936c649,
                    limb2: 0x14eda08ecdf2485c,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x260fb35a218342854cddd939,
                    limb1: 0x45f4d18c9e5641cb3ad28906,
                    limb2: 0x2cbb791cc2ed801,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xd8609ca08440423a114cd709,
                    limb1: 0x9a632a2a5822b9c25939be31,
                    limb2: 0x26796262628d0d,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x65940bd03967422e48a8d8a1,
                    limb1: 0x60f83884d54510cac4a41d03,
                    limb2: 0x14a6ffc8a061b77e,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xa4ccc9201a608df6fd643a27,
                    limb1: 0xea1f3f0fdc27fdb1086931f4,
                    limb2: 0x25e1bbb8efc5dca3,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x73ff56f57e7347e436f2437,
                    limb1: 0x997fee62ced65bfbabc12e5e,
                    limb2: 0x7806f89b50ffb20,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xf41334652b17006913469143,
                    limb1: 0xe3c1eee4f53d343aafa46ed3,
                    limb2: 0xbd658465f365011,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xb01354cb2a2f4bd7bd93d2bd,
                    limb1: 0xdb01cfd8e64f43f1ddebd7cb,
                    limb2: 0x67bd996f7a56a37,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x4b7324c1790c6d5f848348a5,
                    limb1: 0x6f215c39415887a56a992dc2,
                    limb2: 0x5da307e002d7b26,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x9bcbb5e6233ab54a1f000413,
                    limb1: 0xefc6e06a1ec1571fddb815bd,
                    limb2: 0x3a49e3f48fbae74,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xcbf2c378218f1ede6348ec79,
                    limb1: 0x35beb269461b45068a34797f,
                    limb2: 0x1c9b5c509173c12,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x8009db06fa42905e150b2d40,
                    limb1: 0x19282f75659d699ba25fcd42,
                    limb2: 0x5387002838b50e9,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xd0032bfee5723ee8cd9d354f,
                    limb1: 0xdd68b41d3214c94446d74abe,
                    limb2: 0x2889571dc171fbdf,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xa07e2a3a679e81cd25992b3d,
                    limb1: 0xbb76f3c8cb494bad34efb94b,
                    limb2: 0x63f4e3dc8a918b1,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xebab60132df4639027ad194,
                    limb1: 0x9f6f488a1f500be4b46185a,
                    limb2: 0x93153304560a944,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x1f1cd248cd544837a743496b,
                    limb1: 0x6a18f1aaf75b9afb71e1e5dc,
                    limb2: 0x31caf6b134fde47,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x4b862bcc5178de6fa48d5181,
                    limb1: 0x83e8f06829daaf24516b808a,
                    limb2: 0x90979a4c9deb55e,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x34e8210ff636aa3c9c87c309,
                    limb1: 0x7b44fe9c6020fd0f79ff9173,
                    limb2: 0x2cbe80da0e3a3364,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x4ecee46025505db86f24d260,
                    limb1: 0xbec48d3446a0cc4a40e623ab,
                    limb2: 0x1529208642bd7479,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x921146512b39e844be5b7767,
                    limb1: 0xf1423d88468d05db0e171ebe,
                    limb2: 0x13294bf5892dbecf,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x3f3491d9150013bcb4954f7e,
                    limb1: 0x6b0979ab4dcdff0164f6e4e0,
                    limb2: 0x2f81ed821040c0d6,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xe092f16abadd9d3ac0eadb48,
                    limb1: 0x26404c221ddbfaf6c344113d,
                    limb2: 0x1d05e6add4fb7a2c,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x4520218ab8caa7a2f8c28fac,
                    limb1: 0x74aaab7926d2b9a9096d0fc3,
                    limb2: 0x3bc78042de9c03e,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x44454c5f5921ad1049aa4eaa,
                    limb1: 0xa52bd87c00665fbef097896b,
                    limb2: 0x1532662ead6d360,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xb01393a557637be22634eb90,
                    limb1: 0xb09bda44164422789dc23bc6,
                    limb2: 0x1fcce3d51bdbd54b,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x3f18da9d670a1cbb8a8e1855,
                    limb1: 0x6ff9f6cae50627c0008785e9,
                    limb2: 0xbbcb0cdcec1710e,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x873ca315e7e265cfd2c0d3e2,
                    limb1: 0xa99264b093e15a4378a0b9d8,
                    limb2: 0x2cb36d45eca0dc0b,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xbb76c24572f30a68f5ea9c6c,
                    limb1: 0xc8fed4f0ab5fd143309e0080,
                    limb2: 0x22821bda6435737c,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xc2b074749618d81b1ac1c3af,
                    limb1: 0x1a51c829a385ad099a323d2a,
                    limb2: 0x2bc943880a2bca25,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x73123330ceef3f268fa77da8,
                    limb1: 0x376a78ff3b862b150573cf75,
                    limb2: 0x82f9dbdbed78ff9,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x57fe35296296f2f3a5f17c69,
                    limb1: 0xde63949e16491a752d9b9c6c,
                    limb2: 0x12d8356e64e86a67,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x308c50f3a182e41b261449db,
                    limb1: 0xe357f7962a9fb153bfa5fa23,
                    limb2: 0xde6532a20167c1a,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x3e25b363cdfe9ed5fc053a4b,
                    limb1: 0x5c6188d3dec283ba8ae75a20,
                    limb2: 0x2af6b81055b3277b,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x6747f641086cb55f839086ad,
                    limb1: 0x10db582e78919b1d63628acc,
                    limb2: 0x13c4ce4f2029e813,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x985d6f16b17a3b1d2b7cea6d,
                    limb1: 0xc12d6562fb264c741387e5e1,
                    limb2: 0x2dbcab8dc4ee8fe0,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x80d5f341d650c39aefe67f4d,
                    limb1: 0xd8c884126babb54d5d446c72,
                    limb2: 0x27f1a2498322b7ad,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xf6198a751b2306f816778135,
                    limb1: 0x1983b31858080679a35c0c81,
                    limb2: 0x10a1a9d01b48e276,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xcd82883803650af3cb46af1a,
                    limb1: 0xffb9f78c690d1decd972e1b0,
                    limb2: 0x15ffb9fb91e2403f,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x2a14eaffbbf1e559cfd67360,
                    limb1: 0x43482bd618631e75140b25eb,
                    limb2: 0x113450f35704c601,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xdd9991430f50e5a94be9b0c6,
                    limb1: 0x619793464a8691bf89c89db,
                    limb2: 0xf67b34659c381d9,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x1a765a3205588060bae41115,
                    limb1: 0x4aa510131b3d37017c1662b4,
                    limb2: 0xf5c077dc83b914c,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xd0e2db74250fba8710063aa5,
                    limb1: 0x77503757bbceffa2ffdf44e,
                    limb2: 0xc690f40ef4e65d8,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x987bd548f61ce1be69f2fec0,
                    limb1: 0xd9aa2e1c2f2a5bb53a7dfaec,
                    limb2: 0x7f7ef3cc977efc2,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xeb4d79849acac6d7697e790f,
                    limb1: 0x83a6535d9af49a0b864f242e,
                    limb2: 0x2bc946607cf60999,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x2a90cc91d12f6c273907f421,
                    limb1: 0x2c465a324511ed232e5d51b2,
                    limb2: 0x16bd7eaf65f176ea,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xa06fb0edc3e44b91d937801,
                    limb1: 0x7c8a88164fd922e273a788c6,
                    limb2: 0x7e5efa7983188b0,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xd58db58cb6b4283d7db7e358,
                    limb1: 0x680418df8586042fc32b7481,
                    limb2: 0x1aa4e36dfd4b5906,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x6fb27cd57cf1845bcfc4ae83,
                    limb1: 0xb8848dc440ac62c6a1102a2e,
                    limb2: 0x126acafb5b65dea6,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xeee8ab0d8dd406a65c7a3be6,
                    limb1: 0xfd237878cb1dee1e250cbbb4,
                    limb2: 0x7d5b76b431829e5,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x209de2169b35544d63222882,
                    limb1: 0x5498450d0fdac73ce92c237b,
                    limb2: 0x10fac08662c055c8,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xb641c839ac418a6de8310e2e,
                    limb1: 0x4be1304c700b09ddb3688d50,
                    limb2: 0x15e31f2d8bb8ff16,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x332f1b7d2ca5de0c82e3fcaf,
                    limb1: 0x9690513e02d7897d7cbfc59a,
                    limb2: 0x1cb52321efdaf38,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x5607794aac9e1d0266fbce97,
                    limb1: 0xc6b4dddaf0a55330bdc48a8d,
                    limb2: 0x154ee39cbb1b6e9b,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xa475fcc92f85c05db4903693,
                    limb1: 0xdb401fe458a3531b92ebbd32,
                    limb2: 0x1fe5c9b8f6b78b7d,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x58bd4581f4707efb14c63c71,
                    limb1: 0xb435094a4922fec344eb174b,
                    limb2: 0x282cf1747ebcad8b,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xc6a203816a560534cdf96a57,
                    limb1: 0xad2df53499b97eb3792ffdc0,
                    limb2: 0x12be096211eef440,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x61f05a3894ac940027210850,
                    limb1: 0xe0c4945a1e544d45045799c9,
                    limb2: 0x17c60c568afbf95f,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xef635c0b73e9144f605bfb01,
                    limb1: 0xedc60d902a0c964c62c06b3,
                    limb2: 0x2dbd647dbe27280f,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x54d7fea1239360b4e0a50f54,
                    limb1: 0x8d6ecf192e8a0b011cb43e3e,
                    limb2: 0x1e36f458e4c5d465,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xf336c90e0b1f7e569e68cb6c,
                    limb1: 0x8720fd8562d8a6e54435f534,
                    limb2: 0x1e7b85f6c293fed7,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x6a80463599dfeea6440d0e6c,
                    limb1: 0x62e1e1f0280f48b208e8bd68,
                    limb2: 0x17a7b1040292e282,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x1b37deb433d2db30c628d9bd,
                    limb1: 0xb7c00146b3eecbcd22093e,
                    limb2: 0x249ca14c7ce553b7,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xcca1918d9a7514083fc72984,
                    limb1: 0x90b55c800c4ad500376fd39c,
                    limb2: 0xf5f9241d69eabff,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xc4f3132c468923042ea455bc,
                    limb1: 0xe48c416f560fb53e8b502154,
                    limb2: 0x2613466f9a11ed46,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x3197655e53cd20626ec4772b,
                    limb1: 0x2bf012cc22e8ba15e231b3a5,
                    limb2: 0x211a2d76d389e0f6,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x3ed228b00a32e1e26d5f0662,
                    limb1: 0xd73d8b8735e2fed80397768d,
                    limb2: 0x2e4deb74cb98bf7e,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x68c2498698aeb3f6d27ee2f2,
                    limb1: 0x4c0bcec6e06306db0f3b6587,
                    limb2: 0x241a62a2a7ff3048,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xf0cc14ec1cb361c1e43748a3,
                    limb1: 0x7952ea053a736426aeda0020,
                    limb2: 0x1cb39fa7fe13b7aa,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xfde5feeb8faf8266deb76a17,
                    limb1: 0x64656a265b2b8160655c8014,
                    limb2: 0x112fd2ef96af86e2,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xd54150bf8923a2e44a03a376,
                    limb1: 0xd143605ff79b9c5f2d971842,
                    limb2: 0x22b824b36c288d6c,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xc97ee197894cbee5d1375e00,
                    limb1: 0xc5be2e570a45ca1d3e728695,
                    limb2: 0x5d49231781b17fc,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x723be75d8a5b6c6d7410fad7,
                    limb1: 0xabf51364a090acbbf5b2b9a2,
                    limb2: 0x25c6740bb79fc8ea,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x4d85e3c6a02f74022a99ac49,
                    limb1: 0x7e09c23c04638d6a265015,
                    limb2: 0x258e4b07476d88b9,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xb845af8851c7a8b5d6523950,
                    limb1: 0xb656d28488e151e723789bf4,
                    limb2: 0x2daba3811b77ddbc,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xd63f3d7cd80a77edb230c118,
                    limb1: 0xd4e7ac70ac8cfad57bd7425c,
                    limb2: 0x1be22fb23dbb78de,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xb1e65d0ff4ec1c73dc93ea72,
                    limb1: 0x357a2e1bb8f20a972afc9814,
                    limb2: 0x2ba904b0df948de7,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x9dbdabbf04b6426d6367b613,
                    limb1: 0xfe744bbe1121bdaeceb78999,
                    limb2: 0x177c2267c26e2db4,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x1f17b852672236df4eff0191,
                    limb1: 0x64f6151bf63b65b2bd13c5c5,
                    limb2: 0x2b17e9f5f66ec18,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x37163100bf3f8d1ac8c3ce9,
                    limb1: 0xe1fd1e43a5fe0bd9cf300acc,
                    limb2: 0x2dea0f29e1a948b5,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xda1891e6fae50a4fcd7c1efb,
                    limb1: 0x7ccf962002525e580d1dfba3,
                    limb2: 0x2d417d8fb0961d2f,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x9b449081c96a7b6cd8afa4c6,
                    limb1: 0x3b488fd36a053c43bda1f43d,
                    limb2: 0x2b6935952ebb052d,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x3d9e005d071c12def2cbd712,
                    limb1: 0x5243ac0e2c27279507bc17e,
                    limb2: 0x62a5cd7d66e6245,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x9a28bd7c9952182a46c738f3,
                    limb1: 0x3fb4a2da8dc3ebe6ce36cf88,
                    limb2: 0xe9b9152b140f763,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x2de172cb864798f4dbee10be,
                    limb1: 0x6fbf6332b1f8f653dd449862,
                    limb2: 0x1dce67ce75484b79,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xe336c048d0aa7a2b0d83d05e,
                    limb1: 0xaaec6b5d981abb8253d349a8,
                    limb2: 0x10f20943376b2d1b,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x2acdef558a557dde8c4f7461,
                    limb1: 0x3053253d194745b7a4ee9499,
                    limb2: 0x25257e3cc0789512,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xf5b71139f129ea9b4ceb537,
                    limb1: 0x8de9daf98337f77e21884f61,
                    limb2: 0x94edb97f8967bf0,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xd116eb93778b1c09f6f394df,
                    limb1: 0x51992b4c9f1ad702cfaeab84,
                    limb2: 0x25153c0ebf11e856,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xfff046c11f8271eaeafe8fde,
                    limb1: 0xd06c94c838de55faa1ca0bcc,
                    limb2: 0x16fb3d9ee11ac7b3,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x6152ae980011e6c6fe8fd053,
                    limb1: 0x1ece2ab13e7e12ea51cb00a1,
                    limb2: 0x1cbf684a9c876bac,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x57078c36ab21bd3389186922,
                    limb1: 0x6fcc9d2328c2777d4bcb6092,
                    limb2: 0x78dddb8efd28b00,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x3184a75c9f02b6e21f7548d,
                    limb1: 0xc49edc7b5bcffad92d855e35,
                    limb2: 0x1cf34c1e540e05cd,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x9118c445b89081a945b64669,
                    limb1: 0x6f54d322643282fd6a71cc71,
                    limb2: 0x1291fb7829dcc5d6,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xb69b96ca95302ae1e6819fb2,
                    limb1: 0xe70268afd4fff90b2dec54b6,
                    limb2: 0x24ed08be5110415d,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x60c06c06278903d32e1c1dd,
                    limb1: 0xbdf9b22f754f545a5bff1656,
                    limb2: 0x1db72793aeafb703,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x4120ff414537e9f5dedc6df1,
                    limb1: 0xae449ea348589d9036d3fae1,
                    limb2: 0x119f590f6ced6b3b,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x3ea6379669f4451170514d25,
                    limb1: 0xbaff4b52a532e7887be9f995,
                    limb2: 0xa501e68466ecf86,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x5bf9bd737e20fce210bd4798,
                    limb1: 0x1dec5db87cc6fdd2c0a0f21e,
                    limb2: 0xa6526eee26a2a25,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x8261a65c3c0745f53dc4f5cd,
                    limb1: 0x87cd0149cee1bacfc4a813f6,
                    limb2: 0xbdd3824d3d8350e,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x4bd870b5296ac26458bd2d61,
                    limb1: 0x8832028d81f2fd50b4be5d2a,
                    limb2: 0x29a4764d31c2b749,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xd9fcaa87fe8be1e7524220b1,
                    limb1: 0xcb588da0dff5f9e307df5a5,
                    limb2: 0x176ae32b11b2de80,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xedb5d5245fabd985bc879b06,
                    limb1: 0x63b555c22b4d688b8114aaf2,
                    limb2: 0x208e0fc200fec1e2,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xba55323e2d07b977d1952038,
                    limb1: 0x90cec43ac98ff50b939ab02f,
                    limb2: 0xf7d2a7c44201e00,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x550c8edff0da404b81b73c79,
                    limb1: 0xf7cab720ff1ddf69c37b24cf,
                    limb2: 0x300458eb5ead6a8b,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xe67729889b9ad72f5729face,
                    limb1: 0x256504e59555f13e5528bea5,
                    limb2: 0xc5115e7c69e95a5,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x5bccbce7a7db3af4ce8dd122,
                    limb1: 0x16a9b34d48f90e024962aeed,
                    limb2: 0x12af45dca1192e18,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x45e37e27a12142b3d6ae7939,
                    limb1: 0x87d3dc142d5372212c5df406,
                    limb2: 0x382ac921075275a,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x52d5c460fba9af20cb9fb06,
                    limb1: 0x650fa3d4137649fa35ca77a8,
                    limb2: 0x1fc24de526ce7f51,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xaf8628f894c87b36b26c5026,
                    limb1: 0x68f9180439ad8d02f15be11a,
                    limb2: 0x1790fdd94f27c546,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x74886bf98709b777d02b8784,
                    limb1: 0xd13fb17524962b62a76145f8,
                    limb2: 0x247abc2fede3afa7,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xb6e30c8116d312ca043e2311,
                    limb1: 0xe68ee703ef27762cbde9a648,
                    limb2: 0x10943a295a9b168,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xcd29cc2a98d9e7f23710ab4b,
                    limb1: 0x708829b15a02c3a3c780192c,
                    limb2: 0x8b8843bc2b6a6a6,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xa6570c8b0a98e46bf6fa0d28,
                    limb1: 0x848fdbc9656fe436afcdfbe9,
                    limb2: 0x131e31a3c565cb1e,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xb0afb5140940975b54eac3c4,
                    limb1: 0x32f128135ae20f705efa8b9f,
                    limb2: 0xc42e47fb05215f4,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xa3ccac902540f25dabe56f44,
                    limb1: 0x90a2fea1d2ec52ab42887541,
                    limb2: 0xb4629b28a481674,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xe7858cdecc40cfb92b2401cc,
                    limb1: 0x1ff1bc402a466f054d8cac4a,
                    limb2: 0x255b92d472a7e8d9,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x29baef17341a11acfffed7ee,
                    limb1: 0x8bd82a3f7dbe942329107319,
                    limb2: 0x1ece124f9a599f8c,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xd9f4ace7b54227b29ae71aa3,
                    limb1: 0xa1b7fbd76a4335ff020e162f,
                    limb2: 0x1a8ff1a48ee836bf,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x95b834f24f82b22574ba8bea,
                    limb1: 0xe77d70c43c25504adf17516b,
                    limb2: 0x24193cd705e9bda9,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xb2fa2e7ba128cb1ea2b165a,
                    limb1: 0x1ee4ae60791ed5e7df580dc6,
                    limb2: 0x74791a4a1631cf4,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xb310e65310e0c1a9017e6aef,
                    limb1: 0xe5a67dad908cadad0de00ae7,
                    limb2: 0x2a6be1cca1828046,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xbebc64d8f0f32775fbb5a97b,
                    limb1: 0xde0a0779903567d8bb9668f4,
                    limb2: 0x2552c4ebe0adeef5,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x43f2caa64d30936f9fa19d2,
                    limb1: 0xef75488415b994e334809cd1,
                    limb2: 0x1d5e5c7d418a68e6,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xbd6857f47c856b060c011db2,
                    limb1: 0x2e22c150c2190884d81ba62d,
                    limb2: 0x1c9dc484b11ea61a,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x231384a55b6e9e88d91cc1ac,
                    limb1: 0x9676fe22be22b4fe45183f5c,
                    limb2: 0x14816b65a9faf753,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x67812118b8d6bf7988e4da0e,
                    limb1: 0x8bdcc75b68aad55ae1a84888,
                    limb2: 0x2097cb698bb25045,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x838a687940a441fe0740527a,
                    limb1: 0x754899b50c61cedb665e9632,
                    limb2: 0x2b607e349e7be43,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x170f72aab758bd06f53dd36c,
                    limb1: 0xcc6deb0d7ef4a91551a0ac17,
                    limb2: 0x14f8d8e3d4061ac6,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x6127f1f48ab447f8b299af00,
                    limb1: 0xe4bf9f72cad5bf2b9ef935e0,
                    limb2: 0x21413b30adad2eeb,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x4ce9e3cb73938426309a4c88,
                    limb1: 0x90c3c2135d058173d9bec214,
                    limb2: 0x2fa65153b4d03b95,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x39d20f6bf2831ec1bbecdc8f,
                    limb1: 0x15c141ff3cb8a0f05d32d8f1,
                    limb2: 0xd4d92d620fc3cd3,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x809132db90061063bf4977d7,
                    limb1: 0x767a976977a51c9e8f7dbba5,
                    limb2: 0x157b40cc9cbf8c6a,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x74ea71503f4d439c0d22a38d,
                    limb1: 0x8430005f55cdb863e929a01b,
                    limb2: 0x27098bf43230c913,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xb12a878f4575e1b8197474d2,
                    limb1: 0x68103cfd5a437c4f051d578d,
                    limb2: 0x2e8b35494915952a,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x4c3b6707efa9d3fe82f0c45f,
                    limb1: 0x48f14d8768c12ad854544eb7,
                    limb2: 0x188e6e8cbaa65971,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x4227deb8fe5b68857076c2ab,
                    limb1: 0x5135f6095fe7049b6847ea95,
                    limb2: 0x172a309695981496,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x409dabcfa6842620ca798807,
                    limb1: 0x7484bfe7935e6d313d845ba5,
                    limb2: 0xa11d4d2f3628dfe,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x4305da39327d1f735a46daab,
                    limb1: 0xb1cac1222cc1ea2bebad610e,
                    limb2: 0x290d2ee385ad6970,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x6ddf2cc66c692ef268441d2c,
                    limb1: 0xd5944da8b1e135e2330f0efb,
                    limb2: 0x10ab4944c3f767,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x54d43be5f53496c9e887c939,
                    limb1: 0x50697341b8a2a346f47473b4,
                    limb2: 0x95c1db937bf3cb7,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xfda199da460826fd313e8c4d,
                    limb1: 0x54498779b8e89693e6c5b801,
                    limb2: 0x303065624449a537,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x2209412710137cbcd771cca4,
                    limb1: 0x87e579ecaa6ee417cac90f88,
                    limb2: 0x304d825d836c7f96,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x39388ff9e076e1edefaac31a,
                    limb1: 0x50d5f63b5fc47f6eea698e5,
                    limb2: 0x167d285acce32737,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xbeccc885e472048a07f2bc35,
                    limb1: 0x4c34f219ef1a4eac33b05d5,
                    limb2: 0x120cd5fbb3f90a31,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x3b9d52b67bdc7b758e550b29,
                    limb1: 0xf19b699cf2b400fb4f613706,
                    limb2: 0x200903643c3ecd96,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x39ba019a6272d1a8b0301e3f,
                    limb1: 0x9376096aba8eb5343f75e8d7,
                    limb2: 0x252e09ae1797db3b,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xa45e153c3b8d1b36700dda21,
                    limb1: 0xcbb2f3c86f4295f8d045d4ec,
                    limb2: 0x299e61a6a44d25f9,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xc69543f64244b72419da5c7a,
                    limb1: 0x253bce6731ceb41acdac93df,
                    limb2: 0x2cdedff80f0e784f,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x104c15a89bb65552fdbc3588,
                    limb1: 0xe6274772d2798b188b8f93df,
                    limb2: 0x1656a44912c003d4,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xfed770c50ae0918d67b25d00,
                    limb1: 0x33551093ad3ed7419d18459b,
                    limb2: 0x2e306d07631e2135,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xf903a07dd578cc7f33439954,
                    limb1: 0x9c2b7556b18a02307b2aaa22,
                    limb2: 0x6aa4a23a045612e,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x9f703fbf7a5a40a3beca20b7,
                    limb1: 0xd2345640d98c759b58d23d79,
                    limb2: 0x2ab967c5d1b64fba,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x906ff5d16df5dac793edf9a0,
                    limb1: 0x822b2b0776320181ec0b2af,
                    limb2: 0xaa72f61beee11d7,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xa77ac0d967c66f3990ec11e4,
                    limb1: 0x71f6106d5431382f35056141,
                    limb2: 0x35eaa763f64fe59,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x404c55351a4b5574ab9bd81e,
                    limb1: 0x64846c33a3889fcbf53324dd,
                    limb2: 0x2dfd7dc89da8cab7,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x2ca4d01335df0c5aea09a549,
                    limb1: 0xdf30348eb0cb11eafb537578,
                    limb2: 0xf089e2afd4e2598,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xe105e89030d0b13729c13f57,
                    limb1: 0x53c0e5a116140592fab8cfe7,
                    limb2: 0x2568156231a35bd0,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xf46bf2d8ad19f6fe1be44d95,
                    limb1: 0xe5280cbc146092f800489075,
                    limb2: 0x152746346523b33b,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x4ed7b726bc13ee9bb8cabade,
                    limb1: 0x42e95d91e99e50360369eb85,
                    limb2: 0x2486594633f287b,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x43d6eef97b1095f3b07d1518,
                    limb1: 0xc9c7bc07d47ef431221d96ec,
                    limb2: 0x2667cb5c3505ff7e,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xc80491882788bda6f09e60d7,
                    limb1: 0xb5d149b2d8debb4573583e00,
                    limb2: 0x182db6bca3bf95a6,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x4d159ffbe55c63e320538535,
                    limb1: 0x16cf34185c96b279bbf3f386,
                    limb2: 0x17e5c0c00f49b833,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xb4d6b1c8b058241f58f61aa3,
                    limb1: 0x3cec1b63db0578eb9d5e0da8,
                    limb2: 0x2448fec9b445849d,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x3c00d089cc38fc346b931c10,
                    limb1: 0x489bb3bcd53a205ae3a82d4,
                    limb2: 0xf10315a062b38a7,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x19a56df3979f269076b31f65,
                    limb1: 0x505850a4fad28ea397ae138f,
                    limb2: 0x901830b18ae5490,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xf7b6df2cc82fe2a358ad67ac,
                    limb1: 0x44599f76297b3c139dca85ea,
                    limb2: 0x21aebc43283a5758,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x7508ad1b120b2493a977fd1e,
                    limb1: 0xc484bc659a62fe199624e2ce,
                    limb2: 0xd13751cfea53c97,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xc39b7dee1db1064044c50950,
                    limb1: 0x74a10d9a37f22499acef8794,
                    limb2: 0x10987631cb9b9d8c,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xb93edac7e2c1e9ccf74d81df,
                    limb1: 0x5fc2b465b3290fdafd7d3595,
                    limb2: 0x70be8453a860134,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x120ecc5bded061005788d256,
                    limb1: 0x6cb132ca9df710448e2a6e43,
                    limb2: 0x842133bf2bdecb1,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xf765b6021dbd053433022677,
                    limb1: 0x3c4af2e8a167b5b0510e1c60,
                    limb2: 0x27ddf0d47591a515,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x2b500629b5cd6d2700419389,
                    limb1: 0xe68ac25440b87b24a8893c84,
                    limb2: 0x159e6b3b7899e57a,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xce1b3a80d732f83cebb0fd2d,
                    limb1: 0xcee84f32d537540d0f146f81,
                    limb2: 0x251c4f20a773829e,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xdae225d9af7aebbdf833ff19,
                    limb1: 0xa67e2cba0baa8e62204fb268,
                    limb2: 0x1d6548a008b22b9b,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x468af576cdc6465ed464f714,
                    limb1: 0x1aa0a9927d55768f1bdccab6,
                    limb2: 0x2c5968e341b037e7,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xa8548a668b01fe6691e54f56,
                    limb1: 0x261d12ac8f80b2675cc97f67,
                    limb2: 0x10c8275054a1db35,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x1368e8209177795d00bf3b87,
                    limb1: 0xf1e90525a699b050183f75d2,
                    limb2: 0x24a1f20e31545f2a,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xa9c67608664264ce24a5d633,
                    limb1: 0x6a5f0f824be130ed510de66b,
                    limb2: 0x18bfc318aca9adf7,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xd82ae0486cc46aa7138bd62,
                    limb1: 0xcbe69a9684a883e227dbf77a,
                    limb2: 0x25a8db781a8683cc,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x6ec51b98736c9292f0c38e31,
                    limb1: 0x5396fcae9b36cb607d12e537,
                    limb2: 0x2c4149d2e5a8c33d,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x80872290ed5a89fe046a372b,
                    limb1: 0x3fa146833eb1f167fc250a95,
                    limb2: 0x1a1dd3725ffed9ff,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x171195de05b44b4f0651338a,
                    limb1: 0x422e6286759d0d72b21484e8,
                    limb2: 0x9dd32c2adace017,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x5ae5843341cb27874fb1c1b1,
                    limb1: 0x2a24a124861ccb87854a1b7d,
                    limb2: 0x12e9eee1c23894b4,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xd37d442996f1deae2b0576ed,
                    limb1: 0x3d9cd40ada10652e3885d0ec,
                    limb2: 0xeccf7ff0554e4b5,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xf014490080c69694971e9b6a,
                    limb1: 0x553b396166961bdc93bb0dcd,
                    limb2: 0x20221e786b1e99a2,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x843b6fea2e6ad30d5126a789,
                    limb1: 0xd7e1a631063d2bf78deec8e,
                    limb2: 0x2ac233a88109aafb,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x9de0d14948b8146ec147b016,
                    limb1: 0xc054d27c28c85ae1af716991,
                    limb2: 0x221f2a9d88e7cb86,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xc3c683794e83952cdf366b7b,
                    limb1: 0x95057f6c85cbb532b11c4adc,
                    limb2: 0x6e63e5f32473834,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xabe225c55342d02ea36cf7d1,
                    limb1: 0x8869d02a963e9d105de6630f,
                    limb2: 0xe85bc612cd43391,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xdde6a32dac4a2c3259f32f55,
                    limb1: 0xb1226e4c8bbd0f5c966383f5,
                    limb2: 0x37432c8880f7858,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xddf8bcde168d877fc489145d,
                    limb1: 0x91d9db0ec9f51dba0afceaf,
                    limb2: 0x2048a8c3e1177c5a,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x73f62a7019abaf424ee280f2,
                    limb1: 0x5d2d7fc45c0dd76db25c3a8,
                    limb2: 0x128b1d37521d0bf8,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xba86ec47f4722eda3b89059,
                    limb1: 0xb8e60b08273e4e67e4b28e4d,
                    limb2: 0xed04b37b62e6b7,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xbcd3a1124eada06c019e3c77,
                    limb1: 0x3be787d099c18f8ef172f626,
                    limb2: 0x5e7b1c9712454b6,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xe0a35a51978440214d222e09,
                    limb1: 0xe1d7b69c852dbf05d4e411f5,
                    limb2: 0x289a3442718d89a1,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xb18e26673f0d288a2edf374b,
                    limb1: 0xd3e69a3a2f7dc586870b538c,
                    limb2: 0x295bfb7cd5addb5,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x915acc69addfd575e6107545,
                    limb1: 0xa2184383d894fc38ecbc1b5,
                    limb2: 0x196efa4624afe181,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x73cc04b7815266d2d0aca419,
                    limb1: 0xe774b5a6bbf13367b39ae3c7,
                    limb2: 0x23738c227561ca44,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x10eb34fa1072ab6e1b59439e,
                    limb1: 0x8a520267209e34282dd9ab7a,
                    limb2: 0x16d971290a19fc6b,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x471fa3d19d3675856a5a78e4,
                    limb1: 0xcfc2cf716c5868e5ca6d434c,
                    limb2: 0xe338212c6be67b5,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x30d7776b4ce0300e7ebda974,
                    limb1: 0x3042514c0c3a60c975afb834,
                    limb2: 0x28dcad55d053f6d8,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x7ba14b61f08fb92c4deb7b3,
                    limb1: 0xfd111f8897cdf50838b532c0,
                    limb2: 0x255c42e457422403,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xf93bb6c611b4e5d0f6dde5fd,
                    limb1: 0x2d8244c244e427a425470824,
                    limb2: 0x1179cb1c16ce4975,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x291dffdc4db41e8346edbd9d,
                    limb1: 0x28da3f3de7dc78c9762529,
                    limb2: 0xa94cb1235b3686d,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x741beef7f740bc6f76f24139,
                    limb1: 0x6d73274eab70165a491d907d,
                    limb2: 0x1f8c4789232e5148,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xb5afed7d2b43af9f42bdc5b7,
                    limb1: 0x42920b45a4aab464be367350,
                    limb2: 0x52481bada99a834,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x1559c8b31b054e07b0dffd8f,
                    limb1: 0xf47413f284cd03ee796db0a4,
                    limb2: 0x119b2c0d45ce6f6e,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xd0eb52a2bfefad25c78cdeeb,
                    limb1: 0xbfba5e02e1072588a7334b7f,
                    limb2: 0x278294bbc4129984,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xaa308bba9419ff12e0bbcd6c,
                    limb1: 0xa8a297cddedeeea22148a245,
                    limb2: 0x1600784b213705dd,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x78ae650dd075ed34538bbdbb,
                    limb1: 0x2da9f2bfb0f2cbd83ccb26e4,
                    limb2: 0x261208420786151f,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xe29142a813716e83a5ab46b,
                    limb1: 0xe52f4ede3d0871fc91174aa9,
                    limb2: 0x66d502eab73f111,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x6aeae0f538bd9bfcaf0c8de1,
                    limb1: 0xc04f54be5f5c3aefcd1ccc31,
                    limb2: 0x5bedc208565b5e1,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x65cc85d6583cd1041fb0536,
                    limb1: 0xcc2fc1eeb492019da18689f4,
                    limb2: 0x28966afe90fe1e85,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xdf2b8bdc7b6bce3c42b23459,
                    limb1: 0xb759cac5d1de2fc54de10f22,
                    limb2: 0x25b8dd37c5ccc96f,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x1aff6880b81abba09c6d1f8b,
                    limb1: 0x3dacf2105aea95e3168fc65a,
                    limb2: 0x15112b2df210c79c,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x881e34225b5f6bb4a8deabe4,
                    limb1: 0x8ce17c8cbe0f6928e5efe0e7,
                    limb2: 0x2610dd06bd95e6f8,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xe5587a4530c62858c8f543cd,
                    limb1: 0x507b79c5bc11539d2b72d65b,
                    limb2: 0x1715e822dca43ad0,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x39798dd3f1ad3427d9f23c79,
                    limb1: 0x187713d83c78015cee4a4df3,
                    limb2: 0xd2708abba95d860,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x79c8ac89032c6cc4c84a3517,
                    limb1: 0xac1216a341a6b0badd606da,
                    limb2: 0x5ca3012dc886b26,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x94d857ccda9e6be2efd4ebe,
                    limb1: 0xc363ae0d502a2eb68ba3f914,
                    limb2: 0x145e5b5d0cad3158,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x325b1d31628ddbba0803cc41,
                    limb1: 0x75b7e944db98ceb393643919,
                    limb2: 0x2717d5e3a1519f07,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x54ed2360dec821b36218aae7,
                    limb1: 0xf85e98716f6c7db4c9171a3b,
                    limb2: 0xb04b815461779a9,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x7a8332de45f83c1ab9244d55,
                    limb1: 0xa714b23714da4f13db886db6,
                    limb2: 0x21530674ed55a962,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x752dc934df65b38c5590bb0b,
                    limb1: 0x17a9921f1e0e9019e18dd9d5,
                    limb2: 0x1c98e2288b9748ba,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x3697e9ed25a11f6f63cd3f2b,
                    limb1: 0x1cd0fd18adb6dbe7c95336f2,
                    limb2: 0x20d5081f906ba9c8,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xe0cae8326a28ab5003d5a56f,
                    limb1: 0x8a82aafa816758306aa680b9,
                    limb2: 0x1c9d52c0330e8a47,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x290fee5401bf363c39484f0a,
                    limb1: 0x81a0fbab52a6b9edd8fade1,
                    limb2: 0x26869316b832369a,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x2dea5473359fee51cb2e0702,
                    limb1: 0xb231af1bbfa2bf52038133c2,
                    limb2: 0x111fbc860aaa20dc,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xf11b709b49dbb30d02ff1d0a,
                    limb1: 0x8eea8f62019cf36e6701235f,
                    limb2: 0x1821e4e8e4c02c75,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x137821e1d5bf35628ba35bf8,
                    limb1: 0xf5d47e94f894b499145b6026,
                    limb2: 0x2106fcc1f425b265,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x6cc02b9d8a922c99ea1283e3,
                    limb1: 0x71d0944653d0c8c455565a25,
                    limb2: 0x1c1a4c6035238785,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x44fa0839d88b31d04c19b8d6,
                    limb1: 0x97a9bb1fd404f124fe4ee6a5,
                    limb2: 0x16a0fffa55b4b778,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xbd1c68db288be88835fac486,
                    limb1: 0xd7d1b2ad10864f16a77c965d,
                    limb2: 0xd3c84c5ab3997c2,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x1cd683fe4fed3b51f7132d49,
                    limb1: 0x51dc3c80877df4adf903e18f,
                    limb2: 0xf0ee5a7a7c8974,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x143a6ee69765b53a86a0659a,
                    limb1: 0xcd52cbac21a127cb0bdb4f40,
                    limb2: 0x1dbb3e12d27bcf19,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x10b4706e6a72cc61e6eef3f9,
                    limb1: 0x512e3dae64a823050ffdfecd,
                    limb2: 0x2c3110ab08aebf6f,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x637471c20438aee78e52d7c3,
                    limb1: 0x9bb739bd0c495b25e482ff84,
                    limb2: 0xef84ea7df45d4c7,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x60da00cd2814ced4110e5415,
                    limb1: 0xebf545b23b2f4274fe54b12d,
                    limb2: 0x18c564cf9cc44c16,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x656c66336c99aa472514040e,
                    limb1: 0x832a7a79af094744a8042a3f,
                    limb2: 0x15c230d2750c6a54,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x90c708be1e4a9294d5a8ce5c,
                    limb1: 0x6c8f0525588b2fa1610b32d9,
                    limb2: 0x17be7857b9522ad7,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x8fe07615f957f27e58e3372f,
                    limb1: 0xbc0dbaf177d7a644f61e06ad,
                    limb2: 0x5d6beb714f20045,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xb4a1dd92c86dfa5c3e13c8ee,
                    limb1: 0x6d65673e9aa9b30ebadcbac2,
                    limb2: 0x17ec77b3f4f4e45c,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xa16135910cb7289da06fb7d7,
                    limb1: 0x4fb5f3dc55e9cd078827953f,
                    limb2: 0x2d3136a29a9898c3,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x23e4a4e757648ea30d404dd3,
                    limb1: 0xce7a7c679b9a305bcae81353,
                    limb2: 0xcd418be8736f7b7,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x4bca506e3d6e2457d6ced82d,
                    limb1: 0xb6450ce562582acd18d94a3f,
                    limb2: 0x294c9a3aa9af73ef,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x1cec032aac2889c895dd7c4b,
                    limb1: 0xd2a63ae520a07755f754cd26,
                    limb2: 0x206e12677d554b24,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x492e57a5bbb29a9a58cd0c1,
                    limb1: 0x36469a8995b991aee77dce64,
                    limb2: 0x2caa4b3570e23ea6,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x99853a6e0642e1eed586878f,
                    limb1: 0xbe8fed420987c530750cc3fd,
                    limb2: 0x89ac9ec034c10ea,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x12aa624bacd5f0df175b45d2,
                    limb1: 0x2230877036c89d6aa2722cb5,
                    limb2: 0x1d73cd12ab614416,
                    limb3: 0x0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xa813d69ae52922f5eb971fed,
                    limb1: 0x9973d5d966048e7e89d55ea4,
                    limb2: 0x2afca4f8ab74e270,
                    limb3: 0x0
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xe7c77abfa56382459f5bbc1d,
                    limb1: 0xe95f8755435a6365699c7b09,
                    limb2: 0x2f9b283687173116,
                    limb3: 0x0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x607281b78d2d8ec96fdb3587,
                    limb1: 0x635449ac94758ebc30bbcc55,
                    limb2: 0x163b1619127dd84d,
                    limb3: 0x0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xcc232fdc9c5a39941bcbeca2,
                    limb1: 0xc07ffeb8a8615cfceae521b9,
                    limb2: 0x2d3dc73a8f788101,
                    limb3: 0x0
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xa71283147ac59e28f6bc858c,
                    limb1: 0xa845c86a535de5af972f311,
                    limb2: 0xdc5c250347597b,
                    limb3: 0x0
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
        ];
        let big_Q: Array<u384> = array![
            u384 {
                limb0: 0x56f2cd09ab9aaf50b0dbee15,
                limb1: 0x97a5b452a8fc0d124e3ceed0,
                limb2: 0x107f14bf2ff36bf6,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x28c0a88ff320ffcfd511e86f,
                limb1: 0x9989a47a17d0192ecc90e770,
                limb2: 0x1c17711d1ed95922,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x96ad45e4d05a14ee83a50912,
                limb1: 0xbfa70df0abc8eb8eeba92efc,
                limb2: 0x288d24b036206c3,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xb8868b82ea3591787a1b743c,
                limb1: 0xc3bc05ef5a92a05820ce7b4c,
                limb2: 0x20a7461780e9f08c,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x5bff13d8b64b32eca68730cd,
                limb1: 0x6acf4975e567783d6000cf99,
                limb2: 0xd2261e1dadd7829,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x5035380d1ac677c2f1e239e1,
                limb1: 0x290512c428aa5cac8f1507f0,
                limb2: 0x2dbca71d389af16e,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xb02bb8486d32838afbf00437,
                limb1: 0x114034789b3144440d3f1ade,
                limb2: 0xa95cb66ef3e993a,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x8e78e3dc710004316b3d892,
                limb1: 0xfb557d2e49e807fd065b8f87,
                limb2: 0x2b7142e9c4a9a7d3,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xa98544331a81152630afb08c,
                limb1: 0xf248fb8ee6c24e4ecb4a4556,
                limb2: 0x92287c35b3448cc,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x990a9ca602cf9ccc198e794f,
                limb1: 0xa44f0ed83c9bfbe1957a0c04,
                limb2: 0x172c2467542289b,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xb7ca71352c0734087e42eb77,
                limb1: 0xa86757c7eccaf9c08845ede3,
                limb2: 0x27eff18f25e6ff2,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x33b5c16d4040eab749f070de,
                limb1: 0xbeecbb9583133e85cd20486,
                limb2: 0xd2fee6d70d7a90,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x14b46be1ac56f11f636b1548,
                limb1: 0xaa08f321dfca4e3bee85142b,
                limb2: 0x1fff78b41c1ea9e5,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xee4dd7194232929e865c1a2,
                limb1: 0xa9d7fcc616df1a0f8081ffd0,
                limb2: 0x1442893bca560d4b,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x7ad0df4e558432c1f9b34771,
                limb1: 0x87ac9a67defd78a747b8c197,
                limb2: 0x1c8a15cbcc78aaaf,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x9e73132c65e8b3996e9c8ced,
                limb1: 0x5ea12d8b0c9bbb1233d5d505,
                limb2: 0x1806a0daf692b328,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x5e554a5e3632a92ed3c618b5,
                limb1: 0xd3c60b414f95aa9507d1f58a,
                limb2: 0xb0d34cf06fd4390,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x629be21851aa4a2bbb191a86,
                limb1: 0x71eb85f4f6d702d025bd97ab,
                limb2: 0x24ace26e227d25ec,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xd542e3eaa5d0bd18448b77b9,
                limb1: 0xee3fb6c0c339da9a4f59671e,
                limb2: 0x297cbacfd8c7ff3d,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x65654e60a306c4721538da65,
                limb1: 0xa85b55b48b570f0b6ba4d65d,
                limb2: 0xf97bd167378ef7d,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xc522f12267b27f4eafe5e88a,
                limb1: 0x529c2df5d79fa22a8bf13e25,
                limb2: 0x2498aa7f4ddd12c6,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x3a778c887e096041da658f1,
                limb1: 0x3258433aae118459193487af,
                limb2: 0x1cdec66d4d9b32ec,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x51ebd4f3882d648787668b8b,
                limb1: 0x4de195b73de462a85af3df0b,
                limb2: 0x2abd4d8b96dd44f5,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x9825501eb8e68f29287a829e,
                limb1: 0x907e308d188f44e2edacb45,
                limb2: 0x1865d5751cd40bbb,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xb2c07f7a1e7ebe16579d5da7,
                limb1: 0x313ae692f03c4afa68ce8bb0,
                limb2: 0xfbb9711c4d983a7,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x4403d5259b9f49f0f8c1847e,
                limb1: 0xe732a4c618838e1b97f4e5cc,
                limb2: 0x21ec652e1205fd,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x67e44cf2ef69d2f7ccb3b933,
                limb1: 0x774f77142b7683bc77525abd,
                limb2: 0x155a2aa5c0683066,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x92c9014480cfa5bf74864efe,
                limb1: 0xf6015daa6950e4df8ca602a1,
                limb2: 0x286fdda90b0f0e1a,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x7c9d934816f201c7de0a73bd,
                limb1: 0xf4cd11b49c071ee77b068224,
                limb2: 0x2d273f9e3ef51a38,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xe124d095f7976c4cc2aa82dd,
                limb1: 0x8ddfc8418b0743d5d587d088,
                limb2: 0x1dcbd5ccd7aff685,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x69cb33e7abfd89de9bebe96,
                limb1: 0xa25f55b1c1bd867fdaf338e3,
                limb2: 0xc24f2f81db5a07e,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xa280d5ea0a848586c3b1e227,
                limb1: 0xc9184be1b76d27b51cd6421d,
                limb2: 0x2748f5f113037028,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xfcb6f9651540b9a30a3cf541,
                limb1: 0xd0b2324f6b8ab8afdf12f323,
                limb2: 0x2e24f178f8d3a72c,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x75e91595707979dacd3f46a5,
                limb1: 0x736f4f648118e9dd1ad6ec32,
                limb2: 0x6e4e918a6e624f1,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x44122608044658637230953,
                limb1: 0xbd47abd2eb36dd1ce3b94d4c,
                limb2: 0x25725a154f3174c0,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xab0c1aec953b65c5c260f040,
                limb1: 0x86b15dedcdc13f4910bf2a52,
                limb2: 0x2024921ce88eba22,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xf50db010e09030397761ce30,
                limb1: 0x8f23c89627ca5e47462c7e4d,
                limb2: 0x1647fd78459532a6,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xc9de9c2f4f898ecf40f72ae0,
                limb1: 0x6319f67dd1af5152f7839efc,
                limb2: 0x10577f58e41216cf,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x9feb555a3fc10500a350e37d,
                limb1: 0x5c8c7cd3667ef6a9bc45b11e,
                limb2: 0x1d60cb73cd91ce0,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x2d5cba96c3a29d8918a1238f,
                limb1: 0x700cc212675529a975ad60c5,
                limb2: 0x10eb3e5ad3f7fa6,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x41c351e179ef7f6a00c4b279,
                limb1: 0xac801fd918c7337e1f7120f2,
                limb2: 0xa5e035d54277d42,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x9e9503c104110a566e00bafe,
                limb1: 0xee0f01d7f8b02aedbd9912f0,
                limb2: 0x88664b623481bae,
                limb3: 0x0
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        ];

        let res = multi_pairing_check_bn254_2_pairs(
            pair0, pair1, lambda_root, lambda_root_inverse, w, Ris.span(), big_Q
        );
        assert!(res);
    }


    #[test]
    fn BLS12_381_mpcheck_2P() {
        let pair0: G1G2Pair = G1G2Pair {
            p: G1Point {
                x: u384 {
                    limb0: 0xde1d8e2670532ec5bba60ade,
                    limb1: 0x1154f5064f7dd38656f7f82b,
                    limb2: 0xc9bec68372b7d07dcf66270c,
                    limb3: 0x315ced00b3153219bbd430
                },
                y: u384 {
                    limb0: 0xc48b3bc110e208d827b13f4d,
                    limb1: 0x87d82592699bca3dbf847c2b,
                    limb2: 0xff04f0f2c8be12365aa73443,
                    limb3: 0x1739c8c450ac994a5326c809
                }
            },
            q: G2Point {
                x0: u384 {
                    limb0: 0x43ab0fad950464628db89208,
                    limb1: 0x2039da5bdcfa15b87afe787c,
                    limb2: 0x3bedbab51d4af810c85378ec,
                    limb3: 0x7936e4991b2e586deafe0e1
                },
                x1: u384 {
                    limb0: 0xbe0a624e0d2ba6ed122f4ae7,
                    limb1: 0xaa1cb8f82a23568adec006eb,
                    limb2: 0x568df12b5dfbece7ba52ba5,
                    limb3: 0x12b3c2a89177e882235c5b87
                },
                y0: u384 {
                    limb0: 0xf5527511404dc0cf475b22c0,
                    limb1: 0x223333c880b544994de08d5c,
                    limb2: 0x5b02b8381dcc65af97004a31,
                    limb3: 0x120d60c0cccc425ec25c4055
                },
                y1: u384 {
                    limb0: 0x626d34c705aaa622509c2212,
                    limb1: 0xca938c1b2a62466075086797,
                    limb2: 0x7d84305685214746fde4ae2d,
                    limb3: 0x114030309c77f00d599a231c
                }
            }
        };
        let pair1: G1G2Pair = G1G2Pair {
            p: G1Point {
                x: u384 {
                    limb0: 0xde1d8e2670532ec5bba60ade,
                    limb1: 0x1154f5064f7dd38656f7f82b,
                    limb2: 0xc9bec68372b7d07dcf66270c,
                    limb3: 0x315ced00b3153219bbd430
                },
                y: u384 {
                    limb0: 0xecc8c43ea91cf727d84e6b5e,
                    limb1: 0xdf58ad0e8d152be65f2783d2,
                    limb2: 0x4446bbe49bb9394e98ddde7b,
                    limb3: 0x2c74925e8d34d4ff7f4dfac
                }
            },
            q: G2Point {
                x0: u384 {
                    limb0: 0x43ab0fad950464628db89208,
                    limb1: 0x2039da5bdcfa15b87afe787c,
                    limb2: 0x3bedbab51d4af810c85378ec,
                    limb3: 0x7936e4991b2e586deafe0e1
                },
                x1: u384 {
                    limb0: 0xbe0a624e0d2ba6ed122f4ae7,
                    limb1: 0xaa1cb8f82a23568adec006eb,
                    limb2: 0x568df12b5dfbece7ba52ba5,
                    limb3: 0x12b3c2a89177e882235c5b87
                },
                y0: u384 {
                    limb0: 0xf5527511404dc0cf475b22c0,
                    limb1: 0x223333c880b544994de08d5c,
                    limb2: 0x5b02b8381dcc65af97004a31,
                    limb3: 0x120d60c0cccc425ec25c4055
                },
                y1: u384 {
                    limb0: 0x626d34c705aaa622509c2212,
                    limb1: 0xca938c1b2a62466075086797,
                    limb2: 0x7d84305685214746fde4ae2d,
                    limb3: 0x114030309c77f00d599a231c
                }
            }
        };
        let lambda_root_inverse = E12D {
            w0: u384 {
                limb0: 0x1419f4ad032a2a6a8cb8b34b,
                limb1: 0xd4fcecca765dab92edec8f96,
                limb2: 0x3928228cb0109bc206933bd1,
                limb3: 0x60344399b326c0cdbee2085
            },
            w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w2: u384 {
                limb0: 0x3d3e587811dd23de5c7591b9,
                limb1: 0x427746255f60e58ad96c0319,
                limb2: 0x1201769563ceb00bb03353e6,
                limb3: 0x2633cc4a058081e16368b83
            },
            w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w4: u384 {
                limb0: 0xb2ccba06f8eee91b38439200,
                limb1: 0x1ec0efdd003b88e77aac199,
                limb2: 0x8ffad32d85fac3fa342f797b,
                limb3: 0x1490344303dab53b94a6c79c
            },
            w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w6: u384 {
                limb0: 0x7a285c24903b291ba1f0cc65,
                limb1: 0x3e5a86e99b3bfabece16b436,
                limb2: 0xa68b19a57f0be18f89fcfc6,
                limb3: 0xfa8590a37c4315aeab9454a
            },
            w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w8: u384 {
                limb0: 0x8ec3363db1991aea840a93da,
                limb1: 0x7f20fd4d7655081d009de5d0,
                limb2: 0xe66cbd6e1480f32ebf00c884,
                limb3: 0x1047013ff04568b003d6e95b
            },
            w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w10: u384 {
                limb0: 0x84b493bd0ca9319d0fae6f6b,
                limb1: 0x28ec29b1b2ec13d22b31d031,
                limb2: 0x559a237d5f97558e50f4c43e,
                limb3: 0x3b0d1b29291cb17da345d08
            },
            w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        };
        let w: MillerLoopResultScalingFactor = MillerLoopResultScalingFactor {
            w0: u384 {
                limb0: 0xbae9de3ee5d425ae53ef5df6,
                limb1: 0x77ef1ece162182767f9b8024,
                limb2: 0xf6d899df7dee88fec89e2039,
                limb3: 0xb6169fcaceecf162ee629dd
            },
            w2: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w4: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w6: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w8: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            w10: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        };
        let Ris: Array<E12D> = array![
            E12D {
                w0: u384 {
                    limb0: 0x6563dafb5c5a98b6f45a5be9,
                    limb1: 0x89b264f2d1bf816ce90df6be,
                    limb2: 0x57d19fc3a36b1011716d1b18,
                    limb3: 0x11e6859ad075ae553cb3a448
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x2e4d8501746a16b8a8786ef9,
                    limb1: 0xfc9d19a25f42caea0b6f58dd,
                    limb2: 0x4e47403eb92d4d9590ef006b,
                    limb3: 0x9948b751853b6fcc2ed6480
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xc7a0651e881ce2d7ad5002c5,
                    limb1: 0x97f0f9fc46955526ca834a1d,
                    limb2: 0x28ec7f1eacdbd54c3edc024c,
                    limb3: 0xcdafd8d2100799b3039e154
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x94534577d70af2bd5afe9efa,
                    limb1: 0x73a5d02acd601a3ac10aaa17,
                    limb2: 0x59e74bffedbd66e7a9816277,
                    limb3: 0xda7b93e458d880077624aa9
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x588c9d12facebd85377913fe,
                    limb1: 0x70e6a10d888093fa8c94fe02,
                    limb2: 0x8fb28bb49ecd176acdfb897f,
                    limb3: 0x16b0b5719f388d41f025a21b
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xb71807f625ed153731e02cda,
                    limb1: 0xde0132b577fa0db27f4d8152,
                    limb2: 0x6486d4253cda31b76b288cf8,
                    limb3: 0x2f59c7d029501ff35f71c17
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x429db72d524d135560a9148,
                    limb1: 0x7b73181cc2c100f5d6d39fbb,
                    limb2: 0x6de9a5d1847695d128811924,
                    limb3: 0x25242a7e9444a8b703ec41
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x4151c4ba6eac9e11fbdadf34,
                    limb1: 0xcde828b878dded1e8d01eb70,
                    limb2: 0x4d2df32b2c26fb1f3fbce53e,
                    limb3: 0x59ce0fe432b02f174d04b5a
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x7186400cb19e31a40576377f,
                    limb1: 0x5b810ea19ebae3a08f03ea6a,
                    limb2: 0x9ae99a08bb5fb9749c378d4f,
                    limb3: 0x1069bf6612e83a46f06f7e9f
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xe0ac325c48edef5e46bbf8ef,
                    limb1: 0xfea0514de9b832a8c9c5e896,
                    limb2: 0x2f16a0f777daef64b548a68a,
                    limb3: 0x137093739e7cb00ea61606d1
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xd9156df01eb884b5e328ad59,
                    limb1: 0x94b7192af81b4cacbf83d855,
                    limb2: 0xb7972e78eda7c41c6f52953a,
                    limb3: 0x94a4760396f2e786cba55ca
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xd48fca9649b0ec1c94231936,
                    limb1: 0x905cd7869ca5e8f4bca0828b,
                    limb2: 0x24c4f89bd291f0d21813ec3b,
                    limb3: 0x1550013875c9c13d7900f7d8
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x63a26dca0bed3caa257a760c,
                    limb1: 0xbf056851393c28f2d70239cf,
                    limb2: 0xa7d9132a4b50d074ddf2f65a,
                    limb3: 0xe1ded8e0d80814b5c0a6ef6
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xd6aebaa4c0c74f877834c1c,
                    limb1: 0x6d705fd77deab45f7dfe5982,
                    limb2: 0x2a9376b671e0b35a79cc060d,
                    limb3: 0xf399074413929b1ae839c86
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xe91965d43bb2c4376cca88ff,
                    limb1: 0xcb3eb23302e53c59a1330a51,
                    limb2: 0xb76f2b4fadda698bac8aa577,
                    limb3: 0xa2d5f66862c150881f016a6
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x55815e91d116d7532804ec3e,
                    limb1: 0x184ab3307eaf09f52be4f4b7,
                    limb2: 0xb1f53f3a63c02ce284e7c0fe,
                    limb3: 0x366d520e738e7c43feecab5
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xf91249114d944d0484d6bba0,
                    limb1: 0x24d7a8a2bf07d1170fb8f6a2,
                    limb2: 0x8d14aadc911b798ea9a5a3f6,
                    limb3: 0x788b2a9fb716673e8ff8833
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x26f798637e06b238f0d55609,
                    limb1: 0xe4e1143e6f755a360cdf301c,
                    limb2: 0xb77ce00a1f3a25fc5e25b2ec,
                    limb3: 0x8e72dc58c9d09f5a14f0402
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x8d19c63a584a1f5ed4edf8b3,
                    limb1: 0xd5ece5756a56daa7af466d51,
                    limb2: 0xd6b220264087840f8abe3ba2,
                    limb3: 0x109845d7e9445e751381941b
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x961125e2d1be97c216f12306,
                    limb1: 0x2b26b04df4248d6a914398c8,
                    limb2: 0xcf7a6abca525ecf9ce29de22,
                    limb3: 0xc37a07f33ffd4118a87ef1e
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x98368798541358d2017a69f4,
                    limb1: 0x117e1459a924e77b3819e2c4,
                    limb2: 0x71279aa1a6347b9d10e180f8,
                    limb3: 0xa9dc1baa5d9f31b42f049a8
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xa81a53aeeddf73ce6c423073,
                    limb1: 0x4ef5c57d3d10ccbe2f45a118,
                    limb2: 0x860056654f935868d0e03b49,
                    limb3: 0x4fdb8dee348e3cff92e8c9b
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x5832d50c54ebc033ca12eb5f,
                    limb1: 0xa9f7a57bd355bad87f688724,
                    limb2: 0x2f0cc735e4e169c1ce64f90b,
                    limb3: 0x108f3ad9b3d7ca9ded1f2097
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xefc642fb891283518adb81aa,
                    limb1: 0x46173961dca7fa6316a5de9a,
                    limb2: 0x6b2a5e20a01d1c3ff973f037,
                    limb3: 0x18bba5a72d74bfcf16f72381
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xb770dbc198693126574f3179,
                    limb1: 0x39c521e90d668b85024fba78,
                    limb2: 0x3c05caa15c11d04d60476d41,
                    limb3: 0x782627de1bf96a1baa4fe3a
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x309c7a7071499016725d3a38,
                    limb1: 0xbf16b792ed892143bb2f23a1,
                    limb2: 0x388bd47fa3d1be6764c1cdaf,
                    limb3: 0x196db4ffe728cc98fed2a15c
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x562cfabe3c9ec8c858b919ce,
                    limb1: 0xf09f5d4e361ece2f5e331cea,
                    limb2: 0x25a1d42d10b4bed5f7f7923c,
                    limb3: 0xd685017061e43bad23e6bdf
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x9b2ed93394ebd4b137b903cd,
                    limb1: 0x6fa1be27865ddc6d155c5213,
                    limb2: 0x3bd7a146f71c95afefd2d448,
                    limb3: 0x982ded685623f9adeb6b617
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x5fdc7650785b0cccc9df30fe,
                    limb1: 0x9275d027028dcd858ea6dc6e,
                    limb2: 0x6e021694ee0af821cffd9870,
                    limb3: 0x1085393abbc8d597d4145f82
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x95448c7bf0cf89ca615b6b65,
                    limb1: 0xc6431562fa8b3708183e6563,
                    limb2: 0x8c347f2e5f5e161d6fba2c26,
                    limb3: 0x12253af3cbafae2574b87ddf
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x2b98a48017310ccb39c5c50b,
                    limb1: 0xae77e4ed631449bd6c9ef0cd,
                    limb2: 0x4dbdab6a86bea88942de2541,
                    limb3: 0x5d058d6442327962d98b50b
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xdabd695dab0515785b972842,
                    limb1: 0xf21a8da7f7165004861408d5,
                    limb2: 0xcf32295a817dcc6bab07f15b,
                    limb3: 0x117255448f3c5a29872c3b80
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x46a6201b4bc81b68f430e5ef,
                    limb1: 0x7462a12d415bf0975b15368a,
                    limb2: 0xf5fb34c69d09df7e11154f25,
                    limb3: 0xbfee9f1e4eb8108d7ae1cd0
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x7dc835978918522a2ba4b65b,
                    limb1: 0x3c142821479ce0db735c1ee4,
                    limb2: 0x95d17a22410eb2f24e973f9d,
                    limb3: 0xc93c52b92c7ea415357afb6
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xab522ddad452b3fe53d38dd0,
                    limb1: 0x12f3aa990b768e95a51030c7,
                    limb2: 0x67714f7b2ef16f2ba12646f8,
                    limb3: 0x1adfc2d5aa6b4c5f5ef7281
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x2f163e3440905eb698a51d54,
                    limb1: 0x7e9274c308951d6289baf789,
                    limb2: 0x959e80894ef392f3d459eb41,
                    limb3: 0x13283285a82e24f1c395a922
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x2d2faf60e7a3bbc5f693f3dd,
                    limb1: 0x8a4cc10ee42324ab51b06ef0,
                    limb2: 0xa0ce8c6636ac147301a46046,
                    limb3: 0x10f25da25f4ed2b5251a3165
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xdc22b1b866de329e78b62db4,
                    limb1: 0x43d2c6eccd9a8cb85bec534b,
                    limb2: 0x5f784d2d659c4abc84227dc6,
                    limb3: 0x16a4e3582c926be25c0448c5
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x1aa2a57a7c6b5e5d3ad6ce50,
                    limb1: 0x271039b4a82718314e01df8a,
                    limb2: 0x6d0fceadeb63135398098e5,
                    limb3: 0x1155d40096e1b2abeb21ebec
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xc04ca69c9d03edf31d77e4f2,
                    limb1: 0x5c3abf66206895c40153a7d7,
                    limb2: 0xa0096c19e7dfaa52140aa4fc,
                    limb3: 0xac93f32091e198e29705d
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xf427c70862c3cf6ae91ba893,
                    limb1: 0x76006a8b2de674d6573130d9,
                    limb2: 0xd0f6570764135a3f08f0b826,
                    limb3: 0x17ebb31d77f3a01098d98c68
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x9c5f802d3946afb664b05cff,
                    limb1: 0x7c7aebfecf9a3f69bab28e64,
                    limb2: 0xb7242c118268ff46f5c4cef1,
                    limb3: 0x11ea46b9e708366aa619f204
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x9f7febd8b54a7ee18c1ad94f,
                    limb1: 0xabc16d9113a79478e51276b5,
                    limb2: 0x1a6ec811b1a32c25a10095b5,
                    limb3: 0x1215383b31a5c31450c25dc7
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xc4fccbe3e73af162c34d29de,
                    limb1: 0xb18e1976dc08815ed002ed8d,
                    limb2: 0xf094daef68a91cdaa074fb07,
                    limb3: 0x4d747c35427255b9bcc4e01
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x34d1d5aced802e9feeb91816,
                    limb1: 0x9c1d1dcb22365f9521ef7be7,
                    limb2: 0xa44ac9dcb40f6e76d53ae88b,
                    limb3: 0x112fcfba9fe7f8e857a1b51f
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x1b8ea4dd05ae5d71552eb1d2,
                    limb1: 0x6a423dd9838308316c16b044,
                    limb2: 0x896e15f7f1100603f7a4d684,
                    limb3: 0x558a431d9a53c1a25751d3f
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xdc8e2952c3e596993c18b45,
                    limb1: 0x3a4cece4fb1b158c21090dd4,
                    limb2: 0xa290965aef30542c698b0d1d,
                    limb3: 0x103937c54d7f8b50d1d44609
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x14dc06a53aa7ce461cbe0e48,
                    limb1: 0x1c1af6e61bdbe9a9c714cb0a,
                    limb2: 0xa6de8d425192e95414883a5d,
                    limb3: 0x9fd55116269a6a67fe0dbff
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xd0d242444c78e62b7325c24e,
                    limb1: 0xb0c010af5e673a0d026070bb,
                    limb2: 0xe8de945f49c5ef127998ff7f,
                    limb3: 0x1857e696961e32062f937cd1
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x923742a86386d0e4b8132197,
                    limb1: 0xb5b1ecb2a3440b4aae727435,
                    limb2: 0xa8f1008b858330817d812125,
                    limb3: 0x833f3cfc02c6f158e217ba9
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x115f0f115be40bd8c10a9b81,
                    limb1: 0x16f22ee982f39f8413169d0,
                    limb2: 0x19886e287251c20041d12414,
                    limb3: 0x104dcce75641ee5ec48714ea
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xa24342c01ca999c8cba993fb,
                    limb1: 0xc67e18aa04adbc5fb344e92b,
                    limb2: 0xa51890f72241062b67e48cd6,
                    limb3: 0xc2ea50eae678ebd0d7918c6
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x457b04e69db4d97f1cea8dd3,
                    limb1: 0xde9b6048e1ab0705698f548a,
                    limb2: 0xd4183277059592b5bf112892,
                    limb3: 0x17b2f10a7e97e49b78f3c8db
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x6dc8b49ac13fba95511562d9,
                    limb1: 0xf03434f000c2eb0d83ae5661,
                    limb2: 0x8fea7060bc2e7c5081e232cf,
                    limb3: 0x15d40d5889d03185401e9e2e
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x3b1315d554625190350f8e91,
                    limb1: 0x35ebbf25665f111f813397c3,
                    limb2: 0x31d3c581f755d5bd2b24ade0,
                    limb3: 0xf89f50e7eefc0702e29a911
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x363f8b503ac8cf0923ca1f33,
                    limb1: 0x2b3fca04eb2b290060bf5efd,
                    limb2: 0xeee01fa857e379754c291ce4,
                    limb3: 0x81282c4e4dbc863c6a4d4a6
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x86e1bc2f47bf7560ea45f67b,
                    limb1: 0x85818705f6c05bae86cae1fe,
                    limb2: 0x645ed57465ca74d71deab7ed,
                    limb3: 0x55b418fb69cc936761b9b72
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xd15ca650094a057aaa7b10ca,
                    limb1: 0xec9ab8d265dff9daa78713e3,
                    limb2: 0x3dabb4c28934350d7ca6701,
                    limb3: 0xa60c7a35aa44e45789718a1
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x4c220510b70651954eca32ae,
                    limb1: 0x82f2e04ee42d966c02bd1596,
                    limb2: 0x1b4f1a681551538882bdd931,
                    limb3: 0x1510f6b07348cfb8d8d50e
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x8cad37b937150c8c06ce22cc,
                    limb1: 0xf9ed21d227973ecc09c11971,
                    limb2: 0x2f8be14c5b93e1e8a899101f,
                    limb3: 0x133bb4bece9876e978cfdf12
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xc22f07ca237ec599e024628a,
                    limb1: 0x72367cfe43e869bb45fefdf8,
                    limb2: 0x2f065b61513b8ed498d28e80,
                    limb3: 0xd81c82113a84556873e5199
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xbeea2ef1afa725a120712cd7,
                    limb1: 0x9404b5e0e63a990ce6e56d08,
                    limb2: 0xd793b7cf1d7adcf2436894c0,
                    limb3: 0x26a97ad649cd378a5f8b3c5
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x92856f875c533877109ae3cd,
                    limb1: 0x6a07eb28c9780c8954cc8307,
                    limb2: 0x60c63231021fc7955a66df04,
                    limb3: 0x1910cdc552aedd738daa6157
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xa7a58f6ac2fb363fc340b13d,
                    limb1: 0x51cefec19878c75bda6f0621,
                    limb2: 0x14a45d908eb5a8cbb2576cae,
                    limb3: 0x12683d8b150d3feea7b48ac0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xb075e23b6327d259c27050e2,
                    limb1: 0x916885e31cafaeb252cf1bab,
                    limb2: 0xbde6982b0c9af749f9cd21e7,
                    limb3: 0xda23837f5e5d62de54c0880
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x7f830d8f6a725e126b4a83d7,
                    limb1: 0x8aecbade87f93fba290e81ca,
                    limb2: 0x7cb58b531f9ee2c349b29592,
                    limb3: 0x9106333e79ed517f1e45cf4
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xfe349c1ab5efe4c90af3f7ff,
                    limb1: 0x7f379a9407c7c1421eacba86,
                    limb2: 0xaca9456c14dd7dcaaf61d971,
                    limb3: 0xa1b0085e4eb5f37f50329af
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xcd292a714907236f8b235976,
                    limb1: 0x97f567b3bfb69b07acbd847a,
                    limb2: 0x88cd02b2155dd41f3230c1d4,
                    limb3: 0xe692a3da08e81f21d57c68d
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xacb39b2bd1759c7e4ad02e9d,
                    limb1: 0xd7b2457f2d92371181ff84be,
                    limb2: 0x506ce69b47fc010f160a2201,
                    limb3: 0x881ef486dc4044d659e5de5
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x9407f45c036aae235b493751,
                    limb1: 0x767d413cfb9339c79d02dff1,
                    limb2: 0xc6f8fecd939225b83d995618,
                    limb3: 0xf21594633dce9c0738d74d3
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x3bad68707206244e9d3991f1,
                    limb1: 0xc84e6d9a1413bceb809cb4e6,
                    limb2: 0x914b57199bac96b99c0d332a,
                    limb3: 0x14b45594b6ad665bc441c31d
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x41dfe3f6728eeed7ecc85d12,
                    limb1: 0xf5f77c4f15c63882df79763b,
                    limb2: 0xa72e71d6a3bfe1966561399,
                    limb3: 0xabb2945ac99c5c63495d2ce
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x5b43acd58017acc4a63b3505,
                    limb1: 0xfddfd5b0d2051727d76da3aa,
                    limb2: 0x95acd12f6d3e361f0140d468,
                    limb3: 0x1e92de21a40468a97264791
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x5e7ed02b1f42137257453273,
                    limb1: 0x95d96e14eb9dd43665c95fe9,
                    limb2: 0x6307bb740c042f56aefc6fea,
                    limb3: 0xda3ee4f333b591faa882dfa
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xfe39c1b789999a90decf0f09,
                    limb1: 0x8dc07dd02d56c6467766ddcf,
                    limb2: 0x329688cdc8229733965a2d83,
                    limb3: 0x12e5db5152aa265926fc4dac
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x9f8474970cf6e6e95c3c109c,
                    limb1: 0xd73444a881bbb52e1702e08d,
                    limb2: 0xbef4f0e9329ca50a79059af8,
                    limb3: 0xbc2e7e96184d905fb5fb4fe
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x653a4594c5ab2347e198ee54,
                    limb1: 0x445fe1cef26cb1892b487627,
                    limb2: 0x1eaef67417b3ca463d4b6d88,
                    limb3: 0x125389fbfa1eb40602aab2fa
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x1f38bc2ebb410bbfb7ef22e9,
                    limb1: 0xb0409a6e7f4a1bc6311c8417,
                    limb2: 0x1b94e9b43511cf43a41721be,
                    limb3: 0x42eabe35795a9dea7090b8
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xe59d53576175989e7533a455,
                    limb1: 0xbd540c1db0e3fa51b5241538,
                    limb2: 0x181fae0115740b247263673c,
                    limb3: 0x171f74ea9529a2b38a718e37
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x8e458a33cc84c296a0d8c72b,
                    limb1: 0xf062877fd4e661fe7a0f0adc,
                    limb2: 0x1b54f7711632e8603fa2c3e4,
                    limb3: 0x8943cf00f7830d71ee5ffc4
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x511c6c88bcfcf326c006db24,
                    limb1: 0x985812828ec0839e3c2faeef,
                    limb2: 0xbea73f2f498f660f082ad896,
                    limb3: 0x11ac8cf5896805cfd907ab42
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xbcbc18b7de3baefc2bae51f7,
                    limb1: 0x28dd7e26efa6115ac2e103fd,
                    limb2: 0xdb28c4df3fb7249a60b53be3,
                    limb3: 0x5d0e9fa2301b9b726d84ce5
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x9ac1d5f7f2761e8ddab4d493,
                    limb1: 0xc2485c7d1f905ef177f7b2e9,
                    limb2: 0x78cc91c290701f53be7c266,
                    limb3: 0x3b93e610e12685e73efb959
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x4076e47a24c3c1502084e338,
                    limb1: 0xcb1dd2bfb81d4b84464db6a6,
                    limb2: 0xf953ec92844d6483db834a92,
                    limb3: 0x645abd74edcc4343a409216
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x49f5b94ace303dcb6613b212,
                    limb1: 0x363f280ea712ea860a3fd76e,
                    limb2: 0x792c6ee8b317e14c8bc91274,
                    limb3: 0xf295eb3a81ec029d1af5074
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xf72c635de564ae81658718eb,
                    limb1: 0xf8676d48845437966ee13cf,
                    limb2: 0xf0095c802036ed3028727a6c,
                    limb3: 0x3e3786f463dd93cc0a3e909
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x29ed64283bd4d622cb18ba3c,
                    limb1: 0xd402514a3036164d321d5089,
                    limb2: 0xdeb6e636ab85e4d4540a9fa2,
                    limb3: 0x974ffb491020f4fa0192fd5
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xc8527609d74700d339ca06b5,
                    limb1: 0x7c3f414a9e1363928f17bb65,
                    limb2: 0x37776bbde396b2a5c8e68d28,
                    limb3: 0xb5e20d3a7ddd69ee700422f
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x67f033aeaf87ea756b6d8eb6,
                    limb1: 0x9c3e915b5b65ec3bed65b1ee,
                    limb2: 0xa8a4627c5ee7ed437d1d47a9,
                    limb3: 0x63321077a370b5b019f1694
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x5153a2f6dfb4fb30f78f87f9,
                    limb1: 0x44d6e63bddc30e0aa88dd207,
                    limb2: 0x3977a81bc636c28845273bb,
                    limb3: 0x19fbed701aa63170441fc6f6
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xece158fa40b814a22ac813a2,
                    limb1: 0xaeb5cad01d1c4e45ee9344e5,
                    limb2: 0x9fc1b442bd494eddf129d71f,
                    limb3: 0x67e9f0b77adf6b8470d3d63
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xaffe08346327461f8c014555,
                    limb1: 0xff86f36c8bd2fe84327957bb,
                    limb2: 0x5a2d81db8758abe80e0e3cdb,
                    limb3: 0xfe1cbee0b19c2b6ebf764f1
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x2d717eacf5378b3f0a6607bb,
                    limb1: 0x3385fdddb9b5a9844888cbdd,
                    limb2: 0xce51293f61d0ef5793a9a781,
                    limb3: 0x18d3de75711ce0d54c5076e1
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x915975ca1719a6ed9aabbaa2,
                    limb1: 0xf12a1e2013aa2ae1485b7096,
                    limb2: 0xe264f672d109cbe9dcd6b96d,
                    limb3: 0xabefa2355b2034d0361678c
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x69f817ca1fca3c6585330d6d,
                    limb1: 0xa1f386e03712070755434551,
                    limb2: 0x7b969c0745c57c806a4e8682,
                    limb3: 0x2dfd8bd50e5a5c628aef399
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x857b3bf74266836421704594,
                    limb1: 0xfd94b29c0f4956d5d63317c0,
                    limb2: 0xac52e11061af64ac57487a98,
                    limb3: 0x72f954a8811ed1642dd09d1
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x82a9572f2fc9c52645e8909d,
                    limb1: 0xaf0b52afe0a9e3a771142bb2,
                    limb2: 0x73e91b2bc2c82cb909923534,
                    limb3: 0x577f7ae63c8de2ddd95d23d
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xb20458910fd0f54f10f4f012,
                    limb1: 0x4a1bd627bb383ea42cfd9c28,
                    limb2: 0xd7b467b1c44d0a615823880a,
                    limb3: 0x178b57a158651f9b9c6ee066
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x38404047724f2c0873023066,
                    limb1: 0x89e00fed50279a06ac07f4c,
                    limb2: 0x797a672b0b179efe2ee60ff9,
                    limb3: 0xc1c63c42a970f051f8097eb
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xa5b24f6818e585fcc5578e52,
                    limb1: 0x375cb24c9dbd88faffb457a0,
                    limb2: 0x39866e75f96cfc251ad5b178,
                    limb3: 0x10b6696f5b7a4fb43af83263
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xa4b7af6f1f9029864f4f8ee0,
                    limb1: 0x94ecbac7f3bad323c39fa56c,
                    limb2: 0x9a97b1254c32d84b4e8f821e,
                    limb3: 0xe619246ed2ffd581b2f49b6
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x5c49e8e4a2044655b1fdd8e,
                    limb1: 0xcbbdd96f8a564144ef39e484,
                    limb2: 0x2c94c5b289b3f02e303ec6bc,
                    limb3: 0x1959b3dd9bb67d03401544e8
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x546d775b650731c547edfe21,
                    limb1: 0xde3686a052f7ce13a3480b97,
                    limb2: 0x2ad0b08c8d526609dd251105,
                    limb3: 0x17ad881e6b19e72c412d7e91
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x631b088451abe52068f84f9c,
                    limb1: 0x2d881444c438e2d634e10ce9,
                    limb2: 0x42bd86cdda410e7b47bca953,
                    limb3: 0x739aa72b3118f5fc9609fa8
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xda391fc9e979eb70fb99912d,
                    limb1: 0x30f2e1deeebde794354a8e0c,
                    limb2: 0xad9c0aa2e7a7edaf98d48266,
                    limb3: 0x14f4d3b5feb72095a4417a1e
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xe2bc36d61b247374affb213f,
                    limb1: 0xaa7f7d1154d9852a5f1377c3,
                    limb2: 0x2a0738736f96e1efcaa7f126,
                    limb3: 0x1482ba5a35a99d375a87e5a7
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xe57046c08b6bb7493d9cfc46,
                    limb1: 0xe94d2a12899decb8f03cfa3c,
                    limb2: 0xe29ba20c938d087b2021171e,
                    limb3: 0x12ae978d3e3eede94c874c9e
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x3b9acddd886630dbc500f02d,
                    limb1: 0xf1d5c31a2c4ebb8974fb7453,
                    limb2: 0x88d4e2afac7c3fbc3d1c10c8,
                    limb3: 0x2cceb2efab2f2a2673e5c4b
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x28e9d510dc6218b9ccf3891,
                    limb1: 0x51179de1c1f9dbc8c58ba480,
                    limb2: 0xb06f93bd8fdd7c291e201ccf,
                    limb3: 0xfec7c7c3a3f81a4109b4d57
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x642b8140faaf6c14822c3907,
                    limb1: 0xfd612408f8ec3aee4d5315db,
                    limb2: 0x157671832941eda539c41718,
                    limb3: 0x60a4d1d8fcd35645bbe2eab
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xb4ed23c8a98526532e9174d8,
                    limb1: 0xe3adc0f4db1306ee974c4922,
                    limb2: 0xb2ab9081c3be6d478ebe10aa,
                    limb3: 0xb4b24a0c00b994516165674
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x468c79dcf09c247789fd6c63,
                    limb1: 0x4034abb1be332bb2dc7ac8b2,
                    limb2: 0xdf1671fcd1c1a3e4407d067b,
                    limb3: 0x3884094bd10947497ddbe11
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x6787e456ecca0f85bc3df62d,
                    limb1: 0xb503dd50f6df6743dc209459,
                    limb2: 0xe395368482abb1c7d42066eb,
                    limb3: 0x4f6103977ab03dcc1af8d52
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xd3afd6cae61ef417765a8ac1,
                    limb1: 0xe649797db06c6a87a7ff418c,
                    limb2: 0xda7adc446890d72e37e1fa81,
                    limb3: 0x12225638cd0d27eb57861ee2
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xe68435dbb95341376c13388,
                    limb1: 0xe7254adc96f5af705156571e,
                    limb2: 0xf381233b3614239778abcfdd,
                    limb3: 0x16f4cf28b6958770335c41c7
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xf7179d95321804c8693f2790,
                    limb1: 0x46c0866adb031b9ccd867669,
                    limb2: 0x9c31e22d0373ea654e26e334,
                    limb3: 0xaad672aab939f0371ba1526
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x9280c988bcf583e9f7f10718,
                    limb1: 0x79ab01549927991bebf92548,
                    limb2: 0xf72213b551c275b8505e0ecd,
                    limb3: 0xbfb538297ded5d4fc318276
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x1012884d986aae00de55285d,
                    limb1: 0x492baff3bbc6510397dd36f,
                    limb2: 0xcbc0b9f6a1d7e80fac6c66a3,
                    limb3: 0xb7cbe8e296bb01e2db11a90
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x32ad0cb1e718c0ba60e4dae6,
                    limb1: 0xd2040c450071d822413d5922,
                    limb2: 0x4ecd02c37f0827e9c9db2cb,
                    limb3: 0xa42025eddfba622925cdbe9
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x42e2d759230197c8cbdb0670,
                    limb1: 0x70c8de263c05e892c93ad75d,
                    limb2: 0xc32aba3953c7f36d84ad3b6,
                    limb3: 0x12ecf862aaba2d5cc28d24e4
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x148e1a16e1338305b151592,
                    limb1: 0xff4993ac56ed0a4461fff0e5,
                    limb2: 0xa8653dfabb224916eb10ce17,
                    limb3: 0x18b4a19e18f81355aa7aced5
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xb957a16034dd27290ce6432e,
                    limb1: 0x98f7ca371f17e2f44d73756a,
                    limb2: 0xf32eb69c0a71091a97c35112,
                    limb3: 0x6bb4573e02f8b4679212718
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x178729ea3a568f914fdeb680,
                    limb1: 0x5357c798a03eba8e31074a61,
                    limb2: 0xd1e37b0c5a8ccf03cfa38211,
                    limb3: 0x534c337015addc772281d94
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xa790f2e975858e51a0f4faab,
                    limb1: 0xba9720b63e63eff432751d,
                    limb2: 0xf97306bcdc5ffc52642afa37,
                    limb3: 0x16dfea61796acb56af212447
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xc761d8d238a8e4d6bc88054c,
                    limb1: 0xae347c1556b2950939fd0cb3,
                    limb2: 0x839faef7a22f85ed57f49cd4,
                    limb3: 0x233b900c67afa86163021b
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x7235d852f6379bcb0aca7cdd,
                    limb1: 0xdb2b147496912f2e5be71012,
                    limb2: 0xd393853940e88a6be206b138,
                    limb3: 0xbee8cce53b1738734c504bf
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xb7181b53ac6f8a632f93f777,
                    limb1: 0xc5395e4376ec1748f881a439,
                    limb2: 0x744664bd5b204ef48e3688a2,
                    limb3: 0xa14b2ab769ff970eb63fd35
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xa94e79f9c56f3df193e1053d,
                    limb1: 0x373cd77c3385ddbb6e3b77e3,
                    limb2: 0xe288dc2ea288f03204f01533,
                    limb3: 0x15320d0c2559f28219ed3917
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x4b1f7041de6689766f9e81e9,
                    limb1: 0x74c4272c6e5d3993993d52af,
                    limb2: 0x874f64b28a02edb1bfa15c31,
                    limb3: 0x725a7ff6b2184f7201f7139
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xe633e04cea42770e3294a131,
                    limb1: 0x145d0accf437c8d4bc718336,
                    limb2: 0xf695cb62a6f64a2d7d9b7687,
                    limb3: 0x192ce98868f09e0ffe5371ad
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xd61806f038ca1b3e0eb277c4,
                    limb1: 0xb831b5b5d671d5b0d83dbbae,
                    limb2: 0x67e55936926427625b00249f,
                    limb3: 0x3a7d516855a8cb6add6e406
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xfdd21317ae2a7e82af8f46e6,
                    limb1: 0x661954a9ac134d5fa75d4bbb,
                    limb2: 0xe16283dbf789352b2bd411db,
                    limb3: 0xab12ce087f3d28a37c1b428
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x87127816043933804d664c5e,
                    limb1: 0x21c59284d58f926c92bba284,
                    limb2: 0x730955b3a7878557b961ce1c,
                    limb3: 0x17935c7af82b82ca1b1b6945
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x3583b55c9b778aa7121bf48a,
                    limb1: 0xa11f0c2ff9b14020dda03a3b,
                    limb2: 0xc2e1c20fd36514e0845173e2,
                    limb3: 0x171e1ad064224f5613618bff
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x49a19f816f35ab50ed0f94d1,
                    limb1: 0x4bdc37497ac0db88250f1ec2,
                    limb2: 0xc4709fe6030b85384f342c1,
                    limb3: 0x11ce8fc4593f7dcfffb52f95
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0xe84e19832b7a2dda4a32ecab,
                    limb1: 0x4233c32d929a2c5d8fd4b5f8,
                    limb2: 0xb6ae5c48b2387f27814fdf36,
                    limb3: 0x508555519546cc0bed018c2
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x4f44d5481277812b26bfd77,
                    limb1: 0x316e0e043d2d9ea1273b038e,
                    limb2: 0xd149cd938069825bac1a8cc9,
                    limb3: 0x1551521cae837a82f96ba55d
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x47b434ed0bf443d7f6ecb094,
                    limb1: 0xf71e81f11bd6db13a68ba405,
                    limb2: 0x2daeb5d1608bf539051d171c,
                    limb3: 0x1887606d7b7678598eb39a0e
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x9f67e37624b49b5e78742239,
                    limb1: 0x72fee254a9bbf06863dbcab3,
                    limb2: 0x909855002e123899d8fa378e,
                    limb3: 0x148b238e3b0235b4b89a9081
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xb45a353fdb808b748481a730,
                    limb1: 0x5ea383496a3429b27a6f3a12,
                    limb2: 0xf1cd72bec5e077235c082aad,
                    limb3: 0x17ee14783b76c6ecda4d6fbd
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x2493bbf2d6fd8ba69438a5c1,
                    limb1: 0xa3d82f35540e557d515db229,
                    limb2: 0xc6d17bddb7bdc0d344b7ee1d,
                    limb3: 0x7f0a56229ce52a81700ee1f
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x62299fd7ed24f8d2f39294d5,
                    limb1: 0x5b17500a0b2c759d890a0fab,
                    limb2: 0x2c3fe37ab05c0e88eb77ec21,
                    limb3: 0xb8504d78f8f6141de4eda38
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x235cfcce45519e06477f138b,
                    limb1: 0xbf0454b21b98fb176e5e2601,
                    limb2: 0x7bc81ededd0d5bdb54418d98,
                    limb3: 0x37443c3ff68c59d5dcb7f20
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x4679b2d8847cabb26246c004,
                    limb1: 0x1f16bf6a43cf9c23aeaebe3,
                    limb2: 0x43175ab38f2496aea77ef1a9,
                    limb3: 0x162d8462c59204662e8c0c16
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x6d67c480725735b70f84bd20,
                    limb1: 0x82cde299395e12289fe3d0b1,
                    limb2: 0x5a33884e0edf49ff7998dd7c,
                    limb3: 0x43184dc88cbde2c21beb1d7
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x693dd0e8ad6baa319856181c,
                    limb1: 0xb970274d2bd9baafceb3a9eb,
                    limb2: 0x1c8669e0bd09b29daa8d3de2,
                    limb3: 0xd6523c8e50976a2535c4304
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xac4b4ed4dc8ede8483f2423d,
                    limb1: 0x9fe7db11ea5a3115f8256940,
                    limb2: 0x973a738a11a419bf23d3ecad,
                    limb3: 0xb3b8ece678de619a67803a5
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x6ed6b2296c5bf0b0fcf24f94,
                    limb1: 0x98877d021872aa864ba95591,
                    limb2: 0x39088adcf5db43fa3cbaf76b,
                    limb3: 0x3b9f0fcef0f27d234907712
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x33837d4f6f7ad2eb9af5b94e,
                    limb1: 0xfa5401358c8611753e9cb95d,
                    limb2: 0xc1bd15e8601adc6f72f9f206,
                    limb3: 0x873e1e28352d26864a421d5
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xa745cffbc56f8de91ca16d77,
                    limb1: 0xe570126397fee1d65bae4adb,
                    limb2: 0xb00ea6afed445941dc6a806b,
                    limb3: 0x11555b3a8f9793c19b65f817
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x7eff710eaf260f32fa8105f4,
                    limb1: 0x98c02e2915fc6058f529157e,
                    limb2: 0xc8b58a686658f99b28b59d45,
                    limb3: 0xb0c0b6aefe9e21fe001b882
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xf634280f19e2e507ed312e37,
                    limb1: 0xfba3f8b619acfb043349d2c3,
                    limb2: 0x8de64716173094574d2106f3,
                    limb3: 0x36269e5461c8cbf7fdeb2d1
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xf13eb1f7b1d60650561cb1ed,
                    limb1: 0xb07e64d5ef4775d406a2bc19,
                    limb2: 0x1a718a7b05ebd5e2259e22fb,
                    limb3: 0x13e355279437a52f2f707203
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x1e007b3fdfb6a3b832ba1d28,
                    limb1: 0xc4b1aaa7f3bea66152be8968,
                    limb2: 0xcfa883417d54a8aa3afcd69a,
                    limb3: 0x13017c5ecd2da88782096cc1
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x91518bdb21ec904691430bc8,
                    limb1: 0x4a05182bc818828b08c42fc,
                    limb2: 0x41fc2c04c91185474965d135,
                    limb3: 0xb46c272a8f47e00999b1ccc
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x1e294ee9eaf437a7f890c2ce,
                    limb1: 0x99c44a281122ec36b06b721,
                    limb2: 0x1656ef3d41c9d58230f103ad,
                    limb3: 0xbe15e49fb07cee2da6b5781
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x78c00ee91068a5865e778492,
                    limb1: 0x1a4599270b2c845560d9df66,
                    limb2: 0xf4409f90955d362347fdda67,
                    limb3: 0xd6ad6a6a0574fa7a3262bac
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xe53fb7ca0677bb63b858de88,
                    limb1: 0x8073ae404f9df17dfe6db84,
                    limb2: 0x59ed48e16359dce8308cc2d7,
                    limb3: 0x303c3c92efe275715ce2ad5
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xa521b74821a6446724f68cba,
                    limb1: 0xd073106b518da27722c4a33a,
                    limb2: 0xebf4ae49c43d6e0ef1ea4494,
                    limb3: 0x187f9802ab418f80c14d7c39
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x6d5f082afd8cc8858eb3cb4,
                    limb1: 0x2614b2681cb4c1a6a24cbccb,
                    limb2: 0xb27bd0d9d203c138dd21189a,
                    limb3: 0x17489e5f86a1eaf3732f5f10
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x5fc564709c0649c05cf55c88,
                    limb1: 0x64e48a37ad6cf48c2db98098,
                    limb2: 0x7ab53cfdcfbcabb0b046da,
                    limb3: 0xca1cd8cd9d85bf8a5855b84
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x8aeba0942cb7b25c179468a6,
                    limb1: 0x1c4efb5952d408a46bcb4509,
                    limb2: 0x891c9346886e13becf9a4f13,
                    limb3: 0x472a02b180810b6a31afbae
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xd3ee45bb81d4c3393abfeac2,
                    limb1: 0xd59ec894a632b0a6505dd14e,
                    limb2: 0xd75c057f3756646f9c10194c,
                    limb3: 0xd61de95ba16e380fbdd9a91
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xcfda37bf87e46a238b5c8f9e,
                    limb1: 0x352bc258eaf32797f28230f9,
                    limb2: 0xe7388937a79d9a1290acb086,
                    limb3: 0xcbb6f9f2f1bca9b9bf9087b
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x5d220ab1cd5c0589cd82cb93,
                    limb1: 0xea348e639199214ac8d0c3b7,
                    limb2: 0x68fabdd10af93c3e3239268a,
                    limb3: 0x18bc6c29d5cfa7424fa05e7b
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x3ef15cb02e282d0f50a82eee,
                    limb1: 0x5a7c8497bafe328fdf7aaf77,
                    limb2: 0x8420bcdd97b066571254b423,
                    limb3: 0x15268b8aa67d71e235eb5ea0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xf4b3917463717c3baef77d8a,
                    limb1: 0xfc06db872e78badf3f70f7d4,
                    limb2: 0x3993fafabbd44c79165c840a,
                    limb3: 0x904ddce5a9b473cba5a1c5f
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x72be3c089dc819097cdce4a8,
                    limb1: 0xc72e034b05586da9b352a7ec,
                    limb2: 0xe5458715f9b7cc99cc2c3d52,
                    limb3: 0x8576dfabe2b3cf304daf96
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x92269f6656a03d262f4756cd,
                    limb1: 0xbff0956e48cd844e71c5f03e,
                    limb2: 0xaac43eff6db31ba08a4d99cd,
                    limb3: 0x1335a854df15ae3885cb7443
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x7eafd8d2ccc93b707e99a95c,
                    limb1: 0x64806750e9569628f46aea4c,
                    limb2: 0xf6d3dc67dde3792acce1c00d,
                    limb3: 0xdf322205459a6ed9310d43
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x7e2066fae9d5f39ace185039,
                    limb1: 0xe751b83201ed0a8dd941b4fa,
                    limb2: 0xd5e340927039724310ee2a2a,
                    limb3: 0x60234c02850be012d9e8640
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x8b3487bf5ab5a56faa19db74,
                    limb1: 0xd2d94ad7d58ac8c194e2cc4f,
                    limb2: 0x606bff2096bcca64f4bfd83d,
                    limb3: 0x17268d60b4a300829f8cd2a0
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x19cac0d1ba21d67169ef6d17,
                    limb1: 0xc2f740612724f81cfe74a4c1,
                    limb2: 0xafdc1776b395750d6eb42e8,
                    limb3: 0x616a66066dc9f107e0b68ff
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x7afb78b82127b542ae96817e,
                    limb1: 0xda2010171412bea4fc3c4e31,
                    limb2: 0xba5d7a84fbe282e61bdee31c,
                    limb3: 0x9eed86a9d43914400b82f7d
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x4cbc09963178825f329be2e6,
                    limb1: 0xd6ac004f146092add5012f0e,
                    limb2: 0xe3c480721d9673772241205d,
                    limb3: 0x1830423a4a05e04050dee24c
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xb8a8a65137a94740325bc564,
                    limb1: 0xee98d8bc388c2a37c7ab05e,
                    limb2: 0x57a46c94691d28432445fe95,
                    limb3: 0x172142f98b963e3ddbfc761f
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xe891d18345f091e872092391,
                    limb1: 0xe33dc056fa0432d917ed27b,
                    limb2: 0x774d2a23ceb1280b531e53f4,
                    limb3: 0x1439e86cb11bb5de2665c558
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x2c78de5e7d4adda0f0933ecf,
                    limb1: 0x2bc4b8f4f0e93a63eb8b4dda,
                    limb2: 0x5bf62cbd0d4719ec5c99f52d,
                    limb3: 0x102889d4fe2de523533bf4e1
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x5b0e88188a2653e2400c8279,
                    limb1: 0x7c8533a8c808dac749c96565,
                    limb2: 0xa2254f0ae4ff25eb2b98d6e0,
                    limb3: 0xa355d7c852e4b43d5faa58a
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x7723e2bb04fc908d47d7f1c7,
                    limb1: 0x2e40337506a3e2b42245cec8,
                    limb2: 0xaa10c68c8c066a5a225fa299,
                    limb3: 0xe4d8e07a11082761fcbc83f
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0xadd1e0c8e996cce174b71576,
                    limb1: 0x29a50f17140566a44f94c2af,
                    limb2: 0xff8352cbb372b1eb02cb8c41,
                    limb3: 0x7f9e048e3f03bf8cca10283
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x9e107260d6392b32108499d7,
                    limb1: 0xbca5e6a1b65cee290ea2e0dc,
                    limb2: 0x32cc26d2b81190a0f81545ca,
                    limb3: 0x4126c74ee3d83d0d50cd0ac
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0x3c3ed0917d30462dbfd81d1c,
                    limb1: 0x87c9a714dc7850f837919cdc,
                    limb2: 0x801f87e36698d8c22f9c2d3b,
                    limb3: 0xe567ae0ab95220f3a1286af
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x3dbddfffcfa6cae77e04d4c8,
                    limb1: 0xa73700d626534f008affdcd5,
                    limb2: 0xc69d351752a9ab114731f83e,
                    limb3: 0x1be64a39d7235d2469d9052
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x1286515f9e68d08580f2251f,
                    limb1: 0x9bf97f95bc78337679c021a7,
                    limb2: 0xce312412ebcc8f0fa098ca30,
                    limb3: 0xb4e80f8d2c720a57b1920ab
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xaf796aeedfe149da29fc179e,
                    limb1: 0x1dbf94fb318fce85dc4608b7,
                    limb2: 0xe49179dae87d65c4569239c6,
                    limb3: 0x1449c7ea6350843e61a0fe02
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x81d9c07c4ee6048b011e75b6,
                    limb1: 0x4d9892def737017068f7cc73,
                    limb2: 0xd78bccc6f4dfc880089fa466,
                    limb3: 0xeb915fb2f10d64fef6673a9
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xb5ba525808d1e2066936232c,
                    limb1: 0x4f332b5bf2e5e8812f44af94,
                    limb2: 0x6f1432b9d1cc5db4e6d1264d,
                    limb3: 0x945498eb10d289654063832
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xbd089e6b7d9b31e76751e73e,
                    limb1: 0x26749b20457d8387407a75ed,
                    limb2: 0x788ade1ac3140af62c4bf176,
                    limb3: 0x183eb8b59ba1f5e612d7735
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x25b3709a0d2225726d5a7e81,
                    limb1: 0x761f909a06814e6abfcd853c,
                    limb2: 0x15049693c0b6a22cd7d39fed,
                    limb3: 0xbc8b5423b05cbba1a8e936f
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x9968707453f0cc9126edf9ac,
                    limb1: 0x98f7a79fa96079967f2b82cc,
                    limb2: 0x987e12497bc0b4d8b14addfb,
                    limb3: 0x153cd1194b73b1c00621476b
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0xb41721c3d0d89e27c297d8ef,
                    limb1: 0x42546e4520e69d079040323,
                    limb2: 0x4a9835d950d9b0b33de686ca,
                    limb3: 0xc7e6bb7336a1fe0c68f2357
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x35fd48c4d722d042b99c777a,
                    limb1: 0x25571de8b142eead678cff08,
                    limb2: 0xe337ecf529032cabe0b0402c,
                    limb3: 0xce7ea78517e8597f9b47144
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xc024e75a8d74d890a392418f,
                    limb1: 0xa57346677430502cedfa3e39,
                    limb2: 0x5d67f3d79756b62bb8095cd,
                    limb3: 0x16da9fb73cfd3c619749b821
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xdf3fa1704af5fc407d80b346,
                    limb1: 0xb6a9dadfd376664ab152c24a,
                    limb2: 0xe2d2e274623245d6a922de28,
                    limb3: 0x659f26eb73445f5370c586
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x49f51e908a980423aa482b5b,
                    limb1: 0x3305fd4fc24ecdcbcd8b8188,
                    limb2: 0xd0e702062c04b5667ede45db,
                    limb3: 0x19823b26406c57d7aceaad74
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x7a82586aec854da59430658a,
                    limb1: 0xea3c3901382c22d5c4fb2868,
                    limb2: 0xda20c163107402ac05f05e57,
                    limb3: 0x159c48c5e01b1e09037b7dea
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x811938eb84df6d339bd57a01,
                    limb1: 0x42c8cc983f44209d8199cc6c,
                    limb2: 0x4e8246622a1a1be68cae1f2c,
                    limb3: 0x90a3f2c567a4cd7c332b963
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x5ba8574195567bb14dfc33cb,
                    limb1: 0x677d5d2f6d2838115461f0a6,
                    limb2: 0x20eab3b9d8b890a67ab7a094,
                    limb3: 0x175a934afff7fa17011a26e0
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0xe341efbc6faddc6ce61709f3,
                    limb1: 0x751e9d05e330c33be1c92686,
                    limb2: 0x60dd8517756b167b88276a90,
                    limb3: 0x1259332b1eec99df91c861ab
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xd1073d25f6346654d3001a48,
                    limb1: 0xbf1add7f04a086670d4e98b0,
                    limb2: 0xda777b0ac79d1dcfcd8c6270,
                    limb3: 0x2fad0d784f8fe7f6e439ce9
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x5fdd490b7d044bc0a71ff44f,
                    limb1: 0x676fba42b7d7519e668243c1,
                    limb2: 0x79d30cf354556e543ffc6072,
                    limb3: 0x9f64dbacf91d9aa81650e56
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0x7b3bd6310e5282f3ae5c04df,
                    limb1: 0xcf03695c171417498f284fdf,
                    limb2: 0x7262b752702eeed61f22863e,
                    limb3: 0x8242d064c10f7ba37ae5d37
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x754aece2e556067f2735e36b,
                    limb1: 0x2bc71316dad433fb1e1f4e0f,
                    limb2: 0xe5ff4d7772dc537036d27923,
                    limb3: 0x192e035ecc0a858b339b0b3d
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 {
                    limb0: 0x3f9a152ab5992f0f59c1f22b,
                    limb1: 0x1f17a1075cb927f550c40f6d,
                    limb2: 0x72a8c469ee933afa25a09d83,
                    limb3: 0x1782eb8f7a4bf6753672fa63
                },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 {
                    limb0: 0x17d6952920a70cbb5e765787,
                    limb1: 0x35bc2882031df5ece99a9fa5,
                    limb2: 0x68db791f3256003910d0ff29,
                    limb3: 0xf9eaa6a753ac35f7c506e04
                },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 {
                    limb0: 0xdfef4f6ccd6e86cbcc4cfc1e,
                    limb1: 0x3fdb4ca1556fa96f3ab022fb,
                    limb2: 0x31d23dbbf5e82d44b0c6f309,
                    limb3: 0xd3b0f81ce1a9190973b6d9c
                },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 {
                    limb0: 0x12a35aa9ea93e60c4f28571a,
                    limb1: 0xbf0fbf346990f352020a97f5,
                    limb2: 0x72a37af4b0ac2201f23d7231,
                    limb3: 0xee405eb38689604f16482ae
                },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 {
                    limb0: 0xceb3ff4dbcbd0d81faced566,
                    limb1: 0x2097e105e078879b55c370ba,
                    limb2: 0xec926c3dcbe42d1c51b11692,
                    limb3: 0x9f4b3218717ae53c42a46d4
                },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 {
                    limb0: 0x5eaa15616641ef66551c1508,
                    limb1: 0x3995489365ce2f4d3303e8e0,
                    limb2: 0x2f4711952a5720458d2b1391,
                    limb3: 0xadb518f30b0635fe5a29682
                },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
            E12D {
                w0: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w2: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w3: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w4: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w5: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w6: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w7: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w8: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w9: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w10: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                w11: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
            },
        ];
        let big_Q: Array<u384> = array![
            u384 {
                limb0: 0x3497e44eddc04a346744554b,
                limb1: 0x64d714052e872090f07208ba,
                limb2: 0x24d0cbfc0f33284108defe6,
                limb3: 0x133670aecc7c524cdf1fe45d
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x87d8179c0b20e0b6af3a380c,
                limb1: 0x21ce91e80dda76d9ae5360f1,
                limb2: 0x8405a14f476c5a51036e8d4a,
                limb3: 0x12bc1cb7c858d61ff76ffee3
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x7de1ae7b2d3c4e0248a21f8a,
                limb1: 0x59140ad3d48d084d851c1883,
                limb2: 0x5a15ca4e4cd01317d984d8a5,
                limb3: 0x57c4faceca8d354c319aa46
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xcb67d018473475739df54956,
                limb1: 0x124a67786e8838a04a700c4b,
                limb2: 0xe709432ba9348fa03ad6eb69,
                limb3: 0x19370faf16ba2c4b26d8c269
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xcb7eeae9a90eb95470b1354c,
                limb1: 0x6ea9a300d4dea67e6a014829,
                limb2: 0x38e3d4038c0f8faff4983b7a,
                limb3: 0x10c4aeefec02b7094b34d90e
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x8ceb8b7f76b24bbc82fd4bb,
                limb1: 0x38b797177be4481acc6e8e45,
                limb2: 0x1e036e01120728ba6c463b67,
                limb3: 0xbfd3419d34b87d0efd33f16
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x7cf6c8c48cc0df94932655ff,
                limb1: 0xc97aad8acb666868b15a5d24,
                limb2: 0xd1bb8808b761ca830c4c8523,
                limb3: 0x196ed439449759d6d7c68fd1
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x2094641d08a6ba0b2ec50d52,
                limb1: 0x1a70a6bdb9664bd31841168,
                limb2: 0x9b672220921c2c9336c592b8,
                limb3: 0x109632783212450e86ce4e54
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xcf763dc827537c55184bea51,
                limb1: 0xe262925d7662ddb3fb2006a,
                limb2: 0xeadbe24b631a05dea93391c0,
                limb3: 0x36739a04d681778d5f5af9
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x2dac04afaa81fadf4b637ec2,
                limb1: 0xd4d1552f4bfda12e79de4e67,
                limb2: 0xc377e76ecf47650a909ad9dd,
                limb3: 0xb9dc77a19e11de199918415
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xb548bfba86859146d97c0616,
                limb1: 0x6b3d210eb5c2f1ea397546c,
                limb2: 0xa3a747389b28ef8cdc5954c,
                limb3: 0x189f360f6afce8cfdf009ede
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x47f0e1bff8e86de788f8d588,
                limb1: 0xaf7c35112ff9d3bdc47111ce,
                limb2: 0x5b34572ac94a4a7b6f7a6f9a,
                limb3: 0x17277a788f1773d05e2d879c
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x49c084de6b5918601424eda1,
                limb1: 0xa77631fe6e90395f3a5e5c81,
                limb2: 0x6e38d39c6507a378fc168a48,
                limb3: 0xfa3716cdf320568e07fb341
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xc5d0565785b602de82c86ebf,
                limb1: 0x45a37afa0eee8f8a12a7109c,
                limb2: 0x2e293ae599010fc76f9cd0d2,
                limb3: 0xf5407366f68e2aa73ba5d03
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xd04105551359744316f0fefe,
                limb1: 0x33eedfafbc678000892256d9,
                limb2: 0xdddc8e6415b69df068703e71,
                limb3: 0x12b1e5be1d7dba5b0f48a488
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xed3fe2a8b851c623a3811a60,
                limb1: 0xafd321598172205dcf1332fd,
                limb2: 0x2d2bb14f184c1e0504676e7e,
                limb3: 0x194dfff5fc8b1f885bd7a68c
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x6b7a796228006511361a8580,
                limb1: 0x5239fcad0743bced37b5022d,
                limb2: 0x3edcfda5cdb0afe03dc59ad9,
                limb3: 0x353e98ea26ab129f294caa1
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xebcced9ea86bded3698881a3,
                limb1: 0x3ec130dfee3eca980b0affbd,
                limb2: 0xa20aa395d21cb9d47729bde,
                limb3: 0x138defce40d40790f7fb9a92
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x2c293313b3999325cc58dc55,
                limb1: 0xa3b0023ed2ba723b8e88a30c,
                limb2: 0xb4bf533530c95a60a0d6f30,
                limb3: 0x81736b8bb6aee9425c219d3
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xe93613004816ac9e74130eaa,
                limb1: 0x7556de7572ca530e5ff52870,
                limb2: 0x6940919394986f883d2f7fb,
                limb3: 0x19cd3509b2ba0df2c7f35008
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x43551b30420496d3ee4e48e3,
                limb1: 0x8a0eee7c922cd789f2446fb3,
                limb2: 0x8473b6a20404d67ec9dfcba0,
                limb3: 0x4fab073b07f30de603407d6
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x4b83f895d259612ffccbcef9,
                limb1: 0xdae67ecd06e003b46a859391,
                limb2: 0x1f3eea417a0a3e2dd454b509,
                limb3: 0xc683b7c548e9ed8ef61e902
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xd14f57258bbaf5561145d04e,
                limb1: 0x3c28220ef51176c77e528309,
                limb2: 0xa088a9ed3bbf0a17c3306c8,
                limb3: 0x162695e6b053a3dcc75e5af5
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x39577b581bc0c7ef07bb2678,
                limb1: 0x98e9d664c2b1c49adee1c04,
                limb2: 0x1202f100717fa9146184fee4,
                limb3: 0x2f0309c24f5a5e1dadd6ef4
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x4b2587cfa06d260a92e72587,
                limb1: 0x74c78b9a962e52a3e5ecf815,
                limb2: 0x3c6227b54309c40ee709822,
                limb3: 0x4b0352a8b1a20a751e49689
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x11f9c43f1fdeac3e0d2dd532,
                limb1: 0x16c4e13d9a5fb5ec202f2917,
                limb2: 0x889ab3d7863354680beef4ee,
                limb3: 0xccb26e7cf0bbe987d53e093
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x552848ba2b68488dcddafb05,
                limb1: 0xd201a39e7538234e95b88650,
                limb2: 0xe1ea349bedcff33b92ccae7f,
                limb3: 0x167e73be8c5347f521621846
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x2b0e67e094190111d3c43135,
                limb1: 0xb37692d81541fb5af56fbfbe,
                limb2: 0x5c80dac640da121eaea36fbc,
                limb3: 0x65ebd2412eb675fb67623f9
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xa5473a6aee82bea3e049c548,
                limb1: 0xc86295e7cdd0de2b747c27c9,
                limb2: 0xe9e6ee7565eeb6e7c46ee633,
                limb3: 0x10a6101befb4688a83872c32
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x619192f2970ad1ec3ec5cc21,
                limb1: 0xa888fadf6abeaae7d722529e,
                limb2: 0x35b3c8c15cac3df45292c7fb,
                limb3: 0x1274258ef5bfe31327318612
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xb48c984ba6c29ccdc52e9f33,
                limb1: 0xdfd489c070c1e7d7c6f4b312,
                limb2: 0xc82792b7bf295686d2dc3633,
                limb3: 0x84e297d817bee1a3ee13188
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x966c98a3b5179e466b268f34,
                limb1: 0xfe0b16b2b0370f8a18675f6c,
                limb2: 0xc5e05e14464ca441975ee84,
                limb3: 0x13a6424cb0836b059c02de94
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xaadbd951ba766c30f17b0a9e,
                limb1: 0xb70a1d3a9401d7a1ca53dde9,
                limb2: 0x33b2809e60a60a17e0fd2bf3,
                limb3: 0x7c7ee41edc8f1261dcb8a8e
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0xeeef5309c2a1f298a88e97cf,
                limb1: 0xf9dc220d3b0b254b71391efc,
                limb2: 0x644765e719072fa219b55ab8,
                limb3: 0x135e6504f62686de4fbc6823
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x57c47b740f35170c4dd60b59,
                limb1: 0xcd416ced5a9596cd359ef5ec,
                limb2: 0x585908deac8369f1d2d7c122,
                limb3: 0x4981e9e99776199133e5d0f
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x7cb4fb2b0fb9f7bf5aa32e0,
                limb1: 0xef12a453ca754a19dd0be95d,
                limb2: 0xdf7053c9a9ec438ddc641fc1,
                limb3: 0x18708bd4a469d6a1ae478319
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x97fe5bc20c182cb3bc450759,
                limb1: 0x9522c3dcb3d556a9498b9d0a,
                limb2: 0xeb8fb5efa607e7f8cb9199c8,
                limb3: 0xc4c38beab7ce4b5100367a
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x9d04173b270f2fb8cc70293e,
                limb1: 0x82e6959bff029da36916f1fd,
                limb2: 0xdc5402aa602ffda7a39456ea,
                limb3: 0xaeb1e8afee40e5976daf1e2
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 {
                limb0: 0x117a967d67ca9a9842a0950,
                limb1: 0x2f2e8691da13159720968fde,
                limb2: 0xc9c1015c8b5010b146829ddf,
                limb3: 0xa25a87aa513e44e5e8c77f3
            },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        ];

        let res = multi_pairing_check_bls12_381_2_pairs(
            pair0, pair1, lambda_root_inverse, w, Ris.span(), big_Q
        );
        assert!(res);
    }
}
