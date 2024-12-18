use core::result::ResultTrait;
use core::array::ArrayTrait;
use core::circuit::{
    AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub, circuit_mul,
    circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384, CircuitOutputsTrait, CircuitModulus,
    AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData, CircuitInputAccumulator,
};
use garaga::definitions::{
    get_a, get_b, get_modulus, get_g, get_min_one, get_b2, get_n, G1Point, G2Point,
    BLS_X_SEED_SQ_EPNS, BLS_X_SEED_SQ, G1PointZero, THIRD_ROOT_OF_UNITY_BLS12_381_G1, u384Serde,
};
use core::option::Option;
use core::panic_with_felt252;
use core::poseidon::hades_permutation;
use garaga::circuits::ec;
use garaga::utils::hashing;
use garaga::utils::neg_3;
use garaga::basic_field_ops::{add_mod_p, sub_mod_p, neg_mod_p, mul_mod_p, batch_3_mod_p};
use garaga::utils::{u384_assert_zero, u384_assert_eq};

#[generate_trait]
impl G1PointImpl of G1PointTrait {
    fn assert_on_curve(self: @G1Point, curve_index: usize) {
        let (check) = ec::run_IS_ON_CURVE_G1_circuit(
            *self, get_a(curve_index), get_b(curve_index), curve_index,
        );
        u384_assert_zero(check);
    }
    fn negate(self: @G1Point, curve_index: usize) -> G1Point {
        let modulus = get_modulus(curve_index);
        G1Point { x: *self.x, y: neg_mod_p(*self.y, modulus) }
    }
    fn assert_in_subgroup(
        self: @G1Point,
        curve_index: usize,
        msm_hint: Option<MSMHintSmallScalar>,
        derive_point_from_x_hint: Option<DerivePointFromXHint>,
    ) {
        match curve_index {
            0 => { self.assert_on_curve(curve_index) }, // BN254 (cofactor 1)
            1 => {
                // https://github.com/Consensys/gnark-crypto/blob/ff4c0ddbe1ef37d1c1c6bec8c36fc43a84c86be5/ecc/bls12-381/g1.go#L492
                let modulus = get_modulus(curve_index);
                let x_sq_phi_P = scalar_mul_g1_fixed_small_scalar(
                    G1Point {
                        x: mul_mod_p(THIRD_ROOT_OF_UNITY_BLS12_381_G1, *self.x, modulus),
                        y: *self.y,
                    },
                    BLS_X_SEED_SQ_EPNS,
                    BLS_X_SEED_SQ,
                    msm_hint.unwrap(),
                    derive_point_from_x_hint.unwrap(),
                    curve_index,
                );
                if !ec_safe_add(*self, x_sq_phi_P, curve_index).is_infinity() {
                    panic_with_felt252('g1 pt not in subgroup');
                }
            }, // BLS12-381
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
    let same_x = sub_mod_p(p.x, q.x, modulus) == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

    if same_x {
        let opposite_y = sub_mod_p(
            p.y, neg_mod_p(q.y, modulus), modulus,
        ) == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
        if opposite_y {
            return G1PointZero::zero();
        } else {
            let (res) = ec::run_DOUBLE_EC_POINT_circuit(p, get_a(curve_index), curve_index);
            return res;
        }
    } else {
        let (res) = ec::run_ADD_EC_POINT_circuit(p, q, curve_index);
        return res;
    }
}

#[derive(Drop)]
pub struct DerivePointFromXOutput {
    pub rhs: u384,
    pub g_rhs: u384,
    pub should_be_rhs_or_g_rhs: u384,
}

#[inline(always)]
fn get_DERIVE_POINT_FROM_X_circuit(
    x: u384, sqrt_rhs_or_g_rhs: u384, curve_index: usize,
) -> DerivePointFromXOutput {
    // INPUT stack
    let in0 = CircuitElement::<CircuitInput<0>> {}; // x - "random" x coordinate
    let in1 = CircuitElement::<CircuitInput<1>> {}; // a - a in Weierstrass equation
    let in2 = CircuitElement::<CircuitInput<2>> {}; // b - b in Weierstrass equation
    let in3 = CircuitElement::<CircuitInput<3>> {}; // g - Fp* Generator

    // WITNESS stack
    let in4 = CircuitElement::<CircuitInput<4>> {}; // sqrt(rhs) or sqrt(g*rhs)
    let t0 = circuit_mul(in0, in0); // x^2
    let t1 = circuit_mul(in0, t0); // x^3
    let t2 = circuit_mul(in1, in0); // a*x
    let t3 = circuit_add(t2, in2); // a*x + b
    let t4 = circuit_add(t1, t3); // x^3 + (a*x + b) = rhs
    let t5 = circuit_mul(in3, t4); // g * (x^3 + (a*x + b)) = g*rhs
    let t6 = circuit_mul(in4, in4); // should be rhs if sqrt(rhs) or g*rhs if sqrt(g*rhs) exists

    let modulus = get_modulus(curve_index);

    let mut circuit_inputs = (t4, t5, t6).new_inputs();

    circuit_inputs = circuit_inputs.next(x);
    circuit_inputs = circuit_inputs.next(get_a(curve_index));
    circuit_inputs = circuit_inputs.next(get_b(curve_index));
    circuit_inputs = circuit_inputs.next(get_g(curve_index));
    circuit_inputs = circuit_inputs.next(sqrt_rhs_or_g_rhs);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") },
    };
    let rhs = outputs.get_output(t4); // rhs
    let g_rhs = outputs.get_output(t5); // g*rhs
    let should_be_rhs_or_grhs = outputs
        .get_output(t6); // should be rhs if sqrt(rhs) or g*rhs if sqrt(g*rhs) exists

    return DerivePointFromXOutput {
        rhs: rhs, g_rhs: g_rhs, should_be_rhs_or_g_rhs: should_be_rhs_or_grhs,
    };
}

// Derives a random elliptic curve (EC) point on a given curve from a (random) x coordinate.
//
// This function attempts to find a valid y-coordinate from a given x-coordinate on an elliptic
// curve defined by the equation y^2 = x^3 + ax + b.
// Parameters:
// - x: felt252 - The x-coordinate for which we want to derive the corresponding y-coordinate.
// - y_last_attempt: u384 - The valid y-coordinate of the last attempt.
// - g_rhs_sqrt: Array<u384> - An array of square roots of g*rhs, where g is a generator
// in Fp.
// - curve_index: usize - The index of the elliptic curve parameters to use.
//
// Returns:
// - G1Point - A point on the elliptic curve with the given x-coordinate and a valid y-coordinate.
//
// The inner principle of this function is that, if Fp is a prime field, z any element of Fp*,
// and g a generator of Fp*, then:
// If z has a square root in Fp, then g*z does not have a square root in Fp*.
// If z does not have a square root in Fp, then g*z has a square root in Fp*.
// Note: there is exactly (p-1)//2 square roots in Fp*.
fn derive_ec_point_from_X(
    mut x: felt252, y_last_attempt: u384, mut g_rhs_sqrt: Span<u384>, curve_index: usize,
) -> G1Point {
    let mut attempt: felt252 = 0;
    while let Option::Some(root) = g_rhs_sqrt.pop_front() {
        let x_u384: u384 = x.into();
        let res: DerivePointFromXOutput = get_DERIVE_POINT_FROM_X_circuit(
            x_u384, *root, curve_index,
        );
        assert!(
            res.should_be_rhs_or_g_rhs == res.g_rhs, "grhs!=(sqrt(g*rhs))^2 in attempt {attempt}",
        );

        let (new_x, _, _) = hades_permutation(x, attempt.into(), 2);
        x = new_x;
        attempt += 1;
    };

    let x_u384: u384 = x.into();
    let res: DerivePointFromXOutput = get_DERIVE_POINT_FROM_X_circuit(
        x_u384, y_last_attempt, curve_index,
    );
    assert!(res.should_be_rhs_or_g_rhs == res.rhs, "invalid y coordinate");
    return G1Point { x: x_u384, y: y_last_attempt };
}

// A function field element of the form :
// F(x,y) = a(x) + y b(x)
// Where a, b are rational functions of x.
// The rational functions are represented as polynomials in x with coefficients in F_p, starting
// from the constant term.
// No information about the degrees of the polynomials is stored here as they are derived
// implicitely from the MSM size.
#[derive(Drop, Debug, Copy, PartialEq, Serde)]
pub struct FunctionFelt {
    pub a_num: Span<u384>,
    pub a_den: Span<u384>,
    pub b_num: Span<u384>,
    pub b_den: Span<u384>,
}
#[derive(Drop, Debug, Copy, PartialEq)]
pub struct FunctionFeltEvaluations {
    pub a_num: u384,
    pub a_den: u384,
    pub b_num: u384,
    pub b_den: u384,
}

#[derive(Drop, Debug, Copy, PartialEq)]
pub struct SlopeInterceptOutput {
    pub m_A0: u384,
    pub b_A0: u384,
    pub x_A2: u384,
    pub y_A2: u384,
    pub coeff0: u384,
    pub coeff2: u384,
}

#[generate_trait]
impl FunctionFeltImpl of FunctionFeltTrait {
    fn validate_degrees(self: @FunctionFelt, msm_size: usize) {
        assert!((*self.a_num).len() == msm_size + 1, "a_num wrong degree for given msm size");
        assert!((*self.a_den).len() == msm_size + 2, "a_den wrong degree for given msm size");
        assert!((*self.b_num).len() == msm_size + 2, "b_num wrong degree for given msm size");
        assert!((*self.b_den).len() == msm_size + 5, "b_den wrong degree for given msm size");
    }
    fn validate_degrees_batched(self: @FunctionFelt, msm_size: usize) {
        assert!((*self.a_num).len() == msm_size + 3, "a_num wrong degree for given msm size");
        assert!((*self.a_den).len() == msm_size + 4, "a_den wrong degree for given msm size");
        assert!((*self.b_num).len() == msm_size + 4, "b_num wrong degree for given msm size");
        assert!((*self.b_den).len() == msm_size + 7, "b_den wrong degree for given msm size");
    }
    fn update_hash_state(
        self: @FunctionFelt, s0: felt252, s1: felt252, s2: felt252,
    ) -> (felt252, felt252, felt252) {
        let (s0, s1, s2) = hashing::hash_u384_transcript(*self.a_num, s0, s1, s2);
        let (s0, s1, s2) = hashing::hash_u384_transcript(*self.a_den, s0, s1, s2);
        let (s0, s1, s2) = hashing::hash_u384_transcript(*self.b_num, s0, s1, s2);
        let (s0, s1, s2) = hashing::hash_u384_transcript(*self.b_den, s0, s1, s2);
        return (s0, s1, s2);
    }
}

#[derive(Drop, Debug, PartialEq, Serde, Copy)]
pub struct MSMHint {
    pub Q_low: G1Point,
    pub Q_high: G1Point,
    pub Q_high_shifted: G1Point,
    pub RLCSumDlogDiv: FunctionFelt,
}

#[derive(Drop, Debug, PartialEq, Serde)]
pub struct MSMHintSmallScalar {
    pub Q: G1Point,
    pub SumDlogDiv: FunctionFelt,
}

#[derive(Drop, Debug, PartialEq, Serde)]
struct MSMHintBatched {
    Q_low: G1Point,
    Q_high: G1Point,
    Q_high_shifted: G1Point,
    SumDlogDivBatched: FunctionFelt,
}

#[derive(Drop, Debug, PartialEq, Serde, Copy)]
pub struct DerivePointFromXHint {
    pub y_last_attempt: u384,
    pub g_rhs_sqrt: Span<u384>,
}

pub fn scalar_mul_g1_fixed_small_scalar(
    point: G1Point,
    scalar_epns: (felt252, felt252, felt252, felt252),
    scalar: u128,
    hint: MSMHintSmallScalar,
    derive_point_from_x_hint: DerivePointFromXHint,
    curve_index: usize,
) -> G1Point {
    // Check result points are either on curve or the point at infinity
    if !hint.Q.is_infinity() {
        hint.Q.assert_on_curve(curve_index);
    }

    // Validate the degrees of the functions field elements given the msm size
    hint.SumDlogDiv.validate_degrees(1);

    // Hash everything to obtain a x coordinate.

    let (s0, s1, s2): (felt252, felt252, felt252) = hades_permutation(
        'MSM_G1_U128', 0, 1,
    ); // Init Sponge state
    let (s0, s1, s2) = hades_permutation(
        s0 + curve_index.into(), s1 + 1.into(), s2,
    ); // Include curve_index and msm size
    // Check input points are on curve and hash them at the same time.

    point.assert_on_curve(curve_index);

    let (s0, s1, s2) = point.update_hash_state(s0, s1, s2);
    // Hash result point
    let (s0, s1, s2) = hint.Q.update_hash_state(s0, s1, s2);
    // Hash scalar.
    let (s0, s1, s2) = core::poseidon::hades_permutation(s0 + scalar.into(), s1, s2);

    let (s0, _, _) = hint.SumDlogDiv.update_hash_state(s0, s1, s2);

    let random_point: G1Point = derive_ec_point_from_X(
        s0,
        derive_point_from_x_hint.y_last_attempt,
        derive_point_from_x_hint.g_rhs_sqrt,
        curve_index,
    );

    // Get slope, intercept and other constant from random point
    let (mb): (SlopeInterceptOutput,) = ec::run_SLOPE_INTERCEPT_SAME_POINT_circuit(
        random_point, get_a(curve_index), curve_index,
    );
    // Verify Q = scalar * P

    let (lhs) = ec::run_EVAL_FN_CHALLENGE_DUPL_1P_circuit(
        A0: random_point,
        A2: G1Point { x: mb.x_A2, y: mb.y_A2 },
        coeff0: mb.coeff0,
        coeff2: mb.coeff2,
        SumDlogDiv: hint.SumDlogDiv,
        curve_index: curve_index,
    );
    let rhs = compute_rhs_ecip(
        points: array![point].span(),
        m_A0: mb.m_A0,
        b_A0: mb.b_A0,
        x_A0: random_point.x,
        epns: array![scalar_epns],
        Q_result: hint.Q,
        curve_index: curve_index,
    );

    u384_assert_eq(lhs, rhs);
    return hint.Q;
}

// Verifies the mutli scalar multiplication of a set of points on a given curve is equal to
// hint.Q_low + 2**128 * hint.Q_high.
// Uses https://eprint.iacr.org/2022/596.pdf eq 3 and samples a random EC point from the inputs and
// the hint.
fn msm_g1(
    scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
    hint: MSMHint,
    derive_point_from_x_hint: DerivePointFromXHint,
    points: Span<G1Point>,
    scalars: Span<u256>,
    curve_index: usize,
) -> G1Point {
    let n = scalars.len();
    assert!(n == points.len(), "scalars and points length mismatch");
    if n == 0 {
        panic!("Msm size must be >= 1");
    }

    // Check result points are either on curve, or the point at infinity
    if !hint.Q_low.is_infinity() {
        hint.Q_low.assert_on_curve(curve_index);
    }

    if !hint.Q_high.is_infinity() {
        hint.Q_high.assert_on_curve(curve_index);
    }

    if !hint.Q_high_shifted.is_infinity() {
        hint.Q_high_shifted.assert_on_curve(curve_index);
    }

    // Validate the degrees of the functions field elements given the msm size
    hint.RLCSumDlogDiv.validate_degrees_batched(n);

    // Hash everything to obtain a x coordinate.
    let (s0, s1, s2): (felt252, felt252, felt252) = hades_permutation(
        'MSM_G1', 0, 1,
    ); // Init Sponge state
    let (s0, s1, s2) = hades_permutation(
        s0 + curve_index.into(), s1 + n.into(), s2,
    ); // Include curve_index and msm size

    let mut s0 = s0;
    let mut s1 = s1;
    let mut s2 = s2;

    // Check input points are on curve and hash them at the same time.
    for point in points {
        if !point.is_infinity() {
            point.assert_on_curve(curve_index);
        }
        let (_s0, _s1, _s2) = point.update_hash_state(s0, s1, s2);
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };
    // Hash result points
    let (s0, s1, s2) = hint.Q_low.update_hash_state(s0, s1, s2);
    let (s0, s1, s2) = hint.Q_high.update_hash_state(s0, s1, s2);
    let (s0, s1, s2) = hint.Q_high_shifted.update_hash_state(s0, s1, s2);
    // Hash scalars and verify they are below the curve order
    let curve_order = get_n(curve_index);
    let mut s0 = s0;
    let mut s1 = s1;
    let mut s2 = s2;
    for scalar in scalars {
        assert!(*scalar <= curve_order, "One of the scalar is larger than the curve order");
        let (_s0, _s1, _s2) = core::poseidon::hades_permutation(
            s0 + (*scalar.low).into(), s1 + (*scalar.high).into(), s2,
        );
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };

    let base_rlc_coeff = s1;

    let (s0, _, _) = hint.RLCSumDlogDiv.update_hash_state(s0, s1, s2);

    let random_point: G1Point = derive_ec_point_from_X(
        s0,
        derive_point_from_x_hint.y_last_attempt,
        derive_point_from_x_hint.g_rhs_sqrt,
        curve_index,
    );

    // Get slope, intercept and other constant from random point
    let (mb): (SlopeInterceptOutput,) = ec::run_SLOPE_INTERCEPT_SAME_POINT_circuit(
        random_point, get_a(curve_index), curve_index,
    );

    // Get positive and negative multiplicities of low and high part of scalars
    let (epns_low, epns_high) = neg_3::u256_array_to_low_high_epns(
        scalars, scalars_digits_decompositions,
    );

    // Hardcoded epns for 2**128
    let epns_shifted: Array<(felt252, felt252, felt252, felt252)> = array![
        (5279154705627724249993186093248666011, 345561521626566187713367793525016877467, -1, -1),
    ];

    let rhs_low = compute_rhs_ecip(
        points, mb.m_A0, mb.b_A0, random_point.x, epns_low, hint.Q_low, curve_index,
    );
    let rhs_high = compute_rhs_ecip(
        points, mb.m_A0, mb.b_A0, random_point.x, epns_high, hint.Q_high, curve_index,
    );
    let rhs_high_shifted = compute_rhs_ecip(
        array![hint.Q_high].span(),
        mb.m_A0,
        mb.b_A0,
        random_point.x,
        epns_shifted,
        hint.Q_high_shifted,
        curve_index,
    );

    let modulus_curve = get_modulus(curve_index);

    let zk_ecip_batched_rhs = batch_3_mod_p(
        rhs_low, rhs_high, rhs_high_shifted, base_rlc_coeff.into(), modulus_curve,
    );

    let batched_lhs = compute_lhs_ecip(
        hint.RLCSumDlogDiv,
        random_point,
        G1Point { x: mb.x_A2, y: mb.y_A2 },
        mb.coeff0,
        mb.coeff2,
        n,
        curve_index,
    );

    u384_assert_eq(batched_lhs, zk_ecip_batched_rhs);

    // Return Q_low + Q_high_shifted = Q_low + 2^128 * Q_high = Σ(ki * Pi)
    return ec_safe_add(hint.Q_low, hint.Q_high_shifted, curve_index);
}

// Verifies the mutli scalar multiplication of a set of points on a given curve is equal to
// hint.Q
// Uses https://eprint.iacr.org/2022/596.pdf eq 3 and samples a random EC point from the inputs and
// the hint.
fn msm_g1_u128(
    scalars_digits_decompositions: Option<Span<Span<felt252>>>,
    hint: MSMHintSmallScalar,
    derive_point_from_x_hint: DerivePointFromXHint,
    points: Span<G1Point>,
    scalars: Span<u128>,
    curve_index: usize,
) -> G1Point {
    let n = scalars.len();
    assert!(n == points.len(), "scalars and points length mismatch");
    if (n != 1 && n != 2) {
        panic_with_felt252('Msm size must be [1,2]');
    }

    // Check result points are either on curve, or the point at infinity
    if !hint.Q.is_infinity() {
        hint.Q.assert_on_curve(curve_index);
    }

    // Validate the degrees of the functions field elements given the msm size
    hint.SumDlogDiv.validate_degrees(n);

    // Hash everything to obtain a x coordinate.

    let (s0, s1, s2): (felt252, felt252, felt252) = hades_permutation(
        'MSM_G1_U128', 0, 1,
    ); // Init Sponge state
    let (s0, s1, s2) = hades_permutation(
        s0 + curve_index.into(), s1 + n.into(), s2,
    ); // Include curve_index and msm size

    let mut s0 = s0;
    let mut s1 = s1;
    let mut s2 = s2;

    // Check input points are on curve and hash them at the same time.
    for point in points {
        if !point.is_infinity() {
            point.assert_on_curve(curve_index);
        }
        let (_s0, _s1, _s2) = point.update_hash_state(s0, s1, s2);
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };
    // Hash result points
    let (s0, s1, s2) = hint.Q.update_hash_state(s0, s1, s2);
    // Hash scalars. No need to check if scalar is below curve order since it is always at most 128
    // bits.
    let mut s0 = s0;
    let mut s1 = s1;
    let mut s2 = s2;
    for scalar in scalars {
        let (_s0, _s1, _s2) = core::poseidon::hades_permutation(s0 + (*scalar).into(), s1, s2);
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };

    let (s0, _, _) = hint.SumDlogDiv.update_hash_state(s0, s1, s2);

    let random_point: G1Point = derive_ec_point_from_X(
        s0,
        derive_point_from_x_hint.y_last_attempt,
        derive_point_from_x_hint.g_rhs_sqrt,
        curve_index,
    );

    // Get slope, intercept and other constant from random point
    let (mb): (SlopeInterceptOutput,) = ec::run_SLOPE_INTERCEPT_SAME_POINT_circuit(
        random_point, get_a(curve_index), curve_index,
    );

    // Get positive and negative multiplicities of low and high part of scalars
    let epns = neg_3::u128_array_to_epns(scalars, scalars_digits_decompositions);

    let case = n - 1;

    let A0 = random_point;
    let A2 = G1Point { x: mb.x_A2, y: mb.y_A2 };

    let (lhs) = match case {
        0 => (ec::run_EVAL_FN_CHALLENGE_DUPL_1P_circuit(
            A0, A2, mb.coeff0, mb.coeff2, hint.SumDlogDiv, curve_index,
        )),
        _ => ec::run_EVAL_FN_CHALLENGE_DUPL_2P_circuit(
            A0, A2, mb.coeff0, mb.coeff2, hint.SumDlogDiv, curve_index,
        ),
    };

    let rhs = compute_rhs_ecip(points, mb.m_A0, mb.b_A0, random_point.x, epns, hint.Q, curve_index);

    u384_assert_eq(lhs, rhs);

    return hint.Q;
}

// Verifies equation 3 in https://eprint.iacr.org/2022/596.pdf, using directly the weighted sum by
// (-3)**i of the logarithmic derivatives of the divisors functions.
fn zk_ecip_check(
    points: Span<G1Point>,
    epns: Array<(felt252, felt252, felt252, felt252)>,
    Q_result: G1Point,
    n: usize,
    mb: SlopeInterceptOutput,
    sum_dlog_div: FunctionFelt,
    random_point: G1Point,
    curve_index: usize,
) {
    let lhs = compute_lhs_ecip(
        sum_dlog_div: sum_dlog_div,
        A0: random_point,
        A2: G1Point { x: mb.x_A2, y: mb.y_A2 },
        coeff0: mb.coeff0,
        coeff2: mb.coeff2,
        msm_size: n,
        curve_index: curve_index,
    );
    let rhs = compute_rhs_ecip(
        points: points,
        m_A0: mb.m_A0,
        b_A0: mb.b_A0,
        x_A0: random_point.x,
        epns: epns,
        Q_result: Q_result,
        curve_index: curve_index,
    );
    u384_assert_eq(lhs, rhs);
}

#[inline(always)]
fn compute_lhs_ecip(
    sum_dlog_div: FunctionFelt,
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    msm_size: usize,
    curve_index: usize,
) -> u384 {
    let case = msm_size - 1;
    let (res) = match case {
        0 => (ec::run_EVAL_FN_CHALLENGE_DUPL_1P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        )),
        1 => ec::run_EVAL_FN_CHALLENGE_DUPL_2P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        ),
        2 => ec::run_EVAL_FN_CHALLENGE_DUPL_3P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        ),
        3 => ec::run_EVAL_FN_CHALLENGE_DUPL_4P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        ),
        4 => ec::run_EVAL_FN_CHALLENGE_DUPL_5P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        ),
        5 => ec::run_EVAL_FN_CHALLENGE_DUPL_6P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        ),
        6 => ec::run_EVAL_FN_CHALLENGE_DUPL_7P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        ),
        7 => ec::run_EVAL_FN_CHALLENGE_DUPL_8P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        ),
        8 => ec::run_EVAL_FN_CHALLENGE_DUPL_9P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        ),
        9 => ec::run_EVAL_FN_CHALLENGE_DUPL_10P_RLC_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index,
        ),
        _ => {
            let (_f_A0, _f_A2, _xA0_pow, _xA2_pow) = ec::run_INIT_FN_CHALLENGE_DUPL_11P_RLC_circuit(
                A0.x,
                A2.x,
                FunctionFelt {
                    a_num: sum_dlog_div.a_num.slice(0, 11 + 3),
                    a_den: sum_dlog_div.a_den.slice(0, 11 + 4),
                    b_num: sum_dlog_div.b_num.slice(0, 11 + 4),
                    b_den: sum_dlog_div.b_den.slice(0, 11 + 7),
                },
                curve_index,
            );
            let mut f_A0 = _f_A0;
            let mut f_A2 = _f_A2;
            let mut xA0_power = _xA0_pow;
            let mut xA2_power = _xA2_pow;
            let mut i = 11;
            while i != msm_size {
                let (_f_A0, _f_A2, _xA0_power, _xA2_power) =
                    ec::run_ACC_FUNCTION_CHALLENGE_DUPL_circuit(
                    f_A0,
                    f_A2,
                    A0.x,
                    A2.x,
                    xA0_power,
                    xA2_power,
                    *sum_dlog_div.a_num.at(i + 3),
                    *sum_dlog_div.a_den.at(i + 4),
                    *sum_dlog_div.b_num.at(i + 4),
                    *sum_dlog_div.b_den.at(i + 7),
                    curve_index,
                );
                f_A0 = _f_A0;
                f_A2 = _f_A2;
                xA0_power = _xA0_power;
                xA2_power = _xA2_power;
                i += 1;
            };

            ec::run_FINALIZE_FN_CHALLENGE_DUPL_circuit(
                f_A0, f_A2, A0.y, A2.y, coeff0, coeff2, curve_index,
            )
        },
    };
    return res;
}

