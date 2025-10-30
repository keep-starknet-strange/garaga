use core::array::ArrayTrait;
use core::circuit::{
    CircuitElement, CircuitInput, CircuitInputs, CircuitModulus, CircuitOutputsTrait,
    EvalCircuitTrait, circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384, u96,
};
use core::num::traits::{One, Zero};
use core::panic_with_felt252;
use core::poseidon::hades_permutation;
use core::result::ResultTrait;
use corelib_imports::bounded_int::{downcast, upcast};
use corelib_imports::integer::{U128sFromFelt252Result, u128s_from_felt252};
use garaga::basic_field_ops::{is_opposite_mod_p, mul_mod_p, neg_mod_p, sub_mod_p};
use garaga::circuits::ec;
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::{
    G1Point, G1PointZero, get_G, get_a, get_b, get_curve_order_modulus, get_eigenvalue, get_min_one,
    get_min_one_order, get_modulus, get_n, get_nG_glv_fake_glv, get_third_root_of_unity,
};
use garaga::ec::selectors;

#[generate_trait]
pub impl G1PointImpl of G1PointTrait {
    fn assert_on_curve_excluding_infinity(self: @G1Point, curve_index: usize) {
        if self.is_on_curve_excluding_infinity(curve_index) == false {
            panic_with_felt252('point not on curve');
        }
    }
    fn is_on_curve_excluding_infinity(self: @G1Point, curve_index: usize) -> bool {
        let (check) = ec::run_IS_ON_CURVE_G1_circuit(
            *self, get_a(curve_index), get_b(curve_index), curve_index,
        );
        check.is_zero()
    }
    fn negate(self: @G1Point, curve_index: usize) -> G1Point {
        let modulus = get_modulus(curve_index);
        G1Point { x: *self.x, y: neg_mod_p(*self.y, modulus) }
    }
    fn assert_in_subgroup_excluding_infinity(self: @G1Point, curve_index: usize) {
        self.assert_on_curve_excluding_infinity(curve_index);
        match curve_index {
            0 => {}, // BN254 (cofactor 1)
            1 => {
                // https://github.com/Consensys/gnark-crypto/blob/ff4c0ddbe1ef37d1c1c6bec8c36fc43a84c86be5/ecc/bls12-381/g1.go#L492
                let modulus = get_modulus(curve_index);
                let phi_p = G1Point {
                    x: mul_mod_p(get_third_root_of_unity(curve_index), *self.x, modulus),
                    y: *self.y,
                };

                let x_sq_phi_P = scalar_mul_by_bls12_381_seed_square(phi_p);
                if !ec_safe_add(*self, x_sq_phi_P, curve_index).is_infinity() {
                    panic_with_felt252('bls12-381 pt not in subgroup');
                }
            }, // BLS12-381
            2 => {}, // SECP256K1 (cofactor 1)
            3 => {}, // SECP256R1 (cofactor 1)
            4 => { panic_with_felt252('ED25519 not implemented'); },
            5 => {}, // GRUMPKIN (cofactor 1)
            _ => { panic_with_felt252('invalid curve index') },
        }
    }
    fn is_infinity(self: @G1Point) -> bool {
        return self.is_zero();
    }
    fn update_hash_state(
        self: @G1Point, s0: felt252, s1: felt252, s2: felt252,
    ) -> (felt252, felt252, felt252) {
        let base: felt252 = 79228162514264337593543950336; // 2**96
        let self = *self;
        let in_1 = s0 + self.x.limb0.into() + base * self.x.limb1.into();
        let in_2 = s1 + self.x.limb2.into() + base * self.x.limb3.into();
        let (s0, s1, s2) = hades_permutation(in_1, in_2, s2);
        let in_1 = s0 + self.y.limb0.into() + base * self.y.limb1.into();
        let in_2 = s1 + self.y.limb2.into() + base * self.y.limb3.into();
        let (s0, s1, s2) = hades_permutation(in_1, in_2, s2);
        return (s0, s1, s2);
    }
}

// Adds two elliptic curve points on a given curve.
// Does not check the input points are on the curve.
pub fn ec_safe_add(p: G1Point, q: G1Point, curve_index: usize) -> G1Point {
    if p.is_infinity() {
        return q;
    }
    if q.is_infinity() {
        return p;
    }
    let modulus = get_modulus(curve_index);
    let same_x = sub_mod_p(p.x, q.x, modulus).is_zero();

    if same_x {
        let opposite_y = is_opposite_mod_p(p.y, q.y, modulus);
        if opposite_y {
            return G1PointZero::zero();
        } else {
            let (res) = ec::run_DOUBLE_EC_POINT_circuit(p, get_a(curve_index), modulus);
            return res;
        }
    } else {
        let (res) = ec::run_ADD_EC_POINT_circuit(p, q, modulus);
        return res;
    }
}

pub fn _ec_safe_add(
    p: G1Point, q: G1Point, modulus: CircuitModulus, curve_index: usize,
) -> G1Point {
    if p.is_infinity() {
        return q;
    }
    if q.is_infinity() {
        return p;
    }
    let same_x = sub_mod_p(p.x, q.x, modulus).is_zero();

    if same_x {
        let opposite_y = is_opposite_mod_p(p.y, q.y, modulus);
        if opposite_y {
            return G1PointZero::zero();
        } else {
            let (res) = ec::run_DOUBLE_EC_POINT_circuit(p, get_a(curve_index), modulus);
            return res;
        }
    } else {
        let (res) = ec::run_ADD_EC_POINT_circuit(p, q, modulus);
        return res;
    }
}

