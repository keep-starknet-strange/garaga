pub mod array {
    pub use core::array::array_slice;
}


pub mod bounded_int {
    #[feature("bounded-int-utils")]
    pub use core::internal::bounded_int;
    #[feature("bounded-int-utils")]
    pub use core::internal::bounded_int::{
        AddHelper, BoundedInt, DivRemHelper, MulHelper, UnitInt, bounded_int_div_rem, upcast,
    };
}

pub mod circuit {
    pub use core::circuit::{
        AddInputResult, CircuitData, CircuitDefinition, CircuitInputAccumulator, IntoCircuitInputValue,
        U96Guarantee, add_circuit_input, init_circuit_data, into_u96_guarantee, u384, u96,
    };

    pub mod conversions {
    pub use core::circuit::conversions::{
        AddHelperTo128By64Impl, AddHelperTo128By96Impl, AddHelperTo96By32Impl, DivRemU128By96,
            DivRemU96By32, DivRemU96By64, MulHelper32By96Impl, MulHelper64By32Impl, MulHelper64By64Impl,
            NZ_POW32_TYPED, NZ_POW64_TYPED, NZ_POW96_TYPED, POW64_TYPED, POW96_TYPED, upcast,
        };
    }
}