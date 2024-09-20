use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use crate::algebra::polynomial::Polynomial;
use crate::definitions::CurveParamsProvider;
use crate::multi_miller_loop::{extf_mul, double_step, double_and_add_step, triple_step};

pub fn get_max_q_degree(curve_id: usize, n_pairs: usize) -> usize {
    let line_degree: usize;
    if curve_id == 0 {
        line_degree = 9;
    }
    else
    if curve_id == 1 {
        line_degree = 8;
    }
    else {
        unimplemented!();
    }
    let f_degree: usize = 11;
    let max_q_degree = 4 * f_degree + 2 * line_degree * n_pairs + line_degree * n_pairs - 12;
    return max_q_degree;
}

pub fn bit_0_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>, ris: &mut Vec<Vec<FieldElement<F>>>)
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert_eq!(q.len(), n_pairs);
    let mut new_lines = vec![];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1) = double_step(curve_id, &q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.extend(l1.to_vec());
        new_points.push(t);
    }
    let new_f = extf_mul(vec![f.to_vec(), f.to_vec(), new_lines], 12, None, Some(qis), Some(ris));
    return (new_f, new_points);
}

pub fn bit_00_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>, ris: &mut Vec<Vec<FieldElement<F>>>)
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert_eq!(q.len(), n_pairs);
    let mut new_lines = vec![];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1) = double_step(curve_id, &q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.extend(l1.to_vec());
        new_lines.extend(l1.to_vec());
        new_points.push(t);
    }
    let mut new_new_lines = vec![];
    let mut new_new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1) = double_step(curve_id, &new_points[k], &y_inv[k], &x_neg_over_y[k]);
        new_new_lines.extend(l1.to_vec());
        new_new_points.push(t);
    }
    let new_f = extf_mul(vec![f.to_vec(), f.to_vec(), f.to_vec(), f.to_vec(), new_lines, new_new_lines], 12, None, Some(qis), Some(ris));
    return (new_f, new_new_points);
}

pub fn bit_1_init_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>], c: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>, ris: &mut Vec<Vec<FieldElement<F>>>)
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert_eq!(q.len(), n_pairs);
    let mut new_lines = vec![];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1, l2) = triple_step(curve_id, &q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.extend(l1.to_vec());
        new_lines.extend(l2.to_vec());
        new_points.push(t);
    }
    let new_f = extf_mul(vec![f.to_vec(), f.to_vec(), c.to_vec(), new_lines], 12, None, Some(qis), Some(ris));
    return (new_f, new_points);
}

pub fn bit_1_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], q_select: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>], c_or_c_inv: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>, ris: &mut Vec<Vec<FieldElement<F>>>)
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert_eq!(q.len(), n_pairs);
    assert_eq!(q_select.len(), n_pairs);
    let mut new_lines = vec![];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1, l2) = double_and_add_step(curve_id, &q[k], &q_select[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.extend(l1.to_vec());
        new_lines.extend(l2.to_vec());
        new_points.push(t);
    }
    let new_f = extf_mul(vec![f.to_vec(), f.to_vec(), c_or_c_inv.to_vec(), new_lines], 12, None, Some(qis), Some(ris));
    return (new_f, new_points);
}

pub fn multi_pairing_check<F>(_curve_id: usize, _p: &[[FieldElement<F>; 2]], _q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], _n_fixed_g2: usize, _m: Option<&[FieldElement<F>]>)
    -> (Vec<FieldElement<F>>, Vec<FieldElement<F>>, Vec<FieldElement<F>>, Vec<FieldElement<F>>, Vec<bool>, Vec<Polynomial<F>>, Vec<Vec<FieldElement<F>>>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    todo!()
}
