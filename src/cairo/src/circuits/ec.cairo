use core::circuit::{
    RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point};
use core::option::Option;
fn get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let in7 = CircuitElement::<CircuitInput<7>> {};
    let in8 = CircuitElement::<CircuitInput<8>> {};
    let in9 = CircuitElement::<CircuitInput<9>> {};
    let in10 = CircuitElement::<CircuitInput<10>> {};
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t15,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t15);

    let res = array![o0];
    return res;
}

fn get_ADD_EC_POINT_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t6, t9,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t6);
    let o1 = outputs.get_output(t9);

    let res = array![o0, o1];
    return res;
}

fn get_DERIVE_POINT_FROM_X_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};

    // WITNESS stack
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in0, t0);
    let t2 = circuit_mul(in1, in0);
    let t3 = circuit_add(t2, in2);
    let t4 = circuit_add(t1, t3);
    let t5 = circuit_mul(in3, t4);
    let t6 = circuit_mul(in4, in4);
    let t7 = circuit_mul(in5, in5);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t4, t5, t6, t7,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t4);
    let o1 = outputs.get_output(t5);
    let o2 = outputs.get_output(t6);
    let o3 = outputs.get_output(t7);

    let res = array![o0, o1, o2, o3];
    return res;
}

fn get_DOUBLE_EC_POINT_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
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
    let t11 = circuit_sub(in2, t10);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t8, t11,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t8);
    let o1 = outputs.get_output(t11);

    let res = array![o0, o1];
    return res;
}

fn get_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let in7 = CircuitElement::<CircuitInput<7>> {};
    let in8 = CircuitElement::<CircuitInput<8>> {};
    let in9 = CircuitElement::<CircuitInput<9>> {};
    let in10 = CircuitElement::<CircuitInput<10>> {};
    let in11 = CircuitElement::<CircuitInput<11>> {};
    let in12 = CircuitElement::<CircuitInput<12>> {};
    let in13 = CircuitElement::<CircuitInput<13>> {};
    let in14 = CircuitElement::<CircuitInput<14>> {};
    let in15 = CircuitElement::<CircuitInput<15>> {};
    let in16 = CircuitElement::<CircuitInput<16>> {};
    let in17 = CircuitElement::<CircuitInput<17>> {};
    let in18 = CircuitElement::<CircuitInput<18>> {};
    let in19 = CircuitElement::<CircuitInput<19>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(in7, in0);
    let t9 = circuit_add(in6, t8);
    let t10 = circuit_mul(in9, in0);
    let t11 = circuit_add(in8, t10);
    let t12 = circuit_mul(in10, t0);
    let t13 = circuit_add(t11, t12);
    let t14 = circuit_inverse(t13);
    let t15 = circuit_mul(t9, t14);
    let t16 = circuit_mul(in12, in0);
    let t17 = circuit_add(in11, t16);
    let t18 = circuit_mul(in13, t0);
    let t19 = circuit_add(t17, t18);
    let t20 = circuit_mul(in15, in0);
    let t21 = circuit_add(in14, t20);
    let t22 = circuit_mul(in16, t0);
    let t23 = circuit_add(t21, t22);
    let t24 = circuit_mul(in17, t2);
    let t25 = circuit_add(t23, t24);
    let t26 = circuit_mul(in18, t4);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_mul(in19, t6);
    let t29 = circuit_add(t27, t28);
    let t30 = circuit_inverse(t29);
    let t31 = circuit_mul(t19, t30);
    let t32 = circuit_mul(in1, t31);
    let t33 = circuit_add(t15, t32);
    let t34 = circuit_mul(in7, in2);
    let t35 = circuit_add(in6, t34);
    let t36 = circuit_mul(in9, in2);
    let t37 = circuit_add(in8, t36);
    let t38 = circuit_mul(in10, t1);
    let t39 = circuit_add(t37, t38);
    let t40 = circuit_inverse(t39);
    let t41 = circuit_mul(t35, t40);
    let t42 = circuit_mul(in12, in2);
    let t43 = circuit_add(in11, t42);
    let t44 = circuit_mul(in13, t1);
    let t45 = circuit_add(t43, t44);
    let t46 = circuit_mul(in15, in2);
    let t47 = circuit_add(in14, t46);
    let t48 = circuit_mul(in16, t1);
    let t49 = circuit_add(t47, t48);
    let t50 = circuit_mul(in17, t3);
    let t51 = circuit_add(t49, t50);
    let t52 = circuit_mul(in18, t5);
    let t53 = circuit_add(t51, t52);
    let t54 = circuit_mul(in19, t7);
    let t55 = circuit_add(t53, t54);
    let t56 = circuit_inverse(t55);
    let t57 = circuit_mul(t45, t56);
    let t58 = circuit_mul(in3, t57);
    let t59 = circuit_add(t41, t58);
    let t60 = circuit_mul(in4, t33);
    let t61 = circuit_mul(in5, t59);
    let t62 = circuit_sub(t60, t61);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t62,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t62);

    let res = array![o0];
    return res;
}

fn get_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let in7 = CircuitElement::<CircuitInput<7>> {};
    let in8 = CircuitElement::<CircuitInput<8>> {};
    let in9 = CircuitElement::<CircuitInput<9>> {};
    let in10 = CircuitElement::<CircuitInput<10>> {};
    let in11 = CircuitElement::<CircuitInput<11>> {};
    let in12 = CircuitElement::<CircuitInput<12>> {};
    let in13 = CircuitElement::<CircuitInput<13>> {};
    let in14 = CircuitElement::<CircuitInput<14>> {};
    let in15 = CircuitElement::<CircuitInput<15>> {};
    let in16 = CircuitElement::<CircuitInput<16>> {};
    let in17 = CircuitElement::<CircuitInput<17>> {};
    let in18 = CircuitElement::<CircuitInput<18>> {};
    let in19 = CircuitElement::<CircuitInput<19>> {};
    let in20 = CircuitElement::<CircuitInput<20>> {};
    let in21 = CircuitElement::<CircuitInput<21>> {};
    let in22 = CircuitElement::<CircuitInput<22>> {};
    let in23 = CircuitElement::<CircuitInput<23>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(in7, in0);
    let t11 = circuit_add(in6, t10);
    let t12 = circuit_mul(in8, t0);
    let t13 = circuit_add(t11, t12);
    let t14 = circuit_mul(in10, in0);
    let t15 = circuit_add(in9, t14);
    let t16 = circuit_mul(in11, t0);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_mul(in12, t2);
    let t19 = circuit_add(t17, t18);
    let t20 = circuit_inverse(t19);
    let t21 = circuit_mul(t13, t20);
    let t22 = circuit_mul(in14, in0);
    let t23 = circuit_add(in13, t22);
    let t24 = circuit_mul(in15, t0);
    let t25 = circuit_add(t23, t24);
    let t26 = circuit_mul(in16, t2);
    let t27 = circuit_add(t25, t26);
    let t28 = circuit_mul(in18, in0);
    let t29 = circuit_add(in17, t28);
    let t30 = circuit_mul(in19, t0);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_mul(in20, t2);
    let t33 = circuit_add(t31, t32);
    let t34 = circuit_mul(in21, t4);
    let t35 = circuit_add(t33, t34);
    let t36 = circuit_mul(in22, t6);
    let t37 = circuit_add(t35, t36);
    let t38 = circuit_mul(in23, t8);
    let t39 = circuit_add(t37, t38);
    let t40 = circuit_inverse(t39);
    let t41 = circuit_mul(t27, t40);
    let t42 = circuit_mul(in1, t41);
    let t43 = circuit_add(t21, t42);
    let t44 = circuit_mul(in7, in2);
    let t45 = circuit_add(in6, t44);
    let t46 = circuit_mul(in8, t1);
    let t47 = circuit_add(t45, t46);
    let t48 = circuit_mul(in10, in2);
    let t49 = circuit_add(in9, t48);
    let t50 = circuit_mul(in11, t1);
    let t51 = circuit_add(t49, t50);
    let t52 = circuit_mul(in12, t3);
    let t53 = circuit_add(t51, t52);
    let t54 = circuit_inverse(t53);
    let t55 = circuit_mul(t47, t54);
    let t56 = circuit_mul(in14, in2);
    let t57 = circuit_add(in13, t56);
    let t58 = circuit_mul(in15, t1);
    let t59 = circuit_add(t57, t58);
    let t60 = circuit_mul(in16, t3);
    let t61 = circuit_add(t59, t60);
    let t62 = circuit_mul(in18, in2);
    let t63 = circuit_add(in17, t62);
    let t64 = circuit_mul(in19, t1);
    let t65 = circuit_add(t63, t64);
    let t66 = circuit_mul(in20, t3);
    let t67 = circuit_add(t65, t66);
    let t68 = circuit_mul(in21, t5);
    let t69 = circuit_add(t67, t68);
    let t70 = circuit_mul(in22, t7);
    let t71 = circuit_add(t69, t70);
    let t72 = circuit_mul(in23, t9);
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_inverse(t73);
    let t75 = circuit_mul(t61, t74);
    let t76 = circuit_mul(in3, t75);
    let t77 = circuit_add(t55, t76);
    let t78 = circuit_mul(in4, t43);
    let t79 = circuit_mul(in5, t77);
    let t80 = circuit_sub(t78, t79);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t80,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t80);

    let res = array![o0];
    return res;
}