#[derive(Drop, Serde)]
pub struct GlvFakeGlvHint {
    pub Q: G1Point,
    pub u1: felt252, // Encoded as 2^128 * sign + abs(u1)
    pub u2: felt252, // Encoded as 2^128 * sign + abs(u2)
    pub v1: felt252, // Encoded as 2^128 * sign + abs(v1)
    pub v2: felt252 // Encoded as 2^128 * sign + abs(v2)
}

#[derive(Drop, Serde)]
pub struct FakeGlvHint {
    pub Q: G1Point,
    pub s1: u128, // (s1)_u128 (always positive)
    pub s2: felt252 // Encoded as 2^128 * sign + abs(s2)_u128
}

pub fn msm_g1(
    points: Span<G1Point>, scalars: Span<u256>, curve_index: usize, mut hint: Span<felt252>,
) -> G1Point {
    match curve_index {
        0 | 1 | 2 => { return msm_glv_fake_glv(points, scalars, curve_index, ref hint); },
        _ => { return msm_fake_glv(points, scalars, curve_index, ref hint); },
    }
}


pub fn msm_fake_glv(
    mut points: Span<G1Point>, mut scalars: Span<u256>, curve_index: usize, ref hint: Span<felt252>,
) -> G1Point {
    let n = scalars.len();
    assert(n == points.len(), 'n_pts!=n_scalars');
    if n == 0 {
        panic_with_felt252('Msm size must be >= 1');
    }
    assert(hint.len() == n * 10, 'wrong fakeglv hint size');

    let order_modulus = get_curve_order_modulus(curve_index);
    let curve_order: u256 = get_n(curve_index);
    let modulus = get_modulus(curve_index);
    let A_weirstrass = get_a(curve_index);
    let order_minus_one = get_min_one_order(curve_index);
    let base_min_one = get_min_one(curve_index);
    let mut acc = G1PointZero::zero();

    while hint.len() != 0 {
        let pt = *points.pop_front().unwrap();
        let scalar = *scalars.pop_front().unwrap();
        assert(scalar < curve_order, 'unreduced scalar');
        let scalar_u384: u384 = scalar.into();
        let fake_glv_hint: FakeGlvHint = Serde::deserialize(ref hint).unwrap();
        let temp = _scalar_mul_fake_glv(
            pt,
            scalar_u384,
            order_modulus,
            modulus,
            A_weirstrass,
            order_minus_one,
            base_min_one,
            fake_glv_hint,
            curve_index,
        );
        acc = _ec_safe_add(acc, temp, modulus, curve_index);
    }
    return acc;
}

