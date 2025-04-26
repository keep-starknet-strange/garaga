use core::array::ArrayTrait;
use core::circuit::{
    AddInputResultTrait, AddMod, CircuitData, CircuitDefinition, CircuitElement, CircuitInput,
    CircuitInputAccumulator, CircuitInputs, CircuitModulus, CircuitOutputsTrait, EvalCircuitResult,
    EvalCircuitTrait, MulMod, circuit_add, circuit_inverse, circuit_mul, circuit_sub, u384, u96,
};
use core::internal::bounded_int;
use core::internal::bounded_int::{
    AddHelper, BoundedInt, DivRemHelper, MulHelper, UnitInt, downcast, upcast,
};
use core::option::Option;
use core::panic_with_felt252;
use core::poseidon::hades_permutation;
use core::result::ResultTrait;
use garaga::basic_field_ops::{
    add_mod_p, batch_3_mod_p, is_opposite_mod_p, mul_mod_p, neg_mod_p, sub_mod_p,
};
use garaga::circuits::ec;
use garaga::core::circuit::{AddInputResultTrait2, IntoCircuitInputValue, u288IntoCircuitInputValue};
use garaga::definitions::{
    BLS_X_SEED_SQ, BLS_X_SEED_SQ_EPNS, G1Point, G1PointZero, G2Point,
    THIRD_ROOT_OF_UNITY_BLS12_381_G1, deserialize_u288_array, deserialize_u384,
    deserialize_u384_array, get_G, get_a, get_b, get_b2, get_g, get_min_one, get_modulus, get_n,
    serialize_u288_array, serialize_u384, serialize_u384_array, u288, u384Serde,
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
    fn assert_in_subgroup<
        T, +HashFeltTranscriptTrait<T>, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>,
    >(
        self: @G1Point,
        curve_index: usize,
        msm_hint: Option<MSMHintSmallScalar<T>>,
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

pub fn _ec_safe_add(p: G1Point, q: G1Point, modulus: CircuitModulus) -> G1Point {
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
            let (res) = ec::run_DOUBLE_EC_POINT_circuit(
                p, u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }, modulus,
            );
            return res;
        }
    } else {
        let (res) = ec::run_ADD_EC_POINT_circuit(p, q, modulus);
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

    let outputs = circuit_inputs.done().eval(modulus).unwrap();

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
    }

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
#[derive(Drop, Debug, Copy, PartialEq)]
pub struct FunctionFelt<T> {
    pub a_num: Span<T>,
    pub a_den: Span<T>,
    pub b_num: Span<T>,
    pub b_den: Span<T>,
}


