#[cfg(test)]
mod tower_pairing_tests {
    use garaga::single_pairing_tower::{
        E12TOne, u384, G1Point, G2Point, E12T, miller_loop_bls12_381_tower, miller_loop_bn254_tower,
        final_exp_bls12_381_tower, final_exp_bn254_tower, expt_half_bls12_381_tower,
    };
    use garaga::ec_ops::{G1PointImpl};
    use garaga::ec_ops_g2::{G2PointImpl};
    use garaga::circuits::tower_circuits::{
        run_BN254_E12T_MUL_circuit, run_BLS12_381_E12T_MUL_circuit,
    };

    #[test]
    fn test_tower_pairing_BN254_1P() {
        let mut res: E12T = E12TOne::one();

        let p0: G1Point = G1Point {
            x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        };

        p0.assert_on_curve(0);
        let q0: G2Point = G2Point {
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
        };

        q0.assert_on_curve(0);
        let (tmp0) = miller_loop_bn254_tower(p0, q0);
        let (res) = run_BN254_E12T_MUL_circuit(tmp0, res);
        let final = final_exp_bn254_tower(res);
        assert_eq!(
            final,
            E12T {
                c0b0a0: u384 {
                    limb0: 0x898578b55e1f63739d870e95,
                    limb1: 0xda01bde280a3ed6f87e5feb,
                    limb2: 0x262b253feda94cfe,
                    limb3: 0x0,
                },
                c0b0a1: u384 {
                    limb0: 0x918ed66b49d34b48efb8a4a,
                    limb1: 0xa1b1f823879abbd397c4dea,
                    limb2: 0x2e02d2cc795a200,
                    limb3: 0x0,
                },
                c0b1a0: u384 {
                    limb0: 0x87ecb1fc4e135402fdbd1de0,
                    limb1: 0xa5b1ad44b31977935fd29573,
                    limb2: 0x13a9f2d6e29b128d,
                    limb3: 0x0,
                },
                c0b1a1: u384 {
                    limb0: 0x699ce630b130b08a6ea1162b,
                    limb1: 0x4b31984a74e68659c4b420bd,
                    limb2: 0x40ba9fa500f1a5c,
                    limb3: 0x0,
                },
                c0b2a0: u384 {
                    limb0: 0x211ce30bf5e3eeaef89eafdb,
                    limb1: 0xbe359d7f9873f052478f590b,
                    limb2: 0xafc2f3fd870678f,
                    limb3: 0x0,
                },
                c0b2a1: u384 {
                    limb0: 0xcc5a8243f9cddbd2d98dd1f0,
                    limb1: 0xbdc662d929e645cadda9a712,
                    limb2: 0x1c54a530398c9064,
                    limb3: 0x0,
                },
                c1b0a0: u384 {
                    limb0: 0xfd4b7aef5c0d58c5dc2429fe,
                    limb1: 0x23794a0d856f92591ba990ec,
                    limb2: 0x95c0fbf5d5a1ac0,
                    limb3: 0x0,
                },
                c1b0a1: u384 {
                    limb0: 0x590cb4a60f8215d4b99f2b4a,
                    limb1: 0xa31dc10f7b4053c9e9ad9ebb,
                    limb2: 0x14d3d6ca72d8a950,
                    limb3: 0x0,
                },
                c1b1a0: u384 {
                    limb0: 0x43c585fdfaf545838ca7429,
                    limb1: 0x89dc206b4b91c85759dc1a23,
                    limb2: 0x1dc0e7bbc3d70e66,
                    limb3: 0x0,
                },
                c1b1a1: u384 {
                    limb0: 0xac16cc1b7ab2cd3ed5e22b97,
                    limb1: 0x98a855ffc837d2a75ab90d61,
                    limb2: 0xb53320e5a6488cb,
                    limb3: 0x0,
                },
                c1b2a0: u384 {
                    limb0: 0xc42a9c0f9bd7fddaf5ebd723,
                    limb1: 0x6c91476ef36cd1d318ce07ba,
                    limb2: 0x13a8afd3085dae4c,
                    limb3: 0x0,
                },
                c1b2a1: u384 {
                    limb0: 0x43940c383e5314859e762c97,
                    limb1: 0xb601f3730a3afa965ceee1b3,
                    limb2: 0xf97b5221474526,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_tower_pairing_BN254_2P() {
        let mut res: E12T = E12TOne::one();

        let p0: G1Point = G1Point {
            x: u384 {
                limb0: 0xcdb6d03cb7b9a5409b7efcd8,
                limb1: 0xd1df87eab84852372b905c9c,
                limb2: 0x1d0634f3f21e7890,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xaa1d4f4d3021032564460978,
                limb1: 0xeb3f1d6ba3b10e2b53dc193b,
                limb2: 0x24c53532773dce26,
                limb3: 0x0,
            },
        };

        p0.assert_on_curve(0);
        let q0: G2Point = G2Point {
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
        };

        q0.assert_on_curve(0);
        let (tmp0) = miller_loop_bn254_tower(p0, q0);
        let (res) = run_BN254_E12T_MUL_circuit(tmp0, res);
        let p1: G1Point = G1Point {
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
        };

        p1.assert_on_curve(0);
        let q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x335eb0538f718d8e6651eeb1,
                limb1: 0x635e573808d9d5c7178bdce7,
                limb2: 0x1314aaf1c372e6d7,
                limb3: 0x0,
            },
            x1: u384 {
                limb0: 0x5289f29ccc5acf5e81526673,
                limb1: 0x2d4aba9e1448a8cc1048d01a,
                limb2: 0x14c25d3aec745e5a,
                limb3: 0x0,
            },
            y0: u384 {
                limb0: 0x10d1d0efd5869ecd23aab8e9,
                limb1: 0xba7d1de6d86501d49b6a8dab,
                limb2: 0x397391b7b25e2f,
                limb3: 0x0,
            },
            y1: u384 {
                limb0: 0x385a553ea12434f4eda6db36,
                limb1: 0xb058c1ff7e4c5c7ec7e5859b,
                limb2: 0x1863ac65eca09e89,
                limb3: 0x0,
            },
        };

        q1.assert_on_curve(0);
        let (tmp1) = miller_loop_bn254_tower(p1, q1);
        let (res) = run_BN254_E12T_MUL_circuit(tmp1, res);
        let final = final_exp_bn254_tower(res);
        assert_eq!(
            final,
            E12T {
                c0b0a0: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b0a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b1a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b1a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b2a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b2a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b0a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b0a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b1a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b1a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b2a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b2a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_tower_pairing_BN254_3P() {
        let mut res: E12T = E12TOne::one();

        let p0: G1Point = G1Point {
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
        };

        p0.assert_on_curve(0);
        let q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa30b422f34656d6c94e40be,
                limb1: 0x83069b5050fd7194c7e35d0c,
                limb2: 0xf0e8184945e8d34,
                limb3: 0x0,
            },
            x1: u384 {
                limb0: 0xde9079ee8fa5e15901dfef27,
                limb1: 0xdb602cf367841e5047ffab14,
                limb2: 0x1752c7b6b35af45,
                limb3: 0x0,
            },
            y0: u384 {
                limb0: 0x4dafbd7f615fd2aa9f5a0acc,
                limb1: 0x35c8bbffe201ffd56deb5dea,
                limb2: 0xa822a5ba029a283,
                limb3: 0x0,
            },
            y1: u384 {
                limb0: 0xec6d9e4fafec17b8404c0341,
                limb1: 0x17fe961ad4b8ee3bf2ade626,
                limb2: 0x1228147f83e3ea5,
                limb3: 0x0,
            },
        };

        q0.assert_on_curve(0);
        let (tmp0) = miller_loop_bn254_tower(p0, q0);
        let (res) = run_BN254_E12T_MUL_circuit(tmp0, res);
        let p1: G1Point = G1Point {
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
        };

        p1.assert_on_curve(0);
        let q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa30b422f34656d6c94e40be,
                limb1: 0x83069b5050fd7194c7e35d0c,
                limb2: 0xf0e8184945e8d34,
                limb3: 0x0,
            },
            x1: u384 {
                limb0: 0xde9079ee8fa5e15901dfef27,
                limb1: 0xdb602cf367841e5047ffab14,
                limb2: 0x1752c7b6b35af45,
                limb3: 0x0,
            },
            y0: u384 {
                limb0: 0x4dafbd7f615fd2aa9f5a0acc,
                limb1: 0x35c8bbffe201ffd56deb5dea,
                limb2: 0xa822a5ba029a283,
                limb3: 0x0,
            },
            y1: u384 {
                limb0: 0xec6d9e4fafec17b8404c0341,
                limb1: 0x17fe961ad4b8ee3bf2ade626,
                limb2: 0x1228147f83e3ea5,
                limb3: 0x0,
            },
        };

        q1.assert_on_curve(0);
        let (tmp1) = miller_loop_bn254_tower(p1, q1);
        let (res) = run_BN254_E12T_MUL_circuit(tmp1, res);
        let p2: G1Point = G1Point {
            x: u384 {
                limb0: 0x8dcb6db105ead17484cff544,
                limb1: 0x95151f1c65bf4c2e698b5634,
                limb2: 0xc83f07e39979c6a,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x38cf77eafd4a4fdd9e46575,
                limb1: 0x3cf1e428854a9a0e559814bc,
                limb2: 0x15571140da88fd37,
                limb3: 0x0,
            },
        };

        p2.assert_on_curve(0);
        let q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa30b422f34656d6c94e40be,
                limb1: 0x83069b5050fd7194c7e35d0c,
                limb2: 0xf0e8184945e8d34,
                limb3: 0x0,
            },
            x1: u384 {
                limb0: 0xde9079ee8fa5e15901dfef27,
                limb1: 0xdb602cf367841e5047ffab14,
                limb2: 0x1752c7b6b35af45,
                limb3: 0x0,
            },
            y0: u384 {
                limb0: 0x4dafbd7f615fd2aa9f5a0acc,
                limb1: 0x35c8bbffe201ffd56deb5dea,
                limb2: 0xa822a5ba029a283,
                limb3: 0x0,
            },
            y1: u384 {
                limb0: 0xec6d9e4fafec17b8404c0341,
                limb1: 0x17fe961ad4b8ee3bf2ade626,
                limb2: 0x1228147f83e3ea5,
                limb3: 0x0,
            },
        };

