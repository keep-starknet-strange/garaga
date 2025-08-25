use garaga::core::circuit::u288IntoCircuitInputValue;
use garaga::definitions::{G1Point, u384};
use garaga::ec_ops::msm_g1;

#[test]
#[ignore]
fn test_msm_BN254_1P() {
    let mut data = array![
        0x1, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0, 0x1,
        0xb4862b21fb97d43588561712e8e5216a, 0x967d0cae6f4590b9a164106cf6a659e, 0x0,
        0xa9f0001b3fc543c76e78dbe5, 0x59d3efe5fc893f110337f203, 0x2a3c4edaf4eb5933, 0x0,
        0x47c7d40af526b19cd3c8e9d6, 0x77e086d9ab1747415c8a345, 0x2ecf62cd2d14d49c, 0x0,
        0x10000000000000000358f1af3ace11fdc, 0x100000000000000004ac9542b22967d33,
        0x100000000000000000cf05f964742cc6d, 0x1000000000000000081d342cffb91cba7,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xa9f0001b3fc543c76e78dbe5,
                limb1: 0x59d3efe5fc893f110337f203,
                limb2: 0x2a3c4edaf4eb5933,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x47c7d40af526b19cd3c8e9d6,
                limb1: 0x77e086d9ab1747415c8a345,
                limb2: 0x2ecf62cd2d14d49c,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BN254_2P() {
    let mut data = array![
        0x2, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0,
        0x536c985db33c69f7c242e07a, 0xfc531bccffafcf1e59d91fb9, 0x2585e4f8a31664cb, 0x0,
        0x57fa42444057cf0c1d62ae3c, 0x4f48d341183118d68ea41313, 0x1d2d2799db056ed1, 0x0, 0x2,
        0x12e0c8b2bad640fb19488dec4f65d4d9, 0x1521f387af19922ad9b8a714e61a441c,
        0x5a92118719c78df48f4ff31e78de5857, 0x28fcb26f9c6316b950f244556f25e2a2, 0x0,
        0x3e478e7543d16c51c9284bef, 0xc686c1c872c6e2c5037128b3, 0x199c5e1c0cdf53c8, 0x0,
        0xf388e0c9512c46adb6327d02, 0xfeecfb56cfd9a1509392beb3, 0x2ccad398d3b28843, 0x0,
        0x9be5263ddc8a3746, 0x3b9c1e56ffcfcc82, 0x1000000000000000041c754da808c6d02,
        0x277449c3e218531f, 0x5211712cf983c9bb37a437a3, 0x3c9da9e18a4323d2ed3b9bcb,
        0x135de21f5341b7ec, 0x0, 0x3c22df03e388c6cea0664c2b, 0xc1036691dedbab22e63b1e2a,
        0x104e399500d777b8, 0x0, 0x100000000000000005fcd1b724f1296a6,
        0x1000000000000000016e3236cbd22722f, 0x4dac40f4f32b51f2,
        0x1000000000000000000417aa85f133ffd,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x9234d7617541ef6bd6a55e9e,
                limb1: 0x7a1353bb00de9de1d818c849,
                limb2: 0x21e43e4fdf41dbf4,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x30dd41ab3aae480eb7924f99,
                limb1: 0xa94c0b54f99635a912b59f0f,
                limb2: 0x187498a467804f5b,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BN254_3P() {
    let mut data = array![
        0x3, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0,
        0x536c985db33c69f7c242e07a, 0xfc531bccffafcf1e59d91fb9, 0x2585e4f8a31664cb, 0x0,
        0x57fa42444057cf0c1d62ae3c, 0x4f48d341183118d68ea41313, 0x1d2d2799db056ed1, 0x0,
        0x236ca9312dad3661a37f2d6f, 0x98424c01caad7592315715d1, 0x795b9fd941b23c4, 0x0,
        0xc7ab5834609a54b8993ffd79, 0xe81cd490528b814ca632aace, 0x2d9ff53d3009e6f7, 0x0, 0x3,
        0x5a92118719c78df48f4ff31e78de5857, 0x28fcb26f9c6316b950f244556f25e2a2,
        0x8d723104f77383c13458a748e9bb17bc, 0x215ddba6dd84f39e71545a137a1d5006,
        0xeb2083e6ce164dba0ff18e0242af9fc3, 0x5f82a8f03983ca8ea7e9d498c778ea6, 0x0,
        0xeb6c64e1541feb4cd5958beb, 0x69953b682ac9e3bef74198ea, 0xf357da3c551bd01, 0x0,
        0x8cf96097b6703380dee48cfa, 0xaf4c872e1b6551bf875c946f, 0x30549c20b1c1e0ff, 0x0,
        0x100000000000000005fcd1b724f1296a6, 0x1000000000000000016e3236cbd22722f,
        0x4dac40f4f32b51f2, 0x1000000000000000000417aa85f133ffd, 0x71c5aa9b358faf4569aead5,
        0x5b16db715ec2839da79801db, 0x33ab1528e0d2ba4, 0x0, 0x1d4cf315732c8bfaf74e675a,
        0x81e4a39e6f6fca6f89cc94f0, 0x2939221afe7a9318, 0x0, 0x100000000000000001ab0231e3f1af32b,
        0x1f1689eda0b7325, 0x8211c744ee497946, 0x100000000000000001401005296ba5335,
        0x9f30216b591e9f34501cf268, 0x7aebbd8d9c7bedb729aab01f, 0x16413acc47520c69, 0x0,
        0x596a902a02766a7777a12a86, 0xcd89979d5d539a6d7dfb9208, 0x12c9d036ab478f21, 0x0,
        0x257275fdb7e6a5fd, 0x437a0a16546be43f, 0x100000000000000001e20dc33694e8500,
        0x4c004b142b3cda1a,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xa505aa539534e1ed3825e1d3,
                limb1: 0xd3d6e50ccbd336be810ae134,
                limb2: 0x2b8806194c015dab,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xe3066db5d6cc9577162aa35c,
                limb1: 0x3ab20c13b3f5fdea9441aaa8,
                limb2: 0xc21ee843d06bdd4,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BN254_4P() {
    let mut data = array![
        0x4, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0,
        0x536c985db33c69f7c242e07a, 0xfc531bccffafcf1e59d91fb9, 0x2585e4f8a31664cb, 0x0,
        0x57fa42444057cf0c1d62ae3c, 0x4f48d341183118d68ea41313, 0x1d2d2799db056ed1, 0x0,
        0x236ca9312dad3661a37f2d6f, 0x98424c01caad7592315715d1, 0x795b9fd941b23c4, 0x0,
        0xc7ab5834609a54b8993ffd79, 0xe81cd490528b814ca632aace, 0x2d9ff53d3009e6f7, 0x0,
        0x163df40cafbf585ca5b2ab44, 0xb4752e4666c88dbbe23783a0, 0x1a801462ac9cb657, 0x0,
        0xac9b557d7ca8625d957263c6, 0xdc6f75fa8339a78b998ae54a, 0x28683293b6494d9f, 0x0, 0x4,
        0x8d723104f77383c13458a748e9bb17bc, 0x215ddba6dd84f39e71545a137a1d5006,
        0xeb2083e6ce164dba0ff18e0242af9fc3, 0x5f82a8f03983ca8ea7e9d498c778ea6,
        0xb5d32b1666194cb1d71037d1b83e90ec, 0x28045af9ab0c1681c8f8e3d0d3290a4c,
        0xd3fbf47a7e5b1e7f9ca5499d004ae545, 0x2ebce25e3e70f16a55485822de1b372a, 0x0,
        0x6cb501b0f2f9a414f1369408, 0x6ca7b1f397dfefc2369e7f77, 0x135eb18352681cd0, 0x0,
        0xbddf987b8ac91c298eae5fb6, 0x9c1baec61cca6ff8093200df, 0x1db47142bcb9084e, 0x0,
        0x100000000000000001ab0231e3f1af32b, 0x1f1689eda0b7325, 0x8211c744ee497946,
        0x100000000000000001401005296ba5335, 0x975b5f57e34be656906b1316, 0x4365ddb9eb3fb542f4a81fa5,
        0x1e4b71ab4bb74438, 0x0, 0x661840b85c4650ab80d6abfc, 0x6bedd43f4682513b3f26e3b9,
        0x1bfbc09bedc6e6a1, 0x0, 0x257275fdb7e6a5fd, 0x437a0a16546be43f,
        0x100000000000000001e20dc33694e8500, 0x4c004b142b3cda1a, 0x15e4e2a08ec22ffe7c9bb956,
        0x50cedfd39b0f587f62445c96, 0xbfefc101da6032d, 0x0, 0x626cafb2e14919812dc11374,
        0xd8702613e26c1c5acbb0502a, 0xac9c3b014f6663, 0x0, 0x1000000000000000001067d48d1582ff7,
        0x35ded9055ac1fce, 0x100000000000000009f949519947d21c6, 0x1000000000000000008e3b423119eedaf,
        0xfa187fa0605efdbcf49ce5e0, 0x9bba09b74197b6f6a0c7d548, 0x15f5043298d09f8f, 0x0,
        0x69bb1bf803d830390621ff4b, 0xeab9213022b9471b2f5ffb27, 0x20e0ff3bce0d13ab, 0x0,
        0x6d0d75af97fefa50, 0x1000000000000000021d60bf2c3658c74,
        0x1000000000000000034f51fecbdff851a, 0x1000000000000000002c54143b4f61e7f,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xda530556c75d2e27b35e716b,
                limb1: 0xe263c10943a7c230d41bb940,
                limb2: 0x1d051a29c6a2eafe,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x679ed4b58350eefe8c88ae2a,
                limb1: 0x46b4e4ba8a6a9374a0120664,
                limb2: 0x121c2c711b7c7f40,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BN254_10P() {
    let mut data = array![
        0xa, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0,
        0x536c985db33c69f7c242e07a, 0xfc531bccffafcf1e59d91fb9, 0x2585e4f8a31664cb, 0x0,
        0x57fa42444057cf0c1d62ae3c, 0x4f48d341183118d68ea41313, 0x1d2d2799db056ed1, 0x0,
        0x236ca9312dad3661a37f2d6f, 0x98424c01caad7592315715d1, 0x795b9fd941b23c4, 0x0,
        0xc7ab5834609a54b8993ffd79, 0xe81cd490528b814ca632aace, 0x2d9ff53d3009e6f7, 0x0,
        0x163df40cafbf585ca5b2ab44, 0xb4752e4666c88dbbe23783a0, 0x1a801462ac9cb657, 0x0,
        0xac9b557d7ca8625d957263c6, 0xdc6f75fa8339a78b998ae54a, 0x28683293b6494d9f, 0x0,
        0x5c4f5dca0c973b7f70bfff9, 0x188c2afab11eef5d48ecda3c, 0xc2fed35d36c49f1, 0x0,
        0x9d7244ea10697ca42e2e066b, 0xfe18a519c7d68770dc48dbf9, 0x149bb528db998529, 0x0,
        0xffc057151b06c496e6fdd440, 0x5a01bae0c7441f08c7af1cf9, 0x274e0e02529e6d26, 0x0,
        0x65ceb8977413bc9798681ecb, 0x19ffb287b45234f0c28fd1a7, 0x28dbbd2f9267be76, 0x0,
        0xcfcdbfdb2056ff1a64bf1d47, 0xf26fe2dae9f693d9b4aab2e6, 0x12d66ad4802d841e, 0x0,
        0xe6e34ebfa2e18dce86cadbdc, 0x7ce096238b3d4b1b8fba6a55, 0x2e0a660b1549800c, 0x0,
        0xd2dd03b29d58d045656ecf33, 0xeddac3cf7a123aae2180739b, 0x215bec6e0a03c924, 0x0,
        0xe5201e51828eb11589d8619f, 0xa6563c760aa3a2c9d15af235, 0x7ed0c9b2e7811fb, 0x0,
        0xc33ac21c67b06a9994457b4c, 0xa9aa5573bf7a92aab85366eb, 0x1a407281e1d92e91, 0x0,
        0x5a306649d971b115d71a78b1, 0xa70687a9b5132e26b2cfbb37, 0x2031920af5d6c9db, 0x0,
        0x58a3cea1103f16402eb74c08, 0xdfefcd91df2f4295ec21e03a, 0x1150bcc09ac40007, 0x0,
        0x57ed7d356f91abcef751889f, 0x5c668cded3599c9af5a7e5fa, 0x2ccf74197cb9bc13, 0x0, 0xa,
        0xe005b86051ef1922fe43c49e149818d1, 0x1f507980eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x154bc8ce8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x2305d1699a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x144a7edf6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x21c38572fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0x2b70369e16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x522c9d6d7ab792809e469e6ec62b2c8,
        0x85940927468ff53d864a7a50b48d73f1, 0xdc5dba1d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x119d0dd09466e4726b5f5241f323ca74,
        0x5306f3f5151665705b7c709acb175a5a, 0x2592a1c37c879b741d878f9f9cdf5a86, 0x0,
        0x61e02fbc1bed21b7bcf46f4c, 0xa6effae60cef67c2b63c39bb, 0x2ab9fc18a6615fb, 0x0,
        0x4b3724a1eaa0e523a8201b45, 0x62b04965c68922390462b7a3, 0x2198f058f64e1c43, 0x0,
        0x100000000000000003ff332cfc13ea1b7, 0x1000000000000000017a384910097a0a6,
        0x100000000000000008a1753b1b37a6668, 0xbf55a306145dc38, 0x698fa5385db63a1c306f31a6,
        0xbf42f2af27151fb1080c4e1b, 0x1fb3b32ec12c4f, 0x0, 0xce605cbc0a47803533df71b7,
        0x5e11c8521b0dd8cf8f000ffe, 0x7cb22177b9f6c9f, 0x0, 0x7661ed95c25cdb91, 0x10b644cef3d30c35,
        0x100000000000000006f577c0b4a402ddc, 0x100000000000000001a7d3ea294939351,
        0xa645e8eb1794e374ba58a593, 0x1efd47471ced39aacc2c4663, 0x2728f58a400a469f, 0x0,
        0x9bd43dd33e0aab21c26f95c5, 0xd0e362800d54bbfbc6c4fe83, 0x2f76d907a29973cd, 0x0,
        0x3d2887de3517544e, 0x7509da3e05adfa0a, 0x1000000000000000008604e989fdb09b5,
        0x100000000000000002c850eaa7c78bdc0, 0x5fe0d34aad545b3c4ef06b35, 0x5bff1849e6dc24399ac732fd,
        0x1e6185c8691064be, 0x0, 0xea77a9d5f1cd74b987667e33, 0xdc6d8e6d769c20731a299dbc,
        0x1198dca5bf14851b, 0x0, 0x10000000000000000026898e43eca56c7, 0x30387575e4bac6c6,
        0x20776c3ca242b7de, 0x100000000000000007d486e28cf4b0e10, 0x4d7402b67e248a1511a0841e,
        0x9c7a8605f376bd75aeb721e4, 0x16a48728caed67a6, 0x0, 0x3269769473a96aba2d5b866a,
        0x9fa613baafe4ff9c9827622, 0x83acb5fbc7fad50, 0x0, 0x1000000000000000025897c91d7b8d1f1,
        0x3fd9c240adbcce3, 0x100000000000000009a89d61b8c513677, 0x100000000000000001d92935462ea59df,
        0x8373942d7372f9b1f8b95c4c, 0x3d9f31bb677a013ba4cdd49f, 0x2a30441dde9012f4, 0x0,
        0x7d526a9f384aa7db749876de, 0x9c9092ab98018ed02c205430, 0xcdd28eac120a42f, 0x0,
        0x100000000000000002fc911da020d2f55, 0x11da5e7b097ee9cd,
        0x10000000000000000ad5176da721b78b7, 0x100000000000000004102d2a01b7fbf5f,
        0x7d8d69262635c81c7aef2d75, 0xa11a1dba95b5b955c00180c3, 0x76e4b2ad1aa3378, 0x0,
        0xb71796d33a53c64cf156350c, 0x2a66cebb6ad6a9131e268eb8, 0xb500720ebb9a86d, 0x0,
        0x35d8a8c78484d0c2, 0x37b379080cbcb6f7, 0x6b7a53f07ab793f1, 0x449bac4fffe801bc,
        0x71c6ac67d5825359f2b87c45, 0xd7353e8c0a5d50546cf6c671, 0x2ae62bb2dabe475f, 0x0,
        0xf0766ee822be9548105cadfb, 0x3a54b0466d91cbcacb90e0a, 0x5e9d7884973f330, 0x0,
        0x10b1947ddf58a676, 0x103c836271b652be, 0x100000000000000007e3b371d8da612a2,
        0x10000000000000000afdc716fd42dcebf, 0xb0bf2c61b4f4cbdead74273e, 0xb96526c6288d150336e0ee96,
        0x12948db5514c09a7, 0x0, 0xf3d8437a14c19236c52edcfc, 0xffd55886b031537735e02f78,
        0x2ce46f7b1c749b99, 0x0, 0x62e2e02294e2c662, 0xb7b29a6b2600fb8d, 0x12dfa3a68a5aa4b8,
        0x15945e750a0443c5, 0x7f83b4b51d00fc80bb831daf, 0x25d239976a348f767993ced5,
        0x2b84658d4f6cb5c8, 0x0, 0xfff31f69291319d397b31124, 0x156bf2f02ea3e4621278874b,
        0x103cc7bade9316ae, 0x0, 0x1ac00f1b74998794, 0x1000000000000000024c1b4e8a2305293,
        0x59d3cc6f01477796, 0xc9c2a2cd82f7e2d,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x7f5a9b9409f2cc39825a02c,
                limb1: 0xcae0e79fbccb0daf22e3d147,
                limb2: 0xe6a2d797f40f61,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x2a28940c5db0b16b11bcb83b,
                limb1: 0x909e67a632b9f3e09db0636b,
                limb2: 0x18643fa5fa438363,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BN254_11P() {
    let mut data = array![
        0xb, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0,
        0x536c985db33c69f7c242e07a, 0xfc531bccffafcf1e59d91fb9, 0x2585e4f8a31664cb, 0x0,
        0x57fa42444057cf0c1d62ae3c, 0x4f48d341183118d68ea41313, 0x1d2d2799db056ed1, 0x0,
        0x236ca9312dad3661a37f2d6f, 0x98424c01caad7592315715d1, 0x795b9fd941b23c4, 0x0,
        0xc7ab5834609a54b8993ffd79, 0xe81cd490528b814ca632aace, 0x2d9ff53d3009e6f7, 0x0,
        0x163df40cafbf585ca5b2ab44, 0xb4752e4666c88dbbe23783a0, 0x1a801462ac9cb657, 0x0,
        0xac9b557d7ca8625d957263c6, 0xdc6f75fa8339a78b998ae54a, 0x28683293b6494d9f, 0x0,
        0x5c4f5dca0c973b7f70bfff9, 0x188c2afab11eef5d48ecda3c, 0xc2fed35d36c49f1, 0x0,
        0x9d7244ea10697ca42e2e066b, 0xfe18a519c7d68770dc48dbf9, 0x149bb528db998529, 0x0,
        0xffc057151b06c496e6fdd440, 0x5a01bae0c7441f08c7af1cf9, 0x274e0e02529e6d26, 0x0,
        0x65ceb8977413bc9798681ecb, 0x19ffb287b45234f0c28fd1a7, 0x28dbbd2f9267be76, 0x0,
        0xcfcdbfdb2056ff1a64bf1d47, 0xf26fe2dae9f693d9b4aab2e6, 0x12d66ad4802d841e, 0x0,
        0xe6e34ebfa2e18dce86cadbdc, 0x7ce096238b3d4b1b8fba6a55, 0x2e0a660b1549800c, 0x0,
        0xd2dd03b29d58d045656ecf33, 0xeddac3cf7a123aae2180739b, 0x215bec6e0a03c924, 0x0,
        0xe5201e51828eb11589d8619f, 0xa6563c760aa3a2c9d15af235, 0x7ed0c9b2e7811fb, 0x0,
        0xc33ac21c67b06a9994457b4c, 0xa9aa5573bf7a92aab85366eb, 0x1a407281e1d92e91, 0x0,
        0x5a306649d971b115d71a78b1, 0xa70687a9b5132e26b2cfbb37, 0x2031920af5d6c9db, 0x0,
        0x58a3cea1103f16402eb74c08, 0xdfefcd91df2f4295ec21e03a, 0x1150bcc09ac40007, 0x0,
        0x57ed7d356f91abcef751889f, 0x5c668cded3599c9af5a7e5fa, 0x2ccf74197cb9bc13, 0x0,
        0x529118e291927516dfbcba2d, 0x440af959472c61e99aac7977, 0x218bbc79509b59ce, 0x0,
        0x226044f7331ccf82af7afb39, 0xc1953da25a89d084dcfaea76, 0x1042fdc36b43dac3, 0x0, 0xb,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x154bc8ce8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x2305d1699a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x144a7edf6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x21c38572fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0x2b70369e16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x522c9d6d7ab792809e469e6ec62b2c8,
        0x85940927468ff53d864a7a50b48d73f1, 0xdc5dba1d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x119d0dd09466e4726b5f5241f323ca74,
        0x5306f3f5151665705b7c709acb175a5a, 0x2592a1c37c879b741d878f9f9cdf5a86,
        0x30bcab0ed857010255d44936a1515607, 0x1158af9fbb42e0b20426465e3e37952d,
        0x5f3f563838701a14b490b6081dfc8352, 0x1b45bb86552116dd2ba4b180cb69ca38, 0x0,
        0xf59b76239fad9eb74730cd7, 0xa1143b2f09cd01fbb559c486, 0x2f8d04122e8fbde7, 0x0,
        0xa4777776f13805422915c296, 0x1c2749af3d7f4b652217ddae, 0xd4e2c28702c3059, 0x0,
        0x7661ed95c25cdb91, 0x10b644cef3d30c35, 0x100000000000000006f577c0b4a402ddc,
        0x100000000000000001a7d3ea294939351, 0x38ffcd70be2dbbae82096a26, 0xcfeb56ca9f8a8a2384543b8e,
        0x73059fa2677d1e5, 0x0, 0xa84366869190b93d9d917bf, 0xc455446eda9f79d73aa0cbad,
        0x2641bc3008f8cc9e, 0x0, 0x3d2887de3517544e, 0x7509da3e05adfa0a,
        0x1000000000000000008604e989fdb09b5, 0x100000000000000002c850eaa7c78bdc0,
        0xb4ec8b46be22584530b7b3e, 0xb6fd065dbd73e3d763c2e67c, 0x2e111c1d191de144, 0x0,
        0x81464c2ae0122148a3ddad93, 0x44c76e3df069bedffabb2d13, 0x1bf97d9ca1c2f369, 0x0,
        0x10000000000000000026898e43eca56c7, 0x30387575e4bac6c6, 0x20776c3ca242b7de,
        0x100000000000000007d486e28cf4b0e10, 0x64b2119b459e63324fbafc05, 0x66502154bd1382ce47b7681e,
        0x2ddfe6039dcfde7, 0x0, 0x529aa77c8e7a1d4ca0e64359, 0x2e01879e99328b28e513ff1c,
        0x44ef12a2f42ec77, 0x0, 0x1000000000000000025897c91d7b8d1f1, 0x3fd9c240adbcce3,
        0x100000000000000009a89d61b8c513677, 0x100000000000000001d92935462ea59df,
        0x8d414937f9c4a302b137537b, 0xa386777f18abfefe85c31058, 0x257b5a32a23f40a3, 0x0,
        0x3e95a9ff945e0553c85cfe2c, 0x4c5e5834c653623c13fec9b6, 0x1664b40825e1a905, 0x0,
        0x100000000000000002fc911da020d2f55, 0x11da5e7b097ee9cd,
        0x10000000000000000ad5176da721b78b7, 0x100000000000000004102d2a01b7fbf5f,
        0xa66fcc2f529276b780499985, 0xf69c7da32d819f1f4f193fc1, 0x1805e698d92c3ac0, 0x0,
        0xb9abf7ad6d28c58e2cc31b94, 0xf074390b2247dfaf60121eda, 0x27b2e899ed29cf1a, 0x0,
        0x35d8a8c78484d0c2, 0x37b379080cbcb6f7, 0x6b7a53f07ab793f1, 0x449bac4fffe801bc,
        0x5a1cd56b595531e6a3d814bf, 0x525e7a8c84a1f276259877a8, 0x7d7c34039bc644d, 0x0,
        0x97125887d88507b5fe4333b9, 0xdf81a585fe7f350ed9d80836, 0x197c0dbf47481ded, 0x0,
        0x10b1947ddf58a676, 0x103c836271b652be, 0x100000000000000007e3b371d8da612a2,
        0x10000000000000000afdc716fd42dcebf, 0xca590b79acc3248cf7071af2, 0xf8f64dd38ddb672cfe35764,
        0xa4a93bb49cda78e, 0x0, 0x7fca5043edf56dfce89121b9, 0x5a1191ede225c26c4e2fdd0e,
        0x1b28478576081b5e, 0x0, 0x62e2e02294e2c662, 0xb7b29a6b2600fb8d, 0x12dfa3a68a5aa4b8,
        0x15945e750a0443c5, 0x29281279f0958f532340b1e, 0x9c3f90c5b44db2da51242b88,
        0x18c51e06011b8dbf, 0x0, 0x1fce97d7fe0ad6091ef99256, 0x37115682a1c2995a8f46348,
        0x1fe22395832d2e61, 0x0, 0x1ac00f1b74998794, 0x1000000000000000024c1b4e8a2305293,
        0x59d3cc6f01477796, 0xc9c2a2cd82f7e2d, 0x3bb0f32e0eb9448943980b5c,
        0xaf7fdc854146e31d92761fa8, 0x247b7d3680ef0e4b, 0x0, 0xb46343f09e9d87fd5b9796cd,
        0xd0a6f8103729c2dc3c47dbe9, 0x2eaaab3d9d415e13, 0x0, 0x1000000000000000057e1f3bedd0842d4,
        0x10000000000000000255df8d996acfae5, 0x100000000000000000318c2486aecb245,
        0x1000000000000000023ae98fa95aa07b8, 0x4b9261005811ccafc4725902, 0x689c7c5528fbcab2ffdd0e45,
        0xee7f574a2b0c0fe, 0x0, 0x98e15c5c68cffe74a22c43c7, 0x77bc1a28c4ad8e05bfa5a214,
        0xb4a65415b0eba66, 0x0, 0x1000000000000000059cfa117d9318779,
        0x100000000000000008ef4027bb5693ee0, 0x3ae8a87244a109a4, 0x558c79eb7e83bb58,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x8f1d04d9dacdeb4b06745aae,
                limb1: 0x5c68471b1c99a97baed7f423,
                limb2: 0x1e8ed25080c73efd,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xc479efb2cb1c33352e438dbe,
                limb1: 0x1f9fcbf3fb537094c9816470,
                limb2: 0x2e15234a5a95acac,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BN254_12P() {
    let mut data = array![
        0xc, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0,
        0x536c985db33c69f7c242e07a, 0xfc531bccffafcf1e59d91fb9, 0x2585e4f8a31664cb, 0x0,
        0x57fa42444057cf0c1d62ae3c, 0x4f48d341183118d68ea41313, 0x1d2d2799db056ed1, 0x0,
        0x236ca9312dad3661a37f2d6f, 0x98424c01caad7592315715d1, 0x795b9fd941b23c4, 0x0,
        0xc7ab5834609a54b8993ffd79, 0xe81cd490528b814ca632aace, 0x2d9ff53d3009e6f7, 0x0,
        0x163df40cafbf585ca5b2ab44, 0xb4752e4666c88dbbe23783a0, 0x1a801462ac9cb657, 0x0,
        0xac9b557d7ca8625d957263c6, 0xdc6f75fa8339a78b998ae54a, 0x28683293b6494d9f, 0x0,
        0x5c4f5dca0c973b7f70bfff9, 0x188c2afab11eef5d48ecda3c, 0xc2fed35d36c49f1, 0x0,
        0x9d7244ea10697ca42e2e066b, 0xfe18a519c7d68770dc48dbf9, 0x149bb528db998529, 0x0,
        0xffc057151b06c496e6fdd440, 0x5a01bae0c7441f08c7af1cf9, 0x274e0e02529e6d26, 0x0,
        0x65ceb8977413bc9798681ecb, 0x19ffb287b45234f0c28fd1a7, 0x28dbbd2f9267be76, 0x0,
        0xcfcdbfdb2056ff1a64bf1d47, 0xf26fe2dae9f693d9b4aab2e6, 0x12d66ad4802d841e, 0x0,
        0xe6e34ebfa2e18dce86cadbdc, 0x7ce096238b3d4b1b8fba6a55, 0x2e0a660b1549800c, 0x0,
        0xd2dd03b29d58d045656ecf33, 0xeddac3cf7a123aae2180739b, 0x215bec6e0a03c924, 0x0,
        0xe5201e51828eb11589d8619f, 0xa6563c760aa3a2c9d15af235, 0x7ed0c9b2e7811fb, 0x0,
        0xc33ac21c67b06a9994457b4c, 0xa9aa5573bf7a92aab85366eb, 0x1a407281e1d92e91, 0x0,
        0x5a306649d971b115d71a78b1, 0xa70687a9b5132e26b2cfbb37, 0x2031920af5d6c9db, 0x0,
        0x58a3cea1103f16402eb74c08, 0xdfefcd91df2f4295ec21e03a, 0x1150bcc09ac40007, 0x0,
        0x57ed7d356f91abcef751889f, 0x5c668cded3599c9af5a7e5fa, 0x2ccf74197cb9bc13, 0x0,
        0x529118e291927516dfbcba2d, 0x440af959472c61e99aac7977, 0x218bbc79509b59ce, 0x0,
        0x226044f7331ccf82af7afb39, 0xc1953da25a89d084dcfaea76, 0x1042fdc36b43dac3, 0x0,
        0xf1581f4d2c98dddd1045823a, 0x4c70cf5d1fe8d72e2b0eda8, 0x2dd6cf0e5b99415d, 0x0,
        0xc3ebcba51d8891914acc5129, 0xa68f2b05936baf6578514dbf, 0xc4404c6b9b7453d, 0x0, 0xc,
        0x3405095c8a5006c1ec188efbd080e66e, 0x2305d1699a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x144a7edf6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x21c38572fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0x2b70369e16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x522c9d6d7ab792809e469e6ec62b2c8,
        0x85940927468ff53d864a7a50b48d73f1, 0xdc5dba1d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x119d0dd09466e4726b5f5241f323ca74,
        0x5306f3f5151665705b7c709acb175a5a, 0x2592a1c37c879b741d878f9f9cdf5a86,
        0x30bcab0ed857010255d44936a1515607, 0x1158af9fbb42e0b20426465e3e37952d,
        0x5f3f563838701a14b490b6081dfc8352, 0x1b45bb86552116dd2ba4b180cb69ca38,
        0xc87a746319c16a0d0febd845d0dfae43, 0xe0062d1b29a8b06daf66c5f2577bffa,
        0xa25b59fd92e8e269d12ecbc40b9475b1, 0x2689f61688c132adefbfc19ee8f6cf32, 0x0,
        0xa35f081ddc3964fef11b87ba, 0x7926593494405c5ed2a7c203, 0xb1fe4cb2b23209a, 0x0,
        0x1c0a838ac08fb4060688ee71, 0xfce2bda26b33f861d57cd974, 0x1ac64db61ee9a873, 0x0,
        0x3d2887de3517544e, 0x7509da3e05adfa0a, 0x1000000000000000008604e989fdb09b5,
        0x100000000000000002c850eaa7c78bdc0, 0xa74372df079d8431e9b18880, 0x6cd132648c2b9586f34ba4e5,
        0x17c5e79c26faf814, 0x0, 0x4e00fca0765a5dc39716592c, 0x62608fda1d9eb8ac692327ab,
        0x2efd2837ff622761, 0x0, 0x10000000000000000026898e43eca56c7, 0x30387575e4bac6c6,
        0x20776c3ca242b7de, 0x100000000000000007d486e28cf4b0e10, 0x7948eabf056257f90152cce1,
        0xfbefb6402b0f561fc2895f89, 0x7f3f0f1b174e884, 0x0, 0x3c76805faa60392fe4b110d3,
        0xba4b2232318a58138b8716b0, 0x31586d69a9e9d5f, 0x0, 0x1000000000000000025897c91d7b8d1f1,
        0x3fd9c240adbcce3, 0x100000000000000009a89d61b8c513677, 0x100000000000000001d92935462ea59df,
        0x68e1b7bda4cc53d96d5d21fc, 0x224cbbd937d29f5c8f33af33, 0x1eecbf09aea2ba62, 0x0,
        0x9ba28499df4dc86dba4834c9, 0x593878cb3634fbf4ad666d2f, 0x8d61bffa7ed1cf4, 0x0,
        0x100000000000000002fc911da020d2f55, 0x11da5e7b097ee9cd,
        0x10000000000000000ad5176da721b78b7, 0x100000000000000004102d2a01b7fbf5f,
        0x6404129b95705ec3758c3c32, 0xfee2f803c30b9c60ec9058c9, 0x1c4acdc80de3ff15, 0x0,
        0xeef9c5c2c7dd04d9ef28627, 0x85f67ca8fb3693eb3d49e733, 0x23179b3241d8554e, 0x0,
        0x35d8a8c78484d0c2, 0x37b379080cbcb6f7, 0x6b7a53f07ab793f1, 0x449bac4fffe801bc,
        0x127b307b02001ee53147974e, 0x19d13f1496e714d0e81eb452, 0x2d6284b456ce4016, 0x0,
        0xddba124fb48f7a6a17ffd3e9, 0xf09236f948f55c12f051316d, 0x1d89cad2e98d792b, 0x0,
        0x10b1947ddf58a676, 0x103c836271b652be, 0x100000000000000007e3b371d8da612a2,
        0x10000000000000000afdc716fd42dcebf, 0x9933f565ff29445c4095b6bc, 0x657f8c9411abc5bbcc136d8a,
        0x73e7ef94ba9d52e, 0x0, 0x6c40ee001e861af8b54083f9, 0xcd5e9710c4a04d282ce7349a,
        0x690a0b30371b326, 0x0, 0x62e2e02294e2c662, 0xb7b29a6b2600fb8d, 0x12dfa3a68a5aa4b8,
        0x15945e750a0443c5, 0xe73c8b0ec70203c2e8989117, 0x7ddfadad5f08ce1aa07c411c,
        0x13613f779a31d6ff, 0x0, 0x638429e6306a39c9e31a3603, 0x327c5d8bef475c0133cb5d8b,
        0x27096fced1ae8ce9, 0x0, 0x1ac00f1b74998794, 0x1000000000000000024c1b4e8a2305293,
        0x59d3cc6f01477796, 0xc9c2a2cd82f7e2d, 0xdcaf34a4eef803781d3022, 0xbc09ae870f85a6cf01c65e44,
        0x385ae0f48077e7e, 0x0, 0x61a1baa7bab47c085609a548, 0x914206f8e0e04938aee16726,
        0x389734c913660f7, 0x0, 0x1000000000000000057e1f3bedd0842d4,
        0x10000000000000000255df8d996acfae5, 0x100000000000000000318c2486aecb245,
        0x1000000000000000023ae98fa95aa07b8, 0x88adbf9219029597e553bb04, 0xeb6747eb6284e8b022461ec2,
        0x14a572f4f58c464f, 0x0, 0xeb6bac7a6c66241c45996655, 0xbd605734ae6e9a1ddcf2eb6e,
        0x7fbe6469eaad0bb, 0x0, 0x1000000000000000059cfa117d9318779,
        0x100000000000000008ef4027bb5693ee0, 0x3ae8a87244a109a4, 0x558c79eb7e83bb58,
        0xd37309fe22d9e35f307c3a6b, 0xe5de80a909551c749fca4879, 0x21fd1084d81d15e7, 0x0,
        0x8a05d9d6713308396ada192b, 0x5126361876e6ce50233c747c, 0x21db15f93ac460fe, 0x0,
        0x9af91b3e36abc612, 0x86643c813ecda430, 0x100000000000000000e467a16915fd7e5,
        0x100000000000000004a115b9161854fec, 0xe936353409de55cec6156fe6, 0xcb2d34e3b109e4ab4f9bfac3,
        0x8435d0668aada26, 0x0, 0x6d5907f5ae10fced2d3d609d, 0x4720c6ca15b721ac824fd1dc,
        0x28fd8e028bbd4327, 0x0, 0x100000000000000000615f3f7b8d448b9,
        0x100000000000000007f9651eee6b31ff4, 0x1000000000000000016a63b2f0da9904c,
        0x1000000000000000047f4ef94b6a2cc82,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x744865055917ca125348c4f8,
                limb1: 0x5c545244519dd218c72f1665,
                limb2: 0xcc6f1868dc806a6,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xcbb128d3e724151be03bef12,
                limb1: 0x3d9dca95a86b6ea20b40f368,
                limb2: 0x1d2cfc3fd3c3ff7f,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_1P() {
    let mut data = array![
        0x1, 0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0x1,
        0xb4862b21fb97d43588561712e8e5216a, 0x12cfa194e6f4590b9a164106cf6a659e, 0x1,
        0xb603ffc901ec7f3e42216ae4, 0x269adaf11286bf338b9dacb1, 0xab33b097e05378c0867894f,
        0xbfd8ef26d4610b8e77f5c28, 0x9afe78c2bb0f305eccbffb90, 0xc8b06f9aaf49eda1f9fd6cfd,
        0xc422cd476b9611aef3a1ee3, 0x1201e1e9a2b0867eb9da1725, 0x1000000000000000062a39ac9655a0af5,
        0x10000000000000000b59da527feb9e759, 0x885278dc00a1125a, 0x2fe0754b9fadfe7b,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xb603ffc901ec7f3e42216ae4,
                limb1: 0x269adaf11286bf338b9dacb1,
                limb2: 0xab33b097e05378c0867894f,
                limb3: 0xbfd8ef26d4610b8e77f5c28,
            },
            y: u384 {
                limb0: 0x9afe78c2bb0f305eccbffb90,
                limb1: 0xc8b06f9aaf49eda1f9fd6cfd,
                limb2: 0xc422cd476b9611aef3a1ee3,
                limb3: 0x1201e1e9a2b0867eb9da1725,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_2P() {
    let mut data = array![
        0x2, 0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0xde4f62a6588c9401ffefbd3,
        0x9bb5f797ac6d3395b71420b5, 0xdc39e973aaf31de52219df08, 0x105dcc4dce3960447d21d3c1,
        0xaefd0d854043fd325dd3c34f, 0x9b63c98d9a7845c52e1e2b0f, 0x9db0be660d847ccc58358f3f,
        0x17cb6c41f0c4e1a7394ab62a, 0x2, 0x12e0c8b2bad640fb19488dec4f65d4d9,
        0x2a43e70faf19922ad9b8a714e61a441c, 0x5a92118719c78df48f4ff31e78de5857,
        0x51f964df9c6316b950f244556f25e2a2, 0x1, 0x767bdb83da4925db077ac23d,
        0x51fcd455bd59b97a1e4a2d02, 0xf9650cba7ed29c8f01577a4d, 0x13e6deb52a57b03867f2c663,
        0x2170a02826a65df5fff9fc69, 0xcdef32f5872257c0f74a4983, 0x275718e62abbba48d224fc01,
        0x16e4935008c1ecbfc238a44c, 0x97ac96128760678, 0x1b8269c5da3a7aa, 0x946f8bb609f9ba7d,
        0x4e77077ba28bdfd6, 0xe6c4136fba2947157839fc3f, 0x58df45b89ea1d6fd003f377d,
        0x428ff9cfd30586deea516488, 0xc0c17be01b5ec83544d88ff, 0xfdf2fbfb66f355ed990a534f,
        0x98f6b2b220c2c0e179e4d145, 0xe2766e3b994a5f31518b1b4, 0xb1861e2a35c8eceb1eb84bf,
        0x3827704126429022, 0x59c3b34a3b390fcf, 0x1000000000000000076a605fca076460a,
        0x2f4183d416809c9a,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x32321a942ef961780ca91c06,
                limb1: 0x57e5605fbba104f908e63665,
                limb2: 0x843c0bbd70b5a837b690bd95,
                limb3: 0xbe7f58485672327a5c447c1,
            },
            y: u384 {
                limb0: 0x2150b2afd97c7793d20d0ecc,
                limb1: 0x4f6a0ae7eaf68e727f2fcb5d,
                limb2: 0x96407ddecb1fe770faf07c8c,
                limb3: 0x4c4183b2e457821188d59e7,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_3P() {
    let mut data = array![
        0x3, 0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0xde4f62a6588c9401ffefbd3,
        0x9bb5f797ac6d3395b71420b5, 0xdc39e973aaf31de52219df08, 0x105dcc4dce3960447d21d3c1,
        0xaefd0d854043fd325dd3c34f, 0x9b63c98d9a7845c52e1e2b0f, 0x9db0be660d847ccc58358f3f,
        0x17cb6c41f0c4e1a7394ab62a, 0xcf86158ab69213388e721bb7, 0x5f7812269d790797cad9aa15,
        0xb1c3622a0177001d9ed8e25f, 0x115cf429f459884785c6ba46, 0x1e81341e2f3f988ff115dda3,
        0xad22946489db6ee4954fa5e1, 0x83bed94412e19d92b73cc763, 0x2074c7bceff87d0d41edba1, 0x3,
        0x5a92118719c78df48f4ff31e78de5857, 0x51f964df9c6316b950f244556f25e2a2,
        0x8d723104f77383c13458a748e9bb17bc, 0x42bbb74ddd84f39e71545a137a1d5006,
        0xeb2083e6ce164dba0ff18e0242af9fc3, 0xbf0551e03983ca8ea7e9d498c778ea6, 0x1,
        0xa212d9c99e9c04c4d5c9413e, 0x396a875482462ca6c1340431, 0xc2162538b674feeff3abfd69,
        0x753e02471aea6c84aaa5ffc, 0x929a8f9dbb886a14600841b2, 0xd2549b8930caba7ed2b7f6f0,
        0x35911c87fe8cfc373e803e14, 0x180e16c3ae7f7949857d4ca0, 0x3827704126429022,
        0x59c3b34a3b390fcf, 0x1000000000000000076a605fca076460a, 0x2f4183d416809c9a,
        0x201564ee2f51efc0dd066bf4, 0x631f5532a8b44cccd0c4ae3a, 0x56a5d8f1e24804c51d3baba8,
        0x155dcc0adb758a4caede5e39, 0x4e0b78c88baeacb640f333c4, 0x2a16352f6da4000344ea35b3,
        0xe58d1f7ed72ebc3a1aced4bb, 0x7b09c3c38b9665bb6dcd1a3, 0x89ec0bb47cfdf6b1,
        0xb71533d7b1764557, 0x340a863c788b8bd1, 0x100000000000000001b03838bf180c6bb,
        0x8070e05e9145d1c520b0bc9f, 0xd2505d00fcfa7f814e629e1f, 0x789f47493e01360b240d31be,
        0xd4d252b4e71c49b728891b0, 0x32fd0164a7284bf6631f2131, 0xbf29e9b9d14edb8796f7c003,
        0x73032a27b08ccde5970c792a, 0x14128a5b1473f5285668a863, 0x29d77abed65ff201,
        0x4ea390aeeae13c8a, 0x426754eb9138bd09, 0x100000000000000007ebb92a3d2545c26,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x21b85c07d97d8ad7ed64cf5c,
                limb1: 0xc68ab576217c87f6afe7e8f6,
                limb2: 0x8aecb918175dcc693f68b02c,
                limb3: 0x16bdc982d01b9f8d1782060e,
            },
            y: u384 {
                limb0: 0x11cf0b8dceb54a416ec13f47,
                limb1: 0x81a05b3acc5b76a765127289,
                limb2: 0xcdbd38ba08efd726fae10661,
                limb3: 0x9747640d51b315635b0059a,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_4P() {
    let mut data = array![
        0x4, 0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0xde4f62a6588c9401ffefbd3,
        0x9bb5f797ac6d3395b71420b5, 0xdc39e973aaf31de52219df08, 0x105dcc4dce3960447d21d3c1,
        0xaefd0d854043fd325dd3c34f, 0x9b63c98d9a7845c52e1e2b0f, 0x9db0be660d847ccc58358f3f,
        0x17cb6c41f0c4e1a7394ab62a, 0xcf86158ab69213388e721bb7, 0x5f7812269d790797cad9aa15,
        0xb1c3622a0177001d9ed8e25f, 0x115cf429f459884785c6ba46, 0x1e81341e2f3f988ff115dda3,
        0xad22946489db6ee4954fa5e1, 0x83bed94412e19d92b73cc763, 0x2074c7bceff87d0d41edba1,
        0xe2955c55da59eba4b7b57d3d, 0x1e6629b0431bce67cf28c22, 0x1c35b7efd5b67f87221b8bfc,
        0x3e53df9e3488a9e42acd87e, 0x2e089afa726154d40dd12102, 0x5391613ecf49db2bcf1cad86,
        0x84a2abb2de6b3a6e09026a50, 0x19557a3a3c1d62a205d5dc87, 0x4,
        0x8d723104f77383c13458a748e9bb17bc, 0x42bbb74ddd84f39e71545a137a1d5006,
        0xeb2083e6ce164dba0ff18e0242af9fc3, 0xbf0551e03983ca8ea7e9d498c778ea6,
        0xb5d32b1666194cb1d71037d1b83e90ec, 0x5008b5f2ab0c1681c8f8e3d0d3290a4c,
        0xd3fbf47a7e5b1e7f9ca5499d004ae545, 0x5d79c4bd3e70f16a55485822de1b372a, 0x1,
        0x44bb6f75a004bca814756b12, 0x1818b158d2190e6e0fc9e550, 0x2c30743bfb89fd6efbecc08b,
        0x37837c70d528dd05cbf07e7, 0x492cb4f7c261d2d0b24d8b02, 0x230240dd9634dc222a23cb1a,
        0xe3eec79d41d215665e8c84cb, 0xeff88e6c2c0702d1d489a73, 0x89ec0bb47cfdf6b1,
        0xb71533d7b1764557, 0x340a863c788b8bd1, 0x100000000000000001b03838bf180c6bb,
        0xf88a71d0107733babbd62a8a, 0x5c8822f79ed71c8bbfa7ff17, 0x7a8298e09fc3cb760af959c9,
        0x71970cd5e563018d29192bc, 0x6d859bf8574d99e4aa0d6235, 0x743b1ed749ce3385e004fd1e,
        0x40b348aadf32289fd4ba39a2, 0x117e2219a46e398da3a4bcfb, 0x29d77abed65ff201,
        0x4ea390aeeae13c8a, 0x426754eb9138bd09, 0x100000000000000007ebb92a3d2545c26,
        0x62a1dd00d0d70c14a6483357, 0xd3311030294d0ecbd126a83c, 0x9ab588fa5774077b42bfaf84,
        0x2ca8d2c572fb8a41c46768, 0x9078c212d37a3119918e97e2, 0x7bfd90eaf25c921f82205790,
        0x87a6d075aaafcb12c6615ced, 0x14c4cdf3aa2c27b1ab23e540, 0x3a52f2488abaf3cf,
        0x100000000000000002db717c471a1fc21, 0x10000000000000000644c4a2d385dbb8f,
        0x10000000000000000a04a3389734226f8, 0xae129d9a602a42cc514ab5bd, 0x6b8ff0a7bab2c6cf01ab2b0d,
        0xe54a1c91c8cebd80422d7472, 0x18f20ed943760167480b399c, 0x3c855ffac29166b79418290c,
        0x16673746c28add51dbb908b6, 0x6bba7b68853a2592c3ab118d, 0x56b1a0d430dbe3db167379b,
        0x100000000000000004bed5581e0e7a253, 0x100000000000000009c34387abab6c0fe,
        0xb72bffe782e92797, 0x3a8e5d970236b4f1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x7406fee5d57362d0bd20a5fe,
                limb1: 0x9c148946ef3f3c63933238ab,
                limb2: 0x29449d34c8a2d4f2985f3c36,
                limb3: 0xa598551ba8198a566f2d4be,
            },
            y: u384 {
                limb0: 0x79e483b729f05957e7c73f33,
                limb1: 0x3a0046ded0b81194df4ad0d5,
                limb2: 0x6bb49380867caf051586303a,
                limb3: 0xc750343cc7a561d93f3d0c0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_10P() {
    let mut data = array![
        0xa, 0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0xde4f62a6588c9401ffefbd3,
        0x9bb5f797ac6d3395b71420b5, 0xdc39e973aaf31de52219df08, 0x105dcc4dce3960447d21d3c1,
        0xaefd0d854043fd325dd3c34f, 0x9b63c98d9a7845c52e1e2b0f, 0x9db0be660d847ccc58358f3f,
        0x17cb6c41f0c4e1a7394ab62a, 0xcf86158ab69213388e721bb7, 0x5f7812269d790797cad9aa15,
        0xb1c3622a0177001d9ed8e25f, 0x115cf429f459884785c6ba46, 0x1e81341e2f3f988ff115dda3,
        0xad22946489db6ee4954fa5e1, 0x83bed94412e19d92b73cc763, 0x2074c7bceff87d0d41edba1,
        0xe2955c55da59eba4b7b57d3d, 0x1e6629b0431bce67cf28c22, 0x1c35b7efd5b67f87221b8bfc,
        0x3e53df9e3488a9e42acd87e, 0x2e089afa726154d40dd12102, 0x5391613ecf49db2bcf1cad86,
        0x84a2abb2de6b3a6e09026a50, 0x19557a3a3c1d62a205d5dc87, 0x490bf40774926e8b279947c,
        0xeabab6aef9e9d2a4f64f4e7d, 0x3e309fe1b1c8247abab20d7e, 0x79c527862917f69ac58fcc4,
        0xacb18f2da2b425c2ff50dafd, 0x7623850d87e279a8a30f31ff, 0x777564c7291d95fa80203ade,
        0x1764ce0e7fb626109b63789b, 0x42f2f3f4f6b9d2c2b73a361f, 0xcd78c070c184c38b1e5716aa,
        0x72cbc24cd90da89e0e3cefe4, 0x19485e1c46d0dce75f8b192b, 0xb56b3539074b3c47b3f504d9,
        0x2c229530bddedd8851b03dcc, 0xc93eef8474c4e18d6378e7f0, 0x173d36f17a3c9ae77a2acc25,
        0x5fbf29cf20556a11621a6639, 0xdfda5b7dbf0b226822094787, 0x4a3b059e521b4b0445df96d5,
        0x333988c2c09f5af061cdfb, 0x13d3570be6d27d1d588b22fc, 0x20c763e58d4df3e4990cdae9,
        0x2c3301367f400c31f4bded26, 0x16a6c25d133fba74b4c55972, 0xcb24d12438557639f52df5fd,
        0x4a6a46feebe8a88a8062bd0e, 0x65f04211af4b168b1e25787d, 0x17935d6f4fa575744ca46f75,
        0x644f324be8a5c152625a5b8a, 0x501e52e8c5707d7a3a77ee18, 0x9636c463c14c5b85c2e6d3b1,
        0x1939b6f297f7b5b7fd0ac458, 0xde1d8e2670532ec5bba60ade, 0x1154f5064f7dd38656f7f82b,
        0xc9bec68372b7d07dcf66270c, 0x315ced00b3153219bbd430, 0xc48b3bc110e208d827b13f4d,
        0x87d82592699bca3dbf847c2b, 0xff04f0f2c8be12365aa73443, 0x1739c8c450ac994a5326c809,
        0x8904b74d5d114b5416df0ed6, 0x479ee13e49cde067742c2655, 0x45b9359bfa338dd432ca9ff1,
        0x12bf6460e7a42942be6c16a0, 0x3a8b37aacb2f620bc41c6109, 0x91f68edf90b5947273b0aadf,
        0x265d48695a73800b7404124c, 0x141e3d99b3ab683bdb0ce70f, 0xa,
        0xe005b86051ef1922fe43c49e149818d1, 0x3ea0f301eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x2a97919d8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x460ba2d39a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x2894fdbe6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x43870ae2fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0x56e06d3d16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0xa4593acd7ab792809e469e6ec62b2c8,
        0xd450fe4aec4f217bb306d1a8e5eeac76, 0x6b3f2afe642bfa42aef9c00b8a64c1b9,
        0x85940927468ff53d864a7a50b48d73f1, 0x1b8bb742d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x233a1ba09466e4726b5f5241f323ca74, 0x1,
        0x4fec1bc3c60e1e8698dead7e, 0x5d71a7fdab6311661050245a, 0xe05d09f0bc4a8f934ca0be3,
        0x3e410c8ef8929e597fc5e16, 0x2cb369f5527d80a3f85dfe16, 0x23136c25c83e8f7bbec1cf73,
        0xff512e4a07edaf5b49d3d728, 0x12d5dbede4328cb09da72b84, 0x100000000000000004292942fff5c5c73,
        0x100000000000000006f8e81274b1b80e7, 0x3b3d1e96d895314d,
        0x1000000000000000084bf5385aab534ac, 0x60a1a3ab0c7177eab76fff39, 0xc0be22d12b053ffe9ca14f59,
        0x181af3ad4d7e2a3d70d0d390, 0xa7fcec07bd4cbf86517c4ab, 0x225dafa45afbf8fdc096ca46,
        0x83fe86ca3674bc4f0fa1be03, 0x1419a6d50b39b38488129411, 0x673aa0dca89d43027ecf344,
        0x10000000000000000cea55d261de27134, 0x4945ad0e7a3ff67, 0x2fc459c3edadc3a2,
        0x10000000000000000061e3b8d4a2b7b49, 0x17f488f0ade4733d6ef16e5, 0x2345447ae416edecd39537f0,
        0xb6b696b8639e7cf9895c5cc4, 0x9e0e0023c554f7dcea9988f, 0x9d39eb85ff093ed952b7b83e,
        0xe97ebfec0868fb25fc01f0d2, 0x10ad24a237318d2b9652aa09, 0x13254cc65058dd9358b96239,
        0xab1e43002be79daa, 0x4647693a000da8bb, 0x100000000000000007d866035ad43d2cd,
        0x100000000000000008ac469986dc04381, 0x1c0101fbd27c0a2fce7dea00, 0xa1754f662e645363a3d7555e,
        0xf500d7bbb858b228f7566d60, 0x123c9acdbe8c6cd24ca87a2d, 0x49abf7cca1720df09b8013e8,
        0x58d4d7df624dc9492bdd5f14, 0xd885e40ee88b16151fc21f83, 0x18bc3ac505215228c26ed360,
        0x100000000000000008f832425d3465a7d, 0x100000000000000007a1648de1b75e170,
        0x10000000000000000782f24b2b6f99caa, 0x10000000000000000a46207414514e0b7,
        0xb680e2ee3456fa57129b0045, 0xfc71104d4fa38e9455aa5cd8, 0x9d5f6b4a7451e6cd2c4f7c7e,
        0xfefc054f2225661c3586c55, 0xbabd33086acd589bbb7df2d8, 0xea6d9ef8b309c10adde6756d,
        0x717bd330e5157289ed69b9ba, 0xb919c30025518a30b26a33b, 0x10000000000000000ae0ed118d80201db,
        0x100000000000000007dad72d6582f2e8a, 0x3e9b7c2f776f9ad1, 0x33c103bec8d8dd99,
        0xa05e97f79f1da1a74d36f934, 0x82cf8025c3bdc887ecdaff73, 0x24a11bec2b7777732ea49307,
        0x156f141bcbaef8188730e3d3, 0x5630c9208c0eb9c6338de7e, 0x1b5aaef757b58eb36a731689,
        0x3fa1031d312ad2881206f852, 0x12b8899d4af7a8c34e2a9d46, 0x10000000000000000022bf071f1160083,
        0x1000000000000000057d827f50ce811a1, 0x21e30fccd874a3e1,
        0x1000000000000000081bff70857d935ca, 0x7053f48d9623a0772224604c, 0xb11da71ba9823dc5c04dd4dd,
        0x184deafecb58abd1e56400b1, 0x157346717db5b34fd548cd32, 0xd9cadf87641980d152d6537d,
        0xee861d7d0a13c67b7217634, 0x7826079f0eee56e4e5c062fc, 0x191da207fdd5403838e0728e,
        0x10000000000000000ed6a42a626d0b5c2, 0x100000000000000008251f67200c0fd29,
        0x3753a6d93f053e65, 0x39f069691aa27848, 0xc378beb21e5b84edd744923f,
        0x9b228eaa8c0baec7dadb455a, 0x186026cdb53d6b03ac71faf9, 0x30663d24fb4b20705ac56ce,
        0x8b26b689e5b52df6b3b59981, 0x49a372daaf7ae6845981a370, 0x191c1c0b1921fa467089cad9,
        0x11bd657f852a9cc7b38ac45, 0xabf8f0133c1f072e, 0x161489d2a4ae8501,
        0x10000000000000000a422466a58575055, 0x100000000000000010d01a10c0ddec2b7,
        0xc17c00c80be4888b417fcab7, 0x237837a17d7f044145e07dd0, 0xdd4c4c3ee185dede22941eee,
        0x10bcc285e222e3edf5a3bb26, 0x3e1c8591502f1fa558f9f37f, 0xd279a8b40c7d82a067c1a9e0,
        0x8ebeb1d2a390ea6cc8282d68, 0x1859d1c72735f018ea45dea3, 0x1000000000000000005f68a6ba1476c4c,
        0x1badaadb9ef013b5, 0x100000000000000009d7e4713e105078d,
        0x10000000000000000704d4f90616d782f, 0xd7734cfb87bdee6ddbecba22, 0xb5be04f83be44ace5a664a82,
        0xa924b5316afad687fc174c75, 0x136a13276f643b22873d7490, 0xfa56e794ab2e49db1a65d154,
        0xa8c32e8861e673612ae9f3a2, 0xd12e4badeb492211212793, 0x5fe3e9844a34155419eb432,
        0x100000000000000000d9e2865dd56177d, 0x1000000000000000027d8ecbd5198c228,
        0x1000000000000000022c5f7e952ac9b2b, 0x10000000000000000a2e9b304305db746,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x85cd6b5af7b7cca272f94a3,
                limb1: 0x55be389217b4b81baee9530f,
                limb2: 0x1b5a70fff8b31b3cfc4b68de,
                limb3: 0x101c3dcc7f2a1be1afe50e39,
            },
            y: u384 {
                limb0: 0xdc944be6d0d78b23304e3193,
                limb1: 0xe1cdd664f4036ec4bd90db8,
                limb2: 0xf9e55c43073f3a6163464638,
                limb3: 0x14396fc17f6c6bc8f76ea501,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_11P() {
    let mut data = array![
        0xb, 0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0xde4f62a6588c9401ffefbd3,
        0x9bb5f797ac6d3395b71420b5, 0xdc39e973aaf31de52219df08, 0x105dcc4dce3960447d21d3c1,
        0xaefd0d854043fd325dd3c34f, 0x9b63c98d9a7845c52e1e2b0f, 0x9db0be660d847ccc58358f3f,
        0x17cb6c41f0c4e1a7394ab62a, 0xcf86158ab69213388e721bb7, 0x5f7812269d790797cad9aa15,
        0xb1c3622a0177001d9ed8e25f, 0x115cf429f459884785c6ba46, 0x1e81341e2f3f988ff115dda3,
        0xad22946489db6ee4954fa5e1, 0x83bed94412e19d92b73cc763, 0x2074c7bceff87d0d41edba1,
        0xe2955c55da59eba4b7b57d3d, 0x1e6629b0431bce67cf28c22, 0x1c35b7efd5b67f87221b8bfc,
        0x3e53df9e3488a9e42acd87e, 0x2e089afa726154d40dd12102, 0x5391613ecf49db2bcf1cad86,
        0x84a2abb2de6b3a6e09026a50, 0x19557a3a3c1d62a205d5dc87, 0x490bf40774926e8b279947c,
        0xeabab6aef9e9d2a4f64f4e7d, 0x3e309fe1b1c8247abab20d7e, 0x79c527862917f69ac58fcc4,
        0xacb18f2da2b425c2ff50dafd, 0x7623850d87e279a8a30f31ff, 0x777564c7291d95fa80203ade,
        0x1764ce0e7fb626109b63789b, 0x42f2f3f4f6b9d2c2b73a361f, 0xcd78c070c184c38b1e5716aa,
        0x72cbc24cd90da89e0e3cefe4, 0x19485e1c46d0dce75f8b192b, 0xb56b3539074b3c47b3f504d9,
        0x2c229530bddedd8851b03dcc, 0xc93eef8474c4e18d6378e7f0, 0x173d36f17a3c9ae77a2acc25,
        0x5fbf29cf20556a11621a6639, 0xdfda5b7dbf0b226822094787, 0x4a3b059e521b4b0445df96d5,
        0x333988c2c09f5af061cdfb, 0x13d3570be6d27d1d588b22fc, 0x20c763e58d4df3e4990cdae9,
        0x2c3301367f400c31f4bded26, 0x16a6c25d133fba74b4c55972, 0xcb24d12438557639f52df5fd,
        0x4a6a46feebe8a88a8062bd0e, 0x65f04211af4b168b1e25787d, 0x17935d6f4fa575744ca46f75,
        0x644f324be8a5c152625a5b8a, 0x501e52e8c5707d7a3a77ee18, 0x9636c463c14c5b85c2e6d3b1,
        0x1939b6f297f7b5b7fd0ac458, 0xde1d8e2670532ec5bba60ade, 0x1154f5064f7dd38656f7f82b,
        0xc9bec68372b7d07dcf66270c, 0x315ced00b3153219bbd430, 0xc48b3bc110e208d827b13f4d,
        0x87d82592699bca3dbf847c2b, 0xff04f0f2c8be12365aa73443, 0x1739c8c450ac994a5326c809,
        0x8904b74d5d114b5416df0ed6, 0x479ee13e49cde067742c2655, 0x45b9359bfa338dd432ca9ff1,
        0x12bf6460e7a42942be6c16a0, 0x3a8b37aacb2f620bc41c6109, 0x91f68edf90b5947273b0aadf,
        0x265d48695a73800b7404124c, 0x141e3d99b3ab683bdb0ce70f, 0x6d6db022a8549ee86374b69a,
        0x3e98f7258170733507d8709b, 0x10b4337a56d4cd17ab2fe1d5, 0x11366a6fecb124757076f4b6,
        0x77b25b600d3baa1a2f54f826, 0x924c3c1a699e9b27b3612246, 0x6a253cae0097b1955d4f0cfd,
        0xd2bd6591140d2faabafefac, 0xb, 0x4a84eb038d1fd9b74d2b9deb1beb3711,
        0x2a97919d8c25166a1ff39849b4e1357d, 0x3405095c8a5006c1ec188efbd080e66e,
        0x460ba2d39a6a5f92cca74147f6be1f72, 0x1775336d71eacd0549a3e80e966e1277,
        0x2894fdbe6288e1a5cc45782198a6416d, 0x2f1205544a5308cc3dfabc08935ddd72,
        0x43870ae2fcd81b5d24bace4307bf326, 0x42930b33a81ad477fb3675b89cdeb3e6,
        0x56e06d3d16febaa011af923d79fdef7c, 0x2648ee38e07405eb215663abc1f254b8,
        0xa4593acd7ab792809e469e6ec62b2c8, 0xd450fe4aec4f217bb306d1a8e5eeac76,
        0x6b3f2afe642bfa42aef9c00b8a64c1b9, 0x85940927468ff53d864a7a50b48d73f1,
        0x1b8bb742d977e9933c49d76fcfc6e625, 0xd344749096fd35d0adf20806e5214606,
        0x233a1ba09466e4726b5f5241f323ca74, 0x5306f3f5151665705b7c709acb175a5a,
        0x4b2543867c879b741d878f9f9cdf5a86, 0x30bcab0ed857010255d44936a1515607,
        0x22b15f3fbb42e0b20426465e3e37952d, 0x1, 0x19eea9b02b0269a828e87bbc,
        0x67bd46455c26c6ca390ae0ba, 0xa9dc83672893066741fa95e1, 0x14a2ab6a3bc68452c5582829,
        0x2a53345d1b34e4641cc38c3d, 0xc82502e6ee206ff835917eb7, 0xb6c87f3b28288a29296a7059,
        0x1361292ebd69db3c0b2f9180, 0x10000000000000000cea55d261de27134, 0x4945ad0e7a3ff67,
        0x2fc459c3edadc3a2, 0x10000000000000000061e3b8d4a2b7b49, 0xcca46ee7e7d728cf4687644,
        0x3ade741f416cf509a8d72a4c, 0x8e7572df6c768d460cb201d1, 0x1298c2031c383f68f18d47,
        0xa554139550742d2c1c2dbfcc, 0x179852f9e707ce5dfc6c509, 0x307f6d2c8b88fb29906b9668,
        0xce27f25b13c90cd75581cd7, 0xab1e43002be79daa, 0x4647693a000da8bb,
        0x100000000000000007d866035ad43d2cd, 0x100000000000000008ac469986dc04381,
        0x77117911414f1a8ba740937f, 0xfa4b42c9e27b825abb6e1932, 0x1957cbae8168c2a9ea426a5a,
        0x10cae1885e14624756a7eba6, 0xa3cd665fc42827532aaa2ea, 0x8af3e1bc51da81d7990f227e,
        0x788c055adcefcc69a3a5d382, 0x1003592246083ca043286287, 0x100000000000000008f832425d3465a7d,
        0x100000000000000007a1648de1b75e170, 0x10000000000000000782f24b2b6f99caa,
        0x10000000000000000a46207414514e0b7, 0xbe9bca3bf5eec6cc9844c551, 0xe0d5a94e288ef5adcba43ed7,
        0xe9e85c194dff7c219c6d8ca3, 0x1254bb7494352e470a3b0a40, 0x747bed6d938a5434bfd865e3,
        0x3d5af5929e771b0b1a09959b, 0x78e81d642b9ecee32d559eb, 0x14cc935a8ea60d9c8231390c,
        0x10000000000000000ae0ed118d80201db, 0x100000000000000007dad72d6582f2e8a,
        0x3e9b7c2f776f9ad1, 0x33c103bec8d8dd99, 0xac99a8072958d59134f663b9,
        0xb30bb7a088fd8458abe354a5, 0x1d1dacff16391acd20b4eaea, 0x7b73f92d3f09b43016e07b3,
        0xf6ae86523c0174ca5b1b0fc8, 0x73380bbaaba7c2034a6c5c63, 0x74bb326851d9f4a7c3e2c22,
        0xbadb8e20341bc68ee0d62fb, 0x10000000000000000022bf071f1160083,
        0x1000000000000000057d827f50ce811a1, 0x21e30fccd874a3e1,
        0x1000000000000000081bff70857d935ca, 0xd1db88e35a5fd4b22e8a7242, 0xcf4280e99dabae608abafd04,
        0x46af27b56584cc2c598e71ed, 0x14e9eb8a645712d6102c0a9e, 0xd7eb2bc34e0a3094c44bacf3,
        0xd0c67ab4ba8aaa1ddd0d6652, 0xb581c278d1737880614fa64d, 0x99a3a36cbc29026cdb989a3,
        0x10000000000000000ed6a42a626d0b5c2, 0x100000000000000008251f67200c0fd29,
        0x3753a6d93f053e65, 0x39f069691aa27848, 0xb96cfe43c16c753450704e86,
        0x2a10f11f55f81a94dd748595, 0x974380349665cfafcdae9c95, 0x866a4b640813c8ed4602e74,
        0xda29c08c0e39dbfd34e194b7, 0x76eda22634152a733d1bb476, 0x3ccf70b893cad74b3949dcab,
        0x11ae5fe6d5c14a6d2752cef6, 0xabf8f0133c1f072e, 0x161489d2a4ae8501,
        0x10000000000000000a422466a58575055, 0x100000000000000010d01a10c0ddec2b7,
        0xdc59ecc95ada6a3cddec47f, 0xbd9358cf424cddcab08790fa, 0x50659409e42159c50d14ced0,
        0x8306fb79b2c290cc5c1fd38, 0x4ca0ea4e89d982c06289a0c4, 0x37e68136c605119f244d8150,
        0xab4fee3c3a973c68f7f97975, 0xf51d92010bec98bd50ac787, 0x1000000000000000005f68a6ba1476c4c,
        0x1badaadb9ef013b5, 0x100000000000000009d7e4713e105078d,
        0x10000000000000000704d4f90616d782f, 0x86c26fd1dd2a50ee0449c352, 0x1b4d11d7f532f65e13dcba4e,
        0x9015975fbc0102c1ff188862, 0x7e1482bb4fc0ef8853ca0c, 0x94cc4d2e3c7efb6f9333e845,
        0xb0e5f311c82f55c14cd25a55, 0x507353e7c8312a9919c42bd9, 0xd36d6a8ef21c5f12abba7b0,
        0x100000000000000000d9e2865dd56177d, 0x1000000000000000027d8ecbd5198c228,
        0x1000000000000000022c5f7e952ac9b2b, 0x10000000000000000a2e9b304305db746,
        0x6c4a291f3b18b98c85df2dc3, 0xc22d37b8b13205d494623e06, 0x4d3d27bda9b62c0f25a91194,
        0x11bc318214ab34ab5197de3d, 0xf96d5803e611f1ad039b8569, 0x8846b82a7c6d0744b0ce648d,
        0x4a92230e8cec10baf31a9ca8, 0x61491babdbf49d8a7f52951, 0xbda83aa75e798d1,
        0x100000000000000006286d6ba5e14f26e, 0x38e7f7d2ae5ed155, 0x568116e3630d2d3c,
        0x6eda656d7e631870e3600441, 0x170f2b8ebab1a7c6884463a3, 0xd7bfea3459a831bff9178452,
        0xf1e34eceee6376fc7ca9b25, 0x9245d44dca719c11569e91c5, 0x829977ffedfa58f78ae0959e,
        0xcbb65cb0a53b9639d2fcd418, 0x7635fac8f26c4762db2fb7, 0x100000000000000003b4d8d413c8654e3,
        0x480407e0ff6c1d6c, 0x1011af9ee2cc20e6, 0x2dde429d4509a6dc,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x20ed31b5bd1a6a99cbc5f536,
                limb1: 0x455cd2878abeba8b867a4290,
                limb2: 0x9dfb4341a83a69b41feb23e4,
                limb3: 0x16dfcd6d60e4be40819587ca,
            },
            y: u384 {
                limb0: 0xe898728a87fdf94569d6fc7b,
                limb1: 0xebd6dcf86bcbaf6626552df1,
                limb2: 0x3892cf6167890a8cfbb63c03,
                limb3: 0xcc772bf8b9e03accf1bd62,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_12P() {
    let mut data = array![
        0xc, 0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0xde4f62a6588c9401ffefbd3,
        0x9bb5f797ac6d3395b71420b5, 0xdc39e973aaf31de52219df08, 0x105dcc4dce3960447d21d3c1,
        0xaefd0d854043fd325dd3c34f, 0x9b63c98d9a7845c52e1e2b0f, 0x9db0be660d847ccc58358f3f,
        0x17cb6c41f0c4e1a7394ab62a, 0xcf86158ab69213388e721bb7, 0x5f7812269d790797cad9aa15,
        0xb1c3622a0177001d9ed8e25f, 0x115cf429f459884785c6ba46, 0x1e81341e2f3f988ff115dda3,
        0xad22946489db6ee4954fa5e1, 0x83bed94412e19d92b73cc763, 0x2074c7bceff87d0d41edba1,
        0xe2955c55da59eba4b7b57d3d, 0x1e6629b0431bce67cf28c22, 0x1c35b7efd5b67f87221b8bfc,
        0x3e53df9e3488a9e42acd87e, 0x2e089afa726154d40dd12102, 0x5391613ecf49db2bcf1cad86,
        0x84a2abb2de6b3a6e09026a50, 0x19557a3a3c1d62a205d5dc87, 0x490bf40774926e8b279947c,
        0xeabab6aef9e9d2a4f64f4e7d, 0x3e309fe1b1c8247abab20d7e, 0x79c527862917f69ac58fcc4,
        0xacb18f2da2b425c2ff50dafd, 0x7623850d87e279a8a30f31ff, 0x777564c7291d95fa80203ade,
        0x1764ce0e7fb626109b63789b, 0x42f2f3f4f6b9d2c2b73a361f, 0xcd78c070c184c38b1e5716aa,
        0x72cbc24cd90da89e0e3cefe4, 0x19485e1c46d0dce75f8b192b, 0xb56b3539074b3c47b3f504d9,
        0x2c229530bddedd8851b03dcc, 0xc93eef8474c4e18d6378e7f0, 0x173d36f17a3c9ae77a2acc25,
        0x5fbf29cf20556a11621a6639, 0xdfda5b7dbf0b226822094787, 0x4a3b059e521b4b0445df96d5,
        0x333988c2c09f5af061cdfb, 0x13d3570be6d27d1d588b22fc, 0x20c763e58d4df3e4990cdae9,
        0x2c3301367f400c31f4bded26, 0x16a6c25d133fba74b4c55972, 0xcb24d12438557639f52df5fd,
        0x4a6a46feebe8a88a8062bd0e, 0x65f04211af4b168b1e25787d, 0x17935d6f4fa575744ca46f75,
        0x644f324be8a5c152625a5b8a, 0x501e52e8c5707d7a3a77ee18, 0x9636c463c14c5b85c2e6d3b1,
        0x1939b6f297f7b5b7fd0ac458, 0xde1d8e2670532ec5bba60ade, 0x1154f5064f7dd38656f7f82b,
        0xc9bec68372b7d07dcf66270c, 0x315ced00b3153219bbd430, 0xc48b3bc110e208d827b13f4d,
        0x87d82592699bca3dbf847c2b, 0xff04f0f2c8be12365aa73443, 0x1739c8c450ac994a5326c809,
        0x8904b74d5d114b5416df0ed6, 0x479ee13e49cde067742c2655, 0x45b9359bfa338dd432ca9ff1,
        0x12bf6460e7a42942be6c16a0, 0x3a8b37aacb2f620bc41c6109, 0x91f68edf90b5947273b0aadf,
        0x265d48695a73800b7404124c, 0x141e3d99b3ab683bdb0ce70f, 0x6d6db022a8549ee86374b69a,
        0x3e98f7258170733507d8709b, 0x10b4337a56d4cd17ab2fe1d5, 0x11366a6fecb124757076f4b6,
        0x77b25b600d3baa1a2f54f826, 0x924c3c1a699e9b27b3612246, 0x6a253cae0097b1955d4f0cfd,
        0xd2bd6591140d2faabafefac, 0xe706f12d726b82e518e76de2, 0xcbc3fafc8178466a6bfb6b20,
        0x27d77f8bd8c4a2d2333b94e2, 0x3fd4d3cb36a5470ac66276d, 0xaa24c8373ee67a1fdcfeddd6,
        0xb14ff80cfb97cbe0062505e6, 0x1f3cff0169eb74ea25e4b514, 0x9c9767230b739e24df854f7, 0xc,
        0x3405095c8a5006c1ec188efbd080e66e, 0x460ba2d39a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x2894fdbe6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x43870ae2fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0x56e06d3d16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0xa4593acd7ab792809e469e6ec62b2c8,
        0xd450fe4aec4f217bb306d1a8e5eeac76, 0x6b3f2afe642bfa42aef9c00b8a64c1b9,
        0x85940927468ff53d864a7a50b48d73f1, 0x1b8bb742d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x233a1ba09466e4726b5f5241f323ca74,
        0x5306f3f5151665705b7c709acb175a5a, 0x4b2543867c879b741d878f9f9cdf5a86,
        0x30bcab0ed857010255d44936a1515607, 0x22b15f3fbb42e0b20426465e3e37952d,
        0x5f3f563838701a14b490b6081dfc8352, 0x368b770c552116dd2ba4b180cb69ca38,
        0xc87a746319c16a0d0febd845d0dfae43, 0x1c00c5a3b29a8b06daf66c5f2577bffa, 0x1,
        0x662eb982d85d057e3ecd3e80, 0xb4a9a06f1870cef04d259893, 0x13c63b08919789f6693ac767,
        0x46b57475ebe2592c180602a, 0xa29ba889efae66ae28b5a21c, 0x90db50a5f6fd2bd2f903028a,
        0x2ff1e2429fbd64dfa2d6ad63, 0x12dafd8eb8056d84ec28ec15, 0xab1e43002be79daa,
        0x4647693a000da8bb, 0x100000000000000007d866035ad43d2cd,
        0x100000000000000008ac469986dc04381, 0xae2f33a9d9cb4b15ee0ad6b1, 0xf3a69411c14fe8a373bca88b,
        0x217b85cd445d90ff0e4660be, 0xcd5e4ff4b00690b55b4ccab, 0x6eed9ed30f4774665c816e0c,
        0x41cd754068d68ea27a0b5a89, 0xa959aebee91fe56aa2e55599, 0x1979875ae2f9097a371a56f,
        0x100000000000000008f832425d3465a7d, 0x100000000000000007a1648de1b75e170,
        0x10000000000000000782f24b2b6f99caa, 0x10000000000000000a46207414514e0b7,
        0xdfb5306dcb37c28c478de377, 0x82bf6e7247d010b3b88124e, 0x1350fed73699712cd10e4997,
        0x264ec684e80ad573730987b, 0x7e9381355a8d8cf41277ab35, 0x1dd2f50a04724803c09295fb,
        0xd59632cde5cb28cb87504b56, 0x150c5c0d0a3bcdb7fd2c4431, 0x10000000000000000ae0ed118d80201db,
        0x100000000000000007dad72d6582f2e8a, 0x3e9b7c2f776f9ad1, 0x33c103bec8d8dd99,
        0x6adb19e05054bbfb8a53d37b, 0x2c394966e7282d8a110f2653, 0x512faaf7af9cfceb077d30e7,
        0x13427ec47a05bb56e340d4d7, 0xc5ee5e3724d194a0d2791d0f, 0x5d820084f43d9203e1e31a16,
        0xa67dc8923161c3bc6ae1f4f5, 0x1dc8d7785737a204ad5d5e5, 0x10000000000000000022bf071f1160083,
        0x1000000000000000057d827f50ce811a1, 0x21e30fccd874a3e1,
        0x1000000000000000081bff70857d935ca, 0x382cac990c38c14a85724327, 0x98521dab0ab80ddee741516f,
        0xafe85b60155438f1d4633925, 0x45c68724b994edb98efb200, 0xdbf686bb85160b27e6488220,
        0x59414eea0e11ecf7c9d22ae3, 0x40d4f4747cb840ea3899a9b, 0x2861afe5dbb737326928b2b,
        0x10000000000000000ed6a42a626d0b5c2, 0x100000000000000008251f67200c0fd29,
        0x3753a6d93f053e65, 0x39f069691aa27848, 0x849645de9e01e7a980f44c83,
        0x73c2ecb8cb203193684963db, 0x9945175490a2d564c0840500, 0x15307d5f56f347db9f7d7438,
        0x376ccbcc1e7cff3de0291c4d, 0xaea02820b94f9707dd1845c, 0x352c307a3c4c5a6903a65295,
        0x136ac345ecdf8cdb887a13e5, 0xabf8f0133c1f072e, 0x161489d2a4ae8501,
        0x10000000000000000a422466a58575055, 0x100000000000000010d01a10c0ddec2b7,
        0x71a63008c587621a4f6f2fa1, 0x82ce5f249132fd11542b71b2, 0x4069ad0155b3070b2b6f4203,
        0x1126657c4bb0502d5248df50, 0x97eb128e69157b31c5de2a51, 0x627ccbf06c57855ca24f82a3,
        0xba851322224041050c2c7b0b, 0x166b10a0c76fedee06db3e9a, 0x1000000000000000005f68a6ba1476c4c,
        0x1badaadb9ef013b5, 0x100000000000000009d7e4713e105078d,
        0x10000000000000000704d4f90616d782f, 0xda173dac5e6d0480ba667f76, 0x322fa6cc1fec8d7c415cf100,
        0xfef7b6962ba4e32e16c004d7, 0xabbcb2d8ced3d51e8a78865, 0x2d862d3014969ce931cd1262,
        0xcafd95d76195abeda17c7f45, 0x69277501e6ac90cabbfd905b, 0x2104682267f86645d8554d4,
        0x100000000000000000d9e2865dd56177d, 0x1000000000000000027d8ecbd5198c228,
        0x1000000000000000022c5f7e952ac9b2b, 0x10000000000000000a2e9b304305db746,
        0xe86bdaffc7d80a66c773f278, 0xa3367d8c785f430e9f7ab55c, 0x347404e9a1d224b1a7e64804,
        0x17887f8a85307d4c5ccc2bbc, 0xdcd40632f732048108cef9f5, 0x494a6fe05b3b9d1ebc125f36,
        0x18a01df527ac65db6aa8e28b, 0x15157ba64035c63122bcc5cf, 0xbda83aa75e798d1,
        0x100000000000000006286d6ba5e14f26e, 0x38e7f7d2ae5ed155, 0x568116e3630d2d3c,
        0x65253fd616826b1dd8c6236a, 0x493a8f8b6538bb9a725be42c, 0x5a1a1e203464a4e5f03885d8,
        0xf2c7a601a50541e04819723, 0x9fdb8a5060ab7533fe50a415, 0xf4dd7e344ccc7f09843b76af,
        0xc660f2fffacb256a3e366c57, 0xcc76384b035432da44ba0c3, 0x100000000000000003b4d8d413c8654e3,
        0x480407e0ff6c1d6c, 0x1011af9ee2cc20e6, 0x2dde429d4509a6dc, 0x9a04f7c7cf9cf95db3549484,
        0x4a0c467c3a6e7c13b6bbb2e6, 0xdb99b99a930fe293db1b8e80, 0x10c8dfe8a58baf24cbb10f59,
        0xc6d991cbebf3f9fa457915ba, 0xa520ddf24608d77a970d70ae, 0x1c1b315ab5926bca556680a7,
        0x55733b5e405e88290930f38, 0x10000000000000000a857f257ed546ea8,
        0x100000000000000001c358602b6f2cc63, 0x100000000000000000cfc85c4f3f5d8b2,
        0x5dc2c695f99c34b6, 0x15fe07945fe2e77a80e4179c, 0x1ec2648a2cb50e385ba8a01a,
        0x4ad0adea7d44208504ffa544, 0x122dbd49c1be9a7cede8f22d, 0xa7a998d5d885d32646167830,
        0x5f83ce9f704555fd5177aa16, 0x95cdcf02e2e556a08a988e4, 0xdac0c3fac6c4b903f15e3af,
        0x6249de39f2cc9280, 0x100000000000000008d2562f99f8222e7, 0x28c4e5bf72e345ad,
        0x10000000000000000222b64363b6a2501,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x8bce5042829fff73a3bcf235,
                limb1: 0x24302605af7afd068c1bac35,
                limb2: 0x37e884c17dfeef6ccab457b5,
                limb3: 0xd33acb51b348e3a6fe9f58b,
            },
            y: u384 {
                limb0: 0x26976f00ce9dc19a844a55bf,
                limb1: 0x305566a6af04e25742e40b78,
                limb2: 0xeb73722c02dbef5226438532,
                limb3: 0x1618caeaf7d7b6c6e1bf656,
            },
        },
    );
}


#[test]
fn test_msm_SECP256R1_1P() {
    let mut data = array![
        0x1, 0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0, 0x1,
        0xeb1167b367a9c3787c65c1e582e2e662, 0xf7c1bd874da5e709d4713d60c8a70639, 0x3,
        0x5ecaccc77099015edd4567b8, 0xa82e8c31fd89230e9e054b35, 0x9b8f95662d8ac62b, 0x0,
        0x197a10d65c49dfb9020a06d1, 0x385d645da0e58782b062bea8, 0xce16e956485f6821, 0x0,
        0x35a5b9ab55bd33dd4dec8ec8c85b8754, 0x1256a1018e9a2606d3efc444e5bc9e97,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x5ecaccc77099015edd4567b8,
                limb1: 0xa82e8c31fd89230e9e054b35,
                limb2: 0x9b8f95662d8ac62b,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x197a10d65c49dfb9020a06d1,
                limb1: 0x385d645da0e58782b062bea8,
                limb2: 0xce16e956485f6821,
                limb3: 0x0,
            },
        },
    );
}


#[test]
fn test_msm_SECP256R1_2P() {
    let mut data = array![
        0x2, 0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0,
        0xd3ff147ff0ee4213f51f677d, 0x431366a7732a6e4a6b942255, 0x9fe743b25d39a591, 0x0,
        0x7f8bb562ff60a902ef14bcb0, 0xeb9420089fa531db62e806a6, 0xfd028df433dfd5cc, 0x0, 0x2,
        0xe443df789558867f5ba91faf7a024204, 0x23a7711a8133287637ebdcd9e87a1613,
        0x1846d424c17c627923c6612f48268673, 0xfcbd04c340212ef7cca5a5a19e4d6e3c, 0x3,
        0x69ad05b5d409fdd74ff3606a, 0xa4cd8f1dd82b0b833eb4f2e7, 0x24b24c3d5a6a9dfd, 0x0,
        0xd836719652e6763c9000c8bf, 0xf5a12b525077946be38f884b, 0x648707519821f2b4, 0x0,
        0x29fa93ff2e088f257810ffaf340cbe2f, 0x67db401fe06eea845a19e61367b76a34,
        0xf89789bfc970e55d00b6c590, 0xf75a68e0b3fa2545ac20867c, 0x2960649db3055cd8, 0x0,
        0x89f368de0f28fdf05075bde, 0x528cd10ce08cfe5ddb208066, 0xda975b1ed45230dd, 0x0,
        0x44faf735503f8d6a4fd7c1f1541b0e83, 0x108efc1b039167d94064f65615a509dcb,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x7c99e6e15710cca6d05a228c,
                limb1: 0xb3b0695cd0bcf4e2fff2aa40,
                limb2: 0xf51b415c36a8d206,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x3ed9af037beeebe8a4e51272,
                limb1: 0x59c17339e41ffb8881d8ff31,
                limb2: 0x8659e768c3fbaf89,
                limb3: 0x0,
            },
        },
    );
}


#[test]
fn test_msm_SECP256R1_3P() {
    let mut data = array![
        0x3, 0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0,
        0xd3ff147ff0ee4213f51f677d, 0x431366a7732a6e4a6b942255, 0x9fe743b25d39a591, 0x0,
        0x7f8bb562ff60a902ef14bcb0, 0xeb9420089fa531db62e806a6, 0xfd028df433dfd5cc, 0x0,
        0x46ae31f6fc294ad0814552b6, 0x2d54cc811efaf988efb3de23, 0x2a2cc02b8f0c419f, 0x0,
        0xaec889b9d8ce51c4a2c3586f, 0xa2b07874c333bfee9f78e13e, 0xc445de21be8d8709, 0x0, 0x3,
        0x1846d424c17c627923c6612f48268673, 0xfcbd04c340212ef7cca5a5a19e4d6e3c,
        0xb4862b21fb97d43588561712e8e5216a, 0x259f4329e6f4590b9a164106cf6a659e,
        0x12e0c8b2bad640fb19488dec4f65d4d9, 0x5487ce1eaf19922ad9b8a714e61a441c, 0x3,
        0x21932ec80e1487c9cfaca85, 0xc186376df1525312e49b706e, 0xc31cc2013df9b079, 0x0,
        0xfc2a2329e088a2bf919713c2, 0x6f226891c087240877728fb4, 0x8c2581e103f28987, 0x0,
        0x44faf735503f8d6a4fd7c1f1541b0e83, 0x108efc1b039167d94064f65615a509dcb,
        0x771ae9413e9a50212f4cab04, 0xe237a7ac362eb52c39a5693d, 0xfed723892728a27d, 0x0,
        0x22cef04d0e2d637e3ac6f9dc, 0xfe6992a829bc39d46025402c, 0xf9f46dc5ec2a3be2, 0x0,
        0x97f029beb074caf4db383ce1b6f43018, 0x676a9d25b186deaeeb154f6f81c3cac5,
        0xcb6fdbee18c8593a5411d8d4, 0xb5481fe44962e7d3e222115, 0x871c9156dc079065, 0x0,
        0x8c26b99697ee8e8f646fc0eb, 0x73d06be2b40891cb15d4a6c8, 0x97c7a60ae52be2f, 0x0,
        0xe1a61de4d41b08744b95b20a4e12fcb3, 0x153b6b6be0d5eaf38f83e1294ef38c98b,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x60a04d1cd61720fd649a635,
                limb1: 0x4de992ec1fe826266faf9542,
                limb2: 0x7fcc86284cb4d8d5,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xc5cc56bee25131b3aec25cee,
                limb1: 0x60f429ebbf34f181ee9e0f69,
                limb2: 0xeaba7780c9c9f8a8,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256R1_4P() {
    let mut data = array![
        0x4, 0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0,
        0xd3ff147ff0ee4213f51f677d, 0x431366a7732a6e4a6b942255, 0x9fe743b25d39a591, 0x0,
        0x7f8bb562ff60a902ef14bcb0, 0xeb9420089fa531db62e806a6, 0xfd028df433dfd5cc, 0x0,
        0x46ae31f6fc294ad0814552b6, 0x2d54cc811efaf988efb3de23, 0x2a2cc02b8f0c419f, 0x0,
        0xaec889b9d8ce51c4a2c3586f, 0xa2b07874c333bfee9f78e13e, 0xc445de21be8d8709, 0x0,
        0x7e47d1c2d19c21b2f6870259, 0xe701b40af42001c38bca00db, 0xd87ea1720d4dd3d6, 0x0,
        0x5b1d6cc74985ce49a1f737fe, 0xb9127c572c3f091c031c249c, 0x1392711e1576aa6f, 0x0, 0x4,
        0xb4862b21fb97d43588561712e8e5216a, 0x259f4329e6f4590b9a164106cf6a659e,
        0x12e0c8b2bad640fb19488dec4f65d4d9, 0x5487ce1eaf19922ad9b8a714e61a441c,
        0x5a92118719c78df48f4ff31e78de5857, 0xa3f2c9bf9c6316b950f244556f25e2a2,
        0x8d723104f77383c13458a748e9bb17bc, 0x85776e9add84f39e71545a137a1d5006, 0x3,
        0x9921ded7d529ce361c8e3ff0, 0xdc220d0b5287d69a714d190b, 0x1b76478b4180189d, 0x0,
        0xb1d2a54b21c1ad7f7d0f9027, 0x7e58d3d0b7e2a537a993411c, 0x7985849f9dd8119, 0x0,
        0x97f029beb074caf4db383ce1b6f43018, 0x676a9d25b186deaeeb154f6f81c3cac5,
        0xe25b3d09a0ca15758eec5c35, 0x4eb2ac787bfa862b05c37a19, 0x485dc9be973d40ad, 0x0,
        0xc544faf31ae71d76185ae1c9, 0xe7c7a3e02b520e65be0e955f, 0x56d97c994d146f8a, 0x0,
        0xe1a61de4d41b08744b95b20a4e12fcb3, 0x153b6b6be0d5eaf38f83e1294ef38c98b,
        0x57748c8a004a6262d9e306a3, 0x96a084f871c636d34425a103, 0xb3c2b8700cd7d920, 0x0,
        0x4ad02dbf9a1e3ee40e1e3d8d, 0xf797030462c8333af23d3f54, 0x1dc280acb99e5f4c, 0x0,
        0x26994a6057531b28435aaa960f280193, 0x30924dc9b5e85e844f4ee14d4bfe0e12,
        0xfeea2dd70b8a91873d10df4b, 0xb8e2d33a659ef7fa87e3fa0, 0x74fc51cbe8e5400d, 0x0,
        0xe4d3e3cf55a86291a7c5da22, 0xd3b103edfa5860bd1f94cdf8, 0x3480d7e452a5d2b5, 0x0,
        0x935644fe1e5f8844579a502568d12dc6, 0x177896bfd1e087a003ea64e9eaecd32d3,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x34c12d0510448edd8a4f435e,
                limb1: 0x1c1b70597d3d6f0ffda68cdc,
                limb2: 0x8f60be7a69fb2da6,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x67b330ca24613a628c5f1d44,
                limb1: 0xa12378b8d8a57f7ee45cf035,
                limb2: 0x7f7102c7548d7593,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256R1_10P() {
    let mut data = array![
        0xa, 0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0,
        0xd3ff147ff0ee4213f51f677d, 0x431366a7732a6e4a6b942255, 0x9fe743b25d39a591, 0x0,
        0x7f8bb562ff60a902ef14bcb0, 0xeb9420089fa531db62e806a6, 0xfd028df433dfd5cc, 0x0,
        0x46ae31f6fc294ad0814552b6, 0x2d54cc811efaf988efb3de23, 0x2a2cc02b8f0c419f, 0x0,
        0xaec889b9d8ce51c4a2c3586f, 0xa2b07874c333bfee9f78e13e, 0xc445de21be8d8709, 0x0,
        0x7e47d1c2d19c21b2f6870259, 0xe701b40af42001c38bca00db, 0xd87ea1720d4dd3d6, 0x0,
        0x5b1d6cc74985ce49a1f737fe, 0xb9127c572c3f091c031c249c, 0x1392711e1576aa6f, 0x0,
        0xb71f95ea692ed186e06e4c37, 0x807276cd9cc59718bb11dbe9, 0x10756a25836d67ca, 0x0,
        0xd34211b3520c83c5f9be99af, 0x8f19a28ceef67bbda102ffe7, 0x7ac2b92030d351cc, 0x0,
        0x411bb5d0fbe844f025c7178c, 0xcf603787227b7ac499d6d1c4, 0x5f6b2479862eb2f8, 0x0,
        0xce60303cfcb98726ff64a1e5, 0xa64534c614754b3527588d25, 0x44f75e245622181, 0x0,
        0x8a703177da18d4ede707c057, 0x7d6c11e754ab6fbe73deea43, 0xdf9787168190a047, 0x0,
        0x2e6585ab5f125a34fef37875, 0xb70e9f02ce7744197172a117, 0x60e305f9fe6f2298, 0x0,
        0x712f72f3929408ff68af059d, 0x4f72cea12cd115dc1c8639f5, 0xc6d5ae1b897ffe77, 0x0,
        0xfcf91f56bad0659142668837, 0xa15458b49bcdad6c870e3889, 0x81a1342e70b1b765, 0x0,
        0x461d7579f9613d3168fc6220, 0x7626024a6195fe0eafcea08b, 0x32e91b268a032443, 0x0,
        0xcdc7ae298071a741aafd4035, 0x9a9bdfbdb824dc1278457a10, 0x17fbec3713dfd145, 0x0,
        0x9b85054533e9d24310265ee0, 0x51cbb79b2625c435ba43bbef, 0x1fd81fcb136c629b, 0x0,
        0x96378a2e47ab50246a9cf131, 0x4d0f08867537268cf39eae04, 0x4eeb60396f3e5f52, 0x0, 0xa,
        0xd3fbf47a7e5b1e7f9ca5499d004ae545, 0xbaf3897a3e70f16a55485822de1b372a,
        0x101fbcccded733e8b421eaeb534097ca, 0x38c1962e9148624feac1c14f30e9c5cc,
        0x247a8333f7b0b7d2cda8056c3d15eef7, 0x1759edc372ae22448b0163c1cd9d2b7d,
        0xe005b86051ef1922fe43c49e149818d1, 0x7d41e602eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x552f233a8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x8c1745a79a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x5129fb7c6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x870e15c2fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0xadc0da7a16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x148b2758d7ab792809e469e6ec62b2c8, 0x3,
        0x38561918155956c9814da8c1, 0x4ee05f58a1e16b839f0d9c00, 0xecde93203b4a7dfa, 0x0,
        0xa685cbd24295124d7e743db7, 0x839d0ebc27e44d043d77eded, 0xe795a8a4341deaa3, 0x0,
        0xed0428b23446f2526c2e4e7b07209994, 0x10210ae4a0d0485cb56c075354424cf5d,
        0xa3dad4276a73d4c09d6159d4, 0x993f51a3b23380f272860899, 0x32c55c9bd7a08a15, 0x0,
        0xc5e4a047ae1c8e94b7d2caf4, 0xb641a3a56bdde831271d3274, 0x33595945536b7789, 0x0,
        0xc0845253484d89c1d1ccaf50b5524f81, 0x559558f8096b66022bac83a15eb9ff6f,
        0x6b1cb9b2433fb61e81654c3b, 0x67617c9e3a607fac036ceecb, 0x97c35ee2d0c73db6, 0x0,
        0xf0c3a4705c96d01f668e05ce, 0xeafdbf139502919889b40454, 0xc935a5c99c11cf36, 0x0,
        0x44922bc02cadce44e7b7886df54150df, 0x1c077ddb46086b3c48c0151e702cff2f6,
        0x65677810a039bc3e3c9be37c, 0x7d16040d79afaf58b3f80fa9, 0xfae349c7861f6f48, 0x0,
        0xd89bebc35496c77341e51852, 0x2358a145b3d17fa89be6dbdc, 0xd3b85a68d5dc2676, 0x0,
        0xc9ed151811182720cf9615e71e9fa060, 0x142125c7f17a0f71398604210c95e5ca5,
        0x4b3c7e7ccefc0fae7b0f55bb, 0xef7afabc6323803d011d8d2, 0x60a2c23d746b1a06, 0x0,
        0xb25819a91f97473e0339cd04, 0xaf305d5c7986ca879648d39e, 0xda3801752ba46faa, 0x0,
        0xae8d22acf2919234f64b2558ab7b67df, 0x11041f8236fcac05059b625657966610f,
        0x4c3728ed346a68dbf7e146f7, 0x678f6cd8ef42911e63db5bec, 0x77f7f11c0623961b, 0x0,
        0x685ae2d8682fb6e5bddbf735, 0x1f03b99ca6329f7dc3a47dd, 0x711f6d38f7342bbc, 0x0,
        0x1f14954c7b5ac5b971b602c56df47bc3, 0x12d076b9e2d6f7ff90377d25582942bfe,
        0x3b04be6e199cf2f9e01b8e25, 0xfcf54a6935861246f40ccf8c, 0xfbadcace1d51d441, 0x0,
        0xd70f738575d4a0269184b8ff, 0x3b4408df2be178958c3bf10c, 0x79e7079bd76a7b55, 0x0,
        0x6436caaee772af5fc76e60b7db77afc1, 0x1c3e3905b638753f3071cef680336e7fe,
        0xfe871f11377ae9427e3685f9, 0x7e050d6b4465549c28c47dc0, 0xc4902f8601ad20c0, 0x0,
        0xe79c221af2b5a795ce938be6, 0x97c17d2cd373c628e73940b, 0xe94b501243f485aa, 0x0,
        0x16f8de87b088d889a9fe62c941cfad9b, 0x181d97eccb30bde04756f33bbfe09ac77,
        0x34be9f4109fde722b0ad2953, 0x61c76a815bc4e8e49f2f6f22, 0x45c8af482d122938, 0x0,
        0x23cef567487cef807c8f37df, 0xb06e7986c8691afa2c56be48, 0x2f6997e366662173, 0x0,
        0x10c6c0d26e3816ea1b2e066d32578f8e, 0xe883f51850260b2857cb5d63a26adb1d,
        0x642b3b250974accb2a19bddd, 0xab3e89d8cf48dc55485119e6, 0xc5f80116c5e9c74, 0x0,
        0xff9bfb138c144d05684a114c, 0x7e7e1ae6a3570325390ed38e, 0x92eb23ab15e45e63, 0x0,
        0xa318a477495afb754a1e314186443137, 0x1a9d9d5e84e930f6526918aa8ca162b82,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xfba2105cfbf4fb86b8691c25,
                limb1: 0x737afa206da896812a1683ed,
                limb2: 0x3770a73db013e250,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x5590076303a44e451ab3856b,
                limb1: 0xd5fcd660db51d063c730f5c7,
                limb2: 0x506410f9c703c100,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256R1_11P() {
    let mut data = array![
        0xb, 0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0,
        0xd3ff147ff0ee4213f51f677d, 0x431366a7732a6e4a6b942255, 0x9fe743b25d39a591, 0x0,
        0x7f8bb562ff60a902ef14bcb0, 0xeb9420089fa531db62e806a6, 0xfd028df433dfd5cc, 0x0,
        0x46ae31f6fc294ad0814552b6, 0x2d54cc811efaf988efb3de23, 0x2a2cc02b8f0c419f, 0x0,
        0xaec889b9d8ce51c4a2c3586f, 0xa2b07874c333bfee9f78e13e, 0xc445de21be8d8709, 0x0,
        0x7e47d1c2d19c21b2f6870259, 0xe701b40af42001c38bca00db, 0xd87ea1720d4dd3d6, 0x0,
        0x5b1d6cc74985ce49a1f737fe, 0xb9127c572c3f091c031c249c, 0x1392711e1576aa6f, 0x0,
        0xb71f95ea692ed186e06e4c37, 0x807276cd9cc59718bb11dbe9, 0x10756a25836d67ca, 0x0,
        0xd34211b3520c83c5f9be99af, 0x8f19a28ceef67bbda102ffe7, 0x7ac2b92030d351cc, 0x0,
        0x411bb5d0fbe844f025c7178c, 0xcf603787227b7ac499d6d1c4, 0x5f6b2479862eb2f8, 0x0,
        0xce60303cfcb98726ff64a1e5, 0xa64534c614754b3527588d25, 0x44f75e245622181, 0x0,
        0x8a703177da18d4ede707c057, 0x7d6c11e754ab6fbe73deea43, 0xdf9787168190a047, 0x0,
        0x2e6585ab5f125a34fef37875, 0xb70e9f02ce7744197172a117, 0x60e305f9fe6f2298, 0x0,
        0x712f72f3929408ff68af059d, 0x4f72cea12cd115dc1c8639f5, 0xc6d5ae1b897ffe77, 0x0,
        0xfcf91f56bad0659142668837, 0xa15458b49bcdad6c870e3889, 0x81a1342e70b1b765, 0x0,
        0x461d7579f9613d3168fc6220, 0x7626024a6195fe0eafcea08b, 0x32e91b268a032443, 0x0,
        0xcdc7ae298071a741aafd4035, 0x9a9bdfbdb824dc1278457a10, 0x17fbec3713dfd145, 0x0,
        0x9b85054533e9d24310265ee0, 0x51cbb79b2625c435ba43bbef, 0x1fd81fcb136c629b, 0x0,
        0x96378a2e47ab50246a9cf131, 0x4d0f08867537268cf39eae04, 0x4eeb60396f3e5f52, 0x0,
        0x4e9960d402494fb117251955, 0xc0fb055de656d6ac2ba4da86, 0x800a21e8619f448f, 0x0,
        0x21ba9af739425b664464e3d5, 0xd09194888c2ffcf16e93e0c9, 0x5d4d3cd0684b6cd1, 0x0, 0xb,
        0x101fbcccded733e8b421eaeb534097ca, 0x38c1962e9148624feac1c14f30e9c5cc,
        0x247a8333f7b0b7d2cda8056c3d15eef7, 0x1759edc372ae22448b0163c1cd9d2b7d,
        0xe005b86051ef1922fe43c49e149818d1, 0x7d41e602eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x552f233a8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x8c1745a79a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x5129fb7c6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x870e15c2fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0xadc0da7a16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x148b2758d7ab792809e469e6ec62b2c8,
        0xd450fe4aec4f217bb306d1a8e5eeac76, 0xd67e55fd642bfa42aef9c00b8a64c1b9,
        0x85940927468ff53d864a7a50b48d73f1, 0x37176e84d977e9933c49d76fcfc6e625, 0x3,
        0xb16bff1ced538bfd53bae25e, 0xbf1402b7e25844a265c1bdd5, 0x1be24841a28b989f, 0x0,
        0xf986f402c5573e161419f24a, 0x7b675d2f5f2da582d6fe8f9e, 0x6aeca6fa85a397dc, 0x0,
        0xc0845253484d89c1d1ccaf50b5524f81, 0x559558f8096b66022bac83a15eb9ff6f,
        0x962f32f58256def96811a9d0, 0xa1b9c86a62821a4cfcd4a227, 0xef591311df6d01e4, 0x0,
        0x742d94ecec04d08af134a72f, 0xad0028269dacda27bef683c4, 0x298a3de72a4ed3cf, 0x0,
        0x44922bc02cadce44e7b7886df54150df, 0x1c077ddb46086b3c48c0151e702cff2f6,
        0x45a06c488f5dcafb092b1d04, 0x1da9b0f063b8d103454f7cc4, 0xd913f452d9dd6f57, 0x0,
        0x75d6dd631f23b758508fcb4, 0xf21f94eae9d1c6ed2aa4fb67, 0xdf5004b53571e9a9, 0x0,
        0xc9ed151811182720cf9615e71e9fa060, 0x142125c7f17a0f71398604210c95e5ca5,
        0x8d9a40cc54f2cc7d02b7e0b0, 0xe36d1ca0c233cf2ec25c402f, 0x94f2e92234345839, 0x0,
        0x7939e94d8e6282dd8964091f, 0x98530c37ba4b3964a3a0fe4a, 0x982d6fbcc9b50a64, 0x0,
        0xae8d22acf2919234f64b2558ab7b67df, 0x11041f8236fcac05059b625657966610f,
        0x21c3e96235c9016bf0a84114, 0x247ff7af02d28a262889b947, 0x92f35a496b19286d, 0x0,
        0x343cd3d8bf84c15a702e7657, 0x5e021f090c2b6c54bb8bcf1f, 0x5d1e6f00fb3793c5, 0x0,
        0x1f14954c7b5ac5b971b602c56df47bc3, 0x12d076b9e2d6f7ff90377d25582942bfe,
        0x2b574bbd9c8f851c273ff965, 0x6e259626c2a5c8caa331135b, 0x36ae66488788bb25, 0x0,
        0xb143e40a36ef2d4c7875e024, 0x62bbca04aa3439b4100d24c9, 0x49c3be30dc73a5fe, 0x0,
        0x6436caaee772af5fc76e60b7db77afc1, 0x1c3e3905b638753f3071cef680336e7fe,
        0xb50c01b147f62f5ced402fc7, 0x916dc3141db597cb65f49535, 0xfa26dd483341953, 0x0,
        0x83482d67557d46be990aeb2b, 0x879cc943ac21722d332e0387, 0x53e3c2b4d5a19544, 0x0,
        0x16f8de87b088d889a9fe62c941cfad9b, 0x181d97eccb30bde04756f33bbfe09ac77,
        0x39a4c7a121736d93c8c46aca, 0xd75c5f684d85cbf35b9f803d, 0xa71f416ba3e8524f, 0x0,
        0x3fb43e42616b1d7de570fd52, 0xe64815507843d1afb0823f58, 0xb0ed6357a48b8b89, 0x0,
        0x10c6c0d26e3816ea1b2e066d32578f8e, 0xe883f51850260b2857cb5d63a26adb1d,
        0xd9b0171c1f079d16eb88b0b5, 0xc10f56ec85cc7f859a09f8de, 0x215108f002c87662, 0x0,
        0x5e4c522f974963e8bf756e19, 0xe603a1ddbea2d112fc889233, 0x5fc356df32962109, 0x0,
        0xa318a477495afb754a1e314186443137, 0x1a9d9d5e84e930f6526918aa8ca162b82,
        0x145a727889f0bb4d53d6fbaa, 0x4155f220ac0460cd7ed04829, 0xb3ed8c7049dc43dc, 0x0,
        0x8a4850ae0cc7d3a0fc4a4a8e, 0x47478a0e45160288b6680b05, 0x10bdda9cc7016108, 0x0,
        0x2785e73e00b487bf30548408ffb58c02, 0x15f510a537d9b81be6f4a2335fa207095,
        0xff532f80c81fe274ac646064, 0x8c46882da4fde0295beab9e1, 0xc2b5cd8a7a93240a, 0x0,
        0xc949597e8e67ebee593df861, 0xa4849c0210fd9206fdaffcfd, 0x510cde5a5da7c46e, 0x0,
        0xe293dda213f46bf461aba1d96a9d193b, 0x15cb16111d99d7ae505af716e48e6b599,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xe702738c3be4c98312c6fd8,
                limb1: 0xdf289702da4292e2baf6d123,
                limb2: 0xd2e3d9fa85ae9ec9,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xb24620fd1d6468e74e756e09,
                limb1: 0xa92f0cfbb6159a6b7d73d3c8,
                limb2: 0xfdfb28f19d569756,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256R1_12P() {
    let mut data = array![
        0xc, 0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0,
        0xd3ff147ff0ee4213f51f677d, 0x431366a7732a6e4a6b942255, 0x9fe743b25d39a591, 0x0,
        0x7f8bb562ff60a902ef14bcb0, 0xeb9420089fa531db62e806a6, 0xfd028df433dfd5cc, 0x0,
        0x46ae31f6fc294ad0814552b6, 0x2d54cc811efaf988efb3de23, 0x2a2cc02b8f0c419f, 0x0,
        0xaec889b9d8ce51c4a2c3586f, 0xa2b07874c333bfee9f78e13e, 0xc445de21be8d8709, 0x0,
        0x7e47d1c2d19c21b2f6870259, 0xe701b40af42001c38bca00db, 0xd87ea1720d4dd3d6, 0x0,
        0x5b1d6cc74985ce49a1f737fe, 0xb9127c572c3f091c031c249c, 0x1392711e1576aa6f, 0x0,
        0xb71f95ea692ed186e06e4c37, 0x807276cd9cc59718bb11dbe9, 0x10756a25836d67ca, 0x0,
        0xd34211b3520c83c5f9be99af, 0x8f19a28ceef67bbda102ffe7, 0x7ac2b92030d351cc, 0x0,
        0x411bb5d0fbe844f025c7178c, 0xcf603787227b7ac499d6d1c4, 0x5f6b2479862eb2f8, 0x0,
        0xce60303cfcb98726ff64a1e5, 0xa64534c614754b3527588d25, 0x44f75e245622181, 0x0,
        0x8a703177da18d4ede707c057, 0x7d6c11e754ab6fbe73deea43, 0xdf9787168190a047, 0x0,
        0x2e6585ab5f125a34fef37875, 0xb70e9f02ce7744197172a117, 0x60e305f9fe6f2298, 0x0,
        0x712f72f3929408ff68af059d, 0x4f72cea12cd115dc1c8639f5, 0xc6d5ae1b897ffe77, 0x0,
        0xfcf91f56bad0659142668837, 0xa15458b49bcdad6c870e3889, 0x81a1342e70b1b765, 0x0,
        0x461d7579f9613d3168fc6220, 0x7626024a6195fe0eafcea08b, 0x32e91b268a032443, 0x0,
        0xcdc7ae298071a741aafd4035, 0x9a9bdfbdb824dc1278457a10, 0x17fbec3713dfd145, 0x0,
        0x9b85054533e9d24310265ee0, 0x51cbb79b2625c435ba43bbef, 0x1fd81fcb136c629b, 0x0,
        0x96378a2e47ab50246a9cf131, 0x4d0f08867537268cf39eae04, 0x4eeb60396f3e5f52, 0x0,
        0x4e9960d402494fb117251955, 0xc0fb055de656d6ac2ba4da86, 0x800a21e8619f448f, 0x0,
        0x21ba9af739425b664464e3d5, 0xd09194888c2ffcf16e93e0c9, 0x5d4d3cd0684b6cd1, 0x0,
        0x4bec631b62d40e5b8aaff33e, 0xf7161e0a086fb1c95bc84eab, 0xfbff400a905bf4cf, 0x0,
        0x482ffa9e045ec6f1e1e09d6e, 0x9a75ce6f11a020bef0b9b3f3, 0x253b9af963b9e192, 0x0, 0xc,
        0x247a8333f7b0b7d2cda8056c3d15eef7, 0x1759edc372ae22448b0163c1cd9d2b7d,
        0xe005b86051ef1922fe43c49e149818d1, 0x7d41e602eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x552f233a8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x8c1745a79a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x5129fb7c6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x870e15c2fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0xadc0da7a16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x148b2758d7ab792809e469e6ec62b2c8,
        0xd450fe4aec4f217bb306d1a8e5eeac76, 0xd67e55fd642bfa42aef9c00b8a64c1b9,
        0x85940927468ff53d864a7a50b48d73f1, 0x37176e84d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x467437419466e4726b5f5241f323ca74,
        0xa425799aa905d7507e1ea9c573581a81, 0xfb82860deabca8d0b341facdff0ac0f1, 0x3,
        0xf21b3e6af6d840760fa8411f, 0xd677b055694872a38d273ef1, 0x150932895e8f8c82, 0x0,
        0x45195680cc81c556f391cc4b, 0xdde61f43811514fa59ed06e9, 0x220cfb9298b8cc55, 0x0,
        0x44922bc02cadce44e7b7886df54150df, 0x1c077ddb46086b3c48c0151e702cff2f6,
        0x2b346d6b79e589393cf0d61b, 0x4f58aa4dd49fc3dd5924c7f9, 0x386d7047f06ea697, 0x0,
        0x3a470a888b07a992eebf9389, 0x8324abb26382c12bce482ab1, 0xb384c6bec834d324, 0x0,
        0xc9ed151811182720cf9615e71e9fa060, 0x142125c7f17a0f71398604210c95e5ca5,
        0x9c891702b89da5331cb7832e, 0x2731f6bc2f1aa2eb186b25c5, 0x2ad90d0df0c3682c, 0x0,
        0xcd1df42426c63336a3458fe5, 0x7c918ae249bb546477383a55, 0x44e172d8e00fd452, 0x0,
        0xae8d22acf2919234f64b2558ab7b67df, 0x11041f8236fcac05059b625657966610f,
        0xd6cf6a25a18ed80eb0e6190e, 0x3c774b8768bc771fab9fdcc9, 0x47c91895e8b1d94e, 0x0,
        0x272762d65915cc5033c101ea, 0x99426a49b9b07e18aded6f42, 0xca92ae7e999ccfaa, 0x0,
        0x1f14954c7b5ac5b971b602c56df47bc3, 0x12d076b9e2d6f7ff90377d25582942bfe,
        0x394cc425f5996a29056252d1, 0xd2b3ec664a7880e8d35f183f, 0xc828b02c43406f58, 0x0,
        0x804960c086f17cae9d5ad279, 0x484702a1d46ed78aefb3e507, 0x1e99ac387923772, 0x0,
        0x6436caaee772af5fc76e60b7db77afc1, 0x1c3e3905b638753f3071cef680336e7fe,
        0x26ce92552827bb2fa63cca66, 0xc39a63811359b427370b0575, 0xae807a141eaa26dc, 0x0,
        0xc0c2b78a71d509508baf0f2a, 0x2feadccb72de72e9f5fc6138, 0xc0382fd27bb08ce3, 0x0,
        0x16f8de87b088d889a9fe62c941cfad9b, 0x181d97eccb30bde04756f33bbfe09ac77,
        0x78113c1d4dfdf1520f3f1999, 0x2c5b0f78ece4dbf13818b6da, 0x91423833a8a23044, 0x0,
        0x4f72d597c449ae91c028fe43, 0x6254a79f46e2eba930ff0922, 0x2fe944a98818b85, 0x0,
        0x10c6c0d26e3816ea1b2e066d32578f8e, 0xe883f51850260b2857cb5d63a26adb1d,
        0x6623d54c69187cc05a7d25f1, 0x4f1c622a1f647d93565c3832, 0x6a79e7e30dd11556, 0x0,
        0x1fce6face866ebb2c02113a5, 0xdeff94345f28459d5573a31b, 0xae91e80a1d94d7e5, 0x0,
        0xa318a477495afb754a1e314186443137, 0x1a9d9d5e84e930f6526918aa8ca162b82,
        0x8cf51eb38bcb71c8f648bcff, 0x4c19c480af80b7e6a658baa2, 0xcf2c5e5a5d2ebee5, 0x0,
        0x19103765b836ea25211d48d7, 0xfe67a940dcd330efe84be2dd, 0x8d56f6b8b35dbce5, 0x0,
        0x2785e73e00b487bf30548408ffb58c02, 0x15f510a537d9b81be6f4a2335fa207095,
        0x8bfd5afc63995feebc71e165, 0xe7d8abd837751c2eb24eef3e, 0xee5889cb9dcfbaf5, 0x0,
        0x1f5083d084d6f44e5bfbbb5b, 0x2b94b883ed3e33932b61c480, 0xe267eab32408be05, 0x0,
        0xe293dda213f46bf461aba1d96a9d193b, 0x15cb16111d99d7ae505af716e48e6b599,
        0x5c19035d92c3b9e269ca9231, 0x305af2b3721b71e18b9f971, 0x174d9aaf6ed44af2, 0x0,
        0x7b91bd8b08dd4844dd8b2f3e, 0xe8174f87ddde9f6c71c644ff, 0x8b0c88aa96b2ff53, 0x0,
        0x5747d2a86b06c3af37767b79685e955a, 0x12d5f64271c5145c58fdf6149840ae47,
        0x93b81d705fbc02e172727cfd, 0x4de473fa4428b4c924d7bd53, 0x1939f32498b8d75d, 0x0,
        0x8ab3d19f0f073043eb950bf9, 0xee1962e119ef85b4c508ad6d, 0x6808f2627e81135c, 0x0,
        0xf49af9f8629ea294f624aa92983015e9, 0x1046b42b340cdb380acd6a9b3aecef690,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xce6a9b69daea1558dcbe14f1,
                limb1: 0x3d82daa514f325d29522e5e7,
                limb2: 0xc9833209611997e9,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x84af480eeea70b1a6120dc57,
                limb1: 0xc6df620bb03464672b4e6d28,
                limb2: 0x53ae491c8e1b5177,
                limb3: 0x0,
            },
        },
    );
}


#[test]
fn test_msm_SECP256K1_1P() {
    let mut data = array![
        0x1, 0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0, 0x1,
        0xeb1167b367a9c3787c65c1e582e2e662, 0xf7c1bd874da5e709d4713d60c8a70639, 0x2,
        0xc20f5aa13afc3a2097ce088b, 0x50220928f8ca04bf313c1d7, 0x70743ffac9bb07f9, 0x0,
        0xfa42792834ae5445fcaca832, 0x6796f84b7340adf44ed49d33, 0x62fd8a76eedcb778, 0x0,
        0x100000000000000006d17da9dde38d3aa, 0x100000000000000008e0801a3d001f325, 0x87ea3597eb650e8,
        0xe42d003a1f0e89bd,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xc20f5aa13afc3a2097ce088b,
                limb1: 0x50220928f8ca04bf313c1d7,
                limb2: 0x70743ffac9bb07f9,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xfa42792834ae5445fcaca832,
                limb1: 0x6796f84b7340adf44ed49d33,
                limb2: 0x62fd8a76eedcb778,
                limb3: 0x0,
            },
        },
    );
}


#[test]
fn test_msm_SECP256K1_2P() {
    let mut data = array![
        0x2, 0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0,
        0xfdfdc509f368ba4395773d3a, 0x8de2b60b577a13d0f83b578e, 0xc2dd970269530ba2, 0x0,
        0x589fa250d638e35400c12ddf, 0xb3aac19fcb5095808402aa7f, 0xed6de6590d0195d1, 0x0, 0x2,
        0xe443df789558867f5ba91faf7a024204, 0x23a7711a8133287637ebdcd9e87a1613,
        0x1846d424c17c627923c6612f48268673, 0xfcbd04c340212ef7cca5a5a19e4d6e3c, 0x2,
        0x889ef9db2dcca93176722661, 0x30f90e4e5ea1e991ccf9dd07, 0xe840f7e9e3d96c65, 0x0,
        0x6b95984b663cf4ffcd07d9c7, 0x952dac88c6a40f73979028d6, 0xc5e5fd89e078d389, 0x0,
        0x4bab076cac43472e, 0x896dcc1031d19f2d, 0x100000000000000006f45630d920758e7,
        0x13bfcc5670fee7eb, 0xef8bfd5fa527215c20165899, 0x7e263c9c3df47bc32eb4890b,
        0x9a3ee712d779bbf1, 0x0, 0x7d54e9e980c0873b3755c17e, 0x22a963dcae22fec5cacd5431,
        0x817adf30a086d140, 0x0, 0x40c3f72fa123bad6, 0x461e3a87e8955f53, 0x53ec0e0286c9f6ad,
        0x1000000000000000074832ec5bb09d4f6,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x97ad9ae598203a75c13a895,
                limb1: 0xed9fb4bee5b2f54ca5cffb42,
                limb2: 0x284782b62d08871c,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xfb082c65dab4069694f90f18,
                limb1: 0xb12d25f5fb5e746c12686571,
                limb2: 0x7d0eb16046d10c7e,
                limb3: 0x0,
            },
        },
    );
}


#[test]
fn test_msm_SECP256K1_3P() {
    let mut data = array![
        0x3, 0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0,
        0xfdfdc509f368ba4395773d3a, 0x8de2b60b577a13d0f83b578e, 0xc2dd970269530ba2, 0x0,
        0x589fa250d638e35400c12ddf, 0xb3aac19fcb5095808402aa7f, 0xed6de6590d0195d1, 0x0,
        0x2965eeb3ec1fe786a6abe874, 0x33e2545f82bb6add02788b8e, 0xf586bc0db335d7b8, 0x0,
        0x155b35991489db2fdf4de620, 0xf24ce461346a182d67eeccf0, 0xb4122bb4b37cc7d5, 0x0, 0x3,
        0x1846d424c17c627923c6612f48268673, 0xfcbd04c340212ef7cca5a5a19e4d6e3c,
        0xb4862b21fb97d43588561712e8e5216a, 0x259f4329e6f4590b9a164106cf6a659e,
        0x12e0c8b2bad640fb19488dec4f65d4d9, 0x5487ce1eaf19922ad9b8a714e61a441c, 0x2,
        0xa9ca5eaf239f624e5f32d52c, 0xe8781b10ffc1e9d6b65fcf8e, 0xa99e25b10243bc1b, 0x0,
        0x48c471108b3d056fc7043965, 0xa13fee6c99e702aaa40e511e, 0x3dabf3e8f614a3e, 0x0,
        0x40c3f72fa123bad6, 0x461e3a87e8955f53, 0x53ec0e0286c9f6ad,
        0x1000000000000000074832ec5bb09d4f6, 0x280f3fa841c7bf6d615bcb53, 0x276795ef2ecbbe7e2012f4cd,
        0x81043aa56aa2d4a, 0x0, 0x6ed67d338a2a9b542f54ec66, 0x6b2b2546eb3b1938441381f5,
        0x4dbf81ca0dfc9cdf, 0x0, 0x100000000000000008a16fd00888d3c49,
        0x10000000000000000701b1de1a64611a5, 0x7bb19b6adc4d85f4, 0x2fd5ac7d0446c0d3,
        0x8a41f2a7e7ad4089990a1bcd, 0xec1d1ff466f58331529b0acd, 0x5649d8d001330363, 0x0,
        0xfc543db1835e8a78f0994291, 0x43c390ccae632a174f607c8a, 0x813ee8122c9dfa7b, 0x0,
        0x7f7b9792bad13df8, 0xf56d08780b0b13f5, 0x535b7499f702bf5d, 0xce3ee818c4660dc,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x793f03cb81255db0817da454,
                limb1: 0x5ed27cf7207443f37bfeee3c,
                limb2: 0x42943c6416752a12,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xf2d25838b8b95a3caaef5ce4,
                limb1: 0xce58bfff9d25e997305603f3,
                limb2: 0x5d776495b03d0b6c,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256K1_4P() {
    let mut data = array![
        0x4, 0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0,
        0xfdfdc509f368ba4395773d3a, 0x8de2b60b577a13d0f83b578e, 0xc2dd970269530ba2, 0x0,
        0x589fa250d638e35400c12ddf, 0xb3aac19fcb5095808402aa7f, 0xed6de6590d0195d1, 0x0,
        0x2965eeb3ec1fe786a6abe874, 0x33e2545f82bb6add02788b8e, 0xf586bc0db335d7b8, 0x0,
        0x155b35991489db2fdf4de620, 0xf24ce461346a182d67eeccf0, 0xb4122bb4b37cc7d5, 0x0,
        0x12815740835b12f70b96c66f, 0xbfa76a8b80aec9f2e31c40cc, 0xcd8a26d17d33c7c1, 0x0,
        0x9a8f496f09402b8fd6beb89b, 0x28e48918dad2123d7f202bef, 0xcdd11b6ffb3f8614, 0x0, 0x4,
        0xb4862b21fb97d43588561712e8e5216a, 0x259f4329e6f4590b9a164106cf6a659e,
        0x12e0c8b2bad640fb19488dec4f65d4d9, 0x5487ce1eaf19922ad9b8a714e61a441c,
        0x5a92118719c78df48f4ff31e78de5857, 0xa3f2c9bf9c6316b950f244556f25e2a2,
        0x8d723104f77383c13458a748e9bb17bc, 0x85776e9add84f39e71545a137a1d5006, 0x2,
        0x7c5bbcc9341cd7fab6ad4876, 0x3c6a25a05d905654bd812731, 0xf473dbb400e14df5, 0x0,
        0x5f748642ae1443931d093af4, 0xddca2248291c024312127d87, 0xbbb00af8a51cc511, 0x0,
        0x100000000000000008a16fd00888d3c49, 0x10000000000000000701b1de1a64611a5,
        0x7bb19b6adc4d85f4, 0x2fd5ac7d0446c0d3, 0xd548dda6e1f541d784d4c228,
        0x3bc7fbd282f26a90865b5b09, 0x3b648ed118007c3, 0x0, 0x5a28118c93a1de7664b1d6ba,
        0x919d9a3d5dfce3b255589541, 0x883bab5b394b16cf, 0x0, 0x7f7b9792bad13df8, 0xf56d08780b0b13f5,
        0x535b7499f702bf5d, 0xce3ee818c4660dc, 0xbc08950bb2cf7b7d9eeda922,
        0xb2b86106457dfc8ec9cffb7e, 0xe835a6fda5354661, 0x0, 0xdca7ee443dbdfb5bab9335d5,
        0x1e062663e3974b0f7b798cb4, 0x37d153aaefa189f2, 0x0, 0x5aba5c5df852e79b,
        0x10000000000000000a37bff5d07f4f628, 0x399451b7748ce4b8,
        0x1000000000000000006a4728421f58565, 0xa46be4f636be4779570df4e8, 0x7380a6e3dc3aa91b3650ca10,
        0x3ef088ac9bc45c0e, 0x0, 0xce7710a9c0715f82fea0f76a, 0xf51283a23eaaaca518d43319,
        0x5069f990b18886d0, 0x0, 0xa5ba5bf9830a178c, 0xf8d715433d751f7e,
        0x1000000000000000001b585fab6a98780, 0x100000000000000001ee3ebda652c4c63,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xafc19dabd2b0bef1f47a78e4,
                limb1: 0x64c8cfa2f6ce21bd45380a70,
                limb2: 0xd6ec71e82872d984,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x1afed7037f7e7362dceb03ec,
                limb1: 0x149013c6ed7333d6e4ded96a,
                limb2: 0xaf1489c5a6180b55,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256K1_10P() {
    let mut data = array![
        0xa, 0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0,
        0xfdfdc509f368ba4395773d3a, 0x8de2b60b577a13d0f83b578e, 0xc2dd970269530ba2, 0x0,
        0x589fa250d638e35400c12ddf, 0xb3aac19fcb5095808402aa7f, 0xed6de6590d0195d1, 0x0,
        0x2965eeb3ec1fe786a6abe874, 0x33e2545f82bb6add02788b8e, 0xf586bc0db335d7b8, 0x0,
        0x155b35991489db2fdf4de620, 0xf24ce461346a182d67eeccf0, 0xb4122bb4b37cc7d5, 0x0,
        0x12815740835b12f70b96c66f, 0xbfa76a8b80aec9f2e31c40cc, 0xcd8a26d17d33c7c1, 0x0,
        0x9a8f496f09402b8fd6beb89b, 0x28e48918dad2123d7f202bef, 0xcdd11b6ffb3f8614, 0x0,
        0xb5076be8537cff2a42c6db68, 0x1066d40cbd01a3752e4e069c, 0x123ec2fd302cb0f9, 0x0,
        0xc85f5e5efdf415f8081bf53f, 0xadc5010e9d9ac6c64000d33d, 0xf81314011d8852e4, 0x0,
        0xd5915098d3d2001310b0b935, 0x88bb4507ebf1be82cfba2397, 0x8a463f1c00ce885f, 0x0,
        0x414858f8a83f9d4498890137, 0xa09c4658c47ace74c42cdb60, 0x8aaf300ff3ab7d98, 0x0,
        0x1772eb803ddc8a82e23b1c05, 0xc26baeb89b03fd69eb64b337, 0x4ea7131b2d873a45, 0x0,
        0xc9d16330db15efd90235eed9, 0x1b586ef360673d36baa16189, 0xee652d2b848ad111, 0x0,
        0x68f9e7942638253f3b596f1f, 0xb37e6153d9accd97a344f384, 0xda48eae9ff614551, 0x0,
        0xc58be8ed857035b34f51c620, 0x3b14ed53116cb7c1db000006, 0x7dfa292fe99b77dd, 0x0,
        0xf7f7bd2513c1b31de932bbd2, 0x627e2fa74b7ac891f7d555c7, 0x7f8a094f818e7192, 0x0,
        0x9b47b9326b668e62071faf18, 0xe21058cb6937afa89be6931a, 0x21a4bfb4cce2ac8c, 0x0,
        0xaf4ad4d7d582b10b14c97e6c, 0xadf808c85e766e997e470fd0, 0x2714571e587ce46d, 0x0,
        0x86a7815dad7e8a53b19fee2, 0x1922fc1efcc51e68146ffa1b, 0x9e19b7c1f886488e, 0x0, 0xa,
        0xd3fbf47a7e5b1e7f9ca5499d004ae545, 0xbaf3897a3e70f16a55485822de1b372a,
        0x101fbcccded733e8b421eaeb534097ca, 0x38c1962e9148624feac1c14f30e9c5cc,
        0x247a8333f7b0b7d2cda8056c3d15eef7, 0x1759edc372ae22448b0163c1cd9d2b7d,
        0xe005b86051ef1922fe43c49e149818d1, 0x7d41e602eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x552f233a8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x8c1745a79a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x5129fb7c6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x870e15c2fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0xadc0da7a16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x148b2758d7ab792809e469e6ec62b2c8, 0x2,
        0x278357bca21047e53cebcc8a, 0x5e183af032bbb7d3addb0053, 0x69f0f0d699ad0da, 0x0,
        0x4f4baec4857a9e113c4bc046, 0x59934dd81f724602c55be112, 0x8ce0ab262b3c3676, 0x0,
        0x2ef5cbfbef5479e9, 0x6fffb6b3d9f3ca00, 0xf99949f846de0180, 0x19226f35ed7d16dd,
        0xb153c64d6f19ccd0278c6b94, 0x398a04c551fc8f74aa610c1, 0x2d39d1e12f83b407, 0x0,
        0x8feed9f3a486593099594eab, 0x2571bc5e1f54fbed340811bf, 0xbbd2a19c5275b47c, 0x0,
        0x8950a7e57cb188c3, 0x915677115b4cd35f, 0x10000000000000000adff605ec8f8e9b5,
        0x10000000000000000ebfc6d2272e97ea1, 0x4caef24e507f272f30b7c823, 0x5273dc9feb3629a58072cedb,
        0x2854b0b223aa71f0, 0x0, 0xac66b42ece626c4bf206c037, 0xc8b1c6f40a2edf407ce41397,
        0x7c13db0a671e8662, 0x0, 0xa5060dbc57d602fe, 0x6914b48dc0c5534, 0x1b984728b0823ac8,
        0x10000000000000000040e1ff5866bad1f, 0xc0ea96b4755baeb8090366aa, 0xcbfcbba1c8e0c3aa488fe399,
        0xb1f7eea21e3d2ebe, 0x0, 0x769b003ec5b35afb7a3a9dbb, 0x2a28c3b33652ef6083180502,
        0xb8a171b80bdab536, 0x0, 0x100000000000000007cbe66bb133fe6dc,
        0x10000000000000000f0156c908c9d979c, 0x6b7c419ad9ed10d3, 0x1007811bd8c66050,
        0x196c84114c4e6fd84943ae10, 0xb2b1bfb6e4a2d665b61a30e8, 0x3f7696cdb3ac6c, 0x0,
        0x532d5b9de002db8f9775590d, 0x113ca5d5d68dbb4ad52542cb, 0xd4ebd6d9511abbd8, 0x0,
        0x100000000000000001ee58c7660c5446b, 0x6ec3e8f177762e53,
        0x100000000000000004538bd9c129bed52, 0x10000000000000000680a1770588f346e,
        0x7d64eea8c9bb0b269ceb0809, 0x35432fa6ed8233fa1a176ea9, 0x4bb75b24119f877, 0x0,
        0x68c57d7b2100616b5d4f104e, 0x8f4d438beb46139b440e571a, 0x3e63373ef063d4df, 0x0,
        0x31b70045caadb0df, 0x3c110d9c03771d4f, 0x10000000000000000d3c49e4016b7ecb4,
        0x10000000000000000cc890a6969b1a6e8, 0x2b695a4e6347bbe52bec6d29, 0xdd7ea9c6e862c5502f09e620,
        0x94eed93be116d060, 0x0, 0xdbc07e9625599f80c1d400b, 0x33ba3da84dfdc5a2156437fc,
        0x5baa7e2b8dd19cf3, 0x0, 0x22c35f43afc49a04, 0x267ff348a27461d3, 0x4a5f5d7ebb83d89c,
        0x100000000000000002481d409cb1131a6, 0x25d13d57845635a3e479c501, 0x4bf3cea4d7858ac08ea61048,
        0xeb01baa639087890, 0x0, 0xbf474987bdb67ad514ce70d, 0x25fa6f5fd0491ecf3c292ad7,
        0xc7fdc6797752a36f, 0x0, 0x7c6ad3604c315150, 0x100000000000000002bc61778337cab95,
        0xa8c3d96ce6c35e35, 0x79d7ca1b47402407, 0xc67a7a0c9df3fdf85ec5e7bb,
        0x5670672aadc54cf37a60ad0f, 0xa123dd3cd9abff2, 0x0, 0x7df5d7f0d76e984c5f7c7d1b,
        0x28ea2c9960be29367b03d650, 0x217ad558610431f, 0x0, 0x4dcbb5eb0dd68cef, 0x85c36b384754ae7e,
        0x100000000000000006cb2ed250bb203bb, 0x100000000000000004be1fd4931e473e2,
        0x5d40472f64481ec66b6dfdcb, 0xd9d5a457d4f31dcc2466d69c, 0x449dc00f6eae442, 0x0,
        0x6c92237c0eb59cbc2c25069c, 0x11d28a7835aabe323b14a8c6, 0x921e2140e6ae64cd, 0x0,
        0x1000000000000000065147afbdc695a04, 0x10000000000000000018d0e419fe453c3,
        0x1000000000000000032ded75d2eb0eb80, 0x10000000000000000ee7c926d371453c4,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x1c835913f9cca4833f4dee66,
                limb1: 0x192924721b46c95f86539366,
                limb2: 0xb6324fc7eea725e5,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x1655ccd2f516c24c8b23cd23,
                limb1: 0x5a78708d282fbf676e9eafa4,
                limb2: 0x8f71e12b03a69c94,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256K1_11P() {
    let mut data = array![
        0xb, 0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0,
        0xfdfdc509f368ba4395773d3a, 0x8de2b60b577a13d0f83b578e, 0xc2dd970269530ba2, 0x0,
        0x589fa250d638e35400c12ddf, 0xb3aac19fcb5095808402aa7f, 0xed6de6590d0195d1, 0x0,
        0x2965eeb3ec1fe786a6abe874, 0x33e2545f82bb6add02788b8e, 0xf586bc0db335d7b8, 0x0,
        0x155b35991489db2fdf4de620, 0xf24ce461346a182d67eeccf0, 0xb4122bb4b37cc7d5, 0x0,
        0x12815740835b12f70b96c66f, 0xbfa76a8b80aec9f2e31c40cc, 0xcd8a26d17d33c7c1, 0x0,
        0x9a8f496f09402b8fd6beb89b, 0x28e48918dad2123d7f202bef, 0xcdd11b6ffb3f8614, 0x0,
        0xb5076be8537cff2a42c6db68, 0x1066d40cbd01a3752e4e069c, 0x123ec2fd302cb0f9, 0x0,
        0xc85f5e5efdf415f8081bf53f, 0xadc5010e9d9ac6c64000d33d, 0xf81314011d8852e4, 0x0,
        0xd5915098d3d2001310b0b935, 0x88bb4507ebf1be82cfba2397, 0x8a463f1c00ce885f, 0x0,
        0x414858f8a83f9d4498890137, 0xa09c4658c47ace74c42cdb60, 0x8aaf300ff3ab7d98, 0x0,
        0x1772eb803ddc8a82e23b1c05, 0xc26baeb89b03fd69eb64b337, 0x4ea7131b2d873a45, 0x0,
        0xc9d16330db15efd90235eed9, 0x1b586ef360673d36baa16189, 0xee652d2b848ad111, 0x0,
        0x68f9e7942638253f3b596f1f, 0xb37e6153d9accd97a344f384, 0xda48eae9ff614551, 0x0,
        0xc58be8ed857035b34f51c620, 0x3b14ed53116cb7c1db000006, 0x7dfa292fe99b77dd, 0x0,
        0xf7f7bd2513c1b31de932bbd2, 0x627e2fa74b7ac891f7d555c7, 0x7f8a094f818e7192, 0x0,
        0x9b47b9326b668e62071faf18, 0xe21058cb6937afa89be6931a, 0x21a4bfb4cce2ac8c, 0x0,
        0xaf4ad4d7d582b10b14c97e6c, 0xadf808c85e766e997e470fd0, 0x2714571e587ce46d, 0x0,
        0x86a7815dad7e8a53b19fee2, 0x1922fc1efcc51e68146ffa1b, 0x9e19b7c1f886488e, 0x0,
        0x17bc74c409191a2b2249d987, 0xf4fe5f79db38f3064f7d093e, 0x3536ce04295e2a42, 0x0,
        0xb1d36a10f008c1c24de1ad7d, 0xa4f2190c71ee5e0ff07c48f8, 0x21c1a2d4cfff3233, 0x0, 0xb,
        0x101fbcccded733e8b421eaeb534097ca, 0x38c1962e9148624feac1c14f30e9c5cc,
        0x247a8333f7b0b7d2cda8056c3d15eef7, 0x1759edc372ae22448b0163c1cd9d2b7d,
        0xe005b86051ef1922fe43c49e149818d1, 0x7d41e602eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x552f233a8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x8c1745a79a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x5129fb7c6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x870e15c2fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0xadc0da7a16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x148b2758d7ab792809e469e6ec62b2c8,
        0xd450fe4aec4f217bb306d1a8e5eeac76, 0xd67e55fd642bfa42aef9c00b8a64c1b9,
        0x85940927468ff53d864a7a50b48d73f1, 0x37176e84d977e9933c49d76fcfc6e625, 0x2,
        0x7a385b48241ff9b7472584bc, 0xfb86d85d87b00caed733ad64, 0xa1b750a9ad42265e, 0x0,
        0x3c91608638f07e6b127effa, 0xbeb39c70848314492f0b1e9c, 0xba02c3181f197560, 0x0,
        0x8950a7e57cb188c3, 0x915677115b4cd35f, 0x10000000000000000adff605ec8f8e9b5,
        0x10000000000000000ebfc6d2272e97ea1, 0x17404de3e819f065de7c1017, 0x536d661a4644833c20a0cb4,
        0x1f70dd88b20f7871, 0x0, 0x1aaa9311df61995c80ac577e, 0xa164780ea8788997ea2c423f,
        0x83592576e08cd1fc, 0x0, 0xa5060dbc57d602fe, 0x6914b48dc0c5534, 0x1b984728b0823ac8,
        0x10000000000000000040e1ff5866bad1f, 0x20ff56624796b65fd048677d, 0xe383e9098b0d38b210aecacc,
        0xc935268d99a6ed4f, 0x0, 0xa4c981a051c154841b31dd75, 0x13a468f6a24a22757a8a9380,
        0x3d65cc664e17a287, 0x0, 0x100000000000000007cbe66bb133fe6dc,
        0x10000000000000000f0156c908c9d979c, 0x6b7c419ad9ed10d3, 0x1007811bd8c66050,
        0x72ce4e4dc43d1db4a97b15eb, 0x9ac63f1462d8befc6ff716f2, 0xdd1b010de89e6bc9, 0x0,
        0xc040c8c28bb16bed1cb5c089, 0xdb44fcda4787ab558fea8dd4, 0xd22d7176551ddc90, 0x0,
        0x100000000000000001ee58c7660c5446b, 0x6ec3e8f177762e53,
        0x100000000000000004538bd9c129bed52, 0x10000000000000000680a1770588f346e,
        0xd7ed39d04214f124fb9a5454, 0x86156f125d3f2fd0836c41f4, 0x5b9651563d384ca0, 0x0,
        0x1b663c9b6d949019c972b35f, 0x57c5020ee6fa7595d7ff9733, 0x34a8daa071411071, 0x0,
        0x31b70045caadb0df, 0x3c110d9c03771d4f, 0x10000000000000000d3c49e4016b7ecb4,
        0x10000000000000000cc890a6969b1a6e8, 0xfd20e510eb06b6b6cd26caa1, 0x4ed7a07b13deb87f778930b1,
        0xf32b6d3cca1243b3, 0x0, 0x3cc0c83359b0da6a89b90f6f, 0xcc2ad62f07d5162679f1aead,
        0xfab1a759721ba470, 0x0, 0x22c35f43afc49a04, 0x267ff348a27461d3, 0x4a5f5d7ebb83d89c,
        0x100000000000000002481d409cb1131a6, 0x7ab94096eb99e777f21f264a, 0x2833b6cb1e9b57aca3255927,
        0xe9577cffafa96848, 0x0, 0x211e8205578e14223b57d0e, 0x7524d5e57dfb8062ee504b92,
        0x699257546ab9c7fc, 0x0, 0x7c6ad3604c315150, 0x100000000000000002bc61778337cab95,
        0xa8c3d96ce6c35e35, 0x79d7ca1b47402407, 0xaa1d36523b9bbf173e28862b,
        0x5cef005c976b645423a14da0, 0x5457f1479f27d0c4, 0x0, 0x6e15d05091cef49e6e490159,
        0xebc02df9a0a4608fe67588c1, 0x23eaba74cbb63d26, 0x0, 0x4dcbb5eb0dd68cef, 0x85c36b384754ae7e,
        0x100000000000000006cb2ed250bb203bb, 0x100000000000000004be1fd4931e473e2,
        0x910d0a96046e92b7cd582798, 0xbff23854f39adfd43e26c5d4, 0xb51e917d6c662c76, 0x0,
        0x292829fd70bf0df94c146d72, 0xdca27ae811d3ebc462421967, 0x1b2a813516fdba2c, 0x0,
        0x1000000000000000065147afbdc695a04, 0x10000000000000000018d0e419fe453c3,
        0x1000000000000000032ded75d2eb0eb80, 0x10000000000000000ee7c926d371453c4,
        0xe5fe5d19f302b11f287cc8be, 0x247647c30315ec0eb6056189, 0x9de7876737227ed5, 0x0,
        0xf98723a6e18a798271d5b545, 0x58f73113c3451ed86535f3f2, 0x7c4449246418862d, 0x0,
        0x100000000000000000139803cda63f3ba, 0x1000000000000000016b7cf2653dc74a8,
        0x1089abd09e19fd5df, 0xc69eeeb967755694, 0xfdaa8c8434c1fdf1f6736acd,
        0xbb1563781b62fc9b97ec831c, 0x4a33d42ad138f3ae, 0x0, 0x61cfb29de0788d394e459f95,
        0x4c2cf12dc88f92c32a6186ae, 0xa44f474e566f0d73, 0x0, 0x4f62e61d803963a6, 0x6f08b65992670489,
        0x67cea05dbb9a909d, 0x96fb2bd0b03403bc,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x64fc5a7a1dbb0ded5877d244,
                limb1: 0x690efd6ba8db4b9093e04859,
                limb2: 0x4a95e2ad2036bb89,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x787161946cccf45a982322c8,
                limb1: 0xfb559d2c2a26b632cf7c2894,
                limb2: 0x4ed9af33445b7a3f,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256K1_12P() {
    let mut data = array![
        0xc, 0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0,
        0xfdfdc509f368ba4395773d3a, 0x8de2b60b577a13d0f83b578e, 0xc2dd970269530ba2, 0x0,
        0x589fa250d638e35400c12ddf, 0xb3aac19fcb5095808402aa7f, 0xed6de6590d0195d1, 0x0,
        0x2965eeb3ec1fe786a6abe874, 0x33e2545f82bb6add02788b8e, 0xf586bc0db335d7b8, 0x0,
        0x155b35991489db2fdf4de620, 0xf24ce461346a182d67eeccf0, 0xb4122bb4b37cc7d5, 0x0,
        0x12815740835b12f70b96c66f, 0xbfa76a8b80aec9f2e31c40cc, 0xcd8a26d17d33c7c1, 0x0,
        0x9a8f496f09402b8fd6beb89b, 0x28e48918dad2123d7f202bef, 0xcdd11b6ffb3f8614, 0x0,
        0xb5076be8537cff2a42c6db68, 0x1066d40cbd01a3752e4e069c, 0x123ec2fd302cb0f9, 0x0,
        0xc85f5e5efdf415f8081bf53f, 0xadc5010e9d9ac6c64000d33d, 0xf81314011d8852e4, 0x0,
        0xd5915098d3d2001310b0b935, 0x88bb4507ebf1be82cfba2397, 0x8a463f1c00ce885f, 0x0,
        0x414858f8a83f9d4498890137, 0xa09c4658c47ace74c42cdb60, 0x8aaf300ff3ab7d98, 0x0,
        0x1772eb803ddc8a82e23b1c05, 0xc26baeb89b03fd69eb64b337, 0x4ea7131b2d873a45, 0x0,
        0xc9d16330db15efd90235eed9, 0x1b586ef360673d36baa16189, 0xee652d2b848ad111, 0x0,
        0x68f9e7942638253f3b596f1f, 0xb37e6153d9accd97a344f384, 0xda48eae9ff614551, 0x0,
        0xc58be8ed857035b34f51c620, 0x3b14ed53116cb7c1db000006, 0x7dfa292fe99b77dd, 0x0,
        0xf7f7bd2513c1b31de932bbd2, 0x627e2fa74b7ac891f7d555c7, 0x7f8a094f818e7192, 0x0,
        0x9b47b9326b668e62071faf18, 0xe21058cb6937afa89be6931a, 0x21a4bfb4cce2ac8c, 0x0,
        0xaf4ad4d7d582b10b14c97e6c, 0xadf808c85e766e997e470fd0, 0x2714571e587ce46d, 0x0,
        0x86a7815dad7e8a53b19fee2, 0x1922fc1efcc51e68146ffa1b, 0x9e19b7c1f886488e, 0x0,
        0x17bc74c409191a2b2249d987, 0xf4fe5f79db38f3064f7d093e, 0x3536ce04295e2a42, 0x0,
        0xb1d36a10f008c1c24de1ad7d, 0xa4f2190c71ee5e0ff07c48f8, 0x21c1a2d4cfff3233, 0x0,
        0xef493bf7016f192140ec0c20, 0x489bc5a24a83819834b3c08c, 0xcccdd6728670ed1e, 0x0,
        0xb2d8f23e9b244453602fae5a, 0x76fafc92aa2ea44429a3050e, 0xc6c6fb7c62dc6c2f, 0x0, 0xc,
        0x247a8333f7b0b7d2cda8056c3d15eef7, 0x1759edc372ae22448b0163c1cd9d2b7d,
        0xe005b86051ef1922fe43c49e149818d1, 0x7d41e602eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x552f233a8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x8c1745a79a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x5129fb7c6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x870e15c2fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0xadc0da7a16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x148b2758d7ab792809e469e6ec62b2c8,
        0xd450fe4aec4f217bb306d1a8e5eeac76, 0xd67e55fd642bfa42aef9c00b8a64c1b9,
        0x85940927468ff53d864a7a50b48d73f1, 0x37176e84d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x467437419466e4726b5f5241f323ca74,
        0xa425799aa905d7507e1ea9c573581a81, 0xfb82860deabca8d0b341facdff0ac0f1, 0x2,
        0xa87e6d457192ad65d259e791, 0x9228287912a17822cfae6f8f, 0x622e90ac5ea25d59, 0x0,
        0xef651884d008a32a2d116a87, 0xbdc4cdc9a1445b7005e4b44c, 0xdf1337bf8228bb28, 0x0,
        0xa5060dbc57d602fe, 0x6914b48dc0c5534, 0x1b984728b0823ac8,
        0x10000000000000000040e1ff5866bad1f, 0x48ff078b363f5d94cc9f63eb, 0x115c8cf2a38d0da440ebcbae,
        0x1b816a5e72b58557, 0x0, 0xfb6369ff14a7b85e6d35f7bf, 0x4e00e50aca1aa90a598bd7b3,
        0x8e70e3f336057410, 0x0, 0x100000000000000007cbe66bb133fe6dc,
        0x10000000000000000f0156c908c9d979c, 0x6b7c419ad9ed10d3, 0x1007811bd8c66050,
        0x8780bf2048f368173bec0c07, 0x5be44a71954e17bc36eccfd5, 0x4236fb0e86bcdf32, 0x0,
        0x8ec2eb1532b2b96c14bebef9, 0x7b980c967373d71a38ebf92, 0xb4336cf34bb238f5, 0x0,
        0x100000000000000001ee58c7660c5446b, 0x6ec3e8f177762e53,
        0x100000000000000004538bd9c129bed52, 0x10000000000000000680a1770588f346e,
        0x2b4f07edf389acd027af1e2b, 0xab8850651076565399b13fb, 0x501f99d468b51a7e, 0x0,
        0x8d3259be568e4af9d34e488a, 0x11366602fb75ddb2a230c632, 0x2eb403dd3d7fa0e8, 0x0,
        0x31b70045caadb0df, 0x3c110d9c03771d4f, 0x10000000000000000d3c49e4016b7ecb4,
        0x10000000000000000cc890a6969b1a6e8, 0xf1d15e674b76c9d0cb85672c, 0x2e8098be6d52b92e20c98bab,
        0x8acdee9ae1736d12, 0x0, 0x24f1249583774bb75801caa3, 0xaead17e1dc834bd1a624ac48,
        0x6a22bf5e98d9d9b7, 0x0, 0x22c35f43afc49a04, 0x267ff348a27461d3, 0x4a5f5d7ebb83d89c,
        0x100000000000000002481d409cb1131a6, 0x3494a03c71f4399881fd8880, 0x6ac1b4b6ca039c3d1286e70e,
        0xf2d9a056ea050a57, 0x0, 0xeaf37f80878445372361b216, 0xd41e8bc2aadf12bbc38751ef,
        0xa79a8a4e997661e5, 0x0, 0x7c6ad3604c315150, 0x100000000000000002bc61778337cab95,
        0xa8c3d96ce6c35e35, 0x79d7ca1b47402407, 0x6b284c5645d14cd1e45ce41d,
        0xef7365195e7be14a08d63f9, 0x79ebfed96dcb4d8c, 0x0, 0xa32f8ed8fc4e2819dbf5d354,
        0xbe62aa24eb445342493fb1c4, 0xdcc7ad508612f5f4, 0x0, 0x4dcbb5eb0dd68cef, 0x85c36b384754ae7e,
        0x100000000000000006cb2ed250bb203bb, 0x100000000000000004be1fd4931e473e2,
        0x13b1bbb13f7da105749db0c7, 0x65d1c3c7fbdeb2befeb39fec, 0x24e9141cf844f065, 0x0,
        0xfbb506c8ebd4fc51735b3359, 0x6319c6fb9d75f3f8d0fb8575, 0xc49721294a562789, 0x0,
        0x1000000000000000065147afbdc695a04, 0x10000000000000000018d0e419fe453c3,
        0x1000000000000000032ded75d2eb0eb80, 0x10000000000000000ee7c926d371453c4,
        0x93c576094dc85b72f72c8832, 0x654b95f3c73106a0d4381f75, 0xd731fce177c83fd9, 0x0,
        0xabbb1b3a35e3d538325af014, 0x259217577cc285a6b83953ee, 0x6383caf5d18c3339, 0x0,
        0x100000000000000000139803cda63f3ba, 0x1000000000000000016b7cf2653dc74a8,
        0x1089abd09e19fd5df, 0xc69eeeb967755694, 0xfb261e5abbce9c6f9a27475e,
        0x60775102ab55d73e343fc464, 0x92ed6dd8fd0f867a, 0x0, 0xf5668dbab0802c48eca685fb,
        0xe0ee5cbcf3dda9b624126e28, 0xd133f8ecb79a5748, 0x0, 0x4f62e61d803963a6, 0x6f08b65992670489,
        0x67cea05dbb9a909d, 0x96fb2bd0b03403bc, 0xdb5b96b385bbefcb8a8381ba,
        0x356746189fa0ba9f09af67fb, 0xb0aa6be9137e6b04, 0x0, 0x504768e8026a92690411fdf1,
        0x8f2862bfadfa61b926a651c7, 0xa2b129ae94ecfbc0, 0x0, 0x903c783ffbbcfae,
        0x10000000000000000a9647c65c4885765, 0x100000000000000004b4be4ce034de996,
        0x8fc19cd46a492745, 0x278a81bdcc0f4f0f1b17c004, 0xf44d7e6bc07af6f2ee512475,
        0x999ae67b5d65554a, 0x0, 0x6f57b1bfa3ea31cc6d8812f7, 0x709574ee1724876336af416d,
        0x6b54f96429ec82f6, 0x0, 0x984e110d1ee38dcc, 0x1000000000000000004d4f2a3b925c2b8,
        0x1000000000000000008b29d4fa5dec6e5, 0x100000000000000004e45715b78d9bfec,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x37558e45b8041762de768836,
                limb1: 0x5d514037c232b89fb7a06905,
                limb2: 0x2515485638a3a199,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xb85967bc1c9cde890f6a236f,
                limb1: 0xeece653858fb74a34a817724,
                limb2: 0x71995703660dd489,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_1P() {
    let mut data = array![
        0x1, 0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0, 0x1,
        0xb4862b21fb97d43588561712e8e5216a, 0x4b3e865e6f4590b9a164106cf6a659e, 0x4,
        0x62c2b89a3152e22243cf864d, 0xaf83913cf31609fd7b4f9a32, 0x6da9a48b077c3954, 0x0,
        0xa54703c64365ab4373eae904, 0x87e47f46101c003371e14338, 0x462e50d88b5b5c17, 0x0,
        0x21ef407bea1953254c1bc318a0af2527, 0x1c147c0993c84eed5f426b94b3350045,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x62c2b89a3152e22243cf864d,
                limb1: 0xaf83913cf31609fd7b4f9a32,
                limb2: 0x6da9a48b077c3954,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xa54703c64365ab4373eae904,
                limb1: 0x87e47f46101c003371e14338,
                limb2: 0x462e50d88b5b5c17,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_2P() {
    let mut data = array![
        0x2, 0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0,
        0x82e4a33f8e4e5881e791d86b, 0xbcb062435ae8ec5fdaeac4bf, 0x179e1bae9e0f9f34, 0x0,
        0x19657783ba5660e255c21849, 0x7ed7474bcea7551fc71e46bc, 0x596c0a76b75f4756, 0x0, 0x2,
        0x12e0c8b2bad640fb19488dec4f65d4d9, 0xa90f9c3af19922ad9b8a714e61a441c,
        0xeb2083e6ce164dba0ff18e0242af9fc3, 0x2fc154703983ca8ea7e9d498c778ea6, 0x4,
        0xcd7471596402adb99c204f6a, 0x71072cc6a799ca5492c35787, 0xaaecc4b08ca80c, 0x0,
        0x9df62dff1b19647a74925491, 0xcff3a8ebb8f88bfdab94c62, 0x7561a9c9a4e6450a, 0x0,
        0x211c4f690d00cb3af0b34c381ddf6429, 0x10dbbf233e0f266b14c85329c2440c426,
        0x20b84e815be93309f3490609, 0xcddf2646d9499c09fa01ac80, 0x47a3d45b5433479c, 0x0,
        0x257b7612e4301ed9448341a6, 0x4f3236c077377add9253d652, 0x3b0d15e6632e50c, 0x0,
        0x3242668a77ced3cb6ca4b87c1b759c91, 0x128e825972592d2a632df711368a1c105,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x78cd6990a813b6a2588ccb19,
                limb1: 0xcb57433fd1eaa5787491656f,
                limb2: 0x70e4c58e64e4a9f3,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x428873cad69986b7befbd0f0,
                limb1: 0x5dde16f78dd45ec0c5a51f9d,
                limb2: 0x67295fe953f1c748,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_3P() {
    let mut data = array![
        0x3, 0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0,
        0x82e4a33f8e4e5881e791d86b, 0xbcb062435ae8ec5fdaeac4bf, 0x179e1bae9e0f9f34, 0x0,
        0x19657783ba5660e255c21849, 0x7ed7474bcea7551fc71e46bc, 0x596c0a76b75f4756, 0x0,
        0xa6832ef7fe97f77de7cd9a62, 0xf18a70dbf1dc5a76c685da4a, 0x6ac1b7bfc409119f, 0x0,
        0x7751161b1a9ef600b865a5af, 0xed28aad4835a39a9e8318ceb, 0x572e95c429f0e07a, 0x0, 0x3,
        0xeb2083e6ce164dba0ff18e0242af9fc3, 0x2fc154703983ca8ea7e9d498c778ea6,
        0x101fbcccded733e8b421eaeb534097ca, 0x71832c59148624feac1c14f30e9c5cc,
        0x247a8333f7b0b7d2cda8056c3d15eef7, 0x2eb3db872ae22448b0163c1cd9d2b7d, 0x4,
        0xac2b5804f3b5ea6a7c385142, 0x67878b88a9a9d518e06d811c, 0x4549187a243009c8, 0x0,
        0x77b113304bc4ddbb1d09761d, 0xdeac72115bc7d3e18f4a0a72, 0x52c6b8f99ceb4be4, 0x0,
        0x3242668a77ced3cb6ca4b87c1b759c91, 0x128e825972592d2a632df711368a1c105,
        0xd4eecb0109a013892abd75e5, 0x167aa57abaa882be1301e3dd, 0x2457e48112697980, 0x0,
        0xb26742ddc3687f7d8983bc6e, 0xc6eb0f3fd431dccb4cd39680, 0x31fb690012ae0317, 0x0,
        0x25b58a4ace1755dfa44b5f1f5d91fdcb, 0x23fa824d04875112a551d6ef70fef39,
        0x6444144efd61c928f158778, 0x90d9eaffbf7e696c0b22614, 0x6879c7c3d7314db0, 0x0,
        0xd6ae7f02956e20ce1359317d, 0x3545b77c84a0952ba44fa34, 0x54c416a35489a439, 0x0,
        0x46f42706c0113ff0ccf72fe8f742fd2, 0x1035b8cd8e980519d9ab6ef3f50ee8fa9,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x9292b7770106624b91a73738,
                limb1: 0x2c9a7c1a0496485effe3922e,
                limb2: 0x7cc025fefaaec43f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x44e571d5378b2d6e5b1d7114,
                limb1: 0x5d34cb1a17260d862ef07e73,
                limb2: 0x3d6ee7ee0c8df451,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_4P() {
    let mut data = array![
        0x4, 0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0,
        0x82e4a33f8e4e5881e791d86b, 0xbcb062435ae8ec5fdaeac4bf, 0x179e1bae9e0f9f34, 0x0,
        0x19657783ba5660e255c21849, 0x7ed7474bcea7551fc71e46bc, 0x596c0a76b75f4756, 0x0,
        0xa6832ef7fe97f77de7cd9a62, 0xf18a70dbf1dc5a76c685da4a, 0x6ac1b7bfc409119f, 0x0,
        0x7751161b1a9ef600b865a5af, 0xed28aad4835a39a9e8318ceb, 0x572e95c429f0e07a, 0x0,
        0x5e71d0fc5d1c016834779173, 0xadd002dfc0ebf1b25c23c252, 0x40a868d928ae5233, 0x0,
        0x423fa293418d6e3f59c2e830, 0x7a4bcf26f93e71ffd903e68e, 0x7837b851ad8da6e3, 0x0, 0x4,
        0x101fbcccded733e8b421eaeb534097ca, 0x71832c59148624feac1c14f30e9c5cc,
        0x247a8333f7b0b7d2cda8056c3d15eef7, 0x2eb3db872ae22448b0163c1cd9d2b7d,
        0xe005b86051ef1922fe43c49e149818d1, 0xfa83cc0eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0xaa5e4678c25166a1ff39849b4e1357d, 0x4,
        0x338e295a7da6c8dc47afeb59, 0x93a4ff4ae149504868278a09, 0x418e9170913c0f5b, 0x0,
        0x5b20ca7e0ef2c05cc66e6a84, 0xdc8feaa2fc336cdbce46f0fa, 0x5e556f7c5bd833ed, 0x0,
        0x25b58a4ace1755dfa44b5f1f5d91fdcb, 0x23fa824d04875112a551d6ef70fef39,
        0xdf877be8a80fdde7e3b855b0, 0x91e54f2f86bd9262717e6b75, 0x7062334bd4c7b885, 0x0,
        0x9320d417f7513821af6e0284, 0x96ed52f40e0c8b60098260d8, 0xf8afa50615dfd75, 0x0,
        0x46f42706c0113ff0ccf72fe8f742fd2, 0x1035b8cd8e980519d9ab6ef3f50ee8fa9,
        0xfeec5e7debf32dad5e019ae9, 0x8bf005c9328632982aeaeed2, 0x1933fdb9e8d9ea7a, 0x0,
        0x56826fcbe77185341a6d2b8f, 0x69cbccb406ae88585a522de9, 0x76fc50497be174d7, 0x0,
        0x25f8e65eae4eb72e4febaca4a978a32e, 0x3138e75e7839c1e424a845740cd897e1,
        0xa2afdf272784379c88d18a53, 0x15e4f535a988eb9702bc3741, 0x2317d852a07769d1, 0x0,
        0x29cd9f41fe12ae23c14fe282, 0x85611a868445899f82b3529c, 0x676eb93f52742f3f, 0x0,
        0x1efc8eeeff5d60d288b61287fc750073, 0x1205819efd721c8fa9d99528aa8086dd8,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x54e30b1dbc54acd91542088c,
                limb1: 0x702b532dab377f0636d9f465,
                limb2: 0x25ee2efd1d7ca3f6,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xd25f547d7c2f7258cbdb9c6b,
                limb1: 0xcae4d4cae9a1aba26935de1e,
                limb2: 0x277ff10c5815321e,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_10P() {
    let mut data = array![
        0xa, 0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0,
        0x82e4a33f8e4e5881e791d86b, 0xbcb062435ae8ec5fdaeac4bf, 0x179e1bae9e0f9f34, 0x0,
        0x19657783ba5660e255c21849, 0x7ed7474bcea7551fc71e46bc, 0x596c0a76b75f4756, 0x0,
        0xa6832ef7fe97f77de7cd9a62, 0xf18a70dbf1dc5a76c685da4a, 0x6ac1b7bfc409119f, 0x0,
        0x7751161b1a9ef600b865a5af, 0xed28aad4835a39a9e8318ceb, 0x572e95c429f0e07a, 0x0,
        0x5e71d0fc5d1c016834779173, 0xadd002dfc0ebf1b25c23c252, 0x40a868d928ae5233, 0x0,
        0x423fa293418d6e3f59c2e830, 0x7a4bcf26f93e71ffd903e68e, 0x7837b851ad8da6e3, 0x0,
        0x5907087f8e8e4dacdd039371, 0xc390e2073b4e64b9ede0570d, 0x6b039a85962f1594, 0x0,
        0xc45eefa03155b8f7eb780b42, 0x3db57eb22f9b0394a4d7b78e, 0x6cf45b6d90883f60, 0x0,
        0x60dd8ed0a614b596fb37eb1f, 0xabb99f371be41e26ec2d8e4b, 0x187ecd72c40f159d, 0x0,
        0x7b66c9263de5e1663622985d, 0x118b032cc27a1d6dd192eca6, 0x312fb405788616e8, 0x0,
        0xf4ac3e1f1f068dd64c86fdda, 0x24594e591d82a7f964b5ec9f, 0x6ca311b5421c57fc, 0x0,
        0x42745cd7b146012455434d0f, 0x6aa4f552b7bdc93a613bd9df, 0x5832a065d7199c7a, 0x0,
        0x341786b7854e3e0104e2e416, 0xbb368441c295043bee7b1d2f, 0x35c88542e11463b4, 0x0,
        0x3c36e7fcc4e2fde28308132, 0xf58043d0e3d1a36d1f8137fc, 0x58c1508fbe8868a8, 0x0,
        0x560a37951d69a6c8d7138239, 0x462d454a509846714184ef71, 0x3aaf8fb4f60e3e9c, 0x0,
        0xb70cea4e13db5322899753f9, 0x6c62656b6d7ffb5c2af44fd5, 0x4b5ae4567dc6a7c0, 0x0,
        0xb06cccb4b425d5179f528270, 0xce017c281a3861570706cd86, 0x42d14846dc4860ab, 0x0,
        0x646bf486f6e77663c597ece8, 0xd87c8c36a430a6fe42305b88, 0x7964c7742b6f13da, 0x0, 0xa,
        0x2648ee38e07405eb215663abc1f254b8, 0x29164ebd7ab792809e469e6ec62b2c8,
        0x85940927468ff53d864a7a50b48d73f1, 0x6e2edd0d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x8ce86e89466e4726b5f5241f323ca74,
        0x30bcab0ed857010255d44936a1515607, 0x8ac57cfbb42e0b20426465e3e37952d,
        0x5f3f563838701a14b490b6081dfc8352, 0xda2ddc3552116dd2ba4b180cb69ca38,
        0xc87a746319c16a0d0febd845d0dfae43, 0x7003168b29a8b06daf66c5f2577bffa,
        0x176ea1b164264cd51ea45cd69371a71f, 0x3b6a666fb0323a1d576d4155ec17dbe,
        0x9edfa3da6cf55b158b53031d05d51433, 0x23d79a9428a1c22d5fdb76a19fbeb1d,
        0x4d125e7fa59cec98126cbc8f38884479, 0x1f40f472e2950656fa231e959acdd98,
        0x98b33c6e0a14b90a7795e98680ee526e, 0xc8555a9fcfcfa81b306d70019d5f970, 0x4,
        0xb51ed06dd615b64d198d6b40, 0xc6014a9ec6d192c15f73d83, 0x4236ece07ab7f046, 0x0,
        0x8f62a668da7f4862606fc8ee, 0xc2af7ed7c76e0384d7f30cb1, 0x2ee4a538de1cb3e1, 0x0,
        0x109e48ca918759429cee2d75a919bf, 0x254dce38863be7379de4e89912d39a24,
        0xd64052a1c3dddd0acfc5f6de, 0x81b4284ddeec997a06f7adbb, 0x2a3e2e0b8b6db118, 0x0,
        0xeb1fb40ed774d5a5a932cbcd, 0x69a12cf14a2add045b8a6b2a, 0x5b9b707cde7cba42, 0x0,
        0x62af3a314ed8541630e74b78e9f03a0, 0x3e5106e138112347fd7dbb662f3fb959,
        0x76a17d0e9a7acdde761cf17e, 0x9df10374167580666440f792, 0x71e338c631665afe, 0x0,
        0xa37e8ec892cfd84673ff810f, 0x4ff99d688a4d76e5fae62c7c, 0x10ab842e4b509be8, 0x0,
        0x100999da2383a787fc58bce955201c59, 0x2d492fcea91c7b9e8fa3931db543fa13,
        0x9c40d5ca5c4f37890bb899f8, 0x39b20e332317d1cc680cac6b, 0x2c9116e237dcd2c2, 0x0,
        0xee4f6acf3ccd375ceb6fda83, 0x82a46494eb678a382d67337b, 0xa451fa8fc325a99, 0x0,
        0x2be10b93bdf768ae7778b99191b2cf05, 0x19d5b37430b75b04d20856a7ba530478,
        0xde61d931ad4af1b6aa3b7420, 0xebfb852ab0963b3bd6b97d01, 0x62f2626356a4e691, 0x0,
        0x311bab2cac0350b9be3e7c11, 0x213c4209753d44f212a6085f, 0x7ef9ef4df118cf30, 0x0,
        0x306359e58443dc9fa7b677c05b67bc03, 0x22f5c652ce175682bece3c707b7f0c64,
        0xc22428dd359a4d97677d1a2a, 0x6a403588ae0f11e6852c9003, 0x265ca2a9c81b7fcd, 0x0,
        0x41e8bf26a5f61a80ed2a1a4f, 0x4816633adc2e1a1ecbdefd13, 0x78d97cf47703cd10, 0x0,
        0x1af8531e7421e1b5fc3f282922950413, 0x12802c684a9d9ebd5f6c8d17c2c0dce9a,
        0xf78d57c527f35f5b17341ad, 0x9b93fae1633f0f504ea60e41, 0x23373872d46eb70b, 0x0,
        0x654177c81ab44be525fc8a10, 0xcf56847d39c0dc1808c5626c, 0x692fda489d9ad018, 0x0,
        0x3e15cff10f1609922ab32f8f9278107, 0x10a16e8bfef9be00041b12d3df0ab90d2,
        0x32ffdcb0ebe78606cfda3864, 0x810f43c0463b6222100c039d, 0x2676d3d3af79c942, 0x0,
        0xe20135efdb9ce9d0b1f0b087, 0x16a1b8a19bb224519871ad10, 0x54b74ede0f974b53, 0x0,
        0x2be5e02dea43047daaed4fbaf06fafca, 0x1de6096b4f0d2f729b2b56af6ca9e273,
        0x1395db0ef36c4e2931f84d21, 0x27adbaec38ab1b5c362047ca, 0x39e135d80347ccff, 0x0,
        0xddfc395884c79d27da8fb121, 0x3ed6197d9e6d701775f0b246, 0x4f49fa341a6be18, 0x0,
        0x5e0ad7648a4f59729af8617b82d4b15, 0x1204a5942db3ff32572d539505799c162,
        0xfed466728e21ebb6ec730686, 0x4c84b97d2b2b549c0205e93d, 0x6d18c143ec437b75, 0x0,
        0x1375c64d45b624c9fcbbbfc7, 0xa154d66ebcc37fc1b61f1bd0, 0x35765a06dfd06c00, 0x0,
        0x1bb625624ceab37b75f8eb6d9baaec37, 0x8869d6e2bfcd45999b706e500bdf6e9,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x9dd56ed7fdf1e5a3e9cbb3b5,
                limb1: 0xd0df8ca018c550bbd230f67,
                limb2: 0x75b3c38a01fed369,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xa1bb56d8c1b7c9598a692c1c,
                limb1: 0xc940b96f597931f22e3c4b07,
                limb2: 0x41ca6082f12494f3,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_11P() {
    let mut data = array![
        0xb, 0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0,
        0x82e4a33f8e4e5881e791d86b, 0xbcb062435ae8ec5fdaeac4bf, 0x179e1bae9e0f9f34, 0x0,
        0x19657783ba5660e255c21849, 0x7ed7474bcea7551fc71e46bc, 0x596c0a76b75f4756, 0x0,
        0xa6832ef7fe97f77de7cd9a62, 0xf18a70dbf1dc5a76c685da4a, 0x6ac1b7bfc409119f, 0x0,
        0x7751161b1a9ef600b865a5af, 0xed28aad4835a39a9e8318ceb, 0x572e95c429f0e07a, 0x0,
        0x5e71d0fc5d1c016834779173, 0xadd002dfc0ebf1b25c23c252, 0x40a868d928ae5233, 0x0,
        0x423fa293418d6e3f59c2e830, 0x7a4bcf26f93e71ffd903e68e, 0x7837b851ad8da6e3, 0x0,
        0x5907087f8e8e4dacdd039371, 0xc390e2073b4e64b9ede0570d, 0x6b039a85962f1594, 0x0,
        0xc45eefa03155b8f7eb780b42, 0x3db57eb22f9b0394a4d7b78e, 0x6cf45b6d90883f60, 0x0,
        0x60dd8ed0a614b596fb37eb1f, 0xabb99f371be41e26ec2d8e4b, 0x187ecd72c40f159d, 0x0,
        0x7b66c9263de5e1663622985d, 0x118b032cc27a1d6dd192eca6, 0x312fb405788616e8, 0x0,
        0xf4ac3e1f1f068dd64c86fdda, 0x24594e591d82a7f964b5ec9f, 0x6ca311b5421c57fc, 0x0,
        0x42745cd7b146012455434d0f, 0x6aa4f552b7bdc93a613bd9df, 0x5832a065d7199c7a, 0x0,
        0x341786b7854e3e0104e2e416, 0xbb368441c295043bee7b1d2f, 0x35c88542e11463b4, 0x0,
        0x3c36e7fcc4e2fde28308132, 0xf58043d0e3d1a36d1f8137fc, 0x58c1508fbe8868a8, 0x0,
        0x560a37951d69a6c8d7138239, 0x462d454a509846714184ef71, 0x3aaf8fb4f60e3e9c, 0x0,
        0xb70cea4e13db5322899753f9, 0x6c62656b6d7ffb5c2af44fd5, 0x4b5ae4567dc6a7c0, 0x0,
        0xb06cccb4b425d5179f528270, 0xce017c281a3861570706cd86, 0x42d14846dc4860ab, 0x0,
        0x646bf486f6e77663c597ece8, 0xd87c8c36a430a6fe42305b88, 0x7964c7742b6f13da, 0x0,
        0x52c487a17925c92335926072, 0x13155d04b743220ba9c4dd31, 0x1106c832e8e52057, 0x0,
        0xbc69df5aa9a21ba08f160d5f, 0xc207c95ac5d454f546b05fc3, 0x574515b32b35f440, 0x0, 0xb,
        0x85940927468ff53d864a7a50b48d73f1, 0x6e2edd0d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x8ce86e89466e4726b5f5241f323ca74,
        0x30bcab0ed857010255d44936a1515607, 0x8ac57cfbb42e0b20426465e3e37952d,
        0x5f3f563838701a14b490b6081dfc8352, 0xda2ddc3552116dd2ba4b180cb69ca38,
        0xc87a746319c16a0d0febd845d0dfae43, 0x7003168b29a8b06daf66c5f2577bffa,
        0x176ea1b164264cd51ea45cd69371a71f, 0x3b6a666fb0323a1d576d4155ec17dbe,
        0x9edfa3da6cf55b158b53031d05d51433, 0x23d79a9428a1c22d5fdb76a19fbeb1d,
        0x4d125e7fa59cec98126cbc8f38884479, 0x1f40f472e2950656fa231e959acdd98,
        0x98b33c6e0a14b90a7795e98680ee526e, 0xc8555a9fcfcfa81b306d70019d5f970,
        0xebe2136898c752051e01a934402d0baf, 0x6c2a492cc0f859aa6524ab713b7e05,
        0x637e0edc5b6e4ae7a62081434fbaecc0, 0x4e8c1e4403d1f83a859890cd670f668, 0x4,
        0x8d9da7701d08684a79c3c9a, 0x7b0faee9af3327934d090e7b, 0x151533e6a0b794f9, 0x0,
        0xac7e4649ec69e08fa2aa440b, 0xd82ea8c5365beebbfc40ecc, 0x38290dcf3704f737, 0x0,
        0x62af3a314ed8541630e74b78e9f03a0, 0x3e5106e138112347fd7dbb662f3fb959,
        0x78f18f4fb87ce5e32a5ac01, 0x84e0525afbc64b068cb6e83f, 0x679bfbb0e8f543d, 0x0,
        0x6fc9c69b7f2a72ee149372db, 0x5365848854ebf2c4cc13846c, 0x159f12f1f03023c3, 0x0,
        0x100999da2383a787fc58bce955201c59, 0x2d492fcea91c7b9e8fa3931db543fa13,
        0x9c5453b82378379d24968334, 0xfd07ecb3fa7e01e989a2c80e, 0x2abb3011d1e59739, 0x0,
        0x70aab3462dc41390fb5d5945, 0x370b9445bf570bbc08f08c5e, 0x5a10e78a2d5b49fe, 0x0,
        0x2be10b93bdf768ae7778b99191b2cf05, 0x19d5b37430b75b04d20856a7ba530478,
        0xe20e3a8f807f193989382239, 0x3ab3cda492b3306dc2b43c41, 0x6c0baedb36072eff, 0x0,
        0xd3c4bb13b9e5e81a81545d4e, 0xd51c83211a5f2730fbba7376, 0x4a495b6570c26a1e, 0x0,
        0x306359e58443dc9fa7b677c05b67bc03, 0x22f5c652ce175682bece3c707b7f0c64,
        0x6e30168d06be82ea3d69d68a, 0xda5ae968ed031509a07db5ea, 0x5762b3c39c6fe86f, 0x0,
        0x74419c84014bf3e0732f88a3, 0x838840e4c0101d2d3541fb62, 0x74c06cf05074141d, 0x0,
        0x1af8531e7421e1b5fc3f282922950413, 0x12802c684a9d9ebd5f6c8d17c2c0dce9a,
        0xbb52092c3e73614686ee83b5, 0xf204cfa0ed9c00d274e448af, 0x588759dedfb95ed, 0x0,
        0x13596038783eaa2228a4350d, 0x8ae684504a218717c9e052a4, 0x5bd31f41a2d7a4e4, 0x0,
        0x3e15cff10f1609922ab32f8f9278107, 0x10a16e8bfef9be00041b12d3df0ab90d2,
        0x8df66128d3c7762f2e4ddc59, 0x183a5335a9b651a5d1e85f56, 0x1619dd97c40a41f0, 0x0,
        0x552c3d261e98b36a60543610, 0x24f4791bbcdc4290045ca9c, 0x3c7f7ce3551d7fdd, 0x0,
        0x2be5e02dea43047daaed4fbaf06fafca, 0x1de6096b4f0d2f729b2b56af6ca9e273,
        0xbf23cd7c25b12a0d92c6b1c2, 0x821033c574b23f4fbc286f90, 0xfa21edaab8d6f72, 0x0,
        0xc9ac857dc9f3d10bbb9e967c, 0x644a0414354d3a76d9c25fdd, 0x51b76f634c812ae6, 0x0,
        0x5e0ad7648a4f59729af8617b82d4b15, 0x1204a5942db3ff32572d539505799c162,
        0xcf1ad31679ec4c27e3830f3a, 0xa017f3868f913c86551ad885, 0x314bccf1c49a9154, 0x0,
        0x3fbe277240930e0039b24d90, 0x44c3f435ed00859eaef40526, 0xaf4e10850bd6cb6, 0x0,
        0x1bb625624ceab37b75f8eb6d9baaec37, 0x8869d6e2bfcd45999b706e500bdf6e9,
        0x9008bb2465decd0de32e352b, 0xde20aad12ffa049c38c36b98, 0x7f70d611ad868171, 0x0,
        0xe1e028e0788998638bf9bac7, 0xfa52b231caf7768fab52216a, 0x597888666ca85946, 0x0,
        0x4f7c63b27ca63da0b0528098af0dab, 0xf35e51f8509ab42e70f2e964b3fd8c,
        0x93dd0836e7e13591e646d775, 0x165ef3a2c6f0a3c905a9eb74, 0x41d60538e230bb0, 0x0,
        0xa8dc2a660b9336e923e82fd8, 0xf329310a470287aef66cbfc9, 0x5d6441cffa1f00d2, 0x0,
        0x122200117465217fb53ec8140b91481, 0x13d5f8e8fedb409022970ed842b78a9c4,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x1518e158cd20a0734c8395d6,
                limb1: 0x9e542f72e122bba6f1c46e7,
                limb2: 0x74cb223a70d329c9,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x779bfa346b625483d1999346,
                limb1: 0xf6901ab1d5d3d000b7fb3634,
                limb2: 0x6898c5fa74d3665a,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_12P() {
    let mut data = array![
        0xc, 0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0,
        0x82e4a33f8e4e5881e791d86b, 0xbcb062435ae8ec5fdaeac4bf, 0x179e1bae9e0f9f34, 0x0,
        0x19657783ba5660e255c21849, 0x7ed7474bcea7551fc71e46bc, 0x596c0a76b75f4756, 0x0,
        0xa6832ef7fe97f77de7cd9a62, 0xf18a70dbf1dc5a76c685da4a, 0x6ac1b7bfc409119f, 0x0,
        0x7751161b1a9ef600b865a5af, 0xed28aad4835a39a9e8318ceb, 0x572e95c429f0e07a, 0x0,
        0x5e71d0fc5d1c016834779173, 0xadd002dfc0ebf1b25c23c252, 0x40a868d928ae5233, 0x0,
        0x423fa293418d6e3f59c2e830, 0x7a4bcf26f93e71ffd903e68e, 0x7837b851ad8da6e3, 0x0,
        0x5907087f8e8e4dacdd039371, 0xc390e2073b4e64b9ede0570d, 0x6b039a85962f1594, 0x0,
        0xc45eefa03155b8f7eb780b42, 0x3db57eb22f9b0394a4d7b78e, 0x6cf45b6d90883f60, 0x0,
        0x60dd8ed0a614b596fb37eb1f, 0xabb99f371be41e26ec2d8e4b, 0x187ecd72c40f159d, 0x0,
        0x7b66c9263de5e1663622985d, 0x118b032cc27a1d6dd192eca6, 0x312fb405788616e8, 0x0,
        0xf4ac3e1f1f068dd64c86fdda, 0x24594e591d82a7f964b5ec9f, 0x6ca311b5421c57fc, 0x0,
        0x42745cd7b146012455434d0f, 0x6aa4f552b7bdc93a613bd9df, 0x5832a065d7199c7a, 0x0,
        0x341786b7854e3e0104e2e416, 0xbb368441c295043bee7b1d2f, 0x35c88542e11463b4, 0x0,
        0x3c36e7fcc4e2fde28308132, 0xf58043d0e3d1a36d1f8137fc, 0x58c1508fbe8868a8, 0x0,
        0x560a37951d69a6c8d7138239, 0x462d454a509846714184ef71, 0x3aaf8fb4f60e3e9c, 0x0,
        0xb70cea4e13db5322899753f9, 0x6c62656b6d7ffb5c2af44fd5, 0x4b5ae4567dc6a7c0, 0x0,
        0xb06cccb4b425d5179f528270, 0xce017c281a3861570706cd86, 0x42d14846dc4860ab, 0x0,
        0x646bf486f6e77663c597ece8, 0xd87c8c36a430a6fe42305b88, 0x7964c7742b6f13da, 0x0,
        0x52c487a17925c92335926072, 0x13155d04b743220ba9c4dd31, 0x1106c832e8e52057, 0x0,
        0xbc69df5aa9a21ba08f160d5f, 0xc207c95ac5d454f546b05fc3, 0x574515b32b35f440, 0x0,
        0x4f068c66f642eed6b2a9cf28, 0x5cde9d21988aa8eed49fbe13, 0x5847165150f2b16b, 0x0,
        0xdf6b306bce93c8248de1b0ab, 0x5d126993fea5de605b6d6f73, 0xb2fd0f2d63c2503, 0x0, 0xc,
        0xd344749096fd35d0adf20806e5214606, 0x8ce86e89466e4726b5f5241f323ca74,
        0x30bcab0ed857010255d44936a1515607, 0x8ac57cfbb42e0b20426465e3e37952d,
        0x5f3f563838701a14b490b6081dfc8352, 0xda2ddc3552116dd2ba4b180cb69ca38,
        0xc87a746319c16a0d0febd845d0dfae43, 0x7003168b29a8b06daf66c5f2577bffa,
        0x176ea1b164264cd51ea45cd69371a71f, 0x3b6a666fb0323a1d576d4155ec17dbe,
        0x9edfa3da6cf55b158b53031d05d51433, 0x23d79a9428a1c22d5fdb76a19fbeb1d,
        0x4d125e7fa59cec98126cbc8f38884479, 0x1f40f472e2950656fa231e959acdd98,
        0x98b33c6e0a14b90a7795e98680ee526e, 0xc8555a9fcfcfa81b306d70019d5f970,
        0xebe2136898c752051e01a934402d0baf, 0x6c2a492cc0f859aa6524ab713b7e05,
        0x637e0edc5b6e4ae7a62081434fbaecc0, 0x4e8c1e4403d1f83a859890cd670f668,
        0x2284b7a447e7f5938b5885ca0bb2c3f0, 0xf6b20a3f40048d7c31d5a973d792fa1,
        0xc5adf6816b10e53a9145de05b3ab1b2c, 0x54d35980bf9c0efb5816b74a985ab61, 0x4,
        0xfa06825a3970e5b2395be2b, 0x4e5a7ba3551df3652d46082d, 0xcfca9a525fe359, 0x0,
        0x4b5b3f76f46f535ef91e563e, 0x7966c4c81669a7d88fb8ff47, 0x5319f116c45c71a8, 0x0,
        0x100999da2383a787fc58bce955201c59, 0x2d492fcea91c7b9e8fa3931db543fa13,
        0x7f99cd69e93181300ddb085a, 0x2a1d1771927bbfe32603da8b, 0x1b74f12f3379df06, 0x0,
        0x9c6622f17ebe2c6e5ff51ed2, 0x204fecff8a5332121c431d6c, 0x5aef5ec5cb6f461e, 0x0,
        0x2be10b93bdf768ae7778b99191b2cf05, 0x19d5b37430b75b04d20856a7ba530478,
        0xfb04ee0dc3febe0615ddb0f8, 0xdb1a0ab954022ed49344333d, 0xc954e46c5b77f1, 0x0,
        0x9ce91f8ebf3d15bd8a382b6e, 0xdfabad49441c0d28944c6b9c, 0x50386dc8735ea9aa, 0x0,
        0x306359e58443dc9fa7b677c05b67bc03, 0x22f5c652ce175682bece3c707b7f0c64,
        0x4a3eb763e06c59a43ee29389, 0x1bccf75e9f35eef7529a1ef5, 0x10fda802117cdfa6, 0x0,
        0xa7ef2ec0616f2443afd7cfbb, 0xd9cea79fbf13150fc3cd14eb, 0x4716f7e70987aa10, 0x0,
        0x1af8531e7421e1b5fc3f282922950413, 0x12802c684a9d9ebd5f6c8d17c2c0dce9a,
        0x8d97858df9c229a8d620899, 0x7db5c765b658f7a25710c917, 0xcf309068ad0dba9, 0x0,
        0x910500da56aeb50040a7dcc4, 0x3f3a644f90034e28ba18da95, 0x175ed58aa3954930, 0x0,
        0x3e15cff10f1609922ab32f8f9278107, 0x10a16e8bfef9be00041b12d3df0ab90d2,
        0x979bd1588dea18a8b58a36af, 0x3b2b0ed61e1178cba7126bb7, 0x785cdb331bd169df, 0x0,
        0xfa4fe3f5b031c72c034663a2, 0xb0e20f66408902c55e655ba1, 0x75bd7b3b090eed75, 0x0,
        0x2be5e02dea43047daaed4fbaf06fafca, 0x1de6096b4f0d2f729b2b56af6ca9e273,
        0x3fce6566c5bcd92f4f85fa83, 0x623822e4a6f44b0bf23c8675, 0x6e423031e41718c0, 0x0,
        0x16cc5bb608bc6da0bdb24659, 0x14a20f3a350b3c92c8985f2c, 0x62b6194db85582a7, 0x0,
        0x5e0ad7648a4f59729af8617b82d4b15, 0x1204a5942db3ff32572d539505799c162,
        0x695752f39d6ec14aacfbee31, 0xf8dd60148b6b6cd713f249de, 0x4ae3fa433428da67, 0x0,
        0x2fc01927924d2423beeabc84, 0x8d3ab58869e8b96487a1c521, 0x47292b4a7182ce7f, 0x0,
        0x1bb625624ceab37b75f8eb6d9baaec37, 0x8869d6e2bfcd45999b706e500bdf6e9,
        0x6474fbdb6af73701de45f274, 0x6094e5f591a45f3bf08427c8, 0x103a5881e0aef8e4, 0x0,
        0xa14105659db45179803bc1ee, 0xcd28f77e60c994a87a8e0d3d, 0x57e7812e2c87633c, 0x0,
        0x4f7c63b27ca63da0b0528098af0dab, 0xf35e51f8509ab42e70f2e964b3fd8c,
        0xa25e04756aa0d3cf7a58d681, 0xf525fde801d661e742afdf23, 0xb8057a3525f95e3, 0x0,
        0x6423b1c187fb4699d91e7961, 0x97ed6053542a17b2ee5a276d, 0x24f4c3823852a469, 0x0,
        0x122200117465217fb53ec8140b91481, 0x13d5f8e8fedb409022970ed842b78a9c4,
        0xc4c0db3983aec6a159c5bc04, 0x5f92edcb20df32b1cfb385f, 0x300014ec8791a43a, 0x0,
        0x17b89b207ec56f494c10480a, 0x610f69ebee5483ba4bd0d917, 0x2bec654de3ea3a80, 0x0,
        0x37b10ae5354582f85190f7870b858c63, 0x1316ba5fddb42e06735d0f1fdcc24a38,
        0x45a14721d6abe459bc5aea8, 0x1568bffaa9565041d7dbaf28, 0x3e6067b9f8935c8, 0x0,
        0x26d59ad679daa7e759147eba, 0x9503c0a1029b0f7ce7406c4b, 0x3db5661841ebce66, 0x0,
        0x121b5378cd43ffc919a2305e76423029, 0x18300af219c488c1a25884d5c7401c30,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x4ee4167708b29620b1a9e142,
                limb1: 0x6fd520385a98769aa6f2e833,
                limb2: 0x29e58ca78283490e,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xf78829d77fe7c51b0788aa60,
                limb1: 0x98af3b491451a91c0de5fdab,
                limb2: 0x4ba4b20ac788a99,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_1P() {
    let mut data = array![
        0x1, 0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0, 0x1,
        0xb4862b21fb97d43588561712e8e5216a, 0x967d0cae6f4590b9a164106cf6a659e, 0x5,
        0x41c610705003caeb41ebc2e1, 0x7e86ece0ef89d80aca46deac, 0x121b38a9ddb387ef, 0x0,
        0x5d4d7ed98f7bc32e88ca220f, 0xc1b7d0a1662fc4fbf7fefffe, 0x24a447a3fd6b6dd0, 0x0,
        0x5520c252aad219e02bf5055a4ed023b7, 0x197e50b8e7adb6dd93eeede129c12721,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x41c610705003caeb41ebc2e1,
                limb1: 0x7e86ece0ef89d80aca46deac,
                limb2: 0x121b38a9ddb387ef,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x5d4d7ed98f7bc32e88ca220f,
                limb1: 0xc1b7d0a1662fc4fbf7fefffe,
                limb2: 0x24a447a3fd6b6dd0,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_2P() {
    let mut data = array![
        0x2, 0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0,
        0x20669ef12954f8e3bbc8b4d3, 0x396a6f7243c27ce553121ee3, 0x11438ca2ec259aed, 0x0,
        0xa560a5759c90985fde99aca0, 0xc5b21186cc6dcd0421026513, 0x21fb1f47c6ac55b3, 0x0, 0x2,
        0x12e0c8b2bad640fb19488dec4f65d4d9, 0x1521f387af19922ad9b8a714e61a441c,
        0x5a92118719c78df48f4ff31e78de5857, 0x28fcb26f9c6316b950f244556f25e2a2, 0x5,
        0x32536984a4baf6f115cbb0bd, 0xdae1afb06300dbd4fde0fe2a, 0x1f1896139ffba76b, 0x0,
        0xdf40e1ffc936ca509fbb16a8, 0xca2a5643c84ea6749543ee4c, 0x29b131b03ad6f119, 0x0,
        0x39dea48eef47b3e6bcae980c9112d477, 0x538cc4627274d8f320bf5df15c887356,
        0xc0a469a5b7f47ad22e92fe7d, 0xd7d5b526e50c6900bdcfeb9d, 0x21df2654af8f907c, 0x0,
        0x19ca14fef97aef829a022e99, 0x3436a3a9d29787ffa53573f3, 0x16d3f0d2e78b2950, 0x0,
        0x10a2e45b33049f11b360c09b6389565b, 0x63f1d0c59d848c415389772b72561b3d,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x512920e074cbe690304d839e,
                limb1: 0xb077d5884dbdc5fcb9424a35,
                limb2: 0x16cd67edce8be7ac,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x70cd2c4a003d407aabc7cc,
                limb1: 0xe2748dd5f8c2a0e1dadd02d5,
                limb2: 0x1c1cfa79fda07581,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_3P() {
    let mut data = array![
        0x3, 0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0,
        0x20669ef12954f8e3bbc8b4d3, 0x396a6f7243c27ce553121ee3, 0x11438ca2ec259aed, 0x0,
        0xa560a5759c90985fde99aca0, 0xc5b21186cc6dcd0421026513, 0x21fb1f47c6ac55b3, 0x0,
        0x3c26f4ff476ab777dc184776, 0xbccb2cba46cf421f11eb4d14, 0x27ec44064c727a3d, 0x0,
        0xa893636703904fcbe984618c, 0x73b210a224190b9b7b28784c, 0x20f05486689dff6c, 0x0, 0x3,
        0x5a92118719c78df48f4ff31e78de5857, 0x28fcb26f9c6316b950f244556f25e2a2,
        0x8d723104f77383c13458a748e9bb17bc, 0x215ddba6dd84f39e71545a137a1d5006,
        0xeb2083e6ce164dba0ff18e0242af9fc3, 0x5f82a8f03983ca8ea7e9d498c778ea6, 0x5,
        0xe7bee0981732826e6716a8b9, 0x8001b0e38269465d6a3ba48f, 0x1a727a8f4b29ab8, 0x0,
        0x8180b66bf02ff17b607d43de, 0xfaf5d89afaaafcba4c3a43ef, 0xb1992b294551079, 0x0,
        0x10a2e45b33049f11b360c09b6389565b, 0x63f1d0c59d848c415389772b72561b3d,
        0x74575ca46c143d22121ea904, 0x77200655d23500648b27cb30, 0xaa0637dd46a67ab, 0x0,
        0xfe93e7c36bbe7d7cde12c6ac, 0x51cb8066bcd86f62f01ec58, 0x1f28f657f6b9dadd, 0x0,
        0x4330e45cf056866449d6d2b7255a6d25, 0x102e9d68e73086da22f4b98d2103a3c22,
        0x2e20c00e88de121d37fa2696, 0x86ac870558aabfae43dc69a0, 0x26095fa9606bf53, 0x0,
        0x327031fef1203666f47f2099, 0xdb951627a7f45379f1e51f4f, 0x376fe09acf51529, 0x0,
        0x32cbca2bbd2f37ecb19ba4403b940cc1, 0x12977bae8a28f111cf0a43807982d3bb7,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x213a074a0215934c65d47250,
                limb1: 0x57ceadf09cd8ebde50476db0,
                limb2: 0x1f82780f1a4c3d23,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7282af42d1608d1f8c034960,
                limb1: 0x81214b248c88a391f72dd6e0,
                limb2: 0x5df1db744450be3,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_4P() {
    let mut data = array![
        0x4, 0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0,
        0x20669ef12954f8e3bbc8b4d3, 0x396a6f7243c27ce553121ee3, 0x11438ca2ec259aed, 0x0,
        0xa560a5759c90985fde99aca0, 0xc5b21186cc6dcd0421026513, 0x21fb1f47c6ac55b3, 0x0,
        0x3c26f4ff476ab777dc184776, 0xbccb2cba46cf421f11eb4d14, 0x27ec44064c727a3d, 0x0,
        0xa893636703904fcbe984618c, 0x73b210a224190b9b7b28784c, 0x20f05486689dff6c, 0x0,
        0x74f2a24c1853d803c1b9e310, 0x9e78bb9233603b686b9d27, 0x1d13a84fbcd96e81, 0x0,
        0xe5bc08950f2f1accd92245f4, 0x3b653bbe7b6cfd9074b07f89, 0x1638a8a07b89463b, 0x0, 0x4,
        0x8d723104f77383c13458a748e9bb17bc, 0x215ddba6dd84f39e71545a137a1d5006,
        0xeb2083e6ce164dba0ff18e0242af9fc3, 0x5f82a8f03983ca8ea7e9d498c778ea6,
        0xb5d32b1666194cb1d71037d1b83e90ec, 0x28045af9ab0c1681c8f8e3d0d3290a4c,
        0xd3fbf47a7e5b1e7f9ca5499d004ae545, 0x2ebce25e3e70f16a55485822de1b372a, 0x5,
        0x6463bd58916931d0ac4eb128, 0x36bcb9db9fbc494127d685b9, 0xbe0d59677fd6637, 0x0,
        0xfdfd5ee62a80a8195a667cd1, 0x8eb9b531d1c1bed421f1d865, 0x2fbd2d2aa811c3e1, 0x0,
        0x4330e45cf056866449d6d2b7255a6d25, 0x102e9d68e73086da22f4b98d2103a3c22,
        0x8fd7943c409c6d0b97790c17, 0x6609bc50ae73b6db4a08db2e, 0x1a5a408e625e1019, 0x0,
        0x56e67a10d45628f5fcf8d390, 0xe19469815ce43c544151b3ac, 0xeb5ad829227a07f, 0x0,
        0x32cbca2bbd2f37ecb19ba4403b940cc1, 0x12977bae8a28f111cf0a43807982d3bb7,
        0xd49218ddf86e81250924e4ed, 0xf193c73d0d41e7f71dd4d878, 0x21192796ca5e2dac, 0x0,
        0xbb5b1bfe4b3be7d06581a624, 0x57281f4af424359f81b5526a, 0x2f72bb4496fb4ce4, 0x0,
        0x453503237fe891d4168e4f9228c400b7, 0x72e13e861339a4b3dab61e0d640fc66,
        0x7ec3a5c2c9499344ac050cdd, 0x791b53545bf433b7079614ac, 0x21453b32e9702074, 0x0,
        0xdb015deb84bb2b7b687999ca, 0xf553ab53e8fed39de94cc1f5, 0x1c73bed188a1cf2f, 0x0,
        0x3370dc3b2f6a7a7d6a4917e6cae4e0e1, 0x14488bb2a825221dfb2b87de071f1b27c,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x577ddc8cb42b7a3b83e4d525,
                limb1: 0x74e9415eb1dbca9529930fc,
                limb2: 0x26b61a5d6d67dd31,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x6cc0d22d0549fc5bbbb24080,
                limb1: 0x315ae072448564ca12dc062e,
                limb2: 0x2d218fcb973e8f23,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_10P() {
    let mut data = array![
        0xa, 0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0,
        0x20669ef12954f8e3bbc8b4d3, 0x396a6f7243c27ce553121ee3, 0x11438ca2ec259aed, 0x0,
        0xa560a5759c90985fde99aca0, 0xc5b21186cc6dcd0421026513, 0x21fb1f47c6ac55b3, 0x0,
        0x3c26f4ff476ab777dc184776, 0xbccb2cba46cf421f11eb4d14, 0x27ec44064c727a3d, 0x0,
        0xa893636703904fcbe984618c, 0x73b210a224190b9b7b28784c, 0x20f05486689dff6c, 0x0,
        0x74f2a24c1853d803c1b9e310, 0x9e78bb9233603b686b9d27, 0x1d13a84fbcd96e81, 0x0,
        0xe5bc08950f2f1accd92245f4, 0x3b653bbe7b6cfd9074b07f89, 0x1638a8a07b89463b, 0x0,
        0x549a4dee31909bd274709d7c, 0x2628a928b4ed90e98d5de1f, 0x1f2c2eeb200495b, 0x0,
        0xbae71f4f781675cce1119290, 0x18995b20b8d0966bac7f5c23, 0x1f7a255155ab7785, 0x0,
        0x616d2877cb47206e625b0076, 0xa7255531af3575b0a682d6df, 0xdd4a0db8187661d, 0x0,
        0xea99c54030edacb739c9ad0f, 0x1e2e84792f7a12b330406ecd, 0x70f1e1a9673a240, 0x0,
        0x4ca9473b8cae66da0baf8eca, 0x9ca627187edabffeb80da281, 0xda800cad866dc3c, 0x0,
        0x6dcd62554ccd88a00f3e90b3, 0x141b8118cd6873dc9ac01a64, 0x19146bc96fa6a4bd, 0x0,
        0xd21eca6170588371cf0fef12, 0x2aae89b6d1784d7fe5d6f233, 0x2fa67b7cd137898c, 0x0,
        0xb20856046d39da92c0a6898a, 0xc9dba030db3ed937e781ae4d, 0x695a8c76fb0f771, 0x0,
        0x919e8724022c5bd17875261b, 0x3a2b09cc9362be43a8573a0, 0x2cf4abb949016ad7, 0x0,
        0x89062bf5adf784b526337420, 0xf710d8fb0beb9551fe0e08f3, 0x1577b6c8f024c52d, 0x0,
        0x2cb6c8386e51647e028876a2, 0x3eeb71e38623705690872fa1, 0xbf610b0d76e1a8f, 0x0,
        0x92f468ac225e9f9a2b52929d, 0x28e7d79e30f3f4d4abf38c05, 0x2e2ba523e6456871, 0x0, 0xa,
        0xe005b86051ef1922fe43c49e149818d1, 0x1f507980eece328bff7b118e820865d6,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x154bc8ce8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x2305d1699a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x144a7edf6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x21c38572fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0x2b70369e16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x522c9d6d7ab792809e469e6ec62b2c8,
        0x85940927468ff53d864a7a50b48d73f1, 0xdc5dba1d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x119d0dd09466e4726b5f5241f323ca74,
        0x5306f3f5151665705b7c709acb175a5a, 0x2592a1c37c879b741d878f9f9cdf5a86, 0x5,
        0x32eb30f6f18b90fd2c54a7bc, 0x3c30d2c79fedd11320172c6b, 0x1c24ff684f9b5d37, 0x0,
        0x30da50af17d999a6e4f507cc, 0x8b68b2e39f2184199c693db6, 0x29406ed67ec36daa, 0x0,
        0x44a6ec700b7df57842dc495ff54035ab, 0x1a16322818541ea7ff83fb7401b38645,
        0xf988d8bc102cc5827e4caa0f, 0x49d307fa622f159f155a1d5d, 0x279bbe5814108d5, 0x0,
        0x8175447243fbd59a37850f7e, 0x97eab11e0760e9d18ebd0279, 0x207bde70fd6ed720, 0x0,
        0x2f98f4efaa736ab4d7bfb789bfba3055, 0x13cd9b8573802529fd653bb6e0d2b9003,
        0x52463a5e56dce95d52653f6c, 0xc486275eefc0a3085d30994f, 0x1911dc07106bf4ba, 0x0,
        0x50eeee6f973b2226963afb66, 0x1afe5cccc2c986ed4ae0d870, 0x1164fff2e2c71e0a, 0x0,
        0x4bf90ecc32be6be1a6c37a7a9d07c71d, 0xf44e3c518c0a9551bc4adf61e4848ba,
        0x2704d0e441c6416e0fca2d7c, 0x2210d1dbdbe71c652f93ab45, 0x22a59daf5cbe974b, 0x0,
        0xfa94c262d139c0ee254542eb, 0x2d6985158d5a69f37216750b, 0x196f95cbe169d63, 0x0,
        0x5ef24d1d34d20af1accc99a7a47ced7, 0x15a3bf99ae0dc9de808f9f24fc67eb36b,
        0x90e925805f4e493a98513928, 0x20747869ef32538aca7f3a98, 0x1d9ba510fc4dbce1, 0x0,
        0x19866ab554bc8233e08b4443, 0xa95c235c28b853948e2ab1bf, 0x167644ace98da43f, 0x0,
        0x2cb938e8d1c7a21ed6905354bb26d393, 0x5531d3f34afddbea08c69f58e5606d44,
        0xe8975bf70ea1a1253b0d37d2, 0xc825272fb51f264751b2a16e, 0x82a1f118fcda22c, 0x0,
        0x2f242762bb612f6c60c0126c, 0x919d79be09b46ad1f5cebf8e, 0x6b9c0cfd4951eec, 0x0,
        0x60e45e17bea8d8126f02e5a29022aee5, 0x132504ebb936117e97628b682972007b8,
        0x6fd67ead04596b5005a7175b, 0x9da6449170ac81a2f6cc28a, 0x1413b85981e32e9e, 0x0,
        0x3ff0bf0cd595a2bd615527a3, 0x94482e2708c6ae32d5bd1b5f, 0xfcfed4eeb170294, 0x0,
        0x516c64bbee2a8bf42f7414f288f1f846, 0x145799d59f914437c97585c53ceb86623,
        0xc71e8a64b2f862ae51d2200a, 0x39cef19185293495361def27, 0x2e0a4cb3b5568f75, 0x0,
        0x85d0d27771793625c874ebbf, 0xce9e91179dc4f4b408181c1f, 0x261a1cca4c19631a, 0x0,
        0xcefe84e1bdce362a5bd286f90a8b1cb, 0x3717c82dc5b0858c3ba6f188e61330a,
        0x67427da6ac310253c4305f51, 0x4b8a13108dbfa4be65e8debc, 0x17a3550c4017bb7a, 0x0,
        0xc1b3b3c0adb4ea9812127500, 0xe8a20b9f8ad97a21e3450200, 0x1dcd89db1920a499, 0x0,
        0x146dc11c44642a7552be554048969667, 0x1240b81ea23b0099fa77c5be92a2a8286,
        0xead19fc6d1fe6777fc7fe69f, 0x75f5a9115bf9d3ee7a306806, 0x325b9bf2679afd4, 0x0,
        0x69479ee6fe51ea5b53a60c39, 0xb467acaf148cd9cc4e51a679, 0x1aa47e4314e976ec, 0x0,
        0x2024c45822518dadf0322fb9e8b505e1, 0x1581e6419c45af5a4b61bbe76efb6a640,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x664e7a2a841e9440a32b6d19,
                limb1: 0xafdb5f6d16a62de9213ee040,
                limb2: 0x13f95a9cdebbf34c,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7ff039b0dc46b2d7c69d0faf,
                limb1: 0x2e4a2bd3a50e076ea1b3056,
                limb2: 0x2dbf12d12987fc34,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_11P() {
    let mut data = array![
        0xb, 0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0,
        0x20669ef12954f8e3bbc8b4d3, 0x396a6f7243c27ce553121ee3, 0x11438ca2ec259aed, 0x0,
        0xa560a5759c90985fde99aca0, 0xc5b21186cc6dcd0421026513, 0x21fb1f47c6ac55b3, 0x0,
        0x3c26f4ff476ab777dc184776, 0xbccb2cba46cf421f11eb4d14, 0x27ec44064c727a3d, 0x0,
        0xa893636703904fcbe984618c, 0x73b210a224190b9b7b28784c, 0x20f05486689dff6c, 0x0,
        0x74f2a24c1853d803c1b9e310, 0x9e78bb9233603b686b9d27, 0x1d13a84fbcd96e81, 0x0,
        0xe5bc08950f2f1accd92245f4, 0x3b653bbe7b6cfd9074b07f89, 0x1638a8a07b89463b, 0x0,
        0x549a4dee31909bd274709d7c, 0x2628a928b4ed90e98d5de1f, 0x1f2c2eeb200495b, 0x0,
        0xbae71f4f781675cce1119290, 0x18995b20b8d0966bac7f5c23, 0x1f7a255155ab7785, 0x0,
        0x616d2877cb47206e625b0076, 0xa7255531af3575b0a682d6df, 0xdd4a0db8187661d, 0x0,
        0xea99c54030edacb739c9ad0f, 0x1e2e84792f7a12b330406ecd, 0x70f1e1a9673a240, 0x0,
        0x4ca9473b8cae66da0baf8eca, 0x9ca627187edabffeb80da281, 0xda800cad866dc3c, 0x0,
        0x6dcd62554ccd88a00f3e90b3, 0x141b8118cd6873dc9ac01a64, 0x19146bc96fa6a4bd, 0x0,
        0xd21eca6170588371cf0fef12, 0x2aae89b6d1784d7fe5d6f233, 0x2fa67b7cd137898c, 0x0,
        0xb20856046d39da92c0a6898a, 0xc9dba030db3ed937e781ae4d, 0x695a8c76fb0f771, 0x0,
        0x919e8724022c5bd17875261b, 0x3a2b09cc9362be43a8573a0, 0x2cf4abb949016ad7, 0x0,
        0x89062bf5adf784b526337420, 0xf710d8fb0beb9551fe0e08f3, 0x1577b6c8f024c52d, 0x0,
        0x2cb6c8386e51647e028876a2, 0x3eeb71e38623705690872fa1, 0xbf610b0d76e1a8f, 0x0,
        0x92f468ac225e9f9a2b52929d, 0x28e7d79e30f3f4d4abf38c05, 0x2e2ba523e6456871, 0x0,
        0x7bfeb500d87c8d6a89e3b500, 0x114bfa8db0c1f0065e73cf9a, 0x129e9c5a3641b28e, 0x0,
        0x755ef61cf917721bfef36992, 0x8f3d6b6348b89a2c0cfa9d3f, 0x272de7db2186fd11, 0x0, 0xb,
        0x4a84eb038d1fd9b74d2b9deb1beb3711, 0x154bc8ce8c25166a1ff39849b4e1357d,
        0x3405095c8a5006c1ec188efbd080e66e, 0x2305d1699a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x144a7edf6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x21c38572fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0x2b70369e16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x522c9d6d7ab792809e469e6ec62b2c8,
        0x85940927468ff53d864a7a50b48d73f1, 0xdc5dba1d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x119d0dd09466e4726b5f5241f323ca74,
        0x5306f3f5151665705b7c709acb175a5a, 0x2592a1c37c879b741d878f9f9cdf5a86,
        0x30bcab0ed857010255d44936a1515607, 0x1158af9fbb42e0b20426465e3e37952d,
        0x5f3f563838701a14b490b6081dfc8352, 0x1b45bb86552116dd2ba4b180cb69ca38, 0x5,
        0x82a38d8c5a5ed06e02f523ea, 0x82af79a6bf3ac89993eab3e8, 0x1be27c5dcf4d031, 0x0,
        0x47cd0a6bf8f3e2719f3676c3, 0xb52e9a47fb56e1d543047f8b, 0x2d0102ccf985e7db, 0x0,
        0x2f98f4efaa736ab4d7bfb789bfba3055, 0x13cd9b8573802529fd653bb6e0d2b9003,
        0xfc1dd0e74df0a1a8d64f91ef, 0x7152ce13dd09af9d91af51a5, 0x1f20f94df2d7fe74, 0x0,
        0x7e05f6cc422c4a84b77ae1c4, 0xce37231b21808d9920cd5380, 0x111ebb3c2386a02a, 0x0,
        0x4bf90ecc32be6be1a6c37a7a9d07c71d, 0xf44e3c518c0a9551bc4adf61e4848ba,
        0xa237e5e2279f34d3f8c9d69c, 0xff7f5d3ae502e52c40306b83, 0x1337f2421463490b, 0x0,
        0x45b6a863b5abf54962d9b884, 0x30a306da962a35989645725e, 0x99a1ae365a1daf2, 0x0,
        0x5ef24d1d34d20af1accc99a7a47ced7, 0x15a3bf99ae0dc9de808f9f24fc67eb36b,
        0xb84b0e70b2875bab51e9d89a, 0x2091fcf632cf164d90c07d54, 0x1817470ef8567bdd, 0x0,
        0x6cfa31ea1faa7f591e0c9898, 0x91ae224d73336f6aea463d10, 0x1a76f383b7ffeff9, 0x0,
        0x2cb938e8d1c7a21ed6905354bb26d393, 0x5531d3f34afddbea08c69f58e5606d44,
        0x70b4837532b9116ba15cb044, 0x8dc6e9f1aec52fcb46bbea60, 0x1de8b549ffcc3ab3, 0x0,
        0x8ebe92f66b5744c974e0ae04, 0xf4f8ffe04323fde3bc621b11, 0x177ac0d85f238570, 0x0,
        0x60e45e17bea8d8126f02e5a29022aee5, 0x132504ebb936117e97628b682972007b8,
        0xf69fee0280761794b8af094d, 0x2cab3532c766373f21f01ea1, 0xb2a41c7c05cf495, 0x0,
        0x47c5682cc4d62cd6a6b5c399, 0xff9caa6f33c1d17ec353d81e, 0x424b8d93bc33ee3, 0x0,
        0x516c64bbee2a8bf42f7414f288f1f846, 0x145799d59f914437c97585c53ceb86623,
        0x91abb630ebe86fa5ed36f08, 0x8792ec1248359362df03ea13, 0xa395ae138e67d28, 0x0,
        0xea244ec29efaa151ea8df973, 0x1066b45d5cfb0ecf6b1c83d, 0x29bc678e1f1a863b, 0x0,
        0xcefe84e1bdce362a5bd286f90a8b1cb, 0x3717c82dc5b0858c3ba6f188e61330a,
        0x4e0af46df62ebdf83ef8427a, 0xe920eb4917f8088bed5a0ff1, 0x290d2f419d55f05, 0x0,
        0xc99e48407b226ca08f8edcd0, 0xa26bf316d4aa7e7801849498, 0xe537c8f794284fb, 0x0,
        0x146dc11c44642a7552be554048969667, 0x1240b81ea23b0099fa77c5be92a2a8286,
        0x4e0ff52d69dc8189069ca894, 0xbb8275552c772e2c5ab6a827, 0x304d9f7b60971a3a, 0x0,
        0x2c86e8197dada4886b64d972, 0x7c82e3ee4a0890e23f95a00e, 0x223e0af0a2ca1d7f, 0x0,
        0x2024c45822518dadf0322fb9e8b505e1, 0x1581e6419c45af5a4b61bbe76efb6a640,
        0xd2f1ac9e8e396d2773eb4815, 0xff66e9037c285a85f82cd552, 0x17f35aece5c7a033, 0x0,
        0xa9f477c2284f410dcf3e9b, 0x4c5370e3920042051b704352, 0x16d56bd7c7796d7c, 0x0,
        0x32d3a03325ee181cc9c2b39a4e2916d9, 0x219449b8074d447b4f3f2fb27633a5e1,
        0x85028124eee08fb0e6ef7707, 0x91fb6fec286026bab476ba92, 0x2733c400e9b74caf, 0x0,
        0x7660634344195f9b47cdb6ca, 0x4fdc765e611b89333602fe6d, 0x1152965b31d3e6b7, 0x0,
        0xa131e2b48ec3bee1efa6016b50ac441, 0x10c7fd5e62bf48ea70c58c0cfa9a06e45,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xffdf31426d80fe0e0c50bc6c,
                limb1: 0x3f2ee5e0c6081e2b90431a5d,
                limb2: 0xee45d84f0c8d969,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xe2ce9a7cc98cfccbbfd0057,
                limb1: 0xcb704f80e53cbafb61a4cf65,
                limb2: 0x2249c2809c6b67ce,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_12P() {
    let mut data = array![
        0xc, 0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0,
        0x20669ef12954f8e3bbc8b4d3, 0x396a6f7243c27ce553121ee3, 0x11438ca2ec259aed, 0x0,
        0xa560a5759c90985fde99aca0, 0xc5b21186cc6dcd0421026513, 0x21fb1f47c6ac55b3, 0x0,
        0x3c26f4ff476ab777dc184776, 0xbccb2cba46cf421f11eb4d14, 0x27ec44064c727a3d, 0x0,
        0xa893636703904fcbe984618c, 0x73b210a224190b9b7b28784c, 0x20f05486689dff6c, 0x0,
        0x74f2a24c1853d803c1b9e310, 0x9e78bb9233603b686b9d27, 0x1d13a84fbcd96e81, 0x0,
        0xe5bc08950f2f1accd92245f4, 0x3b653bbe7b6cfd9074b07f89, 0x1638a8a07b89463b, 0x0,
        0x549a4dee31909bd274709d7c, 0x2628a928b4ed90e98d5de1f, 0x1f2c2eeb200495b, 0x0,
        0xbae71f4f781675cce1119290, 0x18995b20b8d0966bac7f5c23, 0x1f7a255155ab7785, 0x0,
        0x616d2877cb47206e625b0076, 0xa7255531af3575b0a682d6df, 0xdd4a0db8187661d, 0x0,
        0xea99c54030edacb739c9ad0f, 0x1e2e84792f7a12b330406ecd, 0x70f1e1a9673a240, 0x0,
        0x4ca9473b8cae66da0baf8eca, 0x9ca627187edabffeb80da281, 0xda800cad866dc3c, 0x0,
        0x6dcd62554ccd88a00f3e90b3, 0x141b8118cd6873dc9ac01a64, 0x19146bc96fa6a4bd, 0x0,
        0xd21eca6170588371cf0fef12, 0x2aae89b6d1784d7fe5d6f233, 0x2fa67b7cd137898c, 0x0,
        0xb20856046d39da92c0a6898a, 0xc9dba030db3ed937e781ae4d, 0x695a8c76fb0f771, 0x0,
        0x919e8724022c5bd17875261b, 0x3a2b09cc9362be43a8573a0, 0x2cf4abb949016ad7, 0x0,
        0x89062bf5adf784b526337420, 0xf710d8fb0beb9551fe0e08f3, 0x1577b6c8f024c52d, 0x0,
        0x2cb6c8386e51647e028876a2, 0x3eeb71e38623705690872fa1, 0xbf610b0d76e1a8f, 0x0,
        0x92f468ac225e9f9a2b52929d, 0x28e7d79e30f3f4d4abf38c05, 0x2e2ba523e6456871, 0x0,
        0x7bfeb500d87c8d6a89e3b500, 0x114bfa8db0c1f0065e73cf9a, 0x129e9c5a3641b28e, 0x0,
        0x755ef61cf917721bfef36992, 0x8f3d6b6348b89a2c0cfa9d3f, 0x272de7db2186fd11, 0x0,
        0x499828e9a86afe3b8c909275, 0xb8910cabe37f6e8f4bd4b4c1, 0x2634fe56d6751316, 0x0,
        0x777228ef48ddade6caeb3c9, 0x6e0e16c7f54463307a858b78, 0x6e2e3e3a1dc83da, 0x0, 0xc,
        0x3405095c8a5006c1ec188efbd080e66e, 0x2305d1699a6a5f92cca74147f6be1f72,
        0x1775336d71eacd0549a3e80e966e1277, 0x144a7edf6288e1a5cc45782198a6416d,
        0x2f1205544a5308cc3dfabc08935ddd72, 0x21c38572fcd81b5d24bace4307bf326,
        0x42930b33a81ad477fb3675b89cdeb3e6, 0x2b70369e16febaa011af923d79fdef7c,
        0x2648ee38e07405eb215663abc1f254b8, 0x522c9d6d7ab792809e469e6ec62b2c8,
        0x85940927468ff53d864a7a50b48d73f1, 0xdc5dba1d977e9933c49d76fcfc6e625,
        0xd344749096fd35d0adf20806e5214606, 0x119d0dd09466e4726b5f5241f323ca74,
        0x5306f3f5151665705b7c709acb175a5a, 0x2592a1c37c879b741d878f9f9cdf5a86,
        0x30bcab0ed857010255d44936a1515607, 0x1158af9fbb42e0b20426465e3e37952d,
        0x5f3f563838701a14b490b6081dfc8352, 0x1b45bb86552116dd2ba4b180cb69ca38,
        0xc87a746319c16a0d0febd845d0dfae43, 0xe0062d1b29a8b06daf66c5f2577bffa,
        0xa25b59fd92e8e269d12ecbc40b9475b1, 0x2689f61688c132adefbfc19ee8f6cf32, 0x5,
        0xf9033eff6f190d31c0c4211d, 0x5695a5c1624dd1742a3cdfe9, 0x179c263b9b4504b8, 0x0,
        0x28d168c4ac03deddb2bfced2, 0x70704860340808682034ce25, 0x128005647d6a6d42, 0x0,
        0x4bf90ecc32be6be1a6c37a7a9d07c71d, 0xf44e3c518c0a9551bc4adf61e4848ba,
        0x8064a8fdea100eeea33de95e, 0x48241e9bcc914c3f4688d747, 0x36d11122251d0be, 0x0,
        0xed92f97ad0666c54c0c7c322, 0xb8286940afc6cb2b56a8186f, 0x2998081bd2a6cc53, 0x0,
        0x5ef24d1d34d20af1accc99a7a47ced7, 0x15a3bf99ae0dc9de808f9f24fc67eb36b,
        0x9091115a73842d352e7260c2, 0x7c9c3b4234d11be97c3a47c2, 0x20f7f327ca913b6, 0x0,
        0x554304ae2efdf0b481bef53a, 0x2ec24f5512a59f6d9389adb7, 0xf108022c4d70cb1, 0x0,
        0x2cb938e8d1c7a21ed6905354bb26d393, 0x5531d3f34afddbea08c69f58e5606d44,
        0xaf21babf96dd103773c072ef, 0x7ce5ce3522b6ea4c0e3ec87c, 0x949d7f5b6f58cf0, 0x0,
        0x997fee3b8a7a55ed6c3ce35a, 0x85dc08d63c739254f7cd9e08, 0x1e8720754774e3be, 0x0,
        0x60e45e17bea8d8126f02e5a29022aee5, 0x132504ebb936117e97628b682972007b8,
        0x949ac2b0821b3f17297f3379, 0x68229918ea7af402a38533f4, 0x2218e85e6418087f, 0x0,
        0x8240596af6fd6399672c6fc7, 0x7f7eb048cdb769efa3581400, 0x2300655984a19dfc, 0x0,
        0x516c64bbee2a8bf42f7414f288f1f846, 0x145799d59f914437c97585c53ceb86623,
        0xf2116223dcea1035d6598225, 0xec21b290a7a3b366b93dc6c5, 0x19ba2583fa478605, 0x0,
        0xe2501715d7aa98cae184ce22, 0x23c9c5d67009ad497435a9cd, 0x17f114ad703e0cf1, 0x0,
        0xcefe84e1bdce362a5bd286f90a8b1cb, 0x3717c82dc5b0858c3ba6f188e61330a,
        0x6b7bafcd4192510084e8f673, 0x4fac1a2d0116dc53ad2667fa, 0x1ed9f98441a2478c, 0x0,
        0xf1355b40d63ec40e1e343f5c, 0x4cada2fa0416e8c573e54188, 0x2c486d8ca96cef62, 0x0,
        0x146dc11c44642a7552be554048969667, 0x1240b81ea23b0099fa77c5be92a2a8286,
        0x5b9ecbfbecd3454955d82d52, 0xdb7b0c28a61b88ec3874eaf4, 0x1d92b948e287e544, 0x0,
        0xbc95b0afca3a981ea9d42a63, 0xf6b2fcafda97e7d50eae45a2, 0x67531d1cc994e69, 0x0,
        0x2024c45822518dadf0322fb9e8b505e1, 0x1581e6419c45af5a4b61bbe76efb6a640,
        0xeccb4b446b26500e9b2af328, 0x438e22ee4ae8272a0464cc1a, 0x1187394d50486a03, 0x0,
        0x28bb06c6fbae4aa8769a05e1, 0x3c6ae34464712ecdb77f360f, 0x141ed6d5a2aba61e, 0x0,
        0x32d3a03325ee181cc9c2b39a4e2916d9, 0x219449b8074d447b4f3f2fb27633a5e1,
        0x7d2d0722d87337ba712167c5, 0xc3cc9233aa74d73f553e65b6, 0x518142076033a0c, 0x0,
        0x5669e2a9f99dec284bd9833e, 0x7ff81fdc9b9fe048166702e, 0x23306f377d466ff8, 0x0,
        0xa131e2b48ec3bee1efa6016b50ac441, 0x10c7fd5e62bf48ea70c58c0cfa9a06e45,
        0xac500059bd0254354a7eb10d, 0x57846864e2cc212729077c5f, 0x1779a3734e112297, 0x0,
        0x95dab19850fefcce556c2e45, 0x8508e9c2e5ccb68087e137a9, 0x47ca47056355729, 0x0,
        0x14a37dd97b695d69cf3442e2c033af3c, 0x21a0482fffb4108132fea168f764c63f,
        0x6ea786336e5cc29f4f62bb0a, 0xfe31116e59152678d3e658f7, 0x1d659cd996e57821, 0x0,
        0x7f9bfd31230be6f74a939865, 0xceae5af5704b817d79a4b61e, 0x11c5608e4816db0f, 0x0,
        0x5396fa1ad3cb506768c58b91578ff06d, 0x542910fa71de1143e977087fee8f6313,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xcb36822ddaf2d31c783a48a,
                limb1: 0x8bdd749154654edb9553e2d,
                limb2: 0x27b9db3dc009b797,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x98d17fd0a10d23d8218f14dc,
                limb1: 0xe9084619146a3dc82331192,
                limb2: 0xd5e171223497006,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BN254_1P_edge_case() {
    let mut data = array![
        0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x2, 0x0, 0x0, 0x0, 0x2,
        0x0, 0x0, 0x2833e84879b9709143e1f593f0000000, 0x30644e72e131a029b85045b68181585d, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x1, 0x0, 0x0, 0x0,
        0x6871ca8d3c208c16d87cfd45, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0,
        0x100000000000000000000000000000001, 0x0, 0x1, 0x0,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 {
                limb0: 0x6871ca8d3c208c16d87cfd45,
                limb1: 0xb85045b68181585d97816a91,
                limb2: 0x30644e72e131a029,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BN254_2P_edge_case() {
    let mut data = array![
        0x3, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x2, 0x0, 0x0, 0x0, 0x3, 0x0, 0x0,
        0xb4862b21fb97d43588561712e8e5216a, 0x967d0cae6f4590b9a164106cf6a659e,
        0x2833e84879b9709143e1f593f0000000, 0x30644e72e131a029b85045b68181585d, 0x0, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x10000000000000000358f1af3ace11fdc, 0x100000000000000004ac9542b22967d33,
        0x100000000000000000cf05f964742cc6d, 0x1000000000000000081d342cffb91cba7, 0x1, 0x0, 0x0,
        0x0, 0x6871ca8d3c208c16d87cfd45, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0,
        0x100000000000000000000000000000001, 0x0, 0x1, 0x0,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 {
                limb0: 0x6871ca8d3c208c16d87cfd45,
                limb1: 0xb85045b68181585d97816a91,
                limb2: 0x30644e72e131a029,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BN254_3P_edge_case() {
    let mut data = array![
        0x4, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0,
        0x536c985db33c69f7c242e07a, 0xfc531bccffafcf1e59d91fb9, 0x2585e4f8a31664cb, 0x0,
        0x57fa42444057cf0c1d62ae3c, 0x4f48d341183118d68ea41313, 0x1d2d2799db056ed1, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x2, 0x0, 0x0, 0x0, 0x4, 0x0, 0x0,
        0x12e0c8b2bad640fb19488dec4f65d4d9, 0x1521f387af19922ad9b8a714e61a441c,
        0x5a92118719c78df48f4ff31e78de5857, 0x28fcb26f9c6316b950f244556f25e2a2,
        0x2833e84879b9709143e1f593f0000000, 0x30644e72e131a029b85045b68181585d, 0x0, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x21725fdb9f487676e547051,
        0xc23930e4f96498a77a316418, 0x1244cb13309195ed, 0x0, 0x6251c487cf0f5a44ac24a45b,
        0xf1db336c10ce7fae206dd8dd, 0x1da9c56792006d76, 0x0, 0x9be5263ddc8a3746, 0x3b9c1e56ffcfcc82,
        0x1000000000000000041c754da808c6d02, 0x277449c3e218531f, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x0, 0x100000000000000005fcd1b724f1296a6, 0x1000000000000000016e3236cbd22722f,
        0x4dac40f4f32b51f2, 0x1000000000000000000417aa85f133ffd, 0x1, 0x0, 0x0, 0x0,
        0x6871ca8d3c208c16d87cfd45, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0,
        0x100000000000000000000000000000001, 0x0, 0x1, 0x0,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x8cb92121f4f98343b28bd83d,
                limb1: 0xa60bedf2a6dc9ea3a4503a84,
                limb2: 0x242282a9381754f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x41c01095a54c1bf16eec174b,
                limb1: 0x84b781a7f16d430823b44408,
                limb2: 0x26bc23f1f4abf016,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_1P_edge_case() {
    let mut data = array![
        0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xf97a1aeffb3af00adb22c6bb,
        0xa14e3a3f171bac586c55e83f, 0x4fa9ac0fc3688c4f9774b905, 0x17f1d3a73197d7942695638c,
        0xa2888ae40caa232946c5e7e1, 0xdb18cb2c04b3edd03cc744, 0x741d8ae4fcf5e095d5d00af6,
        0x8b3f481e3aaa0f1a09e30ed, 0x2, 0x0, 0x0, 0x53bda402fffe5bfeffffffff00000000,
        0x73eda753299d7d483339d80809a1d805, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x1, 0x0, 0xf97a1aeffb3af00adb22c6bb, 0xa14e3a3f171bac586c55e83f,
        0x4fa9ac0fc3688c4f9774b905, 0x17f1d3a73197d7942695638c, 0xecb751bad54dcd6b939c2ca,
        0x6655b9d5caac42364e6f38ba, 0xcf2e21f267816aef1db507c9, 0x114d1d6855d545a8aa7d76c8,
        0x100000000000000000000000000000001, 0x0, 0x1, 0x0,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xf97a1aeffb3af00adb22c6bb,
                limb1: 0xa14e3a3f171bac586c55e83f,
                limb2: 0x4fa9ac0fc3688c4f9774b905,
                limb3: 0x17f1d3a73197d7942695638c,
            },
            y: u384 {
                limb0: 0xecb751bad54dcd6b939c2ca,
                limb1: 0x6655b9d5caac42364e6f38ba,
                limb2: 0xcf2e21f267816aef1db507c9,
                limb3: 0x114d1d6855d545a8aa7d76c8,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_2P_edge_case() {
    let mut data = array![
        0x3, 0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x0, 0xf97a1aeffb3af00adb22c6bb, 0xa14e3a3f171bac586c55e83f, 0x4fa9ac0fc3688c4f9774b905,
        0x17f1d3a73197d7942695638c, 0xa2888ae40caa232946c5e7e1, 0xdb18cb2c04b3edd03cc744,
        0x741d8ae4fcf5e095d5d00af6, 0x8b3f481e3aaa0f1a09e30ed, 0x3, 0x0, 0x0,
        0xb4862b21fb97d43588561712e8e5216a, 0x12cfa194e6f4590b9a164106cf6a659e,
        0x53bda402fffe5bfeffffffff00000000, 0x73eda753299d7d483339d80809a1d805, 0x1, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x1000000000000000062a39ac9655a0af5, 0x10000000000000000b59da527feb9e759,
        0x885278dc00a1125a, 0x2fe0754b9fadfe7b, 0xf97a1aeffb3af00adb22c6bb,
        0xa14e3a3f171bac586c55e83f, 0x4fa9ac0fc3688c4f9774b905, 0x17f1d3a73197d7942695638c,
        0xecb751bad54dcd6b939c2ca, 0x6655b9d5caac42364e6f38ba, 0xcf2e21f267816aef1db507c9,
        0x114d1d6855d545a8aa7d76c8, 0x100000000000000000000000000000001, 0x0, 0x1, 0x0,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xf97a1aeffb3af00adb22c6bb,
                limb1: 0xa14e3a3f171bac586c55e83f,
                limb2: 0x4fa9ac0fc3688c4f9774b905,
                limb3: 0x17f1d3a73197d7942695638c,
            },
            y: u384 {
                limb0: 0xecb751bad54dcd6b939c2ca,
                limb1: 0x6655b9d5caac42364e6f38ba,
                limb2: 0xcf2e21f267816aef1db507c9,
                limb3: 0x114d1d6855d545a8aa7d76c8,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_BLS12_381_3P_edge_case() {
    let mut data = array![
        0x4, 0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0xde4f62a6588c9401ffefbd3,
        0x9bb5f797ac6d3395b71420b5, 0xdc39e973aaf31de52219df08, 0x105dcc4dce3960447d21d3c1,
        0xaefd0d854043fd325dd3c34f, 0x9b63c98d9a7845c52e1e2b0f, 0x9db0be660d847ccc58358f3f,
        0x17cb6c41f0c4e1a7394ab62a, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0xf97a1aeffb3af00adb22c6bb, 0xa14e3a3f171bac586c55e83f, 0x4fa9ac0fc3688c4f9774b905,
        0x17f1d3a73197d7942695638c, 0xa2888ae40caa232946c5e7e1, 0xdb18cb2c04b3edd03cc744,
        0x741d8ae4fcf5e095d5d00af6, 0x8b3f481e3aaa0f1a09e30ed, 0x4, 0x0, 0x0,
        0x12e0c8b2bad640fb19488dec4f65d4d9, 0x2a43e70faf19922ad9b8a714e61a441c,
        0x5a92118719c78df48f4ff31e78de5857, 0x51f964df9c6316b950f244556f25e2a2,
        0x53bda402fffe5bfeffffffff00000000, 0x73eda753299d7d483339d80809a1d805, 0x1, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x2b828af1f5fe30bbe7a1074a,
        0x5669beaa69827b52dc874c9f, 0x648af2c24d82a5a758c96b8e, 0x188bc245620ae6b6afec9dc3,
        0xdc96192f803ef92f56d59758, 0xfc6139925c05a030065d564, 0xb24447300bec56efec94dcf4,
        0x156f97e5d31055c0a5fe154d, 0x97ac96128760678, 0x1b8269c5da3a7aa, 0x946f8bb609f9ba7d,
        0x4e77077ba28bdfd6, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x3827704126429022,
        0x59c3b34a3b390fcf, 0x1000000000000000076a605fca076460a, 0x2f4183d416809c9a,
        0xf97a1aeffb3af00adb22c6bb, 0xa14e3a3f171bac586c55e83f, 0x4fa9ac0fc3688c4f9774b905,
        0x17f1d3a73197d7942695638c, 0xecb751bad54dcd6b939c2ca, 0x6655b9d5caac42364e6f38ba,
        0xcf2e21f267816aef1db507c9, 0x114d1d6855d545a8aa7d76c8, 0x100000000000000000000000000000001,
        0x0, 0x1, 0x0,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xba6f9a258a5c81eb5c00d6d3,
                limb1: 0xa5d26fbf164440da345149b7,
                limb2: 0xf226b85ccdee44779e368a95,
                limb3: 0x187795607228007e29c792fb,
            },
            y: u384 {
                limb0: 0x7393cfd2196053529ef8ea01,
                limb1: 0xf856ee4c4e2adaa88c09b7d9,
                limb2: 0x499710d15a098f2ff8b26e13,
                limb3: 0x119aed04afd21b50d616ee0e,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256R1_1P_edge_case() {
    let mut data = array![
        0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2deb33a0f4a13945d898c296,
        0xf8bce6e563a440f277037d81, 0x6b17d1f2e12c4247, 0x0, 0x6b315ececbb6406837bf51f5,
        0x8ee7eb4a7c0f9e162bce3357, 0x4fe342e2fe1a7f9b, 0x0, 0x2, 0x0, 0x0,
        0xbce6faada7179e84f3b9cac2fc632550, 0xffffffff00000000ffffffffffffffff, 0x3, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x100000000000000000000000000000001,
        0x2deb33a0f4a13945d898c296, 0xf8bce6e563a440f277037d81, 0x6b17d1f2e12c4247, 0x0,
        0x94cea1313449bf97c840ae0a, 0x711814b583f061e9d431cca9, 0xb01cbd1c01e58065, 0x0, 0x1, 0x1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x2deb33a0f4a13945d898c296,
                limb1: 0xf8bce6e563a440f277037d81,
                limb2: 0x6b17d1f2e12c4247,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x94cea1313449bf97c840ae0a,
                limb1: 0x711814b583f061e9d431cca9,
                limb2: 0xb01cbd1c01e58065,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256R1_2P_edge_case() {
    let mut data = array![
        0x3, 0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2deb33a0f4a13945d898c296, 0xf8bce6e563a440f277037d81,
        0x6b17d1f2e12c4247, 0x0, 0x6b315ececbb6406837bf51f5, 0x8ee7eb4a7c0f9e162bce3357,
        0x4fe342e2fe1a7f9b, 0x0, 0x3, 0x0, 0x0, 0xeb1167b367a9c3787c65c1e582e2e662,
        0xf7c1bd874da5e709d4713d60c8a70639, 0xbce6faada7179e84f3b9cac2fc632550,
        0xffffffff00000000ffffffffffffffff, 0x3, 0x113c8d620e3745e45e4389b8,
        0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0, 0x60c0ba1b358f375b2362662e,
        0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0, 0x1,
        0x100000000000000000000000000000001, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x35a5b9ab55bd33dd4dec8ec8c85b8754, 0x1256a1018e9a2606d3efc444e5bc9e97,
        0x2deb33a0f4a13945d898c296, 0xf8bce6e563a440f277037d81, 0x6b17d1f2e12c4247, 0x0,
        0x94cea1313449bf97c840ae0a, 0x711814b583f061e9d431cca9, 0xb01cbd1c01e58065, 0x0, 0x1, 0x1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x2deb33a0f4a13945d898c296,
                limb1: 0xf8bce6e563a440f277037d81,
                limb2: 0x6b17d1f2e12c4247,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x94cea1313449bf97c840ae0a,
                limb1: 0x711814b583f061e9d431cca9,
                limb2: 0xb01cbd1c01e58065,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256R1_3P_edge_case() {
    let mut data = array![
        0x4, 0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0,
        0xd3ff147ff0ee4213f51f677d, 0x431366a7732a6e4a6b942255, 0x9fe743b25d39a591, 0x0,
        0x7f8bb562ff60a902ef14bcb0, 0xeb9420089fa531db62e806a6, 0xfd028df433dfd5cc, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2deb33a0f4a13945d898c296, 0xf8bce6e563a440f277037d81,
        0x6b17d1f2e12c4247, 0x0, 0x6b315ececbb6406837bf51f5, 0x8ee7eb4a7c0f9e162bce3357,
        0x4fe342e2fe1a7f9b, 0x0, 0x4, 0x0, 0x0, 0xe443df789558867f5ba91faf7a024204,
        0x23a7711a8133287637ebdcd9e87a1613, 0x1846d424c17c627923c6612f48268673,
        0xfcbd04c340212ef7cca5a5a19e4d6e3c, 0xbce6faada7179e84f3b9cac2fc632550,
        0xffffffff00000000ffffffffffffffff, 0x3, 0x113c8d620e3745e45e4389b8,
        0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0, 0x60c0ba1b358f375b2362662e,
        0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0, 0x1,
        0x100000000000000000000000000000001, 0x33ee7695471a03192ef22266, 0xb449dd8cfd0c3438e14a718c,
        0x1fbb33f079b828e2, 0x0, 0xb411f97aeec2eae6044122ec, 0xcdce180b60667260d7ce284e,
        0xa73a7381dd3b07c, 0x0, 0x29fa93ff2e088f257810ffaf340cbe2f,
        0x67db401fe06eea845a19e61367b76a34, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x44faf735503f8d6a4fd7c1f1541b0e83, 0x108efc1b039167d94064f65615a509dcb,
        0x2deb33a0f4a13945d898c296, 0xf8bce6e563a440f277037d81, 0x6b17d1f2e12c4247, 0x0,
        0x94cea1313449bf97c840ae0a, 0x711814b583f061e9d431cca9, 0xb01cbd1c01e58065, 0x0, 0x1, 0x1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xdffcaf62be678f4d3d103700,
                limb1: 0x4ae0c3b5a4fb0e4e7ee75279,
                limb2: 0x651ce75927276c9a,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xb27867c3cd0eb05ed74c5f9c,
                limb1: 0xd30f6d2e04931e22def1d510,
                limb2: 0x645a0d9d9776e75f,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256K1_1P_edge_case() {
    let mut data = array![
        0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2dce28d959f2815b16f81798,
        0x55a06295ce870b07029bfcdb, 0x79be667ef9dcbbac, 0x0, 0xa68554199c47d08ffb10d4b8,
        0x5da4fbfc0e1108a8fd17b448, 0x483ada7726a3c465, 0x0, 0x2, 0x0, 0x0,
        0xbaaedce6af48a03bbfd25e8cd0364140, 0xfffffffffffffffffffffffffffffffe, 0x2, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x2dce28d959f2815b16f81798,
        0x55a06295ce870b07029bfcdb, 0x79be667ef9dcbbac, 0x0, 0x597aabe663b82f6f04ef2777,
        0xa25b0403f1eef75702e84bb7, 0xb7c52588d95c3b9a, 0x0, 0x100000000000000000000000000000001,
        0x0, 0x1, 0x0,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x2dce28d959f2815b16f81798,
                limb1: 0x55a06295ce870b07029bfcdb,
                limb2: 0x79be667ef9dcbbac,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x597aabe663b82f6f04ef2777,
                limb1: 0xa25b0403f1eef75702e84bb7,
                limb2: 0xb7c52588d95c3b9a,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256K1_2P_edge_case() {
    let mut data = array![
        0x3, 0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2dce28d959f2815b16f81798, 0x55a06295ce870b07029bfcdb,
        0x79be667ef9dcbbac, 0x0, 0xa68554199c47d08ffb10d4b8, 0x5da4fbfc0e1108a8fd17b448,
        0x483ada7726a3c465, 0x0, 0x3, 0x0, 0x0, 0xeb1167b367a9c3787c65c1e582e2e662,
        0xf7c1bd874da5e709d4713d60c8a70639, 0xbaaedce6af48a03bbfd25e8cd0364140,
        0xfffffffffffffffffffffffffffffffe, 0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x1, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x100000000000000006d17da9dde38d3aa,
        0x100000000000000008e0801a3d001f325, 0x87ea3597eb650e8, 0xe42d003a1f0e89bd,
        0x2dce28d959f2815b16f81798, 0x55a06295ce870b07029bfcdb, 0x79be667ef9dcbbac, 0x0,
        0x597aabe663b82f6f04ef2777, 0xa25b0403f1eef75702e84bb7, 0xb7c52588d95c3b9a, 0x0,
        0x100000000000000000000000000000001, 0x0, 0x1, 0x0,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x2dce28d959f2815b16f81798,
                limb1: 0x55a06295ce870b07029bfcdb,
                limb2: 0x79be667ef9dcbbac,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x597aabe663b82f6f04ef2777,
                limb1: 0xa25b0403f1eef75702e84bb7,
                limb2: 0xb7c52588d95c3b9a,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_SECP256K1_3P_edge_case() {
    let mut data = array![
        0x4, 0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0,
        0xfdfdc509f368ba4395773d3a, 0x8de2b60b577a13d0f83b578e, 0xc2dd970269530ba2, 0x0,
        0x589fa250d638e35400c12ddf, 0xb3aac19fcb5095808402aa7f, 0xed6de6590d0195d1, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2dce28d959f2815b16f81798, 0x55a06295ce870b07029bfcdb,
        0x79be667ef9dcbbac, 0x0, 0xa68554199c47d08ffb10d4b8, 0x5da4fbfc0e1108a8fd17b448,
        0x483ada7726a3c465, 0x0, 0x4, 0x0, 0x0, 0xe443df789558867f5ba91faf7a024204,
        0x23a7711a8133287637ebdcd9e87a1613, 0x1846d424c17c627923c6612f48268673,
        0xfcbd04c340212ef7cca5a5a19e4d6e3c, 0xbaaedce6af48a03bbfd25e8cd0364140,
        0xfffffffffffffffffffffffffffffffe, 0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x1, 0x0, 0x55909ba28af82ea934a4b85d, 0x4bf448ca5d57fb119c843e0a, 0x6a2275491b991ee3, 0x0,
        0x5bf4bf0cefc9553422e60eb0, 0x178d55925d3d72f44783f626, 0xe13a21d7302f8139, 0x0,
        0x4bab076cac43472e, 0x896dcc1031d19f2d, 0x100000000000000006f45630d920758e7,
        0x13bfcc5670fee7eb, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x40c3f72fa123bad6,
        0x461e3a87e8955f53, 0x53ec0e0286c9f6ad, 0x1000000000000000074832ec5bb09d4f6,
        0x2dce28d959f2815b16f81798, 0x55a06295ce870b07029bfcdb, 0x79be667ef9dcbbac, 0x0,
        0x597aabe663b82f6f04ef2777, 0xa25b0403f1eef75702e84bb7, 0xb7c52588d95c3b9a, 0x0,
        0x100000000000000000000000000000001, 0x0, 0x1, 0x0,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0x8ae1b945a4bee5df2482580e,
                limb1: 0x113a509c4213fb90b017895a,
                limb2: 0xdb53345431b0c359,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x5f8a05f7d421794bf1c2f718,
                limb1: 0xf026f2017517996e6dc446ce,
                limb2: 0xc09762999f005286,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_1P_edge_case() {
    let mut data = array![
        0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xd617c9aca55c89b025aef35,
        0xf00b8f02f1c20618a9c13fdf, 0x2a78dd0fd02c0339, 0x0, 0x807131659b7830f3f62c1d14,
        0xbe483ba563798323cf6fd061, 0x29c644a5c71da22e, 0x0, 0x2, 0x0, 0x0,
        0x14def9dea2f79cd65812631a5cf5d3ec, 0x10000000000000000000000000000000, 0x4, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x100000000000000000000000000000001,
        0xd617c9aca55c89b025aef35, 0xf00b8f02f1c20618a9c13fdf, 0x2a78dd0fd02c0339, 0x0,
        0x7f8ece9a6487cf0c09d3e2d9, 0x41b7c45a9c867cdc30902f9e, 0x5639bb5a38e25dd1, 0x0, 0x1, 0x1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xd617c9aca55c89b025aef35,
                limb1: 0xf00b8f02f1c20618a9c13fdf,
                limb2: 0x2a78dd0fd02c0339,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7f8ece9a6487cf0c09d3e2d9,
                limb1: 0x41b7c45a9c867cdc30902f9e,
                limb2: 0x5639bb5a38e25dd1,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_2P_edge_case() {
    let mut data = array![
        0x3, 0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xd617c9aca55c89b025aef35, 0xf00b8f02f1c20618a9c13fdf,
        0x2a78dd0fd02c0339, 0x0, 0x807131659b7830f3f62c1d14, 0xbe483ba563798323cf6fd061,
        0x29c644a5c71da22e, 0x0, 0x3, 0x0, 0x0, 0xb4862b21fb97d43588561712e8e5216a,
        0x4b3e865e6f4590b9a164106cf6a659e, 0x14def9dea2f79cd65812631a5cf5d3ec,
        0x10000000000000000000000000000000, 0x4, 0x7238f02b9f20e09c2181a557,
        0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0, 0xf046f8cd6e5a75fca71dd19b,
        0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0, 0x1,
        0x100000000000000000000000000000001, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x21ef407bea1953254c1bc318a0af2527, 0x1c147c0993c84eed5f426b94b3350045,
        0xd617c9aca55c89b025aef35, 0xf00b8f02f1c20618a9c13fdf, 0x2a78dd0fd02c0339, 0x0,
        0x7f8ece9a6487cf0c09d3e2d9, 0x41b7c45a9c867cdc30902f9e, 0x5639bb5a38e25dd1, 0x0, 0x1, 0x1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xd617c9aca55c89b025aef35,
                limb1: 0xf00b8f02f1c20618a9c13fdf,
                limb2: 0x2a78dd0fd02c0339,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x7f8ece9a6487cf0c09d3e2d9,
                limb1: 0x41b7c45a9c867cdc30902f9e,
                limb2: 0x5639bb5a38e25dd1,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_ED25519_3P_edge_case() {
    let mut data = array![
        0x4, 0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0,
        0x82e4a33f8e4e5881e791d86b, 0xbcb062435ae8ec5fdaeac4bf, 0x179e1bae9e0f9f34, 0x0,
        0x19657783ba5660e255c21849, 0x7ed7474bcea7551fc71e46bc, 0x596c0a76b75f4756, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0xd617c9aca55c89b025aef35, 0xf00b8f02f1c20618a9c13fdf,
        0x2a78dd0fd02c0339, 0x0, 0x807131659b7830f3f62c1d14, 0xbe483ba563798323cf6fd061,
        0x29c644a5c71da22e, 0x0, 0x4, 0x0, 0x0, 0x12e0c8b2bad640fb19488dec4f65d4d9,
        0xa90f9c3af19922ad9b8a714e61a441c, 0xeb2083e6ce164dba0ff18e0242af9fc3,
        0x2fc154703983ca8ea7e9d498c778ea6, 0x14def9dea2f79cd65812631a5cf5d3ec,
        0x10000000000000000000000000000000, 0x4, 0x7238f02b9f20e09c2181a557,
        0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0, 0xf046f8cd6e5a75fca71dd19b,
        0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0, 0x1,
        0x100000000000000000000000000000001, 0xf7d884feff5aba51d9990dce, 0x999f1d302046c6266257ff5,
        0x7f9caa5ee5815899, 0x0, 0x6d71279424538e87f8ecf2cc, 0x8a8a1d74581da5996a52bbaf,
        0x29acff692eccea25, 0x0, 0x211c4f690d00cb3af0b34c381ddf6429,
        0x10dbbf233e0f266b14c85329c2440c426, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x3242668a77ced3cb6ca4b87c1b759c91, 0x128e825972592d2a632df711368a1c105,
        0xd617c9aca55c89b025aef35, 0xf00b8f02f1c20618a9c13fdf, 0x2a78dd0fd02c0339, 0x0,
        0x7f8ece9a6487cf0c09d3e2d9, 0x41b7c45a9c867cdc30902f9e, 0x5639bb5a38e25dd1, 0x0, 0x1, 0x1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xea1930f7f9c99711b76d5726,
                limb1: 0xa06d0a2a0011cdaa581c307a,
                limb2: 0x6a9d379c7dcfb5b6,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0xe529194a47d7db7a9a8b88b1,
                limb1: 0xebb88d8901d42d55b9966ff5,
                limb2: 0x2ea083fb0eb0877c,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_1P_edge_case() {
    let mut data = array![
        0x2, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0xf1181294833fc48d823f272c,
        0xcf135e7506a45d632d270d45, 0x2, 0x0, 0x2, 0x0, 0x0, 0x97816a916871ca8d3c208c16d87cfd46,
        0x30644e72e131a029b85045b68181585d, 0x5, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1,
        0x100000000000000000000000000000001, 0x1, 0x0, 0x0, 0x0, 0x88a15dfcc0a231066dc0d8d5,
        0xe93ce7417adcfaf9fb0cdb02, 0x30644e72e131a026, 0x0, 0x1, 0x1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 {
                limb0: 0x88a15dfcc0a231066dc0d8d5,
                limb1: 0xe93ce7417adcfaf9fb0cdb02,
                limb2: 0x30644e72e131a026,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_2P_edge_case() {
    let mut data = array![
        0x3, 0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0xf1181294833fc48d823f272c,
        0xcf135e7506a45d632d270d45, 0x2, 0x0, 0x3, 0x0, 0x0, 0xb4862b21fb97d43588561712e8e5216a,
        0x967d0cae6f4590b9a164106cf6a659e, 0x97816a916871ca8d3c208c16d87cfd46,
        0x30644e72e131a029b85045b68181585d, 0x5, 0x86b402ce02e7c7ca81f13d51,
        0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0, 0x371e7b6a5c01505bd4334e81,
        0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0, 0x1,
        0x100000000000000000000000000000001, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x5520c252aad219e02bf5055a4ed023b7, 0x197e50b8e7adb6dd93eeede129c12721, 0x1, 0x0, 0x0, 0x0,
        0x88a15dfcc0a231066dc0d8d5, 0xe93ce7417adcfaf9fb0cdb02, 0x30644e72e131a026, 0x0, 0x1, 0x1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 {
                limb0: 0x88a15dfcc0a231066dc0d8d5,
                limb1: 0xe93ce7417adcfaf9fb0cdb02,
                limb2: 0x30644e72e131a026,
                limb3: 0x0,
            },
        },
    );
}


#[test]
#[ignore]
fn test_msm_GRUMPKIN_3P_edge_case() {
    let mut data = array![
        0x4, 0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0,
        0x20669ef12954f8e3bbc8b4d3, 0x396a6f7243c27ce553121ee3, 0x11438ca2ec259aed, 0x0,
        0xa560a5759c90985fde99aca0, 0xc5b21186cc6dcd0421026513, 0x21fb1f47c6ac55b3, 0x0, 0x0, 0x0,
        0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0xf1181294833fc48d823f272c,
        0xcf135e7506a45d632d270d45, 0x2, 0x0, 0x4, 0x0, 0x0, 0x12e0c8b2bad640fb19488dec4f65d4d9,
        0x1521f387af19922ad9b8a714e61a441c, 0x5a92118719c78df48f4ff31e78de5857,
        0x28fcb26f9c6316b950f244556f25e2a2, 0x97816a916871ca8d3c208c16d87cfd46,
        0x30644e72e131a029b85045b68181585d, 0x5, 0x86b402ce02e7c7ca81f13d51,
        0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0, 0x371e7b6a5c01505bd4334e81,
        0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0, 0x1,
        0x100000000000000000000000000000001, 0xf47b4ee8eecf8576c38173d8, 0x755d90a26c30d7d6fb33afd3,
        0x5e835e05fdb55c5, 0x0, 0x990d5f4767a8d057f8695e4e, 0x5f8dd4e272c268c0d2ce4a39,
        0x1704905427d31a82, 0x0, 0x39dea48eef47b3e6bcae980c9112d477,
        0x538cc4627274d8f320bf5df15c887356, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
        0x10a2e45b33049f11b360c09b6389565b, 0x63f1d0c59d848c415389772b72561b3d, 0x1, 0x0, 0x0, 0x0,
        0x88a15dfcc0a231066dc0d8d5, 0xe93ce7417adcfaf9fb0cdb02, 0x30644e72e131a026, 0x0, 0x1, 0x1,
    ]
        .span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_id = Serde::deserialize(ref data).unwrap();
    let res = msm_g1(points, scalars, curve_id, data);
    assert!(
        res == G1Point {
            x: u384 {
                limb0: 0xf8c1f1ea2f76ef32e8aaa1e5,
                limb1: 0x4f332469fd3c88e2a2a255c6,
                limb2: 0x25bea91cb12ea60f,
                limb3: 0x0,
            },
            y: u384 {
                limb0: 0x13dd399b7d2ee3c5048e382d,
                limb1: 0x8d9fd23cff123740ae29ea9a,
                limb2: 0x8aa44466337bea4,
                limb3: 0x0,
            },
        },
    );
}