pub fn _scalar_mul_fake_glv(
    point: G1Point,
    scalar: u384,
    order_modulus: CircuitModulus,
    modulus: CircuitModulus,
    A_weirstrass: u384,
    order_minus_one: u384,
    base_min_one: u384,
    hint: FakeGlvHint,
    curve_index: usize,
) -> G1Point {
    if scalar.is_zero() || point.is_infinity() {
        return G1PointZero::zero();
    }
    point.assert_on_curve_excluding_infinity(curve_index);

    if scalar.is_one() {
        return point;
    }
    if scalar == order_minus_one {
        return G1Point { x: point.x, y: neg_mod_p(point.y, modulus) };
    }

    hint.Q.assert_on_curve_excluding_infinity(curve_index);

    let (_s2_sign_order, _s2_sign_base, _s2_abs): (u384, u384, u128) =
        match u128s_from_felt252(hint.s2) {
        U128sFromFelt252Result::Narrow(low) => {
            (
                u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
                u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 },
                low,
            )
        },
        U128sFromFelt252Result::Wide((_, low)) => { (order_minus_one, base_min_one, low) },
    };

    // Verify decomposition : s1 + scalar*s2 = 0 mod n && s2!=0.
    let s1 = CircuitElement::<CircuitInput<0>> {};
    let S = CircuitElement::<CircuitInput<1>> {};
    let s2 = CircuitElement::<CircuitInput<2>> {};
    let s2_sign = CircuitElement::<CircuitInput<3>> {};

    let check = circuit_add(s1, circuit_mul(S, circuit_mul(s2_sign, s2)));

    let s1_u384: u384 = hint.s1.into();
    let s2_u384: u384 = _s2_abs.into();
    let outputs = (check,)
        .new_inputs()
        .next_2(s1_u384)
        .next_2(scalar)
        .next_2(s2_u384)
        .next_2(_s2_sign_order)
        .done_2()
        .eval(order_modulus)
        .unwrap();

    assert(_s2_abs != 0, 'FakeGLV: s2=0');
    assert(outputs.get_output(check).is_zero(), 'Wrong FakeGLV decomposition');

    let (T1, T2, T3, T4, T5y, T6y, T7y, T8y, T9, T10, T11, T12, T13y, T14y, T15y, T16y, R2, R0y) =
        ec::run_PREPARE_FAKE_GLV_PTS_circuit(
        point, hint.Q, _s2_sign_base, A_weirstrass, modulus,
    );

    // ['T6', 'T7', 'T10', 'T11', 'T8', 'T5', 'T12', 'T9', 'T14', 'T15', 'T2', 'T3', 'T16', 'T13',
    // 'T4', 'T1']
    let mut Ts: Array<G1Point> = array![
        G1Point { x: T1.x, y: T6y }, G1Point { x: T4.x, y: T7y }, T10, T11,
        G1Point { x: T3.x, y: T8y }, G1Point { x: T2.x, y: T5y }, T12, T9,
        G1Point { x: T9.x, y: T14y }, G1Point { x: T12.x, y: T15y }, T2, T3,
        G1Point { x: T11.x, y: T16y }, G1Point { x: T10.x, y: T13y }, T4, T1,
    ];

    let (mut selectors, s1lsb, s2lsb) = selectors::build_selectors_inlined_fake_glv(
        hint.s1, _s2_abs,
    );

    // Add corrected point for the last bits 2-1 at position 16 in Ts array.
    let last_selector = *selectors.pop_front().unwrap();
    let last_selector_pt = *Ts[last_selector];
    let (last_selector_pt_corrected) = ec::run_ADD_EC_POINT_circuit(last_selector_pt, R2, modulus);
    Ts.append(last_selector_pt_corrected);

    let Ts = Ts.span();

    // now the first selector should be 16 and will select the corrected point in the last
    // iteration.

    // First iteration (bit 128)
    let selector_y = *selectors.pop_back().unwrap();
    let Bi = *Ts[selector_y];

    let (Acc) = ec::run_DOUBLE_EC_POINT_circuit(T2, A_weirstrass, modulus);
    let (mut Acc) = ec::run_ADD_EC_POINT_circuit(Acc, Bi, modulus);

    // assert(selectors.len() == 63, 'wrong number of selectors');
    // 7 iterations* 9 * 2 bits = 63 * 2 = 126 bits.
    while let Some(selector_y) = selectors.multi_pop_back::<9>() {
        let [
            selector_y8,
            selector_y7,
            selector_y6,
            selector_y5,
            selector_y4,
            selector_y3,
            selector_y2,
            selector_y1,
            selector_y0,
        ] =
            selector_y
            .unbox();

        let Bi = *Ts.at(selector_y0);
        let Bi1 = *Ts.at(selector_y1);
        let Bi2 = *Ts.at(selector_y2);
        let Bi3 = *Ts.at(selector_y3);
        let Bi4 = *Ts.at(selector_y4);
        let Bi5 = *Ts.at(selector_y5);
        let Bi6 = *Ts.at(selector_y6);
        let Bi7 = *Ts.at(selector_y7);
        let Bi8 = *Ts.at(selector_y8);

        let (_Acc) = ec::run_QUADRUPLE_AND_ADD_9_circuit(
            Acc, Bi, Bi1, Bi2, Bi3, Bi4, Bi5, Bi6, Bi7, Bi8, A_weirstrass, modulus,
        );
        Acc = _Acc;
    }

    let (Acc) = if s1lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(
            Acc, G1Point { x: point.x, y: neg_mod_p(point.y, modulus) }, modulus,
        )
    } else {
        (Acc,)
    };
    let (Acc) = if s2lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(Acc, G1Point { x: hint.Q.x, y: R0y }, modulus)
    } else {
        (Acc,)
    };

    // Assert.
    assert(Acc == R2, 'wrong FakeGLV result');

    return hint.Q;
}


fn msm_glv_fake_glv(
    mut points: Span<G1Point>, mut scalars: Span<u256>, curve_index: usize, ref hint: Span<felt252>,
) -> G1Point {
    let n = scalars.len();
    assert!(n == points.len(), "scalars and points length mismatch");
    if n == 0 {
        panic_with_felt252('Msm size must be >= 1');
    }
    assert(hint.len() == n * 12, 'wrong glv&fakeglv hint size');
    let eigen = get_eigenvalue(curve_index);
    let third_root_of_unity = get_third_root_of_unity(curve_index);
    let modulus = get_modulus(curve_index);
    let order_modulus = get_curve_order_modulus(curve_index);
    let curve_order: u256 = get_n(curve_index);
    let min_one = get_min_one_order(curve_index);
    let nG = get_nG_glv_fake_glv(curve_index);

    let mut acc = G1PointZero::zero();

    while hint.len() != 0 {
        let pt = *points.pop_front().unwrap();
        let scalar = *scalars.pop_front().unwrap();
        assert(scalar < curve_order, 'unreduced scalar');
        let scalar_u384: u384 = scalar.into();
        let glv_fake_glv_hint: GlvFakeGlvHint = Serde::deserialize(ref hint).unwrap();
        match pt.is_infinity() {
            true => { acc = acc; },
            false => {
                pt.assert_on_curve_excluding_infinity(curve_index);
                let temp = _scalar_mul_glv_and_fake_glv(
                    pt,
                    scalar_u384,
                    order_modulus,
                    modulus,
                    glv_fake_glv_hint,
                    eigen,
                    third_root_of_unity,
                    min_one,
                    nG,
                    curve_index,
                );
                acc = _ec_safe_add(acc, temp, modulus, curve_index);
            },
        }
    }

    return acc;
}


