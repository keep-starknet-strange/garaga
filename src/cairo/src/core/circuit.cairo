use core::circuit::{
    add_circuit_input, AddInputResult, CircuitData, IntoCircuitInputValue, CircuitDefinition,
    init_circuit_data, CircuitInputAccumulator
};
use core::panic_with_felt252;
use garaga::definitions::{E12D, G2Line, u384};
use garaga::utils::{PoseidonState, hades_permutation};
use core::panics::panic;

#[generate_trait]
pub impl AddInputResultImpl2<C> of AddInputResultTrait2<C> {
    /// Adds an input to the accumulator.
    // Inlining to make sure possibly huge `C` won't be in a user function name.
    // #[inline]
    fn next_2<Value, +IntoCircuitInputValue<Value>, +Drop<Value>>(
        self: AddInputResult<C>, value: Value
    ) -> AddInputResult<C> {
        match self {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252('All inputs have been filled'),
        }
    }
    fn next_e12d(self: AddInputResult<C>, value: E12D) -> AddInputResult<C> {
        let c = match self {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w0.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w1.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w2.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w3.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w4.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w5.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w6.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w7.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w8.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w9.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w10.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.w11.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        c
    }


    fn next_e12d_with_state_update(
        self: AddInputResult<C>, value: E12D, state: PoseidonState
    ) -> (AddInputResult<C>, PoseidonState) {
        let base: felt252 = 79228162514264337593543950336; // 2**96
        // let in_1 = state.s0 + value.w0.limb0.into() + base * value.w0.limb1.into();
        // let in_2 = state.s1 + value.w0.limb2.into() + base * value.w0.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, state.s2);
        // let in_1 = _s0 + value.w1.limb0.into() + base * value.w1.limb1.into();
        // let in_2 = _s1 + value.w1.limb2.into() + base * value.w1.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w2.limb0.into() + base * value.w2.limb1.into();
        // let in_2 = _s1 + value.w2.limb2.into() + base * value.w2.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w3.limb0.into() + base * value.w3.limb1.into();
        // let in_2 = _s1 + value.w3.limb2.into() + base * value.w3.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w4.limb0.into() + base * value.w4.limb1.into();
        // let in_2 = _s1 + value.w4.limb2.into() + base * value.w4.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w5.limb0.into() + base * value.w5.limb1.into();
        // let in_2 = _s1 + value.w5.limb2.into() + base * value.w5.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w6.limb0.into() + base * value.w6.limb1.into();
        // let in_2 = _s1 + value.w6.limb2.into() + base * value.w6.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w7.limb0.into() + base * value.w7.limb1.into();
        // let in_2 = _s1 + value.w7.limb2.into() + base * value.w7.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w8.limb0.into() + base * value.w8.limb1.into();
        // let in_2 = _s1 + value.w8.limb2.into() + base * value.w8.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w9.limb0.into() + base * value.w9.limb1.into();
        // let in_2 = _s1 + value.w9.limb2.into() + base * value.w9.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w10.limb0.into() + base * value.w10.limb1.into();
        // let in_2 = _s1 + value.w10.limb2.into() + base * value.w10.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        // let in_1 = _s0 + value.w11.limb0.into() + base * value.w11.limb1.into();
        // let in_2 = _s1 + value.w11.limb2.into() + base * value.w11.limb3.into();
        // let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);

        let (c, _s0, _s1, _s2) = match self {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w0.into_circuit_input_value());
                let in_0 = state.s0 + value.w0.limb0.into() + base * value.w0.limb1.into();
                let in_1 = state.s1 + value.w0.limb2.into() + base * value.w0.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, state.s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w1.into_circuit_input_value());
                let in_0 = _s0 + value.w1.limb0.into() + base * value.w1.limb1.into();
                let in_1 = _s1 + value.w1.limb2.into() + base * value.w1.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w2.into_circuit_input_value());
                let in_0 = _s0 + value.w2.limb0.into() + base * value.w2.limb1.into();
                let in_1 = _s1 + value.w2.limb2.into() + base * value.w2.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w3.into_circuit_input_value());
                let in_0 = _s0 + value.w3.limb0.into() + base * value.w3.limb1.into();
                let in_1 = _s1 + value.w3.limb2.into() + base * value.w3.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w4.into_circuit_input_value());
                let in_0 = _s0 + value.w4.limb0.into() + base * value.w4.limb1.into();
                let in_1 = _s1 + value.w4.limb2.into() + base * value.w4.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w5.into_circuit_input_value());
                let in_0 = _s0 + value.w5.limb0.into() + base * value.w5.limb1.into();
                let in_1 = _s1 + value.w5.limb2.into() + base * value.w5.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w6.into_circuit_input_value());
                let in_0 = _s0 + value.w6.limb0.into() + base * value.w6.limb1.into();
                let in_1 = _s1 + value.w6.limb2.into() + base * value.w6.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w7.into_circuit_input_value());
                let in_0 = _s0 + value.w7.limb0.into() + base * value.w7.limb1.into();
                let in_1 = _s1 + value.w7.limb2.into() + base * value.w7.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w8.into_circuit_input_value());
                let in_0 = _s0 + value.w8.limb0.into() + base * value.w8.limb1.into();
                let in_1 = _s1 + value.w8.limb2.into() + base * value.w8.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w9.into_circuit_input_value());
                let in_0 = _s0 + value.w9.limb0.into() + base * value.w9.limb1.into();
                let in_1 = _s1 + value.w9.limb2.into() + base * value.w9.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w10.into_circuit_input_value());
                let in_0 = _s0 + value.w10.limb0.into() + base * value.w10.limb1.into();
                let in_1 = _s1 + value.w10.limb2.into() + base * value.w10.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        let (c, _s0, _s1, _s2) = match c {
            AddInputResult::More(accumulator) => {
                let _c = add_circuit_input(accumulator, value.w11.into_circuit_input_value());
                let in_0 = _s0 + value.w11.limb0.into() + base * value.w11.limb1.into();
                let in_1 = _s1 + value.w11.limb2.into() + base * value.w11.limb3.into();
                let (_s0, _s1, _s2) = hades_permutation(in_0, in_1, _s2);
                (_c, _s0, _s1, _s2)
            },
            AddInputResult::Done(_) => panic(array![0]),
        };
        (c, PoseidonState { s0: _s0, s1: _s1, s2: _s2 })
    }

    fn next_g2line(self: AddInputResult<C>, value: G2Line) -> AddInputResult<C> {
        let c = match self {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.r0a0.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.r0a1.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.r1a0.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.r1a1.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };

        c
    }
    fn next_g2lineb(self: AddInputResult<C>, value: Box<G2Line>) -> AddInputResult<C> {
        let value = value.unbox();
        let c = match self {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.r0a0.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.r0a1.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.r1a0.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };
        let c = match c {
            AddInputResult::More(accumulator) => add_circuit_input(
                accumulator, value.r1a1.into_circuit_input_value()
            ),
            AddInputResult::Done(_) => panic_with_felt252(0),
        };

        c
    }
    #[inline]
    fn next_array_with_state_update(
        self: AddInputResult<C>, value: Array<u384>, state: PoseidonState
    ) -> (AddInputResult<C>, PoseidonState) {
        let base: felt252 = 79228162514264337593543950336; // 2**96
        let mut add_input_result = self;
        let mut s0 = state.s0;
        let mut s1 = state.s1;
        let mut s2 = state.s2;
        let mut value = value;
        while let Option::Some(v) = value.pop_front() {
            add_input_result =
                add_circuit_input(
                    match add_input_result {
                        AddInputResult::More(acc) => acc,
                        AddInputResult::Done(_) => panic(array![0]),
                    },
                    v.into_circuit_input_value()
                );
            let in_1 = s0 + v.limb0.into() + base * v.limb1.into();
            let in_2 = s1 + v.limb2.into() + base * v.limb3.into();
            let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
            s0 = _s0;
            s1 = _s1;
            s2 = _s2;
        };
        (add_input_result, PoseidonState { s0: s0, s1: s1, s2: s2 })
    }

    #[inline]
    fn next_array<Value, +IntoCircuitInputValue<Value>, +Drop<Value>>(
        self: AddInputResult<C>, value: Array<Value>
    ) -> AddInputResult<C> {
        let mut add_input_result = self;
        for v in value {
            add_input_result =
                add_circuit_input(
                    match add_input_result {
                        AddInputResult::More(acc) => acc,
                        AddInputResult::Done(_) => panic_with_felt252(0),
                    },
                    v.into_circuit_input_value()
                );
        };
        add_input_result
    }
    #[inline]
    fn next_span(self: AddInputResult<C>, value: Span<u384>) -> AddInputResult<C> {
        let mut add_input_result = self;
        for v in value {
            add_input_result =
                add_circuit_input(
                    match add_input_result {
                        AddInputResult::More(acc) => acc,
                        AddInputResult::Done(_) => panic_with_felt252(0),
                    },
                    (*v).into_circuit_input_value()
                );
        };
        add_input_result
    }
    // Inlining to make sure possibly huge `C` won't be in a user function name.
    #[inline(always)]
    fn done_2(self: AddInputResult<C>) -> CircuitData<C> {
        match self {
            AddInputResult::Done(data) => data,
            AddInputResult::More(_) => panic_with_felt252(0),
        }
    }
}
