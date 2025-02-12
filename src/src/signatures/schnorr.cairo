use core::circuit::{CircuitModulus, u96};
use garaga::basic_field_ops::neg_mod_p;
use garaga::definitions::{SECP256K1, Zero};
use garaga::ec_ops::{DerivePointFromXHint, G1Point, G1PointTrait, MSMHint, msm_g1, u384};

pub const SECP256K1_G1_GENERATOR: G1Point = G1Point {
    x: u384 {
        limb0: 0x2dce28d959f2815b16f81798,
        limb1: 0x55a06295ce870b07029bfcdb,
        limb2: 0x79be667ef9dcbbac,
        limb3: 0x0,
    },
    y: u384 {
        limb0: 0xa68554199c47d08ffb10d4b8,
        limb1: 0x5da4fbfc0e1108a8fd17b448,
        limb2: 0x483ada7726a3c465,
        limb3: 0x0,
    },
};
pub const SECP256K1_N: [u96; 4] = [
    0xaf48a03bbfd25e8cd0364141, 0xfffffffffffffffebaaedce6, 0xffffffffffffffff, 0,
];

/// Verifies a Schnorr signature for a hash challenge.
///
/// # Arguments:
/// * `rx`: `u256` - The x-coordinate of the R point from the signature.
/// * `s`: `u256` - The s-coordinate of the signature.
/// * `e`: `u256` - The challenge hash.
/// * `px`: `u256` - The x-coordinate of the public key.
/// * `py`: `u256` - The y-coordinate of the public key.
/// * `msm_hint`: `MSMHint` - The hint for the MSM operation.
/// * `msm_derive_hint`: `DerivePointFromXHint` - The hint for the derive point from x operation.
///
/// Panics if the signature is invalid.
pub fn verify_schnorr(
    rx: u256,
    s: u256,
    e: u256,
    px: u256,
    py: u256,
    msm_hint: MSMHint,
    msm_derive_hint: DerivePointFromXHint,
) {
    // println!("rx: {rx}");
    // println!("s: {s}");
    // println!("e: {e}");
    // println!("px: {px}");
    // println!("py: {py}");

    assert(rx < SECP256K1.n, '');
    assert(rx != 0, '');

    assert(s < SECP256K1.n, '');
    assert(s != 0, '');

    assert(e < SECP256K1.n, '');
    assert(e != 0, '');

    let pk_point = G1Point { x: px.into(), y: py.into() };
    // See
    // https://github.com/bitcoin/bips/blob/58ffd93812ff25e87d53d1f202fbb389fdfb85bb/bip-0340/reference.py#L71
    assert(py.low & 1 == 0, 'py is not even');
    pk_point.assert_on_curve(2);

    let modulus = TryInto::<[u96; 4], CircuitModulus>::try_into(SECP256K1_N).unwrap();
    let e_neg: u256 = neg_mod_p(e.into(), modulus).try_into().unwrap();
    let rx: u384 = rx.into();

    let points = array![SECP256K1_G1_GENERATOR, pk_point].span();
    let scalars = array![s, e_neg].span();

    let res = msm_g1(Option::None, msm_hint, msm_derive_hint, points, scalars, 2);
    assert(res.x.is_non_zero(), 'R.x == 0');
    assert(res.x == rx, 'R.x != rx');

    let ry: u256 = res.y.try_into().unwrap();
    assert(res.y.is_non_zero(), 'R.y == 0');
    assert(ry.low & 1 == 0, 'R.y is not even');
}

