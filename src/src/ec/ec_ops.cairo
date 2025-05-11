use core::array::ArrayTrait;
use core::circuit::{
    AddInputResultTrait, AddMod, CircuitData, CircuitDefinition, CircuitElement, CircuitInput,
    CircuitInputAccumulator, CircuitInputs, CircuitModulus, CircuitOutputsTrait, EvalCircuitResult,
    EvalCircuitTrait, MulMod, circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384, u96,
};
pub use core::integer::{U128sFromFelt252Result, u128s_from_felt252};
use core::internal::bounded_int;
use core::internal::bounded_int::{
    AddHelper, BoundedInt, DivRemHelper, MulHelper, UnitInt, downcast, upcast,
};
use core::num::traits::{One, Zero};
use core::option::Option;
use core::panic_with_felt252;
use core::poseidon::hades_permutation;
use core::result::ResultTrait;
use garaga::basic_field_ops::{
    add_mod_p, batch_3_mod_p, is_opposite_mod_p, is_zero_mod_p, mul_mod_p, neg_mod_p, sub_mod_p,
};
use garaga::circuits::ec;
use garaga::core::circuit::{AddInputResultTrait2, IntoCircuitInputValue, u288IntoCircuitInputValue};
use garaga::definitions::{
    BLS_X_SEED_SQ, BLS_X_SEED_SQ_EPNS, G1Point, G1PointZero, G2Point,
    THIRD_ROOT_OF_UNITY_BLS12_381_G1, deserialize_u288_array, deserialize_u384,
    deserialize_u384_array, get_G, get_a, get_b, get_b2, get_curve_order_modulus, get_eigenvalue,
    get_g, get_min_one, get_min_one_order, get_modulus, get_n, get_nG_glv_fake_glv,
    get_third_root_of_unity, serialize_u288_array, serialize_u384, serialize_u384_array, u288,
    u384Serde,
};
use garaga::ec::selectors;
use garaga::utils::{hashing, neg_3, u384_assert_eq, u384_assert_zero};