fn compute_rhs_ecip(
    mut points: Span<G1Point>,
    m_A0: u384,
    b_A0: u384,
    x_A0: u384,
    mut epns: Array<(felt252, felt252, felt252, felt252)>,
    Q_result: G1Point,
    curve_index: usize,
) -> u384 {
    let mut basis_sum: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
    while let Option::Some(point) = points.pop_front() {
        let (ep, en, sp, sn) = epns.pop_front().unwrap();
        if ep - en != 0 {
            if !point.is_infinity() {
                let (_basis_sum) = ec::run_ACC_EVAL_POINT_CHALLENGE_SIGNED_circuit(
                    basis_sum,
                    m_A0,
                    b_A0,
                    x_A0,
                    *point,
                    ep.into(),
                    en.into(),
                    neg_3::sign_to_u384(sp, curve_index),
                    neg_3::sign_to_u384(sn, curve_index),
                    curve_index,
                );
                basis_sum = _basis_sum;
            }
        }
    };

    if Q_result.is_infinity() {
        return basis_sum;
    } else {
        let (rhs) = ec::run_RHS_FINALIZE_ACC_circuit(
            basis_sum, m_A0, b_A0, x_A0, Q_result, curve_index,
        );
        return rhs;
    }
}

#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{u384};

    use super::{G1Point, derive_ec_point_from_X};

    #[test]
    fn derive_ec_point_from_X_BN254_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 0x598cfc33bd761e9f469d5cf1,
            limb1: 0x70aa740aee8c937ce5a652ed,
            limb2: 0x15150916fc849dd8,
            limb3: 0x0,
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 0x70af0825548810253be61ac2,
                limb1: 0xf5002d67b9fa4c1219c100a4,
                limb2: 0x299198e451040cb,
                limb3: 0x0,
            },
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 0);
        assert!(
            result
                .x == u384 {
                    limb0: 0xca77736f57333ec7243f64dc,
                    limb1: 0xed10c0cb48d824856b668918,
                    limb2: 0x2763f5473b1953e,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_BLS12_381_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 0xda347f7c60a049c6d7bafb5b,
            limb1: 0xec21b937ef78861d979f0f50,
            limb2: 0x2ad1c01bba7ac189c78a1e86,
            limb3: 0x1026dca24cfcadfb336698e,
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 0xdbca26cdf0c7aa11a90c641f,
                limb1: 0x2e5c0209028615f11d0dc47e,
                limb2: 0xb1add5551aa6b9c56333f02f,
                limb3: 0x19972c66940a5bb4365da67,
            },
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 1);
        assert!(
            result
                .x == u384 {
                    limb0: 0xca77736f57333ec7243f64dc,
                    limb1: 0xed10c0cb48d824856b668918,
                    limb2: 0x2763f5473b1953e,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256K1_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 0x6fd1f24224585b2f83a36f19,
            limb1: 0x6edcd937a50597e42acc02c4,
            limb2: 0x634a08e35a355a32,
            limb3: 0x0,
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 0x5e1402d5a1794a2ba5113078,
                limb1: 0xcebc2596ba2db2a201abd409,
                limb2: 0x54a070a2d860e57f,
                limb3: 0x0,
            },
            u384 {
                limb0: 0xd619858e2ea7e31cb17c33cb,
                limb1: 0x4816924dd606b04c135bcfa3,
                limb2: 0x13dc60324901f16f,
                limb3: 0x0,
            },
            u384 {
                limb0: 0x6ae587737bb1f9839802fd91,
                limb1: 0x4fc0f718bb7b3ca34f2cccb3,
                limb2: 0x4071c850696772a1,
                limb3: 0x0,
            },
            u384 {
                limb0: 0xd81a6ef8f7ee11a079f304e8,
                limb1: 0xf765e8b9e097ca1bf0f3ea0e,
                limb2: 0x459195cbdf16786a,
                limb3: 0x0,
            },
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 2);
        assert!(
            result
                .x == u384 {
                    limb0: 0x8ab6a1b6714eb0afec427f11,
                    limb1: 0x774701c0acf48486afeb35d5,
                    limb2: 0x1a3e9f740bb8959,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256R1_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 0x40cbfb35489307de40764c95,
            limb1: 0x67ad6ff08b304dc35ef9a319,
            limb2: 0x5ff5aff356baa1da,
            limb3: 0x0,
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 0x145e66309035da0e73a4ed6,
                limb1: 0x696ff6786cf7a86549a1b150,
                limb2: 0x69e04ef11ab29ee8,
                limb3: 0x0,
            },
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 3);
        assert!(
            result
                .x == u384 {
                    limb0: 0xca77736f57333ec7243f64dc,
                    limb1: 0xed10c0cb48d824856b668918,
                    limb2: 0x2763f5473b1953e,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_ED25519_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 0xc329e0f3a716909d81ee695d,
            limb1: 0xac52065a46c058e2dd3da949,
            limb2: 0x81add1124b65c41,
            limb3: 0x0,
        };
        let grhs_roots: Array<u384> = array![];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 4);
        assert!(
            result
                .x == u384 {
                    limb0: 0x9558867f5ba91faf7a024204,
                    limb1: 0x37ebdcd9e87a1613e443df78,
                    limb2: 0x23a771181332876,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_BN254_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 0x185ddfe68eca3df51ff4c645,
            limb1: 0x17b6ccbb6f4843c170dc2009,
            limb2: 0x171370980ed3ba91,
            limb3: 0x0,
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 0xb6dca81bd6f041ae382202ae,
                limb1: 0xfebe33fdfdc01232d27737ce,
                limb2: 0x1031c8f96f566cea,
                limb3: 0x0,
            },
            u384 {
                limb0: 0xcc497c90b1d5d736c46a619a,
                limb1: 0xf08b3fe8157a259bf06d1c18,
                limb2: 0x1329fd3ffe2dbe8e,
                limb3: 0x0,
            },
            u384 {
                limb0: 0xa46d4f66ca22531865b67bf5,
                limb1: 0xd5964d6b0c925503d596d887,
                limb2: 0xa95d8f1df105f18,
                limb3: 0x0,
            },
            u384 {
                limb0: 0x3b52382c9597a1fad8935560,
                limb1: 0x3fa8d8a8174fc08c702332ce,
                limb2: 0x23191b53d4b072b,
                limb3: 0x0,
            },
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 0);
        assert!(
            result
                .x == u384 {
                    limb0: 0x4ed478dca9953c97aedb70f7,
                    limb1: 0xd98adb6e70e8f1580604709,
                    limb2: 0x4bea6d08411cc00,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_BLS12_381_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 0x35d8a6fefdafaaaf5b29e897,
            limb1: 0x6f7727ee8543e37553eeb26f,
            limb2: 0x2f70791057cdbd90daf42308,
            limb3: 0x75b09d110be5483f36e068,
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 0x5cf036935c9f06c3e0a0aa7c,
                limb1: 0x79a5eb4e385146a0aa3c1de,
                limb2: 0x6e20141582b8406d26dda065,
                limb3: 0x3c3d605784954989e301c3c,
            },
            u384 {
                limb0: 0x77a98db8c9be953431659e97,
                limb1: 0x214a25baa29b08ffc8bec3db,
                limb2: 0xfe6a7b8656df401896f71787,
                limb3: 0xa9152bcd397888aa9388bd8,
            },
            u384 {
                limb0: 0x4551a54de8fb23786fd1f2a0,
                limb1: 0x2b19133889843628ea5fd520,
                limb2: 0xb893ee8526ef349b780c0c24,
                limb3: 0x50a551b0bd152405d128fc7,
            },
            u384 {
                limb0: 0xf4ecd002f01cd7ee33519fd5,
                limb1: 0xed3c61685851221c96d7592b,
                limb2: 0x9f42fc7c025009a0247daafb,
                limb3: 0x45d3eb549e2ff2d259ef50a,
            },
            u384 {
                limb0: 0xc71aa51c55a340c4b62ce4bb,
                limb1: 0xc29f377906d89036689603a4,
                limb2: 0x4dc8b1c21520b64e2101850,
                limb3: 0x6de8fe79d9b161443b37f30,
            },
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 1);
        assert!(
            result
                .x == u384 {
                    limb0: 0x836d4610c564d82c11088e19,
                    limb1: 0x4801f5832d47c11bd2378845,
                    limb2: 0x75e11f8d50c3760,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256K1_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 0xc6d067f5c5c6a580350c2471,
            limb1: 0x2ff4d91827cad9a2b11c1cff,
            limb2: 0x18917af46df8fc3f,
            limb3: 0x0,
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 0x22d9db5344ce97b7eb160092,
                limb1: 0x2747c16db787c85dcc773a44,
                limb2: 0x18a010b6b674e456,
                limb3: 0x0,
            },
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 2);
        assert!(
            result
                .x == u384 {
                    limb0: 0xbb4647393e0b7dd03ae7107f,
                    limb1: 0xcdc5afca778a37383350bcf8,
                    limb2: 0x3a81368ffad9e03,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256R1_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 0x6e67fe45dcddd89cb69ce7ee,
            limb1: 0x36156ccb6884f75af70900f1,
            limb2: 0x30b6330c77234ef8,
            limb3: 0x0,
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 0xea8397d53edccf2ceda23ff0,
                limb1: 0xa5a0c4098c25294b18a0f0f9,
                limb2: 0x11722147901e6d89,
                limb3: 0x0,
            },
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 3);
        assert!(
            result
                .x == u384 {
                    limb0: 0xbb4647393e0b7dd03ae7107f,
                    limb1: 0xcdc5afca778a37383350bcf8,
                    limb2: 0x3a81368ffad9e03,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_ED25519_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 0x33e9327c0c98794856bde22a,
            limb1: 0xdf89110f1e821a3112ce76bb,
            limb2: 0xacf925c82c4365f,
            limb3: 0x0,
        };
        let grhs_roots: Array<u384> = array![];
        let result = derive_ec_point_from_X(x, y, grhs_roots.span(), 4);
        assert!(
            result
                .x == u384 {
                    limb0: 0xfb97d43588561712e8e5216a,
                    limb1: 0x9a164106cf6a659eb4862b21,
                    limb2: 0x259f432e6f4590b,
                    limb3: 0x0,
                },
        );
        assert!(result.y == y);
    }
}
