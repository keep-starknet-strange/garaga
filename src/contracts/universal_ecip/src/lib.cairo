use garaga::definitions::G1Point;
use garaga::ec_ops::{DerivePointFromXHint, MSMHint, MSMHintSmallScalar, u288, u384};

#[starknet::interface]
trait IUniversalECIP<TContractState> {
    fn msm_g1_u288(
        self: @TContractState,
        scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
        msm_hint: MSMHint<u288>,
        derive_point_from_x_hint: DerivePointFromXHint,
        points: Span<G1Point>,
        scalars: Span<u256>,
        curve_index: usize,
    ) -> G1Point;

    fn msm_g1_u384(
        self: @TContractState,
        scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
        msm_hint: MSMHint<u384>,
        derive_point_from_x_hint: DerivePointFromXHint,
        points: Span<G1Point>,
        scalars: Span<u256>,
        curve_index: usize,
    ) -> G1Point;


    fn msm_g1_u128_u288(
        self: @TContractState,
        scalars_digits_decompositions: Option<Span<Span<felt252>>>,
        msm_hint: MSMHintSmallScalar<u288>,
        derive_point_from_x_hint: DerivePointFromXHint,
        points: Span<G1Point>,
        scalars: Span<u128>,
        curve_index: usize,
    ) -> G1Point;

    fn msm_g1_u128_u384(
        self: @TContractState,
        scalars_digits_decompositions: Option<Span<Span<felt252>>>,
        msm_hint: MSMHintSmallScalar<u384>,
        derive_point_from_x_hint: DerivePointFromXHint,
        points: Span<G1Point>,
        scalars: Span<u128>,
        curve_index: usize,
    ) -> G1Point;
}

#[starknet::contract]
mod UniversalECIP {
    use garaga::core::circuit::u288IntoCircuitInputValue;
    use garaga::definitions::G1Point;
    use garaga::ec_ops::{
        DerivePointFromXHint, MSMHint, MSMHintSmallScalar, msm_g1, msm_g1_u128, u288, u384,
    };

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IUniversalECIP of super::IUniversalECIP<ContractState> {
        fn msm_g1_u288(
            self: @ContractState,
            scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
            msm_hint: MSMHint<u288>,
            derive_point_from_x_hint: DerivePointFromXHint,
            points: Span<G1Point>,
            scalars: Span<u256>,
            curve_index: usize,
        ) -> G1Point {
            msm_g1(
                scalars_digits_decompositions,
                msm_hint,
                derive_point_from_x_hint,
                points,
                scalars,
                curve_index,
            )
        }

        fn msm_g1_u384(
            self: @ContractState,
            scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
            msm_hint: MSMHint<u384>,
            derive_point_from_x_hint: DerivePointFromXHint,
            points: Span<G1Point>,
            scalars: Span<u256>,
            curve_index: usize,
        ) -> G1Point {
            msm_g1(
                scalars_digits_decompositions,
                msm_hint,
                derive_point_from_x_hint,
                points,
                scalars,
                curve_index,
            )
        }

        fn msm_g1_u128_u288(
            self: @ContractState,
            scalars_digits_decompositions: Option<Span<Span<felt252>>>,
            msm_hint: MSMHintSmallScalar<u288>,
            derive_point_from_x_hint: DerivePointFromXHint,
            points: Span<G1Point>,
            scalars: Span<u128>,
            curve_index: usize,
        ) -> G1Point {
            msm_g1_u128(
                scalars_digits_decompositions,
                msm_hint,
                derive_point_from_x_hint,
                points,
                scalars,
                curve_index,
            )
        }
        fn msm_g1_u128_u384(
            self: @ContractState,
            scalars_digits_decompositions: Option<Span<Span<felt252>>>,
            msm_hint: MSMHintSmallScalar<u384>,
            derive_point_from_x_hint: DerivePointFromXHint,
            points: Span<G1Point>,
            scalars: Span<u128>,
            curve_index: usize,
        ) -> G1Point {
            msm_g1_u128(
                scalars_digits_decompositions,
                msm_hint,
                derive_point_from_x_hint,
                points,
                scalars,
                curve_index,
            )
        }
    }
}
