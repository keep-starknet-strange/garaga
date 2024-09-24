use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use crate::algebra::extf_mul::{direct_to_tower, tower_inv, tower_mul, tower_to_direct};
use crate::algebra::polynomial::Polynomial;
use crate::definitions::CurveParamsProvider;
use crate::multi_miller_loop::{filter_elements, compact_elements, extf_neg, extf_mul, extf_inv, conjugate_e12d, double_step, double_and_add_step, triple_step, precompute_consts, bn254_finalize_step, miller_loop};
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

fn get_final_exp_witness<F>(curve_id: usize, f: [FieldElement<F>; 12]) -> ([FieldElement<F>; 12], [FieldElement<F>; 12])
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    use num_bigint::BigUint;
    use crate::io::{element_to_biguint, element_from_biguint};
    let f: Vec<BigUint> = f.iter().map(element_to_biguint).collect();
    let f: [BigUint; 12] = f.try_into().unwrap();
    let (c, wi) = crate::final_exp_witness::get_final_exp_witness(curve_id, f);
    let c: Vec<FieldElement<F>> = c.iter().map(element_from_biguint).collect();
    let wi: Vec<FieldElement<F>> = wi.iter().map(element_from_biguint).collect();
    let c: [FieldElement<F>; 12] = c.try_into().unwrap();
    let wi: [FieldElement<F>; 12] = wi.try_into().unwrap();
    (c, wi)
}

fn get_sparsity<F: IsPrimeField>(x: &[FieldElement<F>]) -> Vec<bool> {
    let mut sparsity = vec![false; x.len()];
    for i in 0..x.len() {
        sparsity[i] = x[i] != FieldElement::<F>::from(0);
    }
    sparsity
}

pub fn get_root_and_scaling_factor<F>(curve_id: usize, p: &[[FieldElement<F>; 2]], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], m: &Option<[FieldElement<F>; 12]>)
    -> ([FieldElement<F>; 12], Vec<FieldElement<F>>, Vec<bool>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(p.len(), q.len());
    assert!(p.len() >= 2);
    let mut f = direct_to_tower(&miller_loop(curve_id, p, q).to_vec(), 12);
    if let Some(m) = m {
        let m = direct_to_tower(&m.to_vec(), 12);
        f = tower_mul(&f, &m, 12);
    }
    let f: [FieldElement<F>; 12] = f.try_into().unwrap();
    let (lambda_root_e12, scaling_factor_e12) = get_final_exp_witness(curve_id, f);
    let lambda_root = tower_to_direct(&(if curve_id == 1 { tower_inv(&lambda_root_e12, 12) } else { lambda_root_e12.to_vec() }), 12);
    let lambda_root: [FieldElement<F>; 12] = lambda_root.try_into().unwrap();
    let scaling_factor = tower_to_direct(&scaling_factor_e12, 12);

    let e6_subfield = vec![
        FieldElement::<F>::from(2),
        FieldElement::<F>::from(3),
        FieldElement::<F>::from(4),
        FieldElement::<F>::from(5),
        FieldElement::<F>::from(6),
        FieldElement::<F>::from(7),
        FieldElement::<F>::from(0),
        FieldElement::<F>::from(0),
        FieldElement::<F>::from(0),
        FieldElement::<F>::from(0),
        FieldElement::<F>::from(0),
        FieldElement::<F>::from(0),
    ];
    let scaling_factor_sparsity = get_sparsity(&tower_to_direct(&e6_subfield, 12));

    for i in 0..scaling_factor_sparsity.len() {
        if !scaling_factor_sparsity[i] {
            assert_eq!(scaling_factor[i], FieldElement::<F>::from(0));
        }
    }
    (lambda_root, scaling_factor, scaling_factor_sparsity)
}