fn get_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let in7 = CircuitElement::<CircuitInput<7>> {};
    let in8 = CircuitElement::<CircuitInput<8>> {};
    let in9 = CircuitElement::<CircuitInput<9>> {};
    let in10 = CircuitElement::<CircuitInput<10>> {};
    let in11 = CircuitElement::<CircuitInput<11>> {};
    let in12 = CircuitElement::<CircuitInput<12>> {};
    let in13 = CircuitElement::<CircuitInput<13>> {};
    let in14 = CircuitElement::<CircuitInput<14>> {};
    let in15 = CircuitElement::<CircuitInput<15>> {};
    let in16 = CircuitElement::<CircuitInput<16>> {};
    let in17 = CircuitElement::<CircuitInput<17>> {};
    let in18 = CircuitElement::<CircuitInput<18>> {};
    let in19 = CircuitElement::<CircuitInput<19>> {};
    let in20 = CircuitElement::<CircuitInput<20>> {};
    let in21 = CircuitElement::<CircuitInput<21>> {};
    let in22 = CircuitElement::<CircuitInput<22>> {};
    let in23 = CircuitElement::<CircuitInput<23>> {};
    let in24 = CircuitElement::<CircuitInput<24>> {};
    let in25 = CircuitElement::<CircuitInput<25>> {};
    let in26 = CircuitElement::<CircuitInput<26>> {};
    let in27 = CircuitElement::<CircuitInput<27>> {};
    let t0 = circuit_mul(in0, in0);
    let t1 = circuit_mul(in2, in2);
    let t2 = circuit_mul(t0, in0);
    let t3 = circuit_mul(t1, in2);
    let t4 = circuit_mul(t2, in0);
    let t5 = circuit_mul(t3, in2);
    let t6 = circuit_mul(t4, in0);
    let t7 = circuit_mul(t5, in2);
    let t8 = circuit_mul(t6, in0);
    let t9 = circuit_mul(t7, in2);
    let t10 = circuit_mul(t8, in0);
    let t11 = circuit_mul(t9, in2);
    let t12 = circuit_mul(in7, in0);
    let t13 = circuit_add(in6, t12);
    let t14 = circuit_mul(in8, t0);
    let t15 = circuit_add(t13, t14);
    let t16 = circuit_mul(in9, t2);
    let t17 = circuit_add(t15, t16);
    let t18 = circuit_mul(in11, in0);
    let t19 = circuit_add(in10, t18);
    let t20 = circuit_mul(in12, t0);
    let t21 = circuit_add(t19, t20);
    let t22 = circuit_mul(in13, t2);
    let t23 = circuit_add(t21, t22);
    let t24 = circuit_mul(in14, t4);
    let t25 = circuit_add(t23, t24);
    let t26 = circuit_inverse(t25);
    let t27 = circuit_mul(t17, t26);
    let t28 = circuit_mul(in16, in0);
    let t29 = circuit_add(in15, t28);
    let t30 = circuit_mul(in17, t0);
    let t31 = circuit_add(t29, t30);
    let t32 = circuit_mul(in18, t2);
    let t33 = circuit_add(t31, t32);
    let t34 = circuit_mul(in19, t4);
    let t35 = circuit_add(t33, t34);
    let t36 = circuit_mul(in21, in0);
    let t37 = circuit_add(in20, t36);
    let t38 = circuit_mul(in22, t0);
    let t39 = circuit_add(t37, t38);
    let t40 = circuit_mul(in23, t2);
    let t41 = circuit_add(t39, t40);
    let t42 = circuit_mul(in24, t4);
    let t43 = circuit_add(t41, t42);
    let t44 = circuit_mul(in25, t6);
    let t45 = circuit_add(t43, t44);
    let t46 = circuit_mul(in26, t8);
    let t47 = circuit_add(t45, t46);
    let t48 = circuit_mul(in27, t10);
    let t49 = circuit_add(t47, t48);
    let t50 = circuit_inverse(t49);
    let t51 = circuit_mul(t35, t50);
    let t52 = circuit_mul(in1, t51);
    let t53 = circuit_add(t27, t52);
    let t54 = circuit_mul(in7, in2);
    let t55 = circuit_add(in6, t54);
    let t56 = circuit_mul(in8, t1);
    let t57 = circuit_add(t55, t56);
    let t58 = circuit_mul(in9, t3);
    let t59 = circuit_add(t57, t58);
    let t60 = circuit_mul(in11, in2);
    let t61 = circuit_add(in10, t60);
    let t62 = circuit_mul(in12, t1);
    let t63 = circuit_add(t61, t62);
    let t64 = circuit_mul(in13, t3);
    let t65 = circuit_add(t63, t64);
    let t66 = circuit_mul(in14, t5);
    let t67 = circuit_add(t65, t66);
    let t68 = circuit_inverse(t67);
    let t69 = circuit_mul(t59, t68);
    let t70 = circuit_mul(in16, in2);
    let t71 = circuit_add(in15, t70);
    let t72 = circuit_mul(in17, t1);
    let t73 = circuit_add(t71, t72);
    let t74 = circuit_mul(in18, t3);
    let t75 = circuit_add(t73, t74);
    let t76 = circuit_mul(in19, t5);
    let t77 = circuit_add(t75, t76);
    let t78 = circuit_mul(in21, in2);
    let t79 = circuit_add(in20, t78);
    let t80 = circuit_mul(in22, t1);
    let t81 = circuit_add(t79, t80);
    let t82 = circuit_mul(in23, t3);
    let t83 = circuit_add(t81, t82);
    let t84 = circuit_mul(in24, t5);
    let t85 = circuit_add(t83, t84);
    let t86 = circuit_mul(in25, t7);
    let t87 = circuit_add(t85, t86);
    let t88 = circuit_mul(in26, t9);
    let t89 = circuit_add(t87, t88);
    let t90 = circuit_mul(in27, t11);
    let t91 = circuit_add(t89, t90);
    let t92 = circuit_inverse(t91);
    let t93 = circuit_mul(t77, t92);
    let t94 = circuit_mul(in3, t93);
    let t95 = circuit_add(t69, t94);
    let t96 = circuit_mul(in4, t53);
    let t97 = circuit_mul(in5, t95);
    let t98 = circuit_sub(t96, t97);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t98,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t98);

    let res = array![o0];
    return res;
}

fn get_IS_ON_CURVE_G1_G2_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let in7 = CircuitElement::<CircuitInput<7>> {};
    let in8 = CircuitElement::<CircuitInput<8>> {};
    let in9 = CircuitElement::<CircuitInput<9>> {};
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
    let t14 = circuit_mul(in2, t11);
    let t15 = circuit_mul(in3, t13);
    let t16 = circuit_sub(t14, t15);
    let t17 = circuit_mul(in2, t13);
    let t18 = circuit_mul(in3, t11);
    let t19 = circuit_add(t17, t18);
    let t20 = circuit_mul(in6, in2);
    let t21 = circuit_mul(in6, in3);
    let t22 = circuit_add(t20, in8);
    let t23 = circuit_add(t21, in9);
    let t24 = circuit_add(t16, t22);
    let t25 = circuit_add(t19, t23);
    let t26 = circuit_sub(t0, t3);
    let t27 = circuit_sub(t6, t24);
    let t28 = circuit_sub(t8, t25);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t26, t27, t28,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t26);
    let o1 = outputs.get_output(t27);
    let o2 = outputs.get_output(t28);

    let res = array![o0, o1, o2];
    return res;
}

