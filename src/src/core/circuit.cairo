use core::circuit::{CircuitElement, CircuitModulus};
use core::panic_with_felt252;
use corelib_imports::bounded_int::bounded_int;
use corelib_imports::circuit::conversions::{
    AddHelperTo128By64Impl, AddHelperTo128By96Impl, AddHelperTo96By32Impl, DivRemU128By96,
    DivRemU96By32, DivRemU96By64, MulHelper32By96Impl, MulHelper64By32Impl, MulHelper64By64Impl,
    NZ_POW32_TYPED, NZ_POW64_TYPED, NZ_POW96_TYPED, POW64_TYPED, POW96_TYPED, upcast,
};
use corelib_imports::circuit::{
    AddInputResult, CircuitData, CircuitDescriptor, CircuitOutputs, CircuitPartialOutputs,
    IntoCircuitInputValue, IntoU96Guarantee, U96Guarantee, add_circuit_input,
    circuit_failure_guarantee_verify, eval_circuit, get_circuit_descriptor, get_circuit_output,
    into_u96_guarantee, u384, u96,
};
use garaga::definitions::u288;

// Cairo 2.21's default destructors use a libfunc not yet supported by Starknet runtimes.
// Keep the legacy checks for both output ranges and failed inversions.
pub type EvalCircuitResult<C> = Result<CircuitOutputs<C>, (CircuitPartialOutputs<C>, ())>;

#[generate_trait]
pub impl EvalCircuitImpl<C> of EvalCircuitTrait<C> {
    #[inline]
    fn eval(self: CircuitData<C>, modulus: CircuitModulus) -> EvalCircuitResult<C> {
        self.eval_ex(get_circuit_descriptor::<C>(), modulus)
    }

    #[inline]
    fn eval_ex(
        self: CircuitData<C>, descriptor: CircuitDescriptor<C>, modulus: CircuitModulus,
    ) -> EvalCircuitResult<C> {
        match eval_circuit::<C>(descriptor, self, modulus, 0, 1) {
            Result::Ok(outputs) => Result::Ok(outputs),
            Result::Err((partial_outputs, guarantee)) => {
                circuit_failure_guarantee_verify(guarantee, 0, 1).into_u96_guarantee().destruct();
                Result::Err((partial_outputs, ()))
            },
        }
    }
}

pub trait CircuitOutputsTrait<Outputs, OutputElement> {
    fn get_output(self: Outputs, output: OutputElement) -> u384;
}

pub impl CircuitOutputsImpl<
    C, Output,
> of CircuitOutputsTrait<CircuitOutputs<C>, CircuitElement<Output>> {
    #[inline]
    fn get_output(self: CircuitOutputs<C>, output: CircuitElement<Output>) -> u384 {
        let (value, guarantee) = get_circuit_output::<C, Output>(self);
        guarantee.into_u96_guarantee().destruct();
        value
    }
}


pub impl U32IntoU384 of Into<u32, u384> {
    fn into(self: u32) -> u384 {
        u384 { limb0: upcast(self), limb1: 0, limb2: 0, limb3: 0 }
    }
}

pub impl U64IntoU384 of Into<u64, u384> {
    fn into(self: u64) -> u384 {
        u384 { limb0: upcast(self), limb1: 0, limb2: 0, limb3: 0 }
    }
}


// Cuts a u384 into a u256.
// This is unsafe because it assumes the value is less than 2^256.
// Only use when computing circuit with a modulus less than 2^256.
#[inline(never)]
pub fn into_u256_unchecked(value: u384) -> u256 {
    let (_, limb2_low) = bounded_int::div_rem(value.limb2, NZ_POW64_TYPED);
    let (limb1_high, limb1_low) = bounded_int::div_rem(value.limb1, NZ_POW32_TYPED);
    u256 {
        high: upcast(bounded_int::add(bounded_int::mul(limb2_low, POW64_TYPED), limb1_high)),
        low: upcast(bounded_int::add(bounded_int::mul(limb1_low, POW96_TYPED), value.limb0)),
    }
}

pub fn u256_to_u384(value: u256) -> u384 {
    value.into()
}

pub impl u288IntoCircuitInputValue of IntoCircuitInputValue<u288> {
    fn into_circuit_input_value(self: u288) -> [U96Guarantee; 4] {
        [
            into_u96_guarantee(self.limb0), into_u96_guarantee(self.limb1),
            into_u96_guarantee(self.limb2), into_u96_guarantee(0_u8),
        ]
    }
}

#[generate_trait]
pub impl AddInputResultImpl2<C> of AddInputResultTrait2<C> {
    /// Adds an input to the accumulator.
    // Inlining to make sure possibly huge `C` won't be in a user function name.
    // #[inline(never)]
    fn next_2<Value, +IntoCircuitInputValue<Value>, +Drop<Value>>(
        self: AddInputResult<C>, value: Value,
    ) -> AddInputResult<C> {
        match self {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.into_circuit_input_value(),
            ),
            AddInputResult::Done(_) => panic_with_felt252('All inputs have been filled'),
        }
    }
    // #[inline(never)]
    fn next_u256(self: AddInputResult<C>, value: u256) -> AddInputResult<C> {
        let val_u384: u384 = value.into();
        self.next_2(val_u384)
    }
    // #[inline(never)]
    fn next_u128(self: AddInputResult<C>, value: u128) -> AddInputResult<C> {
        let (limb1, limb0) = bounded_int::div_rem(value, NZ_POW96_TYPED);
        let limb1: u96 = upcast(limb1);
        let c = match self {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator,
                [
                    into_u96_guarantee(limb0), into_u96_guarantee(limb1), into_u96_guarantee(0_u8),
                    into_u96_guarantee(0_u8),
                ],
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        c
    }
    // fn next_e12d(self: AddInputResult<C>, value: E12D<u384>) -> AddInputResult<C> {
    //     let c = match self {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w0.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w1.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w2.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w3.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w4.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w5.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w6.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w7.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w8.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w9.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w10.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     let c = match c {
    //         AddInputResult::More(accumulator) => add_circuit_input(
    //             accumulator, value.w11.into_circuit_input_value()
    //         ),
    //         AddInputResult::Done(_) => panic_with_felt252(0),
    //     };
    //     c
    // }

    // #[inline]
    // fn next_array<Value, +IntoCircuitInputValue<Value>, +Drop<Value>>(
    //     self: AddInputResult<C>, value: Array<Value>
    // ) -> AddInputResult<C> {
    //     let mut add_input_result = self;
    //     for v in value {
    //         add_input_result =
    //             add_circuit_input(
    //                 match add_input_result {
    //                     AddInputResult::More(acc) => acc,
    //                     AddInputResult::Done(_) => panic_with_felt252(0),
    //                 },
    //                 v.into_circuit_input_value()
    //             );
    //     };
    //     add_input_result
    // }
    #[inline]
    fn next_span(self: AddInputResult<C>, value: Span<u384>) -> AddInputResult<C> {
        let mut add_input_result = self;
        for v in value {
            add_input_result =
                add_circuit_input(
                    match add_input_result {
                        AddInputResult::More(acc) => acc,
                        AddInputResult::Done(_) => panic_with_felt252('all inputs filled'),
                    },
                    (*v).into_circuit_input_value(),
                );
        }
        add_input_result
    }
    // Inlining to make sure possibly huge `C` won't be in a user function name.
    #[inline(always)]
    fn done_2(self: AddInputResult<C>) -> CircuitData<C> {
        match self {
            AddInputResult::Done(data) => data,
            AddInputResult::More(_) => panic_with_felt252('not all inputs filled'),
        }
    }
}
