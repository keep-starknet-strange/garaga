use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use crate::algebra::polynomial::{Polynomial, pad_with_zero_coefficients_to_length};
use crate::algebra::extf_mul::nondeterministic_extension_field_div;
use crate::algebra::extf_mul::nondeterministic_extension_field_mul_divmod;
use crate::definitions::CurveParamsProvider;

pub fn filter_elements<F: IsPrimeField>(elmts: &[FieldElement<F>], sparsity: &[bool]) -> Vec<FieldElement<F>> {
    assert_eq!(sparsity.len(), elmts.len());
    let mut result = vec![];
    for i in 0..elmts.len() {
        result.push(if sparsity[i] { elmts[i].clone() } else { FieldElement::<F>::from(0) });
    }
    result
}

pub fn compact_elements<F: IsPrimeField>(elmts: &[FieldElement<F>], sparsity: &[bool]) -> Vec<FieldElement<F>> {
    assert_eq!(sparsity.len(), elmts.len());
    let mut result = vec![];
    for i in 0..elmts.len() {
        if sparsity[i] {
            result.push(elmts[i].clone());
        }
    }
    result
}

fn add<F: IsPrimeField>(a: &FieldElement<F>, b: &FieldElement<F>) -> FieldElement<F> {
    a + b
}

fn double<F: IsPrimeField>(a: &FieldElement<F>) -> FieldElement<F> {
    a + a
}

fn mul<F: IsPrimeField>(a: &FieldElement<F>, b: &FieldElement<F>) -> FieldElement<F> {
    a * b
}

fn neg<F: IsPrimeField>(a: &FieldElement<F>) -> FieldElement<F> {
    -a
}

fn sub<F: IsPrimeField>(a: &FieldElement<F>, b: &FieldElement<F>)-> FieldElement<F> {
    a - b
}

fn inv<F: IsPrimeField>(a: &FieldElement<F>) -> FieldElement<F> {
    a.inv().unwrap()
}

fn div<F: IsPrimeField>(a: &FieldElement<F>, b: &FieldElement<F>) -> FieldElement<F> {
    a / b
}

fn fp2_mul<F: IsPrimeField>(x: &[FieldElement<F>; 2], y: &[FieldElement<F>; 2]) -> [FieldElement<F>; 2] {
    [
        sub(&mul(&x[0], &y[0]), &mul(&x[1], &y[1])),
        add(&mul(&x[0], &y[1]), &mul(&x[1], &y[0])),
    ]
}

fn fp2_square<F: IsPrimeField>(x: &[FieldElement<F>; 2]) -> [FieldElement<F>; 2] {
    [
        mul(&add(&x[0], &x[1]), &sub(&x[0], &x[1])),
        double(&mul(&x[0], &x[1])),
    ]
}

fn fp2_div<F>(x: &[FieldElement<F>; 2], y: &[FieldElement<F>; 2]) -> [FieldElement<F>; 2]
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let x = Polynomial::new(x.to_vec());
    let y = Polynomial::new(y.to_vec());
    let mut z = nondeterministic_extension_field_div(x, y, 2);
    pad_with_zero_coefficients_to_length(&mut z, 2);
    [z.coefficients[0].clone(), z.coefficients[1].clone()]
}

fn extf_add<const N: usize, F: IsPrimeField>(x: &[FieldElement<F>; N], y: &[FieldElement<F>; N]) -> [FieldElement<F>; N] {
    let mut z = x.clone();
    for i in 0..z.len() {
        z[i] = add(&x[i], &y[i]);
    }
    z
}

fn extf_scalar_mul<const N: usize, F: IsPrimeField>(x: &[FieldElement<F>; N], c: &FieldElement<F>) -> [FieldElement<F>; N] {
    let mut z = x.clone();
    for i in 0..z.len() {
        z[i] = mul(&x[i], c);
    }
    z
}

pub fn extf_neg<const N: usize, F: IsPrimeField>(x: &[FieldElement<F>; N]) -> [FieldElement<F>; N] {
    let mut z = x.clone();
    for i in 0..z.len() {
        z[i] = neg(&x[i]);
    }
    z
}

