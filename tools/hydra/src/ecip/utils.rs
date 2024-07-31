use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;

pub fn is_quad_residue(value: u64, p: u64) -> bool {
    // Implement the logic to check if the value is a quadratic residue modulo p
    // Placeholder implementation, replace with actual logic
    true
}

pub fn sqrt_mod_p(value: u64, p: u64) -> u64 {
    // Implement the logic to compute the square root modulo p
    // Placeholder implementation, replace with actual logic
    value
}

pub fn hades_permutation(x: u64, attempt: usize, _: u64) -> (u64, u64, u64) {
    // Implement the hades_permutation logic
    // Placeholder implementation, replace with actual logic
    (x + attempt as u64, 0, 0)
}

#[derive(Clone)]
pub struct RationalFunction {
    pub numerator: Polynomial<FieldElement<Stark252PrimeField>>,
    pub denominator: Polynomial<FieldElement<Stark252PrimeField>>,
}

impl RationalFunction {
    pub fn new(
        numerator: Polynomial<FieldElement<Stark252PrimeField>>,
        denominator: Polynomial<FieldElement<Stark252PrimeField>>,
    ) -> Self {
        RationalFunction {
            numerator,
            denominator,
        }
    }
}

#[derive(Clone)]
pub struct FunctionFelt {
    pub a: RationalFunction,
    pub b: RationalFunction,
}

impl FunctionFelt {
    pub fn new(a: RationalFunction, b: RationalFunction) -> Self {
        FunctionFelt { a, b }
    }
}

pub fn dlog(d: &FF) -> FunctionFelt {
    let field = FieldElement::<Stark252PrimeField>::zero().field();

    let mut d = d.reduce();
    assert!(
        d.coeffs.len() == 2,
        "D has {} coeffs: {:?}",
        d.coeffs.len(),
        d.coeffs
    );
    let dx = FF::new(
        vec![d[0].differentiate(), d[1].differentiate()],
        d.curve_id,
    );
    let dy = d[1].clone(); // B(x)

    let two_y = FF::new(
        vec![
            Polynomial::zero(field.clone()),
            Polynomial::new(vec![field.from(2)]),
        ],
        d.curve_id,
    );
    let u = dx * two_y.clone()
        + FF::new(
            vec![
                dy.clone()
                    * Polynomial::new(vec![
                        field.from(CURVES[d.curve_id].a),
                        field.zero(),
                        field.from(3),
                    ]), // 3x^2 + A
                Polynomial::zero(field.clone()),
            ],
            d.curve_id,
        );

    let v = two_y * d;

    let num = (u * v.neg_y()).reduce();
    let den_ff = (v * v.neg_y()).reduce();

    assert!(
        den_ff[1].is_zero(),
        "Den[1] is not zero: {:?}",
        den_ff[1].print_as_sage_poly("x")
    );

    let den = den_ff[0].clone();

    let (gcd_0, _, _) = Polynomial::xgcd(num[0].clone(), den.clone());
    let (gcd_1, _, _) = Polynomial::xgcd(num[1].clone(), den.clone());

    // Simplify the numerator and denominator by dividing by the gcd
    let a_num = num[0].clone() / gcd_0.clone();
    let a_den = den.clone() / gcd_0;
    let b_num = num[1].clone() / gcd_1.clone();
    let b_den = den.clone() / gcd_1;

    // Normalize to obtain exactly Sage's coeffs.
    let res = FunctionFelt::new(
        RationalFunction::new(
            a_num * den.leading_coefficient().inv(),
            a_den * a_den.leading_coefficient().inv(),
        ),
        RationalFunction::new(
            b_num * den.leading_coefficient().inv(),
            b_den * b_den.leading_coefficient().inv(),
        ),
    );

    res
}

pub fn ecip_functions(
    bs: Vec<G1Point>,
    dss: Vec<Vec<i32>>,
) -> (G1Point, Vec<FF>) {
    // Implement the logic for ecip_functions
    // Placeholder implementation, replace with actual logic
    (G1Point::default(), vec![])
}

pub fn slope_intercept_internal(
    p: G1Point,
    q: G1Point,
) -> (FieldElement<Stark252PrimeField>, FieldElement<Stark252PrimeField>) {
    let field = FieldElement::<Stark252PrimeField>::zero().field();

    if p == q {
        let px = p.x.clone();
        let py = p.y.clone();
        let m = (FieldElement::<Stark252PrimeField>::from(3) * px.clone() * px.clone() + FieldElement::<Stark252PrimeField>::from(CURVES[p.curve_id].a)) / (FieldElement::<Stark252PrimeField>::from(2) * py.clone());
        let b = py - m.clone() * px;
        (m, b)
    } else {
        let px = p.x.clone();
        let py = p.y.clone();
        let qx = q.x.clone();
        let qy = q.y.clone();
        let m = (py - qy.clone()) / (px.clone() - qx.clone());
        let b = qy - m.clone() * qx;
        (m, b)
    }
}