#[generate_trait]
impl G1PointImpl of G1PointTrait {
    fn assert_on_curve(self: @G1Point, curve_index: usize) {
        let (check) = ec::run_IS_ON_CURVE_G1_circuit(
            *self, get_a(curve_index), get_b(curve_index), curve_index,
        );
        u384_assert_zero(check);
    }
    fn is_on_curve(self: @G1Point, curve_index: usize) -> bool {
        let (check) = ec::run_IS_ON_CURVE_G1_circuit(
            *self, get_a(curve_index), get_b(curve_index), curve_index,
        );
        check.is_zero()
    }
    fn negate(self: @G1Point, curve_index: usize) -> G1Point {
        let modulus = get_modulus(curve_index);
        G1Point { x: *self.x, y: neg_mod_p(*self.y, modulus) }
    }
    fn assert_in_subgroup(
        self: @G1Point,
        curve_index: usize,
        hint: Span<felt252> // msm_hint: Option<MSMHintSmallScalar<T>>,
        // derive_point_from_x_hint: Option<DerivePointFromXHint>,
    ) { // match curve_index {
    //     0 => { self.assert_on_curve(curve_index) }, // BN254 (cofactor 1)
    //     1 => {
    //         //
    //         https://github.com/Consensys/gnark-crypto/blob/ff4c0ddbe1ef37d1c1c6bec8c36fc43a84c86be5/ecc/bls12-381/g1.go#L492
    //         let modulus = get_modulus(curve_index);
    //         let x_sq_phi_P = scalar_mul_g1_fixed_small_scalar(
    //             G1Point {
    //                 x: mul_mod_p(THIRD_ROOT_OF_UNITY_BLS12_381_G1, *self.x, modulus),
    //                 y: *self.y,
    //             },
    //             BLS_X_SEED_SQ_EPNS,
    //             BLS_X_SEED_SQ,
    //             msm_hint.unwrap(),
    //             derive_point_from_x_hint.unwrap(),
    //             curve_index,
    //         );
    //         if !ec_safe_add(*self, x_sq_phi_P, curve_index).is_infinity() {
    //             panic_with_felt252('g1 pt not in subgroup');
    //         }
    //     }, // BLS12-381
    //     _ => { panic_with_felt252('invalid curve index') },
    // }

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
struct GlvFakeGlvHint {
    Q: G1Point,
    u1: felt252, // Encoded as 2^128 * sign + abs(u1)_u64
    u2: felt252, // Encoded as 2^128 * sign + abs(u2)_u64
    v1: felt252, // Encoded as 2^128 * sign + abs(v1)_u64
    v2: felt252 // Encoded as 2^128 * sign + abs(v2)_u64
}

#[derive(Drop, Serde)]
struct FakeGlvHint {
    Q: G1Point,
    s1: u128, // (s1)_u128 (always positive)
    s2: felt252 // Encoded as 2^128 * sign + abs(s2)_u128
}

fn msm_g1(
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
    point.assert_on_curve(curve_index);

    if scalar.is_one() {
        return point;
    }
    if scalar == order_minus_one {
        return G1Point { x: point.x, y: neg_mod_p(point.y, modulus) };
    }

    hint.Q.assert_on_curve(curve_index);

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
        G1Point { x: T1.x, y: T6y },
        G1Point { x: T4.x, y: T7y },
        T10,
        T11,
        G1Point { x: T3.x, y: T8y },
        G1Point { x: T2.x, y: T5y },
        T12,
        T9,
        G1Point { x: T9.x, y: T14y },
        G1Point { x: T12.x, y: T15y },
        T2,
        T3,
        G1Point { x: T11.x, y: T16y },
        G1Point { x: T10.x, y: T13y },
        T4,
        T1,
    ];

    let (mut selectors, s1lsb, s2lsb) = selectors::build_selectors_inlined_fake_glv(
        hint.s1, _s2_abs,
    );

    // Add corrected point for the last bits 2-1 at position 16 in Ts array.
    let last_selector = *selectors.pop_front().unwrap();
    let last_selector_pt = *Ts[last_selector];
    let (last_selector_pt_corrected) = ec::run_ADD_EC_POINT_circuit(last_selector_pt, R2, modulus);
    // println!("last_selector_pt_corrected : {:?}", last_selector_pt_corrected);
    Ts.append(last_selector_pt_corrected);

    let Ts = Ts.span();

    // now the first selector should be 16 and will select the corrected point in the last
    // iteration.

    // assert(*selectors[0] == 16, 'wrong first selector');

    // First iteration (bit 128)
    let selector_y = *selectors.pop_back().unwrap();
    // println!("First selector : {:?}", selector_y);
    let Bi = *Ts[selector_y];

    // println!("Point : {:?}", point);
    // println!("Scalar : {:?}", scalar);
    // println!("T2 (Acc) : {:?}", T2);
    // println!("Bi (_T_current) : {:?}", Bi);
    let (Acc) = ec::run_DOUBLE_EC_POINT_circuit(T2, A_weirstrass, modulus);
    let (mut Acc) = ec::run_ADD_EC_POINT_circuit(Acc, Bi, modulus);
    // println!("Acc before loop : {:?}", Acc);
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

        let Bi = *Ts[selector_y0];
        let Bi1 = *Ts[selector_y1];
        let Bi2 = *Ts[selector_y2];
        let Bi3 = *Ts[selector_y3];
        let Bi4 = *Ts[selector_y4];
        let Bi5 = *Ts[selector_y5];
        let Bi6 = *Ts[selector_y6];
        let Bi7 = *Ts[selector_y7];
        let Bi8 = *Ts[selector_y8];

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
    assert(Acc == R2, 'wrong result');

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
                pt.assert_on_curve(curve_index);
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

// let mut u1: BoundedInt<0, { POW128 - 1 }> = upcast(_u1);
// let mut u2: BoundedInt<0, { POW128 - 1 }> = upcast(_u2);
// let mut v1: BoundedInt<0, { POW128 - 1 }> = upcast(_v1);
// let mut v2: BoundedInt<0, { POW128 - 1 }> = upcast(_v2);

// // Initial division and remainder to get LSBs
// let (qu1, u1lsb) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
// let (qu2, u2lsb) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
// let (qv1, v1lsb) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
// let (qv2, v2lsb) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
// u1 = upcast(qu1);
// u2 = upcast(qu2);
// v1 = upcast(qv1);
// v2 = upcast(qv2);

use selectors::{DivRemU128By2, POW128, TWO_NZ_TYPED};

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

    hint.Q.assert_on_curve(curve_index);

    if scalar == minus_one {
        return G1Point { x: point.x, y: neg_mod_p(point.y, modulus) };
    }

    let one_u384: u384 = u384 { limb0: 1, limb1: 0, limb2: 0, limb3: 0 };

    // Retrieve the u1, u2, v1, v2 values from the hint
    // They are encoded as 2^128 * sign + abs(value)_u64
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
    // let Q0 = G1Point { x: hint.Q.x, y: Q0y };

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
        G1Point { x: B1.x, y: B16y },
        B8,
        G1Point { x: B3.x, y: B14y },
        B6,
        G1Point { x: B5.x, y: B12y },
        B4,
        G1Point { x: B7.x, y: B10y },
        B2,
        G1Point { x: B2.x, y: B15y },
        B7,
        G1Point { x: B4.x, y: B13y },
        B5,
        G1Point { x: B6.x, y: B11y },
        B3,
        G1Point { x: B8.x, y: B9y },
        B1,
    ]
        .span();

