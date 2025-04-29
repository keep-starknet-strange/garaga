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