pub fn bit_0_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>, ris: &mut Vec<Vec<FieldElement<F>>>)
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(q.len(), n_pairs);
    let mut new_lines = vec![f.to_vec(), f.to_vec()];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1) = double_step(curve_id, &q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1.to_vec());
        new_points.push(t);
    }
    let new_f = extf_mul(new_lines, 12, None, Some(qis), Some(ris));
    return (new_f, new_points);
}

pub fn bit_00_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>, ris: &mut Vec<Vec<FieldElement<F>>>)
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(q.len(), n_pairs);
    let mut new_lines = vec![f.to_vec(), f.to_vec(), f.to_vec(), f.to_vec()];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1) = double_step(curve_id, &q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1.to_vec());
        new_lines.push(l1.to_vec());
        new_points.push(t);
    }
    let mut new_new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1) = double_step(curve_id, &new_points[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1.to_vec());
        new_new_points.push(t);
    }
    let new_f = extf_mul(new_lines, 12, None, Some(qis), Some(ris));
    return (new_f, new_new_points);
}

pub fn bit_1_init_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>], c: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>, ris: &mut Vec<Vec<FieldElement<F>>>)
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(q.len(), n_pairs);
    let mut new_lines = vec![f.to_vec(), f.to_vec(), c.to_vec()];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1, l2) = triple_step(curve_id, &q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1.to_vec());
        new_lines.push(l2.to_vec());
        new_points.push(t);
    }
    let new_f = extf_mul(new_lines, 12, None, Some(qis), Some(ris));
    return (new_f, new_points);
}