#[inline(always)]
// /!\ Assumes point is on curve (not infinity) and scalar is reduced mod n. /!\
pub fn _scalar_mul_glv_and_fake_glv(
    point: G1Point,
    scalar: u384,
    order_modulus: CircuitModulus,
    modulus: CircuitModulus,
    hint: GlvFakeGlvHint,
    _lambda: u384,
    third_root_of_unity: u384,
    minus_one: u384,
    n_bits_G: G1Point,
    curve_index: usize,
) -> G1Point {
    if scalar.is_zero() {
        return G1PointZero::zero();
    }
    if scalar.is_one() {
        return point;
    }

    hint.Q.assert_on_curve_excluding_infinity(curve_index);

    if scalar == minus_one {
        return G1Point { x: point.x, y: neg_mod_p(point.y, modulus) };
    }

    let one_u384: u384 = u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 };

    // Retrieve the u1, u2, v1, v2 values from the hint
    // They are encoded as 2^128 * sign + abs(value)
    // If high_128 limbs are != 0, we consider the value is negative, otherwise it is positive.
    // We also precompute the negated value of the y coordinate of the points based on the sign in
    // the same match condition for efficiency.

    let (_u1_sign, _u1_abs, P0y, P1y): (u384, u96, u384, u384) = match u128s_from_felt252(hint.u1) {
        U128sFromFelt252Result::Narrow(low) => {
            (one_u384, downcast(low).unwrap(), neg_mod_p(point.y, modulus), point.y)
        },
        U128sFromFelt252Result::Wide((
            _, low,
        )) => { (minus_one, downcast(low).unwrap(), point.y, neg_mod_p(point.y, modulus)) },
    };
    let (_u2_sign, _u2_abs, Phi_P0y, Phi_P1y): (u384, u96, u384, u384) =
        match u128s_from_felt252(hint.u2) {
        U128sFromFelt252Result::Narrow(low) => {
            (one_u384, downcast(low).unwrap(), neg_mod_p(point.y, modulus), point.y)
        },
        U128sFromFelt252Result::Wide((
            _, low,
        )) => { (minus_one, downcast(low).unwrap(), point.y, neg_mod_p(point.y, modulus)) },
    };
    let (_v1_sign, _v1_abs, Q0y): (u384, u96, u384) = match u128s_from_felt252(hint.v1) {
        U128sFromFelt252Result::Narrow(low) => {
            (one_u384, downcast(low).unwrap(), neg_mod_p(hint.Q.y, modulus))
        },
        U128sFromFelt252Result::Wide((_, low)) => { (minus_one, downcast(low).unwrap(), hint.Q.y) },
    };
    let (_v2_sign, _v2_abs, Phi_Q0y): (u384, u96, u384) = match u128s_from_felt252(hint.v2) {
        U128sFromFelt252Result::Narrow(low) => {
            (one_u384, downcast(low).unwrap(), neg_mod_p(hint.Q.y, modulus))
        },
        U128sFromFelt252Result::Wide((_, low)) => { (minus_one, downcast(low).unwrap(), hint.Q.y) },
    };

    // At this point ~ 631 steps.

    // Check that the GLV/FakeGLV decomposition is valid:
    // # s*(v1 + λ*v2) + u1 + λ*u2 = 0
    let s = CircuitElement::<CircuitInput<0>> {};
    let lambda = CircuitElement::<CircuitInput<1>> {};
    let u1_abs = CircuitElement::<CircuitInput<2>> {};
    let u1_sign = CircuitElement::<CircuitInput<3>> {};
    let u2_abs = CircuitElement::<CircuitInput<4>> {};
    let u2_sign = CircuitElement::<CircuitInput<5>> {};
    let v1_abs = CircuitElement::<CircuitInput<6>> {};
    let v1_sign = CircuitElement::<CircuitInput<7>> {};
    let v2_abs = CircuitElement::<CircuitInput<8>> {};
    let v2_sign = CircuitElement::<CircuitInput<9>> {};

    let u1 = circuit_mul(u1_abs, u1_sign);
    let u2 = circuit_mul(u2_abs, u2_sign);
    let v1 = circuit_mul(v1_abs, v1_sign);
    let v2 = circuit_mul(v2_abs, v2_sign);

    // u1 + λ*u2
    let lambda_u2 = circuit_mul(lambda, u2);
    let u1_lambda_u2 = circuit_add(u1, lambda_u2);

    // s*(v1 + λ*v2)
    let lambda_v2 = circuit_mul(lambda, v2);
    let v1_lambda_v2 = circuit_add(v1, lambda_v2);
    let s_v1_lambda_v2 = circuit_mul(s, v1_lambda_v2);

    // s*(v1 + λ*v2) + u1 + λ*u2
    let res = circuit_add(s_v1_lambda_v2, u1_lambda_u2);

    let outputs = (res,)
        .new_inputs()
        .next_2(scalar)
        .next_2(_lambda)
        .next_2([_u1_abs, 0, 0, 0])
        .next_2(_u1_sign)
        .next_2([_u2_abs, 0, 0, 0])
        .next_2(_u2_sign)
        .next_2([_v1_abs, 0, 0, 0])
        .next_2(_v1_sign)
        .next_2([_v2_abs, 0, 0, 0])
        .next_2(_v2_sign)
        .done_2()
        .eval(order_modulus)
        .unwrap();

    assert(outputs.get_output(res).is_zero(), 'Wrong GLV/FakeGLV decomposition');

    // At this point, ~ 836 steps

    // Note : P != Q (scalar != 1)
    let P0 = G1Point { x: point.x, y: P0y };
    let Q0 = G1Point { x: hint.Q.x, y: Q0y };

    let (
        B1,
        B2,
        B3,
        B4,
        B5,
        B6,
        B7,
        B8,
        B9y,
        B10y,
        B11y,
        B12y,
        B13y,
        B14y,
        B15y,
        B16y,
        Phi_P0x,
        Phi_Q0x,
        mut Acc,
    ) =
        ec::run_PREPARE_GLV_FAKE_GLV_PTS_circuit(
        point.x,
        P0y,
        P1y,
        hint.Q.x,
        Q0y,
        Phi_P0y,
        Phi_P1y,
        Phi_Q0y,
        get_G(curve_index),
        third_root_of_unity,
        modulus,
    );
    let Bs: Span<G1Point> = array![
        G1Point { x: B1.x, y: B16y }, B8, G1Point { x: B3.x, y: B14y }, B6,
        G1Point { x: B5.x, y: B12y }, B4, G1Point { x: B7.x, y: B10y }, B2,
        G1Point { x: B2.x, y: B15y }, B7, G1Point { x: B4.x, y: B13y }, B5,
        G1Point { x: B6.x, y: B11y }, B3, G1Point { x: B8.x, y: B9y }, B1,
    ]
        .span();

    // At this point, ~ 1643 steps.

    // println!("Bs: {:?}", Bs);
    // println!("Acc: {:?}", Acc);
    let mut _u1: u128 = upcast(_u1_abs);
    let mut _u2: u128 = upcast(_u2_abs);
    let mut _v1: u128 = upcast(_v1_abs);
    let mut _v2: u128 = upcast(_v2_abs);

    let (mut selectors, u1lsb, u2lsb, v1lsb, v2lsb) = selectors::build_selectors_inlined(
        _u1, _u2, _v1, _v2,
    );

    // Process 8 bits per iteration
    while let Some(selector_y) = selectors.multi_pop_back::<8>() {
        let [
            selector_y7,
            selector_y6,
            selector_y5,
            selector_y4,
            selector_y3,
            selector_y2,
            selector_y1,
            selector_y0,
        ] =
            (*selector_y)
            .unbox();
        let Bi = *Bs.at(selector_y0);
        let Bi1 = *Bs.at(selector_y1);
        let Bi2 = *Bs.at(selector_y2);
        let Bi3 = *Bs.at(selector_y3);
        let Bi4 = *Bs.at(selector_y4);
        let Bi5 = *Bs.at(selector_y5);
        let Bi6 = *Bs.at(selector_y6);
        let Bi7 = *Bs.at(selector_y7);

        Acc = double_and_add_8(Acc, Bi, Bi1, Bi2, Bi3, Bi4, Bi5, Bi6, Bi7, modulus);
    }

    // println!("Acc final: {:?}", Acc);
    let (Acc) = if u1lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(Acc, P0, modulus)
    } else {
        (Acc,)
    };
    let (Acc) = if u2lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(Acc, G1Point { x: Phi_P0x, y: Phi_P0y }, modulus)
    } else {
        (Acc,)
    };

    let (Acc) = if v1lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(Acc, Q0, modulus)
    } else {
        (Acc,)
    };

    let (Acc) = if v2lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(Acc, G1Point { x: Phi_Q0x, y: Phi_Q0y }, modulus)
    } else {
        (Acc,)
    };

    assert(Acc == n_bits_G, 'Wrong Glv&FakeGLV result');

    return hint.Q;
}

