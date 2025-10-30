use garaga::signatures::eddsa_25519::{EdDSASignatureWithHint, is_valid_eddsa_signature};

#[test]
fn test_eddsa_0_0B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x3a0764c9d3fe4bd5b70ab18201985ad7, 0x1a5107f7681a02af2523a6daf372e10e,
        0x8a826e80cce2869072ac60c3004356e5, 0x5501492265e073d874d9e5b81e7f8784,
        0x6bb4f91c70391ec6ac3ba3901582b85f, 0xb107a8e4341516524be5b59f0f55bd2, 0x0, 0x14,
        0xea59f1a1b369842eaf693886, 0xf9224e07ed11424e3ec1fa70, 0x4a92acec2f8e1cbe, 0x0,
        0xe590d7d2c7256a3e0ead52f, 0xd86b5e53124f1f969c189730, 0x537563cb5552be8d, 0x0,
        0x138c5052d6a27a4e4c9560fdd264cfd3, 0x11a2728b581551e5fb75531f987dd1989,
        0x21ed5fd748dd92098b05acad, 0x7994ad2b8159fd82cc56b3ef, 0x50b6933858654726, 0x0,
        0xe2c7733e684c969b9e877cc9, 0x5b1f73e8e98e8c71a215ef2d, 0x697849ab9ad5648, 0x0,
        0x336adfeb48576dcc2cbe3d6bcebf0290, 0xde93b33a51de734be6bf4494c1e417d,
        0x82324bd01ce6f3cf81ab44e62959c82a, 0x6218e309d40065fcc338b3127f468371,
        0xc513d47253187c24b12786bd777645ce, 0x55d0e09a2b9d34292297e08d60d0f620,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_1_2B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x58f03002d07ea48da3a118628ecd51fc, 0x258090481591eb5dac0333ba13ed1608,
        0xa301be3a9ce627480224ecde57d69162, 0xacc35adbd780365e443a7484a248e50c,
        0x59c64d9860f767ae90f2168d539bff18, 0xac41eeacebe27c08dd26e71e9157c4a, 0x2, 0xaf, 0x82,
        0x14, 0x6dcaf738b22009c93c0bdb87, 0x3bf824e64854c39e4f4b4d71, 0x2ba562c0a5855870, 0x0,
        0xd156c934e0630b6b1cade37c, 0xf9592c2a8d4525621a66ff9e, 0x6ea3c2799dcb0791, 0x0,
        0x2b7d8065ce28f598d400cb3247955529, 0x11805a2d4008709e8bf8df99ecd21a9c8,
        0xbea748bd8161e9392414c6af, 0xfb78a46df09a3550b0f40b90, 0x1736a99e1e6b6b2a, 0x0,
        0xcd40357ed01033e3ff528c49, 0xc3d6cd32c65892252ebd9898, 0x11d058072223478a, 0x0,
        0x941c53d6db9e9db6634c5d73d8a9cf3, 0x12d39e660f6e64df38adf8625e063b3cf,
        0x98f8f7962a1ed013293448bba5b444f, 0x39a50ed09ff56e66f9db162c5fb6791a,
        0x18236f1734e3e9b945a9ff5486cdbd02, 0x61213aa2dc9d68833f65d1b48dcf8598,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_2_4B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x5323472831c45de2863153c402c1dac0, 0xa73302d9921f008eeb2a158b87dbabea,
        0x4d6630d51be769278400d1b0c66f4f12, 0x1634b9ae09b5fded6dc5f67d50f88d88,
        0x2a8bc1975609f35d3006aa388d916be2, 0x70c155ea8e5ba9fe40adc2ea5ea32a8, 0x4, 0x5f, 0x4c,
        0x89, 0x89, 0x14, 0xfc2e795891abcdefc79c39ab, 0xc39ec060c9acab62d783f744,
        0x7edd959fdf5944aa, 0x0, 0xb9af3f53cf443ce8258ce9d8, 0x25a93844e779d9acf1a76582,
        0x6044e088dd26d914, 0x0, 0x367ea01340ed3f4eb35fc0b5d6909880,
        0x65becb59a33390e7a8eeb2961732995, 0x4d1173ab1a7126cd6f3553e5, 0x737d4ab842a32b29798c247e,
        0x7175327fc8d35a1d, 0x0, 0xd940bd48ba9f49f998750045, 0x6a748e9b4454606da58d20fa,
        0x1e0a3bd228532c1, 0x0, 0x683951430b64535637cbe187fb571f2,
        0x1426013715579b3cf9108dacbc5d24c5, 0xafd7a14549a75297ba0c7c7b8bf58cc2,
        0x6b0c3a1c5526758320ce254b6896d815, 0x44c071ef224e23c3376a6cfaf588f8b1,
        0x15daf15d98e9a7cec9a0d949aa8a1010,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_3_6B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x54cc85d1334a44bef2d70505a4bfcffb, 0x3d64e33eb887502b0b64e16052616de1,
        0x3f5a6d63ff558746e1e99c1dfc29d66e, 0x29fae5f73018249db793fd1ac9d9a540,
        0x994ed1168dbd8d24bbec6ecc208f4b85, 0x239d831895634dc7094d90e4942175, 0x6, 0x89, 0x1, 0xd,
        0x85, 0x59, 0x72, 0x14, 0x80741b4318d18819882bb551, 0xb2779f18fc7fb12feb65a53,
        0x142ca3875044978f, 0x0, 0xa93609d4fc6719102719e96b, 0x6d8f72df2fdf0661b61a1139,
        0x2a9bc38a67fdf1af, 0x0, 0xeba21cc2b39436195b0b53a4dd3d7e5,
        0x126aa5d255d4eb38e1d8919974d3f183e, 0x72b49563bd0280d6978d8f59, 0xee4b484f08eead598602db92,
        0x1d762afb1672ad6f, 0x0, 0x54194dff66204d8aa3eef75b, 0xc8e4dab18ef2e40c806b2245,
        0x5b786f9856ffe227, 0x0, 0x3c7b94be6b7e6bfa95bee538eefe5fef,
        0x94070cbd62a695ecf77e388896f23b0, 0x166b7bb41838af3515acc516812d7b0a,
        0xc9430416260957f2798ebc1f4c0820, 0xfd1009be194ba52c4c3af995f41ea6de,
        0x28ea2ab7b73169d1eb053770cc4c90cc,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_4_8B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x403164cdaf33b05ed9ce5f824ab51ff8, 0x63b8346f4303258970a920bd0afbab75,
        0x88f2e7d378b17bc18a52b0afc5deadd6, 0x23def957bcf35e5410e116adb1db9a7f,
        0x59620cc93a0fbe07893b728f38c8a514, 0x8fa05f888d4b73ddf4576c1ec85e8bb, 0x8, 0x42, 0x84,
        0xab, 0xc5, 0x1b, 0xb6, 0x72, 0x35, 0x14, 0x62920ccda7a4a43580c16a97,
        0xbc42ab1a6625ff1e10cf6704, 0xddd34ffe3defba, 0x0, 0x21bd69a53ef0e957f99488cf,
        0x951d5e6a7d167e2c8b9c8ee8, 0x27d72985e7a6135f, 0x0, 0x3af1a7897e95058b0a1f9e6f8c89504a,
        0x228f99300a1dbd3aa20393f9adaa37c9, 0x99acfb45641fa7e3e18424da, 0x44eec67bb79d7b7b0a740c2f,
        0x102c2cdf25176fb7, 0x0, 0x1b86dd209edc5f7108c52dd0, 0x67ab6794197e33768c702848,
        0x754e75fee6b042b, 0x0, 0x39e458b6a016bff5cc4ee182498edeaa,
        0x3489b4d0d7178376a2f9c2366c0d415, 0xba02b3f75514da3d99a7c37c948ff75a,
        0x758f833d060d0a8a117ec27148c907fd, 0x46eadcf85f952099fbb70cdb91f10610,
        0x54c40a9283a8e6206a15e02b64b46288,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_5_10B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xe938c55c67fafa1dabf748834b52b231, 0xff4d6ea3c1bbd82ac1279e81e53f4ea8,
        0x914eab3f9f3ff001dee95a418c59e428, 0x9949c55e6b9796edf0c2bdd37f58b9e,
        0x258894367c6237391983f0404c1a15d9, 0x8ced65d6a69a67f49870a9f5ada999e, 0xa, 0x33, 0xd7,
        0xa7, 0x86, 0xad, 0xed, 0x8c, 0x1b, 0xf6, 0x91, 0x14, 0x38c8023c9fb41d7b6939d204,
        0x6c47c9dcf6dd08f0027d26cb, 0x7643328979691ed8, 0x0, 0xf539d2a0878555c6a28113ce,
        0xd28009225c7af9f44698b284, 0x748c3d43195e54b8, 0x0, 0x37fb348b196c8215fbfea725d82bec57,
        0x1070137c89b13bc46aaaa21e205c4982d, 0xb35abd3c324790d8a654aa98, 0xe5e89428ddbb53e8b5978536,
        0x107329dcf2c18f83, 0x0, 0xc569bab4c0dd2d506349ad99, 0x40a1ce7bc71879d83ddb9493,
        0x7d172c2321d811d4, 0x0, 0x238c19411579a152ed700c6fed5a148d,
        0x1265553ee261600443f5b5980f90b6abe, 0x75f6f309f81f9e8aa1f24f9c28eab288,
        0x256a25046b0c5c6e6e7a0eee192ff255, 0x26d6d2c886c8d8938da2c0c48aaa27ab,
        0x4cd530baaf96cfce24c4baf37493d3cc,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_6_12B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xa940aaba3f4f1c1311d111d09336e86f, 0x5782b17ac29ee3b03bf72f01306bd7d3,
        0x1e38377d274b6106faa2333079d99a0f, 0x582292ced69ed05845a9a5c25af6946d,
        0xddc8d0c0c3ae9742c93a862e9567a5c1, 0xec4ad559b4427bab60b8604e58410f7, 0xc, 0x5a, 0x8d,
        0x9d, 0xa, 0x22, 0x35, 0x7e, 0x66, 0x55, 0xf9, 0xc7, 0x85, 0x14, 0x9b1776a1824355ed0f31d4b6,
        0x9ba13aeac727ec1c4c3989d7, 0x1c20c27b1b41836f, 0x0, 0xad7ca35f9f1a595260a64136,
        0x9b28c807d04f47f3e7ba89ae, 0x76a7aad88686c4cd, 0x0, 0x360399ddbc65be2e628e3fae9ee6d55c,
        0x11c8a2911627601b102062e50546df703, 0xfbc5708cfe886fd0498219ad, 0xbd3fded76459b0468208d2b7,
        0x66086effa4c818f0, 0x0, 0xbcdf5d18e7a01ecc5fcbc1aa, 0xb7733fa1f254458c678f0c4,
        0x6ade3a37aaa14389, 0x0, 0x1b635746f2ada962d38fcba9f0aec343,
        0x193ab04b7e052b85dcd94e7d6e265dfc, 0x7ec01a0af470fa5a48b1b20af07af00a,
        0x5fca1ee5ddca2e7454275f8125d54949, 0x141afcb83c809f637a968f7a694d9a6a,
        0xb2e763e5c5d8d490ad567a99d254c52,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_7_14B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x267e03bc533dd3527a5b7a4698f83acf, 0x91f2e233c0e9172225fc036999daa842,
        0xe6253b6b00b21223eb603ce281fee36e, 0xb06ad6af8ddb4ec444f8236610028e83,
        0x9042af526e1d8af5b8f55d19fd871067, 0x6cf94ef95877492000121735cd55380, 0xe, 0x55, 0xc7,
        0xfa, 0x43, 0x4f, 0x5e, 0xd8, 0xcd, 0xec, 0x2b, 0x7a, 0xea, 0xc1, 0x73, 0x14,
        0xc1e32736d15729299aaa09e7, 0x8e424562b0b2d4e10849f3f7, 0x4638985f6c4eecb8, 0x0,
        0xf6f8582e11475ecce6e33473, 0x602deb6eefe4e4c17c82e744, 0x3abfa51751dcd4a0, 0x0,
        0x249f7fab0b194de4a84fcbf4d04b48a2, 0x12e9de13153f96a14ecb14d5df17d9e2d,
        0x63296c74f8e9485907858fda, 0xa300e4caed5ea8cfc94893a3, 0x4a781002e18f5dea, 0x0,
        0xb6accf3462884fda4c7da786, 0x57c6fccffb3d8e0dd16d6d28, 0x184c57d464a36acc, 0x0,
        0x227d1381630c922e8c77a0be24f969f7, 0x983ecf169859b172a652dab7630e8b,
        0xf51214784e30f6963636248940f4bd31, 0x673970dc3e5bec3f2a44fc4e7518e66d,
        0x1750714406fc2d2876ff75bc2cad8e11, 0x100e3069d5815a94db87c734f43b368b,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_8_16B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xa2debae466c062697443478c50a8e534, 0x5b954321cd6c47944f5cde84b48a1b20,
        0x68b308f9b7a3497912a8d040dc273d2a, 0x87ae2db0b9415d7ac1a654ff1b7638f,
        0x53ce87ba90a44fe4e1b07af442c1aa09, 0xc5054ae7c364ceff1ca3915893af392, 0x10, 0xc9, 0x42,
        0xfa, 0x7a, 0xc6, 0xb2, 0x3a, 0xb7, 0xff, 0x61, 0x2f, 0xdc, 0x8e, 0x68, 0xef, 0x39, 0x14,
        0x2ccc5c7cac2eee8b2e47375, 0xbe3457718bcbd53b10b92cf9, 0x47d2b530179b9892, 0x0,
        0xa0d5148d627eff7de3695066, 0xfbbf54cf338c905e6d373cd9, 0x51a1142c5de46d49, 0x0,
        0x3540f747691b1589c7246b2a16cb78f, 0x127059d142c92015acd6f16fcc0f6aca0,
        0xcf28c60e976b78e041947ee, 0xd1a14bd8d8623e6a8a8e9b0a, 0x21bcebc8f8c18ced, 0x0,
        0x5e9d79fb649eeffc22a13d52, 0x6d83860361dd3223bf842efe, 0x4e148cceb02ebe6f, 0x0,
        0x1175e121aacfeb9369560423064b5895, 0x101759331499142832f566dbd72c777cb,
        0x1ea7db3fb12901a9622ff15d26e3634e, 0x5b4066ef8eb5ea44ae38dc24f9b8ce84,
        0x6fe7a48b2b9e4c036d80526005e9e3aa, 0x64599205bcb26f328e09b76cea8e9f6,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_9_18B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xf2e34c3bc3ae76866ad899f12791d274, 0x6b3a2165ca8c1ecd1c192cf591b1cc25,
        0xee92302f49750591173ca043d729e9fb, 0xf5134738ca574ecacfca3604af12b2a,
        0x80db0a70f1418c6c2d32912758db62c2, 0xa3e62e73eae4434700b2714bcca7e02, 0x12, 0xbd, 0x8e,
        0x5, 0x3, 0x3f, 0x3a, 0x8b, 0xcd, 0xcb, 0xf4, 0xbe, 0xce, 0xb7, 0x9, 0x1, 0xc8, 0x2e, 0x31,
        0x14, 0xfa1252aa123e86ee87f8c8c7, 0xa2218cc84ca64ab31a5bdbf9, 0x760ea6e91bcff0fd, 0x0,
        0xbc93a87ac4c455717816c9d1, 0x88c7777545d6c5afdfd4387a, 0x4dd7be231e07a6b8, 0x0,
        0x3662cbc08efd2b73724c4b64e181fe3f, 0x220b0e53b6a13c6efb4727fc6922ae1c,
        0x20ff2c17be4383c0c7b3461, 0xcee6248e4f8755edfae5b7e, 0x7584f114bf6892a4, 0x0,
        0xeb29df4ea33769a5027a031, 0x677e70b90c46b0141bae3def, 0x5bee213f1981b3be, 0x0,
        0x379f66621fb39f0dcb0c73e8ad7ba68f, 0x129078edcd97e548881a71998959917dc,
        0x12f9c9f73a8645fb1ec4f7e542186624, 0x1faf3db7e89ef842c31398dc78b1d6a4,
        0xbb608ba1755964b8a7e626f14eb5a33c, 0x46e151b817dfa0805ffc863f3ba6a850,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_10_20B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x5b0884354e71a735658929859381a21c, 0x7f81008c5dddc89f81423f72ec9fef86,
        0x4d42f6df7f7e676206982d6abcc2ada1, 0x85326f256ee9f3fd90ca95570fa5dbe7,
        0xc44c74eba94023d992e4860331dc7ca, 0x5f193db373926046e3ee85ff3fdaf61, 0x14, 0x8b, 0xa6,
        0xa4, 0xc9, 0xa1, 0x5a, 0x24, 0x4a, 0x9c, 0x26, 0xbb, 0x2a, 0x59, 0xb1, 0x2, 0x6f, 0x21,
        0x34, 0x8b, 0x49, 0x14, 0x937d82291b7f8dc2781d4e5f, 0xa937d9ca11ae15eff034e737,
        0x34b1848dd33cc4bc, 0x0, 0x1aa605be8f31fb5fa2f72f6d, 0x2b625f928529ba42e9970fea,
        0x52f1e366d79e7073, 0x0, 0x387306bd9bc7a9af9d7ca633a58771b9,
        0x243411ab947bef8f30e95cdb895fa8c1, 0x37e3b62e93ef9a9e5987db54, 0x1ffee904ff81caa82c12aba7,
        0x18f6049707602a63, 0x0, 0xe2045701aec1245297f05444, 0xf0506a3f16f97c20c745af91,
        0x6341e55f4b7c38c7, 0x0, 0x29ddad2d13e8fcc5f380cdc5ad8dc7fb,
        0x1df6c6969ff415bd6ab279f827575811, 0x6120e97100cf4aaebfcf1db80e51bdbb,
        0x6ef0677f61dbc7d5f23697cafb1ff6af, 0xc0decbf4f20c787447d823b0dd40639c,
        0x37a3fb1811a6325320bf08033e450a8f,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_11_22B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x147e5eb78bbb945d71f0230d859b3548, 0x85fc02a0bd3f4005a8286ff014af2e32,
        0x1d6e8787cea32243c5badf8999d0dcb6, 0x6ad897a7a6d70bb5249dc798a94d1362,
        0x9fecfb2c653c674ac1d691749ddc140e, 0x13928ab6d079082f3bda45c9382a96, 0x16, 0x1b, 0xa, 0xfb,
        0xa, 0xc4, 0xba, 0x9a, 0xb7, 0xb7, 0x17, 0x2c, 0xdd, 0xc9, 0xeb, 0x42, 0xbb, 0xa1, 0xa6,
        0x4b, 0xce, 0x47, 0xd4, 0x14, 0x95156f4654352c47d318d763, 0x60bbfcd2afac5410c4e71df8,
        0x15b6c8789497160a, 0x0, 0x8b5ca313032ef0415a347710, 0x5804f93938239c9afbc99e9e,
        0x7c65c4735c4ffbd8, 0x0, 0x28a74c9dce2b2e4a842e33e399863e1f,
        0x11da7a8750a2ce61ed28c38c0d512155d, 0x189e561188bc49a918bafffe, 0xfc6b5aae2395e9e47a2ba2a2,
        0xc37c6f902c1d20c, 0x0, 0x876528e8db7ca14d83a81e9c, 0xaacbaa6e2bb209db25f41261,
        0x370d6bc6274f3efe, 0x0, 0x196f76c318589c37468b549f759bb8bb,
        0x117d80ddf19758192660aa5d7d49050f3, 0xc0d2ff32c5a6af243630ec9259c6af2c,
        0x61aea3a5983fd6cae64eb8e88b96850d, 0xafe00c80288a3f318befb32b139a5437,
        0x5c7c637a089f1adb6ead8f3bf7b7eddf,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_12_24B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x5819635133648c8ad52720890198d3b1, 0x71137301f7e496032cabe1db6c1bf93,
        0x974e658b38a47047aa489c4d76fa6a83, 0x24d9df7dc42f7fa2bcfe6729086fc1b3,
        0x230bb64643700951cf8a6929c7cf034b, 0xae72d12d199239156dc9d083054250f, 0x18, 0xd3, 0xd6,
        0x15, 0xa8, 0x47, 0x2d, 0x99, 0x62, 0xbb, 0x70, 0xc5, 0xb5, 0x46, 0x6a, 0x3d, 0x98, 0x3a,
        0x48, 0x11, 0x4, 0x6e, 0x2a, 0xe, 0xf5, 0x14, 0x93365d4deeadd32cb6bef2eb,
        0xb1e8c7218c86075e32aee0, 0x1d7d22ed34f1149, 0x0, 0xe0f56ac073d697677a6fe5e5,
        0x96d8c7060abc38fe9aca1fa8, 0x49724abc771d47ee, 0x0, 0x160b0f9b0c4c14a731464bb6d1b233d7,
        0xd2e63ee4fa297d82b689e05eb59b317, 0xb184e835deae44e701bcd4c3, 0x89e0109a1956c9ad42d7eb0e,
        0x4c9b77572f7eba05, 0x0, 0x6d672251bdafa6854506ba2c, 0xed6dbbf342430dda8e232a5,
        0x522281f8c2485961, 0x0, 0x12bc7ea1134aefe5e5b12d22ad5b534d,
        0x1243a10433596b92d64a074d7e1776fca, 0x82b993a0531c7dd032b01d860a0439de,
        0x7bd75a648b9b9f011eb35a457c8f0fa8, 0xfae6685f07ce72100cf3cb675d2dff5e,
        0x71631f2614a7d8451b8e92b94431e353,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_13_26B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xa0ee85cd9ee2f3d82246ba42a12bf32b, 0x238b21dd270b519b2c41649dbe479c7b,
        0x27dd70b034665bf7f00d035a8c5b1f88, 0xf9bb6964eeb3389334ae3887c0e31ebd,
        0x2831212de5e5382517d238a57130b76, 0xf9a04447ba0dc37653ad665f8b5907a, 0x1a, 0x82, 0xcb,
        0x53, 0xc4, 0xd5, 0xa0, 0x13, 0xba, 0xe5, 0x7, 0x7, 0x59, 0xec, 0x6, 0xc3, 0xc6, 0x95, 0x5a,
        0xb7, 0xa4, 0x5, 0x9, 0x58, 0xec, 0x32, 0x8c, 0x14, 0xdc02485645b64ce43298b09c,
        0xc5b33942074cdd7280920b92, 0x6ab46e3a2ba409d6, 0x0, 0x41ba3f26848b6a909d587a94,
        0xfdbf13ee5884324e413206d9, 0x3a09c07e27fd90b2, 0x0, 0x16e65808b9c27d57d7cd996821a0eff,
        0x22b34ea38eebdbf4fbfde51a1faefa0e, 0xf772d2a88ec86f5ce6a7877e, 0x117c7f63e5c11f2b8d94f370,
        0x692164d4228964e1, 0x0, 0x320d098d9fa46ac8495c66a0, 0xfd7ce2c6687abd6fb03ed1a0,
        0x7b1010a7831bec78, 0x0, 0x3102b7637f8a45b26c33aaf26633fd91,
        0x11c35669269462aabc3a7d66234b45bb3, 0xc9035a46924bf4932cd117694695e539,
        0x6ce4dac054bc1a31f39854152016223e, 0x667226bfd4e63a2380c6eb6b8f164376,
        0x7287797999af616511d3b1c69188181c,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_14_28B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x336ff7c6db96a4af9b6b7ab9a84a089d, 0x7e426943910f0a5281e617d9c916a106,
        0xffd9e58d99e8b56c21661b78235487f5, 0x81efc3a9034537e3ac547010671d9dc2,
        0xca78c41a6f70bd44672981de69f27715, 0x191cba6f957bd02f8b371f8cd549bf0, 0x1c, 0x5c, 0xb6,
        0xf9, 0xaa, 0x59, 0xb8, 0xe, 0xca, 0x14, 0xf6, 0xa6, 0x8f, 0xb4, 0xc, 0xf0, 0x7b, 0x79,
        0x4e, 0x75, 0x17, 0x1f, 0xba, 0x96, 0x26, 0x2c, 0x1c, 0x6a, 0xdc, 0x14,
        0xc64d7b617fdd5e1dbfba3d1c, 0xdfc0e53f0dc3699f5e6cc2c6, 0x144281755c7dcb1f, 0x0,
        0xd2a954957a5a6f44af21b472, 0x32241a2bbac5dcaa73d93ee7, 0x3f300f37829c6980, 0x0,
        0x2db8a4f9c475029ff4a31fd1468b1d9d, 0x105400ba14430012a90e043fe206b7f80,
        0x2916403d6d09a3606f2bb0e1, 0x9a8c140557d268d2555dc87d, 0x2750f18a91ffb29f, 0x0,
        0xc0ea955da0b0dd810bdc057c, 0xaa16523f1baed52398fc986e, 0x76b7543e99975ea1, 0x0,
        0xaea7956216a955368dbcfbf36879b7f, 0x1226e3a51516bc1bad4960660c8167217,
        0xb4bd4eea06387163676c44a6cd8d3bd3, 0x7001ba4f029bd407b7f030ec050834e8,
        0xac5166adc37dd52a5364e38f13cd26e0, 0x2eca1086c3bd55727b33c81bb9a08aa2,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_15_30B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xa3746aa5bbf565ce71fd2d563c32be23, 0x5b5afdb4f9c735f6942f3d576bc3dfa6,
        0x8b375cc7ea20544f1b77de6b1ead8f0f, 0x482b433b82c110c22bcd5066acb56dae,
        0xce93b289897a2fb9fa8f459505b116e0, 0x26ff1aa2a6506fc38203a246ceddfb8, 0x1e, 0xbb, 0x31,
        0x72, 0x79, 0x57, 0x10, 0xfe, 0x0, 0x5, 0x4d, 0x3b, 0x5d, 0xfe, 0xf8, 0xa1, 0x16, 0x23,
        0x58, 0x2d, 0xa6, 0x8b, 0xf8, 0xe4, 0x6d, 0x72, 0xd2, 0x7c, 0xec, 0xe2, 0xaa, 0x14,
        0x695dff34554d1a4dc482d768, 0xd80b6ba6d7fa574d4d3290e7, 0x2a7ec089be1f9cbc, 0x0,
        0x9d67cc27cacb90f274d3b80e, 0xe5f1d418344e291b7d9b6672, 0x1a29179e69f6518b, 0x0,
        0x2148218957c9696ee542bcbdba204bb4, 0x10c6379409ee699507ba2a0c374d2adf7,
        0x4739284c7860670641e3c224, 0xda1134a29f016547e345c4f0, 0x59dd1b7111fe87a, 0x0,
        0x410b16bb6b54b3fe38806104, 0xaee2032adbd06d2248f8bfd5, 0x57dc9745231a60b, 0x0,
        0xe956cf464450cbc9d6b0fba01bc8249, 0x1227d4b51278afc080aecbff814bf4a0f,
        0x51dbe64d8ca775957a1e4bc33415af30, 0x4f2937cc1546c324d01dbb640cb6b0e9,
        0x9b9a4ef694420c49e77e74c2e8d4b572, 0x2a0ac0449362354f213d5b96a050528c,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