pub fn bit_1_case<F>(curve_id: usize, f: &[FieldElement<F>], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], q_select: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], n_pairs: usize, y_inv: &[FieldElement<F>], x_neg_over_y: &[FieldElement<F>], c_or_c_inv: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>, ris: &mut Vec<Vec<FieldElement<F>>>)
    -> (Vec<FieldElement<F>>, Vec<([FieldElement<F>; 2], [FieldElement<F>; 2])>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(q.len(), n_pairs);
    assert_eq!(q_select.len(), n_pairs);
    let mut new_lines = vec![f.to_vec(), f.to_vec(), c_or_c_inv.to_vec()];
    let mut new_points = vec![];
    for k in 0..n_pairs {
        let (t, l1, l2) = double_and_add_step(curve_id, &q[k], &q_select[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1.to_vec());
        new_lines.push(l2.to_vec());
        new_points.push(t);
    }
    let new_f = extf_mul(new_lines, 12, None, Some(qis), Some(ris));
    return (new_f, new_points);
}

pub fn multi_pairing_check<F>(curve_id: usize, p: &[[FieldElement<F>; 2]], q: &[([FieldElement<F>; 2], [FieldElement<F>; 2])], _n_fixed_g2: usize, m: &Option<[FieldElement<F>; 12]>)
    -> (Option<[FieldElement<F>; 12]>, [FieldElement<F>; 12], Vec<FieldElement<F>>, Vec<Polynomial<F>>, Vec<Vec<FieldElement<F>>>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(p.len(), q.len());
    let n_pairs = p.len();

    let (y_inv, x_neg_over_y) = precompute_consts(p);

    let loop_counter = &F::get_curve_params().loop_counter;

    let (mut qis, mut ris) = (vec![], vec![]);

    let (mut c_or_c_inv, scaling_factor, scaling_factor_sparsity) = get_root_and_scaling_factor(curve_id, p, q, m);
    let w = filter_elements(&scaling_factor, &scaling_factor_sparsity);
    let compact_scaling_factor = compact_elements(&scaling_factor, &scaling_factor_sparsity);

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
        if let Some(_) = m {
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
        if let Some(_) = m {
            f = conjugate_e12d(&f);
        }
    }
    else {
            unimplemented!();
    }

    if let Some(m) = m {
        let sparsity = vec![true, false, false, false, false, false, false, false, false, false, false, false];
        let new_f = extf_mul(vec![f.to_vec(), m.to_vec()], 12, Some(sparsity), Some(&mut qis), Some(&mut ris));
        f = new_f.try_into().unwrap();
    }

    assert_eq!(f[0], FieldElement::from(1));
    for i in 1..f.len() {
        assert_eq!(f[i], FieldElement::from(0));
    }

    return (lambda_root, lambda_root_inverse, compact_scaling_factor, qis, ris);
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::definitions::{BN254PrimeField, BLS12381PrimeField};

    #[test]
    fn test_get_root_and_scaling_factor_1() {
        let p = [("0x1d0634f3f21e7890d1df87eab84852372b905c9ccdb6d03cb7b9a5409b7efcd8", "0x24c53532773dce26eb3f1d6ba3b10e2b53dc193baa1d4f4d3021032564460978"), ("0x2585e4f8a31664cbfc531bccffafcf1e59d91fb9536c985db33c69f7c242e07a", "0x1d2d2799db056ed14f48d341183118d68ea4131357fa42444057cf0c1d62ae3c")];
        let q = [("0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed", "0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2", "0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa", "0x90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b"), ("0x1314aaf1c372e6d7635e573808d9d5c7178bdce7335eb0538f718d8e6651eeb1", "0x14c25d3aec745e5a2d4aba9e1448a8cc1048d01a5289f29ccc5acf5e81526673", "0x397391b7b25e2fba7d1de6d86501d49b6a8dab10d1d0efd5869ecd23aab8e9", "0x1863ac65eca09e89b058c1ff7e4c5c7ec7e5859b385a553ea12434f4eda6db36")];
        let c = ["0x14156ca1853095df27f3cb7c50eca75e794d2f14195c16df4a0f8f9dcb48bee9", "0xdc2a20a6107d4c49fed6b2018946bcc2a8dad06f01d099a6df0a4a55ed21b59", "0x14260c5afb0b1148ed80f8339cf9e06ff04257cb6c1817c4efa721fc98f69503", "0xafe8a09df07bf3dffefe512eb9448ef436dd090f98323135baab8ae3c766c60", "0x114692950f53d4f707bb02cc2b5dc98aff5936811707d6579371dae20368253c", "0x2dd3fca72591963149646f1e106dc0ee917551f5a9da397fe12d4a3939ce650c", "0x1750bd450b85cbd62ea3f1b228beff5fd364a127d6054be99a9248497b82062a", "0x1248cfad33a2147726169d3ce55db12ecafd74bc4b83377c168d89b919386546", "0x28d156bac04e64938816b055888399c99a954b82724e5f5589d549a709b2b5ef", "0x39e1ab153bd709556afece475580f453f9126f256fbb49c235bc75082f5f26e", "0x14853f940bf5c557c7f558d3e74e6617d7f08b54fd83597fed1d7e7b9d09e04", "0xaa480d613601947fee14a3ce2b7af4e1872fe49ae3473546aa01a618b78b125"];
        let f = ["0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0"];
        let xs = [true, false, true, false, true, false, true, false, true, false, true, false];
        let p = p.into_iter().map(|(x, y)| [FieldElement::<BN254PrimeField>::from_hex(x).unwrap(), FieldElement::<BN254PrimeField>::from_hex(y).unwrap()]).collect::<Vec<_>>();
        let q = q.into_iter().map(|(x1, y1, x2, y2)| ([FieldElement::<BN254PrimeField>::from_hex(x1).unwrap(), FieldElement::<BN254PrimeField>::from_hex(y1).unwrap()], [FieldElement::<BN254PrimeField>::from_hex(x2).unwrap(), FieldElement::<BN254PrimeField>::from_hex(y2).unwrap()])).collect::<Vec<_>>();
        let xc = c.into_iter().map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let xf = f.into_iter().map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let (c, f, s) = get_root_and_scaling_factor(0, &p, &q, &None);
        assert_eq!(c.to_vec(), xc);
        assert_eq!(f.to_vec(), xf);
        assert_eq!(s.to_vec(), xs);
    }

    #[test]
    fn test_get_root_and_scaling_factor_2() {
        let p = [("0x72f26b55fb56be102cd3bc838c66439a3d6160b5c724369afbc772d02aed58e", "0x2884b1dc4e84e30fce2f55e418ca01b3d6d1014b772ca79c580e121ca148fe75"), ("0x72f26b55fb56be102cd3bc838c66439a3d6160b5c724369afbc772d02aed58e", "0x2884b1dc4e84e30fce2f55e418ca01b3d6d1014b772ca79c580e121ca148fe75"), ("0x72f26b55fb56be102cd3bc838c66439a3d6160b5c724369afbc772d02aed58e", "0x2884b1dc4e84e30fce2f55e418ca01b3d6d1014b772ca79c580e121ca148fe75")];
        let q = [("0xf0e8184945e8d3483069b5050fd7194c7e35d0c0a30b422f34656d6c94e40be", "0x1752c7b6b35af45db602cf367841e5047ffab14de9079ee8fa5e15901dfef27", "0xa822a5ba029a28335c8bbffe201ffd56deb5dea4dafbd7f615fd2aa9f5a0acc", "0x1228147f83e3ea517fe961ad4b8ee3bf2ade626ec6d9e4fafec17b8404c0341"), ("0xf0e8184945e8d3483069b5050fd7194c7e35d0c0a30b422f34656d6c94e40be", "0x1752c7b6b35af45db602cf367841e5047ffab14de9079ee8fa5e15901dfef27", "0xa822a5ba029a28335c8bbffe201ffd56deb5dea4dafbd7f615fd2aa9f5a0acc", "0x1228147f83e3ea517fe961ad4b8ee3bf2ade626ec6d9e4fafec17b8404c0341"), ("0xf0e8184945e8d3483069b5050fd7194c7e35d0c0a30b422f34656d6c94e40be", "0x1752c7b6b35af45db602cf367841e5047ffab14de9079ee8fa5e15901dfef27", "0xa822a5ba029a28335c8bbffe201ffd56deb5dea4dafbd7f615fd2aa9f5a0acc", "0x1228147f83e3ea517fe961ad4b8ee3bf2ade626ec6d9e4fafec17b8404c0341")];
        let m = ["0x590ff61397d0dd212bfc53caae870d85457c4bcfaccb300f066ee143625434e", "0xf706ef44c1d0af1cc055f39a02506234d00e8eb3d74a2131fff08abcc77f5ff", "0x22a5875254921ffd7da5ae6eba3609b9a258aeb54605464626791e8c2d23914a", "0xae461e60176f9fc701510a38855b7b7bbcf7e5ba36080e7d54da24b20b89bf4", "0xaae21f01619c3fa4ec0223c3dc06216c285cccb310a2f82381041f00ab0a97b", "0xe203da0f9a03b1aac945c0f61fb2673fb43b2aaa206b95ba090599b7a5e8c2e", "0x1e2de9ed7968cac14ad4e2c546956c34ec381b30280fda652c0775ee0202237c", "0xf3b13b4d08af03303a0db8cbb989aa911eec40dff110a40e2837285a53cdc9", "0x242bd1109f659686c79a5ba5d705c69b59a88b64622927b875c780e6f64e6abe", "0x1f626f25b03417e492d2dc829a2f34f4ee684f0447a207ed1fe3501ee8a66a12", "0x234cc399b032b927dca506524d7f4aeb8f0939709cf6ea1c727f2d3d16f4095b", "0x8dd178fb6d5acd8339c2266bcf3504782285acc0c04208d92713b2b39e39f93"];
        let c = ["0x25202875a18b48d6e87a29af47945c59bebde6e323ca9e30f07b55b24f193b0f", "0xe200b0579a47bb3bc4e8cdff399f10e04552e9e73c45803819fb7aff4be48d4", "0x2743277dfb400b1209b242eecb685264d1d38f92b7e202dd946f1c1e893294f5", "0x7ce37c37c9a9830297d2b276e1e10592a67e028713dcf49af707a72abcdd23f", "0x2209ca34e9632ffe10ec67e9ba10af63294f90671a1e7136ddb0226444e3dd93", "0x56824745ec0be7ecd30a7361a37968571854966282b36f9275c1d75a96b4bba", "0x21c2ff8564f4b3599e173cc60a49b16b0ae54cb6fd161b3f69becd983863c1f8", "0x21dfaf1ab1424f7a1d49d1548ca28958a1477f7783b2b95b17f74a4135c8f0ec", "0x2cedae6373f81ff31d527af4bf9944d9cacfc9b69f42e8c899eb37b1c750776a", "0x1b4e8f8bab34df2763de3d3ed13db73b40636e335826957af02c5ff75ecf2f7f", "0x1da51303ee50de4521c9659455fa7db99219fcb1e47acbb5fc054b575c4de206", "0x291ee2a6f851083adcca144de9ddd923bbb33c4bfba59dce6d63b61b27c81f88"];
        let f = ["0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0"];
        let xs = [true, false, true, false, true, false, true, false, true, false, true, false];
        let p = p.into_iter().map(|(x, y)| [FieldElement::<BN254PrimeField>::from_hex(x).unwrap(), FieldElement::<BN254PrimeField>::from_hex(y).unwrap()]).collect::<Vec<_>>();
        let q = q.into_iter().map(|(x1, y1, x2, y2)| ([FieldElement::<BN254PrimeField>::from_hex(x1).unwrap(), FieldElement::<BN254PrimeField>::from_hex(y1).unwrap()], [FieldElement::<BN254PrimeField>::from_hex(x2).unwrap(), FieldElement::<BN254PrimeField>::from_hex(y2).unwrap()])).collect::<Vec<_>>();
        let m = m.into_iter().map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let xc = c.into_iter().map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let xf = f.into_iter().map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let (c, f, s) = get_root_and_scaling_factor(0, &p, &q, &Some(m.try_into().unwrap()));
        assert_eq!(c.to_vec(), xc);
        assert_eq!(f.to_vec(), xf);
        assert_eq!(s.to_vec(), xs);
    }

    #[test]
    fn test_get_root_and_scaling_factor_3() {
        let p = [("0x59d2a79bda5f8a941d4db9e360a80121d5ef96fd687003db24ddec0e0c3b63d82efa81fe174bb39be8658ef83c8c2d", "0x2df47e8cdf189985d5085bdcebb5ee96e40a033f5d3b7986f6992be16bc35f88c471acf7f68344f543e52fe891285a9"), ("0x105dcc4dce3960447d21d3c1dc39e973aaf31de52219df089bb5f797ac6d3395b71420b50de4f62a6588c9401ffefbd3", "0x17cb6c41f0c4e1a7394ab62a9db0be660d847ccc58358f3f9b63c98d9a7845c52e1e2b0faefd0d854043fd325dd3c34f")];
        let q = [("0x24aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8", "0x13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e", "0xce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801", "0x606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be"), ("0x82dc9154807866eb0f36ccb665a5fc010510bd690ddd7b540e5bf3ff02d81e98b75703a3b3d3c305a70960906e6cb09", "0xdd18d077ad5bd58dabb18d84a6ceebe6375a83dd242851bb4dcf956002c4efb974ffceee6709deb0dcf81d4285e5e60", "0x4a468eb9e206b9833d8e8e2197d3446652372ce5ef50e93c91aa58105d3a281b2e84ddb61535fe1a90bae7e6692f9b0", "0x198fd0ab6249082bf7007d7e8be8992de81f47ae3341c590194fa3bf769a2e5a5253527727115c334e82ed4be8da6c10")];
        let c = ["0x521ad898cee9071ebcbf44d874b1a6540a5a24a4fd9c68f45778308171f9267fab695191d4eab620cf33a8eded7fd2c", "0x5966d7f6d173ea01e1a586966651ab83510fb89f6b2afe45cecf0013c8d5695a1e6a597a9f581d9c26c7bc732af4135", "0x110012a0987f151e6eacf408ccd24b9c3e637b240a4100a3ccdc16d44e3cbdf8393eb3557a64d089a1a115a3eab1a695", "0xfc350acc198fbd5b4d95cfcae897c7118bbf9c0479cff61cdaab0fcd1147d96b5521ac4d7d9acb3a8622465c6b1c0fe", "0x6d44964cce393f36664dfb78c36a4b56c817816904d06056f68e9017165ef8db1a4f97532d5c3bbed4da9a68948c926", "0x86f3ebd100f5f5157bc57f79a49542de5fc03a989fe46f82b0c186b4950da2943f4ad019715bc72d9969488889a609f", "0x18776284b17c0858f647e075e04c49ded673151413b8ce9b65bf572081d748820d57d62d54e14ea09aad1c01c5c5faac", "0x647bb2047c521d397fd0f7ae5bd1a1ce889e14808c4ee8f5bd8e019057fb48dad4ea34d4ff280a7232eada165a4400", "0xa97b4be53ee479681acc5ebfc4fae663d5040baacca25a862aae0152d3543705d87df48c8266658d2a03e597cfec8fc", "0x1338aeb075e78cc7505a5d70f24bb9b22ece2fe9e392d6ff22bbd02e82d79e84d590ca9645b2fc96a09f2ffc8b84a4dc", "0xe608702099837e04fc2e999cbb4b845ab04d0a51ea25ee04675bf96847cb9d629da62d1e4354c04ab5208100a0129af", "0x12c968f3ea7364e3ee21b8b2e8162fd74d36e0786ea6a88c7a10d38aa97360f22cd213ab003cca5a2ae19eefaf128521"];
        let f = ["0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x18bc5b99f39cbf0fd8d087688e9a0930581e2c940247cd0991e7a80fe41d8f58d83f1513f1ca42a0e74df934924892fb", "0x0", "0x0", "0x0"];
        let xs = [true, false, true, false, true, false, true, false, true, false, true, false];
        let p = p.into_iter().map(|(x, y)| [FieldElement::<BLS12381PrimeField>::from_hex(x).unwrap(), FieldElement::<BLS12381PrimeField>::from_hex(y).unwrap()]).collect::<Vec<_>>();
        let q = q.into_iter().map(|(x1, y1, x2, y2)| ([FieldElement::<BLS12381PrimeField>::from_hex(x1).unwrap(), FieldElement::<BLS12381PrimeField>::from_hex(y1).unwrap()], [FieldElement::<BLS12381PrimeField>::from_hex(x2).unwrap(), FieldElement::<BLS12381PrimeField>::from_hex(y2).unwrap()])).collect::<Vec<_>>();
        let xc = c.into_iter().map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let xf = f.into_iter().map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let (c, f, s) = get_root_and_scaling_factor(1, &p, &q, &None);
        assert_eq!(c.to_vec(), xc);
        assert_eq!(f.to_vec(), xf);
        assert_eq!(s.to_vec(), xs);
    }

    #[test]
    fn test_get_root_and_scaling_factor_4() {
        let p = [("0x18154782ce0913b21588066dbed78d3d341e911d49f154540dff1f15010392a6da1f95a6e4f817e54aede0613c17035c", "0x11a612bdd0bc09562856a70df9ef4088763fe611fb85858d3070afd4f0e121de7fcee603d77d61326ef5a9a5a681757"), ("0x18154782ce0913b21588066dbed78d3d341e911d49f154540dff1f15010392a6da1f95a6e4f817e54aede0613c17035c", "0x11a612bdd0bc09562856a70df9ef4088763fe611fb85858d3070afd4f0e121de7fcee603d77d61326ef5a9a5a681757"), ("0x18154782ce0913b21588066dbed78d3d341e911d49f154540dff1f15010392a6da1f95a6e4f817e54aede0613c17035c", "0x11a612bdd0bc09562856a70df9ef4088763fe611fb85858d3070afd4f0e121de7fcee603d77d61326ef5a9a5a681757")];
        let q = [("0x120a838699abaae7ed9481944d92a8c02d22b8cea4ff21ab92fab4f255a20d09700542e530d2fddc2fa171cdd4d31a55", "0x158186f6f2dd04cfa4e785476143a906b63b7f3476ad681992e1b13e2c93fc9957b1784151cd5fdc71cf4557ef606935", "0x2bd32fdfe26d866771e21806a44c4a6d642c3dd98128703cde395f3ee4e353cf25a2e219f1c7dcdbe4574f05d0c093b", "0x7ff9623d918ca12e0ff6ccefc83cf9d283b7231df1db3f9eb8540654b533da9b594fc277060005397ea11f7e9a26050"), ("0x120a838699abaae7ed9481944d92a8c02d22b8cea4ff21ab92fab4f255a20d09700542e530d2fddc2fa171cdd4d31a55", "0x158186f6f2dd04cfa4e785476143a906b63b7f3476ad681992e1b13e2c93fc9957b1784151cd5fdc71cf4557ef606935", "0x2bd32fdfe26d866771e21806a44c4a6d642c3dd98128703cde395f3ee4e353cf25a2e219f1c7dcdbe4574f05d0c093b", "0x7ff9623d918ca12e0ff6ccefc83cf9d283b7231df1db3f9eb8540654b533da9b594fc277060005397ea11f7e9a26050"), ("0x120a838699abaae7ed9481944d92a8c02d22b8cea4ff21ab92fab4f255a20d09700542e530d2fddc2fa171cdd4d31a55", "0x158186f6f2dd04cfa4e785476143a906b63b7f3476ad681992e1b13e2c93fc9957b1784151cd5fdc71cf4557ef606935", "0x2bd32fdfe26d866771e21806a44c4a6d642c3dd98128703cde395f3ee4e353cf25a2e219f1c7dcdbe4574f05d0c093b", "0x7ff9623d918ca12e0ff6ccefc83cf9d283b7231df1db3f9eb8540654b533da9b594fc277060005397ea11f7e9a26050")];
        let m = ["0x276d8a09b1ef471d61e1fe932f3136b6412048dad82afcf371bde647281b4f0753c7b540b911c83d732e7d278eca2b2", "0x84dc8eb534426c70fdeb97ad357bcaa08f3bcf837b69302f78975823557a6eaed4035682d08819331e98c628ad7e6a4", "0xad1ecf602d65fe881eaa6e0db2e7f9897c5d9aac15601e7eac85ffce2bc7b2518fb953cd8ab7356837a3539e775e8a4", "0xc44713fa939be012d57473ac1ba1386389c858a2803bf5114d8b2b539c52b38e862bb30b4bbd298bab0e4881a5ebb34", "0x17d27924032bad1b96b038a774356664cf5f284c5d9047dd1f6ed0fc4768c4d33ae5bde98c8a60ac405578242750266c", "0x252d46d43966352b46ef871529d5c8a74ead9d4395930565d5411099e394511d4bf5f21dca890b5c14238be57f05981", "0xdb2280eeda7144c402dfe7f6198bb2924ef03ae600f7222606ac452167328657347b2031e65e90c6094915aaef973cd", "0x190ab4a19e1f1b981b892baedf1e1ed1387d8c002c5f3a2031f94b4bb159c235c039f75271c5034bc18b6d1c45a03c30", "0x16e03a19b04611cdff78c5fd9170f7ea386763607860320a369f48c0083f000e7eeec362f00e883b8262021a004b9fc8", "0x128d8d88c3c8616ff326a554bed73f63ea723c5eca33d4914ba7b263cc869557904c59cff3b76b5dfdcf84760b96fa0c", "0x36d2ef1d9b923357234e298303031f5c1bf5e2f73d4750a712262fd5e7ddfa653a4708e4380616825a3a723a4dc2b5c", "0x329f18e7852fa05613e92046afab08a2bc52479f09c105f34b2a5b11f48e46a872245a2be53e886831d35b55f343069"];
        let c = ["0x105016815aeab4c1b10cba422f6a4e683585d4ccc465352ad2f1409607d64c54b73d78aa8bdaa3278720844c37567039", "0xe11367a38a9da9df34240738a7a3dca8c8fe5ccf68c0b23ece7f8c4810788c9023c2ad2f14f1369d17825c133efc2d6", "0x13e42c3e0801ac2144a06fbf1712c06213e43c0272585dc031325aee1b1dbae62f7c153bf3c140b105713ed07834b4a", "0xc759210484ca64b6a064096c61d5ab0a8dc2dffbaa7e2dc7336f37c2c0d759c4ff697bf713b362105bba1e8fcbb94a0", "0xd6a3922a006a5ac269f11053acef2763be703fa77d9050683f2d1513c7ce01407cbcbebdb2b0eb950e9144b7f2f02fa", "0xde779332fd6d9f465b20e6a6a17068bd9eb8099e645e126c5ec4b01df1cb55da421916cd7a563e564895cf2511754e1", "0x92dc96c5c90e4a4e20a4cc830355b613eab563b9cb9b14af48de62916116cc249eda46862b4676a303984e5006cae4a", "0xe6467206b01d8ecaea8fdd90675022b9d62cbd8685978d49df16aef14c96dda37955922adef7cf0ce5e70667934f1c", "0x33f8a5722e1821e1f8c5f4aeb067bfcab205abe6c371677f1cea39accc8cc574af258075a0918f6778263817954d908", "0x130fe108a81a7753e3f765d559da93e49907f3bcb160ed13cf4fd2a6884e312f05ffe06b5bec5a38ecbb7806f62dcc79", "0xcd24160fefddfaa66c9468a5c5e051f326dbaef7f17399b2f2f405981e6aca41db75f4d675bac7aed2b433f922616d3", "0x17f2b41158bbf2cb53644eae30ce07f0ccb46385c2b2b40a6e0c09afc5dbcf4dffd7fc0582d362ba811d62d7264e9909"];
        let f = ["0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x66ba50e8c99edbeedf33b876935c3e1b9cf1af588eafb63c6a64d7c9213ad89ad6e2940079b43033d2c6148ace378dd", "0x0", "0x0", "0x0"];
        let xs = [true, false, true, false, true, false, true, false, true, false, true, false];
        let p = p.into_iter().map(|(x, y)| [FieldElement::<BLS12381PrimeField>::from_hex(x).unwrap(), FieldElement::<BLS12381PrimeField>::from_hex(y).unwrap()]).collect::<Vec<_>>();
        let q = q.into_iter().map(|(x1, y1, x2, y2)| ([FieldElement::<BLS12381PrimeField>::from_hex(x1).unwrap(), FieldElement::<BLS12381PrimeField>::from_hex(y1).unwrap()], [FieldElement::<BLS12381PrimeField>::from_hex(x2).unwrap(), FieldElement::<BLS12381PrimeField>::from_hex(y2).unwrap()])).collect::<Vec<_>>();
        let m = m.into_iter().map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let xc = c.into_iter().map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let xf = f.into_iter().map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap()).collect::<Vec<_>>();
        let (c, f, s) = get_root_and_scaling_factor(1, &p, &q, &Some(m.try_into().unwrap()));
        assert_eq!(c.to_vec(), xc);
        assert_eq!(f.to_vec(), xf);
        assert_eq!(s.to_vec(), xs);
    }
}
