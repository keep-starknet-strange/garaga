use garaga::core::circuit::u288IntoCircuitInputValue;
use garaga::definitions::G1Point;
use garaga::signatures::ecdsa::{ECDSASignatureWithHint, is_valid_ecdsa_signature_assuming_hash};

#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_ecdsa_BN254() {
    let mut ecdsa_sig_with_hints_serialized = array![
        0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0,
        0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0,
        0x236ca9312dad3661a37f2d6f, 0x98424c01caad7592315715d1, 0x795b9fd941b23c4, 0x0,
        0xbf6659a4013d8a0bc49c2bba0fe0b551, 0x2667e798582a362fb041cb7c36d149a8, 0x1,
        0xb4862b21fb97d43588561712e8e5216b, 0x967d0cae6f4590b9a164106cf6a659e, 0x18,
        0x1f553b3c905bf06693d39af3, 0x22a1bf1fdfb897a2e2368128, 0x56d66d1d4d06ac4, 0x0,
        0xf6482bdbc7401ca9a5730403, 0x75053f99e9420c530d43ee42, 0x1fe46da1cc905e5d, 0x0,
        0x1a59f6054bfb443f, 0x1000000000000000005d7679874156a92, 0xa19cd0d3b84ff34,
        0x4aae535488bc0171, 0xb2b487addb0999f4b7e26ef8, 0xab2d694c6f3e51b16518f05b,
        0x206ee9b43426de0b, 0x0, 0x43ad5aba55c006f840ef53f6, 0xd90cb92d61bdf082a563725f,
        0x28e0a95f5fae45b5, 0x0, 0xa0b063933d8e3f54, 0x1000000000000000003fc2ccc129935ee,
        0x1000000000000000030112506a6d6deff, 0x21d269100269048a,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let ecdsa_with_hints = Serde::<
        ECDSASignatureWithHint,
    >::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_ecdsa_signature_assuming_hash(ecdsa_with_hints, public_key, 0);
    assert!(is_valid);
}


#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_ecdsa_BLS12_381() {
    let mut ecdsa_sig_with_hints_serialized = array![
        0xe4f817e54aede0613c17035c, 0xdff1f15010392a6da1f95a6, 0xbed78d3d341e911d49f15454,
        0x18154782ce0913b21588066d, 0x3d77d61326ef5a9a5a681757, 0xd3070afd4f0e121de7fcee60,
        0xdf9ef4088763fe611fb85858, 0x11a612bdd0bc09562856a70, 0x867620dc5a8fd7ecbe07be76,
        0x11d338240a4de8ca41217d43, 0x2c7753c1707137bf, 0x0, 0x94796ffb457f39ac41d6612e5ce0a191,
        0x356631f83b3d990d4f60bada0d2ecc95, 0x1, 0xb4862b21fb97d43588561712e8e5216b,
        0x12cfa194e6f4590b9a164106cf6a659e, 0x18, 0x6c178cfd0b3cfa1cdc9611c2,
        0x2e2e9b5b3dc7495056fcb216, 0xdc6b710b9b8d6af1b0d9662f, 0x144281277c62ad45fcc361df,
        0xdd51112be4c794ba47bc61bb, 0xba737e0b6d17079da040afaf, 0x93d8c4b8589d2520cda8c68a,
        0x1492245eaba8fad13666bf8, 0x2da17082600f7add, 0x1cbcf87b9857ba44, 0x989a085f93dfee0,
        0x100000000000000002e5733515f6dc037, 0xcb7778677f6122a2ad987779, 0xf6d1d01660d142741ae0a2c9,
        0x5d1be8a4ebf8d22589f99a46, 0xbcaa099b6ef5b8ac192db47, 0xe6dd3401412576d3a894bcf2,
        0x2a839ac601bb4ed694e4724b, 0xa6ee37842198c02e8bc4074b, 0x107f65d9ec3f6a9587cfe814,
        0x4c5ccbf186df2adb, 0x100000000000000009289460599d5e6be,
        0x100000000000000003f0c985cb7645566, 0x396e116d375dd2dd,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let ecdsa_with_hints = Serde::<
        ECDSASignatureWithHint,
    >::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_ecdsa_signature_assuming_hash(ecdsa_with_hints, public_key, 1);
    assert!(is_valid);
}


