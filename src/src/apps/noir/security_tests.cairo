use garaga::definitions::G1PointZero;
use super::{aggregate_pairing_accumulator, decode_accumulator_coordinate, decode_accumulator_point};

#[test]
fn default_accumulator_preserves_the_outer_pair() {
    let zero = G1PointZero::zero();
    let (lhs, rhs) = aggregate_pairing_accumulator(
        array![0, 0, 0, 0, 0, 0, 0, 0].span(), zero, zero, array![].span(),
    );
    assert_eq!(lhs, zero);
    assert_eq!(rhs, zero);
}

#[test]
#[should_panic]
fn reject_default_accumulator_with_hints() {
    let zero = G1PointZero::zero();
    aggregate_pairing_accumulator(
        array![0, 0, 0, 0, 0, 0, 0, 0].span(), zero, zero, array![1].span(),
    );
}

#[test]
#[should_panic]
fn reject_mixed_infinity_accumulator() {
    let zero = G1PointZero::zero();
    aggregate_pairing_accumulator(
        array![1, 0, 2, 0, 0, 0, 0, 0].span(),
        zero,
        zero,
        array![0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0].span(),
    );
}

#[test]
#[should_panic]
fn reject_noncanonical_reconstructed_coordinate() {
    // The low limb is bounded, but the reconstructed coordinate equals Fp.
    decode_accumulator_point(
        array![0x5d97816a916871ca8d3c208c16d87cfd47, 0x30644e72e131a029b85045b6818158, 2, 0].span(),
    );
}

#[test]
#[should_panic]
fn reject_oversized_low_accumulator_limb() {
    decode_accumulator_coordinate(0x10000000000000000000000000000000000, 0);
}

#[test]
#[should_panic]
fn reject_oversized_high_accumulator_limb() {
    decode_accumulator_coordinate(0, 0x1000000000000000000000000000000);
}
