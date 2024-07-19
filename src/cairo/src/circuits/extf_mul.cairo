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

fn run_BLS12_381_FP12_MUL_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 2
    let in1 = CircuitElement::<
        CircuitInput<1>
    > {}; // 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559785
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 1

    // INPUT stack
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

    // COMMIT stack
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 

    // FELT stack
    let in50 = CircuitElement::<CircuitInput<50>> {}; // 
    let in51 = CircuitElement::<CircuitInput<51>> {}; // 
    let t0 = circuit_mul(in51, in51); //Compute z^2
    let t1 = circuit_mul(t0, in51); //Compute z^3
    let t2 = circuit_mul(t1, in51); //Compute z^4
    let t3 = circuit_mul(t2, in51); //Compute z^5
    let t4 = circuit_mul(t3, in51); //Compute z^6
    let t5 = circuit_mul(t4, in51); //Compute z^7
    let t6 = circuit_mul(t5, in51); //Compute z^8
    let t7 = circuit_mul(t6, in51); //Compute z^9
    let t8 = circuit_mul(t7, in51); //Compute z^10
    let t9 = circuit_mul(t8, in51); //Compute z^11
    let t10 = circuit_mul(t9, in51); //Compute z^12
    let t11 = circuit_mul(in4, in51);
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
    let t33 = circuit_mul(in16, in51);
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
    let t56 = circuit_mul(in50, t55);
    let t57 = circuit_mul(in50, in27);
    let t58 = circuit_mul(in50, in28);
    let t59 = circuit_mul(in50, in29);
    let t60 = circuit_mul(in50, in30);
    let t61 = circuit_mul(in50, in31);
    let t62 = circuit_mul(in50, in32);
    let t63 = circuit_mul(in50, in33);
    let t64 = circuit_mul(in50, in34);
    let t65 = circuit_mul(in50, in35);
    let t66 = circuit_mul(in50, in36);
    let t67 = circuit_mul(in50, in37);
    let t68 = circuit_mul(in50, in38);
    let t69 = circuit_mul(in40, in51);
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
    let t93 = circuit_mul(t58, in51);
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

    let mut circuit_inputs = (t117,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next(u384 { limb0: 2, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs
        .next(
            u384 {
                limb0: 54880396502181392957329877673,
                limb1: 31935979117156477062286671870,
                limb2: 20826981314825584179608359615,
                limb3: 8047903782086192180586325942
            }
        );
    circuit_inputs = circuit_inputs.next(u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 });

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t117)];
    return res;
}

