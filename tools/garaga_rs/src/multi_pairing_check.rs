use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use crate::algebra::polynomial::Polynomial;
use crate::definitions::CurveParamsProvider;
use crate::multi_miller_loop::{filter_elements, extf_neg, extf_mul, extf_inv, conjugate_e12d, double_step, double_and_add_step, triple_step, precompute_consts, bn254_finalize_step};
use crate::frobenius::{frobenius, get_frobenius_maps_12};

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

pub fn get_root_and_scaling_factor<F>(_curve_id: usize, p: &[[FieldElement<F>; 2]], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], _m: Option<&[FieldElement<F>]>)
    -> ([FieldElement<F>; 12], Vec<FieldElement<F>>, Vec<bool>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    todo!() // TODO
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
        new_lines.push(l1);
        new_points.push(t);
    }
    let new_lines = new_lines.into_iter().flat_map(|v| v.to_vec()).collect();
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
        new_lines.push(l1.clone());
        new_lines.push(l1);
        new_points.push(t);
    }
    let mut new_new_lines = vec![];
    let mut new_new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1) = double_step(curve_id, &new_points[k], &y_inv[k], &x_neg_over_y[k]);
        new_new_lines.push(l1);
        new_new_points.push(t);
    }
    let new_lines = new_lines.into_iter().flat_map(|v| v.to_vec()).collect();
    let new_new_lines = new_new_lines.into_iter().flat_map(|v| v.to_vec()).collect();
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
        new_lines.push(l1);
        new_lines.push(l2);
        new_points.push(t);
    }
    let new_lines = new_lines.into_iter().flat_map(|v| v.to_vec()).collect();
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
        new_lines.push(l1);
        new_lines.push(l2);
        new_points.push(t);
    }
    let new_lines = new_lines.into_iter().flat_map(|v| v.to_vec()).collect();
    let new_f = extf_mul(vec![f.to_vec(), f.to_vec(), c_or_c_inv.to_vec(), new_lines], 12, None, Some(qis), Some(ris));
    return (new_f, new_points);
}