impl FunctionFeltSerdeu384 of Serde<FunctionFelt<u384>> {
    fn serialize(self: @FunctionFelt<u384>, ref output: Array<felt252>) {
        serialize_u384_array(*self.a_num.snapshot, ref output);
        serialize_u384_array(*self.a_den.snapshot, ref output);
        serialize_u384_array(*self.b_num.snapshot, ref output);
        serialize_u384_array(*self.b_den.snapshot, ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<FunctionFelt<u384>> {
        return Option::Some(
            FunctionFelt {
                a_num: deserialize_u384_array(ref serialized).span(),
                a_den: deserialize_u384_array(ref serialized).span(),
                b_num: deserialize_u384_array(ref serialized).span(),
                b_den: deserialize_u384_array(ref serialized).span(),
            },
        );
    }
}

impl FunctionFeltSerdeu288 of Serde<FunctionFelt<u288>> {
    fn serialize(self: @FunctionFelt<u288>, ref output: Array<felt252>) {
        serialize_u288_array(*self.a_num.snapshot, ref output);
        serialize_u288_array(*self.a_den.snapshot, ref output);
        serialize_u288_array(*self.b_num.snapshot, ref output);
        serialize_u288_array(*self.b_den.snapshot, ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<FunctionFelt<u288>> {
        return Option::Some(
            FunctionFelt {
                a_num: deserialize_u288_array(ref serialized).span(),
                a_den: deserialize_u288_array(ref serialized).span(),
                b_num: deserialize_u288_array(ref serialized).span(),
                b_den: deserialize_u288_array(ref serialized).span(),
            },
        );
    }
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
use garaga::utils::hashing::HashFeltTranscriptTrait;

#[generate_trait]
impl FunctionFeltImpl<T, +HashFeltTranscriptTrait<T>> of FunctionFeltTrait<T> {
    fn validate_degrees(self: @FunctionFelt<T>, msm_size: usize) {
        assert!((*self.a_num).len() == msm_size + 1, "a_num wrong degree for given msm size");
        assert!((*self.a_den).len() == msm_size + 2, "a_den wrong degree for given msm size");
        assert!((*self.b_num).len() == msm_size + 2, "b_num wrong degree for given msm size");
        assert!((*self.b_den).len() == msm_size + 5, "b_den wrong degree for given msm size");
    }
    fn validate_degrees_batched(self: @FunctionFelt<T>, msm_size: usize) {
        assert!((*self.a_num).len() == msm_size + 3, "a_num wrong degree for given msm size");
        assert!((*self.a_den).len() == msm_size + 4, "a_den wrong degree for given msm size");
        assert!((*self.b_num).len() == msm_size + 4, "b_num wrong degree for given msm size");
        assert!((*self.b_den).len() == msm_size + 7, "b_den wrong degree for given msm size");
    }
    fn update_hash_state(
        self: @FunctionFelt<T>, s0: felt252, s1: felt252, s2: felt252,
    ) -> (felt252, felt252, felt252) {
        let (s0, s1, s2) = HashFeltTranscriptTrait::hash_field_element_transcript(
            *self.a_num, s0, s1, s2,
        );
        let (s0, s1, s2) = HashFeltTranscriptTrait::hash_field_element_transcript(
            *self.a_den, s0, s1, s2,
        );
        let (s0, s1, s2) = HashFeltTranscriptTrait::hash_field_element_transcript(
            *self.b_num, s0, s1, s2,
        );
        let (s0, s1, s2) = HashFeltTranscriptTrait::hash_field_element_transcript(
            *self.b_den, s0, s1, s2,
        );
        return (s0, s1, s2);
    }
}

#[derive(Drop, Debug, PartialEq, Serde, Copy)]
pub struct MSMHint<T> {
    pub Q_low: G1Point,
    pub Q_high: G1Point,
    pub Q_high_shifted: G1Point,
    pub RLCSumDlogDiv: FunctionFelt<T>,
}

#[derive(Drop, Debug, PartialEq, Serde)]
pub struct MSMHintSmallScalar<T> {
    pub Q: G1Point,
    pub SumDlogDiv: FunctionFelt<T>,
}


#[derive(Drop, Debug, PartialEq, Copy)]
pub struct DerivePointFromXHint {
    pub y_last_attempt: u384,
    pub g_rhs_sqrt: Span<u384>,
}

impl DerivePointFromXHintSerde of Serde<DerivePointFromXHint> {
    fn serialize(self: @DerivePointFromXHint, ref output: Array<felt252>) {
        serialize_u384(self.y_last_attempt, ref output);
        serialize_u384_array(*self.g_rhs_sqrt.snapshot, ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<DerivePointFromXHint> {
        return Option::Some(
            DerivePointFromXHint {
                y_last_attempt: deserialize_u384(ref serialized),
                g_rhs_sqrt: deserialize_u384_array(ref serialized).span(),
            },
        );
    }
}

pub fn scalar_mul_g1_fixed_small_scalar<
    T, +HashFeltTranscriptTrait<T>, +Drop<T>, +IntoCircuitInputValue<T>, +Copy<T>,
>(
    point: G1Point,
    scalar_epns: (felt252, felt252, felt252, felt252),
    scalar: u128,
    hint: MSMHintSmallScalar<T>,
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
fn msm_g1<T, +HashFeltTranscriptTrait<T>, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
    hint: MSMHint<T>,
    derive_point_from_x_hint: DerivePointFromXHint,
    points: Span<G1Point>,
    scalars: Span<u256>,
    curve_index: usize,
) -> G1Point {
    let n = scalars.len();
    assert!(n == points.len(), "scalars and points length mismatch");
    if n == 0 {
        panic_with_felt252('Msm size must be >= 1');
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
    }
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
    }

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
fn msm_g1_u128<T, +HashFeltTranscriptTrait<T>, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    scalars_digits_decompositions: Option<Span<Span<felt252>>>,
    hint: MSMHintSmallScalar<T>,
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
    }
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
    }

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
fn zk_ecip_check<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    points: Span<G1Point>,
    epns: Array<(felt252, felt252, felt252, felt252)>,
    Q_result: G1Point,
    n: usize,
    mb: SlopeInterceptOutput,
    sum_dlog_div: FunctionFelt<T>,
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

#[inline]
fn compute_lhs_ecip<T, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    sum_dlog_div: FunctionFelt<T>,
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
            }

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
    }

    if Q_result.is_infinity() {
        return basis_sum;
    } else {
        let (rhs) = ec::run_RHS_FINALIZE_ACC_circuit(
            basis_sum, m_A0, b_A0, x_A0, Q_result, curve_index,
        );
        return rhs;
    }
}

// A version of compute_rhs_ecip that does not check if the points are infinity and expect them to
// be on curve.
// Do not use unless all points are known to be on curve.
fn _compute_rhs_ecip_no_infinity(
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

    if Q_result.is_infinity() {
        return basis_sum;
    } else {
        let (rhs) = ec::run_RHS_FINALIZE_ACC_circuit(
            basis_sum, m_A0, b_A0, x_A0, Q_result, curve_index,
        );
        return rhs;
    }
}

// A version of msm_g1 that works with 2 points only to reduce bytecode size.
fn msm_g1_2_points<T, +HashFeltTranscriptTrait<T>, +IntoCircuitInputValue<T>, +Drop<T>, +Copy<T>>(
    scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
    hint: MSMHint<T>,
    derive_point_from_x_hint: DerivePointFromXHint,
    points: Span<G1Point>,
    scalars: Span<u256>,
    curve_index: usize,
) -> G1Point {
    let n = scalars.len();
    assert!(n == points.len(), "scalars and points length mismatch");
    if n != 2 {
        panic_with_felt252('Msm size must be 2');
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
    }
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
    }

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

    let (batched_lhs) = ec::run_EVAL_FN_CHALLENGE_DUPL_2P_RLC_circuit(
        random_point,
        G1Point { x: mb.x_A2, y: mb.y_A2 },
        mb.coeff0,
        mb.coeff2,
        hint.RLCSumDlogDiv,
        curve_index,
    );

    u384_assert_eq(batched_lhs, zk_ecip_batched_rhs);

    // Return Q_low + Q_high_shifted = Q_low + 2^128 * Q_high = Σ(ki * Pi)
    return ec_safe_add(hint.Q_low, hint.Q_high_shifted, curve_index);
}


#[derive(Drop)]
struct ScalarMulFakeGLVHint {
    Q: G1Point,
    u1: felt252, // Encoded as 2^128 * sign + abs(u1)_u64
    u2: felt252, // Encoded as 2^128 * sign + abs(u2)_u64
    v1: felt252, // Encoded as 2^128 * sign + abs(v1)_u64
    v2: felt252 // Encoded as 2^128 * sign + abs(v2)_u64
}

pub use core::integer::{U128sFromFelt252Result, u128s_from_felt252};

fn _scalar_mul_glv_and_fake_glv(
    point: G1Point,
    scalar: u256,
    order_modulus: CircuitModulus,
    modulus: CircuitModulus,
    hint: ScalarMulFakeGLVHint,
    _lambda: u384,
    third_root_of_unity: u384,
    minus_one: u384,
    one_u384: u384,
    n_bits: usize,
    n_bits_G: G1Point,
    curve_index: usize,
) -> G1Point {
    if scalar == 0 || point.is_infinity() {
        return G1PointZero::zero();
    }
    if scalar == 1 {
        return point;
    }

    let scalar_u384: u384 = scalar.into();

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
        .next_2(scalar_u384)
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

    let (S0) = ec::run_ADD_EC_POINT_circuit(P0, Q0, modulus); // -P - Q
    // println!("S0: {:?}", S0);
    let S1 = G1Point { x: S0.x, y: neg_mod_p(S0.y, modulus) }; // P + Q
    // println!("S1: {:?}", S1);

    let (S2) = ec::run_ADD_EC_POINT_circuit(
        G1Point { x: point.x, y: P1y }, G1Point { x: hint.Q.x, y: Q0y }, modulus,
    ); // P - Q
    // println!("S2: {:?}", S2);

    // let S3 = G1Point { x: S2.x, y: neg_mod_p(S2.y, modulus) }; // -P + Q
    // println!("S3: {:?}", S3);

    // Table S ok.
    let phi_q_x = mul_mod_p(hint.Q.x, third_root_of_unity, modulus);
    let Phi_Q0 = G1Point { x: phi_q_x, y: Phi_Q0y };
    let phi_p_x = mul_mod_p(point.x, third_root_of_unity, modulus);
    let Phi_P0 = G1Point { x: phi_p_x, y: Phi_P0y };
    let (Phi_S0) = ec::run_ADD_EC_POINT_circuit(Phi_P0, Phi_Q0, modulus); // -Φ(P) - Φ(Q)
    let Phi_S1 = G1Point { x: Phi_S0.x, y: neg_mod_p(Phi_S0.y, modulus) }; // Φ(P) + Φ(Q)

    let (Phi_S2) = ec::run_ADD_EC_POINT_circuit(
        G1Point { x: phi_p_x, y: Phi_P1y }, G1Point { x: phi_q_x, y: Phi_Q0y }, modulus,
    ); // Φ(P) - Φ(Q)

    let Phi_S3 = G1Point { x: Phi_S2.x, y: neg_mod_p(Phi_S2.y, modulus) }; // -Φ(P) + Φ(Q)

    // we suppose that the first bits of the sub-scalars are 1 and set:
    // Acc = P + Q + Φ(P) + Φ(Q)
    let (Acc) = ec::run_ADD_EC_POINT_circuit(S1, Phi_S1, modulus); // P + Q + Φ(P) + Φ(Q)

    let B1 = Acc;
    // println!("B1: {:?}", B1);
    let (B2) = ec::run_ADD_EC_POINT_circuit(S1, Phi_S2, modulus); // P + Q + Φ(P) - Φ(Q)
    let (B3) = ec::run_ADD_EC_POINT_circuit(S1, Phi_S3, modulus); // P + Q - Φ(P) + Φ(Q)
    let (B4) = ec::run_ADD_EC_POINT_circuit(S1, Phi_S0, modulus); // P + Q - Φ(P) - Φ(Q)
    let (B5) = ec::run_ADD_EC_POINT_circuit(S2, Phi_S1, modulus); // P - Q + Φ(P) + Φ(Q)
    let (B6) = ec::run_ADD_EC_POINT_circuit(S2, Phi_S2, modulus); // P - Q + Φ(P) - Φ(Q)
    let (B7) = ec::run_ADD_EC_POINT_circuit(S2, Phi_S3, modulus); // P - Q - Φ(P) + Φ(Q)
    let (B8) = ec::run_ADD_EC_POINT_circuit(S2, Phi_S0, modulus); // P - Q - Φ(P) - Φ(Q)
    let B9 = G1Point { x: B8.x, y: neg_mod_p(B8.y, modulus) }; // -P + Q + Φ(P) + Φ(Q)
    let B10 = G1Point { x: B7.x, y: neg_mod_p(B7.y, modulus) }; // -P + Q + Φ(P) - Φ(Q)
    let B11 = G1Point { x: B6.x, y: neg_mod_p(B6.y, modulus) }; // -P + Q - Φ(P) + Φ(Q)
    let B12 = G1Point { x: B5.x, y: neg_mod_p(B5.y, modulus) }; // -P + Q - Φ(P) - Φ(Q)
    let B13 = G1Point { x: B4.x, y: neg_mod_p(B4.y, modulus) }; // -P - Q + Φ(P) + Φ(Q)
    let B14 = G1Point { x: B3.x, y: neg_mod_p(B3.y, modulus) }; // -P - Q + Φ(P) - Φ(Q)
    let B15 = G1Point { x: B2.x, y: neg_mod_p(B2.y, modulus) }; // -P - Q - Φ(P) + Φ(Q)
    let B16 = G1Point { x: B1.x, y: neg_mod_p(B1.y, modulus) }; // -P - Q - Φ(P) - Φ(Q)

    let Bs: Span<G1Point> = array![
        B16, B8, B14, B6, B12, B4, B10, B2, B15, B7, B13, B5, B11, B3, B9, B1,
    ]
        .span();

    // println!("Bs: {:?}", Bs);
    let (mut Acc) = ec::run_ADD_EC_POINT_circuit(Acc, get_G(curve_index), modulus);
    // println!("Acc: {:?}", Acc);
    let mut _u1: u128 = upcast(_u1_abs);
    let mut _u2: u128 = upcast(_u2_abs);
    let mut _v1: u128 = upcast(_v1_abs);
    let mut _v2: u128 = upcast(_v2_abs);

    let (mut selectors, u1lsb, u2lsb, v1lsb, v2lsb) = selectors::build_selectors_inlined(
        _u1, _u2, _v1, _v2,
    );

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
        let Bi = *Bs[selector_y0];
        let Bi1 = *Bs[selector_y1];
        let Bi2 = *Bs[selector_y2];
        let Bi3 = *Bs[selector_y3];
        let Bi4 = *Bs[selector_y4];
        let Bi5 = *Bs[selector_y5];
        let Bi6 = *Bs[selector_y6];
        let Bi7 = *Bs[selector_y7];

        Acc = double_and_add_8(Acc, Bi, Bi1, Bi2, Bi3, Bi4, Bi5, Bi6, Bi7, modulus);
    }