fn extf_sub<const N: usize, F: IsPrimeField>(x: &[FieldElement<F>; N], y: &[FieldElement<F>; N]) -> [FieldElement<F>; N] {
    let mut z = x.clone();
    for i in 0..z.len() {
        z[i] = sub(&x[i], &y[i]);
    }
    z
}

pub fn extf_mul<F>(ps: Vec<Vec<FieldElement<F>>>, ext_degree: usize, r_sparsity: Option<Vec<bool>>, qis: Option<&mut Vec<Polynomial<F>>>, ris: Option<&mut Vec<Vec<FieldElement<F>>>>)
    -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    let ps = ps.into_iter().map(|coefficients| Polynomial::new(coefficients)).collect();
    let (q, mut r) = nondeterministic_extension_field_mul_divmod(ext_degree, ps);
    pad_with_zero_coefficients_to_length(&mut r, ext_degree);
    let mut r = r.coefficients;
    if let Some(r_sparsity) = r_sparsity {
        r = filter_elements(&r, &r_sparsity);
    }
    if let Some(qis) = qis {
        qis.push(q)
    }
    if let Some(ris) = ris {
        ris.push(r.clone())
    }
    r
}

pub fn extf_inv<F>(y: &[FieldElement<F>], ext_degree: usize, qis: Option<&mut Vec<Polynomial<F>>>, ris: Option<&mut Vec<Vec<FieldElement<F>>>>) -> Vec<FieldElement<F>>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let y = Polynomial::new(y.to_vec()); 
    let one = Polynomial::one();
    let mut y_inv = nondeterministic_extension_field_div(one, y.clone(), ext_degree);
    let (q, mut r) = nondeterministic_extension_field_mul_divmod(ext_degree, vec![y_inv.clone(), y]);
    pad_with_zero_coefficients_to_length(&mut r, ext_degree);
    let r = r.coefficients;
    assert_eq!(r[0], FieldElement::from(1));
    for i in 1..r.len() {
        assert_eq!(r[i], FieldElement::from(0));
    }
    if let Some(qis) = qis {
        qis.push(q)
    }
    if let Some(ris) = ris {
        ris.push(r)
    }
    pad_with_zero_coefficients_to_length(&mut y_inv, ext_degree);
    y_inv.coefficients
}

pub fn conjugate_e12d<F: IsPrimeField>(e12d: &[FieldElement<F>; 12]) -> [FieldElement<F>; 12] {
    [
        e12d[0].clone(),
        neg(&e12d[1]),
        e12d[2].clone(),
        neg(&e12d[3]),
        e12d[4].clone(),
        neg(&e12d[5]),
        e12d[6].clone(),
        neg(&e12d[7]),
        e12d[8].clone(),
        neg(&e12d[9]),
        e12d[10].clone(),
        neg(&e12d[11]),
    ]
}

pub fn precompute_consts<F: IsPrimeField>(p: &[[FieldElement<F>;2]]) -> (Vec<FieldElement<F>>, Vec<FieldElement<F>>) {
    let mut y_inv = vec![];
    let mut x_neg_over_y = vec![];
    for pi in p {
        y_inv.push(inv(&pi[1]));
        x_neg_over_y.push(neg(&div(&pi[0], &pi[1])));
    } 
    (y_inv, x_neg_over_y)
}

fn compute_doubling_slope<F>(q: &([FieldElement<F>; 2], [FieldElement<F>; 2])) -> [FieldElement<F>; 2]
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let [x0, x1] = &q.0;
    let num = [
        mul(&mul(&add(x0, x1), &sub(x0, x1)), &FieldElement::<F>::from(3)),
        mul(&mul(x0, x1), &FieldElement::<F>::from(6)),
    ];
    let den = extf_add(&q.1, &q.1);
    return fp2_div(&num, &den);
}

