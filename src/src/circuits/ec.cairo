use core::circuit::{
    AddInputResultTrait, AddMod, CircuitData, CircuitDefinition, CircuitElement as CE,
    CircuitInput as CI, CircuitInputAccumulator, CircuitInputs, CircuitModulus, CircuitOutputsTrait,
    EvalCircuitResult, EvalCircuitTrait, MulMod, RangeCheck96, circuit_add, circuit_inverse,
    circuit_mul, circuit_sub, u384, u96,
};
use core::option::Option;
use garaga::core::circuit::{AddInputResultTrait2, IntoCircuitInputValue, u288IntoCircuitInputValue};
use garaga::definitions::{
    BLSProcessedPair, BNProcessedPair, E12D, E12DMulQuotient, E12T, G1G2Pair, G1Point, G2Line,
    G2Point, MillerLoopResultScalingFactor, get_BLS12_381_modulus, get_BN254_modulus, get_a, get_b,
    get_g, get_min_one, get_modulus, u288,
};

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
pub fn run_ADD_EC_POINTS_G2_circuit(p: G2Point, q: G2Point, curve_index: usize) -> (G2Point,) {
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

    let modulus = get_modulus(curve_index);

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
pub fn run_ADD_EC_POINT_circuit(p: G1Point, q: G1Point, modulus: CircuitModulus) -> (G1Point,) {
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
pub fn run_CLEAR_COFACTOR_BLS12_381_circuit(P: G1Point, modulus: CircuitModulus) -> (G1Point,) {
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
pub fn run_DOUBLE_AND_ADD_72_circuit(
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
    Q_10: G1Point,
    Q_11: G1Point,
    Q_12: G1Point,
    Q_13: G1Point,
    Q_14: G1Point,
    Q_15: G1Point,
    Q_16: G1Point,
    Q_17: G1Point,
    Q_18: G1Point,
    Q_19: G1Point,
    Q_20: G1Point,
    Q_21: G1Point,
    Q_22: G1Point,
    Q_23: G1Point,
    Q_24: G1Point,
    Q_25: G1Point,
    Q_26: G1Point,
    Q_27: G1Point,
    Q_28: G1Point,
    Q_29: G1Point,
    Q_30: G1Point,
    Q_31: G1Point,
    Q_32: G1Point,
    Q_33: G1Point,
    Q_34: G1Point,
    Q_35: G1Point,
    Q_36: G1Point,
    Q_37: G1Point,
    Q_38: G1Point,
    Q_39: G1Point,
    Q_40: G1Point,
    Q_41: G1Point,
    Q_42: G1Point,
    Q_43: G1Point,
    Q_44: G1Point,
    Q_45: G1Point,
    Q_46: G1Point,
    Q_47: G1Point,
    Q_48: G1Point,
    Q_49: G1Point,
    Q_50: G1Point,
    Q_51: G1Point,
    Q_52: G1Point,
    Q_53: G1Point,
    Q_54: G1Point,
    Q_55: G1Point,
    Q_56: G1Point,
    Q_57: G1Point,
    Q_58: G1Point,
    Q_59: G1Point,
    Q_60: G1Point,
    Q_61: G1Point,
    Q_62: G1Point,
    Q_63: G1Point,
    Q_64: G1Point,
    Q_65: G1Point,
    Q_66: G1Point,
    Q_67: G1Point,
    Q_68: G1Point,
    Q_69: G1Point,
    Q_70: G1Point,
    Q_71: G1Point,
    Q_72: G1Point,
    modulus: CircuitModulus,
) -> (G1Point,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25, in26) = (CE::<CI<24>> {}, CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28, in29) = (CE::<CI<27>> {}, CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31, in32) = (CE::<CI<30>> {}, CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34, in35) = (CE::<CI<33>> {}, CE::<CI<34>> {}, CE::<CI<35>> {});
    let (in36, in37, in38) = (CE::<CI<36>> {}, CE::<CI<37>> {}, CE::<CI<38>> {});
    let (in39, in40, in41) = (CE::<CI<39>> {}, CE::<CI<40>> {}, CE::<CI<41>> {});
    let (in42, in43, in44) = (CE::<CI<42>> {}, CE::<CI<43>> {}, CE::<CI<44>> {});
    let (in45, in46, in47) = (CE::<CI<45>> {}, CE::<CI<46>> {}, CE::<CI<47>> {});
    let (in48, in49, in50) = (CE::<CI<48>> {}, CE::<CI<49>> {}, CE::<CI<50>> {});
    let (in51, in52, in53) = (CE::<CI<51>> {}, CE::<CI<52>> {}, CE::<CI<53>> {});
    let (in54, in55, in56) = (CE::<CI<54>> {}, CE::<CI<55>> {}, CE::<CI<56>> {});
    let (in57, in58, in59) = (CE::<CI<57>> {}, CE::<CI<58>> {}, CE::<CI<59>> {});
    let (in60, in61, in62) = (CE::<CI<60>> {}, CE::<CI<61>> {}, CE::<CI<62>> {});
    let (in63, in64, in65) = (CE::<CI<63>> {}, CE::<CI<64>> {}, CE::<CI<65>> {});
    let (in66, in67, in68) = (CE::<CI<66>> {}, CE::<CI<67>> {}, CE::<CI<68>> {});
    let (in69, in70, in71) = (CE::<CI<69>> {}, CE::<CI<70>> {}, CE::<CI<71>> {});
    let (in72, in73, in74) = (CE::<CI<72>> {}, CE::<CI<73>> {}, CE::<CI<74>> {});
    let (in75, in76, in77) = (CE::<CI<75>> {}, CE::<CI<76>> {}, CE::<CI<77>> {});
    let (in78, in79, in80) = (CE::<CI<78>> {}, CE::<CI<79>> {}, CE::<CI<80>> {});
    let (in81, in82, in83) = (CE::<CI<81>> {}, CE::<CI<82>> {}, CE::<CI<83>> {});
    let (in84, in85, in86) = (CE::<CI<84>> {}, CE::<CI<85>> {}, CE::<CI<86>> {});
    let (in87, in88, in89) = (CE::<CI<87>> {}, CE::<CI<88>> {}, CE::<CI<89>> {});
    let (in90, in91, in92) = (CE::<CI<90>> {}, CE::<CI<91>> {}, CE::<CI<92>> {});
    let (in93, in94, in95) = (CE::<CI<93>> {}, CE::<CI<94>> {}, CE::<CI<95>> {});
    let (in96, in97, in98) = (CE::<CI<96>> {}, CE::<CI<97>> {}, CE::<CI<98>> {});
    let (in99, in100, in101) = (CE::<CI<99>> {}, CE::<CI<100>> {}, CE::<CI<101>> {});
    let (in102, in103, in104) = (CE::<CI<102>> {}, CE::<CI<103>> {}, CE::<CI<104>> {});
    let (in105, in106, in107) = (CE::<CI<105>> {}, CE::<CI<106>> {}, CE::<CI<107>> {});
    let (in108, in109, in110) = (CE::<CI<108>> {}, CE::<CI<109>> {}, CE::<CI<110>> {});
    let (in111, in112, in113) = (CE::<CI<111>> {}, CE::<CI<112>> {}, CE::<CI<113>> {});
    let (in114, in115, in116) = (CE::<CI<114>> {}, CE::<CI<115>> {}, CE::<CI<116>> {});
    let (in117, in118, in119) = (CE::<CI<117>> {}, CE::<CI<118>> {}, CE::<CI<119>> {});
    let (in120, in121, in122) = (CE::<CI<120>> {}, CE::<CI<121>> {}, CE::<CI<122>> {});
    let (in123, in124, in125) = (CE::<CI<123>> {}, CE::<CI<124>> {}, CE::<CI<125>> {});
    let (in126, in127, in128) = (CE::<CI<126>> {}, CE::<CI<127>> {}, CE::<CI<128>> {});
    let (in129, in130, in131) = (CE::<CI<129>> {}, CE::<CI<130>> {}, CE::<CI<131>> {});
    let (in132, in133, in134) = (CE::<CI<132>> {}, CE::<CI<133>> {}, CE::<CI<134>> {});
    let (in135, in136, in137) = (CE::<CI<135>> {}, CE::<CI<136>> {}, CE::<CI<137>> {});
    let (in138, in139, in140) = (CE::<CI<138>> {}, CE::<CI<139>> {}, CE::<CI<140>> {});
    let (in141, in142, in143) = (CE::<CI<141>> {}, CE::<CI<142>> {}, CE::<CI<143>> {});
    let (in144, in145) = (CE::<CI<144>> {}, CE::<CI<145>> {});
    let t0 = circuit_sub(in3, in1);
    let t1 = circuit_sub(in2, in0);
    let t2 = circuit_inverse(t1);
    let t3 = circuit_mul(t0, t2);
    let t4 = circuit_mul(t3, t3);
    let t5 = circuit_add(in0, in2);
    let t6 = circuit_sub(t4, t5);
    let t7 = circuit_add(in1, in1);
    let t8 = circuit_sub(t6, in0);
    let t9 = circuit_inverse(t8);
    let t10 = circuit_mul(t7, t9);
    let t11 = circuit_add(t3, t10);
    let t12 = circuit_mul(t11, t11);
    let t13 = circuit_add(in0, t6);
    let t14 = circuit_sub(t12, t13);
    let t15 = circuit_sub(t14, in0);
    let t16 = circuit_mul(t11, t15);
    let t17 = circuit_sub(t16, in1);
    let t18 = circuit_sub(in5, t17);
    let t19 = circuit_sub(in4, t14);
    let t20 = circuit_inverse(t19);
    let t21 = circuit_mul(t18, t20);
    let t22 = circuit_mul(t21, t21);
    let t23 = circuit_add(t14, in4);
    let t24 = circuit_sub(t22, t23);
    let t25 = circuit_add(t17, t17);
    let t26 = circuit_sub(t24, t14);
    let t27 = circuit_inverse(t26);
    let t28 = circuit_mul(t25, t27);
    let t29 = circuit_add(t21, t28);
    let t30 = circuit_mul(t29, t29);
    let t31 = circuit_add(t14, t24);
    let t32 = circuit_sub(t30, t31);
    let t33 = circuit_sub(t32, t14);
    let t34 = circuit_mul(t29, t33);
    let t35 = circuit_sub(t34, t17);
    let t36 = circuit_sub(in7, t35);
    let t37 = circuit_sub(in6, t32);
    let t38 = circuit_inverse(t37);
    let t39 = circuit_mul(t36, t38);
    let t40 = circuit_mul(t39, t39);
    let t41 = circuit_add(t32, in6);
    let t42 = circuit_sub(t40, t41);
    let t43 = circuit_add(t35, t35);
    let t44 = circuit_sub(t42, t32);
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t43, t45);
    let t47 = circuit_add(t39, t46);
    let t48 = circuit_mul(t47, t47);
    let t49 = circuit_add(t32, t42);
    let t50 = circuit_sub(t48, t49);
    let t51 = circuit_sub(t50, t32);
    let t52 = circuit_mul(t47, t51);
    let t53 = circuit_sub(t52, t35);
    let t54 = circuit_sub(in9, t53);
    let t55 = circuit_sub(in8, t50);
    let t56 = circuit_inverse(t55);
    let t57 = circuit_mul(t54, t56);
    let t58 = circuit_mul(t57, t57);
    let t59 = circuit_add(t50, in8);
    let t60 = circuit_sub(t58, t59);
    let t61 = circuit_add(t53, t53);
    let t62 = circuit_sub(t60, t50);
    let t63 = circuit_inverse(t62);
    let t64 = circuit_mul(t61, t63);
    let t65 = circuit_add(t57, t64);
    let t66 = circuit_mul(t65, t65);
    let t67 = circuit_add(t50, t60);
    let t68 = circuit_sub(t66, t67);
    let t69 = circuit_sub(t68, t50);
    let t70 = circuit_mul(t65, t69);
    let t71 = circuit_sub(t70, t53);
    let t72 = circuit_sub(in11, t71);
    let t73 = circuit_sub(in10, t68);
    let t74 = circuit_inverse(t73);
    let t75 = circuit_mul(t72, t74);
    let t76 = circuit_mul(t75, t75);
    let t77 = circuit_add(t68, in10);
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
    let t90 = circuit_sub(in13, t89);
    let t91 = circuit_sub(in12, t86);
    let t92 = circuit_inverse(t91);
    let t93 = circuit_mul(t90, t92);
    let t94 = circuit_mul(t93, t93);
    let t95 = circuit_add(t86, in12);
    let t96 = circuit_sub(t94, t95);
    let t97 = circuit_add(t89, t89);
    let t98 = circuit_sub(t96, t86);
    let t99 = circuit_inverse(t98);
    let t100 = circuit_mul(t97, t99);
    let t101 = circuit_add(t93, t100);
    let t102 = circuit_mul(t101, t101);
    let t103 = circuit_add(t86, t96);
    let t104 = circuit_sub(t102, t103);
    let t105 = circuit_sub(t104, t86);
    let t106 = circuit_mul(t101, t105);
    let t107 = circuit_sub(t106, t89);
    let t108 = circuit_sub(in15, t107);
    let t109 = circuit_sub(in14, t104);
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t108, t110);
    let t112 = circuit_mul(t111, t111);
    let t113 = circuit_add(t104, in14);
    let t114 = circuit_sub(t112, t113);
    let t115 = circuit_add(t107, t107);
    let t116 = circuit_sub(t114, t104);
    let t117 = circuit_inverse(t116);
    let t118 = circuit_mul(t115, t117);
    let t119 = circuit_add(t111, t118);
    let t120 = circuit_mul(t119, t119);
    let t121 = circuit_add(t104, t114);
    let t122 = circuit_sub(t120, t121);
    let t123 = circuit_sub(t122, t104);
    let t124 = circuit_mul(t119, t123);
    let t125 = circuit_sub(t124, t107);
    let t126 = circuit_sub(in17, t125);
    let t127 = circuit_sub(in16, t122);
    let t128 = circuit_inverse(t127);
    let t129 = circuit_mul(t126, t128);
    let t130 = circuit_mul(t129, t129);
    let t131 = circuit_add(t122, in16);
    let t132 = circuit_sub(t130, t131);
    let t133 = circuit_add(t125, t125);
    let t134 = circuit_sub(t132, t122);
    let t135 = circuit_inverse(t134);
    let t136 = circuit_mul(t133, t135);
    let t137 = circuit_add(t129, t136);
    let t138 = circuit_mul(t137, t137);
    let t139 = circuit_add(t122, t132);
    let t140 = circuit_sub(t138, t139);
    let t141 = circuit_sub(t140, t122);
    let t142 = circuit_mul(t137, t141);
    let t143 = circuit_sub(t142, t125);
    let t144 = circuit_sub(in19, t143);
    let t145 = circuit_sub(in18, t140);
    let t146 = circuit_inverse(t145);
    let t147 = circuit_mul(t144, t146);
    let t148 = circuit_mul(t147, t147);
    let t149 = circuit_add(t140, in18);
    let t150 = circuit_sub(t148, t149);
    let t151 = circuit_add(t143, t143);
    let t152 = circuit_sub(t150, t140);
    let t153 = circuit_inverse(t152);
    let t154 = circuit_mul(t151, t153);
    let t155 = circuit_add(t147, t154);
    let t156 = circuit_mul(t155, t155);
    let t157 = circuit_add(t140, t150);
    let t158 = circuit_sub(t156, t157);
    let t159 = circuit_sub(t158, t140);
    let t160 = circuit_mul(t155, t159);
    let t161 = circuit_sub(t160, t143);
    let t162 = circuit_sub(in21, t161);
    let t163 = circuit_sub(in20, t158);
    let t164 = circuit_inverse(t163);
    let t165 = circuit_mul(t162, t164);
    let t166 = circuit_mul(t165, t165);
    let t167 = circuit_add(t158, in20);
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
    let t180 = circuit_sub(in23, t179);
    let t181 = circuit_sub(in22, t176);
    let t182 = circuit_inverse(t181);
    let t183 = circuit_mul(t180, t182);
    let t184 = circuit_mul(t183, t183);
    let t185 = circuit_add(t176, in22);
    let t186 = circuit_sub(t184, t185);
    let t187 = circuit_add(t179, t179);
    let t188 = circuit_sub(t186, t176);
    let t189 = circuit_inverse(t188);
    let t190 = circuit_mul(t187, t189);
    let t191 = circuit_add(t183, t190);
    let t192 = circuit_mul(t191, t191);
    let t193 = circuit_add(t176, t186);
    let t194 = circuit_sub(t192, t193);
    let t195 = circuit_sub(t194, t176);
    let t196 = circuit_mul(t191, t195);
    let t197 = circuit_sub(t196, t179);
    let t198 = circuit_sub(in25, t197);
    let t199 = circuit_sub(in24, t194);
    let t200 = circuit_inverse(t199);
    let t201 = circuit_mul(t198, t200);
    let t202 = circuit_mul(t201, t201);
    let t203 = circuit_add(t194, in24);
    let t204 = circuit_sub(t202, t203);
    let t205 = circuit_add(t197, t197);
    let t206 = circuit_sub(t204, t194);
    let t207 = circuit_inverse(t206);
    let t208 = circuit_mul(t205, t207);
    let t209 = circuit_add(t201, t208);
    let t210 = circuit_mul(t209, t209);
    let t211 = circuit_add(t194, t204);
    let t212 = circuit_sub(t210, t211);
    let t213 = circuit_sub(t212, t194);
    let t214 = circuit_mul(t209, t213);
    let t215 = circuit_sub(t214, t197);
    let t216 = circuit_sub(in27, t215);
    let t217 = circuit_sub(in26, t212);
    let t218 = circuit_inverse(t217);
    let t219 = circuit_mul(t216, t218);
    let t220 = circuit_mul(t219, t219);
    let t221 = circuit_add(t212, in26);
    let t222 = circuit_sub(t220, t221);
    let t223 = circuit_add(t215, t215);
    let t224 = circuit_sub(t222, t212);
    let t225 = circuit_inverse(t224);
    let t226 = circuit_mul(t223, t225);
    let t227 = circuit_add(t219, t226);
    let t228 = circuit_mul(t227, t227);
    let t229 = circuit_add(t212, t222);
    let t230 = circuit_sub(t228, t229);
    let t231 = circuit_sub(t230, t212);
    let t232 = circuit_mul(t227, t231);
    let t233 = circuit_sub(t232, t215);
    let t234 = circuit_sub(in29, t233);
    let t235 = circuit_sub(in28, t230);
    let t236 = circuit_inverse(t235);
    let t237 = circuit_mul(t234, t236);
    let t238 = circuit_mul(t237, t237);
    let t239 = circuit_add(t230, in28);
    let t240 = circuit_sub(t238, t239);
    let t241 = circuit_add(t233, t233);
    let t242 = circuit_sub(t240, t230);
    let t243 = circuit_inverse(t242);
    let t244 = circuit_mul(t241, t243);
    let t245 = circuit_add(t237, t244);
    let t246 = circuit_mul(t245, t245);
    let t247 = circuit_add(t230, t240);
    let t248 = circuit_sub(t246, t247);
    let t249 = circuit_sub(t248, t230);
    let t250 = circuit_mul(t245, t249);
    let t251 = circuit_sub(t250, t233);
    let t252 = circuit_sub(in31, t251);
    let t253 = circuit_sub(in30, t248);
    let t254 = circuit_inverse(t253);
    let t255 = circuit_mul(t252, t254);
    let t256 = circuit_mul(t255, t255);
    let t257 = circuit_add(t248, in30);
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
    let t270 = circuit_sub(in33, t269);
    let t271 = circuit_sub(in32, t266);
    let t272 = circuit_inverse(t271);
    let t273 = circuit_mul(t270, t272);
    let t274 = circuit_mul(t273, t273);
    let t275 = circuit_add(t266, in32);
    let t276 = circuit_sub(t274, t275);
    let t277 = circuit_add(t269, t269);
    let t278 = circuit_sub(t276, t266);
    let t279 = circuit_inverse(t278);
    let t280 = circuit_mul(t277, t279);
    let t281 = circuit_add(t273, t280);
    let t282 = circuit_mul(t281, t281);
    let t283 = circuit_add(t266, t276);
    let t284 = circuit_sub(t282, t283);
    let t285 = circuit_sub(t284, t266);
    let t286 = circuit_mul(t281, t285);
    let t287 = circuit_sub(t286, t269);
    let t288 = circuit_sub(in35, t287);
    let t289 = circuit_sub(in34, t284);
    let t290 = circuit_inverse(t289);
    let t291 = circuit_mul(t288, t290);
    let t292 = circuit_mul(t291, t291);
    let t293 = circuit_add(t284, in34);
    let t294 = circuit_sub(t292, t293);
    let t295 = circuit_add(t287, t287);
    let t296 = circuit_sub(t294, t284);
    let t297 = circuit_inverse(t296);
    let t298 = circuit_mul(t295, t297);
    let t299 = circuit_add(t291, t298);
    let t300 = circuit_mul(t299, t299);
    let t301 = circuit_add(t284, t294);
    let t302 = circuit_sub(t300, t301);
    let t303 = circuit_sub(t302, t284);
    let t304 = circuit_mul(t299, t303);
    let t305 = circuit_sub(t304, t287);
    let t306 = circuit_sub(in37, t305);
    let t307 = circuit_sub(in36, t302);
    let t308 = circuit_inverse(t307);
    let t309 = circuit_mul(t306, t308);
    let t310 = circuit_mul(t309, t309);
    let t311 = circuit_add(t302, in36);
    let t312 = circuit_sub(t310, t311);
    let t313 = circuit_add(t305, t305);
    let t314 = circuit_sub(t312, t302);
    let t315 = circuit_inverse(t314);
    let t316 = circuit_mul(t313, t315);
    let t317 = circuit_add(t309, t316);
    let t318 = circuit_mul(t317, t317);
    let t319 = circuit_add(t302, t312);
    let t320 = circuit_sub(t318, t319);
    let t321 = circuit_sub(t320, t302);
    let t322 = circuit_mul(t317, t321);
    let t323 = circuit_sub(t322, t305);
    let t324 = circuit_sub(in39, t323);
    let t325 = circuit_sub(in38, t320);
    let t326 = circuit_inverse(t325);
    let t327 = circuit_mul(t324, t326);
    let t328 = circuit_mul(t327, t327);
    let t329 = circuit_add(t320, in38);
    let t330 = circuit_sub(t328, t329);
    let t331 = circuit_add(t323, t323);
    let t332 = circuit_sub(t330, t320);
    let t333 = circuit_inverse(t332);
    let t334 = circuit_mul(t331, t333);
    let t335 = circuit_add(t327, t334);
    let t336 = circuit_mul(t335, t335);
    let t337 = circuit_add(t320, t330);
    let t338 = circuit_sub(t336, t337);
    let t339 = circuit_sub(t338, t320);
    let t340 = circuit_mul(t335, t339);
    let t341 = circuit_sub(t340, t323);
    let t342 = circuit_sub(in41, t341);
    let t343 = circuit_sub(in40, t338);
    let t344 = circuit_inverse(t343);
    let t345 = circuit_mul(t342, t344);
    let t346 = circuit_mul(t345, t345);
    let t347 = circuit_add(t338, in40);
    let t348 = circuit_sub(t346, t347);
    let t349 = circuit_add(t341, t341);
    let t350 = circuit_sub(t348, t338);
    let t351 = circuit_inverse(t350);
    let t352 = circuit_mul(t349, t351);
    let t353 = circuit_add(t345, t352);
    let t354 = circuit_mul(t353, t353);
    let t355 = circuit_add(t338, t348);
    let t356 = circuit_sub(t354, t355);
    let t357 = circuit_sub(t356, t338);
    let t358 = circuit_mul(t353, t357);
    let t359 = circuit_sub(t358, t341);
    let t360 = circuit_sub(in43, t359);
    let t361 = circuit_sub(in42, t356);
    let t362 = circuit_inverse(t361);
    let t363 = circuit_mul(t360, t362);
    let t364 = circuit_mul(t363, t363);
    let t365 = circuit_add(t356, in42);
    let t366 = circuit_sub(t364, t365);
    let t367 = circuit_add(t359, t359);
    let t368 = circuit_sub(t366, t356);
    let t369 = circuit_inverse(t368);
    let t370 = circuit_mul(t367, t369);
    let t371 = circuit_add(t363, t370);
    let t372 = circuit_mul(t371, t371);
    let t373 = circuit_add(t356, t366);
    let t374 = circuit_sub(t372, t373);
    let t375 = circuit_sub(t374, t356);
    let t376 = circuit_mul(t371, t375);
    let t377 = circuit_sub(t376, t359);
    let t378 = circuit_sub(in45, t377);
    let t379 = circuit_sub(in44, t374);
    let t380 = circuit_inverse(t379);
    let t381 = circuit_mul(t378, t380);
    let t382 = circuit_mul(t381, t381);
    let t383 = circuit_add(t374, in44);
    let t384 = circuit_sub(t382, t383);
    let t385 = circuit_add(t377, t377);
    let t386 = circuit_sub(t384, t374);
    let t387 = circuit_inverse(t386);
    let t388 = circuit_mul(t385, t387);
    let t389 = circuit_add(t381, t388);
    let t390 = circuit_mul(t389, t389);
    let t391 = circuit_add(t374, t384);
    let t392 = circuit_sub(t390, t391);
    let t393 = circuit_sub(t392, t374);
    let t394 = circuit_mul(t389, t393);
    let t395 = circuit_sub(t394, t377);
    let t396 = circuit_sub(in47, t395);
    let t397 = circuit_sub(in46, t392);
    let t398 = circuit_inverse(t397);
    let t399 = circuit_mul(t396, t398);
    let t400 = circuit_mul(t399, t399);
    let t401 = circuit_add(t392, in46);
    let t402 = circuit_sub(t400, t401);
    let t403 = circuit_add(t395, t395);
    let t404 = circuit_sub(t402, t392);
    let t405 = circuit_inverse(t404);
    let t406 = circuit_mul(t403, t405);
    let t407 = circuit_add(t399, t406);
    let t408 = circuit_mul(t407, t407);
    let t409 = circuit_add(t392, t402);
    let t410 = circuit_sub(t408, t409);
    let t411 = circuit_sub(t410, t392);
    let t412 = circuit_mul(t407, t411);
    let t413 = circuit_sub(t412, t395);
    let t414 = circuit_sub(in49, t413);
    let t415 = circuit_sub(in48, t410);
    let t416 = circuit_inverse(t415);
    let t417 = circuit_mul(t414, t416);
    let t418 = circuit_mul(t417, t417);
    let t419 = circuit_add(t410, in48);
    let t420 = circuit_sub(t418, t419);
    let t421 = circuit_add(t413, t413);
    let t422 = circuit_sub(t420, t410);
    let t423 = circuit_inverse(t422);
    let t424 = circuit_mul(t421, t423);
    let t425 = circuit_add(t417, t424);
    let t426 = circuit_mul(t425, t425);
    let t427 = circuit_add(t410, t420);
    let t428 = circuit_sub(t426, t427);
    let t429 = circuit_sub(t428, t410);
    let t430 = circuit_mul(t425, t429);
    let t431 = circuit_sub(t430, t413);
    let t432 = circuit_sub(in51, t431);
    let t433 = circuit_sub(in50, t428);
    let t434 = circuit_inverse(t433);
    let t435 = circuit_mul(t432, t434);
    let t436 = circuit_mul(t435, t435);
    let t437 = circuit_add(t428, in50);
    let t438 = circuit_sub(t436, t437);
    let t439 = circuit_add(t431, t431);
    let t440 = circuit_sub(t438, t428);
    let t441 = circuit_inverse(t440);
    let t442 = circuit_mul(t439, t441);
    let t443 = circuit_add(t435, t442);
    let t444 = circuit_mul(t443, t443);
    let t445 = circuit_add(t428, t438);
    let t446 = circuit_sub(t444, t445);
    let t447 = circuit_sub(t446, t428);
    let t448 = circuit_mul(t443, t447);
    let t449 = circuit_sub(t448, t431);
    let t450 = circuit_sub(in53, t449);
    let t451 = circuit_sub(in52, t446);
    let t452 = circuit_inverse(t451);
    let t453 = circuit_mul(t450, t452);
    let t454 = circuit_mul(t453, t453);
    let t455 = circuit_add(t446, in52);
    let t456 = circuit_sub(t454, t455);
    let t457 = circuit_add(t449, t449);
    let t458 = circuit_sub(t456, t446);
    let t459 = circuit_inverse(t458);
    let t460 = circuit_mul(t457, t459);
    let t461 = circuit_add(t453, t460);
    let t462 = circuit_mul(t461, t461);
    let t463 = circuit_add(t446, t456);
    let t464 = circuit_sub(t462, t463);
    let t465 = circuit_sub(t464, t446);
    let t466 = circuit_mul(t461, t465);
    let t467 = circuit_sub(t466, t449);
    let t468 = circuit_sub(in55, t467);
    let t469 = circuit_sub(in54, t464);
    let t470 = circuit_inverse(t469);
    let t471 = circuit_mul(t468, t470);
    let t472 = circuit_mul(t471, t471);
    let t473 = circuit_add(t464, in54);
    let t474 = circuit_sub(t472, t473);
    let t475 = circuit_add(t467, t467);
    let t476 = circuit_sub(t474, t464);
    let t477 = circuit_inverse(t476);
    let t478 = circuit_mul(t475, t477);
    let t479 = circuit_add(t471, t478);
    let t480 = circuit_mul(t479, t479);
    let t481 = circuit_add(t464, t474);
    let t482 = circuit_sub(t480, t481);
    let t483 = circuit_sub(t482, t464);
    let t484 = circuit_mul(t479, t483);
    let t485 = circuit_sub(t484, t467);
    let t486 = circuit_sub(in57, t485);
    let t487 = circuit_sub(in56, t482);
    let t488 = circuit_inverse(t487);
    let t489 = circuit_mul(t486, t488);
    let t490 = circuit_mul(t489, t489);
    let t491 = circuit_add(t482, in56);
    let t492 = circuit_sub(t490, t491);
    let t493 = circuit_add(t485, t485);
    let t494 = circuit_sub(t492, t482);
    let t495 = circuit_inverse(t494);
    let t496 = circuit_mul(t493, t495);
    let t497 = circuit_add(t489, t496);
    let t498 = circuit_mul(t497, t497);
    let t499 = circuit_add(t482, t492);
    let t500 = circuit_sub(t498, t499);
    let t501 = circuit_sub(t500, t482);
    let t502 = circuit_mul(t497, t501);
    let t503 = circuit_sub(t502, t485);
    let t504 = circuit_sub(in59, t503);
    let t505 = circuit_sub(in58, t500);
    let t506 = circuit_inverse(t505);
    let t507 = circuit_mul(t504, t506);
    let t508 = circuit_mul(t507, t507);
    let t509 = circuit_add(t500, in58);
    let t510 = circuit_sub(t508, t509);
    let t511 = circuit_add(t503, t503);
    let t512 = circuit_sub(t510, t500);
    let t513 = circuit_inverse(t512);
    let t514 = circuit_mul(t511, t513);
    let t515 = circuit_add(t507, t514);
    let t516 = circuit_mul(t515, t515);
    let t517 = circuit_add(t500, t510);
    let t518 = circuit_sub(t516, t517);
    let t519 = circuit_sub(t518, t500);
    let t520 = circuit_mul(t515, t519);
    let t521 = circuit_sub(t520, t503);
    let t522 = circuit_sub(in61, t521);
    let t523 = circuit_sub(in60, t518);
    let t524 = circuit_inverse(t523);
    let t525 = circuit_mul(t522, t524);
    let t526 = circuit_mul(t525, t525);
    let t527 = circuit_add(t518, in60);
    let t528 = circuit_sub(t526, t527);
    let t529 = circuit_add(t521, t521);
    let t530 = circuit_sub(t528, t518);
    let t531 = circuit_inverse(t530);
    let t532 = circuit_mul(t529, t531);
    let t533 = circuit_add(t525, t532);
    let t534 = circuit_mul(t533, t533);
    let t535 = circuit_add(t518, t528);
    let t536 = circuit_sub(t534, t535);
    let t537 = circuit_sub(t536, t518);
    let t538 = circuit_mul(t533, t537);
    let t539 = circuit_sub(t538, t521);
    let t540 = circuit_sub(in63, t539);
    let t541 = circuit_sub(in62, t536);
    let t542 = circuit_inverse(t541);
    let t543 = circuit_mul(t540, t542);
    let t544 = circuit_mul(t543, t543);
    let t545 = circuit_add(t536, in62);
    let t546 = circuit_sub(t544, t545);
    let t547 = circuit_add(t539, t539);
    let t548 = circuit_sub(t546, t536);
    let t549 = circuit_inverse(t548);
    let t550 = circuit_mul(t547, t549);
    let t551 = circuit_add(t543, t550);
    let t552 = circuit_mul(t551, t551);
    let t553 = circuit_add(t536, t546);
    let t554 = circuit_sub(t552, t553);
    let t555 = circuit_sub(t554, t536);
    let t556 = circuit_mul(t551, t555);
    let t557 = circuit_sub(t556, t539);
    let t558 = circuit_sub(in65, t557);
    let t559 = circuit_sub(in64, t554);
    let t560 = circuit_inverse(t559);
    let t561 = circuit_mul(t558, t560);
    let t562 = circuit_mul(t561, t561);
    let t563 = circuit_add(t554, in64);
    let t564 = circuit_sub(t562, t563);
    let t565 = circuit_add(t557, t557);
    let t566 = circuit_sub(t564, t554);
    let t567 = circuit_inverse(t566);
    let t568 = circuit_mul(t565, t567);
    let t569 = circuit_add(t561, t568);
    let t570 = circuit_mul(t569, t569);
    let t571 = circuit_add(t554, t564);
    let t572 = circuit_sub(t570, t571);
    let t573 = circuit_sub(t572, t554);
    let t574 = circuit_mul(t569, t573);
    let t575 = circuit_sub(t574, t557);
    let t576 = circuit_sub(in67, t575);
    let t577 = circuit_sub(in66, t572);
    let t578 = circuit_inverse(t577);
    let t579 = circuit_mul(t576, t578);
    let t580 = circuit_mul(t579, t579);
    let t581 = circuit_add(t572, in66);
    let t582 = circuit_sub(t580, t581);
    let t583 = circuit_add(t575, t575);
    let t584 = circuit_sub(t582, t572);
    let t585 = circuit_inverse(t584);
    let t586 = circuit_mul(t583, t585);
    let t587 = circuit_add(t579, t586);
    let t588 = circuit_mul(t587, t587);
    let t589 = circuit_add(t572, t582);
    let t590 = circuit_sub(t588, t589);
    let t591 = circuit_sub(t590, t572);
    let t592 = circuit_mul(t587, t591);
    let t593 = circuit_sub(t592, t575);
    let t594 = circuit_sub(in69, t593);
    let t595 = circuit_sub(in68, t590);
    let t596 = circuit_inverse(t595);
    let t597 = circuit_mul(t594, t596);
    let t598 = circuit_mul(t597, t597);
    let t599 = circuit_add(t590, in68);
    let t600 = circuit_sub(t598, t599);
    let t601 = circuit_add(t593, t593);
    let t602 = circuit_sub(t600, t590);
    let t603 = circuit_inverse(t602);
    let t604 = circuit_mul(t601, t603);
    let t605 = circuit_add(t597, t604);
    let t606 = circuit_mul(t605, t605);
    let t607 = circuit_add(t590, t600);
    let t608 = circuit_sub(t606, t607);
    let t609 = circuit_sub(t608, t590);
    let t610 = circuit_mul(t605, t609);
    let t611 = circuit_sub(t610, t593);
    let t612 = circuit_sub(in71, t611);
    let t613 = circuit_sub(in70, t608);
    let t614 = circuit_inverse(t613);
    let t615 = circuit_mul(t612, t614);
    let t616 = circuit_mul(t615, t615);
    let t617 = circuit_add(t608, in70);
    let t618 = circuit_sub(t616, t617);
    let t619 = circuit_add(t611, t611);
    let t620 = circuit_sub(t618, t608);
    let t621 = circuit_inverse(t620);
    let t622 = circuit_mul(t619, t621);
    let t623 = circuit_add(t615, t622);
    let t624 = circuit_mul(t623, t623);
    let t625 = circuit_add(t608, t618);
    let t626 = circuit_sub(t624, t625);
    let t627 = circuit_sub(t626, t608);
    let t628 = circuit_mul(t623, t627);
    let t629 = circuit_sub(t628, t611);
    let t630 = circuit_sub(in73, t629);
    let t631 = circuit_sub(in72, t626);
    let t632 = circuit_inverse(t631);
    let t633 = circuit_mul(t630, t632);
    let t634 = circuit_mul(t633, t633);
    let t635 = circuit_add(t626, in72);
    let t636 = circuit_sub(t634, t635);
    let t637 = circuit_add(t629, t629);
    let t638 = circuit_sub(t636, t626);
    let t639 = circuit_inverse(t638);
    let t640 = circuit_mul(t637, t639);
    let t641 = circuit_add(t633, t640);
    let t642 = circuit_mul(t641, t641);
    let t643 = circuit_add(t626, t636);
    let t644 = circuit_sub(t642, t643);
    let t645 = circuit_sub(t644, t626);
    let t646 = circuit_mul(t641, t645);
    let t647 = circuit_sub(t646, t629);
    let t648 = circuit_sub(in75, t647);
    let t649 = circuit_sub(in74, t644);
    let t650 = circuit_inverse(t649);
    let t651 = circuit_mul(t648, t650);
    let t652 = circuit_mul(t651, t651);
    let t653 = circuit_add(t644, in74);
    let t654 = circuit_sub(t652, t653);
    let t655 = circuit_add(t647, t647);
    let t656 = circuit_sub(t654, t644);
    let t657 = circuit_inverse(t656);
    let t658 = circuit_mul(t655, t657);
    let t659 = circuit_add(t651, t658);
    let t660 = circuit_mul(t659, t659);
    let t661 = circuit_add(t644, t654);
    let t662 = circuit_sub(t660, t661);
    let t663 = circuit_sub(t662, t644);
    let t664 = circuit_mul(t659, t663);
    let t665 = circuit_sub(t664, t647);
    let t666 = circuit_sub(in77, t665);
    let t667 = circuit_sub(in76, t662);
    let t668 = circuit_inverse(t667);
    let t669 = circuit_mul(t666, t668);
    let t670 = circuit_mul(t669, t669);
    let t671 = circuit_add(t662, in76);
    let t672 = circuit_sub(t670, t671);
    let t673 = circuit_add(t665, t665);
    let t674 = circuit_sub(t672, t662);
    let t675 = circuit_inverse(t674);
    let t676 = circuit_mul(t673, t675);
    let t677 = circuit_add(t669, t676);
    let t678 = circuit_mul(t677, t677);
    let t679 = circuit_add(t662, t672);
    let t680 = circuit_sub(t678, t679);
    let t681 = circuit_sub(t680, t662);
    let t682 = circuit_mul(t677, t681);
    let t683 = circuit_sub(t682, t665);
    let t684 = circuit_sub(in79, t683);
    let t685 = circuit_sub(in78, t680);
    let t686 = circuit_inverse(t685);
    let t687 = circuit_mul(t684, t686);
    let t688 = circuit_mul(t687, t687);
    let t689 = circuit_add(t680, in78);
    let t690 = circuit_sub(t688, t689);
    let t691 = circuit_add(t683, t683);
    let t692 = circuit_sub(t690, t680);
    let t693 = circuit_inverse(t692);
    let t694 = circuit_mul(t691, t693);
    let t695 = circuit_add(t687, t694);
    let t696 = circuit_mul(t695, t695);
    let t697 = circuit_add(t680, t690);
    let t698 = circuit_sub(t696, t697);
    let t699 = circuit_sub(t698, t680);
    let t700 = circuit_mul(t695, t699);
    let t701 = circuit_sub(t700, t683);
    let t702 = circuit_sub(in81, t701);
    let t703 = circuit_sub(in80, t698);
    let t704 = circuit_inverse(t703);
    let t705 = circuit_mul(t702, t704);
    let t706 = circuit_mul(t705, t705);
    let t707 = circuit_add(t698, in80);
    let t708 = circuit_sub(t706, t707);
    let t709 = circuit_add(t701, t701);
    let t710 = circuit_sub(t708, t698);
    let t711 = circuit_inverse(t710);
    let t712 = circuit_mul(t709, t711);
    let t713 = circuit_add(t705, t712);
    let t714 = circuit_mul(t713, t713);
    let t715 = circuit_add(t698, t708);
    let t716 = circuit_sub(t714, t715);
    let t717 = circuit_sub(t716, t698);
    let t718 = circuit_mul(t713, t717);
    let t719 = circuit_sub(t718, t701);
    let t720 = circuit_sub(in83, t719);
    let t721 = circuit_sub(in82, t716);
    let t722 = circuit_inverse(t721);
    let t723 = circuit_mul(t720, t722);
    let t724 = circuit_mul(t723, t723);
    let t725 = circuit_add(t716, in82);
    let t726 = circuit_sub(t724, t725);
    let t727 = circuit_add(t719, t719);
    let t728 = circuit_sub(t726, t716);
    let t729 = circuit_inverse(t728);
    let t730 = circuit_mul(t727, t729);
    let t731 = circuit_add(t723, t730);
    let t732 = circuit_mul(t731, t731);
    let t733 = circuit_add(t716, t726);
    let t734 = circuit_sub(t732, t733);
    let t735 = circuit_sub(t734, t716);
    let t736 = circuit_mul(t731, t735);
    let t737 = circuit_sub(t736, t719);
    let t738 = circuit_sub(in85, t737);
    let t739 = circuit_sub(in84, t734);
    let t740 = circuit_inverse(t739);
    let t741 = circuit_mul(t738, t740);
    let t742 = circuit_mul(t741, t741);
    let t743 = circuit_add(t734, in84);
    let t744 = circuit_sub(t742, t743);
    let t745 = circuit_add(t737, t737);
    let t746 = circuit_sub(t744, t734);
    let t747 = circuit_inverse(t746);
    let t748 = circuit_mul(t745, t747);
    let t749 = circuit_add(t741, t748);
    let t750 = circuit_mul(t749, t749);
    let t751 = circuit_add(t734, t744);
    let t752 = circuit_sub(t750, t751);
    let t753 = circuit_sub(t752, t734);
    let t754 = circuit_mul(t749, t753);
    let t755 = circuit_sub(t754, t737);
    let t756 = circuit_sub(in87, t755);
    let t757 = circuit_sub(in86, t752);
    let t758 = circuit_inverse(t757);
    let t759 = circuit_mul(t756, t758);
    let t760 = circuit_mul(t759, t759);
    let t761 = circuit_add(t752, in86);
    let t762 = circuit_sub(t760, t761);
    let t763 = circuit_add(t755, t755);
    let t764 = circuit_sub(t762, t752);
    let t765 = circuit_inverse(t764);
    let t766 = circuit_mul(t763, t765);
    let t767 = circuit_add(t759, t766);
    let t768 = circuit_mul(t767, t767);
    let t769 = circuit_add(t752, t762);
    let t770 = circuit_sub(t768, t769);
    let t771 = circuit_sub(t770, t752);
    let t772 = circuit_mul(t767, t771);
    let t773 = circuit_sub(t772, t755);
    let t774 = circuit_sub(in89, t773);
    let t775 = circuit_sub(in88, t770);
    let t776 = circuit_inverse(t775);
    let t777 = circuit_mul(t774, t776);
    let t778 = circuit_mul(t777, t777);
    let t779 = circuit_add(t770, in88);
    let t780 = circuit_sub(t778, t779);
    let t781 = circuit_add(t773, t773);
    let t782 = circuit_sub(t780, t770);
    let t783 = circuit_inverse(t782);
    let t784 = circuit_mul(t781, t783);
    let t785 = circuit_add(t777, t784);
    let t786 = circuit_mul(t785, t785);
    let t787 = circuit_add(t770, t780);
    let t788 = circuit_sub(t786, t787);
    let t789 = circuit_sub(t788, t770);
    let t790 = circuit_mul(t785, t789);
    let t791 = circuit_sub(t790, t773);
    let t792 = circuit_sub(in91, t791);
    let t793 = circuit_sub(in90, t788);
    let t794 = circuit_inverse(t793);
    let t795 = circuit_mul(t792, t794);
    let t796 = circuit_mul(t795, t795);
    let t797 = circuit_add(t788, in90);
    let t798 = circuit_sub(t796, t797);
    let t799 = circuit_add(t791, t791);
    let t800 = circuit_sub(t798, t788);
    let t801 = circuit_inverse(t800);
    let t802 = circuit_mul(t799, t801);
    let t803 = circuit_add(t795, t802);
    let t804 = circuit_mul(t803, t803);
    let t805 = circuit_add(t788, t798);
    let t806 = circuit_sub(t804, t805);
    let t807 = circuit_sub(t806, t788);
    let t808 = circuit_mul(t803, t807);
    let t809 = circuit_sub(t808, t791);
    let t810 = circuit_sub(in93, t809);
    let t811 = circuit_sub(in92, t806);
    let t812 = circuit_inverse(t811);
    let t813 = circuit_mul(t810, t812);
    let t814 = circuit_mul(t813, t813);
    let t815 = circuit_add(t806, in92);
    let t816 = circuit_sub(t814, t815);
    let t817 = circuit_add(t809, t809);
    let t818 = circuit_sub(t816, t806);
    let t819 = circuit_inverse(t818);
    let t820 = circuit_mul(t817, t819);
    let t821 = circuit_add(t813, t820);
    let t822 = circuit_mul(t821, t821);
    let t823 = circuit_add(t806, t816);
    let t824 = circuit_sub(t822, t823);
    let t825 = circuit_sub(t824, t806);
    let t826 = circuit_mul(t821, t825);
    let t827 = circuit_sub(t826, t809);
    let t828 = circuit_sub(in95, t827);
    let t829 = circuit_sub(in94, t824);
    let t830 = circuit_inverse(t829);
    let t831 = circuit_mul(t828, t830);
    let t832 = circuit_mul(t831, t831);
    let t833 = circuit_add(t824, in94);
    let t834 = circuit_sub(t832, t833);
    let t835 = circuit_add(t827, t827);
    let t836 = circuit_sub(t834, t824);
    let t837 = circuit_inverse(t836);
    let t838 = circuit_mul(t835, t837);
    let t839 = circuit_add(t831, t838);
    let t840 = circuit_mul(t839, t839);
    let t841 = circuit_add(t824, t834);
    let t842 = circuit_sub(t840, t841);
    let t843 = circuit_sub(t842, t824);
    let t844 = circuit_mul(t839, t843);
    let t845 = circuit_sub(t844, t827);
    let t846 = circuit_sub(in97, t845);
    let t847 = circuit_sub(in96, t842);
    let t848 = circuit_inverse(t847);
    let t849 = circuit_mul(t846, t848);
    let t850 = circuit_mul(t849, t849);
    let t851 = circuit_add(t842, in96);
    let t852 = circuit_sub(t850, t851);
    let t853 = circuit_add(t845, t845);
    let t854 = circuit_sub(t852, t842);
    let t855 = circuit_inverse(t854);
    let t856 = circuit_mul(t853, t855);
    let t857 = circuit_add(t849, t856);
    let t858 = circuit_mul(t857, t857);
    let t859 = circuit_add(t842, t852);
    let t860 = circuit_sub(t858, t859);
    let t861 = circuit_sub(t860, t842);
    let t862 = circuit_mul(t857, t861);
    let t863 = circuit_sub(t862, t845);
    let t864 = circuit_sub(in99, t863);
    let t865 = circuit_sub(in98, t860);
    let t866 = circuit_inverse(t865);
    let t867 = circuit_mul(t864, t866);
    let t868 = circuit_mul(t867, t867);
    let t869 = circuit_add(t860, in98);
    let t870 = circuit_sub(t868, t869);
    let t871 = circuit_add(t863, t863);
    let t872 = circuit_sub(t870, t860);
    let t873 = circuit_inverse(t872);
    let t874 = circuit_mul(t871, t873);
    let t875 = circuit_add(t867, t874);
    let t876 = circuit_mul(t875, t875);
    let t877 = circuit_add(t860, t870);
    let t878 = circuit_sub(t876, t877);
    let t879 = circuit_sub(t878, t860);
    let t880 = circuit_mul(t875, t879);
    let t881 = circuit_sub(t880, t863);
    let t882 = circuit_sub(in101, t881);
    let t883 = circuit_sub(in100, t878);
    let t884 = circuit_inverse(t883);
    let t885 = circuit_mul(t882, t884);
    let t886 = circuit_mul(t885, t885);
    let t887 = circuit_add(t878, in100);
    let t888 = circuit_sub(t886, t887);
    let t889 = circuit_add(t881, t881);
    let t890 = circuit_sub(t888, t878);
    let t891 = circuit_inverse(t890);
    let t892 = circuit_mul(t889, t891);
    let t893 = circuit_add(t885, t892);
    let t894 = circuit_mul(t893, t893);
    let t895 = circuit_add(t878, t888);
    let t896 = circuit_sub(t894, t895);
    let t897 = circuit_sub(t896, t878);
    let t898 = circuit_mul(t893, t897);
    let t899 = circuit_sub(t898, t881);
    let t900 = circuit_sub(in103, t899);
    let t901 = circuit_sub(in102, t896);
    let t902 = circuit_inverse(t901);
    let t903 = circuit_mul(t900, t902);
    let t904 = circuit_mul(t903, t903);
    let t905 = circuit_add(t896, in102);
    let t906 = circuit_sub(t904, t905);
    let t907 = circuit_add(t899, t899);
    let t908 = circuit_sub(t906, t896);
    let t909 = circuit_inverse(t908);
    let t910 = circuit_mul(t907, t909);
    let t911 = circuit_add(t903, t910);
    let t912 = circuit_mul(t911, t911);
    let t913 = circuit_add(t896, t906);
    let t914 = circuit_sub(t912, t913);
    let t915 = circuit_sub(t914, t896);
    let t916 = circuit_mul(t911, t915);
    let t917 = circuit_sub(t916, t899);
    let t918 = circuit_sub(in105, t917);
    let t919 = circuit_sub(in104, t914);
    let t920 = circuit_inverse(t919);
    let t921 = circuit_mul(t918, t920);
    let t922 = circuit_mul(t921, t921);
    let t923 = circuit_add(t914, in104);
    let t924 = circuit_sub(t922, t923);
    let t925 = circuit_add(t917, t917);
    let t926 = circuit_sub(t924, t914);
    let t927 = circuit_inverse(t926);
    let t928 = circuit_mul(t925, t927);
    let t929 = circuit_add(t921, t928);
    let t930 = circuit_mul(t929, t929);
    let t931 = circuit_add(t914, t924);
    let t932 = circuit_sub(t930, t931);
    let t933 = circuit_sub(t932, t914);
    let t934 = circuit_mul(t929, t933);
    let t935 = circuit_sub(t934, t917);
    let t936 = circuit_sub(in107, t935);
    let t937 = circuit_sub(in106, t932);
    let t938 = circuit_inverse(t937);
    let t939 = circuit_mul(t936, t938);
    let t940 = circuit_mul(t939, t939);
    let t941 = circuit_add(t932, in106);
    let t942 = circuit_sub(t940, t941);
    let t943 = circuit_add(t935, t935);
    let t944 = circuit_sub(t942, t932);
    let t945 = circuit_inverse(t944);
    let t946 = circuit_mul(t943, t945);
    let t947 = circuit_add(t939, t946);
    let t948 = circuit_mul(t947, t947);
    let t949 = circuit_add(t932, t942);
    let t950 = circuit_sub(t948, t949);
    let t951 = circuit_sub(t950, t932);
    let t952 = circuit_mul(t947, t951);
    let t953 = circuit_sub(t952, t935);
    let t954 = circuit_sub(in109, t953);
    let t955 = circuit_sub(in108, t950);
    let t956 = circuit_inverse(t955);
    let t957 = circuit_mul(t954, t956);
    let t958 = circuit_mul(t957, t957);
    let t959 = circuit_add(t950, in108);
    let t960 = circuit_sub(t958, t959);
    let t961 = circuit_add(t953, t953);
    let t962 = circuit_sub(t960, t950);
    let t963 = circuit_inverse(t962);
    let t964 = circuit_mul(t961, t963);
    let t965 = circuit_add(t957, t964);
    let t966 = circuit_mul(t965, t965);
    let t967 = circuit_add(t950, t960);
    let t968 = circuit_sub(t966, t967);
    let t969 = circuit_sub(t968, t950);
    let t970 = circuit_mul(t965, t969);
    let t971 = circuit_sub(t970, t953);
    let t972 = circuit_sub(in111, t971);
    let t973 = circuit_sub(in110, t968);
    let t974 = circuit_inverse(t973);
    let t975 = circuit_mul(t972, t974);
    let t976 = circuit_mul(t975, t975);
    let t977 = circuit_add(t968, in110);
    let t978 = circuit_sub(t976, t977);
    let t979 = circuit_add(t971, t971);
    let t980 = circuit_sub(t978, t968);
    let t981 = circuit_inverse(t980);
    let t982 = circuit_mul(t979, t981);
    let t983 = circuit_add(t975, t982);
    let t984 = circuit_mul(t983, t983);
    let t985 = circuit_add(t968, t978);
    let t986 = circuit_sub(t984, t985);
    let t987 = circuit_sub(t986, t968);
    let t988 = circuit_mul(t983, t987);
    let t989 = circuit_sub(t988, t971);
    let t990 = circuit_sub(in113, t989);
    let t991 = circuit_sub(in112, t986);
    let t992 = circuit_inverse(t991);
    let t993 = circuit_mul(t990, t992);
    let t994 = circuit_mul(t993, t993);
    let t995 = circuit_add(t986, in112);
    let t996 = circuit_sub(t994, t995);
    let t997 = circuit_add(t989, t989);
    let t998 = circuit_sub(t996, t986);
    let t999 = circuit_inverse(t998);
    let t1000 = circuit_mul(t997, t999);
    let t1001 = circuit_add(t993, t1000);
    let t1002 = circuit_mul(t1001, t1001);
    let t1003 = circuit_add(t986, t996);
    let t1004 = circuit_sub(t1002, t1003);
    let t1005 = circuit_sub(t1004, t986);
    let t1006 = circuit_mul(t1001, t1005);
    let t1007 = circuit_sub(t1006, t989);
    let t1008 = circuit_sub(in115, t1007);
    let t1009 = circuit_sub(in114, t1004);
    let t1010 = circuit_inverse(t1009);
    let t1011 = circuit_mul(t1008, t1010);
    let t1012 = circuit_mul(t1011, t1011);
    let t1013 = circuit_add(t1004, in114);
    let t1014 = circuit_sub(t1012, t1013);
    let t1015 = circuit_add(t1007, t1007);
    let t1016 = circuit_sub(t1014, t1004);
    let t1017 = circuit_inverse(t1016);
    let t1018 = circuit_mul(t1015, t1017);
    let t1019 = circuit_add(t1011, t1018);
    let t1020 = circuit_mul(t1019, t1019);
    let t1021 = circuit_add(t1004, t1014);
    let t1022 = circuit_sub(t1020, t1021);
    let t1023 = circuit_sub(t1022, t1004);
    let t1024 = circuit_mul(t1019, t1023);
    let t1025 = circuit_sub(t1024, t1007);
    let t1026 = circuit_sub(in117, t1025);
    let t1027 = circuit_sub(in116, t1022);
    let t1028 = circuit_inverse(t1027);
    let t1029 = circuit_mul(t1026, t1028);
    let t1030 = circuit_mul(t1029, t1029);
    let t1031 = circuit_add(t1022, in116);
    let t1032 = circuit_sub(t1030, t1031);
    let t1033 = circuit_add(t1025, t1025);
    let t1034 = circuit_sub(t1032, t1022);
    let t1035 = circuit_inverse(t1034);
    let t1036 = circuit_mul(t1033, t1035);
    let t1037 = circuit_add(t1029, t1036);
    let t1038 = circuit_mul(t1037, t1037);
    let t1039 = circuit_add(t1022, t1032);
    let t1040 = circuit_sub(t1038, t1039);
    let t1041 = circuit_sub(t1040, t1022);
    let t1042 = circuit_mul(t1037, t1041);
    let t1043 = circuit_sub(t1042, t1025);
    let t1044 = circuit_sub(in119, t1043);
    let t1045 = circuit_sub(in118, t1040);
    let t1046 = circuit_inverse(t1045);
    let t1047 = circuit_mul(t1044, t1046);
    let t1048 = circuit_mul(t1047, t1047);
    let t1049 = circuit_add(t1040, in118);
    let t1050 = circuit_sub(t1048, t1049);
    let t1051 = circuit_add(t1043, t1043);
    let t1052 = circuit_sub(t1050, t1040);
    let t1053 = circuit_inverse(t1052);
    let t1054 = circuit_mul(t1051, t1053);
    let t1055 = circuit_add(t1047, t1054);
    let t1056 = circuit_mul(t1055, t1055);
    let t1057 = circuit_add(t1040, t1050);
    let t1058 = circuit_sub(t1056, t1057);
    let t1059 = circuit_sub(t1058, t1040);
    let t1060 = circuit_mul(t1055, t1059);
    let t1061 = circuit_sub(t1060, t1043);
    let t1062 = circuit_sub(in121, t1061);
    let t1063 = circuit_sub(in120, t1058);
    let t1064 = circuit_inverse(t1063);
    let t1065 = circuit_mul(t1062, t1064);
    let t1066 = circuit_mul(t1065, t1065);
    let t1067 = circuit_add(t1058, in120);
    let t1068 = circuit_sub(t1066, t1067);
    let t1069 = circuit_add(t1061, t1061);
    let t1070 = circuit_sub(t1068, t1058);
    let t1071 = circuit_inverse(t1070);
    let t1072 = circuit_mul(t1069, t1071);
    let t1073 = circuit_add(t1065, t1072);
    let t1074 = circuit_mul(t1073, t1073);
    let t1075 = circuit_add(t1058, t1068);
    let t1076 = circuit_sub(t1074, t1075);
    let t1077 = circuit_sub(t1076, t1058);
    let t1078 = circuit_mul(t1073, t1077);
    let t1079 = circuit_sub(t1078, t1061);
    let t1080 = circuit_sub(in123, t1079);
    let t1081 = circuit_sub(in122, t1076);
    let t1082 = circuit_inverse(t1081);
    let t1083 = circuit_mul(t1080, t1082);
    let t1084 = circuit_mul(t1083, t1083);
    let t1085 = circuit_add(t1076, in122);
    let t1086 = circuit_sub(t1084, t1085);
    let t1087 = circuit_add(t1079, t1079);
    let t1088 = circuit_sub(t1086, t1076);
    let t1089 = circuit_inverse(t1088);
    let t1090 = circuit_mul(t1087, t1089);
    let t1091 = circuit_add(t1083, t1090);
    let t1092 = circuit_mul(t1091, t1091);
    let t1093 = circuit_add(t1076, t1086);
    let t1094 = circuit_sub(t1092, t1093);
    let t1095 = circuit_sub(t1094, t1076);
    let t1096 = circuit_mul(t1091, t1095);
    let t1097 = circuit_sub(t1096, t1079);
    let t1098 = circuit_sub(in125, t1097);
    let t1099 = circuit_sub(in124, t1094);
    let t1100 = circuit_inverse(t1099);
    let t1101 = circuit_mul(t1098, t1100);
    let t1102 = circuit_mul(t1101, t1101);
    let t1103 = circuit_add(t1094, in124);
    let t1104 = circuit_sub(t1102, t1103);
    let t1105 = circuit_add(t1097, t1097);
    let t1106 = circuit_sub(t1104, t1094);
    let t1107 = circuit_inverse(t1106);
    let t1108 = circuit_mul(t1105, t1107);
    let t1109 = circuit_add(t1101, t1108);
    let t1110 = circuit_mul(t1109, t1109);
    let t1111 = circuit_add(t1094, t1104);
    let t1112 = circuit_sub(t1110, t1111);
    let t1113 = circuit_sub(t1112, t1094);
    let t1114 = circuit_mul(t1109, t1113);
    let t1115 = circuit_sub(t1114, t1097);
    let t1116 = circuit_sub(in127, t1115);
    let t1117 = circuit_sub(in126, t1112);
    let t1118 = circuit_inverse(t1117);
    let t1119 = circuit_mul(t1116, t1118);
    let t1120 = circuit_mul(t1119, t1119);
    let t1121 = circuit_add(t1112, in126);
    let t1122 = circuit_sub(t1120, t1121);
    let t1123 = circuit_add(t1115, t1115);
    let t1124 = circuit_sub(t1122, t1112);
    let t1125 = circuit_inverse(t1124);
    let t1126 = circuit_mul(t1123, t1125);
    let t1127 = circuit_add(t1119, t1126);
    let t1128 = circuit_mul(t1127, t1127);
    let t1129 = circuit_add(t1112, t1122);
    let t1130 = circuit_sub(t1128, t1129);
    let t1131 = circuit_sub(t1130, t1112);
    let t1132 = circuit_mul(t1127, t1131);
    let t1133 = circuit_sub(t1132, t1115);
    let t1134 = circuit_sub(in129, t1133);
    let t1135 = circuit_sub(in128, t1130);
    let t1136 = circuit_inverse(t1135);
    let t1137 = circuit_mul(t1134, t1136);
    let t1138 = circuit_mul(t1137, t1137);
    let t1139 = circuit_add(t1130, in128);
    let t1140 = circuit_sub(t1138, t1139);
    let t1141 = circuit_add(t1133, t1133);
    let t1142 = circuit_sub(t1140, t1130);
    let t1143 = circuit_inverse(t1142);
    let t1144 = circuit_mul(t1141, t1143);
    let t1145 = circuit_add(t1137, t1144);
    let t1146 = circuit_mul(t1145, t1145);
    let t1147 = circuit_add(t1130, t1140);
    let t1148 = circuit_sub(t1146, t1147);
    let t1149 = circuit_sub(t1148, t1130);
    let t1150 = circuit_mul(t1145, t1149);
    let t1151 = circuit_sub(t1150, t1133);
    let t1152 = circuit_sub(in131, t1151);
    let t1153 = circuit_sub(in130, t1148);
    let t1154 = circuit_inverse(t1153);
    let t1155 = circuit_mul(t1152, t1154);
    let t1156 = circuit_mul(t1155, t1155);
    let t1157 = circuit_add(t1148, in130);
    let t1158 = circuit_sub(t1156, t1157);
    let t1159 = circuit_add(t1151, t1151);
    let t1160 = circuit_sub(t1158, t1148);
    let t1161 = circuit_inverse(t1160);
    let t1162 = circuit_mul(t1159, t1161);
    let t1163 = circuit_add(t1155, t1162);
    let t1164 = circuit_mul(t1163, t1163);
    let t1165 = circuit_add(t1148, t1158);
    let t1166 = circuit_sub(t1164, t1165);
    let t1167 = circuit_sub(t1166, t1148);
    let t1168 = circuit_mul(t1163, t1167);
    let t1169 = circuit_sub(t1168, t1151);
    let t1170 = circuit_sub(in133, t1169);
    let t1171 = circuit_sub(in132, t1166);
    let t1172 = circuit_inverse(t1171);
    let t1173 = circuit_mul(t1170, t1172);
    let t1174 = circuit_mul(t1173, t1173);
    let t1175 = circuit_add(t1166, in132);
    let t1176 = circuit_sub(t1174, t1175);
    let t1177 = circuit_add(t1169, t1169);
    let t1178 = circuit_sub(t1176, t1166);
    let t1179 = circuit_inverse(t1178);
    let t1180 = circuit_mul(t1177, t1179);
    let t1181 = circuit_add(t1173, t1180);
    let t1182 = circuit_mul(t1181, t1181);
    let t1183 = circuit_add(t1166, t1176);
    let t1184 = circuit_sub(t1182, t1183);
    let t1185 = circuit_sub(t1184, t1166);
    let t1186 = circuit_mul(t1181, t1185);
    let t1187 = circuit_sub(t1186, t1169);
    let t1188 = circuit_sub(in135, t1187);
    let t1189 = circuit_sub(in134, t1184);
    let t1190 = circuit_inverse(t1189);
    let t1191 = circuit_mul(t1188, t1190);
    let t1192 = circuit_mul(t1191, t1191);
    let t1193 = circuit_add(t1184, in134);
    let t1194 = circuit_sub(t1192, t1193);
    let t1195 = circuit_add(t1187, t1187);
    let t1196 = circuit_sub(t1194, t1184);
    let t1197 = circuit_inverse(t1196);
    let t1198 = circuit_mul(t1195, t1197);
    let t1199 = circuit_add(t1191, t1198);
    let t1200 = circuit_mul(t1199, t1199);
    let t1201 = circuit_add(t1184, t1194);
    let t1202 = circuit_sub(t1200, t1201);
    let t1203 = circuit_sub(t1202, t1184);
    let t1204 = circuit_mul(t1199, t1203);
    let t1205 = circuit_sub(t1204, t1187);
    let t1206 = circuit_sub(in137, t1205);
    let t1207 = circuit_sub(in136, t1202);
    let t1208 = circuit_inverse(t1207);
    let t1209 = circuit_mul(t1206, t1208);
    let t1210 = circuit_mul(t1209, t1209);
    let t1211 = circuit_add(t1202, in136);
    let t1212 = circuit_sub(t1210, t1211);
    let t1213 = circuit_add(t1205, t1205);
    let t1214 = circuit_sub(t1212, t1202);
    let t1215 = circuit_inverse(t1214);
    let t1216 = circuit_mul(t1213, t1215);
    let t1217 = circuit_add(t1209, t1216);
    let t1218 = circuit_mul(t1217, t1217);
    let t1219 = circuit_add(t1202, t1212);
    let t1220 = circuit_sub(t1218, t1219);
    let t1221 = circuit_sub(t1220, t1202);
    let t1222 = circuit_mul(t1217, t1221);
    let t1223 = circuit_sub(t1222, t1205);
    let t1224 = circuit_sub(in139, t1223);
    let t1225 = circuit_sub(in138, t1220);
    let t1226 = circuit_inverse(t1225);
    let t1227 = circuit_mul(t1224, t1226);
    let t1228 = circuit_mul(t1227, t1227);
    let t1229 = circuit_add(t1220, in138);
    let t1230 = circuit_sub(t1228, t1229);
    let t1231 = circuit_add(t1223, t1223);
    let t1232 = circuit_sub(t1230, t1220);
    let t1233 = circuit_inverse(t1232);
    let t1234 = circuit_mul(t1231, t1233);
    let t1235 = circuit_add(t1227, t1234);
    let t1236 = circuit_mul(t1235, t1235);
    let t1237 = circuit_add(t1220, t1230);
    let t1238 = circuit_sub(t1236, t1237);
    let t1239 = circuit_sub(t1238, t1220);
    let t1240 = circuit_mul(t1235, t1239);
    let t1241 = circuit_sub(t1240, t1223);
    let t1242 = circuit_sub(in141, t1241);
    let t1243 = circuit_sub(in140, t1238);
    let t1244 = circuit_inverse(t1243);
    let t1245 = circuit_mul(t1242, t1244);
    let t1246 = circuit_mul(t1245, t1245);
    let t1247 = circuit_add(t1238, in140);
    let t1248 = circuit_sub(t1246, t1247);
    let t1249 = circuit_add(t1241, t1241);
    let t1250 = circuit_sub(t1248, t1238);
    let t1251 = circuit_inverse(t1250);
    let t1252 = circuit_mul(t1249, t1251);
    let t1253 = circuit_add(t1245, t1252);
    let t1254 = circuit_mul(t1253, t1253);
    let t1255 = circuit_add(t1238, t1248);
    let t1256 = circuit_sub(t1254, t1255);
    let t1257 = circuit_sub(t1256, t1238);
    let t1258 = circuit_mul(t1253, t1257);
    let t1259 = circuit_sub(t1258, t1241);
    let t1260 = circuit_sub(in143, t1259);
    let t1261 = circuit_sub(in142, t1256);
    let t1262 = circuit_inverse(t1261);
    let t1263 = circuit_mul(t1260, t1262);
    let t1264 = circuit_mul(t1263, t1263);
    let t1265 = circuit_add(t1256, in142);
    let t1266 = circuit_sub(t1264, t1265);
    let t1267 = circuit_add(t1259, t1259);
    let t1268 = circuit_sub(t1266, t1256);
    let t1269 = circuit_inverse(t1268);
    let t1270 = circuit_mul(t1267, t1269);
    let t1271 = circuit_add(t1263, t1270);
    let t1272 = circuit_mul(t1271, t1271);
    let t1273 = circuit_add(t1256, t1266);
    let t1274 = circuit_sub(t1272, t1273);
    let t1275 = circuit_sub(t1274, t1256);
    let t1276 = circuit_mul(t1271, t1275);
    let t1277 = circuit_sub(t1276, t1259);
    let t1278 = circuit_sub(in145, t1277);
    let t1279 = circuit_sub(in144, t1274);
    let t1280 = circuit_inverse(t1279);
    let t1281 = circuit_mul(t1278, t1280);
    let t1282 = circuit_mul(t1281, t1281);
    let t1283 = circuit_add(t1274, in144);
    let t1284 = circuit_sub(t1282, t1283);
    let t1285 = circuit_add(t1277, t1277);
    let t1286 = circuit_sub(t1284, t1274);
    let t1287 = circuit_inverse(t1286);
    let t1288 = circuit_mul(t1285, t1287);
    let t1289 = circuit_add(t1281, t1288);
    let t1290 = circuit_mul(t1289, t1289);
    let t1291 = circuit_add(t1274, t1284);
    let t1292 = circuit_sub(t1290, t1291);
    let t1293 = circuit_sub(t1292, t1274);
    let t1294 = circuit_mul(t1289, t1293);
    let t1295 = circuit_sub(t1294, t1277);

    let modulus = modulus;

    let mut circuit_inputs = (t1292, t1295).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(P.x); // in0
    circuit_inputs = circuit_inputs.next_2(P.y); // in1
    circuit_inputs = circuit_inputs.next_2(Q_1.x); // in2
    circuit_inputs = circuit_inputs.next_2(Q_1.y); // in3
    circuit_inputs = circuit_inputs.next_2(Q_2.x); // in4
    circuit_inputs = circuit_inputs.next_2(Q_2.y); // in5
    circuit_inputs = circuit_inputs.next_2(Q_3.x); // in6
    circuit_inputs = circuit_inputs.next_2(Q_3.y); // in7
    circuit_inputs = circuit_inputs.next_2(Q_4.x); // in8
    circuit_inputs = circuit_inputs.next_2(Q_4.y); // in9
    circuit_inputs = circuit_inputs.next_2(Q_5.x); // in10
    circuit_inputs = circuit_inputs.next_2(Q_5.y); // in11
    circuit_inputs = circuit_inputs.next_2(Q_6.x); // in12
    circuit_inputs = circuit_inputs.next_2(Q_6.y); // in13
    circuit_inputs = circuit_inputs.next_2(Q_7.x); // in14
    circuit_inputs = circuit_inputs.next_2(Q_7.y); // in15
    circuit_inputs = circuit_inputs.next_2(Q_8.x); // in16
    circuit_inputs = circuit_inputs.next_2(Q_8.y); // in17
    circuit_inputs = circuit_inputs.next_2(Q_9.x); // in18
    circuit_inputs = circuit_inputs.next_2(Q_9.y); // in19
    circuit_inputs = circuit_inputs.next_2(Q_10.x); // in20
    circuit_inputs = circuit_inputs.next_2(Q_10.y); // in21
    circuit_inputs = circuit_inputs.next_2(Q_11.x); // in22
    circuit_inputs = circuit_inputs.next_2(Q_11.y); // in23
    circuit_inputs = circuit_inputs.next_2(Q_12.x); // in24
    circuit_inputs = circuit_inputs.next_2(Q_12.y); // in25
    circuit_inputs = circuit_inputs.next_2(Q_13.x); // in26
    circuit_inputs = circuit_inputs.next_2(Q_13.y); // in27
    circuit_inputs = circuit_inputs.next_2(Q_14.x); // in28
    circuit_inputs = circuit_inputs.next_2(Q_14.y); // in29
    circuit_inputs = circuit_inputs.next_2(Q_15.x); // in30
    circuit_inputs = circuit_inputs.next_2(Q_15.y); // in31
    circuit_inputs = circuit_inputs.next_2(Q_16.x); // in32
    circuit_inputs = circuit_inputs.next_2(Q_16.y); // in33
    circuit_inputs = circuit_inputs.next_2(Q_17.x); // in34
    circuit_inputs = circuit_inputs.next_2(Q_17.y); // in35
    circuit_inputs = circuit_inputs.next_2(Q_18.x); // in36
    circuit_inputs = circuit_inputs.next_2(Q_18.y); // in37
    circuit_inputs = circuit_inputs.next_2(Q_19.x); // in38
    circuit_inputs = circuit_inputs.next_2(Q_19.y); // in39
    circuit_inputs = circuit_inputs.next_2(Q_20.x); // in40
    circuit_inputs = circuit_inputs.next_2(Q_20.y); // in41
    circuit_inputs = circuit_inputs.next_2(Q_21.x); // in42
    circuit_inputs = circuit_inputs.next_2(Q_21.y); // in43
    circuit_inputs = circuit_inputs.next_2(Q_22.x); // in44
    circuit_inputs = circuit_inputs.next_2(Q_22.y); // in45
    circuit_inputs = circuit_inputs.next_2(Q_23.x); // in46
    circuit_inputs = circuit_inputs.next_2(Q_23.y); // in47
    circuit_inputs = circuit_inputs.next_2(Q_24.x); // in48
    circuit_inputs = circuit_inputs.next_2(Q_24.y); // in49
    circuit_inputs = circuit_inputs.next_2(Q_25.x); // in50
    circuit_inputs = circuit_inputs.next_2(Q_25.y); // in51
    circuit_inputs = circuit_inputs.next_2(Q_26.x); // in52
    circuit_inputs = circuit_inputs.next_2(Q_26.y); // in53
    circuit_inputs = circuit_inputs.next_2(Q_27.x); // in54
    circuit_inputs = circuit_inputs.next_2(Q_27.y); // in55
    circuit_inputs = circuit_inputs.next_2(Q_28.x); // in56
    circuit_inputs = circuit_inputs.next_2(Q_28.y); // in57
    circuit_inputs = circuit_inputs.next_2(Q_29.x); // in58
    circuit_inputs = circuit_inputs.next_2(Q_29.y); // in59
    circuit_inputs = circuit_inputs.next_2(Q_30.x); // in60
    circuit_inputs = circuit_inputs.next_2(Q_30.y); // in61
    circuit_inputs = circuit_inputs.next_2(Q_31.x); // in62
    circuit_inputs = circuit_inputs.next_2(Q_31.y); // in63
    circuit_inputs = circuit_inputs.next_2(Q_32.x); // in64
    circuit_inputs = circuit_inputs.next_2(Q_32.y); // in65
    circuit_inputs = circuit_inputs.next_2(Q_33.x); // in66
    circuit_inputs = circuit_inputs.next_2(Q_33.y); // in67
    circuit_inputs = circuit_inputs.next_2(Q_34.x); // in68
    circuit_inputs = circuit_inputs.next_2(Q_34.y); // in69
    circuit_inputs = circuit_inputs.next_2(Q_35.x); // in70
    circuit_inputs = circuit_inputs.next_2(Q_35.y); // in71
    circuit_inputs = circuit_inputs.next_2(Q_36.x); // in72
    circuit_inputs = circuit_inputs.next_2(Q_36.y); // in73
    circuit_inputs = circuit_inputs.next_2(Q_37.x); // in74
    circuit_inputs = circuit_inputs.next_2(Q_37.y); // in75
    circuit_inputs = circuit_inputs.next_2(Q_38.x); // in76
    circuit_inputs = circuit_inputs.next_2(Q_38.y); // in77
    circuit_inputs = circuit_inputs.next_2(Q_39.x); // in78
    circuit_inputs = circuit_inputs.next_2(Q_39.y); // in79
    circuit_inputs = circuit_inputs.next_2(Q_40.x); // in80
    circuit_inputs = circuit_inputs.next_2(Q_40.y); // in81
    circuit_inputs = circuit_inputs.next_2(Q_41.x); // in82
    circuit_inputs = circuit_inputs.next_2(Q_41.y); // in83
    circuit_inputs = circuit_inputs.next_2(Q_42.x); // in84
    circuit_inputs = circuit_inputs.next_2(Q_42.y); // in85
    circuit_inputs = circuit_inputs.next_2(Q_43.x); // in86
    circuit_inputs = circuit_inputs.next_2(Q_43.y); // in87
    circuit_inputs = circuit_inputs.next_2(Q_44.x); // in88
    circuit_inputs = circuit_inputs.next_2(Q_44.y); // in89
    circuit_inputs = circuit_inputs.next_2(Q_45.x); // in90
    circuit_inputs = circuit_inputs.next_2(Q_45.y); // in91
    circuit_inputs = circuit_inputs.next_2(Q_46.x); // in92
    circuit_inputs = circuit_inputs.next_2(Q_46.y); // in93
    circuit_inputs = circuit_inputs.next_2(Q_47.x); // in94
    circuit_inputs = circuit_inputs.next_2(Q_47.y); // in95
    circuit_inputs = circuit_inputs.next_2(Q_48.x); // in96
    circuit_inputs = circuit_inputs.next_2(Q_48.y); // in97
    circuit_inputs = circuit_inputs.next_2(Q_49.x); // in98
    circuit_inputs = circuit_inputs.next_2(Q_49.y); // in99
    circuit_inputs = circuit_inputs.next_2(Q_50.x); // in100
    circuit_inputs = circuit_inputs.next_2(Q_50.y); // in101
    circuit_inputs = circuit_inputs.next_2(Q_51.x); // in102
    circuit_inputs = circuit_inputs.next_2(Q_51.y); // in103
    circuit_inputs = circuit_inputs.next_2(Q_52.x); // in104
    circuit_inputs = circuit_inputs.next_2(Q_52.y); // in105
    circuit_inputs = circuit_inputs.next_2(Q_53.x); // in106
    circuit_inputs = circuit_inputs.next_2(Q_53.y); // in107
    circuit_inputs = circuit_inputs.next_2(Q_54.x); // in108
    circuit_inputs = circuit_inputs.next_2(Q_54.y); // in109
    circuit_inputs = circuit_inputs.next_2(Q_55.x); // in110
    circuit_inputs = circuit_inputs.next_2(Q_55.y); // in111
    circuit_inputs = circuit_inputs.next_2(Q_56.x); // in112
    circuit_inputs = circuit_inputs.next_2(Q_56.y); // in113
    circuit_inputs = circuit_inputs.next_2(Q_57.x); // in114
    circuit_inputs = circuit_inputs.next_2(Q_57.y); // in115
    circuit_inputs = circuit_inputs.next_2(Q_58.x); // in116
    circuit_inputs = circuit_inputs.next_2(Q_58.y); // in117
    circuit_inputs = circuit_inputs.next_2(Q_59.x); // in118
    circuit_inputs = circuit_inputs.next_2(Q_59.y); // in119
    circuit_inputs = circuit_inputs.next_2(Q_60.x); // in120
    circuit_inputs = circuit_inputs.next_2(Q_60.y); // in121
    circuit_inputs = circuit_inputs.next_2(Q_61.x); // in122
    circuit_inputs = circuit_inputs.next_2(Q_61.y); // in123
    circuit_inputs = circuit_inputs.next_2(Q_62.x); // in124
    circuit_inputs = circuit_inputs.next_2(Q_62.y); // in125
    circuit_inputs = circuit_inputs.next_2(Q_63.x); // in126
    circuit_inputs = circuit_inputs.next_2(Q_63.y); // in127
    circuit_inputs = circuit_inputs.next_2(Q_64.x); // in128
    circuit_inputs = circuit_inputs.next_2(Q_64.y); // in129
    circuit_inputs = circuit_inputs.next_2(Q_65.x); // in130
    circuit_inputs = circuit_inputs.next_2(Q_65.y); // in131
    circuit_inputs = circuit_inputs.next_2(Q_66.x); // in132
    circuit_inputs = circuit_inputs.next_2(Q_66.y); // in133
    circuit_inputs = circuit_inputs.next_2(Q_67.x); // in134
    circuit_inputs = circuit_inputs.next_2(Q_67.y); // in135
    circuit_inputs = circuit_inputs.next_2(Q_68.x); // in136
    circuit_inputs = circuit_inputs.next_2(Q_68.y); // in137
    circuit_inputs = circuit_inputs.next_2(Q_69.x); // in138
    circuit_inputs = circuit_inputs.next_2(Q_69.y); // in139
    circuit_inputs = circuit_inputs.next_2(Q_70.x); // in140
    circuit_inputs = circuit_inputs.next_2(Q_70.y); // in141
    circuit_inputs = circuit_inputs.next_2(Q_71.x); // in142
    circuit_inputs = circuit_inputs.next_2(Q_71.y); // in143
    circuit_inputs = circuit_inputs.next_2(Q_72.x); // in144
    circuit_inputs = circuit_inputs.next_2(Q_72.y); // in145

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let R: G1Point = G1Point { x: outputs.get_output(t1292), y: outputs.get_output(t1295) };
    return (R,);
}
#[inline(always)]
pub fn run_DOUBLE_EC_POINT_G2_A_EQ_0_circuit(p: G2Point, curve_index: usize) -> (G2Point,) {
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

    let modulus = get_modulus(curve_index);

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
    p: G1Point, A_weirstrass: u384, modulus: CircuitModulus,
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

    let modulus = get_modulus(curve_index);

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

    let modulus = get_modulus(curve_index);

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

    let modulus = get_modulus(curve_index);

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
    P: G1Point, Q: G1Point, s2_sign: u384, A_weirstrass: u384, modulus: CircuitModulus,
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
    let t0 = circuit_sub(in0, in1);
    let t1 = circuit_mul(in1, in1);
    let t2 = circuit_add(t1, t1);
    let t3 = circuit_add(t2, t1);
    let t4 = circuit_add(t3, in6);
    let t5 = circuit_add(in2, in2);
    let t6 = circuit_inverse(t5);
    let t7 = circuit_mul(t4, t6);
    let t8 = circuit_mul(t7, t7);
    let t9 = circuit_add(in1, in1);
    let t10 = circuit_sub(t8, t9);
    let t11 = circuit_sub(in1, t10);
    let t12 = circuit_add(in2, in2);
    let t13 = circuit_inverse(t11);
    let t14 = circuit_mul(t12, t13);
    let t15 = circuit_sub(t14, t7);
    let t16 = circuit_mul(t15, t15);
    let t17 = circuit_add(in1, t10);
    let t18 = circuit_sub(t16, t17);
    let t19 = circuit_sub(in1, t18);
    let t20 = circuit_mul(t15, t19);
    let t21 = circuit_sub(t20, in2);
    let t22 = circuit_mul(in5, in4);
    let t23 = circuit_sub(in0, t22);
    let t24 = circuit_mul(in3, in3);
    let t25 = circuit_add(t24, t24);
    let t26 = circuit_add(t25, t24);
    let t27 = circuit_add(t26, in6);
    let t28 = circuit_add(t22, t22);
    let t29 = circuit_inverse(t28);
    let t30 = circuit_mul(t27, t29);
    let t31 = circuit_mul(t30, t30);
    let t32 = circuit_add(in3, in3);
    let t33 = circuit_sub(t31, t32);
    let t34 = circuit_sub(in3, t33);
    let t35 = circuit_add(t22, t22);
    let t36 = circuit_inverse(t34);
    let t37 = circuit_mul(t35, t36);
    let t38 = circuit_sub(t37, t30);
    let t39 = circuit_mul(t38, t38);
    let t40 = circuit_add(in3, t33);
    let t41 = circuit_sub(t39, t40);
    let t42 = circuit_sub(in3, t41);
    let t43 = circuit_mul(t38, t42);
    let t44 = circuit_sub(t43, t22);
    let t45 = circuit_sub(t21, t44);
    let t46 = circuit_sub(t18, t41);
    let t47 = circuit_inverse(t46);
    let t48 = circuit_mul(t45, t47);
    let t49 = circuit_mul(t48, t48);
    let t50 = circuit_sub(t49, t18);
    let t51 = circuit_sub(t50, t41);
    let t52 = circuit_sub(t18, t51);
    let t53 = circuit_mul(t48, t52);
    let t54 = circuit_sub(t53, t21);
    let t55 = circuit_sub(in2, t22);
    let t56 = circuit_sub(in1, in3);
    let t57 = circuit_inverse(t56);
    let t58 = circuit_mul(t55, t57);
    let t59 = circuit_mul(t58, t58);
    let t60 = circuit_sub(t59, in1);
    let t61 = circuit_sub(t60, in3);
    let t62 = circuit_sub(in1, t61);
    let t63 = circuit_mul(t58, t62);
    let t64 = circuit_sub(t63, in2);
    let t65 = circuit_sub(t21, t22);
    let t66 = circuit_sub(t18, in3);
    let t67 = circuit_inverse(t66);
    let t68 = circuit_mul(t65, t67);
    let t69 = circuit_mul(t68, t68);
    let t70 = circuit_sub(t69, t18);
    let t71 = circuit_sub(t70, in3);
    let t72 = circuit_sub(t18, t71);
    let t73 = circuit_mul(t68, t72);
    let t74 = circuit_sub(t73, t21);
    let t75 = circuit_sub(in2, t44);
    let t76 = circuit_sub(in1, t41);
    let t77 = circuit_inverse(t76);
    let t78 = circuit_mul(t75, t77);
    let t79 = circuit_mul(t78, t78);
    let t80 = circuit_sub(t79, in1);
    let t81 = circuit_sub(t80, t41);
    let t82 = circuit_sub(in1, t81);
    let t83 = circuit_mul(t78, t82);
    let t84 = circuit_sub(t83, in2);
    let t85 = circuit_sub(in0, t64);
    let t86 = circuit_sub(in0, t54);
    let t87 = circuit_sub(in0, t84);
    let t88 = circuit_sub(in0, t74);
    let t89 = circuit_sub(t21, t23);
    let t90 = circuit_sub(t18, in3);
    let t91 = circuit_inverse(t90);
    let t92 = circuit_mul(t89, t91);
    let t93 = circuit_mul(t92, t92);
    let t94 = circuit_sub(t93, t18);
    let t95 = circuit_sub(t94, in3);
    let t96 = circuit_sub(t18, t95);
    let t97 = circuit_mul(t92, t96);
    let t98 = circuit_sub(t97, t21);
    let t99 = circuit_sub(in0, t44);
    let t100 = circuit_sub(in2, t99);
    let t101 = circuit_sub(in1, t41);
    let t102 = circuit_inverse(t101);
    let t103 = circuit_mul(t100, t102);
    let t104 = circuit_mul(t103, t103);
    let t105 = circuit_sub(t104, in1);
    let t106 = circuit_sub(t105, t41);
    let t107 = circuit_sub(in1, t106);
    let t108 = circuit_mul(t103, t107);
    let t109 = circuit_sub(t108, in2);
    let t110 = circuit_sub(t21, t99);
    let t111 = circuit_sub(t18, t41);
    let t112 = circuit_inverse(t111);
    let t113 = circuit_mul(t110, t112);
    let t114 = circuit_mul(t113, t113);
    let t115 = circuit_sub(t114, t18);
    let t116 = circuit_sub(t115, t41);
    let t117 = circuit_sub(t18, t116);
    let t118 = circuit_mul(t113, t117);
    let t119 = circuit_sub(t118, t21);
    let t120 = circuit_sub(t23, in2);
    let t121 = circuit_sub(in3, in1);
    let t122 = circuit_inverse(t121);
    let t123 = circuit_mul(t120, t122);
    let t124 = circuit_mul(t123, t123);
    let t125 = circuit_sub(t124, in3);
    let t126 = circuit_sub(t125, in1);
    let t127 = circuit_sub(in3, t126);
    let t128 = circuit_mul(t123, t127);
    let t129 = circuit_sub(t128, t23);
    let t130 = circuit_sub(in0, t109);
    let t131 = circuit_sub(in0, t98);
    let t132 = circuit_sub(in0, t129);
    let t133 = circuit_sub(in0, t119);

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
        t85,
        t86,
        t87,
        t88,
        t95,
        t98,
        t106,
        t109,
        t116,
        t119,
        t126,
        t129,
        t130,
        t131,
        t132,
        t133,
        t41,
        t44,
        t23,
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
    let T1: G1Point = G1Point { x: outputs.get_output(t51), y: outputs.get_output(t54) };
    let T2: G1Point = G1Point { x: outputs.get_output(t61), y: outputs.get_output(t64) };
    let T3: G1Point = G1Point { x: outputs.get_output(t71), y: outputs.get_output(t74) };
    let T4: G1Point = G1Point { x: outputs.get_output(t81), y: outputs.get_output(t84) };
    let T5y: u384 = outputs.get_output(t85);
    let T6y: u384 = outputs.get_output(t86);
    let T7y: u384 = outputs.get_output(t87);
    let T8y: u384 = outputs.get_output(t88);
    let T9: G1Point = G1Point { x: outputs.get_output(t95), y: outputs.get_output(t98) };
    let T10: G1Point = G1Point { x: outputs.get_output(t106), y: outputs.get_output(t109) };
    let T11: G1Point = G1Point { x: outputs.get_output(t116), y: outputs.get_output(t119) };
    let T12: G1Point = G1Point { x: outputs.get_output(t126), y: outputs.get_output(t129) };
    let T13y: u384 = outputs.get_output(t130);
    let T14y: u384 = outputs.get_output(t131);
    let T15y: u384 = outputs.get_output(t132);
    let T16y: u384 = outputs.get_output(t133);
    let R2: G1Point = G1Point { x: outputs.get_output(t41), y: outputs.get_output(t44) };
    let R0y: u384 = outputs.get_output(t23);
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
    modulus: CircuitModulus,
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
    modulus: CircuitModulus,
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