fn test_eddsa_16_32B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x920ebc336f46f3a8fca7c6b1783a9fb4, 0xd9169375c3465f46a7c20643a0fb019f,
        0xcfff01c94634eb2c32c1913b036c2604, 0xb33a73b89a17c59c987e834400cc43c,
        0xf96da651bac612c035ef4281b4d8bbec, 0xb79952410703eb0e4b1d68a26b68c30, 0x20, 0xa7, 0x50,
        0xc2, 0x32, 0x93, 0x3d, 0xc1, 0x4b, 0x11, 0x84, 0xd8, 0x6d, 0x8b, 0x4c, 0xe7, 0x2e, 0x16,
        0xd6, 0x97, 0x44, 0xba, 0x69, 0x81, 0x8b, 0x6a, 0xc3, 0x3b, 0x1d, 0x82, 0x3b, 0xb2, 0xc3,
        0x14, 0x662dc9a0c76e92de64ec1a88, 0xd2d804748dd9b3bca82dd8bd, 0x457a1c7d45c2e9a7, 0x0,
        0x11a47f8c54b597cc233eb3c6, 0x63336aece841abd85253fd9a, 0x6ea4440a5a4d3f30, 0x0,
        0x25bf29e718cebe0ce36dd0d4940f9d9d, 0x14fba393e8cd1b8036af3f707a8d9bfc,
        0xfe9858637aa58ff5156e78d4, 0x956a2b8e1e2e952d10372d02, 0x6e43afd2c1a07d87, 0x0,
        0x427e477e25b26ddcf82d0b31, 0xcbbb0211b0fa3200f1155f46, 0x78d4ba282e9fa7d4, 0x0,
        0x28a9d1a11a601216ef8957600ea23a3f, 0x256a50b455e31ea6fd318955d93f2727,
        0x9256394c23e0a68b4782cb46ae015318, 0x3357ca9c3c92a0fbc7694fcf95f4a6,
        0x454ef0b5785b42c24de91294328ace85, 0x7dc110abca7f279ee8797a0fbd3d1bc0,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_17_34B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x4434db9c3af99a4b95c94d4745716baf, 0xc059ce3300b930e2244d821c657c5b9d,
        0x7e2eb16ba77c2fdee09a99f2b1edc16, 0x3cc381f6897a04c578de3c14915edab8,
        0x522d00ec11a803590928c9d528344e4e, 0x43eabb9d06d0c202719feb3f8d79ea3, 0x22, 0x8b, 0xc4,
        0x18, 0x5e, 0x50, 0xe5, 0x7d, 0x5f, 0x87, 0xf4, 0x75, 0x15, 0xfe, 0x2b, 0x18, 0x37, 0xd5,
        0x85, 0xf0, 0xaa, 0xe9, 0xe1, 0xca, 0x38, 0x3b, 0x3e, 0xc9, 0x8, 0x88, 0x4b, 0xb9, 0x0,
        0xff, 0x27, 0x14, 0x8574ce95d05ba104575918c8, 0x478f99955bb34eafda2c4ef3,
        0x76569cefd127cdc3, 0x0, 0x431e7bf616e082984d43819b, 0xd3de171509f57d53c66792c1,
        0x12e6b6b75421ba59, 0x0, 0x42d2ba3c9b2a04ea6efa1fb2c448b27,
        0x13c1fbc940e682b14e2822fd823c59374, 0x5a14bca84136abbbf31fa2b5, 0xc6a3506b2be99c8ce20d3fdf,
        0x48fb6aec47c72452, 0x0, 0x5da1125f4fa6cded1ed8e483, 0xc2b212667311e55132b3860c,
        0x3ac68f0d30d25ab2, 0x0, 0xae2fc31954b7bc1d2b8aac8de538e91,
        0x12f8f3fcfcd9732eb74c7f05846518331, 0x4b0a8d3f7b856f0ccd6b58fa2d44a71c,
        0x83744d08483ecb443579ded32c9c548, 0x40d42f7668f5a94e643c14c7da1fdebd,
        0x6d275cfcf946e02027096f961f1121f2,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_18_36B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xaae380fcc272f2c7810a0979c8707301, 0x265b74ab60116998fc9a37cb3f60bcc2,
        0xeecce3639db5961e14a75a33827f95ac, 0xfdd53395dc42afc24065027dc4a2c395,
        0xb1755e913478f3ea7a18ad79167d8281, 0xc5e1a05dd43ba167501c8066828a947, 0x24, 0xe0, 0x5f,
        0x71, 0xe4, 0xe4, 0x9a, 0x72, 0xec, 0x55, 0xc, 0x44, 0xa3, 0xb8, 0x5a, 0xca, 0x8f, 0x20,
        0xff, 0x26, 0xc3, 0xee, 0x94, 0xa8, 0xf, 0x1b, 0x43, 0x1c, 0x7d, 0x15, 0x4e, 0xc9, 0x60,
        0x3e, 0xe0, 0x25, 0x31, 0x14, 0xae93b41734e620cdee334fa0, 0xd352ee5d019527eb8c98e8f1,
        0x33ec5f8898a0b075, 0x0, 0xb7b28970512e699b3a38463f, 0x6ddca8144ee02b3057724405,
        0x38d2dfd4057d68ba, 0x0, 0xbd218002a44c7b51960ce902651c697,
        0x1111b38650a75851b477de2ab9df44637, 0x84021670d8df0bfb2b628b5d, 0x11e4264eb37f2d5374f3a81,
        0x7411fca07291f143, 0x0, 0xeb56b6b0af302d8903d0f9b7, 0x1ecf1d9759518efbfbce8f53,
        0x6fab7cf11da9bf96, 0x0, 0x99aea252a91ad794073425c9eb7ca69,
        0x16838f2988f00e1efa919551d94ce0b8, 0x115b8c0b51e3124c0c202c162992a1ab,
        0x78e0429e2308507c6259d6eeeb977dde, 0x8e42671bc55a1b56d9411c574a12fdb0,
        0x3f318627b427cd4f04c4bcb332869caf,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_19_38B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x3df5a88a1f2b1ca8076556b2bd0fad34, 0x30e9ee070d903e901ba9ad87cc64aacc,
        0x4973c8372e2332c7549c489c1655b22a, 0xfd08ef29d3fee7abdb0905a2ebb186d4,
        0x43b3ca51ccb56ca22e7be645d11cba75, 0x5f979b9d9fc6a4cecb0d71ffe85b0ee, 0x26, 0x83, 0x83,
        0x67, 0x47, 0x11, 0x83, 0xc7, 0x1f, 0x7e, 0x71, 0x77, 0x24, 0xf8, 0x9d, 0x40, 0x1c, 0x3a,
        0xd9, 0x86, 0x3f, 0xd9, 0xcc, 0x7a, 0xa3, 0xcf, 0x33, 0xd3, 0xc5, 0x29, 0x86, 0xc, 0xb5,
        0x81, 0xf3, 0x9, 0x3d, 0x87, 0xda, 0x14, 0xa6292f8e5d044b22c5c63f84,
        0xb5185d5bf28c5010285e7757, 0x455da0f9cd7bf6b0, 0x0, 0x765e6b22af349115fad57451,
        0x59540b16237f6a1b57b61ec9, 0x62f01856724d22d6, 0x0, 0x17e85b805b8f90696245d1b1b1649e49,
        0x3d44174a16f4dfe2ba3435e92180d6c8, 0x4981e32164acf5f47ec1644b, 0xc9771971ecf4273b72688ecf,
        0x6d903846fdffebc, 0x0, 0xf9f67f8a29cbbb2787d26da9, 0xe579cb390629c7b291f9b184,
        0x59c8c0216b2de9e0, 0x0, 0x2248d914e046643681fcff8df64e4d19,
        0x110cf02766d970c48e424aa5132ad8c4a, 0x26c5bcd8bb36d24db3e484b1d29db41d,
        0x5a146fe46aad15a653ebf45fc80274c1, 0xc49b3df64adbc040338abbe815fd2b80,
        0x5fd235e9d5bdd1630c10d1de12b63e15,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_20_40B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x3cbce77b25c3d1f9d23fd2c2abc57217, 0xb864f9d243773a9b744b8440ee9cd71c,
        0x5b972a3c6db9cea4b893e72476cd2868, 0x5283581e6258406153f34566ffe573f7,
        0x321e5144266f736dafe6df421ff3e789, 0x8cbe8d30e73188d77792a5898a60f0c, 0x28, 0xda, 0x9c,
        0x55, 0x59, 0xd0, 0xea, 0x51, 0xd2, 0x55, 0xb6, 0xbd, 0x9d, 0x76, 0x38, 0xb8, 0x76, 0x47,
        0x2f, 0x94, 0x2b, 0x33, 0xf, 0xc0, 0xe2, 0xb3, 0xa, 0xea, 0x68, 0xd7, 0x73, 0x68, 0xfc,
        0xe4, 0x94, 0x82, 0x72, 0x99, 0x1d, 0x25, 0x7e, 0x14, 0x5fa522a4fef55e8e23ddadc9,
        0x4162b9c3d065c6877fcae158, 0x2c69d38963d3bbb0, 0x0, 0xa32c421a1744326f2487aa9d,
        0x5d3a2032e251af5714e7268, 0x6f0b4dcca7119894, 0x0, 0x1eb1fc609d94408338932e6571331544,
        0x106e4b717d15ec8ce530c18b4be2f30bf, 0x948833f5f59ff99bb96d7d9a, 0x1972451c30b9681ac6cc4894,
        0x71db24cb9a8e37e5, 0x0, 0x5b05737bf52d3fac0da1105c, 0xdb567e54ca42d6c5bcaee354,
        0xd21c41d6e5278aa, 0x0, 0x4a10590868e679657c16429324bdd19,
        0x363fc94159c3ad82e51877bd206d3da4, 0x649a1364d8d8f4e98bc74329570bfc96,
        0x3a80f629c7d3bc576d89c9d496ee9f95, 0x57b85b2b20263ab1877dcbc3614d71ed,
        0x39711965fa2e49141a67dce0499f9413,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_21_42B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xa3ff77a0b64bf8a53add37c4208b76da, 0x8d39c2e67fcefdc35c2b35c50185b64a,
        0x6e7ca9c4d5e470a6262477c6203a721c, 0x2203296e40441e6315a4b01bf74791be,
        0x5fe90f5d23dc8e6a85e78f347d97cae4, 0xa2f558ffddbc7e2778af2ddef1ad97e, 0x2a, 0x56, 0xf1,
        0x32, 0x9d, 0x9a, 0x6b, 0xe2, 0x5a, 0x61, 0x59, 0xc7, 0x2f, 0x12, 0x68, 0x8d, 0xc8, 0x31,
        0x4e, 0x85, 0xdd, 0x9e, 0x7e, 0x4d, 0xc0, 0x5b, 0xbe, 0xcb, 0x77, 0x29, 0xe0, 0x23, 0xc8,
        0x6f, 0x8e, 0x9, 0x37, 0x35, 0x3f, 0x27, 0xc7, 0xed, 0xe9, 0x14, 0x6b84c39c4ad9cb2e9fa5c149,
        0x78c59746fc3088327d4bbd98, 0x68c11f92ae24ca72, 0x0, 0x1ced9f7228d7051e25a21ff2,
        0x5ad874fcfa9ef5ba64690548, 0x51bb8c3d280a1573, 0x0, 0x13a34b7d33dc76aaae012b70bcf1acd0,
        0x2e42e245d8c7acb1d38141d0f2db3a2d, 0x3e1169a11a78e93989c338ab, 0x899bef2f13548199aa4ef880,
        0x4f1ae0fecc6a40e4, 0x0, 0x99a7d8e333508e404954f77b, 0x6a763523b369a5647f1c3231,
        0x24569ad8c201845a, 0x0, 0x66ff6748d8f79e3c78e61150ca8a367,
        0x222ba2090a2091dccb807d3796e4bcba, 0xe4a0af74125fe32ce5ba54d9150a8f70,
        0x2f9b4728682aa4dc6c45b098f9fa09c7, 0xe1c91d844f3ac84d0a918cb52493a511,
        0x3b5e09022b3317db3e3908788aa7e0f8,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_22_44B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x476be4e75dba5012b6312fd42b6afbec, 0x37be3a0a7bdfd17b1ab70d66bcdfaf19,
        0xb801bc80df12f7989423c74c3485f89a, 0xf6e2727a014555aa8bd2a1d41e293806,
        0xa46c3a54f5b9fa5beba63d60f9cc4956, 0xcb015f6de95bf66bf763c156638afa7, 0x2c, 0x63, 0xb8,
        0xb, 0x79, 0x56, 0xac, 0xbe, 0xcf, 0xc, 0x35, 0xe9, 0xab, 0x6, 0xb9, 0x14, 0xb0, 0xc7, 0x1,
        0x4f, 0xe1, 0xa4, 0xbb, 0xc0, 0x21, 0x72, 0x40, 0xc1, 0xa3, 0x30, 0x95, 0xd7, 0x7, 0x95,
        0x3e, 0xd7, 0x7b, 0x15, 0xd2, 0x11, 0xad, 0xaf, 0x9b, 0x97, 0xdc, 0x14,
        0x8e7a92dea46f5561cf42f4bf, 0x3c16c9f7e12c8031937b5841, 0x2fad501544bd25c3, 0x0,
        0x9a42264efd722de5794de5a1, 0x8ad70bf5e54d7c1e3e4833a8, 0x52e0fbeffe0d8623, 0x0,
        0x63dda375cf39add7aff7470ead0dda5, 0x128071e01fe406fbeba88b7ccaa65a4a4,
        0x6527a45e52b613894241f38, 0x27f84d85b97550d9cff0469e, 0xeff192310afb7, 0x0,
        0x57d8a273d2fa8a6a0a827f15, 0xca33afdf5da8a3e129924e5e, 0x17dbe1f0ad58ba4e, 0x0,
        0x235bfdd3d4df5fbab9ebc276cf04fa73, 0x1024324259d46313353e5ba361cda0906,
        0x20866b32fd08893480bdca692eb706b5, 0x44899a259832955b940237cc48fa0d8,
        0x396285d427e7e9697dd65ae4a51141ba, 0x257ce91e91c41dabaf781533a67e1b9e,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_23_46B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xeedad93b7bddeacc2a01b2aa95e7a3ab, 0x32386e83a3c29936c9d7dc8b25f56fed,
        0xe016915541fad2d520ce87d4a81f692c, 0xf76cd64135185625150e24f57c39f4bb,
        0x4347384defdb3903398d38a401245853, 0xb6e8a1a13b9a78ba6ab8d5ff546a3ca, 0x2e, 0x4f, 0x18,
        0x46, 0xdd, 0x7a, 0xd5, 0xe, 0x54, 0x5d, 0x4c, 0xfb, 0xff, 0xbb, 0x1d, 0xc2, 0xff, 0x14,
        0x5d, 0xc1, 0x23, 0x75, 0x4d, 0x8, 0xaf, 0x4e, 0x44, 0xec, 0xc0, 0xbc, 0x8c, 0x91, 0x41,
        0x13, 0x88, 0xbc, 0x76, 0x53, 0xe2, 0xd8, 0x93, 0xd1, 0xea, 0xc2, 0x10, 0x7d, 0x5, 0x14,
        0xf6aa1c3bcc6e9700fc72b9ec, 0x681c04f4d32e18731212375d, 0x5e0dd71647da599c, 0x0,
        0x8e0f72c3b68f7ebafcec36a9, 0xbfdb6659c14511f534e282e1, 0x560f035da03f446c, 0x0,
        0x6754299b9230b4b748b81c8773dcc0b, 0x11e0735b5b5d8d1e8a026d71f4944f30f,
        0x7b9ba4e30b721ef913b4b6af, 0x23173f3fe90e6b5dec2fab9b, 0x230513fc8fe0951c, 0x0,
        0x561a02e5dfbd78c8fb30a94b, 0x9b595711a1baf14fbec9b24b, 0x4c2dfe6dc0026e8b, 0x0,
        0xffb8cc0ac6f793bee4a03695b069793, 0x1028d22f7af6abfad53ca95e74b6d75dc,
        0x5c419a73d0a5de49c039f6583bfa4681, 0x6706312f873431995171f83697a97122,
        0xc3aee7a86e08b3325330143719401486, 0x6faf8d956cf70dd2ebc8a45c3391c21,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_24_48B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xcfdb8360a12c992b6b3ed4a4bbefd290, 0x7fc4d34558e9f375eeb007393822b3a2,
        0xd2cb053d81746685d5f1ae2144992efa, 0x60fec2bdfdc60dcd6eaf24b45eef84cf,
        0x9e14c9f1b2bf594ff3ec12338885e95f, 0xbaedd28edf3301173b205daecc99c5b, 0x30, 0x78, 0x3e,
        0x33, 0xc3, 0xac, 0xbd, 0xbb, 0x36, 0xe8, 0x19, 0xf5, 0x44, 0xa7, 0x78, 0x1d, 0x83, 0xfc,
        0x28, 0x3d, 0x33, 0x9, 0xf5, 0xd3, 0xd1, 0x2c, 0x8d, 0xcd, 0x6b, 0xb, 0x3d, 0xe, 0x89, 0xe3,
        0x8c, 0xfd, 0x3b, 0x4d, 0x8, 0x85, 0x66, 0x1c, 0xa5, 0x47, 0xfb, 0x97, 0x64, 0xab, 0xff,
        0x14, 0xc17a6d05aaa41f9149dcdb2b, 0x402616ffdb4be4a39136a15a, 0x5ba0b15e673922b, 0x0,
        0xdf4a5ed66de118a654bb55b4, 0x49018cec5c513896e1d4a5e6, 0x6ae98c1c50103d05, 0x0,
        0x723647dbe73565e7b296b665b6be597, 0x19ef237fc11b456bec481912e370bb95,
        0x71388f6384ec1f413bb64710, 0x5df63eb4f74230be958e4991, 0x562fa915201de425, 0x0,
        0xa445ce534badd02fdfd8f5cc, 0x73ac7e1c6a395204156ead87, 0x3824d1eac362f57c, 0x0,
        0x334bb82d22d7cc13bf79805b67a26a85, 0x12582916a2d746811cf563824ac031712,
        0xce5742cee59b900d9b3befe2ee496042, 0x5d32a7afdf3f080544d2ce6e7ca33834,
        0x69b771d216a328ed57ed6b4ec1cad004, 0x75fe7470f00d84132c4a40f8d601283c,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_25_50B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x9fb36f3a5f8c20a6bb348ee70f8502c, 0xea3e15166e0a2078e025ccdb5030110b,
        0xdcda74b5f6ae8167383631a49a4e669, 0x82d3d8fdbe897cc664a2d0f158cc1e73,
        0x579680c715179313f50bcc333be18d9d, 0xe593607433d771c964c7e560b9bfe2, 0x32, 0xf3, 0x99,
        0x2c, 0xde, 0x64, 0x93, 0xe6, 0x71, 0xf1, 0xe1, 0x29, 0xdd, 0xca, 0x80, 0x38, 0xb0, 0xab,
        0xdb, 0x77, 0xbb, 0x90, 0x35, 0xf9, 0xf8, 0xbe, 0x54, 0xbd, 0x5d, 0x68, 0xc1, 0xae, 0xff,
        0x72, 0x4f, 0xf4, 0x7d, 0x29, 0x34, 0x43, 0x91, 0xdc, 0x53, 0x61, 0x66, 0xb8, 0x67, 0x1c,
        0xbb, 0xf1, 0x23, 0x14, 0xb3b35fd5c7c76a8ea5b2a6ba, 0x6c0a0a53693666bd25ee428c,
        0x202f90c8ef321f6f, 0x0, 0x3c08c085af81e14f87c4bc03, 0x3afe55b3061dc180489354f,
        0x837540e0ecd67a3, 0x0, 0x333eda5ec9a4997625f1b53f1102021d,
        0x1079bddd98bb1a199c2d8b57dcb5dc00f, 0xa9db5a3566d6d7bf3cf98b58, 0xd867c7904c4254f037ab74f5,
        0x19c96b03ef8562cd, 0x0, 0xaae27af9c2298bc97cd34493, 0xfc562747747b0394b3f02019,
        0x1a01d22c3d2fa4a0, 0x0, 0x111acf0e8d550078a432773811d0e09,
        0x21bb5e205ac4f9c793f53dabc51b401e, 0x83c9cb27881166dc58f55d24a3cc5629,
        0x13943760e9fccf769ae50fa9cbe54f4, 0xac766d9b53daefcb66a02c6d840691a3,
        0x49509ad5e9d477ad6c36d0b0d515bdb4,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_26_52B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xe1405cbd4e9a829f72cf5a41f2193c5e, 0x1ae53709ed876037a90357a9bc9fbca6,
        0xcc2c3c13dd3b0b36d4f91e81a1c3d427, 0x139b7f17e47eb06c771582242f2cd030,
        0x2e187f3c66c725f2d8fec2a670dd42fc, 0x1eab1c54e83d5e1b0c70df2cfece87e, 0x34, 0xf8, 0xb2,
        0x19, 0x62, 0x44, 0x7b, 0xa, 0x8f, 0x2e, 0x42, 0x79, 0xde, 0x41, 0x1b, 0xea, 0x12, 0x8e,
        0xb, 0xe4, 0x4b, 0x69, 0x15, 0xe6, 0xcd, 0xa8, 0x83, 0x41, 0xa6, 0x8a, 0xd, 0x81, 0x83,
        0x57, 0xdb, 0x93, 0x8e, 0xac, 0x73, 0xe0, 0xaf, 0x6d, 0x31, 0x20, 0x6b, 0x39, 0x48, 0xf8,
        0xc4, 0x8a, 0x44, 0x73, 0x8, 0x14, 0xe65e7fe469389002fc7e8a57, 0xf5b85bed46a00c3b565ebe3,
        0xdfb32e26ef297ed, 0x0, 0xafa8530415d22760c6d2b82a, 0x3d4cf9af9e321a9d52458d29,
        0x1017dee106d78e13, 0x0, 0x204988f6a59dff4ef4bfb55d11ab1ec5,
        0x1c7564759fa0994497c7b23d5195c3af, 0x67cd465864680f744b4c139f, 0x1f6118c3db728c0b671289a0,
        0x526a6d0a81c6de17, 0x0, 0x7e2abbcc7e46b7f2a07873eb, 0x6d925be11b749e01fbed5766,
        0x42b07313b6687cad, 0x0, 0x753cc470c1cbef106b37c0820954b69,
        0x107776920c1afb3097c6af04856fcc034, 0x2949b860890c89625374cd3a9b74b1b2,
        0x3e8bf981fa03c01cc7dccd738a261f28, 0x8ab1c1445f2f250fc8c354c959da80,
        0x238e9c2dd40f5ec92dd14281c6e86509,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_27_54B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xe205910db2c633ec94a8fe163e9ca965, 0x2e4aabfeac8b4dbd9b9d76a464274ea0,
        0xa27b806af44a61d382b6b8831d90bb01, 0x75a50aff49f523345d3275b7fe581369,
        0xf4d419b354f3d821970fc7e9741a4e7e, 0xd736446d6fe94fb0ffd70c84514d9a1, 0x36, 0xe0, 0x72,
        0x41, 0xdb, 0xd3, 0xad, 0xbe, 0x61, 0xb, 0xbe, 0x4d, 0x0, 0x5d, 0xd4, 0x67, 0x32, 0xa4,
        0xc2, 0x50, 0x86, 0xec, 0xb8, 0xec, 0x29, 0xcd, 0x7b, 0xca, 0x11, 0x6e, 0x1b, 0xf9, 0xf5,
        0x3b, 0xfb, 0xf3, 0xe1, 0x1f, 0xa4, 0x90, 0x18, 0xd3, 0x9f, 0xf1, 0x15, 0x4a, 0x6, 0x66,
        0x8e, 0xf7, 0xdf, 0x5c, 0x67, 0x8e, 0x6a, 0x14, 0x8fd48a5f0cbc7cd551b22b8f,
        0xf70280b61c3739182e9707c5, 0x1bb4d9afe2b6388a, 0x0, 0xedd3e73dfef36cf88bd9c61d,
        0xaec12bf9f55127130f8749cc, 0x4c9f640f4dd1e2af, 0x0, 0x188b5300042082233b95b31db38d6faf,
        0x9223932d7b504223f930056888ac19c, 0x2e970b3220987939bb229eaa, 0x47a6fa0b58ad803d3daaf244,
        0x5f1c153a8b5f9869, 0x0, 0xb3795852b41dd54acd555598, 0x8d67b51c5ff50eb415b43815,
        0x326cc94912a4cc3e, 0x0, 0x165d26c1c61e237b08433ed3d7ee3ca7,
        0x124bbe48efb6b7c2e2caf70c2e3cb5d1c, 0xe98560f4b05a42b6abfd7d4381e6ea5c,
        0x791bc3d6e37de6c41a20af9aac189a7d, 0x4c6aaaebe23953c625e6c2ce955a818c,
        0x6286fc75f531a5a68b22af0e38eb4903,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_28_56B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x6cd49146124c9ae4dfcd13517a4ca057, 0xda1fa7ec0a33a172cb9d3f348fdc9c1f,
        0x90c02885701acf55147dc8f947c9cba6, 0xfa55dea45474f4adba1d5d85e4ce1ef1,
        0x2d9921cf8c29598f5f5b3ad7364be84c, 0xb66c3f2329d7e3b75873d1634ef92f4, 0x38, 0x7f, 0x31,
        0x8d, 0xbd, 0x12, 0x1c, 0x8, 0xbf, 0xdd, 0xfe, 0xff, 0x4f, 0x6a, 0xff, 0x4e, 0x45, 0x79,
        0x32, 0x51, 0xf8, 0xab, 0xf6, 0x58, 0x40, 0x33, 0x58, 0x23, 0x89, 0x84, 0x36, 0x0, 0x54,
        0xf2, 0xa8, 0x62, 0xc5, 0xbb, 0x83, 0xed, 0x89, 0x2, 0x5d, 0x20, 0x14, 0xa7, 0xa0, 0xce,
        0xe5, 0xd, 0xa3, 0xcb, 0xe, 0x76, 0xbb, 0xb6, 0xbf, 0x14, 0x221f8ae08ba5a8b36e213773,
        0x3b5c2e1a0eb0f0dbbf806105, 0x4193c37bae1895cf, 0x0, 0x93b2e4cb7b4cb75620dd80ad,
        0x30c7fe492e2173818988c7b, 0x13c907b836ebd26d, 0x0, 0x1892c94646453a6599670cbf4d7329cb,
        0x26c90b82594af5ef94487cfcd2106d53, 0xd9ddc94af516fb8449f061a8, 0xc0fb572fdbe70b1d59d80007,
        0x2d8b0f14c92d1cdd, 0x0, 0xcddf1ba9914ce12c8cc36a68, 0x79e032c4c246b23cd4943fa7,
        0x33443ad08a8b45d4, 0x0, 0x2e324828471c960e7c93d1f2920a0f3b,
        0x10d9e8be6f56de45c5a85896623d83ef0, 0x7d5783030cd8e4017806134ff0ebf737,
        0x3e70836352841b985940286dd86ee97e, 0xe730705124f314044c5f7421d9b16011,
        0x90ad7fad39fa85be8e39c6bed340cbb,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_29_58B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xa5cd35ea3685ae2b5e62991409da7e0f, 0x123634832c6f1d346b417e9c6ad13b48,
        0xe074ecb682f8165568625d6af241bdef, 0x78659c9ae9268f2431c203d23018a7d5,
        0x9fbcecf9240dad1672fab8cd680d90ec, 0x4a71fa395536426f6826566515365fa, 0x3a, 0x8d, 0xdc,
        0xd6, 0x30, 0x43, 0xf5, 0x5e, 0xc3, 0xbf, 0xc8, 0x3d, 0xce, 0xae, 0x69, 0xd8, 0xf8, 0xb3,
        0x2f, 0x4c, 0xdb, 0x6e, 0x2a, 0xeb, 0xd9, 0x4b, 0x43, 0x14, 0xf8, 0xfe, 0x72, 0x87, 0xdc,
        0xb6, 0x27, 0x32, 0xc9, 0x5, 0x2e, 0x75, 0x57, 0xfe, 0x63, 0x53, 0x43, 0x38, 0xef, 0xb5,
        0xb6, 0x25, 0x4c, 0x5d, 0x41, 0xd2, 0x69, 0xc, 0xf5, 0x14, 0x4f, 0x14,
        0x9b1c19208091298d52b36ff8, 0x86a37c43e6283f0de97ec43c, 0x4a72aab104cfe59c, 0x0,
        0xdea3ba3657ed19626b8a6032, 0x41ae598bba09f743633bf037, 0x1dbd4c50f393a85f, 0x0,
        0x1bc74f1028aeb6f6970483ae9cc95d63, 0x2025f40277c842f6a70792a848c26cb4,
        0x50994f1284796db6fad98849, 0x30278b2241f9ac8d9d9adcfb, 0x6ae23674d14c9829, 0x0,
        0x4ee6e2f223e8d6739f5f5880, 0x236022ff45332e17e050ef89, 0x4e62795b32055a40, 0x0,
        0x3e5d60e5fc3b1f7d57a9c5f4a661cef3, 0x134cf865b10157749c76a5699e5a54c9f,
        0xf044d65abce84b8879ae487d70dbcb0c, 0x18b94c37ce13d3ab114b84324e8fd5e7,
        0xe2358f86e3017a6600ec864c9b562c80, 0x4252d8aff604e746087ad8b8c79e7bd5,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_30_60B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x9b7290b34092910ceb3f4d5440e58d78, 0x135f2ec69465bb63e97ad644be987e4,
        0x409078c3a7fa07258520e79127e0fdd2, 0x42154902407f55ac13f321636486efd9,
        0x88515dbc1f5095d4b0cd90695cd067dd, 0xf69c27fa40306ee8b09f61bdc84bbbf, 0x3c, 0x3a, 0x53,
        0x59, 0x4f, 0x3f, 0xba, 0x3, 0x2, 0x93, 0x18, 0xf5, 0x12, 0xb0, 0x84, 0xa0, 0x71, 0xeb,
        0xd6, 0xb, 0xae, 0xc7, 0xf5, 0x5b, 0x2, 0x8d, 0xc7, 0x3b, 0xfc, 0x9c, 0x74, 0xe0, 0xca,
        0x49, 0x6b, 0xf8, 0x19, 0xdd, 0x92, 0xab, 0x61, 0xcd, 0x8b, 0x74, 0xbe, 0x3c, 0xd, 0x6d,
        0xcd, 0x12, 0x8e, 0xfc, 0x5e, 0xd3, 0x34, 0x2c, 0xba, 0x12, 0x4f, 0x72, 0x6c, 0x14,
        0x767582504fcdf5c532ae821f, 0x369283997ece24f13874c7f3, 0x2c98a25fbbac87a0, 0x0,
        0xb605dd1a7fd4bc65bfa1cc37, 0xa8f7771da5567342f07d981f, 0x70c2347f0c6cad9d, 0x0,
        0x2374543478d593b0338a55f4bfc170d1, 0x1091fb47f6277c497014342fd6302db4f,
        0x75607a81fc9dfdbce0a61099, 0xaaf1cdc31dac2c136d9f0796, 0x320d0d002388dca2, 0x0,
        0xd52681f4406522dfe89abd4b, 0x16c7f383c6733c5126d3ef23, 0x705ed4abf42a6a8b, 0x0,
        0x28b688ea47e475fbe26e2054b2f25ec5, 0x12c0f45dc3f535dd3bda5ee32c863aa05,
        0x3c11a7163b0a795314eedc7f9f209cf2, 0x38b48bcaf3ce9863ef2021828e2f49c3,
        0x25b049f36336d365154fee2d92f7209a, 0x7afa60ee9713dfea9945e105904bb927,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_eddsa_31_62B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0xe2c6f49b0327d5e1b001737df5ea1005, 0xb15103103c20f3345476b4613a0a3092,
        0xec38dd1c63f1903a5b70c76a43d8e506, 0xad60d5e7a4be5efaf2b9a97897a43f1a,
        0xca1a7642373220a48bfafa42ff26dda7, 0xb435db4aa2df73ff6be1bc20d940469, 0x3e, 0x54, 0xe0,
        0xca, 0xa8, 0xe6, 0x39, 0x19, 0xca, 0x61, 0x4b, 0x2b, 0xfd, 0x30, 0x8c, 0xcf, 0xe5, 0xc,
        0x9e, 0xa8, 0x88, 0xe1, 0xee, 0x44, 0x46, 0xd6, 0x82, 0xcb, 0x50, 0x34, 0x62, 0x7f, 0x97,
        0xb0, 0x53, 0x92, 0xc0, 0x4e, 0x83, 0x55, 0x56, 0xc3, 0x1c, 0x52, 0x81, 0x6a, 0x48, 0xe4,
        0xfb, 0x19, 0x66, 0x93, 0x20, 0x6b, 0x8a, 0xfb, 0x44, 0x8, 0x66, 0x2b, 0x3c, 0xb5, 0x75,
        0x14, 0x962624a2b58a3398a4cb5f20, 0xa2f7b76e2e5211d70478e1c4, 0x34f1dbb6c3a2820f, 0x0,
        0xb1959060b4fbc9fdbf1fbd3d, 0xb65e79dd2152fee4e722175b, 0x1e30caa19014bf94, 0x0,
        0x566024cc1d8444077611d2dbc0124c0, 0x838993ad8b06741eb5a8c34b36a8ab9,
        0xa8daf3da5d467d1f8f78fa2e, 0xda73157212cd2884342c6fe5, 0x2027ede735f65b7d, 0x0,
        0x66c3c9bb08d3e040fcfc08b1, 0x2653aa90486e889f8d9527d9, 0x5fd1337521e862db, 0x0,
        0x5dca01e9cbf9f2873a07d909c4bc1d9, 0x1703982ac551c4c9dbe2856f29d22033,
        0xbed3d85b70b069b3447e8327aaf8695f, 0x408a942fe8f45cddd22487f5180e39a3,
        0x8c9bf6a015c76f19883037c34ca77b45, 0x566af0d91aa86827627d0323bd33fdb9,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}

