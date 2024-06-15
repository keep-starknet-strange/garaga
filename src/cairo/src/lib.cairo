mod definitions;
mod utils;

#[cfg(test)]
mod tests {
    use core::traits::TryInto;
    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, CircuitDefinition,
        circuit_add, circuit_sub, circuit_mul, circuit_inverse, EvalCircuitResult, FillInputResult,
        InputAccumulatorTrait, CircuitDescriptorTrait, u384, CircuitOutputsTrait, CircuitModulus
    };
    use super::utils::{scalar_to_base_neg3_le, neg_3_base_le};

    #[test]
    fn test_u96() {
        let a: u96 = 0x123;
        assert_eq!(a, 0x123);
    }

    #[test]
    fn test_builtins() {
        core::internal::require_implicit::<RangeCheck96>();
        core::internal::require_implicit::<AddMod>();
        core::internal::require_implicit::<MulMod>();
    }

    #[test]
    fn test_circuit_success() {
        let in1 = CircuitElement::<CircuitInput<0>> {};
        let in2 = CircuitElement::<CircuitInput<1>> {};
        let add = circuit_add(in1, in2);
        let inv = circuit_inverse(add);
        let sub = circuit_sub(inv, in2);
        let mul = circuit_mul(inv, sub);
        let circ = (mul,);
        let inputs = circ.init();

        let inputs = match inputs.fill_input([3, 0, 0, 0]) {
            FillInputResult::More(new_inputs) => new_inputs,
            FillInputResult::Done(_data) => { panic!("Expected more inputs") }
        };
        let data = match inputs.fill_input([6, 0, 0, 0]) {
            FillInputResult::More(_new_inputs) => panic!("Expected Done"),
            FillInputResult::Done(data) => data
        };

        let modulus = TryInto::<_, CircuitModulus>::try_into([7, 0, 0, 0]).unwrap();
        let outputs = match circ.get_descriptor().eval(data, modulus) {
            EvalCircuitResult::Success(outputs) => { outputs },
            EvalCircuitResult::Failure((_, _)) => { panic!("Expected success") }
        };

        assert_eq!(outputs.get_output(add), u384 { limb0: 2, limb1: 0, limb2: 0, limb3: 0 });
        assert_eq!(outputs.get_output(inv), u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 });
        assert_eq!(outputs.get_output(sub), u384 { limb0: 5, limb1: 0, limb2: 0, limb3: 0 });
        assert_eq!(outputs.get_output(mul), u384 { limb0: 6, limb1: 0, limb2: 0, limb3: 0 });
    }


    #[test]
    fn test_circuit_failure() {
        let in0 = CircuitElement::<CircuitInput<0>> {};
        let out0 = circuit_inverse(in0);
        let circ = (out0,);
        let inputs = circ.init();

        let data = match inputs.fill_input([11, 0, 0, 0]) {
            FillInputResult::More(_new_inputs) => panic!("Expected Done"),
            FillInputResult::Done(data) => data
        };

        let modulus = TryInto::<_, CircuitModulus>::try_into([55, 0, 0, 0]).unwrap();

        match circ.get_descriptor().eval(data, modulus) {
            EvalCircuitResult::Failure((_, _)) => {},
            EvalCircuitResult::Success(_outputs) => { panic!("Expected failure"); }
        }
    }

    
    fn test_scalar_to_base_neg3_le() {
        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(12);

        assert_eq!(sum_p, 9);
        assert_eq!(sum_n, 3618502788666131213697322783095070105623107215331596699973092056135872020478);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 3618502788666131213697322783095070105623107215331596699973092056135872020480);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(35);

        assert_eq!(sum_p, 9);
        assert_eq!(sum_n, 3618502788666131213697322783095070105623107215331596699973092056135872020455);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 3618502788666131213697322783095070105623107215331596699973092056135872020480);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(0);

        assert_eq!(sum_p, 0);
        assert_eq!(sum_n, 0);


        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(170141183460469231731687303715884105728); //2**127

        assert_eq!(sum_p, 164253760949568696627221936579612523510);
        assert_eq!(sum_n, 3618502788666131213697322783095070105623107215331596699973092056135872020480 -5887422510900535104465367136271582218 +1); //using STARK field
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 3618502788666131213697322783095070105623107215331596699973092056135872020480);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(85070591730234615865843651857942052864); //2 **126

        assert_eq!(sum_p, 97865891762673628272143863189949020615);
        assert_eq!(sum_n, 12795300032439012406300211332006967751);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 1);

        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(85070591730234615865843651857942052874); //2 **126 + 10

        assert_eq!(sum_p, 97865891762673628272143863189949020623);
        assert_eq!(sum_n, 12795300032439012406300211332006967749);
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 1);

    }

    
    fn test_scalar_to_base_neg3_le_single() {
        let (sum_p, sum_n, sign_p, sign_n) = scalar_to_base_neg3_le(170141183460469231731687303715884105728); //2**127

        assert_eq!(sum_p, 164253760949568696627221936579612523510);
        assert_eq!(sum_n, 3618502788666131213697322783095070105623107215331596699973092056135872020480 -5887422510900535104465367136271582218 +1); //using STARK field
        assert_eq!(sign_p, 1);
        assert_eq!(sign_n, 3618502788666131213697322783095070105623107215331596699973092056135872020480);
    }

    
    fn test_neg_3_base_le(){
        let digits: Array<felt252> = neg_3_base_le(12);

        let expected:Array<felt252> = array![0, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 1];

        assert_eq!(digits, expected);

        let digits: Array<felt252> = neg_3_base_le(0);
        let expected:Array<felt252> = array![0];

        assert_eq!(digits, expected);

        let digits: Array<felt252> = neg_3_base_le(35);

        let expected:Array<felt252> = array![3618502788666131213697322783095070105623107215331596699973092056135872020480, 0, 1, 3618502788666131213697322783095070105623107215331596699973092056135872020480];

        let digits: Array<felt252> = neg_3_base_le(22);
        let expected: Array<felt252> = array![1, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480];
        
        assert_eq!(digits, expected);

        let digits: Array<felt252> = neg_3_base_le(16);

        let expected: Array<felt252> = array![1, 1, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480];

        assert_eq!(digits, expected);
        let digits: Array<felt252> = neg_3_base_le(170141183460469231731687303715884105728); //2**127

        let expected: Array<felt252> = array![3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 0, 1, 0, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 0, 0, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 1, 0, 0, 1, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 0, 0, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 1, 0, 1, 1, 0, 0, 0, 1, 1, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 1, 1, 0, 1, 1, 1, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 0, 1, 0, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 1, 0, 0, 0, 1, 1, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 1, 0, 1, 0, 0, 1, 0, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 1, 0, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 0, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 1, 0, 1];

        assert_eq!(digits, expected);
    }

    #[test]
    fn test_neg_3_base_le_single(){


        let digits: Array<felt252> = neg_3_base_le(16);

        let expected: Array<felt252> = array![1, 1, 3618502788666131213697322783095070105623107215331596699973092056135872020480, 3618502788666131213697322783095070105623107215331596699973092056135872020480];

        assert_eq!(digits, expected);
    }
}