    // println!("Acc final: {:?}", Acc);
    let (Acc) = if u1lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(Acc, P0, modulus)
    } else {
        (Acc,)
    };
    let (Acc) = if u2lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(Acc, Phi_P0, modulus)
    } else {
        (Acc,)
    };

    let (Acc) = if v1lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(Acc, Q0, modulus)
    } else {
        (Acc,)
    };

    let (Acc) = if v2lsb == 0 {
        ec::run_ADD_EC_POINT_circuit(Acc, Phi_Q0, modulus)
    } else {
        (Acc,)
    };

    assert(Acc == n_bits_G, 'Wrong result');

    return hint.Q;
}

const TWO: felt252 = 2;
const TWO_NZ_TYPED: NonZero<UnitInt<TWO>> = 2;
const POW128_DIV_2: felt252 = 0x7fffffffffffffffffffffffffffffff; // ((2^128-1) // 2)
const POW128: felt252 = 0x100000000000000000000000000000000;

impl DivRemU128By2 of DivRemHelper<BoundedInt<0, { POW128 - 1 }>, UnitInt<TWO>> {
    type DivT = BoundedInt<0, { POW128_DIV_2 }>;
    type RemT = BoundedInt<0, { TWO - 1 }>;
}

#[inline(always)]
fn build_selectors(
    _u1: u128, _u2: u128, _v1: u128, _v2: u128, n_bits: usize,
) -> (Span<usize>, u128, u128, u128, u128) {
    let mut selectors: Array<usize> = array![];

    let mut u1: BoundedInt<0, { POW128 - 1 }> = upcast(_u1);
    let mut u2: BoundedInt<0, { POW128 - 1 }> = upcast(_u2);
    let mut v1: BoundedInt<0, { POW128 - 1 }> = upcast(_v1);
    let mut v2: BoundedInt<0, { POW128 - 1 }> = upcast(_v2);

    let (qu1, u1lsb) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
    let (qu2, u2lsb) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
    let (qv1, v1lsb) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
    let (qv2, v2lsb) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
    u1 = upcast(qu1);
    u2 = upcast(qu2);
    v1 = upcast(qv1);
    v2 = upcast(qv2);

    for _ in 0..n_bits - 1 {
        let (qu1, u1b) = bounded_int::div_rem(u1, TWO_NZ_TYPED);
        let (qu2, u2b) = bounded_int::div_rem(u2, TWO_NZ_TYPED);
        let (qv1, v1b) = bounded_int::div_rem(v1, TWO_NZ_TYPED);
        let (qv2, v2b) = bounded_int::div_rem(v2, TWO_NZ_TYPED);
        u1 = upcast(qu1);
        u2 = upcast(qu2);
        v1 = upcast(qv1);
        v2 = upcast(qv2);
        let selector_y: felt252 = u1b.into() + 2 * u2b.into() + 4 * v1b.into() + 8 * v2b.into();
        let selector_y: usize = selector_y.try_into().unwrap();
        selectors.append(selector_y);
    }
    return (selectors.span(), upcast(u1lsb), upcast(u2lsb), upcast(v1lsb), upcast(v2lsb));
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
#[cfg(test)]
mod tests {
    use core::circuit::u384;
    use core::traits::TryInto;
    use garaga::definitions::{
        get_curve_order_modulus, get_eigenvalue, get_min_one_order, get_modulus,
        get_nbits_and_nG_glv_fake_glv, get_third_root_of_unity,
    };
    use super::{
        G1Point, ScalarMulFakeGLVHint, _scalar_mul_glv_and_fake_glv, derive_ec_point_from_X,
    };

    #[test]
    fn test_scalar_mul_glv_and_fake_glv() {
        let curve_id = 2;
        let eigen = get_eigenvalue(curve_id);
        let third_root_of_unity = get_third_root_of_unity(curve_id);
        let modulus = get_modulus(curve_id);
        let order_modulus = get_curve_order_modulus(curve_id);
        let min_one = get_min_one_order(curve_id);
        let (nbits, nG) = get_nbits_and_nG_glv_fake_glv(curve_id);
        let scalar = 111793196543967404139194827996419963236210979610743141064269745943111491389390;
        let hint = ScalarMulFakeGLVHint {
            Q: G1Point {
                x: u384 {
                    limb0: 0x393dead57bc85a6e9bb44a70,
                    limb1: 0x64d4b065b3ede27cf9fb9e5c,
                    limb2: 0xda670c8c69a8ce0a,
                    limb3: 0x0,
                },
                y: u384 {
                    limb0: 0x789872895ad7121175bd78f8,
                    limb1: 0xc0deb0b56fb251e8fb5d0a8d,
                    limb2: 0x3f10d670dc3297c2,
                    limb3: 0x0,
                },
            },
            u1: 340282366920938463464343795955316113711,
            u2: 340282366920938463474852729012356961284,
            v1: 6737143207983294551,
            v2: 7075379181548270484,
        };
        let result = _scalar_mul_glv_and_fake_glv(
            G1Point {
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
            },
            scalar,
            order_modulus,
            modulus,
            hint,
            eigen,
            third_root_of_unity,
            min_one,
            u384 { limb0: 1, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            nbits,
            nG,
            curve_id,
        );
        // assert!(result == nG);
    }
}
