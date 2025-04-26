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
use garaga::ec_ops::{FunctionFelt, FunctionFeltEvaluations, SlopeInterceptOutput};

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
pub fn run_ACC_EVAL_POINT_CHALLENGE_SIGNED_circuit(
    acc: u384,
    m: u384,
    b: u384,
    xA: u384,
    p: G1Point,
    ep: u384,
    en: u384,
    sp: u384,
    sn: u384,
    curve_index: usize,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let (in7, in8, in9) = (CE::<CI<7>> {}, CE::<CI<8>> {}, CE::<CI<9>> {});
    let in10 = CE::<CI<10>> {};
    let t0 = circuit_sub(in4, in5);
    let t1 = circuit_mul(in2, in5);
    let t2 = circuit_add(t1, in3);
    let t3 = circuit_sub(in6, t2);
    let t4 = circuit_sub(in0, in6);
    let t5 = circuit_sub(t4, t2);
    let t6 = circuit_mul(in9, in7);
    let t7 = circuit_inverse(t3);
    let t8 = circuit_mul(t0, t7);
    let t9 = circuit_mul(t6, t8);
    let t10 = circuit_mul(in10, in8);
    let t11 = circuit_inverse(t5);
    let t12 = circuit_mul(t0, t11);
    let t13 = circuit_mul(t10, t12);
    let t14 = circuit_add(t9, t13);
    let t15 = circuit_add(in1, t14);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t15,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(acc); // in1
    circuit_inputs = circuit_inputs.next_2(m); // in2
    circuit_inputs = circuit_inputs.next_2(b); // in3
    circuit_inputs = circuit_inputs.next_2(xA); // in4
    circuit_inputs = circuit_inputs.next_2(p.x); // in5
    circuit_inputs = circuit_inputs.next_2(p.y); // in6
    circuit_inputs = circuit_inputs.next_2(ep); // in7
    circuit_inputs = circuit_inputs.next_2(en); // in8
    circuit_inputs = circuit_inputs.next_2(sp); // in9
    circuit_inputs = circuit_inputs.next_2(sn); // in10

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res_acc: u384 = outputs.get_output(t15);
    return (res_acc,);
}
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
pub fn run_FINALIZE_FN_CHALLENGE_DUPL_circuit(
    f_a0_accs: FunctionFeltEvaluations,
    f_a1_accs: FunctionFeltEvaluations,
    yA0: u384,
    yA2: u384,
    coeff_A0: u384,
    coeff_A2: u384,
    curve_index: usize,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let t0 = circuit_inverse(in1);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_inverse(in3);
    let t3 = circuit_mul(in2, t2);
    let t4 = circuit_mul(in8, t3);
    let t5 = circuit_add(t1, t4); // a(x0) + y0 b(x0)
    let t6 = circuit_inverse(in5);
    let t7 = circuit_mul(in4, t6);
    let t8 = circuit_inverse(in7);
    let t9 = circuit_mul(in6, t8);
    let t10 = circuit_mul(in9, t9);
    let t11 = circuit_add(t7, t10); // a(x2) + y2 b(x2)
    let t12 = circuit_mul(in10, t5);
    let t13 = circuit_mul(in11, t11);
    let t14 = circuit_sub(t12, t13);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t14,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.a_num); // in0
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.a_den); // in1
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.b_num); // in2
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.b_den); // in3
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.a_num); // in4
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.a_den); // in5
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.b_num); // in6
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.b_den); // in7
    circuit_inputs = circuit_inputs.next_2(yA0); // in8
    circuit_inputs = circuit_inputs.next_2(yA2); // in9
    circuit_inputs = circuit_inputs.next_2(coeff_A0); // in10
    circuit_inputs = circuit_inputs.next_2(coeff_A2); // in11

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t14);
    return (res,);
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
pub fn run_RHS_FINALIZE_ACC_circuit(
    acc: u384, m: u384, b: u384, xA: u384, Q_result: G1Point, curve_index: usize,
) -> (u384,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x0

    // INPUT stack
    let (in1, in2, in3) = (CE::<CI<1>> {}, CE::<CI<2>> {}, CE::<CI<3>> {});
    let (in4, in5, in6) = (CE::<CI<4>> {}, CE::<CI<5>> {}, CE::<CI<6>> {});
    let t0 = circuit_sub(in4, in5);
    let t1 = circuit_mul(in2, in5);
    let t2 = circuit_add(t1, in3);
    let t3 = circuit_sub(in0, in6);
    let t4 = circuit_sub(t3, t2);
    let t5 = circuit_inverse(t4);
    let t6 = circuit_mul(t0, t5);
    let t7 = circuit_add(in1, t6);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t7,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in0
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(acc); // in1
    circuit_inputs = circuit_inputs.next_2(m); // in2
    circuit_inputs = circuit_inputs.next_2(b); // in3
    circuit_inputs = circuit_inputs.next_2(xA); // in4
    circuit_inputs = circuit_inputs.next_2(Q_result.x); // in5
    circuit_inputs = circuit_inputs.next_2(Q_result.y); // in6

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let rhs: u384 = outputs.get_output(t7);
    return (rhs,);
}
#[inline(always)]
pub fn run_SLOPE_INTERCEPT_SAME_POINT_circuit(
    p: G1Point, a: u384, curve_index: usize,
) -> (SlopeInterceptOutput,) {
    // CONSTANT stack
    let in0 = CE::<CI<0>> {}; // 0x3
    let in1 = CE::<CI<1>> {}; // 0x0

    // INPUT stack
    let (in2, in3, in4) = (CE::<CI<2>> {}, CE::<CI<3>> {}, CE::<CI<4>> {});
    let t0 = circuit_mul(in2, in2);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_add(t1, in4);
    let t3 = circuit_add(in3, in3);
    let t4 = circuit_inverse(t3);
    let t5 = circuit_mul(t2, t4);
    let t6 = circuit_mul(in2, t5);
    let t7 = circuit_sub(in3, t6);
    let t8 = circuit_mul(t5, t5);
    let t9 = circuit_add(in2, in2);
    let t10 = circuit_sub(t8, t9);
    let t11 = circuit_sub(in2, t10);
    let t12 = circuit_mul(t5, t11);
    let t13 = circuit_sub(t12, in3);
    let t14 = circuit_sub(in1, t13);
    let t15 = circuit_sub(t14, in3);
    let t16 = circuit_sub(t10, in2);
    let t17 = circuit_inverse(t16);
    let t18 = circuit_mul(t15, t17);
    let t19 = circuit_mul(t18, t14);
    let t20 = circuit_add(t14, t14);
    let t21 = circuit_sub(in2, t10);
    let t22 = circuit_mul(t20, t21);
    let t23 = circuit_mul(t10, t10);
    let t24 = circuit_mul(in0, t23);
    let t25 = circuit_add(t19, t19);
    let t26 = circuit_sub(in4, t25);
    let t27 = circuit_add(t24, t26);
    let t28 = circuit_inverse(t27);
    let t29 = circuit_mul(t22, t28);
    let t30 = circuit_add(t18, t18);
    let t31 = circuit_add(t29, t30);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t5, t7, t10, t14, t31, t29).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next_2([0x3, 0x0, 0x0, 0x0]); // in0
    circuit_inputs = circuit_inputs.next_2([0x0, 0x0, 0x0, 0x0]); // in1
    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(p.x); // in2
    circuit_inputs = circuit_inputs.next_2(p.y); // in3
    circuit_inputs = circuit_inputs.next_2(a); // in4

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let mb: SlopeInterceptOutput = SlopeInterceptOutput {
        m_A0: outputs.get_output(t5),
        b_A0: outputs.get_output(t7),
        x_A2: outputs.get_output(t10),
        y_A2: outputs.get_output(t14),
        coeff0: outputs.get_output(t31),
        coeff2: outputs.get_output(t29),
    };
    return (mb,);
}
#[inline]
pub fn run_ACC_FUNCTION_CHALLENGE_DUPL_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    f_a0_accs: FunctionFeltEvaluations,
    f_a1_accs: FunctionFeltEvaluations,
    xA0: u384,
    xA2: u384,
    xA0_power: u384,
    xA2_power: u384,
    next_a_num_coeff: T,
    next_a_den_coeff: T,
    next_b_num_coeff: T,
    next_b_den_coeff: T,
    curve_index: usize,
) -> (FunctionFeltEvaluations, FunctionFeltEvaluations, u384, u384) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let in15 = CE::<CI<15>> {};
    let t0 = circuit_mul(in12, in10);
    let t1 = circuit_add(in0, t0);
    let t2 = circuit_mul(in10, in8);
    let t3 = circuit_mul(in13, t2);
    let t4 = circuit_add(in1, t3);
    let t5 = circuit_mul(in14, t2);
    let t6 = circuit_add(in2, t5);
    let t7 = circuit_mul(t2, in8);
    let t8 = circuit_mul(t7, in8);
    let t9 = circuit_mul(t8, in8);
    let t10 = circuit_mul(in15, t9);
    let t11 = circuit_add(in3, t10);
    let t12 = circuit_mul(in12, in11);
    let t13 = circuit_add(in4, t12);
    let t14 = circuit_mul(in11, in9);
    let t15 = circuit_mul(in13, t14);
    let t16 = circuit_add(in5, t15);
    let t17 = circuit_mul(in14, t14);
    let t18 = circuit_add(in6, t17);
    let t19 = circuit_mul(t14, in9);
    let t20 = circuit_mul(t19, in9);
    let t21 = circuit_mul(t20, in9);
    let t22 = circuit_mul(in15, t21);
    let t23 = circuit_add(in7, t22);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t1, t4, t6, t11, t13, t16, t18, t23, t2, t14).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.a_num); // in0
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.a_den); // in1
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.b_num); // in2
    circuit_inputs = circuit_inputs.next_2(f_a0_accs.b_den); // in3
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.a_num); // in4
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.a_den); // in5
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.b_num); // in6
    circuit_inputs = circuit_inputs.next_2(f_a1_accs.b_den); // in7
    circuit_inputs = circuit_inputs.next_2(xA0); // in8
    circuit_inputs = circuit_inputs.next_2(xA2); // in9
    circuit_inputs = circuit_inputs.next_2(xA0_power); // in10
    circuit_inputs = circuit_inputs.next_2(xA2_power); // in11
    circuit_inputs = circuit_inputs.next_2(next_a_num_coeff); // in12
    circuit_inputs = circuit_inputs.next_2(next_a_den_coeff); // in13
    circuit_inputs = circuit_inputs.next_2(next_b_num_coeff); // in14
    circuit_inputs = circuit_inputs.next_2(next_b_den_coeff); // in15

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let next_f_a0_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t1),
        a_den: outputs.get_output(t4),
        b_num: outputs.get_output(t6),
        b_den: outputs.get_output(t11),
    };
    let next_f_a1_accs: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t13),
        a_den: outputs.get_output(t16),
        b_num: outputs.get_output(t18),
        b_den: outputs.get_output(t23),
    };
    let next_xA0_power: u384 = outputs.get_output(t2);
    let next_xA2_power: u384 = outputs.get_output(t14);
    return (next_f_a0_accs, next_f_a1_accs, next_xA0_power, next_xA2_power);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_10P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let in63 = CE::<CI<63>> {};
    let t0 = circuit_mul(in18, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in17, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_11
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in16, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_10
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in15, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t7 = circuit_add(in14, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t9 = circuit_add(in13, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t11 = circuit_add(in12, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t13 = circuit_add(in11, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t15 = circuit_add(in10, t14); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t17 = circuit_add(in9, t16); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t19 = circuit_add(in8, t18); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t21 = circuit_add(in7, t20); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t23 = circuit_add(in6, t22); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t24 = circuit_mul(in32, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t25 = circuit_add(in31, t24); // Eval sumdlogdiv_a_den Horner step: add coefficient_12
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t27 = circuit_add(in30, t26); // Eval sumdlogdiv_a_den Horner step: add coefficient_11
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t29 = circuit_add(in29, t28); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t31 = circuit_add(in28, t30); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t33 = circuit_add(in27, t32); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t35 = circuit_add(in26, t34); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t37 = circuit_add(in25, t36); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t39 = circuit_add(in24, t38); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t41 = circuit_add(in23, t40); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t43 = circuit_add(in22, t42); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t45 = circuit_add(in21, t44); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t47 = circuit_add(in20, t46); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t49 = circuit_add(in19, t48); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t50 = circuit_inverse(t49);
    let t51 = circuit_mul(t23, t50);
    let t52 = circuit_mul(in46, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t53 = circuit_add(in45, t52); // Eval sumdlogdiv_b_num Horner step: add coefficient_12
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t55 = circuit_add(in44, t54); // Eval sumdlogdiv_b_num Horner step: add coefficient_11
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t57 = circuit_add(in43, t56); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t59 = circuit_add(in42, t58); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t61 = circuit_add(in41, t60); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t63 = circuit_add(in40, t62); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t65 = circuit_add(in39, t64); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t66 = circuit_mul(t65, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t67 = circuit_add(in38, t66); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t69 = circuit_add(in37, t68); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t70 = circuit_mul(t69, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t71 = circuit_add(in36, t70); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t72 = circuit_mul(t71, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t73 = circuit_add(in35, t72); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t74 = circuit_mul(t73, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t75 = circuit_add(in34, t74); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t76 = circuit_mul(t75, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t77 = circuit_add(in33, t76); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t78 = circuit_mul(in63, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t79 = circuit_add(in62, t78); // Eval sumdlogdiv_b_den Horner step: add coefficient_15
    let t80 = circuit_mul(t79, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t81 = circuit_add(in61, t80); // Eval sumdlogdiv_b_den Horner step: add coefficient_14
    let t82 = circuit_mul(t81, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t83 = circuit_add(in60, t82); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t84 = circuit_mul(t83, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t85 = circuit_add(in59, t84); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t86 = circuit_mul(t85, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t87 = circuit_add(in58, t86); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t88 = circuit_mul(t87, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t89 = circuit_add(in57, t88); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t90 = circuit_mul(t89, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t91 = circuit_add(in56, t90); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t92 = circuit_mul(t91, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t93 = circuit_add(in55, t92); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t94 = circuit_mul(t93, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t95 = circuit_add(in54, t94); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t96 = circuit_mul(t95, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t97 = circuit_add(in53, t96); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t98 = circuit_mul(t97, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t99 = circuit_add(in52, t98); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t100 = circuit_mul(t99, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t101 = circuit_add(in51, t100); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t102 = circuit_mul(t101, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t103 = circuit_add(in50, t102); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t104 = circuit_mul(t103, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t105 = circuit_add(in49, t104); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t106 = circuit_mul(t105, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t107 = circuit_add(in48, t106); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t108 = circuit_mul(t107, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t109 = circuit_add(in47, t108); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t110 = circuit_inverse(t109);
    let t111 = circuit_mul(t77, t110);
    let t112 = circuit_mul(in1, t111);
    let t113 = circuit_add(t51, t112);
    let t114 = circuit_mul(in4, t113);
    let t115 = circuit_mul(in18, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t116 = circuit_add(in17, t115); // Eval sumdlogdiv_a_num Horner step: add coefficient_11
    let t117 = circuit_mul(t116, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t118 = circuit_add(in16, t117); // Eval sumdlogdiv_a_num Horner step: add coefficient_10
    let t119 = circuit_mul(t118, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t120 = circuit_add(in15, t119); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t121 = circuit_mul(t120, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t122 = circuit_add(in14, t121); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t123 = circuit_mul(t122, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t124 = circuit_add(in13, t123); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t125 = circuit_mul(t124, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t126 = circuit_add(in12, t125); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t127 = circuit_mul(t126, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t128 = circuit_add(in11, t127); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t129 = circuit_mul(t128, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t130 = circuit_add(in10, t129); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t131 = circuit_mul(t130, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t132 = circuit_add(in9, t131); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t133 = circuit_mul(t132, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t134 = circuit_add(in8, t133); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t135 = circuit_mul(t134, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t136 = circuit_add(in7, t135); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t137 = circuit_mul(t136, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t138 = circuit_add(in6, t137); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t139 = circuit_mul(in32, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t140 = circuit_add(in31, t139); // Eval sumdlogdiv_a_den Horner step: add coefficient_12
    let t141 = circuit_mul(t140, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t142 = circuit_add(in30, t141); // Eval sumdlogdiv_a_den Horner step: add coefficient_11
    let t143 = circuit_mul(t142, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t144 = circuit_add(in29, t143); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t145 = circuit_mul(t144, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t146 = circuit_add(in28, t145); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t147 = circuit_mul(t146, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t148 = circuit_add(in27, t147); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t149 = circuit_mul(t148, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t150 = circuit_add(in26, t149); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t151 = circuit_mul(t150, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t152 = circuit_add(in25, t151); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t153 = circuit_mul(t152, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t154 = circuit_add(in24, t153); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t155 = circuit_mul(t154, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t156 = circuit_add(in23, t155); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t157 = circuit_mul(t156, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t158 = circuit_add(in22, t157); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t159 = circuit_mul(t158, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t160 = circuit_add(in21, t159); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t161 = circuit_mul(t160, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t162 = circuit_add(in20, t161); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t163 = circuit_mul(t162, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t164 = circuit_add(in19, t163); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t165 = circuit_inverse(t164);
    let t166 = circuit_mul(t138, t165);
    let t167 = circuit_mul(in46, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t168 = circuit_add(in45, t167); // Eval sumdlogdiv_b_num Horner step: add coefficient_12
    let t169 = circuit_mul(t168, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t170 = circuit_add(in44, t169); // Eval sumdlogdiv_b_num Horner step: add coefficient_11
    let t171 = circuit_mul(t170, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t172 = circuit_add(in43, t171); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t173 = circuit_mul(t172, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t174 = circuit_add(in42, t173); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t175 = circuit_mul(t174, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t176 = circuit_add(in41, t175); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t177 = circuit_mul(t176, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t178 = circuit_add(in40, t177); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t179 = circuit_mul(t178, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t180 = circuit_add(in39, t179); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t181 = circuit_mul(t180, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t182 = circuit_add(in38, t181); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t183 = circuit_mul(t182, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t184 = circuit_add(in37, t183); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t185 = circuit_mul(t184, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t186 = circuit_add(in36, t185); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t187 = circuit_mul(t186, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t188 = circuit_add(in35, t187); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t189 = circuit_mul(t188, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t190 = circuit_add(in34, t189); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t191 = circuit_mul(t190, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t192 = circuit_add(in33, t191); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t193 = circuit_mul(in63, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t194 = circuit_add(in62, t193); // Eval sumdlogdiv_b_den Horner step: add coefficient_15
    let t195 = circuit_mul(t194, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t196 = circuit_add(in61, t195); // Eval sumdlogdiv_b_den Horner step: add coefficient_14
    let t197 = circuit_mul(t196, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t198 = circuit_add(in60, t197); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t199 = circuit_mul(t198, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t200 = circuit_add(in59, t199); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t201 = circuit_mul(t200, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t202 = circuit_add(in58, t201); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t203 = circuit_mul(t202, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t204 = circuit_add(in57, t203); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t205 = circuit_mul(t204, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t206 = circuit_add(in56, t205); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t207 = circuit_mul(t206, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t208 = circuit_add(in55, t207); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t209 = circuit_mul(t208, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t210 = circuit_add(in54, t209); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t211 = circuit_mul(t210, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t212 = circuit_add(in53, t211); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t213 = circuit_mul(t212, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t214 = circuit_add(in52, t213); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t215 = circuit_mul(t214, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t216 = circuit_add(in51, t215); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t217 = circuit_mul(t216, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t218 = circuit_add(in50, t217); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t219 = circuit_mul(t218, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t220 = circuit_add(in49, t219); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t221 = circuit_mul(t220, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t222 = circuit_add(in48, t221); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t223 = circuit_mul(t222, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t224 = circuit_add(in47, t223); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t225 = circuit_inverse(t224);
    let t226 = circuit_mul(t192, t225);
    let t227 = circuit_mul(in3, t226);
    let t228 = circuit_add(t166, t227);
    let t229 = circuit_mul(in5, t228);
    let t230 = circuit_sub(t114, t229);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t230,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in63

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t230);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_1P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let in27 = CE::<CI<27>> {};
    let t0 = circuit_mul(in9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in8, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in7, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in6, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t6 = circuit_mul(in14, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t7 = circuit_add(in13, t6); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t9 = circuit_add(in12, t8); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t11 = circuit_add(in11, t10); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t13 = circuit_add(in10, t12); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t14 = circuit_inverse(t13);
    let t15 = circuit_mul(t5, t14);
    let t16 = circuit_mul(in19, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t17 = circuit_add(in18, t16); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t19 = circuit_add(in17, t18); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t21 = circuit_add(in16, t20); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t23 = circuit_add(in15, t22); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t24 = circuit_mul(in27, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t25 = circuit_add(in26, t24); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t27 = circuit_add(in25, t26); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t29 = circuit_add(in24, t28); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t31 = circuit_add(in23, t30); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t33 = circuit_add(in22, t32); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t35 = circuit_add(in21, t34); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t37 = circuit_add(in20, t36); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t38 = circuit_inverse(t37);
    let t39 = circuit_mul(t23, t38);
    let t40 = circuit_mul(in1, t39);
    let t41 = circuit_add(t15, t40);
    let t42 = circuit_mul(in4, t41);
    let t43 = circuit_mul(in9, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t44 = circuit_add(in8, t43); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t45 = circuit_mul(t44, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t46 = circuit_add(in7, t45); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t47 = circuit_mul(t46, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t48 = circuit_add(in6, t47); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t49 = circuit_mul(in14, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t50 = circuit_add(in13, t49); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t51 = circuit_mul(t50, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t52 = circuit_add(in12, t51); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t53 = circuit_mul(t52, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t54 = circuit_add(in11, t53); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t55 = circuit_mul(t54, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t56 = circuit_add(in10, t55); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t57 = circuit_inverse(t56);
    let t58 = circuit_mul(t48, t57);
    let t59 = circuit_mul(in19, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t60 = circuit_add(in18, t59); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t61 = circuit_mul(t60, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t62 = circuit_add(in17, t61); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t63 = circuit_mul(t62, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t64 = circuit_add(in16, t63); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t65 = circuit_mul(t64, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t66 = circuit_add(in15, t65); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t67 = circuit_mul(in27, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t68 = circuit_add(in26, t67); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t69 = circuit_mul(t68, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t70 = circuit_add(in25, t69); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t71 = circuit_mul(t70, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t72 = circuit_add(in24, t71); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t73 = circuit_mul(t72, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t74 = circuit_add(in23, t73); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t75 = circuit_mul(t74, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t76 = circuit_add(in22, t75); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t77 = circuit_mul(t76, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t78 = circuit_add(in21, t77); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t79 = circuit_mul(t78, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t80 = circuit_add(in20, t79); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t81 = circuit_inverse(t80);
    let t82 = circuit_mul(t66, t81);
    let t83 = circuit_mul(in3, t82);
    let t84 = circuit_add(t58, t83);
    let t85 = circuit_mul(in5, t84);
    let t86 = circuit_sub(t42, t85);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t86,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in27

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t86);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_1P_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19) = (CE::<CI<18>> {}, CE::<CI<19>> {});
    let t0 = circuit_mul(in7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in6, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t2 = circuit_mul(in10, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t3 = circuit_add(in9, t2); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t5 = circuit_add(in8, t4); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t6 = circuit_inverse(t5);
    let t7 = circuit_mul(t1, t6);
    let t8 = circuit_mul(in13, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t9 = circuit_add(in12, t8); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t11 = circuit_add(in11, t10); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t12 = circuit_mul(in19, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t13 = circuit_add(in18, t12); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t15 = circuit_add(in17, t14); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t17 = circuit_add(in16, t16); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t19 = circuit_add(in15, t18); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t21 = circuit_add(in14, t20); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t22 = circuit_inverse(t21);
    let t23 = circuit_mul(t11, t22);
    let t24 = circuit_mul(in1, t23);
    let t25 = circuit_add(t7, t24);
    let t26 = circuit_mul(in4, t25);
    let t27 = circuit_mul(in7, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t28 = circuit_add(in6, t27); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t29 = circuit_mul(in10, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t30 = circuit_add(in9, t29); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t31 = circuit_mul(t30, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t32 = circuit_add(in8, t31); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t33 = circuit_inverse(t32);
    let t34 = circuit_mul(t28, t33);
    let t35 = circuit_mul(in13, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t36 = circuit_add(in12, t35); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t37 = circuit_mul(t36, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t38 = circuit_add(in11, t37); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t39 = circuit_mul(in19, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t40 = circuit_add(in18, t39); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t41 = circuit_mul(t40, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t42 = circuit_add(in17, t41); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t43 = circuit_mul(t42, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t44 = circuit_add(in16, t43); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t45 = circuit_mul(t44, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t46 = circuit_add(in15, t45); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t47 = circuit_mul(t46, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t48 = circuit_add(in14, t47); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t49 = circuit_inverse(t48);
    let t50 = circuit_mul(t38, t49);
    let t51 = circuit_mul(in3, t50);
    let t52 = circuit_add(t34, t51);
    let t53 = circuit_mul(in5, t52);
    let t54 = circuit_sub(t26, t53);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t54,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDiv.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDiv.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDiv.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDiv.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in19

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t54);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_2P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let (in30, in31) = (CE::<CI<30>> {}, CE::<CI<31>> {});
    let t0 = circuit_mul(in10, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in9, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in8, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in7, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t7 = circuit_add(in6, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t8 = circuit_mul(in16, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t9 = circuit_add(in15, t8); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t11 = circuit_add(in14, t10); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t13 = circuit_add(in13, t12); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t15 = circuit_add(in12, t14); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t17 = circuit_add(in11, t16); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t18 = circuit_inverse(t17);
    let t19 = circuit_mul(t7, t18);
    let t20 = circuit_mul(in22, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t21 = circuit_add(in21, t20); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t23 = circuit_add(in20, t22); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t25 = circuit_add(in19, t24); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t27 = circuit_add(in18, t26); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t29 = circuit_add(in17, t28); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t30 = circuit_mul(in31, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t31 = circuit_add(in30, t30); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t33 = circuit_add(in29, t32); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t35 = circuit_add(in28, t34); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t37 = circuit_add(in27, t36); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t39 = circuit_add(in26, t38); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t41 = circuit_add(in25, t40); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t43 = circuit_add(in24, t42); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t45 = circuit_add(in23, t44); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t46 = circuit_inverse(t45);
    let t47 = circuit_mul(t29, t46);
    let t48 = circuit_mul(in1, t47);
    let t49 = circuit_add(t19, t48);
    let t50 = circuit_mul(in4, t49);
    let t51 = circuit_mul(in10, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t52 = circuit_add(in9, t51); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t53 = circuit_mul(t52, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t54 = circuit_add(in8, t53); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t55 = circuit_mul(t54, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t56 = circuit_add(in7, t55); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t57 = circuit_mul(t56, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t58 = circuit_add(in6, t57); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t59 = circuit_mul(in16, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t60 = circuit_add(in15, t59); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t61 = circuit_mul(t60, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t62 = circuit_add(in14, t61); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t63 = circuit_mul(t62, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t64 = circuit_add(in13, t63); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t65 = circuit_mul(t64, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t66 = circuit_add(in12, t65); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t67 = circuit_mul(t66, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t68 = circuit_add(in11, t67); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t69 = circuit_inverse(t68);
    let t70 = circuit_mul(t58, t69);
    let t71 = circuit_mul(in22, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t72 = circuit_add(in21, t71); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t73 = circuit_mul(t72, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t74 = circuit_add(in20, t73); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t75 = circuit_mul(t74, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t76 = circuit_add(in19, t75); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t77 = circuit_mul(t76, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t78 = circuit_add(in18, t77); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t79 = circuit_mul(t78, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t80 = circuit_add(in17, t79); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t81 = circuit_mul(in31, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t82 = circuit_add(in30, t81); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t83 = circuit_mul(t82, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t84 = circuit_add(in29, t83); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t85 = circuit_mul(t84, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t86 = circuit_add(in28, t85); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t87 = circuit_mul(t86, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t88 = circuit_add(in27, t87); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t89 = circuit_mul(t88, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t90 = circuit_add(in26, t89); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t91 = circuit_mul(t90, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t92 = circuit_add(in25, t91); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t93 = circuit_mul(t92, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t94 = circuit_add(in24, t93); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t95 = circuit_mul(t94, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t96 = circuit_add(in23, t95); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t97 = circuit_inverse(t96);
    let t98 = circuit_mul(t80, t97);
    let t99 = circuit_mul(in3, t98);
    let t100 = circuit_add(t70, t99);
    let t101 = circuit_mul(in5, t100);
    let t102 = circuit_sub(t50, t101);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t102,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in31

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t102);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_2P_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDiv: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
    // INPUT stack
    let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
    let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
    let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
    let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
    let (in12, in13, in14) = (CE::<CI<12>> {}, CE::<CI<13>> {}, CE::<CI<14>> {});
    let (in15, in16, in17) = (CE::<CI<15>> {}, CE::<CI<16>> {}, CE::<CI<17>> {});
    let (in18, in19, in20) = (CE::<CI<18>> {}, CE::<CI<19>> {}, CE::<CI<20>> {});
    let (in21, in22, in23) = (CE::<CI<21>> {}, CE::<CI<22>> {}, CE::<CI<23>> {});
    let t0 = circuit_mul(in8, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in7, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in6, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t4 = circuit_mul(in12, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t5 = circuit_add(in11, t4); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t7 = circuit_add(in10, t6); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t9 = circuit_add(in9, t8); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t10 = circuit_inverse(t9);
    let t11 = circuit_mul(t3, t10);
    let t12 = circuit_mul(in16, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t13 = circuit_add(in15, t12); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t15 = circuit_add(in14, t14); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t17 = circuit_add(in13, t16); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t18 = circuit_mul(in23, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t19 = circuit_add(in22, t18); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t21 = circuit_add(in21, t20); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t23 = circuit_add(in20, t22); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t25 = circuit_add(in19, t24); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t27 = circuit_add(in18, t26); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t29 = circuit_add(in17, t28); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t30 = circuit_inverse(t29);
    let t31 = circuit_mul(t17, t30);
    let t32 = circuit_mul(in1, t31);
    let t33 = circuit_add(t11, t32);
    let t34 = circuit_mul(in4, t33);
    let t35 = circuit_mul(in8, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t36 = circuit_add(in7, t35); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t37 = circuit_mul(t36, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t38 = circuit_add(in6, t37); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t39 = circuit_mul(in12, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t40 = circuit_add(in11, t39); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t41 = circuit_mul(t40, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t42 = circuit_add(in10, t41); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t43 = circuit_mul(t42, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t44 = circuit_add(in9, t43); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t45 = circuit_inverse(t44);
    let t46 = circuit_mul(t38, t45);
    let t47 = circuit_mul(in16, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t48 = circuit_add(in15, t47); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t49 = circuit_mul(t48, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t50 = circuit_add(in14, t49); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t51 = circuit_mul(t50, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t52 = circuit_add(in13, t51); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t53 = circuit_mul(in23, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t54 = circuit_add(in22, t53); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t55 = circuit_mul(t54, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t56 = circuit_add(in21, t55); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t57 = circuit_mul(t56, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t58 = circuit_add(in20, t57); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t59 = circuit_mul(t58, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t60 = circuit_add(in19, t59); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t61 = circuit_mul(t60, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t62 = circuit_add(in18, t61); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t63 = circuit_mul(t62, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t64 = circuit_add(in17, t63); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t65 = circuit_inverse(t64);
    let t66 = circuit_mul(t52, t65);
    let t67 = circuit_mul(in3, t66);
    let t68 = circuit_add(t46, t67);
    let t69 = circuit_mul(in5, t68);
    let t70 = circuit_sub(t34, t69);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t70,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDiv.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDiv.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDiv.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDiv.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in23

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t70);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_3P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let t0 = circuit_mul(in11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in10, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in9, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in8, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t7 = circuit_add(in7, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t9 = circuit_add(in6, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t10 = circuit_mul(in18, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t11 = circuit_add(in17, t10); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t13 = circuit_add(in16, t12); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t15 = circuit_add(in15, t14); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t17 = circuit_add(in14, t16); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t19 = circuit_add(in13, t18); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t21 = circuit_add(in12, t20); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t22 = circuit_inverse(t21);
    let t23 = circuit_mul(t9, t22);
    let t24 = circuit_mul(in25, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t25 = circuit_add(in24, t24); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t27 = circuit_add(in23, t26); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t29 = circuit_add(in22, t28); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t31 = circuit_add(in21, t30); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t33 = circuit_add(in20, t32); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t35 = circuit_add(in19, t34); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t36 = circuit_mul(in35, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t37 = circuit_add(in34, t36); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t39 = circuit_add(in33, t38); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t41 = circuit_add(in32, t40); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t43 = circuit_add(in31, t42); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t45 = circuit_add(in30, t44); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t47 = circuit_add(in29, t46); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t49 = circuit_add(in28, t48); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t51 = circuit_add(in27, t50); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t53 = circuit_add(in26, t52); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t54 = circuit_inverse(t53);
    let t55 = circuit_mul(t35, t54);
    let t56 = circuit_mul(in1, t55);
    let t57 = circuit_add(t23, t56);
    let t58 = circuit_mul(in4, t57);
    let t59 = circuit_mul(in11, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t60 = circuit_add(in10, t59); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t61 = circuit_mul(t60, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t62 = circuit_add(in9, t61); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t63 = circuit_mul(t62, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t64 = circuit_add(in8, t63); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t65 = circuit_mul(t64, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t66 = circuit_add(in7, t65); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t67 = circuit_mul(t66, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t68 = circuit_add(in6, t67); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t69 = circuit_mul(in18, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t70 = circuit_add(in17, t69); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t71 = circuit_mul(t70, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t72 = circuit_add(in16, t71); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t73 = circuit_mul(t72, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t74 = circuit_add(in15, t73); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t75 = circuit_mul(t74, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t76 = circuit_add(in14, t75); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t77 = circuit_mul(t76, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t78 = circuit_add(in13, t77); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t79 = circuit_mul(t78, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t80 = circuit_add(in12, t79); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t81 = circuit_inverse(t80);
    let t82 = circuit_mul(t68, t81);
    let t83 = circuit_mul(in25, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t84 = circuit_add(in24, t83); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t85 = circuit_mul(t84, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t86 = circuit_add(in23, t85); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t87 = circuit_mul(t86, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t88 = circuit_add(in22, t87); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t89 = circuit_mul(t88, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t90 = circuit_add(in21, t89); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t91 = circuit_mul(t90, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t92 = circuit_add(in20, t91); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t93 = circuit_mul(t92, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t94 = circuit_add(in19, t93); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t95 = circuit_mul(in35, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t96 = circuit_add(in34, t95); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t97 = circuit_mul(t96, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t98 = circuit_add(in33, t97); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t99 = circuit_mul(t98, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t100 = circuit_add(in32, t99); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t101 = circuit_mul(t100, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t102 = circuit_add(in31, t101); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t103 = circuit_mul(t102, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t104 = circuit_add(in30, t103); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t105 = circuit_mul(t104, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t106 = circuit_add(in29, t105); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t107 = circuit_mul(t106, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t108 = circuit_add(in28, t107); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t109 = circuit_mul(t108, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t110 = circuit_add(in27, t109); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t111 = circuit_mul(t110, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t112 = circuit_add(in26, t111); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t113 = circuit_inverse(t112);
    let t114 = circuit_mul(t94, t113);
    let t115 = circuit_mul(in3, t114);
    let t116 = circuit_add(t82, t115);
    let t117 = circuit_mul(in5, t116);
    let t118 = circuit_sub(t58, t117);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t118,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in35

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t118);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_4P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let in39 = CE::<CI<39>> {};
    let t0 = circuit_mul(in12, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in11, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in10, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in9, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t7 = circuit_add(in8, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t9 = circuit_add(in7, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t11 = circuit_add(in6, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t12 = circuit_mul(in20, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t13 = circuit_add(in19, t12); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t15 = circuit_add(in18, t14); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t17 = circuit_add(in17, t16); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t19 = circuit_add(in16, t18); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t21 = circuit_add(in15, t20); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t23 = circuit_add(in14, t22); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t25 = circuit_add(in13, t24); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t26 = circuit_inverse(t25);
    let t27 = circuit_mul(t11, t26);
    let t28 = circuit_mul(in28, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t29 = circuit_add(in27, t28); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t31 = circuit_add(in26, t30); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t33 = circuit_add(in25, t32); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t35 = circuit_add(in24, t34); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t37 = circuit_add(in23, t36); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t39 = circuit_add(in22, t38); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t41 = circuit_add(in21, t40); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t42 = circuit_mul(in39, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t43 = circuit_add(in38, t42); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t45 = circuit_add(in37, t44); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t47 = circuit_add(in36, t46); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t49 = circuit_add(in35, t48); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t51 = circuit_add(in34, t50); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t53 = circuit_add(in33, t52); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t55 = circuit_add(in32, t54); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t57 = circuit_add(in31, t56); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t59 = circuit_add(in30, t58); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t61 = circuit_add(in29, t60); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t62 = circuit_inverse(t61);
    let t63 = circuit_mul(t41, t62);
    let t64 = circuit_mul(in1, t63);
    let t65 = circuit_add(t27, t64);
    let t66 = circuit_mul(in4, t65);
    let t67 = circuit_mul(in12, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t68 = circuit_add(in11, t67); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t69 = circuit_mul(t68, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t70 = circuit_add(in10, t69); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t71 = circuit_mul(t70, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t72 = circuit_add(in9, t71); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t73 = circuit_mul(t72, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t74 = circuit_add(in8, t73); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t75 = circuit_mul(t74, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t76 = circuit_add(in7, t75); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t77 = circuit_mul(t76, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t78 = circuit_add(in6, t77); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t79 = circuit_mul(in20, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t80 = circuit_add(in19, t79); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t81 = circuit_mul(t80, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t82 = circuit_add(in18, t81); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t83 = circuit_mul(t82, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t84 = circuit_add(in17, t83); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t85 = circuit_mul(t84, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t86 = circuit_add(in16, t85); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t87 = circuit_mul(t86, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t88 = circuit_add(in15, t87); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t89 = circuit_mul(t88, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t90 = circuit_add(in14, t89); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t91 = circuit_mul(t90, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t92 = circuit_add(in13, t91); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t93 = circuit_inverse(t92);
    let t94 = circuit_mul(t78, t93);
    let t95 = circuit_mul(in28, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t96 = circuit_add(in27, t95); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t97 = circuit_mul(t96, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t98 = circuit_add(in26, t97); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t99 = circuit_mul(t98, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t100 = circuit_add(in25, t99); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t101 = circuit_mul(t100, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t102 = circuit_add(in24, t101); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t103 = circuit_mul(t102, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t104 = circuit_add(in23, t103); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t105 = circuit_mul(t104, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t106 = circuit_add(in22, t105); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t107 = circuit_mul(t106, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t108 = circuit_add(in21, t107); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t109 = circuit_mul(in39, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t110 = circuit_add(in38, t109); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t111 = circuit_mul(t110, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t112 = circuit_add(in37, t111); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t113 = circuit_mul(t112, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t114 = circuit_add(in36, t113); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t115 = circuit_mul(t114, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t116 = circuit_add(in35, t115); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t117 = circuit_mul(t116, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t118 = circuit_add(in34, t117); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t119 = circuit_mul(t118, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t120 = circuit_add(in33, t119); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t121 = circuit_mul(t120, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t122 = circuit_add(in32, t121); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t123 = circuit_mul(t122, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t124 = circuit_add(in31, t123); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t125 = circuit_mul(t124, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t126 = circuit_add(in30, t125); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t127 = circuit_mul(t126, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t128 = circuit_add(in29, t127); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t129 = circuit_inverse(t128);
    let t130 = circuit_mul(t108, t129);
    let t131 = circuit_mul(in3, t130);
    let t132 = circuit_add(t94, t131);
    let t133 = circuit_mul(in5, t132);
    let t134 = circuit_sub(t66, t133);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t134,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in39

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t134);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_5P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let (in42, in43) = (CE::<CI<42>> {}, CE::<CI<43>> {});
    let t0 = circuit_mul(in13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in12, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in11, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in10, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t7 = circuit_add(in9, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t9 = circuit_add(in8, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t11 = circuit_add(in7, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t13 = circuit_add(in6, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t14 = circuit_mul(in22, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t15 = circuit_add(in21, t14); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t17 = circuit_add(in20, t16); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t19 = circuit_add(in19, t18); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t21 = circuit_add(in18, t20); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t23 = circuit_add(in17, t22); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t25 = circuit_add(in16, t24); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t27 = circuit_add(in15, t26); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t29 = circuit_add(in14, t28); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t30 = circuit_inverse(t29);
    let t31 = circuit_mul(t13, t30);
    let t32 = circuit_mul(in31, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t33 = circuit_add(in30, t32); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t35 = circuit_add(in29, t34); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t37 = circuit_add(in28, t36); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t39 = circuit_add(in27, t38); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t41 = circuit_add(in26, t40); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t43 = circuit_add(in25, t42); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t45 = circuit_add(in24, t44); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t47 = circuit_add(in23, t46); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t48 = circuit_mul(in43, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t49 = circuit_add(in42, t48); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t51 = circuit_add(in41, t50); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t53 = circuit_add(in40, t52); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t55 = circuit_add(in39, t54); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t57 = circuit_add(in38, t56); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t59 = circuit_add(in37, t58); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t61 = circuit_add(in36, t60); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t63 = circuit_add(in35, t62); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t65 = circuit_add(in34, t64); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t66 = circuit_mul(t65, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t67 = circuit_add(in33, t66); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t69 = circuit_add(in32, t68); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t70 = circuit_inverse(t69);
    let t71 = circuit_mul(t47, t70);
    let t72 = circuit_mul(in1, t71);
    let t73 = circuit_add(t31, t72);
    let t74 = circuit_mul(in4, t73);
    let t75 = circuit_mul(in13, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t76 = circuit_add(in12, t75); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t77 = circuit_mul(t76, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t78 = circuit_add(in11, t77); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t79 = circuit_mul(t78, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t80 = circuit_add(in10, t79); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t81 = circuit_mul(t80, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t82 = circuit_add(in9, t81); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t83 = circuit_mul(t82, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t84 = circuit_add(in8, t83); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t85 = circuit_mul(t84, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t86 = circuit_add(in7, t85); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t87 = circuit_mul(t86, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t88 = circuit_add(in6, t87); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t89 = circuit_mul(in22, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t90 = circuit_add(in21, t89); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t91 = circuit_mul(t90, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t92 = circuit_add(in20, t91); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t93 = circuit_mul(t92, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t94 = circuit_add(in19, t93); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t95 = circuit_mul(t94, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t96 = circuit_add(in18, t95); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t97 = circuit_mul(t96, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t98 = circuit_add(in17, t97); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t99 = circuit_mul(t98, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t100 = circuit_add(in16, t99); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t101 = circuit_mul(t100, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t102 = circuit_add(in15, t101); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t103 = circuit_mul(t102, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t104 = circuit_add(in14, t103); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t105 = circuit_inverse(t104);
    let t106 = circuit_mul(t88, t105);
    let t107 = circuit_mul(in31, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t108 = circuit_add(in30, t107); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t109 = circuit_mul(t108, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t110 = circuit_add(in29, t109); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t111 = circuit_mul(t110, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t112 = circuit_add(in28, t111); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t113 = circuit_mul(t112, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t114 = circuit_add(in27, t113); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t115 = circuit_mul(t114, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t116 = circuit_add(in26, t115); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t117 = circuit_mul(t116, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t118 = circuit_add(in25, t117); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t119 = circuit_mul(t118, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t120 = circuit_add(in24, t119); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t121 = circuit_mul(t120, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t122 = circuit_add(in23, t121); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t123 = circuit_mul(in43, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t124 = circuit_add(in42, t123); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t125 = circuit_mul(t124, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t126 = circuit_add(in41, t125); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t127 = circuit_mul(t126, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t128 = circuit_add(in40, t127); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t129 = circuit_mul(t128, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t130 = circuit_add(in39, t129); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t131 = circuit_mul(t130, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t132 = circuit_add(in38, t131); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t133 = circuit_mul(t132, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t134 = circuit_add(in37, t133); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t135 = circuit_mul(t134, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t136 = circuit_add(in36, t135); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t137 = circuit_mul(t136, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t138 = circuit_add(in35, t137); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t139 = circuit_mul(t138, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t140 = circuit_add(in34, t139); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t141 = circuit_mul(t140, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t142 = circuit_add(in33, t141); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t143 = circuit_mul(t142, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t144 = circuit_add(in32, t143); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t145 = circuit_inverse(t144);
    let t146 = circuit_mul(t122, t145);
    let t147 = circuit_mul(in3, t146);
    let t148 = circuit_add(t106, t147);
    let t149 = circuit_mul(in5, t148);
    let t150 = circuit_sub(t74, t149);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t150,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in43

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t150);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_6P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let t0 = circuit_mul(in14, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in13, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in12, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in11, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t7 = circuit_add(in10, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t9 = circuit_add(in9, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t11 = circuit_add(in8, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t13 = circuit_add(in7, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t15 = circuit_add(in6, t14); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t16 = circuit_mul(in24, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t17 = circuit_add(in23, t16); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t19 = circuit_add(in22, t18); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t21 = circuit_add(in21, t20); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t23 = circuit_add(in20, t22); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t25 = circuit_add(in19, t24); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t27 = circuit_add(in18, t26); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t29 = circuit_add(in17, t28); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t31 = circuit_add(in16, t30); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t33 = circuit_add(in15, t32); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t34 = circuit_inverse(t33);
    let t35 = circuit_mul(t15, t34);
    let t36 = circuit_mul(in34, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t37 = circuit_add(in33, t36); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t39 = circuit_add(in32, t38); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t41 = circuit_add(in31, t40); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t43 = circuit_add(in30, t42); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t45 = circuit_add(in29, t44); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t47 = circuit_add(in28, t46); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t49 = circuit_add(in27, t48); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t51 = circuit_add(in26, t50); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t53 = circuit_add(in25, t52); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t54 = circuit_mul(in47, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t55 = circuit_add(in46, t54); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t57 = circuit_add(in45, t56); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t59 = circuit_add(in44, t58); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t61 = circuit_add(in43, t60); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t63 = circuit_add(in42, t62); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t65 = circuit_add(in41, t64); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t66 = circuit_mul(t65, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t67 = circuit_add(in40, t66); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t69 = circuit_add(in39, t68); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t70 = circuit_mul(t69, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t71 = circuit_add(in38, t70); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t72 = circuit_mul(t71, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t73 = circuit_add(in37, t72); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t74 = circuit_mul(t73, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t75 = circuit_add(in36, t74); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t76 = circuit_mul(t75, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t77 = circuit_add(in35, t76); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t78 = circuit_inverse(t77);
    let t79 = circuit_mul(t53, t78);
    let t80 = circuit_mul(in1, t79);
    let t81 = circuit_add(t35, t80);
    let t82 = circuit_mul(in4, t81);
    let t83 = circuit_mul(in14, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t84 = circuit_add(in13, t83); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t85 = circuit_mul(t84, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t86 = circuit_add(in12, t85); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t87 = circuit_mul(t86, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t88 = circuit_add(in11, t87); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t89 = circuit_mul(t88, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t90 = circuit_add(in10, t89); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t91 = circuit_mul(t90, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t92 = circuit_add(in9, t91); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t93 = circuit_mul(t92, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t94 = circuit_add(in8, t93); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t95 = circuit_mul(t94, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t96 = circuit_add(in7, t95); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t97 = circuit_mul(t96, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t98 = circuit_add(in6, t97); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t99 = circuit_mul(in24, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t100 = circuit_add(in23, t99); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t101 = circuit_mul(t100, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t102 = circuit_add(in22, t101); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t103 = circuit_mul(t102, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t104 = circuit_add(in21, t103); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t105 = circuit_mul(t104, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t106 = circuit_add(in20, t105); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t107 = circuit_mul(t106, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t108 = circuit_add(in19, t107); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t109 = circuit_mul(t108, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t110 = circuit_add(in18, t109); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t111 = circuit_mul(t110, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t112 = circuit_add(in17, t111); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t113 = circuit_mul(t112, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t114 = circuit_add(in16, t113); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t115 = circuit_mul(t114, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t116 = circuit_add(in15, t115); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t117 = circuit_inverse(t116);
    let t118 = circuit_mul(t98, t117);
    let t119 = circuit_mul(in34, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t120 = circuit_add(in33, t119); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t121 = circuit_mul(t120, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t122 = circuit_add(in32, t121); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t123 = circuit_mul(t122, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t124 = circuit_add(in31, t123); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t125 = circuit_mul(t124, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t126 = circuit_add(in30, t125); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t127 = circuit_mul(t126, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t128 = circuit_add(in29, t127); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t129 = circuit_mul(t128, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t130 = circuit_add(in28, t129); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t131 = circuit_mul(t130, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t132 = circuit_add(in27, t131); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t133 = circuit_mul(t132, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t134 = circuit_add(in26, t133); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t135 = circuit_mul(t134, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t136 = circuit_add(in25, t135); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t137 = circuit_mul(in47, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t138 = circuit_add(in46, t137); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t139 = circuit_mul(t138, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t140 = circuit_add(in45, t139); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t141 = circuit_mul(t140, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t142 = circuit_add(in44, t141); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t143 = circuit_mul(t142, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t144 = circuit_add(in43, t143); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t145 = circuit_mul(t144, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t146 = circuit_add(in42, t145); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t147 = circuit_mul(t146, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t148 = circuit_add(in41, t147); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t149 = circuit_mul(t148, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t150 = circuit_add(in40, t149); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t151 = circuit_mul(t150, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t152 = circuit_add(in39, t151); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t153 = circuit_mul(t152, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t154 = circuit_add(in38, t153); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t155 = circuit_mul(t154, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t156 = circuit_add(in37, t155); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t157 = circuit_mul(t156, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t158 = circuit_add(in36, t157); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t159 = circuit_mul(t158, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t160 = circuit_add(in35, t159); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t161 = circuit_inverse(t160);
    let t162 = circuit_mul(t136, t161);
    let t163 = circuit_mul(in3, t162);
    let t164 = circuit_add(t118, t163);
    let t165 = circuit_mul(in5, t164);
    let t166 = circuit_sub(t82, t165);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t166,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in47

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t166);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_7P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let in51 = CE::<CI<51>> {};
    let t0 = circuit_mul(in15, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in14, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in13, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in12, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t7 = circuit_add(in11, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t9 = circuit_add(in10, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t11 = circuit_add(in9, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t13 = circuit_add(in8, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t15 = circuit_add(in7, t14); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t17 = circuit_add(in6, t16); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t18 = circuit_mul(in26, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t19 = circuit_add(in25, t18); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t21 = circuit_add(in24, t20); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t23 = circuit_add(in23, t22); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t25 = circuit_add(in22, t24); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t27 = circuit_add(in21, t26); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t29 = circuit_add(in20, t28); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t31 = circuit_add(in19, t30); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t33 = circuit_add(in18, t32); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t35 = circuit_add(in17, t34); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t37 = circuit_add(in16, t36); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t38 = circuit_inverse(t37);
    let t39 = circuit_mul(t17, t38);
    let t40 = circuit_mul(in37, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t41 = circuit_add(in36, t40); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t43 = circuit_add(in35, t42); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t45 = circuit_add(in34, t44); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t47 = circuit_add(in33, t46); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t49 = circuit_add(in32, t48); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t51 = circuit_add(in31, t50); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t53 = circuit_add(in30, t52); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t55 = circuit_add(in29, t54); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t57 = circuit_add(in28, t56); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t59 = circuit_add(in27, t58); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t60 = circuit_mul(in51, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t61 = circuit_add(in50, t60); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t63 = circuit_add(in49, t62); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t65 = circuit_add(in48, t64); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t66 = circuit_mul(t65, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t67 = circuit_add(in47, t66); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t69 = circuit_add(in46, t68); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t70 = circuit_mul(t69, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t71 = circuit_add(in45, t70); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t72 = circuit_mul(t71, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t73 = circuit_add(in44, t72); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t74 = circuit_mul(t73, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t75 = circuit_add(in43, t74); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t76 = circuit_mul(t75, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t77 = circuit_add(in42, t76); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t78 = circuit_mul(t77, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t79 = circuit_add(in41, t78); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t80 = circuit_mul(t79, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t81 = circuit_add(in40, t80); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t82 = circuit_mul(t81, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t83 = circuit_add(in39, t82); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t84 = circuit_mul(t83, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t85 = circuit_add(in38, t84); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t86 = circuit_inverse(t85);
    let t87 = circuit_mul(t59, t86);
    let t88 = circuit_mul(in1, t87);
    let t89 = circuit_add(t39, t88);
    let t90 = circuit_mul(in4, t89);
    let t91 = circuit_mul(in15, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t92 = circuit_add(in14, t91); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t93 = circuit_mul(t92, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t94 = circuit_add(in13, t93); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t95 = circuit_mul(t94, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t96 = circuit_add(in12, t95); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t97 = circuit_mul(t96, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t98 = circuit_add(in11, t97); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t99 = circuit_mul(t98, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t100 = circuit_add(in10, t99); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t101 = circuit_mul(t100, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t102 = circuit_add(in9, t101); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t103 = circuit_mul(t102, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t104 = circuit_add(in8, t103); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t105 = circuit_mul(t104, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t106 = circuit_add(in7, t105); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t107 = circuit_mul(t106, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t108 = circuit_add(in6, t107); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t109 = circuit_mul(in26, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t110 = circuit_add(in25, t109); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t111 = circuit_mul(t110, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t112 = circuit_add(in24, t111); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t113 = circuit_mul(t112, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t114 = circuit_add(in23, t113); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t115 = circuit_mul(t114, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t116 = circuit_add(in22, t115); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t117 = circuit_mul(t116, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t118 = circuit_add(in21, t117); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t119 = circuit_mul(t118, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t120 = circuit_add(in20, t119); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t121 = circuit_mul(t120, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t122 = circuit_add(in19, t121); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t123 = circuit_mul(t122, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t124 = circuit_add(in18, t123); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t125 = circuit_mul(t124, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t126 = circuit_add(in17, t125); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t127 = circuit_mul(t126, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t128 = circuit_add(in16, t127); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t129 = circuit_inverse(t128);
    let t130 = circuit_mul(t108, t129);
    let t131 = circuit_mul(in37, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t132 = circuit_add(in36, t131); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t133 = circuit_mul(t132, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t134 = circuit_add(in35, t133); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t135 = circuit_mul(t134, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t136 = circuit_add(in34, t135); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t137 = circuit_mul(t136, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t138 = circuit_add(in33, t137); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t139 = circuit_mul(t138, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t140 = circuit_add(in32, t139); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t141 = circuit_mul(t140, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t142 = circuit_add(in31, t141); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t143 = circuit_mul(t142, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t144 = circuit_add(in30, t143); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t145 = circuit_mul(t144, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t146 = circuit_add(in29, t145); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t147 = circuit_mul(t146, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t148 = circuit_add(in28, t147); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t149 = circuit_mul(t148, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t150 = circuit_add(in27, t149); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t151 = circuit_mul(in51, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t152 = circuit_add(in50, t151); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t153 = circuit_mul(t152, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t154 = circuit_add(in49, t153); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t155 = circuit_mul(t154, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t156 = circuit_add(in48, t155); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t157 = circuit_mul(t156, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t158 = circuit_add(in47, t157); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t159 = circuit_mul(t158, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t160 = circuit_add(in46, t159); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t161 = circuit_mul(t160, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t162 = circuit_add(in45, t161); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t163 = circuit_mul(t162, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t164 = circuit_add(in44, t163); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t165 = circuit_mul(t164, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t166 = circuit_add(in43, t165); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t167 = circuit_mul(t166, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t168 = circuit_add(in42, t167); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t169 = circuit_mul(t168, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t170 = circuit_add(in41, t169); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t171 = circuit_mul(t170, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t172 = circuit_add(in40, t171); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t173 = circuit_mul(t172, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t174 = circuit_add(in39, t173); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t175 = circuit_mul(t174, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t176 = circuit_add(in38, t175); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t177 = circuit_inverse(t176);
    let t178 = circuit_mul(t150, t177);
    let t179 = circuit_mul(in3, t178);
    let t180 = circuit_add(t130, t179);
    let t181 = circuit_mul(in5, t180);
    let t182 = circuit_sub(t90, t181);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t182,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in51

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t182);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_8P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let (in54, in55) = (CE::<CI<54>> {}, CE::<CI<55>> {});
    let t0 = circuit_mul(in16, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in15, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in14, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in13, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t7 = circuit_add(in12, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t9 = circuit_add(in11, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t11 = circuit_add(in10, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t13 = circuit_add(in9, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t15 = circuit_add(in8, t14); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t17 = circuit_add(in7, t16); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t19 = circuit_add(in6, t18); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t20 = circuit_mul(in28, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t21 = circuit_add(in27, t20); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t22 = circuit_mul(t21, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t23 = circuit_add(in26, t22); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t25 = circuit_add(in25, t24); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t27 = circuit_add(in24, t26); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t29 = circuit_add(in23, t28); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t31 = circuit_add(in22, t30); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t33 = circuit_add(in21, t32); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t35 = circuit_add(in20, t34); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t37 = circuit_add(in19, t36); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t39 = circuit_add(in18, t38); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t41 = circuit_add(in17, t40); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t42 = circuit_inverse(t41);
    let t43 = circuit_mul(t19, t42);
    let t44 = circuit_mul(in40, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t45 = circuit_add(in39, t44); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t46 = circuit_mul(t45, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t47 = circuit_add(in38, t46); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t48 = circuit_mul(t47, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t49 = circuit_add(in37, t48); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t51 = circuit_add(in36, t50); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t53 = circuit_add(in35, t52); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t55 = circuit_add(in34, t54); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t57 = circuit_add(in33, t56); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t59 = circuit_add(in32, t58); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t61 = circuit_add(in31, t60); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t63 = circuit_add(in30, t62); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t65 = circuit_add(in29, t64); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t66 = circuit_mul(in55, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t67 = circuit_add(in54, t66); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t69 = circuit_add(in53, t68); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t70 = circuit_mul(t69, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t71 = circuit_add(in52, t70); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t72 = circuit_mul(t71, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t73 = circuit_add(in51, t72); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t74 = circuit_mul(t73, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t75 = circuit_add(in50, t74); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t76 = circuit_mul(t75, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t77 = circuit_add(in49, t76); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t78 = circuit_mul(t77, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t79 = circuit_add(in48, t78); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t80 = circuit_mul(t79, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t81 = circuit_add(in47, t80); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t82 = circuit_mul(t81, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t83 = circuit_add(in46, t82); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t84 = circuit_mul(t83, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t85 = circuit_add(in45, t84); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t86 = circuit_mul(t85, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t87 = circuit_add(in44, t86); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t88 = circuit_mul(t87, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t89 = circuit_add(in43, t88); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t90 = circuit_mul(t89, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t91 = circuit_add(in42, t90); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t92 = circuit_mul(t91, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t93 = circuit_add(in41, t92); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t94 = circuit_inverse(t93);
    let t95 = circuit_mul(t65, t94);
    let t96 = circuit_mul(in1, t95);
    let t97 = circuit_add(t43, t96);
    let t98 = circuit_mul(in4, t97);
    let t99 = circuit_mul(in16, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t100 = circuit_add(in15, t99); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t101 = circuit_mul(t100, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t102 = circuit_add(in14, t101); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t103 = circuit_mul(t102, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t104 = circuit_add(in13, t103); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t105 = circuit_mul(t104, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t106 = circuit_add(in12, t105); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t107 = circuit_mul(t106, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t108 = circuit_add(in11, t107); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t109 = circuit_mul(t108, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t110 = circuit_add(in10, t109); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t111 = circuit_mul(t110, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t112 = circuit_add(in9, t111); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t113 = circuit_mul(t112, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t114 = circuit_add(in8, t113); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t115 = circuit_mul(t114, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t116 = circuit_add(in7, t115); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t117 = circuit_mul(t116, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t118 = circuit_add(in6, t117); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t119 = circuit_mul(in28, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t120 = circuit_add(in27, t119); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t121 = circuit_mul(t120, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t122 = circuit_add(in26, t121); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t123 = circuit_mul(t122, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t124 = circuit_add(in25, t123); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t125 = circuit_mul(t124, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t126 = circuit_add(in24, t125); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t127 = circuit_mul(t126, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t128 = circuit_add(in23, t127); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t129 = circuit_mul(t128, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t130 = circuit_add(in22, t129); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t131 = circuit_mul(t130, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t132 = circuit_add(in21, t131); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t133 = circuit_mul(t132, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t134 = circuit_add(in20, t133); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t135 = circuit_mul(t134, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t136 = circuit_add(in19, t135); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t137 = circuit_mul(t136, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t138 = circuit_add(in18, t137); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t139 = circuit_mul(t138, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t140 = circuit_add(in17, t139); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t141 = circuit_inverse(t140);
    let t142 = circuit_mul(t118, t141);
    let t143 = circuit_mul(in40, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t144 = circuit_add(in39, t143); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t145 = circuit_mul(t144, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t146 = circuit_add(in38, t145); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t147 = circuit_mul(t146, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t148 = circuit_add(in37, t147); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t149 = circuit_mul(t148, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t150 = circuit_add(in36, t149); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t151 = circuit_mul(t150, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t152 = circuit_add(in35, t151); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t153 = circuit_mul(t152, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t154 = circuit_add(in34, t153); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t155 = circuit_mul(t154, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t156 = circuit_add(in33, t155); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t157 = circuit_mul(t156, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t158 = circuit_add(in32, t157); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t159 = circuit_mul(t158, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t160 = circuit_add(in31, t159); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t161 = circuit_mul(t160, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t162 = circuit_add(in30, t161); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t163 = circuit_mul(t162, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t164 = circuit_add(in29, t163); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t165 = circuit_mul(in55, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t166 = circuit_add(in54, t165); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t167 = circuit_mul(t166, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t168 = circuit_add(in53, t167); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t169 = circuit_mul(t168, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t170 = circuit_add(in52, t169); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t171 = circuit_mul(t170, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t172 = circuit_add(in51, t171); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t173 = circuit_mul(t172, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t174 = circuit_add(in50, t173); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t175 = circuit_mul(t174, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t176 = circuit_add(in49, t175); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t177 = circuit_mul(t176, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t178 = circuit_add(in48, t177); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t179 = circuit_mul(t178, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t180 = circuit_add(in47, t179); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t181 = circuit_mul(t180, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t182 = circuit_add(in46, t181); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t183 = circuit_mul(t182, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t184 = circuit_add(in45, t183); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t185 = circuit_mul(t184, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t186 = circuit_add(in44, t185); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t187 = circuit_mul(t186, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t188 = circuit_add(in43, t187); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t189 = circuit_mul(t188, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t190 = circuit_add(in42, t189); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t191 = circuit_mul(t190, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t192 = circuit_add(in41, t191); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t193 = circuit_inverse(t192);
    let t194 = circuit_mul(t164, t193);
    let t195 = circuit_mul(in3, t194);
    let t196 = circuit_add(t142, t195);
    let t197 = circuit_mul(in5, t196);
    let t198 = circuit_sub(t98, t197);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t198,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in55

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t198);
    return (res,);
}
#[inline]
pub fn run_EVAL_FN_CHALLENGE_DUPL_9P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    SumDlogDivBatched: FunctionFelt<T>,
    curve_index: usize,
) -> (u384,) {
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
    let t0 = circuit_mul(in17, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t1 = circuit_add(in16, t0); // Eval sumdlogdiv_a_num Horner step: add coefficient_10
    let t2 = circuit_mul(t1, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t3 = circuit_add(in15, t2); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t4 = circuit_mul(t3, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t5 = circuit_add(in14, t4); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t6 = circuit_mul(t5, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t7 = circuit_add(in13, t6); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t8 = circuit_mul(t7, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t9 = circuit_add(in12, t8); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t10 = circuit_mul(t9, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t11 = circuit_add(in11, t10); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t12 = circuit_mul(t11, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t13 = circuit_add(in10, t12); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t14 = circuit_mul(t13, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t15 = circuit_add(in9, t14); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t16 = circuit_mul(t15, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t17 = circuit_add(in8, t16); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t18 = circuit_mul(t17, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t19 = circuit_add(in7, t18); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t20 = circuit_mul(t19, in0); // Eval sumdlogdiv_a_num Horner step: multiply by xA0
    let t21 = circuit_add(in6, t20); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t22 = circuit_mul(in30, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t23 = circuit_add(in29, t22); // Eval sumdlogdiv_a_den Horner step: add coefficient_11
    let t24 = circuit_mul(t23, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t25 = circuit_add(in28, t24); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t26 = circuit_mul(t25, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t27 = circuit_add(in27, t26); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t28 = circuit_mul(t27, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t29 = circuit_add(in26, t28); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t30 = circuit_mul(t29, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t31 = circuit_add(in25, t30); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t32 = circuit_mul(t31, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t33 = circuit_add(in24, t32); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t34 = circuit_mul(t33, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t35 = circuit_add(in23, t34); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t36 = circuit_mul(t35, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t37 = circuit_add(in22, t36); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t38 = circuit_mul(t37, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t39 = circuit_add(in21, t38); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t40 = circuit_mul(t39, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t41 = circuit_add(in20, t40); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t42 = circuit_mul(t41, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t43 = circuit_add(in19, t42); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t44 = circuit_mul(t43, in0); // Eval sumdlogdiv_a_den Horner step: multiply by xA0
    let t45 = circuit_add(in18, t44); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t46 = circuit_inverse(t45);
    let t47 = circuit_mul(t21, t46);
    let t48 = circuit_mul(in43, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t49 = circuit_add(in42, t48); // Eval sumdlogdiv_b_num Horner step: add coefficient_11
    let t50 = circuit_mul(t49, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t51 = circuit_add(in41, t50); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t52 = circuit_mul(t51, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t53 = circuit_add(in40, t52); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t54 = circuit_mul(t53, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t55 = circuit_add(in39, t54); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t56 = circuit_mul(t55, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t57 = circuit_add(in38, t56); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t58 = circuit_mul(t57, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t59 = circuit_add(in37, t58); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t60 = circuit_mul(t59, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t61 = circuit_add(in36, t60); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t62 = circuit_mul(t61, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t63 = circuit_add(in35, t62); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t64 = circuit_mul(t63, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t65 = circuit_add(in34, t64); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t66 = circuit_mul(t65, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t67 = circuit_add(in33, t66); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t68 = circuit_mul(t67, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t69 = circuit_add(in32, t68); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t70 = circuit_mul(t69, in0); // Eval sumdlogdiv_b_num Horner step: multiply by xA0
    let t71 = circuit_add(in31, t70); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t72 = circuit_mul(in59, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t73 = circuit_add(in58, t72); // Eval sumdlogdiv_b_den Horner step: add coefficient_14
    let t74 = circuit_mul(t73, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t75 = circuit_add(in57, t74); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t76 = circuit_mul(t75, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t77 = circuit_add(in56, t76); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t78 = circuit_mul(t77, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t79 = circuit_add(in55, t78); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t80 = circuit_mul(t79, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t81 = circuit_add(in54, t80); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t82 = circuit_mul(t81, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t83 = circuit_add(in53, t82); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t84 = circuit_mul(t83, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t85 = circuit_add(in52, t84); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t86 = circuit_mul(t85, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t87 = circuit_add(in51, t86); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t88 = circuit_mul(t87, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t89 = circuit_add(in50, t88); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t90 = circuit_mul(t89, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t91 = circuit_add(in49, t90); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t92 = circuit_mul(t91, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t93 = circuit_add(in48, t92); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t94 = circuit_mul(t93, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t95 = circuit_add(in47, t94); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t96 = circuit_mul(t95, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t97 = circuit_add(in46, t96); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t98 = circuit_mul(t97, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t99 = circuit_add(in45, t98); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t100 = circuit_mul(t99, in0); // Eval sumdlogdiv_b_den Horner step: multiply by xA0
    let t101 = circuit_add(in44, t100); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t102 = circuit_inverse(t101);
    let t103 = circuit_mul(t71, t102);
    let t104 = circuit_mul(in1, t103);
    let t105 = circuit_add(t47, t104);
    let t106 = circuit_mul(in4, t105);
    let t107 = circuit_mul(in17, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t108 = circuit_add(in16, t107); // Eval sumdlogdiv_a_num Horner step: add coefficient_10
    let t109 = circuit_mul(t108, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t110 = circuit_add(in15, t109); // Eval sumdlogdiv_a_num Horner step: add coefficient_9
    let t111 = circuit_mul(t110, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t112 = circuit_add(in14, t111); // Eval sumdlogdiv_a_num Horner step: add coefficient_8
    let t113 = circuit_mul(t112, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t114 = circuit_add(in13, t113); // Eval sumdlogdiv_a_num Horner step: add coefficient_7
    let t115 = circuit_mul(t114, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t116 = circuit_add(in12, t115); // Eval sumdlogdiv_a_num Horner step: add coefficient_6
    let t117 = circuit_mul(t116, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t118 = circuit_add(in11, t117); // Eval sumdlogdiv_a_num Horner step: add coefficient_5
    let t119 = circuit_mul(t118, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t120 = circuit_add(in10, t119); // Eval sumdlogdiv_a_num Horner step: add coefficient_4
    let t121 = circuit_mul(t120, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t122 = circuit_add(in9, t121); // Eval sumdlogdiv_a_num Horner step: add coefficient_3
    let t123 = circuit_mul(t122, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t124 = circuit_add(in8, t123); // Eval sumdlogdiv_a_num Horner step: add coefficient_2
    let t125 = circuit_mul(t124, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t126 = circuit_add(in7, t125); // Eval sumdlogdiv_a_num Horner step: add coefficient_1
    let t127 = circuit_mul(t126, in2); // Eval sumdlogdiv_a_num Horner step: multiply by xA2
    let t128 = circuit_add(in6, t127); // Eval sumdlogdiv_a_num Horner step: add coefficient_0
    let t129 = circuit_mul(in30, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t130 = circuit_add(in29, t129); // Eval sumdlogdiv_a_den Horner step: add coefficient_11
    let t131 = circuit_mul(t130, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t132 = circuit_add(in28, t131); // Eval sumdlogdiv_a_den Horner step: add coefficient_10
    let t133 = circuit_mul(t132, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t134 = circuit_add(in27, t133); // Eval sumdlogdiv_a_den Horner step: add coefficient_9
    let t135 = circuit_mul(t134, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t136 = circuit_add(in26, t135); // Eval sumdlogdiv_a_den Horner step: add coefficient_8
    let t137 = circuit_mul(t136, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t138 = circuit_add(in25, t137); // Eval sumdlogdiv_a_den Horner step: add coefficient_7
    let t139 = circuit_mul(t138, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t140 = circuit_add(in24, t139); // Eval sumdlogdiv_a_den Horner step: add coefficient_6
    let t141 = circuit_mul(t140, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t142 = circuit_add(in23, t141); // Eval sumdlogdiv_a_den Horner step: add coefficient_5
    let t143 = circuit_mul(t142, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t144 = circuit_add(in22, t143); // Eval sumdlogdiv_a_den Horner step: add coefficient_4
    let t145 = circuit_mul(t144, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t146 = circuit_add(in21, t145); // Eval sumdlogdiv_a_den Horner step: add coefficient_3
    let t147 = circuit_mul(t146, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t148 = circuit_add(in20, t147); // Eval sumdlogdiv_a_den Horner step: add coefficient_2
    let t149 = circuit_mul(t148, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t150 = circuit_add(in19, t149); // Eval sumdlogdiv_a_den Horner step: add coefficient_1
    let t151 = circuit_mul(t150, in2); // Eval sumdlogdiv_a_den Horner step: multiply by xA2
    let t152 = circuit_add(in18, t151); // Eval sumdlogdiv_a_den Horner step: add coefficient_0
    let t153 = circuit_inverse(t152);
    let t154 = circuit_mul(t128, t153);
    let t155 = circuit_mul(in43, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t156 = circuit_add(in42, t155); // Eval sumdlogdiv_b_num Horner step: add coefficient_11
    let t157 = circuit_mul(t156, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t158 = circuit_add(in41, t157); // Eval sumdlogdiv_b_num Horner step: add coefficient_10
    let t159 = circuit_mul(t158, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t160 = circuit_add(in40, t159); // Eval sumdlogdiv_b_num Horner step: add coefficient_9
    let t161 = circuit_mul(t160, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t162 = circuit_add(in39, t161); // Eval sumdlogdiv_b_num Horner step: add coefficient_8
    let t163 = circuit_mul(t162, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t164 = circuit_add(in38, t163); // Eval sumdlogdiv_b_num Horner step: add coefficient_7
    let t165 = circuit_mul(t164, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t166 = circuit_add(in37, t165); // Eval sumdlogdiv_b_num Horner step: add coefficient_6
    let t167 = circuit_mul(t166, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t168 = circuit_add(in36, t167); // Eval sumdlogdiv_b_num Horner step: add coefficient_5
    let t169 = circuit_mul(t168, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t170 = circuit_add(in35, t169); // Eval sumdlogdiv_b_num Horner step: add coefficient_4
    let t171 = circuit_mul(t170, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t172 = circuit_add(in34, t171); // Eval sumdlogdiv_b_num Horner step: add coefficient_3
    let t173 = circuit_mul(t172, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t174 = circuit_add(in33, t173); // Eval sumdlogdiv_b_num Horner step: add coefficient_2
    let t175 = circuit_mul(t174, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t176 = circuit_add(in32, t175); // Eval sumdlogdiv_b_num Horner step: add coefficient_1
    let t177 = circuit_mul(t176, in2); // Eval sumdlogdiv_b_num Horner step: multiply by xA2
    let t178 = circuit_add(in31, t177); // Eval sumdlogdiv_b_num Horner step: add coefficient_0
    let t179 = circuit_mul(in59, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t180 = circuit_add(in58, t179); // Eval sumdlogdiv_b_den Horner step: add coefficient_14
    let t181 = circuit_mul(t180, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t182 = circuit_add(in57, t181); // Eval sumdlogdiv_b_den Horner step: add coefficient_13
    let t183 = circuit_mul(t182, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t184 = circuit_add(in56, t183); // Eval sumdlogdiv_b_den Horner step: add coefficient_12
    let t185 = circuit_mul(t184, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t186 = circuit_add(in55, t185); // Eval sumdlogdiv_b_den Horner step: add coefficient_11
    let t187 = circuit_mul(t186, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t188 = circuit_add(in54, t187); // Eval sumdlogdiv_b_den Horner step: add coefficient_10
    let t189 = circuit_mul(t188, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t190 = circuit_add(in53, t189); // Eval sumdlogdiv_b_den Horner step: add coefficient_9
    let t191 = circuit_mul(t190, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t192 = circuit_add(in52, t191); // Eval sumdlogdiv_b_den Horner step: add coefficient_8
    let t193 = circuit_mul(t192, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t194 = circuit_add(in51, t193); // Eval sumdlogdiv_b_den Horner step: add coefficient_7
    let t195 = circuit_mul(t194, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t196 = circuit_add(in50, t195); // Eval sumdlogdiv_b_den Horner step: add coefficient_6
    let t197 = circuit_mul(t196, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t198 = circuit_add(in49, t197); // Eval sumdlogdiv_b_den Horner step: add coefficient_5
    let t199 = circuit_mul(t198, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t200 = circuit_add(in48, t199); // Eval sumdlogdiv_b_den Horner step: add coefficient_4
    let t201 = circuit_mul(t200, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t202 = circuit_add(in47, t201); // Eval sumdlogdiv_b_den Horner step: add coefficient_3
    let t203 = circuit_mul(t202, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t204 = circuit_add(in46, t203); // Eval sumdlogdiv_b_den Horner step: add coefficient_2
    let t205 = circuit_mul(t204, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t206 = circuit_add(in45, t205); // Eval sumdlogdiv_b_den Horner step: add coefficient_1
    let t207 = circuit_mul(t206, in2); // Eval sumdlogdiv_b_den Horner step: multiply by xA2
    let t208 = circuit_add(in44, t207); // Eval sumdlogdiv_b_den Horner step: add coefficient_0
    let t209 = circuit_inverse(t208);
    let t210 = circuit_mul(t178, t209);
    let t211 = circuit_mul(in3, t210);
    let t212 = circuit_add(t154, t211);
    let t213 = circuit_mul(in5, t212);
    let t214 = circuit_sub(t106, t213);

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t214,).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(A0.x); // in0
    circuit_inputs = circuit_inputs.next_2(A0.y); // in1
    circuit_inputs = circuit_inputs.next_2(A2.x); // in2
    circuit_inputs = circuit_inputs.next_2(A2.y); // in3
    circuit_inputs = circuit_inputs.next_2(coeff0); // in4
    circuit_inputs = circuit_inputs.next_2(coeff2); // in5

    for val in SumDlogDivBatched.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDivBatched.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in6 - in59

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let res: u384 = outputs.get_output(t214);
    return (res,);
}
#[inline]
pub fn run_INIT_FN_CHALLENGE_DUPL_11P_RLC_circuit<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    xA0: u384, xA2: u384, SumDlogDiv: FunctionFelt<T>, curve_index: usize,
) -> (FunctionFeltEvaluations, FunctionFeltEvaluations, u384, u384) {
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
    let in63 = CE::<CI<63>> {};
    let t0 = circuit_mul(in0, in0); // xA0^2
    let t1 = circuit_mul(in1, in1); // xA2^2
    let t2 = circuit_mul(t0, in0); // xA0^3
    let t3 = circuit_mul(t1, in1); // xA2^3
    let t4 = circuit_mul(t2, in0); // xA0^4
    let t5 = circuit_mul(t3, in1); // xA2^4
    let t6 = circuit_mul(t4, in0); // xA0^5
    let t7 = circuit_mul(t5, in1); // xA2^5
    let t8 = circuit_mul(t6, in0); // xA0^6
    let t9 = circuit_mul(t7, in1); // xA2^6
    let t10 = circuit_mul(t8, in0); // xA0^7
    let t11 = circuit_mul(t9, in1); // xA2^7
    let t12 = circuit_mul(t10, in0); // xA0^8
    let t13 = circuit_mul(t11, in1); // xA2^8
    let t14 = circuit_mul(t12, in0); // xA0^9
    let t15 = circuit_mul(t13, in1); // xA2^9
    let t16 = circuit_mul(t14, in0); // xA0^10
    let t17 = circuit_mul(t15, in1); // xA2^10
    let t18 = circuit_mul(t16, in0); // xA0^11
    let t19 = circuit_mul(t17, in1); // xA2^11
    let t20 = circuit_mul(t18, in0); // xA0^12
    let t21 = circuit_mul(t19, in1); // xA2^12
    let t22 = circuit_mul(t20, in0); // xA0^13
    let t23 = circuit_mul(t21, in1); // xA2^13
    let t24 = circuit_mul(t22, in0); // xA0^14
    let t25 = circuit_mul(t23, in1); // xA2^14
    let t26 = circuit_mul(t24, in0); // xA0^15
    let t27 = circuit_mul(t25, in1); // xA2^15
    let t28 = circuit_mul(t26, in0); // xA0^16
    let t29 = circuit_mul(t27, in1); // xA2^16
    let t30 = circuit_mul(t28, in0); // xA0^17
    let t31 = circuit_mul(t29, in1); // xA2^17
    let t32 = circuit_mul(in3, in0); // Eval sumdlogdiv_a_num step coeff_1 * xA0^1
    let t33 = circuit_add(in2, t32); // Eval sumdlogdiv_a_num step + (coeff_1 * xA0^1)
    let t34 = circuit_mul(in4, t0); // Eval sumdlogdiv_a_num step coeff_2 * xA0^2
    let t35 = circuit_add(t33, t34); // Eval sumdlogdiv_a_num step + (coeff_2 * xA0^2)
    let t36 = circuit_mul(in5, t2); // Eval sumdlogdiv_a_num step coeff_3 * xA0^3
    let t37 = circuit_add(t35, t36); // Eval sumdlogdiv_a_num step + (coeff_3 * xA0^3)
    let t38 = circuit_mul(in6, t4); // Eval sumdlogdiv_a_num step coeff_4 * xA0^4
    let t39 = circuit_add(t37, t38); // Eval sumdlogdiv_a_num step + (coeff_4 * xA0^4)
    let t40 = circuit_mul(in7, t6); // Eval sumdlogdiv_a_num step coeff_5 * xA0^5
    let t41 = circuit_add(t39, t40); // Eval sumdlogdiv_a_num step + (coeff_5 * xA0^5)
    let t42 = circuit_mul(in8, t8); // Eval sumdlogdiv_a_num step coeff_6 * xA0^6
    let t43 = circuit_add(t41, t42); // Eval sumdlogdiv_a_num step + (coeff_6 * xA0^6)
    let t44 = circuit_mul(in9, t10); // Eval sumdlogdiv_a_num step coeff_7 * xA0^7
    let t45 = circuit_add(t43, t44); // Eval sumdlogdiv_a_num step + (coeff_7 * xA0^7)
    let t46 = circuit_mul(in10, t12); // Eval sumdlogdiv_a_num step coeff_8 * xA0^8
    let t47 = circuit_add(t45, t46); // Eval sumdlogdiv_a_num step + (coeff_8 * xA0^8)
    let t48 = circuit_mul(in11, t14); // Eval sumdlogdiv_a_num step coeff_9 * xA0^9
    let t49 = circuit_add(t47, t48); // Eval sumdlogdiv_a_num step + (coeff_9 * xA0^9)
    let t50 = circuit_mul(in12, t16); // Eval sumdlogdiv_a_num step coeff_10 * xA0^10
    let t51 = circuit_add(t49, t50); // Eval sumdlogdiv_a_num step + (coeff_10 * xA0^10)
    let t52 = circuit_mul(in13, t18); // Eval sumdlogdiv_a_num step coeff_11 * xA0^11
    let t53 = circuit_add(t51, t52); // Eval sumdlogdiv_a_num step + (coeff_11 * xA0^11)
    let t54 = circuit_mul(in14, t20); // Eval sumdlogdiv_a_num step coeff_12 * xA0^12
    let t55 = circuit_add(t53, t54); // Eval sumdlogdiv_a_num step + (coeff_12 * xA0^12)
    let t56 = circuit_mul(in15, t22); // Eval sumdlogdiv_a_num step coeff_13 * xA0^13
    let t57 = circuit_add(t55, t56); // Eval sumdlogdiv_a_num step + (coeff_13 * xA0^13)
    let t58 = circuit_mul(in17, in0); // Eval sumdlogdiv_a_den step coeff_1 * xA0^1
    let t59 = circuit_add(in16, t58); // Eval sumdlogdiv_a_den step + (coeff_1 * xA0^1)
    let t60 = circuit_mul(in18, t0); // Eval sumdlogdiv_a_den step coeff_2 * xA0^2
    let t61 = circuit_add(t59, t60); // Eval sumdlogdiv_a_den step + (coeff_2 * xA0^2)
    let t62 = circuit_mul(in19, t2); // Eval sumdlogdiv_a_den step coeff_3 * xA0^3
    let t63 = circuit_add(t61, t62); // Eval sumdlogdiv_a_den step + (coeff_3 * xA0^3)
    let t64 = circuit_mul(in20, t4); // Eval sumdlogdiv_a_den step coeff_4 * xA0^4
    let t65 = circuit_add(t63, t64); // Eval sumdlogdiv_a_den step + (coeff_4 * xA0^4)
    let t66 = circuit_mul(in21, t6); // Eval sumdlogdiv_a_den step coeff_5 * xA0^5
    let t67 = circuit_add(t65, t66); // Eval sumdlogdiv_a_den step + (coeff_5 * xA0^5)
    let t68 = circuit_mul(in22, t8); // Eval sumdlogdiv_a_den step coeff_6 * xA0^6
    let t69 = circuit_add(t67, t68); // Eval sumdlogdiv_a_den step + (coeff_6 * xA0^6)
    let t70 = circuit_mul(in23, t10); // Eval sumdlogdiv_a_den step coeff_7 * xA0^7
    let t71 = circuit_add(t69, t70); // Eval sumdlogdiv_a_den step + (coeff_7 * xA0^7)
    let t72 = circuit_mul(in24, t12); // Eval sumdlogdiv_a_den step coeff_8 * xA0^8
    let t73 = circuit_add(t71, t72); // Eval sumdlogdiv_a_den step + (coeff_8 * xA0^8)
    let t74 = circuit_mul(in25, t14); // Eval sumdlogdiv_a_den step coeff_9 * xA0^9
    let t75 = circuit_add(t73, t74); // Eval sumdlogdiv_a_den step + (coeff_9 * xA0^9)
    let t76 = circuit_mul(in26, t16); // Eval sumdlogdiv_a_den step coeff_10 * xA0^10
    let t77 = circuit_add(t75, t76); // Eval sumdlogdiv_a_den step + (coeff_10 * xA0^10)
    let t78 = circuit_mul(in27, t18); // Eval sumdlogdiv_a_den step coeff_11 * xA0^11
    let t79 = circuit_add(t77, t78); // Eval sumdlogdiv_a_den step + (coeff_11 * xA0^11)
    let t80 = circuit_mul(in28, t20); // Eval sumdlogdiv_a_den step coeff_12 * xA0^12
    let t81 = circuit_add(t79, t80); // Eval sumdlogdiv_a_den step + (coeff_12 * xA0^12)
    let t82 = circuit_mul(in29, t22); // Eval sumdlogdiv_a_den step coeff_13 * xA0^13
    let t83 = circuit_add(t81, t82); // Eval sumdlogdiv_a_den step + (coeff_13 * xA0^13)
    let t84 = circuit_mul(in30, t24); // Eval sumdlogdiv_a_den step coeff_14 * xA0^14
    let t85 = circuit_add(t83, t84); // Eval sumdlogdiv_a_den step + (coeff_14 * xA0^14)
    let t86 = circuit_mul(in32, in0); // Eval sumdlogdiv_b_num step coeff_1 * xA0^1
    let t87 = circuit_add(in31, t86); // Eval sumdlogdiv_b_num step + (coeff_1 * xA0^1)
    let t88 = circuit_mul(in33, t0); // Eval sumdlogdiv_b_num step coeff_2 * xA0^2
    let t89 = circuit_add(t87, t88); // Eval sumdlogdiv_b_num step + (coeff_2 * xA0^2)
    let t90 = circuit_mul(in34, t2); // Eval sumdlogdiv_b_num step coeff_3 * xA0^3
    let t91 = circuit_add(t89, t90); // Eval sumdlogdiv_b_num step + (coeff_3 * xA0^3)
    let t92 = circuit_mul(in35, t4); // Eval sumdlogdiv_b_num step coeff_4 * xA0^4
    let t93 = circuit_add(t91, t92); // Eval sumdlogdiv_b_num step + (coeff_4 * xA0^4)
    let t94 = circuit_mul(in36, t6); // Eval sumdlogdiv_b_num step coeff_5 * xA0^5
    let t95 = circuit_add(t93, t94); // Eval sumdlogdiv_b_num step + (coeff_5 * xA0^5)
    let t96 = circuit_mul(in37, t8); // Eval sumdlogdiv_b_num step coeff_6 * xA0^6
    let t97 = circuit_add(t95, t96); // Eval sumdlogdiv_b_num step + (coeff_6 * xA0^6)
    let t98 = circuit_mul(in38, t10); // Eval sumdlogdiv_b_num step coeff_7 * xA0^7
    let t99 = circuit_add(t97, t98); // Eval sumdlogdiv_b_num step + (coeff_7 * xA0^7)
    let t100 = circuit_mul(in39, t12); // Eval sumdlogdiv_b_num step coeff_8 * xA0^8
    let t101 = circuit_add(t99, t100); // Eval sumdlogdiv_b_num step + (coeff_8 * xA0^8)
    let t102 = circuit_mul(in40, t14); // Eval sumdlogdiv_b_num step coeff_9 * xA0^9
    let t103 = circuit_add(t101, t102); // Eval sumdlogdiv_b_num step + (coeff_9 * xA0^9)
    let t104 = circuit_mul(in41, t16); // Eval sumdlogdiv_b_num step coeff_10 * xA0^10
    let t105 = circuit_add(t103, t104); // Eval sumdlogdiv_b_num step + (coeff_10 * xA0^10)
    let t106 = circuit_mul(in42, t18); // Eval sumdlogdiv_b_num step coeff_11 * xA0^11
    let t107 = circuit_add(t105, t106); // Eval sumdlogdiv_b_num step + (coeff_11 * xA0^11)
    let t108 = circuit_mul(in43, t20); // Eval sumdlogdiv_b_num step coeff_12 * xA0^12
    let t109 = circuit_add(t107, t108); // Eval sumdlogdiv_b_num step + (coeff_12 * xA0^12)
    let t110 = circuit_mul(in44, t22); // Eval sumdlogdiv_b_num step coeff_13 * xA0^13
    let t111 = circuit_add(t109, t110); // Eval sumdlogdiv_b_num step + (coeff_13 * xA0^13)
    let t112 = circuit_mul(in45, t24); // Eval sumdlogdiv_b_num step coeff_14 * xA0^14
    let t113 = circuit_add(t111, t112); // Eval sumdlogdiv_b_num step + (coeff_14 * xA0^14)
    let t114 = circuit_mul(in47, in0); // Eval sumdlogdiv_b_den step coeff_1 * xA0^1
    let t115 = circuit_add(in46, t114); // Eval sumdlogdiv_b_den step + (coeff_1 * xA0^1)
    let t116 = circuit_mul(in48, t0); // Eval sumdlogdiv_b_den step coeff_2 * xA0^2
    let t117 = circuit_add(t115, t116); // Eval sumdlogdiv_b_den step + (coeff_2 * xA0^2)
    let t118 = circuit_mul(in49, t2); // Eval sumdlogdiv_b_den step coeff_3 * xA0^3
    let t119 = circuit_add(t117, t118); // Eval sumdlogdiv_b_den step + (coeff_3 * xA0^3)
    let t120 = circuit_mul(in50, t4); // Eval sumdlogdiv_b_den step coeff_4 * xA0^4
    let t121 = circuit_add(t119, t120); // Eval sumdlogdiv_b_den step + (coeff_4 * xA0^4)
    let t122 = circuit_mul(in51, t6); // Eval sumdlogdiv_b_den step coeff_5 * xA0^5
    let t123 = circuit_add(t121, t122); // Eval sumdlogdiv_b_den step + (coeff_5 * xA0^5)
    let t124 = circuit_mul(in52, t8); // Eval sumdlogdiv_b_den step coeff_6 * xA0^6
    let t125 = circuit_add(t123, t124); // Eval sumdlogdiv_b_den step + (coeff_6 * xA0^6)
    let t126 = circuit_mul(in53, t10); // Eval sumdlogdiv_b_den step coeff_7 * xA0^7
    let t127 = circuit_add(t125, t126); // Eval sumdlogdiv_b_den step + (coeff_7 * xA0^7)
    let t128 = circuit_mul(in54, t12); // Eval sumdlogdiv_b_den step coeff_8 * xA0^8
    let t129 = circuit_add(t127, t128); // Eval sumdlogdiv_b_den step + (coeff_8 * xA0^8)
    let t130 = circuit_mul(in55, t14); // Eval sumdlogdiv_b_den step coeff_9 * xA0^9
    let t131 = circuit_add(t129, t130); // Eval sumdlogdiv_b_den step + (coeff_9 * xA0^9)
    let t132 = circuit_mul(in56, t16); // Eval sumdlogdiv_b_den step coeff_10 * xA0^10
    let t133 = circuit_add(t131, t132); // Eval sumdlogdiv_b_den step + (coeff_10 * xA0^10)
    let t134 = circuit_mul(in57, t18); // Eval sumdlogdiv_b_den step coeff_11 * xA0^11
    let t135 = circuit_add(t133, t134); // Eval sumdlogdiv_b_den step + (coeff_11 * xA0^11)
    let t136 = circuit_mul(in58, t20); // Eval sumdlogdiv_b_den step coeff_12 * xA0^12
    let t137 = circuit_add(t135, t136); // Eval sumdlogdiv_b_den step + (coeff_12 * xA0^12)
    let t138 = circuit_mul(in59, t22); // Eval sumdlogdiv_b_den step coeff_13 * xA0^13
    let t139 = circuit_add(t137, t138); // Eval sumdlogdiv_b_den step + (coeff_13 * xA0^13)
    let t140 = circuit_mul(in60, t24); // Eval sumdlogdiv_b_den step coeff_14 * xA0^14
    let t141 = circuit_add(t139, t140); // Eval sumdlogdiv_b_den step + (coeff_14 * xA0^14)
    let t142 = circuit_mul(in61, t26); // Eval sumdlogdiv_b_den step coeff_15 * xA0^15
    let t143 = circuit_add(t141, t142); // Eval sumdlogdiv_b_den step + (coeff_15 * xA0^15)
    let t144 = circuit_mul(in62, t28); // Eval sumdlogdiv_b_den step coeff_16 * xA0^16
    let t145 = circuit_add(t143, t144); // Eval sumdlogdiv_b_den step + (coeff_16 * xA0^16)
    let t146 = circuit_mul(in63, t30); // Eval sumdlogdiv_b_den step coeff_17 * xA0^17
    let t147 = circuit_add(t145, t146); // Eval sumdlogdiv_b_den step + (coeff_17 * xA0^17)
    let t148 = circuit_mul(in3, in1); // Eval sumdlogdiv_a_num step coeff_1 * xA2^1
    let t149 = circuit_add(in2, t148); // Eval sumdlogdiv_a_num step + (coeff_1 * xA2^1)
    let t150 = circuit_mul(in4, t1); // Eval sumdlogdiv_a_num step coeff_2 * xA2^2
    let t151 = circuit_add(t149, t150); // Eval sumdlogdiv_a_num step + (coeff_2 * xA2^2)
    let t152 = circuit_mul(in5, t3); // Eval sumdlogdiv_a_num step coeff_3 * xA2^3
    let t153 = circuit_add(t151, t152); // Eval sumdlogdiv_a_num step + (coeff_3 * xA2^3)
    let t154 = circuit_mul(in6, t5); // Eval sumdlogdiv_a_num step coeff_4 * xA2^4
    let t155 = circuit_add(t153, t154); // Eval sumdlogdiv_a_num step + (coeff_4 * xA2^4)
    let t156 = circuit_mul(in7, t7); // Eval sumdlogdiv_a_num step coeff_5 * xA2^5
    let t157 = circuit_add(t155, t156); // Eval sumdlogdiv_a_num step + (coeff_5 * xA2^5)
    let t158 = circuit_mul(in8, t9); // Eval sumdlogdiv_a_num step coeff_6 * xA2^6
    let t159 = circuit_add(t157, t158); // Eval sumdlogdiv_a_num step + (coeff_6 * xA2^6)
    let t160 = circuit_mul(in9, t11); // Eval sumdlogdiv_a_num step coeff_7 * xA2^7
    let t161 = circuit_add(t159, t160); // Eval sumdlogdiv_a_num step + (coeff_7 * xA2^7)
    let t162 = circuit_mul(in10, t13); // Eval sumdlogdiv_a_num step coeff_8 * xA2^8
    let t163 = circuit_add(t161, t162); // Eval sumdlogdiv_a_num step + (coeff_8 * xA2^8)
    let t164 = circuit_mul(in11, t15); // Eval sumdlogdiv_a_num step coeff_9 * xA2^9
    let t165 = circuit_add(t163, t164); // Eval sumdlogdiv_a_num step + (coeff_9 * xA2^9)
    let t166 = circuit_mul(in12, t17); // Eval sumdlogdiv_a_num step coeff_10 * xA2^10
    let t167 = circuit_add(t165, t166); // Eval sumdlogdiv_a_num step + (coeff_10 * xA2^10)
    let t168 = circuit_mul(in13, t19); // Eval sumdlogdiv_a_num step coeff_11 * xA2^11
    let t169 = circuit_add(t167, t168); // Eval sumdlogdiv_a_num step + (coeff_11 * xA2^11)
    let t170 = circuit_mul(in14, t21); // Eval sumdlogdiv_a_num step coeff_12 * xA2^12
    let t171 = circuit_add(t169, t170); // Eval sumdlogdiv_a_num step + (coeff_12 * xA2^12)
    let t172 = circuit_mul(in15, t23); // Eval sumdlogdiv_a_num step coeff_13 * xA2^13
    let t173 = circuit_add(t171, t172); // Eval sumdlogdiv_a_num step + (coeff_13 * xA2^13)
    let t174 = circuit_mul(in17, in1); // Eval sumdlogdiv_a_den step coeff_1 * xA2^1
    let t175 = circuit_add(in16, t174); // Eval sumdlogdiv_a_den step + (coeff_1 * xA2^1)
    let t176 = circuit_mul(in18, t1); // Eval sumdlogdiv_a_den step coeff_2 * xA2^2
    let t177 = circuit_add(t175, t176); // Eval sumdlogdiv_a_den step + (coeff_2 * xA2^2)
    let t178 = circuit_mul(in19, t3); // Eval sumdlogdiv_a_den step coeff_3 * xA2^3
    let t179 = circuit_add(t177, t178); // Eval sumdlogdiv_a_den step + (coeff_3 * xA2^3)
    let t180 = circuit_mul(in20, t5); // Eval sumdlogdiv_a_den step coeff_4 * xA2^4
    let t181 = circuit_add(t179, t180); // Eval sumdlogdiv_a_den step + (coeff_4 * xA2^4)
    let t182 = circuit_mul(in21, t7); // Eval sumdlogdiv_a_den step coeff_5 * xA2^5
    let t183 = circuit_add(t181, t182); // Eval sumdlogdiv_a_den step + (coeff_5 * xA2^5)
    let t184 = circuit_mul(in22, t9); // Eval sumdlogdiv_a_den step coeff_6 * xA2^6
    let t185 = circuit_add(t183, t184); // Eval sumdlogdiv_a_den step + (coeff_6 * xA2^6)
    let t186 = circuit_mul(in23, t11); // Eval sumdlogdiv_a_den step coeff_7 * xA2^7
    let t187 = circuit_add(t185, t186); // Eval sumdlogdiv_a_den step + (coeff_7 * xA2^7)
    let t188 = circuit_mul(in24, t13); // Eval sumdlogdiv_a_den step coeff_8 * xA2^8
    let t189 = circuit_add(t187, t188); // Eval sumdlogdiv_a_den step + (coeff_8 * xA2^8)
    let t190 = circuit_mul(in25, t15); // Eval sumdlogdiv_a_den step coeff_9 * xA2^9
    let t191 = circuit_add(t189, t190); // Eval sumdlogdiv_a_den step + (coeff_9 * xA2^9)
    let t192 = circuit_mul(in26, t17); // Eval sumdlogdiv_a_den step coeff_10 * xA2^10
    let t193 = circuit_add(t191, t192); // Eval sumdlogdiv_a_den step + (coeff_10 * xA2^10)
    let t194 = circuit_mul(in27, t19); // Eval sumdlogdiv_a_den step coeff_11 * xA2^11
    let t195 = circuit_add(t193, t194); // Eval sumdlogdiv_a_den step + (coeff_11 * xA2^11)
    let t196 = circuit_mul(in28, t21); // Eval sumdlogdiv_a_den step coeff_12 * xA2^12
    let t197 = circuit_add(t195, t196); // Eval sumdlogdiv_a_den step + (coeff_12 * xA2^12)
    let t198 = circuit_mul(in29, t23); // Eval sumdlogdiv_a_den step coeff_13 * xA2^13
    let t199 = circuit_add(t197, t198); // Eval sumdlogdiv_a_den step + (coeff_13 * xA2^13)
    let t200 = circuit_mul(in30, t25); // Eval sumdlogdiv_a_den step coeff_14 * xA2^14
    let t201 = circuit_add(t199, t200); // Eval sumdlogdiv_a_den step + (coeff_14 * xA2^14)
    let t202 = circuit_mul(in32, in1); // Eval sumdlogdiv_b_num step coeff_1 * xA2^1
    let t203 = circuit_add(in31, t202); // Eval sumdlogdiv_b_num step + (coeff_1 * xA2^1)
    let t204 = circuit_mul(in33, t1); // Eval sumdlogdiv_b_num step coeff_2 * xA2^2
    let t205 = circuit_add(t203, t204); // Eval sumdlogdiv_b_num step + (coeff_2 * xA2^2)
    let t206 = circuit_mul(in34, t3); // Eval sumdlogdiv_b_num step coeff_3 * xA2^3
    let t207 = circuit_add(t205, t206); // Eval sumdlogdiv_b_num step + (coeff_3 * xA2^3)
    let t208 = circuit_mul(in35, t5); // Eval sumdlogdiv_b_num step coeff_4 * xA2^4
    let t209 = circuit_add(t207, t208); // Eval sumdlogdiv_b_num step + (coeff_4 * xA2^4)
    let t210 = circuit_mul(in36, t7); // Eval sumdlogdiv_b_num step coeff_5 * xA2^5
    let t211 = circuit_add(t209, t210); // Eval sumdlogdiv_b_num step + (coeff_5 * xA2^5)
    let t212 = circuit_mul(in37, t9); // Eval sumdlogdiv_b_num step coeff_6 * xA2^6
    let t213 = circuit_add(t211, t212); // Eval sumdlogdiv_b_num step + (coeff_6 * xA2^6)
    let t214 = circuit_mul(in38, t11); // Eval sumdlogdiv_b_num step coeff_7 * xA2^7
    let t215 = circuit_add(t213, t214); // Eval sumdlogdiv_b_num step + (coeff_7 * xA2^7)
    let t216 = circuit_mul(in39, t13); // Eval sumdlogdiv_b_num step coeff_8 * xA2^8
    let t217 = circuit_add(t215, t216); // Eval sumdlogdiv_b_num step + (coeff_8 * xA2^8)
    let t218 = circuit_mul(in40, t15); // Eval sumdlogdiv_b_num step coeff_9 * xA2^9
    let t219 = circuit_add(t217, t218); // Eval sumdlogdiv_b_num step + (coeff_9 * xA2^9)
    let t220 = circuit_mul(in41, t17); // Eval sumdlogdiv_b_num step coeff_10 * xA2^10
    let t221 = circuit_add(t219, t220); // Eval sumdlogdiv_b_num step + (coeff_10 * xA2^10)
    let t222 = circuit_mul(in42, t19); // Eval sumdlogdiv_b_num step coeff_11 * xA2^11
    let t223 = circuit_add(t221, t222); // Eval sumdlogdiv_b_num step + (coeff_11 * xA2^11)
    let t224 = circuit_mul(in43, t21); // Eval sumdlogdiv_b_num step coeff_12 * xA2^12
    let t225 = circuit_add(t223, t224); // Eval sumdlogdiv_b_num step + (coeff_12 * xA2^12)
    let t226 = circuit_mul(in44, t23); // Eval sumdlogdiv_b_num step coeff_13 * xA2^13
    let t227 = circuit_add(t225, t226); // Eval sumdlogdiv_b_num step + (coeff_13 * xA2^13)
    let t228 = circuit_mul(in45, t25); // Eval sumdlogdiv_b_num step coeff_14 * xA2^14
    let t229 = circuit_add(t227, t228); // Eval sumdlogdiv_b_num step + (coeff_14 * xA2^14)
    let t230 = circuit_mul(in47, in1); // Eval sumdlogdiv_b_den step coeff_1 * xA2^1
    let t231 = circuit_add(in46, t230); // Eval sumdlogdiv_b_den step + (coeff_1 * xA2^1)
    let t232 = circuit_mul(in48, t1); // Eval sumdlogdiv_b_den step coeff_2 * xA2^2
    let t233 = circuit_add(t231, t232); // Eval sumdlogdiv_b_den step + (coeff_2 * xA2^2)
    let t234 = circuit_mul(in49, t3); // Eval sumdlogdiv_b_den step coeff_3 * xA2^3
    let t235 = circuit_add(t233, t234); // Eval sumdlogdiv_b_den step + (coeff_3 * xA2^3)
    let t236 = circuit_mul(in50, t5); // Eval sumdlogdiv_b_den step coeff_4 * xA2^4
    let t237 = circuit_add(t235, t236); // Eval sumdlogdiv_b_den step + (coeff_4 * xA2^4)
    let t238 = circuit_mul(in51, t7); // Eval sumdlogdiv_b_den step coeff_5 * xA2^5
    let t239 = circuit_add(t237, t238); // Eval sumdlogdiv_b_den step + (coeff_5 * xA2^5)
    let t240 = circuit_mul(in52, t9); // Eval sumdlogdiv_b_den step coeff_6 * xA2^6
    let t241 = circuit_add(t239, t240); // Eval sumdlogdiv_b_den step + (coeff_6 * xA2^6)
    let t242 = circuit_mul(in53, t11); // Eval sumdlogdiv_b_den step coeff_7 * xA2^7
    let t243 = circuit_add(t241, t242); // Eval sumdlogdiv_b_den step + (coeff_7 * xA2^7)
    let t244 = circuit_mul(in54, t13); // Eval sumdlogdiv_b_den step coeff_8 * xA2^8
    let t245 = circuit_add(t243, t244); // Eval sumdlogdiv_b_den step + (coeff_8 * xA2^8)
    let t246 = circuit_mul(in55, t15); // Eval sumdlogdiv_b_den step coeff_9 * xA2^9
    let t247 = circuit_add(t245, t246); // Eval sumdlogdiv_b_den step + (coeff_9 * xA2^9)
    let t248 = circuit_mul(in56, t17); // Eval sumdlogdiv_b_den step coeff_10 * xA2^10
    let t249 = circuit_add(t247, t248); // Eval sumdlogdiv_b_den step + (coeff_10 * xA2^10)
    let t250 = circuit_mul(in57, t19); // Eval sumdlogdiv_b_den step coeff_11 * xA2^11
    let t251 = circuit_add(t249, t250); // Eval sumdlogdiv_b_den step + (coeff_11 * xA2^11)
    let t252 = circuit_mul(in58, t21); // Eval sumdlogdiv_b_den step coeff_12 * xA2^12
    let t253 = circuit_add(t251, t252); // Eval sumdlogdiv_b_den step + (coeff_12 * xA2^12)
    let t254 = circuit_mul(in59, t23); // Eval sumdlogdiv_b_den step coeff_13 * xA2^13
    let t255 = circuit_add(t253, t254); // Eval sumdlogdiv_b_den step + (coeff_13 * xA2^13)
    let t256 = circuit_mul(in60, t25); // Eval sumdlogdiv_b_den step coeff_14 * xA2^14
    let t257 = circuit_add(t255, t256); // Eval sumdlogdiv_b_den step + (coeff_14 * xA2^14)
    let t258 = circuit_mul(in61, t27); // Eval sumdlogdiv_b_den step coeff_15 * xA2^15
    let t259 = circuit_add(t257, t258); // Eval sumdlogdiv_b_den step + (coeff_15 * xA2^15)
    let t260 = circuit_mul(in62, t29); // Eval sumdlogdiv_b_den step coeff_16 * xA2^16
    let t261 = circuit_add(t259, t260); // Eval sumdlogdiv_b_den step + (coeff_16 * xA2^16)
    let t262 = circuit_mul(in63, t31); // Eval sumdlogdiv_b_den step coeff_17 * xA2^17
    let t263 = circuit_add(t261, t262); // Eval sumdlogdiv_b_den step + (coeff_17 * xA2^17)

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t57, t85, t113, t147, t173, t201, t229, t263, t24, t25).new_inputs();
    // Prefill constants:

    // Fill inputs:
    circuit_inputs = circuit_inputs.next_2(xA0); // in0
    circuit_inputs = circuit_inputs.next_2(xA2); // in1

    for val in SumDlogDiv.a_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDiv.a_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDiv.b_num {
        circuit_inputs = circuit_inputs.next_2(*val);
    }

    for val in SumDlogDiv.b_den {
        circuit_inputs = circuit_inputs.next_2(*val);
    }
    // in2 - in63

    let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
    let A0_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t57),
        a_den: outputs.get_output(t85),
        b_num: outputs.get_output(t113),
        b_den: outputs.get_output(t147),
    };
    let A2_evals: FunctionFeltEvaluations = FunctionFeltEvaluations {
        a_num: outputs.get_output(t173),
        a_den: outputs.get_output(t201),
        b_num: outputs.get_output(t229),
        b_den: outputs.get_output(t263),
    };
    let xA0_power: u384 = outputs.get_output(t24);
    let xA2_power: u384 = outputs.get_output(t25);
    return (A0_evals, A2_evals, xA0_power, xA2_power);
}
