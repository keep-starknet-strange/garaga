use core::circuit::{
    RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{get_a, get_b, get_p, get_g, get_min_one, G1Point};
use core::option::Option;
fn get_BLS12_381_FP12_MUL_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};

    // INPUT stack
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

    // COMMIT stack
    let in27 = CircuitElement::<CircuitInput<27>> {};
    let in28 = CircuitElement::<CircuitInput<28>> {};
    let in29 = CircuitElement::<CircuitInput<29>> {};
    let in30 = CircuitElement::<CircuitInput<30>> {};
    let in31 = CircuitElement::<CircuitInput<31>> {};
    let in32 = CircuitElement::<CircuitInput<32>> {};
    let in33 = CircuitElement::<CircuitInput<33>> {};
    let in34 = CircuitElement::<CircuitInput<34>> {};
    let in35 = CircuitElement::<CircuitInput<35>> {};
    let in36 = CircuitElement::<CircuitInput<36>> {};
    let in37 = CircuitElement::<CircuitInput<37>> {};
    let in38 = CircuitElement::<CircuitInput<38>> {};
    let in39 = CircuitElement::<CircuitInput<39>> {};
    let in40 = CircuitElement::<CircuitInput<40>> {};
    let in41 = CircuitElement::<CircuitInput<41>> {};
    let in42 = CircuitElement::<CircuitInput<42>> {};
    let in43 = CircuitElement::<CircuitInput<43>> {};
    let in44 = CircuitElement::<CircuitInput<44>> {};
    let in45 = CircuitElement::<CircuitInput<45>> {};
    let in46 = CircuitElement::<CircuitInput<46>> {};
    let in47 = CircuitElement::<CircuitInput<47>> {};
    let in48 = CircuitElement::<CircuitInput<48>> {};
    let in49 = CircuitElement::<CircuitInput<49>> {};

    // FELT stack
    let in50 = CircuitElement::<CircuitInput<50>> {};
    let in51 = CircuitElement::<CircuitInput<51>> {};
    let t0 = circuit_mul(in50, in50);
    let t1 = circuit_mul(t0, in50);
    let t2 = circuit_mul(t1, in50);
    let t3 = circuit_mul(t2, in50);
    let t4 = circuit_mul(t3, in50);
    let t5 = circuit_mul(t4, in50);
    let t6 = circuit_mul(t5, in50);
    let t7 = circuit_mul(t6, in50);
    let t8 = circuit_mul(t7, in50);
    let t9 = circuit_mul(t8, in50);
    let t10 = circuit_mul(t9, in50);
    let t11 = circuit_mul(in4, in50);
    let t12 = circuit_add(in3, t11);
    let t13 = circuit_mul(in5, t0);
    let t14 = circuit_add(t12, t13);
    let t15 = circuit_mul(in6, t1);
    let t16 = circuit_add(t14, t15);
    let t17 = circuit_mul(in7, t2);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_mul(in8, t3);
    let t20 = circuit_add(t18, t19);
    let t21 = circuit_mul(in9, t4);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_mul(in10, t5);
    let t24 = circuit_add(t22, t23);
    let t25 = circuit_mul(in11, t6);
    let t26 = circuit_add(t24, t25);
    let t27 = circuit_mul(in12, t7);
    let t28 = circuit_add(t26, t27);
    let t29 = circuit_mul(in13, t8);
    let t30 = circuit_add(t28, t29);
    let t31 = circuit_mul(in14, t9);
    let t32 = circuit_add(t30, t31);
    let t33 = circuit_mul(in16, in50);
    let t34 = circuit_add(in15, t33);
    let t35 = circuit_mul(in17, t0);
    let t36 = circuit_add(t34, t35);
    let t37 = circuit_mul(in18, t1);
    let t38 = circuit_add(t36, t37);
    let t39 = circuit_mul(in19, t2);
    let t40 = circuit_add(t38, t39);
    let t41 = circuit_mul(in20, t3);
    let t42 = circuit_add(t40, t41);
    let t43 = circuit_mul(in21, t4);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_mul(in22, t5);
    let t46 = circuit_add(t44, t45);
    let t47 = circuit_mul(in23, t6);
    let t48 = circuit_add(t46, t47);
    let t49 = circuit_mul(in24, t7);
    let t50 = circuit_add(t48, t49);
    let t51 = circuit_mul(in25, t8);
    let t52 = circuit_add(t50, t51);
    let t53 = circuit_mul(in26, t9);
    let t54 = circuit_add(t52, t53);
    let t55 = circuit_mul(t32, t54);
    let t56 = circuit_mul(in51, t55);
    let t57 = circuit_mul(in51, in27);
    let t58 = circuit_mul(in51, in28);
    let t59 = circuit_mul(in51, in29);
    let t60 = circuit_mul(in51, in30);
    let t61 = circuit_mul(in51, in31);
    let t62 = circuit_mul(in51, in32);
    let t63 = circuit_mul(in51, in33);
    let t64 = circuit_mul(in51, in34);
    let t65 = circuit_mul(in51, in35);
    let t66 = circuit_mul(in51, in36);
    let t67 = circuit_mul(in51, in37);
    let t68 = circuit_mul(in51, in38);
    let t69 = circuit_mul(in40, in50);
    let t70 = circuit_add(in39, t69);
    let t71 = circuit_mul(in41, t0);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_mul(in42, t1);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_mul(in43, t2);
    let t76 = circuit_add(t74, t75);
    let t77 = circuit_mul(in44, t3);
    let t78 = circuit_add(t76, t77);
    let t79 = circuit_mul(in45, t4);
    let t80 = circuit_add(t78, t79);
    let t81 = circuit_mul(in46, t5);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_mul(in47, t6);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_mul(in48, t7);
    let t86 = circuit_add(t84, t85);
    let t87 = circuit_mul(in49, t8);
    let t88 = circuit_add(t86, t87);
    let t89 = circuit_mul(in1, t4);
    let t90 = circuit_add(in0, t89);
    let t91 = circuit_mul(in2, t10);
    let t92 = circuit_add(t90, t91);
    let t93 = circuit_mul(t58, in50);
    let t94 = circuit_add(t57, t93);
    let t95 = circuit_mul(t59, t0);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_mul(t60, t1);
    let t98 = circuit_add(t96, t97);
    let t99 = circuit_mul(t61, t2);
    let t100 = circuit_add(t98, t99);
    let t101 = circuit_mul(t62, t3);
    let t102 = circuit_add(t100, t101);
    let t103 = circuit_mul(t63, t4);
    let t104 = circuit_add(t102, t103);
    let t105 = circuit_mul(t64, t5);
    let t106 = circuit_add(t104, t105);
    let t107 = circuit_mul(t65, t6);
    let t108 = circuit_add(t106, t107);
    let t109 = circuit_mul(t66, t7);
    let t110 = circuit_add(t108, t109);
    let t111 = circuit_mul(t67, t8);
    let t112 = circuit_add(t110, t111);
    let t113 = circuit_mul(t68, t9);
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_mul(t88, t92);
    let t116 = circuit_add(t115, t114);
    let t117 = circuit_sub(t116, t56);
    // commit_start_index=27, commit_end_index-1=49
    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (
        in27, in28, in29, in30, in31, in32, in33, in34, in35, in36, in37, in38, t117,
    )
        .new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(in27);
    let o1 = outputs.get_output(in28);
    let o2 = outputs.get_output(in29);
    let o3 = outputs.get_output(in30);
    let o4 = outputs.get_output(in31);
    let o5 = outputs.get_output(in32);
    let o6 = outputs.get_output(in33);
    let o7 = outputs.get_output(in34);
    let o8 = outputs.get_output(in35);
    let o9 = outputs.get_output(in36);
    let o10 = outputs.get_output(in37);
    let o11 = outputs.get_output(in38);
    let o12 = outputs.get_output(t117);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12];
    return res;
}

