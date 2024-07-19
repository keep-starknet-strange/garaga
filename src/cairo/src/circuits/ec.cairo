use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, G1Point, G2Point, E12D, G1G2Pair, BNProcessedPair,
    BLSProcessedPair
};
use core::option::Option;

fn run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
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
    // Prefill constants:
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t15)];
    return res;
}

fn run_ADD_EC_POINT_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
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
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t6), outputs.get_output(t9)];
    return res;
}

fn run_DOUBLE_EC_POINT_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
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
    // Prefill constants:
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t8), outputs.get_output(t11)];
    return res;
}

fn run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
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
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t62)];
    return res;
}

fn run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
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
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t80)];
    return res;
}

fn run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
    let in10 = CircuitElement::<CircuitInput<10>> {}; // 
    let in11 = CircuitElement::<CircuitInput<11>> {}; // 
    let in12 = CircuitElement::<CircuitInput<12>> {}; // 
    let in13 = CircuitElement::<CircuitInput<13>> {}; // 
    let in14 = CircuitElement::<CircuitInput<14>> {}; // 
    let in15 = CircuitElement::<CircuitInput<15>> {}; // 
    let in16 = CircuitElement::<CircuitInput<16>> {}; // 
    let in17 = CircuitElement::<CircuitInput<17>> {}; // 
    let in18 = CircuitElement::<CircuitInput<18>> {}; // 
    let in19 = CircuitElement::<CircuitInput<19>> {}; // 
    let in20 = CircuitElement::<CircuitInput<20>> {}; // 
    let in21 = CircuitElement::<CircuitInput<21>> {}; // 
    let in22 = CircuitElement::<CircuitInput<22>> {}; // 
    let in23 = CircuitElement::<CircuitInput<23>> {}; // 
    let in24 = CircuitElement::<CircuitInput<24>> {}; // 
    let in25 = CircuitElement::<CircuitInput<25>> {}; // 
    let in26 = CircuitElement::<CircuitInput<26>> {}; // 
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
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
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t98)];
    return res;
}

fn run_IS_ON_CURVE_G1_G2_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
    let in7 = CircuitElement::<CircuitInput<7>> {}; // 
    let in8 = CircuitElement::<CircuitInput<8>> {}; // 
    let in9 = CircuitElement::<CircuitInput<9>> {}; // 
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
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t26), outputs.get_output(t27), outputs.get_output(t28)];
    return res;
}

fn run_IS_ON_CURVE_G1_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
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
    // Prefill constants:

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t6)];
    return res;
}

fn run_RHS_FINALIZE_ACC_circuit(mut input: Array<u384>, curve_index: usize) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 0

    // INPUT stack
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
    let in5 = CircuitElement::<CircuitInput<5>> {}; // 
    let in6 = CircuitElement::<CircuitInput<6>> {}; // 
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
    // Prefill constants:
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t7)];
    return res;
}