fn compute_adding_slope<F>(qa: &([FieldElement<F>; 2], [FieldElement<F>; 2]), qb: &([FieldElement<F>; 2], [FieldElement<F>; 2])) -> [FieldElement<F>; 2]
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let num = extf_sub(&qa.1, &qb.1);
    let num = [num[0].clone(), num[1].clone()];
    let den = extf_sub(&qa.0, &qb.0);
    let den = [den[0].clone(), den[1].clone()];
    return fp2_div(&num, &den);
}

fn build_sparse_line_eval<F: IsPrimeField>(curve_id: usize, r0: &[FieldElement<F>; 2], r1: &[FieldElement<F>; 2], y_inv: &FieldElement<F>, x_neg_over_y: &FieldElement<F>) -> [FieldElement<F>; 12] {
    if curve_id == 0 {
        return [
            FieldElement::<F>::from(1),
            mul(&add(&r0[0], &mul(&neg(&FieldElement::<F>::from(9)), &r0[1])), &x_neg_over_y),
            FieldElement::<F>::from(0),
            mul(&add(&r1[0], &mul(&neg(&FieldElement::<F>::from(9)), &r1[1])), &y_inv),
            FieldElement::<F>::from(0),
            FieldElement::<F>::from(0),
            FieldElement::<F>::from(0),
            mul(&r0[1], &x_neg_over_y),
            FieldElement::<F>::from(0),
            mul(&r1[1], &y_inv),
            FieldElement::<F>::from(0),
            FieldElement::<F>::from(0),
        ];
    }
    if curve_id == 1 {
        return [
            mul(&sub(&r1[0], &r1[1]), &y_inv),
            FieldElement::<F>::from(0),
            mul(&sub(&r0[0], &r0[1]), &x_neg_over_y),
            FieldElement::<F>::from(1),
            FieldElement::<F>::from(0),
            FieldElement::<F>::from(0),
            mul(&r1[1], &y_inv),
            FieldElement::<F>::from(0),
            mul(&r0[1], &x_neg_over_y),
            FieldElement::<F>::from(0),
            FieldElement::<F>::from(0),
            FieldElement::<F>::from(0),
        ];
    }
    unimplemented!()
}

fn _add<F>(qa: &([FieldElement<F>; 2], [FieldElement<F>; 2]), qb: &([FieldElement<F>; 2], [FieldElement<F>; 2])) -> (([FieldElement<F>; 2], [FieldElement<F>; 2]), ([FieldElement<F>; 2], [FieldElement<F>; 2]))
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let λ = compute_adding_slope(qa, qb);
    let xr = extf_sub(&fp2_square(&λ), &extf_add(&qa.0, &qb.0));
    let yr = extf_sub(&fp2_mul(&λ, &extf_sub(&qa.0, &xr)), &qa.1);
    let p = (xr, yr);
    let line_r0 = λ.clone();
    let line_r1 = extf_sub(&fp2_mul(&λ, &qa.0), &qa.1);
    return (p, (line_r0, line_r1));
}

fn _line_compute<F>(qa: &([FieldElement<F>; 2], [FieldElement<F>; 2]), qb: &([FieldElement<F>; 2], [FieldElement<F>; 2])) -> ([FieldElement<F>; 2], [FieldElement<F>; 2])
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let λ = compute_adding_slope(qa, qb);
    let line_r0 = λ.clone();
    let line_r1 = extf_sub(&fp2_mul(&λ, &qa.0), &qa.1);
    return (line_r0, line_r1);
}

fn _double<F>(q: &([FieldElement<F>; 2], [FieldElement<F>; 2])) -> (([FieldElement<F>; 2], [FieldElement<F>; 2]), ([FieldElement<F>; 2], [FieldElement<F>; 2]))
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let λ = compute_doubling_slope(q);
    let xr = extf_sub(&fp2_square(&λ), &extf_add(&q.0, &q.0));
    let yr = extf_sub(&fp2_mul(&λ, &extf_sub(&q.0, &xr)), &q.1);
    let p = (xr, yr);
    let line_r0 = λ.clone();
    let line_r1 = extf_sub(&fp2_mul(&λ, &q.0), &q.1);
    return (p, (line_r0, line_r1));
}

