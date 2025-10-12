use garaga::core::circuit::u288IntoCircuitInputValue;
use garaga::definitions::G1Point;
use garaga::signatures::schnorr::{
    SchnorrSignatureWithHint, is_valid_schnorr_signature_assuming_hash,
};

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_schnorr_BN254() {
    let mut sch_sig_with_hints_serialized = array![
        0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0xf14522f0e41279fa3733fed2, 0xea20efd268b756a9c0b06945, 0x7df9c9692acbd19, 0x0,
        0x536c985db33c69f7c242e07a, 0xfc531bccffafcf1e59d91fb9, 0x2585e4f8a31664cb, 0x0,
        0x88be2ce9ce62b465354a3799fa203a0f, 0x153a203b4df3737a1b3372ac547e5fbc,
        0x12e0c8b2bad640fb19488dec4f65d4da, 0x1521f387af19922ad9b8a714e61a441c, 0x18,
        0x2c40cb132c58c1528d9f95d4, 0x363f4c34cb9e9ec70646c9a0, 0x283fe6ad6138b4db, 0x0,
        0x10969c686e4b6ba132f856ea, 0x9a84e9b2de29941e85990dd8, 0xce8c7dd9d8b7727, 0x0,
        0x15f0bf1ccf4e04fd, 0x100000000000000004d15cba927fede3d,
        0x100000000000000003fda8089c1ac8853, 0x8309133f4f176e9e, 0x2c41289f2cce1b1d98bc1c58,
        0x877a1e0880ae4ac2e8cb9898, 0x1f1f91048403230b, 0x0, 0x51b26382cce36f83e9330566,
        0x9303c191ab170a86a28c3ddd, 0x122b07c7aa481cb, 0x0, 0x100000000000000003a941ddef107f2c9,
        0x10000000000000000002a2b771d1d6d88, 0x6f26862a18f2c12b, 0x44028f462731bd,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let sch_with_hints = Serde::<
        SchnorrSignatureWithHint,
    >::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_schnorr_signature_assuming_hash(sch_with_hints, public_key, 0);
    assert!(is_valid);
}


#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_schnorr_BLS12_381() {
    let mut sch_sig_with_hints_serialized = array![
        0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x73dc29ec930fa565a5979354, 0x9429c7a3a7a2e40636af119e,
        0x63acb8cedd134d23d3ccba66, 0x18e6b0be5c742604e8963d45, 0xde4f62a6588c9401ffefbd3,
        0x9bb5f797ac6d3395b71420b5, 0xdc39e973aaf31de52219df08, 0x105dcc4dce3960447d21d3c1,
        0xb83ced7922696854920e4dce5618fd79, 0x1efa0c12855ed037f8665a14d0c63ba1,
        0x12e0c8b2bad640fb19488dec4f65d4da, 0x2a43e70faf19922ad9b8a714e61a441c, 0x18,
        0x99c33ff58fea7052bbb086a1, 0x1c359e13cb837e312dddb499, 0xedbe35427d90e4bb5ebcdf77,
        0xb985b53c974e161da07a472, 0xde25a39170f2c0507b5ed860, 0x994e3ae48dce086260b85782,
        0x7b22ea9577da0309f37f3ef9, 0x10ea8776b9541b0999d8d9cd, 0x22dbd86bddefd4d2,
        0x100000000000000002092233c9decb8ff, 0xcd1dbee71ada39b7, 0x9322462863de7845,
        0x95784ad2a24613cafab3e5ce, 0xdcf21fab1f76105f40e47606, 0x53de1e9b25d4c163c91db04c,
        0x11a0b3d6dba83f3db716cb0e, 0x79e7b489b946a83ef4db5c0, 0x3b050ac62a98e6a19f9fe1c6,
        0x93e750c788c6bfeb8566333a, 0x457b247b6591483d8dbf18b, 0x100000000000000008af4c254e183b405,
        0x100000000000000004cbee0df44e8382c, 0x10000000000000000946f8bb609f9ba7d,
        0x100000000000000004e77077ba28bdfd6,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let sch_with_hints = Serde::<
        SchnorrSignatureWithHint,
    >::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_schnorr_signature_assuming_hash(sch_with_hints, public_key, 1);
    assert!(is_valid);
}


#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_schnorr_SECP256R1() {
    let mut sch_sig_with_hints_serialized = array![
        0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0,
        0xd3ff147ff0ee4213f51f677d, 0x431366a7732a6e4a6b942255, 0x9fe743b25d39a591, 0x0,
        0x227664fcd18152d34168f6ded74ab915, 0x69b292ba7d07a7c252d76438f5ee7ec1,
        0xe443df789558867f5ba91faf7a024205, 0x23a7711a8133287637ebdcd9e87a1613, 0x14,
        0xe7048fa08ff83c48faafa01e, 0x4f5e1916e57a6dbf63c36e8d, 0x72872d18857fcd24, 0x0,
        0x701ae40e4ba5a9f2e60e57ea, 0xadfda7abf39a0913191769f6, 0x2de1ee879affd779, 0x0,
        0x434ebc818522df6c3a48fdeffa4bc338, 0x187026bb983fceb4a56a5ca9e9c969631,
        0x40ab24bf96ae6fa731d65b90, 0x3d2d6da80d5ca858290e1409, 0x953b9901eec6e415, 0x0,
        0x553919b2bd1f42bea69d67f3, 0x320dbca9f723841d3be6dcf9, 0x936046f4cb8c4595, 0x0,
        0x3de0ac20b2665b5ee208e66433aaac05, 0x67db401fe06eea845a19e61367b76a34,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let sch_with_hints = Serde::<
        SchnorrSignatureWithHint,
    >::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_schnorr_signature_assuming_hash(sch_with_hints, public_key, 3);
    assert!(is_valid);
}


#[test]
fn test_schnorr_SECP256K1() {
    let mut sch_sig_with_hints_serialized = array![
        0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0,
        0xfdfdc509f368ba4395773d3a, 0x8de2b60b577a13d0f83b578e, 0xc2dd970269530ba2, 0x0,
        0x2cad564f3e93c6683bd94b5438ce08f0, 0xcbbfcb3b677e87eff66c9a804800a3b3,
        0xe443df789558867f5ba91faf7a024205, 0x23a7711a8133287637ebdcd9e87a1613, 0x18,
        0x594f9cb2a86a873bb8d4ccbd, 0xfee1700bc5d2111958ae798c, 0x4d99e99571d0a61e, 0x0,
        0xf284daf0aabffcef1939ef8, 0x91753b141fbe90ddcb717736, 0x3233811221bd1d30, 0x0,
        0x100000000000000000a9b06fa280b530a, 0x1000000000000000040415040c7a17610,
        0x100000000000000002e35f1582f3234ce, 0x100000000000000008f635c9bcb2eefe1,
        0x79a64775d37621de2372f3cb, 0xd3aa1d3b8418f14398df80f2, 0x2430232b1b17cb55, 0x0,
        0x895249ed4eaf972102b5c3f5, 0xd35f2675285d8568f81ef0d, 0x1fbd9931c3f2bbf8, 0x0,
        0x10000000000000000baf06a7a3e4aa015, 0x1000000000000000075adffb9c0d2b742,
        0x100000000000000006f45630d920758e7, 0x13bfcc5670fee7eb,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let sch_with_hints = Serde::<
        SchnorrSignatureWithHint,
    >::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_schnorr_signature_assuming_hash(sch_with_hints, public_key, 2);
    assert!(is_valid);
}


#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_schnorr_ED25519() {
    let mut sch_sig_with_hints_serialized = array![
        0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xfb9073291a58a0358e22e52, 0x76d4b9ec10a3a720b1096d5b, 0xad805c90a8c77b8, 0x0,
        0x82e4a33f8e4e5881e791d86b, 0xbcb062435ae8ec5fdaeac4bf, 0x179e1bae9e0f9f34, 0x0,
        0xa84dfdd6e617589384812f69a2d349c1, 0xa968f5c0a623e3b190de39304eb726a,
        0x12e0c8b2bad640fb19488dec4f65d4da, 0xa90f9c3af19922ad9b8a714e61a441c, 0x14,
        0x5cba1348511e21f20cd92c86, 0x63fd89d574978c8364a33dc6, 0x7a1a075dacc03bb1, 0x0,
        0xe16c3afd3bd9d2a736b5cb70, 0xd954e7aefbda0297b7855a5, 0x3285ce7a8018f502, 0x0,
        0x3315e27d27a210cb7baa18b5f3f0f9b3, 0x10f773711dcf75ce59993cf26c4f5ebf9,
        0xfbd811bae294558352d2ca8f, 0xc6b9c22af47b1e43d21ba644, 0x5c18972e38278425, 0x0,
        0x6a687b6263384a17569caeb3, 0x4166dd87f125393bd27679eb, 0x13a8e31e947075f3, 0x0,
        0x2ed8419cedf331ec3d387ed44220284f, 0xdbbf233e0f266b14c85329c2440c426,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let sch_with_hints = Serde::<
        SchnorrSignatureWithHint,
    >::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_schnorr_signature_assuming_hash(sch_with_hints, public_key, 4);
    assert!(is_valid);
}


#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_schnorr_GRUMPKIN() {
    let mut sch_sig_with_hints_serialized = array![
        0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x429af526e7e0a5381bccb180, 0x88f6dad23856d096b8b80e2e, 0x2684532513785230, 0x0,
        0x20669ef12954f8e3bbc8b4d3, 0x396a6f7243c27ce553121ee3, 0x11438ca2ec259aed, 0x0,
        0x7c7059f6158e689893dd21a94f41e410, 0x2454f3702220747f9b72cc1f2d34af71,
        0x12e0c8b2bad640fb19488dec4f65d4da, 0x1521f387af19922ad9b8a714e61a441c, 0x14,
        0x1619e977386f5b086cdc8857, 0x9ee9c3131ed8c4e6fb8d3b10, 0x2a23881e074bdeda, 0x0,
        0x783572bfbbe358723c90aaab, 0xf40d2176448bb22e9cbc031d, 0x2be35fe4dd3f44fb, 0x0,
        0x51cf7b3d0715b44af5d2f31cb1fd7677, 0x15838663fe7e8f8c16583cabb5df7308,
        0xa8fc937f9ebc90a8a9a2cf09, 0x6c2d666bea9386f60b1a46c2, 0x2244eddd508f6f81, 0x0,
        0x5ec6d01c41cedc947662556b, 0x4a7cb97d69bce744b75607b3, 0x2e39c1ad41f66954, 0x0,
        0x19ae1fd3832d250c6410c5e4cb759edf, 0x538cc4627274d8f320bf5df15c887356,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let sch_with_hints = Serde::<
        SchnorrSignatureWithHint,
    >::deserialize(ref sch_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_schnorr_signature_assuming_hash(sch_with_hints, public_key, 5);
    assert!(is_valid);
}