        q2.assert_on_curve(0);
        let (tmp2) = miller_loop_bn254_tower(p2, q2);
        let (res) = run_BN254_E12T_MUL_circuit(tmp2, res);
        let final = final_exp_bn254_tower(res);
        assert_eq!(
            final,
            E12T {
                c0b0a0: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b0a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b1a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b1a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b2a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b2a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b0a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b0a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b1a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b1a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b2a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b2a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_tower_pairing_BLS12_381_1P() {
        let mut res: E12T = E12TOne::one();

        let p0: G1Point = G1Point {
            x: u384 {
                limb0: 0xf97a1aeffb3af00adb22c6bb,
                limb1: 0xa14e3a3f171bac586c55e83f,
                limb2: 0x4fa9ac0fc3688c4f9774b905,
                limb3: 0x17f1d3a73197d7942695638c,
            },
            y: u384 {
                limb0: 0xa2888ae40caa232946c5e7e1,
                limb1: 0xdb18cb2c04b3edd03cc744,
                limb2: 0x741d8ae4fcf5e095d5d00af6,
                limb3: 0x8b3f481e3aaa0f1a09e30ed,
            },
        };

        p0.assert_on_curve(1);
        let q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa805bbefd48056c8c121bdb8,
                limb1: 0xb4510b647ae3d1770bac0326,
                limb2: 0x2dc51051c6e47ad4fa403b02,
                limb3: 0x24aa2b2f08f0a9126080527,
            },
            x1: u384 {
                limb0: 0x13945d57e5ac7d055d042b7e,
                limb1: 0xb5da61bbdc7f5049334cf112,
                limb2: 0x88274f65596bd0d09920b61a,
                limb3: 0x13e02b6052719f607dacd3a0,
            },
            y0: u384 {
                limb0: 0x3baca289e193548608b82801,
                limb1: 0x6d429a695160d12c923ac9cc,
                limb2: 0xda2e351aadfd9baa8cbdd3a7,
                limb3: 0xce5d527727d6e118cc9cdc6,
            },
            y1: u384 {
                limb0: 0x5cec1da1aaa9075ff05f79be,
                limb1: 0x267492ab572e99ab3f370d27,
                limb2: 0x2bc28b99cb3e287e85a763af,
                limb3: 0x606c4a02ea734cc32acd2b0,
            },
        };

        q0.assert_on_curve(1);
        let (tmp0) = miller_loop_bls12_381_tower(p0, q0);
        let (res) = run_BLS12_381_E12T_MUL_circuit(tmp0, res);
        let final = final_exp_bls12_381_tower(res);
        assert_eq!(
            final,
            E12T {
                c0b0a0: u384 {
                    limb0: 0x839c508a84305aaca1789b6,
                    limb1: 0x3dd8e90ce98db3e7b6d194f6,
                    limb2: 0x68d0d727272d441befa15c50,
                    limb3: 0x1250ebd871fc0a92a7b2d831,
                },
                c0b0a1: u384 {
                    limb0: 0x50439f1d59882a98eaa0170f,
                    limb1: 0xaf5af689452eafabf1a8943e,
                    limb2: 0xa532348868a84045483c92b7,
                    limb3: 0x89a1c5b46e5110b86750ec6,
                },
                c0b1a0: u384 {
                    limb0: 0x9396b38c881c4c849ec23e87,
                    limb1: 0x16da0e22a5031b54ddff5730,
                    limb2: 0x689ce34c0378a68e72a6b3b2,
                    limb3: 0x1368bb445c7c2d209703f239,
                },
                c0b1a1: u384 {
                    limb0: 0x579973b1315021ec3c19934f,
                    limb1: 0x7c90d8bd66065b1fffe51d7a,
                    limb2: 0x5a50512937e0794e1e65a761,
                    limb3: 0x193502b86edb8857c273fa07,
                },
                c0b2a0: u384 {
                    limb0: 0xbbaad8431dad1c1fb597aaa5,
                    limb1: 0x185203fcca589ac719c34dff,
                    limb2: 0x4dc4007cfbf2f8da752f7c74,
                    limb3: 0x1b2f522473d171391125ba8,
                },
                c0b2a1: u384 {
                    limb0: 0xa35c8ca78beae9624045b4b6,
                    limb1: 0x8061e55cceba478b23f7daca,
                    limb2: 0x7a45b84546da634b8f6be14a,
                    limb3: 0x18107154f25a764bd3c7993,
                },
                c1b0a0: u384 {
                    limb0: 0x86a8703e0f948226e47ee89d,
                    limb1: 0xdea54d43b2b73f2cbb12d583,
                    limb2: 0xc3d5a04dc88784fbb3d0b2db,
                    limb3: 0x19f26337d205fb469cd6bd15,
                },
                c1b0a1: u384 {
                    limb0: 0xff02f0b8102ae1c2d5d5ab1a,
                    limb1: 0xa7d2809d61bfe02e1bfd1b68,
                    limb2: 0xa771b6ffd5857baaf222eb95,
                    limb3: 0x6fba23eb7c5af0d9f80940c,
                },
                c1b1a0: u384 {
                    limb0: 0x1e32fac91b93b47333e2ba57,
                    limb1: 0x7d0d15ff7b984e8978ef4888,
                    limb2: 0x3b0b0ec5c81a93b330ee1a67,
                    limb3: 0x11b8b424cd48bf38fcef6808,
                },
                c1b1a1: u384 {
                    limb0: 0xa09ffdd9be2291a0c25a99a2,
                    limb1: 0x20c806ad360829107ba810c5,
                    limb2: 0x6ce5771cc6a0e9786ab59733,
                    limb3: 0x3350f55a7aefcd3c31b4fcb,
                },
                c1b2a0: u384 {
                    limb0: 0x66245cb9108f0242d0fe3ef,
                    limb1: 0x1c7cdba7b3872629a4fafc05,
                    limb2: 0x728ffd21a189e87935a95405,
                    limb3: 0x4c581234d086a9902249b64,
                },
                c1b2a1: u384 {
                    limb0: 0xafe47e1efde449383b676631,
                    limb1: 0xdeff686bfd6df543d48eaa24,
                    limb2: 0xd01a7ec73baca4d72ca93544,
                    limb3: 0xf41e58663bf08cf068672cb,
                },
            },
        );
    }