fn run_SLOPE_INTERCEPT_SAME_POINT_circuit(
    mut input: Array<u384>, curve_index: usize
) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 3
    let in1 = CircuitElement::<CircuitInput<1>> {}; // 0

    // INPUT stack
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 
    let in3 = CircuitElement::<CircuitInput<3>> {}; // 
    let in4 = CircuitElement::<CircuitInput<4>> {}; // 
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
    // Prefill constants:
    circuit_inputs = circuit_inputs.next(u384 { limb0: 3, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs.next(u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![
        outputs.get_output(t5),
        outputs.get_output(t7),
        outputs.get_output(t10),
        outputs.get_output(t14),
        outputs.get_output(t31),
        outputs.get_output(t29)
    ];
    return res;
}


#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs
    };
    use garaga::definitions::{G1Point, G2Point, E12D, G1G2Pair, BNProcessedPair, BLSProcessedPair};

    use super::{
        run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit, run_ADD_EC_POINT_circuit,
        run_DOUBLE_EC_POINT_circuit, run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit,
        run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit, run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit,
        run_IS_ON_CURVE_G1_G2_circuit, run_IS_ON_CURVE_G1_circuit, run_RHS_FINALIZE_ACC_circuit,
        run_SLOPE_INTERCEPT_SAME_POINT_circuit
    };

    #[test]
    fn test_run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 24518572383822428187053585524,
                limb1: 62144213105303746170256971593,
                limb2: 66164499627986659981648816130,
                limb3: 6717625395142062314114190166
            },
            u384 {
                limb0: 78051448651935200646441452501,
                limb1: 16365343235665394266835558103,
                limb2: 13643564991252409266580032806,
                limb3: 786616785993762432549355239
            },
            u384 {
                limb0: 5626086656711605944790156643,
                limb1: 42091902137922686331918701794,
                limb2: 7492924250895821195399018406,
                limb3: 2768513503505413035623553663
            },
            u384 {
                limb0: 31673793415781511236239548409,
                limb1: 14393431360454544118271081677,
                limb2: 32514518853458990518560888254,
                limb3: 7865069905668911447865091562
            },
            u384 {
                limb0: 11479270507113298535861180691,
                limb1: 15065834954807184795960136286,
                limb2: 53116676460980883395800500182,
                limb3: 4551368233847384068470047178
            },
            u384 {
                limb0: 74995620985662905071968848712,
                limb1: 79158249513572290458349601341,
                limb2: 29072512419378797950000958459,
                limb3: 6467881820258422224500017525
            },
            u384 { limb0: 42348513109177914202303689600, limb1: 1235388780, limb2: 0, limb3: 0 },
            u384 { limb0: 6780775362192739574355254462, limb1: 230353784, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 48716585181191991223694379225,
                limb1: 72772538773672876944691424774,
                limb2: 43941487086474034817891968100,
                limb3: 1320858222455867630245206709
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 45742550057374806329167237825,
                limb1: 5510726952699698538507522860,
                limb2: 3049538818873697689,
                limb3: 0
            },
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
                limb0: 65917823739508736469247779160,
                limb1: 3098786748851022159658983169,
                limb2: 2488262035068768042,
                limb3: 0
            },
            u384 {
                limb0: 50853918540922815225247809382,
                limb1: 28712599458085412945819279336,
                limb2: 2179096613753899535,
                limb3: 0
            },
            u384 { limb0: 29223359368920413333441117546, limb1: 1266803654, limb2: 0, limb3: 0 },
            u384 { limb0: 60619417850417312561337014615, limb1: 130695199, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 1340259879001784236130471393,
                limb1: 13660712802589127909524135549,
                limb2: 3365427384532902420,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_ADD_EC_POINT_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 56873637829135196937545787741,
                limb1: 60252242310749107847077499493,
                limb2: 15655717028870112823713306596,
                limb3: 5253505310797755716308562857
            },
            u384 {
                limb0: 34362884758539854943684363444,
                limb1: 14118904461016864593793139101,
                limb2: 67765717242353915572638954092,
                limb3: 5777457059767452034618992494
            },
            u384 {
                limb0: 35927696938674269383930749465,
                limb1: 18273803274368040672328349735,
                limb2: 51813587602451745262395755883,
                limb3: 5907566148924863399581960293
            },
            u384 {
                limb0: 9966379396175578393622831250,
                limb1: 15574762109237035231900932640,
                limb2: 54018752227133903337216724622,
                limb3: 1427866097143788743637239623
            }
        ];
        let got = run_ADD_EC_POINT_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 20705363598382168455670129594,
                limb1: 15085141015124875935481256605,
                limb2: 33573645960440532417274324795,
                limb3: 4646239174048204338089448627
            },
            u384 {
                limb0: 26220237564775598845576248544,
                limb1: 52551761895798116707808638369,
                limb2: 57174638091353469162198359634,
                limb3: 847328142657762632508221347
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_ADD_EC_POINT_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 49613233139976166820933933033,
                limb1: 43972812792898214110431846422,
                limb2: 3124149996396808164,
                limb3: 0
            },
            u384 {
                limb0: 63824609037301126063922625889,
                limb1: 20640785082980109702919037119,
                limb2: 2767657580781827941,
                limb3: 0
            },
            u384 {
                limb0: 16776647801889250781294719899,
                limb1: 53819387450153218721863223941,
                limb2: 3238971312040363041,
                limb3: 0
            },
            u384 {
                limb0: 73131808072361950503339604242,
                limb1: 72831540730642989035268380153,
                limb2: 1664095061258156717,
                limb3: 0
            }
        ];
        let got = run_ADD_EC_POINT_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 64557636454391543536058816495,
                limb1: 2087384318367081968443430132,
                limb2: 109001327450590800,
                limb3: 0
            },
            u384 {
                limb0: 8085146166888010828227289768,
                limb1: 37697351098583322000520696350,
                limb2: 2463462585271942076,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_DOUBLE_EC_POINT_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 30438952894144031593970507942,
                limb1: 11624878374159450061801008870,
                limb2: 57949611680629167423471054844,
                limb3: 7650735250733096280713929356
            },
            u384 {
                limb0: 57184401038867865590487487064,
                limb1: 6328790681889781521705178539,
                limb2: 53000244676703635679067223961,
                limb3: 7592325591151621909492528647
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_DOUBLE_EC_POINT_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 76214127218128515082957104518,
                limb1: 69892540954950473074936881709,
                limb2: 15613688268136583826769739139,
                limb3: 1948169850523185640041007995
            },
            u384 {
                limb0: 29959044230042005818514044519,
                limb1: 67723124908785778946342829470,
                limb2: 71365913806860402187004190260,
                limb3: 799794467843113921314416077
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_DOUBLE_EC_POINT_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 14851398790425281408725747707,
                limb1: 54165005602420261392867141973,
                limb2: 145287008867519146,
                limb3: 0
            },
            u384 {
                limb0: 64053397048797885251156030001,
                limb1: 34360415572814481112505250496,
                limb2: 630702696590238794,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_DOUBLE_EC_POINT_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 64738051925517883470757500090,
                limb1: 74489092163442293378499844594,
                limb2: 1888842806392784043,
                limb3: 0
            },
            u384 {
                limb0: 61882520224793610057118644897,
                limb1: 51600441633547976350293086647,
                limb2: 2850111636632650310,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 23190786942654637927998312858,
                limb1: 51533703149629508113726820482,
                limb2: 23677845575104138786185028603,
                limb3: 1714864472688935466098073243
            },
            u384 {
                limb0: 948579824479117495763554222,
                limb1: 2881950833977188242293554635,
                limb2: 24591845582980178744284541476,
                limb3: 2754190916059889688307162807
            },
            u384 {
                limb0: 66466046950033152777488124104,
                limb1: 20219207088942308827699287653,
                limb2: 12708585001913390459135553847,
                limb3: 3672085802367182586192855009
            },
            u384 {
                limb0: 15934054615141244012547238316,
                limb1: 25359063384311972664746558861,
                limb2: 75954033411979690091752471103,
                limb3: 6374946457900294028978930117
            },
            u384 {
                limb0: 27981744695157186197662648517,
                limb1: 77491481431503163404034776005,
                limb2: 48066691563114112939128740296,
                limb3: 3920920531171560165298409543
            },
            u384 {
                limb0: 31090279229777142355933763059,
                limb1: 8387557671888197399101442264,
                limb2: 7008473728372992983576295250,
                limb3: 5309922750147582035629427275
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
            },
            u384 {
                limb0: 58247514047000673326953733421,
                limb1: 10569797218150830971634955722,
                limb2: 43259665565439599057250653538,
                limb3: 6365939481976508614542297210
            },
            u384 {
                limb0: 61730036016416933443554944004,
                limb1: 77708501871147916944663337801,
                limb2: 50051270608661453292999870395,
                limb3: 1335515306071121813647770946
            },
            u384 {
                limb0: 73949267877328342851350321422,
                limb1: 31550560087781981441883185687,
                limb2: 43023324265596570770670560569,
                limb3: 362674503930246033700862496
            },
            u384 {
                limb0: 15140773916091266809263008883,
                limb1: 68305651497972452750161514573,
                limb2: 68595606343843968562730711995,
                limb3: 2705806261126741954668659404
            },
            u384 {
                limb0: 29157482836910200457220954122,
                limb1: 31692990246474661176987618221,
                limb2: 70880484580307539847847438828,
                limb3: 3357656108903956795895826951
            },
            u384 {
                limb0: 39313269928267195370355159805,
                limb1: 29104221694752553153147397760,
                limb2: 41141271644650005218195381332,
                limb3: 818144750613678757874486955
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 76891102507805939066767218349,
                limb1: 18934709535954606871022441953,
                limb2: 9152350510837362923008628675,
                limb3: 7373290606664543017899718715
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 13268259472981868365421112389,
                limb1: 46352131756625236806836889929,
                limb2: 2843863423214240149,
                limb3: 0
            },
            u384 {
                limb0: 76737231855177948808203514245,
                limb1: 54634224157169326523931280027,
                limb2: 609293085769401994,
                limb3: 0
            },
            u384 {
                limb0: 32588232865761331317945543626,
                limb1: 42920692865198747596796644719,
                limb2: 1292288524620745949,
                limb3: 0
            },
            u384 {
                limb0: 22109629374835879147832829060,
                limb1: 77111384800343837264156671167,
                limb2: 3063898201025651161,
                limb3: 0
            },
            u384 {
                limb0: 24107147632521216287129241473,
                limb1: 46679700613611998209717953614,
                limb2: 2329384646076374441,
                limb3: 0
            },
            u384 {
                limb0: 34705519720342937325384114955,
                limb1: 7544545746441526561568429662,
                limb2: 321838271172728463,
                limb3: 0
            },
            u384 {
                limb0: 54240729226336754529891271225,
                limb1: 60872072766243616304862081407,
                limb2: 257968258960322105,
                limb3: 0
            },
            u384 {
                limb0: 2543242936061279358354121977,
                limb1: 31783549287040172917293284174,
                limb2: 305241059133926046,
                limb3: 0
            },
            u384 {
                limb0: 74705003839443619688298510508,
                limb1: 56879028618946847021972239934,
                limb2: 980566852076747479,
                limb3: 0
            },
            u384 {
                limb0: 31345188335193998570564539413,
                limb1: 50931972522891471604441323597,
                limb2: 658878908941684905,
                limb3: 0
            },
            u384 {
                limb0: 19539844265600609273886224350,
                limb1: 42702180300091913904288405785,
                limb2: 3444993136106080444,
                limb3: 0
            },
            u384 {
                limb0: 49711396943153995822956410677,
                limb1: 53913276305137721624552051841,
                limb2: 2750451209395678440,
                limb3: 0
            },
            u384 {
                limb0: 30234994542158251909307390480,
                limb1: 37082732317122305754957358281,
                limb2: 1159442963746785705,
                limb3: 0
            },
            u384 {
                limb0: 68197993831314783171983742905,
                limb1: 53897604287461337563561928239,
                limb2: 528276659766376889,
                limb3: 0
            },
            u384 {
                limb0: 42543172544982570052857664023,
                limb1: 60894664981146960725259421456,
                limb2: 1568782484594102931,
                limb3: 0
            },
            u384 {
                limb0: 34445652327236331720596696809,
                limb1: 257120338022751237048174282,
                limb2: 3330061854342727628,
                limb3: 0
            },
            u384 {
                limb0: 20867829993853018589638419949,
                limb1: 60368865098254360087322536075,
                limb2: 2341268480058990900,
                limb3: 0
            },
            u384 {
                limb0: 68969586761391561090281896559,
                limb1: 66683915952894400650221431918,
                limb2: 2341181818185855399,
                limb3: 0
            },
            u384 {
                limb0: 42018946958951763195093848207,
                limb1: 47453279052251022910409565149,
                limb2: 2253296117258904635,
                limb3: 0
            },
            u384 {
                limb0: 4589304846514288715766513407,
                limb1: 44950647632290901991879197353,
                limb2: 363202783876958070,
                limb3: 0
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 11700412489472584404906732428,
                limb1: 7017305906384258990996142651,
                limb2: 2188885089417606049,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 12430989948664808994241301926,
                limb1: 4093368143640501464664670717,
                limb2: 15462147561276158799106237558,
                limb3: 1667895780299146974566946786
            },
            u384 {
                limb0: 28024704109155327036287002204,
                limb1: 31711932875333925759295774991,
                limb2: 68182048002205124895704611962,
                limb3: 2620282031403213299743592252
            },
            u384 {
                limb0: 24363876268511953156665213928,
                limb1: 44120557724986152999522536242,
                limb2: 32644216006826340694302735081,
                limb3: 5978556081050966686408473022
            },
            u384 {
                limb0: 23245801630578026645014902892,
                limb1: 41821247742038219520668640991,
                limb2: 23700901209691784152598121101,
                limb3: 2518016620058886992756048254
            },
            u384 {
                limb0: 11503743565308119947376390714,
                limb1: 64276006918226844507365534387,
                limb2: 431887945103229227339918623,
                limb3: 6377938769931157688865234540
            },
            u384 {
                limb0: 71479442553884072415076480166,
                limb1: 39388230984148411150262682166,
                limb2: 54038477610559005443856988467,
                limb3: 91965736540864445818897648
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
            },
            u384 {
                limb0: 60764752087874078749903320152,
                limb1: 48971594630374720657631450484,
                limb2: 39458640027008148540971347284,
                limb3: 5403137681520926664036797617
            },
            u384 {
                limb0: 75793635447577760130681793522,
                limb1: 19401226453399426410086795837,
                limb2: 54270565591339164029467757296,
                limb3: 4491683571141144293364051458
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 2609718045099109344619142549,
                limb1: 24637207683730425919859648074,
                limb2: 73520284553909715171100436966,
                limb3: 6243792129865244272399829854
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 72352229351541557974185256159,
                limb1: 109695862189705609719928842,
                limb2: 586385101556276692,
                limb3: 0
            },
            u384 {
                limb0: 67992600012982420926133220046,
                limb1: 23077548885373181195572604447,
                limb2: 2828225239011667775,
                limb3: 0
            },
            u384 {
                limb0: 53667012199774782546845025478,
                limb1: 13988392951643632014579812896,
                limb2: 2855263762372963376,
                limb3: 0
            },
            u384 {
                limb0: 44657725054425516182046824655,
                limb1: 11558627534921529854849092531,
                limb2: 652105213504402783,
                limb3: 0
            },
            u384 {
                limb0: 1840421064017092026928335363,
                limb1: 27948250785264884498918334154,
                limb2: 1068426233884146722,
                limb3: 0
            },
            u384 {
                limb0: 72458689863252062882649001148,
                limb1: 57036135675129203477209168166,
                limb2: 2976109614092192022,
                limb3: 0
            },
            u384 {
                limb0: 10172219962658913022154488244,
                limb1: 75017080977665226557673008652,
                limb2: 761513689810464176,
                limb3: 0
            },
            u384 {
                limb0: 57831097157244995651582775035,
                limb1: 56485637013277440733112642140,
                limb2: 1840027204273873818,
                limb3: 0
            },
            u384 {
                limb0: 51488644415329370925019831230,
                limb1: 71274770803685296705510079601,
                limb2: 2082112336717404596,
                limb3: 0
            },
            u384 {
                limb0: 17802357378338648940166652311,
                limb1: 1666505890335566830781071452,
                limb2: 2554512134891071074,
                limb3: 0
            },
            u384 {
                limb0: 17447419136232834430860315795,
                limb1: 56080937434418198093665616470,
                limb2: 271507322399880886,
                limb3: 0
            },
            u384 {
                limb0: 71734764027497687440959466964,
                limb1: 26179242522752084688581078523,
                limb2: 2371126598316569875,
                limb3: 0
            },
            u384 {
                limb0: 53001879985015283259353718573,
                limb1: 42722513826086271939214843879,
                limb2: 3335874891481034863,
                limb3: 0
            },
            u384 {
                limb0: 45242695156380974609575304310,
                limb1: 19252224704182182869429558083,
                limb2: 2181202683696566687,
                limb3: 0
            },
            u384 {
                limb0: 15085828163067877367322517405,
                limb1: 52209992599600172477278698580,
                limb2: 1633909151565962963,
                limb3: 0
            },
            u384 {
                limb0: 37001506145532468353282582033,
                limb1: 4291883352266323174688581548,
                limb2: 3013531520861314659,
                limb3: 0
            },
            u384 {
                limb0: 19700584396745388153764221534,
                limb1: 42488934677374555174315232256,
                limb2: 646476748448880253,
                limb3: 0
            },
            u384 {
                limb0: 22068620180697579185898549089,
                limb1: 69283915317002778409893284629,
                limb2: 347651441635828348,
                limb3: 0
            },
            u384 {
                limb0: 68243106492345335480105108532,
                limb1: 7757128702044682744238220654,
                limb2: 3007487481293790040,
                limb3: 0
            },
            u384 {
                limb0: 66236929673530884233645586901,
                limb1: 7389038283343813755265297320,
                limb2: 3475207490854347497,
                limb3: 0
            },
            u384 {
                limb0: 4645575212695119035598803845,
                limb1: 170766220800888265123408008,
                limb2: 1800502560172094280,
                limb3: 0
            },
            u384 {
                limb0: 62120472738151456561021868284,
                limb1: 22599772358810472611047161037,
                limb2: 3212461292401604586,
                limb3: 0
            },
            u384 {
                limb0: 78865510699530816999690257603,
                limb1: 52438847471388457525305827726,
                limb2: 2244375768231156426,
                limb3: 0
            },
            u384 {
                limb0: 23507616024573787281496785879,
                limb1: 4633523845333701238548283116,
                limb2: 3392988848811485376,
                limb3: 0
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 56149420417655143552764995406,
                limb1: 59978217342842349576011470883,
                limb2: 3373506507271656045,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 48839749009103782507783367452,
                limb1: 34428548770130333860477102223,
                limb2: 9109870439970883494521435807,
                limb3: 4544385949090286500948314384
            },
            u384 {
                limb0: 74994170139779222845948269711,
                limb1: 31399726067193799626104585826,
                limb2: 78086235841218139060547023797,
                limb3: 7882078750053668433232463977
            },
            u384 {
                limb0: 57270616668750985311565784598,
                limb1: 43119694190361155351410002942,
                limb2: 67504563008413813317455897414,
                limb3: 6183018010816292329391680372
            },
            u384 {
                limb0: 30876392376095068042043911339,
                limb1: 46789645864631132829443404052,
                limb2: 64428927351841604012381638577,
                limb3: 6150265427925661336787270878
            },
            u384 {
                limb0: 75681599359438957743197537025,
                limb1: 51709024024534955612554469734,
                limb2: 42726605613341599596612351380,
                limb3: 7209729965231887620029340547
            },
            u384 {
                limb0: 31288116175861124905867689254,
                limb1: 21289333174520947310574898673,
                limb2: 44201919183949355578539519184,
                limb3: 4143593134827477039323590346
            },
            u384 {
                limb0: 48064578018082300610169461290,
                limb1: 68253879289511411247955277989,
                limb2: 58169297172506380213854576972,
                limb3: 3420384326213041003758033266
            },
            u384 {
                limb0: 10360361760042969780406328942,
                limb1: 40800929632893017027277156576,
                limb2: 25282965684603596983239204800,
                limb3: 1213398222873456066244544601
            },
            u384 {
                limb0: 19642157698477259284320683538,
                limb1: 4009364390011265313965903514,
                limb2: 30435484982713293189942039907,
                limb3: 4141005917757073192130303891
            },
            u384 {
                limb0: 68556723077630141383278765066,
                limb1: 64450354958247639583578511279,
                limb2: 45769082499545055570586424685,
                limb3: 1880025864162848678757523327
            },
            u384 {
                limb0: 39476662811943484528625708076,
                limb1: 36984904280691813400381479402,
                limb2: 24445095324632232051189135176,
                limb3: 891802972730580130986174606
            },
            u384 {
                limb0: 40045436017096087305216247527,
                limb1: 19072488161436698459058802990,
                limb2: 27959229893603784593679561830,
                limb3: 2786418177050091472037403663
            },
            u384 {
                limb0: 69906135456451231594610516721,
                limb1: 53282571737198360719513681564,
                limb2: 42521022107923634489331835200,
                limb3: 1064599542627165695439792654
            },
            u384 {
                limb0: 69915346460617944663644522573,
                limb1: 28979890201216361489201659621,
                limb2: 28992544034480197337642442220,
                limb3: 506641198432921025078690172
            },
            u384 {
                limb0: 15422181854611521415463959119,
                limb1: 22865382472193769054143404969,
                limb2: 39951239267883031545972455942,
                limb3: 5445520904789570749217795235
            },
            u384 {
                limb0: 78363838989302665816523392567,
                limb1: 48411825622227047920593322655,
                limb2: 77254019783559425082748724776,
                limb3: 3695977290556157437038042667
            },
            u384 {
                limb0: 26865104976650633113549824616,
                limb1: 28966321112217522923444769064,
                limb2: 15770990131560501570007557575,
                limb3: 3975145133958004728839996185
            },
            u384 {
                limb0: 3589301718409097877427395344,
                limb1: 56536570778325254642634998789,
                limb2: 37533878725578178034869086174,
                limb3: 1475036879398203511228529935
            },
            u384 {
                limb0: 40842572263389068264383701924,
                limb1: 73790633515474674021405601755,
                limb2: 12874738550256158281932343385,
                limb3: 6105525120501285282165337065
            },
            u384 {
                limb0: 23707786858539703201169672349,
                limb1: 40193634114222454687519364805,
                limb2: 42176306680298273827923346921,
                limb3: 5574931860096054091776956190
            },
            u384 {
                limb0: 64630281259129928955639829277,
                limb1: 26243504144747109540436267483,
                limb2: 77635520605191798386321167228,
                limb3: 3047093665289821358483726870
            },
            u384 {
                limb0: 57466104163159058530556190598,
                limb1: 49855152079105017314422154037,
                limb2: 37600910592607430664963381523,
                limb3: 6492658507779856537906433387
            },
            u384 {
                limb0: 61493891020894930002615493956,
                limb1: 18027831752766582418503558364,
                limb2: 46231477092615081153151217031,
                limb3: 5191745567624287838273450260
            },
            u384 {
                limb0: 49100529186714387157413776454,
                limb1: 30121781772448878626463323719,
                limb2: 53932740959541852800858497276,
                limb3: 5670461244822498047917332494
            },
            u384 {
                limb0: 8706820308586522890886550258,
                limb1: 34942675417748493104475225591,
                limb2: 11997620497803898530042881671,
                limb3: 2019245404010916077836419322
            },
            u384 {
                limb0: 61399631249056930361219382882,
                limb1: 37364433927983148025017652084,
                limb2: 58299035033350864679883307818,
                limb3: 6989659358339779411718899235
            },
            u384 {
                limb0: 72265921096225073271030525687,
                limb1: 43280223428508128796238087141,
                limb2: 61163332094691932208117222730,
                limb3: 6741780712043553045190973770
            },
            u384 {
                limb0: 54929939477564818470244181949,
                limb1: 38360700049932423186371919202,
                limb2: 19531258280549022459288369525,
                limb3: 2956192537240636010175198860
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 77514088270106673020948454845,
                limb1: 64786933115492028388191968194,
                limb2: 45887094027542265086105457298,
                limb3: 54459443084979794041134849
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 60560709830483091375804020284,
                limb1: 43197816287652788845584008834,
                limb2: 952729612994221368,
                limb3: 0
            },
            u384 {
                limb0: 10492971140459274210700811770,
                limb1: 44513061576255265500981326083,
                limb2: 1067917977423273551,
                limb3: 0
            },
            u384 {
                limb0: 39116622780220397755667403458,
                limb1: 22352500441126699540646417604,
                limb2: 3063271674606767109,
                limb3: 0
            },
            u384 {
                limb0: 37270314562710266601265233496,
                limb1: 70170752127981054059805844972,
                limb2: 859714678417469440,
                limb3: 0
            },
            u384 {
                limb0: 7623391984462887236582266015,
                limb1: 42491402479383729878308216988,
                limb2: 3452782009672681354,
                limb3: 0
            },
            u384 {
                limb0: 64559904209742266183304320555,
                limb1: 69704337930866810693557616486,
                limb2: 3299664043155415477,
                limb3: 0
            },
            u384 {
                limb0: 67559430074253106794595011940,
                limb1: 4506464022247638802529509883,
                limb2: 2341945580717447970,
                limb3: 0
            },
            u384 {
                limb0: 9498395769183164685220205206,
                limb1: 45134336288613177510213742987,
                limb2: 2669792903937128468,
                limb3: 0
            },
            u384 {
                limb0: 49072459003494725393436534870,
                limb1: 52082467902580653677531159892,
                limb2: 2606649103654554636,
                limb3: 0
            },
            u384 {
                limb0: 74055059530330231771921454741,
                limb1: 53061158448153114658671266402,
                limb2: 1448917347914504333,
                limb3: 0
            },
            u384 {
                limb0: 31357385428746531424018531805,
                limb1: 51141841383992554608876666149,
                limb2: 2108576180504140738,
                limb3: 0
            },
            u384 {
                limb0: 59568841990531844953896713482,
                limb1: 738046613222001001099970651,
                limb2: 2864591434320851751,
                limb3: 0
            },
            u384 {
                limb0: 78918891441719414915281368514,
                limb1: 42595786019864910729645154069,
                limb2: 2332981375169284075,
                limb3: 0
            },
            u384 {
                limb0: 73940426017474097647230135471,
                limb1: 5450208962476772138591757465,
                limb2: 1126563023504792259,
                limb3: 0
            },
            u384 {
                limb0: 12497991859429624369378841554,
                limb1: 43038160816172651229416840480,
                limb2: 1395114064909906243,
                limb3: 0
            },
            u384 {
                limb0: 78216661607741669574274640364,
                limb1: 41906999438047143355081431569,
                limb2: 3079975387921428976,
                limb3: 0
            },
            u384 {
                limb0: 9145201159815867598203053839,
                limb1: 58820309865218752061636884055,
                limb2: 716876953711284375,
                limb3: 0
            },
            u384 {
                limb0: 47919555913202845524736646361,
                limb1: 27165775241744433059614937901,
                limb2: 3170520892864132107,
                limb3: 0
            },
            u384 {
                limb0: 7312637792304348806296256704,
                limb1: 65707725566676067595956811555,
                limb2: 203314316937823219,
                limb3: 0
            },
            u384 {
                limb0: 61094359288010675957661195982,
                limb1: 77627591411109742420212671904,
                limb2: 745165346533507101,
                limb3: 0
            },
            u384 {
                limb0: 43708626113706013141793591071,
                limb1: 44439620535069455225037692732,
                limb2: 515927216987158182,
                limb3: 0
            },
            u384 {
                limb0: 69966896750444602556632215137,
                limb1: 11809297346016666377576163689,
                limb2: 166150464296701499,
                limb3: 0
            },
            u384 {
                limb0: 46151162575772561405597189355,
                limb1: 34051211886365655982861863138,
                limb2: 192901580404573442,
                limb3: 0
            },
            u384 {
                limb0: 71224651109362605387179230439,
                limb1: 77025323316292258909086735111,
                limb2: 183982628697211185,
                limb3: 0
            },
            u384 {
                limb0: 16643977945356356981949983936,
                limb1: 52839909067565107751874718774,
                limb2: 1631054796495564483,
                limb3: 0
            },
            u384 {
                limb0: 70048367821558724187387179708,
                limb1: 77155317606823885789624872003,
                limb2: 3456355443560131626,
                limb3: 0
            },
            u384 {
                limb0: 73746832228116322001147796294,
                limb1: 53075510893070141178755025066,
                limb2: 3389854563291057351,
                limb3: 0
            },
            u384 {
                limb0: 21138526233002691845902124138,
                limb1: 55560982282160920599510200465,
                limb2: 1764162309832058791,
                limb3: 0
            }
        ];
        let got = run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 2416167632796175225590722157,
                limb1: 48551152508610380532404214460,
                limb2: 2551930387880968103,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_G2_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 46806776863449525277463128885,
                limb1: 74264233834072686015889351085,
                limb2: 56416510031808503640236731969,
                limb3: 3014182144541551908077651876
            },
            u384 {
                limb0: 26304510027230690107436767274,
                limb1: 58635985286184027444201487362,
                limb2: 39231697390315165518171579204,
                limb3: 2569021924640935475243051682
            },
            u384 {
                limb0: 69439209360712733097515821979,
                limb1: 72402770113326050206143860957,
                limb2: 44567176906312973832450698280,
                limb3: 7381435055718928949512358701
            },
            u384 {
                limb0: 20170011011660279030913068082,
                limb1: 26413077674772781004537786179,
                limb2: 32144069241290405660577982445,
                limb3: 6698339096995733235926694468
            },
            u384 {
                limb0: 73905509664260742202038610125,
                limb1: 41921685195227558433855159575,
                limb2: 67808545378987435056965365910,
                limb3: 4735618301712211913515537638
            },
            u384 {
                limb0: 77313114189912165354081620508,
                limb1: 61082723253525694988585347373,
                limb2: 48744407599403170955862443035,
                limb3: 7967892484204534143265734014
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_IS_ON_CURVE_G1_G2_circuit(input, 1);
        let exp = array![
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_G2_circuit_BN254() {
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
        let got = run_IS_ON_CURVE_G1_G2_circuit(input, 0);
        let exp = array![
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 72119456892574327087895430824,
                limb1: 17296066240093314917779201991,
                limb2: 39199516670365472300772300498,
                limb3: 4829915475023326775314724059
            },
            u384 {
                limb0: 35641563017940795158065637280,
                limb1: 10403221229108363244854674749,
                limb2: 35492084715787433638506996176,
                limb3: 4304853606181542937569089117
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
            u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_IS_ON_CURVE_G1_circuit(input, 1);
        let exp = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_IS_ON_CURVE_G1_circuit_BN254() {
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
        let got = run_IS_ON_CURVE_G1_circuit(input, 0);
        let exp = array![u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_RHS_FINALIZE_ACC_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 67018490718989488556366582278,
                limb1: 9877990626482080858397385525,
                limb2: 60460344339103332084735402960,
                limb3: 4449841983249050318869772987
            },
            u384 {
                limb0: 47155157580410154244586791027,
                limb1: 32580270077309149637595426587,
                limb2: 57209453349698553721739001605,
                limb3: 7373228604366906540939927371
            },
            u384 {
                limb0: 47840487593603415292794737343,
                limb1: 71112324679872669027813793391,
                limb2: 53854423044626140133246332943,
                limb3: 3601022549561483554696089075
            },
            u384 {
                limb0: 54413571308220951694408654991,
                limb1: 9340021380150954005637346220,
                limb2: 5608037228891323312037787125,
                limb3: 5711438324683376021852211466
            },
            u384 {
                limb0: 48431370088931500816788116296,
                limb1: 40912237208773069114775416060,
                limb2: 54151487610586160622601084297,
                limb3: 2156732182859838941626607689
            },
            u384 {
                limb0: 43107433463842223331482120752,
                limb1: 57709163549598318046812828012,
                limb2: 28481152534074743932059040869,
                limb3: 4142020926115684851821687321
            }
        ];
        let got = run_RHS_FINALIZE_ACC_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 33998964370520736199086627959,
                limb1: 30749376387371893820661010209,
                limb2: 12037988041978887193413997419,
                limb3: 5819611598165301259903898929
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_RHS_FINALIZE_ACC_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 48260330286441674708424697259,
                limb1: 42318920684542540519119384547,
                limb2: 1128991126786149844,
                limb3: 0
            },
            u384 {
                limb0: 7938632032443998648511649961,
                limb1: 17356141526537130956730385433,
                limb2: 1071065699868464167,
                limb3: 0
            },
            u384 {
                limb0: 37619741555986601766966302341,
                limb1: 43774217688409160760116850140,
                limb2: 765995078829870260,
                limb3: 0
            },
            u384 {
                limb0: 25465506521267819856047091585,
                limb1: 36391637133555566268841396773,
                limb2: 847591488136361640,
                limb3: 0
            },
            u384 {
                limb0: 22807643629428285123183151353,
                limb1: 55708330713379591852963876440,
                limb2: 2683820433665504527,
                limb3: 0
            },
            u384 {
                limb0: 17858926073002335585446583990,
                limb1: 62282319402827862502223658486,
                limb2: 641547017572429827,
                limb3: 0
            }
        ];
        let got = run_RHS_FINALIZE_ACC_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 43020444810219973869643857067,
                limb1: 78487722760902767733668096942,
                limb2: 2450254110215152594,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_SLOPE_INTERCEPT_SAME_POINT_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 28925677528230177705184246157,
                limb1: 58723827335969265142494085461,
                limb2: 62934633389716063287037580157,
                limb3: 4634226478207006418146872589
            },
            u384 {
                limb0: 1508478943791420831635186886,
                limb1: 74931160670983153988520954343,
                limb2: 19184287737308570044351310884,
                limb3: 7455302980839713006092163310
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_SLOPE_INTERCEPT_SAME_POINT_circuit(input, 1);
        let exp = array![
            u384 {
                limb0: 60580535867653841428807408826,
                limb1: 22872052533000939074413562640,
                limb2: 19872895635177359725568692929,
                limb3: 242067589895218022892677380
            },
            u384 {
                limb0: 50069630649302370380792978733,
                limb1: 16203124929632156842349921230,
                limb2: 32959068055930065910611555800,
                limb3: 6650484703201720346640295174
            },
            u384 {
                limb0: 17900009223516063749586107565,
                limb1: 58990724765685700438729174672,
                limb2: 38756440383934055543468236330,
                limb3: 771421283927735791526579107
            },
            u384 {
                limb0: 54472844784743731813670542972,
                limb1: 20293667423333696070980186503,
                limb2: 44411860245550293963729898050,
                limb3: 7685015612656139680147727083
            },
            u384 {
                limb0: 19019221600860294468723432741,
                limb1: 60523923972777968619074021842,
                limb2: 68838918577573669841158667344,
                limb3: 404634761451724415252822711
            },
            u384 {
                limb0: 31966708881998342161982443100,
                limb1: 46715798023932567532533568431,
                limb2: 49920108622044534569629641101,
                limb3: 7968403363747480550053793893
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }


    #[test]
    fn test_run_SLOPE_INTERCEPT_SAME_POINT_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 6754777447406199233880053248,
                limb1: 29592157390458577971370257756,
                limb2: 3000117645115658293,
                limb3: 0
            },
            u384 {
                limb0: 74292046482889929051988509288,
                limb1: 63954496481719982841226773346,
                limb2: 2481793984440015144,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let got = run_SLOPE_INTERCEPT_SAME_POINT_circuit(input, 0);
        let exp = array![
            u384 {
                limb0: 28410243153404370084288088563,
                limb1: 39482639662138611135709072649,
                limb2: 763429169832334703,
                limb3: 0
            },
            u384 {
                limb0: 63347016304765991054776207810,
                limb1: 25366636730535729198773503339,
                limb2: 3045097332156004237,
                limb3: 0
            },
            u384 {
                limb0: 7029259507251224309510592606,
                limb1: 4394235099959160960573638211,
                limb2: 2360694219009690802,
                limb3: 0
            },
            u384 {
                limb0: 10873665323371506257584653620,
                limb1: 26056128684821873069202969974,
                limb2: 190976246494716538,
                limb3: 0
            },
            u384 {
                limb0: 1010842944790402801638352442,
                limb1: 36815218695260472920363455031,
                limb2: 114829169171683136,
                limb3: 0
            },
            u384 {
                limb0: 55742525314635411403384754075,
                limb1: 14892224453606490110825079477,
                limb2: 2074969096309984395,
                limb3: 0
            }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
    }
}