fn run_BN254_FP12_MUL_circuit(mut input: Array<u384>) -> Array<u384> {
    // CONSTANT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // 82
    let in1 = CircuitElement::<
        CircuitInput<1>
    > {}; // 21888242871839275222246405745257275088696311157297823662689037894645226208565
    let in2 = CircuitElement::<CircuitInput<2>> {}; // 1

    // INPUT stack
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

    // COMMIT stack
    let in27 = CircuitElement::<CircuitInput<27>> {}; // 
    let in28 = CircuitElement::<CircuitInput<28>> {}; // 
    let in29 = CircuitElement::<CircuitInput<29>> {}; // 
    let in30 = CircuitElement::<CircuitInput<30>> {}; // 
    let in31 = CircuitElement::<CircuitInput<31>> {}; // 
    let in32 = CircuitElement::<CircuitInput<32>> {}; // 
    let in33 = CircuitElement::<CircuitInput<33>> {}; // 
    let in34 = CircuitElement::<CircuitInput<34>> {}; // 
    let in35 = CircuitElement::<CircuitInput<35>> {}; // 
    let in36 = CircuitElement::<CircuitInput<36>> {}; // 
    let in37 = CircuitElement::<CircuitInput<37>> {}; // 
    let in38 = CircuitElement::<CircuitInput<38>> {}; // 
    let in39 = CircuitElement::<CircuitInput<39>> {}; // 
    let in40 = CircuitElement::<CircuitInput<40>> {}; // 
    let in41 = CircuitElement::<CircuitInput<41>> {}; // 
    let in42 = CircuitElement::<CircuitInput<42>> {}; // 
    let in43 = CircuitElement::<CircuitInput<43>> {}; // 
    let in44 = CircuitElement::<CircuitInput<44>> {}; // 
    let in45 = CircuitElement::<CircuitInput<45>> {}; // 
    let in46 = CircuitElement::<CircuitInput<46>> {}; // 
    let in47 = CircuitElement::<CircuitInput<47>> {}; // 
    let in48 = CircuitElement::<CircuitInput<48>> {}; // 
    let in49 = CircuitElement::<CircuitInput<49>> {}; // 

    // FELT stack
    let in50 = CircuitElement::<CircuitInput<50>> {}; // 
    let in51 = CircuitElement::<CircuitInput<51>> {}; // 
    let t0 = circuit_mul(in51, in51); //Compute z^2
    let t1 = circuit_mul(t0, in51); //Compute z^3
    let t2 = circuit_mul(t1, in51); //Compute z^4
    let t3 = circuit_mul(t2, in51); //Compute z^5
    let t4 = circuit_mul(t3, in51); //Compute z^6
    let t5 = circuit_mul(t4, in51); //Compute z^7
    let t6 = circuit_mul(t5, in51); //Compute z^8
    let t7 = circuit_mul(t6, in51); //Compute z^9
    let t8 = circuit_mul(t7, in51); //Compute z^10
    let t9 = circuit_mul(t8, in51); //Compute z^11
    let t10 = circuit_mul(t9, in51); //Compute z^12
    let t11 = circuit_mul(in4, in51);
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
    let t33 = circuit_mul(in16, in51);
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
    let t56 = circuit_mul(in50, t55);
    let t57 = circuit_mul(in50, in27);
    let t58 = circuit_mul(in50, in28);
    let t59 = circuit_mul(in50, in29);
    let t60 = circuit_mul(in50, in30);
    let t61 = circuit_mul(in50, in31);
    let t62 = circuit_mul(in50, in32);
    let t63 = circuit_mul(in50, in33);
    let t64 = circuit_mul(in50, in34);
    let t65 = circuit_mul(in50, in35);
    let t66 = circuit_mul(in50, in36);
    let t67 = circuit_mul(in50, in37);
    let t68 = circuit_mul(in50, in38);
    let t69 = circuit_mul(in40, in51);
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
    let t93 = circuit_mul(t58, in51);
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

    let modulus = TryInto::<
        _, CircuitModulus
    >::try_into(
        [32324006162389411176778628423, 57042285082623239461879769745, 3486998266802970665, 0]
    )
        .unwrap();

    let mut circuit_inputs = (t117,).new_inputs();
    // Prefill constants:
    circuit_inputs = circuit_inputs.next(u384 { limb0: 82, limb1: 0, limb2: 0, limb3: 0 });
    circuit_inputs = circuit_inputs
        .next(
            u384 {
                limb0: 32324006162389411176778628405,
                limb1: 57042285082623239461879769745,
                limb2: 3486998266802970665,
                limb3: 0
            }
        );
    circuit_inputs = circuit_inputs.next(u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 });

    let mut input = input;
    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let res = array![outputs.get_output(t117)];
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

    use super::{run_BLS12_381_FP12_MUL_circuit, run_BN254_FP12_MUL_circuit};

    #[test]
    fn test_run_BLS12_381_FP12_MUL_circuit_BLS12_381() {
        let input = array![
            u384 {
                limb0: 77081921102631858949365752521,
                limb1: 61098720374347849544704026915,
                limb2: 16422238753940578729750965464,
                limb3: 4842851976640883489189892117
            },
            u384 {
                limb0: 27635034728725056016077133069,
                limb1: 74037559964165469098787741017,
                limb2: 21665538153814520149336633197,
                limb3: 5679439129255027180619731079
            },
            u384 {
                limb0: 30082472345626922296731442590,
                limb1: 31258081103002322554055593634,
                limb2: 75631905882386544261830094711,
                limb3: 1450629279303850933547928355
            },
            u384 {
                limb0: 22788422904743497741434034943,
                limb1: 6261356863655968905549017244,
                limb2: 35048646334443904323096889208,
                limb3: 7401281982983819591185975512
            },
            u384 {
                limb0: 16009476576207287279669276754,
                limb1: 21481346931245835267859588251,
                limb2: 55156372961464328038666381314,
                limb3: 1081727663445665540668455963
            },
            u384 {
                limb0: 46493502405790253214177493646,
                limb1: 4022051399189077729814353662,
                limb2: 42073441739680301323294227740,
                limb3: 2305901607840872318565195257
            },
            u384 {
                limb0: 73610860856880680364706883523,
                limb1: 51727496468273280824976003984,
                limb2: 69593988236194715133902996342,
                limb3: 6442623144294022144384791456
            },
            u384 {
                limb0: 76369138410138386831978236897,
                limb1: 22612933222794424303577785368,
                limb2: 71934176522069253029910647015,
                limb3: 6460053723866575679343241551
            },
            u384 {
                limb0: 42399131131845249435002627935,
                limb1: 67370328789337419035356860235,
                limb2: 72353512907017136611875459230,
                limb3: 4138532367275150396396766239
            },
            u384 {
                limb0: 13927415845455690200499539562,
                limb1: 2879139147301820268211965275,
                limb2: 31453150364518380569077655231,
                limb3: 1845140971560287420733180348
            },
            u384 {
                limb0: 76227901356732459955916216120,
                limb1: 22933936519900520977582158142,
                limb2: 734220610280105840267640214,
                limb3: 5969673364997588712736124565
            },
            u384 {
                limb0: 67427899240500188553895313475,
                limb1: 21616380767465910197160252664,
                limb2: 8924795874549538930908993146,
                limb3: 7240654153323828152887654043
            },
            u384 {
                limb0: 20382623327810353098443680553,
                limb1: 1115864729315654019180793055,
                limb2: 62651069302898308171020041601,
                limb3: 6678945380412839485734565281
            },
            u384 {
                limb0: 13904139436747692184101013578,
                limb1: 50605070981682135650177352595,
                limb2: 65520884453918182635454371899,
                limb3: 3247628366426916965765215696
            },
            u384 {
                limb0: 53023911856056787776895742555,
                limb1: 77777114069399309639574300800,
                limb2: 25638365458929870059016758227,
                limb3: 67642259739082207756697782
            },
            u384 {
                limb0: 18659916057253587464784892651,
                limb1: 21153469636108633193976775257,
                limb2: 23922613719849632457908002898,
                limb3: 5673502498483410082325079509
            },
            u384 {
                limb0: 51790132126839830984914727886,
                limb1: 18721819130210934134810581776,
                limb2: 9366737524676467614873510217,
                limb3: 1581758835812566460478529601
            },
            u384 {
                limb0: 39813773122003770580847387140,
                limb1: 70338874698133819796954852580,
                limb2: 24638211168825125955736195151,
                limb3: 6325490555535671017719914207
            },
            u384 {
                limb0: 23375287305238774992614163806,
                limb1: 17497479541848220045265034086,
                limb2: 10582409213260093169998548947,
                limb3: 4505890476002552692525900039
            },
            u384 {
                limb0: 47991583913259890098578361567,
                limb1: 55613474090435897089684005034,
                limb2: 37302843403771784687194382825,
                limb3: 7942573672407473268111554890
            },
            u384 {
                limb0: 17304351137299447384400598992,
                limb1: 53902239774132764012656016238,
                limb2: 69176886281252168809852607589,
                limb3: 5204365832160188147658989618
            },
            u384 {
                limb0: 45374101355345567577765550495,
                limb1: 13035976408898047636366593902,
                limb2: 41225704108877636519937934433,
                limb3: 6737317732521386945852241523
            },
            u384 {
                limb0: 46201718798906095497634984222,
                limb1: 71217351893704279230404351097,
                limb2: 64071187894468457089523512710,
                limb3: 1306713420266262778217375218
            },
            u384 {
                limb0: 36191303803011983827250984419,
                limb1: 44272475022915055199882869725,
                limb2: 63930420923761856630795168949,
                limb3: 215604156123130294981374798
            }
        ];
        let got = run_BLS12_381_FP12_MUL_circuit(input);
        let exp = array![
            u384 {
                limb0: 4983301780014004884484941325,
                limb1: 55642437941731218369438444577,
                limb2: 23390926911542387740656454220,
                limb3: 6134998202369872840520268606
            },
            u384 {
                limb0: 1700305047159467713110193630,
                limb1: 47800445110596919201940690432,
                limb2: 2177698316205181499136796123,
                limb3: 6348119916703773305442100847
            },
            u384 {
                limb0: 57696040354788103753472069174,
                limb1: 53540750216198945415725121694,
                limb2: 30219753849278731883300169882,
                limb3: 5238396149130435595009764236
            },
            u384 {
                limb0: 31099941670567693701697767357,
                limb1: 51428901177736885290330596154,
                limb2: 24978296659297710946901371527,
                limb3: 6429778069854081314808793987
            },
            u384 {
                limb0: 76907460606122236078790797563,
                limb1: 47584408842508005912746857454,
                limb2: 61639261545456158041509283808,
                limb3: 2722973744914088290188543813
            },
            u384 {
                limb0: 1600702638151437521082069206,
                limb1: 44944246599822125394650083800,
                limb2: 28802776716490786459364134241,
                limb3: 7557339960593410117440196092
            },
            u384 {
                limb0: 36863093741812246008411695134,
                limb1: 3329774871451486530825817667,
                limb2: 52046857487718133657625736203,
                limb3: 3871859843383750240182522506
            },
            u384 {
                limb0: 10570384926700052458745677903,
                limb1: 36787854502792844815256828269,
                limb2: 55787611521533314557142362020,
                limb3: 4883442413764273564156850469
            },
            u384 {
                limb0: 19387280916216894184715891714,
                limb1: 30254086974330290143658774110,
                limb2: 63938850374951716936861298399,
                limb3: 4562949673011254831934644168
            },
            u384 {
                limb0: 30702492254700489003873870591,
                limb1: 8418698064245739368496965829,
                limb2: 67835341109528758407461363913,
                limb3: 1125852914750896557582067561
            },
            u384 {
                limb0: 1771373231119529273628012844,
                limb1: 11707916904786560207781332753,
                limb2: 73056965729105657510712011628,
                limb3: 7625689480094997593160737501
            },
            u384 {
                limb0: 70095478775217105721359012507,
                limb1: 70527682131984925140910195680,
                limb2: 75658483858045422148372698075,
                limb3: 3110785176707760317689736266
            },
            u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
        ];
        assert_eq!(got.len(), exp.len());
        assert_eq!(got, exp);
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
}