    #[test]
    fn test_tower_pairing_BLS12_381_2P() {
        let mut res: E12T = E12TOne::one();

        let p0: G1Point = G1Point {
            x: u384 {
                limb0: 0xfe174bb39be8658ef83c8c2d,
                limb1: 0xdb24ddec0e0c3b63d82efa81,
                limb2: 0xe360a80121d5ef96fd687003,
                limb3: 0x59d2a79bda5f8a941d4db9,
            },
            y: u384 {
                limb0: 0x7f68344f543e52fe891285a9,
                limb1: 0x6f6992be16bc35f88c471acf,
                limb2: 0xcebb5ee96e40a033f5d3b798,
                limb3: 0x2df47e8cdf189985d5085bd,
            },
        };

        p0.assert_on_curve(1);
        let q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0xa805bbefd48056c8c121bdb8,
                limb1: 0xb4510b647ae3d1770bac0326,
                limb2: 0x2dc51051c6e47ad4fa403b02,
                limb3: 0x24aa2b2f08f0a9126080527,
            },
            x1: u384 {
                limb0: 0x13945d57e5ac7d055d042b7e,
                limb1: 0xb5da61bbdc7f5049334cf112,
                limb2: 0x88274f65596bd0d09920b61a,
                limb3: 0x13e02b6052719f607dacd3a0,
            },
            y0: u384 {
                limb0: 0x3baca289e193548608b82801,
                limb1: 0x6d429a695160d12c923ac9cc,
                limb2: 0xda2e351aadfd9baa8cbdd3a7,
                limb3: 0xce5d527727d6e118cc9cdc6,
            },
            y1: u384 {
                limb0: 0x5cec1da1aaa9075ff05f79be,
                limb1: 0x267492ab572e99ab3f370d27,
                limb2: 0x2bc28b99cb3e287e85a763af,
                limb3: 0x606c4a02ea734cc32acd2b0,
            },
        };

        q0.assert_on_curve(1);
        let (tmp0) = miller_loop_bls12_381_tower(p0, q0);
        let (res) = run_BLS12_381_E12T_MUL_circuit(tmp0, res);
        let p1: G1Point = G1Point {
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
        };

        p1.assert_on_curve(1);
        let q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x3b3d3c305a70960906e6cb09,
                limb1: 0x40e5bf3ff02d81e98b75703a,
                limb2: 0x665a5fc010510bd690ddd7b5,
                limb3: 0x82dc9154807866eb0f36ccb,
            },
            x1: u384 {
                limb0: 0xe6709deb0dcf81d4285e5e60,
                limb1: 0xb4dcf956002c4efb974ffcee,
                limb2: 0x4a6ceebe6375a83dd242851b,
                limb3: 0xdd18d077ad5bd58dabb18d8,
            },
            y0: u384 {
                limb0: 0x61535fe1a90bae7e6692f9b0,
                limb1: 0xc91aa58105d3a281b2e84ddb,
                limb2: 0x197d3446652372ce5ef50e93,
                limb3: 0x4a468eb9e206b9833d8e8e2,
            },
            y1: u384 {
                limb0: 0x27115c334e82ed4be8da6c10,
                limb1: 0x194fa3bf769a2e5a52535277,
                limb2: 0x8be8992de81f47ae3341c590,
                limb3: 0x198fd0ab6249082bf7007d7e,
            },
        };

        q1.assert_on_curve(1);
        let (tmp1) = miller_loop_bls12_381_tower(p1, q1);
        let (res) = run_BLS12_381_E12T_MUL_circuit(tmp1, res);
        let final = final_exp_bls12_381_tower(res);
        assert_eq!(
            final,
            E12T {
                c0b0a0: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b0a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b1a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b1a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b2a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b2a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b0a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b0a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b1a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b1a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b2a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b2a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_tower_pairing_BLS12_381_3P() {
        let mut res: E12T = E12TOne::one();

        let p0: G1Point = G1Point {
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
        };

        p0.assert_on_curve(1);
        let q0: G2Point = G2Point {
            x0: u384 {
                limb0: 0x30d2fddc2fa171cdd4d31a55,
                limb1: 0x92fab4f255a20d09700542e5,
                limb2: 0x4d92a8c02d22b8cea4ff21ab,
                limb3: 0x120a838699abaae7ed948194,
            },
            x1: u384 {
                limb0: 0x51cd5fdc71cf4557ef606935,
                limb1: 0x92e1b13e2c93fc9957b17841,
                limb2: 0x6143a906b63b7f3476ad6819,
                limb3: 0x158186f6f2dd04cfa4e78547,
            },
            y0: u384 {
                limb0: 0x9f1c7dcdbe4574f05d0c093b,
                limb1: 0xcde395f3ee4e353cf25a2e21,
                limb2: 0x6a44c4a6d642c3dd98128703,
                limb3: 0x2bd32fdfe26d866771e2180,
            },
            y1: u384 {
                limb0: 0x7060005397ea11f7e9a26050,
                limb1: 0xeb8540654b533da9b594fc27,
                limb2: 0xfc83cf9d283b7231df1db3f9,
                limb3: 0x7ff9623d918ca12e0ff6cce,
            },
        };

        q0.assert_on_curve(1);
        let (tmp0) = miller_loop_bls12_381_tower(p0, q0);
        let (res) = run_BLS12_381_E12T_MUL_circuit(tmp0, res);
        let p1: G1Point = G1Point {
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
        };

        p1.assert_on_curve(1);
        let q1: G2Point = G2Point {
            x0: u384 {
                limb0: 0x30d2fddc2fa171cdd4d31a55,
                limb1: 0x92fab4f255a20d09700542e5,
                limb2: 0x4d92a8c02d22b8cea4ff21ab,
                limb3: 0x120a838699abaae7ed948194,
            },
            x1: u384 {
                limb0: 0x51cd5fdc71cf4557ef606935,
                limb1: 0x92e1b13e2c93fc9957b17841,
                limb2: 0x6143a906b63b7f3476ad6819,
                limb3: 0x158186f6f2dd04cfa4e78547,
            },
            y0: u384 {
                limb0: 0x9f1c7dcdbe4574f05d0c093b,
                limb1: 0xcde395f3ee4e353cf25a2e21,
                limb2: 0x6a44c4a6d642c3dd98128703,
                limb3: 0x2bd32fdfe26d866771e2180,
            },
            y1: u384 {
                limb0: 0x7060005397ea11f7e9a26050,
                limb1: 0xeb8540654b533da9b594fc27,
                limb2: 0xfc83cf9d283b7231df1db3f9,
                limb3: 0x7ff9623d918ca12e0ff6cce,
            },
        };

        q1.assert_on_curve(1);
        let (tmp1) = miller_loop_bls12_381_tower(p1, q1);
        let (res) = run_BLS12_381_E12T_MUL_circuit(tmp1, res);
        let p2: G1Point = G1Point {
            x: u384 {
                limb0: 0x6b2dbb412523879f8e3a96a0,
                limb1: 0x6daa411c3d8c33de611bc2fe,
                limb2: 0x38ff9a4921f13749974e4731,
                limb3: 0x2b2fcedd1d05f99449b4884,
            },
            y: u384 {
                limb0: 0x845744e5af99690d2a360ec2,
                limb1: 0x56b0c0147f0ee90a5c1b6e41,
                limb2: 0xdee769045aef4994aab4b4fc,
                limb3: 0x32b985c03cd5519d41d0cbb,
            },
        };

        p2.assert_on_curve(1);
        let q2: G2Point = G2Point {
            x0: u384 {
                limb0: 0x30d2fddc2fa171cdd4d31a55,
                limb1: 0x92fab4f255a20d09700542e5,
                limb2: 0x4d92a8c02d22b8cea4ff21ab,
                limb3: 0x120a838699abaae7ed948194,
            },
            x1: u384 {
                limb0: 0x51cd5fdc71cf4557ef606935,
                limb1: 0x92e1b13e2c93fc9957b17841,
                limb2: 0x6143a906b63b7f3476ad6819,
                limb3: 0x158186f6f2dd04cfa4e78547,
            },
            y0: u384 {
                limb0: 0x9f1c7dcdbe4574f05d0c093b,
                limb1: 0xcde395f3ee4e353cf25a2e21,
                limb2: 0x6a44c4a6d642c3dd98128703,
                limb3: 0x2bd32fdfe26d866771e2180,
            },
            y1: u384 {
                limb0: 0x7060005397ea11f7e9a26050,
                limb1: 0xeb8540654b533da9b594fc27,
                limb2: 0xfc83cf9d283b7231df1db3f9,
                limb3: 0x7ff9623d918ca12e0ff6cce,
            },
        };

        q2.assert_on_curve(1);
        let (tmp2) = miller_loop_bls12_381_tower(p2, q2);
        let (res) = run_BLS12_381_E12T_MUL_circuit(tmp2, res);
        let final = final_exp_bls12_381_tower(res);
        assert_eq!(
            final,
            E12T {
                c0b0a0: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b0a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b1a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b1a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b2a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c0b2a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b0a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b0a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b1a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b1a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b2a0: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                c1b2a1: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            },
        );
    }


    #[test]
    fn test_tower_final_exp_BN254() {
        let input = E12T {
            c0b0a0: u384 {
                limb0: 0x9558867f5ba91faf7a024204,
                limb1: 0x37ebdcd9e87a1613e443df78,
                limb2: 0x8e9dc4681332876,
                limb3: 0x0,
            },
            c0b0a1: u384 {
                limb0: 0xfb97d43588561712e8e5216a,
                limb1: 0x9a164106cf6a659eb4862b21,
                limb2: 0x967d0cae6f4590b,
                limb3: 0x0,
            },
            c0b1a0: u384 {
                limb0: 0xbad640fb19488dec4f65d4d9,
                limb1: 0xd9b8a714e61a441c12e0c8b2,
                limb2: 0x1521f387af19922a,
                limb3: 0x0,
            },
            c0b1a1: u384 {
                limb0: 0x19c78df48f4ff31e78de5857,
                limb1: 0x50f244556f25e2a25a921187,
                limb2: 0x28fcb26f9c6316b9,
                limb3: 0x0,
            },
            c0b2a0: u384 {
                limb0: 0xf77383c13458a748e9bb17bc,
                limb1: 0x71545a137a1d50068d723104,
                limb2: 0x215ddba6dd84f39e,
                limb3: 0x0,
            },
            c0b2a1: u384 {
                limb0: 0xce164dba0ff18e0242af9fc3,
                limb1: 0xea7e9d498c778ea6eb2083e6,
                limb2: 0x5f82a8f03983ca8,
                limb3: 0x0,
            },
            c1b0a0: u384 {
                limb0: 0x66194cb1d71037d1b83e90ec,
                limb1: 0xc8f8e3d0d3290a4cb5d32b16,
                limb2: 0x28045af9ab0c1681,
                limb3: 0x0,
            },
            c1b0a1: u384 {
                limb0: 0x7e5b1e7f9ca5499d004ae545,
                limb1: 0x55485822de1b372ad3fbf47a,
                limb2: 0x2ebce25e3e70f16a,
                limb3: 0x0,
            },
            c1b1a0: u384 {
                limb0: 0xded733e8b421eaeb534097ca,
                limb1: 0xeac1c14f30e9c5cc101fbccc,
                limb2: 0xe30658b9148624f,
                limb3: 0x0,
            },
            c1b1a1: u384 {
                limb0: 0xf7b0b7d2cda8056c3d15eef7,
                limb1: 0x8b0163c1cd9d2b7d247a8333,
                limb2: 0x5d67b7072ae2244,
                limb3: 0x0,
            },
            c1b2a0: u384 {
                limb0: 0x51ef1922fe43c49e149818d1,
                limb1: 0xff7b118e820865d6e005b860,
                limb2: 0x1f507980eece328b,
                limb3: 0x0,
            },
            c1b2a1: u384 {
                limb0: 0x8d1fd9b74d2b9deb1beb3711,
                limb1: 0x1ff39849b4e1357d4a84eb03,
                limb2: 0x154bc8ce8c25166a,
                limb3: 0x0,
            },
        };

        let res = final_exp_bn254_tower(input);
        assert_eq!(
            res,
            E12T {
                c0b0a0: u384 {
                    limb0: 0xdbc3eb4cffd298b3fa7d5a31,
                    limb1: 0x9c46ca08e6740e40f6588c03,
                    limb2: 0x1e656501517e97b6,
                    limb3: 0x0,
                },
                c0b0a1: u384 {
                    limb0: 0x5c5f9021ddc05b4e8e458180,
                    limb1: 0xfc9ac0db94ad84f883101197,
                    limb2: 0x10d35fc577ab954a,
                    limb3: 0x0,
                },
                c0b1a0: u384 {
                    limb0: 0x8338823c5e5ac5cd9c54b10c,
                    limb1: 0x1749d62236197afa5b52b1b2,
                    limb2: 0xc2fb8c574d4a2aa,
                    limb3: 0x0,
                },
                c0b1a1: u384 {
                    limb0: 0x3fed1e7b4d562acb92ab1a7c,
                    limb1: 0x215c21048e64e6366563b7bd,
                    limb2: 0x56befad9198c47f,
                    limb3: 0x0,
                },
                c0b2a0: u384 {
                    limb0: 0x2e357f74fb161fde82246aaf,
                    limb1: 0x30461114e53b7faeeabde969,
                    limb2: 0x160bd4f153a876cc,
                    limb3: 0x0,
                },
                c0b2a1: u384 {
                    limb0: 0x9953d9fc7152b696a117f008,
                    limb1: 0x3260659f2890ee7e7fef447,
                    limb2: 0x2c09cd97bcdf915f,
                    limb3: 0x0,
                },
                c1b0a0: u384 {
                    limb0: 0x68db7596dac15cee7f675e5b,
                    limb1: 0xd64fc7fa279a306f05a4f7bb,
                    limb2: 0x1badb5f4113cf175,
                    limb3: 0x0,
                },
                c1b0a1: u384 {
                    limb0: 0xd43446d44724e68a5d3e0ce0,
                    limb1: 0x1ad7eb734406471bac65ff96,
                    limb2: 0x15027bc7d1c7191b,
                    limb3: 0x0,
                },
                c1b1a0: u384 {
                    limb0: 0x75668ecaf7e92d7d38d72226,
                    limb1: 0x2f055eefa07fed95961aa90e,
                    limb2: 0x231ea84923202c33,
                    limb3: 0x0,
                },
                c1b1a1: u384 {
                    limb0: 0x5d2ac3131b5214c54a04b4ca,
                    limb1: 0x5a879571728f9d6a335a11b6,
                    limb2: 0x1a88b1de9b27f1fe,
                    limb3: 0x0,
                },
                c1b2a0: u384 {
                    limb0: 0x1c3137fb1e4efedec89693d5,
                    limb1: 0x90787e810e0d14fcd37605c5,
                    limb2: 0x27a6e50c674c3d45,
                    limb3: 0x0,
                },
                c1b2a1: u384 {
                    limb0: 0x36b1cc116e2ac5e8f8918e00,
                    limb1: 0xcb7e94a03ed3261502d9cf46,
                    limb2: 0xbec9af879f51f8,
                    limb3: 0x0,
                },
            },
        );
    }


    #[test]
    fn test_tower_final_exp_BLS12_381() {
        let input = E12T {
            c0b0a0: u384 {
                limb0: 0x4da5e709d4713d60c8a70639,
                limb1: 0x5ba91faf7a024204f7c1bd87,
                limb2: 0xe87a1613e443df789558867f,
                limb3: 0x474ee238133287637ebdcd9,
            },
            c0b0a1: u384 {
                limb0: 0xc17c627923c6612f48268673,
                limb1: 0xcca5a5a19e4d6e3c1846d424,
                limb2: 0xe8e5216afcbd04c340212ef7,
                limb3: 0x1690c564fb97d43588561712,
            },
            c0b1a0: u384 {
                limb0: 0xe6f4590b9a164106cf6a659e,
                limb1: 0x19488dec4f65d4d9259f4329,
                limb2: 0xe61a441c12e0c8b2bad640fb,
                limb3: 0xa90f9c3af19922ad9b8a714,
            },
            c0b1a1: u384 {
                limb0: 0x19c78df48f4ff31e78de5857,
                limb1: 0x50f244556f25e2a25a921187,
                limb2: 0xe9bb17bca3f2c9bf9c6316b9,
                limb3: 0x11ae4620f77383c13458a748,
            },
            c0b2a0: u384 {
                limb0: 0xdd84f39e71545a137a1d5006,
                limb1: 0xff18e0242af9fc385776e9a,
                limb2: 0x8c778ea6eb2083e6ce164dba,
                limb3: 0x2fc154703983ca8ea7e9d49,
            },
            c0b2a1: u384 {
                limb0: 0x3e70f16a55485822de1b372a,
                limb1: 0xb421eaeb534097cabaf3897a,
                limb2: 0x30e9c5cc101fbcccded733e8,
                limb3: 0x71832c59148624feac1c14f,
            },
            c1b0a0: u384 {
                limb0: 0xeece328bff7b118e820865d6,
                limb1: 0x4d2b9deb1beb37117d41e602,
                limb2: 0xb4e1357d4a84eb038d1fd9b7,
                limb3: 0xaa5e4678c25166a1ff39849,
            },
            c1b0a1: u384 {
                limb0: 0x8a5006c1ec188efbd080e66e,
                limb1: 0xcca74147f6be1f723405095c,
                limb2: 0x966e12778c1745a79a6a5f92,
                limb3: 0x2eea66d71eacd0549a3e80e,
            },
            c1b1a0: u384 {
                limb0: 0x6288e1a5cc45782198a6416d,
                limb1: 0x3dfabc08935ddd725129fb7c,
                limb2: 0x307bf3262f1205544a5308cc,
                limb3: 0x10e1c2b2fcd81b5d24bace4,
            },
            c1b1a1: u384 {
                limb0: 0xa81ad477fb3675b89cdeb3e6,
                limb1: 0x11af923d79fdef7c42930b33,
                limb2: 0xc1f254b8adc0da7a16febaa0,
                limb3: 0x4c91dc7e07405eb215663ab,
            },
            c1b2a0: u384 {
                limb0: 0x151665705b7c709acb175a5a,
                limb1: 0x1d878f9f9cdf5a865306f3f5,
                limb2: 0xa1515607964a870c7c879b74,
                limb3: 0x6179561d857010255d44936,
            },
            c1b2a1: u384 {
                limb0: 0xbb42e0b20426465e3e37952d,
                limb1: 0xb490b6081dfc83524562be7f,
                limb2: 0xcb69ca385f3f563838701a14,
                limb3: 0xda2ddc3552116dd2ba4b180,
            },
        };

        let res = final_exp_bls12_381_tower(input);
        assert_eq!(
            res,
            E12T {
                c0b0a0: u384 {
                    limb0: 0xc47661ee2c6ec195b6465492,
                    limb1: 0x6923c966026d1a5202d2547f,
                    limb2: 0x3ca333e30f3750a593c5dd62,
                    limb3: 0x16211c8f3af6c885d6e7aae7,
                },
                c0b0a1: u384 {
                    limb0: 0x18ef376237b7b85323d0d503,
                    limb1: 0x6e98bbb5ebf752814d657668,
                    limb2: 0xf72474b60f257f5566c184d6,
                    limb3: 0x6298b60c51ccfdaa550d764,
                },
                c0b1a0: u384 {
                    limb0: 0x348c2c399e7bd6de56256576,
                    limb1: 0xf4a77fefb18543958b97e185,
                    limb2: 0x5d0aab75be4368260e7d2ed9,
                    limb3: 0x158469853e297d165ee80a77,
                },
                c0b1a1: u384 {
                    limb0: 0x72f3c5aec1469c18e1fdbce1,
                    limb1: 0x51ddbb4388643f1a6efaf631,
                    limb2: 0x34f1e1e014398ac114bd5c0,
                    limb3: 0x10e831545a67da3f9fdf361a,
                },
                c0b2a0: u384 {
                    limb0: 0xf0e118cc2ee8a943979abc0c,
                    limb1: 0x6e7b8556c21ea7bb63547b6d,
                    limb2: 0x4479c64648fd5135f004569a,
                    limb3: 0x9c3267b433303abded9ab0,
                },
                c0b2a1: u384 {
                    limb0: 0xe5fa5528617a7773128a3a1f,
                    limb1: 0x6be496fac02353edcae1c79e,
                    limb2: 0x4f9bbd2d6d5199cbf179da1f,
                    limb3: 0x17f02c9ce45af7421efccde,
                },
                c1b0a0: u384 {
                    limb0: 0xd2192367be40c767eecd94f0,
                    limb1: 0x5a094323a3c2b121fc6db025,
                    limb2: 0xe70f56b994092e1f7d106f54,
                    limb3: 0x12ac5958b941614ac10d5ff6,
                },
                c1b0a1: u384 {
                    limb0: 0x96dcae9f5d11d83ff8ee58e0,
                    limb1: 0x1539f36298c543196ff7521,
                    limb2: 0xf4f41990abca0c681a3221f6,
                    limb3: 0x11aa8e62757ec2cbf6c16ffc,
                },
                c1b1a0: u384 {
                    limb0: 0xffb243b8fb10435f6ea824db,
                    limb1: 0x1bda384d4058fd317cf9270f,
                    limb2: 0x3f176c05329fa1b37897428a,
                    limb3: 0x9ffc940d1185cb35015aa48,
                },
                c1b1a1: u384 {
                    limb0: 0x74d71b12604949416f2e7fad,
                    limb1: 0x84b612cd1cafbc9b8af3e707,
                    limb2: 0xe4855dd3d16e5ae18223225e,
                    limb3: 0x801946300201b84e305ee6,
                },
                c1b2a0: u384 {
                    limb0: 0xbb3b943ceffbff6187a09c3a,
                    limb1: 0x8c71050ce550d5e89695deb2,
                    limb2: 0x2fd70aa73c133a3e0e483ef2,
                    limb3: 0x7f835c51a9434870d20cedf,
                },
                c1b2a1: u384 {
                    limb0: 0xcb5beb0bdcff8c233260205d,
                    limb1: 0x987fe621d66e1a6dca01005b,
                    limb2: 0xf19f8ff647ec05851ed472a9,
                    limb3: 0x9f783e3dcba8af017c07469,
                },
            },
        );
    }


    #[test]
    fn test_expt_half_BLS12_381() {
        let input = E12T {
            c0b0a0: u384 {
                limb0: 0xe3ac2758b1f2a23159402205,
                limb1: 0x776adf14829933202da5751a,
                limb2: 0x5bace5b80e293dd7b75ca30d,
                limb3: 0x275df6cfc4cc34ee2e1426f,
            },
            c0b0a1: u384 {
                limb0: 0x6a1a0fac0380ab822cb9f49,
                limb1: 0xf1a5da70f2bcb8f5e6d189b5,
                limb2: 0xb9605d6164ac88b2e58734aa,
                limb3: 0x6178fc2e2d96839d3ccabe6,
            },
            c0b1a0: u384 {
                limb0: 0xb343ef57150681832154ce9e,
                limb1: 0x32d7b542146ded07806e3543,
                limb2: 0xf0531ecdf071f340be23eb71,
                limb3: 0x17bfe8e4c08234e0c2e85f61,
            },
            c0b1a1: u384 {
                limb0: 0x6a48ae9e0d45a65b46b124f0,
                limb1: 0x22c3a45726890fc3e75712b9,
                limb2: 0xa3e43a38db3ee9b2759e745f,
                limb3: 0xb509ee1722d55991cbc266e,
            },
            c0b2a0: u384 {
                limb0: 0x3e65e1d198488c5b45547fde,
                limb1: 0x32b590108b32373abcc44192,
                limb2: 0xb6c8b2c2cacad9bd22b87f0b,
                limb3: 0x17341bebcfb46b3919e1140c,
            },
            c0b2a1: u384 {
                limb0: 0xb9cab821cbd975c0ffdc67c8,
                limb1: 0x844bfef770ab7fc0ff7c585e,
                limb2: 0xc34fb405e0719e218adf4cda,
                limb3: 0xb7d87719c2bab9241194b3d,
            },
            c1b0a0: u384 {
                limb0: 0xc8de1b0b73c9757d8479766c,
                limb1: 0xa5f030312159f381a92d1668,
                limb2: 0x808b453867425d4ce92ab0ca,
                limb3: 0xc98aa88897c0c6b2edc28db,
            },
            c1b0a1: u384 {
                limb0: 0xb264c3a73b8175a6ee83c940,
                limb1: 0x6a26e058e811ef6ad4df2948,
                limb2: 0xb39592c43801e887c11cb17a,
                limb3: 0xe67f58b04c48f601737c58c,
            },
            c1b1a0: u384 {
                limb0: 0x4616073a64ebfc2e37d002b4,
                limb1: 0xbcedb779f425f193e5a05990,
                limb2: 0x3004f59b738b8cf2dacd9d,
                limb3: 0x18510173ebccf15dcfb67bb4,
            },
            c1b1a1: u384 {
                limb0: 0x68785e9d2a8c1f3cd22b74c9,
                limb1: 0xc13aa5c90a3964b3118e07ee,
                limb2: 0xdd71679943a514616d96a409,
                limb3: 0x5e9a73cd8bcc623956a00f0,
            },
            c1b2a0: u384 {
                limb0: 0xd054b25067025ef528684ca5,
                limb1: 0xb98b233f22590428ff65e7e7,
                limb2: 0x863f94e6f59dd2cc1b29aa15,
                limb3: 0x40a30f80f41371306ace4d3,
            },
            c1b2a1: u384 {
                limb0: 0x82ff7f662c94e86e681d04bc,
                limb1: 0x68fbbcb98776e529c74002eb,
                limb2: 0xabac2de4cc82c3c718a21a75,
                limb3: 0x8f53b1c2901726845866899,
            },
        };

        let (res) = expt_half_bls12_381_tower(input);
        assert_eq!(
            res,
            E12T {
                c0b0a0: u384 {
                    limb0: 0x931e7dfdbe1f652c188eaa4b,
                    limb1: 0x82aaa351edc988786951ca9a,
                    limb2: 0x54412c1075ce2746c44fbaaa,
                    limb3: 0x194d674d95de505092e97747,
                },
                c0b0a1: u384 {
                    limb0: 0xb22a60296aec52df8de3aa42,
                    limb1: 0x8be8af04ee32ae90e6f92ff0,
                    limb2: 0xdb264c1d022ccaa31f5f1e55,
                    limb3: 0x13c2c104d8418aa6c186c863,
                },
                c0b1a0: u384 {
                    limb0: 0xf16f15e433e53d884ca450ae,
                    limb1: 0xbab8e1a90f84f24c7d8d7bb7,
                    limb2: 0x7c33ac5908cc4d224c8cb672,
                    limb3: 0x11c649a221098f0592d9e573,
                },
                c0b1a1: u384 {
                    limb0: 0xa4ab60885ce8a47203eef11b,
                    limb1: 0x3de6b25ed023824c36351f47,
                    limb2: 0x257f17e0eeb3654697159a62,
                    limb3: 0xc742afcd12178eb714c25e4,
                },
                c0b2a0: u384 {
                    limb0: 0x2db3c373e66b30e10f9f9d45,
                    limb1: 0x92e88c066844966e118c3c8d,
                    limb2: 0x16fd097082cf86fa0ee9b179,
                    limb3: 0x5c0754baecbd25ec3c53996,
                },
                c0b2a1: u384 {
                    limb0: 0x21f88494e25abb2762bde18a,
                    limb1: 0x23a58e293f380741a2997a6f,
                    limb2: 0x76ea54dc279a3301a304e3e8,
                    limb3: 0x9f6038c6be05423ebd3e178,
                },
                c1b0a0: u384 {
                    limb0: 0x18a242496526b14c50bed73d,
                    limb1: 0xc27c41f74df1b94a3b251ca4,
                    limb2: 0x147ca1df5c1a39cd188fe196,
                    limb3: 0x3a62857263f7afc342bdfee,
                },
                c1b0a1: u384 {
                    limb0: 0x357719d10ab8c0520084939d,
                    limb1: 0x50cfb756fa9f6a5b5a853d6d,
                    limb2: 0xcc89f28f2729e44b3d552e9b,
                    limb3: 0xb4601ced0c45e2775128a73,
                },
                c1b1a0: u384 {
                    limb0: 0xba340a1342aeb93bc2367f71,
                    limb1: 0x1130eb422f714c3af0319aba,
                    limb2: 0x5411d9cdd1e37a8eb4a23883,
                    limb3: 0x58ca7e22399842e52f7e7ac,
                },
                c1b1a1: u384 {
                    limb0: 0xd91a1802a0ad0f168e57d558,
                    limb1: 0x3bb71c240214073cb08bb41f,
                    limb2: 0xc5406201fb75fb66ae611a4d,
                    limb3: 0x189532247da029ae9a0264af,
                },
                c1b2a0: u384 {
                    limb0: 0xe850c7a5f139c398a432d6e3,
                    limb1: 0xece47d0aaef590d0e590a168,
                    limb2: 0xd480c1d152ba8c62fc7ca716,
                    limb3: 0xa0f18b8c690d4e3461ee05a,
                },
                c1b2a1: u384 {
                    limb0: 0x76c2ba1ef05a96b90f9fdeb1,
                    limb1: 0xf777cac315947753c4e6f4a9,
                    limb2: 0x601635ad906b95586d6c73f9,
                    limb3: 0x90e534b3e561c1a32ac874c,
                },
            },
        );
    }
}
