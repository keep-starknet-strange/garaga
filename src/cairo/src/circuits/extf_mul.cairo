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
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor
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
        MillerLoopResultScalingFactor
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

    use super::{run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit, run_BN254_FP12_MUL_ASSERT_ONE_circuit};

    #[test]
    fn test_run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit_BLS12_381() {
        let X = E12D {
            w0: u384 {
                limb0: 0x20fff2cb6857548c9e689188,
                limb1: 0x30cceeb348d46113b50aea15,
                limb2: 0x7d9fab3fccdbab0b13b40ac,
                limb3: 0x5cdb615bd33677abff8746d
            },
            w1: u384 {
                limb0: 0x8c9965796ec59896ffcb2aa3,
                limb1: 0xf2e573e2b22d888b38130ad1,
                limb2: 0xe722efaacd69de05feaedd7,
                limb3: 0xcbadaf824b4aaafab3a1d34
            },
            w2: u384 {
                limb0: 0x74cac73bf14a58b3eefd1aa0,
                limb1: 0x62330da619e0f5b764fbfae6,
                limb2: 0xf6000f24cfe1f8acc66aefe,
                limb3: 0x487867a3ab319ae45b333c7
            },
            w3: u384 {
                limb0: 0xeab94eba93f28ab5616cd40e,
                limb1: 0x526aea432c337ceea97d229a,
                limb2: 0x827254df38305e4bc3d4540a,
                limb3: 0xcd633bb5d88c5860fad3771
            },
            w4: u384 {
                limb0: 0x7363cd269c45171f0d58306,
                limb1: 0x5f40ec4712d527a03cc17dde,
                limb2: 0x7d3e37112985c817a937cc86,
                limb3: 0x11552fa7bd6337b3d5957c15
            },
            w5: u384 {
                limb0: 0x8b2439d4b6328f01197e30de,
                limb1: 0xe5961b741925b544c69d9109,
                limb2: 0x5cec2965858f0cef7b0b48ed,
                limb3: 0xa6944aa6d3b6c47810c040
            },
            w6: u384 {
                limb0: 0x869f6ec6da58e05a291b0b3f,
                limb1: 0x700b2978e9e0cd8b2da562c6,
                limb2: 0x7fca5734b32d747134f75266,
                limb3: 0x98e61de6d4fda9921f6383c
            },
            w7: u384 {
                limb0: 0x62ada60321811ff0125f0449,
                limb1: 0xe76419b8e79ae8b592ef181c,
                limb2: 0xdf181e4f394e61fe1bbc403d,
                limb3: 0xfc93d71c3629df76898a668
            },
            w8: u384 {
                limb0: 0x23f6395130ae10926138cf93,
                limb1: 0xeda12915fd209f3259c07b44,
                limb2: 0x4d75fe3e7c52dc01327278c,
                limb3: 0x162db8b7b03dd39f42e37126
            },
            w9: u384 {
                limb0: 0xc46477d001f59b1c483837de,
                limb1: 0xc5f87eff12d06ce5dff4e562,
                limb2: 0xde9f56956cf89db398b3f261,
                limb3: 0xc2a67c01151de92980b5c39
            },
            w10: u384 {
                limb0: 0x8c1d76b28e334a4986cdf496,
                limb1: 0xb9452195d03ce6060b7fc161,
                limb2: 0xca10725a112a21749d270596,
                limb3: 0x623c85b1d665a38c24d532f
            },
            w11: u384 {
                limb0: 0x96417f0c516ee3ec675a4db5,
                limb1: 0xa85e869463e55888b40dd177,
                limb2: 0x8950724d7dbfd37f0107d458,
                limb3: 0xf142ed15f82283e4d7a2830
            }
        };

        let Y = E12D {
            w0: u384 {
                limb0: 0xf2d72a3b0e3522edb63250a2,
                limb1: 0xcaa9df00ded5ea11403af7af,
                limb2: 0x486dd2b74be622a100ec2994,
                limb3: 0x150dd1212d3f11dc3f8d692c
            },
            w1: u384 {
                limb0: 0xf3020be7f86445d74c6bf5b8,
                limb1: 0xfbb2fcac8f1df6fc380320fc,
                limb2: 0xafb72774fe3da5241873b82b,
                limb3: 0x147ebec130b570fee209b136
            },
            w2: u384 {
                limb0: 0x72883dfe3bef6eeff6307286,
                limb1: 0xd31b6f936a73fc45df3fe737,
                limb2: 0x1f33f11e54425d51df5f725,
                limb3: 0x577d6202162113f8285b5e8
            },
            w3: u384 {
                limb0: 0xcd7dd454f3841334ebbd44b7,
                limb1: 0x3b99fbc3325659ab7a4883c9,
                limb2: 0x2253dfc54d9f0dfa10e2e071,
                limb3: 0x13b0236cc3c74f42c4b9ee85
            },
            w4: u384 {
                limb0: 0x6cb7c5bf0e58cd63c7e470d9,
                limb1: 0x4aaa3cc8dcc3339446780a81,
                limb2: 0xd64d47458f8643af86e396dd,
                limb3: 0x13c34c118cb10928452db5ba
            },
            w5: u384 {
                limb0: 0x137a168eb782fe1ab917e104,
                limb1: 0xd53fa183977b5433bec4aa17,
                limb2: 0xdf93e0d5d7a6058518c8a622,
                limb3: 0x41cf661114d1ad3790eefa8
            },
            w6: u384 {
                limb0: 0xaaf50770a2081bc46f3454e0,
                limb1: 0xb470b8c2e842be8d0a97b6f9,
                limb2: 0x4a1f73ba3579404fb0a11815,
                limb3: 0x8d66734d7eaecc0955f3565
            },
            w7: u384 {
                limb0: 0xebcb61c01270ff80ede013c6,
                limb1: 0xc99ad9bba38beec4baf239b9,
                limb2: 0xbf74c16073fb7c3a93a5e78e,
                limb3: 0x13613033b1db0f7729735237
            },
            w8: u384 {
                limb0: 0x527febc215777894468bc959,
                limb1: 0x2d2674be2a6ba43a0ec37460,
                limb2: 0xede3739857c22aee6d7e8c63,
                limb3: 0x279c5ef02af139b55966408
            },
            w9: u384 {
                limb0: 0xab2e8bc1a68f3d5525c355dd,
                limb1: 0xf1173924b70918e85df4e0e8,
                limb2: 0x6d63565fe1c7087e5a469d02,
                limb3: 0x1667e7f45cf7f2d5067c6e85
            },
            w10: u384 {
                limb0: 0x9219fe1dd5ee9df9101c0d4c,
                limb1: 0xa6d8179a59a7a4d295dc200c,
                limb2: 0x57916b319835245afe5f37d3,
                limb3: 0x372184b75fc330325671f98
            },
            w11: u384 {
                limb0: 0xbd7e1f96c55dcbc2fc3b28bf,
                limb1: 0xebe36227b3e6b224cef9ae0f,
                limb2: 0x9f4bb174aeb9c209bef5602e,
                limb3: 0xe52e617d6846cfd8dc68e11
            }
        };

        let Q = E12DMulQuotient {
            w0: u384 {
                limb0: 0xbb44af62d891a86421e3aa38,
                limb1: 0x7b66a9ac60e8610172421123,
                limb2: 0xdbe26a9c4f0743b18ed9acf0,
                limb3: 0x158745d5bf5057febbdb799e
            },
            w1: u384 {
                limb0: 0xf55aae577c63747aa71cbf0f,
                limb1: 0x50da07a16c3a6e073660fc39,
                limb2: 0xf6170e9c7cadab1606378948,
                limb3: 0x4bccfcc688cd288d7c3ba60
            },
            w2: u384 {
                limb0: 0xd4f75de64b4270089b4d3ac7,
                limb1: 0x506dec11c8bbea21dd5d3b9b,
                limb2: 0x324e04b61c4cd545369b4563,
                limb3: 0x12d265dfbb5225772080dd12
            },
            w3: u384 {
                limb0: 0xf499341a7bdfcf8ba129d91b,
                limb1: 0xc5440df00080c8261b259968,
                limb2: 0x5f2f25cb07b62caffafd260a,
                limb3: 0xd7989874733ef7da55f50f6
            },
            w4: u384 {
                limb0: 0x3b6803ee940d10cdaf73d31f,
                limb1: 0x93f0e4b4387138d463416865,
                limb2: 0x9675562f1157c073b3e19908,
                limb3: 0x8b2699ca6aae7ad191fa8bc
            },
            w5: u384 {
                limb0: 0x451ad86965f5779e2b41d86,
                limb1: 0xd148867a65698eaad4fae26d,
                limb2: 0xd6a77153b5c7dfc64af5adf3,
                limb3: 0x5e151c267d7ff805feff9a8
            },
            w6: u384 {
                limb0: 0x9a44df106074662f5c6f76ca,
                limb1: 0xb6a6668e9543cfd8edf50d02,
                limb2: 0xc984fec7cf0015141faf39ed,
                limb3: 0x11efae12ef58e475bd33307b
            },
            w7: u384 {
                limb0: 0x552a41d26ce38dafc2acf2c9,
                limb1: 0xf9e5399e55a0fcb3422e2e95,
                limb2: 0x2da2f1939e730261181a00c0,
                limb3: 0x7a22b24dfe68c5171a261d8
            },
            w8: u384 {
                limb0: 0x72add5ea1934c37730ac64c5,
                limb1: 0xff8b112a183608b3519fc4,
                limb2: 0x2f7acf2f9fbe505baccb54e8,
                limb3: 0x17bd5418cc19b2c95b3146b6
            },
            w9: u384 {
                limb0: 0x4e210675bd6b774d0e15c9f5,
                limb1: 0x154959a9295f90503c79db9d,
                limb2: 0x53a34be0bc6f12c0898122bb,
                limb3: 0x29bfffa9d9f20907af94397
            },
            w10: u384 {
                limb0: 0x537dec6395a2888492747f90,
                limb1: 0xdc59e4a50a06c335079092e4,
                limb2: 0x1d494ca5fc5a326352b51adc,
                limb3: 0xd48b428fcc6b9501a047c3d
            }
        };

        let z: u384 = u384 {
            limb0: 0xd42986fae9aebe887af51c9c,
            limb1: 0x61086f02d9657db2f00a2a15,
            limb2: 0x46bc0d80593dc4eb93cf3e68,
            limb3: 0x12262a0f92f424609a1c1c26
        };

        let (check_result) = run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit(X, Y, Q, z);
        let check: u384 = u384 {
            limb0: 0xd5ce849cb6cc5a029850006,
            limb1: 0x7ac372440461ed78fab065f5,
            limb2: 0x9974bdad58268cae48bad1b1,
            limb3: 0xb33965e7715f38651980d0a
        };
        assert_eq!(check_result, check);
    }


    #[test]
    fn test_run_BN254_FP12_MUL_ASSERT_ONE_circuit_BN254() {
        let X = E12D {
            w0: u384 {
                limb0: 0x3756af5183dc01010b63983c,
                limb1: 0xaac487b171db0784b71df25e,
                limb2: 0x1148931e9cf52508,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xdc8848ba6ab09995c78e0f48,
                limb1: 0xf5a3f57c637c71aef9862da,
                limb2: 0xff27c52c05f9874,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x5f0099167df8b7f044a1d4d0,
                limb1: 0xee1ce2b4b385492d4c6700b,
                limb2: 0x10f382e0fee2f56b,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x5bf2b6a11b95cd28b2764173,
                limb1: 0xeaaa5a3e31dbd1d548e003be,
                limb2: 0xee2ee03572de2ff,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0xd4ae04b3fab2a7803dbe0be0,
                limb1: 0xaf5f7bd63021c8ad3302a5ca,
                limb2: 0x7c9974060e248c1,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x405e342dfbe30bf988f1559e,
                limb1: 0xf86040142b3c1658aa3042f9,
                limb2: 0x162a6df5f61d103d,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x6e090ea64032ee1e75711fc,
                limb1: 0xab46afee8898a682e0968f21,
                limb2: 0x2237c0c10b320459,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x1c0989b1af56d7ba6f086f65,
                limb1: 0xb58e2a1ccdf53f9b4102364b,
                limb2: 0x20b73dcd33744da6,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x8d87b7e8ac91b72f6c14b828,
                limb1: 0x25bc36a32df19dfb5a5915c2,
                limb2: 0x7cd5d03cc2946f5,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xd8d02c0dbb4e01c54980588c,
                limb1: 0xc2411753bd3a98bdcc583f50,
                limb2: 0xb22506f4b7118ac,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xb092a5ff948c2d4389fb4504,
                limb1: 0x7a440b3413e34b3d3d946990,
                limb2: 0xc55d173ccfcd746,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0xfc8ba273caa7b1c81a71a203,
                limb1: 0xd12ea61b76ad2cfc23f4fe14,
                limb2: 0x167ab9a6a09c93de,
                limb3: 0x0
            }
        };

        let Y = E12D {
            w0: u384 {
                limb0: 0xd24f8f4351a2fa157b6c0adb,
                limb1: 0x7bef34f04fc3489b9c14c815,
                limb2: 0x12235a882415f2a3,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0xb0a1baa56921c1c00bae07a2,
                limb1: 0x76ad98ba10fb5581cccb4dfb,
                limb2: 0xb5c580897ec1a40,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0x1ce76bc0c34c3f471171c294,
                limb1: 0x3b34252964d63e97de6ff3f1,
                limb2: 0x280ca50f4ab878c7,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0xf11e71ae6ce2a4651b742111,
                limb1: 0x955e988df24bfd76a07f949e,
                limb2: 0x12e643b9f6714d76,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x8615ad73699303f1bde82282,
                limb1: 0xe31b328e3a3262055e26b29d,
                limb2: 0xfb49e12c6950d85,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0xa6db74d1a748687529bdf604,
                limb1: 0x1ddde15af323e4341bbf9922,
                limb2: 0x26bc799b890974e4,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0x99225957ee705259262ae4c4,
                limb1: 0x2fd8e8ebe14880c0994d799a,
                limb2: 0x15ddb694f8c03d19,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0xa886e763c2c49a972e6f1665,
                limb1: 0x55b1f1c6059251e1de0a09a6,
                limb2: 0x6952b2c265a9190,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x9b3e660550835669836cd602,
                limb1: 0x1a29313d3f74df9ae43bd530,
                limb2: 0x2fae5a58bc16ca04,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0xf856a0c38fda05f0e45d7a7c,
                limb1: 0xbc7838b31a9af2a3ec6b2ea2,
                limb2: 0x1e8fa641aeef4b09,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xb2b5591a9d7f542b85e2b078,
                limb1: 0x7e54ed03eef42592ec1c6fe4,
                limb2: 0x157302c349556582,
                limb3: 0x0
            },
            w11: u384 {
                limb0: 0x173235659dc257bde19dad46,
                limb1: 0xa246b8560a94891e357245f9,
                limb2: 0x19dae528ecd2742d,
                limb3: 0x0
            }
        };

        let Q = E12DMulQuotient {
            w0: u384 {
                limb0: 0xb916751942a699a5571cf04d,
                limb1: 0xb36cddb8beabdee5c8614c36,
                limb2: 0x43fd37ae6ff73b5,
                limb3: 0x0
            },
            w1: u384 {
                limb0: 0x733db528d4323934cda9cfae,
                limb1: 0x9ca574d20979829cc898b6a,
                limb2: 0x632d384abe04a61,
                limb3: 0x0
            },
            w2: u384 {
                limb0: 0xb5743132ef3822707072aa51,
                limb1: 0xc34920a7fcfa3a3b47f050aa,
                limb2: 0x10453e8455b3b1ac,
                limb3: 0x0
            },
            w3: u384 {
                limb0: 0x5cae1234bb10d4065a55805d,
                limb1: 0xe8ebbae25bc1c77afa29fad9,
                limb2: 0x2df54b73f2aaaaf0,
                limb3: 0x0
            },
            w4: u384 {
                limb0: 0x47595fb338b4372600cea03,
                limb1: 0xa0e38dd6f700358564d06b24,
                limb2: 0x2275e2ac94be4e35,
                limb3: 0x0
            },
            w5: u384 {
                limb0: 0x631d91b5073039f1e6ad906,
                limb1: 0x17bcd32324b441266f1f7a15,
                limb2: 0x80097e0d5d0a12d,
                limb3: 0x0
            },
            w6: u384 {
                limb0: 0xe9edc59ca80ab2000cfcbe46,
                limb1: 0xf6bd16ac4ab507018e6b81a3,
                limb2: 0x303e940c326e1983,
                limb3: 0x0
            },
            w7: u384 {
                limb0: 0x3e0f74885c88c320a7b0a957,
                limb1: 0x15362c1f90b359d9ff0a837a,
                limb2: 0xe45d6bac38efb8c,
                limb3: 0x0
            },
            w8: u384 {
                limb0: 0x5140094b6ed4e645aaed8b53,
                limb1: 0xb2363b7ea221c908a4edeefd,
                limb2: 0x125881cea0f9986a,
                limb3: 0x0
            },
            w9: u384 {
                limb0: 0x75f98f4110a15299054efa50,
                limb1: 0xf106892ba1fa46f346685cdd,
                limb2: 0xdaf189a61af473d,
                limb3: 0x0
            },
            w10: u384 {
                limb0: 0xe9a28f3cb9abe19f2911cf30,
                limb1: 0x28685bdd02c81d1173f19747,
                limb2: 0x2b0c5edd82ab3e,
                limb3: 0x0
            }
        };

        let z: u384 = u384 {
            limb0: 0xfdcb8a6e9265da012aad0659,
            limb1: 0xcb771b1e922ba0aae055b94,
            limb2: 0x17aaf63d178234e8,
            limb3: 0x0
        };

        let (check_result) = run_BN254_FP12_MUL_ASSERT_ONE_circuit(X, Y, Q, z);
        let check: u384 = u384 {
            limb0: 0x9e685905eb3ee138f9d93c34,
            limb1: 0x7a409f0fa629cee3409d3e20,
            limb2: 0x8c91ce90b6543e9,
            limb3: 0x0
        };
        assert_eq!(check_result, check);
    }
}