    // At this point, ~ 1643 steps.

    // println!("Bs: {:?}", Bs);
    // println!("Acc: {:?}", Acc);
    let mut _u1: u128 = upcast(_u1_abs);
    let mut _u2: u128 = upcast(_u2_abs);
    let mut _v1: u128 = upcast(_v1_abs);
    let mut _v2: u128 = upcast(_v2_abs);

    // let (mut selectors, u1lsb, u2lsb, v1lsb, v2lsb) = selectors::build_selectors_inlined(
    //     _u1, _u2, _v1, _v2,
    // );

    // Process 8 bits per iteration
    // while let Some(selector_y) = selectors.multi_pop_back::<8>() {
    //     let [
    //         selector_y7,
    //         selector_y6,
    //         selector_y5,
    //         selector_y4,
    //         selector_y3,
    //         selector_y2,
    //         selector_y1,
    //         selector_y0,
    //     ] =
    //         (*selector_y)
    //         .unbox();
    //     let Bi = *Bs[selector_y0];
    //     let Bi1 = *Bs[selector_y1];
    //     let Bi2 = *Bs[selector_y2];
    //     let Bi3 = *Bs[selector_y3];
    //     let Bi4 = *Bs[selector_y4];
    //     let Bi5 = *Bs[selector_y5];
    //     let Bi6 = *Bs[selector_y6];
    //     let Bi7 = *Bs[selector_y7];

    //     Acc = double_and_add_8(Acc, Bi, Bi1, Bi2, Bi3, Bi4, Bi5, Bi6, Bi7, modulus);
    // }

    let mut u1: BoundedInt<0, { POW128 - 1 }> = upcast(_u1);
    let mut u2: BoundedInt<0, { POW128 - 1 }> = upcast(_u2);
    let mut v1: BoundedInt<0, { POW128 - 1 }> = upcast(_v1);
    let mut v2: BoundedInt<0, { POW128 - 1 }> = upcast(_v2);

