use core::circuit::u384;
use garaga::definitions::{G1Point, G1PointZero, get_G};
use garaga::ec::ec_ops::{FakeGlvHint, GlvFakeGlvHint, ec_safe_add, msm_g1};
const SIGN: felt252 = 0x100000000000000000000000000000000;

fn glv_mul(point: G1Point, scalar: u256, curve_index: usize, hint: GlvFakeGlvHint) -> G1Point {
    let mut data = array![];
    hint.serialize(ref data);
    msm_g1(array![point].span(), array![scalar].span(), curve_index, data.span())
}

fn fake_mul(
    point: G1Point, scalar: u256, curve_index: usize, hint: FakeGlvHint, cofactor_preimage: G1Point,
) -> G1Point {
    let mut data = array![];
    hint.serialize(ref data);
    msm_g1(array![point].span(), array![scalar].span(), curve_index, data.span())
}

fn ed25519_torsion() -> G1Point {
    G1Point {
        x: u384 {
            limb0: 0xe035a41c93a737a1ade43eb9,
            limb1: 0xeccbe0143e94516eaabd570c,
            limb2: 0x63009227b1e7ffbd,
            limb3: 0x0,
        },
        y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    }
}

#[test]
fn test_baseline_noncanonical_output_is_returned() {
    let mut data = array![0x1, 0x5c724369afbc772d02aed58e, 0x2cd3bc838c66439a3d6160b, 0x72f26b55fb56be1, 0x0, 0x772ca79c580e121ca148fe75, 0xce2f55e418ca01b3d6d1014b, 0x2884b1dc4e84e30f, 0x0, 0x1, 0xb4862b21fb97d43588561712e8e5216a, 0x967d0cae6f4590b9a164106cf6a659e, 0x0, 0xa9f0001b3fc543c76e78dbe5, 0x59d3efe5fc893f110337f203, 0x2a3c4edaf4eb5933, 0x0, 0xb0399e9831473db3ac45e71d, 0xbfce4e241c32ccd1ad4a0dd6, 0x5f33b1400e4674c5, 0x0, 0x10000000000000000358f1af3ace11fdc, 0x100000000000000004ac9542b22967d33, 0x100000000000000000cf05f964742cc6d, 0x1000000000000000081d342cffb91cba7].span();
    let points = Serde::deserialize(ref data).unwrap();
    let scalars = Serde::deserialize(ref data).unwrap();
    let curve_index = Serde::deserialize(ref data).unwrap();
    let result = msm_g1(points, scalars, curve_index, data);
    assert!(result.y == u384 { limb0: 0xb0399e9831473db3ac45e71d, limb1: 0xbfce4e241c32ccd1ad4a0dd6, limb2: 0x5f33b1400e4674c5, limb3: 0x0 });
}

#[test]
fn test_baseline_zero_glv_denominator_returns_wrong_q() {
    let point = get_G(0);
    let expected = ec_safe_add(point, point, 0);
    let forged = ec_safe_add(point, expected, 0);
    let result = glv_mul(point, 2, 0, GlvFakeGlvHint { Q: forged, u1: 0, u2: 0, v1: 0, v2: 0 });
    assert!(result == forged);
    assert!(result != expected);
}

#[test]
fn test_baseline_bls_torsion_shift_returns_wrong_q() {
    let point = get_G(1);
    let expected = ec_safe_add(point, point, 1);
    let torsion = G1Point { x: 0_u128.into(), y: 2_u128.into() };
    let forged = ec_safe_add(expected, torsion, 1);
    let result = glv_mul(point, 2, 1, GlvFakeGlvHint { Q: forged, u1: SIGN + 6, u2: 0, v1: 3, v2: 0 });
    assert!(result == forged);
    assert!(result != expected);
}

#[test]
fn test_baseline_ed_even_denominator_torsion_shift_returns_wrong_q() {
    let point = get_G(4);
    let expected = ec_safe_add(point, point, 4);
    let forged = ec_safe_add(expected, ed25519_torsion(), 4);
    let result = fake_mul(point, 2, 4, FakeGlvHint { Q: forged, s1: 4, s2: SIGN + 2 }, G1PointZero::zero());
    assert!(result == forged);
    assert!(result != expected);
}