fn get_BN254_FP12_MUL_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {};
    let in1 = CircuitElement::<CircuitInput<1>> {};
    let in2 = CircuitElement::<CircuitInput<2>> {};

    // INPUT stack
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

    // COMMIT stack
    let in27 = CircuitElement::<CircuitInput<27>> {};
    let in28 = CircuitElement::<CircuitInput<28>> {};
    let in29 = CircuitElement::<CircuitInput<29>> {};
    let in30 = CircuitElement::<CircuitInput<30>> {};
    let in31 = CircuitElement::<CircuitInput<31>> {};
    let in32 = CircuitElement::<CircuitInput<32>> {};
    let in33 = CircuitElement::<CircuitInput<33>> {};
    let in34 = CircuitElement::<CircuitInput<34>> {};
    let in35 = CircuitElement::<CircuitInput<35>> {};
    let in36 = CircuitElement::<CircuitInput<36>> {};
    let in37 = CircuitElement::<CircuitInput<37>> {};
    let in38 = CircuitElement::<CircuitInput<38>> {};
    let in39 = CircuitElement::<CircuitInput<39>> {};
    let in40 = CircuitElement::<CircuitInput<40>> {};
    let in41 = CircuitElement::<CircuitInput<41>> {};
    let in42 = CircuitElement::<CircuitInput<42>> {};
    let in43 = CircuitElement::<CircuitInput<43>> {};
    let in44 = CircuitElement::<CircuitInput<44>> {};
    let in45 = CircuitElement::<CircuitInput<45>> {};
    let in46 = CircuitElement::<CircuitInput<46>> {};
    let in47 = CircuitElement::<CircuitInput<47>> {};
    let in48 = CircuitElement::<CircuitInput<48>> {};
    let in49 = CircuitElement::<CircuitInput<49>> {};

    // FELT stack
    let in50 = CircuitElement::<CircuitInput<50>> {};
    let in51 = CircuitElement::<CircuitInput<51>> {};
    let t0 = circuit_mul(in50, in50);
    let t1 = circuit_mul(t0, in50);
    let t2 = circuit_mul(t1, in50);
    let t3 = circuit_mul(t2, in50);
    let t4 = circuit_mul(t3, in50);
    let t5 = circuit_mul(t4, in50);
    let t6 = circuit_mul(t5, in50);
    let t7 = circuit_mul(t6, in50);
    let t8 = circuit_mul(t7, in50);
    let t9 = circuit_mul(t8, in50);
    let t10 = circuit_mul(t9, in50);
    let t11 = circuit_mul(in4, in50);
    let t12 = circuit_add(in3, t11);
    let t13 = circuit_mul(in5, t0);
    let t14 = circuit_add(t12, t13);
    let t15 = circuit_mul(in6, t1);
    let t16 = circuit_add(t14, t15);
    let t17 = circuit_mul(in7, t2);
    let t18 = circuit_add(t16, t17);
    let t19 = circuit_mul(in8, t3);
    let t20 = circuit_add(t18, t19);
    let t21 = circuit_mul(in9, t4);
    let t22 = circuit_add(t20, t21);
    let t23 = circuit_mul(in10, t5);
    let t24 = circuit_add(t22, t23);
    let t25 = circuit_mul(in11, t6);
    let t26 = circuit_add(t24, t25);
    let t27 = circuit_mul(in12, t7);
    let t28 = circuit_add(t26, t27);
    let t29 = circuit_mul(in13, t8);
    let t30 = circuit_add(t28, t29);
    let t31 = circuit_mul(in14, t9);
    let t32 = circuit_add(t30, t31);
    let t33 = circuit_mul(in16, in50);
    let t34 = circuit_add(in15, t33);
    let t35 = circuit_mul(in17, t0);
    let t36 = circuit_add(t34, t35);
    let t37 = circuit_mul(in18, t1);
    let t38 = circuit_add(t36, t37);
    let t39 = circuit_mul(in19, t2);
    let t40 = circuit_add(t38, t39);
    let t41 = circuit_mul(in20, t3);
    let t42 = circuit_add(t40, t41);
    let t43 = circuit_mul(in21, t4);
    let t44 = circuit_add(t42, t43);
    let t45 = circuit_mul(in22, t5);
    let t46 = circuit_add(t44, t45);
    let t47 = circuit_mul(in23, t6);
    let t48 = circuit_add(t46, t47);
    let t49 = circuit_mul(in24, t7);
    let t50 = circuit_add(t48, t49);
    let t51 = circuit_mul(in25, t8);
    let t52 = circuit_add(t50, t51);
    let t53 = circuit_mul(in26, t9);
    let t54 = circuit_add(t52, t53);
    let t55 = circuit_mul(t32, t54);
    let t56 = circuit_mul(in51, t55);
    let t57 = circuit_mul(in51, in27);
    let t58 = circuit_mul(in51, in28);
    let t59 = circuit_mul(in51, in29);
    let t60 = circuit_mul(in51, in30);
    let t61 = circuit_mul(in51, in31);
    let t62 = circuit_mul(in51, in32);
    let t63 = circuit_mul(in51, in33);
    let t64 = circuit_mul(in51, in34);
    let t65 = circuit_mul(in51, in35);
    let t66 = circuit_mul(in51, in36);
    let t67 = circuit_mul(in51, in37);
    let t68 = circuit_mul(in51, in38);
    let t69 = circuit_mul(in40, in50);
    let t70 = circuit_add(in39, t69);
    let t71 = circuit_mul(in41, t0);
    let t72 = circuit_add(t70, t71);
    let t73 = circuit_mul(in42, t1);
    let t74 = circuit_add(t72, t73);
    let t75 = circuit_mul(in43, t2);
    let t76 = circuit_add(t74, t75);
    let t77 = circuit_mul(in44, t3);
    let t78 = circuit_add(t76, t77);
    let t79 = circuit_mul(in45, t4);
    let t80 = circuit_add(t78, t79);
    let t81 = circuit_mul(in46, t5);
    let t82 = circuit_add(t80, t81);
    let t83 = circuit_mul(in47, t6);
    let t84 = circuit_add(t82, t83);
    let t85 = circuit_mul(in48, t7);
    let t86 = circuit_add(t84, t85);
    let t87 = circuit_mul(in49, t8);
    let t88 = circuit_add(t86, t87);
    let t89 = circuit_mul(in1, t4);
    let t90 = circuit_add(in0, t89);
    let t91 = circuit_mul(in2, t10);
    let t92 = circuit_add(t90, t91);
    let t93 = circuit_mul(t58, in50);
    let t94 = circuit_add(t57, t93);
    let t95 = circuit_mul(t59, t0);
    let t96 = circuit_add(t94, t95);
    let t97 = circuit_mul(t60, t1);
    let t98 = circuit_add(t96, t97);
    let t99 = circuit_mul(t61, t2);
    let t100 = circuit_add(t98, t99);
    let t101 = circuit_mul(t62, t3);
    let t102 = circuit_add(t100, t101);
    let t103 = circuit_mul(t63, t4);
    let t104 = circuit_add(t102, t103);
    let t105 = circuit_mul(t64, t5);
    let t106 = circuit_add(t104, t105);
    let t107 = circuit_mul(t65, t6);
    let t108 = circuit_add(t106, t107);
    let t109 = circuit_mul(t66, t7);
    let t110 = circuit_add(t108, t109);
    let t111 = circuit_mul(t67, t8);
    let t112 = circuit_add(t110, t111);
    let t113 = circuit_mul(t68, t9);
    let t114 = circuit_add(t112, t113);
    let t115 = circuit_mul(t88, t92);
    let t116 = circuit_add(t115, t114);
    let t117 = circuit_sub(t116, t56);
    // commit_start_index=27, commit_end_index-1=49
    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (
        in27, in28, in29, in30, in31, in32, in33, in34, in35, in36, in37, in38, t117,
    )
        .new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        EvalCircuitResult::Success(outputs) => { outputs },
        EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(in27);
    let o1 = outputs.get_output(in28);
    let o2 = outputs.get_output(in29);
    let o3 = outputs.get_output(in30);
    let o4 = outputs.get_output(in31);
    let o5 = outputs.get_output(in32);
    let o6 = outputs.get_output(in33);
    let o7 = outputs.get_output(in34);
    let o8 = outputs.get_output(in35);
    let o9 = outputs.get_output(in36);
    let o10 = outputs.get_output(in37);
    let o11 = outputs.get_output(in38);
    let o12 = outputs.get_output(t117);

    let res = array![o0, o1, o2, o3, o4, o5, o6, o7, o8, o9, o10, o11, o12];
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

    use super::{get_BLS12_381_FP12_MUL_circuit, get_BN254_FP12_MUL_circuit};

    #[test]
    fn test_get_BLS12_381_FP12_MUL_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 70056301675051700717137429486,
                limb1: 25987334674525242886731302998,
                limb2: 17538516353098226935484266007,
                limb3: 6292735648761631235055062007
            },
            u384 {
                limb0: 72049111421910329407775977272,
                limb1: 51438048568187523215140703006,
                limb2: 11074276133212642735257162715,
                limb3: 368531081255117900029352244
            },
            u384 {
                limb0: 39029743339205774992390936133,
                limb1: 18602774827232231696440627815,
                limb2: 10748413337003100725406035226,
                limb3: 3674320094692612748525587201
            },
            u384 {
                limb0: 7845302166844865028881243993,
                limb1: 48776993748824083701592549610,
                limb2: 75387302325179433171946195024,
                limb3: 6836208567690746290633510106
            },
            u384 {
                limb0: 35128427216700306076664007996,
                limb1: 18706770539405341941221004901,
                limb2: 7871684252106426584336877737,
                limb3: 3637909214543968153162880059
            },
            u384 {
                limb0: 36026421978974631774031229925,
                limb1: 16804754127624632848696731851,
                limb2: 47310777062177169582139555442,
                limb3: 500905305494958357993853510
            },
            u384 {
                limb0: 19297515645726961054274772699,
                limb1: 62350828911867254326094421487,
                limb2: 5435856147191871942785773231,
                limb3: 5488608090187817755100508420
            },
            u384 {
                limb0: 17109428907712018643197379568,
                limb1: 18460057307864781648742858098,
                limb2: 11690446189044904570182728326,
                limb3: 5902316265738877298133995148
            },
            u384 {
                limb0: 68009940043291454900803327139,
                limb1: 78239974089360065623061251225,
                limb2: 19858871488372870617080736277,
                limb3: 1088657792286173590777980645
            },
            u384 {
                limb0: 2042514148677898167507423949,
                limb1: 28382877272558345087044410177,
                limb2: 18850883750688928833015148383,
                limb3: 156288292696346578577723563
            },
            u384 {
                limb0: 4151478183251406727761585710,
                limb1: 33351931671505497125534515053,
                limb2: 59077690017384050780724365964,
                limb3: 4439502679182532613192898277
            },
            u384 {
                limb0: 40662900099317234332362088419,
                limb1: 35811559068518827386079969028,
                limb2: 74903544011775870415652229782,
                limb3: 7202265757285873374555776094
            },
            u384 {
                limb0: 48194287442401190975179239260,
                limb1: 9997927726397883000550929599,
                limb2: 50157505724065878813971018446,
                limb3: 7052819690849091417005520321
            },
            u384 {
                limb0: 78802529321403269118083160690,
                limb1: 23364206799677681089440033835,
                limb2: 47966852373011942309120881043,
                limb3: 7854443274598238068704119561
            },
            u384 {
                limb0: 67565201436882084061382168800,
                limb1: 69539050526138233778943509686,
                limb2: 57110821802798553505013087707,
                limb3: 4259206374503184172084946846
            },
            u384 {
                limb0: 18103126184267293997473012295,
                limb1: 65554904823554840942699589553,
                limb2: 32958095597666172281072156937,
                limb3: 3095328940550140206541955769
            },
            u384 {
                limb0: 52695274180530494441361795060,
                limb1: 75551383096477959168832075052,
                limb2: 73126408529490775643855738924,
                limb3: 903446503060537082232020690
            },
            u384 {
                limb0: 7386449414086889806458978474,
                limb1: 58992415681390287031754519969,
                limb2: 64314989323068543572052655121,
                limb3: 594022837688074652137504530
            },
            u384 {
                limb0: 68777345591839517960087707903,
                limb1: 4075978103133986483856522008,
                limb2: 47569388472556425672546384101,
                limb3: 1026010291496438021509392049
            },
            u384 {
                limb0: 16854904679129456730424113100,
                limb1: 38202980167601997516503803274,
                limb2: 8573943691364242478550490241,
                limb3: 5508986431206698367995417102
            },
            u384 {
                limb0: 60419843000428525798056033060,
                limb1: 17918169308724322956508938013,
                limb2: 66960090683228060557458673484,
                limb3: 7600283663516734448545264302
            },
            u384 {
                limb0: 48612283253047197369389837369,
                limb1: 44109468313663035901026715162,
                limb2: 73609640966889790739802788401,
                limb3: 6867805991865201275747934358
            },
            u384 {
                limb0: 14294034132998625598222332994,
                limb1: 60404305134271043883976952914,
                limb2: 26923683404463040248715779776,
                limb3: 1796553622150353903912004560
            },
            u384 {
                limb0: 44868579769900272229951689357,
                limb1: 5513125318973295878526713063,
                limb2: 50165054631954772340184835492,
                limb3: 908724078973669916270956462
            }
        ];
        let output = array![
            u384 {
                limb0: 45024088937805342000293579938,
                limb1: 15294689263080525226385279871,
                limb2: 19451474437037820487406671654,
                limb3: 5849552822267276876873396090
            },
            u384 {
                limb0: 70612062538515382025194496630,
                limb1: 8973362815251481279617414598,
                limb2: 56717466935022427394965507242,
                limb3: 4743323363427839195826661450
            },
            u384 {
                limb0: 71355615718170202215507923904,
                limb1: 61612523873210650284022774089,
                limb2: 38580044476690496411727973173,
                limb3: 2660839734459990136098042324
            },
            u384 {
                limb0: 5337925604770743407705866834,
                limb1: 42491628253413821226613852370,
                limb2: 69595013005538845766334391359,
                limb3: 1460169787423473726999398365
            },
            u384 {
                limb0: 73587394252876922674410579707,
                limb1: 4986093110787048586762028335,
                limb2: 66021884159026838440047887980,
                limb3: 3135528881899575055218209265
            },
            u384 {
                limb0: 37458195231114756009601242166,
                limb1: 19845770866813223168290155246,
                limb2: 6723372441881748175872975734,
                limb3: 1050908004050145538443932829
            },
            u384 {
                limb0: 64398623202177324048508115665,
                limb1: 30766563263191469892679278041,
                limb2: 14717465987210539549701327567,
                limb3: 4831010157685578224904577560
            },
            u384 {
                limb0: 1268058383630540969282210829,
                limb1: 47781472075740848863203017280,
                limb2: 17713740040672802449875431584,
                limb3: 3280510277795268053890535545
            },
            u384 {
                limb0: 74237088235506541038632048600,
                limb1: 42335390411676766924815362031,
                limb2: 15776218321965890085640852349,
                limb3: 173266827488764348537101413
            },
            u384 {
                limb0: 73399316356141759607643093357,
                limb1: 57465377862118554315317262914,
                limb2: 34868053625706316637276597600,
                limb3: 5993188703612061001858237525
            },
            u384 {
                limb0: 61630620351798115798977674852,
                limb1: 43754498984276644267435754047,
                limb2: 25365882818630674750650072267,
                limb3: 5765080733881584757252500839
            },
            u384 {
                limb0: 30243049622849660010176466208,
                limb1: 57094540414735723961735855522,
                limb2: 46723620537360914358202061866,
                limb3: 7547173681161988751664390301
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let result = get_BLS12_381_FP12_MUL_circuit(input, 1);
        assert_eq!(result, output);
    }


    #[test]
    fn test_get_BN254_FP12_MUL_circuit_BN254() {
        let input = array![
            u384 {
                limb0: 21032412199834333261939123735,
                limb1: 47265244308347101614009170242,
                limb2: 1594200400813068812,
                limb3: 0
            },
            u384 {
                limb0: 24852077554833352323818974681,
                limb1: 77979197808012628407782703729,
                limb2: 533322060029271853,
                limb3: 0
            },
            u384 {
                limb0: 45682011358128210378883869411,
                limb1: 3516663277250005877045919917,
                limb2: 2010960371714814928,
                limb3: 0
            },
            u384 {
                limb0: 26161142043639132868890557204,
                limb1: 52558970395385538537115294951,
                limb2: 574732826177931155,
                limb3: 0
            },
            u384 {
                limb0: 23793981484893071433000931488,
                limb1: 52836699316751822051324643294,
                limb2: 1504253134003531797,
                limb3: 0
            },
            u384 {
                limb0: 23424218119507333462035248694,
                limb1: 15199138224163700583972076027,
                limb2: 3066445744495025918,
                limb3: 0
            },
            u384 {
                limb0: 53662656028629915111201156199,
                limb1: 13787866356868025780325957390,
                limb2: 2624534764951069359,
                limb3: 0
            },
            u384 {
                limb0: 43412058122167972086485290266,
                limb1: 24075454119565607250948981584,
                limb2: 969296535650250092,
                limb3: 0
            },
            u384 {
                limb0: 45951128267436914957011985992,
                limb1: 25531214560874901660437982244,
                limb2: 2037378388087895881,
                limb3: 0
            },
            u384 {
                limb0: 13444337232144876793227659097,
                limb1: 22483875406569365855296713048,
                limb2: 3061485457108150697,
                limb3: 0
            },
            u384 {
                limb0: 26556350026839819342330751351,
                limb1: 75425183560459799663181576490,
                limb2: 1083140224987076292,
                limb3: 0
            },
            u384 {
                limb0: 17797867294410332348538967616,
                limb1: 11674583860098129783412156406,
                limb2: 213123166459969039,
                limb3: 0
            },
            u384 {
                limb0: 37644179208859124554613522482,
                limb1: 60885998379492576531800945527,
                limb2: 2100236366651907824,
                limb3: 0
            },
            u384 {
                limb0: 49895154123984193292567367244,
                limb1: 56913226545590318965674945290,
                limb2: 1770788136931313063,
                limb3: 0
            },
            u384 {
                limb0: 61009344304826299626465211704,
                limb1: 61672818703954154206104770825,
                limb2: 1009226610971664787,
                limb3: 0
            },
            u384 {
                limb0: 75897889180057310726252325071,
                limb1: 36805434136770898815720310316,
                limb2: 2570580524357328036,
                limb3: 0
            },
            u384 {
                limb0: 67212130069148775897751057734,
                limb1: 10564211878373053956315241334,
                limb2: 2142788732496487279,
                limb3: 0
            },
            u384 {
                limb0: 78268903571817173877170528193,
                limb1: 25138933921729851010456074840,
                limb2: 3482975918563380131,
                limb3: 0
            },
            u384 {
                limb0: 48539317651620988052948942161,
                limb1: 70673128978082661182499734578,
                limb2: 1967994385592820803,
                limb3: 0
            },
            u384 {
                limb0: 20535270260491076068358505352,
                limb1: 66540793235598632009375969678,
                limb2: 1278872866409793455,
                limb3: 0
            },
            u384 {
                limb0: 41301626368169066917821963665,
                limb1: 18955010489807639961721015512,
                limb2: 2028554308241065135,
                limb3: 0
            },
            u384 {
                limb0: 10963122675139695732802939527,
                limb1: 30347182342567321533643806358,
                limb2: 704689890124018161,
                limb3: 0
            },
            u384 {
                limb0: 5088733895110159143047520910,
                limb1: 26215124346222420553205336148,
                limb2: 2148696609224429659,
                limb3: 0
            },
            u384 {
                limb0: 55105008470844047275501959798,
                limb1: 69772809644638520583106071494,
                limb2: 2654903143610843523,
                limb3: 0
            }
        ];
        let output = array![
            u384 {
                limb0: 29925897417392059827699810721,
                limb1: 50118639585050855722024742355,
                limb2: 758606659299625925,
                limb3: 0
            },
            u384 {
                limb0: 52012802899104870612764897269,
                limb1: 17153643174800272997707739010,
                limb2: 1087997407199108535,
                limb3: 0
            },
            u384 {
                limb0: 52888400261618788871934761790,
                limb1: 65903593656190038316177537098,
                limb2: 3055666804873550041,
                limb3: 0
            },
            u384 {
                limb0: 19157249835193561175603731412,
                limb1: 26431423683428070972075202115,
                limb2: 1997376581632942668,
                limb3: 0
            },
            u384 {
                limb0: 54737316413367394306415051316,
                limb1: 6175544958810839831863305236,
                limb2: 1175002224421300760,
                limb3: 0
            },
            u384 {
                limb0: 19076402681171003877672850239,
                limb1: 55010053471320731615160327039,
                limb2: 1053329099427227620,
                limb3: 0
            },
            u384 {
                limb0: 48955494970426148453955849427,
                limb1: 3159467422834612285404611510,
                limb2: 943091429978808099,
                limb3: 0
            },
            u384 {
                limb0: 73813256467657613014730729832,
                limb1: 25371848352325883989964678957,
                limb2: 1105701838158667447,
                limb3: 0
            },
            u384 {
                limb0: 74399835284570455866009459283,
                limb1: 7481516998553585224352605948,
                limb2: 2656787078445239451,
                limb3: 0
            },
            u384 {
                limb0: 35288566449784425316242507708,
                limb1: 33389858039336189892466011659,
                limb2: 351562701571084509,
                limb3: 0
            },
            u384 {
                limb0: 11907115804536084854752853254,
                limb1: 76230670688795242081752552308,
                limb2: 1221052469478062767,
                limb3: 0
            },
            u384 {
                limb0: 22069122762267938773570672004,
                limb1: 57790372935964217253749234951,
                limb2: 2484225744460455023,
                limb3: 0
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        let result = get_BN254_FP12_MUL_circuit(input, 0);
        assert_eq!(result, output);
    }
}
