use crate::algebra::extf_mul::{
    e2_conjugate, nondeterministic_extension_field_div, nondeterministic_extension_field_mul_divmod,
};
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::algebra::polynomial::Polynomial;
use crate::definitions::{CurveID, CurveParamsProvider};
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::{IsField, IsPrimeField, IsSubFieldOf};
use lambdaworks_math::traits::ByteConversion;

// Replaces elements in a list by zero where sparsity is not set
// e.g. [1 2 3 4] [T F T F] => [1 0 3 0]
pub fn replace_by_zero_elements_given_sparsity<F: IsPrimeField>(
    elmts: &[FieldElement<F>],
    sparsity: &[bool],
) -> Vec<FieldElement<F>> {
    assert_eq!(sparsity.len(), elmts.len());
    let mut result = vec![];
    for i in 0..elmts.len() {
        result.push(if sparsity[i] {
            elmts[i].clone()
        } else {
            FieldElement::from(0)
        });
    }
    result
}

// Removes elements from a list where sparsity is not set, it compacts the list
// e.g. [1 2 3 4] [T F T F] => [1 3]
pub fn remove_and_compact_elements_given_sparsity<F: IsPrimeField>(
    elmts: &[FieldElement<F>],
    sparsity: &[bool],
) -> Vec<FieldElement<F>> {
    assert_eq!(sparsity.len(), elmts.len());
    let mut result = vec![];
    for i in 0..elmts.len() {
        if sparsity[i] {
            result.push(elmts[i].clone());
        }
    }
    result
}

pub fn extf_mul<F>(
    ps: Vec<Polynomial<F>>,
    r_sparsity: Option<Vec<bool>>,
    qis: Option<&mut Vec<Polynomial<F>>>,
    ris: Option<&mut Vec<Polynomial<F>>>,
) -> Polynomial<F>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    let (q, r) = nondeterministic_extension_field_mul_divmod(12, ps);
    let mut r = r.get_coefficients_ext_degree(12);
    if let Some(r_sparsity) = r_sparsity {
        r = replace_by_zero_elements_given_sparsity(&r, &r_sparsity);
    }
    let r = Polynomial::new(r);
    if let Some(qis) = qis {
        qis.push(q)
    }
    if let Some(ris) = ris {
        ris.push(r.clone())
    }
    r
}

pub fn extf_inv<F, E2, E6, E12>(
    y: &Polynomial<F>,
    qis: Option<&mut Vec<Polynomial<F>>>,
    ris: Option<&mut Vec<Polynomial<F>>>,
) -> Polynomial<F>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
    FieldElement<F>: ByteConversion,
{
    let one = Polynomial::one();
    let y_inv = nondeterministic_extension_field_div(one, y.clone(), 12);
    let (q, r) = nondeterministic_extension_field_mul_divmod(12, vec![y_inv.clone(), y.clone()]);
    let r = Polynomial::new(r.coefficients); // removes trailing zero coefficients
    assert_eq!(r, Polynomial::one());
    if let Some(qis) = qis {
        qis.push(q)
    }
    if let Some(ris) = ris {
        ris.push(r)
    }
    y_inv
}

pub fn conjugate_e12d<F: IsPrimeField>(f: Polynomial<F>) -> Polynomial<F> {
    let e12d = f.get_coefficients_ext_degree(12);
    Polynomial::new(vec![
        e12d[0].clone(),
        -&e12d[1],
        e12d[2].clone(),
        -&e12d[3],
        e12d[4].clone(),
        -&e12d[5],
        e12d[6].clone(),
        -&e12d[7],
        e12d[8].clone(),
        -&e12d[9],
        e12d[10].clone(),
        -&e12d[11],
    ])
}

pub fn precompute_consts<F: IsPrimeField>(
    p: &[G1Point<F>],
) -> (Vec<FieldElement<F>>, Vec<FieldElement<F>>) {
    let mut y_inv = vec![];
    let mut x_neg_over_y = vec![];
    for point in p {
        y_inv.push(point.y.inv().unwrap());
        x_neg_over_y.push(-&(&point.x / &point.y).unwrap());
    }
    (y_inv, x_neg_over_y)
}

fn build_sparse_line_eval<F, E2>(
    r0: &FieldElement<E2>,
    r1: &FieldElement<E2>,
    y_inv: &FieldElement<F>,
    x_neg_over_y: &FieldElement<F>,
) -> Polynomial<F>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    use crate::algebra::extf_mul::from_e2;
    let curve_id = F::get_curve_params().curve_id;
    let [r0x, r0y] = from_e2(r0.clone());
    let [r1x, r1y] = from_e2(r1.clone());
    let coefficients = match curve_id {
        CurveID::BN254 => vec![
            FieldElement::from(1),
            &(&r0x + &(&-FieldElement::<F>::from(9) * &r0y)) * x_neg_over_y,
            FieldElement::from(0),
            &(&r1x + &(&-FieldElement::<F>::from(9) * &r1y)) * y_inv,
            FieldElement::from(0),
            FieldElement::from(0),
            FieldElement::from(0),
            &r0y * x_neg_over_y,
            FieldElement::from(0),
            &r1y * y_inv,
            FieldElement::from(0),
            FieldElement::from(0),
        ],
        CurveID::BLS12_381 => vec![
            &(&r1x - &r1y) * y_inv,
            FieldElement::from(0),
            &(&r0x - &r0y) * x_neg_over_y,
            FieldElement::from(1),
            FieldElement::from(0),
            FieldElement::from(0),
            &r1y * y_inv,
            FieldElement::from(0),
            &r0y * x_neg_over_y,
            FieldElement::from(0),
            FieldElement::from(0),
            FieldElement::from(0),
        ],
        _ => unimplemented!(),
    };
    Polynomial::new(coefficients)
}

pub fn add_step<F, E2>(
    qa: &G2Point<F, E2>,
    qb: &G2Point<F, E2>,
    y_inv: &FieldElement<F>,
    x_neg_over_y: &FieldElement<F>,
) -> (G2Point<F, E2>, Polynomial<F>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let λ = G2Point::compute_adding_slope(qa, qb);
    let xr = &(&λ * &λ) - &(&qa.x + &qb.x);
    let yr = &(&λ * &(&qa.x - &xr)) - &qa.y;
    let p = G2Point::new_unchecked(xr, yr);
    let line_r0 = λ.clone();
    let line_r1 = &(&λ * &qa.x) - &qa.y;
    let line = build_sparse_line_eval(&line_r0, &line_r1, y_inv, x_neg_over_y);
    (p, line)
}

pub fn line_compute_step<F, E2>(
    qa: &G2Point<F, E2>,
    qb: &G2Point<F, E2>,
    y_inv: &FieldElement<F>,
    x_neg_over_y: &FieldElement<F>,
) -> Polynomial<F>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let λ = G2Point::compute_adding_slope(qa, qb);
    let line_r0 = λ.clone();
    let line_r1 = &(&λ * &qa.x) - &qa.y;

    build_sparse_line_eval(&line_r0, &line_r1, y_inv, x_neg_over_y)
}

pub fn double_step<F, E2>(
    q: &G2Point<F, E2>,
    y_inv: &FieldElement<F>,
    x_neg_over_y: &FieldElement<F>,
) -> (G2Point<F, E2>, Polynomial<F>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let λ = G2Point::compute_doubling_slope(q);
    let xr = &(&λ * &λ) - &(&q.x + &q.x);
    let yr = &(&λ * &(&q.x - &xr)) - &q.y;
    let p = G2Point::new_unchecked(xr, yr);
    let line_r0 = λ.clone();
    let line_r1 = &(&λ * &q.x) - &q.y;
    let line = build_sparse_line_eval(&line_r0, &line_r1, y_inv, x_neg_over_y);
    (p, line)
}

pub fn double_and_add_step<F, E2>(
    qa: &G2Point<F, E2>,
    qb: &G2Point<F, E2>,
    y_inv: &FieldElement<F>,
    x_neg_over_y: &FieldElement<F>,
) -> (G2Point<F, E2>, Polynomial<F>, Polynomial<F>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let λ1 = G2Point::compute_adding_slope(qa, qb);
    let x3 = &(&λ1 * &λ1) - &(&qa.x + &qb.x);
    let line1_r0 = λ1.clone();
    let line1_r1 = &(&λ1 * &qa.x) - &qa.y;
    let num = &qa.y + &qa.y;
    let den = &x3 - &qa.x;
    let λ2 = -&(&λ1 + &(&num / &den).unwrap());
    let x4 = &(&(&λ2 * &λ2) - &qa.x) - &x3;
    let y4 = &(&λ2 * &(&qa.x - &x4)) - &qa.y;
    let p = G2Point::new_unchecked(x4, y4);
    let line2_r0 = λ2.clone();
    let line2_r1 = &(&λ2 * &qa.x) - &qa.y;
    let line1 = build_sparse_line_eval(&line1_r0, &line1_r1, y_inv, x_neg_over_y);
    let line2 = build_sparse_line_eval(&line2_r0, &line2_r1, y_inv, x_neg_over_y);
    (p, line1, line2)
}

