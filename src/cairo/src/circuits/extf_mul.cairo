use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
<<<<<<< HEAD
=======
use garaga::core::circuit::AddInputResultTrait2;
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, E12DMulQuotient, G1G2Pair,
<<<<<<< HEAD
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor
};
use core::option::Option;

=======
    BNProcessedPair, BLSProcessedPair, MillerLoopResultScalingFactor, G2Line
};
use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};
use core::option::Option;

fn run_BLS12_381_EVAL_E12D_circuit(f: E12D, z: u384) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let in12 = CE::<CI<12>> {};
    let t0 = circuit_mul(in12, in12); // Compute z^2
    let t1 = circuit_mul(t0, in12); // Compute z^3
    let t2 = circuit_mul(t1, in12); // Compute z^4
    let t3 = circuit_mul(t2, in12); // Compute z^5
    let t4 = circuit_mul(t3, in12); // Compute z^6
    let t5 = circuit_mul(t4, in12); // Compute z^7
    let t6 = circuit_mul(t5, in12); // Compute z^8
    let t7 = circuit_mul(t6, in12); // Compute z^9
    let t8 = circuit_mul(t7, in12); // Compute z^10
    let t9 = circuit_mul(t8, in12); // Compute z^11
    let t10 = circuit_mul(in1, in12); // Eval X step coeff_1 * z^1
    let t11 = circuit_add(in0, t10); // Eval X step + (coeff_1 * z^1)
    let t12 = circuit_mul(in2, t0); // Eval X step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval X step + (coeff_2 * z^2)
    let t14 = circuit_mul(in3, t1); // Eval X step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval X step + (coeff_3 * z^3)
    let t16 = circuit_mul(in4, t2); // Eval X step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval X step + (coeff_4 * z^4)
    let t18 = circuit_mul(in5, t3); // Eval X step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval X step + (coeff_5 * z^5)
    let t20 = circuit_mul(in6, t4); // Eval X step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval X step + (coeff_6 * z^6)
    let t22 = circuit_mul(in7, t5); // Eval X step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval X step + (coeff_7 * z^7)
    let t24 = circuit_mul(in8, t6); // Eval X step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval X step + (coeff_8 * z^8)
    let t26 = circuit_mul(in9, t7); // Eval X step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval X step + (coeff_9 * z^9)
    let t28 = circuit_mul(in10, t8); // Eval X step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval X step + (coeff_10 * z^10)
    let t30 = circuit_mul(in11, t9); // Eval X step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval X step + (coeff_11 * z^11)

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [
            0xb153ffffb9feffffffffaaab,
            0x6730d2a0f6b0f6241eabfffe,
            0x434bacd764774b84f38512bf,
            0x1a0111ea397fe69a4b1ba7b6
        ]
    )
        .unwrap(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t31,).new_inputs();
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
    let f_of_z: u384 = outputs.get_output(t31);
    return (f_of_z,);
}
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
fn run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit(
    X: E12D, Y: E12D, Q: E12DMulQuotient, z: u384
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x2
    let in1 = CE::<CI<1>> {}; // -0x2 % p
    let in2 = CE::<CI<2>> {}; // 0x1

    // INPUT stack
<<<<<<< HEAD
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
=======
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
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
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
<<<<<<< HEAD
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
=======
            0xb153ffffb9feffffffffaaab,
            0x6730d2a0f6b0f6241eabfffe,
            0x434bacd764774b84f38512bf,
            0x1a0111ea397fe69a4b1ba7b6
        ]
    )
        .unwrap(); // BLS12_381 prime field modulus

    let mut circuit_inputs = (t81,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x2, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
            [
                0xb153ffffb9feffffffffaaa9,
                0x6730d2a0f6b0f6241eabfffe,
                0x434bacd764774b84f38512bf,
                0x1a0111ea397fe69a4b1ba7b6
            ]
<<<<<<< HEAD
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
fn run_BLS12_381_FP12_MUL_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x2
    let in1 = CE::<CI<1>> {}; // -0x2 % p

    // INPUT stack
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21) = (CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23) = (CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});

    // COMMIT stack
    let (in26, in27) = (CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29) = (CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31) = (CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33) = (CE::<CI<32>> {}, CE::<CI<33>> {});
    let (in34, in35) = (CE::<CI<34>> {}, CE::<CI<35>> {});
    let (in36, in37) = (CE::<CI<36>> {}, CE::<CI<37>> {});
    let (in38, in39) = (CE::<CI<38>> {}, CE::<CI<39>> {});
    let (in40, in41) = (CE::<CI<40>> {}, CE::<CI<41>> {});
    let (in42, in43) = (CE::<CI<42>> {}, CE::<CI<43>> {});
    let (in44, in45) = (CE::<CI<44>> {}, CE::<CI<45>> {});
    let (in46, in47) = (CE::<CI<46>> {}, CE::<CI<47>> {});
    let in48 = CE::<CI<48>> {};

    // FELT stack
    let (in49, in50) = (CE::<CI<49>> {}, CE::<CI<50>> {});
    let t0 = circuit_mul(in50, in50); // Compute z^2
    let t1 = circuit_mul(t0, in50); // Compute z^3
    let t2 = circuit_mul(t1, in50); // Compute z^4
    let t3 = circuit_mul(t2, in50); // Compute z^5
    let t4 = circuit_mul(t3, in50); // Compute z^6
    let t5 = circuit_mul(t4, in50); // Compute z^7
    let t6 = circuit_mul(t5, in50); // Compute z^8
    let t7 = circuit_mul(t6, in50); // Compute z^9
    let t8 = circuit_mul(t7, in50); // Compute z^10
    let t9 = circuit_mul(t8, in50); // Compute z^11
    let t10 = circuit_mul(t9, in50); // Compute z^12
    let t11 = circuit_mul(in3, in50); // Eval UnnamedPoly step coeff_1 * z^1
    let t12 = circuit_add(in2, t11); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t13 = circuit_mul(in4, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t14 = circuit_add(t12, t13); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t15 = circuit_mul(in5, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t16 = circuit_add(t14, t15); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t17 = circuit_mul(in6, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t18 = circuit_add(t16, t17); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t19 = circuit_mul(in7, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t20 = circuit_add(t18, t19); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t21 = circuit_mul(in8, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t22 = circuit_add(t20, t21); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t23 = circuit_mul(in9, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t24 = circuit_add(t22, t23); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t25 = circuit_mul(in10, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t26 = circuit_add(t24, t25); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t27 = circuit_mul(in11, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t28 = circuit_add(t26, t27); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t29 = circuit_mul(in12, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t30 = circuit_add(t28, t29); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t31 = circuit_mul(in13, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t32 = circuit_add(t30, t31); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t33 = circuit_mul(in15, in50); // Eval UnnamedPoly step coeff_1 * z^1
    let t34 = circuit_add(in14, t33); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t35 = circuit_mul(in16, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t36 = circuit_add(t34, t35); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t37 = circuit_mul(in17, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t38 = circuit_add(t36, t37); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t39 = circuit_mul(in18, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t40 = circuit_add(t38, t39); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t41 = circuit_mul(in19, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t42 = circuit_add(t40, t41); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t43 = circuit_mul(in20, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t44 = circuit_add(t42, t43); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t45 = circuit_mul(in21, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t46 = circuit_add(t44, t45); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t47 = circuit_mul(in22, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t48 = circuit_add(t46, t47); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t49 = circuit_mul(in23, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t50 = circuit_add(t48, t49); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t51 = circuit_mul(in24, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t52 = circuit_add(t50, t51); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t53 = circuit_mul(in25, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t54 = circuit_add(t52, t53); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t55 = circuit_mul(t32, t54);
    let t56 = circuit_mul(in49, t55);
    let t57 = circuit_mul(in49, in26);
    let t58 = circuit_mul(in49, in27);
    let t59 = circuit_mul(in49, in28);
    let t60 = circuit_mul(in49, in29);
    let t61 = circuit_mul(in49, in30);
    let t62 = circuit_mul(in49, in31);
    let t63 = circuit_mul(in49, in32);
    let t64 = circuit_mul(in49, in33);
    let t65 = circuit_mul(in49, in34);
    let t66 = circuit_mul(in49, in35);
    let t67 = circuit_mul(in49, in36);
    let t68 = circuit_mul(in49, in37);
    let t69 = circuit_mul(in39, in50); // Eval UnnamedPoly step coeff_1 * z^1
    let t70 = circuit_add(in38, t69); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t71 = circuit_mul(in40, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t72 = circuit_add(t70, t71); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t73 = circuit_mul(in41, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t74 = circuit_add(t72, t73); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t75 = circuit_mul(in42, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t76 = circuit_add(t74, t75); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t77 = circuit_mul(in43, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t78 = circuit_add(t76, t77); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t79 = circuit_mul(in44, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t80 = circuit_add(t78, t79); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t81 = circuit_mul(in45, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t82 = circuit_add(t80, t81); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t83 = circuit_mul(in46, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t84 = circuit_add(t82, t83); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t85 = circuit_mul(in47, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t86 = circuit_add(t84, t85); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t87 = circuit_mul(in48, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t88 = circuit_add(t86, t87); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t89 = circuit_mul(in1, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t90 = circuit_add(in0, t89); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t91 = circuit_add(t90, t10); // Eval sparse poly UnnamedPoly step + 1*z^12
    let t92 = circuit_mul(t58, in50); // Eval UnnamedPoly step coeff_1 * z^1
    let t93 = circuit_add(t57, t92); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t94 = circuit_mul(t59, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t96 = circuit_mul(t60, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t98 = circuit_mul(t61, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t100 = circuit_mul(t62, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t102 = circuit_mul(t63, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t104 = circuit_mul(t64, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t106 = circuit_mul(t65, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t108 = circuit_mul(t66, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t110 = circuit_mul(t67, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t111 = circuit_add(t109, t110); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t112 = circuit_mul(t68, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t113 = circuit_add(t111, t112); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t114 = circuit_mul(t88, t91);
    let t115 = circuit_add(t114, t113);
    let t116 = circuit_sub(t115, t56);

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

    let mut circuit_inputs = (t116,).new_inputs();
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

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t116)];
    return res;
}

=======
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
fn run_BN254_EVAL_E12D_circuit(f: E12D, z: u384) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let in12 = CE::<CI<12>> {};
    let t0 = circuit_mul(in12, in12); // Compute z^2
    let t1 = circuit_mul(t0, in12); // Compute z^3
    let t2 = circuit_mul(t1, in12); // Compute z^4
    let t3 = circuit_mul(t2, in12); // Compute z^5
    let t4 = circuit_mul(t3, in12); // Compute z^6
    let t5 = circuit_mul(t4, in12); // Compute z^7
    let t6 = circuit_mul(t5, in12); // Compute z^8
    let t7 = circuit_mul(t6, in12); // Compute z^9
    let t8 = circuit_mul(t7, in12); // Compute z^10
    let t9 = circuit_mul(t8, in12); // Compute z^11
    let t10 = circuit_mul(in1, in12); // Eval X step coeff_1 * z^1
    let t11 = circuit_add(in0, t10); // Eval X step + (coeff_1 * z^1)
    let t12 = circuit_mul(in2, t0); // Eval X step coeff_2 * z^2
    let t13 = circuit_add(t11, t12); // Eval X step + (coeff_2 * z^2)
    let t14 = circuit_mul(in3, t1); // Eval X step coeff_3 * z^3
    let t15 = circuit_add(t13, t14); // Eval X step + (coeff_3 * z^3)
    let t16 = circuit_mul(in4, t2); // Eval X step coeff_4 * z^4
    let t17 = circuit_add(t15, t16); // Eval X step + (coeff_4 * z^4)
    let t18 = circuit_mul(in5, t3); // Eval X step coeff_5 * z^5
    let t19 = circuit_add(t17, t18); // Eval X step + (coeff_5 * z^5)
    let t20 = circuit_mul(in6, t4); // Eval X step coeff_6 * z^6
    let t21 = circuit_add(t19, t20); // Eval X step + (coeff_6 * z^6)
    let t22 = circuit_mul(in7, t5); // Eval X step coeff_7 * z^7
    let t23 = circuit_add(t21, t22); // Eval X step + (coeff_7 * z^7)
    let t24 = circuit_mul(in8, t6); // Eval X step coeff_8 * z^8
    let t25 = circuit_add(t23, t24); // Eval X step + (coeff_8 * z^8)
    let t26 = circuit_mul(in9, t7); // Eval X step coeff_9 * z^9
    let t27 = circuit_add(t25, t26); // Eval X step + (coeff_9 * z^9)
    let t28 = circuit_mul(in10, t8); // Eval X step coeff_10 * z^10
    let t29 = circuit_add(t27, t28); // Eval X step + (coeff_10 * z^10)
    let t30 = circuit_mul(in11, t9); // Eval X step coeff_11 * z^11
    let t31 = circuit_add(t29, t30); // Eval X step + (coeff_11 * z^11)

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into([0x6871ca8d3c208c16d87cfd47, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0])
        .unwrap(); // BN254 prime field modulus

    let mut circuit_inputs = (t31,).new_inputs();
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
    let f_of_z: u384 = outputs.get_output(t31);
    return (f_of_z,);
}
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
fn run_BN254_FP12_MUL_ASSERT_ONE_circuit(X: E12D, Y: E12D, Q: E12DMulQuotient, z: u384) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x52
    let in1 = CE::<CI<1>> {}; // -0x12 % p
    let in2 = CE::<CI<2>> {}; // 0x1

    // INPUT stack
<<<<<<< HEAD
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
=======
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
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
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
<<<<<<< HEAD
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
fn run_BN254_FP12_MUL_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x52
    let in1 = CE::<CI<1>> {}; // -0x12 % p

    // INPUT stack
    let (in2, in3) = (CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5) = (CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7) = (CE::<CI<6>> {}, CE::<CI<7>> {});
    let (in8, in9) = (CE::<CI<8>> {}, CE::<CI<9>> {});
    let (in10, in11) = (CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13) = (CE::<CI<12>> {}, CE::<CI<13>> {});
    let (in14, in15) = (CE::<CI<14>> {}, CE::<CI<15>> {});
    let (in16, in17) = (CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let (in20, in21) = (CE::<CI<20>> {}, CE::<CI<21>> {});
    let (in22, in23) = (CE::<CI<22>> {}, CE::<CI<23>> {});
    let (in24, in25) = (CE::<CI<24>> {}, CE::<CI<25>> {});

    // COMMIT stack
    let (in26, in27) = (CE::<CI<26>> {}, CE::<CI<27>> {});
    let (in28, in29) = (CE::<CI<28>> {}, CE::<CI<29>> {});
    let (in30, in31) = (CE::<CI<30>> {}, CE::<CI<31>> {});
    let (in32, in33) = (CE::<CI<32>> {}, CE::<CI<33>> {});
    let (in34, in35) = (CE::<CI<34>> {}, CE::<CI<35>> {});
    let (in36, in37) = (CE::<CI<36>> {}, CE::<CI<37>> {});
    let (in38, in39) = (CE::<CI<38>> {}, CE::<CI<39>> {});
    let (in40, in41) = (CE::<CI<40>> {}, CE::<CI<41>> {});
    let (in42, in43) = (CE::<CI<42>> {}, CE::<CI<43>> {});
    let (in44, in45) = (CE::<CI<44>> {}, CE::<CI<45>> {});
    let (in46, in47) = (CE::<CI<46>> {}, CE::<CI<47>> {});
    let in48 = CE::<CI<48>> {};

    // FELT stack
    let (in49, in50) = (CE::<CI<49>> {}, CE::<CI<50>> {});
    let t0 = circuit_mul(in50, in50); // Compute z^2
    let t1 = circuit_mul(t0, in50); // Compute z^3
    let t2 = circuit_mul(t1, in50); // Compute z^4
    let t3 = circuit_mul(t2, in50); // Compute z^5
    let t4 = circuit_mul(t3, in50); // Compute z^6
    let t5 = circuit_mul(t4, in50); // Compute z^7
    let t6 = circuit_mul(t5, in50); // Compute z^8
    let t7 = circuit_mul(t6, in50); // Compute z^9
    let t8 = circuit_mul(t7, in50); // Compute z^10
    let t9 = circuit_mul(t8, in50); // Compute z^11
    let t10 = circuit_mul(t9, in50); // Compute z^12
    let t11 = circuit_mul(in3, in50); // Eval UnnamedPoly step coeff_1 * z^1
    let t12 = circuit_add(in2, t11); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t13 = circuit_mul(in4, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t14 = circuit_add(t12, t13); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t15 = circuit_mul(in5, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t16 = circuit_add(t14, t15); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t17 = circuit_mul(in6, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t18 = circuit_add(t16, t17); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t19 = circuit_mul(in7, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t20 = circuit_add(t18, t19); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t21 = circuit_mul(in8, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t22 = circuit_add(t20, t21); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t23 = circuit_mul(in9, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t24 = circuit_add(t22, t23); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t25 = circuit_mul(in10, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t26 = circuit_add(t24, t25); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t27 = circuit_mul(in11, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t28 = circuit_add(t26, t27); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t29 = circuit_mul(in12, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t30 = circuit_add(t28, t29); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t31 = circuit_mul(in13, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t32 = circuit_add(t30, t31); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t33 = circuit_mul(in15, in50); // Eval UnnamedPoly step coeff_1 * z^1
    let t34 = circuit_add(in14, t33); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t35 = circuit_mul(in16, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t36 = circuit_add(t34, t35); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t37 = circuit_mul(in17, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t38 = circuit_add(t36, t37); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t39 = circuit_mul(in18, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t40 = circuit_add(t38, t39); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t41 = circuit_mul(in19, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t42 = circuit_add(t40, t41); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t43 = circuit_mul(in20, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t44 = circuit_add(t42, t43); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t45 = circuit_mul(in21, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t46 = circuit_add(t44, t45); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t47 = circuit_mul(in22, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t48 = circuit_add(t46, t47); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t49 = circuit_mul(in23, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t50 = circuit_add(t48, t49); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t51 = circuit_mul(in24, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t52 = circuit_add(t50, t51); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t53 = circuit_mul(in25, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t54 = circuit_add(t52, t53); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t55 = circuit_mul(t32, t54);
    let t56 = circuit_mul(in49, t55);
    let t57 = circuit_mul(in49, in26);
    let t58 = circuit_mul(in49, in27);
    let t59 = circuit_mul(in49, in28);
    let t60 = circuit_mul(in49, in29);
    let t61 = circuit_mul(in49, in30);
    let t62 = circuit_mul(in49, in31);
    let t63 = circuit_mul(in49, in32);
    let t64 = circuit_mul(in49, in33);
    let t65 = circuit_mul(in49, in34);
    let t66 = circuit_mul(in49, in35);
    let t67 = circuit_mul(in49, in36);
    let t68 = circuit_mul(in49, in37);
    let t69 = circuit_mul(in39, in50); // Eval UnnamedPoly step coeff_1 * z^1
    let t70 = circuit_add(in38, t69); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t71 = circuit_mul(in40, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t72 = circuit_add(t70, t71); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t73 = circuit_mul(in41, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t74 = circuit_add(t72, t73); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t75 = circuit_mul(in42, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t76 = circuit_add(t74, t75); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t77 = circuit_mul(in43, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t78 = circuit_add(t76, t77); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t79 = circuit_mul(in44, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t80 = circuit_add(t78, t79); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t81 = circuit_mul(in45, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t82 = circuit_add(t80, t81); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t83 = circuit_mul(in46, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t84 = circuit_add(t82, t83); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t85 = circuit_mul(in47, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t86 = circuit_add(t84, t85); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t87 = circuit_mul(in48, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t88 = circuit_add(t86, t87); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t89 = circuit_mul(in1, t4); // Eval sparse poly UnnamedPoly step coeff_6 * z^6
    let t90 = circuit_add(in0, t89); // Eval sparse poly UnnamedPoly step + coeff_6 * z^6
    let t91 = circuit_add(t90, t10); // Eval sparse poly UnnamedPoly step + 1*z^12
    let t92 = circuit_mul(t58, in50); // Eval UnnamedPoly step coeff_1 * z^1
    let t93 = circuit_add(t57, t92); // Eval UnnamedPoly step + (coeff_1 * z^1)
    let t94 = circuit_mul(t59, t0); // Eval UnnamedPoly step coeff_2 * z^2
    let t95 = circuit_add(t93, t94); // Eval UnnamedPoly step + (coeff_2 * z^2)
    let t96 = circuit_mul(t60, t1); // Eval UnnamedPoly step coeff_3 * z^3
    let t97 = circuit_add(t95, t96); // Eval UnnamedPoly step + (coeff_3 * z^3)
    let t98 = circuit_mul(t61, t2); // Eval UnnamedPoly step coeff_4 * z^4
    let t99 = circuit_add(t97, t98); // Eval UnnamedPoly step + (coeff_4 * z^4)
    let t100 = circuit_mul(t62, t3); // Eval UnnamedPoly step coeff_5 * z^5
    let t101 = circuit_add(t99, t100); // Eval UnnamedPoly step + (coeff_5 * z^5)
    let t102 = circuit_mul(t63, t4); // Eval UnnamedPoly step coeff_6 * z^6
    let t103 = circuit_add(t101, t102); // Eval UnnamedPoly step + (coeff_6 * z^6)
    let t104 = circuit_mul(t64, t5); // Eval UnnamedPoly step coeff_7 * z^7
    let t105 = circuit_add(t103, t104); // Eval UnnamedPoly step + (coeff_7 * z^7)
    let t106 = circuit_mul(t65, t6); // Eval UnnamedPoly step coeff_8 * z^8
    let t107 = circuit_add(t105, t106); // Eval UnnamedPoly step + (coeff_8 * z^8)
    let t108 = circuit_mul(t66, t7); // Eval UnnamedPoly step coeff_9 * z^9
    let t109 = circuit_add(t107, t108); // Eval UnnamedPoly step + (coeff_9 * z^9)
    let t110 = circuit_mul(t67, t8); // Eval UnnamedPoly step coeff_10 * z^10
    let t111 = circuit_add(t109, t110); // Eval UnnamedPoly step + (coeff_10 * z^10)
    let t112 = circuit_mul(t68, t9); // Eval UnnamedPoly step coeff_11 * z^11
    let t113 = circuit_add(t111, t112); // Eval UnnamedPoly step + (coeff_11 * z^11)
    let t114 = circuit_mul(t88, t91);
    let t115 = circuit_add(t114, t113);
    let t116 = circuit_sub(t115, t56);

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t116,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next([0x52, 0x0, 0x0, 0x0]);
    circuit_inputs = circuit_inputs
        .next([0x6871ca8d3c208c16d87cfd35, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]);

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t116)];
    return res;
}

=======
    >::try_into([0x6871ca8d3c208c16d87cfd47, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0])
        .unwrap(); // BN254 prime field modulus

    let mut circuit_inputs = (t81,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x52, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs
        .next_2(
            [0x6871ca8d3c208c16d87cfd35, 0xb85045b68181585d97816a91, 0x30644e72e131a029, 0x0]
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
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411

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
<<<<<<< HEAD
        MillerLoopResultScalingFactor
    };

    use super::{
        run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit, run_BLS12_381_FP12_MUL_circuit,
        run_BN254_FP12_MUL_ASSERT_ONE_circuit, run_BN254_FP12_MUL_circuit
    };

    #[test]
    fn test_run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit_BLS12_381() {
        let X: E12D = E12D {
            w0: u384 {
                limb0: 71029029285038535328301142941,
                limb1: 51725320338008152483723565975,
                limb2: 73911455883094295412141261626,
                limb3: 3867164482506304348186712195
            },
            w1: u384 {
                limb0: 55464086965603394220937522799,
                limb1: 31004385889608404247826647971,
                limb2: 40832848433225188251344281518,
                limb3: 7635521334383696381787612377
            },
            w2: u384 {
                limb0: 34548047606004572950120704827,
                limb1: 57659675347788322849285395323,
                limb2: 62224349506316350971693464899,
                limb3: 2236678833840831745691356571
            },
            w3: u384 {
                limb0: 54020592794423544965142549071,
                limb1: 4372972263229517496662238226,
                limb2: 75965854791756086351574637739,
                limb3: 3618304243774044701240765242
            },
            w4: u384 {
                limb0: 76132363328362933367246505164,
                limb1: 66645271661799032816669711093,
                limb2: 60729027616931253880269499568,
                limb3: 2011607713306819550745639738
            },
            w5: u384 {
                limb0: 3116136987019992062869560190,
                limb1: 52348747740995785708738113000,
                limb2: 55133474293768395616260822339,
                limb3: 1057379248098252027861002035
            },
            w6: u384 {
                limb0: 28463598373936524886581190286,
                limb1: 70133890718351129300135804702,
                limb2: 58258384046545676126660762566,
                limb3: 353538770283163018453892822
            },
            w7: u384 {
                limb0: 57023601030769823013827151429,
                limb1: 18894738741295778481120149032,
                limb2: 4990790043678587988438046768,
                limb3: 6372000652768851214212330562
            },
            w8: u384 {
                limb0: 42303088661821409746372490097,
                limb1: 64315685935980079435483658002,
                limb2: 78898068543092828759474425123,
                limb3: 3360116953454601624664407328
            },
            w9: u384 {
                limb0: 62414245446145425238212056490,
                limb1: 32127642246835655563386568184,
                limb2: 63945343353534451009783431867,
                limb3: 5180726008387910658668279196
            },
            w10: u384 {
                limb0: 53722859847507397517199786636,
                limb1: 42510773771855106263438683587,
                limb2: 45900496196881014460290028333,
                limb3: 713385010770818366777389754
            },
            w11: u384 {
                limb0: 11217953222531294174764912797,
                limb1: 1510326924841615377987810337,
                limb2: 72732964440908167458194577800,
                limb3: 2403411547259994768396886548
            }
        };

        let Y: E12D = E12D {
            w0: u384 {
                limb0: 10342265047551032619057033226,
                limb1: 50124604767079605388933165102,
                limb2: 24349772199378442733977472005,
                limb3: 963535678478737866544117555
            },
            w1: u384 {
                limb0: 13523406597324953546234823521,
                limb1: 5067244053962917478577841029,
                limb2: 8424425580526610544689109559,
                limb3: 5892370825357558614652018993
            },
            w2: u384 {
                limb0: 17475556066150465692331589443,
                limb1: 16054885387459224409876200439,
                limb2: 64295319946593133471433765334,
                limb3: 7308088934630676479019402967
            },
            w3: u384 {
                limb0: 60548371115851383859269121541,
                limb1: 13741938846798337531701858131,
                limb2: 9566443606626428228856943253,
                limb3: 7502412695021128801671045143
            },
            w4: u384 {
                limb0: 55166235635043133805092638175,
                limb1: 13073132143403500775970934517,
                limb2: 73339571126837961266935110114,
                limb3: 1320841220536407241145517460
            },
            w5: u384 {
                limb0: 67135307236062755756545900078,
                limb1: 29800172027123290510840005017,
                limb2: 1238361513404017870432949577,
                limb3: 799437993886640975704439585
            },
            w6: u384 {
                limb0: 14214550930860201660722978887,
                limb1: 55993810344993093729499172829,
                limb2: 70268656884556458862703114145,
                limb3: 6868126275059647322836345202
            },
            w7: u384 {
                limb0: 61208724092214516655378827826,
                limb1: 10053453470637550528106329095,
                limb2: 50692215121526672291403328155,
                limb3: 4460735030049386998099932776
            },
            w8: u384 {
                limb0: 74323116453506673577333285524,
                limb1: 54800026102147583691166006575,
                limb2: 14261106391697589298440276788,
                limb3: 6061447797076441252658566763
            },
            w9: u384 {
                limb0: 49691241918702875942653967335,
                limb1: 23863503866939148387560484295,
                limb2: 362076205285380942585458279,
                limb3: 1900513941960699393836719077
            },
            w10: u384 {
                limb0: 42006693876405215659581308420,
                limb1: 49035969002012381740373311908,
                limb2: 60302791431760153799282757719,
                limb3: 5026440187166584576604487888
            },
            w11: u384 {
                limb0: 61031931745339693587765558029,
                limb1: 16488070294311780794698298854,
                limb2: 15347999924141323732138583191,
                limb3: 1477777684450895756770445794
            }
        };

        let Q: E12DMulQuotient = E12DMulQuotient {
            w0: u384 {
                limb0: 76738325331097784098604458616,
                limb1: 39417186659492356989027551786,
                limb2: 53094169080319585762352008913,
                limb3: 535063529279238856852655344
            },
            w1: u384 {
                limb0: 22585138241466902975054453122,
                limb1: 19916516860679998441664261275,
                limb2: 63790846234686982641901917483,
                limb3: 4487756784340157775933620637
            },
            w2: u384 {
                limb0: 58661869304581898856455133892,
                limb1: 42574096519912998584804297538,
                limb2: 62233089377122619708039166050,
                limb3: 5099359427611870068309283215
            },
            w3: u384 {
                limb0: 70915478360605433910852481281,
                limb1: 35242341865846906270953282568,
                limb2: 25826187497304245333665750975,
                limb3: 7398788812224297161839865185
            },
            w4: u384 {
                limb0: 25803420863687201551154558281,
                limb1: 8725624939389234135888653453,
                limb2: 7769441528829129652241786566,
                limb3: 4086147442961509392265234938
            },
            w5: u384 {
                limb0: 29752741105515908274421030525,
                limb1: 5825624154518746837927625130,
                limb2: 38378733309776841093529391429,
                limb3: 4316598524314752177287016219
            },
            w6: u384 {
                limb0: 73514791122030279584214867726,
                limb1: 14107427283636357602792953436,
                limb2: 10807087021979156256370725950,
                limb3: 1922817208175532140301022739
            },
            w7: u384 {
                limb0: 77291500896980713022023279320,
                limb1: 26612053689119475219298956141,
                limb2: 54842568267807880625876169566,
                limb3: 2778968976132832092048594321
            },
            w8: u384 {
                limb0: 67474773117741811493881627435,
                limb1: 33135105537387115517972398445,
                limb2: 27220895700244848961553422705,
                limb3: 2923138043952362602799583926
            },
            w9: u384 {
                limb0: 62554355123322281670832808791,
                limb1: 75485435419429754335494972238,
                limb2: 13463676008550633729025710814,
                limb3: 5474226680247745772947227743
            },
            w10: u384 {
                limb0: 6851202343162025005316934440,
                limb1: 41338781875332116018559773462,
                limb2: 78884656005785174486630078154,
                limb3: 4689207862567338777032312923
            }
        };

        let z: u384 = u384 {
            limb0: 22118195736760409498012936622,
            limb1: 33918397682506047102484121175,
            limb2: 19541957279868152243375454112,
            limb3: 4300591001267578104706097582
        };

        let (check_result) = run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit(X, Y, Q, z);
        let check: u384 = u384 {
            limb0: 28266221504594817035365447594,
            limb1: 27464814037690403238365721240,
            limb2: 17672694422257258854517063532,
            limb3: 5176855091393523583744364111
        };
        assert_eq!(check_result, check);
    }


    #[test]
    fn test_run_BLS12_381_FP12_MUL_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 31481706122096549464913901405,
                limb1: 67868759843779350247177940085,
                limb2: 36298951532418126956287301854,
                limb3: 122445131395547102836367213
            },
            u384 {
                limb0: 49363734691025808346622681592,
                limb1: 61931518654422335291235459818,
                limb2: 32835509912913724709832130657,
                limb3: 5611274462785060862788826525
            },
            u384 {
                limb0: 60084846668691309517372316159,
                limb1: 7938978354065306655951631649,
                limb2: 44580400306068298829136402342,
                limb3: 7781647792384042784670105029
            },
            u384 {
                limb0: 42437256044111696706190270870,
                limb1: 69553893877560558565201056805,
                limb2: 30347830340399582238940862186,
                limb3: 5665043739611039930416900669
            },
            u384 {
                limb0: 2968336193316344014976643487,
                limb1: 31926886704307061432180361220,
                limb2: 48222637916789365455698757457,
                limb3: 3978441220039978176360333433
            },
            u384 {
                limb0: 70479330135208240068164429557,
                limb1: 54708136242387862249369984540,
                limb2: 59084388121203733450468753215,
                limb3: 2659930602984709324473361979
            },
            u384 {
                limb0: 7781582870615248658587257332,
                limb1: 18060647040107088382910630438,
                limb2: 77185614555783836617429948131,
                limb3: 7665630709639008690534394922
            },
            u384 {
                limb0: 58703695236318437153595959611,
                limb1: 40921457806600222017082202009,
                limb2: 65047699476382581548940007594,
                limb3: 7838541229651537177851691326
            },
            u384 {
                limb0: 24649711132791196136131160859,
                limb1: 31959463879970389990593419036,
                limb2: 67446565494304065918737183308,
                limb3: 5631857740691152141712596740
            },
            u384 {
                limb0: 15272293677032018409538790787,
                limb1: 15903213564985846642707780916,
                limb2: 19766655320402504719997868701,
                limb3: 500714869335157671806326788
            },
            u384 {
                limb0: 2421465682553396439589200302,
                limb1: 38725675093600391949462775738,
                limb2: 14069629701951197615903423905,
                limb3: 4700035313273406223527750081
            },
            u384 {
                limb0: 27710834356798301570745616575,
                limb1: 66365768534034441518580806642,
                limb2: 59338814344640457861156924468,
                limb3: 895198274277565377987995855
            },
            u384 {
                limb0: 30626887791993392103379586712,
                limb1: 67646694486068026383923539548,
                limb2: 76448649319326805723591966979,
                limb3: 2192154911194849472310777129
            },
            u384 {
                limb0: 704970819134024183709672830,
                limb1: 10483002088231165148734058283,
                limb2: 47627371899731550128433669234,
                limb3: 2216111036432550975662029282
            },
            u384 {
                limb0: 27627588965592301460380496363,
                limb1: 17288302570054643574378652905,
                limb2: 53653006904319436309055243647,
                limb3: 6175895627598679785198880379
            },
            u384 {
                limb0: 8106000001404022517624719871,
                limb1: 79182953298664484961752549336,
                limb2: 66811837476094140901479161969,
                limb3: 5560401943914382348729286921
            },
            u384 {
                limb0: 48253920679701385420901725843,
                limb1: 54224795299195489880085725980,
                limb2: 5057692327865246571366759693,
                limb3: 2738157490462795058984169342
            },
            u384 {
                limb0: 68254396481106596829350200441,
                limb1: 51983150611125032858337537600,
                limb2: 70701135991376745614962998732,
                limb3: 1865427922302805324228624816
            },
            u384 {
                limb0: 60647129510547984252479325222,
                limb1: 4498152892290892512780120009,
                limb2: 63569805250568050666655229469,
                limb3: 4001996991071955534537953035
            },
            u384 {
                limb0: 30762308298674705845589581567,
                limb1: 46191896762110535052809632152,
                limb2: 45321870723840521366311010763,
                limb3: 3398561834045363305438402277
            },
            u384 {
                limb0: 17617427117379033275285056553,
                limb1: 50572412767809481294543489853,
                limb2: 71822429050293948548360635255,
                limb3: 3550383619517082565340011891
            },
            u384 {
                limb0: 66981013715848115191440958196,
                limb1: 52101602828662489289142320883,
                limb2: 14351061200601853379016259167,
                limb3: 4662387984672337729785523866
            },
            u384 {
                limb0: 20643629126958689685053977386,
                limb1: 36742902326561821771793167892,
                limb2: 37279748083972798427848845144,
                limb3: 6282761029441618838917334490
            },
            u384 {
                limb0: 74815231909794712396130231675,
                limb1: 37413097640667786778752793087,
                limb2: 39651902859902868225373859126,
                limb3: 6741304143114206993439277529
            }
        ];
        let got = run_BLS12_381_FP12_MUL_circuit(input);
        let exp = array![
            u384 {
                limb0: 21448829438051705008495457586,
                limb1: 57801949056943885331418910824,
                limb2: 64420422200751530183481188004,
                limb3: 4746202111627640384510408933
            },
            u384 {
                limb0: 75713094439827553950299913705,
                limb1: 50544351001940742158281332967,
                limb2: 16563864662501399819357615492,
                limb3: 2343832696756384558814504823
            },
            u384 {
                limb0: 38486379899022802582930291757,
                limb1: 22122506976201516734682403778,
                limb2: 16360761498551330164648085039,
                limb3: 1784580662868681574407670154
            },
            u384 {
                limb0: 52534847248357128201893874109,
                limb1: 9507460543240051569308928972,
                limb2: 44415194869720260297351656175,
                limb3: 4792690276895686225250036746
            },
            u384 {
                limb0: 6871772335871622498462644239,
                limb1: 10820204534046793999690617134,
                limb2: 23650836244557532970681920705,
                limb3: 4377810984112299838038383117
            },
            u384 {
                limb0: 44409745992696063320004102203,
                limb1: 43135367713761470605773198955,
                limb2: 47831834609263324548637867081,
                limb3: 3600538276226193125853478991
            },
            u384 {
                limb0: 19545994933887640300541817987,
                limb1: 76607128326895103535946946559,
                limb2: 17934161436863045508172693141,
                limb3: 5270868536712996673897317218
            },
            u384 {
                limb0: 23523704909657058080290425644,
                limb1: 18537937209798287492168040158,
                limb2: 18747782112827204116580348889,
                limb3: 5464130976857698063665883981
            },
            u384 {
                limb0: 63897128130005262302055601080,
                limb1: 9591404062633591070122883634,
                limb2: 23874060901549460051868044456,
                limb3: 2017388381249884752017711554
            },
            u384 {
                limb0: 33541731023335788901843471202,
                limb1: 8330312856367057720459799777,
                limb2: 73555582291023014739080758649,
                limb3: 99519497114503922571904843
            },
            u384 {
                limb0: 51802679130477516547168214393,
                limb1: 28939374425596397379535729688,
                limb2: 15496736095748895048816664404,
                limb3: 1025430698042901768881101985
            },
            u384 {
                limb0: 50582671329603822972137924349,
                limb1: 19796100204509190560283220892,
                limb2: 34861112956119535204499684621,
                limb3: 6787638201682964124680955574
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_BN254_FP12_MUL_ASSERT_ONE_circuit_BN254() {
        let X: E12D = E12D {
            w0: u384 {
                limb0: 36232733333819267831187881540,
                limb1: 61207529572384806113351989225,
                limb2: 2284229624673291714,
                limb3: 0
            },
            w1: u384 {
                limb0: 8969499376599097893218605797,
                limb1: 21224345759731257053133235063,
                limb2: 2504635170111213235,
                limb3: 0
            },
            w2: u384 {
                limb0: 43286565974349949823592896197,
                limb1: 33684224885911475634557836598,
                limb2: 3394148779991496381,
                limb3: 0
            },
            w3: u384 {
                limb0: 59527722920086956476939076529,
                limb1: 69309576269972711353767312268,
                limb2: 148636478670566545,
                limb3: 0
            },
            w4: u384 {
                limb0: 61451870023105400256060457677,
                limb1: 16628261520090209209766376377,
                limb2: 3401639472285759118,
                limb3: 0
            },
            w5: u384 {
                limb0: 27779837117219349798710292002,
                limb1: 48349921116687246466292232191,
                limb2: 1974572064131858823,
                limb3: 0
            },
            w6: u384 {
                limb0: 27794465715114939498189951795,
                limb1: 47287937754346425484707073506,
                limb2: 776503542237936721,
                limb3: 0
            },
            w7: u384 {
                limb0: 78078427233016903726119976440,
                limb1: 64585285632714581698908558240,
                limb2: 625293452831141160,
                limb3: 0
            },
            w8: u384 {
                limb0: 62248857904685867220612954546,
                limb1: 4697111671249175294339079849,
                limb2: 1278929067580822477,
                limb3: 0
            },
            w9: u384 {
                limb0: 10053116060569092063157998764,
                limb1: 10512852830014012631465111641,
                limb2: 674428845728389386,
                limb3: 0
            },
            w10: u384 {
                limb0: 65639091059276963372207044870,
                limb1: 66833364416817988916805091151,
                limb2: 1811012549976372535,
                limb3: 0
            },
            w11: u384 {
                limb0: 45748363673848459401462885085,
                limb1: 49740456341038515146350467234,
                limb2: 1730176986552903637,
                limb3: 0
            }
        };

        let Y: E12D = E12D {
            w0: u384 {
                limb0: 50201163309546882248555739861,
                limb1: 60917285496848173983672750279,
                limb2: 1857821278612033369,
                limb3: 0
            },
            w1: u384 {
                limb0: 22043310114576972898845539990,
                limb1: 69508242421211606256704821383,
                limb2: 2096913536410940104,
                limb3: 0
            },
            w2: u384 {
                limb0: 57910393905526210430607019328,
                limb1: 50297250063754204659308222327,
                limb2: 3215677824510022722,
                limb3: 0
            },
            w3: u384 {
                limb0: 16784602335539274389890340634,
                limb1: 25580012076337666166744261511,
                limb2: 1307842245546628046,
                limb3: 0
            },
            w4: u384 {
                limb0: 54077334749729967705748885977,
                limb1: 3639973854618842972547126374,
                limb2: 2887743342320138977,
                limb3: 0
            },
            w5: u384 {
                limb0: 36411818698197502009182846927,
                limb1: 73637258445497310788190929866,
                limb2: 728570381439274546,
                limb3: 0
            },
            w6: u384 {
                limb0: 21710058672518109474964576816,
                limb1: 28556633235768307693973217555,
                limb2: 380097610269688579,
                limb3: 0
            },
            w7: u384 {
                limb0: 71606434688571104041731434301,
                limb1: 4103010541947587870498687894,
                limb2: 2885090501209793552,
                limb3: 0
            },
            w8: u384 {
                limb0: 55415454367504549155731528320,
                limb1: 34007178513724874568324539649,
                limb2: 420582025281265987,
                limb3: 0
            },
            w9: u384 {
                limb0: 86066182370540470378270233,
                limb1: 6174942182774166670343849259,
                limb2: 2737863453576830214,
                limb3: 0
            },
            w10: u384 {
                limb0: 53873782153088072732807505137,
                limb1: 638782431691722587747903274,
                limb2: 1584456100392117998,
                limb3: 0
            },
            w11: u384 {
                limb0: 78289697287566290293728612021,
                limb1: 54986801116415714804033864416,
                limb2: 2203003535456877327,
                limb3: 0
            }
        };

        let Q: E12DMulQuotient = E12DMulQuotient {
            w0: u384 {
                limb0: 30349926683087214248120667615,
                limb1: 63854479497956248880689342153,
                limb2: 475933087515585238,
                limb3: 0
            },
            w1: u384 {
                limb0: 10548930879994947288330859291,
                limb1: 53648326885857135644920141196,
                limb2: 315492849180345543,
                limb3: 0
            },
            w2: u384 {
                limb0: 671437938181734446603920381,
                limb1: 13002652799230472914944778672,
                limb2: 1619567495594269453,
                limb3: 0
            },
            w3: u384 {
                limb0: 49761627243910020748324982332,
                limb1: 72881521037612513657669716986,
                limb2: 2841149120367153617,
                limb3: 0
            },
            w4: u384 {
                limb0: 68133250682852055712931171580,
                limb1: 71035411712167048865556289785,
                limb2: 645696621978850556,
                limb3: 0
            },
            w5: u384 {
                limb0: 46710857834164914215498827578,
                limb1: 27851522634801178442987594039,
                limb2: 1980206079096092577,
                limb3: 0
            },
            w6: u384 {
                limb0: 11078488847043997400530374639,
                limb1: 51072103608314502015173455261,
                limb2: 1144468390854873842,
                limb3: 0
            },
            w7: u384 {
                limb0: 67176933111624304288558418521,
                limb1: 69390179140389019312130200760,
                limb2: 947451150930076693,
                limb3: 0
            },
            w8: u384 {
                limb0: 40368537015381881859003331824,
                limb1: 31037713268746269798580298608,
                limb2: 2979932114636022986,
                limb3: 0
            },
            w9: u384 {
                limb0: 71139962115052159171680550418,
                limb1: 18962553627762909824947652986,
                limb2: 1779583125281633834,
                limb3: 0
            },
            w10: u384 {
                limb0: 78188889610784037067589048559,
                limb1: 25073546934847101430326685335,
                limb2: 1783976531669393757,
                limb3: 0
            }
        };

        let z: u384 = u384 {
            limb0: 45031733892261894151632473720,
            limb1: 43286799582515793146102527599,
            limb2: 796762439735921222,
            limb3: 0
        };

        let (check_result) = run_BN254_FP12_MUL_ASSERT_ONE_circuit(X, Y, Q, z);
        let check: u384 = u384 {
            limb0: 69352195828274006668473688617,
            limb1: 41678845886887377055287214226,
            limb2: 2472458301078632122,
            limb3: 0
        };
        assert_eq!(check_result, check);
    }


    #[test]
    fn test_run_BN254_FP12_MUL_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 24179711637078154872698072788,
                limb1: 69033323171013648726746901527,
                limb2: 1028053427466515130,
                limb3: 0
            },
            u384 {
                limb0: 15301318457210954370086002523,
                limb1: 22073208276000943622353706448,
                limb2: 320146711337384969,
                limb3: 0
            },
            u384 {
                limb0: 22114560534868413469990194000,
                limb1: 40359275625242915973686933105,
                limb2: 3133724186599576222,
                limb3: 0
            },
            u384 {
                limb0: 14147600119690206055886498978,
                limb1: 77924904970046305529730533213,
                limb2: 176430179553745541,
                limb3: 0
            },
            u384 {
                limb0: 34429688114677249373942859004,
                limb1: 62307259392135261750940332868,
                limb2: 2012511570471233567,
                limb3: 0
            },
            u384 {
                limb0: 40519109474734117827222995157,
                limb1: 71266106994207255293368923737,
                limb2: 876583633381180973,
                limb3: 0
            },
            u384 {
                limb0: 56999116716456660037505908076,
                limb1: 58394141795252174366841312619,
                limb2: 908664166153080643,
                limb3: 0
            },
            u384 {
                limb0: 5543896111964588329291062870,
                limb1: 72950982944412260385931489325,
                limb2: 2873797086284348751,
                limb3: 0
            },
            u384 {
                limb0: 67186692668466921528645961350,
                limb1: 71309057108007916549270106582,
                limb2: 2338689782217042832,
                limb3: 0
            },
            u384 {
                limb0: 32356219940895644890465912726,
                limb1: 55238541489685791664213375236,
                limb2: 2556776294363696928,
                limb3: 0
            },
            u384 {
                limb0: 33311190625122701884446338806,
                limb1: 30038983821758303538297491617,
                limb2: 3450161675760874860,
                limb3: 0
            },
            u384 {
                limb0: 22731646690559464945584085643,
                limb1: 62254228244041056092578285633,
                limb2: 2797732666789192166,
                limb3: 0
            },
            u384 {
                limb0: 36840159815284822828872550826,
                limb1: 53528704665659692542594704228,
                limb2: 2357373971914367642,
                limb3: 0
            },
            u384 {
                limb0: 71398900445303871977830922946,
                limb1: 58308873271295456045776211143,
                limb2: 3038412792524760357,
                limb3: 0
            },
            u384 {
                limb0: 40838315389252462131274918152,
                limb1: 49062895761140906196185797430,
                limb2: 430672426797295067,
                limb3: 0
            },
            u384 {
                limb0: 1935178840434513892301483496,
                limb1: 77955442914431956726435850640,
                limb2: 2819003629311265027,
                limb3: 0
            },
            u384 {
                limb0: 5770046817954911365433419997,
                limb1: 70206999211031843174167750500,
                limb2: 2654813442635484636,
                limb3: 0
            },
            u384 {
                limb0: 55170867641077938500934205932,
                limb1: 31663761889710221522616740278,
                limb2: 680552691678954420,
                limb3: 0
            },
            u384 {
                limb0: 33683551981682337331343347221,
                limb1: 63708146281584045824133167367,
                limb2: 3209326608523281200,
                limb3: 0
            },
            u384 {
                limb0: 3978710132448725972414947603,
                limb1: 72689463003301296553109628281,
                limb2: 559667764532122151,
                limb3: 0
            },
            u384 {
                limb0: 63494764767764911070010584767,
                limb1: 42080603038047810901012306942,
                limb2: 2577587956506592516,
                limb3: 0
            },
            u384 {
                limb0: 39992646296251654083222591112,
                limb1: 71848434114489718999273628124,
                limb2: 2056413546060797467,
                limb3: 0
            },
            u384 {
                limb0: 58918454144710925140404170297,
                limb1: 35658200186838653936236949040,
                limb2: 3466958500785709215,
                limb3: 0
            },
            u384 {
                limb0: 50520744070478778258648930928,
                limb1: 61613748404667949331712434274,
                limb2: 2234809294668425107,
                limb3: 0
            }
        ];
        let got = run_BN254_FP12_MUL_circuit(input);
        let exp = array![
            u384 {
                limb0: 70773159131707667644855018196,
                limb1: 7253812458867194552267082414,
                limb2: 2171836549216372770,
                limb3: 0
            },
            u384 {
                limb0: 17231439283064386666377119449,
                limb1: 43092515804295764836028014389,
                limb2: 2003106786073840848,
                limb3: 0
            },
            u384 {
                limb0: 43854703349027848737917815111,
                limb1: 53215411737743561424052829617,
                limb2: 3441945717517484241,
                limb3: 0
            },
            u384 {
                limb0: 67778832540775784342998288871,
                limb1: 49496667918005887595302450393,
                limb2: 2808915320566262546,
                limb3: 0
            },
            u384 {
                limb0: 43625608444910290343947208449,
                limb1: 41047802985053871868132256629,
                limb2: 3159702736010909197,
                limb3: 0
            },
            u384 {
                limb0: 67240480420936535263697774024,
                limb1: 38098186420091676301906266304,
                limb2: 3106853330008702245,
                limb3: 0
            },
            u384 {
                limb0: 12206276915900194701407578542,
                limb1: 45761794288690166103826102770,
                limb2: 986073357551576907,
                limb3: 0
            },
            u384 {
                limb0: 21692988428379961135741950639,
                limb1: 38447986245408464593651432235,
                limb2: 306197041157837579,
                limb3: 0
            },
            u384 {
                limb0: 57152108599251694963495472942,
                limb1: 34468289854105400115671745405,
                limb2: 1852783585180016969,
                limb3: 0
            },
            u384 {
                limb0: 43819573964426468505474703843,
                limb1: 67533849973158749802699245288,
                limb2: 3201099209362036192,
                limb3: 0
            },
            u384 {
                limb0: 67309836701450948781118811571,
                limb1: 73482588144277828186674696310,
                limb2: 1729131218028674879,
                limb3: 0
            },
            u384 {
                limb0: 30184641081192880425084568131,
                limb1: 13465532172817448083911447270,
                limb2: 2950537300086220252,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }
=======
        MillerLoopResultScalingFactor, G2Line
    };
    use garaga::ec_ops::{SlopeInterceptOutput, FunctionFeltEvaluations, FunctionFelt};

    use super::{
        run_BLS12_381_EVAL_E12D_circuit, run_BLS12_381_FP12_MUL_ASSERT_ONE_circuit,
        run_BN254_EVAL_E12D_circuit, run_BN254_FP12_MUL_ASSERT_ONE_circuit
    };
>>>>>>> a504e556e4f9731d65815eff327cc8f5dd654411
}