fn scalar_mul_by_bls12_381_seed_square(q: G1Point) -> G1Point {
    let a = get_a(1);
    let modulus = get_modulus(1);
    let (z) = ec::run_DOUBLE_EC_POINT_circuit(q, a, modulus); // z := g1.double(q)
    let (z) = ec::run_ADD_EC_POINT_circuit(q, z, modulus); // z = g1.add(q, z)
    let (z) = ec::run_DOUBLE_EC_POINT_circuit(z, a, modulus); // z = g1.double(z)
    let z = double_and_add(z, q, modulus); // z = g1.doubleAndAdd(z, q)
    let z = double_n_times(z, 2, modulus, a); // z = g1.doubleN(z, 2)
    let z = double_and_add(z, q, modulus); // z = g1.doubleAndAdd(z, q)
    let z = double_n_times(z, 8, modulus, a); // z = g1.doubleN(z, 8)
    let z = double_and_add(z, q, modulus); // z = g1.doubleAndAdd(z, q)
    let (t0) = ec::run_DOUBLE_EC_POINT_circuit(z, a, modulus); // t0 := g1.double(z)
    let (t0) = ec::run_ADD_EC_POINT_circuit(z, t0, modulus); // t0 = g1.add(z, t0)
    let (t0) = ec::run_DOUBLE_EC_POINT_circuit(t0, a, modulus); // t0 = g1.double(t0)
    let t0 = double_and_add(t0, z, modulus); // t0 = g1.doubleAndAdd(t0, z)
    let t0 = double_n_times(t0, 2, modulus, a); // t0 = g1.doubleN(t0, 2)
    let t0 = double_and_add(t0, z, modulus); // t0 = g1.doubleAndAdd(t0, z)
    let t0 = double_n_times(t0, 8, modulus, a); // t0 = g1.doubleN(t0, 8)
    let t0 = double_and_add(t0, z, modulus); // t0 = g1.doubleAndAdd(t0, z)
    let t0 = double_n_times(t0, 31, modulus, a); // t0 = g1.doubleN(t0, 31)
    let (z) = ec::run_ADD_EC_POINT_circuit(t0, z, modulus); // z = g1.add(t0, z)
    let z = double_n_times(z, 32, modulus, a); // z = g1.doubleN(z, 32)
    let z = double_and_add(z, q, modulus); // z = g1.doubleAndAdd(z, q)
    let z = double_n_times(z, 32, modulus, a); // z = g1.doubleN(z, 32)
    return z;
}

