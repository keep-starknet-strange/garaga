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
    get_BLS12_381_modulus, get_BN254_modulus,
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;
#[inline(always)]
pub fn run_BLS12_381_EVAL_E12D_circuit(f: E12D<u384>, z: u384) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let in12 = CE::<CI<12>> {};
    let t0 = circuit_mul(in11, in12); // Eval X Horner step: multiply by z
    let t1 = circuit_add(in10, t0); // Eval X Horner step: add coefficient_10
    let t2 = circuit_mul(t1, in12); // Eval X Horner step: multiply by z
    let t3 = circuit_add(in9, t2); // Eval X Horner step: add coefficient_9
    let t4 = circuit_mul(t3, in12); // Eval X Horner step: multiply by z
    let t5 = circuit_add(in8, t4); // Eval X Horner step: add coefficient_8
    let t6 = circuit_mul(t5, in12); // Eval X Horner step: multiply by z
    let t7 = circuit_add(in7, t6); // Eval X Horner step: add coefficient_7
    let t8 = circuit_mul(t7, in12); // Eval X Horner step: multiply by z
    let t9 = circuit_add(in6, t8); // Eval X Horner step: add coefficient_6
    let t10 = circuit_mul(t9, in12); // Eval X Horner step: multiply by z
    let t11 = circuit_add(in5, t10); // Eval X Horner step: add coefficient_5
    let t12 = circuit_mul(t11, in12); // Eval X Horner step: multiply by z
    let t13 = circuit_add(in4, t12); // Eval X Horner step: add coefficient_4
    let t14 = circuit_mul(t13, in12); // Eval X Horner step: multiply by z
    let t15 = circuit_add(in3, t14); // Eval X Horner step: add coefficient_3
    let t16 = circuit_mul(t15, in12); // Eval X Horner step: multiply by z
    let t17 = circuit_add(in2, t16); // Eval X Horner step: add coefficient_2
    let t18 = circuit_mul(t17, in12); // Eval X Horner step: multiply by z
    let t19 = circuit_add(in1, t18); // Eval X Horner step: add coefficient_1
    let t20 = circuit_mul(t19, in12); // Eval X Horner step: multiply by z
    let t21 = circuit_add(in0, t20); // Eval X Horner step: add coefficient_0

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t21,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(f.w0); // in0
    circuit_inputs = circuit_inputs.next_2(f.w1); // in1
    circuit_inputs = circuit_inputs.next_2(f.w2); // in2
    circuit_inputs = circuit_inputs.next_2(f.w3); // in3
    circuit_inputs = circuit_inputs.next_2(f.w4); // in4
    circuit_inputs = circuit_inputs.next_2(f.w5); // in5
    circuit_inputs = circuit_inputs.next_2(f.w6); // in6
    circuit_inputs = circuit_inputs.next_2(f.w7); // in7
    circuit_inputs = circuit_inputs.next_2(f.w8); // in8
    circuit_inputs = circuit_inputs.next_2(f.w9); // in9
    circuit_inputs = circuit_inputs.next_2(f.w10); // in10
    circuit_inputs = circuit_inputs.next_2(f.w11); // in11
    circuit_inputs = circuit_inputs.next_2(z); // in12

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let f_of_z: u384 = outputs.get_output(t21);
    return (f_of_z,);
}
#[inline(always)]
pub fn run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit(
    X: E12D<u384>, Y: E12D<u384>, Q: E12DMulQuotient<u384>, z: u384,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x2
    let in1 = CE::<CI<1>> {}; // -0x2 % p
    let in2 = CE::<CI<2>> {}; // 0x1

    // INPUT stack
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
    let t0 = circuit_mul(in38, in38); // Compute z^2
    let t1 = circuit_mul(t0, in38); // Compute z^3
    let t2 = circuit_mul(t1, in38); // Compute z^4
    let t3 = circuit_mul(t2, in38); // Compute z^5
    let t4 = circuit_mul(t3, in38); // Compute z^6
    let t5 = circuit_mul(t4, in38); // Compute z^7
    let t6 = circuit_mul(t5, in38); // Compute z^8
    let t7 = circuit_mul(t6, in38); // Compute z^9
    let t8 = circuit_mul(t7, in38); // Compute z^10
    let t9 = circuit_mul(t8, in38); // Compute z^11
    let t10 = circuit_mul(t9, in38); // Compute z^12
    let t11 = circuit_mul(in1, t4); // Eval sparse poly P_irr step coeff_6 * z^6
    let t12 = circuit_add(in0, t11); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t13 = circuit_add(t12, t10); // Eval sparse poly P_irr step + 1*z^12
    let t14 = circuit_mul(in28, in38); // Eval Q step coeff_1 * z^1
    let t15 = circuit_add(in27, t14); // Eval Q step + (coeff_1 * z^1)
    let t16 = circuit_mul(in29, t0); // Eval Q step coeff_2 * z^2
    let t17 = circuit_add(t15, t16); // Eval Q step + (coeff_2 * z^2)
    let t18 = circuit_mul(in30, t1); // Eval Q step coeff_3 * z^3
    let t19 = circuit_add(t17, t18); // Eval Q step + (coeff_3 * z^3)
    let t20 = circuit_mul(in31, t2); // Eval Q step coeff_4 * z^4
    let t21 = circuit_add(t19, t20); // Eval Q step + (coeff_4 * z^4)
    let t22 = circuit_mul(in32, t3); // Eval Q step coeff_5 * z^5
    let t23 = circuit_add(t21, t22); // Eval Q step + (coeff_5 * z^5)
    let t24 = circuit_mul(in33, t4); // Eval Q step coeff_6 * z^6
    let t25 = circuit_add(t23, t24); // Eval Q step + (coeff_6 * z^6)
    let t26 = circuit_mul(in34, t5); // Eval Q step coeff_7 * z^7
    let t27 = circuit_add(t25, t26); // Eval Q step + (coeff_7 * z^7)
    let t28 = circuit_mul(in35, t6); // Eval Q step coeff_8 * z^8
    let t29 = circuit_add(t27, t28); // Eval Q step + (coeff_8 * z^8)
    let t30 = circuit_mul(in36, t7); // Eval Q step coeff_9 * z^9
    let t31 = circuit_add(t29, t30); // Eval Q step + (coeff_9 * z^9)
    let t32 = circuit_mul(in37, t8); // Eval Q step coeff_10 * z^10
    let t33 = circuit_add(t31, t32); // Eval Q step + (coeff_10 * z^10)
    let t34 = circuit_mul(in4, in38); // Eval X step coeff_1 * z^1
    let t35 = circuit_add(in3, t34); // Eval X step + (coeff_1 * z^1)
    let t36 = circuit_mul(in5, t0); // Eval X step coeff_2 * z^2
    let t37 = circuit_add(t35, t36); // Eval X step + (coeff_2 * z^2)
    let t38 = circuit_mul(in6, t1); // Eval X step coeff_3 * z^3
    let t39 = circuit_add(t37, t38); // Eval X step + (coeff_3 * z^3)
    let t40 = circuit_mul(in7, t2); // Eval X step coeff_4 * z^4
    let t41 = circuit_add(t39, t40); // Eval X step + (coeff_4 * z^4)
    let t42 = circuit_mul(in8, t3); // Eval X step coeff_5 * z^5
    let t43 = circuit_add(t41, t42); // Eval X step + (coeff_5 * z^5)
    let t44 = circuit_mul(in9, t4); // Eval X step coeff_6 * z^6
    let t45 = circuit_add(t43, t44); // Eval X step + (coeff_6 * z^6)
    let t46 = circuit_mul(in10, t5); // Eval X step coeff_7 * z^7
    let t47 = circuit_add(t45, t46); // Eval X step + (coeff_7 * z^7)
    let t48 = circuit_mul(in11, t6); // Eval X step coeff_8 * z^8
    let t49 = circuit_add(t47, t48); // Eval X step + (coeff_8 * z^8)
    let t50 = circuit_mul(in12, t7); // Eval X step coeff_9 * z^9
    let t51 = circuit_add(t49, t50); // Eval X step + (coeff_9 * z^9)
    let t52 = circuit_mul(in13, t8); // Eval X step coeff_10 * z^10
    let t53 = circuit_add(t51, t52); // Eval X step + (coeff_10 * z^10)
    let t54 = circuit_mul(in14, t9); // Eval X step coeff_11 * z^11
    let t55 = circuit_add(t53, t54); // Eval X step + (coeff_11 * z^11)
    let t56 = circuit_mul(in16, in38); // Eval Y step coeff_1 * z^1
    let t57 = circuit_add(in15, t56); // Eval Y step + (coeff_1 * z^1)
    let t58 = circuit_mul(in17, t0); // Eval Y step coeff_2 * z^2
    let t59 = circuit_add(t57, t58); // Eval Y step + (coeff_2 * z^2)
    let t60 = circuit_mul(in18, t1); // Eval Y step coeff_3 * z^3
    let t61 = circuit_add(t59, t60); // Eval Y step + (coeff_3 * z^3)
    let t62 = circuit_mul(in19, t2); // Eval Y step coeff_4 * z^4
    let t63 = circuit_add(t61, t62); // Eval Y step + (coeff_4 * z^4)
    let t64 = circuit_mul(in20, t3); // Eval Y step coeff_5 * z^5
    let t65 = circuit_add(t63, t64); // Eval Y step + (coeff_5 * z^5)
    let t66 = circuit_mul(in21, t4); // Eval Y step coeff_6 * z^6
    let t67 = circuit_add(t65, t66); // Eval Y step + (coeff_6 * z^6)
    let t68 = circuit_mul(in22, t5); // Eval Y step coeff_7 * z^7
    let t69 = circuit_add(t67, t68); // Eval Y step + (coeff_7 * z^7)
    let t70 = circuit_mul(in23, t6); // Eval Y step coeff_8 * z^8
    let t71 = circuit_add(t69, t70); // Eval Y step + (coeff_8 * z^8)
    let t72 = circuit_mul(in24, t7); // Eval Y step coeff_9 * z^9
    let t73 = circuit_add(t71, t72); // Eval Y step + (coeff_9 * z^9)
    let t74 = circuit_mul(in25, t8); // Eval Y step coeff_10 * z^10
    let t75 = circuit_add(t73, t74); // Eval Y step + (coeff_10 * z^10)
    let t76 = circuit_mul(in26, t9); // Eval Y step coeff_11 * z^11
    let t77 = circuit_add(t75, t76); // Eval Y step + (coeff_11 * z^11)
    let t78 = circuit_mul(t55, t77); // X(z) * Y(z)
    let t79 = circuit_mul(t33, t13); // Q(z) * P(z)
    let t80 = circuit_sub(t78, t79); // (X(z) * Y(z)) - (Q(z) * P(z))
    let t81 = circuit_sub(t80, in2); // (X(z) * Y(z) - Q(z) * P(z)) - 1

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t81,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x2, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [
                0xb153ffffb9feffffffffaaa9, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6,
            ],
        ); // in1
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(X.w0); // in3
    circuit_inputs = circuit_inputs.next_2(X.w1); // in4
    circuit_inputs = circuit_inputs.next_2(X.w2); // in5
    circuit_inputs = circuit_inputs.next_2(X.w3); // in6
    circuit_inputs = circuit_inputs.next_2(X.w4); // in7
    circuit_inputs = circuit_inputs.next_2(X.w5); // in8
    circuit_inputs = circuit_inputs.next_2(X.w6); // in9
    circuit_inputs = circuit_inputs.next_2(X.w7); // in10
    circuit_inputs = circuit_inputs.next_2(X.w8); // in11
    circuit_inputs = circuit_inputs.next_2(X.w9); // in12
    circuit_inputs = circuit_inputs.next_2(X.w10); // in13
    circuit_inputs = circuit_inputs.next_2(X.w11); // in14
    circuit_inputs = circuit_inputs.next_2(Y.w0); // in15
    circuit_inputs = circuit_inputs.next_2(Y.w1); // in16
    circuit_inputs = circuit_inputs.next_2(Y.w2); // in17
    circuit_inputs = circuit_inputs.next_2(Y.w3); // in18
    circuit_inputs = circuit_inputs.next_2(Y.w4); // in19
    circuit_inputs = circuit_inputs.next_2(Y.w5); // in20
    circuit_inputs = circuit_inputs.next_2(Y.w6); // in21
    circuit_inputs = circuit_inputs.next_2(Y.w7); // in22
    circuit_inputs = circuit_inputs.next_2(Y.w8); // in23
    circuit_inputs = circuit_inputs.next_2(Y.w9); // in24
    circuit_inputs = circuit_inputs.next_2(Y.w10); // in25
    circuit_inputs = circuit_inputs.next_2(Y.w11); // in26
    circuit_inputs = circuit_inputs.next_2(Q.w0); // in27
    circuit_inputs = circuit_inputs.next_2(Q.w1); // in28
    circuit_inputs = circuit_inputs.next_2(Q.w2); // in29
    circuit_inputs = circuit_inputs.next_2(Q.w3); // in30
    circuit_inputs = circuit_inputs.next_2(Q.w4); // in31
    circuit_inputs = circuit_inputs.next_2(Q.w5); // in32
    circuit_inputs = circuit_inputs.next_2(Q.w6); // in33
    circuit_inputs = circuit_inputs.next_2(Q.w7); // in34
    circuit_inputs = circuit_inputs.next_2(Q.w8); // in35
    circuit_inputs = circuit_inputs.next_2(Q.w9); // in36
    circuit_inputs = circuit_inputs.next_2(Q.w10); // in37
    circuit_inputs = circuit_inputs.next_2(z); // in38

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let check: u384 = outputs.get_output(t81);
    return (check,);
}
#[inline(always)]
pub fn run_BN254_EVAL_E12D_circuit(f: E12D<u288>, z: u384) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let in12 = CE::<CI<12>> {};
    let t0 = circuit_mul(in11, in12); // Eval X Horner step: multiply by z
    let t1 = circuit_add(in10, t0); // Eval X Horner step: add coefficient_10
    let t2 = circuit_mul(t1, in12); // Eval X Horner step: multiply by z
    let t3 = circuit_add(in9, t2); // Eval X Horner step: add coefficient_9
    let t4 = circuit_mul(t3, in12); // Eval X Horner step: multiply by z
    let t5 = circuit_add(in8, t4); // Eval X Horner step: add coefficient_8
    let t6 = circuit_mul(t5, in12); // Eval X Horner step: multiply by z
    let t7 = circuit_add(in7, t6); // Eval X Horner step: add coefficient_7
    let t8 = circuit_mul(t7, in12); // Eval X Horner step: multiply by z
    let t9 = circuit_add(in6, t8); // Eval X Horner step: add coefficient_6
    let t10 = circuit_mul(t9, in12); // Eval X Horner step: multiply by z
    let t11 = circuit_add(in5, t10); // Eval X Horner step: add coefficient_5
    let t12 = circuit_mul(t11, in12); // Eval X Horner step: multiply by z
    let t13 = circuit_add(in4, t12); // Eval X Horner step: add coefficient_4
    let t14 = circuit_mul(t13, in12); // Eval X Horner step: multiply by z
    let t15 = circuit_add(in3, t14); // Eval X Horner step: add coefficient_3
    let t16 = circuit_mul(t15, in12); // Eval X Horner step: multiply by z
    let t17 = circuit_add(in2, t16); // Eval X Horner step: add coefficient_2
    let t18 = circuit_mul(t17, in12); // Eval X Horner step: multiply by z
    let t19 = circuit_add(in1, t18); // Eval X Horner step: add coefficient_1
    let t20 = circuit_mul(t19, in12); // Eval X Horner step: multiply by z
    let t21 = circuit_add(in0, t20); // Eval X Horner step: add coefficient_0

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t21,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_u288(f.w0); // in0
    circuit_inputs = circuit_inputs.next_u288(f.w1); // in1
    circuit_inputs = circuit_inputs.next_u288(f.w2); // in2
    circuit_inputs = circuit_inputs.next_u288(f.w3); // in3
    circuit_inputs = circuit_inputs.next_u288(f.w4); // in4
    circuit_inputs = circuit_inputs.next_u288(f.w5); // in5
    circuit_inputs = circuit_inputs.next_u288(f.w6); // in6
    circuit_inputs = circuit_inputs.next_u288(f.w7); // in7
    circuit_inputs = circuit_inputs.next_u288(f.w8); // in8
    circuit_inputs = circuit_inputs.next_u288(f.w9); // in9
    circuit_inputs = circuit_inputs.next_u288(f.w10); // in10
    circuit_inputs = circuit_inputs.next_u288(f.w11); // in11
    circuit_inputs = circuit_inputs.next_2(z); // in12

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let f_of_z: u384 = outputs.get_output(t21);
    return (f_of_z,);
}
#[inline(always)]
pub fn run_BN254_FP12_MUL_ASSERT_ONE_circuit(
    X: E12D<u288>, Y: E12D<u288>, Q: E12DMulQuotient<u288>, z: u384,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x52
    let in1 = CE::<CI<1>> {}; // -0x12 % p
    let in2 = CE::<CI<2>> {}; // 0x1

    // INPUT stack
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
    let t0 = circuit_mul(in38, in38); // Compute z^2
    let t1 = circuit_mul(t0, in38); // Compute z^3
    let t2 = circuit_mul(t1, in38); // Compute z^4
    let t3 = circuit_mul(t2, in38); // Compute z^5
    let t4 = circuit_mul(t3, in38); // Compute z^6
    let t5 = circuit_mul(t4, in38); // Compute z^7
    let t6 = circuit_mul(t5, in38); // Compute z^8
    let t7 = circuit_mul(t6, in38); // Compute z^9
    let t8 = circuit_mul(t7, in38); // Compute z^10
    let t9 = circuit_mul(t8, in38); // Compute z^11
    let t10 = circuit_mul(t9, in38); // Compute z^12
    let t11 = circuit_mul(in1, t4); // Eval sparse poly P_irr step coeff_6 * z^6
    let t12 = circuit_add(in0, t11); // Eval sparse poly P_irr step + coeff_6 * z^6
    let t13 = circuit_add(t12, t10); // Eval sparse poly P_irr step + 1*z^12
    let t14 = circuit_mul(in28, in38); // Eval Q step coeff_1 * z^1
    let t15 = circuit_add(in27, t14); // Eval Q step + (coeff_1 * z^1)
    let t16 = circuit_mul(in29, t0); // Eval Q step coeff_2 * z^2
    let t17 = circuit_add(t15, t16); // Eval Q step + (coeff_2 * z^2)
    let t18 = circuit_mul(in30, t1); // Eval Q step coeff_3 * z^3
    let t19 = circuit_add(t17, t18); // Eval Q step + (coeff_3 * z^3)
    let t20 = circuit_mul(in31, t2); // Eval Q step coeff_4 * z^4
    let t21 = circuit_add(t19, t20); // Eval Q step + (coeff_4 * z^4)
    let t22 = circuit_mul(in32, t3); // Eval Q step coeff_5 * z^5
    let t23 = circuit_add(t21, t22); // Eval Q step + (coeff_5 * z^5)
    let t24 = circuit_mul(in33, t4); // Eval Q step coeff_6 * z^6
    let t25 = circuit_add(t23, t24); // Eval Q step + (coeff_6 * z^6)
    let t26 = circuit_mul(in34, t5); // Eval Q step coeff_7 * z^7
    let t27 = circuit_add(t25, t26); // Eval Q step + (coeff_7 * z^7)
    let t28 = circuit_mul(in35, t6); // Eval Q step coeff_8 * z^8
    let t29 = circuit_add(t27, t28); // Eval Q step + (coeff_8 * z^8)
    let t30 = circuit_mul(in36, t7); // Eval Q step coeff_9 * z^9
    let t31 = circuit_add(t29, t30); // Eval Q step + (coeff_9 * z^9)
    let t32 = circuit_mul(in37, t8); // Eval Q step coeff_10 * z^10
    let t33 = circuit_add(t31, t32); // Eval Q step + (coeff_10 * z^10)
    let t34 = circuit_mul(in4, in38); // Eval X step coeff_1 * z^1
    let t35 = circuit_add(in3, t34); // Eval X step + (coeff_1 * z^1)
    let t36 = circuit_mul(in5, t0); // Eval X step coeff_2 * z^2
    let t37 = circuit_add(t35, t36); // Eval X step + (coeff_2 * z^2)
    let t38 = circuit_mul(in6, t1); // Eval X step coeff_3 * z^3
    let t39 = circuit_add(t37, t38); // Eval X step + (coeff_3 * z^3)
    let t40 = circuit_mul(in7, t2); // Eval X step coeff_4 * z^4
    let t41 = circuit_add(t39, t40); // Eval X step + (coeff_4 * z^4)
    let t42 = circuit_mul(in8, t3); // Eval X step coeff_5 * z^5
    let t43 = circuit_add(t41, t42); // Eval X step + (coeff_5 * z^5)
    let t44 = circuit_mul(in9, t4); // Eval X step coeff_6 * z^6
    let t45 = circuit_add(t43, t44); // Eval X step + (coeff_6 * z^6)
    let t46 = circuit_mul(in10, t5); // Eval X step coeff_7 * z^7
    let t47 = circuit_add(t45, t46); // Eval X step + (coeff_7 * z^7)
    let t48 = circuit_mul(in11, t6); // Eval X step coeff_8 * z^8
    let t49 = circuit_add(t47, t48); // Eval X step + (coeff_8 * z^8)
    let t50 = circuit_mul(in12, t7); // Eval X step coeff_9 * z^9
    let t51 = circuit_add(t49, t50); // Eval X step + (coeff_9 * z^9)
    let t52 = circuit_mul(in13, t8); // Eval X step coeff_10 * z^10
    let t53 = circuit_add(t51, t52); // Eval X step + (coeff_10 * z^10)
    let t54 = circuit_mul(in14, t9); // Eval X step coeff_11 * z^11
    let t55 = circuit_add(t53, t54); // Eval X step + (coeff_11 * z^11)
    let t56 = circuit_mul(in16, in38); // Eval Y step coeff_1 * z^1
    let t57 = circuit_add(in15, t56); // Eval Y step + (coeff_1 * z^1)
    let t58 = circuit_mul(in17, t0); // Eval Y step coeff_2 * z^2
    let t59 = circuit_add(t57, t58); // Eval Y step + (coeff_2 * z^2)
    let t60 = circuit_mul(in18, t1); // Eval Y step coeff_3 * z^3
    let t61 = circuit_add(t59, t60); // Eval Y step + (coeff_3 * z^3)
    let t62 = circuit_mul(in19, t2); // Eval Y step coeff_4 * z^4
    let t63 = circuit_add(t61, t62); // Eval Y step + (coeff_4 * z^4)
    let t64 = circuit_mul(in20, t3); // Eval Y step coeff_5 * z^5
    let t65 = circuit_add(t63, t64); // Eval Y step + (coeff_5 * z^5)
    let t66 = circuit_mul(in21, t4); // Eval Y step coeff_6 * z^6
    let t67 = circuit_add(t65, t66); // Eval Y step + (coeff_6 * z^6)
    let t68 = circuit_mul(in22, t5); // Eval Y step coeff_7 * z^7
    let t69 = circuit_add(t67, t68); // Eval Y step + (coeff_7 * z^7)
    let t70 = circuit_mul(in23, t6); // Eval Y step coeff_8 * z^8
    let t71 = circuit_add(t69, t70); // Eval Y step + (coeff_8 * z^8)
    let t72 = circuit_mul(in24, t7); // Eval Y step coeff_9 * z^9
    let t73 = circuit_add(t71, t72); // Eval Y step + (coeff_9 * z^9)
    let t74 = circuit_mul(in25, t8); // Eval Y step coeff_10 * z^10
    let t75 = circuit_add(t73, t74); // Eval Y step + (coeff_10 * z^10)
    let t76 = circuit_mul(in26, t9); // Eval Y step coeff_11 * z^11
    let t77 = circuit_add(t75, t76); // Eval Y step + (coeff_11 * z^11)
    let t78 = circuit_mul(t55, t77); // X(z) * Y(z)
    let t79 = circuit_mul(t33, t13); // Q(z) * P(z)
    let t80 = circuit_sub(t78, t79); // (X(z) * Y(z)) - (Q(z) * P(z))
    let t81 = circuit_sub(t80, in2); // (X(z) * Y(z) - Q(z) * P(z)) - 1

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let mut circuit_inputs = (t81,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x52, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd35, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0],
        ); // in1
    circuit_inputs = circuit_inputs.next_2([0x1, 0x0, 0x0, 0x0]); // in2
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_u288(X.w0); // in3
    circuit_inputs = circuit_inputs.next_u288(X.w1); // in4
    circuit_inputs = circuit_inputs.next_u288(X.w2); // in5
    circuit_inputs = circuit_inputs.next_u288(X.w3); // in6
    circuit_inputs = circuit_inputs.next_u288(X.w4); // in7
    circuit_inputs = circuit_inputs.next_u288(X.w5); // in8
    circuit_inputs = circuit_inputs.next_u288(X.w6); // in9
    circuit_inputs = circuit_inputs.next_u288(X.w7); // in10
    circuit_inputs = circuit_inputs.next_u288(X.w8); // in11
    circuit_inputs = circuit_inputs.next_u288(X.w9); // in12
    circuit_inputs = circuit_inputs.next_u288(X.w10); // in13
    circuit_inputs = circuit_inputs.next_u288(X.w11); // in14
    circuit_inputs = circuit_inputs.next_u288(Y.w0); // in15
    circuit_inputs = circuit_inputs.next_u288(Y.w1); // in16
    circuit_inputs = circuit_inputs.next_u288(Y.w2); // in17
    circuit_inputs = circuit_inputs.next_u288(Y.w3); // in18
    circuit_inputs = circuit_inputs.next_u288(Y.w4); // in19
    circuit_inputs = circuit_inputs.next_u288(Y.w5); // in20
    circuit_inputs = circuit_inputs.next_u288(Y.w6); // in21
    circuit_inputs = circuit_inputs.next_u288(Y.w7); // in22
    circuit_inputs = circuit_inputs.next_u288(Y.w8); // in23
    circuit_inputs = circuit_inputs.next_u288(Y.w9); // in24
    circuit_inputs = circuit_inputs.next_u288(Y.w10); // in25
    circuit_inputs = circuit_inputs.next_u288(Y.w11); // in26
    circuit_inputs = circuit_inputs.next_u288(Q.w0); // in27
    circuit_inputs = circuit_inputs.next_u288(Q.w1); // in28
    circuit_inputs = circuit_inputs.next_u288(Q.w2); // in29
    circuit_inputs = circuit_inputs.next_u288(Q.w3); // in30
    circuit_inputs = circuit_inputs.next_u288(Q.w4); // in31
    circuit_inputs = circuit_inputs.next_u288(Q.w5); // in32
    circuit_inputs = circuit_inputs.next_u288(Q.w6); // in33
    circuit_inputs = circuit_inputs.next_u288(Q.w7); // in34
    circuit_inputs = circuit_inputs.next_u288(Q.w8); // in35
    circuit_inputs = circuit_inputs.next_u288(Q.w9); // in36
    circuit_inputs = circuit_inputs.next_u288(Q.w10); // in37
    circuit_inputs = circuit_inputs.next_2(z); // in38

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let check: u384 = outputs.get_output(t81);
    return (check,);
}

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

    use super::{
        run_BLS12_381_EVAL_E12D_circuit, run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit,
        run_BN254_EVAL_E12D_circuit, run_BN254_FP12_MUL_ASSERT_ONE_circuit,
    };
}