fn get_IS_ON_CURVE_G1_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let t0 = circuit_mul(in1, in1);
    let t1 = circuit_mul(in0, in0);
    let t2 = circuit_mul(in0, t1);
    let t3 = circuit_mul(in2, in0);
    let t4 = circuit_add(t3, in3);
    let t5 = circuit_add(t2, t4);
    let t6 = circuit_sub(t0, t5);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t6,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t6);

    let res = array![o0];
    return res;
}

fn get_RHS_FINALIZE_ACC_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
    let in5 = CircuitElement::<CircuitInput<5>> {};
    let in6 = CircuitElement::<CircuitInput<6>> {};
    let t0 = circuit_sub(in4, in5);
    let t1 = circuit_mul(in2, in5);
    let t2 = circuit_add(t1, in3);
    let t3 = circuit_sub(in0, in6);
    let t4 = circuit_sub(t3, t2);
    let t5 = circuit_inverse(t4);
    let t6 = circuit_mul(t0, t5);
    let t7 = circuit_add(in1, t6);

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t7,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t7);

    let res = array![o0];
    return res;
}

fn get_SLOPE_INTERCEPT_SAME_POINT_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};

    // INPUT stack
    let in2 = CircuitElement::<CircuitInput<2>> {};
    let in3 = CircuitElement::<CircuitInput<3>> {};
    let in4 = CircuitElement::<CircuitInput<4>> {};
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t5, t7, t10, t14, t31, t29,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t5);
    let o1 = outputs.get_output(t7);
    let o2 = outputs.get_output(t10);
    let o3 = outputs.get_output(t14);
    let o4 = outputs.get_output(t31);
    let o5 = outputs.get_output(t29);

    let res = array![o0, o1, o2, o3, o4, o5];
    return res;
}