#[test]
fn test_eddsa_32_64B() {
    let mut eddsa_sig_with_hints_serialized = array![
        0x51e367ada5fda575b66d4bf876a03ff7, 0xccc6e9870301ca0968d1ad297f8e1ea4,
        0xa1ea48dde7ba2174837f2011a7d2b957, 0x3a8f457be1fe065830f1a0709a1aab8e,
        0x770b006f49e8c90a3e4d83d102b36409, 0x66aee0e84c7fb32e657a9f8413b08f0, 0x40, 0x4b, 0xaf,
        0xda, 0xc9, 0x9, 0x9d, 0x40, 0x57, 0xed, 0x6d, 0xd0, 0x8b, 0xca, 0xee, 0x87, 0x56, 0xe9,
        0xa4, 0xf, 0x2c, 0xb9, 0x59, 0x80, 0x20, 0xeb, 0x95, 0x1, 0x95, 0x28, 0x40, 0x9b, 0xbe,
        0xa3, 0x8b, 0x38, 0x4a, 0x59, 0xf1, 0x19, 0xf5, 0x72, 0x97, 0xbf, 0xb2, 0xfa, 0x14, 0x2f,
        0xc7, 0xbb, 0x1d, 0x90, 0xdb, 0xdd, 0xde, 0x77, 0x2b, 0xcd, 0xe4, 0x8c, 0x56, 0x70, 0xd5,
        0xfa, 0x13, 0x14, 0xd161fc726de012c0e0743e7, 0x42acee4e16921c0867f97342, 0x3df8d27df4355025,
        0x0, 0x417af9c7a0442b578a1bc6fd, 0x8b47ac563f259260e2b0f80, 0x6c6ff02c28f84b7c, 0x0,
        0xa02b77f8fd8b7c1eb63155c5ea920a5, 0x106d7cd46cb0e0c81f3d995c3bc47503d,
        0xb4630746992c8a357d6df9eb, 0x5fdba5230f13b83f1c2abc8e, 0x23b4e6d66fd0dd34, 0x0,
        0x7670dc68e4c7436863f0f4e, 0xf570573dc0f1cc0cdc47bf49, 0x5e0b72bc8a7978af, 0x0,
        0x211da8e595abb9413372df7309b63acf, 0x1085d544d1097dd536984587f626dac87,
        0xf72722a04d4e780bc03c03781212ceac, 0x7d057bb78a4c6624f1754cb4366b1757,
        0xdb32bb362e6f4e4ab652852ea150f205, 0x745397cfb61e599ed42508c8e6169142,
    ]
        .span();
    let public_key_y = Serde::<u256>::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let eddsa_with_hints = Serde::<
        EdDSASignatureWithHint,
    >::deserialize(ref eddsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_eddsa_signature(eddsa_with_hints, public_key_y);
    assert!(is_valid);
}
