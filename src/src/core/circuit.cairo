use core::circuit::{
    add_circuit_input, AddInputResult, CircuitData, IntoCircuitInputValue, CircuitDefinition,
    init_circuit_data, CircuitInputAccumulator, into_u96_guarantee, U96Guarantee,
};
use core::panic_with_felt252;
use garaga::definitions::{E12D, G2Line, u384, u288};
use garaga::utils::hashing::{hades_permutation, PoseidonState};
// use core::panics::panic;

impl U64IntoU384 of Into<u64, u384> {
    fn into(self: u64) -> u384 {
        let v128: u128 = self.into();
        v128.into()
    }
}

impl u288IntoCircuitInputValue of IntoCircuitInputValue<u288> {
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
    #[inline]
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
    #[inline]
    fn next_u256(self: AddInputResult<C>, value: u256) -> AddInputResult<C> {
        let val_u384: u384 = value.into();
        self.next_2(val_u384)
    }
    #[inline]
    fn next_u128(self: AddInputResult<C>, value: u128) -> AddInputResult<C> {
        let val_u384: u384 = value.into();
        self.next_2(val_u384)
    }
    #[inline(always)]
    fn next_u288(self: AddInputResult<C>, value: u288) -> AddInputResult<C> {
        let c = match self {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator,
                [
                    into_u96_guarantee(value.limb0), into_u96_guarantee(value.limb1),
                    into_u96_guarantee(value.limb2), into_u96_guarantee(0_u8),
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
        };
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