pub fn multi_pairing_check<F>(curve_id: usize, p: &[[FieldElement<F>; 2]], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], _n_fixed_g2: usize, m: Option<&[FieldElement<F>]>)
    -> ([FieldElement<F>; 12], Option<[FieldElement<F>; 12]>, [FieldElement<F>; 12], Vec<FieldElement<F>>, Vec<bool>, Vec<Polynomial<F>>, Vec<Vec<FieldElement<F>>>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    assert_eq!(p.len(), q.len());
    let n_pairs = p.len();

    let (y_inv, x_neg_over_y) = precompute_consts(p);

    let loop_counter = &F::get_curve_params().loop_counter;

    let (mut qis, mut ris) = (vec![], vec![]);

    let (mut c_or_c_inv, scaling_factor, scaling_factor_sparsity) = get_root_and_scaling_factor(curve_id, p, q, m);
    let w = filter_elements(&scaling_factor, &scaling_factor_sparsity);

    let lambda_root;
    let lambda_root_inverse;
    let c;
    let c_inv;

    if curve_id == 1 {
        lambda_root = None;
        lambda_root_inverse = c_or_c_inv.clone();
        c = None;
        c_inv = conjugate_e12d(&lambda_root_inverse);
    }
    else
    if curve_id == 0 {
        lambda_root = Some(c_or_c_inv.clone());
        lambda_root_inverse = extf_inv(&c_or_c_inv.to_vec(), 12, Some(&mut qis), Some(&mut ris)).try_into().unwrap();
        c = Some(c_or_c_inv.clone());
        c_inv = lambda_root_inverse.clone();
    }
    else {
        unimplemented!();
    }

    let mut f = c_inv.clone();
    let mut qs;

    let mut q_neg = vec![];
    if loop_counter.contains(&-1) {
        for i in 0..n_pairs {
            q_neg.push((q[i].0.clone(), extf_neg(&q[i].1)));
        }
    }

    let start_index = loop_counter.len() - 2;

    if loop_counter[start_index] == 1 {
        let (new_f, new_qs) = bit_1_init_case(curve_id, &f, q, n_pairs, &y_inv, &x_neg_over_y, &c_inv, &mut qis, &mut ris);
        f = new_f.try_into().unwrap();
        qs = new_qs;
    }
    else
    if loop_counter[start_index] == 0 {
        let (new_f, new_qs) = bit_0_case(curve_id, &f, q, n_pairs, &y_inv, &x_neg_over_y, &mut qis, &mut ris);
        f = new_f.try_into().unwrap();
        qs = new_qs;
    }
    else {
        unimplemented!();
    }

    let mut i = start_index;
    while i > 0 {
        i -= 1;
        if loop_counter[i] == 0 {
            if i > 0 && loop_counter[i - 1] == 0 {
                let (new_f, new_qs) = bit_00_case(curve_id, &f, &qs, n_pairs, &y_inv, &x_neg_over_y, &mut qis, &mut ris);
                f = new_f.try_into().unwrap();
                qs = new_qs;
                i -= 1;
            }
            else {
                let (new_f, new_qs) = bit_0_case(curve_id, &f, &qs, n_pairs, &y_inv, &x_neg_over_y, &mut qis, &mut ris);
                f = new_f.try_into().unwrap();
                qs = new_qs;
            }
        }
        else
        if loop_counter[i] == 1 || loop_counter[i] == -1 {
            let mut q_selects = vec![];
            for k in 0..n_pairs {
                q_selects.push(if loop_counter[i] == 1 { q[k].clone() } else { q_neg[k].clone() });
            }
            c_or_c_inv = if loop_counter[i] == 1 { c_inv.clone() } else { c.clone().unwrap() };
            let (new_f, new_qs) = bit_1_case(curve_id, &f, &qs, &q_selects, n_pairs, &y_inv, &x_neg_over_y, &c_or_c_inv, &mut qis, &mut ris);
            f = new_f.try_into().unwrap();
            qs = new_qs;
        }
        else {
            unimplemented!();
        }
    }

    let final_r_sparsity =
        if m != None && m.unwrap().len() == 12 {
            None
        }
        else {
            let sparsity = vec![true, false, false, false, false, false, false, false, false, false, false, false];
            Some(sparsity)
        };

    let frobenius_maps = get_frobenius_maps_12(curve_id);

    if curve_id == 0 {
        let lines = bn254_finalize_step(&qs, q, &y_inv, &x_neg_over_y);
        let lines = lines.into_iter().flat_map(|v| v.to_vec()).collect();
        let new_f = extf_mul(vec![f.to_vec(), lines], 12, None, Some(&mut qis), Some(&mut ris));
        f = new_f.try_into().unwrap();
        let c_inv_frob_1 = frobenius(&frobenius_maps, &c_inv, 1, 12);
        let c_frob_2 = frobenius(&frobenius_maps, &c.unwrap(), 2, 12);
        let c_inv_frob_3 = frobenius(&frobenius_maps, &c_inv, 3, 12);
        let new_f = extf_mul(vec![f.to_vec(), w, c_inv_frob_1, c_frob_2, c_inv_frob_3], 12, final_r_sparsity, Some(&mut qis), Some(&mut ris));
        f = new_f.try_into().unwrap();
    }
    else
    if curve_id == 1 {
        let c_inv_frob_1 = frobenius(&frobenius_maps, &c_inv, 1, 12);
        let new_f = extf_mul(vec![f.to_vec(), w, c_inv_frob_1], 12, final_r_sparsity, Some(&mut qis), Some(&mut ris));
        f = new_f.try_into().unwrap();
        if m != None && m.unwrap().len() == 12 {
            f = conjugate_e12d(&f);
        }
    }
    else {
            unimplemented!();
    }

    if m != None && m.unwrap().len() == 12 {
        let sparsity = vec![true, false, false, false, false, false, false, false, false, false, false, false];
        let new_f = extf_mul(vec![f.to_vec(), m.unwrap().to_vec()], 12, Some(sparsity), Some(&mut qis), Some(&mut ris));
        f = new_f.try_into().unwrap();
    }

    //assert f == [1] + [0] * 11

    return (f, lambda_root, lambda_root_inverse, scaling_factor, scaling_factor_sparsity, qis, ris);
}
