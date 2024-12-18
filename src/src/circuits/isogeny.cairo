use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, circuit_add, circuit_sub, circuit_mul, circuit_inverse,
    EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait, CircuitModulus, AddInputResultTrait,
    CircuitInputs, CircuitDefinition, CircuitData, CircuitInputAccumulator,
};
use garaga::core::circuit::AddInputResultTrait2;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_a, get_b, get_modulus, get_g, get_min_one, G1Point, G2Point, E12D, u288, E12DMulQuotient,
    G1G2Pair, BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line, E12T,
    get_BLS12_381_modulus,
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;
#[inline(always)]
pub fn run_BLS12_381_APPLY_ISOGENY_BLS12_381_circuit(pt: G1Point) -> (G1Point,) {
    // CONSTANT stack
    let in0 = CE::<
        CI<0>,
    > {}; // 0x11a05f2b1e833340b809101dd99815856b303e88a2d7005ff2627b56cdb4e2c85610c2d5f2e62d6eaeac1662734649b7
    let in1 = CE::<
        CI<1>,
    > {}; // 0x17294ed3e943ab2f0588bab22147a81c7c17e75b2f6a8417f565e33c70d1e86b4838f2a6f318c356e834eef1b3cb83bb
    let in2 = CE::<
        CI<2>,
    > {}; // 0xd54005db97678ec1d1048c5d10a9a1bce032473295983e56878e501ec68e25c958c3e3d2a09729fe0179f9dac9edcb0
    let in3 = CE::<
        CI<3>,
    > {}; // 0x1778e7166fcc6db74e0609d307e55412d7f5e4656a8dbf25f1b33289f1b330835336e25ce3107193c5b388641d9b6861
    let in4 = CE::<
        CI<4>,
    > {}; // 0xe99726a3199f4436642b4b3e4118e5499db995a1257fb3f086eeb65982fac18985a286f301e77c451154ce9ac8895d9
    let in5 = CE::<
        CI<5>,
    > {}; // 0x1630c3250d7313ff01d1201bf7a74ab5db3cb17dd952799b9ed3ab9097e68f90a0870d2dcae73d19cd13c1c66f652983
    let in6 = CE::<
        CI<6>,
    > {}; // 0xd6ed6553fe44d296a3726c38ae652bfb11586264f0f8ce19008e218f9c86b2a8da25128c1052ecaddd7f225a139ed84
    let in7 = CE::<
        CI<7>,
    > {}; // 0x17b81e7701abdbe2e8743884d1117e53356de5ab275b4db1a682c62ef0f2753339b7c8f8c8f475af9ccb5618e3f0c88e
    let in8 = CE::<
        CI<8>,
    > {}; // 0x80d3cf1f9a78fc47b90b33563be990dc43b756ce79f5574a2c596c928c5d1de4fa295f296b74e956d71986a8497e317
    let in9 = CE::<
        CI<9>,
    > {}; // 0x169b1f8e1bcfa7c42e0c37515d138f22dd2ecb803a0c5c99676314baf4bb1b7fa3190b2edc0327797f241067be390c9e
    let in10 = CE::<
        CI<10>,
    > {}; // 0x10321da079ce07e272d8ec09d2565b0dfa7dccdde6787f96d50af36003b14866f69b771f8c285decca67df3f1605fb7b
    let in11 = CE::<
        CI<11>,
    > {}; // 0x6e08c248e260e70bd1e962381edee3d31d79d7e22c837bc23c0bf1bc24c6b68c24b1b80b64d391fa9c8ba2e8ba2d229
    let in12 = CE::<
        CI<12>,
    > {}; // 0x8ca8d548cff19ae18b2e62f4bd3fa6f01d5ef4ba35b48ba9c9588617fc8ac62b558d681be343df8993cf9fa40d21b1c
    let in13 = CE::<
        CI<13>,
    > {}; // 0x12561a5deb559c4348b4711298e536367041e8ca0cf0800c0126c2588c48bf5713daa8846cb026e9e5c8276ec82b3bff
    let in14 = CE::<
        CI<14>,
    > {}; // 0xb2962fe57a3225e8137e629bff2991f6f89416f5a718cd1fca64e00b11aceacd6a3d0967c94fedcfcc239ba5cb83e19
    let in15 = CE::<
        CI<15>,
    > {}; // 0x3425581a58ae2fec83aafef7c40eb545b08243f16b1655154cca8abc28d6fd04976d5243eecf5c4130de8938dc62cd8
    let in16 = CE::<
        CI<16>,
    > {}; // 0x13a8e162022914a80a6f1d5f43e7a07dffdfc759a12062bb8d6b44e833b306da9bd29ba81f35781d539d395b3532a21e
    let in17 = CE::<
        CI<17>,
    > {}; // 0xe7355f8e4e667b955390f7f0506c6e9395735e9ce9cad4d0a43bcef24b8982f7400d24bc4228f11c02df9a29f6304a5
    let in18 = CE::<
        CI<18>,
    > {}; // 0x772caacf16936190f3e0c63e0596721570f5799af53a1894e2e073062aede9cea73b3538f0de06cec2574496ee84a3a
    let in19 = CE::<
        CI<19>,
    > {}; // 0x14a7ac2a9d64a8b230b3f5b074cf01996e7f63c21bca68a81996e1cdf9822c580fa5b9489d11e2d311f7d99bbdcc5a5e
    let in20 = CE::<
        CI<20>,
    > {}; // 0xa10ecf6ada54f825e920b3dafc7a3cce07f8d1d7161366b74100da67f39883503826692abba43704776ec3a79a1d641
    let in21 = CE::<
        CI<21>,
    > {}; // 0x95fc13ab9e92ad4476d6e3eb3a56680f682b4ee96f7d03776df533978f31c1593174e4b4b7865002d6384d168ecdd0a
    let in22 = CE::<CI<22>> {}; // 0x1
    let in23 = CE::<
        CI<23>,
    > {}; // 0x90d97c81ba24ee0259d1f094980dcfa11ad138e48a869522b52af6c956543d3cd0c7aee9b3ba3c2be9845719707bb33
    let in24 = CE::<
        CI<24>,
    > {}; // 0x134996a104ee5811d51036d776fb46831223e96c254f383d0f906343eb67ad34d6c56711962fa8bfe097e75a2e41c696
    let in25 = CE::<
        CI<25>,
    > {}; // 0xcc786baa966e66f4a384c86a3b49942552e2d658a31ce2c344be4b91400da7d26d521628b00523b8dfe240c72de1f6
    let in26 = CE::<
        CI<26>,
    > {}; // 0x1f86376e8981c217898751ad8746757d42aa7b90eeb791c09e4a3ec03251cf9de405aba9ec61deca6355c77b0e5f4cb
    let in27 = CE::<
        CI<27>,
    > {}; // 0x8cc03fdefe0ff135caf4fe2a21529c4195536fbe3ce50b879833fd221351adc2ee7f8dc099040a841b6daecf2e8fedb
    let in28 = CE::<
        CI<28>,
    > {}; // 0x16603fca40634b6a2211e11db8f0a6a074a7d0d4afadb7bd76505c3d3ad5544e203f6326c95a807299b23ab13633a5f0
    let in29 = CE::<
        CI<29>,
    > {}; // 0x4ab0b9bcfac1bbcb2c977d027796b3ce75bb8ca2be184cb5231413c4d634f3747a87ac2460f415ec961f8855fe9d6f2
    let in30 = CE::<
        CI<30>,
    > {}; // 0x987c8d5333ab86fde9926bd2ca6c674170a05bfe3bdd81ffd038da6c26c842642f64550fedfe935a15e4ca31870fb29
    let in31 = CE::<
        CI<31>,
    > {}; // 0x9fc4018bd96684be88c9e221e4da1bb8f3abd16679dc26c1e8b6e6a1f20cabe69d65201c78607a360370e577bdba587
    let in32 = CE::<
        CI<32>,
    > {}; // 0xe1bba7a1186bdb5223abde7ada14a23c42a0ca7915af6fe06985e7ed1e4d43b9b3f7055dd4eba6f2bafaaebca731c30
    let in33 = CE::<
        CI<33>,
    > {}; // 0x19713e47937cd1be0dfd0b8f1d43fb93cd2fcbcb6caf493fd1183e416389e61031bf3a5cce3fbafce813711ad011c132
    let in34 = CE::<
        CI<34>,
    > {}; // 0x18b46a908f36f6deb918c143fed2edcc523559b8aaf0c2462e6bfe7f911f643249d9cdf41b44d606ce07c8a4d0074d8e
    let in35 = CE::<
        CI<35>,
    > {}; // 0xb182cac101b9399d155096004f53f447aa7b12a3426b08ec02710e807b4633f06c851c1919211f20d4c04f00b971ef8
    let in36 = CE::<
        CI<36>,
    > {}; // 0x245a394ad1eca9b72fc00ae7be315dc757b3b080d4c158013e6632d3c40659cc6cf90ad1c232a6442d9d3f5db980133
    let in37 = CE::<
        CI<37>,
    > {}; // 0x5c129645e44cf1102a159f748c4a3fc5e673d81d7e86568d9ab0f5d396a7ce46ba1049b6579afb7866b1e715475224b
    let in38 = CE::<
        CI<38>,
    > {}; // 0x15e6be4e990f03ce4ea50b3b42df2eb5cb181d8f84965a3957add4fa95af01b2b665027efec01c7704b456be69c8b604
    let in39 = CE::<
        CI<39>,
    > {}; // 0x16112c4c3a9c98b252181140fad0eae9601a6de578980be6eec3232b5be72e7a07f3688ef60c206d01479253b03663c1
    let in40 = CE::<
        CI<40>,
    > {}; // 0x1962d75c2381201e1a0cbd6c43c348b885c84ff731c4d59ca4a10356f453e01f78a4260763529e3532f6102c2e49a03d
    let in41 = CE::<
        CI<41>,
    > {}; // 0x58df3306640da276faaae7d6e8eb15778c4855551ae7f310c35a5dd279cd2eca6757cd636f96f891e2538b53dbf67f2
    let in42 = CE::<
        CI<42>,
    > {}; // 0x16b7d288798e5395f20d23bf89edb4d1d115c5dbddbcd30e123da489e726af41727364f2c28297ada8d26d98445f5416
    let in43 = CE::<
        CI<43>,
    > {}; // 0xbe0e079545f43e4b00cc912f8228ddcc6d19c9f0f69bbb0542eda0fc9dec916a20b15dc0fd2ededda39142311a5001d
    let in44 = CE::<
        CI<44>,
    > {}; // 0x8d9e5297186db2d9fb266eaac783182b70152c65550d881c5ecd87b6f0f5a6449f38db9dfa9cce202c6477faaf9b7ac
    let in45 = CE::<
        CI<45>,
    > {}; // 0x166007c08a99db2fc3ba8734ace9824b5eecfdfa8d0cf8ef5dd365bc400a0051d5fa9c01a58b1fb93d1a1399126a775c
    let in46 = CE::<
        CI<46>,
    > {}; // 0x16a3ef08be3ea7ea03bcddfabba6ff6ee5a4375efa1f4fd7feb34fd206357132b920f5b00801dee460ee415a15812ed9
    let in47 = CE::<
        CI<47>,
    > {}; // 0x1866c8ed336c61231a1be54fd1d74cc4f9fb0ce4c6af5920abc5750c4bf39b4852cfe2f7bb9248836b233d9d55535d4a
    let in48 = CE::<
        CI<48>,
    > {}; // 0x167a55cda70a6e1cea820597d94a84903216f763e13d87bb5308592e7ea7d4fbc7385ea3d529b35e346ef48bb8913f55
    let in49 = CE::<
        CI<49>,
    > {}; // 0x4d2f259eea405bd48f010a01ad2911d9c6dd039bb61a6290e591b36e636a5c871a5c29f4f83060400f8b49cba8f6aa8
    let in50 = CE::<
        CI<50>,
    > {}; // 0xaccbb67481d033ff5852c1e48c50c477f94ff8aefce42d28c0f9a88cea7913516f968986f7ebbea9684b529e2561092
    let in51 = CE::<
        CI<51>,
    > {}; // 0xad6b9514c767fe3c3613144b45f1496543346d98adf02267d5ceef9a00d9b8693000763e3b90ac11e99b138573345cc
    let in52 = CE::<
        CI<52>,
    > {}; // 0x2660400eb2e4f3b628bdd0d53cd76f2bf565b94e72927c1cb748df27942480e420517bd8714cc80d1fadc1326ed06f7
    let in53 = CE::<
        CI<53>,
    > {}; // 0xe0fa1d816ddc03e6b24255e0d7819c171c40f65e273b853324efcd6356caa205ca2f570f13497804415473a1d634b8f

    // INPUT stack
    let (in54, in55) = (CE::<CI<54>> {}, CE::<CI<55>> {});
    let t0 = circuit_mul(in11, in54); // Eval x_num Horner step: multiply by z
    let t1 = circuit_add(in10, t0); // Eval x_num Horner step: add coefficient_10
    let t2 = circuit_mul(t1, in54); // Eval x_num Horner step: multiply by z
    let t3 = circuit_add(in9, t2); // Eval x_num Horner step: add coefficient_9
    let t4 = circuit_mul(t3, in54); // Eval x_num Horner step: multiply by z
    let t5 = circuit_add(in8, t4); // Eval x_num Horner step: add coefficient_8
    let t6 = circuit_mul(t5, in54); // Eval x_num Horner step: multiply by z
    let t7 = circuit_add(in7, t6); // Eval x_num Horner step: add coefficient_7
    let t8 = circuit_mul(t7, in54); // Eval x_num Horner step: multiply by z
    let t9 = circuit_add(in6, t8); // Eval x_num Horner step: add coefficient_6
    let t10 = circuit_mul(t9, in54); // Eval x_num Horner step: multiply by z
    let t11 = circuit_add(in5, t10); // Eval x_num Horner step: add coefficient_5
    let t12 = circuit_mul(t11, in54); // Eval x_num Horner step: multiply by z
    let t13 = circuit_add(in4, t12); // Eval x_num Horner step: add coefficient_4
    let t14 = circuit_mul(t13, in54); // Eval x_num Horner step: multiply by z
    let t15 = circuit_add(in3, t14); // Eval x_num Horner step: add coefficient_3
    let t16 = circuit_mul(t15, in54); // Eval x_num Horner step: multiply by z
    let t17 = circuit_add(in2, t16); // Eval x_num Horner step: add coefficient_2
    let t18 = circuit_mul(t17, in54); // Eval x_num Horner step: multiply by z
    let t19 = circuit_add(in1, t18); // Eval x_num Horner step: add coefficient_1
    let t20 = circuit_mul(t19, in54); // Eval x_num Horner step: multiply by z
    let t21 = circuit_add(in0, t20); // Eval x_num Horner step: add coefficient_0
    let t22 = circuit_mul(in22, in54); // Eval x_den Horner step: multiply by z
    let t23 = circuit_add(in21, t22); // Eval x_den Horner step: add coefficient_9
    let t24 = circuit_mul(t23, in54); // Eval x_den Horner step: multiply by z
    let t25 = circuit_add(in20, t24); // Eval x_den Horner step: add coefficient_8
    let t26 = circuit_mul(t25, in54); // Eval x_den Horner step: multiply by z
    let t27 = circuit_add(in19, t26); // Eval x_den Horner step: add coefficient_7
    let t28 = circuit_mul(t27, in54); // Eval x_den Horner step: multiply by z
    let t29 = circuit_add(in18, t28); // Eval x_den Horner step: add coefficient_6
    let t30 = circuit_mul(t29, in54); // Eval x_den Horner step: multiply by z
    let t31 = circuit_add(in17, t30); // Eval x_den Horner step: add coefficient_5
    let t32 = circuit_mul(t31, in54); // Eval x_den Horner step: multiply by z
    let t33 = circuit_add(in16, t32); // Eval x_den Horner step: add coefficient_4
    let t34 = circuit_mul(t33, in54); // Eval x_den Horner step: multiply by z
    let t35 = circuit_add(in15, t34); // Eval x_den Horner step: add coefficient_3
    let t36 = circuit_mul(t35, in54); // Eval x_den Horner step: multiply by z
    let t37 = circuit_add(in14, t36); // Eval x_den Horner step: add coefficient_2
    let t38 = circuit_mul(t37, in54); // Eval x_den Horner step: multiply by z
    let t39 = circuit_add(in13, t38); // Eval x_den Horner step: add coefficient_1
    let t40 = circuit_mul(t39, in54); // Eval x_den Horner step: multiply by z
    let t41 = circuit_add(in12, t40); // Eval x_den Horner step: add coefficient_0
    let t42 = circuit_inverse(t41);
    let t43 = circuit_mul(t21, t42);
    let t44 = circuit_mul(in38, in54); // Eval y_num Horner step: multiply by z
    let t45 = circuit_add(in37, t44); // Eval y_num Horner step: add coefficient_14
    let t46 = circuit_mul(t45, in54); // Eval y_num Horner step: multiply by z
    let t47 = circuit_add(in36, t46); // Eval y_num Horner step: add coefficient_13
    let t48 = circuit_mul(t47, in54); // Eval y_num Horner step: multiply by z
    let t49 = circuit_add(in35, t48); // Eval y_num Horner step: add coefficient_12
    let t50 = circuit_mul(t49, in54); // Eval y_num Horner step: multiply by z
    let t51 = circuit_add(in34, t50); // Eval y_num Horner step: add coefficient_11
    let t52 = circuit_mul(t51, in54); // Eval y_num Horner step: multiply by z
    let t53 = circuit_add(in33, t52); // Eval y_num Horner step: add coefficient_10
    let t54 = circuit_mul(t53, in54); // Eval y_num Horner step: multiply by z
    let t55 = circuit_add(in32, t54); // Eval y_num Horner step: add coefficient_9
    let t56 = circuit_mul(t55, in54); // Eval y_num Horner step: multiply by z
    let t57 = circuit_add(in31, t56); // Eval y_num Horner step: add coefficient_8
    let t58 = circuit_mul(t57, in54); // Eval y_num Horner step: multiply by z
    let t59 = circuit_add(in30, t58); // Eval y_num Horner step: add coefficient_7
    let t60 = circuit_mul(t59, in54); // Eval y_num Horner step: multiply by z
    let t61 = circuit_add(in29, t60); // Eval y_num Horner step: add coefficient_6
    let t62 = circuit_mul(t61, in54); // Eval y_num Horner step: multiply by z
    let t63 = circuit_add(in28, t62); // Eval y_num Horner step: add coefficient_5
    let t64 = circuit_mul(t63, in54); // Eval y_num Horner step: multiply by z
    let t65 = circuit_add(in27, t64); // Eval y_num Horner step: add coefficient_4
    let t66 = circuit_mul(t65, in54); // Eval y_num Horner step: multiply by z
    let t67 = circuit_add(in26, t66); // Eval y_num Horner step: add coefficient_3
    let t68 = circuit_mul(t67, in54); // Eval y_num Horner step: multiply by z
    let t69 = circuit_add(in25, t68); // Eval y_num Horner step: add coefficient_2
    let t70 = circuit_mul(t69, in54); // Eval y_num Horner step: multiply by z
    let t71 = circuit_add(in24, t70); // Eval y_num Horner step: add coefficient_1
    let t72 = circuit_mul(t71, in54); // Eval y_num Horner step: multiply by z
    let t73 = circuit_add(in23, t72); // Eval y_num Horner step: add coefficient_0
    let t74 = circuit_mul(in22, in54); // Eval y_den Horner step: multiply by z
    let t75 = circuit_add(in53, t74); // Eval y_den Horner step: add coefficient_14
    let t76 = circuit_mul(t75, in54); // Eval y_den Horner step: multiply by z
    let t77 = circuit_add(in52, t76); // Eval y_den Horner step: add coefficient_13
    let t78 = circuit_mul(t77, in54); // Eval y_den Horner step: multiply by z
    let t79 = circuit_add(in51, t78); // Eval y_den Horner step: add coefficient_12
    let t80 = circuit_mul(t79, in54); // Eval y_den Horner step: multiply by z
    let t81 = circuit_add(in50, t80); // Eval y_den Horner step: add coefficient_11
    let t82 = circuit_mul(t81, in54); // Eval y_den Horner step: multiply by z
    let t83 = circuit_add(in49, t82); // Eval y_den Horner step: add coefficient_10
    let t84 = circuit_mul(t83, in54); // Eval y_den Horner step: multiply by z
    let t85 = circuit_add(in48, t84); // Eval y_den Horner step: add coefficient_9
    let t86 = circuit_mul(t85, in54); // Eval y_den Horner step: multiply by z
    let t87 = circuit_add(in47, t86); // Eval y_den Horner step: add coefficient_8
    let t88 = circuit_mul(t87, in54); // Eval y_den Horner step: multiply by z
    let t89 = circuit_add(in46, t88); // Eval y_den Horner step: add coefficient_7
    let t90 = circuit_mul(t89, in54); // Eval y_den Horner step: multiply by z
    let t91 = circuit_add(in45, t90); // Eval y_den Horner step: add coefficient_6
    let t92 = circuit_mul(t91, in54); // Eval y_den Horner step: multiply by z
    let t93 = circuit_add(in44, t92); // Eval y_den Horner step: add coefficient_5
    let t94 = circuit_mul(t93, in54); // Eval y_den Horner step: multiply by z
    let t95 = circuit_add(in43, t94); // Eval y_den Horner step: add coefficient_4
    let t96 = circuit_mul(t95, in54); // Eval y_den Horner step: multiply by z
    let t97 = circuit_add(in42, t96); // Eval y_den Horner step: add coefficient_3
    let t98 = circuit_mul(t97, in54); // Eval y_den Horner step: multiply by z
    let t99 = circuit_add(in41, t98); // Eval y_den Horner step: add coefficient_2
    let t100 = circuit_mul(t99, in54); // Eval y_den Horner step: multiply by z
    let t101 = circuit_add(in40, t100); // Eval y_den Horner step: add coefficient_1
    let t102 = circuit_mul(t101, in54); // Eval y_den Horner step: multiply by z
    let t103 = circuit_add(in39, t102); // Eval y_den Horner step: add coefficient_0
    let t104 = circuit_inverse(t103);
    let t105 = circuit_mul(t73, t104);
    let t106 = circuit_mul(t105, in55);

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t43, t106).new_inputs();
    // Prefill constants:

    circuit_inputs = circuit_inputs
        .next_span(APPLY_ISOGENY_BLS12_381_BLS12_381_CONSTANTS.span()); // in0 - in53

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(pt.x); // in54
    circuit_inputs = circuit_inputs.next_2(pt.y); // in55

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: G1Point = G1Point { x: outputs.get_output(t43), y: outputs.get_output(t106) };
    return (res,);
}
const APPLY_ISOGENY_BLS12_381_BLS12_381_CONSTANTS: [u384; 54] = [
    u384 {
        limb0: 0xf2e62d6eaeac1662734649b7,
        limb1: 0xf2627b56cdb4e2c85610c2d5,
        limb2: 0xd99815856b303e88a2d7005f,
        limb3: 0x11a05f2b1e833340b809101d,
    },
    u384 {
        limb0: 0xf318c356e834eef1b3cb83bb,
        limb1: 0xf565e33c70d1e86b4838f2a6,
        limb2: 0x2147a81c7c17e75b2f6a8417,
        limb3: 0x17294ed3e943ab2f0588bab2,
    },
    u384 {
        limb0: 0x2a09729fe0179f9dac9edcb0,
        limb1: 0x6878e501ec68e25c958c3e3d,
        limb2: 0xd10a9a1bce032473295983e5,
        limb3: 0xd54005db97678ec1d1048c5,
    },
    u384 {
        limb0: 0xe3107193c5b388641d9b6861,
        limb1: 0xf1b33289f1b330835336e25c,
        limb2: 0x7e55412d7f5e4656a8dbf25,
        limb3: 0x1778e7166fcc6db74e0609d3,
    },
    u384 {
        limb0: 0x301e77c451154ce9ac8895d9,
        limb1: 0x86eeb65982fac18985a286f,
        limb2: 0xe4118e5499db995a1257fb3f,
        limb3: 0xe99726a3199f4436642b4b3,
    },
    u384 {
        limb0: 0xcae73d19cd13c1c66f652983,
        limb1: 0x9ed3ab9097e68f90a0870d2d,
        limb2: 0xf7a74ab5db3cb17dd952799b,
        limb3: 0x1630c3250d7313ff01d1201b,
    },
    u384 {
        limb0: 0xc1052ecaddd7f225a139ed84,
        limb1: 0x9008e218f9c86b2a8da25128,
        limb2: 0x8ae652bfb11586264f0f8ce1,
        limb3: 0xd6ed6553fe44d296a3726c3,
    },
    u384 {
        limb0: 0xc8f475af9ccb5618e3f0c88e,
        limb1: 0xa682c62ef0f2753339b7c8f8,
        limb2: 0xd1117e53356de5ab275b4db1,
        limb3: 0x17b81e7701abdbe2e8743884,
    },
    u384 {
        limb0: 0x96b74e956d71986a8497e317,
        limb1: 0xa2c596c928c5d1de4fa295f2,
        limb2: 0x63be990dc43b756ce79f5574,
        limb3: 0x80d3cf1f9a78fc47b90b335,
    },
    u384 {
        limb0: 0xdc0327797f241067be390c9e,
        limb1: 0x676314baf4bb1b7fa3190b2e,
        limb2: 0x5d138f22dd2ecb803a0c5c99,
        limb3: 0x169b1f8e1bcfa7c42e0c3751,
    },
    u384 {
        limb0: 0x8c285decca67df3f1605fb7b,
        limb1: 0xd50af36003b14866f69b771f,
        limb2: 0xd2565b0dfa7dccdde6787f96,
        limb3: 0x10321da079ce07e272d8ec09,
    },
    u384 {
        limb0: 0xb64d391fa9c8ba2e8ba2d229,
        limb1: 0x23c0bf1bc24c6b68c24b1b80,
        limb2: 0x81edee3d31d79d7e22c837bc,
        limb3: 0x6e08c248e260e70bd1e9623,
    },
    u384 {
        limb0: 0xbe343df8993cf9fa40d21b1c,
        limb1: 0x9c9588617fc8ac62b558d681,
        limb2: 0x4bd3fa6f01d5ef4ba35b48ba,
        limb3: 0x8ca8d548cff19ae18b2e62f,
    },
    u384 {
        limb0: 0x6cb026e9e5c8276ec82b3bff,
        limb1: 0x126c2588c48bf5713daa884,
        limb2: 0x98e536367041e8ca0cf0800c,
        limb3: 0x12561a5deb559c4348b47112,
    },
    u384 {
        limb0: 0x7c94fedcfcc239ba5cb83e19,
        limb1: 0xfca64e00b11aceacd6a3d096,
        limb2: 0xbff2991f6f89416f5a718cd1,
        limb3: 0xb2962fe57a3225e8137e629,
    },
    u384 {
        limb0: 0x3eecf5c4130de8938dc62cd8,
        limb1: 0x54cca8abc28d6fd04976d524,
        limb2: 0x7c40eb545b08243f16b16551,
        limb3: 0x3425581a58ae2fec83aafef,
    },
    u384 {
        limb0: 0x1f35781d539d395b3532a21e,
        limb1: 0x8d6b44e833b306da9bd29ba8,
        limb2: 0x43e7a07dffdfc759a12062bb,
        limb3: 0x13a8e162022914a80a6f1d5f,
    },
    u384 {
        limb0: 0xc4228f11c02df9a29f6304a5,
        limb1: 0xa43bcef24b8982f7400d24b,
        limb2: 0x506c6e9395735e9ce9cad4d,
        limb3: 0xe7355f8e4e667b955390f7f,
    },
    u384 {
        limb0: 0x8f0de06cec2574496ee84a3a,
        limb1: 0x4e2e073062aede9cea73b353,
        limb2: 0xe0596721570f5799af53a189,
        limb3: 0x772caacf16936190f3e0c63,
    },
    u384 {
        limb0: 0x9d11e2d311f7d99bbdcc5a5e,
        limb1: 0x1996e1cdf9822c580fa5b948,
        limb2: 0x74cf01996e7f63c21bca68a8,
        limb3: 0x14a7ac2a9d64a8b230b3f5b0,
    },
    u384 {
        limb0: 0xabba43704776ec3a79a1d641,
        limb1: 0x74100da67f39883503826692,
        limb2: 0xafc7a3cce07f8d1d7161366b,
        limb3: 0xa10ecf6ada54f825e920b3d,
    },
    u384 {
        limb0: 0x4b7865002d6384d168ecdd0a,
        limb1: 0x76df533978f31c1593174e4b,
        limb2: 0xb3a56680f682b4ee96f7d037,
        limb3: 0x95fc13ab9e92ad4476d6e3e,
    },
    u384 { limb0: 0x1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    u384 {
        limb0: 0x9b3ba3c2be9845719707bb33,
        limb1: 0x2b52af6c956543d3cd0c7aee,
        limb2: 0x4980dcfa11ad138e48a86952,
        limb3: 0x90d97c81ba24ee0259d1f09,
    },
    u384 {
        limb0: 0x962fa8bfe097e75a2e41c696,
        limb1: 0xf906343eb67ad34d6c56711,
        limb2: 0x76fb46831223e96c254f383d,
        limb3: 0x134996a104ee5811d51036d7,
    },
    u384 {
        limb0: 0x28b00523b8dfe240c72de1f6,
        limb1: 0xc344be4b91400da7d26d5216,
        limb2: 0x6a3b49942552e2d658a31ce2,
        limb3: 0xcc786baa966e66f4a384c8,
    },
    u384 {
        limb0: 0x9ec61deca6355c77b0e5f4cb,
        limb1: 0x9e4a3ec03251cf9de405aba,
        limb2: 0xd8746757d42aa7b90eeb791c,
        limb3: 0x1f86376e8981c217898751a,
    },
    u384 {
        limb0: 0x99040a841b6daecf2e8fedb,
        limb1: 0x79833fd221351adc2ee7f8dc,
        limb2: 0xa21529c4195536fbe3ce50b8,
        limb3: 0x8cc03fdefe0ff135caf4fe2,
    },
    u384 {
        limb0: 0xc95a807299b23ab13633a5f0,
        limb1: 0x76505c3d3ad5544e203f6326,
        limb2: 0xb8f0a6a074a7d0d4afadb7bd,
        limb3: 0x16603fca40634b6a2211e11d,
    },
    u384 {
        limb0: 0x460f415ec961f8855fe9d6f2,
        limb1: 0x5231413c4d634f3747a87ac2,
        limb2: 0x27796b3ce75bb8ca2be184cb,
        limb3: 0x4ab0b9bcfac1bbcb2c977d0,
    },
    u384 {
        limb0: 0xfedfe935a15e4ca31870fb29,
        limb1: 0xfd038da6c26c842642f64550,
        limb2: 0x2ca6c674170a05bfe3bdd81f,
        limb3: 0x987c8d5333ab86fde9926bd,
    },
    u384 {
        limb0: 0xc78607a360370e577bdba587,
        limb1: 0x1e8b6e6a1f20cabe69d65201,
        limb2: 0x1e4da1bb8f3abd16679dc26c,
        limb3: 0x9fc4018bd96684be88c9e22,
    },
    u384 {
        limb0: 0xdd4eba6f2bafaaebca731c30,
        limb1: 0x6985e7ed1e4d43b9b3f7055,
        limb2: 0xada14a23c42a0ca7915af6fe,
        limb3: 0xe1bba7a1186bdb5223abde7,
    },
    u384 {
        limb0: 0xce3fbafce813711ad011c132,
        limb1: 0xd1183e416389e61031bf3a5c,
        limb2: 0x1d43fb93cd2fcbcb6caf493f,
        limb3: 0x19713e47937cd1be0dfd0b8f,
    },
    u384 {
        limb0: 0x1b44d606ce07c8a4d0074d8e,
        limb1: 0x2e6bfe7f911f643249d9cdf4,
        limb2: 0xfed2edcc523559b8aaf0c246,
        limb3: 0x18b46a908f36f6deb918c143,
    },
    u384 {
        limb0: 0x919211f20d4c04f00b971ef8,
        limb1: 0xc02710e807b4633f06c851c1,
        limb2: 0x4f53f447aa7b12a3426b08e,
        limb3: 0xb182cac101b9399d1550960,
    },
    u384 {
        limb0: 0x1c232a6442d9d3f5db980133,
        limb1: 0x13e6632d3c40659cc6cf90ad,
        limb2: 0x7be315dc757b3b080d4c1580,
        limb3: 0x245a394ad1eca9b72fc00ae,
    },
    u384 {
        limb0: 0x6579afb7866b1e715475224b,
        limb1: 0xd9ab0f5d396a7ce46ba1049b,
        limb2: 0x48c4a3fc5e673d81d7e86568,
        limb3: 0x5c129645e44cf1102a159f7,
    },
    u384 {
        limb0: 0xfec01c7704b456be69c8b604,
        limb1: 0x57add4fa95af01b2b665027e,
        limb2: 0x42df2eb5cb181d8f84965a39,
        limb3: 0x15e6be4e990f03ce4ea50b3b,
    },
    u384 {
        limb0: 0xf60c206d01479253b03663c1,
        limb1: 0xeec3232b5be72e7a07f3688e,
        limb2: 0xfad0eae9601a6de578980be6,
        limb3: 0x16112c4c3a9c98b252181140,
    },
    u384 {
        limb0: 0x63529e3532f6102c2e49a03d,
        limb1: 0xa4a10356f453e01f78a42607,
        limb2: 0x43c348b885c84ff731c4d59c,
        limb3: 0x1962d75c2381201e1a0cbd6c,
    },
    u384 {
        limb0: 0x36f96f891e2538b53dbf67f2,
        limb1: 0xc35a5dd279cd2eca6757cd6,
        limb2: 0x6e8eb15778c4855551ae7f31,
        limb3: 0x58df3306640da276faaae7d,
    },
    u384 {
        limb0: 0xc28297ada8d26d98445f5416,
        limb1: 0x123da489e726af41727364f2,
        limb2: 0x89edb4d1d115c5dbddbcd30e,
        limb3: 0x16b7d288798e5395f20d23bf,
    },
    u384 {
        limb0: 0xfd2ededda39142311a5001d,
        limb1: 0x542eda0fc9dec916a20b15dc,
        limb2: 0xf8228ddcc6d19c9f0f69bbb0,
        limb3: 0xbe0e079545f43e4b00cc912,
    },
    u384 {
        limb0: 0xdfa9cce202c6477faaf9b7ac,
        limb1: 0xc5ecd87b6f0f5a6449f38db9,
        limb2: 0xac783182b70152c65550d881,
        limb3: 0x8d9e5297186db2d9fb266ea,
    },
    u384 {
        limb0: 0xa58b1fb93d1a1399126a775c,
        limb1: 0x5dd365bc400a0051d5fa9c01,
        limb2: 0xace9824b5eecfdfa8d0cf8ef,
        limb3: 0x166007c08a99db2fc3ba8734,
    },
    u384 {
        limb0: 0x801dee460ee415a15812ed9,
        limb1: 0xfeb34fd206357132b920f5b0,
        limb2: 0xbba6ff6ee5a4375efa1f4fd7,
        limb3: 0x16a3ef08be3ea7ea03bcddfa,
    },
    u384 {
        limb0: 0xbb9248836b233d9d55535d4a,
        limb1: 0xabc5750c4bf39b4852cfe2f7,
        limb2: 0xd1d74cc4f9fb0ce4c6af5920,
        limb3: 0x1866c8ed336c61231a1be54f,
    },
    u384 {
        limb0: 0xd529b35e346ef48bb8913f55,
        limb1: 0x5308592e7ea7d4fbc7385ea3,
        limb2: 0xd94a84903216f763e13d87bb,
        limb3: 0x167a55cda70a6e1cea820597,
    },
    u384 {
        limb0: 0x4f83060400f8b49cba8f6aa8,
        limb1: 0xe591b36e636a5c871a5c29f,
        limb2: 0x1ad2911d9c6dd039bb61a629,
        limb3: 0x4d2f259eea405bd48f010a0,
    },
    u384 {
        limb0: 0x6f7ebbea9684b529e2561092,
        limb1: 0x8c0f9a88cea7913516f96898,
        limb2: 0x48c50c477f94ff8aefce42d2,
        limb3: 0xaccbb67481d033ff5852c1e,
    },
    u384 {
        limb0: 0xe3b90ac11e99b138573345cc,
        limb1: 0x7d5ceef9a00d9b8693000763,
        limb2: 0xb45f1496543346d98adf0226,
        limb3: 0xad6b9514c767fe3c3613144,
    },
    u384 {
        limb0: 0x8714cc80d1fadc1326ed06f7,
        limb1: 0xcb748df27942480e420517bd,
        limb2: 0x53cd76f2bf565b94e72927c1,
        limb3: 0x2660400eb2e4f3b628bdd0d,
    },
    u384 {
        limb0: 0xf13497804415473a1d634b8f,
        limb1: 0x324efcd6356caa205ca2f570,
        limb2: 0xd7819c171c40f65e273b853,
        limb3: 0xe0fa1d816ddc03e6b24255e,
    },
];

#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs,
    };
    use garaga::definitions::{
        G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair, BNProcessedPair, BLSProcessedPair,
        MillerLoopResultScalingFactor, G2Line,
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

    use super::{run_BLS12_381_APPLY_ISOGENY_BLS12_381_circuit};
}
