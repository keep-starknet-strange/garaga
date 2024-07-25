use core::result::ResultTrait;
use core::array::ArrayTrait;
use core::circuit::{
    RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition, CircuitData,
    CircuitInputAccumulator
};
use garaga::definitions::{
    get_a, get_b, get_p, get_g, get_min_one, get_b2, get_n, G1Point, G1PointTrait, G2Point,
    G2PointTrait
};
use core::option::Option;
use core::poseidon::hades_permutation;
use garaga::circuits::ec;
use garaga::utils;
use garaga::basic_field_ops::{sub_mod_p, neg_mod_p};

impl G1PointImpl of G1PointTrait {
    fn is_on_curve(self: @G1Point, curve_index: usize) -> bool {
        let (check) = ec::run_IS_ON_CURVE_G1_circuit(
            *self, get_a(curve_index), get_b(curve_index), curve_index
        );
        return (check == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    }
    fn is_infinity(self: @G1Point) -> bool {
        return (*self.x == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
            && *self.y == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 });
    }
    fn update_hash_state(
        self: @G1Point, s0: felt252, s1: felt252, s2: felt252
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

impl G2PointImpl of G2PointTrait {
    fn is_on_curve(self: @G2Point, curve_index: usize) -> bool {
        let (b20, b21) = get_b2(curve_index).unwrap();
        let (check0, check1) = ec::run_IS_ON_CURVE_G2_circuit(
            *self, get_a(curve_index), b20, b21, curve_index
        );
        let zero = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
        return (check0 == zero && check1 == zero);
    }
}

fn ec_safe_add(p: G1Point, q: G1Point, curve_index: usize) -> G1Point {
    if p.is_infinity() {
        return q;
    }
    if q.is_infinity() {
        return p;
    }
    let modulus = get_p(curve_index);
    let same_x = sub_mod_p(p.x, q.x, modulus) == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };

    if same_x {
        let opposite_y = sub_mod_p(
            p.y, neg_mod_p(q.y, modulus), modulus
        ) == u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
        if opposite_y {
            return G1Point {
                x: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
                y: u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 }
            };
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
struct DerivePointFromXOutput {
    rhs: u384,
    g_rhs: u384,
    should_be_rhs_or_g_rhs: u384,
}

fn get_DERIVE_POINT_FROM_X_circuit(
    x: u384, sqrt_rhs_or_g_rhs: u384, curve_index: usize
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

    let p = get_p(curve_index);
    let modulus = TryInto::<_, CircuitModulus>::try_into([p.limb0, p.limb1, p.limb2, p.limb3])
        .unwrap();

    let mut circuit_inputs = (t4, t5, t6,).new_inputs();

    circuit_inputs = circuit_inputs.next(x);
    circuit_inputs = circuit_inputs.next(get_a(curve_index));
    circuit_inputs = circuit_inputs.next(get_b(curve_index));
    circuit_inputs = circuit_inputs.next(get_g(curve_index));
    circuit_inputs = circuit_inputs.next(sqrt_rhs_or_g_rhs);

    let outputs = match circuit_inputs.done().eval(modulus) {
        Result::Ok(outputs) => { outputs },
        Result::Err(_) => { panic!("Expected success") }
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
    mut x: felt252, y_last_attempt: u384, mut g_rhs_sqrt: Array<u384>, curve_index: usize,
) -> G1Point {
    let mut attempt: felt252 = 0;
    while let Option::Some(root) = g_rhs_sqrt.pop_front() {
        let x_u384: u384 = x.into();
        let res: DerivePointFromXOutput = get_DERIVE_POINT_FROM_X_circuit(
            x_u384, root, curve_index
        );
        assert!(
            res.should_be_rhs_or_g_rhs == res.g_rhs, "grhs!=(sqrt(g*rhs))^2 in attempt {attempt}"
        );

        let (new_x, _, _) = hades_permutation(x, attempt.into(), 2);
        x = new_x;
        attempt += 1;
    };

    let x_u384: u384 = x.into();
    let res: DerivePointFromXOutput = get_DERIVE_POINT_FROM_X_circuit(
        x_u384, y_last_attempt, curve_index
    );
    assert!(res.should_be_rhs_or_g_rhs == res.rhs, "unvalid y coordinate");
    return G1Point { x: x_u384, y: y_last_attempt };
}

// A function field element of the form :
// F(x,y) = a(x) + y b(x)
// Where a, b are rational functions of x.
// The rational functions are represented as polynomials in x with coefficients in F_p, starting
// from the constant term.
// No information about the degrees of the polynomials is stored here as they are derived
// implicitely from the MSM size.
#[derive(Drop, Debug, PartialEq)]
struct FunctionFelt {
    a_num: Span<u384>,
    a_den: Span<u384>,
    b_num: Span<u384>,
    b_den: Span<u384>,
}
#[derive(Drop, Debug, Copy, PartialEq)]
struct FunctionFeltEvaluations {
    a_num: u384,
    a_den: u384,
    b_num: u384,
    b_den: u384,
}

#[derive(Drop, Debug, Copy, PartialEq)]
struct SlopeInterceptOutput {
    m_A0: u384,
    b_A0: u384,
    x_A2: u384,
    y_A2: u384,
    coeff0: u384,
    coeff2: u384,
}

#[generate_trait]
impl FunctionFeltImpl of FunctionFeltTrait {
    fn validate_degrees(self: @FunctionFelt, msm_size: usize) {
        assert!((*self.a_num).len() == msm_size + 1, "a_num wrong degree for given msm size");
        assert!((*self.a_den).len() == msm_size + 2, "a_den wrong degree for given msm size");
        assert!((*self.b_num).len() == msm_size + 2, "b_num wrong degree for given msm size");
        assert!((*self.b_den).len() == msm_size + 5, "b_den wrong degree for given msm size");
    }
    fn update_hash_state(
        self: @FunctionFelt, s0: felt252, s1: felt252, s2: felt252
    ) -> (felt252, felt252, felt252) {
        let (s0, s1, s2) = utils::hash_u384_transcript(*self.a_num, s0, s1, s2);
        let (s0, s1, s2) = utils::hash_u384_transcript(*self.a_den, s0, s1, s2);
        let (s0, s1, s2) = utils::hash_u384_transcript(*self.b_num, s0, s1, s2);
        let (s0, s1, s2) = utils::hash_u384_transcript(*self.b_den, s0, s1, s2);
        return (s0, s1, s2);
    }
}

fn msm_g1(
    points: Span<G1Point>,
    scalars: Span<u256>,
    scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
    Q_low: G1Point,
    Q_high: G1Point,
    Q_high_shifted: G1Point,
    SumDlogDivLow: FunctionFelt,
    SumDlogDivHigh: FunctionFelt,
    SumDlogDivHighShifted: FunctionFelt,
    y_last_attempt: u384,
    g_rhs_sqrt: Array<u384>,
    curve_index: usize
) -> G1Point {
    let n = scalars.len();
    assert!(n == points.len(), "scalars and points length mismatch");
    let b = get_b(curve_index);
    assert!(
        b != u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 },
        "b must be non-zero to correctly encode point at infinity"
    );

    if n == 0 {
        panic!("Msm size must be >= 1");
    }

    // Check result points are either on curve or the point at infinity
    assert!(
        Q_low.is_on_curve(curve_index) || Q_low.is_infinity(),
        "Q_low is neither on curve nor the point at infinity"
    );
    assert!(
        Q_high.is_on_curve(curve_index) || Q_high.is_infinity(),
        "Q_high is neither on curve nor the point at infinity"
    );
    assert!(
        Q_high_shifted.is_on_curve(curve_index) || Q_high_shifted.is_infinity(),
        "Q_high_shifted is neither on curve nor the point at infinity"
    );

    // Validate the degrees of the functions field elements given the msm size
    SumDlogDivLow.validate_degrees(n);
    SumDlogDivHigh.validate_degrees(n);
    SumDlogDivHighShifted.validate_degrees(1);

    // Hash everything to obtain a x coordinate.

    let (s0, s1, s2): (felt252, felt252, felt252) = hades_permutation(
        'MSM_G1', 0, 1
    ); // Init Sponge state
    let (s0, s1, s2) = hades_permutation(
        s0 + curve_index.into(), s1 + n.into(), s2
    ); // Include curve_index and msm size
    let (s0, s1, s2) = SumDlogDivLow.update_hash_state(s0, s1, s2);
    let (s0, s1, s2) = SumDlogDivHigh.update_hash_state(s0, s1, s2);
    let (s0, s1, s2) = SumDlogDivHighShifted.update_hash_state(s0, s1, s2);

    let mut s0 = s0;
    let mut s1 = s1;
    let mut s2 = s2;

    // Check input points are on curve and hash them at the same time.
    for point in points {
        assert!(point.is_on_curve(curve_index), "One of the points is not on curve");
        let (_s0, _s1, _s2) = point.update_hash_state(s0, s1, s2);
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };

    // Hash result points
    let (s0, s1, s2) = Q_low.update_hash_state(s0, s1, s2);
    let (s0, s1, s2) = Q_high.update_hash_state(s0, s1, s2);
    let (s0, s1, s2) = Q_high_shifted.update_hash_state(s0, s1, s2);

    // Hash scalars and verify they are below the curve order
    let curve_order = get_n(curve_index);
    let mut s0 = s0;
    let mut s1 = s1;
    let mut s2 = s2;
    for scalar in scalars {
        assert!(*scalar <= curve_order, "One of the scalar is larger than the curve order");
        let (_s0, _s1, _s2) = core::poseidon::hades_permutation(
            s0 + (*scalar.low).into(), s1 + (*scalar.high).into(), s2
        );
        s0 = _s0;
        s1 = _s1;
        s2 = _s2;
    };

    let random_point: G1Point = derive_ec_point_from_X(s0, y_last_attempt, g_rhs_sqrt, curve_index);

    // Get slope, intercept and other constant from random point
    let (mb): (SlopeInterceptOutput,) = ec::run_SLOPE_INTERCEPT_SAME_POINT_circuit(
        random_point, get_a(curve_index), curve_index
    );

    // Get positive and negative multiplicities of low and high part of scalars
    let (epns_low, epns_high) = utils::u256_array_to_low_high_epns(
        scalars, scalars_digits_decompositions
    );

    // Hardcoded epns for 2^128
    let epns_shifted: Array<(felt252, felt252, felt252, felt252)> = array![
        (5279154705627724249993186093248666011, 345561521626566187713367793525016877467, -1, -1)
    ];

    // Verify Q_low = sum(scalar_low * P for scalar_low,P in zip(scalars_low, points))
    zk_ecip_check(points, epns_low, Q_low, n, mb, SumDlogDivLow, random_point, curve_index);
    // Verify Q_high = sum(scalar_high * P for scalar_high,P in zip(scalars_high, points))
    zk_ecip_check(points, epns_high, Q_high, n, mb, SumDlogDivHigh, random_point, curve_index);
    // Verify Q_high_shifted = 2^128 * Q_high
    zk_ecip_check(
        array![Q_high].span(),
        epns_shifted,
        Q_high_shifted,
        1,
        mb,
        SumDlogDivHighShifted,
        random_point,
        curve_index
    );

    // Return Q_low + Q_high_shifted = Q_low + 2^128 * Q_high = Σ(ki * Pi)
    return ec_safe_add(Q_low, Q_high_shifted, curve_index);
}

fn zk_ecip_check(
    points: Span<G1Point>,
    epns: Array<(felt252, felt252, felt252, felt252)>,
    Q_result: G1Point,
    n: usize,
    mb: SlopeInterceptOutput,
    sum_dlog_div: FunctionFelt,
    random_point: G1Point,
    curve_index: usize
) {
    let lhs = compute_lhs_ecip(
        sum_dlog_div: sum_dlog_div,
        A0: random_point,
        A2: G1Point { x: mb.x_A2, y: mb.y_A2 },
        coeff0: mb.coeff0,
        coeff2: mb.coeff2,
        msm_size: n,
        curve_index: curve_index
    );
    let rhs = compute_rhs_ecip(
        points: points,
        m_A0: mb.m_A0,
        b_A0: mb.b_A0,
        x_A0: random_point.x,
        epns: epns,
        Q_result: Q_result,
        curve_index: curve_index
    );
    assert!(lhs == rhs, "LHS and RHS are not equal");
}

fn compute_lhs_ecip(
    sum_dlog_div: FunctionFelt,
    A0: G1Point,
    A2: G1Point,
    coeff0: u384,
    coeff2: u384,
    msm_size: usize,
    curve_index: usize
) -> u384 {
    let case = msm_size - 1;
    let (res) = match case {
        0 => (ec::run_EVAL_FUNCTION_CHALLENGE_DUPL_1_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index
        )),
        1 => ec::run_EVAL_FUNCTION_CHALLENGE_DUPL_2_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index
        ),
        2 => ec::run_EVAL_FUNCTION_CHALLENGE_DUPL_3_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index
        ),
        3 => ec::run_EVAL_FUNCTION_CHALLENGE_DUPL_4_circuit(
            A0, A2, coeff0, coeff2, sum_dlog_div, curve_index
        ),
        _ => {
            let (_f_A0, _f_A2, _xA0_power, _xA2_power) =
                ec::run_INIT_FUNCTION_CHALLENGE_DUPL_5_circuit(
                A0.x,
                A2.x,
                FunctionFelt {
                    a_num: sum_dlog_div.a_num.slice(0, 5 + 1),
                    a_den: sum_dlog_div.a_den.slice(0, 5 + 2),
                    b_num: sum_dlog_div.b_num.slice(0, 5 + 2),
                    b_den: sum_dlog_div.b_den.slice(0, 5 + 5),
                },
                curve_index
            );
            let mut f_A0 = _f_A0;
            let mut f_A2 = _f_A2;
            let mut xA0_power = _xA0_power;
            let mut xA2_power = _xA2_power;
            let mut i = 5;
            while i != msm_size {
                let (_f_A0, _f_A2, _xA0_power, _xA2_power) =
                    ec::run_ACC_FUNCTION_CHALLENGE_DUPL_circuit(
                    f_A0,
                    f_A2,
                    A0.x,
                    A2.x,
                    xA0_power,
                    xA2_power,
                    *sum_dlog_div.a_num.at(i + 1),
                    *sum_dlog_div.a_den.at(i + 2),
                    *sum_dlog_div.b_num.at(i + 2),
                    *sum_dlog_div.b_den.at(i + 5),
                    curve_index
                );
                f_A0 = f_A0;
                f_A2 = f_A2;
                xA0_power = xA0_power;
                xA2_power = xA2_power;
                i += 1;
            };
            ec::run_FINALIZE_FUNCTION_CHALLENGE_DUPL_circuit(
                f_A0, f_A2, A0.y, A2.y, coeff0, coeff2, curve_index
            )
        }
    };
    return res;
}