pub fn double_step<F>(curve_id: usize, q: &([FieldElement<F>; 2], [FieldElement<F>; 2]), y_inv: &FieldElement<F>, x_neg_over_y: &FieldElement<F>)
    -> (([FieldElement<F>; 2], [FieldElement<F>; 2]), [FieldElement<F>; 12])
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let (p, (line_r0, line_r1)) = _double(q);
    let line = build_sparse_line_eval(curve_id, &line_r0, &line_r1, y_inv, x_neg_over_y);
    return (p, line);
}

fn _double_and_add<F>(qa: &([FieldElement<F>; 2], [FieldElement<F>; 2]), qb: &([FieldElement<F>; 2], [FieldElement<F>; 2]))
    -> (([FieldElement<F>; 2], [FieldElement<F>; 2]), ([FieldElement<F>; 2], [FieldElement<F>; 2]), ([FieldElement<F>; 2], [FieldElement<F>; 2]))
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let λ1 = compute_adding_slope(qa, qb);
    let x3 = extf_sub(&fp2_square(&λ1), &extf_add(&qa.0, &qb.0));
    let line1_r0 = λ1.clone();
    let line1_r1 = extf_sub(&fp2_mul(&λ1, &qa.0), &qa.1);
    let num = extf_add(&qa.1, &qa.1);
    let den = extf_sub(&x3, &qa.0);
    let λ2 = extf_neg(&extf_add(&λ1, &fp2_div(&num, &den)));
    let x4 = extf_sub(&extf_sub(&fp2_square(&λ2), &qa.0), &x3);
    let y4 = extf_sub(&fp2_mul(&λ2, &extf_sub(&qa.0, &x4)), &qa.1);
    let line2_r0 = λ2.clone();
    let line2_r1 = extf_sub(&fp2_mul(&λ2, &qa.0), &qa.1);
    return ((x4, y4), (line1_r0, line1_r1), (line2_r0, line2_r1));
}

pub fn double_and_add_step<F>(curve_id: usize, qa: &([FieldElement<F>; 2], [FieldElement<F>; 2]), qb: &([FieldElement<F>; 2], [FieldElement<F>; 2]), y_inv: &FieldElement<F>, x_neg_over_y: &FieldElement<F>)
    -> (([FieldElement<F>; 2], [FieldElement<F>; 2]), [FieldElement<F>; 12], [FieldElement<F>; 12])
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let (p, (line1_r0, line1_r1), (line2_r0, line2_r1)) = _double_and_add(qa, qb);
    let line1 = build_sparse_line_eval(curve_id, &line1_r0, &line1_r1, y_inv, x_neg_over_y);
    let line2 = build_sparse_line_eval(curve_id, &line2_r0, &line2_r1, y_inv, x_neg_over_y);
    return (p, line1, line2);
}

fn _triple<F>(q: &([FieldElement<F>; 2], [FieldElement<F>; 2]))
    -> (([FieldElement<F>; 2], [FieldElement<F>; 2]), ([FieldElement<F>; 2], [FieldElement<F>; 2]), ([FieldElement<F>; 2], [FieldElement<F>; 2]))
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let [x0, x1] = &q.0;
    let num = [
        mul(&mul(&add(&x0, &x1), &sub(&x0, &x1)), &FieldElement::<F>::from(3)),
        mul(&mul(&x0, &x1), &FieldElement::<F>::from(6)),
    ];
    let den = extf_add(&q.1, &q.1);
    let λ1 = fp2_div(&num, &den);
    let line1_r0 = λ1.clone();
    let line1_r1 = extf_sub(&fp2_mul(&λ1, &q.0), &q.1);
    let x2 = extf_sub(&fp2_square(&λ1), &extf_add(&q.0, &q.0));
    let λ2 = extf_sub(&fp2_div(&den, &extf_sub(&q.0, &x2)), &λ1);
    let line2_r0 = λ2.clone();
    let line2_r1 = extf_sub(&fp2_mul(&λ2, &q.0), &q.1);
    let xr = extf_sub(&fp2_square(&λ2), &extf_add(&q.0, &x2));
    let yr = extf_sub(&fp2_mul(&λ2, &extf_sub(&q.0, &xr)), &q.1);
    return ((xr, yr), (line1_r0, line1_r1), (line2_r0, line2_r1));
}

