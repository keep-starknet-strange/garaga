use core::circuit::u384;
use core::num::traits::{One, Zero};
use garaga::basic_field_ops::mul_mod_p;
use garaga::circuits::ed25519::{
    run_ED25519_FINISH_circuit, run_ED25519_FROM_WEIERSTRASS_circuit, run_ED25519_HALVE_NQR_circuit,
    run_ED25519_HALVE_UP_circuit, run_ED25519_LOW_ORDER_circuit, run_ED25519_PREPARE_circuit,
    run_ED25519_SQRT_OR_TWICE_circuit, run_ED25519_SQRT_circuit,
};
use garaga::definitions::{ED25519, G1Point, get_ED25519_modulus};
use garaga::ec::ec_ops::G1PointTrait;

const SQRT_MINUS_ONE: u384 = u384 {
    limb0: 0xad2fe478c4ee1b274a0ea0b0,
    limb1: 0x2b4d00993dfbd7a72f431806,
    limb2: 0x2b8324804fc1df0b,
    limb3: 0,
};
const MINUS_ONE: u384 = u384 {
    limb0: 0xffffffffffffffffffffffec,
    limb1: 0xffffffffffffffffffffffff,
    limb2: 0x7fffffffffffffff,
    limb3: 0,
};
const SQRT_TWO_I: u384 = u384 {
    limb0: 0x52d01b873b11e4d8b5f15f3c,
    limb1: 0xd4b2ff66c2042858d0bce7f9,
    limb2: 0x547cdb7fb03e20f4,
    limb3: 0,
};
const I_SQRT_TWO_I: u384 = u384 {
    limb0: 0x52d01b873b11e4d8b5f15f3e,
    limb1: 0xd4b2ff66c2042858d0bce7f9,
    limb2: 0x547cdb7fb03e20f4,
    limb3: 0,
};

/// Test [8]P = O for a canonical on-curve point in Edwards coordinates.
/// This accepts no nonzero torsion coset and does not test [ell]P = O.
pub fn is_small_order_edwards(x: u384, y: u384) -> bool {
    if x.is_zero() || y.is_zero() {
        return true;
    }
    let (check,) = run_ED25519_LOW_ORDER_circuit(x, y);
    check.is_zero()
}

fn sqrt(value: u384) -> Option<u384> {
    let (root, same, opposite) = run_ED25519_SQRT_circuit(value);
    if same.is_zero() {
        Some(root)
    } else if opposite.is_zero() {
        Some(mul_mod_p(root, SQRT_MINUS_ONE, get_ED25519_modulus()))
    } else {
        None
    }
}

// The extra two checks reuse the power chain when value is a nonresidue.
fn sqrt_or_twice(value: u384) -> Option<(bool, u384)> {
    let (root, same, opposite, imaginary, neg_imaginary) = run_ED25519_SQRT_OR_TWICE_circuit(value);
    let modulus = get_ED25519_modulus();
    if same.is_zero() {
        Some((true, root))
    } else if opposite.is_zero() {
        Some((true, mul_mod_p(root, SQRT_MINUS_ONE, modulus)))
    } else if imaginary.is_zero() {
        Some((false, mul_mod_p(root, I_SQRT_TWO_I, modulus)))
    } else if neg_imaginary.is_zero() {
        Some((false, mul_mod_p(root, SQRT_TWO_I, modulus)))
    } else {
        None
    }
}

/// Test Ed25519 subgroup membership with one halving and a quartic Tate test.
/// The identity is accepted. Inputs use Garaga's Weierstrass coordinates.
pub fn is_in_prime_order_subgroup(point: G1Point) -> bool {
    if point.is_infinity() {
        return true;
    }
    let x: Option<u256> = point.x.try_into();
    let y: Option<u256> = point.y.try_into();
    let prime: u256 = ED25519.p.try_into().unwrap();
    match (x, y) {
        (Some(x), Some(y)) => { if x >= prime || y >= prime {
            return false;
        } },
        _ => { return false; },
    }
    if !point.is_on_curve_excluding_infinity(4) || point.y.is_zero() {
        return false;
    }
    let (x, y) = run_ED25519_FROM_WEIERSTRASS_circuit(point.x, point.y);
    is_in_prime_order_subgroup_edwards(x, y)
}

// The caller must establish the Edwards curve equation first.
fn is_in_prime_order_subgroup_edwards(x: u384, y: u384) -> bool {
    if is_small_order_edwards(x, y) {
        return x.is_zero() && y.is_one();
    }
    let (u, w, mut e) = run_ED25519_PREPARE_circuit(x, y);
    let modulus = get_ED25519_modulus();
    let four_u = mul_mod_p(u, u384 { limb0: 4, limb1: 0, limb2: 0, limb3: 0 }, modulus);
    let mut wp = match sqrt(four_u) {
        Some(root) => root,
        None => { return false; },
    };
    let (up,) = run_ED25519_HALVE_UP_circuit(u, w, e, wp);
    let (is_square, root) = match sqrt_or_twice(up) {
        Some(pair) => pair,
        None => { return false; },
    };
    let (w, sign) = if is_square {
        (root, One::one())
    } else {
        let (next_e, next_wp, next_w) = run_ED25519_HALVE_NQR_circuit(e, wp, root);
        e = next_e;
        wp = next_wp;
        (next_w, MINUS_ONE)
    };
    // Zero has symbol zero and cannot equal one, so no exceptional Miller value passes.
    let (quartic,) = run_ED25519_FINISH_circuit(e, wp, w, sign);
    quartic.is_one()
}