#[test]
fn test_ecdsa_SECP256R1() {
    let mut ecdsa_sig_with_hints_serialized = array![
        0x113c8d620e3745e45e4389b8, 0x85b8ff52d905fd02fe191c3f, 0xf5d132d685201517, 0x0,
        0x60c0ba1b358f375b2362662e, 0x6abfc829d93e09aa5174ec04, 0x7bc4637aca93cb5a, 0x0,
        0x46ae31f6fc294ad0814552b6, 0x2d54cc811efaf988efb3de23, 0x2a2cc02b8f0c419f, 0x0,
        0x47e8f962616a171283a1176e90490f33, 0xde5c72ea3ea08688ab2876686671cca8, 0x1,
        0xeb1167b367a9c3787c65c1e582e2e663, 0xf7c1bd874da5e709d4713d60c8a70639, 0x14,
        0x286091616e02ba0069d28be8, 0x1d9745f8427b797bfae94bc9, 0xb3eb1f4823aa5b9f, 0x0,
        0xd955b1c2d5dbf2b7ce1f8cc0, 0xd9d9fdc9f4834421e0583e30, 0x8bab0f5e16efdcd5, 0x0,
        0xeae9da0724797b8c4deebd03881e0a93, 0x168a1a12c6aaa58209ea9db2a7f1a2b2f,
        0x94038dc6b682d83583f52251, 0x2c3509157e0085975bedd577, 0x1e00bb14af9e8bf8, 0x0,
        0x3017341aa1f59a0d17c013c5, 0x51583e6cc584e0a8145045aa, 0xb9220afd0e923820, 0x0,
        0xd0446b1605d4f3bfb5a82b168ba1b43, 0x1ab0f41000c73e671352e746066899a70,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let ecdsa_with_hints = Serde::<
        ECDSASignatureWithHint,
    >::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_ecdsa_signature_assuming_hash(ecdsa_with_hints, public_key, 3);
    assert!(is_valid);
}


#[test]
fn test_ecdsa_SECP256K1() {
    let mut ecdsa_sig_with_hints_serialized = array![
        0x393dead57bc85a6e9bb44a70, 0x64d4b065b3ede27cf9fb9e5c, 0xda670c8c69a8ce0a, 0x0,
        0x789872895ad7121175bd78f8, 0xc0deb0b56fb251e8fb5d0a8d, 0x3f10d670dc3297c2, 0x0,
        0x2965eeb3ec1fe786a6abe874, 0x33e2545f82bb6add02788b8e, 0xf586bc0db335d7b8, 0x0,
        0x6bb797837f385ccf8ea3b9b6e7074b68, 0x123ea74e335845008c7f5f797313610f, 0x0,
        0xeb1167b367a9c3787c65c1e582e2e663, 0xf7c1bd874da5e709d4713d60c8a70639, 0x18,
        0xed540ba7da3f81bbaa728909, 0x893eeca8c449fc9407668128, 0x4c72a831e28b48, 0x0,
        0xf7ae1bf4ac84c840ee8163eb, 0xfb80d24687ae79865523f56d, 0xebddaf8646d563b7, 0x0,
        0x5763a6a1517232b0, 0x100000000000000003fa616b9d1aa135b, 0x2ee3ef80f868d011,
        0x100000000000000003fe78eccc1da3303, 0x3baca0be7f388c0f13f91502, 0x279cead44672432f6083c7de,
        0x7b7ead3b5811d2dd, 0x0, 0x5bbc00623473536e653b34f3, 0xe4d94e156ddc62c1d41c68f4,
        0xe635b285558b642c, 0x0, 0x1000000000000000097e848fb19a47c06,
        0x100000000000000003dc81ff2129521cf, 0xdfac131bb3bb11de, 0xafc939cc6fed0eee,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let ecdsa_with_hints = Serde::<
        ECDSASignatureWithHint,
    >::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_ecdsa_signature_assuming_hash(ecdsa_with_hints, public_key, 2);
    assert!(is_valid);
}


#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_ecdsa_ED25519() {
    let mut ecdsa_sig_with_hints_serialized = array![
        0x7238f02b9f20e09c2181a557, 0x2cedcc5b0be371c337fd7e9e, 0x41f3bbeb280fe8a2, 0x0,
        0xf046f8cd6e5a75fca71dd19b, 0x892b4613ef5c58df4ef692a4, 0x7527fa36f5738847, 0x0,
        0xd4b581f1ee29a4dfba0aa2d4, 0xf18a70dbf1dc5a76494bff12, 0xac1b7bfc409119f, 0x0,
        0xd75af662c90a1cb06a531ce8992bfda2, 0x9c65af0ba668f70fb54682dc51dddb4, 0x1,
        0xb4862b21fb97d43588561712e8e5216b, 0x4b3e865e6f4590b9a164106cf6a659e, 0x14,
        0x8e4ebbfe9103ea220b651a02, 0x18ce985bbcad7e677405dafb, 0x69d6abb9648d50ad, 0x0,
        0xc1ce73f105e57f3a39f4ed13, 0xcd2f4939fe1a2abf2a689253, 0x34f18a43f7786d73, 0x0,
        0x28c38021207719b4c15ec8e3585a12b, 0x12f56bf5ab761b880d6d797751d76c911,
        0x378b92a7d8456bc43b2417e1, 0xca39a3a66b3713d3f07aa06c, 0x2aa069ab39cf3c36, 0x0,
        0x3d54f7790b6544e46aa424c4, 0x2fad442bf9ae38403e9616c2, 0xda201ff9acac7ac, 0x0,
        0xa9c80a21b193cc891541d32627df585, 0x113108f379dac95a41e3221331fd0f214,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let ecdsa_with_hints = Serde::<
        ECDSASignatureWithHint,
    >::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_ecdsa_signature_assuming_hash(ecdsa_with_hints, public_key, 4);
    assert!(is_valid);
}


#[test]
#[ignore] // Ignored for auto-benchmarks
fn test_ecdsa_GRUMPKIN() {
    let mut ecdsa_sig_with_hints_serialized = array![
        0x86b402ce02e7c7ca81f13d51, 0x39493672733a9289a36020c1, 0x7f40d91dc5413d3, 0x0,
        0x371e7b6a5c01505bd4334e81, 0x2f596ae4492a87c66f7bda1a, 0x9dffb4dcdb94df9, 0x0,
        0x3c26f4ff476ab777dc184776, 0xbccb2cba46cf421f11eb4d14, 0x27ec44064c727a3d, 0x0,
        0x4be0b43c26c6f414a5ea9ea34cff6d0c, 0x14d85887ecbe1e0c06e6a8310bf6d595, 0x0,
        0xb4862b21fb97d43588561712e8e5216b, 0x967d0cae6f4590b9a164106cf6a659e, 0x14,
        0xa92ff39dc786d18400f152fa, 0x20eafe86707668d52aa0d2, 0x6b08f8ea2e0d3ff, 0x0,
        0x7e5a501bb54172443d6608ac, 0xe03026c1fc3a1c6ead58dafd, 0xa6f4d2409778496, 0x0,
        0x5291f4cf1867b05ae7b1d1bbabfd2ac3, 0x26042d2cad5454bf11c7d3f813c42338,
        0x3b840ebf6e6c7b9ad848e269, 0xc10e351a38f60bd193db9784, 0x16a66333126cff05, 0x0,
        0x8f5f58884224366a4b4708a4, 0xee5fc2fc6e001cdb0584bd57, 0x1d311cc64e5601b2, 0x0,
        0xab7959b0b8b002ec27721af3d0ccf03, 0x357d7828010d521de3fe6fc9427ab043,
    ]
        .span();
    let public_key = Serde::<G1Point>::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializePk');
    let ecdsa_with_hints = Serde::<
        ECDSASignatureWithHint,
    >::deserialize(ref ecdsa_sig_with_hints_serialized)
        .expect('FailToDeserializeSig');
    let is_valid = is_valid_ecdsa_signature_assuming_hash(ecdsa_with_hints, public_key, 5);
    assert!(is_valid);
}

