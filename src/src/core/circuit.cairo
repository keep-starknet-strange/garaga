use core::circuit::{
    add_circuit_input, AddInputResult, CircuitData, IntoCircuitInputValue, CircuitDefinition,
    init_circuit_data, CircuitInputAccumulator, into_u96_guarantee, U96Guarantee, u384,
};
use core::panic_with_felt252;
use garaga::definitions::{E12D, G2Line, u288};
use garaga::utils::hashing::{hades_permutation, PoseidonState};

/// Implementation of conversion from u64 to u384
impl U64IntoU384 of Into<u64, u384> {
    fn into(self: u64) -> u384 {
        let v128: u128 = self.into();
        v128.into()
    }
}

/// Implementation of circuit input value conversion for u288
impl u288IntoCircuitInputValue of IntoCircuitInputValue<u288> {
    fn into_circuit_input_value(self: u288) -> [U96Guarantee; 4] {
        [
            into_u96_guarantee(self.limb0), into_u96_guarantee(self.limb1),
            into_u96_guarantee(self.limb2), into_u96_guarantee(0_u8),
        ]
    }
}

/// Trait implementation for handling circuit input operations
#[generate_trait]
pub impl AddInputResultImpl2<C> of AddInputResultTrait2<C> {
    /// Adds a generic input value to the accumulator
    /// Returns AddInputResult containing the updated accumulator state
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

    /// Adds a u256 value to the accumulator
    #[inline]
    fn next_u256(self: AddInputResult<C>, value: u256) -> AddInputResult<C> {
        let val_u384: u384 = value.into();
        self.next_2(val_u384)
    }

    /// Adds a u128 value to the accumulator
    #[inline]
    fn next_u128(self: AddInputResult<C>, value: u128) -> AddInputResult<C> {
        let val_u384: u384 = value.into();
        self.next_2(val_u384)
    }

    /// Adds a u288 value to the accumulator
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
            AddInputResult::Done(_) => panic_with_felt252('All inputs have been filled'),
        };
        c
    }

    /// Adds a span of u384 values to the accumulator
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

    /// Finalizes the input process and returns the circuit data
    /// Panics if not all inputs have been filled
    #[inline(always)]
    fn done_2(self: AddInputResult<C>) -> CircuitData<C> {
        match self {
            AddInputResult::Done(data) => data,
            AddInputResult::More(_) => panic_with_felt252('not all inputs filled'),
        }
    }
}