fn compute_rhs_ecip(
    points: Span<G1Point>,
    m_A0: u384,
    b_A0: u384,
    x_A0: u384,
    epns: Array<(felt252, felt252, felt252, felt252)>,
    Q_result: G1Point,
    curve_index: usize
) -> u384 {
    let mut basis_sum: u384 = u384 { limb0: 0, limb1: 0, limb2: 0, limb3: 0 };
    let mut i = 0;
    let n = points.len();
    while i != n {
        let (ep, en, sp, sn) = *epns.at(i);
        let (_basis_sum) = ec::run_ACCUMULATE_EVAL_POINT_CHALLENGE_SIGNED_circuit(
            basis_sum,
            m_A0,
            b_A0,
            x_A0,
            *points.at(i),
            ep.into(),
            en.into(),
            utils::sign_to_u384(sp, curve_index),
            utils::sign_to_u384(sn, curve_index),
            curve_index
        );
        basis_sum = _basis_sum;
        i += 1;
    };
    if Q_result.is_infinity() {
        return basis_sum;
    } else {
        let (rhs) = ec::run_RHS_FINALIZE_ACC_circuit(
            basis_sum, m_A0, b_A0, x_A0, Q_result, curve_index
        );
        return rhs;
    }
}

#[cfg(test)]
mod tests {
    use core::traits::TryInto;