    // Initial division and remainder to get LSBs
    let (qu1, u1lsb) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2, u2lsb) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1, v1lsb) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2, v2lsb) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1);
    u2 = upcast(qu2);
    v1 = upcast(qv1);
    v2 = upcast(qv2);

    let (u1, u2, v1, v2, selector_0) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q71 = *Bs[upcast(selector_0)];
    let (u1, u2, v1, v2, selector_1) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q70 = *Bs[upcast(selector_1)];
    let (u1, u2, v1, v2, selector_2) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q69 = *Bs[upcast(selector_2)];
    let (u1, u2, v1, v2, selector_3) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q68 = *Bs[upcast(selector_3)];
    let (u1, u2, v1, v2, selector_4) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q67 = *Bs[upcast(selector_4)];
    let (u1, u2, v1, v2, selector_5) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q66 = *Bs[upcast(selector_5)];
    let (u1, u2, v1, v2, selector_6) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q65 = *Bs[upcast(selector_6)];
    let (u1, u2, v1, v2, selector_7) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q64 = *Bs[upcast(selector_7)];
    let (u1, u2, v1, v2, selector_8) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q63 = *Bs[upcast(selector_8)];
    let (u1, u2, v1, v2, selector_9) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q62 = *Bs[upcast(selector_9)];
    let (u1, u2, v1, v2, selector_10) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q61 = *Bs[upcast(selector_10)];
    let (u1, u2, v1, v2, selector_11) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q60 = *Bs[upcast(selector_11)];
    let (u1, u2, v1, v2, selector_12) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q59 = *Bs[upcast(selector_12)];
    let (u1, u2, v1, v2, selector_13) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q58 = *Bs[upcast(selector_13)];
    let (u1, u2, v1, v2, selector_14) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q57 = *Bs[upcast(selector_14)];
    let (u1, u2, v1, v2, selector_15) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q56 = *Bs[upcast(selector_15)];
    let (u1, u2, v1, v2, selector_16) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q55 = *Bs[upcast(selector_16)];
    let (u1, u2, v1, v2, selector_17) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q54 = *Bs[upcast(selector_17)];
    let (u1, u2, v1, v2, selector_18) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q53 = *Bs[upcast(selector_18)];
    let (u1, u2, v1, v2, selector_19) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q52 = *Bs[upcast(selector_19)];
    let (u1, u2, v1, v2, selector_20) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q51 = *Bs[upcast(selector_20)];
    let (u1, u2, v1, v2, selector_21) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q50 = *Bs[upcast(selector_21)];
    let (u1, u2, v1, v2, selector_22) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q49 = *Bs[upcast(selector_22)];
    let (u1, u2, v1, v2, selector_23) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q48 = *Bs[upcast(selector_23)];
    let (u1, u2, v1, v2, selector_24) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q47 = *Bs[upcast(selector_24)];
    let (u1, u2, v1, v2, selector_25) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q46 = *Bs[upcast(selector_25)];
    let (u1, u2, v1, v2, selector_26) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q45 = *Bs[upcast(selector_26)];
    let (u1, u2, v1, v2, selector_27) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q44 = *Bs[upcast(selector_27)];
    let (u1, u2, v1, v2, selector_28) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q43 = *Bs[upcast(selector_28)];
    let (u1, u2, v1, v2, selector_29) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q42 = *Bs[upcast(selector_29)];
    let (u1, u2, v1, v2, selector_30) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q41 = *Bs[upcast(selector_30)];
    let (u1, u2, v1, v2, selector_31) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q40 = *Bs[upcast(selector_31)];
    let (u1, u2, v1, v2, selector_32) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q39 = *Bs[upcast(selector_32)];
    let (u1, u2, v1, v2, selector_33) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q38 = *Bs[upcast(selector_33)];
    let (u1, u2, v1, v2, selector_34) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q37 = *Bs[upcast(selector_34)];
    let (u1, u2, v1, v2, selector_35) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q36 = *Bs[upcast(selector_35)];
    let (u1, u2, v1, v2, selector_36) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q35 = *Bs[upcast(selector_36)];
    let (u1, u2, v1, v2, selector_37) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q34 = *Bs[upcast(selector_37)];
    let (u1, u2, v1, v2, selector_38) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q33 = *Bs[upcast(selector_38)];
    let (u1, u2, v1, v2, selector_39) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q32 = *Bs[upcast(selector_39)];
    let (u1, u2, v1, v2, selector_40) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q31 = *Bs[upcast(selector_40)];
    let (u1, u2, v1, v2, selector_41) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q30 = *Bs[upcast(selector_41)];
    let (u1, u2, v1, v2, selector_42) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q29 = *Bs[upcast(selector_42)];
    let (u1, u2, v1, v2, selector_43) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q28 = *Bs[upcast(selector_43)];
    let (u1, u2, v1, v2, selector_44) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q27 = *Bs[upcast(selector_44)];
    let (u1, u2, v1, v2, selector_45) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q26 = *Bs[upcast(selector_45)];
    let (u1, u2, v1, v2, selector_46) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q25 = *Bs[upcast(selector_46)];
    let (u1, u2, v1, v2, selector_47) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q24 = *Bs[upcast(selector_47)];
    let (u1, u2, v1, v2, selector_48) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q23 = *Bs[upcast(selector_48)];
    let (u1, u2, v1, v2, selector_49) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q22 = *Bs[upcast(selector_49)];
    let (u1, u2, v1, v2, selector_50) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q21 = *Bs[upcast(selector_50)];
    let (u1, u2, v1, v2, selector_51) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q20 = *Bs[upcast(selector_51)];
    let (u1, u2, v1, v2, selector_52) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q19 = *Bs[upcast(selector_52)];
    let (u1, u2, v1, v2, selector_53) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q18 = *Bs[upcast(selector_53)];
    let (u1, u2, v1, v2, selector_54) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q17 = *Bs[upcast(selector_54)];
    let (u1, u2, v1, v2, selector_55) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q16 = *Bs[upcast(selector_55)];
    let (u1, u2, v1, v2, selector_56) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q15 = *Bs[upcast(selector_56)];
    let (u1, u2, v1, v2, selector_57) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q14 = *Bs[upcast(selector_57)];
    let (u1, u2, v1, v2, selector_58) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q13 = *Bs[upcast(selector_58)];
    let (u1, u2, v1, v2, selector_59) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q12 = *Bs[upcast(selector_59)];
    let (u1, u2, v1, v2, selector_60) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q11 = *Bs[upcast(selector_60)];
    let (u1, u2, v1, v2, selector_61) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q10 = *Bs[upcast(selector_61)];
    let (u1, u2, v1, v2, selector_62) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q9 = *Bs[upcast(selector_62)];
    let (u1, u2, v1, v2, selector_63) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q8 = *Bs[upcast(selector_63)];
    let (u1, u2, v1, v2, selector_64) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q7 = *Bs[upcast(selector_64)];
    let (u1, u2, v1, v2, selector_65) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q6 = *Bs[upcast(selector_65)];
    let (u1, u2, v1, v2, selector_66) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q5 = *Bs[upcast(selector_66)];
    let (u1, u2, v1, v2, selector_67) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q4 = *Bs[upcast(selector_67)];
    let (u1, u2, v1, v2, selector_68) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q3 = *Bs[upcast(selector_68)];
    let (u1, u2, v1, v2, selector_69) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q2 = *Bs[upcast(selector_69)];
    let (u1, u2, v1, v2, selector_70) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q1 = *Bs[upcast(selector_70)];
    let (_, _, _, _, selector_71) = selectors::_extract_and_calculate_selector_bit_inlined(
        u1, u2, v1, v2,
    );
    let Q0 = *Bs[upcast(selector_71)];

    let (Acc) = ec::run_DOUBLE_AND_ADD_72_circuit(
        Acc,
        Q0,
        Q1,
        Q2,
        Q3,
        Q4,
        Q5,
        Q6,
        Q7,
        Q8,
        Q9,
        Q10,
        Q11,
        Q12,
        Q13,
        Q14,
        Q15,
        Q16,
        Q17,
        Q18,
        Q19,
        Q20,
        Q21,
        Q22,
        Q23,
        Q24,
        Q25,
        Q26,
        Q27,
        Q28,
        Q29,
        Q30,
        Q31,
        Q32,
        Q33,
        Q34,
        Q35,
        Q36,
        Q37,
        Q38,
        Q39,
        Q40,
        Q41,
        Q42,
        Q43,
        Q44,
        Q45,
        Q46,
        Q47,
        Q48,
        Q49,
        Q50,
        Q51,
        Q52,
        Q53,
        Q54,
        Q55,
        Q56,
        Q57,
        Q58,
        Q59,
        Q60,
        Q61,
        Q62,
        Q63,
        Q64,
        Q65,
        Q66,
        Q67,
        Q68,
        Q69,
        Q70,
        Q71,
        modulus,
    );

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


