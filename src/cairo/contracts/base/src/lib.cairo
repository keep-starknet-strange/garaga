use garaga::definitions::{u384, u96, G1Point};

#[starknet::interface]
trait IGaragaBase<TContractState> {
    fn msm(
        self: @TContractState,
        _points: Span<felt252>,
        scalars: Span<u256>,
        scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
        _msm_hint: Span<felt252>,
        curve_index: usize
    ) -> bool;
}

#[starknet::contract]
mod GaragaBase {
    use core::array::ArrayTrait;
    use garaga::definitions::{get_p, u384, G1Point, u96};
    use garaga::utils_calldata::{parse_msm_hint, MSMHint, DerivePointFromXHint, parse_G1Points};
    use garaga::ec_ops::{msm_g1, G1PointTrait};

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IGaragaBase of super::IGaragaBase<ContractState> {
        fn msm(
            self: @ContractState,
            _points: Span<felt252>,
            scalars: Span<u256>,
            scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
            _msm_hint: Span<felt252>,
            curve_index: usize
        ) -> bool {
            let n_scalars = scalars.len();
            let points = parse_G1Points(_points, n_scalars);
            let (msm_hint, derive_point_from_x_hint): (Box<MSMHint>, Box<DerivePointFromXHint>) =
                parse_msm_hint(
                _msm_hint, n_scalars
            );

            let result = msm_g1(
                points,
                scalars,
                scalars_digits_decompositions,
                msm_hint.unbox(),
                derive_point_from_x_hint.unbox(),
                curve_index
            );
            return result.is_on_curve(curve_index);
        }
    }
}

