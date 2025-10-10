use core::circuit::{
    CircuitElement as CE, CircuitInput as CI, CircuitInputs, CircuitOutputsTrait, EvalCircuitTrait,
    circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384,
};
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::{G1Point, G2Point};

impl CircuitDefinition27<
    E0,
    E1,
    E2,
    E3,
    E4,
    E5,
    E6,
    E7,
    E8,
    E9,
    E10,
    E11,
    E12,
    E13,
    E14,
    E15,
    E16,
    E17,
    E18,
    E19,
    E20,
    E21,
    E22,
    E23,
    E24,
    E25,
    E26,
> of core::circuit::CircuitDefinition<
    (
        CE<E0>,
        CE<E1>,
        CE<E2>,
        CE<E3>,
        CE<E4>,
        CE<E5>,
        CE<E6>,
        CE<E7>,
        CE<E8>,
        CE<E9>,
        CE<E10>,
        CE<E11>,
        CE<E12>,
        CE<E13>,
        CE<E14>,
        CE<E15>,
        CE<E16>,
        CE<E17>,
        CE<E18>,
        CE<E19>,
        CE<E20>,
        CE<E21>,
        CE<E22>,
        CE<E23>,
        CE<E24>,
        CE<E25>,
        CE<E26>,
    ),
> {
    type CircuitType =
        core::circuit::Circuit<
            (
                E0,
                E1,
                E2,
                E3,
                E4,
                E5,
                E6,
                E7,
                E8,
                E9,
                E10,
                E11,
                E12,
                E13,
                E14,
                E15,
                E16,
                E17,
                E18,
                E19,
                E20,
                E21,
                E22,
                E23,
                E24,
                E25,
                E26,
            ),
        >;
}
impl MyDrp_27<
    E0,
    E1,
    E2,
    E3,
    E4,
    E5,
    E6,
    E7,
    E8,
    E9,
    E10,
    E11,
    E12,
    E13,
    E14,
    E15,
    E16,
    E17,
    E18,
    E19,
    E20,
    E21,
    E22,
    E23,
    E24,
    E25,
    E26,
> of Drop<
    (
        CE<E0>,
        CE<E1>,
        CE<E2>,
        CE<E3>,
        CE<E4>,
        CE<E5>,
        CE<E6>,
        CE<E7>,
        CE<E8>,
        CE<E9>,
        CE<E10>,
        CE<E11>,
        CE<E12>,
        CE<E13>,
        CE<E14>,
        CE<E15>,
        CE<E16>,
        CE<E17>,
        CE<E18>,
        CE<E19>,
        CE<E20>,
        CE<E21>,
        CE<E22>,
        CE<E23>,
        CE<E24>,
        CE<E25>,
        CE<E26>,
    ),
>;

impl CircuitDefinition28<
    E0,
    E1,
    E2,
    E3,
    E4,
    E5,
    E6,
    E7,
    E8,
    E9,
    E10,
    E11,
    E12,
    E13,
    E14,
    E15,
    E16,
    E17,
    E18,
    E19,
    E20,
    E21,
    E22,
    E23,
    E24,
    E25,
    E26,
    E27,
> of core::circuit::CircuitDefinition<
    (
        CE<E0>,
        CE<E1>,
        CE<E2>,
        CE<E3>,
        CE<E4>,
        CE<E5>,
        CE<E6>,
        CE<E7>,
        CE<E8>,
        CE<E9>,
        CE<E10>,
        CE<E11>,
        CE<E12>,
        CE<E13>,
        CE<E14>,
        CE<E15>,
        CE<E16>,
        CE<E17>,
        CE<E18>,
        CE<E19>,
        CE<E20>,
        CE<E21>,
        CE<E22>,
        CE<E23>,
        CE<E24>,
        CE<E25>,
        CE<E26>,
        CE<E27>,
    ),
> {
    type CircuitType =
        core::circuit::Circuit<
            (
                E0,
                E1,
                E2,
                E3,
                E4,
                E5,
                E6,
                E7,
                E8,
                E9,
                E10,
                E11,
                E12,
                E13,
                E14,
                E15,
                E16,
                E17,
                E18,
                E19,
                E20,
                E21,
                E22,
                E23,
                E24,
                E25,
                E26,
                E27,
            ),
        >;
}
impl MyDrp_28<
    E0,
    E1,
    E2,
    E3,
    E4,
    E5,
    E6,
    E7,
    E8,
    E9,
    E10,
    E11,
    E12,
    E13,
    E14,
    E15,
    E16,
    E17,
    E18,
    E19,
    E20,
    E21,
    E22,
    E23,
    E24,
    E25,
    E26,
    E27,
> of Drop<
    (
        CE<E0>,
        CE<E1>,
        CE<E2>,
        CE<E3>,
        CE<E4>,
        CE<E5>,
        CE<E6>,
        CE<E7>,
        CE<E8>,
        CE<E9>,
        CE<E10>,
        CE<E11>,
        CE<E12>,
        CE<E13>,
        CE<E14>,
        CE<E15>,
        CE<E16>,
        CE<E17>,
        CE<E18>,
        CE<E19>,
        CE<E20>,
        CE<E21>,
        CE<E22>,
        CE<E23>,
        CE<E24>,
        CE<E25>,
        CE<E26>,
        CE<E27>,
    ),
