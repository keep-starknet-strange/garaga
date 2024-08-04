use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::fields::fft_friendly::stark_252_prime_field::Stark252PrimeField;
use crate::ecip::polynomial::Polynomial;
use crate::ecip::curve::CURVES;
use crate::ecip::ff::FF;

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
        vec![d.get(0).differentiate(), d.get(1).differentiate()],
        d.curve_id,
    );
    let dy = d.get(1).clone(); // B(x)

    let two_y = FF::new(
        vec![
            Polynomial::zero(field.clone()),
            Polynomial::new(&[field.from(2)]),
        ],
        d.curve_id,
    );
    let u = dx * two_y.clone()
        + FF::new(
            vec![
                dy.clone()
                    * Polynomial::new(&[
                        field.from(CURVES[d.curve_id as usize].a),
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
        den_ff.get(1).is_zero(),
        "Den[1] is not zero: {:?}",
        den_ff.get(1)
    );

    let den = den_ff.get(0).clone();

    let (gcd_0, _, _) = num.get(0).xgcd(&den);
    let (gcd_1, _, _) = num.get(1).xgcd(&den);

    // Simplify the numerator and denominator by dividing by the gcd
    let a_num = num.get(0).clone() / gcd_0.clone();
    let a_den = den.clone() / gcd_0;
    let b_num = num.get(1).clone() / gcd_1.clone();
    let b_den = den.clone() / gcd_1;

    // Normalize to obtain exactly Sage's coeffs.
    FunctionFelt::new(
        RationalFunction::new(
            a_num * den.leading_coefficient().inv(),
            a_den * a_den.leading_coefficient().inv(),
        ),
        RationalFunction::new(
            b_num * den.leading_coefficient().inv(),
            b_den * b_den.leading_coefficient().inv(),
        ),
    )
}
