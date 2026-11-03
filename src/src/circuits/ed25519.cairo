use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, circuit_add, circuit_inverse,
    circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{
    AddInputResultTrait2, CircuitOutputsTrait, EvalCircuitTrait, u288IntoCircuitInputValue,
};

#[inline(always)]
pub fn run_ED25519_FINISH_circuit(e: u384, wp: u384, w: u384, sign: u384) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x2406d9dc56dffce7198e80f2eef3d13000e0149a8283b156ebd69b9426b2f157
    let in1 = CE::<CI<1>> {}; // 0x3ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7
    let in2 = CE::<CI<2>> {}; // 0x570649009f83be16569a01327bf7af4e5e86300d5a5fc8f189dc364e941d4160

    // INPUT stack
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let in6 = CE::<CI<6>> {};
    let t0 = circuit_mul(in5, in5);
    let t1 = circuit_mul(in3, in3);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_sub(t0, t2);
    let t4 = circuit_mul(in5, in4);
    let t5 = circuit_sub(t3, t4);
    let t6 = circuit_mul(t5, in1);
    let t7 = circuit_mul(in6, in5);
    let t8 = circuit_mul(in2, in3);
    let t9 = circuit_add(t7, t8);
    let t10 = circuit_mul(t9, t9);
    let t11 = circuit_mul(t6, t10);
    let t12 = circuit_mul(t11, t11);
    let t13 = circuit_mul(t12, t12);
    let t14 = circuit_mul(t13, t13);
    let t15 = circuit_mul(t14, t11);
    let t16 = circuit_mul(t15, t12);
    let t17 = circuit_mul(t16, t16);
    let t18 = circuit_mul(t17, t15);
    let t19 = circuit_mul(t18, t18);
    let t20 = circuit_mul(t19, t19);
    let t21 = circuit_mul(t20, t20);
    let t22 = circuit_mul(t21, t21);
    let t23 = circuit_mul(t22, t22);
    let t24 = circuit_mul(t23, t18);
    let t25 = circuit_mul(t24, t24);
    let t26 = circuit_mul(t25, t25);
    let t27 = circuit_mul(t26, t26);
    let t28 = circuit_mul(t27, t27);
    let t29 = circuit_mul(t28, t28);
    let t30 = circuit_mul(t29, t29);
    let t31 = circuit_mul(t30, t30);
    let t32 = circuit_mul(t31, t31);
    let t33 = circuit_mul(t32, t32);
    let t34 = circuit_mul(t33, t33);
    let t35 = circuit_mul(t34, t24);
    let t36 = circuit_mul(t35, t35);
    let t37 = circuit_mul(t36, t36);
    let t38 = circuit_mul(t37, t37);
    let t39 = circuit_mul(t38, t38);
    let t40 = circuit_mul(t39, t39);
    let t41 = circuit_mul(t40, t40);
    let t42 = circuit_mul(t41, t41);
    let t43 = circuit_mul(t42, t42);
    let t44 = circuit_mul(t43, t43);
    let t45 = circuit_mul(t44, t44);
    let t46 = circuit_mul(t45, t45);
    let t47 = circuit_mul(t46, t46);
    let t48 = circuit_mul(t47, t47);
    let t49 = circuit_mul(t48, t48);
    let t50 = circuit_mul(t49, t49);
    let t51 = circuit_mul(t50, t50);
    let t52 = circuit_mul(t51, t51);
    let t53 = circuit_mul(t52, t52);
    let t54 = circuit_mul(t53, t53);
    let t55 = circuit_mul(t54, t54);
    let t56 = circuit_mul(t55, t35);
    let t57 = circuit_mul(t56, t56);
    let t58 = circuit_mul(t57, t57);
    let t59 = circuit_mul(t58, t58);
    let t60 = circuit_mul(t59, t59);
    let t61 = circuit_mul(t60, t60);
    let t62 = circuit_mul(t61, t61);
    let t63 = circuit_mul(t62, t62);
    let t64 = circuit_mul(t63, t63);
    let t65 = circuit_mul(t64, t64);
    let t66 = circuit_mul(t65, t65);
    let t67 = circuit_mul(t66, t24);
    let t68 = circuit_mul(t67, t67);
    let t69 = circuit_mul(t68, t68);
    let t70 = circuit_mul(t69, t69);
    let t71 = circuit_mul(t70, t70);
    let t72 = circuit_mul(t71, t71);
    let t73 = circuit_mul(t72, t72);
    let t74 = circuit_mul(t73, t73);
    let t75 = circuit_mul(t74, t74);
    let t76 = circuit_mul(t75, t75);
    let t77 = circuit_mul(t76, t76);
    let t78 = circuit_mul(t77, t77);
    let t79 = circuit_mul(t78, t78);
    let t80 = circuit_mul(t79, t79);
    let t81 = circuit_mul(t80, t80);
    let t82 = circuit_mul(t81, t81);
    let t83 = circuit_mul(t82, t82);
    let t84 = circuit_mul(t83, t83);
    let t85 = circuit_mul(t84, t84);
    let t86 = circuit_mul(t85, t85);
    let t87 = circuit_mul(t86, t86);
    let t88 = circuit_mul(t87, t87);
    let t89 = circuit_mul(t88, t88);
    let t90 = circuit_mul(t89, t89);
    let t91 = circuit_mul(t90, t90);
    let t92 = circuit_mul(t91, t91);
    let t93 = circuit_mul(t92, t92);
    let t94 = circuit_mul(t93, t93);
    let t95 = circuit_mul(t94, t94);
    let t96 = circuit_mul(t95, t95);
    let t97 = circuit_mul(t96, t96);
    let t98 = circuit_mul(t97, t97);
    let t99 = circuit_mul(t98, t98);
    let t100 = circuit_mul(t99, t99);
    let t101 = circuit_mul(t100, t100);
    let t102 = circuit_mul(t101, t101);
    let t103 = circuit_mul(t102, t102);
    let t104 = circuit_mul(t103, t103);
    let t105 = circuit_mul(t104, t104);
    let t106 = circuit_mul(t105, t105);
    let t107 = circuit_mul(t106, t106);
    let t108 = circuit_mul(t107, t107);
    let t109 = circuit_mul(t108, t108);
    let t110 = circuit_mul(t109, t109);
    let t111 = circuit_mul(t110, t110);
    let t112 = circuit_mul(t111, t111);
    let t113 = circuit_mul(t112, t112);
    let t114 = circuit_mul(t113, t113);
    let t115 = circuit_mul(t114, t114);
    let t116 = circuit_mul(t115, t115);
    let t117 = circuit_mul(t116, t116);
    let t118 = circuit_mul(t117, t67);
    let t119 = circuit_mul(t118, t118);
    let t120 = circuit_mul(t119, t119);
    let t121 = circuit_mul(t120, t120);
    let t122 = circuit_mul(t121, t121);
    let t123 = circuit_mul(t122, t122);
    let t124 = circuit_mul(t123, t123);
    let t125 = circuit_mul(t124, t124);
    let t126 = circuit_mul(t125, t125);
    let t127 = circuit_mul(t126, t126);
    let t128 = circuit_mul(t127, t127);
    let t129 = circuit_mul(t128, t128);
    let t130 = circuit_mul(t129, t129);
    let t131 = circuit_mul(t130, t130);
    let t132 = circuit_mul(t131, t131);
    let t133 = circuit_mul(t132, t132);
    let t134 = circuit_mul(t133, t133);
    let t135 = circuit_mul(t134, t134);
    let t136 = circuit_mul(t135, t135);
    let t137 = circuit_mul(t136, t136);
    let t138 = circuit_mul(t137, t137);
    let t139 = circuit_mul(t138, t138);
    let t140 = circuit_mul(t139, t139);
    let t141 = circuit_mul(t140, t140);
    let t142 = circuit_mul(t141, t141);
    let t143 = circuit_mul(t142, t142);
    let t144 = circuit_mul(t143, t143);
    let t145 = circuit_mul(t144, t144);
    let t146 = circuit_mul(t145, t145);
    let t147 = circuit_mul(t146, t146);
    let t148 = circuit_mul(t147, t147);
    let t149 = circuit_mul(t148, t148);
    let t150 = circuit_mul(t149, t149);
    let t151 = circuit_mul(t150, t150);
    let t152 = circuit_mul(t151, t151);
    let t153 = circuit_mul(t152, t152);
    let t154 = circuit_mul(t153, t153);
    let t155 = circuit_mul(t154, t154);
    let t156 = circuit_mul(t155, t155);
    let t157 = circuit_mul(t156, t156);
    let t158 = circuit_mul(t157, t157);
    let t159 = circuit_mul(t158, t158);
    let t160 = circuit_mul(t159, t159);
    let t161 = circuit_mul(t160, t160);
    let t162 = circuit_mul(t161, t161);
    let t163 = circuit_mul(t162, t162);
    let t164 = circuit_mul(t163, t163);
    let t165 = circuit_mul(t164, t164);
    let t166 = circuit_mul(t165, t165);
    let t167 = circuit_mul(t166, t166);
    let t168 = circuit_mul(t167, t167);
    let t169 = circuit_mul(t168, t168);
    let t170 = circuit_mul(t169, t169);
    let t171 = circuit_mul(t170, t170);
    let t172 = circuit_mul(t171, t171);
    let t173 = circuit_mul(t172, t172);
    let t174 = circuit_mul(t173, t173);
    let t175 = circuit_mul(t174, t174);
    let t176 = circuit_mul(t175, t175);
    let t177 = circuit_mul(t176, t176);
    let t178 = circuit_mul(t177, t177);
    let t179 = circuit_mul(t178, t178);
    let t180 = circuit_mul(t179, t179);
    let t181 = circuit_mul(t180, t180);
    let t182 = circuit_mul(t181, t181);
    let t183 = circuit_mul(t182, t182);
    let t184 = circuit_mul(t183, t183);
    let t185 = circuit_mul(t184, t184);
    let t186 = circuit_mul(t185, t185);
    let t187 = circuit_mul(t186, t186);
    let t188 = circuit_mul(t187, t187);
    let t189 = circuit_mul(t188, t188);
    let t190 = circuit_mul(t189, t189);
    let t191 = circuit_mul(t190, t190);
    let t192 = circuit_mul(t191, t191);
    let t193 = circuit_mul(t192, t192);
    let t194 = circuit_mul(t193, t193);
    let t195 = circuit_mul(t194, t194);
    let t196 = circuit_mul(t195, t195);
    let t197 = circuit_mul(t196, t196);
    let t198 = circuit_mul(t197, t197);
    let t199 = circuit_mul(t198, t198);
    let t200 = circuit_mul(t199, t199);
    let t201 = circuit_mul(t200, t200);
    let t202 = circuit_mul(t201, t201);
    let t203 = circuit_mul(t202, t202);
    let t204 = circuit_mul(t203, t203);
    let t205 = circuit_mul(t204, t204);
    let t206 = circuit_mul(t205, t205);
    let t207 = circuit_mul(t206, t206);
    let t208 = circuit_mul(t207, t207);
    let t209 = circuit_mul(t208, t208);
    let t210 = circuit_mul(t209, t209);
    let t211 = circuit_mul(t210, t210);
    let t212 = circuit_mul(t211, t211);
    let t213 = circuit_mul(t212, t212);
    let t214 = circuit_mul(t213, t213);
    let t215 = circuit_mul(t214, t214);
    let t216 = circuit_mul(t215, t215);
    let t217 = circuit_mul(t216, t216);
    let t218 = circuit_mul(t217, t217);
    let t219 = circuit_mul(t218, t118);
    let t220 = circuit_mul(t219, t219);
    let t221 = circuit_mul(t220, t220);
    let t222 = circuit_mul(t221, t221);
    let t223 = circuit_mul(t222, t222);
    let t224 = circuit_mul(t223, t223);
    let t225 = circuit_mul(t224, t224);
    let t226 = circuit_mul(t225, t225);
    let t227 = circuit_mul(t226, t226);
    let t228 = circuit_mul(t227, t227);
    let t229 = circuit_mul(t228, t228);
    let t230 = circuit_mul(t229, t229);
    let t231 = circuit_mul(t230, t230);
    let t232 = circuit_mul(t231, t231);
    let t233 = circuit_mul(t232, t232);
    let t234 = circuit_mul(t233, t233);
    let t235 = circuit_mul(t234, t234);
    let t236 = circuit_mul(t235, t235);
    let t237 = circuit_mul(t236, t236);
    let t238 = circuit_mul(t237, t237);
    let t239 = circuit_mul(t238, t238);
    let t240 = circuit_mul(t239, t239);
    let t241 = circuit_mul(t240, t240);
    let t242 = circuit_mul(t241, t241);
    let t243 = circuit_mul(t242, t242);
    let t244 = circuit_mul(t243, t243);
    let t245 = circuit_mul(t244, t244);
    let t246 = circuit_mul(t245, t245);
    let t247 = circuit_mul(t246, t246);
    let t248 = circuit_mul(t247, t247);
    let t249 = circuit_mul(t248, t248);
    let t250 = circuit_mul(t249, t249);
    let t251 = circuit_mul(t250, t250);
    let t252 = circuit_mul(t251, t251);
    let t253 = circuit_mul(t252, t252);
    let t254 = circuit_mul(t253, t253);
    let t255 = circuit_mul(t254, t254);
    let t256 = circuit_mul(t255, t255);
    let t257 = circuit_mul(t256, t256);
    let t258 = circuit_mul(t257, t257);
    let t259 = circuit_mul(t258, t258);
    let t260 = circuit_mul(t259, t259);
    let t261 = circuit_mul(t260, t260);
    let t262 = circuit_mul(t261, t261);
    let t263 = circuit_mul(t262, t262);
    let t264 = circuit_mul(t263, t263);
    let t265 = circuit_mul(t264, t264);
    let t266 = circuit_mul(t265, t265);
    let t267 = circuit_mul(t266, t266);
    let t268 = circuit_mul(t267, t267);
    let t269 = circuit_mul(t268, t268);
    let t270 = circuit_mul(t269, t67);
    let t271 = circuit_mul(t270, t270);
    let t272 = circuit_mul(t271, t271);
    let t273 = circuit_mul(t272, t11);
    let t274 = circuit_mul(t273, t273);
    let t275 = circuit_mul(t274, t11);

    let modulus = crate::definitions::get_ED25519_modulus(); // ED25519 prime field modulus

    let mut circuit_inputs = (t275,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x8283b156ebd69b9426b2f157, 0x198e80f2eef3d13000e0149a, 0x2406d9dc56dffce7, 0x0],
        ); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0xfffffffffffffffffffffff7, 0xffffffffffffffffffffffff, 0x3fffffffffffffff, 0x0],
        ); // in1
    circuit_inputs = circuit_inputs
        .next_2(
            [0x5a5fc8f189dc364e941d4160, 0x569a01327bf7af4e5e86300d, 0x570649009f83be16, 0x0],
        ); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(e); // in3
    circuit_inputs = circuit_inputs.next_2(wp); // in4
    circuit_inputs = circuit_inputs.next_2(w); // in5
    circuit_inputs = circuit_inputs.next_2(sign); // in6

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let out_0: u384 = outputs.get_output(t275);
    return (out_0,);
}
#[inline(always)]
pub fn run_ED25519_FROM_WEIERSTRASS_circuit(x: u384, y: u384) -> (u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0xc
    let in1 = CE::<CI<1>> {}; // 0x2dfc9311d490018c7338bf8688861767ff8ff5b2bebe27548a14b235eca68745
    let in2 = CE::<CI<2>> {}; // 0x1a1120a6d92ff841bfe4425f55618af80230338246493b594d9884f260bf5b69
    let in3 = CE::<CI<3>> {}; // 0x2dfc9311d490018c7338bf8688861767ff8ff5b2bebe27548a14b235eca68749
    let in4 = CE::<CI<4>> {}; // 0x1
    let in5 = CE::<CI<5>> {}; // 0x4

    // INPUT stack
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let t0 = circuit_mul(in0, in6);
    let t1 = circuit_sub(in1, t0);
    let t2 = circuit_sub(in2, t0);
    let t3 = circuit_inverse(t2);
    let t4 = circuit_mul(t1, t3);
    let t5 = circuit_add(in4, t4);
    let t6 = circuit_mul(in3, t5);
    let t7 = circuit_mul(in5, in7);
    let t8 = circuit_sub(in4, t4);
    let t9 = circuit_mul(t7, t8);
    let t10 = circuit_inverse(t9);
    let t11 = circuit_mul(t6, t10);

    let modulus = crate::definitions::get_ED25519_modulus(); // ED25519 prime field modulus

    let mut circuit_inputs = (t11, t4).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0xc, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0xbebe27548a14b235eca68745, 0x7338bf8688861767ff8ff5b2, 0x2dfc9311d490018c, 0x0],
        ); // in1
    circuit_inputs = circuit_inputs
        .next_2(
            [0x46493b594d9884f260bf5b69, 0xbfe4425f55618af802303382, 0x1a1120a6d92ff841, 0x0],
        ); // in2
    circuit_inputs = circuit_inputs
        .next_2(
            [0xbebe27548a14b235eca68749, 0x7338bf8688861767ff8ff5b2, 0x2dfc9311d490018c, 0x0],
        ); // in3
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in4
    circuit_inputs = circuit_inputs.next_2([0x4, 0x0, 0x0, 0x0]); // in5
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(x); // in6
    circuit_inputs = circuit_inputs.next_2(y); // in7

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let out_0: u384 = outputs.get_output(t11);
    let out_1: u384 = outputs.get_output(t4);
    return (out_0, out_1);
}
#[inline(always)]
pub fn run_ED25519_HALVE_NQR_circuit(e: u384, wp: u384, root: u384) -> (u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x67b1c8a467f589201330581b9f79b4722341b71101a71bf6e560c1376814bfa1

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let t0 = circuit_mul(in1, in3);
    let t1 = circuit_mul(in2, in3);
    let t2 = circuit_mul(in1, in1);
    let t3 = circuit_mul(in0, t2);

    let modulus = crate::definitions::get_ED25519_modulus(); // ED25519 prime field modulus

    let mut circuit_inputs = (t0, t1, t3).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0x1a71bf6e560c1376814bfa1, 0x1330581b9f79b4722341b711, 0x67b1c8a467f58920, 0x0],
        ); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(e); // in1
    circuit_inputs = circuit_inputs.next_2(wp); // in2
    circuit_inputs = circuit_inputs.next_2(root); // in3

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let out_0: u384 = outputs.get_output(t0);
    let out_1: u384 = outputs.get_output(t1);
    let out_2: u384 = outputs.get_output(t3);
    return (out_0, out_1, out_2);
}
#[inline(always)]
pub fn run_ED25519_HALVE_UP_circuit(u: u384, w: u384, e: u384, wp: u384) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x4
    let in1 = CE::<CI<1>> {}; // 0x37f24c4752400631cce2fe1a22185d9ffe3fd6cafaf89d522852c8d7b29a1d3f
    let in2 = CE::<CI<2>> {}; // 0x2
    let in3 = CE::<CI<3>> {}; // 0x3ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff7

    // INPUT stack
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let in7 = CE::<CI<7>> {};
    let t0 = circuit_mul(in0, in4);
    let t1 = circuit_mul(in6, in6);
    let t2 = circuit_mul(in1, t1);
    let t3 = circuit_sub(t0, t2);
    let t4 = circuit_mul(in7, in5);
    let t5 = circuit_mul(in2, t4);
    let t6 = circuit_sub(t3, t5);
    let t7 = circuit_mul(t6, in3);

    let modulus = crate::definitions::get_ED25519_modulus(); // ED25519 prime field modulus

    let mut circuit_inputs = (t7,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x4, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0xfaf89d522852c8d7b29a1d3f, 0xcce2fe1a22185d9ffe3fd6ca, 0x37f24c4752400631, 0x0],
        ); // in1
    circuit_inputs = circuit_inputs.next_2([0x2, 0x0, 0x0, 0x0]); // in2
    circuit_inputs = circuit_inputs
        .next_2(
            [0xfffffffffffffffffffffff7, 0xffffffffffffffffffffffff, 0x3fffffffffffffff, 0x0],
        ); // in3
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(u); // in4
    circuit_inputs = circuit_inputs.next_2(w); // in5
    circuit_inputs = circuit_inputs.next_2(e); // in6
    circuit_inputs = circuit_inputs.next_2(wp); // in7

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let out_0: u384 = outputs.get_output(t7);
    return (out_0,);
}
#[inline(always)]
pub fn run_ED25519_LOW_ORDER_circuit(x: u384, y: u384) -> (u384,) {
    // INPUT stack
    let (in0, in1) = (CE::<CI<0>> {}, CE::<CI<1>> {});
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in1, in1);
    let t2 = circuit_add(t0, t1);

    let modulus = crate::definitions::get_ED25519_modulus(); // ED25519 prime field modulus

    let mut circuit_inputs = (t2,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(x); // in0
    circuit_inputs = circuit_inputs.next_2(y); // in1

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let out_0: u384 = outputs.get_output(t2);
    return (out_0,);
}
#[inline(always)]
pub fn run_ED25519_PREPARE_circuit(x: u384, y: u384) -> (u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x1
    let in1 = CE::<CI<1>> {}; // 0x2dfc9311d490018c7338bf8688861767ff8ff5b2bebe27548a14b235eca68749
    let in2 = CE::<CI<2>> {}; // 0x2

    // INPUT stack
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let t0 = circuit_sub(in0, in4);
    let t1 = circuit_mul(in3, t0);
    let t2 = circuit_add(in0, in4);
    let t3 = circuit_mul(in1, t2);
    let t4 = circuit_mul(t3, in3);
    let t5 = circuit_mul(t4, t1);
    let t6 = circuit_mul(in2, t0);

    let modulus = crate::definitions::get_ED25519_modulus(); // ED25519 prime field modulus

    let mut circuit_inputs = (t5, t6, t1).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0xbebe27548a14b235eca68749, 0x7338bf8688861767ff8ff5b2, 0x2dfc9311d490018c, 0x0],
        ); // in1
    circuit_inputs = circuit_inputs.next_2([0x2, 0x0, 0x0, 0x0]); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(x); // in3
    circuit_inputs = circuit_inputs.next_2(y); // in4

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let out_0: u384 = outputs.get_output(t5);
    let out_1: u384 = outputs.get_output(t6);
    let out_2: u384 = outputs.get_output(t1);
    return (out_0, out_1, out_2);
}
#[inline(always)]
pub fn run_ED25519_SQRT_OR_TWICE_circuit(value: u384) -> (u384, u384, u384, u384, u384) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x2b8324804fc1df0b2b4d00993dfbd7a72f431806ad2fe478c4ee1b274a0ea0b0

    // INPUT stack
    let in1 = CE::<CI<1>> {};
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(t0, t0);
    let t2 = circuit_mul(t1, t1);
    let t3 = circuit_mul(t2, in1);
    let t4 = circuit_mul(t3, t0);
    let t5 = circuit_mul(t4, t4);
    let t6 = circuit_mul(t5, t3);
    let t7 = circuit_mul(t6, t6);
    let t8 = circuit_mul(t7, t7);
    let t9 = circuit_mul(t8, t8);
    let t10 = circuit_mul(t9, t9);
    let t11 = circuit_mul(t10, t10);
    let t12 = circuit_mul(t11, t6);
    let t13 = circuit_mul(t12, t12);
    let t14 = circuit_mul(t13, t13);
    let t15 = circuit_mul(t14, t14);
    let t16 = circuit_mul(t15, t15);
    let t17 = circuit_mul(t16, t16);
    let t18 = circuit_mul(t17, t17);
    let t19 = circuit_mul(t18, t18);
    let t20 = circuit_mul(t19, t19);
    let t21 = circuit_mul(t20, t20);
    let t22 = circuit_mul(t21, t21);
    let t23 = circuit_mul(t22, t12);
    let t24 = circuit_mul(t23, t23);
    let t25 = circuit_mul(t24, t24);
    let t26 = circuit_mul(t25, t25);
    let t27 = circuit_mul(t26, t26);
    let t28 = circuit_mul(t27, t27);
    let t29 = circuit_mul(t28, t28);
    let t30 = circuit_mul(t29, t29);
    let t31 = circuit_mul(t30, t30);
    let t32 = circuit_mul(t31, t31);
    let t33 = circuit_mul(t32, t32);
    let t34 = circuit_mul(t33, t33);
    let t35 = circuit_mul(t34, t34);
    let t36 = circuit_mul(t35, t35);
    let t37 = circuit_mul(t36, t36);
    let t38 = circuit_mul(t37, t37);
    let t39 = circuit_mul(t38, t38);
    let t40 = circuit_mul(t39, t39);
    let t41 = circuit_mul(t40, t40);
    let t42 = circuit_mul(t41, t41);
    let t43 = circuit_mul(t42, t42);
    let t44 = circuit_mul(t43, t23);
    let t45 = circuit_mul(t44, t44);
    let t46 = circuit_mul(t45, t45);
    let t47 = circuit_mul(t46, t46);
    let t48 = circuit_mul(t47, t47);
    let t49 = circuit_mul(t48, t48);
    let t50 = circuit_mul(t49, t49);
    let t51 = circuit_mul(t50, t50);
    let t52 = circuit_mul(t51, t51);
    let t53 = circuit_mul(t52, t52);
    let t54 = circuit_mul(t53, t53);
    let t55 = circuit_mul(t54, t12);
    let t56 = circuit_mul(t55, t55);
    let t57 = circuit_mul(t56, t56);
    let t58 = circuit_mul(t57, t57);
    let t59 = circuit_mul(t58, t58);
    let t60 = circuit_mul(t59, t59);
    let t61 = circuit_mul(t60, t60);
    let t62 = circuit_mul(t61, t61);
    let t63 = circuit_mul(t62, t62);
    let t64 = circuit_mul(t63, t63);
    let t65 = circuit_mul(t64, t64);
    let t66 = circuit_mul(t65, t65);
    let t67 = circuit_mul(t66, t66);
    let t68 = circuit_mul(t67, t67);
    let t69 = circuit_mul(t68, t68);
    let t70 = circuit_mul(t69, t69);
    let t71 = circuit_mul(t70, t70);
    let t72 = circuit_mul(t71, t71);
    let t73 = circuit_mul(t72, t72);
    let t74 = circuit_mul(t73, t73);
    let t75 = circuit_mul(t74, t74);
    let t76 = circuit_mul(t75, t75);
    let t77 = circuit_mul(t76, t76);
    let t78 = circuit_mul(t77, t77);
    let t79 = circuit_mul(t78, t78);
    let t80 = circuit_mul(t79, t79);
    let t81 = circuit_mul(t80, t80);
    let t82 = circuit_mul(t81, t81);
    let t83 = circuit_mul(t82, t82);
    let t84 = circuit_mul(t83, t83);
    let t85 = circuit_mul(t84, t84);
    let t86 = circuit_mul(t85, t85);
    let t87 = circuit_mul(t86, t86);
    let t88 = circuit_mul(t87, t87);
    let t89 = circuit_mul(t88, t88);
    let t90 = circuit_mul(t89, t89);
    let t91 = circuit_mul(t90, t90);
    let t92 = circuit_mul(t91, t91);
    let t93 = circuit_mul(t92, t92);
    let t94 = circuit_mul(t93, t93);
    let t95 = circuit_mul(t94, t94);
    let t96 = circuit_mul(t95, t95);
    let t97 = circuit_mul(t96, t96);
    let t98 = circuit_mul(t97, t97);
    let t99 = circuit_mul(t98, t98);
    let t100 = circuit_mul(t99, t99);
    let t101 = circuit_mul(t100, t100);
    let t102 = circuit_mul(t101, t101);
    let t103 = circuit_mul(t102, t102);
    let t104 = circuit_mul(t103, t103);
    let t105 = circuit_mul(t104, t104);
    let t106 = circuit_mul(t105, t55);
    let t107 = circuit_mul(t106, t106);
    let t108 = circuit_mul(t107, t107);
    let t109 = circuit_mul(t108, t108);
    let t110 = circuit_mul(t109, t109);
    let t111 = circuit_mul(t110, t110);
    let t112 = circuit_mul(t111, t111);
    let t113 = circuit_mul(t112, t112);
    let t114 = circuit_mul(t113, t113);
    let t115 = circuit_mul(t114, t114);
    let t116 = circuit_mul(t115, t115);
    let t117 = circuit_mul(t116, t116);
    let t118 = circuit_mul(t117, t117);
    let t119 = circuit_mul(t118, t118);
    let t120 = circuit_mul(t119, t119);
    let t121 = circuit_mul(t120, t120);
    let t122 = circuit_mul(t121, t121);
    let t123 = circuit_mul(t122, t122);
    let t124 = circuit_mul(t123, t123);
    let t125 = circuit_mul(t124, t124);
    let t126 = circuit_mul(t125, t125);
    let t127 = circuit_mul(t126, t126);
    let t128 = circuit_mul(t127, t127);
    let t129 = circuit_mul(t128, t128);
    let t130 = circuit_mul(t129, t129);
    let t131 = circuit_mul(t130, t130);
    let t132 = circuit_mul(t131, t131);
    let t133 = circuit_mul(t132, t132);
    let t134 = circuit_mul(t133, t133);
    let t135 = circuit_mul(t134, t134);
    let t136 = circuit_mul(t135, t135);
    let t137 = circuit_mul(t136, t136);
    let t138 = circuit_mul(t137, t137);
    let t139 = circuit_mul(t138, t138);
    let t140 = circuit_mul(t139, t139);
    let t141 = circuit_mul(t140, t140);
    let t142 = circuit_mul(t141, t141);
    let t143 = circuit_mul(t142, t142);
    let t144 = circuit_mul(t143, t143);
    let t145 = circuit_mul(t144, t144);
    let t146 = circuit_mul(t145, t145);
    let t147 = circuit_mul(t146, t146);
    let t148 = circuit_mul(t147, t147);
    let t149 = circuit_mul(t148, t148);
    let t150 = circuit_mul(t149, t149);
    let t151 = circuit_mul(t150, t150);
    let t152 = circuit_mul(t151, t151);
    let t153 = circuit_mul(t152, t152);
    let t154 = circuit_mul(t153, t153);
    let t155 = circuit_mul(t154, t154);
    let t156 = circuit_mul(t155, t155);
    let t157 = circuit_mul(t156, t156);
    let t158 = circuit_mul(t157, t157);
    let t159 = circuit_mul(t158, t158);
    let t160 = circuit_mul(t159, t159);
    let t161 = circuit_mul(t160, t160);
    let t162 = circuit_mul(t161, t161);
    let t163 = circuit_mul(t162, t162);
    let t164 = circuit_mul(t163, t163);
    let t165 = circuit_mul(t164, t164);
    let t166 = circuit_mul(t165, t165);
    let t167 = circuit_mul(t166, t166);
    let t168 = circuit_mul(t167, t167);
    let t169 = circuit_mul(t168, t168);
    let t170 = circuit_mul(t169, t169);
    let t171 = circuit_mul(t170, t170);
    let t172 = circuit_mul(t171, t171);
    let t173 = circuit_mul(t172, t172);
    let t174 = circuit_mul(t173, t173);
    let t175 = circuit_mul(t174, t174);
    let t176 = circuit_mul(t175, t175);
    let t177 = circuit_mul(t176, t176);
    let t178 = circuit_mul(t177, t177);
    let t179 = circuit_mul(t178, t178);
    let t180 = circuit_mul(t179, t179);
    let t181 = circuit_mul(t180, t180);
    let t182 = circuit_mul(t181, t181);
    let t183 = circuit_mul(t182, t182);
    let t184 = circuit_mul(t183, t183);
    let t185 = circuit_mul(t184, t184);
    let t186 = circuit_mul(t185, t185);
    let t187 = circuit_mul(t186, t186);
    let t188 = circuit_mul(t187, t187);
    let t189 = circuit_mul(t188, t188);
    let t190 = circuit_mul(t189, t189);
    let t191 = circuit_mul(t190, t190);
    let t192 = circuit_mul(t191, t191);
    let t193 = circuit_mul(t192, t192);
    let t194 = circuit_mul(t193, t193);
    let t195 = circuit_mul(t194, t194);
    let t196 = circuit_mul(t195, t195);
    let t197 = circuit_mul(t196, t196);
    let t198 = circuit_mul(t197, t197);
    let t199 = circuit_mul(t198, t198);
    let t200 = circuit_mul(t199, t199);
    let t201 = circuit_mul(t200, t200);
    let t202 = circuit_mul(t201, t201);
    let t203 = circuit_mul(t202, t202);
    let t204 = circuit_mul(t203, t203);
    let t205 = circuit_mul(t204, t204);
    let t206 = circuit_mul(t205, t205);
    let t207 = circuit_mul(t206, t106);
    let t208 = circuit_mul(t207, t207);
    let t209 = circuit_mul(t208, t208);
    let t210 = circuit_mul(t209, t209);
    let t211 = circuit_mul(t210, t210);
    let t212 = circuit_mul(t211, t211);
    let t213 = circuit_mul(t212, t212);
    let t214 = circuit_mul(t213, t213);
    let t215 = circuit_mul(t214, t214);
    let t216 = circuit_mul(t215, t215);
    let t217 = circuit_mul(t216, t216);
    let t218 = circuit_mul(t217, t217);
    let t219 = circuit_mul(t218, t218);
    let t220 = circuit_mul(t219, t219);
    let t221 = circuit_mul(t220, t220);
    let t222 = circuit_mul(t221, t221);
    let t223 = circuit_mul(t222, t222);
    let t224 = circuit_mul(t223, t223);
    let t225 = circuit_mul(t224, t224);
    let t226 = circuit_mul(t225, t225);
    let t227 = circuit_mul(t226, t226);
    let t228 = circuit_mul(t227, t227);
    let t229 = circuit_mul(t228, t228);
    let t230 = circuit_mul(t229, t229);
    let t231 = circuit_mul(t230, t230);
    let t232 = circuit_mul(t231, t231);
    let t233 = circuit_mul(t232, t232);
    let t234 = circuit_mul(t233, t233);
    let t235 = circuit_mul(t234, t234);
    let t236 = circuit_mul(t235, t235);
    let t237 = circuit_mul(t236, t236);
    let t238 = circuit_mul(t237, t237);
    let t239 = circuit_mul(t238, t238);
    let t240 = circuit_mul(t239, t239);
    let t241 = circuit_mul(t240, t240);
    let t242 = circuit_mul(t241, t241);
    let t243 = circuit_mul(t242, t242);
    let t244 = circuit_mul(t243, t243);
    let t245 = circuit_mul(t244, t244);
    let t246 = circuit_mul(t245, t245);
    let t247 = circuit_mul(t246, t246);
    let t248 = circuit_mul(t247, t247);
    let t249 = circuit_mul(t248, t248);
    let t250 = circuit_mul(t249, t249);
    let t251 = circuit_mul(t250, t250);
    let t252 = circuit_mul(t251, t251);
    let t253 = circuit_mul(t252, t252);
    let t254 = circuit_mul(t253, t253);
    let t255 = circuit_mul(t254, t254);
    let t256 = circuit_mul(t255, t255);
    let t257 = circuit_mul(t256, t256);
    let t258 = circuit_mul(t257, t55);
    let t259 = circuit_mul(t258, t258);
    let t260 = circuit_mul(t259, t259);
    let t261 = circuit_mul(t260, in1);
    let t262 = circuit_mul(t261, in1);
    let t263 = circuit_mul(t262, t262);
    let t264 = circuit_sub(t263, in1);
    let t265 = circuit_add(t263, in1);
    let t266 = circuit_mul(in0, in1);
    let t267 = circuit_sub(t263, t266);
    let t268 = circuit_add(t263, t266);

    let modulus = crate::definitions::get_ED25519_modulus(); // ED25519 prime field modulus

    let mut circuit_inputs = (t262, t264, t265, t267, t268).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [0xad2fe478c4ee1b274a0ea0b0, 0x2b4d00993dfbd7a72f431806, 0x2b8324804fc1df0b, 0x0],
        ); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(value); // in1

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let out_0: u384 = outputs.get_output(t262);
    let out_1: u384 = outputs.get_output(t264);
    let out_2: u384 = outputs.get_output(t265);
    let out_3: u384 = outputs.get_output(t267);
    let out_4: u384 = outputs.get_output(t268);
    return (out_0, out_1, out_2, out_3, out_4);
}
#[inline(always)]
pub fn run_ED25519_SQRT_circuit(value: u384) -> (u384, u384, u384) {
    // INPUT stack
    let in0 = CE::<CI<0>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(t0, t0);
    let t2 = circuit_mul(t1, t1);
    let t3 = circuit_mul(t2, in0);
    let t4 = circuit_mul(t3, t0);
    let t5 = circuit_mul(t4, t4);
    let t6 = circuit_mul(t5, t3);
    let t7 = circuit_mul(t6, t6);
    let t8 = circuit_mul(t7, t7);
    let t9 = circuit_mul(t8, t8);
    let t10 = circuit_mul(t9, t9);
    let t11 = circuit_mul(t10, t10);
    let t12 = circuit_mul(t11, t6);
    let t13 = circuit_mul(t12, t12);
    let t14 = circuit_mul(t13, t13);
    let t15 = circuit_mul(t14, t14);
    let t16 = circuit_mul(t15, t15);
    let t17 = circuit_mul(t16, t16);
    let t18 = circuit_mul(t17, t17);
    let t19 = circuit_mul(t18, t18);
    let t20 = circuit_mul(t19, t19);
    let t21 = circuit_mul(t20, t20);
    let t22 = circuit_mul(t21, t21);
    let t23 = circuit_mul(t22, t12);
    let t24 = circuit_mul(t23, t23);
    let t25 = circuit_mul(t24, t24);
    let t26 = circuit_mul(t25, t25);
    let t27 = circuit_mul(t26, t26);
    let t28 = circuit_mul(t27, t27);
    let t29 = circuit_mul(t28, t28);
    let t30 = circuit_mul(t29, t29);
    let t31 = circuit_mul(t30, t30);
    let t32 = circuit_mul(t31, t31);
    let t33 = circuit_mul(t32, t32);
    let t34 = circuit_mul(t33, t33);
    let t35 = circuit_mul(t34, t34);
    let t36 = circuit_mul(t35, t35);
    let t37 = circuit_mul(t36, t36);
    let t38 = circuit_mul(t37, t37);
    let t39 = circuit_mul(t38, t38);
    let t40 = circuit_mul(t39, t39);
    let t41 = circuit_mul(t40, t40);
    let t42 = circuit_mul(t41, t41);
    let t43 = circuit_mul(t42, t42);
    let t44 = circuit_mul(t43, t23);
    let t45 = circuit_mul(t44, t44);
    let t46 = circuit_mul(t45, t45);
    let t47 = circuit_mul(t46, t46);
    let t48 = circuit_mul(t47, t47);
    let t49 = circuit_mul(t48, t48);
    let t50 = circuit_mul(t49, t49);
    let t51 = circuit_mul(t50, t50);
    let t52 = circuit_mul(t51, t51);
    let t53 = circuit_mul(t52, t52);
    let t54 = circuit_mul(t53, t53);
    let t55 = circuit_mul(t54, t12);
    let t56 = circuit_mul(t55, t55);
    let t57 = circuit_mul(t56, t56);
    let t58 = circuit_mul(t57, t57);
    let t59 = circuit_mul(t58, t58);
    let t60 = circuit_mul(t59, t59);
    let t61 = circuit_mul(t60, t60);
    let t62 = circuit_mul(t61, t61);
    let t63 = circuit_mul(t62, t62);
    let t64 = circuit_mul(t63, t63);
    let t65 = circuit_mul(t64, t64);
    let t66 = circuit_mul(t65, t65);
    let t67 = circuit_mul(t66, t66);
    let t68 = circuit_mul(t67, t67);
    let t69 = circuit_mul(t68, t68);
    let t70 = circuit_mul(t69, t69);
    let t71 = circuit_mul(t70, t70);
    let t72 = circuit_mul(t71, t71);
    let t73 = circuit_mul(t72, t72);
    let t74 = circuit_mul(t73, t73);
    let t75 = circuit_mul(t74, t74);
    let t76 = circuit_mul(t75, t75);
    let t77 = circuit_mul(t76, t76);
    let t78 = circuit_mul(t77, t77);
    let t79 = circuit_mul(t78, t78);
    let t80 = circuit_mul(t79, t79);
    let t81 = circuit_mul(t80, t80);
    let t82 = circuit_mul(t81, t81);
    let t83 = circuit_mul(t82, t82);
    let t84 = circuit_mul(t83, t83);
    let t85 = circuit_mul(t84, t84);
    let t86 = circuit_mul(t85, t85);
    let t87 = circuit_mul(t86, t86);
    let t88 = circuit_mul(t87, t87);
    let t89 = circuit_mul(t88, t88);
    let t90 = circuit_mul(t89, t89);
    let t91 = circuit_mul(t90, t90);
    let t92 = circuit_mul(t91, t91);
    let t93 = circuit_mul(t92, t92);
    let t94 = circuit_mul(t93, t93);
    let t95 = circuit_mul(t94, t94);
    let t96 = circuit_mul(t95, t95);
    let t97 = circuit_mul(t96, t96);
    let t98 = circuit_mul(t97, t97);
    let t99 = circuit_mul(t98, t98);
    let t100 = circuit_mul(t99, t99);
    let t101 = circuit_mul(t100, t100);
    let t102 = circuit_mul(t101, t101);
    let t103 = circuit_mul(t102, t102);
    let t104 = circuit_mul(t103, t103);
    let t105 = circuit_mul(t104, t104);
    let t106 = circuit_mul(t105, t55);
    let t107 = circuit_mul(t106, t106);
    let t108 = circuit_mul(t107, t107);
    let t109 = circuit_mul(t108, t108);
    let t110 = circuit_mul(t109, t109);
    let t111 = circuit_mul(t110, t110);
    let t112 = circuit_mul(t111, t111);
    let t113 = circuit_mul(t112, t112);
    let t114 = circuit_mul(t113, t113);
    let t115 = circuit_mul(t114, t114);
    let t116 = circuit_mul(t115, t115);
    let t117 = circuit_mul(t116, t116);
    let t118 = circuit_mul(t117, t117);
    let t119 = circuit_mul(t118, t118);
    let t120 = circuit_mul(t119, t119);
    let t121 = circuit_mul(t120, t120);
    let t122 = circuit_mul(t121, t121);
    let t123 = circuit_mul(t122, t122);
    let t124 = circuit_mul(t123, t123);
    let t125 = circuit_mul(t124, t124);
    let t126 = circuit_mul(t125, t125);
    let t127 = circuit_mul(t126, t126);
    let t128 = circuit_mul(t127, t127);
    let t129 = circuit_mul(t128, t128);
    let t130 = circuit_mul(t129, t129);
    let t131 = circuit_mul(t130, t130);
    let t132 = circuit_mul(t131, t131);
    let t133 = circuit_mul(t132, t132);
    let t134 = circuit_mul(t133, t133);
    let t135 = circuit_mul(t134, t134);
    let t136 = circuit_mul(t135, t135);
    let t137 = circuit_mul(t136, t136);
    let t138 = circuit_mul(t137, t137);
    let t139 = circuit_mul(t138, t138);
    let t140 = circuit_mul(t139, t139);
    let t141 = circuit_mul(t140, t140);
    let t142 = circuit_mul(t141, t141);
    let t143 = circuit_mul(t142, t142);
    let t144 = circuit_mul(t143, t143);
    let t145 = circuit_mul(t144, t144);
    let t146 = circuit_mul(t145, t145);
    let t147 = circuit_mul(t146, t146);
    let t148 = circuit_mul(t147, t147);
    let t149 = circuit_mul(t148, t148);
    let t150 = circuit_mul(t149, t149);
    let t151 = circuit_mul(t150, t150);
    let t152 = circuit_mul(t151, t151);
    let t153 = circuit_mul(t152, t152);
    let t154 = circuit_mul(t153, t153);
    let t155 = circuit_mul(t154, t154);
    let t156 = circuit_mul(t155, t155);
    let t157 = circuit_mul(t156, t156);
    let t158 = circuit_mul(t157, t157);
    let t159 = circuit_mul(t158, t158);
    let t160 = circuit_mul(t159, t159);
    let t161 = circuit_mul(t160, t160);
    let t162 = circuit_mul(t161, t161);
    let t163 = circuit_mul(t162, t162);
    let t164 = circuit_mul(t163, t163);
    let t165 = circuit_mul(t164, t164);
    let t166 = circuit_mul(t165, t165);
    let t167 = circuit_mul(t166, t166);
    let t168 = circuit_mul(t167, t167);
    let t169 = circuit_mul(t168, t168);
    let t170 = circuit_mul(t169, t169);
    let t171 = circuit_mul(t170, t170);
    let t172 = circuit_mul(t171, t171);
    let t173 = circuit_mul(t172, t172);
    let t174 = circuit_mul(t173, t173);
    let t175 = circuit_mul(t174, t174);
    let t176 = circuit_mul(t175, t175);
    let t177 = circuit_mul(t176, t176);
    let t178 = circuit_mul(t177, t177);
    let t179 = circuit_mul(t178, t178);
    let t180 = circuit_mul(t179, t179);
    let t181 = circuit_mul(t180, t180);
    let t182 = circuit_mul(t181, t181);
    let t183 = circuit_mul(t182, t182);
    let t184 = circuit_mul(t183, t183);
    let t185 = circuit_mul(t184, t184);
    let t186 = circuit_mul(t185, t185);
    let t187 = circuit_mul(t186, t186);
    let t188 = circuit_mul(t187, t187);
    let t189 = circuit_mul(t188, t188);
    let t190 = circuit_mul(t189, t189);
    let t191 = circuit_mul(t190, t190);
    let t192 = circuit_mul(t191, t191);
    let t193 = circuit_mul(t192, t192);
    let t194 = circuit_mul(t193, t193);
    let t195 = circuit_mul(t194, t194);
    let t196 = circuit_mul(t195, t195);
    let t197 = circuit_mul(t196, t196);
    let t198 = circuit_mul(t197, t197);
    let t199 = circuit_mul(t198, t198);
    let t200 = circuit_mul(t199, t199);
    let t201 = circuit_mul(t200, t200);
    let t202 = circuit_mul(t201, t201);
    let t203 = circuit_mul(t202, t202);
    let t204 = circuit_mul(t203, t203);
    let t205 = circuit_mul(t204, t204);
    let t206 = circuit_mul(t205, t205);
    let t207 = circuit_mul(t206, t106);
    let t208 = circuit_mul(t207, t207);
    let t209 = circuit_mul(t208, t208);
    let t210 = circuit_mul(t209, t209);
    let t211 = circuit_mul(t210, t210);
    let t212 = circuit_mul(t211, t211);
    let t213 = circuit_mul(t212, t212);
    let t214 = circuit_mul(t213, t213);
    let t215 = circuit_mul(t214, t214);
    let t216 = circuit_mul(t215, t215);
    let t217 = circuit_mul(t216, t216);
    let t218 = circuit_mul(t217, t217);
    let t219 = circuit_mul(t218, t218);
    let t220 = circuit_mul(t219, t219);
    let t221 = circuit_mul(t220, t220);
    let t222 = circuit_mul(t221, t221);
    let t223 = circuit_mul(t222, t222);
    let t224 = circuit_mul(t223, t223);
    let t225 = circuit_mul(t224, t224);
    let t226 = circuit_mul(t225, t225);
    let t227 = circuit_mul(t226, t226);
    let t228 = circuit_mul(t227, t227);
    let t229 = circuit_mul(t228, t228);
    let t230 = circuit_mul(t229, t229);
    let t231 = circuit_mul(t230, t230);
    let t232 = circuit_mul(t231, t231);
    let t233 = circuit_mul(t232, t232);
    let t234 = circuit_mul(t233, t233);
    let t235 = circuit_mul(t234, t234);
    let t236 = circuit_mul(t235, t235);
    let t237 = circuit_mul(t236, t236);
    let t238 = circuit_mul(t237, t237);
    let t239 = circuit_mul(t238, t238);
    let t240 = circuit_mul(t239, t239);
    let t241 = circuit_mul(t240, t240);
    let t242 = circuit_mul(t241, t241);
    let t243 = circuit_mul(t242, t242);
    let t244 = circuit_mul(t243, t243);
    let t245 = circuit_mul(t244, t244);
    let t246 = circuit_mul(t245, t245);
    let t247 = circuit_mul(t246, t246);
    let t248 = circuit_mul(t247, t247);
    let t249 = circuit_mul(t248, t248);
    let t250 = circuit_mul(t249, t249);
    let t251 = circuit_mul(t250, t250);
    let t252 = circuit_mul(t251, t251);
    let t253 = circuit_mul(t252, t252);
    let t254 = circuit_mul(t253, t253);
    let t255 = circuit_mul(t254, t254);
    let t256 = circuit_mul(t255, t255);
    let t257 = circuit_mul(t256, t256);
    let t258 = circuit_mul(t257, t55);
    let t259 = circuit_mul(t258, t258);
    let t260 = circuit_mul(t259, t259);
    let t261 = circuit_mul(t260, in0);
    let t262 = circuit_mul(t261, in0);
    let t263 = circuit_mul(t262, t262);
    let t264 = circuit_sub(t263, in0);
    let t265 = circuit_add(t263, in0);

    let modulus = crate::definitions::get_ED25519_modulus(); // ED25519 prime field modulus

    let mut circuit_inputs = (t262, t264, t265).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(value); // in0

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let out_0: u384 = outputs.get_output(t262);
    let out_1: u384 = outputs.get_output(t264);
    let out_2: u384 = outputs.get_output(t265);
    return (out_0, out_1, out_2);
}