>;
#[inline(always)]
pub fn run_ADD_EC_POINTS_G2_circuit(
    p: G2Point, q: G2Point, modulus: core::circuit::CircuitModulus,
) -> (G2Point,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let t0 = circuit_sub(in3, in7); // Fp2 sub coeff 0/1
    let t1 = circuit_sub(in4, in8); // Fp2 sub coeff 1/1
    let t2 = circuit_sub(in1, in5); // Fp2 sub coeff 0/1
    let t3 = circuit_sub(in2, in6); // Fp2 sub coeff 1/1
    let t4 = circuit_mul(t2, t2); // Fp2 Inv start
    let t5 = circuit_mul(t3, t3);
    let t6 = circuit_add(t4, t5);
    let t7 = circuit_inverse(t6);
    let t8 = circuit_mul(t2, t7); // Fp2 Inv real part end
    let t9 = circuit_mul(t3, t7);
    let t10 = circuit_sub(in0, t9); // Fp2 Inv imag part end
    let t11 = circuit_mul(t0, t8); // Fp2 mul start
    let t12 = circuit_mul(t1, t10);
    let t13 = circuit_sub(t11, t12); // Fp2 mul real part end
    let t14 = circuit_mul(t0, t10);
    let t15 = circuit_mul(t1, t8);
    let t16 = circuit_add(t14, t15); // Fp2 mul imag part end
    let t17 = circuit_add(t13, t16);
    let t18 = circuit_sub(t13, t16);
    let t19 = circuit_mul(t17, t18);
    let t20 = circuit_mul(t13, t16);
    let t21 = circuit_add(t20, t20);
    let t22 = circuit_sub(t19, in1); // Fp2 sub coeff 0/1
    let t23 = circuit_sub(t21, in2); // Fp2 sub coeff 1/1
    let t24 = circuit_sub(t22, in5); // Fp2 sub coeff 0/1
    let t25 = circuit_sub(t23, in6); // Fp2 sub coeff 1/1
    let t26 = circuit_sub(in1, t24); // Fp2 sub coeff 0/1
    let t27 = circuit_sub(in2, t25); // Fp2 sub coeff 1/1
    let t28 = circuit_mul(t13, t26); // Fp2 mul start
    let t29 = circuit_mul(t16, t27);
    let t30 = circuit_sub(t28, t29); // Fp2 mul real part end
    let t31 = circuit_mul(t13, t27);
    let t32 = circuit_mul(t16, t26);
    let t33 = circuit_add(t31, t32); // Fp2 mul imag part end
    let t34 = circuit_sub(t30, in3); // Fp2 sub coeff 0/1
    let t35 = circuit_sub(t33, in4); // Fp2 sub coeff 1/1

    let modulus = modulus;

    let mut circuit_inputs = (t24, t25, t34, t35).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x0); // in1
    circuit_inputs = circuit_inputs.next_2(p.x1); // in2
    circuit_inputs = circuit_inputs.next_2(p.y0); // in3
    circuit_inputs = circuit_inputs.next_2(p.y1); // in4
    circuit_inputs = circuit_inputs.next_2(q.x0); // in5
    circuit_inputs = circuit_inputs.next_2(q.x1); // in6
    circuit_inputs = circuit_inputs.next_2(q.y0); // in7
    circuit_inputs = circuit_inputs.next_2(q.y1); // in8

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let result: G2Point = G2Point {
        x0: outputs.get_output(t24),
        x1: outputs.get_output(t25),
        y0: outputs.get_output(t34),
        y1: outputs.get_output(t35),
    };
    return (result,);
}
#[inline(always)]
pub fn run_ADD_EC_POINT_circuit(
    p: G1Point, q: G1Point, modulus: core::circuit::CircuitModulus,
) -> (G1Point,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let in3 = CE::<CI<3>> {};
    let t0 = circuit_sub(in1, in3);
    let t1 = circuit_sub(in0, in2);
    let t2 = circuit_inverse(t1);
    let t3 = circuit_mul(t0, t2);
    let t4 = circuit_mul(t3, t3);
    let t5 = circuit_sub(t4, in0);
    let t6 = circuit_sub(t5, in2);
    let t7 = circuit_sub(in0, t6);
    let t8 = circuit_mul(t3, t7);
    let t9 = circuit_sub(t8, in1);

    let modulus = modulus;

    let mut circuit_inputs = (t6, t9).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in0
    circuit_inputs = circuit_inputs.next_2(p.y); // in1
    circuit_inputs = circuit_inputs.next_2(q.x); // in2
    circuit_inputs = circuit_inputs.next_2(q.y); // in3

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let r: G1Point = G1Point { x: outputs.get_output(t6), y: outputs.get_output(t9) };
    return (r,);
}
#[inline(always)]
pub fn run_CLEAR_COFACTOR_BLS12_381_circuit(
    P: G1Point, modulus: core::circuit::CircuitModulus,
) -> (G1Point,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3

    // INPUT stack
    let (in1, in2) = (CE::<CI<1>> {}, CE::<CI<2>> {});
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_add(in2, in2);
    let t3 = circuit_inverse(t2);
    let t4 = circuit_mul(t1, t3);
    let t5 = circuit_mul(t4, t4);
    let t6 = circuit_sub(t5, in1);
    let t7 = circuit_sub(t6, in1);
    let t8 = circuit_sub(in1, t7);
    let t9 = circuit_mul(t4, t8);
    let t10 = circuit_sub(t9, in2);
    let t11 = circuit_sub(t10, in2);
    let t12 = circuit_sub(t7, in1);
    let t13 = circuit_inverse(t12);
    let t14 = circuit_mul(t11, t13);
    let t15 = circuit_mul(t14, t14);
    let t16 = circuit_sub(t15, t7);
    let t17 = circuit_sub(t16, in1);
    let t18 = circuit_sub(t7, t17);
    let t19 = circuit_mul(t14, t18);
    let t20 = circuit_sub(t19, t10);
    let t21 = circuit_mul(t17, t17);
    let t22 = circuit_mul(in0, t21);
    let t23 = circuit_add(t20, t20);
    let t24 = circuit_inverse(t23);
    let t25 = circuit_mul(t22, t24);
    let t26 = circuit_mul(t25, t25);
    let t27 = circuit_sub(t26, t17);
    let t28 = circuit_sub(t27, t17);
    let t29 = circuit_sub(t17, t28);
    let t30 = circuit_mul(t25, t29);
    let t31 = circuit_sub(t30, t20);
    let t32 = circuit_mul(t28, t28);
    let t33 = circuit_mul(in0, t32);
    let t34 = circuit_add(t31, t31);
    let t35 = circuit_inverse(t34);
    let t36 = circuit_mul(t33, t35);
    let t37 = circuit_mul(t36, t36);
    let t38 = circuit_sub(t37, t28);
    let t39 = circuit_sub(t38, t28);
    let t40 = circuit_sub(t28, t39);
    let t41 = circuit_mul(t36, t40);
    let t42 = circuit_sub(t41, t31);
    let t43 = circuit_sub(t42, in2);
    let t44 = circuit_sub(t39, in1);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t43, t45);
    let t47 = circuit_mul(t46, t46);
    let t48 = circuit_sub(t47, t39);
    let t49 = circuit_sub(t48, in1);
    let t50 = circuit_sub(t39, t49);
    let t51 = circuit_mul(t46, t50);
    let t52 = circuit_sub(t51, t42);
    let t53 = circuit_mul(t49, t49);
    let t54 = circuit_mul(in0, t53);
    let t55 = circuit_add(t52, t52);
    let t56 = circuit_inverse(t55);
    let t57 = circuit_mul(t54, t56);
    let t58 = circuit_mul(t57, t57);
    let t59 = circuit_sub(t58, t49);
    let t60 = circuit_sub(t59, t49);
    let t61 = circuit_sub(t49, t60);
    let t62 = circuit_mul(t57, t61);
    let t63 = circuit_sub(t62, t52);
    let t64 = circuit_mul(t60, t60);
    let t65 = circuit_mul(in0, t64);
    let t66 = circuit_add(t63, t63);
    let t67 = circuit_inverse(t66);
    let t68 = circuit_mul(t65, t67);
    let t69 = circuit_mul(t68, t68);
    let t70 = circuit_sub(t69, t60);
    let t71 = circuit_sub(t70, t60);
    let t72 = circuit_sub(t60, t71);
    let t73 = circuit_mul(t68, t72);
    let t74 = circuit_sub(t73, t63);
    let t75 = circuit_mul(t71, t71);
    let t76 = circuit_mul(in0, t75);
    let t77 = circuit_add(t74, t74);
    let t78 = circuit_inverse(t77);
    let t79 = circuit_mul(t76, t78);
    let t80 = circuit_mul(t79, t79);
    let t81 = circuit_sub(t80, t71);
    let t82 = circuit_sub(t81, t71);
    let t83 = circuit_sub(t71, t82);
    let t84 = circuit_mul(t79, t83);
    let t85 = circuit_sub(t84, t74);
    let t86 = circuit_sub(t85, in2);
    let t87 = circuit_sub(t82, in1);
    let t88 = circuit_inverse(t87);
    let t89 = circuit_mul(t86, t88);
    let t90 = circuit_mul(t89, t89);
    let t91 = circuit_sub(t90, t82);
    let t92 = circuit_sub(t91, in1);
    let t93 = circuit_sub(t82, t92);
    let t94 = circuit_mul(t89, t93);
    let t95 = circuit_sub(t94, t85);
    let t96 = circuit_mul(t92, t92);
    let t97 = circuit_mul(in0, t96);
    let t98 = circuit_add(t95, t95);
    let t99 = circuit_inverse(t98);
    let t100 = circuit_mul(t97, t99);
    let t101 = circuit_mul(t100, t100);
    let t102 = circuit_sub(t101, t92);
    let t103 = circuit_sub(t102, t92);
    let t104 = circuit_sub(t92, t103);
    let t105 = circuit_mul(t100, t104);
    let t106 = circuit_sub(t105, t95);
    let t107 = circuit_mul(t103, t103);
    let t108 = circuit_mul(in0, t107);
    let t109 = circuit_add(t106, t106);
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t108, t110);
    let t112 = circuit_mul(t111, t111);
    let t113 = circuit_sub(t112, t103);
    let t114 = circuit_sub(t113, t103);
    let t115 = circuit_sub(t103, t114);
    let t116 = circuit_mul(t111, t115);
    let t117 = circuit_sub(t116, t106);
    let t118 = circuit_mul(t114, t114);
    let t119 = circuit_mul(in0, t118);
    let t120 = circuit_add(t117, t117);
    let t121 = circuit_inverse(t120);
    let t122 = circuit_mul(t119, t121);
    let t123 = circuit_mul(t122, t122);
    let t124 = circuit_sub(t123, t114);
    let t125 = circuit_sub(t124, t114);
    let t126 = circuit_sub(t114, t125);
    let t127 = circuit_mul(t122, t126);
    let t128 = circuit_sub(t127, t117);
    let t129 = circuit_mul(t125, t125);
    let t130 = circuit_mul(in0, t129);
    let t131 = circuit_add(t128, t128);
    let t132 = circuit_inverse(t131);
    let t133 = circuit_mul(t130, t132);
    let t134 = circuit_mul(t133, t133);
    let t135 = circuit_sub(t134, t125);
    let t136 = circuit_sub(t135, t125);
    let t137 = circuit_sub(t125, t136);
    let t138 = circuit_mul(t133, t137);
    let t139 = circuit_sub(t138, t128);
    let t140 = circuit_mul(t136, t136);
    let t141 = circuit_mul(in0, t140);
    let t142 = circuit_add(t139, t139);
    let t143 = circuit_inverse(t142);
    let t144 = circuit_mul(t141, t143);
    let t145 = circuit_mul(t144, t144);
    let t146 = circuit_sub(t145, t136);
    let t147 = circuit_sub(t146, t136);
    let t148 = circuit_sub(t136, t147);
    let t149 = circuit_mul(t144, t148);
    let t150 = circuit_sub(t149, t139);
    let t151 = circuit_mul(t147, t147);
    let t152 = circuit_mul(in0, t151);
    let t153 = circuit_add(t150, t150);
    let t154 = circuit_inverse(t153);
    let t155 = circuit_mul(t152, t154);
    let t156 = circuit_mul(t155, t155);
    let t157 = circuit_sub(t156, t147);
    let t158 = circuit_sub(t157, t147);
    let t159 = circuit_sub(t147, t158);
    let t160 = circuit_mul(t155, t159);
    let t161 = circuit_sub(t160, t150);
    let t162 = circuit_mul(t158, t158);
    let t163 = circuit_mul(in0, t162);
    let t164 = circuit_add(t161, t161);
    let t165 = circuit_inverse(t164);
    let t166 = circuit_mul(t163, t165);
    let t167 = circuit_mul(t166, t166);
    let t168 = circuit_sub(t167, t158);
    let t169 = circuit_sub(t168, t158);
    let t170 = circuit_sub(t158, t169);
    let t171 = circuit_mul(t166, t170);
    let t172 = circuit_sub(t171, t161);
    let t173 = circuit_mul(t169, t169);
    let t174 = circuit_mul(in0, t173);
    let t175 = circuit_add(t172, t172);
    let t176 = circuit_inverse(t175);
    let t177 = circuit_mul(t174, t176);
    let t178 = circuit_mul(t177, t177);
    let t179 = circuit_sub(t178, t169);
    let t180 = circuit_sub(t179, t169);
    let t181 = circuit_sub(t169, t180);
    let t182 = circuit_mul(t177, t181);
    let t183 = circuit_sub(t182, t172);
    let t184 = circuit_mul(t180, t180);
    let t185 = circuit_mul(in0, t184);
    let t186 = circuit_add(t183, t183);
    let t187 = circuit_inverse(t186);
    let t188 = circuit_mul(t185, t187);
    let t189 = circuit_mul(t188, t188);
    let t190 = circuit_sub(t189, t180);
    let t191 = circuit_sub(t190, t180);
    let t192 = circuit_sub(t180, t191);
    let t193 = circuit_mul(t188, t192);
    let t194 = circuit_sub(t193, t183);
    let t195 = circuit_sub(t194, in2);
    let t196 = circuit_sub(t191, in1);
    let t197 = circuit_inverse(t196);
    let t198 = circuit_mul(t195, t197);
    let t199 = circuit_mul(t198, t198);
    let t200 = circuit_sub(t199, t191);
    let t201 = circuit_sub(t200, in1);
    let t202 = circuit_sub(t191, t201);
    let t203 = circuit_mul(t198, t202);
    let t204 = circuit_sub(t203, t194);
    let t205 = circuit_mul(t201, t201);
    let t206 = circuit_mul(in0, t205);
    let t207 = circuit_add(t204, t204);
    let t208 = circuit_inverse(t207);
    let t209 = circuit_mul(t206, t208);
    let t210 = circuit_mul(t209, t209);
    let t211 = circuit_sub(t210, t201);
    let t212 = circuit_sub(t211, t201);
    let t213 = circuit_sub(t201, t212);
    let t214 = circuit_mul(t209, t213);
    let t215 = circuit_sub(t214, t204);
    let t216 = circuit_mul(t212, t212);
    let t217 = circuit_mul(in0, t216);
    let t218 = circuit_add(t215, t215);
    let t219 = circuit_inverse(t218);
    let t220 = circuit_mul(t217, t219);
    let t221 = circuit_mul(t220, t220);
    let t222 = circuit_sub(t221, t212);
    let t223 = circuit_sub(t222, t212);
    let t224 = circuit_sub(t212, t223);
    let t225 = circuit_mul(t220, t224);
    let t226 = circuit_sub(t225, t215);
    let t227 = circuit_mul(t223, t223);
    let t228 = circuit_mul(in0, t227);
    let t229 = circuit_add(t226, t226);
    let t230 = circuit_inverse(t229);
    let t231 = circuit_mul(t228, t230);
    let t232 = circuit_mul(t231, t231);
    let t233 = circuit_sub(t232, t223);
    let t234 = circuit_sub(t233, t223);
    let t235 = circuit_sub(t223, t234);
    let t236 = circuit_mul(t231, t235);
    let t237 = circuit_sub(t236, t226);
    let t238 = circuit_mul(t234, t234);
    let t239 = circuit_mul(in0, t238);
    let t240 = circuit_add(t237, t237);
    let t241 = circuit_inverse(t240);
    let t242 = circuit_mul(t239, t241);
    let t243 = circuit_mul(t242, t242);
    let t244 = circuit_sub(t243, t234);
    let t245 = circuit_sub(t244, t234);
    let t246 = circuit_sub(t234, t245);
    let t247 = circuit_mul(t242, t246);
    let t248 = circuit_sub(t247, t237);
    let t249 = circuit_mul(t245, t245);
    let t250 = circuit_mul(in0, t249);
    let t251 = circuit_add(t248, t248);
    let t252 = circuit_inverse(t251);
    let t253 = circuit_mul(t250, t252);
    let t254 = circuit_mul(t253, t253);
    let t255 = circuit_sub(t254, t245);
    let t256 = circuit_sub(t255, t245);
    let t257 = circuit_sub(t245, t256);
    let t258 = circuit_mul(t253, t257);
    let t259 = circuit_sub(t258, t248);
    let t260 = circuit_mul(t256, t256);
    let t261 = circuit_mul(in0, t260);
    let t262 = circuit_add(t259, t259);
    let t263 = circuit_inverse(t262);
    let t264 = circuit_mul(t261, t263);
    let t265 = circuit_mul(t264, t264);
    let t266 = circuit_sub(t265, t256);
    let t267 = circuit_sub(t266, t256);
    let t268 = circuit_sub(t256, t267);
    let t269 = circuit_mul(t264, t268);
    let t270 = circuit_sub(t269, t259);
    let t271 = circuit_mul(t267, t267);
    let t272 = circuit_mul(in0, t271);
    let t273 = circuit_add(t270, t270);
    let t274 = circuit_inverse(t273);
    let t275 = circuit_mul(t272, t274);
    let t276 = circuit_mul(t275, t275);
    let t277 = circuit_sub(t276, t267);
    let t278 = circuit_sub(t277, t267);
    let t279 = circuit_sub(t267, t278);
    let t280 = circuit_mul(t275, t279);
    let t281 = circuit_sub(t280, t270);
    let t282 = circuit_mul(t278, t278);
    let t283 = circuit_mul(in0, t282);
    let t284 = circuit_add(t281, t281);
    let t285 = circuit_inverse(t284);
    let t286 = circuit_mul(t283, t285);
    let t287 = circuit_mul(t286, t286);
    let t288 = circuit_sub(t287, t278);
    let t289 = circuit_sub(t288, t278);
    let t290 = circuit_sub(t278, t289);
    let t291 = circuit_mul(t286, t290);
    let t292 = circuit_sub(t291, t281);
    let t293 = circuit_mul(t289, t289);
    let t294 = circuit_mul(in0, t293);
    let t295 = circuit_add(t292, t292);
    let t296 = circuit_inverse(t295);
    let t297 = circuit_mul(t294, t296);
    let t298 = circuit_mul(t297, t297);
    let t299 = circuit_sub(t298, t289);
    let t300 = circuit_sub(t299, t289);
    let t301 = circuit_sub(t289, t300);
    let t302 = circuit_mul(t297, t301);
    let t303 = circuit_sub(t302, t292);
    let t304 = circuit_mul(t300, t300);
    let t305 = circuit_mul(in0, t304);
    let t306 = circuit_add(t303, t303);
    let t307 = circuit_inverse(t306);
    let t308 = circuit_mul(t305, t307);
    let t309 = circuit_mul(t308, t308);
    let t310 = circuit_sub(t309, t300);
    let t311 = circuit_sub(t310, t300);
    let t312 = circuit_sub(t300, t311);
    let t313 = circuit_mul(t308, t312);
    let t314 = circuit_sub(t313, t303);
    let t315 = circuit_mul(t311, t311);
    let t316 = circuit_mul(in0, t315);
    let t317 = circuit_add(t314, t314);
    let t318 = circuit_inverse(t317);
    let t319 = circuit_mul(t316, t318);
    let t320 = circuit_mul(t319, t319);
    let t321 = circuit_sub(t320, t311);
    let t322 = circuit_sub(t321, t311);
    let t323 = circuit_sub(t311, t322);
    let t324 = circuit_mul(t319, t323);
    let t325 = circuit_sub(t324, t314);
    let t326 = circuit_mul(t322, t322);
    let t327 = circuit_mul(in0, t326);
    let t328 = circuit_add(t325, t325);
    let t329 = circuit_inverse(t328);
    let t330 = circuit_mul(t327, t329);
    let t331 = circuit_mul(t330, t330);
    let t332 = circuit_sub(t331, t322);
    let t333 = circuit_sub(t332, t322);
    let t334 = circuit_sub(t322, t333);
    let t335 = circuit_mul(t330, t334);
    let t336 = circuit_sub(t335, t325);
    let t337 = circuit_mul(t333, t333);
    let t338 = circuit_mul(in0, t337);
    let t339 = circuit_add(t336, t336);
    let t340 = circuit_inverse(t339);
    let t341 = circuit_mul(t338, t340);
    let t342 = circuit_mul(t341, t341);
    let t343 = circuit_sub(t342, t333);
    let t344 = circuit_sub(t343, t333);
    let t345 = circuit_sub(t333, t344);
    let t346 = circuit_mul(t341, t345);
    let t347 = circuit_sub(t346, t336);
    let t348 = circuit_mul(t344, t344);
    let t349 = circuit_mul(in0, t348);
    let t350 = circuit_add(t347, t347);
    let t351 = circuit_inverse(t350);
    let t352 = circuit_mul(t349, t351);
    let t353 = circuit_mul(t352, t352);
    let t354 = circuit_sub(t353, t344);
    let t355 = circuit_sub(t354, t344);
    let t356 = circuit_sub(t344, t355);
    let t357 = circuit_mul(t352, t356);
    let t358 = circuit_sub(t357, t347);
    let t359 = circuit_mul(t355, t355);
    let t360 = circuit_mul(in0, t359);
    let t361 = circuit_add(t358, t358);
    let t362 = circuit_inverse(t361);
    let t363 = circuit_mul(t360, t362);
    let t364 = circuit_mul(t363, t363);
    let t365 = circuit_sub(t364, t355);
    let t366 = circuit_sub(t365, t355);
    let t367 = circuit_sub(t355, t366);
    let t368 = circuit_mul(t363, t367);
    let t369 = circuit_sub(t368, t358);
    let t370 = circuit_mul(t366, t366);
    let t371 = circuit_mul(in0, t370);
    let t372 = circuit_add(t369, t369);
    let t373 = circuit_inverse(t372);
    let t374 = circuit_mul(t371, t373);
    let t375 = circuit_mul(t374, t374);
    let t376 = circuit_sub(t375, t366);
    let t377 = circuit_sub(t376, t366);
    let t378 = circuit_sub(t366, t377);
    let t379 = circuit_mul(t374, t378);
    let t380 = circuit_sub(t379, t369);
    let t381 = circuit_mul(t377, t377);
    let t382 = circuit_mul(in0, t381);
    let t383 = circuit_add(t380, t380);
    let t384 = circuit_inverse(t383);
    let t385 = circuit_mul(t382, t384);
    let t386 = circuit_mul(t385, t385);
    let t387 = circuit_sub(t386, t377);
    let t388 = circuit_sub(t387, t377);
    let t389 = circuit_sub(t377, t388);
    let t390 = circuit_mul(t385, t389);
    let t391 = circuit_sub(t390, t380);
    let t392 = circuit_mul(t388, t388);
    let t393 = circuit_mul(in0, t392);
    let t394 = circuit_add(t391, t391);
    let t395 = circuit_inverse(t394);
    let t396 = circuit_mul(t393, t395);
    let t397 = circuit_mul(t396, t396);
    let t398 = circuit_sub(t397, t388);
    let t399 = circuit_sub(t398, t388);
    let t400 = circuit_sub(t388, t399);
    let t401 = circuit_mul(t396, t400);
    let t402 = circuit_sub(t401, t391);
    let t403 = circuit_mul(t399, t399);
    let t404 = circuit_mul(in0, t403);
    let t405 = circuit_add(t402, t402);
    let t406 = circuit_inverse(t405);
    let t407 = circuit_mul(t404, t406);
    let t408 = circuit_mul(t407, t407);
    let t409 = circuit_sub(t408, t399);
    let t410 = circuit_sub(t409, t399);
    let t411 = circuit_sub(t399, t410);
    let t412 = circuit_mul(t407, t411);
    let t413 = circuit_sub(t412, t402);
    let t414 = circuit_mul(t410, t410);
    let t415 = circuit_mul(in0, t414);
    let t416 = circuit_add(t413, t413);
    let t417 = circuit_inverse(t416);
    let t418 = circuit_mul(t415, t417);
    let t419 = circuit_mul(t418, t418);
    let t420 = circuit_sub(t419, t410);
    let t421 = circuit_sub(t420, t410);
    let t422 = circuit_sub(t410, t421);
    let t423 = circuit_mul(t418, t422);
    let t424 = circuit_sub(t423, t413);
    let t425 = circuit_mul(t421, t421);
    let t426 = circuit_mul(in0, t425);
    let t427 = circuit_add(t424, t424);
    let t428 = circuit_inverse(t427);
    let t429 = circuit_mul(t426, t428);
    let t430 = circuit_mul(t429, t429);
    let t431 = circuit_sub(t430, t421);
    let t432 = circuit_sub(t431, t421);
    let t433 = circuit_sub(t421, t432);
    let t434 = circuit_mul(t429, t433);
    let t435 = circuit_sub(t434, t424);
    let t436 = circuit_mul(t432, t432);
    let t437 = circuit_mul(in0, t436);
    let t438 = circuit_add(t435, t435);
    let t439 = circuit_inverse(t438);
    let t440 = circuit_mul(t437, t439);
    let t441 = circuit_mul(t440, t440);
    let t442 = circuit_sub(t441, t432);
    let t443 = circuit_sub(t442, t432);
    let t444 = circuit_sub(t432, t443);
    let t445 = circuit_mul(t440, t444);
    let t446 = circuit_sub(t445, t435);
    let t447 = circuit_mul(t443, t443);
    let t448 = circuit_mul(in0, t447);
    let t449 = circuit_add(t446, t446);
    let t450 = circuit_inverse(t449);
    let t451 = circuit_mul(t448, t450);
    let t452 = circuit_mul(t451, t451);
    let t453 = circuit_sub(t452, t443);
    let t454 = circuit_sub(t453, t443);
    let t455 = circuit_sub(t443, t454);
    let t456 = circuit_mul(t451, t455);
    let t457 = circuit_sub(t456, t446);
    let t458 = circuit_mul(t454, t454);
    let t459 = circuit_mul(in0, t458);
    let t460 = circuit_add(t457, t457);
    let t461 = circuit_inverse(t460);
    let t462 = circuit_mul(t459, t461);
    let t463 = circuit_mul(t462, t462);
    let t464 = circuit_sub(t463, t454);
    let t465 = circuit_sub(t464, t454);
    let t466 = circuit_sub(t454, t465);
    let t467 = circuit_mul(t462, t466);
    let t468 = circuit_sub(t467, t457);
    let t469 = circuit_mul(t465, t465);
    let t470 = circuit_mul(in0, t469);
    let t471 = circuit_add(t468, t468);
    let t472 = circuit_inverse(t471);
    let t473 = circuit_mul(t470, t472);
    let t474 = circuit_mul(t473, t473);
    let t475 = circuit_sub(t474, t465);
    let t476 = circuit_sub(t475, t465);
    let t477 = circuit_sub(t465, t476);
    let t478 = circuit_mul(t473, t477);
    let t479 = circuit_sub(t478, t468);
    let t480 = circuit_mul(t476, t476);
    let t481 = circuit_mul(in0, t480);
    let t482 = circuit_add(t479, t479);
    let t483 = circuit_inverse(t482);
    let t484 = circuit_mul(t481, t483);
    let t485 = circuit_mul(t484, t484);
    let t486 = circuit_sub(t485, t476);
    let t487 = circuit_sub(t486, t476);
    let t488 = circuit_sub(t476, t487);
    let t489 = circuit_mul(t484, t488);
    let t490 = circuit_sub(t489, t479);
    let t491 = circuit_mul(t487, t487);
    let t492 = circuit_mul(in0, t491);
    let t493 = circuit_add(t490, t490);
    let t494 = circuit_inverse(t493);
    let t495 = circuit_mul(t492, t494);
    let t496 = circuit_mul(t495, t495);
    let t497 = circuit_sub(t496, t487);
    let t498 = circuit_sub(t497, t487);
    let t499 = circuit_sub(t487, t498);
    let t500 = circuit_mul(t495, t499);
    let t501 = circuit_sub(t500, t490);
    let t502 = circuit_mul(t498, t498);
    let t503 = circuit_mul(in0, t502);
    let t504 = circuit_add(t501, t501);
    let t505 = circuit_inverse(t504);
    let t506 = circuit_mul(t503, t505);
    let t507 = circuit_mul(t506, t506);
    let t508 = circuit_sub(t507, t498);
    let t509 = circuit_sub(t508, t498);
    let t510 = circuit_sub(t498, t509);
    let t511 = circuit_mul(t506, t510);
    let t512 = circuit_sub(t511, t501);
    let t513 = circuit_mul(t509, t509);
    let t514 = circuit_mul(in0, t513);
    let t515 = circuit_add(t512, t512);
    let t516 = circuit_inverse(t515);
    let t517 = circuit_mul(t514, t516);
    let t518 = circuit_mul(t517, t517);
    let t519 = circuit_sub(t518, t509);
    let t520 = circuit_sub(t519, t509);
    let t521 = circuit_sub(t509, t520);
    let t522 = circuit_mul(t517, t521);
    let t523 = circuit_sub(t522, t512);
    let t524 = circuit_mul(t520, t520);
    let t525 = circuit_mul(in0, t524);
    let t526 = circuit_add(t523, t523);
    let t527 = circuit_inverse(t526);
    let t528 = circuit_mul(t525, t527);
    let t529 = circuit_mul(t528, t528);
    let t530 = circuit_sub(t529, t520);
    let t531 = circuit_sub(t530, t520);
    let t532 = circuit_sub(t520, t531);
    let t533 = circuit_mul(t528, t532);
    let t534 = circuit_sub(t533, t523);
    let t535 = circuit_mul(t531, t531);
    let t536 = circuit_mul(in0, t535);
    let t537 = circuit_add(t534, t534);
    let t538 = circuit_inverse(t537);
    let t539 = circuit_mul(t536, t538);
    let t540 = circuit_mul(t539, t539);
    let t541 = circuit_sub(t540, t531);
    let t542 = circuit_sub(t541, t531);
    let t543 = circuit_sub(t531, t542);
    let t544 = circuit_mul(t539, t543);
    let t545 = circuit_sub(t544, t534);
    let t546 = circuit_mul(t542, t542);
    let t547 = circuit_mul(in0, t546);
    let t548 = circuit_add(t545, t545);
    let t549 = circuit_inverse(t548);
    let t550 = circuit_mul(t547, t549);
    let t551 = circuit_mul(t550, t550);
    let t552 = circuit_sub(t551, t542);
    let t553 = circuit_sub(t552, t542);
    let t554 = circuit_sub(t542, t553);
    let t555 = circuit_mul(t550, t554);
    let t556 = circuit_sub(t555, t545);
    let t557 = circuit_sub(t556, in2);
    let t558 = circuit_sub(t553, in1);
    let t559 = circuit_inverse(t558);
    let t560 = circuit_mul(t557, t559);
    let t561 = circuit_mul(t560, t560);
    let t562 = circuit_sub(t561, t553);
    let t563 = circuit_sub(t562, in1);
    let t564 = circuit_sub(t553, t563);
    let t565 = circuit_mul(t560, t564);
    let t566 = circuit_sub(t565, t556);
    let t567 = circuit_mul(t563, t563);
    let t568 = circuit_mul(in0, t567);
    let t569 = circuit_add(t566, t566);
    let t570 = circuit_inverse(t569);
    let t571 = circuit_mul(t568, t570);
    let t572 = circuit_mul(t571, t571);
    let t573 = circuit_sub(t572, t563);
    let t574 = circuit_sub(t573, t563);
    let t575 = circuit_sub(t563, t574);
    let t576 = circuit_mul(t571, t575);
    let t577 = circuit_sub(t576, t566);
    let t578 = circuit_mul(t574, t574);
    let t579 = circuit_mul(in0, t578);
    let t580 = circuit_add(t577, t577);
    let t581 = circuit_inverse(t580);
    let t582 = circuit_mul(t579, t581);
    let t583 = circuit_mul(t582, t582);
    let t584 = circuit_sub(t583, t574);
    let t585 = circuit_sub(t584, t574);
    let t586 = circuit_sub(t574, t585);
    let t587 = circuit_mul(t582, t586);
    let t588 = circuit_sub(t587, t577);
    let t589 = circuit_mul(t585, t585);
    let t590 = circuit_mul(in0, t589);
    let t591 = circuit_add(t588, t588);
    let t592 = circuit_inverse(t591);
    let t593 = circuit_mul(t590, t592);
    let t594 = circuit_mul(t593, t593);
    let t595 = circuit_sub(t594, t585);
    let t596 = circuit_sub(t595, t585);
    let t597 = circuit_sub(t585, t596);
    let t598 = circuit_mul(t593, t597);
    let t599 = circuit_sub(t598, t588);
    let t600 = circuit_mul(t596, t596);
    let t601 = circuit_mul(in0, t600);
    let t602 = circuit_add(t599, t599);
    let t603 = circuit_inverse(t602);
    let t604 = circuit_mul(t601, t603);
    let t605 = circuit_mul(t604, t604);
    let t606 = circuit_sub(t605, t596);
    let t607 = circuit_sub(t606, t596);
    let t608 = circuit_sub(t596, t607);
    let t609 = circuit_mul(t604, t608);
    let t610 = circuit_sub(t609, t599);
    let t611 = circuit_mul(t607, t607);
    let t612 = circuit_mul(in0, t611);
    let t613 = circuit_add(t610, t610);
    let t614 = circuit_inverse(t613);
    let t615 = circuit_mul(t612, t614);
    let t616 = circuit_mul(t615, t615);
    let t617 = circuit_sub(t616, t607);
    let t618 = circuit_sub(t617, t607);
    let t619 = circuit_sub(t607, t618);
    let t620 = circuit_mul(t615, t619);
    let t621 = circuit_sub(t620, t610);
    let t622 = circuit_mul(t618, t618);
    let t623 = circuit_mul(in0, t622);
    let t624 = circuit_add(t621, t621);
    let t625 = circuit_inverse(t624);
    let t626 = circuit_mul(t623, t625);
    let t627 = circuit_mul(t626, t626);
    let t628 = circuit_sub(t627, t618);
    let t629 = circuit_sub(t628, t618);
    let t630 = circuit_sub(t618, t629);
    let t631 = circuit_mul(t626, t630);
    let t632 = circuit_sub(t631, t621);
    let t633 = circuit_mul(t629, t629);
    let t634 = circuit_mul(in0, t633);
    let t635 = circuit_add(t632, t632);
    let t636 = circuit_inverse(t635);
    let t637 = circuit_mul(t634, t636);
    let t638 = circuit_mul(t637, t637);
    let t639 = circuit_sub(t638, t629);
    let t640 = circuit_sub(t639, t629);
    let t641 = circuit_sub(t629, t640);
    let t642 = circuit_mul(t637, t641);
    let t643 = circuit_sub(t642, t632);
    let t644 = circuit_mul(t640, t640);
    let t645 = circuit_mul(in0, t644);
    let t646 = circuit_add(t643, t643);
    let t647 = circuit_inverse(t646);
    let t648 = circuit_mul(t645, t647);
    let t649 = circuit_mul(t648, t648);
    let t650 = circuit_sub(t649, t640);
    let t651 = circuit_sub(t650, t640);
    let t652 = circuit_sub(t640, t651);
    let t653 = circuit_mul(t648, t652);
    let t654 = circuit_sub(t653, t643);
    let t655 = circuit_mul(t651, t651);
    let t656 = circuit_mul(in0, t655);
    let t657 = circuit_add(t654, t654);
    let t658 = circuit_inverse(t657);
    let t659 = circuit_mul(t656, t658);
    let t660 = circuit_mul(t659, t659);
    let t661 = circuit_sub(t660, t651);
    let t662 = circuit_sub(t661, t651);
    let t663 = circuit_sub(t651, t662);
    let t664 = circuit_mul(t659, t663);
    let t665 = circuit_sub(t664, t654);
    let t666 = circuit_mul(t662, t662);
    let t667 = circuit_mul(in0, t666);
    let t668 = circuit_add(t665, t665);
    let t669 = circuit_inverse(t668);
    let t670 = circuit_mul(t667, t669);
    let t671 = circuit_mul(t670, t670);
    let t672 = circuit_sub(t671, t662);
    let t673 = circuit_sub(t672, t662);
    let t674 = circuit_sub(t662, t673);
    let t675 = circuit_mul(t670, t674);
    let t676 = circuit_sub(t675, t665);
    let t677 = circuit_mul(t673, t673);
    let t678 = circuit_mul(in0, t677);
    let t679 = circuit_add(t676, t676);
    let t680 = circuit_inverse(t679);
    let t681 = circuit_mul(t678, t680);
    let t682 = circuit_mul(t681, t681);
    let t683 = circuit_sub(t682, t673);
    let t684 = circuit_sub(t683, t673);
    let t685 = circuit_sub(t673, t684);
    let t686 = circuit_mul(t681, t685);
    let t687 = circuit_sub(t686, t676);
    let t688 = circuit_mul(t684, t684);
    let t689 = circuit_mul(in0, t688);
    let t690 = circuit_add(t687, t687);
    let t691 = circuit_inverse(t690);
    let t692 = circuit_mul(t689, t691);
    let t693 = circuit_mul(t692, t692);
    let t694 = circuit_sub(t693, t684);
    let t695 = circuit_sub(t694, t684);
    let t696 = circuit_sub(t684, t695);
    let t697 = circuit_mul(t692, t696);
    let t698 = circuit_sub(t697, t687);
    let t699 = circuit_mul(t695, t695);
    let t700 = circuit_mul(in0, t699);
    let t701 = circuit_add(t698, t698);
    let t702 = circuit_inverse(t701);
    let t703 = circuit_mul(t700, t702);
    let t704 = circuit_mul(t703, t703);
    let t705 = circuit_sub(t704, t695);
    let t706 = circuit_sub(t705, t695);
    let t707 = circuit_sub(t695, t706);
    let t708 = circuit_mul(t703, t707);
    let t709 = circuit_sub(t708, t698);
    let t710 = circuit_mul(t706, t706);
    let t711 = circuit_mul(in0, t710);
    let t712 = circuit_add(t709, t709);
    let t713 = circuit_inverse(t712);
    let t714 = circuit_mul(t711, t713);
    let t715 = circuit_mul(t714, t714);
    let t716 = circuit_sub(t715, t706);
    let t717 = circuit_sub(t716, t706);
    let t718 = circuit_sub(t706, t717);
    let t719 = circuit_mul(t714, t718);
    let t720 = circuit_sub(t719, t709);
    let t721 = circuit_mul(t717, t717);
    let t722 = circuit_mul(in0, t721);
    let t723 = circuit_add(t720, t720);
    let t724 = circuit_inverse(t723);
    let t725 = circuit_mul(t722, t724);
    let t726 = circuit_mul(t725, t725);
    let t727 = circuit_sub(t726, t717);
    let t728 = circuit_sub(t727, t717);
    let t729 = circuit_sub(t717, t728);
    let t730 = circuit_mul(t725, t729);
    let t731 = circuit_sub(t730, t720);
    let t732 = circuit_mul(t728, t728);
    let t733 = circuit_mul(in0, t732);
    let t734 = circuit_add(t731, t731);
    let t735 = circuit_inverse(t734);
    let t736 = circuit_mul(t733, t735);
    let t737 = circuit_mul(t736, t736);
    let t738 = circuit_sub(t737, t728);
    let t739 = circuit_sub(t738, t728);
    let t740 = circuit_sub(t728, t739);
    let t741 = circuit_mul(t736, t740);
    let t742 = circuit_sub(t741, t731);
    let t743 = circuit_sub(in2, t742);
    let t744 = circuit_sub(in1, t739);
    let t745 = circuit_inverse(t744);
    let t746 = circuit_mul(t743, t745);
    let t747 = circuit_mul(t746, t746);
    let t748 = circuit_sub(t747, in1);
    let t749 = circuit_sub(t748, t739);
    let t750 = circuit_sub(in1, t749);
    let t751 = circuit_mul(t746, t750);
    let t752 = circuit_sub(t751, in2);

    let modulus = modulus;

    let mut circuit_inputs = (t749, t752).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(P.x); // in1
    circuit_inputs = circuit_inputs.next_2(P.y); // in2

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: G1Point = G1Point { x: outputs.get_output(t749), y: outputs.get_output(t752) };
    return (res,);
}
#[inline(always)]
pub fn run_DOUBLE_AND_ADD_EC_POINTS_G2_circuit(
    p: G2Point, q: G2Point, modulus: core::circuit::CircuitModulus,
) -> (G2Point,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let t0 = circuit_sub(in7, in3); // Fp2 sub coeff 0/1
    let t1 = circuit_sub(in8, in4); // Fp2 sub coeff 1/1
    let t2 = circuit_sub(in5, in1); // Fp2 sub coeff 0/1
    let t3 = circuit_sub(in6, in2); // Fp2 sub coeff 1/1
    let t4 = circuit_mul(t2, t2); // Fp2 Inv start
    let t5 = circuit_mul(t3, t3);
    let t6 = circuit_add(t4, t5);
    let t7 = circuit_inverse(t6);
    let t8 = circuit_mul(t2, t7); // Fp2 Inv real part end
    let t9 = circuit_mul(t3, t7);
    let t10 = circuit_sub(in0, t9); // Fp2 Inv imag part end
    let t11 = circuit_mul(t0, t8); // Fp2 mul start
    let t12 = circuit_mul(t1, t10);
    let t13 = circuit_sub(t11, t12); // Fp2 mul real part end
    let t14 = circuit_mul(t0, t10);
    let t15 = circuit_mul(t1, t8);
    let t16 = circuit_add(t14, t15); // Fp2 mul imag part end
    let t17 = circuit_add(t13, t16);
    let t18 = circuit_sub(t13, t16);
    let t19 = circuit_mul(t17, t18);
    let t20 = circuit_mul(t13, t16);
    let t21 = circuit_add(t20, t20);
    let t22 = circuit_add(in1, in5); // Fp2 add coeff 0/1
    let t23 = circuit_add(in2, in6); // Fp2 add coeff 1/1
    let t24 = circuit_sub(t19, t22); // Fp2 sub coeff 0/1
    let t25 = circuit_sub(t21, t23); // Fp2 sub coeff 1/1
    let t26 = circuit_add(in3, in3); // Fp2 add coeff 0/1
    let t27 = circuit_add(in4, in4); // Fp2 add coeff 1/1
    let t28 = circuit_sub(t24, in1); // Fp2 sub coeff 0/1
    let t29 = circuit_sub(t25, in2); // Fp2 sub coeff 1/1
    let t30 = circuit_mul(t28, t28); // Fp2 Inv start
    let t31 = circuit_mul(t29, t29);
    let t32 = circuit_add(t30, t31);
    let t33 = circuit_inverse(t32);
    let t34 = circuit_mul(t28, t33); // Fp2 Inv real part end
    let t35 = circuit_mul(t29, t33);
    let t36 = circuit_sub(in0, t35); // Fp2 Inv imag part end
    let t37 = circuit_mul(t26, t34); // Fp2 mul start
    let t38 = circuit_mul(t27, t36);
    let t39 = circuit_sub(t37, t38); // Fp2 mul real part end
    let t40 = circuit_mul(t26, t36);
    let t41 = circuit_mul(t27, t34);
    let t42 = circuit_add(t40, t41); // Fp2 mul imag part end
    let t43 = circuit_add(t13, t39); // Fp2 add coeff 0/1
    let t44 = circuit_add(t16, t42); // Fp2 add coeff 1/1
    let t45 = circuit_add(t43, t44);
    let t46 = circuit_sub(t43, t44);
    let t47 = circuit_mul(t45, t46);
    let t48 = circuit_mul(t43, t44);
    let t49 = circuit_add(t48, t48);
    let t50 = circuit_add(in1, t24); // Fp2 add coeff 0/1
    let t51 = circuit_add(in2, t25); // Fp2 add coeff 1/1
    let t52 = circuit_sub(t47, t50); // Fp2 sub coeff 0/1
    let t53 = circuit_sub(t49, t51); // Fp2 sub coeff 1/1
    let t54 = circuit_sub(t52, in1); // Fp2 sub coeff 0/1
    let t55 = circuit_sub(t53, in2); // Fp2 sub coeff 1/1
    let t56 = circuit_mul(t43, t54); // Fp2 mul start
    let t57 = circuit_mul(t44, t55);
    let t58 = circuit_sub(t56, t57); // Fp2 mul real part end
    let t59 = circuit_mul(t43, t55);
    let t60 = circuit_mul(t44, t54);
    let t61 = circuit_add(t59, t60); // Fp2 mul imag part end
    let t62 = circuit_sub(t58, in3); // Fp2 sub coeff 0/1
    let t63 = circuit_sub(t61, in4); // Fp2 sub coeff 1/1

    let modulus = modulus;

    let mut circuit_inputs = (t52, t53, t62, t63).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x0); // in1
    circuit_inputs = circuit_inputs.next_2(p.x1); // in2
    circuit_inputs = circuit_inputs.next_2(p.y0); // in3
    circuit_inputs = circuit_inputs.next_2(p.y1); // in4
    circuit_inputs = circuit_inputs.next_2(q.x0); // in5
    circuit_inputs = circuit_inputs.next_2(q.x1); // in6
    circuit_inputs = circuit_inputs.next_2(q.y0); // in7
    circuit_inputs = circuit_inputs.next_2(q.y1); // in8

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let result: G2Point = G2Point {
        x0: outputs.get_output(t52),
        x1: outputs.get_output(t53),
        y0: outputs.get_output(t62),
        y1: outputs.get_output(t63),
    };
    return (result,);
}
#[inline(always)]
pub fn run_DOUBLE_EC_POINT_G2_A_EQ_0_circuit(
    p: G2Point, modulus: core::circuit::CircuitModulus,
) -> (G2Point,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x0

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let in5 = CE::<CI<5>> {};
    let t0 = circuit_add(in2, in3);
    let t1 = circuit_sub(in2, in3);
    let t2 = circuit_mul(t0, t1);
    let t3 = circuit_mul(in2, in3);
    let t4 = circuit_add(t3, t3);
    let t5 = circuit_mul(t2, in0); // Fp2 scalar mul coeff 0/1
    let t6 = circuit_mul(t4, in0); // Fp2 scalar mul coeff 1/1
    let t7 = circuit_add(in4, in4); // Fp2 add coeff 0/1
    let t8 = circuit_add(in5, in5); // Fp2 add coeff 1/1
    let t9 = circuit_mul(t7, t7); // Fp2 Inv start
    let t10 = circuit_mul(t8, t8);
    let t11 = circuit_add(t9, t10);
    let t12 = circuit_inverse(t11);
    let t13 = circuit_mul(t7, t12); // Fp2 Inv real part end
    let t14 = circuit_mul(t8, t12);
    let t15 = circuit_sub(in1, t14); // Fp2 Inv imag part end
    let t16 = circuit_mul(t5, t13); // Fp2 mul start
    let t17 = circuit_mul(t6, t15);
    let t18 = circuit_sub(t16, t17); // Fp2 mul real part end
    let t19 = circuit_mul(t5, t15);
    let t20 = circuit_mul(t6, t13);
    let t21 = circuit_add(t19, t20); // Fp2 mul imag part end
    let t22 = circuit_add(t18, t21);
    let t23 = circuit_sub(t18, t21);
    let t24 = circuit_mul(t22, t23);
    let t25 = circuit_mul(t18, t21);
    let t26 = circuit_add(t25, t25);
    let t27 = circuit_sub(t24, in2); // Fp2 sub coeff 0/1
    let t28 = circuit_sub(t26, in3); // Fp2 sub coeff 1/1
    let t29 = circuit_sub(t27, in2); // Fp2 sub coeff 0/1
    let t30 = circuit_sub(t28, in3); // Fp2 sub coeff 1/1
    let t31 = circuit_sub(in2, t29); // Fp2 sub coeff 0/1
    let t32 = circuit_sub(in3, t30); // Fp2 sub coeff 1/1
    let t33 = circuit_mul(t18, t31); // Fp2 mul start
    let t34 = circuit_mul(t21, t32);
    let t35 = circuit_sub(t33, t34); // Fp2 mul real part end
    let t36 = circuit_mul(t18, t32);
    let t37 = circuit_mul(t21, t31);
    let t38 = circuit_add(t36, t37); // Fp2 mul imag part end
    let t39 = circuit_sub(t35, in4); // Fp2 sub coeff 0/1
    let t40 = circuit_sub(t38, in5); // Fp2 sub coeff 1/1

    let modulus = modulus;

    let mut circuit_inputs = (t29, t30, t39, t40).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x0); // in2
    circuit_inputs = circuit_inputs.next_2(p.x1); // in3
    circuit_inputs = circuit_inputs.next_2(p.y0); // in4
    circuit_inputs = circuit_inputs.next_2(p.y1); // in5

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let result: G2Point = G2Point {
        x0: outputs.get_output(t29),
        x1: outputs.get_output(t30),
        y0: outputs.get_output(t39),
        y1: outputs.get_output(t40),
    };
    return (result,);
}
#[inline(always)]
pub fn run_DOUBLE_EC_POINT_circuit(
    p: G1Point, A_weirstrass: u384, modulus: core::circuit::CircuitModulus,
) -> (G1Point,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_add(t1, in3);
    let t3 = circuit_add(in2, in2);
    let t4 = circuit_inverse(t3);
    let t5 = circuit_mul(t2, t4);
    let t6 = circuit_mul(t5, t5);
    let t7 = circuit_sub(t6, in1);
    let t8 = circuit_sub(t7, in1);
    let t9 = circuit_sub(in1, t8);
    let t10 = circuit_mul(t5, t9);
    let t11 = circuit_sub(t10, in2);

    let modulus = modulus;

    let mut circuit_inputs = (t8, t11).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in1
    circuit_inputs = circuit_inputs.next_2(p.y); // in2
    circuit_inputs = circuit_inputs.next_2(A_weirstrass); // in3

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let r: G1Point = G1Point { x: outputs.get_output(t8), y: outputs.get_output(t11) };
    return (r,);
}
#[inline(always)]
pub fn run_IS_ON_CURVE_G1_G2_circuit(
    p: G1Point, q: G2Point, a: u384, b: u384, b20: u384, b21: u384, curve_index: usize,
) -> (u384, u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let in9 = CE::<CI<9>> {};
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, in0);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_add(t2, in7);
    let t4 = circuit_add(in4, in5);
    let t5 = circuit_sub(in4, in5);
    let t6 = circuit_mul(t4, t5);
    let t7 = circuit_mul(in4, in5);
    let t8 = circuit_add(t7, t7);
    let t9 = circuit_add(in2, in3);
    let t10 = circuit_sub(in2, in3);
    let t11 = circuit_mul(t9, t10);
    let t12 = circuit_mul(in2, in3);
    let t13 = circuit_add(t12, t12);
    let t14 = circuit_mul(in2, t11); // Fp2 mul start
    let t15 = circuit_mul(in3, t13);
    let t16 = circuit_sub(t14, t15); // Fp2 mul real part end
    let t17 = circuit_mul(in2, t13);
    let t18 = circuit_mul(in3, t11);
    let t19 = circuit_add(t17, t18); // Fp2 mul imag part end
    let t20 = circuit_mul(in6, in2);
    let t21 = circuit_mul(in6, in3);
    let t22 = circuit_add(t20, in8);
    let t23 = circuit_add(t21, in9);
    let t24 = circuit_add(t16, t22);
    let t25 = circuit_add(t19, t23);
    let t26 = circuit_sub(t0, t3);
    let t27 = circuit_sub(t6, t24);
    let t28 = circuit_sub(t8, t25);

    let modulus = crate::definitions::get_modulus(curve_index);

    let mut circuit_inputs = (t26, t27, t28).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in0
    circuit_inputs = circuit_inputs.next_2(p.y); // in1
    circuit_inputs = circuit_inputs.next_2(q.x0); // in2
    circuit_inputs = circuit_inputs.next_2(q.x1); // in3
    circuit_inputs = circuit_inputs.next_2(q.y0); // in4
    circuit_inputs = circuit_inputs.next_2(q.y1); // in5
    circuit_inputs = circuit_inputs.next_2(a); // in6
    circuit_inputs = circuit_inputs.next_2(b); // in7
    circuit_inputs = circuit_inputs.next_2(b20); // in8
    circuit_inputs = circuit_inputs.next_2(b21); // in9

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zero_check_0: u384 = outputs.get_output(t26);
    let zero_check_1: u384 = outputs.get_output(t27);
    let zero_check_2: u384 = outputs.get_output(t28);
    return (zero_check_0, zero_check_1, zero_check_2);
}
#[inline(always)]
pub fn run_IS_ON_CURVE_G1_circuit(p: G1Point, a: u384, b: u384, curve_index: usize) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let in3 = CE::<CI<3>> {};
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, in0);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_mul(in2, in0);
    let t4 = circuit_add(t3, in3);
    let t5 = circuit_add(t2, t4);
    let t6 = circuit_sub(t0, t5);

    let modulus = crate::definitions::get_modulus(curve_index);

    let mut circuit_inputs = (t6,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in0
    circuit_inputs = circuit_inputs.next_2(p.y); // in1
    circuit_inputs = circuit_inputs.next_2(a); // in2
    circuit_inputs = circuit_inputs.next_2(b); // in3

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zero_check: u384 = outputs.get_output(t6);
    return (zero_check,);
}
#[inline(always)]
pub fn run_IS_ON_CURVE_G2_circuit(
    p: G2Point, a: u384, b20: u384, b21: u384, curve_index: usize,
) -> (u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let in6 = CE::<CI<6>> {};
    let t0 = circuit_add(in2, in3);
    let t1 = circuit_sub(in2, in3);
    let t2 = circuit_mul(t0, t1);
    let t3 = circuit_mul(in2, in3);
    let t4 = circuit_add(t3, t3);
    let t5 = circuit_add(in0, in1);
    let t6 = circuit_sub(in0, in1);
    let t7 = circuit_mul(t5, t6);
    let t8 = circuit_mul(in0, in1);
    let t9 = circuit_add(t8, t8);
    let t10 = circuit_mul(in0, t7); // Fp2 mul start
    let t11 = circuit_mul(in1, t9);
    let t12 = circuit_sub(t10, t11); // Fp2 mul real part end
    let t13 = circuit_mul(in0, t9);
    let t14 = circuit_mul(in1, t7);
    let t15 = circuit_add(t13, t14); // Fp2 mul imag part end
    let t16 = circuit_mul(in4, in0);
    let t17 = circuit_mul(in4, in1);
    let t18 = circuit_add(t16, in5);
    let t19 = circuit_add(t17, in6);
    let t20 = circuit_add(t12, t18);
    let t21 = circuit_add(t15, t19);
    let t22 = circuit_sub(t2, t20);
    let t23 = circuit_sub(t4, t21);

    let modulus = crate::definitions::get_modulus(curve_index);

    let mut circuit_inputs = (t22, t23).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x0); // in0
    circuit_inputs = circuit_inputs.next_2(p.x1); // in1
    circuit_inputs = circuit_inputs.next_2(p.y0); // in2
    circuit_inputs = circuit_inputs.next_2(p.y1); // in3
    circuit_inputs = circuit_inputs.next_2(a); // in4
    circuit_inputs = circuit_inputs.next_2(b20); // in5
    circuit_inputs = circuit_inputs.next_2(b21); // in6

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let zero_check_0: u384 = outputs.get_output(t22);
    let zero_check_1: u384 = outputs.get_output(t23);
    return (zero_check_0, zero_check_1);
}
#[inline(always)]
pub fn run_PREPARE_FAKE_GLV_PTS_circuit(
    P: G1Point,
    Q: G1Point,
    s2_sign: u384,
    A_weirstrass: u384,
    modulus: core::circuit::CircuitModulus,
) -> (
    G1Point,
    G1Point,
    G1Point,
    G1Point,
    u384,
    u384,
    u384,
    u384,
    G1Point,
    G1Point,
    G1Point,
    G1Point,
    u384,
    u384,
    u384,
    u384,
    G1Point,
    u384,
) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_add(t0, t0);
    let t2 = circuit_add(t1, t0);
    let t3 = circuit_add(t2, in6);
    let t4 = circuit_add(in2, in2);
    let t5 = circuit_inverse(t4);
    let t6 = circuit_mul(t3, t5);
    let t7 = circuit_mul(t6, t6);
    let t8 = circuit_add(in1, in1);
    let t9 = circuit_sub(t7, t8);
    let t10 = circuit_sub(in1, t9);
    let t11 = circuit_add(in2, in2);
    let t12 = circuit_inverse(t10);
    let t13 = circuit_mul(t11, t12);
    let t14 = circuit_sub(t13, t6);
    let t15 = circuit_mul(t14, t14);
    let t16 = circuit_add(in1, t9);
    let t17 = circuit_sub(t15, t16);
    let t18 = circuit_sub(in1, t17);
    let t19 = circuit_mul(t14, t18);
    let t20 = circuit_sub(t19, in2);
    let t21 = circuit_mul(in5, in4);
    let t22 = circuit_sub(in0, t21);
    let t23 = circuit_mul(in3, in3);
    let t24 = circuit_add(t23, t23);
    let t25 = circuit_add(t24, t23);
    let t26 = circuit_add(t25, in6);
    let t27 = circuit_add(t21, t21);
    let t28 = circuit_inverse(t27);
    let t29 = circuit_mul(t26, t28);
    let t30 = circuit_mul(t29, t29);
    let t31 = circuit_add(in3, in3);
    let t32 = circuit_sub(t30, t31);
    let t33 = circuit_sub(in3, t32);
    let t34 = circuit_add(t21, t21);
    let t35 = circuit_inverse(t33);
    let t36 = circuit_mul(t34, t35);
    let t37 = circuit_sub(t36, t29);
    let t38 = circuit_mul(t37, t37);
    let t39 = circuit_add(in3, t32);
    let t40 = circuit_sub(t38, t39);
    let t41 = circuit_sub(in3, t40);
    let t42 = circuit_mul(t37, t41);
    let t43 = circuit_sub(t42, t21);
    let t44 = circuit_sub(t20, t43);
    let t45 = circuit_sub(t17, t40);
    let t46 = circuit_inverse(t45);
    let t47 = circuit_mul(t44, t46);
    let t48 = circuit_mul(t47, t47);
    let t49 = circuit_sub(t48, t17);
    let t50 = circuit_sub(t49, t40);
    let t51 = circuit_sub(t17, t50);
    let t52 = circuit_mul(t47, t51);
    let t53 = circuit_sub(t52, t20);
    let t54 = circuit_sub(in2, t21);
    let t55 = circuit_sub(in1, in3);
    let t56 = circuit_inverse(t55);
    let t57 = circuit_mul(t54, t56);
    let t58 = circuit_mul(t57, t57);
    let t59 = circuit_sub(t58, in1);
    let t60 = circuit_sub(t59, in3);
    let t61 = circuit_sub(in1, t60);
    let t62 = circuit_mul(t57, t61);
    let t63 = circuit_sub(t62, in2);
    let t64 = circuit_sub(t20, t21);
    let t65 = circuit_sub(t17, in3);
    let t66 = circuit_inverse(t65);
    let t67 = circuit_mul(t64, t66);
    let t68 = circuit_mul(t67, t67);
    let t69 = circuit_sub(t68, t17);
    let t70 = circuit_sub(t69, in3);
    let t71 = circuit_sub(t17, t70);
    let t72 = circuit_mul(t67, t71);
    let t73 = circuit_sub(t72, t20);
    let t74 = circuit_sub(in2, t43);
    let t75 = circuit_sub(in1, t40);
    let t76 = circuit_inverse(t75);
    let t77 = circuit_mul(t74, t76);
    let t78 = circuit_mul(t77, t77);
    let t79 = circuit_sub(t78, in1);
    let t80 = circuit_sub(t79, t40);
    let t81 = circuit_sub(in1, t80);
    let t82 = circuit_mul(t77, t81);
    let t83 = circuit_sub(t82, in2);
    let t84 = circuit_sub(in0, t63);
    let t85 = circuit_sub(in0, t53);
    let t86 = circuit_sub(in0, t83);
    let t87 = circuit_sub(in0, t73);
    let t88 = circuit_sub(t20, t22);
    let t89 = circuit_sub(t17, in3);
    let t90 = circuit_inverse(t89);
    let t91 = circuit_mul(t88, t90);
    let t92 = circuit_mul(t91, t91);
    let t93 = circuit_sub(t92, t17);
    let t94 = circuit_sub(t93, in3);
    let t95 = circuit_sub(t17, t94);
    let t96 = circuit_mul(t91, t95);
    let t97 = circuit_sub(t96, t20);
    let t98 = circuit_sub(in0, t43);
    let t99 = circuit_sub(in2, t98);
    let t100 = circuit_sub(in1, t40);
    let t101 = circuit_inverse(t100);
    let t102 = circuit_mul(t99, t101);
    let t103 = circuit_mul(t102, t102);
    let t104 = circuit_sub(t103, in1);
    let t105 = circuit_sub(t104, t40);
    let t106 = circuit_sub(in1, t105);
    let t107 = circuit_mul(t102, t106);
    let t108 = circuit_sub(t107, in2);
    let t109 = circuit_sub(t20, t98);
    let t110 = circuit_sub(t17, t40);
    let t111 = circuit_inverse(t110);
    let t112 = circuit_mul(t109, t111);
    let t113 = circuit_mul(t112, t112);
    let t114 = circuit_sub(t113, t17);
    let t115 = circuit_sub(t114, t40);
    let t116 = circuit_sub(t17, t115);
    let t117 = circuit_mul(t112, t116);
    let t118 = circuit_sub(t117, t20);
    let t119 = circuit_sub(t22, in2);
    let t120 = circuit_sub(in3, in1);
    let t121 = circuit_inverse(t120);
    let t122 = circuit_mul(t119, t121);
    let t123 = circuit_mul(t122, t122);
    let t124 = circuit_sub(t123, in3);
    let t125 = circuit_sub(t124, in1);
    let t126 = circuit_sub(in3, t125);
    let t127 = circuit_mul(t122, t126);
    let t128 = circuit_sub(t127, t22);
    let t129 = circuit_sub(in0, t108);
    let t130 = circuit_sub(in0, t97);
    let t131 = circuit_sub(in0, t128);
    let t132 = circuit_sub(in0, t118);

    let modulus = modulus;

    let mut circuit_inputs = (
        t50,
        t53,
        t60,
        t63,
        t70,
        t73,
        t80,
        t83,
        t84,
        t85,
        t86,
        t87,
        t94,
        t97,
        t105,
        t108,
        t115,
        t118,
        t125,
        t128,
        t129,
        t130,
        t131,
        t132,
        t40,
        t43,
        t22,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(P.x); // in1
    circuit_inputs = circuit_inputs.next_2(P.y); // in2
    circuit_inputs = circuit_inputs.next_2(Q.x); // in3
    circuit_inputs = circuit_inputs.next_2(Q.y); // in4
    circuit_inputs = circuit_inputs.next_2(s2_sign); // in5
    circuit_inputs = circuit_inputs.next_2(A_weirstrass); // in6

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let T1: G1Point = G1Point { x: outputs.get_output(t50), y: outputs.get_output(t53) };
    let T2: G1Point = G1Point { x: outputs.get_output(t60), y: outputs.get_output(t63) };
    let T3: G1Point = G1Point { x: outputs.get_output(t70), y: outputs.get_output(t73) };
    let T4: G1Point = G1Point { x: outputs.get_output(t80), y: outputs.get_output(t83) };
    let T5y: u384 = outputs.get_output(t84);
    let T6y: u384 = outputs.get_output(t85);
    let T7y: u384 = outputs.get_output(t86);
    let T8y: u384 = outputs.get_output(t87);
    let T9: G1Point = G1Point { x: outputs.get_output(t94), y: outputs.get_output(t97) };
    let T10: G1Point = G1Point { x: outputs.get_output(t105), y: outputs.get_output(t108) };
    let T11: G1Point = G1Point { x: outputs.get_output(t115), y: outputs.get_output(t118) };
    let T12: G1Point = G1Point { x: outputs.get_output(t125), y: outputs.get_output(t128) };
    let T13y: u384 = outputs.get_output(t129);
    let T14y: u384 = outputs.get_output(t130);
    let T15y: u384 = outputs.get_output(t131);
    let T16y: u384 = outputs.get_output(t132);
    let R2: G1Point = G1Point { x: outputs.get_output(t40), y: outputs.get_output(t43) };
    let R0y: u384 = outputs.get_output(t22);
    return (T1, T2, T3, T4, T5y, T6y, T7y, T8y, T9, T10, T11, T12, T13y, T14y, T15y, T16y, R2, R0y);
}
#[inline(always)]
pub fn run_PREPARE_GLV_FAKE_GLV_PTS_circuit(
    Px: u384,
    P0y: u384,
    P1y: u384,
    Qx: u384,
    Q0y: u384,
    Phi_P0y: u384,
    Phi_P1y: u384,
    Phi_Q0y: u384,
    Gen: G1Point,
    third_root: u384,
    modulus: core::circuit::CircuitModulus,
) -> (
    G1Point,
    G1Point,
    G1Point,
    G1Point,
    G1Point,
    G1Point,
    G1Point,
    G1Point,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    u384,
    G1Point,
) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let t0 = circuit_sub(in2, in5);
    let t1 = circuit_sub(in1, in4);
    let t2 = circuit_inverse(t1);
    let t3 = circuit_mul(t0, t2);
    let t4 = circuit_mul(t3, t3);
    let t5 = circuit_sub(t4, in1);
    let t6 = circuit_sub(t5, in4);
    let t7 = circuit_sub(in1, t6);
    let t8 = circuit_mul(t3, t7);
    let t9 = circuit_sub(t8, in2);
    let t10 = circuit_sub(in0, t9);
    let t11 = circuit_sub(in3, in5);
    let t12 = circuit_sub(in1, in4);
    let t13 = circuit_inverse(t12);
    let t14 = circuit_mul(t11, t13);
    let t15 = circuit_mul(t14, t14);
    let t16 = circuit_sub(t15, in1);
    let t17 = circuit_sub(t16, in4);
    let t18 = circuit_sub(in1, t17);
    let t19 = circuit_mul(t14, t18);
    let t20 = circuit_sub(t19, in3);
    let t21 = circuit_mul(in1, in11);
    let t22 = circuit_mul(in4, in11);
    let t23 = circuit_sub(in6, in8);
    let t24 = circuit_sub(t21, t22);
    let t25 = circuit_inverse(t24);
    let t26 = circuit_mul(t23, t25);
    let t27 = circuit_mul(t26, t26);
    let t28 = circuit_sub(t27, t21);
    let t29 = circuit_sub(t28, t22);
    let t30 = circuit_sub(t21, t29);
    let t31 = circuit_mul(t26, t30);
    let t32 = circuit_sub(t31, in6);
    let t33 = circuit_sub(in0, t32);
    let t34 = circuit_sub(in7, in8);
    let t35 = circuit_sub(t21, t22);
    let t36 = circuit_inverse(t35);
    let t37 = circuit_mul(t34, t36);
    let t38 = circuit_mul(t37, t37);
    let t39 = circuit_sub(t38, t21);
    let t40 = circuit_sub(t39, t22);
    let t41 = circuit_sub(t21, t40);
    let t42 = circuit_mul(t37, t41);
    let t43 = circuit_sub(t42, in7);
    let t44 = circuit_sub(in0, t43);
    let t45 = circuit_sub(t10, t33);
    let t46 = circuit_sub(t6, t29);
    let t47 = circuit_inverse(t46);
    let t48 = circuit_mul(t45, t47);
    let t49 = circuit_mul(t48, t48);
    let t50 = circuit_sub(t49, t6);
    let t51 = circuit_sub(t50, t29);
    let t52 = circuit_sub(t6, t51);
    let t53 = circuit_mul(t48, t52);
    let t54 = circuit_sub(t53, t10);
    let t55 = circuit_sub(t10, t43);
    let t56 = circuit_sub(t6, t40);
    let t57 = circuit_inverse(t56);
    let t58 = circuit_mul(t55, t57);
    let t59 = circuit_mul(t58, t58);
    let t60 = circuit_sub(t59, t6);
    let t61 = circuit_sub(t60, t40);
    let t62 = circuit_sub(t6, t61);
    let t63 = circuit_mul(t58, t62);
    let t64 = circuit_sub(t63, t10);
    let t65 = circuit_sub(t10, t44);
    let t66 = circuit_sub(t6, t40);
    let t67 = circuit_inverse(t66);
    let t68 = circuit_mul(t65, t67);
    let t69 = circuit_mul(t68, t68);
    let t70 = circuit_sub(t69, t6);
    let t71 = circuit_sub(t70, t40);
    let t72 = circuit_sub(t6, t71);
    let t73 = circuit_mul(t68, t72);
    let t74 = circuit_sub(t73, t10);
    let t75 = circuit_sub(t10, t32);
    let t76 = circuit_sub(t6, t29);
    let t77 = circuit_inverse(t76);
    let t78 = circuit_mul(t75, t77);
    let t79 = circuit_mul(t78, t78);
    let t80 = circuit_sub(t79, t6);
    let t81 = circuit_sub(t80, t29);
    let t82 = circuit_sub(t6, t81);
    let t83 = circuit_mul(t78, t82);
    let t84 = circuit_sub(t83, t10);
    let t85 = circuit_sub(t20, t33);
    let t86 = circuit_sub(t17, t29);
    let t87 = circuit_inverse(t86);
    let t88 = circuit_mul(t85, t87);
    let t89 = circuit_mul(t88, t88);
    let t90 = circuit_sub(t89, t17);
    let t91 = circuit_sub(t90, t29);
    let t92 = circuit_sub(t17, t91);
    let t93 = circuit_mul(t88, t92);
    let t94 = circuit_sub(t93, t20);
    let t95 = circuit_sub(t20, t43);
    let t96 = circuit_sub(t17, t40);
    let t97 = circuit_inverse(t96);
    let t98 = circuit_mul(t95, t97);
    let t99 = circuit_mul(t98, t98);
    let t100 = circuit_sub(t99, t17);
    let t101 = circuit_sub(t100, t40);
    let t102 = circuit_sub(t17, t101);
    let t103 = circuit_mul(t98, t102);
    let t104 = circuit_sub(t103, t20);
    let t105 = circuit_sub(t20, t44);
    let t106 = circuit_sub(t17, t40);
    let t107 = circuit_inverse(t106);
    let t108 = circuit_mul(t105, t107);
    let t109 = circuit_mul(t108, t108);
    let t110 = circuit_sub(t109, t17);
    let t111 = circuit_sub(t110, t40);
    let t112 = circuit_sub(t17, t111);
    let t113 = circuit_mul(t108, t112);
    let t114 = circuit_sub(t113, t20);
    let t115 = circuit_sub(t20, t32);
    let t116 = circuit_sub(t17, t29);
    let t117 = circuit_inverse(t116);
    let t118 = circuit_mul(t115, t117);
    let t119 = circuit_mul(t118, t118);
    let t120 = circuit_sub(t119, t17);
    let t121 = circuit_sub(t120, t29);
    let t122 = circuit_sub(t17, t121);
    let t123 = circuit_mul(t118, t122);
    let t124 = circuit_sub(t123, t20);
    let t125 = circuit_sub(in0, t124);
    let t126 = circuit_sub(in0, t114);
    let t127 = circuit_sub(in0, t104);
    let t128 = circuit_sub(in0, t94);
    let t129 = circuit_sub(in0, t84);
    let t130 = circuit_sub(in0, t74);
    let t131 = circuit_sub(in0, t64);
    let t132 = circuit_sub(in0, t54);
    let t133 = circuit_sub(t54, in10);
    let t134 = circuit_sub(t51, in9);
    let t135 = circuit_inverse(t134);
    let t136 = circuit_mul(t133, t135);
    let t137 = circuit_mul(t136, t136);
    let t138 = circuit_sub(t137, t51);
    let t139 = circuit_sub(t138, in9);
    let t140 = circuit_sub(t51, t139);
    let t141 = circuit_mul(t136, t140);
    let t142 = circuit_sub(t141, t54);

    let modulus = modulus;

    let mut circuit_inputs = (
        t51,
        t54,
        t61,
        t64,
        t71,
        t74,
        t81,
        t84,
        t91,
        t94,
        t101,
        t104,
        t111,
        t114,
        t121,
        t124,
        t125,
        t126,
        t127,
        t128,
        t129,
        t130,
        t131,
        t132,
        t21,
        t22,
        t139,
        t142,
    )
        .new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(Px); // in1
    circuit_inputs = circuit_inputs.next_2(P0y); // in2
    circuit_inputs = circuit_inputs.next_2(P1y); // in3
    circuit_inputs = circuit_inputs.next_2(Qx); // in4
    circuit_inputs = circuit_inputs.next_2(Q0y); // in5
    circuit_inputs = circuit_inputs.next_2(Phi_P0y); // in6
    circuit_inputs = circuit_inputs.next_2(Phi_P1y); // in7
    circuit_inputs = circuit_inputs.next_2(Phi_Q0y); // in8
    circuit_inputs = circuit_inputs.next_2(Gen.x); // in9
    circuit_inputs = circuit_inputs.next_2(Gen.y); // in10
    circuit_inputs = circuit_inputs.next_2(third_root); // in11

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let B1: G1Point = G1Point { x: outputs.get_output(t51), y: outputs.get_output(t54) };
    let B2: G1Point = G1Point { x: outputs.get_output(t61), y: outputs.get_output(t64) };
    let B3: G1Point = G1Point { x: outputs.get_output(t71), y: outputs.get_output(t74) };
    let B4: G1Point = G1Point { x: outputs.get_output(t81), y: outputs.get_output(t84) };
    let B5: G1Point = G1Point { x: outputs.get_output(t91), y: outputs.get_output(t94) };
    let B6: G1Point = G1Point { x: outputs.get_output(t101), y: outputs.get_output(t104) };
    let B7: G1Point = G1Point { x: outputs.get_output(t111), y: outputs.get_output(t114) };
    let B8: G1Point = G1Point { x: outputs.get_output(t121), y: outputs.get_output(t124) };
    let B9y: u384 = outputs.get_output(t125);
    let B10y: u384 = outputs.get_output(t126);
    let B11y: u384 = outputs.get_output(t127);
    let B12y: u384 = outputs.get_output(t128);
    let B13y: u384 = outputs.get_output(t129);
    let B14y: u384 = outputs.get_output(t130);
    let B15y: u384 = outputs.get_output(t131);
    let B16y: u384 = outputs.get_output(t132);
    let Phi_P0x: u384 = outputs.get_output(t21);
    let Phi_Q0x: u384 = outputs.get_output(t22);
    let Acc: G1Point = G1Point { x: outputs.get_output(t139), y: outputs.get_output(t142) };
    return (
        B1,
        B2,
        B3,
        B4,
        B5,
        B6,
        B7,
        B8,
        B9y,
        B10y,
        B11y,
        B12y,
        B13y,
        B14y,
        B15y,
        B16y,
        Phi_P0x,
        Phi_Q0x,
        Acc,
    );
}
#[inline(always)]
pub fn run_PSI_G2_BLS12_381_circuit(
    p: G2Point, modulus: core::circuit::CircuitModulus,
) -> (G2Point,) {
    // CONSTANT stack
    let in0 = CE::<
        CI<0>,
    > {}; // 0x1a0111ea397fe699ec02408663d4de85aa0d857d89759ad4897d29650fb85f9b409427eb4f49fffd8bfd00000000aaad
    let in1 = CE::<
        CI<1>,
    > {}; // 0x135203e60180a68ee2e9c448d77a2cd91c3dedd930b1cf60ef396489f61eb45e304466cf3e67fa0af1ee7b04121bdea2
    let in2 = CE::<
        CI<2>,
    > {}; // 0x6af0e0437ff400b6831e36d6bd17ffe48395dabc2d3435e77f76e17009241c5ee67992f72ec05f4c81084fbede3cc09
    let in3 = CE::<CI<3>> {}; // 0x0

    // INPUT stack
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let in7 = CE::<CI<7>> {};
    let t0 = circuit_mul(in5, in0);
    let t1 = circuit_mul(in4, in0);
    let t2 = circuit_sub(in3, in7);
    let t3 = circuit_mul(in6, in1); // Fp2 mul start
    let t4 = circuit_mul(t2, in2);
    let t5 = circuit_sub(t3, t4); // Fp2 mul real part end
    let t6 = circuit_mul(in6, in2);
    let t7 = circuit_mul(t2, in1);
    let t8 = circuit_add(t6, t7); // Fp2 mul imag part end

    let modulus = modulus;

    let mut circuit_inputs = (t0, t1, t5, t8).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0x4f49fffd8bfd00000000aaad, 0x897d29650fb85f9b409427eb, 0x63d4de85aa0d857d89759ad4,
                0x1a0111ea397fe699ec024086,
            ],
        ); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0x3e67fa0af1ee7b04121bdea2, 0xef396489f61eb45e304466cf, 0xd77a2cd91c3dedd930b1cf60,
                0x135203e60180a68ee2e9c448,
            ],
        ); // in1
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0x72ec05f4c81084fbede3cc09, 0x77f76e17009241c5ee67992f, 0x6bd17ffe48395dabc2d3435e,
                0x6af0e0437ff400b6831e36d,
            ],
        ); // in2
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in3
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x0); // in4
    circuit_inputs = circuit_inputs.next_2(p.x1); // in5
    circuit_inputs = circuit_inputs.next_2(p.y0); // in6
    circuit_inputs = circuit_inputs.next_2(p.y1); // in7

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let result: G2Point = G2Point {
        x0: outputs.get_output(t0),
        x1: outputs.get_output(t1),
        y0: outputs.get_output(t5),
        y1: outputs.get_output(t8),
    };
    return (result,);
}
#[inline(always)]
pub fn run_QUADRUPLE_AND_ADD_9_circuit(
    P: G1Point,
    Q_1: G1Point,
    Q_2: G1Point,
    Q_3: G1Point,
    Q_4: G1Point,
    Q_5: G1Point,
    Q_6: G1Point,
    Q_7: G1Point,
    Q_8: G1Point,
    Q_9: G1Point,
    A_weirstrass: u384,
    modulus: core::circuit::CircuitModulus,
) -> (G1Point,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11, in12) = (CE::<CI<10>> {}, CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14, in15) = (CE::<CI<13>> {}, CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17, in18) = (CE::<CI<16>> {}, CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20, in21) = (CE::<CI<19>> {}, CE::<CI<20>> {}, CE::<CI<21>> {});
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_add(t1, in21);
    let t3 = circuit_add(in2, in2);
    let t4 = circuit_inverse(t3);
    let t5 = circuit_mul(t2, t4);
    let t6 = circuit_mul(t5, t5);
    let t7 = circuit_sub(t6, in1);
    let t8 = circuit_sub(t7, in1);
    let t9 = circuit_sub(in1, t8);
    let t10 = circuit_mul(t5, t9);
    let t11 = circuit_sub(t10, in2);
    let t12 = circuit_sub(in4, t11);
    let t13 = circuit_sub(in3, t8);
    let t14 = circuit_inverse(t13);
    let t15 = circuit_mul(t12, t14);
    let t16 = circuit_mul(t15, t15);
    let t17 = circuit_add(t8, in3);
    let t18 = circuit_sub(t16, t17);
    let t19 = circuit_add(t11, t11);
    let t20 = circuit_sub(t18, t8);
    let t21 = circuit_inverse(t20);
    let t22 = circuit_mul(t19, t21);
    let t23 = circuit_add(t15, t22);
    let t24 = circuit_mul(t23, t23);
    let t25 = circuit_add(t8, t18);
    let t26 = circuit_sub(t24, t25);
    let t27 = circuit_sub(t26, t8);
    let t28 = circuit_mul(t23, t27);
    let t29 = circuit_sub(t28, t11);
    let t30 = circuit_mul(t26, t26);
    let t31 = circuit_mul(in0, t30);
    let t32 = circuit_add(t31, in21);
    let t33 = circuit_add(t29, t29);
    let t34 = circuit_inverse(t33);
    let t35 = circuit_mul(t32, t34);
    let t36 = circuit_mul(t35, t35);
    let t37 = circuit_sub(t36, t26);
    let t38 = circuit_sub(t37, t26);
    let t39 = circuit_sub(t26, t38);
    let t40 = circuit_mul(t35, t39);
    let t41 = circuit_sub(t40, t29);
    let t42 = circuit_sub(in6, t41);
    let t43 = circuit_sub(in5, t38);
    let t44 = circuit_inverse(t43);
    let t45 = circuit_mul(t42, t44);
    let t46 = circuit_mul(t45, t45);
    let t47 = circuit_add(t38, in5);
    let t48 = circuit_sub(t46, t47);
    let t49 = circuit_add(t41, t41);
    let t50 = circuit_sub(t48, t38);
    let t51 = circuit_inverse(t50);
    let t52 = circuit_mul(t49, t51);
    let t53 = circuit_add(t45, t52);
    let t54 = circuit_mul(t53, t53);
    let t55 = circuit_add(t38, t48);
    let t56 = circuit_sub(t54, t55);
    let t57 = circuit_sub(t56, t38);
    let t58 = circuit_mul(t53, t57);
    let t59 = circuit_sub(t58, t41);
    let t60 = circuit_mul(t56, t56);
    let t61 = circuit_mul(in0, t60);
    let t62 = circuit_add(t61, in21);
    let t63 = circuit_add(t59, t59);
    let t64 = circuit_inverse(t63);
    let t65 = circuit_mul(t62, t64);
    let t66 = circuit_mul(t65, t65);
    let t67 = circuit_sub(t66, t56);
    let t68 = circuit_sub(t67, t56);
    let t69 = circuit_sub(t56, t68);
    let t70 = circuit_mul(t65, t69);
    let t71 = circuit_sub(t70, t59);
    let t72 = circuit_sub(in8, t71);
    let t73 = circuit_sub(in7, t68);
    let t74 = circuit_inverse(t73);
    let t75 = circuit_mul(t72, t74);
    let t76 = circuit_mul(t75, t75);
    let t77 = circuit_add(t68, in7);
    let t78 = circuit_sub(t76, t77);
    let t79 = circuit_add(t71, t71);
    let t80 = circuit_sub(t78, t68);
    let t81 = circuit_inverse(t80);
    let t82 = circuit_mul(t79, t81);
    let t83 = circuit_add(t75, t82);
    let t84 = circuit_mul(t83, t83);
    let t85 = circuit_add(t68, t78);
    let t86 = circuit_sub(t84, t85);
    let t87 = circuit_sub(t86, t68);
    let t88 = circuit_mul(t83, t87);
    let t89 = circuit_sub(t88, t71);
    let t90 = circuit_mul(t86, t86);
    let t91 = circuit_mul(in0, t90);
    let t92 = circuit_add(t91, in21);
    let t93 = circuit_add(t89, t89);
    let t94 = circuit_inverse(t93);
    let t95 = circuit_mul(t92, t94);
    let t96 = circuit_mul(t95, t95);
    let t97 = circuit_sub(t96, t86);
    let t98 = circuit_sub(t97, t86);
    let t99 = circuit_sub(t86, t98);
    let t100 = circuit_mul(t95, t99);
    let t101 = circuit_sub(t100, t89);
    let t102 = circuit_sub(in10, t101);
    let t103 = circuit_sub(in9, t98);
    let t104 = circuit_inverse(t103);
    let t105 = circuit_mul(t102, t104);
    let t106 = circuit_mul(t105, t105);
    let t107 = circuit_add(t98, in9);
    let t108 = circuit_sub(t106, t107);
    let t109 = circuit_add(t101, t101);
    let t110 = circuit_sub(t108, t98);
    let t111 = circuit_inverse(t110);
    let t112 = circuit_mul(t109, t111);
    let t113 = circuit_add(t105, t112);
    let t114 = circuit_mul(t113, t113);
    let t115 = circuit_add(t98, t108);
    let t116 = circuit_sub(t114, t115);
    let t117 = circuit_sub(t116, t98);
    let t118 = circuit_mul(t113, t117);
    let t119 = circuit_sub(t118, t101);
    let t120 = circuit_mul(t116, t116);
    let t121 = circuit_mul(in0, t120);
    let t122 = circuit_add(t121, in21);
    let t123 = circuit_add(t119, t119);
    let t124 = circuit_inverse(t123);
    let t125 = circuit_mul(t122, t124);
    let t126 = circuit_mul(t125, t125);
    let t127 = circuit_sub(t126, t116);
    let t128 = circuit_sub(t127, t116);
    let t129 = circuit_sub(t116, t128);
    let t130 = circuit_mul(t125, t129);
    let t131 = circuit_sub(t130, t119);
    let t132 = circuit_sub(in12, t131);
    let t133 = circuit_sub(in11, t128);
    let t134 = circuit_inverse(t133);
    let t135 = circuit_mul(t132, t134);
    let t136 = circuit_mul(t135, t135);
    let t137 = circuit_add(t128, in11);
    let t138 = circuit_sub(t136, t137);
    let t139 = circuit_add(t131, t131);
    let t140 = circuit_sub(t138, t128);
    let t141 = circuit_inverse(t140);
    let t142 = circuit_mul(t139, t141);
    let t143 = circuit_add(t135, t142);
    let t144 = circuit_mul(t143, t143);
    let t145 = circuit_add(t128, t138);
    let t146 = circuit_sub(t144, t145);
    let t147 = circuit_sub(t146, t128);
    let t148 = circuit_mul(t143, t147);
    let t149 = circuit_sub(t148, t131);
    let t150 = circuit_mul(t146, t146);
    let t151 = circuit_mul(in0, t150);
    let t152 = circuit_add(t151, in21);
    let t153 = circuit_add(t149, t149);
    let t154 = circuit_inverse(t153);
    let t155 = circuit_mul(t152, t154);
    let t156 = circuit_mul(t155, t155);
    let t157 = circuit_sub(t156, t146);
    let t158 = circuit_sub(t157, t146);
    let t159 = circuit_sub(t146, t158);
    let t160 = circuit_mul(t155, t159);
    let t161 = circuit_sub(t160, t149);
    let t162 = circuit_sub(in14, t161);
    let t163 = circuit_sub(in13, t158);
    let t164 = circuit_inverse(t163);
    let t165 = circuit_mul(t162, t164);
    let t166 = circuit_mul(t165, t165);
    let t167 = circuit_add(t158, in13);
    let t168 = circuit_sub(t166, t167);
    let t169 = circuit_add(t161, t161);
    let t170 = circuit_sub(t168, t158);
    let t171 = circuit_inverse(t170);
    let t172 = circuit_mul(t169, t171);
    let t173 = circuit_add(t165, t172);
    let t174 = circuit_mul(t173, t173);
    let t175 = circuit_add(t158, t168);
    let t176 = circuit_sub(t174, t175);
    let t177 = circuit_sub(t176, t158);
    let t178 = circuit_mul(t173, t177);
    let t179 = circuit_sub(t178, t161);
    let t180 = circuit_mul(t176, t176);
    let t181 = circuit_mul(in0, t180);
    let t182 = circuit_add(t181, in21);
    let t183 = circuit_add(t179, t179);
    let t184 = circuit_inverse(t183);
    let t185 = circuit_mul(t182, t184);
    let t186 = circuit_mul(t185, t185);
    let t187 = circuit_sub(t186, t176);
    let t188 = circuit_sub(t187, t176);
    let t189 = circuit_sub(t176, t188);
    let t190 = circuit_mul(t185, t189);
    let t191 = circuit_sub(t190, t179);
    let t192 = circuit_sub(in16, t191);
    let t193 = circuit_sub(in15, t188);
    let t194 = circuit_inverse(t193);
    let t195 = circuit_mul(t192, t194);
    let t196 = circuit_mul(t195, t195);
    let t197 = circuit_add(t188, in15);
    let t198 = circuit_sub(t196, t197);
    let t199 = circuit_add(t191, t191);
    let t200 = circuit_sub(t198, t188);
    let t201 = circuit_inverse(t200);
    let t202 = circuit_mul(t199, t201);
    let t203 = circuit_add(t195, t202);
    let t204 = circuit_mul(t203, t203);
    let t205 = circuit_add(t188, t198);
    let t206 = circuit_sub(t204, t205);
    let t207 = circuit_sub(t206, t188);
    let t208 = circuit_mul(t203, t207);
    let t209 = circuit_sub(t208, t191);
    let t210 = circuit_mul(t206, t206);
    let t211 = circuit_mul(in0, t210);
    let t212 = circuit_add(t211, in21);
    let t213 = circuit_add(t209, t209);
    let t214 = circuit_inverse(t213);
    let t215 = circuit_mul(t212, t214);
    let t216 = circuit_mul(t215, t215);
    let t217 = circuit_sub(t216, t206);
    let t218 = circuit_sub(t217, t206);
    let t219 = circuit_sub(t206, t218);
    let t220 = circuit_mul(t215, t219);
    let t221 = circuit_sub(t220, t209);
    let t222 = circuit_sub(in18, t221);
    let t223 = circuit_sub(in17, t218);
    let t224 = circuit_inverse(t223);
    let t225 = circuit_mul(t222, t224);
    let t226 = circuit_mul(t225, t225);
    let t227 = circuit_add(t218, in17);
    let t228 = circuit_sub(t226, t227);
    let t229 = circuit_add(t221, t221);
    let t230 = circuit_sub(t228, t218);
    let t231 = circuit_inverse(t230);
    let t232 = circuit_mul(t229, t231);
    let t233 = circuit_add(t225, t232);
    let t234 = circuit_mul(t233, t233);
    let t235 = circuit_add(t218, t228);
    let t236 = circuit_sub(t234, t235);
    let t237 = circuit_sub(t236, t218);
    let t238 = circuit_mul(t233, t237);
    let t239 = circuit_sub(t238, t221);
    let t240 = circuit_mul(t236, t236);
    let t241 = circuit_mul(in0, t240);
    let t242 = circuit_add(t241, in21);
    let t243 = circuit_add(t239, t239);
    let t244 = circuit_inverse(t243);
    let t245 = circuit_mul(t242, t244);
    let t246 = circuit_mul(t245, t245);
    let t247 = circuit_sub(t246, t236);
    let t248 = circuit_sub(t247, t236);
    let t249 = circuit_sub(t236, t248);
    let t250 = circuit_mul(t245, t249);
    let t251 = circuit_sub(t250, t239);
    let t252 = circuit_sub(in20, t251);
    let t253 = circuit_sub(in19, t248);
    let t254 = circuit_inverse(t253);
    let t255 = circuit_mul(t252, t254);
    let t256 = circuit_mul(t255, t255);
    let t257 = circuit_add(t248, in19);
    let t258 = circuit_sub(t256, t257);
    let t259 = circuit_add(t251, t251);
    let t260 = circuit_sub(t258, t248);
    let t261 = circuit_inverse(t260);
    let t262 = circuit_mul(t259, t261);
    let t263 = circuit_add(t255, t262);
    let t264 = circuit_mul(t263, t263);
    let t265 = circuit_add(t248, t258);
    let t266 = circuit_sub(t264, t265);
    let t267 = circuit_sub(t266, t248);
    let t268 = circuit_mul(t263, t267);
    let t269 = circuit_sub(t268, t251);

    let modulus = modulus;

    let mut circuit_inputs = (t266, t269).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(P.x); // in1
    circuit_inputs = circuit_inputs.next_2(P.y); // in2
    circuit_inputs = circuit_inputs.next_2(Q_1.x); // in3
    circuit_inputs = circuit_inputs.next_2(Q_1.y); // in4
    circuit_inputs = circuit_inputs.next_2(Q_2.x); // in5
    circuit_inputs = circuit_inputs.next_2(Q_2.y); // in6
    circuit_inputs = circuit_inputs.next_2(Q_3.x); // in7
    circuit_inputs = circuit_inputs.next_2(Q_3.y); // in8
    circuit_inputs = circuit_inputs.next_2(Q_4.x); // in9
    circuit_inputs = circuit_inputs.next_2(Q_4.y); // in10
    circuit_inputs = circuit_inputs.next_2(Q_5.x); // in11
    circuit_inputs = circuit_inputs.next_2(Q_5.y); // in12
    circuit_inputs = circuit_inputs.next_2(Q_6.x); // in13
    circuit_inputs = circuit_inputs.next_2(Q_6.y); // in14
    circuit_inputs = circuit_inputs.next_2(Q_7.x); // in15
    circuit_inputs = circuit_inputs.next_2(Q_7.y); // in16
    circuit_inputs = circuit_inputs.next_2(Q_8.x); // in17
    circuit_inputs = circuit_inputs.next_2(Q_8.y); // in18
    circuit_inputs = circuit_inputs.next_2(Q_9.x); // in19
    circuit_inputs = circuit_inputs.next_2(Q_9.y); // in20
    circuit_inputs = circuit_inputs.next_2(A_weirstrass); // in21

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let R: G1Point = G1Point { x: outputs.get_output(t266), y: outputs.get_output(t269) };
    return (R,);
}
