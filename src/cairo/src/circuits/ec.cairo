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

    let mut circuit_inputs = (t4, t5, t6, t7, in4,).new_inputs();

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
    let o4 = outputs.get_output(in4);

    let res = array![o0, o1, o2, o3, o4];
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

    let mut circuit_inputs = (t5, t7, in2, in3, t10, t14, t31, t29,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t5);
    let o1 = outputs.get_output(t7);
    let o2 = outputs.get_output(in2);
    let o3 = outputs.get_output(in3);
    let o4 = outputs.get_output(t10);
    let o5 = outputs.get_output(t14);
    let o6 = outputs.get_output(t31);
    let o7 = outputs.get_output(t29);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7];
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
                limb0: 53039994392964625739614782612,
                limb1: 75089047723124581503093743729,
                limb2: 55417324567391959512649598523,
                limb3: 3653360854514354500383879135
            },
            u384 {
                limb0: 17579445270756342385323184524,
                limb1: 13813247220324932672779707634,
                limb2: 43188545300000586902726008241,
                limb3: 5167371424815606439156733423
            },
            u384 {
                limb0: 37714183584643079239786159300,
                limb1: 54845133007678031462818600954,
                limb2: 1049029455550956416780674620,
                limb3: 1481407541992070811892939168
            },
            u384 {
                limb0: 75095281339493862588641313012,
                limb1: 4075114049959532046154741953,
                limb2: 3207112010614344933979250966,
                limb3: 6020231356690392449116536878
            },
            u384 {
                limb0: 53717890085530308776843385497,
                limb1: 63724885491434788259027949765,
                limb2: 27752533005465292435399418004,
                limb3: 6598966299309591663547495701
            },
            u384 {
                limb0: 56424509167471919234324420589,
                limb1: 44556168691003171048257079218,
                limb2: 51208051189556193032722994760,
                limb3: 629190300023192979176362334
            },
            u384 { limb0: 60909040423131710805406274269, limb1: 1246334442, limb2: 0, limb3: 0 },
            u384 { limb0: 48836067093425790343164900071, limb1: 221791720, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 58478154724644012832698479560,
                limb1: 42603747670265123325074793782,
                limb2: 68398507108615991148945381263,
                limb3: 120574712343423488461450487
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
                limb0: 19030959434133007784182351486,
                limb1: 18067653269358796646554112089,
                limb2: 31093752624445874905059918307,
                limb3: 1085810049515202791074903355
            },
            u384 {
                limb0: 66542355876716956796453623684,
                limb1: 68379129774381453543882071682,
                limb2: 38795092676864176765642249275,
                limb3: 6558010427018386837905870730
            }
        ];
        let output = array![
            u384 {
                limb0: 55894114282458273299679445702,
                limb1: 13742951262172676019643938789,
                limb2: 40295218763132825713211362215,
                limb3: 5569043206399445725339357626
            },
            u384 {
                limb0: 29576056589890161663297427210,
                limb1: 77111382540858433508008111308,
                limb2: 38643672135627689706510867257,
                limb3: 6747703040009221867399726831
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
                limb0: 30035702723735789924106859563,
                limb1: 36024992289669488189020922472,
                limb2: 389111638850808505,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 28011627355307825707627930368,
                limb1: 53411590460066106585862200349,
                limb2: 49652091526773162353382610701,
                limb3: 6761300534645413532383659932
            },
            u384 {
                limb0: 53502251575825028801767986090,
                limb1: 17134650631621028039469306970,
                limb2: 28074149436403981107387162538,
                limb3: 4188094039763856235978327913
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 {
                limb0: 53502251575825028801767986090,
                limb1: 17134650631621028039469306970,
                limb2: 28074149436403981107387162538,
                limb3: 4188094039763856235978327913
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
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 46338741327332156564860821056,
                limb1: 16151866188608207280411844120,
                limb2: 61645587805704275339023311331,
                limb3: 1754177290432455040314550611
            },
            u384 {
                limb0: 61607415820200045687731837978,
                limb1: 16660842789475134270568052648,
                limb2: 3032139067443331336701144504,
                limb3: 831117140637889112071878631
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
                limb0: 8548427125435895768647672008,
                limb1: 42106088536622232034610659224,
                limb2: 26335422535902228546289459594,
                limb3: 4165742548260601333126353602
            },
            u384 {
                limb0: 46874564632879880887156608283,
                limb1: 29031118257031746675369284576,
                limb2: 76540562265789424536105591562,
                limb3: 4012142794901263066748461256
            },
            u384 {
                limb0: 61863339212075682319471542837,
                limb1: 54128249125505722572224405568,
                limb2: 54578692889177616060130790944,
                limb3: 5351040164419422084774491394
            },
            u384 {
                limb0: 38028710362122972935356076869,
                limb1: 14399734802619163560457610606,
                limb2: 61922232843086941245472871131,
                limb3: 6731819012004418483635709270
            },
            u384 {
                limb0: 60403495029550683054064910901,
                limb1: 58891025537716995546381176812,
                limb2: 75564477564150507053047607382,
                limb3: 7321211121105966329481549902
            },
            u384 {
                limb0: 53915689719997572356633594713,
                limb1: 61557999012719152498191325122,
                limb2: 21989498748480509702322585653,
                limb3: 5951390150798766169868301564
            },
            u384 {
                limb0: 27035119202680581644972631414,
                limb1: 33280482250162556250286271438,
                limb2: 8361650603430460296901445484,
                limb3: 3586936586098517594915693489
            },
            u384 {
                limb0: 65656957294819693759804322968,
                limb1: 12121207637888104979284195925,
                limb2: 58137253330734744998489363946,
                limb3: 6441818266512330209541304786
            },
            u384 {
                limb0: 64032138815186176976330432166,
                limb1: 61373418500185767315409473558,
                limb2: 34509766516629733181699292703,
                limb3: 5867584437722179691597748150
            },
            u384 {
                limb0: 67479668518579958409116094967,
                limb1: 74048374568893416743139591532,
                limb2: 69850019016256011485708257828,
                limb3: 7432357128010647800597955213
            },
            u384 {
                limb0: 48355459453848246795357332053,
                limb1: 26652086373647368026871195214,
                limb2: 67419429664409211253565219329,
                limb3: 4828460702707906052799865062
            },
            u384 {
                limb0: 63210792033358313014193650823,
                limb1: 22156827791384962023945364027,
                limb2: 55553500094769805980692424294,
                limb3: 5504287739845088054128588557
            },
            u384 {
                limb0: 75113256454410355088977118058,
                limb1: 19122196254397789720726278898,
                limb2: 38709125173506026263192981557,
                limb3: 2380052964889067581306046244
            },
            u384 {
                limb0: 51173699553035763639527392799,
                limb1: 35508045830198828422827560387,
                limb2: 7372446065128810699783251475,
                limb3: 4004994746023701355926062565
            },
            u384 {
                limb0: 26207986953086158914020810726,
                limb1: 35949403684282145133745422633,
                limb2: 19918251350322936334346012514,
                limb3: 7143254071017518753454000779
            },
            u384 {
                limb0: 9472102553316238055030207553,
                limb1: 75336281648900054400484865034,
                limb2: 14669082185422302079820422076,
                limb3: 7314786176960667153823487048
            },
            u384 {
                limb0: 18023073391495333781932454041,
                limb1: 23948106176605149970129138594,
                limb2: 42318541909003415981291158053,
                limb3: 450765657816241609256713644
            },
            u384 {
                limb0: 43841614052591311667491202186,
                limb1: 74798485459622701613460322189,
                limb2: 68806584625945105698364054082,
                limb3: 1015978807063588632538840290
            },
            u384 {
                limb0: 45482053616623421869246812051,
                limb1: 37927647050474547485157783121,
                limb2: 14606794829149682892017930303,
                limb3: 2500424800674137645364468379
            },
            u384 {
                limb0: 37849606003979032557460753211,
                limb1: 5177040130416596406538391694,
                limb2: 5869394317156297220453352259,
                limb3: 6798281667054544696420837510
            }
        ];
        let output = array![
            u384 {
                limb0: 69457902223473087323228144459,
                limb1: 33372806042494555562805460820,
                limb2: 62687039005206728175496987709,
                limb3: 2767627684000815675032037081
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
                limb0: 21550450915088876126157962408,
                limb1: 16307014575928125966721336358,
                limb2: 5784644688959315647631753271,
                limb3: 6597930111460333327238240396
            },
            u384 {
                limb0: 65139969218337261205943669126,
                limb1: 24511862720943395534677438987,
                limb2: 2004380619412114231007648311,
                limb3: 4208688807167405528846640755
            },
            u384 {
                limb0: 23703011206281781861784998584,
                limb1: 65619438118305508915191512157,
                limb2: 48006834334450417603810837322,
                limb3: 6800842210382226774574345271
            },
            u384 {
                limb0: 6226168181125758584760731407,
                limb1: 65861417624655264221942110144,
                limb2: 27837268840277080121887804980,
                limb3: 236697540058958143117128678
            },
            u384 {
                limb0: 43404579670331348769163160605,
                limb1: 44456970782165004571634603244,
                limb2: 34200174071404984385698827925,
                limb3: 1894629806534276927998528842
            },
            u384 {
                limb0: 20015509338492133357506855581,
                limb1: 66326020873121941136988399354,
                limb2: 30851934474200766417824309377,
                limb3: 1359876588705636339350344952
            },
            u384 {
                limb0: 9384699591256219912009509652,
                limb1: 32972702935408319256957149133,
                limb2: 62648942637892259708266848811,
                limb3: 7682096730557048404436888130
            },
            u384 {
                limb0: 35693432986664631580053950539,
                limb1: 23558742010541320332039667261,
                limb2: 78438357651333253614590484985,
                limb3: 5631433473436648774545427143
            },
            u384 {
                limb0: 48299936755480667508698752395,
                limb1: 7862093354102508672309112903,
                limb2: 16462653855725766494112793966,
                limb3: 2620928269961104326616269002
            },
            u384 {
                limb0: 12443344778304364362031288722,
                limb1: 43733331427271430221733547497,
                limb2: 211992826581174726333789086,
                limb3: 6827201011819627377576942477
            },
            u384 {
                limb0: 23075938569688439147454530210,
                limb1: 22826020729967132362910930427,
                limb2: 55696412235755521384287768249,
                limb3: 704930195194609696297136079
            },
            u384 {
                limb0: 73199774653402613602909189453,
                limb1: 62689104929519290910238169619,
                limb2: 52384317107199978493521939752,
                limb3: 1959106624739554870780805946
            },
            u384 {
                limb0: 43144676896430893745699154009,
                limb1: 11804155957014375358918368422,
                limb2: 65492467979962473121271621401,
                limb3: 590626543350482227631331560
            },
            u384 {
                limb0: 24371518399817493693024823912,
                limb1: 65303044387623894984523304526,
                limb2: 22866086886350808813653167502,
                limb3: 4641759821371652938169867350
            },
            u384 {
                limb0: 55438613896418324894463112054,
                limb1: 21569565448519877295145143388,
                limb2: 39122487878400496310794777050,
                limb3: 5922668229752776566074570521
            },
            u384 {
                limb0: 34228837351167200527551582460,
                limb1: 47831122831604334209840867933,
                limb2: 7235661521073167673960438894,
                limb3: 6677927570132241446774426206
            },
            u384 {
                limb0: 45571968412441941404874269239,
                limb1: 1643624375821430033621037119,
                limb2: 53263634514684846855336229449,
                limb3: 5706873738507422947797936551
            },
            u384 {
                limb0: 50292826515662347692536244608,
                limb1: 76776465720416580670921530204,
                limb2: 27568315234859784671483111821,
                limb3: 3179606971975753138193399870
            },
            u384 {
                limb0: 67956617199157168444246187700,
                limb1: 32613884221919717692755661142,
                limb2: 22834966520268973405698824459,
                limb3: 3965886997852661700945187608
            },
            u384 {
                limb0: 43583143821676632764211125532,
                limb1: 6976815487978236021815180223,
                limb2: 25612388030350716754693730882,
                limb3: 7650944122706597133004114354
            },
            u384 {
                limb0: 40770515480487292065166132283,
                limb1: 91196791771514630193442253,
                limb2: 42988693456072645070051634762,
                limb3: 536811254427488132379448573
            },
            u384 {
                limb0: 28663114038156270142503610578,
                limb1: 39494692246340579116733230829,
                limb2: 60212653973181035611026016658,
                limb3: 2644796899361961616596168188
            },
            u384 {
                limb0: 73497808494462924422074968212,
                limb1: 69787858564518727994683705151,
                limb2: 9620365863852471327662310292,
                limb3: 6239438391785163545714621648
            },
            u384 {
                limb0: 18959098346817874123974181751,
                limb1: 24620162586442748086646494154,
                limb2: 43753864550486063811240642846,
                limb3: 2225327474056912129695552505
            }
        ];
        let output = array![
            u384 {
                limb0: 20789607349198867885672108744,
                limb1: 78164621523938363518161336361,
                limb2: 71190364326052554904171217858,
                limb3: 1800207610133627719969592768
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
                limb0: 41876365979791228076071623741,
                limb1: 37650404170189165973627525709,
                limb2: 17080227056846003699662426719,
                limb3: 6215996994712966294370107858
            },
            u384 {
                limb0: 53562558879041794890522044285,
                limb1: 55870403245918053055103388521,
                limb2: 17872220752573345833936985446,
                limb3: 7508161330066490292833849134
            },
            u384 {
                limb0: 43429379876212832961455349500,
                limb1: 47611056387712449524460605275,
                limb2: 32108853107835428209485260628,
                limb3: 2219048249728308825107511594
            },
            u384 {
                limb0: 16090755071451259415924894642,
                limb1: 36270747185404729091403426129,
                limb2: 42665431882429290619612425603,
                limb3: 830996072190332053874421512
            },
            u384 {
                limb0: 76213260824541542814317814505,
                limb1: 52388241379902008469149771458,
                limb2: 37782442779115516493786495120,
                limb3: 1009233149223826070030745338
            },
            u384 {
                limb0: 72902457782538383537093687576,
                limb1: 41160202620625721900674603494,
                limb2: 22888111740877780795608442633,
                limb3: 3966769940017439624570025522
            },
            u384 {
                limb0: 39485375448878087678735111641,
                limb1: 23123655099175939896701508060,
                limb2: 21662951975335807930497068980,
                limb3: 4778444360443988224105091883
            },
            u384 {
                limb0: 19310351630681970556500266992,
                limb1: 11459717187747487754581177669,
                limb2: 73037919636589672453561823610,
                limb3: 7390923384514757964621467488
            },
            u384 {
                limb0: 68455266504940032006937085581,
                limb1: 61217631037731878616631808727,
                limb2: 32875125693003341732211710041,
                limb3: 7801175365010671290323963977
            },
            u384 {
                limb0: 65010627311103104279251720371,
                limb1: 57523685552742810109023362537,
                limb2: 46501997170111362374575204351,
                limb3: 6535736673293546487283047369
            },
            u384 {
                limb0: 11772941745766394344624427462,
                limb1: 38373478145126901465673166360,
                limb2: 43727402812672977311618435834,
                limb3: 3735707447978529608969199547
            },
            u384 {
                limb0: 68904758136922758756997402766,
                limb1: 66950920796512514785061994112,
                limb2: 41670137718339857129875695720,
                limb3: 151995258191354395054224575
            },
            u384 {
                limb0: 32481852459444275059954422819,
                limb1: 76847894781551528562463700617,
                limb2: 37196877468935116728043845519,
                limb3: 2624658510746637053929327246
            },
            u384 {
                limb0: 54881712804592936291723375345,
                limb1: 6363235149382595265295382421,
                limb2: 67529437557505160907355671135,
                limb3: 5284739435682553971207221576
            },
            u384 {
                limb0: 25088481345435104812294753203,
                limb1: 70310135811311089830803663143,
                limb2: 69117303461924988937602345022,
                limb3: 6115022335289244884368623245
            },
            u384 {
                limb0: 50210675846930408150502969740,
                limb1: 7963003982605479441203343472,
                limb2: 54984436921633567540660988642,
                limb3: 286679741063364212739919623
            },
            u384 {
                limb0: 63076984147439374318243811430,
                limb1: 28400392036918774343134991458,
                limb2: 11533227294636246845479032298,
                limb3: 4080762834555636707831822623
            },
            u384 {
                limb0: 62789861689330070018699864411,
                limb1: 13870423455179649741246444884,
                limb2: 68995021307421294225505338633,
                limb3: 6765437202158231387175283803
            },
            u384 {
                limb0: 72321765829150918711714448759,
                limb1: 18395863547422483059585960241,
                limb2: 20122158049862950885740374971,
                limb3: 6604070612302950217434950017
            },
            u384 {
                limb0: 46552226457955962761835379977,
                limb1: 76219795597101723293836468074,
                limb2: 19814822843009473268613612217,
                limb3: 2992068102454803282240155907
            },
            u384 {
                limb0: 30478538780486786939799724692,
                limb1: 8449942826310512614676115794,
                limb2: 45312384253024649392281977680,
                limb3: 2930178219633398943360270161
            },
            u384 {
                limb0: 63292219732599987988171326747,
                limb1: 63535595427025658628719315454,
                limb2: 50438064645282952527823877324,
                limb3: 2482087585425680956415311227
            },
            u384 {
                limb0: 57117830591636728816636917949,
                limb1: 53942898139659984468025341681,
                limb2: 49774943338307229488644965105,
                limb3: 6214044141438159767174364220
            },
            u384 {
                limb0: 59221535315077808699634113500,
                limb1: 15908602935162819628444313888,
                limb2: 42736285308771361020783704433,
                limb3: 3623277502224625991659010236
            },
            u384 {
                limb0: 59148525167486897208757192621,
                limb1: 63717866722590367833465705936,
                limb2: 76288266753562947017510732563,
                limb3: 7468754562861203031876620713
            },
            u384 {
                limb0: 68147359025422104418071645918,
                limb1: 53431966384718585117548973366,
                limb2: 76635004537457793752876547747,
                limb3: 5519356857931179837651858881
            },
            u384 {
                limb0: 62644279346999852775579545371,
                limb1: 20952567276452392942570755746,
                limb2: 36031861523496510918309498265,
                limb3: 7417851649401757259643199805
            },
            u384 {
                limb0: 46313622200304685694893065944,
                limb1: 50591084936404416209294648069,
                limb2: 8584062625602148633115293759,
                limb3: 4669280760682225974991001248
            }
        ];
        let output = array![
            u384 {
                limb0: 13943674776283441223425042756,
                limb1: 1829153638495039970551062724,
                limb2: 6951342127876496001690782581,
                limb3: 2978891227270948819998751872
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
                limb0: 77571989043064996593321390073,
                limb1: 54380397677316225710810361696,
                limb2: 48249482663761811943099631445,
                limb3: 4379085891340682516150528047
            },
            u384 {
                limb0: 4173237397415504384117581190,
                limb1: 69841221533432094888792986187,
                limb2: 72427952557380730564390128773,
                limb3: 5285512005088897162078418088
            },
            u384 {
                limb0: 38970194721079799909880804200,
                limb1: 35129914082186278039910447318,
                limb2: 6796125051567338906407944442,
                limb3: 5126516293311445168678103015
            },
            u384 {
                limb0: 25678868440056125813135012811,
                limb1: 19927634290736980923065622412,
                limb2: 69922645930191133091462093682,
                limb3: 1232956668139740580736776414
            },
            u384 {
                limb0: 51847410826736189405284271973,
                limb1: 33160155057516595262681471744,
                limb2: 36708830881728918928036978544,
                limb3: 591580439064023895302331246
            },
            u384 {
                limb0: 62601581548651109796587530228,
                limb1: 48624811021017314198243072787,
                limb2: 22702480147986120114102334892,
                limb3: 4264598023265610453750801472
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
                limb0: 42053972536463622571412853912,
                limb1: 55878439307793697453612584253,
                limb2: 62494102199722047590135983687,
                limb3: 943767542437261801013326056
            },
            u384 {
                limb0: 46713649739487232471622912658,
                limb1: 57545176274574899388534616473,
                limb2: 78259319878299099764248970387,
                limb3: 1517810995640262987239097859
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
                limb0: 61202241295851139919554950188,
                limb1: 54212586387149770184193246661,
                limb2: 9590970079198569275367658320,
                limb3: 5604724518994754820306734070
            },
            u384 {
                limb0: 13724313549774192579549762534,
                limb1: 8491263950573146786954198905,
                limb2: 35105483810013819177539980245,
                limb3: 7159842126246078837215080891
            },
            u384 {
                limb0: 5046749310682290330677263035,
                limb1: 59713926695426460588116485426,
                limb2: 75182526424689005041064327491,
                limb3: 1787059159364192305885273902
            },
            u384 {
                limb0: 56931014158857763216442083355,
                limb1: 42697244449160452605856761573,
                limb2: 16315425491625937771336839888,
                limb3: 7956064707071492061051702650
            },
            u384 {
                limb0: 24728424253849308064984697269,
                limb1: 44465176792605244481097857125,
                limb2: 69838900022624149202498614102,
                limb3: 7491561384245361669201524713
            },
            u384 {
                limb0: 51434447572803771809054650899,
                limb1: 63217270798194089215955384972,
                limb2: 61755699676328709252914855154,
                limb3: 6338036894057804432651507048
            }
        ];
        let output = array![
            u384 {
                limb0: 78758047666447477710871744337,
                limb1: 26304952686681615447149078420,
                limb2: 11461315973375388834873640024,
                limb3: 476298592584631921461332761
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
                limb0: 20002885729693568286666011457,
                limb1: 77140645043557960812286428096,
                limb2: 2366760047288998557969229635,
                limb3: 1390699465347841050238233891
            },
            u384 {
                limb0: 72130745730116853556485390428,
                limb1: 58666228466484510307049472637,
                limb2: 1817634964447894496830426843,
                limb3: 497101116751174512170794010
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let output = array![
            u384 {
                limb0: 69240321605981128063506283417,
                limb1: 71028707260498723780885241048,
                limb2: 65784990315923150572989981115,
                limb3: 6719996080050377559080128754
            },
            u384 {
                limb0: 59312973887555221956748861940,
                limb1: 73896533663585922999843275034,
                limb2: 18563864933535096804703861160,
                limb3: 4757598931736390517043129230
            },
            u384 {
                limb0: 20002885729693568286666011457,
                limb1: 77140645043557960812286428096,
                limb2: 2366760047288998557969229635,
                limb3: 1390699465347841050238233891
            },
            u384 {
                limb0: 72130745730116853556485390428,
                limb1: 58666228466484510307049472637,
                limb2: 1817634964447894496830426843,
                limb3: 497101116751174512170794010
            },
            u384 {
                limb0: 45792416376293467484376857507,
                limb1: 61418993198768907346467547746,
                limb2: 76494687350409678901555957322,
                limb3: 4812394880639552586628623787
            },
            u384 {
                limb0: 3659176331315922687064327592,
                limb1: 2633020962161973855658714404,
                limb2: 1555071796344085048730935341,
                limb3: 5488167537748396491033408560
            },
            u384 {
                limb0: 780114939537363364490981817,
                limb1: 60591932257775159116821950794,
                limb2: 67020596919143833414051245766,
                limb3: 3946125996231711373388856359
            },
            u384 {
                limb0: 51288427246202230745682120669,
                limb1: 61634638485355003273168762773,
                limb2: 56332741431213038220831953101,
                limb3: 6601941400303340616401250734
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