pub fn triple_step<F, E2>(
    q: &G2Point<F, E2>,
    y_inv: &FieldElement<F>,
    x_neg_over_y: &FieldElement<F>,
) -> (G2Point<F, E2>, Polynomial<F>, Polynomial<F>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let λ1 = G2Point::compute_doubling_slope(q);
    let line1_r0 = λ1.clone();
    let line1_r1 = &(&λ1 * &q.x) - &q.y;
    let x2 = &(&λ1 * &λ1) - &(&q.x + &q.x);
    let λ2 = &(((&q.y + &q.y) / &(&q.x - &x2)).unwrap()) - &λ1;
    let line2_r0 = λ2.clone();
    let line2_r1 = &(&λ2 * &q.x) - &q.y;
    let xr = &(&λ2 * &λ2) - &(&q.x + &x2);
    let yr = &(&λ2 * &(&q.x - &xr)) - &q.y;
    let p = G2Point::new_unchecked(xr, yr);
    let line1 = build_sparse_line_eval(&line1_r0, &line1_r1, y_inv, x_neg_over_y);
    let line2 = build_sparse_line_eval(&line2_r0, &line2_r1, y_inv, x_neg_over_y);
    (p, line1, line2)
}

fn bit_0_case<F, E2>(
    f: &Polynomial<F>,
    q: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
) -> (Polynomial<F>, Vec<G2Point<F, E2>>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let mut new_lines = vec![f.clone(), f.clone()];
    let mut new_points = vec![];
    for k in 0..q.len() {
        let (t, l1) = double_step(&q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_points.push(t);
    }
    let new_f = extf_mul(new_lines, None, None, None);
    (new_f, new_points)
}

fn bit_1_init_case<F, E2>(
    f: &Polynomial<F>,
    q: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
) -> (Polynomial<F>, Vec<G2Point<F, E2>>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let mut new_lines = vec![f.clone(), f.clone()];
    let mut new_points = vec![];
    for k in 0..q.len() {
        let (t, l1, l2) = triple_step(&q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_lines.push(l2);
        new_points.push(t);
    }
    let new_f = extf_mul(new_lines, None, None, None);
    (new_f, new_points)
}

fn bit_1_case<F, E2>(
    f: &Polynomial<F>,
    q: &[G2Point<F, E2>],
    q_select: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
) -> (Polynomial<F>, Vec<G2Point<F, E2>>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let mut new_lines = vec![f.clone(), f.clone()];
    let mut new_points = vec![];
    for k in 0..q.len() {
        let (t, l1, l2) = double_and_add_step(&q[k], &q_select[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_lines.push(l2);
        new_points.push(t);
    }
    let new_f = extf_mul(new_lines, None, None, None);
    (new_f, new_points)
}

pub fn bn254_finalize_step<F, E2>(
    qs: &[G2Point<F, E2>],
    q: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
) -> Vec<Polynomial<F>>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    use crate::algebra::extf_mul::to_e2;
    let nr1p2 = to_e2([
        FieldElement::<F>::from_hex(
            "2fb347984f7911f74c0bec3cf559b143b78cc310c2c3330c99e39557176f553d",
        )
        .unwrap(),
        FieldElement::<F>::from_hex(
            "16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2",
        )
        .unwrap(),
    ]);
    let nr1p3 = to_e2([
        FieldElement::<F>::from_hex(
            "63cf305489af5dcdc5ec698b6e2f9b9dbaae0eda9c95998dc54014671a0135a",
        )
        .unwrap(),
        FieldElement::<F>::from_hex(
            "7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3",
        )
        .unwrap(),
    ]);
    let nr2p2 = FieldElement::<F>::from_hex(
        "30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48",
    )
    .unwrap();
    let nr2p3 = -FieldElement::<F>::from_hex(
        "30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd46",
    )
    .unwrap();
    let mut lines = vec![];
    for k in 0..q.len() {
        let q1x = nr1p2.clone() * e2_conjugate(q[k].x.clone());
        let q1y = nr1p3.clone() * e2_conjugate(q[k].y.clone());
        let q2x = nr2p2.clone() * q[k].x.clone();
        let q2y = nr2p3.clone() * q[k].y.clone();
        let (t, line1) = add_step(
            &qs[k],
            &G2Point::new_unchecked(q1x, q1y),
            &y_inv[k],
            &x_neg_over_y[k],
        );
        lines.push(line1);
        let line2 = line_compute_step(
            &t,
            &G2Point::new_unchecked(q2x, q2y),
            &y_inv[k],
            &x_neg_over_y[k],
        );
        lines.push(line2);
    }
    lines
}

pub fn miller_loop<F, E2>(p: &[G1Point<F>], q: &[G2Point<F, E2>]) -> Polynomial<F>
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    assert_eq!(p.len(), q.len());

    let (y_inv, x_neg_over_y) = precompute_consts(p);

    let loop_counter = &F::get_curve_params().loop_counter;

    let mut f = Polynomial::new(vec![
        FieldElement::from(1),
        FieldElement::from(0),
        FieldElement::from(0),
        FieldElement::from(0),
        FieldElement::from(0),
        FieldElement::from(0),
        FieldElement::from(0),
        FieldElement::from(0),
        FieldElement::from(0),
        FieldElement::from(0),
        FieldElement::from(0),
        FieldElement::from(0),
    ]);
    let mut qs;

    let mut q_neg = vec![];
    if loop_counter.contains(&-1) {
        for point in q {
            q_neg.push(point.neg());
        }
    }

    let start_index = loop_counter.len() - 2;

    if loop_counter[start_index] == 1 {
        (f, qs) = bit_1_init_case(&f, q, &y_inv, &x_neg_over_y);
    } else if loop_counter[start_index] == 0 {
        (f, qs) = bit_0_case(&f, q, &y_inv, &x_neg_over_y);
    } else {
        unimplemented!();
    }

    for i in (0..start_index).rev() {
        if loop_counter[i] == 0 {
            (f, qs) = bit_0_case(&f, &qs, &y_inv, &x_neg_over_y);
        } else if loop_counter[i] == 1 || loop_counter[i] == -1 {
            let mut q_selects = vec![];
            for k in 0..q.len() {
                q_selects.push(if loop_counter[i] == 1 {
                    q[k].clone()
                } else {
                    q_neg[k].clone()
                });
            }
            (f, qs) = bit_1_case(&f, &qs, &q_selects, &y_inv, &x_neg_over_y);
        } else {
            unimplemented!();
        }
    }

    let curve_id = F::get_curve_params().curve_id;
    match curve_id {
        CurveID::BN254 => {
            let mut lines = bn254_finalize_step(&qs, q, &y_inv, &x_neg_over_y);
            lines.insert(0, f);
            f = extf_mul(lines, None, None, None);
        }
        CurveID::BLS12_381 => {
            f = conjugate_e12d(f);
        }
        _ => unimplemented!(),
    }

    f
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::algebra::extf_mul::{from_e2, to_e2};
    use crate::definitions::{BLS12381PrimeField, BN254PrimeField};

    #[test]
    fn test_extf_mul_1() {
        let p = [
            [
                "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
            ],
            [
                "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
            ],
            [
                "0x1",
                "0x3049ed443e0ee79060270c9094ac6390a5c1ab3db65328a47174c6c33f6bd5f2",
                "0x0",
                "0xa279a60d390f263fa2b23afda6a2160c7af52ea6fdddb7ffe26ded0e216c821",
                "0x0",
                "0x0",
                "0x0",
                "0x146bccf3dc47e8eedf574326c5188ea8e4978a568116c9aa5b8517cdeb0e1f38",
                "0x0",
                "0x10b71d55b795eb0c1590286e48c412e3434b0def1afddfc8840541b6936825fd",
                "0x0",
                "0x0",
            ],
            [
                "0x1",
                "0x10b80d23f4e55970de219c8bb6cc99af9ca48837a7da389ff6e02693c8912bf3",
                "0x0",
                "0x1999e3b5911b71ef05b218f5be987ba6f43afb6a702ffca89c7a6643b411046f",
                "0x0",
                "0x0",
                "0x0",
                "0x2a00794e593076aab0ec5e6283a9ed0ddbe6ef97af88861febd351722d50802a",
                "0x0",
                "0x22583e5a131ce5504fbb720b2081781441eeb10978efac409e27787d1fa359b6",
                "0x0",
                "0x0",
            ],
        ];
        let xf = [
            "0x11d12be7502f97a642a86eb73802fe0fe4772283c9e66f3d535534c22390e0ca",
            "0x109dabf551c2a0d785f86365c9f7a4e2aae4c8e3f5bb96b72c3461402f80049e",
            "0x15e06e6b765f21da4c21d50705a9bf0f72ba0283f93e75a896235fa107d4ca4d",
            "0x23c17e1664ac6452ffdd3ca599029d07bbea4e54e00dd8289aa145149627cc90",
            "0x751d37ad50cc00d6245f08ca81ce16f9a3714c3efe87c95ae8e132234b5dd07",
            "0x0",
            "0x1535e3c0e51be5f14093e8501425031896dfb26ec8759e3409e44e94d81e17cf",
            "0xe07f7cf5446bf6fd7f35bd2c741235928fd0f5cc82d853d0b37dd293fe1a21b",
            "0x2eae2d9b2332fb1f1c3617826ac6ede574d04ed01692a36b9743fc604b3f3bf",
            "0x2ab0d3ce9813032acfb54c2e7c43299edb854672b7bc17be60c2e1cda8e826c",
            "0x1f316d8807400efe60a15b7e5311a9031439eb344c0d84fb80044f8786d59de4",
            "0x0",
        ];
        let p: Vec<Polynomial<BN254PrimeField>> = p
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xf = Polynomial::new(
            xf.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let f = extf_mul(p, None, None, None);
        assert_eq!(f, xf);
    }

    #[test]
    fn test_extf_mul_2() {
        let p = [["0xc71fb5b76cf57e5c7c9dbbd201062289f97dedce8bbb72d15abaec86c40039d3b4f3fccb7338ff3e7701b7f6619769b", "0x129a0a7e9efe3f397b5dbcae1f22f39c0cbcf4d183ead8de682a7571560cc28f2c13ecc7628b11dda4fcc3eaef203a45", "0x162ca20e57a4ad07f919b85c9975acd11d5f0cddd22192ebc465e5a89a0546be2ec98581fcda54c808aa8790189addd6", "0x10a05ef6bc41b1ac2ba68a585a4c7016589ffad9c5412bf00fd0f50f8ac9ea3d9a7db639e62eae3ca960447fb588a60b", "0x16dbc5bd5769b32d94959f3a71085f5adc66454928e158caeecda06706afd32cea844001820431c1f3534760c01c3ce5", "0x199988fcc386f48448a34d747599bd68a9bb4993cc0e6d2434e9182475096fe323352ae743be4cec47278fbbb8d52f52", "0x189109c92dac219f6b362d169e4ca995bbd0536c8727610f0f361f3490e9d41a94c69d397c1401b31b5a973bc393f3b1", "0x19ea64dde64bbb01d1072ca0532cbe26f8227deaf22155b2ba4bacf79ec45d43bbecca1bb35c6efdd163d6d7ff862979", "0xd9b819680b2cfa830393d2a883cbf07d691020e2a01580c62c9bb1869a1c40317ab6b0df57ff873f2b4bc93d71985e5", "0x704a7bc9193e53c9dde39b3a0a34d0e76345261a4caa612bb3ee39b3715a0d649760f83a32b24cc4b37fe549e80afde", "0x117957ce838607a66a58785c7af8af5a2d3a1832a559f19b20af84c9a5e968cabea23dd6815968b93234b9b34f8108e1", "0xae22d05bd7cd226ba438387b13606f1ad88319c787ccdcec28ab4de6e9bd5fd1ede497ebb746c3313cd6655b961689d"], ["0xc71fb5b76cf57e5c7c9dbbd201062289f97dedce8bbb72d15abaec86c40039d3b4f3fccb7338ff3e7701b7f6619769b", "0x129a0a7e9efe3f397b5dbcae1f22f39c0cbcf4d183ead8de682a7571560cc28f2c13ecc7628b11dda4fcc3eaef203a45", "0x162ca20e57a4ad07f919b85c9975acd11d5f0cddd22192ebc465e5a89a0546be2ec98581fcda54c808aa8790189addd6", "0x10a05ef6bc41b1ac2ba68a585a4c7016589ffad9c5412bf00fd0f50f8ac9ea3d9a7db639e62eae3ca960447fb588a60b", "0x16dbc5bd5769b32d94959f3a71085f5adc66454928e158caeecda06706afd32cea844001820431c1f3534760c01c3ce5", "0x199988fcc386f48448a34d747599bd68a9bb4993cc0e6d2434e9182475096fe323352ae743be4cec47278fbbb8d52f52", "0x189109c92dac219f6b362d169e4ca995bbd0536c8727610f0f361f3490e9d41a94c69d397c1401b31b5a973bc393f3b1", "0x19ea64dde64bbb01d1072ca0532cbe26f8227deaf22155b2ba4bacf79ec45d43bbecca1bb35c6efdd163d6d7ff862979", "0xd9b819680b2cfa830393d2a883cbf07d691020e2a01580c62c9bb1869a1c40317ab6b0df57ff873f2b4bc93d71985e5", "0x704a7bc9193e53c9dde39b3a0a34d0e76345261a4caa612bb3ee39b3715a0d649760f83a32b24cc4b37fe549e80afde", "0x117957ce838607a66a58785c7af8af5a2d3a1832a559f19b20af84c9a5e968cabea23dd6815968b93234b9b34f8108e1", "0xae22d05bd7cd226ba438387b13606f1ad88319c787ccdcec28ab4de6e9bd5fd1ede497ebb746c3313cd6655b961689d"], ["0xed2ad16fd30c6bae9d4659d084faa4e8bbce72d77ce2867a8ccd2916078758f11a33bf3f6acad21af21aafd4dbe67c1", "0x0", "0x143159d9a3967261ec92e14b1108686052cbe30a24c1142a087b498252aaef8b03b69ea297bc174eb69de56e7a594cfa", "0x1", "0x0", "0x0", "0xd2c6c6d4383235e52ea373e1add3c36becb732dbd0fae843b6a12f2841cfa4243dd3bead4e582e60c1e81c3f4db03bb", "0x0", "0x5dd1d6911248fb5ef5a2e4f99c1f90767186060eda81b7f490cc99583db6989183cc9884244bc5b62a507c413c93e2e", "0x0", "0x0", "0x0"], ["0x4ca59a9615490d4871ae113788793a0ef5c6dbbfb2602731932d16dd279f227782505589090120984a32f00d5c17317", "0x0", "0x9649308cd68a27b4e25e3702dab91e62890a1fb24fa7318b413f60fc7b95245612a76f802df69650a6d78458addb193", "0x1", "0x0", "0x0", "0x6d3c6b1903e1d11b99026fac6088b42737e0e7cddf5e95d20f6b7b05c13589063d20aefc27a91c014a7b5f49957ff", "0x0", "0xc9fb3306280d86d70eb3b713248de91c6d4ef90148d3c2300b3d6b19df197e00e70af98bcd050a431a8c58b53832815", "0x0", "0x0", "0x0"]];
        let xf = ["0x1913c7c566f59082bc8178020dbab618db967238ea9cd35f30a48e8f4e37b31fa826f2ce8023e3f492da64e7fc430262", "0xe88184d680a3c04ed182e6b263c806982325a7601dab1e928ee1cf7c98a702c77ef44f6202e8049b3eb05d0d530416d", "0x133b8d475abdbde6aa5ce6524599001bdebe394bd4b3c7a7c62a4c736176f27fabcb165d0e9db88c3aa8af04ac87b690", "0xff88e1756ceadda3075ef7ac6f1764de912e15b03a34e439b837bfa984174e90399e3fbda93a12cc209b1ed1469ab6f", "0xa2e5dd0e5330c07becfea58e47106140d177f1b1241de5c1e752050408f4970ed1275db43a9c3cc8b4f393a72148638", "0x1124c5ec5de53991b87616d2e433c3387e4ea68342f9713bcf93e2be0ff2b07e03ff0091e0ff71ae050db38a10394cca", "0x47203ee35055ffa8e288c3da40c9831b46d6c7b911ea92ee62d4af79903c75831bb79321155920b413155ca1f2424bf", "0x180ccf08a53eb9416fc958429dfea456e5e802217f5f5ecc44653622720256512e4c7f01efa251cd28065c103db44f11", "0xf4e1f72f26c9590b43bc7b7c45fff374a786d462f2dc275bc0812c9a26969ce0bd7d8fc5a90a9fa47cb7f40320d6418", "0x134043dade475ebc5c796603d3ae7161f7f06e07e968716ea64520685e44705bd9221f8d7d7b0b9e2d131576fdb3af44", "0x19ceec83acdc521e6a9dbf17392e097e01a2685cc2c9d7f3f1430e22221070d222e599ac3e9142d486383eec146b8dac", "0x7ca2e9db2452cc19c71ff5049bdd024819954fb83f0f903169da844e8fe4a584031b750f0678f8661f1c1e1f4653a84"];
        let p: Vec<Polynomial<BLS12381PrimeField>> = p
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xf = Polynomial::new(
            xf.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let f = extf_mul(p, None, None, None);
        assert_eq!(f, xf);
    }

    #[test]
    fn test_extf_inv_1() {
        let c = [
            "0x14156ca1853095df27f3cb7c50eca75e794d2f14195c16df4a0f8f9dcb48bee9",
            "0xdc2a20a6107d4c49fed6b2018946bcc2a8dad06f01d099a6df0a4a55ed21b59",
            "0x14260c5afb0b1148ed80f8339cf9e06ff04257cb6c1817c4efa721fc98f69503",
            "0xafe8a09df07bf3dffefe512eb9448ef436dd090f98323135baab8ae3c766c60",
            "0x114692950f53d4f707bb02cc2b5dc98aff5936811707d6579371dae20368253c",
            "0x2dd3fca72591963149646f1e106dc0ee917551f5a9da397fe12d4a3939ce650c",
            "0x1750bd450b85cbd62ea3f1b228beff5fd364a127d6054be99a9248497b82062a",
            "0x1248cfad33a2147726169d3ce55db12ecafd74bc4b83377c168d89b919386546",
            "0x28d156bac04e64938816b055888399c99a954b82724e5f5589d549a709b2b5ef",
            "0x39e1ab153bd709556afece475580f453f9126f256fbb49c235bc75082f5f26e",
            "0x14853f940bf5c557c7f558d3e74e6617d7f08b54fd83597fed1d7e7b9d09e04",
            "0xaa480d613601947fee14a3ce2b7af4e1872fe49ae3473546aa01a618b78b125",
        ];
        let xi = [[
            "0x13e8e196ed7970229c16369f6f62a54fe9848ec0abbb56e77355358805db92a6",
            "0x29aa20be8afc3104b3211fb1c2636e3291bca41e1276bdbbb485917fae34c150",
            "0xcbdf387c0036815f944eeedb8a3ed8babb406326444cbed0df3e47fc7a3f440",
            "0xcc614e3d877550dc9bb19f8dfdc513f2f8fed01d3a180a2a9e475c9a29f6d96",
            "0x1a6e474f0a5394b39bd15f2390e0cfa64391cb4ffc5d435a63028ac3c744d064",
            "0x8fc0b38f1129ab34ebd5a5888f0711adecaecc7aa5312cc62508d51da03aa1e",
            "0xff9b26cf44e068601c663a62662f0ef698166a3410d4f36a68b2e46800daa6e",
            "0xf4ec161da901a5ab3f6088ede93acdbf15f0c18b653b9f7146d132c6d4111c5",
            "0x1843faa07a91bed2c949f1b3f126e0ae88d429bf7d37b5e00696b22be53ac607",
            "0x1c151df931008732415af45f4616affed9e0e64976e66cc5e2e57c799ddfa646",
            "0x1526c80d7045ccb0ae04a7cf1de7a2519ad52f885c7b9acb7bed0d027459433",
        ]];
        let xj = [[
            "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
        ]];
        let xc = [
            "0x1d7a9ffbbe137d697794dbccbd7925ea98507cf8d4445d3e89123811ede12825",
            "0x1f45aa2ee73f15e275e5c1fc0ff08be0981a61d8e7642301653a6307c7467811",
            "0x2446d99f276e4c8bc63d81e8d0c1e37c901a5a569865533968e39b5083fc576e",
            "0x223bd50b771fcaa905131a5f04c3c634c9df344731b5aada49be919aaa447cc7",
            "0x24cfef2958a7c9c4d7ddfacdd59750105dcc37f6aefbf4a9ce706bc36252c47",
            "0x3a974db52b274684955cb370b0ac66e3e295ea6e9789fb7259c294210f7720e",
            "0x160b7346ec9fdd9841feb355a44845dc30c2a9ae3fb8266ad697b531de5e2fb6",
            "0xe46af84e1cbba805f204fa5ce1c9a99c79799110a56b5d534495a358f9c739f",
            "0x1f2b5709d0d7c9499b9524e9708ac412d3fa05fea9b51192113e131bd5572a21",
            "0x8a75eef583ffc3b0f690cd9eab121b1f329194c1052a86d50224b92838c5d76",
            "0xef3a64570d17038de7ec74175c125ac7e8780509764f07572ce9593878da9fb",
            "0x2a6290607745b58a7b87bc78053320664e06d12b35825f15893ad52a39f54331",
        ];
        let c = c
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let c = Polynomial::new(c);
        let xc = Polynomial::new(
            xc.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xi = xi
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xj = xj
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let mut i = vec![];
        let mut j = vec![];
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree12ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree6ExtensionField;
        let c = extf_inv::<
            BN254PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(&c, Some(&mut i), Some(&mut j));
        assert_eq!(c, xc);
        assert_eq!(i, xi);
        assert_eq!(j, xj);
    }

    #[test]
    fn test_precompute_consts_1() {
        let p = [
            (
                "0x1d0634f3f21e7890d1df87eab84852372b905c9ccdb6d03cb7b9a5409b7efcd8",
                "0x24c53532773dce26eb3f1d6ba3b10e2b53dc193baa1d4f4d3021032564460978",
            ),
            (
                "0x2585e4f8a31664cbfc531bccffafcf1e59d91fb9536c985db33c69f7c242e07a",
                "0x1d2d2799db056ed14f48d341183118d68ea4131357fa42444057cf0c1d62ae3c",
            ),
        ];
        let y = [
            "0x1ab9de59fc825e8b5326694c7d82556785cb9cbfd0d0a11721d1972c21c411f8",
            "0x16a475582082ae3616c808acd62684170d9fa7bf234110353e9cbceca19d2c69",
        ];
        let x = [
            "0x27783160c70b7ac760cff888c621846a7ed80e50c7ea8a7a718a4ad8a50886fb",
            "0x10a6d46618419682152a25b5f819b22c2e572d1f670d12026a18c384248dad2f",
        ];
        let p = p
            .into_iter()
            .map(|(x, y)| {
                G1Point::new(
                    FieldElement::<BN254PrimeField>::from_hex(x).unwrap(),
                    FieldElement::<BN254PrimeField>::from_hex(y).unwrap(),
                )
                .unwrap()
            })
            .collect::<Vec<_>>();
        let xy = y
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xx = x
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let (y, x) = precompute_consts(&p);
        assert_eq!(y.to_vec(), xy);
        assert_eq!(x.to_vec(), xx);
    }

    #[test]
    fn test_precompute_consts_2() {
        let p = [("0x59d2a79bda5f8a941d4db9e360a80121d5ef96fd687003db24ddec0e0c3b63d82efa81fe174bb39be8658ef83c8c2d", "0x2df47e8cdf189985d5085bdcebb5ee96e40a033f5d3b7986f6992be16bc35f88c471acf7f68344f543e52fe891285a9"), ("0x105dcc4dce3960447d21d3c1dc39e973aaf31de52219df089bb5f797ac6d3395b71420b50de4f62a6588c9401ffefbd3", "0x17cb6c41f0c4e1a7394ab62a9db0be660d847ccc58358f3f9b63c98d9a7845c52e1e2b0faefd0d854043fd325dd3c34f")];
        let y = ["0x6ce420ceafa50ff15baa710e1633d7893404a18b69ef5316a81b182dadbe66bb0ef4fe49ffa578c7698795e6d4a12cb", "0xf45ba6de68a0f1ab26ba5fac564f3f21a75239243fae800e2a8665fd9699e2795c674834c6ce016370aee9e4a1d38d1"];
        let x = ["0x7f2db8fbcf121365e92ce3d77bf5d9a3537b5422e894c09e00053ace96a5403a8db66fbe03950e93033c5874bbe8046", "0xb190c99770f69f3e912d3ef69f63e082a05a1e63b50eb9a5de3e07b14aed7eded07b2f2b3c42c7e365d2a47945fc285"];
        let p = p
            .into_iter()
            .map(|(x, y)| {
                G1Point::new(
                    FieldElement::<BLS12381PrimeField>::from_hex(x).unwrap(),
                    FieldElement::<BLS12381PrimeField>::from_hex(y).unwrap(),
                )
                .unwrap()
            })
            .collect::<Vec<_>>();
        let xy = y
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xx = x
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let (y, x) = precompute_consts(&p);
        assert_eq!(y.to_vec(), xy);
        assert_eq!(x.to_vec(), xx);
    }

    #[test]
    fn test_build_sparse_line_eval_1() {
        let r0 = [
            "0x237db2935c4432bc98005e68cacde68a193b54e64d347301094edcbfa224d3d5",
            "0x124077e14a7d826a707c3ec1809ae9bafafa05dd6b4ba735fba44e801d415637",
        ];
        let r1 = [
            "0x3b7178c857630da7676d0000961488f8fbce03349a8dc1dd6e067932b6a7e0d",
            "0x2b17c2b12c26fdd0e3520b9dfa601ead6f0bf9cd98c81278efe1e96b86397652",
        ];
        let y = "0x1ab9de59fc825e8b5326694c7d82556785cb9cbfd0d0a11721d1972c21c411f8";
        let x = "0x27783160c70b7ac760cff888c621846a7ed80e50c7ea8a7a718a4ad8a50886fb";
        let xl = [
            "0x1",
            "0x3049ed443e0ee79060270c9094ac6390a5c1ab3db65328a47174c6c33f6bd5f2",
            "0x0",
            "0xa279a60d390f263fa2b23afda6a2160c7af52ea6fdddb7ffe26ded0e216c821",
            "0x0",
            "0x0",
            "0x0",
            "0x146bccf3dc47e8eedf574326c5188ea8e4978a568116c9aa5b8517cdeb0e1f38",
            "0x0",
            "0x10b71d55b795eb0c1590286e48c412e3434b0def1afddfc8840541b6936825fd",
            "0x0",
            "0x0",
        ];
        let r0 = r0
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let r1 = r1
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xl = Polynomial::new(
            xl.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let r0: [FieldElement<BN254PrimeField>; 2] = r0.try_into().unwrap();
        let r1: [FieldElement<BN254PrimeField>; 2] = r1.try_into().unwrap();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        let r0 = to_e2::<BN254PrimeField, Degree2ExtensionField>(r0);
        let r1 = to_e2::<BN254PrimeField, Degree2ExtensionField>(r1);
        let y = FieldElement::<BN254PrimeField>::from_hex(y).unwrap();
        let x = FieldElement::<BN254PrimeField>::from_hex(x).unwrap();
        let l = build_sparse_line_eval(&r0, &r1, &y, &x);
        assert_eq!(l, xl);
    }

    #[test]
    fn test_build_sparse_line_eval_2() {
        let r0 = ["0x56ceab5d5d994dee0ca07fc0d41aa908b1a833b94e768d2dec05cffe4a869aed2a64ee86a72f085ee4e78bd4c2aef8e", "0x39b596a976f556e5ea4016a3111e14b674a67295a242cf3b343a6878db6ec20bcac1275d23aad6cd3e84e398a4e7bc8"];
        let r1 = ["0x4786cc02b147d13e701c1f52827dbba9d5d8516fb557dfb71bc60f1a68459eb52df6a9219fcdcac7feb1f0edbefdbf8", "0x145f508c63c10d270e027b2b0bf6789475132950c583823a43387d10f8329296e43e6610cb7555c0db86510eb99cfadd"];
        let y = "0x6ce420ceafa50ff15baa710e1633d7893404a18b69ef5316a81b182dadbe66bb0ef4fe49ffa578c7698795e6d4a12cb";
        let x = "0x7f2db8fbcf121365e92ce3d77bf5d9a3537b5422e894c09e00053ace96a5403a8db66fbe03950e93033c5874bbe8046";
        let xl = ["0xed2ad16fd30c6bae9d4659d084faa4e8bbce72d77ce2867a8ccd2916078758f11a33bf3f6acad21af21aafd4dbe67c1", "0x0", "0x143159d9a3967261ec92e14b1108686052cbe30a24c1142a087b498252aaef8b03b69ea297bc174eb69de56e7a594cfa", "0x1", "0x0", "0x0", "0xd2c6c6d4383235e52ea373e1add3c36becb732dbd0fae843b6a12f2841cfa4243dd3bead4e582e60c1e81c3f4db03bb", "0x0", "0x5dd1d6911248fb5ef5a2e4f99c1f90767186060eda81b7f490cc99583db6989183cc9884244bc5b62a507c413c93e2e", "0x0", "0x0", "0x0"];
        let r0 = r0
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let r1 = r1
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xl = Polynomial::new(
            xl.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let r0: [FieldElement<BLS12381PrimeField>; 2] = r0.try_into().unwrap();
        let r1: [FieldElement<BLS12381PrimeField>; 2] = r1.try_into().unwrap();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        let r0 = to_e2::<BLS12381PrimeField, Degree2ExtensionField>(r0);
        let r1 = to_e2::<BLS12381PrimeField, Degree2ExtensionField>(r1);
        let y = FieldElement::<BLS12381PrimeField>::from_hex(y).unwrap();
        let x = FieldElement::<BLS12381PrimeField>::from_hex(x).unwrap();
        let l = build_sparse_line_eval(&r0, &r1, &y, &x);
        assert_eq!(l, xl);
    }

    #[test]
    fn test_bit_0_case_1() {
        let f = [
            "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
        ];
        let q = [
            (
                "0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed",
                "0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2",
                "0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa",
                "0x90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b",
            ),
            (
                "0x1314aaf1c372e6d7635e573808d9d5c7178bdce7335eb0538f718d8e6651eeb1",
                "0x14c25d3aec745e5a2d4aba9e1448a8cc1048d01a5289f29ccc5acf5e81526673",
                "0x397391b7b25e2fba7d1de6d86501d49b6a8dab10d1d0efd5869ecd23aab8e9",
                "0x1863ac65eca09e89b058c1ff7e4c5c7ec7e5859b385a553ea12434f4eda6db36",
            ),
        ];
        let y = [
            "0x1ab9de59fc825e8b5326694c7d82556785cb9cbfd0d0a11721d1972c21c411f8",
            "0x16a475582082ae3616c808acd62684170d9fa7bf234110353e9cbceca19d2c69",
        ];
        let x = [
            "0x27783160c70b7ac760cff888c621846a7ed80e50c7ea8a7a718a4ad8a50886fb",
            "0x10a6d46618419682152a25b5f819b22c2e572d1f670d12026a18c384248dad2f",
        ];
        let xf = [
            "0x11d12be7502f97a642a86eb73802fe0fe4772283c9e66f3d535534c22390e0ca",
            "0x109dabf551c2a0d785f86365c9f7a4e2aae4c8e3f5bb96b72c3461402f80049e",
            "0x15e06e6b765f21da4c21d50705a9bf0f72ba0283f93e75a896235fa107d4ca4d",
            "0x23c17e1664ac6452ffdd3ca599029d07bbea4e54e00dd8289aa145149627cc90",
            "0x751d37ad50cc00d6245f08ca81ce16f9a3714c3efe87c95ae8e132234b5dd07",
            "0x0",
            "0x1535e3c0e51be5f14093e8501425031896dfb26ec8759e3409e44e94d81e17cf",
            "0xe07f7cf5446bf6fd7f35bd2c741235928fd0f5cc82d853d0b37dd293fe1a21b",
            "0x2eae2d9b2332fb1f1c3617826ac6ede574d04ed01692a36b9743fc604b3f3bf",
            "0x2ab0d3ce9813032acfb54c2e7c43299edb854672b7bc17be60c2e1cda8e826c",
            "0x1f316d8807400efe60a15b7e5311a9031439eb344c0d84fb80044f8786d59de4",
            "0x0",
        ];
        let xp = [
            (
                "0x27dc7234fd11d3e8c36c59277c3e6f149d5cd3cfa9a62aee49f8130962b4b3b9",
                "0x203e205db4f19b37b60121b83a7333706db86431c6d835849957ed8c3928ad79",
                "0x4bb53b8977e5f92a0bc372742c4830944a59b4fe6b1c0466e2a6dad122b5d2e",
                "0x195e8aa5b7827463722b8c153931579d3505566b4edf48d498e185f0509de152",
            ),
            (
                "0x19092b3d714b3bb6599b735386dd05eab401e72057bab79773a6de8f5693387b",
                "0x1acb3fbdde3ce471791558747f0e52b1b7a708834dc533393bcfc2af317703ee",
                "0x258d7966e4b36382460549a44d5cbe96fbe1c412e36f25218438f72d7d387077",
                "0x2a58bf6a639ae104439ba4e8db873938a26fcd5bd0b68beb20c44705d9820860",
            ),
        ];
        let f = Polynomial::new(
            f.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let q = q
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                G2Point::new(
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
                .unwrap()
            })
            .collect::<Vec<_>>();
        let y = y
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let x = x
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xf = Polynomial::new(
            xf.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xp = xp
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                (
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
            })
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        let (f, p) = bit_0_case::<BN254PrimeField, Degree2ExtensionField>(&f, &q, &y, &x);
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
    }

    #[test]
    fn test_bit_0_case_2() {
        let f = ["0xc71fb5b76cf57e5c7c9dbbd201062289f97dedce8bbb72d15abaec86c40039d3b4f3fccb7338ff3e7701b7f6619769b", "0x129a0a7e9efe3f397b5dbcae1f22f39c0cbcf4d183ead8de682a7571560cc28f2c13ecc7628b11dda4fcc3eaef203a45", "0x162ca20e57a4ad07f919b85c9975acd11d5f0cddd22192ebc465e5a89a0546be2ec98581fcda54c808aa8790189addd6", "0x10a05ef6bc41b1ac2ba68a585a4c7016589ffad9c5412bf00fd0f50f8ac9ea3d9a7db639e62eae3ca960447fb588a60b", "0x16dbc5bd5769b32d94959f3a71085f5adc66454928e158caeecda06706afd32cea844001820431c1f3534760c01c3ce5", "0x199988fcc386f48448a34d747599bd68a9bb4993cc0e6d2434e9182475096fe323352ae743be4cec47278fbbb8d52f52", "0x189109c92dac219f6b362d169e4ca995bbd0536c8727610f0f361f3490e9d41a94c69d397c1401b31b5a973bc393f3b1", "0x19ea64dde64bbb01d1072ca0532cbe26f8227deaf22155b2ba4bacf79ec45d43bbecca1bb35c6efdd163d6d7ff862979", "0xd9b819680b2cfa830393d2a883cbf07d691020e2a01580c62c9bb1869a1c40317ab6b0df57ff873f2b4bc93d71985e5", "0x704a7bc9193e53c9dde39b3a0a34d0e76345261a4caa612bb3ee39b3715a0d649760f83a32b24cc4b37fe549e80afde", "0x117957ce838607a66a58785c7af8af5a2d3a1832a559f19b20af84c9a5e968cabea23dd6815968b93234b9b34f8108e1", "0xae22d05bd7cd226ba438387b13606f1ad88319c787ccdcec28ab4de6e9bd5fd1ede497ebb746c3313cd6655b961689d"];
        let q = [("0x122915c824a0857e2ee414a3dccb23ae691ae54329781315a0c75df1c04d6d7a50a030fc866f09d516020ef82324afae", "0x9380275bbc8e5dcea7dc4dd7e0550ff2ac480905396eda55062650f8d251c96eb480673937cc6d9d6a44aaa56ca66dc", "0xb21da7955969e61010c7a1abc1a6f0136961d1e3b20b1a7326ac738fef5c721479dfd948b52fdf2455e44813ecfd892", "0x8f239ba329b3967fe48d718a36cfe5f62a7e42e0bf1c1ed714150a166bfbd6bcf6b3b58b975b9edea56d53f23a0e849"), ("0x893227b499dab30e15b606ec3c375f9fabf7fbb574b9b11c9eefbe33fae82066297e23c518f59e74d5cf646cec6464f", "0x10578234a81819d1ebb3d77b03a128f3165642386fff1b0a74ad73c139425703a991ce459cdc1995351adff98061f0ea", "0x16efa85752a02d4358a92eb3b577c1e27a02ec36000c44403159baf7022541a02104b633549e05b774e1b76343a8e661", "0xaf65df48a519d9209257e3df9fb0a1bd3491799091df954380242592db0bead0ddd62dbe33aeeaf1d4a63bdbc4c6008")];
        let y = ["0x6ce420ceafa50ff15baa710e1633d7893404a18b69ef5316a81b182dadbe66bb0ef4fe49ffa578c7698795e6d4a12cb", "0xf45ba6de68a0f1ab26ba5fac564f3f21a75239243fae800e2a8665fd9699e2795c674834c6ce016370aee9e4a1d38d1"];
        let x = ["0x7f2db8fbcf121365e92ce3d77bf5d9a3537b5422e894c09e00053ace96a5403a8db66fbe03950e93033c5874bbe8046", "0xb190c99770f69f3e912d3ef69f63e082a05a1e63b50eb9a5de3e07b14aed7eded07b2f2b3c42c7e365d2a47945fc285"];
        let xf = ["0x1913c7c566f59082bc8178020dbab618db967238ea9cd35f30a48e8f4e37b31fa826f2ce8023e3f492da64e7fc430262", "0xe88184d680a3c04ed182e6b263c806982325a7601dab1e928ee1cf7c98a702c77ef44f6202e8049b3eb05d0d530416d", "0x133b8d475abdbde6aa5ce6524599001bdebe394bd4b3c7a7c62a4c736176f27fabcb165d0e9db88c3aa8af04ac87b690", "0xff88e1756ceadda3075ef7ac6f1764de912e15b03a34e439b837bfa984174e90399e3fbda93a12cc209b1ed1469ab6f", "0xa2e5dd0e5330c07becfea58e47106140d177f1b1241de5c1e752050408f4970ed1275db43a9c3cc8b4f393a72148638", "0x1124c5ec5de53991b87616d2e433c3387e4ea68342f9713bcf93e2be0ff2b07e03ff0091e0ff71ae050db38a10394cca", "0x47203ee35055ffa8e288c3da40c9831b46d6c7b911ea92ee62d4af79903c75831bb79321155920b413155ca1f2424bf", "0x180ccf08a53eb9416fc958429dfea456e5e802217f5f5ecc44653622720256512e4c7f01efa251cd28065c103db44f11", "0xf4e1f72f26c9590b43bc7b7c45fff374a786d462f2dc275bc0812c9a26969ce0bd7d8fc5a90a9fa47cb7f40320d6418", "0x134043dade475ebc5c796603d3ae7161f7f06e07e968716ea64520685e44705bd9221f8d7d7b0b9e2d131576fdb3af44", "0x19ceec83acdc521e6a9dbf17392e097e01a2685cc2c9d7f3f1430e22221070d222e599ac3e9142d486383eec146b8dac", "0x7ca2e9db2452cc19c71ff5049bdd024819954fb83f0f903169da844e8fe4a584031b750f0678f8661f1c1e1f4653a84"];
        let xp = [("0x19e384121b7d70927c49e6d044fd8517c36bc6ed2813a8956dd64f049869e8a77f7e46930240e6984abe26fa6a89658f", "0x3f4b4e761936d90fd5f55f99087138a07a69755ad4a46e4dd1c2cfe6d11371e1cc033111a0595e3bba98d0f538db451", "0x17a31a4fccfb5f768a2157517c77a4f8aaf0dee8f260d96e02e1175a8754d09600923beae02a019afc327b65a2fdbbfc", "0x88bb5832f4a4a452edda646ebaa2853a54205d56329960b44b2450070734724a74daaa401879bad142132316e9b3401"), ("0x1604bd06ba18d6d65bdd88e22c26eaef8a620a1a9fefe016d00eac356f9ceda8bc8eee5e46f9f4736ab22cff0e8cb9e8", "0x3e5755e9bfc250ff0a03efea22428a36a247504e613980918dc5319efb7f66b10d5fe2e7e86af7e014e1456aeaeac5f", "0x5655a99f7ff904c1e41382c25ff0360d9c51d0e331bfb1e38f5dd41c6909caaf6e313f47f727922109bf8c3204fe274", "0x62ec2ed9b207f63e0d9899ed11f9a125b472586b65bb77b8a04d5d446d15a8701ba5c361a07cd85e0743f5ae2e95a9f")];
        let f = Polynomial::new(
            f.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let q = q
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                G2Point::new(
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
                .unwrap()
            })
            .collect::<Vec<_>>();
        let y = y
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let x = x
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xf = Polynomial::new(
            xf.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xp = xp
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                (
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
            })
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        let (f, p) = bit_0_case::<BLS12381PrimeField, Degree2ExtensionField>(&f, &q, &y, &x);
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
    }

    #[test]
    fn test_bit_1_init_case_1() {
        let f = [
            "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
        ];
        let q = [("0x24aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8", "0x13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e", "0xce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801", "0x606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be"), ("0x82dc9154807866eb0f36ccb665a5fc010510bd690ddd7b540e5bf3ff02d81e98b75703a3b3d3c305a70960906e6cb09", "0xdd18d077ad5bd58dabb18d84a6ceebe6375a83dd242851bb4dcf956002c4efb974ffceee6709deb0dcf81d4285e5e60", "0x4a468eb9e206b9833d8e8e2197d3446652372ce5ef50e93c91aa58105d3a281b2e84ddb61535fe1a90bae7e6692f9b0", "0x198fd0ab6249082bf7007d7e8be8992de81f47ae3341c590194fa3bf769a2e5a5253527727115c334e82ed4be8da6c10")];
        let y = ["0x6ce420ceafa50ff15baa710e1633d7893404a18b69ef5316a81b182dadbe66bb0ef4fe49ffa578c7698795e6d4a12cb", "0xf45ba6de68a0f1ab26ba5fac564f3f21a75239243fae800e2a8665fd9699e2795c674834c6ce016370aee9e4a1d38d1"];
        let x = ["0x7f2db8fbcf121365e92ce3d77bf5d9a3537b5422e894c09e00053ace96a5403a8db66fbe03950e93033c5874bbe8046", "0xb190c99770f69f3e912d3ef69f63e082a05a1e63b50eb9a5de3e07b14aed7eded07b2f2b3c42c7e365d2a47945fc285"];
        let xf = ["0xc71fb5b76cf57e5c7c9dbbd201062289f97dedce8bbb72d15abaec86c40039d3b4f3fccb7338ff3e7701b7f6619769b", "0x129a0a7e9efe3f397b5dbcae1f22f39c0cbcf4d183ead8de682a7571560cc28f2c13ecc7628b11dda4fcc3eaef203a45", "0x162ca20e57a4ad07f919b85c9975acd11d5f0cddd22192ebc465e5a89a0546be2ec98581fcda54c808aa8790189addd6", "0x10a05ef6bc41b1ac2ba68a585a4c7016589ffad9c5412bf00fd0f50f8ac9ea3d9a7db639e62eae3ca960447fb588a60b", "0x16dbc5bd5769b32d94959f3a71085f5adc66454928e158caeecda06706afd32cea844001820431c1f3534760c01c3ce5", "0x199988fcc386f48448a34d747599bd68a9bb4993cc0e6d2434e9182475096fe323352ae743be4cec47278fbbb8d52f52", "0x189109c92dac219f6b362d169e4ca995bbd0536c8727610f0f361f3490e9d41a94c69d397c1401b31b5a973bc393f3b1", "0x19ea64dde64bbb01d1072ca0532cbe26f8227deaf22155b2ba4bacf79ec45d43bbecca1bb35c6efdd163d6d7ff862979", "0xd9b819680b2cfa830393d2a883cbf07d691020e2a01580c62c9bb1869a1c40317ab6b0df57ff873f2b4bc93d71985e5", "0x704a7bc9193e53c9dde39b3a0a34d0e76345261a4caa612bb3ee39b3715a0d649760f83a32b24cc4b37fe549e80afde", "0x117957ce838607a66a58785c7af8af5a2d3a1832a559f19b20af84c9a5e968cabea23dd6815968b93234b9b34f8108e1", "0xae22d05bd7cd226ba438387b13606f1ad88319c787ccdcec28ab4de6e9bd5fd1ede497ebb746c3313cd6655b961689d"];
        let xp = [("0x122915c824a0857e2ee414a3dccb23ae691ae54329781315a0c75df1c04d6d7a50a030fc866f09d516020ef82324afae", "0x9380275bbc8e5dcea7dc4dd7e0550ff2ac480905396eda55062650f8d251c96eb480673937cc6d9d6a44aaa56ca66dc", "0xb21da7955969e61010c7a1abc1a6f0136961d1e3b20b1a7326ac738fef5c721479dfd948b52fdf2455e44813ecfd892", "0x8f239ba329b3967fe48d718a36cfe5f62a7e42e0bf1c1ed714150a166bfbd6bcf6b3b58b975b9edea56d53f23a0e849"), ("0x893227b499dab30e15b606ec3c375f9fabf7fbb574b9b11c9eefbe33fae82066297e23c518f59e74d5cf646cec6464f", "0x10578234a81819d1ebb3d77b03a128f3165642386fff1b0a74ad73c139425703a991ce459cdc1995351adff98061f0ea", "0x16efa85752a02d4358a92eb3b577c1e27a02ec36000c44403159baf7022541a02104b633549e05b774e1b76343a8e661", "0xaf65df48a519d9209257e3df9fb0a1bd3491799091df954380242592db0bead0ddd62dbe33aeeaf1d4a63bdbc4c6008")];
        let f = Polynomial::new(
            f.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let q = q
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                G2Point::new(
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
                .unwrap()
            })
            .collect::<Vec<_>>();
        let y = y
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let x = x
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xf = Polynomial::new(
            xf.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xp = xp
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                (
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
            })
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        let (f, p) = bit_1_init_case::<BLS12381PrimeField, Degree2ExtensionField>(&f, &q, &y, &x);
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
    }

    #[test]
    fn test_bit_1_case_1() {
        let f = [
            "0x11d12be7502f97a642a86eb73802fe0fe4772283c9e66f3d535534c22390e0ca",
            "0x109dabf551c2a0d785f86365c9f7a4e2aae4c8e3f5bb96b72c3461402f80049e",
            "0x15e06e6b765f21da4c21d50705a9bf0f72ba0283f93e75a896235fa107d4ca4d",
            "0x23c17e1664ac6452ffdd3ca599029d07bbea4e54e00dd8289aa145149627cc90",
            "0x751d37ad50cc00d6245f08ca81ce16f9a3714c3efe87c95ae8e132234b5dd07",
            "0x0",
            "0x1535e3c0e51be5f14093e8501425031896dfb26ec8759e3409e44e94d81e17cf",
            "0xe07f7cf5446bf6fd7f35bd2c741235928fd0f5cc82d853d0b37dd293fe1a21b",
            "0x2eae2d9b2332fb1f1c3617826ac6ede574d04ed01692a36b9743fc604b3f3bf",
            "0x2ab0d3ce9813032acfb54c2e7c43299edb854672b7bc17be60c2e1cda8e826c",
            "0x1f316d8807400efe60a15b7e5311a9031439eb344c0d84fb80044f8786d59de4",
            "0x0",
        ];
        let q = [
            (
                "0x27dc7234fd11d3e8c36c59277c3e6f149d5cd3cfa9a62aee49f8130962b4b3b9",
                "0x203e205db4f19b37b60121b83a7333706db86431c6d835849957ed8c3928ad79",
                "0x4bb53b8977e5f92a0bc372742c4830944a59b4fe6b1c0466e2a6dad122b5d2e",
                "0x195e8aa5b7827463722b8c153931579d3505566b4edf48d498e185f0509de152",
            ),
            (
                "0x19092b3d714b3bb6599b735386dd05eab401e72057bab79773a6de8f5693387b",
                "0x1acb3fbdde3ce471791558747f0e52b1b7a708834dc533393bcfc2af317703ee",
                "0x258d7966e4b36382460549a44d5cbe96fbe1c412e36f25218438f72d7d387077",
                "0x2a58bf6a639ae104439ba4e8db873938a26fcd5bd0b68beb20c44705d9820860",
            ),
        ];
        let s = [
            (
                "0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed",
                "0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2",
                "0x1d9befcd05a5323e6da4d435f3b617cdb3af83285c2df711ef39c01571827f9d",
                "0x275dc4a288d1afb3cbb1ac09187524c7db36395df7be3b99e673b13a075a65ec",
            ),
            (
                "0x1314aaf1c372e6d7635e573808d9d5c7178bdce7335eb0538f718d8e6651eeb1",
                "0x14c25d3aec745e5a2d4aba9e1448a8cc1048d01a5289f29ccc5acf5e81526673",
                "0x302adae1297f41f9fdd327cfa91c5688fc16dce6579ff99d6699ed49b4d2445e",
                "0x1800a20cf49101a007f783b70334fbdecf9be4f63017754e9afc5721ead62211",
            ),
        ];
        let y = [
            "0x1ab9de59fc825e8b5326694c7d82556785cb9cbfd0d0a11721d1972c21c411f8",
            "0x16a475582082ae3616c808acd62684170d9fa7bf234110353e9cbceca19d2c69",
        ];
        let x = [
            "0x27783160c70b7ac760cff888c621846a7ed80e50c7ea8a7a718a4ad8a50886fb",
            "0x10a6d46618419682152a25b5f819b22c2e572d1f670d12026a18c384248dad2f",
        ];
        let xf = [
            "0x44e300afb5d8c9fe4ed7556cdf91d67bae6f78cdd7b5afdb2d62ae76d668cf9",
            "0x2d6f11dc8d07f13fae893dc146f477a28fdcbe346b5536270b156027e060cbb6",
            "0x1d6149797ffea4e32ec9ad26f54081fc57e62a50c0657a81f91fe7e5b0ee93d0",
            "0x297f8335441b111054cbff68ca424972bff570bcb8b05d4876e93c92fe0b6ff0",
            "0x7aedbe74e081653144a40e4713c7d64ce54773908e447526ec741ff71182e8d",
            "0x164a744315557a2bcc0654ff50e4d8a2ee66dd2a5046c3a93c677b5d76febcf5",
            "0x2b1a554f7baf8c4b91a81e797d2cafbc401bd86d331a29d9309ced81b8b81c26",
            "0x197d1963b67e5a1ffff3e87eca2bc07326ce5e0b7be87d82a1f0ed18c864f08c",
            "0x1bf49bd642edf7a1b83ca6efc6293abfcf04bdc29066ceb99b02c0e71bd454f0",
            "0x243aef64db80f1e463301ece27afe624978d8bfc8033b3470b14731fd488561f",
            "0x2c2632c4740be43538ff3ac49b28b87df2ae5ebe6c5f5853b62815d62cb02e1e",
            "0x4a1156582f27dbbb55d2203377de72269bee7a13ed0105a8a6f2e434c3bcc6d",
        ];
        let xp = [
            (
                "0x6064e784db10e9051e52826e192715e8d7e478cb09a5e0012defa0694fbc7f5",
                "0x1014772f57bb9742735191cd5dcfe4ebbc04156b6878a0a7c9824f32ffb66e85",
                "0x58e1d5681b5b9e0074b0f9c8d2c68a069b920d74521e79765036d57666c5597",
                "0x21e2335f3354bb7922ffcc2f38d3323dd9453ac49b55441452aeaca147711b2",
            ),
            (
                "0xbddb1ea5c182ba12d0762b9c85ebd180541e0b153ca85ff24489f09cb0d44a7",
                "0x2170b47e91296dad38a19f370fa3368b1f333b8f05e5018b7a38af0a045be237",
                "0x760488b80e6b5dd63b4b7422f5609df112bf8a63604449ae3020c63ad8e2489",
                "0x1c937b1f996ef4397c744c8b2503cf644feb5b6d8b7f77237a7b8a2bcb98583a",
            ),
        ];
        let f = Polynomial::new(
            f.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let q = q
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                G2Point::new(
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
                .unwrap()
            })
            .collect::<Vec<_>>();
        let s = s
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                G2Point::new(
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
                .unwrap()
            })
            .collect::<Vec<_>>();
        let y = y
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let x = x
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xf = Polynomial::new(
            xf.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xp = xp
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                (
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BN254PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BN254PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
            })
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        let (f, p) = bit_1_case::<BN254PrimeField, Degree2ExtensionField>(&f, &q, &s, &y, &x);
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
    }

    #[test]
    fn test_bit_1_case_2() {
        let f = ["0x1913c7c566f59082bc8178020dbab618db967238ea9cd35f30a48e8f4e37b31fa826f2ce8023e3f492da64e7fc430262", "0xe88184d680a3c04ed182e6b263c806982325a7601dab1e928ee1cf7c98a702c77ef44f6202e8049b3eb05d0d530416d", "0x133b8d475abdbde6aa5ce6524599001bdebe394bd4b3c7a7c62a4c736176f27fabcb165d0e9db88c3aa8af04ac87b690", "0xff88e1756ceadda3075ef7ac6f1764de912e15b03a34e439b837bfa984174e90399e3fbda93a12cc209b1ed1469ab6f", "0xa2e5dd0e5330c07becfea58e47106140d177f1b1241de5c1e752050408f4970ed1275db43a9c3cc8b4f393a72148638", "0x1124c5ec5de53991b87616d2e433c3387e4ea68342f9713bcf93e2be0ff2b07e03ff0091e0ff71ae050db38a10394cca", "0x47203ee35055ffa8e288c3da40c9831b46d6c7b911ea92ee62d4af79903c75831bb79321155920b413155ca1f2424bf", "0x180ccf08a53eb9416fc958429dfea456e5e802217f5f5ecc44653622720256512e4c7f01efa251cd28065c103db44f11", "0xf4e1f72f26c9590b43bc7b7c45fff374a786d462f2dc275bc0812c9a26969ce0bd7d8fc5a90a9fa47cb7f40320d6418", "0x134043dade475ebc5c796603d3ae7161f7f06e07e968716ea64520685e44705bd9221f8d7d7b0b9e2d131576fdb3af44", "0x19ceec83acdc521e6a9dbf17392e097e01a2685cc2c9d7f3f1430e22221070d222e599ac3e9142d486383eec146b8dac", "0x7ca2e9db2452cc19c71ff5049bdd024819954fb83f0f903169da844e8fe4a584031b750f0678f8661f1c1e1f4653a84"];
        let q = [("0x19e384121b7d70927c49e6d044fd8517c36bc6ed2813a8956dd64f049869e8a77f7e46930240e6984abe26fa6a89658f", "0x3f4b4e761936d90fd5f55f99087138a07a69755ad4a46e4dd1c2cfe6d11371e1cc033111a0595e3bba98d0f538db451", "0x17a31a4fccfb5f768a2157517c77a4f8aaf0dee8f260d96e02e1175a8754d09600923beae02a019afc327b65a2fdbbfc", "0x88bb5832f4a4a452edda646ebaa2853a54205d56329960b44b2450070734724a74daaa401879bad142132316e9b3401"), ("0x1604bd06ba18d6d65bdd88e22c26eaef8a620a1a9fefe016d00eac356f9ceda8bc8eee5e46f9f4736ab22cff0e8cb9e8", "0x3e5755e9bfc250ff0a03efea22428a36a247504e613980918dc5319efb7f66b10d5fe2e7e86af7e014e1456aeaeac5f", "0x5655a99f7ff904c1e41382c25ff0360d9c51d0e331bfb1e38f5dd41c6909caaf6e313f47f727922109bf8c3204fe274", "0x62ec2ed9b207f63e0d9899ed11f9a125b472586b65bb77b8a04d5d446d15a8701ba5c361a07cd85e0743f5ae2e95a9f")];
        let s = [("0x24aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8", "0x13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e", "0xce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801", "0x606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be"), ("0x82dc9154807866eb0f36ccb665a5fc010510bd690ddd7b540e5bf3ff02d81e98b75703a3b3d3c305a70960906e6cb09", "0xdd18d077ad5bd58dabb18d84a6ceebe6375a83dd242851bb4dcf956002c4efb974ffceee6709deb0dcf81d4285e5e60", "0x4a468eb9e206b9833d8e8e2197d3446652372ce5ef50e93c91aa58105d3a281b2e84ddb61535fe1a90bae7e6692f9b0", "0x198fd0ab6249082bf7007d7e8be8992de81f47ae3341c590194fa3bf769a2e5a5253527727115c334e82ed4be8da6c10")];
        let y = ["0x6ce420ceafa50ff15baa710e1633d7893404a18b69ef5316a81b182dadbe66bb0ef4fe49ffa578c7698795e6d4a12cb", "0xf45ba6de68a0f1ab26ba5fac564f3f21a75239243fae800e2a8665fd9699e2795c674834c6ce016370aee9e4a1d38d1"];
        let x = ["0x7f2db8fbcf121365e92ce3d77bf5d9a3537b5422e894c09e00053ace96a5403a8db66fbe03950e93033c5874bbe8046", "0xb190c99770f69f3e912d3ef69f63e082a05a1e63b50eb9a5de3e07b14aed7eded07b2f2b3c42c7e365d2a47945fc285"];
        let xf = ["0x1a009648cc19099f6492fffcdbb1fbed70f61197872a6cbe7e8dda188a5d86701784d71b61130b358bf54a34a90ef1b9", "0x12a81cb61e9b5488fd7cdce673b05acb85475e23b8a68a787721d157650449c422c2903f1f40bab857321ca2aa7ad526", "0x9f9613378d1e258091b5642054bd71a71b047398ae80810d638e9376ae6e45487b41b4d0e5f766f5213b574c27049a1", "0xa211beb012676eacf4c5b94424d3691722b63d3d4493933ffac06589780f351522a8581a194c0663460652181577475", "0x7cdae4413bdf98e6ddbde01882644efcf0cda6141b28ae006abaea3bd405dfcece6208283faef1dad7be06019612c51", "0x1000cb1d25ade5a4224ab93d088ac6a9c5a26cb42b515b71b62ea00d23d39580d75fc848b3ed14fe32b393cd2aa77a29", "0xdfa1993791bd8119033f1734210190856724381a8c45726a9f0f2639f7d5d6b088f4771ae23235234d8108f4beb088", "0x3defca275c0c70ef01a514491daac5461b809ecd6890ef97bafc8e603d20c8e1c75650097bcbc9aaf67428bff100652", "0x62dde56c4a01536859050695f6b9236a150fe6cc3bfd1cfe15921706a387e20dc210c1e0d186abb3a2bcbf8c468135d", "0x15c7bab248f754a557cbaac90c4dda45383bdb5d55cc267955f7b12c32aadcce7f967fcc20f5e803369dfbb63332db60", "0x16a53e4e17f1ba363ae7d2374caaf5b1c11876e4979c1d9ad8f6503f3e2bc05b4fecb1c25d4639d2664929ce90b9552f", "0xb943117f90666049d9ca925443e630eb956afcd48a48f44b90da802913f096aad69e0be1318bff8e88512eaa1f1e13d"];
        let xp = [("0x152110e866f1a6e8c5348f6e005dbd93de671b7d0fbfa04d6614bcdd27a3cb2a70f0deacb3608ba95226268481a0be7c", "0xbf78a97086750eb166986ed8e428ca1d23ae3bbf8b2ee67451d7dd84445311e8bc8ab558b0bc008199f577195fc39b7", "0x845be51ad0d708657bfb0da8eec64cd7779c50d90b59a3ac6a2045cad0561d654af9a84dd105cea5409d2adf286b561", "0xa298f69fd652551e12219252baacab101768fc6651309450e49c7d3bb52b7547f218d12de64961aa7f059025b8e0cb5"), ("0xbfa363ea499e05a429d9af2a73ba635e0ff3825edddacfab8afc6b9188700c835282a2c4c7effe70dc61c557b8d90e1", "0x5c3fefe5849b36814f32ce71dee6eba467b220e1b53f01421b9ec6d23209f6206e864539ddaa327b085ad8d78a8589b", "0x17b304f1c4f58afee1ecd75f1570b13da2ee02dfc5731f82ac55d5b6d011ce70ae42061b3d205cbe49efdfcd8d2c04b4", "0x101d88f38de6be9d7eb2c074905585f487715b3e6d8179a066ba56988207caa28f7a5f1ba2f7abd01e200ac71d198282")];
        let f = Polynomial::new(
            f.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let q = q
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                G2Point::new(
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
                .unwrap()
            })
            .collect::<Vec<_>>();
        let s = s
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                G2Point::new(
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
                .unwrap()
            })
            .collect::<Vec<_>>();
        let y = y
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let x = x
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        let xf = Polynomial::new(
            xf.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xp = xp
            .into_iter()
            .map(|(x1, y1, x2, y2)| {
                (
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x1).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y1).unwrap(),
                    ],
                    [
                        FieldElement::<BLS12381PrimeField>::from_hex(x2).unwrap(),
                        FieldElement::<BLS12381PrimeField>::from_hex(y2).unwrap(),
                    ],
                )
            })
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        let (f, p) = bit_1_case::<BLS12381PrimeField, Degree2ExtensionField>(&f, &q, &s, &y, &x);
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
    }
}