pub fn triple_step<F>(curve_id: usize, q: &([FieldElement<F>; 2], [FieldElement<F>; 2]), y_inv: &FieldElement<F>, x_neg_over_y: &FieldElement<F>)
    -> (([FieldElement<F>; 2], [FieldElement<F>; 2]), [FieldElement<F>; 12], [FieldElement<F>; 12])
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let (p, (line1_r0, line1_r1), (line2_r0, line2_r1)) = _triple(q);
    let line1 = build_sparse_line_eval(curve_id, &line1_r0, &line1_r1, y_inv, x_neg_over_y);
    let line2 = build_sparse_line_eval(curve_id, &line2_r0, &line2_r1, y_inv, x_neg_over_y);
    return (p, line1, line2);
}

fn bit_0_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>])
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(q.len(), n_pairs);
    let mut new_lines = vec![];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1) = double_step(curve_id, &q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_points.push(t);
    }
    let new_lines = new_lines.into_iter().flat_map(|v| v.to_vec()).collect();
    let new_f = extf_mul(vec![f.to_vec(), f.to_vec(), new_lines], 12, None, None, None);
    return (new_f, new_points);
}

fn bit_1_init_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>])
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(q.len(), n_pairs);
    let mut new_lines = vec![];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1, l2) = triple_step(curve_id, &q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_lines.push(l2);
        new_points.push(t);
    }
    let new_lines = new_lines.into_iter().flat_map(|v| v.to_vec()).collect();
    let new_f = extf_mul(vec![f.to_vec(), f.to_vec(), new_lines], 12, None, None, None);
    return (new_f, new_points);
}

fn bit_1_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], q_select: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>])
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(q.len(), n_pairs);
    assert_eq!(q_select.len(), n_pairs);
    let mut new_lines = vec![];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1, l2) = double_and_add_step(curve_id, &q[k], &q_select[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_lines.push(l2);
        new_points.push(t);
    }
    let new_lines = new_lines.into_iter().flat_map(|v| v.to_vec()).collect();
    let new_f = extf_mul(vec![f.to_vec(), f.to_vec(), new_lines], 12, None, None, None);
    return (new_f, new_points);
}

fn _bn254_finalize_step<F>(qs: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])])
    -> Vec<(([FieldElement<F>; 2], [FieldElement<F>; 2]), ([FieldElement<F>; 2], [FieldElement<F>; 2]))>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let nr1p2 = [
        FieldElement::<F>::from_hex("2fb347984f7911f74c0bec3cf559b143b78cc310c2c3330c99e39557176f553d").unwrap(),
        FieldElement::<F>::from_hex("16c9e55061ebae204ba4cc8bd75a079432ae2a1d0b7c9dce1665d51c640fcba2").unwrap(),
    ];
    let nr1p3 = [
        FieldElement::<F>::from_hex("63cf305489af5dcdc5ec698b6e2f9b9dbaae0eda9c95998dc54014671a0135a").unwrap(),
        FieldElement::<F>::from_hex("7c03cbcac41049a0704b5a7ec796f2b21807dc98fa25bd282d37f632623b0e3").unwrap(),
    ];
    let nr2p2 = FieldElement::<F>::from_hex("30644e72e131a0295e6dd9e7e0acccb0c28f069fbb966e3de4bd44e5607cfd48").unwrap();
    let nr2p3 = FieldElement::<F>::from_hex("30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd46").unwrap();
    let mut new_lines = vec![];
    for k in 0..q.len() {
        let q1x = [q[k].0[0].clone(), neg(&q[k].0[1])];
        let q1y = [q[k].1[0].clone(), neg(&q[k].1[1])];
        let q1x = fp2_mul(&q1x, &nr1p2);
        let q1y = fp2_mul(&q1y, &nr1p3);
        let q2x = extf_scalar_mul(&q[k].0, &nr2p2);
        let q2y = extf_scalar_mul(&q[k].1, &nr2p3);
        let (t, (l1_r0, l1_r1)) = _add(&qs[k], &(q1x, q1y));
        let (l2_r0, l2_r1) = _line_compute(&t, &(q2x, q2y));
        new_lines.push(((l1_r0, l1_r1), (l2_r0, l2_r1)));
    }
    return new_lines;
}