pub fn double_n_times(p: G1Point, n: usize, modulus: CircuitModulus, a: u384) -> G1Point {
    let mut res = p;
    for _ in 0..n {
        let (tmp) = ec::run_DOUBLE_EC_POINT_circuit(res, a, modulus);
        res = tmp;
    }
    return res;
}


// Computes 2*P + Q
pub fn double_and_add(p: G1Point, q: G1Point, modulus: CircuitModulus) -> G1Point {
    let px = CircuitElement::<CircuitInput<0>> {};
    let py = CircuitElement::<CircuitInput<1>> {};
    let qx = CircuitElement::<CircuitInput<2>> {};
    let qy = CircuitElement::<CircuitInput<3>> {};

    // Compute lambda1 for P + Q
    let num_lambda1 = circuit_sub(qy, py);
    let den_lambda1 = circuit_sub(qx, px);
    let lambda1 = circuit_mul(num_lambda1, circuit_inverse(den_lambda1));

    // Compute x-coordinate of P + Q
    let lambda1_sq = circuit_mul(lambda1, lambda1);
    let x2 = circuit_sub(lambda1_sq, px);
    let x2 = circuit_sub(x2, qx);

    // Compute lambda2 for 2*P
    let den_lambda2 = circuit_sub(x2, px);
    let num_lambda2 = circuit_add(py, py);
    let term2_lambda2 = circuit_mul(num_lambda2, circuit_inverse(den_lambda2));
    let lambda2 = circuit_add(lambda1, term2_lambda2);

    // Compute final coordinates of 2*P + Q
    let lambda2_sq = circuit_mul(lambda2, lambda2);
    let tx_temp = circuit_sub(lambda2_sq, px);
    let result_x = circuit_sub(tx_temp, x2);

    let tx_sub_px = circuit_sub(result_x, px);
    let term1_ty = circuit_mul(lambda2, tx_sub_px);
    let result_y = circuit_sub(term1_ty, py);

    let outputs = (result_x, result_y)
        .new_inputs()
        .next_2(p.x)
        .next_2(p.y)
        .next_2(q.x)
        .next_2(q.y)
        .done_2()
        .eval(modulus)
        .expect('double_and_add failed');

    return G1Point { x: outputs.get_output(result_x), y: outputs.get_output(result_y) };
}