    use core::circuit::{
        RangeCheck96, AddMod, MulMod, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
        circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, u384,
        CircuitOutputsTrait, CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitDefinition,
        CircuitData, CircuitInputAccumulator
    };

    use super::{G1Point, derive_ec_point_from_X};

    #[test]
    fn derive_ec_point_from_X_BN254_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 27714606479635523100598951153,
            limb1: 34868386485493864315220284141,
            limb2: 1519130443637890520,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 34873921585975737735287544514,
                limb1: 75824041826137017845509324964,
                limb2: 187208958347329739,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 0);
        assert!(
            result
                .x == u384 {
                    limb0: 62660379282463401875295134940,
                    limb1: 73368200585075358810639862040,
                    limb2: 177398867278533950,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_BLS12_381_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 67531198318575421426300025691,
            limb1: 73079231539510663354129518416,
            limb2: 13251943114660016581709012614,
            limb3: 312421328302071775409629582
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 68021603415295632383289353247,
                limb1: 14347541238121938408363115646,
                limb2: 54988998339125932059796959279,
                limb3: 494992670041001062700538471
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 1);
        assert!(
            result
                .x == u384 {
                    limb0: 62660379282463401875295134940,
                    limb1: 73368200585075358810639862040,
                    limb2: 177398867278533950,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256K1_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 34606645619261666887882469145,
            limb1: 34310340540651960142565999300,
            limb2: 7154540730595498546,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 29115782825123595146650267768,
                limb1: 63981367585271686949344367625,
                limb2: 6097997740176893311,
                limb3: 0
            },
            u384 {
                limb0: 66260645944799995925272212427,
                limb1: 22310207976496367248630075299,
                limb2: 1431124550686470511,
                limb3: 0
            },
            u384 {
                limb0: 33082894703518262725666078097,
                limb1: 24682596414004853981531917491,
                limb2: 4643712938487018145,
                limb3: 0
            },
            u384 {
                limb0: 66880718245691397296801121512,
                limb1: 76565997951508614922957482510,
                limb2: 5012952563093764202,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 2);
        assert!(
            result
                .x == u384 {
                    limb0: 42929719520991302865932943121,
                    limb1: 36914558178536778654385124821,
                    limb2: 118195263393991001,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256R1_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 20053638866842022551859121301,
            limb1: 32086628798319651018449199897,
            limb2: 6914626262564250074,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 393988862542943514351259350,
                limb1: 32631280720834460460687405392,
                limb2: 7629184566207618792,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 3);
        assert!(
            result
                .x == u384 {
                    limb0: 62660379282463401875295134940,
                    limb1: 73368200585075358810639862040,
                    limb2: 177398867278533950,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_X25519_0() {
        let x: felt252 =
            1007924606664371314454745651482312426967359991013948795084104590968267883012;
        let y: u384 = u384 {
            limb0: 6641231605643607855894531310,
            limb1: 28562104663165609178035840171,
            limb2: 4565350961645903027,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 7105175563015008315685364011,
                limb1: 76416124497522470000489060934,
                limb2: 330980194138944710,
                limb3: 0
            },
            u384 {
                limb0: 38793056481542655932181586012,
                limb1: 57451582827274319204362394172,
                limb2: 2942017708458610346,
                limb3: 0
            },
            u384 {
                limb0: 14430532572489113284395332323,
                limb1: 26241382189639247952699002461,
                limb2: 2598004041982469908,
                limb3: 0
            },
            u384 {
                limb0: 49409567804625469691750341753,
                limb1: 64866096857366305012188395545,
                limb2: 1595126387735062936,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 4);
        assert!(
            result
                .x == u384 {
                    limb0: 42929719520991302865932943121,
                    limb1: 36914558178536778654385124821,
                    limb2: 118195263393991001,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_BN254_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 7541127677702363468415682117,
            limb1: 7339146545383179916410626057,
            limb2: 1662796485815941777,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 56593029338919184351948309166,
                limb1: 78839133926349938496323925966,
                limb2: 1166934752106015978,
                limb3: 0
            },
            u384 {
                limb0: 63223781830975669344766943642,
                limb1: 74444744836329886611135077400,
                limb2: 1380913212054945422,
                limb3: 0
            },
            u384 {
                limb0: 50887689488123923580373597173,
                limb1: 66102011561815370814199355527,
                limb2: 762754245250277144,
                limb3: 0
            },
            u384 {
                limb0: 18359012771626800922322228576,
                limb1: 19701678288333074153024467662,
                limb2: 158067669538113323,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 0);
        assert!(
            result
                .x == u384 {
                    limb0: 24396693794304597105208684791,
                    limb1: 4207882195617269586684036873,
                    limb2: 341894036225903616,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_BLS12_381_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 16664622114157216710127118487,
            limb1: 34496886834924133882820211311,
            limb2: 14681766861219310585427272456,
            limb3: 142278354763043665247395944
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 28763020826406771731898346108,
                limb1: 2353016884227923852537348574,
                limb2: 34082131550706258092314435685,
                limb3: 1165206251617494340182481980
            },
            u384 {
                limb0: 37033693894667150389905038999,
                limb1: 10302644005127102463907644379,
                limb2: 78737921960701689473478891399,
                limb3: 3270535059343858278495456216
            },
            u384 {
                limb0: 21453169296718612908389560992,
                limb1: 13338169335698150965007865120,
                limb2: 57124080282056246848186485796,
                limb3: 1559916207367557786314641351
            },
            u384 {
                limb0: 75800631196261115574214565845,
                limb1: 73420942871209786314270923051,
                limb2: 49289097989605023512973388539,
                limb3: 1350666271416254326454023434
            },
            u384 {
                limb0: 61619728738907003718143370427,
                limb1: 60232573073365562843282670500,
                limb2: 1504560647451545717145868368,
                limb3: 2125971161844144636941270832
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 1);
        assert!(
            result
                .x == u384 {
                    limb0: 40674640075959635844425879065,
                    limb1: 22285289032531025076675905605,
                    limb2: 530881566500206432,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256K1_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 61529979452557460149067588721,
            limb1: 14841798560705171636287708415,
            limb2: 1770331318768958527,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 10785862971079680493708771474,
                limb1: 12156662556876153363522599492,
                limb2: 1774436630115181654,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 2);
        assert!(
            result
                .x == u384 {
                    limb0: 57958657987920053228408344703,
                    limb1: 63683415548830384065057176824,
                    limb2: 263481919888268803,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_SECP256R1_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 34169071209595369166351427566,
            limb1: 16738091740365154255463055601,
            limb2: 3510049088213307128,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![
            u384 {
                limb0: 72578578591589386637147258864,
                limb1: 51259380511610139263350403321,
                limb2: 1257103837234097545,
                limb3: 0
            }
        ];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 3);
        assert!(
            result
                .x == u384 {
                    limb0: 57958657987920053228408344703,
                    limb1: 63683415548830384065057176824,
                    limb2: 263481919888268803,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }


    #[test]
    fn derive_ec_point_from_X_X25519_1() {
        let x: felt252 =
            1063560484360105189252690783610884672686565418691657713591359159370969850218;
        let y: u384 = u384 {
            limb0: 23844267126761620632980646996,
            limb1: 69199219782413262757458670200,
            limb2: 8935330945789737,
            limb3: 0
        };
        let grhs_roots: Array<u384> = array![];
        let result = derive_ec_point_from_X(x, y, grhs_roots, 4);
        assert!(
            result
                .x == u384 {
                    limb0: 77864287393115290533831713130,
                    limb1: 47687594959966383440346360609,
                    limb2: 169434960463419659,
                    limb3: 0
                }
        );
        assert!(result.y == y);
    }
}

