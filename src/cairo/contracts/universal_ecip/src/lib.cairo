use garaga::definitions::{u384, u96, G1Point};
use garaga::ec_ops::{MSMHint, DerivePointFromXHint};

#[starknet::interface]
trait IUniversalECIP<TContractState> {
    fn msm_g1(
        ref self: TContractState,
        scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
        msm_hint: MSMHint,
        derive_point_from_x_hint: DerivePointFromXHint,
        points: Span<G1Point>,
        scalars: Span<u256>,
        curve_index: usize
    ) -> G1Point;
}

#[starknet::contract]
mod UniversalECIP {
    use garaga::definitions::{u384, G1Point};
    use garaga::utils_calldata::{MSMHint, DerivePointFromXHint};
    use garaga::ec_ops::{msm_g1, G1PointTrait};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IUniversalECIP of super::IUniversalECIP<ContractState> {
        fn msm_g1(
            ref self: ContractState,
            scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
            msm_hint: MSMHint,
            derive_point_from_x_hint: DerivePointFromXHint,
            points: Span<G1Point>,
            scalars: Span<u256>,
            curve_index: usize
        ) -> G1Point {
            msm_g1(
                scalars_digits_decompositions,
                msm_hint,
                derive_point_from_x_hint,
                points,
                scalars,
                curve_index
            )
        }
    }
}