pub fn bn254_finalize_step<F>(qs: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>])
    -> Vec<[FieldElement<F>; 12]>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let curve_id = 0;
    let lines = _bn254_finalize_step(qs, q);
    let mut lines_evaluated = vec![];
    for k in 0..lines.len() {
        let (l1, l2) = &lines[k];
        let line_eval1 = build_sparse_line_eval(curve_id, &l1.0, &l1.1, &y_inv[k], &x_neg_over_y[k]);
        let line_eval2 = build_sparse_line_eval(curve_id, &l2.0, &l2.1, &y_inv[k], &x_neg_over_y[k]);
        lines_evaluated.push(line_eval1);
        lines_evaluated.push(line_eval2);
    }
    return lines_evaluated;
}

pub fn miller_loop<F>(curve_id: usize, p: &[[FieldElement<F>; 2]], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])]) -> [FieldElement<F>; 12]
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(p.len(), q.len());
    let n_pairs = p.len();

    let (y_inv, x_neg_over_y) = precompute_consts(p);

    let loop_counter = &F::get_curve_params().loop_counter;

    let mut f = [
        FieldElement::<F>::from(1), FieldElement::<F>::from(0), FieldElement::<F>::from(0), FieldElement::<F>::from(0),
        FieldElement::<F>::from(0), FieldElement::<F>::from(0), FieldElement::<F>::from(0), FieldElement::<F>::from(0),
        FieldElement::<F>::from(0), FieldElement::<F>::from(0), FieldElement::<F>::from(0), FieldElement::<F>::from(0),
    ];
    let mut qs;

    let mut q_neg = vec![];
    if loop_counter.contains(&-1) {
        for i in 0..n_pairs {
            q_neg.push((q[i].0.clone(), extf_neg(&q[i].1)));
        }
    }

    let start_index = loop_counter.len() - 2;

    if loop_counter[start_index] == 1 {
        let (new_f, new_qs) = bit_1_init_case(curve_id, &f, q, n_pairs, &y_inv, &x_neg_over_y);
        f = new_f.try_into().unwrap();
        qs = new_qs;
    }
    else
    if loop_counter[start_index] == 0 {
        let (new_f, new_qs) = bit_0_case(curve_id, &f, q, n_pairs, &y_inv, &x_neg_over_y);
        f = new_f.try_into().unwrap();
        qs = new_qs;
    }
    else {
        unimplemented!();
    }

    for i in (0..start_index).rev() {
        if loop_counter[i] == 0 {
            let (new_f, new_qs) = bit_0_case(curve_id, &f, &qs, n_pairs, &y_inv, &x_neg_over_y);
            f = new_f.try_into().unwrap();
            qs = new_qs;
        }
        else
        if loop_counter[i] == 1 || loop_counter[i] == -1 {
            let mut q_selects = vec![];
            for k in 0..n_pairs {
                q_selects.push(if loop_counter[i] == 1 { q[k].clone() } else { q_neg[k].clone() });
            }
            let (new_f, new_qs) = bit_1_case(curve_id, &f, &qs, &q_selects, n_pairs, &y_inv, &x_neg_over_y);
            f = new_f.try_into().unwrap();
            qs = new_qs;
        }
        else {
            unimplemented!();
        }
    }

    if curve_id == 0 {
        let lines = bn254_finalize_step(&qs, q, &y_inv, &x_neg_over_y);
        let lines = lines.into_iter().flat_map(|v| v.to_vec()).collect();
        let new_f = extf_mul(vec![f.to_vec(), lines], 12, None, None, None);
        f = new_f.try_into().unwrap();
    }
    else
    if curve_id == 1 {
        f = conjugate_e12d(&f);
    }
    else {
            unimplemented!();
    }

    return f;
}