// Computes 2*(2*(2*(2*(2*(2*(2*(2*P + Q0) + Q1) + Q2) + Q3) + Q4) + Q5) + Q6) + Q7
#[inline(always)]
pub fn double_and_add_8(
    p: G1Point,
    q0: G1Point,
    q1: G1Point,
    q2: G1Point,
    q3: G1Point,
    q4: G1Point,
    q5: G1Point,
    q6: G1Point,
    q7: G1Point,
    modulus: CircuitModulus,
) -> G1Point {
    let px = CircuitElement::<CircuitInput<0>> {};
    let py = CircuitElement::<CircuitInput<1>> {};
    let q0x = CircuitElement::<CircuitInput<2>> {};
    let q0y = CircuitElement::<CircuitInput<3>> {};
    let q1x = CircuitElement::<CircuitInput<4>> {};
    let q1y = CircuitElement::<CircuitInput<5>> {};
    let q2x = CircuitElement::<CircuitInput<6>> {};
    let q2y = CircuitElement::<CircuitInput<7>> {};
    let q3x = CircuitElement::<CircuitInput<8>> {};
    let q3y = CircuitElement::<CircuitInput<9>> {};
    let q4x = CircuitElement::<CircuitInput<10>> {};
    let q4y = CircuitElement::<CircuitInput<11>> {};
    let q5x = CircuitElement::<CircuitInput<12>> {};
    let q5y = CircuitElement::<CircuitInput<13>> {};
    let q6x = CircuitElement::<CircuitInput<14>> {};
    let q6y = CircuitElement::<CircuitInput<15>> {};
    let q7x = CircuitElement::<CircuitInput<16>> {};
    let q7y = CircuitElement::<CircuitInput<17>> {};

    // --- Step 1: (2 * CurrentP) + Q0 ---
    let num_lambda1_0 = circuit_sub(q0y, py);
    let den_lambda1_0 = circuit_sub(q0x, px);
    let lambda1_0 = circuit_mul(num_lambda1_0, circuit_inverse(den_lambda1_0));

    let lambda1_sq_0 = circuit_mul(lambda1_0, lambda1_0);
    let x2_0 = circuit_sub(lambda1_sq_0, px);
    let x2_0 = circuit_sub(x2_0, q0x);

    let den_lambda2_0 = circuit_sub(x2_0, px);
    let num_lambda2_0 = circuit_add(py, py);
    let term2_lambda2_0 = circuit_mul(num_lambda2_0, circuit_inverse(den_lambda2_0));
    let lambda2_0 = circuit_add(lambda1_0, term2_lambda2_0);

    let lambda2_sq_0 = circuit_mul(lambda2_0, lambda2_0);
    let tx_temp_0 = circuit_sub(lambda2_sq_0, px);
    let T1x = circuit_sub(tx_temp_0, x2_0);

    let tx_sub_px_0 = circuit_sub(T1x, px);
    let term1_ty_0 = circuit_mul(lambda2_0, tx_sub_px_0);
    let T1y = circuit_sub(term1_ty_0, py);

    // --- Step 2: (2 * CurrentP) + Q1 ---
    let num_lambda1_1 = circuit_sub(q1y, T1y);
    let den_lambda1_1 = circuit_sub(q1x, T1x);
    let lambda1_1 = circuit_mul(num_lambda1_1, circuit_inverse(den_lambda1_1));

    let lambda1_sq_1 = circuit_mul(lambda1_1, lambda1_1);
    let x2_1 = circuit_sub(lambda1_sq_1, T1x);
    let x2_1 = circuit_sub(x2_1, q1x);

    let den_lambda2_1 = circuit_sub(x2_1, T1x);
    let num_lambda2_1 = circuit_add(T1y, T1y);
    let term2_lambda2_1 = circuit_mul(num_lambda2_1, circuit_inverse(den_lambda2_1));
    let lambda2_1 = circuit_add(lambda1_1, term2_lambda2_1);

    let lambda2_sq_1 = circuit_mul(lambda2_1, lambda2_1);
    let tx_temp_1 = circuit_sub(lambda2_sq_1, T1x);
    let T2x = circuit_sub(tx_temp_1, x2_1);

    let tx_sub_px_1 = circuit_sub(T2x, T1x);
    let term1_ty_1 = circuit_mul(lambda2_1, tx_sub_px_1);
    let T2y = circuit_sub(term1_ty_1, T1y);

    // --- Step 3: (2 * CurrentP) + Q2 ---
    let num_lambda1_2 = circuit_sub(q2y, T2y);
    let den_lambda1_2 = circuit_sub(q2x, T2x);
    let lambda1_2 = circuit_mul(num_lambda1_2, circuit_inverse(den_lambda1_2));

    let lambda1_sq_2 = circuit_mul(lambda1_2, lambda1_2);
    let x2_2 = circuit_sub(lambda1_sq_2, T2x);
    let x2_2 = circuit_sub(x2_2, q2x);

    let den_lambda2_2 = circuit_sub(x2_2, T2x);
    let num_lambda2_2 = circuit_add(T2y, T2y);
    let term2_lambda2_2 = circuit_mul(num_lambda2_2, circuit_inverse(den_lambda2_2));
    let lambda2_2 = circuit_add(lambda1_2, term2_lambda2_2);

    let lambda2_sq_2 = circuit_mul(lambda2_2, lambda2_2);
    let tx_temp_2 = circuit_sub(lambda2_sq_2, T2x);
    let T3x = circuit_sub(tx_temp_2, x2_2);

    let tx_sub_px_2 = circuit_sub(T3x, T2x);
    let term1_ty_2 = circuit_mul(lambda2_2, tx_sub_px_2);
    let T3y = circuit_sub(term1_ty_2, T2y);

    // --- Step 4: (2 * CurrentP) + Q3 ---
    let num_lambda1_3 = circuit_sub(q3y, T3y);
    let den_lambda1_3 = circuit_sub(q3x, T3x);
    let lambda1_3 = circuit_mul(num_lambda1_3, circuit_inverse(den_lambda1_3));

    let lambda1_sq_3 = circuit_mul(lambda1_3, lambda1_3);
    let x2_3 = circuit_sub(lambda1_sq_3, T3x);
    let x2_3 = circuit_sub(x2_3, q3x);

    let den_lambda2_3 = circuit_sub(x2_3, T3x);
    let num_lambda2_3 = circuit_add(T3y, T3y);
    let term2_lambda2_3 = circuit_mul(num_lambda2_3, circuit_inverse(den_lambda2_3));
    let lambda2_3 = circuit_add(lambda1_3, term2_lambda2_3);

    let lambda2_sq_3 = circuit_mul(lambda2_3, lambda2_3);
    let tx_temp_3 = circuit_sub(lambda2_sq_3, T3x);
    let T4x = circuit_sub(tx_temp_3, x2_3);

    let tx_sub_px_3 = circuit_sub(T4x, T3x);
    let term1_ty_3 = circuit_mul(lambda2_3, tx_sub_px_3);
    let T4y = circuit_sub(term1_ty_3, T3y);

    // --- Step 5: (2 * CurrentP) + Q4 ---
    let num_lambda1_4 = circuit_sub(q4y, T4y);
    let den_lambda1_4 = circuit_sub(q4x, T4x);
    let lambda1_4 = circuit_mul(num_lambda1_4, circuit_inverse(den_lambda1_4));

    let lambda1_sq_4 = circuit_mul(lambda1_4, lambda1_4);
    let x2_4 = circuit_sub(lambda1_sq_4, T4x);
    let x2_4 = circuit_sub(x2_4, q4x);

    let den_lambda2_4 = circuit_sub(x2_4, T4x);
    let num_lambda2_4 = circuit_add(T4y, T4y);
    let term2_lambda2_4 = circuit_mul(num_lambda2_4, circuit_inverse(den_lambda2_4));
    let lambda2_4 = circuit_add(lambda1_4, term2_lambda2_4);

    let lambda2_sq_4 = circuit_mul(lambda2_4, lambda2_4);
    let tx_temp_4 = circuit_sub(lambda2_sq_4, T4x);
    let T5x = circuit_sub(tx_temp_4, x2_4);

    let tx_sub_px_4 = circuit_sub(T5x, T4x);
    let term1_ty_4 = circuit_mul(lambda2_4, tx_sub_px_4);
    let T5y = circuit_sub(term1_ty_4, T4y);

    // --- Step 6: (2 * CurrentP) + Q5 ---
    let num_lambda1_5 = circuit_sub(q5y, T5y);
    let den_lambda1_5 = circuit_sub(q5x, T5x);
    let lambda1_5 = circuit_mul(num_lambda1_5, circuit_inverse(den_lambda1_5));

    let lambda1_sq_5 = circuit_mul(lambda1_5, lambda1_5);
    let x2_5 = circuit_sub(lambda1_sq_5, T5x);
    let x2_5 = circuit_sub(x2_5, q5x);

    let den_lambda2_5 = circuit_sub(x2_5, T5x);
    let num_lambda2_5 = circuit_add(T5y, T5y);
    let term2_lambda2_5 = circuit_mul(num_lambda2_5, circuit_inverse(den_lambda2_5));
    let lambda2_5 = circuit_add(lambda1_5, term2_lambda2_5);

    let lambda2_sq_5 = circuit_mul(lambda2_5, lambda2_5);
    let tx_temp_5 = circuit_sub(lambda2_sq_5, T5x);
    let T6x = circuit_sub(tx_temp_5, x2_5);

    let tx_sub_px_5 = circuit_sub(T6x, T5x);
    let term1_ty_5 = circuit_mul(lambda2_5, tx_sub_px_5);
    let T6y = circuit_sub(term1_ty_5, T5y);

    // --- Step 7: (2 * CurrentP) + Q6 ---
    let num_lambda1_6 = circuit_sub(q6y, T6y);
    let den_lambda1_6 = circuit_sub(q6x, T6x);
    let lambda1_6 = circuit_mul(num_lambda1_6, circuit_inverse(den_lambda1_6));

    let lambda1_sq_6 = circuit_mul(lambda1_6, lambda1_6);
    let x2_6 = circuit_sub(lambda1_sq_6, T6x);
    let x2_6 = circuit_sub(x2_6, q6x);

    let den_lambda2_6 = circuit_sub(x2_6, T6x);
    let num_lambda2_6 = circuit_add(T6y, T6y);
    let term2_lambda2_6 = circuit_mul(num_lambda2_6, circuit_inverse(den_lambda2_6));
    let lambda2_6 = circuit_add(lambda1_6, term2_lambda2_6);

    let lambda2_sq_6 = circuit_mul(lambda2_6, lambda2_6);
    let tx_temp_6 = circuit_sub(lambda2_sq_6, T6x);
    let T7x = circuit_sub(tx_temp_6, x2_6);

    let tx_sub_px_6 = circuit_sub(T7x, T6x);
    let term1_ty_6 = circuit_mul(lambda2_6, tx_sub_px_6);
    let T7y = circuit_sub(term1_ty_6, T6y);

    // --- Step 8: (2 * CurrentP) + Q7 ---
    let num_lambda1_7 = circuit_sub(q7y, T7y);
    let den_lambda1_7 = circuit_sub(q7x, T7x);
    let lambda1_7 = circuit_mul(num_lambda1_7, circuit_inverse(den_lambda1_7));

    let lambda1_sq_7 = circuit_mul(lambda1_7, lambda1_7);
    let x2_7 = circuit_sub(lambda1_sq_7, T7x);
    let x2_7 = circuit_sub(x2_7, q7x);

    let den_lambda2_7 = circuit_sub(x2_7, T7x);
    let num_lambda2_7 = circuit_add(T7y, T7y);
    let term2_lambda2_7 = circuit_mul(num_lambda2_7, circuit_inverse(den_lambda2_7));
    let lambda2_7 = circuit_add(lambda1_7, term2_lambda2_7);

    let lambda2_sq_7 = circuit_mul(lambda2_7, lambda2_7);
    let tx_temp_7 = circuit_sub(lambda2_sq_7, T7x);
    let T8x = circuit_sub(tx_temp_7, x2_7);

    let tx_sub_px_7 = circuit_sub(T8x, T7x);
    let term1_ty_7 = circuit_mul(lambda2_7, tx_sub_px_7);
    let T8y = circuit_sub(term1_ty_7, T7y);

    let outputs = (T8x, T8y)
        .new_inputs()
        .next_2(p.x)
        .next_2(p.y)
        .next_2(q0.x)
        .next_2(q0.y)
        .next_2(q1.x)
        .next_2(q1.y)
        .next_2(q2.x)
        .next_2(q2.y)
        .next_2(q3.x)
        .next_2(q3.y)
        .next_2(q4.x)
        .next_2(q4.y)
        .next_2(q5.x)
        .next_2(q5.y)
        .next_2(q6.x)
        .next_2(q6.y)
        .next_2(q7.x)
        .next_2(q7.y)
        .done_2()
        .eval(modulus)
        .expect('double_and_add_8 failed');

    return G1Point { x: outputs.get_output(T8x), y: outputs.get_output(T8y) };
}