#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs,
    };

    use super::{
        get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit, get_ADD_EC_POINT_circuit,
        get_DERIVE_POINT_FROM_X_circuit, get_DOUBLE_EC_POINT_circuit,
        get_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit, get_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit,
        get_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit, get_IS_ON_CURVE_G1_G2_circuit,
        get_IS_ON_CURVE_G1_circuit, get_RHS_FINALIZE_ACC_circuit,
        get_SLOPE_INTERCEPT_SAME_POINT_circuit
    };

    #[test]
    fn test_get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 38478084703374874537639596153,
                limb1: 32815016693131147500705109325,
                limb2: 59812757887808418955886740269,
                limb3: 3418426356571336021683806391
            },
            u384 {
                limb0: 13895792033117584804650311205,
                limb1: 61768864410012368983742641165,
                limb2: 38842463671231965080779437830,
                limb3: 2746950517954702035784765236
            },
            u384 {
                limb0: 78316797952862049579891941595,
                limb1: 9335985220380020415724715767,
                limb2: 33497038552840785775179774362,
                limb3: 192419594671358017032003950
            },
            u384 {
                limb0: 19030959434133007784182351486,
                limb1: 18067653269358796646554112089,
                limb2: 31093752624445874905059918307,
                limb3: 1085810049515202791074903355
            },
            u384 {
                limb0: 68049412666289964740463100424,
                limb1: 52757747430618260898010303067,
                limb2: 66654091105881792281275919333,
                limb3: 6935093947630925217430093830
            },
            u384 {
                limb0: 71071503335546601037716075418,
                limb1: 66725512618402176713606005719,
                limb2: 10665400091320263770770929067,
                limb3: 3816892642662802787025210355
            },
            u384 { limb0: 72162155754229987035486746492, limb1: 1857079568, limb2: 0, limb3: 0 },
            u384 { limb0: 28624214975065508841753886528, limb1: 46076153, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 54880396502181392957329877674,
                limb1: 31935979117156477062286671870,
                limb2: 20826981314825584179608359615,
                limb3: 8047903782086192180586325942
            }
        ];
        let output = array![
            u384 {
                limb0: 16483557007176432041817108239,
                limb1: 31551480929528949957638714948,
                limb2: 58328715601600627791870691726,
                limb3: 5802202314587402029776730711
            }
        ];
        let result = get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 49004183427130274765757209906,
                limb1: 28651678594242496095872415535,
                limb2: 886774594345458111,
                limb3: 0
            },
            u384 {
                limb0: 59944514004050895099943652078,
                limb1: 752845018923284327252448144,
                limb2: 2850540727481550486,
                limb3: 0
            },
            u384 {
                limb0: 11821401101418842552472433741,
                limb1: 9861056098048424797180451009,
                limb2: 936083819655826342,
                limb3: 0
            },
            u384 {
                limb0: 65917823739508736469247779160,
                limb1: 3098786748851022159658983169,
                limb2: 2488262035068768042,
                limb3: 0
            },
            u384 {
                limb0: 48185423340381280141810272235,
                limb1: 63301634627173454805882398894,
                limb2: 123310375818212584,
                limb3: 0
            },
            u384 {
                limb0: 17014569491207493468992222046,
                limb1: 59600013555630617834451983488,
                limb2: 1302256991438570352,
                limb3: 0
            },
            u384 { limb0: 51525863270911958056661166738, limb1: 1259095008, limb2: 0, limb3: 0 },
            u384 { limb0: 71439464234331032902178403969, limb1: 96096, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 32324006162389411176778628422,
                limb1: 57042285082623239461879769745,
                limb2: 3486998266802970665,
                limb3: 0
            }
        ];
        let output = array![
            u384 {
                limb0: 2973201773529233144369375558,
                limb1: 58461038200914366513766420182,
                limb2: 512998820134196565,
                limb3: 0
            }
        ];
        let result = get_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_ADD_EC_POINT_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 42542926892572899956576343537,
                limb1: 57332310572799097912253594712,
                limb2: 64682531830089178655477589526,
                limb3: 5062221758561910268530330298
            },
            u384 {
                limb0: 20654157080518180770878893183,
                limb1: 37457041561105068070810760479,
                limb2: 69663006599517997469427117684,
                limb3: 1990717483030619553126794563
            },
            u384 {
                limb0: 57257103732257040113013690712,
                limb1: 4437301562055852869229456576,
                limb2: 63756066861892486319288470350,
                limb3: 425780330185476655204405611
            },
            u384 {
                limb0: 49910047622314194874295112117,
                limb1: 36002102386917142489939696052,
                limb2: 33481827470806150970597261218,
                limb3: 2109917533894221554083162639
            }
        ];
        let output = array![
            u384 {
                limb0: 30778583685058258434973191546,
                limb1: 31408663298101790777891996256,
                limb2: 66578029790031122228672146296,
                limb3: 6966272104076066861183834716
            },
            u384 {
                limb0: 52045277318082941178000960246,
                limb1: 56135805389602277344629703403,
                limb2: 24269861435728572419680128571,
                limb3: 7947590256458366497420638376
            }
        ];
        let result = get_ADD_EC_POINT_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_ADD_EC_POINT_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 18136750393035509461112022750,
                limb1: 47936843852685121872255482680,
                limb2: 456202489926302475,
                limb3: 0
            },
            u384 {
                limb0: 32356989520534189092065547106,
                limb1: 54844007975459957403137643979,
                limb2: 345827457653299144,
                limb3: 0
            },
            u384 {
                limb0: 72213660346953176646925933246,
                limb1: 45564150586434423168127661127,
                limb2: 2271214273907542899,
                limb3: 0
            },
            u384 {
                limb0: 17047951238784578147151354743,
                limb1: 65948381321874561617264693272,
                limb2: 272339544062968857,
                limb3: 0
            }
        ];
        let output = array![
            u384 {
                limb0: 28712659794186920652270178847,
                limb1: 8740698466052822869112370138,
                limb2: 2747806911160292621,
                limb3: 0
            },
            u384 {
                limb0: 38237376836212064039344085733,
                limb1: 76577223820084215379853692308,
                limb2: 193867352868552600,
                limb3: 0
            }
        ];
        let result = get_ADD_EC_POINT_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_DERIVE_POINT_FROM_X_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 11240467793431437190924717465,
                limb1: 76994746119436984022304040447,
                limb2: 105789404023956686,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 28359953623331170064732172650,
                limb1: 40650747581348910716225838594,
                limb2: 41784223201981341788666909183,
                limb3: 5690317802279913245341097577
            },
            u384 {
                limb0: 54547230379895061873080712936,
                limb1: 58080284509733778024104172041,
                limb2: 4470544462028519413240057983,
                limb3: 975145842667355374850640848
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 54547230379895061873080712936,
                limb1: 58080284509733778024104172041,
                limb2: 4470544462028519413240057983,
                limb3: 975145842667355374850640848
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let result = get_DERIVE_POINT_FROM_X_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_DERIVE_POINT_FROM_X_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 15753541456266781052776419251,
                limb1: 55564688894591871250890297265,
                limb2: 483673423642446070,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 24052524442701269673361695094,
                limb1: 69466788270736004859124987265,
                limb2: 1400250215477140164,
                limb3: 0
            },
            u384 {
                limb0: 39833567165714397843306456859,
                limb1: 72129917215320437521951241714,
                limb2: 713752379628449828,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 39833567165714397843306456859,
                limb1: 72129917215320437521951241714,
                limb2: 713752379628449828,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let result = get_DERIVE_POINT_FROM_X_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_DOUBLE_EC_POINT_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 23727275140042211734319435903,
                limb1: 27021246570474065856336553656,
                limb2: 56554788171289091015723441712,
                limb3: 5512711356183448420616652251
            },
            u384 {
                limb0: 71799788901023822362769566133,
                limb1: 7194574471174330662178442688,
                limb2: 6731702511406729753270516338,
                limb3: 4384057705654264290695410502
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 18613200948661970389879295108,
                limb1: 46448104799496305650672407482,
                limb2: 40913863319634703976950568801,
                limb3: 5316919088916316047833750846
            },
            u384 {
                limb0: 11336512304885792468638514101,
                limb1: 30322647220061302355888490685,
                limb2: 44335962531610160048440164266,
                limb3: 7801949412290396203445002288
            }
        ];
        let result = get_DOUBLE_EC_POINT_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_DOUBLE_EC_POINT_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 15414899119486199844306498064,
                limb1: 67516702193113279786976868262,
                limb2: 2335849229440770959,
                limb3: 0
            },
            u384 {
                limb0: 38903580336568434938780221445,
                limb1: 50787062514492248333130409082,
                limb2: 914129056396043197,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 33264874772861278424489988998,
                limb1: 39704629667044471016702771345,
                limb2: 3292403123383451092,
                limb3: 0
            },
            u384 {
                limb0: 14889007883280780966271834778,
                limb1: 66208083862978982543095281597,
                limb2: 1921196844315273675,
                limb3: 0
            }
        ];
        let result = get_DOUBLE_EC_POINT_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 27325004453265602167015734849,
                limb1: 28057412701760479961981311679,
                limb2: 65128961294171032306493031285,
                limb3: 6012752843374946925861737921
            },
            u384 {
                limb0: 79036116297048505654147411930,
                limb1: 6323385910661575064128623192,
                limb2: 3700768239101563166778462449,
                limb3: 3578090092010939467237975487
            },
            u384 {
                limb0: 70077671161031881965060732941,
                limb1: 74490406503161172371668394238,
                limb2: 70835594594908818552646755113,
                limb3: 1136626293842092267028984985
            },
            u384 {
                limb0: 46662704051824572458519371537,
                limb1: 25107381537738089304168011676,
                limb2: 65689948904467555823113688239,
                limb3: 62243563149141403840176594
            },
            u384 {
                limb0: 13743512440374266572644076392,
                limb1: 51323354486951727504623535746,
                limb2: 65688903908733555253892307691,
                limb3: 3544000489230808199430903929
            },
            u384 {
                limb0: 40859728471747492819989496607,
                limb1: 57194666247888560214532173239,
                limb2: 61428618716523076532663701176,
                limb3: 787950299486168152701792025
            },
            u384 {
                limb0: 39634866370069687440400174302,
                limb1: 52928229229714358210403009006,
                limb2: 5710408984783803410372829878,
                limb3: 7348821372465763618084254914
            },
            u384 {
                limb0: 1484857796432718225625862704,
                limb1: 6168911286250600643505058901,
                limb2: 45616340403452241959386824179,
                limb3: 4005210228930851427261453106
            },
            u384 {
                limb0: 65919883969018226631161771277,
                limb1: 28668923958285987759539243157,
                limb2: 66906944064165384822654479890,
                limb3: 4314731314494644167894489272
            },
            u384 {
                limb0: 41512589782797861685987132624,
                limb1: 68970049872239205242722465599,
                limb2: 26899013648034368802245191499,
                limb3: 7716009651118108594528645710
            },
            u384 {
                limb0: 40444652772648687589091098333,
                limb1: 42038845225510659683146990343,
                limb2: 71774593427978477334105438183,
                limb3: 3477123328710087276490056877
            },
            u384 {
                limb0: 64883792658241509173914600526,
                limb1: 11701194222123139740097822756,
                limb2: 11602506507820408817860746629,
                limb3: 1718251107793591013856453163
            },
            u384 {
                limb0: 60230460739028329472600756716,
                limb1: 5970101589329475665330163571,
                limb2: 61231333974211738332160422598,
                limb3: 4594768647679447739444314165
            },
            u384 {
                limb0: 68472691837791641332346824903,
                limb1: 25047103964281551044249497795,
                limb2: 5410195014964960588995044579,
                limb3: 6252935348120971477187769943
            },
            u384 {
                limb0: 21761889760686717831139926994,
                limb1: 27883735366272412575550884096,
                limb2: 24593043509918168245585630345,
                limb3: 372444161509624846876983657
            },
            u384 {
                limb0: 65893795917781118287222954166,
                limb1: 51075739697685388808763072877,
                limb2: 67763322324951012100215373182,
                limb3: 5883481544476846262570560505
            },
            u384 {
                limb0: 51643884131934573367923841161,
                limb1: 47933500582545049764355929651,
                limb2: 11952445511448745569037767396,
                limb3: 4461764811029420700878064370
            },
            u384 {
                limb0: 71236166552923914896542734683,
                limb1: 77832604571724359931940198877,
                limb2: 39974490405539226533544944215,
                limb3: 387644863768982540782179782
            },
            u384 {
                limb0: 32386047933525779174386284223,
                limb1: 53787818865071521340915405568,
                limb2: 62528999444477412296449002587,
                limb3: 3314206634274336323330492510
            },
            u384 {
                limb0: 69188343332762451578483774268,
                limb1: 6457252387363983399172627918,
                limb2: 11205110634875311102857472699,
                limb3: 3072386268476096179881370947
            }
        ];
        let output = array![
            u384 {
                limb0: 3576021129316308078871677670,
                limb1: 64039478493793642266994117322,
                limb2: 47300579389644751699518245063,
                limb3: 4395342302979951666354813943
            }
        ];
        let result = get_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 21434520051224414662948715111,
                limb1: 49698523261281665963339425661,
                limb2: 1521160436434597537,
                limb3: 0
            },
            u384 {
                limb0: 11571642610103420718064859258,
                limb1: 33444331411416146305460947219,
                limb2: 1234855016161005327,
                limb3: 0
            },
            u384 {
                limb0: 31693181093045987208973674102,
                limb1: 38790413884557369255198758498,
                limb2: 367892769066037029,
                limb3: 0
            },
            u384 {
                limb0: 12387684762251010114135401905,
                limb1: 1967729551448664404422441426,
                limb2: 1153127186338137407,
                limb3: 0
            },
            u384 {
                limb0: 58747077056269502981891371319,
                limb1: 57254653551925251484008793713,
                limb2: 935214117622969527,
                limb3: 0
            },
            u384 {
                limb0: 12620009132754218823150382816,
                limb1: 75861949607816703280808267463,
                limb2: 2832037389206930801,
                limb3: 0
            },
            u384 {
                limb0: 50706004741235505824374286054,
                limb1: 17399706410744361015302644164,
                limb2: 1495490156365537583,
                limb3: 0
            },
            u384 {
                limb0: 21212618155246119223296100348,
                limb1: 72346096691914122142885723265,
                limb2: 2615656317337110500,
                limb3: 0
            },
            u384 {
                limb0: 36353989240308415886186760805,
                limb1: 11062654041544048724206107523,
                limb2: 3435655280134912760,
                limb3: 0
            },
            u384 {
                limb0: 20816534944806424698517049979,
                limb1: 33944024505433056312930618374,
                limb2: 2691070638576613493,
                limb3: 0
            },
            u384 {
                limb0: 17376380609947366087200808087,
                limb1: 10959769756511551589062852068,
                limb2: 2275940104762577064,
                limb3: 0
            },
            u384 {
                limb0: 3732943742251867073256216280,
                limb1: 12109337091711568564464991638,
                limb2: 737786736022670788,
                limb3: 0
            },
            u384 {
                limb0: 33446958264690672250627929740,
                limb1: 30484406967661230060789973812,
                limb2: 2748050309618191650,
                limb3: 0
            },
            u384 {
                limb0: 57101465837943970912592227216,
                limb1: 70100163348132701606650266443,
                limb2: 3462812660242244404,
                limb3: 0
            },
            u384 {
                limb0: 50782225707178327644272764872,
                limb1: 23253475783427390028081642863,
                limb2: 729373899284596378,
                limb3: 0
            },
            u384 {
                limb0: 14154260307428426626128832863,
                limb1: 8430733981373538618366717212,
                limb2: 2883688166359453206,
                limb3: 0
            },
            u384 {
                limb0: 50622794262632962056429953192,
                limb1: 15759361183541481138399097300,
                limb2: 1724373273432586621,
                limb3: 0
            },
            u384 {
                limb0: 25682288985038139691477859025,
                limb1: 8863074271803315465722610565,
                limb2: 1673953324238989361,
                limb3: 0
            },
            u384 {
                limb0: 65891331720847994941238143664,
                limb1: 18971366953634547639802972973,
                limb2: 1110824133795786522,
                limb3: 0
            },
            u384 {
                limb0: 60261111753521420547363694920,
                limb1: 9963774478104653690402991718,
                limb2: 3042563642015761245,
                limb3: 0
            }
        ];
        let output = array![
            u384 {
                limb0: 42846968037833627668776483246,
                limb1: 47679015283652338518297567899,
                limb2: 725242862010720392,
                limb3: 0
            }
        ];
        let result = get_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 31826934357990760171039338528,
                limb1: 48592498669857133085471836465,
                limb2: 3635373580518070045183726056,
                limb3: 6995789924419480115381727581
            },
            u384 {
                limb0: 39366614399684612648701725577,
                limb1: 12659269804809850884100495906,
                limb2: 46558840120410941588314335917,
                limb3: 6806276165636397406314393157
            },
            u384 {
                limb0: 72938025244469527563768719105,
                limb1: 70168287809525553887145278971,
                limb2: 39038379439933239364829955885,
                limb3: 1850388459594201370824715049
            },
            u384 {
                limb0: 54138957550694998559921740207,
                limb1: 51286777467117012384850849630,
                limb2: 17303404028583960332359330448,
                limb3: 5272002203038563963238810618
            },
            u384 {
                limb0: 24706224934660222200290825742,
                limb1: 73603927618492642550433853948,
                limb2: 73155039486994602658955188131,
                limb3: 5255330963949126509594090436
            },
            u384 {
                limb0: 3188109508430755571438973884,
                limb1: 16858935943476844807595590412,
                limb2: 42990091484547124977056401511,
                limb3: 3409168792007077656255077202
            },
            u384 {
                limb0: 24527604035999034834774190482,
                limb1: 50982788422952187482630095945,
                limb2: 64427136155275909925863840702,
                limb3: 6960499807985050304046897029
            },
            u384 {
                limb0: 58531759711808383649221879720,
                limb1: 72291577403896224041541182895,
                limb2: 51183359257298473177267156683,
                limb3: 5035826072873068791742005707
            },
            u384 {
                limb0: 28727947029437481285421417512,
                limb1: 75359397072871697732980562140,
                limb2: 75082015525036224915315184788,
                limb3: 1901527742744845107276730430
            },
            u384 {
                limb0: 10899050601337473659339454876,
                limb1: 23435064424650012642085862588,
                limb2: 8013196760015309161949328741,
                limb3: 5345630660498406587562980347
            },
            u384 {
                limb0: 70012514271906009292215052715,
                limb1: 52443437491373544600286971636,
                limb2: 60713143533576461949234196628,
                limb3: 5914842291746763548965425018
            },
            u384 {
                limb0: 12854548382922917635362436769,
                limb1: 54892886997441064982891195332,
                limb2: 64099047259033196224359869057,
                limb3: 7142250476734139045971785320
            },
            u384 {
                limb0: 32551573033622289762900204895,
                limb1: 57011450725859592029042031081,
                limb2: 35193047411000198141989275500,
                limb3: 7451321137992434450521127750
            },
            u384 {
                limb0: 29143363060640586493994859975,
                limb1: 45193280277805111586509390871,
                limb2: 36578056044563190305727463176,
                limb3: 7706167186957135336967892173
            },
            u384 {
                limb0: 50799436653757454648317326832,
                limb1: 29410452890333661523725516081,
                limb2: 8127995647235885780484645338,
                limb3: 5109319089647837791693725659
            },
            u384 {
                limb0: 74982583474689713726428165043,
                limb1: 64705898018645326738255960663,
                limb2: 27696982942629252932705263542,
                limb3: 4108939987014244114866858125
            },
            u384 {
                limb0: 39773101200371937909888138844,
                limb1: 30595231670372858115443650737,
                limb2: 29703642363862427933817255587,
                limb3: 3156102069708313905717796689
            },
            u384 {
                limb0: 20276382521889841900792849399,
                limb1: 11846164822982753144093877805,
                limb2: 57617475876843178788294389570,
                limb3: 4191712141783400933094297842
            },
            u384 {
                limb0: 22825758685568696302895021558,
                limb1: 9653820561923806317388365183,
                limb2: 33262006256726018199781985991,
                limb3: 6168017114877521635528824625
            },
            u384 {
                limb0: 8783066888185430758014674421,
                limb1: 39600550623944603897670216320,
                limb2: 1302142466182847519133000650,
                limb3: 5694994224326798030395657354
            },
            u384 {
                limb0: 11375329534802032929293707337,
                limb1: 123939641512362347806641420,
                limb2: 19059462848782106170317089074,
                limb3: 1855067089305470166529148021
            },
            u384 {
                limb0: 6783036319236504817570692312,
                limb1: 28569973096883116325040493930,
                limb2: 41678723051693783764408954521,
                limb3: 7788250479879433238675518614
            },
            u384 {
                limb0: 43904441402315001835563469530,
                limb1: 69192444888604997060425720065,
                limb2: 50363028747390495690977887696,
                limb3: 3697007810297833246992017255
            },
            u384 {
                limb0: 1286842371610342287582640437,
                limb1: 5352619560304367199572361474,
                limb2: 58069570161891803167176587772,
                limb3: 1026637227643095284484406888
            }
        ];
        let output = array![
            u384 {
                limb0: 49702571329078702584620176662,
                limb1: 64654345233211336803552957702,
                limb2: 13186727975479437815805602828,
                limb3: 105643089136427128975304192
            }
        ];
        let result = get_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 61104846999329315373130150309,
                limb1: 4023371550682052897723784491,
                limb2: 50134395404603288,
                limb3: 0
            },
            u384 {
                limb0: 59796229081130554011131769559,
                limb1: 66999178271014489460978285419,
                limb2: 2321219689592162008,
                limb3: 0
            },
            u384 {
                limb0: 42851794293748154582085547659,
                limb1: 46011245161980488585751416770,
                limb2: 1318740873226823,
                limb3: 0
            },
            u384 {
                limb0: 20353673359042888461878182162,
                limb1: 40481757174109770563765781685,
                limb2: 3423890140823077306,
                limb3: 0
            },
            u384 {
                limb0: 10924545337514974729622481734,
                limb1: 24432880423538602572280097485,
                limb2: 2130101000843340635,
                limb3: 0
            },
            u384 {
                limb0: 48467159748512293259663211880,
                limb1: 70096765586308122968596514008,
                limb2: 2814231935888252195,
                limb3: 0
            },
            u384 {
                limb0: 16780382128897181514445538463,
                limb1: 59838273669990558368820708958,
                limb2: 3181452939807736618,
                limb3: 0
            },
            u384 {
                limb0: 24696709242774527107338773215,
                limb1: 53216523692839575827144530938,
                limb2: 1722098115426543758,
                limb3: 0
            },
            u384 {
                limb0: 41006582966044273720093528993,
                limb1: 19641106652278722442122533007,
                limb2: 295267350318793679,
                limb3: 0
            },
            u384 {
                limb0: 46610618464792213397244266139,
                limb1: 46621029220708458653278915843,
                limb2: 33161911589677750,
                limb3: 0
            },
            u384 {
                limb0: 50001128045961016144101677654,
                limb1: 5340003729476240406672988640,
                limb2: 144866699572255526,
                limb3: 0
            },
            u384 {
                limb0: 5613897685387589951369056449,
                limb1: 22063242033468542869682764880,
                limb2: 2238579258681335975,
                limb3: 0
            },
            u384 {
                limb0: 10482824513005329891246750010,
                limb1: 69909589412599764784906084907,
                limb2: 2657307194884612442,
                limb3: 0
            },
            u384 {
                limb0: 62163955556693967508703606777,
                limb1: 32250613016196876252982067488,
                limb2: 435000975820764255,
                limb3: 0
            },
            u384 {
                limb0: 53349435454905209515193710362,
                limb1: 51195634327531670671416941519,
                limb2: 279526621054101998,
                limb3: 0
            },
            u384 {
                limb0: 26882321631719425685440311354,
                limb1: 8657184642709191440490275185,
                limb2: 883553251497603332,
                limb3: 0
            },
            u384 {
                limb0: 35542827535923359748644243439,
                limb1: 14537420167960750796283509940,
                limb2: 2133495408864705561,
                limb3: 0
            },
            u384 {
                limb0: 4008020452492012606908931747,
                limb1: 42829788556438712923712583608,
                limb2: 68058579349137264,
                limb3: 0
            },
            u384 {
                limb0: 73394353600531222135462437763,
                limb1: 18727912609163662576025447216,
                limb2: 1874254038549355874,
                limb3: 0
            },
            u384 {
                limb0: 16934805274864589940639070743,
                limb1: 71498890350228681751963220593,
                limb2: 759254706701908688,
                limb3: 0
            },
            u384 {
                limb0: 56918167496166391598264276276,
                limb1: 15045259138063594069457010553,
                limb2: 1003968170290383698,
                limb3: 0
            },
            u384 {
                limb0: 45887389772625482861659379270,
                limb1: 4829556150805362130218993029,
                limb2: 1446246943544791963,
                limb3: 0
            },
            u384 {
                limb0: 46283317590081428795781440043,
                limb1: 72841352650133049033863647210,
                limb2: 2449386996071389642,
                limb3: 0
            },
            u384 {
                limb0: 76120746827078512205410173669,
                limb1: 67450305724765516116546096226,
                limb2: 315998860936886678,
                limb3: 0
            }
        ];
        let output = array![
            u384 {
                limb0: 13242857524162579801671699385,
                limb1: 33547045769289707309977990031,
                limb2: 2047505232604346032,
                limb3: 0
            }
        ];
        let result = get_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 25200082909529898546392587680,
                limb1: 27189061051057221896926116003,
                limb2: 36088377389159391992561973952,
                limb3: 5360374354390797594663195746
            },
            u384 {
                limb0: 33502624278465174033319801408,
                limb1: 1427996880886562243490432760,
                limb2: 13696480459915472484813396301,
                limb3: 2685264226002448319013355801
            },
            u384 {
                limb0: 23512669944965703700770815670,
                limb1: 63357840608838178600749739619,
                limb2: 914687695032467872744001787,
                limb3: 2600287041076213337576332945
            },
            u384 {
                limb0: 41016242294365733775349554158,
                limb1: 40015025935509126403736297894,
                limb2: 54440063971935819997890776141,
                limb3: 4491712161882045310184552304
            },
            u384 {
                limb0: 6005968629700439448181642212,
                limb1: 37086229342577025242670129741,
                limb2: 40991205000232293976081032470,
                limb3: 1603502736400872968335604550
            },
            u384 {
                limb0: 55681286443078044699539616614,
                limb1: 11261702526044637037473536713,
                limb2: 20422072101535120283051574842,
                limb3: 6058419043906397718719526081
            },
            u384 {
                limb0: 64452812713493456098087636609,
                limb1: 65789771145708935948654231793,
                limb2: 36811218245577948929841292181,
                limb3: 4739143200689797236063139671
            },
            u384 {
                limb0: 64293470307151160132301844688,
                limb1: 56730934084237280682894013167,
                limb2: 36261112029267519690142673391,
                limb3: 1996460513362226586467157267
            },
            u384 {
                limb0: 20069584401943185834614460233,
                limb1: 51252738322481784013654588033,
                limb2: 28282408100535499925234657174,
                limb3: 473428174784158229989760083
            },
            u384 {
                limb0: 26297783011955575666134807719,
                limb1: 63330430785875879189319616025,
                limb2: 70472382096025143924464451879,
                limb3: 4354940687899499143222514619
            },
            u384 {
                limb0: 30633154776835331652361582192,
                limb1: 14801184600733700654189189808,
                limb2: 39417864046396525736528129209,
                limb3: 7895986445831131279326343851
            },
            u384 {
                limb0: 63473490859708176821457470244,
                limb1: 33632328342368402773362738968,
                limb2: 47731267342857159576628006754,
                limb3: 1787154449252619855815688411
            },
            u384 {
                limb0: 25448991531368865617448023500,
                limb1: 25980491476997091311715867476,
                limb2: 24283103718153448374834167956,
                limb3: 7107389200657092590342473998
            },
            u384 {
                limb0: 54648798265643634481983517039,
                limb1: 35425261544146600534303046354,
                limb2: 68931446284789185128162642338,
                limb3: 6089194113969046231910913900
            },
            u384 {
                limb0: 21752516723548739339238689841,
                limb1: 62707333544389779215053243069,
                limb2: 5945373717864730560138173578,
                limb3: 4022911264558054667193595154
            },
            u384 {
                limb0: 63469362261568189860109481311,
                limb1: 12675454082593576445804105853,
                limb2: 11312154644097790279634518404,
                limb3: 6715466872253295096368358476
            },
            u384 {
                limb0: 47940551549985601805073445368,
                limb1: 35646538251239261247168297276,
                limb2: 29473936668252278018544114015,
                limb3: 761436414916173694486577484
            },
            u384 {
                limb0: 41948133786239912769795951023,
                limb1: 24908180792564994740845571724,
                limb2: 19776272571396700168205737180,
                limb3: 256633263915261527320732785
            },
            u384 {
                limb0: 39538336125492398871180292107,
                limb1: 72378294177222663564906132544,
                limb2: 20740084638278899271201310827,
                limb3: 6972452792522757095859425925
            },
            u384 {
                limb0: 78940177151725538448364205158,
                limb1: 54982811046256729817876790195,
                limb2: 38916888815343799918303009933,
                limb3: 1344189118448047781840872260
            },
            u384 {
                limb0: 25320351735504870601483621384,
                limb1: 56215588968268169178401705063,
                limb2: 42955240722525487692135782638,
                limb3: 2970627046838623293047910048
            },
            u384 {
                limb0: 56395327029256240576481910029,
                limb1: 55477085090742760778378901734,
                limb2: 62883105931420135041192185608,
                limb3: 2220781410772635569355407462
            },
            u384 {
                limb0: 15923305318716715941084896271,
                limb1: 18756172712842833532629078251,
                limb2: 2082435294060089027207750539,
                limb3: 5667560928229539487273957107
            },
            u384 {
                limb0: 63672641635728771566955198047,
                limb1: 10281535726384071099206249463,
                limb2: 6830694335086239411180447172,
                limb3: 3943185389847549987213598265
            },
            u384 {
                limb0: 56954722155534384783285384694,
                limb1: 32546542486277570825567194091,
                limb2: 65231667490625914982065764317,
                limb3: 1241176300532644268556987905
            },
            u384 {
                limb0: 9837057596165635728288483672,
                limb1: 24095229013581028692158732140,
                limb2: 25563817972897394501458786160,
                limb3: 2232949569393166494108154504
            },
            u384 {
                limb0: 9917012175727560973789426042,
                limb1: 48680023639006438682731312928,
                limb2: 39817946945172489734028657711,
                limb3: 5860986930883203256540446867
            },
            u384 {
                limb0: 65381952738866730553309742467,
                limb1: 6435137594838891394402141119,
                limb2: 50821200470992064032171844217,
                limb3: 2621025122114314819034265820
            }
        ];
        let output = array![
            u384 {
                limb0: 47314963452420915102274425271,
                limb1: 7161144893353591573003101622,
                limb2: 32812371749676538220482966557,
                limb3: 4054002613116328301235930895
            }
        ];
        let result = get_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 17824479658887775288603704960,
                limb1: 54936986410927098401152219025,
                limb2: 1269206686753988642,
                limb3: 0
            },
            u384 {
                limb0: 72234103050780680564330910315,
                limb1: 47716395096650627297588066020,
                limb2: 3475645143897073671,
                limb3: 0
            },
            u384 {
                limb0: 18702171271187894244109519555,
                limb1: 7109434179913122418553203544,
                limb2: 2609066541399891740,
                limb3: 0
            },
            u384 {
                limb0: 42970884537562369431948079150,
                limb1: 2295364997915154026487278394,
                limb2: 1013658342725393912,
                limb3: 0
            },
            u384 {
                limb0: 47217222476905616391700271106,
                limb1: 17168890127701503618873423597,
                limb2: 3446979023706521128,
                limb3: 0
            },
            u384 {
                limb0: 76351873349134645107570389665,
                limb1: 32043419181133396252671039291,
                limb2: 2275226966640920316,
                limb3: 0
            },
            u384 {
                limb0: 46243282890874105721370333923,
                limb1: 25065401601396432865900803635,
                limb2: 1202569509497006293,
                limb3: 0
            },
            u384 {
                limb0: 56742560451027905540338111672,
                limb1: 21044149849348107640081635994,
                limb2: 603569526718740646,
                limb3: 0
            },
            u384 {
                limb0: 36309119626591257727706738563,
                limb1: 44604951555394215707742063341,
                limb2: 461082151006252365,
                limb3: 0
            },
            u384 {
                limb0: 16887824407119500283973023456,
                limb1: 10494290284643502708754589900,
                limb2: 1609519164025345598,
                limb3: 0
            },
            u384 {
                limb0: 69662965577931112550894686337,
                limb1: 22579027591570185312249932900,
                limb2: 2020769640860489912,
                limb3: 0
            },
            u384 {
                limb0: 43830892872965247008451769769,
                limb1: 22323031810536746828197228330,
                limb2: 971357824965025963,
                limb3: 0
            },
            u384 {
                limb0: 16130640751959412388058721959,
                limb1: 67574715188706461330360487890,
                limb2: 2330787888344888038,
                limb3: 0
            },
            u384 {
                limb0: 71728146243003552979246672992,
                limb1: 4024703240465435069932969080,
                limb2: 2925120703204220745,
                limb3: 0
            },
            u384 {
                limb0: 21920866089119294067437434419,
                limb1: 26427071599004741117877503277,
                limb2: 603299181614338509,
                limb3: 0
            },
            u384 {
                limb0: 20754234561263806567893556404,
                limb1: 35005815592323992835634065343,
                limb2: 3254316715621412249,
                limb3: 0
            },
            u384 {
                limb0: 766112587022364231717413833,
                limb1: 74874648918479479877998462024,
                limb2: 3186765518658028208,
                limb3: 0
            },
            u384 {
                limb0: 43226116578924003939569884394,
                limb1: 29252304138060495446167069662,
                limb2: 2548072260902541520,
                limb3: 0
            },
            u384 {
                limb0: 68191884351193185944444251102,
                limb1: 28348568005096319999957961959,
                limb2: 3145477423920288620,
                limb3: 0
            },
            u384 {
                limb0: 49173870752587468615667177791,
                limb1: 73346566499482149637775541209,
                limb2: 1091758232253017781,
                limb3: 0
            },
            u384 {
                limb0: 77343009921307980041641446548,
                limb1: 14027533759086589119096513897,
                limb2: 1901372383523274256,
                limb3: 0
            },
            u384 {
                limb0: 58356649294053250855429760570,
                limb1: 61987044069995392453051101953,
                limb2: 1898691838811435817,
                limb3: 0
            },
            u384 {
                limb0: 68458204970429980400815130658,
                limb1: 19661834404320930064027663117,
                limb2: 734170457909846283,
                limb3: 0
            },
            u384 {
                limb0: 8564217771985424566073778239,
                limb1: 3068079203178140904526332186,
                limb2: 2170674589595386999,
                limb3: 0
            },
            u384 {
                limb0: 18031972627953615715039953702,
                limb1: 52293216633663689227775345815,
                limb2: 1837599988896560183,
                limb3: 0
            },
            u384 {
                limb0: 68481095491039272362912053676,
                limb1: 61269248766632511501790187248,
                limb2: 1619375690253384792,
                limb3: 0
            },
            u384 {
                limb0: 31665784151200017051324786101,
                limb1: 66841723692074507682773788205,
                limb2: 1527159213049343783,
                limb3: 0
            },
            u384 {
                limb0: 9138314653842363341335550073,
                limb1: 20695600164652876705852397275,
                limb2: 2677497555284565723,
                limb3: 0
            }
        ];
        let output = array![
            u384 {
                limb0: 28726941080861823380284148393,
                limb1: 78339710747931768774458512193,
                limb2: 330960650831731683,
                limb3: 0
            }
        ];
        let result = get_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_IS_ON_CURVE_G1_G2_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 8173578134716574016411279916,
                limb1: 15153083888808451190954782330,
                limb2: 19670543255640499131458280839,
                limb3: 109517743664065792847236246
            },
            u384 {
                limb0: 44527942444130245173728113220,
                limb1: 48062933456659371756019443660,
                limb2: 39841449545068630023478594242,
                limb3: 7283590846848461341247772106
            },
            u384 {
                limb0: 19851011977770059985056048913,
                limb1: 48901311354427986975534807443,
                limb2: 71531698009145882467258117333,
                limb3: 5069971860262085402653203389
            },
            u384 {
                limb0: 9459902584666621416002950689,
                limb1: 28141751978004074395091273059,
                limb2: 8699538749159409771000824034,
                limb3: 1831779348366411224436578865
            },
            u384 {
                limb0: 33079111002700915037238981127,
                limb1: 57051759337901770941554121343,
                limb2: 6829439737591425850925986229,
                limb3: 1023161382010215642978495907
            },
            u384 {
                limb0: 45568685820520316647481247513,
                limb1: 59595111431066563275836350349,
                limb2: 55089405718041751322435518990,
                limb3: 2007786766049375883023713942
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let result = get_IS_ON_CURVE_G1_G2_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_IS_ON_CURVE_G1_G2_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 72303579505629692943460764225,
                limb1: 64383731061350301183472899978,
                limb2: 89326107581585284,
                limb3: 0
            },
            u384 {
                limb0: 2656445009483745034477298029,
                limb1: 40135187278221230646314852042,
                limb2: 748615905220004737,
                limb3: 0
            },
            u384 {
                limb0: 42079130131667592628129761030,
                limb1: 60081133978822882519077118249,
                limb2: 2876942460693786388,
                limb3: 0
            },
            u384 {
                limb0: 73767780233257603821087361087,
                limb1: 51865286289539495173932594223,
                limb2: 1030923927894331265,
                limb3: 0
            },
            u384 {
                limb0: 53907605619747425403594570682,
                limb1: 79164282061086811078259526201,
                limb2: 651114202088725253,
                limb3: 0
            },
            u384 {
                limb0: 72347515962958596214393340424,
                limb1: 71402752684547027195259763041,
                limb2: 176111217446792037,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 27810052284636130223308486885,
                limb1: 40153378333836448380344387045,
                limb2: 3104278944836790958,
                limb3: 0
            },
            u384 {
                limb0: 70926583776874220189091304914,
                limb1: 63498449372070794915149226116,
                limb2: 42524369107353300,
                limb3: 0
            }
        ];
        let output = array![
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let result = get_IS_ON_CURVE_G1_G2_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_IS_ON_CURVE_G1_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 57046780125913284913231611320,
                limb1: 22917029905940612642214821678,
                limb2: 20865346974797207011991771707,
                limb3: 7455191697660846559437157000
            },
            u384 {
                limb0: 73588261088350515475985620065,
                limb1: 16476884100104963008296118058,
                limb2: 37799642634794147832016801631,
                limb3: 3610136233259138183030178378
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];
        let result = get_IS_ON_CURVE_G1_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_IS_ON_CURVE_G1_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 52644011630690813522148617426,
                limb1: 77877746910620474679324982432,
                limb2: 488734493197095745,
                limb3: 0
            },
            u384 {
                limb0: 28626170957394882810848530650,
                limb1: 21031546388754091774793504063,
                limb2: 762300332427566472,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];
        let result = get_IS_ON_CURVE_G1_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_RHS_FINALIZE_ACC_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 23880901847606867563245979628,
                limb1: 60795692977737459340752765537,
                limb2: 20244341149922083494766432737,
                limb3: 1188267427659735408299291905
            },
            u384 {
                limb0: 2371770651733779578239985005,
                limb1: 11234905603490494759744316169,
                limb2: 53228440694700691322946432892,
                limb3: 795348310523502173998821600
            },
            u384 {
                limb0: 5648166135998941710392300792,
                limb1: 23498808171703149135978430252,
                limb2: 56056723508053449335744719213,
                limb3: 4654426426090545450083367176
            },
            u384 {
                limb0: 12295135252511259044427128800,
                limb1: 40789225989541690402519288732,
                limb2: 67208451270522267935197502145,
                limb3: 6775806947749870083284163968
            },
            u384 {
                limb0: 28353245116016981557860769716,
                limb1: 60453484927939384443751770229,
                limb2: 39605560469808223280104528620,
                limb3: 1371584752872522151093977535
            },
            u384 {
                limb0: 66813445028043414861695123594,
                limb1: 62072118503477236249886757315,
                limb2: 61429381504441483409549095519,
                limb3: 6370568347991650090792931796
            }
        ];
        let output = array![
            u384 {
                limb0: 1001159514539857260975563223,
                limb1: 53780962395731801226442886336,
                limb2: 73518244186695677503354699248,
                limb3: 314268449398519763032750214
            }
        ];
        let result = get_RHS_FINALIZE_ACC_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_RHS_FINALIZE_ACC_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 74209421670488410536397023365,
                limb1: 5657089709477325794518563544,
                limb2: 2928320490419257971,
                limb3: 0
            },
            u384 {
                limb0: 69039564723921491985561943797,
                limb1: 49383295561182658333339459509,
                limb2: 1792598146987861692,
                limb3: 0
            },
            u384 {
                limb0: 14275919793398377683825316385,
                limb1: 61185850857729045518054367180,
                limb2: 1667271060807795348,
                limb3: 0
            },
            u384 {
                limb0: 47279048830509819759586012402,
                limb1: 59015822005772908013286956364,
                limb2: 2371441723131935770,
                limb3: 0
            },
            u384 {
                limb0: 74885996552384665454599334920,
                limb1: 46754997478637762248658171355,
                limb2: 2991629586723362052,
                limb3: 0
            },
            u384 {
                limb0: 49727641224342439913036229993,
                limb1: 7681289422175519421960499197,
                limb2: 2501084679195677832,
                limb3: 0
            }
        ];
        let output = array![
            u384 {
                limb0: 14305750360913870968018928480,
                limb1: 54145502513111284853835784233,
                limb2: 350380676256741950,
                limb3: 0
            }
        ];
        let result = get_RHS_FINALIZE_ACC_circuit(input, 0);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_SLOPE_INTERCEPT_SAME_POINT_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 11576486610181534011547288792,
                limb1: 7150621666493177110979603243,
                limb2: 4419843677371077416483621315,
                limb3: 7546742477733477662528531966
            },
            u384 {
                limb0: 52387305188318371509261742298,
                limb1: 3319649193164116367363185103,
                limb2: 65713790171662987657761811959,
                limb3: 5942128109450329058088174021
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 27833968763596724131318750995,
                limb1: 30229658090739170878059131663,
                limb2: 40210019724845525928610729487,
                limb3: 790336632448954760735509324
            },
            u384 {
                limb0: 66461918616083205854646654609,
                limb1: 46224181377792508495398538406,
                limb2: 12003993055606957449134865057,
                limb3: 7162329707326654433867519578
            },
            u384 {
                limb0: 11576486610181534011547288792,
                limb1: 7150621666493177110979603243,
                limb2: 4419843677371077416483621315,
                limb3: 7546742477733477662528531966
            },
            u384 {
                limb0: 52387305188318371509261742298,
                limb1: 3319649193164116367363185103,
                limb2: 65713790171662987657761811959,
                limb3: 5942128109450329058088174021
            },
            u384 {
                limb0: 45135103438916510483414961948,
                limb1: 29848309331437004039239845256,
                limb2: 62138324756465446403902244239,
                limb3: 119780569542618769130858274
            },
            u384 {
                limb0: 22259690933158264504432550922,
                limb1: 41836665203614459830762864847,
                limb2: 34936028398708877964003347895,
                limb3: 4274628287676157834228345533
            },
            u384 {
                limb0: 40879614197706421150899504549,
                limb1: 1473120223440231972509590804,
                limb2: 68193065342540706392183841242,
                limb3: 3884952343771412011188210655
            },
            u384 {
                limb0: 64439839184777310481805952895,
                limb1: 20241966556226227809935277813,
                limb2: 67001188407113992128506332603,
                limb3: 2304279078873502489717192006
            }
        ];
        let result = get_SLOPE_INTERCEPT_SAME_POINT_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_SLOPE_INTERCEPT_SAME_POINT_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 7862869637678795077519372023,
                limb1: 4699109503247496940657468379,
                limb2: 767913315398900925,
                limb3: 0
            },
            u384 {
                limb0: 35734897125503171445406366517,
                limb1: 12489256228081191068726317287,
                limb2: 932103510943225470,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 15596568577007144946107732102,
                limb1: 19297690964877084931055598137,
                limb2: 1819563013969841841,
                limb3: 0
            },
            u384 {
                limb0: 43822460752391213489611866548,
                limb1: 75118984786188757236103963672,
                limb2: 3309626825146705442,
                limb3: 0
            },
            u384 {
                limb0: 7862869637678795077519372023,
                limb1: 4699109503247496940657468379,
                limb2: 767913315398900925,
                limb3: 0
            },
            u384 {
                limb0: 35734897125503171445406366517,
                limb1: 12489256228081191068726317287,
                limb2: 932103510943225470,
                limb3: 0
            },
            u384 {
                limb0: 78553259747925857887271717776,
                limb1: 75298960782044215284875386414,
                limb2: 1528515062737524323,
                limb3: 0
            },
            u384 {
                limb0: 59511817919986023209054773647,
                limb1: 26992494460028604229416054756,
                limb2: 194718161717726059,
                limb3: 0
            },
            u384 {
                limb0: 24832937800006650066678155917,
                limb1: 19353361485965058581350678382,
                limb2: 2817888510201851547,
                limb3: 0
            },
            u384 {
                limb0: 25963806808381771351241320136,
                limb1: 37800264638834128181119251853,
                limb2: 2665760749065138530,
                limb3: 0
            }
        ];
        let result = get_SLOPE_INTERCEPT_SAME_POINT_circuit(input, 0);
        assert_eq!(result, output);
    }
}
