use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair,
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;

fn run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit(
    X: E12D, Y: E12D, Q: E12DMulQuotient, z: u384
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x2
    let in1 = CE::<CI<1>> {}; // -0x2 % p
    let in2 = CE::<CI<2>> {}; // 0x1

    // INPUT stack
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38) = (CE::<CI<37>> {}, CE::<CI<38>> {});
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

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            54880396502181392957329877675,
            31935979117156477062286671870,
            20826981314825584179608359615,
            8047903782086192180586325942
        ]
    )
        .unwrap();

    let mut circuit_inputs = (t81,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x2, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next(
            [
                0xb153ffffb9feffffffffaaa9,
                0x6730d2a0f6b0f6241eabfffe,
                0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6
            ]
        );
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(X.w0);
    circuit_inputs = circuit_inputs.next(X.w1);
    circuit_inputs = circuit_inputs.next(X.w2);
    circuit_inputs = circuit_inputs.next(X.w3);
    circuit_inputs = circuit_inputs.next(X.w4);
    circuit_inputs = circuit_inputs.next(X.w5);
    circuit_inputs = circuit_inputs.next(X.w6);
    circuit_inputs = circuit_inputs.next(X.w7);
    circuit_inputs = circuit_inputs.next(X.w8);
    circuit_inputs = circuit_inputs.next(X.w9);
    circuit_inputs = circuit_inputs.next(X.w10);
    circuit_inputs = circuit_inputs.next(X.w11);
    circuit_inputs = circuit_inputs.next(Y.w0);
    circuit_inputs = circuit_inputs.next(Y.w1);
    circuit_inputs = circuit_inputs.next(Y.w2);
    circuit_inputs = circuit_inputs.next(Y.w3);
    circuit_inputs = circuit_inputs.next(Y.w4);
    circuit_inputs = circuit_inputs.next(Y.w5);
    circuit_inputs = circuit_inputs.next(Y.w6);
    circuit_inputs = circuit_inputs.next(Y.w7);
    circuit_inputs = circuit_inputs.next(Y.w8);
    circuit_inputs = circuit_inputs.next(Y.w9);
    circuit_inputs = circuit_inputs.next(Y.w10);
    circuit_inputs = circuit_inputs.next(Y.w11);
    circuit_inputs = circuit_inputs.next(Q.w0);
    circuit_inputs = circuit_inputs.next(Q.w1);
    circuit_inputs = circuit_inputs.next(Q.w2);
    circuit_inputs = circuit_inputs.next(Q.w3);
    circuit_inputs = circuit_inputs.next(Q.w4);
    circuit_inputs = circuit_inputs.next(Q.w5);
    circuit_inputs = circuit_inputs.next(Q.w6);
    circuit_inputs = circuit_inputs.next(Q.w7);
    circuit_inputs = circuit_inputs.next(Q.w8);
    circuit_inputs = circuit_inputs.next(Q.w9);
    circuit_inputs = circuit_inputs.next(Q.w10);
    circuit_inputs = circuit_inputs.next(z);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let check: u384 = outputs.get_output(t81);
    return (check,);
}
fn run_BN254_FP12_MUL_ASSERT_ONE_circuit(X: E12D, Y: E12D, Q: E12DMulQuotient, z: u384) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x52
    let in1 = CE::<CI<1>> {}; // -0x12 % p
    let in2 = CE::<CI<2>> {}; // 0x1

    // INPUT stack
    let (in3, in4) = (CE::<CI<3>> {}, CE::<CI<4>> {});
    let (in5, in6) = (CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8) = (CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10) = (CE::<CI<9>> {}, CE::<CI<10>> {});
    let (in11, in12) = (CE::<CI<11>> {}, CE::<CI<12>> {});
    let (in13, in14) = (CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16) = (CE::<CI<15>> {}, CE::<CI<16>> {});
    let (in17, in18) = (CE::<CI<17>> {}, CE::<CI<18>> {});
    let (in19, in20) = (CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22) = (CE::<CI<21>> {}, CE::<CI<22>> {});
    let (in23, in24) = (CE::<CI<23>> {}, CE::<CI<24>> {});
    let (in25, in26) = (CE::<CI<25>> {}, CE::<CI<26>> {});
    let (in27, in28) = (CE::<CI<27>> {}, CE::<CI<28>> {});
    let (in29, in30) = (CE::<CI<29>> {}, CE::<CI<30>> {});
    let (in31, in32) = (CE::<CI<31>> {}, CE::<CI<32>> {});
    let (in33, in34) = (CE::<CI<33>> {}, CE::<CI<34>> {});
    let (in35, in36) = (CE::<CI<35>> {}, CE::<CI<36>> {});
    let (in37, in38) = (CE::<CI<37>> {}, CE::<CI<38>> {});
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

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t81,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x52, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd35, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);
    circuit_inputs = circuit_inputs.next([0x1, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs.next(X.w0);
    circuit_inputs = circuit_inputs.next(X.w1);
    circuit_inputs = circuit_inputs.next(X.w2);
    circuit_inputs = circuit_inputs.next(X.w3);
    circuit_inputs = circuit_inputs.next(X.w4);
    circuit_inputs = circuit_inputs.next(X.w5);
    circuit_inputs = circuit_inputs.next(X.w6);
    circuit_inputs = circuit_inputs.next(X.w7);
    circuit_inputs = circuit_inputs.next(X.w8);
    circuit_inputs = circuit_inputs.next(X.w9);
    circuit_inputs = circuit_inputs.next(X.w10);
    circuit_inputs = circuit_inputs.next(X.w11);
    circuit_inputs = circuit_inputs.next(Y.w0);
    circuit_inputs = circuit_inputs.next(Y.w1);
    circuit_inputs = circuit_inputs.next(Y.w2);
    circuit_inputs = circuit_inputs.next(Y.w3);
    circuit_inputs = circuit_inputs.next(Y.w4);
    circuit_inputs = circuit_inputs.next(Y.w5);
    circuit_inputs = circuit_inputs.next(Y.w6);
    circuit_inputs = circuit_inputs.next(Y.w7);
    circuit_inputs = circuit_inputs.next(Y.w8);
    circuit_inputs = circuit_inputs.next(Y.w9);
    circuit_inputs = circuit_inputs.next(Y.w10);
    circuit_inputs = circuit_inputs.next(Y.w11);
    circuit_inputs = circuit_inputs.next(Q.w0);
    circuit_inputs = circuit_inputs.next(Q.w1);
    circuit_inputs = circuit_inputs.next(Q.w2);
    circuit_inputs = circuit_inputs.next(Q.w3);
    circuit_inputs = circuit_inputs.next(Q.w4);
    circuit_inputs = circuit_inputs.next(Q.w5);
    circuit_inputs = circuit_inputs.next(Q.w6);
    circuit_inputs = circuit_inputs.next(Q.w7);
    circuit_inputs = circuit_inputs.next(Q.w8);
    circuit_inputs = circuit_inputs.next(Q.w9);
    circuit_inputs = circuit_inputs.next(Q.w10);
    circuit_inputs = circuit_inputs.next(z);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let check: u384 = outputs.get_output(t81);
    return (check,);
}

#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs
    };
    use garaga::definitions::{
        G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair, BNProcessedPair, BLSProcessedPair,
        MillerLoopResultScalingFactor, G2Line
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

    use super::{run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit, run_BN254_FP12_MUL_ASSERT_ONE_circuit};

    #[test]
    fn test_run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit_BLS12_381() {
        let X = E12D {
            w0: u384 {
                limb0: 0x29a6bc7440d7a39d3bb13095,
                limb1: 0x2f8894833c73246d228a7cc4,
                limb2: 0x48d449353b816204184f368d,
                limb3: 0x13a344741ed0ad7f799e296
            },
            w1: u384 {
                limb0: 0xc9665aa519b0912a8f926d44,
                limb1: 0x9d1ef2754897a1d068c029be,
                limb2: 0x53158ee1c988e4139d2370bb,
                limb3: 0x21e287c1abc918ec785b144
            },
            w2: u384 {
                limb0: 0x13641b28b99479d365ef945c,
                limb1: 0x2a72895f890cc685e609c17f,
                limb2: 0x57de4a3a99ce4cdfc9fe8b0,
                limb3: 0x13b23c987bd85802aa4a4a8b
            },
            w3: u384 {
                limb0: 0xf4d204762f167c5d387f8996,
                limb1: 0x496fd5196c1f2da66dcd732a,
                limb2: 0x63961970cc35644f98e8f1d2,
                limb3: 0xf941a9e6fb69b0ffc2960d6
            },
            w4: u384 {
                limb0: 0x488dcd7a2312810215328479,
                limb1: 0x1da17e1ad99e10e71138b1e2,
                limb2: 0xb7e0d5717085dbbc73557453,
                limb3: 0xeb7972148d988a1e8e32274
            },
            w5: u384 {
                limb0: 0xa1e262d7f247bba6ce56ffbe,
                limb1: 0x97017fd0fda34376f5e617ce,
                limb2: 0x3c4113988d406839532bf37f,
                limb3: 0x573625540bbb5f2cb658530
            },
            w6: u384 {
                limb0: 0xd9d1bb49d391e92479cbdc6c,
                limb1: 0x6fcc0c18d165507002114533,
                limb2: 0xb5c2fec9e3d3d19a1a1d75c5,
                limb3: 0x74efaf82aa9d516a6c44ed2
            },
            w7: u384 {
                limb0: 0x7f079d7d051d3668af99a643,
                limb1: 0xa816e6c789750e817947c92f,
                limb2: 0x5edbd437a375545dcc14577b,
                limb3: 0x1427df6881200651598c3b62
            },
            w8: u384 {
                limb0: 0x947c1b26bb86c87b95ac437c,
                limb1: 0xc70c348875afa0b9ae26a22c,
                limb2: 0x470df9e6a51fd86c51c23926,
                limb3: 0x15cb575bd7d8e3e38df13d3
            },
            w9: u384 {
                limb0: 0xd2644c64884fa1a7c0d32d89,
                limb1: 0x17d2ef1c54dee0459dd68ce9,
                limb2: 0x29a60326e9044701dba83ae0,
                limb3: 0x45a63c250aac729717209cf
            },
            w10: u384 {
                limb0: 0x6fd3dfaa88ffdf979f916215,
                limb1: 0xcc972c86b8629d147432e559,
                limb2: 0xa6092e3214a5238faabd201a,
                limb3: 0x4b0f88d78d45a612033a95a
            },
            w11: u384 {
                limb0: 0xdaac9599ed45f1501197d590,
                limb1: 0x775390d3477acfbf6dcaf7bd,
                limb2: 0x8b51f270d47d10460c9e06be,
                limb3: 0xd4c2b4d815aea9d54014565
            }
        };

        let Y = E12D {
            w0: u384 {
                limb0: 0xbc42940cb81a840c91368e6b,
                limb1: 0x90645d72020da7e7aef31182,
                limb2: 0xdad39cfeffb384a3234c3f18,
                limb3: 0x496eda8aba6d11140bb628f
            },
            w1: u384 {
                limb0: 0x4975c699e77b4418ba1c28c1,
                limb1: 0x99d8bfd370cf574572ce4878,
                limb2: 0x362bf934cafb15e7f0cb2da,
                limb3: 0x43882af1f205c087e566ac0
            },
            w2: u384 {
                limb0: 0xc9df3071dc55c552c587b17,
                limb1: 0x69241cb83fab8471ce28d9c3,
                limb2: 0x61020a09328ec7da09bb3cd2,
                limb3: 0x27760b83220a4a8b610cb24
            },
            w3: u384 {
                limb0: 0x49c97f6936c3f9d08061c530,
                limb1: 0x83ffeb8188c9a3a5fa3c27b8,
                limb2: 0xc96f1cb38b4aa71d9b73f94e,
                limb3: 0x1780082c9da1e38f352bb050
            },
            w4: u384 {
                limb0: 0x94090322ad81d77175a67ba8,
                limb1: 0x9d3670f55a1e69847eaabf26,
                limb2: 0xb31389b0ebbc767692e0c14,
                limb3: 0x3df556a81ed065930878e29
            },
            w5: u384 {
                limb0: 0xd2fcfbfd0bbaab4a887956f1,
                limb1: 0x56d7027b5c3d2d4d263f1dfc,
                limb2: 0xf9f602db074a2910319ee3bc,
                limb3: 0x6bd5136dc0788ebb4750c52
            },
            w6: u384 {
                limb0: 0x249984fe5056acbb7a4e863f,
                limb1: 0xf5f11fc81a6157a95f94d967,
                limb2: 0x36261b4783f18b769d746ceb,
                limb3: 0x145b36e08d9aa0403570d3ee
            },
            w7: u384 {
                limb0: 0xcdad92c220039df02f957322,
                limb1: 0xad42d8eb9279a4fdddc54167,
                limb2: 0x4af05b76d6624feae34f2c2f,
                limb3: 0x939f01125e7f23824742ec7
            },
            w8: u384 {
                limb0: 0x9d7a774cbcb28b77f5d2e1e6,
                limb1: 0xd55bcf6830bea7420f3b07e3,
                limb2: 0x2c650537b5ca0a8736b1b2cc,
                limb3: 0x1497a35fb2ef2d5c61b13f25
            },
            w9: u384 {
                limb0: 0x4c17a70a43293bd7c422f20e,
                limb1: 0x8d9bbb6381768ca8e8031e0,
                limb2: 0xe19863372223ac1d276dfcb4,
                limb3: 0xc1762e8aebb8b34328b9a83
            },
            w10: u384 {
                limb0: 0xd7f0495a942213c106bad44c,
                limb1: 0x6d13929117a5742075291178,
                limb2: 0xb4d7d268f548d7691c17372e,
                limb3: 0x144ec35f8f18d598e01b1b37
            },
            w11: u384 {
                limb0: 0x6a69ef715ed292730b3fa8b6,
                limb1: 0x1f156eb83df32ab0f7141590,
                limb2: 0x77247d388ed2bb3d18821335,
                limb3: 0x1182cacf264731d721650992
            }
        };

        let Q = E12DMulQuotient {
            w0: u384 {
                limb0: 0xbb8bfcbd74cead4a6e409152,
                limb1: 0xb4aa1dca8f53483845846caa,
                limb2: 0xd7819ccc0f95e151d3fd1719,
                limb3: 0xcfed3ab54c57344988884ee
            },
            w1: u384 {
                limb0: 0x99a6f4165e66ddc3a775cc44,
                limb1: 0x30795b5a659185b7664ef107,
                limb2: 0x3866bdcd656ab5b4255753d9,
                limb3: 0x9de46173230a8af3ce372c7
            },
            w2: u384 {
                limb0: 0xf69a7fa038bcbceca5e1f3c,
                limb1: 0x8d3fc6e0ca54448b6de25fe1,
                limb2: 0xbb3dffe11a5f74d477839c20,
                limb3: 0x17a6afcd6bf582857986708
            },
            w3: u384 {
                limb0: 0x9ea91fe149f35d6ba37df6b9,
                limb1: 0xd8d0b8c8304ec17f35c44ff7,
                limb2: 0xa6a48f6516ea9d5d3987c9a0,
                limb3: 0x1455622df0d63eb046299940
            },
            w4: u384 {
                limb0: 0x6ec1b7b019bbf03db6d06615,
                limb1: 0xd149fe6377f141cd3b6f2ad2,
                limb2: 0xcb8c2c5e0bde3249cd06a3c9,
                limb3: 0x141918328525d1322c3c6326
            },
            w5: u384 {
                limb0: 0x5fb915188c126005d422666a,
                limb1: 0x7f82dcafc84d80373fa9613,
                limb2: 0x965fb6d40f65fa0f1d1cef46,
                limb3: 0xa826aa4fcc2a98ea4a661c3
            },
            w6: u384 {
                limb0: 0x80521e37dddfc64818409419,
                limb1: 0x63f7bd7a7ffd5e755fee0d78,
                limb2: 0x45ade3c0413eab4163b67b1d,
                limb3: 0x65f4c7061870c98d48a5ae0
            },
            w7: u384 {
                limb0: 0xbcd4823aedc54265f82e4074,
                limb1: 0x9658ffbeedd2fd1911e4a4de,
                limb2: 0xf4c96d1fd81efa4fb33508e,
                limb3: 0xbfacbe9d3290b13ac234f14
            },
            w8: u384 {
                limb0: 0x38159ed24afe17f878ec4ac4,
                limb1: 0x8bb0155e7342d96b1ae3be4f,
                limb2: 0x9a044f6aaff41ec62b2bb5b9,
                limb3: 0x4a2512c880b6a4cfcec2c1d
            },
            w9: u384 {
                limb0: 0xcdbdb337f839108e29ae1d3a,
                limb1: 0x566d8cf0bad7373d594c1f7c,
                limb2: 0x7ae624a67ec7a123063aa9e2,
                limb3: 0x2637f2ac72a5ac130c97d34
            },
            w10: u384 {
                limb0: 0x952a4ff52da4d7f2a2c1e1d4,
                limb1: 0xce5000d3ea6d556538102725,
                limb2: 0xb2cbcafea5fe07746b08e349,
                limb3: 0xfc81a45d929dfa02639b34b
            }
        };

        let z: u384 = u384 {
            limb0: 0x666a9594a562dbcf07b65bfe,
            limb1: 0x3712475429b75064f2669283,
            limb2: 0x867b77e69a66a840e744e888,
            limb3: 0xca176c5cb346925128c8b2b
        };

        let (check_result) = run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit(X, Y, Q, z);
        let check: u384 = u384 {
            limb0: 0xc815c6d75498c932fc0f1aa9,
            limb1: 0x978171ae7f0d35bc563a2351,
            limb2: 0x6bc0d19a9af0ca996b20a083,
            limb3: 0x632eb45f75e39879d700458
        };
        assert_eq!(check_result, check);
    }


    #[test]
    fn test_run_BN254_FP12_MUL_ASSERT_ONE_circuit_BN254() {
        let X = E12D {
            w0: u384 {
                limb0: 0x16d91fc5be85039460fc74e8,
                limb1: 0x7c11379776bfaa9b641d2571,
                limb2: 0x9031266a9c633e2,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xec5c62d24020912b4f6783a,
                limb1: 0x26b4a0a71cf0589debde3e11,
                limb2: 0x7a9c1d5a1d577a4,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x9b85f2b467706befd5be1022,
                limb1: 0x48040c13180aa66ae45f2e18,
                limb2: 0x24e8d94d14f3578d,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xe6effcd167286f94d370bdf9,
                limb1: 0x73de1a9e87f3aa2b2c0eb235,
                limb2: 0x1113bd24b3e1da11,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xa06d8653567494dfc399daf6,
                limb1: 0xcefad840a59464532cb16080,
                limb2: 0x10b279d06757af74,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x2d5d2173e53b864be48f5984,
                limb1: 0xd3341b0a296e77d2ea853efa,
                limb2: 0x57ba85db97155a0,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x8526a82aa325872d361fbb08,
                limb1: 0xc42d4bd6e6c653b1d113df73,
                limb2: 0x2b3f404c5b8a762f,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xde7b2c4274b20954bc5115e7,
                limb1: 0xd5b2fd55a89d831de6ad2510,
                limb2: 0x153fb6a8173e585c,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x5961640123d8c4800e67287c,
                limb1: 0x39e6f58f7fdf22292ce42e41,
                limb2: 0xecb47f2eded54e3,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xea727bf4202aae6410afa961,
                limb1: 0x6f283a3270a22d8ec3c02b36,
                limb2: 0x1716056c197aef97,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x1eff10783985577fc069f48d,
                limb1: 0x330760dc224c85db5286369e,
                limb2: 0x277be37d3ca318ca,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x321a11284586ce142e215337,
                limb1: 0xb589931f8c662964801f9c5f,
                limb2: 0x70ca877d54f58b7,
                limb3: 0x0
            }
        };

        let Y = E12D {
            w0: u384 {
                limb0: 0x9cd78bd28fbc9bba8748cffa,
                limb1: 0xbcc0cdcf8bebbe5b9013cc05,
                limb2: 0x180ce7baa8b12cca,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xbd08b032f9ad520206ab5a91,
                limb1: 0x23ca4739ce5e761b7b59a1c0,
                limb2: 0x56108e9005ba4e1,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x4cb4dadd98efec68fdeab3c,
                limb1: 0xc3d7df292368db81da34effa,
                limb2: 0x7003e51df0644a8,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xe84b60ec5235fb420e11f795,
                limb1: 0x319c7b43aae0a7644fd43443,
                limb2: 0x40373f6c413b8e8,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x620012a7f497b5a65c1ed1f5,
                limb1: 0xf3971943a640ca97fc88e170,
                limb2: 0x27a7913187b8d77e,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x5e3fafbffc06d3deadb3a8a7,
                limb1: 0x35b592e56b3190f4e55ef749,
                limb2: 0x2e0fed926463137f,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xbca1e7cd98a98ba60a2581e9,
                limb1: 0x1e1dd8c91a7859b39147d0e,
                limb2: 0x1c8a0366e2cd8130,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x6a37285102c1f0b0bce77742,
                limb1: 0x337faf64c6839f4a2749913f,
                limb2: 0x250cd2ec103ba901,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0xee628c9a211acf9ea2d9281b,
                limb1: 0xc9aadaa6e440aa7ce95361bf,
                limb2: 0x30067f7e510020c1,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x4b7bd27ae20e222447d35352,
                limb1: 0x73d0c8bfe2fb8f04c6eb245e,
                limb2: 0x21839c06579dc1fb,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0x5466accc7dbcc5f769d144d1,
                limb1: 0x8431e88c4427635ecf186b91,
                limb2: 0x137aa8a6debec758,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xe5173c41fdf156226751d1a4,
                limb1: 0xedbc59fe47c2e637c176eadb,
                limb2: 0xe9d642b25cc9a3,
                limb3: 0x0
            }
        };

        let Q = E12DMulQuotient {
            w0: u384 {
                limb0: 0xe8c2215dd739bb9e36cc66a4,
                limb1: 0xc0b2ae8b77887200b6bd58d6,
                limb2: 0x19cd7cd54c7c9c38,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xbd60bb3ebd45242f6db6cc9a,
                limb1: 0xedb52ad7db3d977bd3d69412,
                limb2: 0x2bad017cd006434c,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xd7488a7680aaf97e454b57c1,
                limb1: 0x96561c9429efcdfc81992dc5,
                limb2: 0xbd656f0dad16c2b,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xd7fab5bc1dc11ea22f06771e,
                limb1: 0x8410ebdf0ded0f89f059a06d,
                limb2: 0x2cfe157209c9a8dc,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x2328d866975e2ac2f08df7c1,
                limb1: 0x35b996bd901d169d25ab3477,
                limb2: 0x16fb8478a5660feb,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x18867eb5199121865dbfc02b,
                limb1: 0x20283b567d00aff3606d396e,
                limb2: 0x24b3947f55ed6029,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x3402a47a85b3a01ee4146592,
                limb1: 0xc37418f2394993699b73b023,
                limb2: 0x247c655798e19c4a,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xe76a469ebfc27f001875dc2a,
                limb1: 0xb79f3b37f0c0dc323040c2cb,
                limb2: 0xb633df821583621,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x4405962bb016dddaecb501ee,
                limb1: 0xad26ebe4cadf4be2468f6365,
                limb2: 0xad342a4531d07a1,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xb5e2d9fffcb0f07f72127835,
                limb1: 0x199c47458bd657c45606356d,
                limb2: 0x5c82e2dc12c9c8d,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xff34b4c02f2da9e657475fd,
                limb1: 0x6f6972a557ed0cd13048d3c9,
                limb2: 0xfe2fb33e27770d5,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0xed1a474854b58fb5cd656a21,
            limb1: 0x1fb861a396d53ecf6d6fee53,
            limb2: 0x431597554059bed,
            limb3: 0x0
        };

        let (check_result) = run_BN254_FP12_MUL_ASSERT_ONE_circuit(X, Y, Q, z);
        let check: u384 = u384 {
            limb0: 0xc7f92fd74254f73efbd451e9,
            limb1: 0x968840383d9de3af860c6810,
            limb2: 0xebbbf7eea3f8dd8,
            limb3: 0x0
        };
        assert_eq!(check_result, check);
    }
}
