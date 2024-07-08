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
    let t0 = circuit_mul(in51, in51);
    let t1 = circuit_mul(t0, in51);
    let t2 = circuit_mul(t1, in51);
    let t3 = circuit_mul(t2, in51);
    let t4 = circuit_mul(t3, in51);
    let t5 = circuit_mul(t4, in51);
    let t6 = circuit_mul(t5, in51);
    let t7 = circuit_mul(t6, in51);
    let t8 = circuit_mul(t7, in51);
    let t9 = circuit_mul(t8, in51);
    let t10 = circuit_mul(t9, in51);
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
    // commit_start_index=27, commit_end_index-1=49
    let p = get_p(1);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t117,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t117);

    let res = array![o0];
    return res;
}

fn get_BN254_FP12_MUL_circuit(mut input: Array<u384>) -> Array<u384> {
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
    let t0 = circuit_mul(in51, in51);
    let t1 = circuit_mul(t0, in51);
    let t2 = circuit_mul(t1, in51);
    let t3 = circuit_mul(t2, in51);
    let t4 = circuit_mul(t3, in51);
    let t5 = circuit_mul(t4, in51);
    let t6 = circuit_mul(t5, in51);
    let t7 = circuit_mul(t6, in51);
    let t8 = circuit_mul(t7, in51);
    let t9 = circuit_mul(t8, in51);
    let t10 = circuit_mul(t9, in51);
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
    // commit_start_index=27, commit_end_index-1=49
    let p = get_p(0);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t117,).new_inputs();

    while let Option::Some(val) = input.pop_front() {
        circuit_inputs = circuit_inputs.next(val);
    };

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
    };
    let o0 = outputs.get_output(t117);

    let res = array![o0];
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
            },
            u384 {
                limb0: 4746799872180738487063829538,
                limb1: 32928947234026533667957372377,
                limb2: 16164368467471554442920714707,
                limb3: 1422825789581997865753304110
            },
            u384 {
                limb0: 56914571454665398548473145359,
                limb1: 78279275921501344736986707982,
                limb2: 77277099947913622559412447185,
                limb3: 7533261203389187895189457588
            },
            u384 {
                limb0: 44498593744465712139216861422,
                limb1: 19152446723823497391419350747,
                limb2: 21191289360525255678028857097,
                limb3: 1395184572901786623982221677
            },
            u384 {
                limb0: 39515814869766926725758124491,
                limb1: 39405733073037185795314358855,
                limb2: 74889058113270420583601856980,
                limb3: 4528192909680346512312993051
            },
            u384 {
                limb0: 37283731539461438294040876529,
                limb1: 647880615405432083589811807,
                limb2: 34141615504505773974330821086,
                limb3: 2619212698254468485489463142
            },
            u384 {
                limb0: 60518967838715347589524223999,
                limb1: 3584472071670476201344608445,
                limb2: 45182366706314728160744998007,
                limb3: 3590261560691669709454785276
            },
            u384 {
                limb0: 5825785306528226935687873685,
                limb1: 35680749671807472152129028518,
                limb2: 22161755252633372733561896190,
                limb3: 6172285658163339311907838523
            },
            u384 {
                limb0: 9413178862042274926538169081,
                limb1: 7659896475269874860860380522,
                limb2: 62978246364265491286837354431,
                limb3: 5524498897701467821199728075
            },
            u384 {
                limb0: 59814503413734095368147103486,
                limb1: 47732032767784423939988436134,
                limb2: 39620253692677469396958304865,
                limb3: 385385245952966870787040594
            },
            u384 {
                limb0: 26386203219542358811120816328,
                limb1: 41145776388924653600334984404,
                limb2: 48032906744313941516984595409,
                limb3: 1384323872797055557250074444
            },
            u384 {
                limb0: 48572261018349377195691315676,
                limb1: 31133069532473504054221942561,
                limb2: 58574914498411122047621594675,
                limb3: 5879964168832100540075000468
            },
            u384 {
                limb0: 65623845953968105057435816464,
                limb1: 38809650301829997925448327052,
                limb2: 23751855848271491851545999566,
                limb3: 164764469993132255463247786
            },
            u384 {
                limb0: 2111205133760062485982060778,
                limb1: 21037488254799410648501391752,
                limb2: 62028044178274279388295066085,
                limb3: 5728932327523338003861256177
            },
            u384 {
                limb0: 57155205437830241562675632391,
                limb1: 38065074594952668164735212714,
                limb2: 49836513725678828728655195571,
                limb3: 7671327491742243637910532153
            },
            u384 {
                limb0: 11707997871378108483976477340,
                limb1: 19188788679440402270570177778,
                limb2: 75124553296853293503425610055,
                limb3: 1889436503804182240377001637
            },
            u384 {
                limb0: 24853278948010071179419784286,
                limb1: 32718070765074852457160716165,
                limb2: 32513447822434735485278789660,
                limb3: 6055785371143247747404480051
            },
            u384 {
                limb0: 69151742979406825371157873362,
                limb1: 57630731740257729036338281502,
                limb2: 10940021404793935207588801183,
                limb3: 5554753529353727050500303942
            },
            u384 {
                limb0: 52467012687823217201348244027,
                limb1: 29855134486868324452480222549,
                limb2: 13720925392567964525292295936,
                limb3: 5279834705661427154940625484
            },
            u384 {
                limb0: 28069506908622568531152780878,
                limb1: 68742663856298682621989599506,
                limb2: 50968197994782869340149416719,
                limb3: 2618116220297665236461956124
            },
            u384 {
                limb0: 22897266806348697145774733252,
                limb1: 54686439862246509913962734409,
                limb2: 25118555635567285619769613403,
                limb3: 5550800228687537992218469793
            },
            u384 {
                limb0: 73921771565620241596952886818,
                limb1: 21520070136398266268752308662,
                limb2: 48778959961816171583014982161,
                limb3: 2369734849217857192777680871
            },
            u384 {
                limb0: 53069714211243737439559334654,
                limb1: 17879549960853822273689888428,
                limb2: 4158773962166189071132546532,
                limb3: 3271069583024141507532067529
            }
        ];
        let output = array![
            u384 {
                limb0: 433377572626215654948249157,
                limb1: 9904030337959590998650382844,
                limb2: 42450486284082938255578715022,
                limb3: 5649391032475633220565339032
            },
            u384 {
                limb0: 24957801455588396182657007429,
                limb1: 34344091505169592441782929158,
                limb2: 28649356644137959778859387109,
                limb3: 1883291498687024118915692354
            },
            u384 {
                limb0: 73333340634648547074341386040,
                limb1: 13163652181209742063967831320,
                limb2: 23681989764486619814736043527,
                limb3: 3489643659671287219750046709
            },
            u384 {
                limb0: 1446755457595125565199797435,
                limb1: 21880205764484072509703149890,
                limb2: 45126270228354193227128277658,
                limb3: 437718340181956495819529503
            },
            u384 {
                limb0: 63424918917476103948554304300,
                limb1: 44383819377819661958987179632,
                limb2: 27724562805754260990953621434,
                limb3: 2630685948953658885650198219
            },
            u384 {
                limb0: 40361056273455516729068632874,
                limb1: 158551534780540159592273483,
                limb2: 16352889051968683114260546492,
                limb3: 6179010379137596642751166222
            },
            u384 {
                limb0: 17888994928469669072568286922,
                limb1: 73051073641552484680444658303,
                limb2: 6287246449507004367364200294,
                limb3: 1188067927171979197296946496
            },
            u384 {
                limb0: 2604469787677496441038365530,
                limb1: 61582588435128133101417146653,
                limb2: 5585746494441393422837602487,
                limb3: 5737385991213131383396014593
            },
            u384 {
                limb0: 67300254160726345320117647936,
                limb1: 31188528118697488091744119326,
                limb2: 1288450813226808456114869358,
                limb3: 6202786820552573620596247392
            },
            u384 {
                limb0: 6263958425068312979480285605,
                limb1: 30963787978959366755595479408,
                limb2: 68189003529310339091053344147,
                limb3: 6580450015676069082357967624
            },
            u384 {
                limb0: 76502092876020184458889649069,
                limb1: 20586420130710787529741375269,
                limb2: 17923579678499194681188957976,
                limb3: 7817975419138775955530287667
            },
            u384 {
                limb0: 21432834984595058504027822011,
                limb1: 38238814033156914895595115688,
                limb2: 24851206641708263552072368920,
                limb3: 1784161988132118168578634323
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