// doubleAndAdd computes 2p+q as (p+q)+p. It follows [ELM03] (Section 3.1)
// Saves the computation of the y coordinate of p+q as it is used only in the computation of λ2,
// which can be computed as
//
//λ2 = -λ1-2*p.y/(x2-p.x)
//
// instead.
//
// ⚠️  p must be different than q and -q, and both nonzero.
//
// [ELM03]: https://arxiv.org/pdf/math/0208038.pdf
// func (c *Curve[B, S]) doubleAndAdd(p, q *AffinePoint[B]) *AffinePoint[B] {
#[inline(always)]
pub fn double_and_add(p: G1Point, q: G1Point, modulus: CircuitModulus) -> G1Point {
    let px = CircuitElement::<CircuitInput<0>> {};
    let py = CircuitElement::<CircuitInput<1>> {};
    let qx = CircuitElement::<CircuitInput<2>> {};
    let qy = CircuitElement::<CircuitInput<3>> {};

    // Compute λ1 = (q.y-p.y)/(q.x-p.x)
    let num_lambda1 = circuit_sub(qy, py);
    let den_lambda1 = circuit_sub(qx, px);
    let lambda1 = circuit_mul(num_lambda1, circuit_inverse(den_lambda1));

    // Compute x2 = λ1²-p.x-q.x
    let x2 = circuit_mul(lambda1, lambda1);
    let x2 = circuit_sub(x2, px);
    let x2 = circuit_sub(x2, qx);

    // omit y2 computation
    // compute -λ2 = λ1+2*p.y/(x2-p.x)
    let den = circuit_sub(x2, px);
    let num = circuit_add(py, py);

    let lambda2 = circuit_add(lambda1, circuit_mul(num, circuit_inverse(den)));

    // compute x3 = (-λ2)²-p.x-x2
    let x3 = circuit_mul(lambda2, lambda2);
    let x3 = circuit_sub(x3, px);
    let x3 = circuit_sub(x3, x2);

    // compute y3 = -λ2*(x3 - p.x)-p.y
    let y3 = circuit_mul(lambda2, circuit_sub(x3, px));
    let y3 = circuit_sub(y3, py);

    let outputs = (x3, y3)
        .new_inputs()
        .next_2(p.x)
        .next_2(p.y)
        .next_2(q.x)
        .next_2(q.y)
        .done_2()
        .eval(modulus)
        .expect('double and add failed');
    let x3 = outputs.get_output(x3);
    let y3 = outputs.get_output(y3);
    return G1Point { x: x3, y: y3 };
}