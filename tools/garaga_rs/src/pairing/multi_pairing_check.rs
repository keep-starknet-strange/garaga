use crate::algebra::extf_mul::{direct_to_tower, tower_inv, tower_mul, tower_to_direct};
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::algebra::polynomial::Polynomial;
use crate::definitions::{CurveID, CurveParamsProvider};
use crate::frobenius::{frobenius, get_frobenius_maps_ext_degree_12};
use crate::pairing::multi_miller_loop::{
    bn254_finalize_step, conjugate_e12d, double_and_add_step, double_step, extf_inv, extf_mul,
    miller_loop, precompute_consts, remove_and_compact_elements_given_sparsity, triple_step,
};
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::{IsField, IsPrimeField, IsSubFieldOf};
use lambdaworks_math::traits::ByteConversion;

pub fn get_max_q_degree(curve_id: CurveID, n_pairs: usize) -> usize {
    let line_degree = match curve_id {
        CurveID::BN254 => 9,
        CurveID::BLS12_381 => 8,
        _ => unimplemented!(),
    };

    let f_degree = 11;
    let lambda_root_degree = 11;

    match curve_id {
        CurveID::BN254 => {
            // Largest degree happens in bit_10 case where we do (f*f*C * Π_n_pairs(line)^2 * Π_n_pairs(line))
            4 * f_degree
                + 2 * lambda_root_degree
                + 4 * line_degree * n_pairs
                + line_degree * n_pairs
                - 12
        }
        CurveID::BLS12_381 => {
            // Largest Q happens in bit_00 case where we do (f*f* Π_n_pairs(line)^2 * Π_n_pairs(line)
            4 * f_degree + 2 * line_degree * n_pairs + line_degree * n_pairs - 12
        }
        _ => unimplemented!(),
    }
}
fn get_final_exp_witness<F>(f: &[FieldElement<F>]) -> (Vec<FieldElement<F>>, Vec<FieldElement<F>>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    use crate::io::{element_from_biguint, element_to_biguint};
    let f = f.iter().map(element_to_biguint).collect::<Vec<_>>();
    let curve_id = F::get_curve_params().curve_id;
    let (c, wi) = crate::pairing::final_exp_witness::get_final_exp_witness(
        curve_id as usize,
        f.try_into().unwrap(),
    );
    let c = c.iter().map(element_from_biguint).collect::<Vec<_>>();
    let wi = wi.iter().map(element_from_biguint).collect::<Vec<_>>();
    (c, wi)
}

pub fn get_root_and_scaling_factor<F, E2, E6, E12>(
    p: &[G1Point<F>],
    q: &[G2Point<F, E2>],
    m: &Option<Polynomial<F>>,
) -> (Polynomial<F>, Vec<FieldElement<F>>, Vec<bool>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
    FieldElement<F>: ByteConversion,
{
    assert!(p.len() >= 2);
    let f = miller_loop(p, q);
    let mut f = direct_to_tower(&f.get_coefficients_ext_degree(12), 12);
    if let Some(m) = m {
        let m = direct_to_tower(&m.get_coefficients_ext_degree(12), 12);
        f = tower_mul(&f, &m, 12);
    }
    let (lambda_root, scaling_factor) = get_final_exp_witness(&f);
    let curve_id = F::get_curve_params().curve_id;
    let lambda_root_or_inv = match curve_id {
        CurveID::BN254 => lambda_root,
        CurveID::BLS12_381 => tower_inv(&lambda_root, 12),
        _ => unimplemented!(),
    };
    let lambda_root = Polynomial::new(tower_to_direct(&lambda_root_or_inv, 12));
    let scaling_factor = tower_to_direct(&scaling_factor, 12);
    let scaling_factor_sparsity = vec![
        true, false, true, false, true, false, true, false, true, false, true, false,
    ];
    for i in 0..scaling_factor.len() {
        if !scaling_factor_sparsity[i] {
            assert_eq!(scaling_factor[i], FieldElement::from(0));
        }
    }
    (lambda_root, scaling_factor, scaling_factor_sparsity)
}

fn bit_0_case<F, E2>(
    f: &Polynomial<F>,
    q: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>,
    ris: &mut Vec<Polynomial<F>>,
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
    let new_f = extf_mul(new_lines, None, Some(qis), Some(ris));
    (new_f, new_points)
}

fn bit_00_case<F, E2>(
    f: &Polynomial<F>,
    q: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
    qis: &mut Vec<Polynomial<F>>,
    ris: &mut Vec<Polynomial<F>>,
) -> (Polynomial<F>, Vec<G2Point<F, E2>>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let mut new_lines = vec![f.clone(), f.clone(), f.clone(), f.clone()];
    let mut new_points = vec![];
    for k in 0..q.len() {
        let (t, l1) = double_step(&q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1.clone());
        new_lines.push(l1);
        new_points.push(t);
    }
    let mut new_new_points = vec![];
    for k in 0..q.len() {
        let (t, l1) = double_step(&new_points[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_new_points.push(t);
    }
    let new_f = extf_mul(new_lines, None, Some(qis), Some(ris));
    (new_f, new_new_points)
}

fn bit_1_init_case<F, E2>(
    f: &Polynomial<F>,
    q: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
    c: &Polynomial<F>,
    qis: &mut Vec<Polynomial<F>>,
    ris: &mut Vec<Polynomial<F>>,
) -> (Polynomial<F>, Vec<G2Point<F, E2>>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let mut new_lines = vec![f.clone(), f.clone(), c.clone()];
    let mut new_points = vec![];
    for k in 0..q.len() {
        let (t, l1, l2) = triple_step(&q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_lines.push(l2);
        new_points.push(t);
    }
    let new_f = extf_mul(new_lines, None, Some(qis), Some(ris));
    (new_f, new_points)
}

fn bit_1_case<F, E2>(
    f: &Polynomial<F>,
    q: &[G2Point<F, E2>],
    q_select: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
    c_or_c_inv: &Polynomial<F>,
    qis: &mut Vec<Polynomial<F>>,
    ris: &mut Vec<Polynomial<F>>,
) -> (Polynomial<F>, Vec<G2Point<F, E2>>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let mut new_lines = vec![f.clone(), f.clone(), c_or_c_inv.clone()];
    let mut new_points = vec![];
    for k in 0..q.len() {
        let (t, l1, l2) = double_and_add_step(&q[k], &q_select[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_lines.push(l2);
        new_points.push(t);
    }
    let new_f = extf_mul(new_lines, None, Some(qis), Some(ris));
    (new_f, new_points)
}

fn bit_01_case<F, E2>(
    f: &Polynomial<F>,
    q: &[G2Point<F, E2>],
    q_select: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
    c_or_c_inv: &Polynomial<F>,
    qis: &mut Vec<Polynomial<F>>,
    ris: &mut Vec<Polynomial<F>>,
) -> (Polynomial<F>, Vec<G2Point<F, E2>>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let mut new_lines = vec![f.clone(), f.clone(), f.clone(), f.clone()];
    let mut new_points = vec![];
    for k in 0..q.len() {
        let (t, l1) = double_step(&q[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1.clone());
        new_lines.push(l1);
        new_points.push(t);
    }

    let mut new_new_points = vec![];
    for k in 0..q.len() {
        let (t, l1, l2) =
            double_and_add_step(&new_points[k], &q_select[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_lines.push(l2);
        new_new_points.push(t);
    }

    new_lines.push(c_or_c_inv.clone());
    let new_f = extf_mul(new_lines, None, Some(qis), Some(ris));
    (new_f, new_new_points)
}

fn bit_10_case<F, E2>(
    f: &Polynomial<F>,
    q: &[G2Point<F, E2>],
    q_select: &[G2Point<F, E2>],
    y_inv: &[FieldElement<F>],
    x_neg_over_y: &[FieldElement<F>],
    c_or_c_inv: &Polynomial<F>,
    qis: &mut Vec<Polynomial<F>>,
    ris: &mut Vec<Polynomial<F>>,
) -> (Polynomial<F>, Vec<G2Point<F, E2>>)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]>,
{
    let mut new_lines = vec![f.clone(), f.clone(), f.clone(), f.clone()];
    new_lines.push(c_or_c_inv.clone());
    new_lines.push(c_or_c_inv.clone());

    let mut new_points = vec![];
    for k in 0..q.len() {
        let (t, l1, l2) = double_and_add_step(&q[k], &q_select[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1.clone());
        new_lines.push(l1);
        new_lines.push(l2.clone());
        new_lines.push(l2);
        new_points.push(t);
    }

    let mut new_new_points = vec![];
    for k in 0..q.len() {
        let (t, l1) = double_step(&new_points[k], &y_inv[k], &x_neg_over_y[k]);
        new_lines.push(l1);
        new_new_points.push(t);
    }

    let new_f = extf_mul(new_lines, None, Some(qis), Some(ris));
    (new_f, new_new_points)
}

pub fn multi_pairing_check<F, E2, E6, E12>(
    p: &[G1Point<F>],
    q: &[G2Point<F, E2>],
    m: &Option<Polynomial<F>>,
) -> (
    Polynomial<F>,
    Option<Polynomial<F>>,
    Polynomial<F>,
    Vec<FieldElement<F>>,
    Vec<Polynomial<F>>,
    Vec<Polynomial<F>>,
)
where
    F: IsPrimeField + CurveParamsProvider<F> + IsSubFieldOf<E2>,
    E2: IsField<BaseType = [FieldElement<F>; 2]> + IsSubFieldOf<E6>,
    E6: IsField<BaseType = [FieldElement<E2>; 3]> + IsSubFieldOf<E12>,
    E12: IsField<BaseType = [FieldElement<E6>; 2]>,
    FieldElement<F>: ByteConversion,
{
    assert_eq!(p.len(), q.len());
    // let n_pairs: usize = p.len();

    let (y_inv, x_neg_over_y) = precompute_consts(p);

    let loop_counter = &F::get_curve_params().loop_counter;

    let (mut qis, mut ris) = (vec![], vec![]);

    let (c_or_c_inv, scaling_factor, scaling_factor_sparsity) =
        get_root_and_scaling_factor(p, q, m);
    let w = Polynomial::new(scaling_factor.clone());
    let compact_scaling_factor =
        remove_and_compact_elements_given_sparsity(&scaling_factor, &scaling_factor_sparsity);

    let lambda_root;
    let lambda_root_inverse;
    let c;
    let c_inv;

    let curve_id = F::get_curve_params().curve_id;
    match curve_id {
        CurveID::BLS12_381 => {
            lambda_root = None;
            lambda_root_inverse = c_or_c_inv.clone();
            c = None;
            c_inv = conjugate_e12d(lambda_root_inverse.clone());
        }
        CurveID::BN254 => {
            lambda_root = Some(c_or_c_inv.clone());
            lambda_root_inverse = extf_inv(&c_or_c_inv, Some(&mut qis), Some(&mut ris));
            c = Some(c_or_c_inv.clone());
            c_inv = lambda_root_inverse.clone();
        }
        _ => unimplemented!(),
    }

    let mut f = c_inv.clone();
    let mut qs;

    let mut q_neg = vec![];
    if loop_counter.contains(&-1) {
        for point in q {
            q_neg.push(point.neg());
        }
    }

    let start_index = loop_counter.len() - 2;

    if loop_counter[start_index] == 1 {
        (f, qs) = bit_1_init_case(&f, q, &y_inv, &x_neg_over_y, &c_inv, &mut qis, &mut ris);
    } else if loop_counter[start_index] == 0 {
        (f, qs) = bit_0_case(&f, q, &y_inv, &x_neg_over_y, &mut qis, &mut ris);
    } else {
        unimplemented!();
    }

    let mut i: i32 = (start_index - 1) as i32;
    while i >= 0 {
        let idx = i as usize;
        if loop_counter[idx] == 0 {
            if idx > 0 {
                let next_bit = loop_counter[idx - 1];
                if next_bit == 0 {
                    // 00 case
                    let (new_f, new_points) =
                        bit_00_case(&f, &qs, &y_inv, &x_neg_over_y, &mut qis, &mut ris);
                    f = new_f;
                    qs = new_points;
                    i -= 1; // Skip next bit
                } else if (next_bit == 1 || next_bit == -1)
                    && F::get_curve_params().curve_id == CurveID::BN254
                {
                    // 01 or 0(-1) case
                    let q_select: Vec<G2Point<F, E2>> = qs
                        .iter()
                        .enumerate()
                        .map(|(k, _)| {
                            if next_bit == 1 {
                                q[k].clone()
                            } else {
                                q_neg[k].clone()
                            }
                        })
                        .collect();
                    let c_or_c_inv = if next_bit == 1 {
                        &c_inv
                    } else {
                        &c.as_ref().unwrap()
                    };
                    let (new_f, new_points) = bit_01_case(
                        &f,
                        &qs,
                        &q_select,
                        &y_inv,
                        &x_neg_over_y,
                        c_or_c_inv,
                        &mut qis,
                        &mut ris,
                    );
                    f = new_f;
                    qs = new_points;
                    i -= 1; // Skip next bit
                } else {
                    // Single 0 (BLS only)
                    let (new_f, new_points) =
                        bit_0_case(&f, &qs, &y_inv, &x_neg_over_y, &mut qis, &mut ris);
                    f = new_f;
                    qs = new_points;
                }
            } else {
                // Single 0 at the end
                let (new_f, new_points) =
                    bit_0_case(&f, &qs, &y_inv, &x_neg_over_y, &mut qis, &mut ris);
                f = new_f;
                qs = new_points;
            }
        } else if loop_counter[idx] == 1 || loop_counter[idx] == -1 {
            let q_select: Vec<G2Point<F, E2>> = qs
                .iter()
                .enumerate()
                .map(|(k, _)| {
                    if loop_counter[idx] == 1 {
                        q[k].clone()
                    } else {
                        q_neg[k].clone()
                    }
                })
                .collect();
            let c_or_c_inv = if loop_counter[idx] == 1 {
                &c_inv
            } else {
                &c.clone().unwrap()
            };

            if idx > 0
                && loop_counter[idx - 1] == 0
                && F::get_curve_params().curve_id == CurveID::BN254
            {
                // 10 or (-1)0 case
                let (new_f, new_points) = bit_10_case(
                    &f,
                    &qs,
                    &q_select,
                    &y_inv,
                    &x_neg_over_y,
                    c_or_c_inv,
                    &mut qis,
                    &mut ris,
                );
                f = new_f;
                qs = new_points;
                i -= 1; // Skip next bit
            } else if idx == 0 || F::get_curve_params().curve_id == CurveID::BLS12_381 {
                // Single ±1 at the end
                let (new_f, new_points) = bit_1_case(
                    &f,
                    &qs,
                    &q_select,
                    &y_inv,
                    &x_neg_over_y,
                    c_or_c_inv,
                    &mut qis,
                    &mut ris,
                );
                f = new_f;
                qs = new_points;
            } else {
                panic!("Bit {} not implemented", loop_counter[idx]);
            }
        } else {
            panic!("Bit {} not implemented", loop_counter[idx]);
        }
        i -= 1;
    }

    let final_r_sparsity = if m.is_some() {
        None
    } else {
        let sparsity = vec![
            true, false, false, false, false, false, false, false, false, false, false, false,
        ];
        Some(sparsity)
    };

    let frobenius_maps = get_frobenius_maps_ext_degree_12(curve_id);

    match curve_id {
        CurveID::BN254 => {
            let mut lines = bn254_finalize_step(&qs, q, &y_inv, &x_neg_over_y);
            lines.insert(0, f);
            f = extf_mul(lines, None, Some(&mut qis), Some(&mut ris));
            let c_inv_frob_1 = frobenius(&frobenius_maps, &c_inv, 1, 12);
            let c_frob_2 = frobenius(&frobenius_maps, &c.as_ref().unwrap(), 2, 12);
            let c_inv_frob_3 = frobenius(&frobenius_maps, &c_inv, 3, 12);
            f = extf_mul(
                vec![f, w, c_inv_frob_1, c_frob_2, c_inv_frob_3],
                final_r_sparsity,
                Some(&mut qis),
                Some(&mut ris),
            );
        }
        CurveID::BLS12_381 => {
            let c_inv_frob_1 = frobenius(&frobenius_maps, &c_inv, 1, 12);
            f = extf_mul(
                vec![f, w, c_inv_frob_1],
                final_r_sparsity,
                Some(&mut qis),
                Some(&mut ris),
            );
            if m.is_some() {
                f = conjugate_e12d(f);
            }
        }
        _ => unimplemented!(),
    }

    if let Some(m) = m {
        let sparsity = vec![
            true, false, false, false, false, false, false, false, false, false, false, false,
        ];
        f = extf_mul(
            vec![f, m.clone()],
            Some(sparsity),
            Some(&mut qis),
            Some(&mut ris),
        );
    }

    (
        f,
        lambda_root,
        lambda_root_inverse,
        compact_scaling_factor,
        qis,
        ris,
    )
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::algebra::extf_mul::from_e2;
    use crate::definitions::{BLS12381PrimeField, BN254PrimeField};

    #[test]
    fn test_get_root_and_scaling_factor_1() {
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
        let f = [
            "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
        ];
        let xs = [
            true, false, true, false, true, false, true, false, true, false, true, false,
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
        let xc = Polynomial::new(
            c.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xf = f
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree12ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree6ExtensionField;
        let (c, f, s) = get_root_and_scaling_factor::<
            BN254PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(&p, &q, &None);
        assert_eq!(c, xc);
        assert_eq!(f.to_vec(), xf);
        assert_eq!(s.to_vec(), xs);
    }

    #[test]
    fn test_get_root_and_scaling_factor_2() {
        let p = [
            (
                "0x72f26b55fb56be102cd3bc838c66439a3d6160b5c724369afbc772d02aed58e",
                "0x2884b1dc4e84e30fce2f55e418ca01b3d6d1014b772ca79c580e121ca148fe75",
            ),
            (
                "0x72f26b55fb56be102cd3bc838c66439a3d6160b5c724369afbc772d02aed58e",
                "0x2884b1dc4e84e30fce2f55e418ca01b3d6d1014b772ca79c580e121ca148fe75",
            ),
            (
                "0x72f26b55fb56be102cd3bc838c66439a3d6160b5c724369afbc772d02aed58e",
                "0x2884b1dc4e84e30fce2f55e418ca01b3d6d1014b772ca79c580e121ca148fe75",
            ),
        ];
        let q = [
            (
                "0xf0e8184945e8d3483069b5050fd7194c7e35d0c0a30b422f34656d6c94e40be",
                "0x1752c7b6b35af45db602cf367841e5047ffab14de9079ee8fa5e15901dfef27",
                "0xa822a5ba029a28335c8bbffe201ffd56deb5dea4dafbd7f615fd2aa9f5a0acc",
                "0x1228147f83e3ea517fe961ad4b8ee3bf2ade626ec6d9e4fafec17b8404c0341",
            ),
            (
                "0xf0e8184945e8d3483069b5050fd7194c7e35d0c0a30b422f34656d6c94e40be",
                "0x1752c7b6b35af45db602cf367841e5047ffab14de9079ee8fa5e15901dfef27",
                "0xa822a5ba029a28335c8bbffe201ffd56deb5dea4dafbd7f615fd2aa9f5a0acc",
                "0x1228147f83e3ea517fe961ad4b8ee3bf2ade626ec6d9e4fafec17b8404c0341",
            ),
            (
                "0xf0e8184945e8d3483069b5050fd7194c7e35d0c0a30b422f34656d6c94e40be",
                "0x1752c7b6b35af45db602cf367841e5047ffab14de9079ee8fa5e15901dfef27",
                "0xa822a5ba029a28335c8bbffe201ffd56deb5dea4dafbd7f615fd2aa9f5a0acc",
                "0x1228147f83e3ea517fe961ad4b8ee3bf2ade626ec6d9e4fafec17b8404c0341",
            ),
        ];
        let m = [
            "0x590ff61397d0dd212bfc53caae870d85457c4bcfaccb300f066ee143625434e",
            "0xf706ef44c1d0af1cc055f39a02506234d00e8eb3d74a2131fff08abcc77f5ff",
            "0x22a5875254921ffd7da5ae6eba3609b9a258aeb54605464626791e8c2d23914a",
            "0xae461e60176f9fc701510a38855b7b7bbcf7e5ba36080e7d54da24b20b89bf4",
            "0xaae21f01619c3fa4ec0223c3dc06216c285cccb310a2f82381041f00ab0a97b",
            "0xe203da0f9a03b1aac945c0f61fb2673fb43b2aaa206b95ba090599b7a5e8c2e",
            "0x1e2de9ed7968cac14ad4e2c546956c34ec381b30280fda652c0775ee0202237c",
            "0xf3b13b4d08af03303a0db8cbb989aa911eec40dff110a40e2837285a53cdc9",
            "0x242bd1109f659686c79a5ba5d705c69b59a88b64622927b875c780e6f64e6abe",
            "0x1f626f25b03417e492d2dc829a2f34f4ee684f0447a207ed1fe3501ee8a66a12",
            "0x234cc399b032b927dca506524d7f4aeb8f0939709cf6ea1c727f2d3d16f4095b",
            "0x8dd178fb6d5acd8339c2266bcf3504782285acc0c04208d92713b2b39e39f93",
        ];
        let c = [
            "0x25202875a18b48d6e87a29af47945c59bebde6e323ca9e30f07b55b24f193b0f",
            "0xe200b0579a47bb3bc4e8cdff399f10e04552e9e73c45803819fb7aff4be48d4",
            "0x2743277dfb400b1209b242eecb685264d1d38f92b7e202dd946f1c1e893294f5",
            "0x7ce37c37c9a9830297d2b276e1e10592a67e028713dcf49af707a72abcdd23f",
            "0x2209ca34e9632ffe10ec67e9ba10af63294f90671a1e7136ddb0226444e3dd93",
            "0x56824745ec0be7ecd30a7361a37968571854966282b36f9275c1d75a96b4bba",
            "0x21c2ff8564f4b3599e173cc60a49b16b0ae54cb6fd161b3f69becd983863c1f8",
            "0x21dfaf1ab1424f7a1d49d1548ca28958a1477f7783b2b95b17f74a4135c8f0ec",
            "0x2cedae6373f81ff31d527af4bf9944d9cacfc9b69f42e8c899eb37b1c750776a",
            "0x1b4e8f8bab34df2763de3d3ed13db73b40636e335826957af02c5ff75ecf2f7f",
            "0x1da51303ee50de4521c9659455fa7db99219fcb1e47acbb5fc054b575c4de206",
            "0x291ee2a6f851083adcca144de9ddd923bbb33c4bfba59dce6d63b61b27c81f88",
        ];
        let f = [
            "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
        ];
        let xs = [
            true, false, true, false, true, false, true, false, true, false, true, false,
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
        let m = Polynomial::new(
            m.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xc = Polynomial::new(
            c.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xf = f
            .into_iter()
            .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree12ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree6ExtensionField;
        let (c, f, s) = get_root_and_scaling_factor::<
            BN254PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(&p, &q, &Some(m));
        assert_eq!(c, xc);
        assert_eq!(f.to_vec(), xf);
        assert_eq!(s.to_vec(), xs);
    }

    #[test]
    fn test_get_root_and_scaling_factor_3() {
        let p = [("0x59d2a79bda5f8a941d4db9e360a80121d5ef96fd687003db24ddec0e0c3b63d82efa81fe174bb39be8658ef83c8c2d", "0x2df47e8cdf189985d5085bdcebb5ee96e40a033f5d3b7986f6992be16bc35f88c471acf7f68344f543e52fe891285a9"), ("0x105dcc4dce3960447d21d3c1dc39e973aaf31de52219df089bb5f797ac6d3395b71420b50de4f62a6588c9401ffefbd3", "0x17cb6c41f0c4e1a7394ab62a9db0be660d847ccc58358f3f9b63c98d9a7845c52e1e2b0faefd0d854043fd325dd3c34f")];
        let q = [("0x24aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8", "0x13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e", "0xce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801", "0x606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be"), ("0x82dc9154807866eb0f36ccb665a5fc010510bd690ddd7b540e5bf3ff02d81e98b75703a3b3d3c305a70960906e6cb09", "0xdd18d077ad5bd58dabb18d84a6ceebe6375a83dd242851bb4dcf956002c4efb974ffceee6709deb0dcf81d4285e5e60", "0x4a468eb9e206b9833d8e8e2197d3446652372ce5ef50e93c91aa58105d3a281b2e84ddb61535fe1a90bae7e6692f9b0", "0x198fd0ab6249082bf7007d7e8be8992de81f47ae3341c590194fa3bf769a2e5a5253527727115c334e82ed4be8da6c10")];
        let c = ["0x521ad898cee9071ebcbf44d874b1a6540a5a24a4fd9c68f45778308171f9267fab695191d4eab620cf33a8eded7fd2c", "0x5966d7f6d173ea01e1a586966651ab83510fb89f6b2afe45cecf0013c8d5695a1e6a597a9f581d9c26c7bc732af4135", "0x110012a0987f151e6eacf408ccd24b9c3e637b240a4100a3ccdc16d44e3cbdf8393eb3557a64d089a1a115a3eab1a695", "0xfc350acc198fbd5b4d95cfcae897c7118bbf9c0479cff61cdaab0fcd1147d96b5521ac4d7d9acb3a8622465c6b1c0fe", "0x6d44964cce393f36664dfb78c36a4b56c817816904d06056f68e9017165ef8db1a4f97532d5c3bbed4da9a68948c926", "0x86f3ebd100f5f5157bc57f79a49542de5fc03a989fe46f82b0c186b4950da2943f4ad019715bc72d9969488889a609f", "0x18776284b17c0858f647e075e04c49ded673151413b8ce9b65bf572081d748820d57d62d54e14ea09aad1c01c5c5faac", "0x647bb2047c521d397fd0f7ae5bd1a1ce889e14808c4ee8f5bd8e019057fb48dad4ea34d4ff280a7232eada165a4400", "0xa97b4be53ee479681acc5ebfc4fae663d5040baacca25a862aae0152d3543705d87df48c8266658d2a03e597cfec8fc", "0x1338aeb075e78cc7505a5d70f24bb9b22ece2fe9e392d6ff22bbd02e82d79e84d590ca9645b2fc96a09f2ffc8b84a4dc", "0xe608702099837e04fc2e999cbb4b845ab04d0a51ea25ee04675bf96847cb9d629da62d1e4354c04ab5208100a0129af", "0x12c968f3ea7364e3ee21b8b2e8162fd74d36e0786ea6a88c7a10d38aa97360f22cd213ab003cca5a2ae19eefaf128521"];
        let f = ["0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x18bc5b99f39cbf0fd8d087688e9a0930581e2c940247cd0991e7a80fe41d8f58d83f1513f1ca42a0e74df934924892fb", "0x0", "0x0", "0x0"];
        let xs = [
            true, false, true, false, true, false, true, false, true, false, true, false,
        ];
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
        let xc = Polynomial::new(
            c.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xf = f
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree6ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField;
        let (c, f, s) = get_root_and_scaling_factor::<
            BLS12381PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(&p, &q, &None);
        assert_eq!(c, xc);
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
        let xs = [
            true, false, true, false, true, false, true, false, true, false, true, false,
        ];
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
        let m = Polynomial::new(
            m.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xc = Polynomial::new(
            c.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
        let xf = f
            .into_iter()
            .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
            .collect::<Vec<_>>();
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree6ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField;
        let (c, f, s) = get_root_and_scaling_factor::<
            BLS12381PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(&p, &q, &Some(m));
        assert_eq!(c, xc);
        assert_eq!(f.to_vec(), xf);
        assert_eq!(s.to_vec(), xs);
    }

    #[test]
    fn test_bit_0_case_1() {
        let f = [
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
            "0x6e2d5c667e253ffe1d604e9b0c0efb376aaa3e1f2fa8194a9fdd627525394de",
            "0x2dc3c5e55face7c5e2c971b204e63954fbc8ad239d2d152e532c421b7834a99d",
            "0x2ff47505930441520ea2801041714bcb5d41a0ffa81940aec94ea9901fcac97d",
            "0xdab9fd3d1ef5226f76a2af1d6b410d8639501aa55867c1f0779e0422d545f0c",
            "0x2fea029bdb6a10f53ffd60992916c6410e0f53520845bfd3e55f70e8272c8fb3",
            "0x2f329aa1c588e3e4b7d8f5bedbe3c09728563ff0c46ce45b66636cb6ba1ee436",
            "0x2290e74d07afff26a405ca3722d951cb9a512f1c100fa50e29907ad3283e7b83",
            "0x6bd6eba6eb034c98be6fdabbb6f2986a20934fe7f4ccb1aa1cff1983d7d2ae4",
            "0x1ca0c85d7f94b5c6b3543992e315765cb35d0f7d49149a6939c1e7afec80ee3c",
            "0x1f70622e79ccbeb35ecce1f7718bba441de2df4f3e916ca84262a68f9eea11f9",
            "0x2492333e1554b6d2c1ad39913d06e14c6ad3a1569e62952be0e54c3427ea8aab",
            "0x2a9baf66b1ec17ae1f6f435746d944886953830b40efced523794fd2aa17d4a",
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
        let xi = [[
            "0x11a253cbe22e3132c161d5e3e3343657bbd9cf3475b824786b01f9b6b2954451",
            "0x15c7110a9b8d99717d5b36a5ace0ec208511247742b718857d387d03646e962a",
            "0xce691f6829cbf96477c2680a0b89f055de1342852e78bf44a00a771618a2fb9",
            "0x1dbb1eac7562ccccd643bd095a91457d40cdc83000932991e9eb0d518a123ac8",
            "0x334cb5ce87c27266ceb11f14868d44bc2b0d0642fe2d03cccf424afcde8fb8f",
            "0x2fad54548575eabff6e9ff91ccec2fd782accb81b070e6920fff020ab182dcab",
            "0x205830d2f4414548e1226815b77fa991c4ad82698e2714e9fe8186d3eb02a938",
            "0x20e43c4e7765ce864bc67ee78d7ee54a77de4888351a6f55e1014a7ba6b7db7d",
            "0xf5529f07c581dfe555a1997f4037a95be74e5a845fbe8ef3bfee3bfa46bafee",
            "0x2fdbcae39c35e9916e344eca4617e328542adda118c9c7647a66752f0f9312be",
            "0x22cece7898caa51dc9b45b37d3bcab7bee6bf46a8bb62a59772f9bfba17143c7",
            "0x237133eb50789ad88140f3acabdd1e0eb4f1a5ba81f2dbcf40379242cfcbcebc",
            "0xd6bc07c1405393e2a04f16c95d908468731b135ec8df7280a411bbf74bc2a97",
            "0x1c8f529ca5c5f3db100755ee2b62b30fbac4ee36be96a2991bb5c5df10409f30",
            "0x29692f0b8e65ae15c851e5558aba62671dbbad538149b59ada944f8913daab87",
            "0x2091081625469e0549f3ad0902bb68b780db24524a08fcab699a012dead87cb5",
            "0x15420ca5e286164b842ccdd5ede9c9d488836ae7e4250735d913bc865c686ffd",
            "0x2910950b8c5e2f956ea34c9f80bedc007437f5be8a2d391182d57cc107d44ceb",
            "0xcddf598527c71f4c6fe7f3a63f2a6088c35d97703d6a457935d29e9e80f32eb",
            "0x26ffdefe8388fcb1b412d6d5da117ad677c3d01634e46a148db9582257e95966",
            "0xd6ab9f93f6f075e4d50a47dfd2b76c7891b8a7d309beb55e52ff2573ee2f439",
            "0x488ebca58142b146b8891ec91c9eb2f7dd13a31d648eb3b58337aa3f473f7c",
            "0x4a5388ce5bbca66cb7b57f8d1ef6d825f32ba5dee832d7120c24de5db34b0d1",
            "0x6d4d58288e64b3cc7248a086e64f07c9edd468fe1339b6475c6cabe949e4492",
            "0x27a0872bf114a6aff047a0c387c16408308894a8586b2ceca263af44b9e5e2ad",
            "0x212c049231594608761ee58f620b6744e388ff939835e413e987b16a53ac10ee",
            "0xd6fb3a414a6bf136a738e599e89ac51c2bc026a344b709e78b931803d9eb471",
            "0x2d5fd74719cbc5e3b6e5d5acbe6d908e436163e27df30a584573e7beecee6a8c",
            "0x2b238a056fc7b2b14b73eaef6efba5a7fb9ac70d230379d1c72d70fa80ec5f83",
        ]];
        let xj = [[
            "0x6e2d5c667e253ffe1d604e9b0c0efb376aaa3e1f2fa8194a9fdd627525394de",
            "0x2dc3c5e55face7c5e2c971b204e63954fbc8ad239d2d152e532c421b7834a99d",
            "0x2ff47505930441520ea2801041714bcb5d41a0ffa81940aec94ea9901fcac97d",
            "0xdab9fd3d1ef5226f76a2af1d6b410d8639501aa55867c1f0779e0422d545f0c",
            "0x2fea029bdb6a10f53ffd60992916c6410e0f53520845bfd3e55f70e8272c8fb3",
            "0x2f329aa1c588e3e4b7d8f5bedbe3c09728563ff0c46ce45b66636cb6ba1ee436",
            "0x2290e74d07afff26a405ca3722d951cb9a512f1c100fa50e29907ad3283e7b83",
            "0x6bd6eba6eb034c98be6fdabbb6f2986a20934fe7f4ccb1aa1cff1983d7d2ae4",
            "0x1ca0c85d7f94b5c6b3543992e315765cb35d0f7d49149a6939c1e7afec80ee3c",
            "0x1f70622e79ccbeb35ecce1f7718bba441de2df4f3e916ca84262a68f9eea11f9",
            "0x2492333e1554b6d2c1ad39913d06e14c6ad3a1569e62952be0e54c3427ea8aab",
            "0x2a9baf66b1ec17ae1f6f435746d944886953830b40efced523794fd2aa17d4a",
        ]];
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
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        let (f, p) =
            bit_0_case::<BN254PrimeField, Degree2ExtensionField>(&f, &q, &y, &x, &mut i, &mut j);
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
        assert_eq!(i, xi);
        assert_eq!(j, xj);
    }

    #[test]
    fn test_bit_0_case_2() {
        let f = ["0x6dcf1ec2bee9d55fd7c7dd01f0d89e52ce00053fb4cd271af8ac67e915aa56c1f18943cf63d7acf09f9e238c86f7575", "0x7f05f480f32402899fc238d5e397600577a07eddd78a63793400f32912e689ef50ff7298c542fcbddc8a2f30326ff28", "0x71d870e4553f214175e57f71397705b5336a8c404e29abab7505079976315ae30aea8c7fc8e47f2ce78aed551c79270", "0x37df42454ed3974bb2b32f97123a17956e452893cabef6a29a0888f8ce8b899253e37ae32f0ae88611fa10260d597c0", "0xba703f387adf415b877fd75815f8322190dde62bdc8a55e54b5dec1284a8c9177b3c945a72f0e1e9c109d242988e116", "0x14068f72159c932c910dd5126f8907d9616c496a0f51dbcc5585ddebaf32dc4e03ae577f1f07d02f85fc8a875e197521", "0x17dfc12834ee7334831b24af1174df6680c4991d4d20cc807c5e8df6083d142e2fd17ccfce6bb359366acbb7781372b9", "0x17d3b0da632dabdf4ba0f6c890308dd36ed98b5e1d50a8160a2349e79dd3de20eea74d8b95daa3bc8b9ac34a59ff12f0", "0x17ddaa28e29c2317b96c21b7fd31f8f2bab3cabf17b82c770ed0c77db94e0738119993eb4c5d01ef3358bf5ad26286cc", "0x22b2500baf6ce28a86979f31387bb67348f155192cf97f99aeb257fdcdc23c15eb5315ea817f28532b8d5198e199dd", "0x6524f53a10bd1ed1f7de6acc2d4414912600bfec37d116a4d096e4e54120fe17325dec0b0e382b90ef6654c3bd2e20c", "0xebb85352772f284d12c95bf531a0f1fc69bf6acd1695e9af23d641db780ebb70c7fbfbe8a680e766390ddaa62af47cd"];
        let q = [("0x122915c824a0857e2ee414a3dccb23ae691ae54329781315a0c75df1c04d6d7a50a030fc866f09d516020ef82324afae", "0x9380275bbc8e5dcea7dc4dd7e0550ff2ac480905396eda55062650f8d251c96eb480673937cc6d9d6a44aaa56ca66dc", "0xb21da7955969e61010c7a1abc1a6f0136961d1e3b20b1a7326ac738fef5c721479dfd948b52fdf2455e44813ecfd892", "0x8f239ba329b3967fe48d718a36cfe5f62a7e42e0bf1c1ed714150a166bfbd6bcf6b3b58b975b9edea56d53f23a0e849"), ("0x893227b499dab30e15b606ec3c375f9fabf7fbb574b9b11c9eefbe33fae82066297e23c518f59e74d5cf646cec6464f", "0x10578234a81819d1ebb3d77b03a128f3165642386fff1b0a74ad73c139425703a991ce459cdc1995351adff98061f0ea", "0x16efa85752a02d4358a92eb3b577c1e27a02ec36000c44403159baf7022541a02104b633549e05b774e1b76343a8e661", "0xaf65df48a519d9209257e3df9fb0a1bd3491799091df954380242592db0bead0ddd62dbe33aeeaf1d4a63bdbc4c6008")];
        let y = ["0x6ce420ceafa50ff15baa710e1633d7893404a18b69ef5316a81b182dadbe66bb0ef4fe49ffa578c7698795e6d4a12cb", "0xf45ba6de68a0f1ab26ba5fac564f3f21a75239243fae800e2a8665fd9699e2795c674834c6ce016370aee9e4a1d38d1"];
        let x = ["0x7f2db8fbcf121365e92ce3d77bf5d9a3537b5422e894c09e00053ace96a5403a8db66fbe03950e93033c5874bbe8046", "0xb190c99770f69f3e912d3ef69f63e082a05a1e63b50eb9a5de3e07b14aed7eded07b2f2b3c42c7e365d2a47945fc285"];
        let xf = ["0x1727a4684524eb2175d31f506b07370100418d3fcd5ad5c5586b3c2927dbffdd38a1a44b46f601ab362202e8276c007d", "0x57d77a9e8e6cd838edc1e63052a64d020d10ab12ab460dd755dec64232750ca866647b373738bbe4943b6aee387caa1", "0x42e0115d1c759474549023340d4f01ea67f2f082b59dec03aa7e22e27bccb5d4840ac815f2c12da594e423a2108737d", "0x54735182a914667a25226c91d61ee1f8c5c6c2e40b633da27379618cb58b0b55c0acff39fe7471a196e8bd9a0db6863", "0x14276d83ecbbeddabdf9bf5d9449deaf0a40d6de94e8347d983e97ed4491a3cda57fabebeb6d788023db42ceefa73d8b", "0xda9195159528161fa4960f25523d4d906c194a134c2695ba34577b4dcbbb76911a90cbb411db147cc5627ef50c9210d", "0x9552828c7dcc07d56efc554f98880b746c6ce0f7f41377d934699dcb5cf7eab408dbe027df4506c40e2424b24c6b69b", "0x122dcaa1ba9a8a8613064735071ae0aeab8e0333d7ff3018c9d51a652303decdf4907f6e7f232224b4fe0b20245f2fd4", "0x112f00e12354b1ad57581a4dde94de861275afae359c3016f8a13e81943a4a18f4896097697c449335ca5f9d21b7f654", "0x13bbf456483cd4566ed59718bd067589e294b4d7084073073fc77a685f0e4ae94092405afc2ecc6d437c20102b74f4ae", "0xeef615cd28929e56a59bf2e2e93db68f2ed629f9872a3b1aefdccb098674950b928bb5c920a2dc4d6405a69dafd98b8", "0xebec00852daa59ee4861f6c55f01d098689453651a335e711a11c3e6606acd9cd851f8132fb24bfa3edf65997e82785"];
        let xp = [("0x19e384121b7d70927c49e6d044fd8517c36bc6ed2813a8956dd64f049869e8a77f7e46930240e6984abe26fa6a89658f", "0x3f4b4e761936d90fd5f55f99087138a07a69755ad4a46e4dd1c2cfe6d11371e1cc033111a0595e3bba98d0f538db451", "0x17a31a4fccfb5f768a2157517c77a4f8aaf0dee8f260d96e02e1175a8754d09600923beae02a019afc327b65a2fdbbfc", "0x88bb5832f4a4a452edda646ebaa2853a54205d56329960b44b2450070734724a74daaa401879bad142132316e9b3401"), ("0x1604bd06ba18d6d65bdd88e22c26eaef8a620a1a9fefe016d00eac356f9ceda8bc8eee5e46f9f4736ab22cff0e8cb9e8", "0x3e5755e9bfc250ff0a03efea22428a36a247504e613980918dc5319efb7f66b10d5fe2e7e86af7e014e1456aeaeac5f", "0x5655a99f7ff904c1e41382c25ff0360d9c51d0e331bfb1e38f5dd41c6909caaf6e313f47f727922109bf8c3204fe274", "0x62ec2ed9b207f63e0d9899ed11f9a125b472586b65bb77b8a04d5d446d15a8701ba5c361a07cd85e0743f5ae2e95a9f")];
        let xi = [["0x4058ae506a6ea2d9acf5767ef521a39416357fba20e7c319ff4bc05fead6c03a9f34ff39427dd30ca948256f8f5e776", "0x15124e81cc29571ada5ab8d3c9d55f5f083502a4b884a87ea770d7087dce6fc1a4143063e431ab1965a326d6cc5cf28e", "0x190d1a256dc8cad275af59ea8f7d203c3bb8c8a34b2078662bbfd23e7e7294f4afd91a8877df524ca96a0a34ec4fc2d4", "0x18881b4d655fddc0574a3f3cbcbfb2ff8dc94eed30e46b6ae7144979716438563e9ba0cf2a2973a17db83db2e5314407", "0xc65c65aa02e44da35031c6b340fc9709367a561d0bf13a144f325beeba0e0f837e91b5218aac9eb1f28c196c093af1d", "0x10fcc3d0cbcae26707dc37c424fa4c3a37744fbaad96c6df4b766075ccfb1f59f458be55d30259657664f11127121f3c", "0x110c58ec3d55cc3593e958640c42d93f05c964469be251ad45a2e7af7646ff0daba3ef5e5618ece1e61f64fdab4dd60a", "0x173e8e07ef932c01bcc0be6e316728d8acdaebb34d0630aabc5960f155c3dc7c94efff23d3a81c5545aed40de3353b24", "0x167b41861a4cf1f89dd265419cffa76667283a684802d8543352088a297ffac030708ca3205c22ff262b4c32af064100", "0x3b4fa4dc3a053fbc445810c88a8198298b1dad990acb6b4ebb7058fa77a680751dd9ac9bb42ae39582ad6ad7647e2d9", "0xa14179662d3280fa96471af03be7fc5feaca5fbbdd79f0eef4b1e354fc4ae6e4fddf497eeb8f3ad8613273537c80c08", "0xf8242af4b8ae30e76ded4ea3db45d278d4782604e03214436fd0ea18d6f45914fd8d25937ae6c7af57f6c1fa36a075a", "0x1859b038205c8a50cb4f91f15b8828a0c649fd9bd316b0d42bef6398bcb47ec124b1c884dd3c52f08396e95ffa0d2048", "0x15ce69cc39bf81686ea6b3e18bd550a9d570a14a9e397c6c1fefad6e5efd209e994f31f93bdad0f5a85cdf7eb8f71f1e", "0x46f25b1914231273bef92307b4a85cf4f558882c65c35cc36e685ba343e66314e03f1a97b91cb45be155085e29255a8", "0x85450ffae0bf84261ee380b516b33ea88e49cca061f6ccc4818232d9a845081eadd269b1d6c86ac42b4a6c88ba177b8", "0x49d9c4120a63a738795739519c8463107763e61e1aadf534ab6477567e6d327c56c45cb93e9be10a894cab32d9186a9", "0x48aba2f406cc53ac0c9d572d6fd9e99ca649a8d2ce390771d4264c0766a974bf4fc6b3222d6596a946a8187ae404004", "0xb3d9d9f100e451e2ff5d3ff32d211a539a0d90f190e3cc0ccf0d2d44ba805072589b66c7f53c916463cdda53fb33bd0", "0x115caccb0b82e44cf7079fd95d8b6cb506de5e6a67f28c6a5ae713497742697960f5e9dc08d75cacc6f0ea6e4f29e76c", "0x1674a25b64d278d9c8747d1d1a532686bce60ab496ba0ba83a26e3d30942f1ef3c7aa05187a258032ee573659693d6e2", "0x14d18d8c6242d9c3b2cfcf95da5628e94694fec1d40f64e432f1a4e79f9b96ed40b3d9cd602855fde8e8f6527570af27", "0x161fb4586486c4828d6de3f6b1da13867f8db7916355427d8573b8891ec2f2e533e4988d374bf52f0868f45e89b47410", "0x1075865248624b63a4b59a293747451724956b8517187e9554770f9c5551534815ff969dcb1857ce1ab2093cf9c9a8b8", "0x9f685cfe49c968d8c596d9f647ec9a2c5b8b45ae16fef8d7cc9ccd858f5b66fc526c01589a93fadef83efc0b865661c", "0x366861d36b3781daea9909bcde600135486e55965744c33f0f88e1a74f270b402fe2a1eb34bd412007a7501bcc0a1e", "0xe53938fd56c7fdf34c21c1b011fb083c02fb12b440c859f910ff0671a8348d38bac8380d170b07f8dd6e50ac18a8dc8"]];
        let xj = [["0x1727a4684524eb2175d31f506b07370100418d3fcd5ad5c5586b3c2927dbffdd38a1a44b46f601ab362202e8276c007d", "0x57d77a9e8e6cd838edc1e63052a64d020d10ab12ab460dd755dec64232750ca866647b373738bbe4943b6aee387caa1", "0x42e0115d1c759474549023340d4f01ea67f2f082b59dec03aa7e22e27bccb5d4840ac815f2c12da594e423a2108737d", "0x54735182a914667a25226c91d61ee1f8c5c6c2e40b633da27379618cb58b0b55c0acff39fe7471a196e8bd9a0db6863", "0x14276d83ecbbeddabdf9bf5d9449deaf0a40d6de94e8347d983e97ed4491a3cda57fabebeb6d788023db42ceefa73d8b", "0xda9195159528161fa4960f25523d4d906c194a134c2695ba34577b4dcbbb76911a90cbb411db147cc5627ef50c9210d", "0x9552828c7dcc07d56efc554f98880b746c6ce0f7f41377d934699dcb5cf7eab408dbe027df4506c40e2424b24c6b69b", "0x122dcaa1ba9a8a8613064735071ae0aeab8e0333d7ff3018c9d51a652303decdf4907f6e7f232224b4fe0b20245f2fd4", "0x112f00e12354b1ad57581a4dde94de861275afae359c3016f8a13e81943a4a18f4896097697c449335ca5f9d21b7f654", "0x13bbf456483cd4566ed59718bd067589e294b4d7084073073fc77a685f0e4ae94092405afc2ecc6d437c20102b74f4ae", "0xeef615cd28929e56a59bf2e2e93db68f2ed629f9872a3b1aefdccb098674950b928bb5c920a2dc4d6405a69dafd98b8", "0xebec00852daa59ee4861f6c55f01d098689453651a335e711a11c3e6606acd9cd851f8132fb24bfa3edf65997e82785"]];
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
        let xi = xi
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xj = xj
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let mut i = vec![];
        let mut j = vec![];
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        let (f, p) =
            bit_0_case::<BLS12381PrimeField, Degree2ExtensionField>(&f, &q, &y, &x, &mut i, &mut j);
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
        assert_eq!(i, xi);
        assert_eq!(j, xj);
    }

    #[test]
    fn test_bit_00_case_1() {
        let f = [
            "0x9f8f3a5142813065834851b0abdb02873b62058c141808bf3d908c4616492b3",
            "0x2e48eb414b93a0b30e2c3f393d3ed30b098663d73b820a07ba724a9917378495",
            "0xbdf45af1f5b4215f808a4d7ad54cfeb6d8eba26084098a37010e1038db40961",
            "0xf6c4c18f9d9acdf9b467c9e83e6ad6cb145da60900ccb524892622686c3b558",
            "0x8c23916cee1cbeefa7be656ef56e78fce55e743b2a38810a29073d9d799fbd6",
            "0x1d16044d319830664057b4957d214455b93b6279e9b5f5ac08dc3072186dc4f3",
            "0x17f1f10e76b4e9fdb704ceb895c3924cf4727927b0ad3ee897b0f656eabd71b5",
            "0x1095b03dcb74d1b11d583e19e6bc9ac57db13a0c4f04625b02e3e1bf6d387c36",
            "0x2d67c398ad69288c687f6f86108390a0cf2dd20821c4399cc18b975d04242497",
            "0x2955c5cde10bd61dadcf00e62f844d042fa55c88603e3fe991e6720bd794401c",
            "0x2ecbad3d0674a417f39baea2524cc0790b3ba9673433d6d3c30f1ede92e895d6",
            "0x11b947c4a0acbee9a2eb50c665bf7a12292ea3bc4cb8e0bfc2f34d527970ee48",
        ];
        let q = [
            (
                "0x23ad66f3a7cca9dc75049635faebd124316244b91de5fb2764cd151572a905f7",
                "0x9edaf0698a8c56f51139588acc094cee3c37d427bb6d2eab830aae529097d1",
                "0x1ad4f87d3b4375a39988ac099b042b1e7c0c715678e4c2bea8905f607cf950f8",
                "0x2700e8a29b7bb45f3022a18a07bdc66d0254559e17cce64e3b4ad21578fcf410",
            ),
            (
                "0x2c261e6771e418f02c5225132405065a249033d6f8799261934c3c9f9b3d33f7",
                "0x270394a3fc58d9e321fcdfb8fffd764208a6caea73d65f24bba0cc1ae0d3750f",
                "0x2cb21d611ecd44169370fcad2b3dcb1d757f0e468ed4cc0d6c680d0d89c3214e",
                "0x1a737173a08f49638e4b84b0fbe900d1831d55c6097a45af5af1ec1eaedb5726",
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
            "0x17774e3e8a23ff734ca1598a87bc0412dd8d117f26c62ee7e94dcb29e0357bb1",
            "0x1982b56c3e0bcdc9c994b0437e4dc0b9527821ca7809068c62de431b5489c670",
            "0x2872b0c088da975ca497c1a9c18ef0ef3993ddfd09077dade5d72d1ad3abd8fd",
            "0x2969378a0cfddacbdbcbcc93eb8642d2dc8167a467acef3ecbb15eee40139640",
            "0x193581cebff836c6d2319b0bfd91255bddcef3eba4383bb93d17ceefd6953d3c",
            "0x26457780a6d80fcc0f23a463b42645f7fec8e6f0a0008e4410656947089801c1",
            "0x24e212fee032cb7c7409ae15eaa0aa0311a810586db2f6f180a6b0cab54e0502",
            "0x260d3e40114b8d2ecb09e3f0e4fcd13eece95b0a7d7b5ce96bac14f5cb32d71b",
            "0x1b1a5d98ae47d8520d89e8c8fa73dbf28988f9670c62aa77588361bf2193aa0c",
            "0x19139c8f3a190fa873462ce2dd5f25690f00ec110f4b62996e365f3421a3259b",
            "0x2143f989b60bcfb4a9887cd610decf67818b14bd709d865aa40c7a52986a5e5a",
            "0x2d87bf0c00e24b175e5363e0de0a1c9ed68f160c43ca0093e2dca54f07586b65",
        ];
        let xp = [
            (
                "0x126a285e45fa024002aa806848f10e5b2c64a25c6af0163612ef34379fd72584",
                "0x1303baa20971befe5aa7458c1164eac4a10108c8abbcd37a1e09d83ee94bdbd5",
                "0x37dedb5d778240b5f237eaa4160f20981e0ed5d24f832e9eb07004e1a722d0c",
                "0x1305fcc05ab211db0fd12d1f8f1f894726dc7bdbfedeab57b33af11d81279c2b",
            ),
            (
                "0xdded79e4d972e50343575387abeef8a0e3c874b791e2c9491e583ed9d1dfd82",
                "0x2e89537cdf57a51d5d306241c3360b78ab60e5fdbca2bebaae6544d0a9fb6d9a",
                "0x1f661619c64b414dfbf50599d40cee296e40fee522ff41a1039e9b21d41a37e6",
                "0x15de46c6b8e5286908252cdc6a905536304a49b95b386e8139797409df7a1527",
            ),
        ];
        let xi = [[
            "0x1b0a3a3d5e555ec6d6bda084d0fad0138fd60d139e23540b5d4a49b45ac56587",
            "0xc191bad21244bcb105c57c9b4967e036b3b7e3ea1ec8778a8a9371f58d430b1",
            "0x1f4207ade61d68bb73fe79838db33e1b17e3857b7fe958ab082c04ac63561f87",
            "0x3ce267d6ec699ef2f104643b6bb6ab6ddfddc83763b2647a99f23941c324142",
            "0x1b3e7e2fbe90dcaf67c060a52268ee3bf1384274580bfab77a2f986369216fa7",
            "0x1f4204f30004aaa5ec1e9e3b9e81d05ba8672bb8db19e9a79df837073a2d493b",
            "0x1c6b68ae31ec29d4014068f482fbe495e277fd1016cf0ca4883e1fe6da155abb",
            "0x2e2e0e7f32035eddd17a6b3e42c6e311081ee61f8a7372f76c9920109d008214",
            "0x243ce082e4280ebbfb5b3c1f2175052d62978b43133d9f61b38790b33222f17e",
            "0x15bc2bb4c2356e76895c57bf67b8d4a2964bb0dbe972a7b446800dfdfe24e6ee",
            "0xea059ff364db12717381403450f58d590818fff46c46fc0aebdabbb0624ace7",
            "0xe292bee9383249aeaef594757561443d0fea89fdca0b2e9bb1cb2b9979c6466",
            "0x14b41af439343d54bd5aa01e3ac5dbf852fe6ae591dbd86765e376787ee3cc0d",
            "0x1dd42fe7d2d0f14e414514edb81e5f7578d0ad524267c77457f5dc16dc8dfa2e",
            "0x1099b52fd7afa1cb074293cca265168ad673ef7ae209f473fd17bea6e168a5bb",
            "0x17fcc96a8db4a93d6470aab33710e1c9b38fb564679c8849635a53b896ddaa01",
            "0x278f744a391cfa66ca77f51e8aac097db3f4589a7a7438207fcbe7734ee67a89",
            "0x9c274d0e18f401ed95a636f9b7e688ea30c8fd32edb8a2b498ed95e6f0d3678",
            "0x298bf2d5da37d9694cd289309a1a3cfb5977aef139b51f6b5586e6e7969c6676",
            "0x23b4dbd772dad9320234a772dad888faf4054fac8cbc73f2078dff2825e9f7dc",
            "0x7e4100c82537ac9286ff99c1eff62318a12c18c63c9f10e59b02531e40b9d4e",
            "0x194fb153c621bb05efe4a0b8ab9ecbd016865ece06cd81862bf80faba6fbb041",
            "0x1df7ec45772db3f999295ff6bdd8333535b1b4b96b19ca3fae0237ba3d883a8e",
            "0x2b0249411af1423381825db72aa8373b35a5687f4d553fff50bad5dee900a989",
            "0x208bb01a1c668e48ac1c862f3daef64529f2bd36ee2ae50aede8a66d7c8be06d",
            "0x2a920d7def469f8e332dc14d6554d260fb8bf21775a45e9550c9cffbf1583f4f",
            "0x9711d36060019a300a8c5ae3d121b0c5350c00adda85e86ce4bf0ce175cb30a",
            "0x5f9cfb1ea6bf7c0053f7f71df63c007829252cad120c40181eed11520f8ef3a",
            "0x8d951ab724ffc54a8b9c5cb73e77a4ef38a0aaebad1b66e954b54d50e61026b",
            "0x2e2c1f50d0f642d878adf4e06190b5d9f44daf16706f494a71168aacc05d0590",
            "0x2513136cc9d436edca83a981b22b66862cf71e478b09f93d38a2898f80938ae8",
            "0xb811f4b5506117dce1adff60d3b331d796cc4b2900897db300d641be0ba59bd",
            "0x2058f15a7df528cc1d8460287e3a0c5cd66116f98bf8d36fae19f595ba683131",
            "0x2fd9e7a48c6d265a6d76368ae6762f2a3cbac6594ca02481cf295198e65ad723",
            "0x25e61d1cdb9d0efa3dfb7a705f9a2f1d649e113b072bc835776080dc692da4ff",
            "0x688733a105f7f2bbf8f1e99f24a881e4f9e1e1a79551cc40d3038e796b23aee",
            "0x14a5bcaf7f082ae94ba1c357ed865c5e73864a7e2a1a5ad55a6e6f20f1b4f88e",
            "0x1afa85300fbc30626fec5727e2b13b4522eea1731747644bc408319746646fbd",
            "0x2b51d05dd1a610997be175ce8d95064e1bdc83b535da2d8ebfcc58f36e8999c",
            "0x1211e87fd861a4ff60aca71a116f379e6d014ebd50cc4b9de88bd476a28a6cd7",
            "0x16a28d23e4e16eb5f46935a6a6c078810254eaca76f3adb24788543bffb6dce1",
            "0x1a9cb5868564b268952c4cff2c1588cbc95f867cfb112d2634b78f6939b1089c",
            "0x167e0bf6a4329f36deb8c0f66377e8706c2c62686b635ec8e7b965a465d765c7",
            "0x1d48e9c952fdd47498442beb72ed468cd0bd1aaa797482777fa0b45df9391e29",
            "0x2be24efdb917338d46cc5776eaa4fd1eec584b3e55c612c754279f2350072ef7",
            "0x12e7dd26b099490c1682623afbfab964afc23f7b18c77df371b233564c1c75d5",
            "0xf872fd57889ff7b68b0206ca3080fde59c7d2c71b043b8fef8ea9d4e7fdfaf1",
            "0x1a305a6ee976d6d5bb781eb230f24fc1e944ab44caead8b97939ead5b206d56e",
            "0x110248593cb658c9dad10ab6ff442f60c708d63144366926c74ece34926b667d",
            "0x2911a9443b7c8e59996bbbfeec60928da492646304d750b48e054150f21ae7c7",
            "0xae050eee5defe765dd9f066e7714f97441b6c7a1da9a169b9ed7cdb0124da8a",
            "0x1b43e5c7e755e6e22a0bcb8ff95e247bb6ba30d845e27c3c6a65088b7d9f8651",
            "0xf68c7b436f14e3dead7e8c7de3c0b4af4dc7d36f922766893a2e9559c8610d2",
            "0xb085935a1ae2fb12dd4aeff87d34da6ea8f1f03cff8cc20ee66e036613a6b08",
            "0x2b39ad399267003696ecd758fb89cc0a1c49551ff69da652404564d56a3d3481",
            "0x144b43003888f26443fa2dc2c7354749117b746a05f8e3ef4a4abaf0afb60600",
            "0xa90bbac85af36a606d100f71b9b1c9f2c705906a83e659ef457c7e952ed0b28",
            "0xfacd123f0294b69dd2508b485842d1cda5cba41270ad7dfbb9fc97f5bb0547f",
            "0x4e6285a710a4dd253ba29e1b0f6ccfc1209b236b01367c612e546bc683c293b",
            "0x1b6948fd0b32c3feb50d66c5ae5685587ac7ffcf1aff3e3601a31201a424db7f",
            "0x4f662e8e1fc8523907b3e887990ab29087bf2f1e7ba12e4ccbf06b474894d81",
            "0x2bf8a1279f19a68c96de2f2115fcf8d0828cca0491c10cb1b97ab200a8499fe",
            "0x65e1427c6c0a7f1c4e20cddea99611b66a4668966b788dd590f6469679c47b3",
            "0x91660f9429fc5f9985030ea064d3d7aaf2234eee7320c1c730c08a8413869a8",
            "0x87e9d609a0f6c29d4e57bf4a3e1743f6b698486d689569033a5f987a24347fd",
            "0x2c5528aca016c80f5aea6e50df4ba106b830de16871528264bcf3bfeb5bffceb",
            "0x1a94deec61949e75978d9c94826b8bfa8e6f4a20751f5a17374694d5aa93e715",
            "0x60845a0f779048ec9a712ce5da33a370b785401d838b6d92e1177ff7113265d",
            "0x1fd4046339acb4631e26777abde4a0de9d2bb27cc226dcf6c03ca1520366c8eb",
            "0x1943e7070264148ca273df06a7bcd984ba03497dc86cd5480e0c072a1c2bfda9",
            "0x2cf34e981d2335162e7a8c523110a9ac4042df6181038ebd4080ffb5100e1751",
            "0x13230369b80fe2e6c83adae77dbb3d8d7b6ac03073afb55b45dc2e9360de216f",
            "0xe4e4fff31c6a7b4dbe201ce9b4271bf28e1f52ea3e5ceef05dbf29db763e65",
            "0x1a630eb03a920cf31ed396a0b1f900fb699350244c6b8790c12e0dd9241470fe",
            "0x1644c6bd2f50746f3d469743b173655b5665ea0eb77070785efce560b681463a",
            "0x2935c80cbd7a4336883fb448ee6750c75ff4037f996f2040e2bc0bb2066f17ba",
            "0x2ee3eb795e73b84f1d042b472b98b5f884ce32b5bc36b05787d33831a504fd80",
            "0x22ca9da95fc7621796cff16d5a7538d711eb230aca1667afb948910b2aa767a8",
            "0x2d529009c37ddf423d9264df6743990d63604bb168cbdef2bc6a99e886fe8452",
            "0x2407471f7d9339927a72aac4a02eb1f2b2999a6892f5869a54587f4842100434",
            "0x66103e919367b340c163e96eadbd09c01b616f075baa12d999c5af10af900e7",
            "0x28c276632422a69e7dc41ed859375de537917402930e3c3733df4fa8e30df41f",
            "0x2f088812877deb6674478c892a6277820b4836151bc7bca42f4af5cc1135d160",
            "0x1340222ea17d6c3ae591db414b6ba52c14881e2595e9be814df595cd038d6628",
            "0x18514fbb98af7b4ef58db81dd0d1e195a1e3e6d094856f2c457dd19b6c6fa9cc",
            "0x70d71dc0012610f06b23ffae222632103d468d952e2c274848c3d28f4f66d3f",
            "0x5358f254bd79cfcb37aea816e287d08f86b324fd9ea61beea1eff33ee3eb374",
        ]];
        let xj = [[
            "0x17774e3e8a23ff734ca1598a87bc0412dd8d117f26c62ee7e94dcb29e0357bb1",
            "0x1982b56c3e0bcdc9c994b0437e4dc0b9527821ca7809068c62de431b5489c670",
            "0x2872b0c088da975ca497c1a9c18ef0ef3993ddfd09077dade5d72d1ad3abd8fd",
            "0x2969378a0cfddacbdbcbcc93eb8642d2dc8167a467acef3ecbb15eee40139640",
            "0x193581cebff836c6d2319b0bfd91255bddcef3eba4383bb93d17ceefd6953d3c",
            "0x26457780a6d80fcc0f23a463b42645f7fec8e6f0a0008e4410656947089801c1",
            "0x24e212fee032cb7c7409ae15eaa0aa0311a810586db2f6f180a6b0cab54e0502",
            "0x260d3e40114b8d2ecb09e3f0e4fcd13eece95b0a7d7b5ce96bac14f5cb32d71b",
            "0x1b1a5d98ae47d8520d89e8c8fa73dbf28988f9670c62aa77588361bf2193aa0c",
            "0x19139c8f3a190fa873462ce2dd5f25690f00ec110f4b62996e365f3421a3259b",
            "0x2143f989b60bcfb4a9887cd610decf67818b14bd709d865aa40c7a52986a5e5a",
            "0x2d87bf0c00e24b175e5363e0de0a1c9ed68f160c43ca0093e2dca54f07586b65",
        ]];
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
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        let (f, p) =
            bit_00_case::<BN254PrimeField, Degree2ExtensionField>(&f, &q, &y, &x, &mut i, &mut j);
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
        assert_eq!(i, xi);
        assert_eq!(j, xj);
    }

    #[test]
    fn test_bit_00_case_2() {
        let f = ["0x10bbd67a2e6b8bd12ca2a8fc9ebb9d7748bb4b630bb9e8ad6ff87ec4e2647706b3fde59249168a1f3a22e43aa9131c14", "0x10b832788eae08063407690bf13628a4c95b6fc55a9eef6a4e4e1893305748d5ffd9fef14dbbf2265569906a0d24b1bb", "0x19496c56f34ced68a7cd75ca45a97406d2a99dc971e2c9ebd6ec68233a19bba472836ae01acce936e2cf8c477b127acb", "0x925d1d1ef9c0beba6f0a34cac08da0adfb221ad320d929c4a12e88d4c855c6e93e88d2422cc017e588ebe02c9d8944d", "0x63551db5a468540a882a52a9fc100a34798496f25a17711a0f7fe84c2f3b0c22ea84f0e3de8b6df17b043f047eb3d95", "0x1452bf2c3fe715937d83b5c57df5b7b9df88e4cf55e829b75743d3be8818de60a9a1a5156acb9303682c1c8ca5fac965", "0x159fe260119fbb98baf253f4e0f865fe70bcd3a215ac2d2e10d9eea83bb012f8e01a28ebe1e1ab9e46108a3da2287de", "0x2cf0869f40402c8b16429547884c156e8281d85d5a0ee4e6fa097bc9669f5a4c6e33dbebe7a9434b3beb015897656bd", "0xd2c631a38ce47d9e8f0ee1fc2ccd8f589dd387f86500444d3dded1b3595c3ce4312a36a95cdf327419c78b6710a6c8c", "0xcaa4d999eec4b8f23cb8406c8fb3405378036f4c5867363b504394fbc5fc5b04e7a846507e6f24ade84350245ac9e72", "0xdca015d5a2e52becd816f7a434f9cece5b000d281057b64de60f93bdf429d379caaf598e7e990c95a109a8caa63a02b", "0x6995ffd83bb53d7b9787c81663ec0365e65c06194887eb1591ab99d664c7bb9537bd1bd1b9bf5b1707249c394b385b4"];
        let q = [("0x152110e866f1a6e8c5348f6e005dbd93de671b7d0fbfa04d6614bcdd27a3cb2a70f0deacb3608ba95226268481a0be7c", "0xbf78a97086750eb166986ed8e428ca1d23ae3bbf8b2ee67451d7dd84445311e8bc8ab558b0bc008199f577195fc39b7", "0x845be51ad0d708657bfb0da8eec64cd7779c50d90b59a3ac6a2045cad0561d654af9a84dd105cea5409d2adf286b561", "0xa298f69fd652551e12219252baacab101768fc6651309450e49c7d3bb52b7547f218d12de64961aa7f059025b8e0cb5"), ("0xbfa363ea499e05a429d9af2a73ba635e0ff3825edddacfab8afc6b9188700c835282a2c4c7effe70dc61c557b8d90e1", "0x5c3fefe5849b36814f32ce71dee6eba467b220e1b53f01421b9ec6d23209f6206e864539ddaa327b085ad8d78a8589b", "0x17b304f1c4f58afee1ecd75f1570b13da2ee02dfc5731f82ac55d5b6d011ce70ae42061b3d205cbe49efdfcd8d2c04b4", "0x101d88f38de6be9d7eb2c074905585f487715b3e6d8179a066ba56988207caa28f7a5f1ba2f7abd01e200ac71d198282")];
        let y = ["0x6ce420ceafa50ff15baa710e1633d7893404a18b69ef5316a81b182dadbe66bb0ef4fe49ffa578c7698795e6d4a12cb", "0xf45ba6de68a0f1ab26ba5fac564f3f21a75239243fae800e2a8665fd9699e2795c674834c6ce016370aee9e4a1d38d1"];
        let x = ["0x7f2db8fbcf121365e92ce3d77bf5d9a3537b5422e894c09e00053ace96a5403a8db66fbe03950e93033c5874bbe8046", "0xb190c99770f69f3e912d3ef69f63e082a05a1e63b50eb9a5de3e07b14aed7eded07b2f2b3c42c7e365d2a47945fc285"];
        let xf = ["0x7f7956e7258b204e6bb76fb6530b54704b338c9e41d551b4c65d12afeff17a68cd917da4aa7f5d7f85dd4c4af5e97a3", "0x61f63de6863a0737ea4c564fb2649c3298b59c310e023469e9f6a61c9d21a413a15b875c3b5ae69e8bc70cc1642be88", "0xd54ccfbe6ce28ca435fb866b16f94ad9149d23b673b8b033c7415a182a906c0c440ec19e65eff130e3bf3e78e64a8d5", "0x5b0b2403b504c7c3c04fa2649405e14816e285681f6d10877632f67dd17dd934dcdc3b3d59039e2f71aab9d24fe1f50", "0x120e02660f9058203246fbf0112482fcc1899b14e6ac805c02a2d7664553675a1cd30ab8eef17c2cd5a8e39666056b16", "0x848bb58f7c097a46b3a03ed0f1e29a3fe03f4e210140c9f40bce68d096dad390d28e98224a2242169998bd45bcfecd", "0xdc72aced2c6f4a5c4819c14494f27de393ef818bbd4517d07dd58a061d1a3e0141a6e2e95f2d0acc60f04b266569319", "0x4a715b7a58dc6543add0fc9ea5a83207f896f6abf8ab0e2333622e9b8f46b0713f2f072d77df88de226de432ab03d2b", "0xc04235cb1fe7822f16be8bc01f84be86960bad82590ceca82fde4beda8b9e6a5885c858c2816abbab513ff9a9c7b5d1", "0xe44406c2cb2d23cae0a6ab38bf6b02312251b650e69f258a269f5787fd2b0bd9ed885f0edb79bdcbaa9dc247ec2effa", "0x86501a5cf1b338e3103b59e485f10c54276bce940584dc74efb1890226e01d82c5dd98529dfd9eaed5f6ee84dbefdc7", "0x10a91f5f4e43b2f252c415e2034cc18aa5ab46c409e63ff37f5499c66dc28fbd4c3207007302b90bf0cd9d620156bc89"];
        let xp = [("0x76147fc1a30a666d36b43fa11419b6fa517b642c143cc2ad863426f2c7832c9c9fb62fd3c6f9dc94801523782f9b37b", "0x12f4b28115b81c38e3bbf17cf69059247c386ecccbaed914cbf1417f24431096f49191365acd1aafeffe8c4489a89415", "0x164aaf1243752293eb1376a3448bc1941c8b25df7cfd0bcb708514d7f477439817f367d8ffbf02b95629d336e7da1574", "0xe46ddd6615bd3583b69fe7156087f35ed4b8896375ccd7f52459f56836fa38e0b596d289800df74c3a361e813b24550"), ("0x86fe5ccf8266e2300ca10c33b1c74cfa6cb698664f6c984cc2545f9c89af0520d755ca7ffdbc37d75f20fff15e4518", "0x18c767f073bb43219f813ed472efb42787e62706503974e6c49c10fd5a41e617f592da748faf3e3d7139b54f8accc080", "0x558b3b314565e03cfdec488e39e9c099eebea93016d9e1e3a93bec47068d4dad9910792eb85c8382bc646aede853bff", "0xcd8cc6ed38c417768827084f4d1e22c516dbaf1a90f29c2249210c3476f70251f1923bca1422ba5f9f4f6db107339ec")];
        let xi = [["0x11ba967b8fcf46c439d636b9e14c3edd68e62dc6cc493f4e1a7c214779913dd40e5ebc6bfbae882c56c11ff73e7bed8f", "0xcc9f9862097d6f31f2781f916f394a4d9a06009f54f616d9d5c5a517a880391ed02b8f871d1004a5a305453e0c4075b", "0x1a66a98e21ca07db0b1b7d6b7bf65921c7dfce0cc9b25efcdd5e7c1b8e492ffff9dfedb9b32b3affb827c5478907357", "0xc82b7ea20f3578f7eb67a4d7e966e54e595b2ecf91e2a4210f76656817e35952cac71e75199e7fb161f85d569406353", "0x189640b74e901e4042df77f784cc7381c43e27d3da200ce86f47f308a6ea37932bd16fbab80fa131c37d8b429d7598b6", "0x6f14945ff075b3221a66ee8ad672b31c0f85429ab90d7a9c8bf557813fa0efbfe25e5f49f87ffcd4956e178a119492a", "0xf5628335e48c424da2650414f0baf02b9e296d9efebc881f597af374dbe634ddb199eda9ac5ac7c4d76150b6243e95e", "0x1443dc581cbc60dd4197b6f74799d7cebe9cb6bc1932d2f117a6687849f319f20c6c51637f416117f896c0826f70c6a3", "0x5ecc867bb9640bab6c57f5446f435a473568f31dcd5ed8e20f1097f4e3a5c98b9d2fd9170309e54f0d23595241e9ab4", "0xb35142bf853116f48afac573549d09794c7b8d4ca101d4a64fd850cd7a72385486e7c965e9b58910c237a0b61dfb0d1", "0x495f2d46c6fe317c3557f02ad66976d933fcf31aed50fd27207d34b5546dc367a479be3a9dc0d748ee958dbdf4c3dc6", "0x4b87f6f948320dd3accbcc1653d67f9ee8a8495695c52c0463544a7775a58518a607e074453f8663e7b0ad8ea07e21c", "0x65810cc51bcd92db40f079a885a7657d113367ef6b2321380496cb4e94e4c6189b9c80b51107ba437417a83bec3670d", "0x13dddbb670491725aec1646c87db2e3fea286661dd0dc9f62ceba6b063eda63672d8ecc5180785f602438e64bbcd1f17", "0x108542e68466c8e6c016bba69375a0ae187a4e357d15853dfe777e2cad3467f288b83356dd39d2af46db6ad97d56c658", "0xb39e319c9be2be6e28c6d4fa1e3a62a586467af5fa17e602acfa253883982c30bef0ae4bd9af5afa14c357da2dee047", "0x83070c328cf2393b9c0e28a6863343a05d51d75e8a1a489998663833a08663e952bab23b09696d397cbd542f7af429a", "0x78d9252259df0ecdad5e05685c241525043ce26007d819f5c211e8384f6fa9929e8a7f6a7fbe43f15a46544fc8b46ec", "0x9534112d11f8c6657e1eb94a03d1694c7ecfc2d833e8b9b32555d40b8cce7ed08b6cde4c0a8a1a481d509a142dada65", "0x17fb2d3043728a3c9f4f7eb7147eefa2ae79f8ecec711064d1a396f10625c33e2e67085d1f974f1c283e084505347b11", "0x1527d49f0223c4632d2978541c5e7d8d51a7283bd1985381512c5dd8b2103e51c61667251be7e073a48da118fd27232b", "0x181fc8ed425ead408c6162e73014b441098305a952c7b215beb11798b894b948772a699f7560657e0791f7353df0fd5d", "0xd2a54509e10e5665e61510098a424a76631a524e26b5d033d53575a81d77565c865023853d8778c869559a08cadb589", "0x6a3a81c3d7ec179f1becd1274efb578b65b64466ff53b9b9f7f990ce828624ba8fecf97cfd459b2b24c0b02eb315b01", "0x2ccba8aa6af85b297f41cf199aaf4a3f0650cdc229e926e25ff6133b52e12964907bf7c1ab807fa1c1a27077f82fcf4", "0x13f701cb63206a749cc4547b34fc3542d8be923cd0e05a141f5238f8b32ba5f381d59fd53cc11dc73a6988109694725b", "0x104a7d09036552a18da7875dab655b8e25de43d2f2fb359d2c1000ccaeeef04fad656589265f4c04113e798a73c20330", "0x930275466d564f686f7319a6a4727f3d02c510a942f72381b77c9ab13b2adffadee2bcceb4aa896dcebb7b064442c07", "0x23a127089f836b5408e8988a0b92a096caf8d05ee8447312f063af45c922bd8723c158b1562c936e4fb1b53aa43d1e1", "0x8287b7ae5eed694cc39d607c7b7d971612d1bbf700af830baa9494e633b6fb89c2413f8a8ad726c8e283eb3c1be71d2", "0xd3abe3cb1df8ab5cb11d076cd758cb1432c326ddd72aa2a71227a94ed7229680b089254776d3b94a3dce697af042639", "0x160189e110bda3353ae5682c644795d63233a1fa07a574d48ba2836408c15cceb02f98d62856a3d1cf7a6642db52fca8", "0x8ea0f4b667ddae4e4a277bae882943a2111525e96173e9285514b6fdf91ca60123fe4de5f1d49ed1385231a5e71b28b", "0xa791a01fb8b16a02152ebc641bd7a3a6509f18b2581db4aefb73a72fddd79466a905fa8d0e5e7f5ad2c593d095627e", "0x870ad87f645720a0ba982b6466f9a581ed89af7cc0080c7f1d114536877e26b953f26804458cf3fd67cc53be9bae575", "0x3811a0a51b11eeaa5e4de1b43984feb40668a0c62c5530b738dafbdba6c9e815cc4cf952c6207ebfc6b46b2a788c065", "0x4abffc61e058a798cb893b106afd6642a9a5b9c9d190ec6b7e7b7736ae7f55a249a0b111e77724efa62ffa005d60c1b", "0x15001106717bc45a513b6146a10459901cff726c93d0d1e631079bee82eefa9155dbd411db488636973beb7098c9c4b4", "0xab0519a411e6eff310339690c65e26a5fe9b219c8c6945c187f8770c76c54868e294fa116e256a599fad06fe2083152", "0x520c7b90cf5c98118a54b28000fa41595bd4268ae83a9bdb5577168577387d851618625ecc43910bbab4c61a021591", "0xc65eacc9be6245d73eed5b34f8ac954da859308e4b75dbf9c2d3112091ab90f36538189e6273259d778197bb7ce6818", "0x71c5b1b76aba5f951b840c414510b8a36729740fbb935ee17a89d02a9118d4b299f7f704c2814db96c58b5c3e8e4d32", "0xbd28e1ac6c5e1fc4c3c997bfdc3b364690a7fe355062b0cfeb9891f24d1e1098dd536b4174c486ab9acd77c6aff88a4", "0x19adf3b54e4ede32e8529051b0da99c4ab475a13ae3aec8ce601154c65a333d3db61523e885303ec600017b7628ea4cb", "0x1414c8b51b998f78adf2545657e79e04c5e6713c798ba7fbea1b3100eec83d020178ee760d4aa7cfe33d5c9a82591444", "0x5251cc2093d6ace28beccc75ba85b076a4f82043696c3596f25482780c5d16de2d89576fd654eed140266533553b456", "0x44adc21c8b70388f0d70a25d9da68a9b1c99e5db0339827f45d676d966ecd70d51c17e99be1eaebe4256435ec7b2cb3", "0xd2764ffdd4aafbec5111e3502e485297b41c4eb78cd1aca40b15b39ff5f15d0164e59d271a9765179d78100e190c08a", "0xf495343ff43c6582b39c72d7c8451702f9f60ec9e718c09d10a9e93bb138cc69c9674cae87e3dc51c9782830fe3a1c3", "0x813353910401dd8201039268d018a7dcfd8666549fe5f94c51374ef5a37e15c8477d0a60e906c0fb761eae9eb6a3ca1", "0x18a61359e28c306f78bc965891d78d017ddd72a45062b72cf8dce528b0f32dae65e85266779e83ffe2250308e69dd641", "0x14d41d8887c59da2b7cddc906b83183a8d3c745d247eaf6bfc04e806c4696d177ba228233cea1f2adf60e9a125821564", "0x27b4eb6686078e08e0b2c5cea6c4e60bfbbc7839ac73c47ab312a1959c261cf2c2949031a36cfe5624595eb1105eb9f", "0x157440aa6437f627e6177f5e1f009a2cd4f844beedd80029b7b2caf076b31974a103ec4f7bc04326b50da3d2abbd1093", "0xdbfeadd899ed34a01cfd537096e630c70209c4bcfd61188dbe39b7dd19dbe13774820c247de3fec5143e4d23a89d0dd", "0x10431edbc907726e8f1471a35aad7df33f528ed82b927926cca56c54d70c84c511feb40d5f76da3ccc22e3b9a4fc7003", "0x742a7bab4d10cf49e492e363988c6faeb8320a3d46913f3b89907afdb9ce12df2e0674a5e4661193657916509398d3f", "0x49def4922bc54ec02e8412e5265310b6e778071fa1083980ecc1034ccd3dc724ef66584834e9dddc689900aaa044ef3", "0x138f41302d6034a1952188cab929eb75a81d1c8a1adea5099537ed125d6fbf33a330b83096d3145b90919d5e3c992255", "0x6ebb5f7da78c6138fa6834af37751887cdc9cee7518dd38ccc4ee0b5611195a70a401db0e755ba00b56b76f6c9f94a6", "0x126c7803e4974596968a4f04cb60c0ce1b2e259bc760a8e439eb3279905d908a6dd94746750996f969b08d93a2e524d1", "0xa6d898382d6eda6ac3e11fec169f84e17f16397e41b2df42707046ef7fe2ebd592c79977881f70b7bfe829d66d5765b", "0x137218011633b381bd89a97e55763aa251d63568f442799981da6f8735a7dfa1ee0402830ab83afdc84348871ac16e37", "0x2760e0d91fe71d8b4b54e9c65b91e89f5a4ea2a3e3bae93c0bb37ac9b28c8a3390e2a572a56ed9859d027d5500e54ca", "0x14addd1e3595e48b0d69ff071fad7e8decea0154410b54843d8bbece5c0fb194c9ff11e548e3d85022533f0124485c6e", "0xc922489ee0d82dd82e9c9fa32fafb8653984c6847bb45d09429a64bcf8b483c5925582f20b95b4f3386708fb12e1972", "0x124198bd68cdd64d11b74a28e390a36b2b76eefed0a9692cb7f68cfccfd03a91cf4770e6b584334aade210bb1addc2af", "0x12c5e08cba713e18995f1fe5c2941ce6812ba3af7597767d5f9846f4f4484302ca7aeff43ccceff055fbb5045467a5a0", "0x48529961f0804ff9d586c6fce3865111121f620920b5f5c8fe5260d8abad708978027fff404c819fb03d0b1a57fb212", "0x9900bc240091764a11f90800c16626daa8ea09d84ee80ef30eae8f0c2b73a2b0e502a90225fd77e61fe5514c02661bb", "0x21cb6d48e3869a917ea7f7c2c8348bca2f28ee8858ef05dc213b7b3866858eb1d2ff273bd9a7e9094f7395f08cd2494", "0xf310752dd0682895f38102bd06e233884d4c1f9a90fbbd0ebd2ed6970b4009373bc13eeae85e57e4ff71e10d363aebd", "0xb521644578cf2ac7c7427e6bb83a50d771124be587383ca5243a7aa37061cadd7de09dbfdc0e4b3e0733fb33927f485", "0x378f671119170c553acd6df72c0aec702f32dd9c90fd959bada99fc7650e9e121d1a933c2089e03112b40be116ebe3d", "0x1054ee4ca3b1d8523e0e4d82bc512f8e057e843968d57185220906c270ff8dc90a9e903f928967422ff4775a65934653", "0x3c7dacef5d95a76e46ce2f737eea2116d95ac0afa8cedca27dbe830464e9fe9cdc82be6709bafe101a4cfea5286dba5", "0x1534470261aa9852854998dfa667ff1d2fcccb490e54d4b41be562e7a9bc3f5f5772a676d94523b83ce39b61d635a25c", "0x8dec854c0b36dbd59a59a4b391e5bbf8d7dd6a66c21362acf590035182f517da887406fe26bf7bea657269ea5e33c1d", "0xad646d6e77d25c4825dd9bf177d4d4b5b2efd71c31e5977ce2156daafde511c63b6830d944b87697dc19bb9cc0b4bfc", "0x20c0214d819311198ddf2f073f3ec68bc3762fe0299707152bd06a9daadddb87f4c0b5edbc90da730abf7bb2407cef8", "0x1569c15b058a27e1957b7302e1ee92036f14d15f5389f63a875e5e2b5d53f7c48defe9eb7dedd9939e905f7f3dc950a4"]];
        let xj = [["0x7f7956e7258b204e6bb76fb6530b54704b338c9e41d551b4c65d12afeff17a68cd917da4aa7f5d7f85dd4c4af5e97a3", "0x61f63de6863a0737ea4c564fb2649c3298b59c310e023469e9f6a61c9d21a413a15b875c3b5ae69e8bc70cc1642be88", "0xd54ccfbe6ce28ca435fb866b16f94ad9149d23b673b8b033c7415a182a906c0c440ec19e65eff130e3bf3e78e64a8d5", "0x5b0b2403b504c7c3c04fa2649405e14816e285681f6d10877632f67dd17dd934dcdc3b3d59039e2f71aab9d24fe1f50", "0x120e02660f9058203246fbf0112482fcc1899b14e6ac805c02a2d7664553675a1cd30ab8eef17c2cd5a8e39666056b16", "0x848bb58f7c097a46b3a03ed0f1e29a3fe03f4e210140c9f40bce68d096dad390d28e98224a2242169998bd45bcfecd", "0xdc72aced2c6f4a5c4819c14494f27de393ef818bbd4517d07dd58a061d1a3e0141a6e2e95f2d0acc60f04b266569319", "0x4a715b7a58dc6543add0fc9ea5a83207f896f6abf8ab0e2333622e9b8f46b0713f2f072d77df88de226de432ab03d2b", "0xc04235cb1fe7822f16be8bc01f84be86960bad82590ceca82fde4beda8b9e6a5885c858c2816abbab513ff9a9c7b5d1", "0xe44406c2cb2d23cae0a6ab38bf6b02312251b650e69f258a269f5787fd2b0bd9ed885f0edb79bdcbaa9dc247ec2effa", "0x86501a5cf1b338e3103b59e485f10c54276bce940584dc74efb1890226e01d82c5dd98529dfd9eaed5f6ee84dbefdc7", "0x10a91f5f4e43b2f252c415e2034cc18aa5ab46c409e63ff37f5499c66dc28fbd4c3207007302b90bf0cd9d620156bc89"]];
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
        let xi = xi
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xj = xj
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let mut i = vec![];
        let mut j = vec![];
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        let (f, p) = bit_00_case::<BLS12381PrimeField, Degree2ExtensionField>(
            &f, &q, &y, &x, &mut i, &mut j,
        );
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
        assert_eq!(i, xi);
        assert_eq!(j, xj);
    }

    #[test]
    fn test_bit_1_init_case_1() {
        let f = ["0x521ad898cee9071ebcbf44d874b1a6540a5a24a4fd9c68f45778308171f9267fab695191d4eab620cf33a8eded7fd2c", "0x146aa46acc68a7fa2d014f4cdce6921f2f664ffafcd262db0a43e29fba239f8e7cc55a67075e7e25f7928438cd506976", "0x110012a0987f151e6eacf408ccd24b9c3e637b240a4100a3ccdc16d44e3cbdf8393eb3557a64d089a1a115a3eab1a695", "0xa3dc13d77e6eac496424ab994c230664bbb51c4abe8135d998621a4259c788d6959e539d97a534c119cdb9a394de9ad", "0x6d44964cce393f36664dfb78c36a4b56c817816904d06056f68e9017165ef8db1a4f97532d5c3bbed4da9a68948c926", "0x1191d32d29708748f35f4fbea90258a97e7b47db6986cbc73c24ba35ad601bfadab752fd1a3e438ce0686b7777654a0c", "0x18776284b17c0858f647e075e04c49ded673151413b8ce9b65bf572081d748820d57d62d54e14ea09aad1c01c5c5faac", "0x199c96383503947d119bd6be94efdb3595eead7072f8c3d67173449f6658fadb43d715c9dc54d7f547cc1525e9a566ab", "0xa97b4be53ee479681acc5ebfc4fae663d5040baacca25a862aae0152d3543705d87df48c8266658d2a03e597cfec8fc", "0x6c86339c39859d2fac14a4550fff32535a91b9b0ff23bc04475027273d9579f491b35686ba10369195fd003747b05cf", "0xe608702099837e04fc2e999cbb4b845ab04d0a51ea25ee04675bf96847cb9d629da62d1e4354c04ab5208100a0129af", "0x737a8f64f0c81b65cf9ef035b357d0017406b0c84de6a32ed1fff164d3d9531f1d9ec53b11735a58f1d611050ed258a"];
        let q = [("0x24aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8", "0x13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e", "0xce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801", "0x606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be"), ("0x82dc9154807866eb0f36ccb665a5fc010510bd690ddd7b540e5bf3ff02d81e98b75703a3b3d3c305a70960906e6cb09", "0xdd18d077ad5bd58dabb18d84a6ceebe6375a83dd242851bb4dcf956002c4efb974ffceee6709deb0dcf81d4285e5e60", "0x4a468eb9e206b9833d8e8e2197d3446652372ce5ef50e93c91aa58105d3a281b2e84ddb61535fe1a90bae7e6692f9b0", "0x198fd0ab6249082bf7007d7e8be8992de81f47ae3341c590194fa3bf769a2e5a5253527727115c334e82ed4be8da6c10")];
        let y = ["0x6ce420ceafa50ff15baa710e1633d7893404a18b69ef5316a81b182dadbe66bb0ef4fe49ffa578c7698795e6d4a12cb", "0xf45ba6de68a0f1ab26ba5fac564f3f21a75239243fae800e2a8665fd9699e2795c674834c6ce016370aee9e4a1d38d1"];
        let x = ["0x7f2db8fbcf121365e92ce3d77bf5d9a3537b5422e894c09e00053ace96a5403a8db66fbe03950e93033c5874bbe8046", "0xb190c99770f69f3e912d3ef69f63e082a05a1e63b50eb9a5de3e07b14aed7eded07b2f2b3c42c7e365d2a47945fc285"];
        let c = ["0x521ad898cee9071ebcbf44d874b1a6540a5a24a4fd9c68f45778308171f9267fab695191d4eab620cf33a8eded7fd2c", "0x146aa46acc68a7fa2d014f4cdce6921f2f664ffafcd262db0a43e29fba239f8e7cc55a67075e7e25f7928438cd506976", "0x110012a0987f151e6eacf408ccd24b9c3e637b240a4100a3ccdc16d44e3cbdf8393eb3557a64d089a1a115a3eab1a695", "0xa3dc13d77e6eac496424ab994c230664bbb51c4abe8135d998621a4259c788d6959e539d97a534c119cdb9a394de9ad", "0x6d44964cce393f36664dfb78c36a4b56c817816904d06056f68e9017165ef8db1a4f97532d5c3bbed4da9a68948c926", "0x1191d32d29708748f35f4fbea90258a97e7b47db6986cbc73c24ba35ad601bfadab752fd1a3e438ce0686b7777654a0c", "0x18776284b17c0858f647e075e04c49ded673151413b8ce9b65bf572081d748820d57d62d54e14ea09aad1c01c5c5faac", "0x199c96383503947d119bd6be94efdb3595eead7072f8c3d67173449f6658fadb43d715c9dc54d7f547cc1525e9a566ab", "0xa97b4be53ee479681acc5ebfc4fae663d5040baacca25a862aae0152d3543705d87df48c8266658d2a03e597cfec8fc", "0x6c86339c39859d2fac14a4550fff32535a91b9b0ff23bc04475027273d9579f491b35686ba10369195fd003747b05cf", "0xe608702099837e04fc2e999cbb4b845ab04d0a51ea25ee04675bf96847cb9d629da62d1e4354c04ab5208100a0129af", "0x737a8f64f0c81b65cf9ef035b357d0017406b0c84de6a32ed1fff164d3d9531f1d9ec53b11735a58f1d611050ed258a"];
        let xf = ["0x6dcf1ec2bee9d55fd7c7dd01f0d89e52ce00053fb4cd271af8ac67e915aa56c1f18943cf63d7acf09f9e238c86f7575", "0x7f05f480f32402899fc238d5e397600577a07eddd78a63793400f32912e689ef50ff7298c542fcbddc8a2f30326ff28", "0x71d870e4553f214175e57f71397705b5336a8c404e29abab7505079976315ae30aea8c7fc8e47f2ce78aed551c79270", "0x37df42454ed3974bb2b32f97123a17956e452893cabef6a29a0888f8ce8b899253e37ae32f0ae88611fa10260d597c0", "0xba703f387adf415b877fd75815f8322190dde62bdc8a55e54b5dec1284a8c9177b3c945a72f0e1e9c109d242988e116", "0x14068f72159c932c910dd5126f8907d9616c496a0f51dbcc5585ddebaf32dc4e03ae577f1f07d02f85fc8a875e197521", "0x17dfc12834ee7334831b24af1174df6680c4991d4d20cc807c5e8df6083d142e2fd17ccfce6bb359366acbb7781372b9", "0x17d3b0da632dabdf4ba0f6c890308dd36ed98b5e1d50a8160a2349e79dd3de20eea74d8b95daa3bc8b9ac34a59ff12f0", "0x17ddaa28e29c2317b96c21b7fd31f8f2bab3cabf17b82c770ed0c77db94e0738119993eb4c5d01ef3358bf5ad26286cc", "0x22b2500baf6ce28a86979f31387bb67348f155192cf97f99aeb257fdcdc23c15eb5315ea817f28532b8d5198e199dd", "0x6524f53a10bd1ed1f7de6acc2d4414912600bfec37d116a4d096e4e54120fe17325dec0b0e382b90ef6654c3bd2e20c", "0xebb85352772f284d12c95bf531a0f1fc69bf6acd1695e9af23d641db780ebb70c7fbfbe8a680e766390ddaa62af47cd"];
        let xp = [("0x122915c824a0857e2ee414a3dccb23ae691ae54329781315a0c75df1c04d6d7a50a030fc866f09d516020ef82324afae", "0x9380275bbc8e5dcea7dc4dd7e0550ff2ac480905396eda55062650f8d251c96eb480673937cc6d9d6a44aaa56ca66dc", "0xb21da7955969e61010c7a1abc1a6f0136961d1e3b20b1a7326ac738fef5c721479dfd948b52fdf2455e44813ecfd892", "0x8f239ba329b3967fe48d718a36cfe5f62a7e42e0bf1c1ed714150a166bfbd6bcf6b3b58b975b9edea56d53f23a0e849"), ("0x893227b499dab30e15b606ec3c375f9fabf7fbb574b9b11c9eefbe33fae82066297e23c518f59e74d5cf646cec6464f", "0x10578234a81819d1ebb3d77b03a128f3165642386fff1b0a74ad73c139425703a991ce459cdc1995351adff98061f0ea", "0x16efa85752a02d4358a92eb3b577c1e27a02ec36000c44403159baf7022541a02104b633549e05b774e1b76343a8e661", "0xaf65df48a519d9209257e3df9fb0a1bd3491799091df954380242592db0bead0ddd62dbe33aeeaf1d4a63bdbc4c6008")];
        let xi = [["0xe8899bf2d1f2f54c552427835589cd2828d33eb1fef81e5382af6e33a32d19e7436939b3a0aca3000826ee5f29f7a41", "0x163cc7d50f58e7fd58c4467784a7f6848c725dbed14ffa37ceb2664733594beecc9e8e74e15b88e3df1df249b1ee10e7", "0x5456b23a25e181f03ecaf790566ee2ae3f9a7c9aace97c5f51b1822a9d2e8b0ceb672afdc6811f64c2a47bf3b14a670", "0x148cc9dcaebdde0fa4b641ce52ac847504136c550836467c59fdc151741f4e8e8bb6dac0275c34709e7f843f60afe9dc", "0xef2dcf1a1af1d85290833bdc8d333eae4a2416662a7f8d1f171df42ba46755601670b356942900157a4a691278e838a", "0x76ec0b906fec3e2548ddafd05cbe92834d9f67602526598cf63790c56effc25547b035723461181b30bb7f402c48ad5", "0x1893ea72d489bb198282ce86062a8f7d79862b680b0dc9a96d0e0c06024a12ae4269cff7afad6d3c5475405e2884021", "0x380676d535bcc75c2ff6b216b5bc81b5725b2aff21e124d93fd6315a2248700c21be8f775d2bf696c927decf4af8b7f", "0x1ee362659422cdf7cb061e82acac95cc7cb4cf73f02e0c49bc166bbc125ee67ee92e8111ee26b7a8624e906fdba11be", "0x16cc42e3d79053697cf26dfaa74a55c8546d3a08ecefd2b6c0c7ffc2eaf861068d95bba66b1eb9b4daca7ac05c61305d", "0xa9cf5030f0c62f73281fad2c97854ff91e3e22ad09abdb334743ed5de591bba3496cdf30a3357f360fad1f2d109b7ff", "0x1343b69e1140100f3dc3aedcdbfcc4363709747a511a3d8b576f2a210c59a8378ee1acf6ad57126d9da7e4f2099902dc", "0x463f6de4e5ef5d7b704ab2fb2eaf6ba225d334c2080f688657bf8eba8cfdd7d090b35bd45a8d09f1fd5e3ef3a8ce079", "0x114fb86f02da46f189d2db73a0c8a258472caa22d95d35ff3ea1f72cc98d310000e5e3451cef06cbc702937b1ef2fa9c", "0x123daf0320a5fe89b20346dc0f6f518d5ae7cad91197b2d9838bbc04ed0c6681dfb816e4cb8f5f763e05be29aabfa3b4", "0x4ebdb59fa847ba75e7fba78eca31af430c4ce13b8b845d6f1cb144eb550379e57b248c2cf134622a17a72daec5a175d", "0x12bc3e0a8465166f229da4dea0b0698e143efd397b0421810c07ba2caa14590a92641f141e42823cd0d4be8161d8a0cf", "0xc841c20248b8989103512b3c9b44da503c1aa5e941109fd849821197ba666bca1daddba36e8f615fdf46b8f74148576", "0xef637fc86371e1f3f24608bc1ab79884f9ead6afb9102b802ab14471b2298f46c5ce6718c8fb1861e7f0ca584df38e8", "0x8a18906704d81bbe407f0003945c43f7f0827f9dfb606caa563c62390ced3f07a091ee47c69d5c38505445ab5404686", "0xb41a7c5f385e5e11370c7febebccc6c906f7dd9351bc99f3c47b45f89c740383b21ccda4e78a74e1f02df5685fec579", "0x18152c8ebc343acf58014d9f9b8f3f44379b2ef18c288b1a2413e416d3e4e97f18c9eea2a988bafe4b405e9b1e6a1068", "0xd9bec30500bf612262f752ac2c2981be010f17e60f210b21978f498af139b2601f81df384f7891155dc524028a9c85a", "0x3677bf0ef760a7e32576dd0376c00d6c2619cc2a4ed7246a57d7c2f5bdab6ea17d8cc25736f9435d795542853f87851", "0x1a8e6daeeec4175a6a74f5e40f57ca05149fcbdbbc9d4dcba25bff52377e27bdeaa64591b6b4d05b6ec5a6aaad93bb5", "0xb1d85cbda8e37689d68ac73b63a2c4c62582bead16d0572003865fe6a85e8e49f37374ae25acf5584962cc0e85f502d", "0xc85c01b9b42b297feb1a34cc0aefb3739f44df44f6409865738862a7b741741e29841860c40e51d4f154ec443783197", "0xbb3b12dc3cfc717a4612174b132d1c2e06b1ff648cd27d00e2e15247de13695aa784234aa6ad5f62976e220f2802f7c", "0x4a4c14b30188c9e4b26e5362872eb13784c6c7effa2a3de7bb05c6c2c3277d2426a62a490d49d2930e8c6787507b4fe", "0xfd9b096dc81d49c0f30145d2d462c986462656d2fea44782020eae45c9ecfed514d15a91907c933f2cff180d01230f7", "0x1050d223a7ae09664142e67d8bcf631d8e8270c7cf379f55da84fb35756ec93aac7062850e88a2d80a9f8c6eabcde61a", "0x10d6c35de0dbf0832bfac6901fc2f4cebfe769d251c1d018f15709279f7378f5611951d66f04935523f8d3e6bbcfc40a", "0x17502e841d1c751f97992599ab672fd7b4406353102a50e13849da6a584f2defc35cb436546b6ad48a39fdad2448a82e", "0xaaf33baa4db7f6edb87dd9cd7311bd39069a840fa8d8dd49e58df12f3714d71eb7c83e43fa5423d80d01c7fb35712d9", "0x5d0f763804e8e4e17c6e29ff93ceb128a5c6e46c3a6688ed3285727b387018fa11003d39c8d5356b83f5a050f2ba23f", "0x210f7ce0277ee88f4bdfb77a38d8333eaf3ee9aa8d846351042248be09dcbea0fe06622a82d2a52e2f15942cecf7868", "0x7009a78d046a4223d6918822cbc00c0523696f78e85d7883cacccc3eb781350c85fcf0f278738b86441a6806e2556d4", "0x6c2041bd2df5687640ef195e8677a03c150050f4bbe304da55ea4c4a1036aeafb73cff23a63f3fe06d9480947e55a52", "0x4d9c72a03be12a88b76831d01a353ee068c09f96fdaec74eb60a38c08bd5ad8c393119a1b3227b4ac72455594358da1", "0x13f228eb5b3f295c64e9ddf2250879b623441c0db2f2617b3b85df938f2427a7190d721d87254067019582785dd6964f", "0x23d5b1edc9d5bf13fd5dde686530cae59ad34f32962a43efc58eb582cf3f69d9360706533a5a3043913f97b1f01bc4d", "0x15fba452e8ffcd78d21f4ded67b9c9eac394df22928fd62ea7d3375de41fa486f272a3e7c9dbfe15d4344718257ee00d", "0x119e8db942cd3373ead2539dc6c19d97c28ace94de92e80a71e49ca831646f45cce63f39ab8dbc4063e136195ba9df9e", "0x54872800533a260494090d1f316a5b6aae9fa22843ba6b76ce5f7db72189c29195731167868ce96342dcb9a1d676c67", "0x190ec7594c543f6a6279c47fb997f36649b16583c9493ec0e80fbe17d6b32b6f6a025a31625357d868db93889fa9bc83", "0x1076cb0dfadbeeba2605e596436f69349532cd836fc10b9997fb9a5f1f5b73eee3b055b5cebaa2435c9ff0f8146d07b4", "0x74d333f32f240ba7aafdb1572a94d228ade7d6bb45b67654606f8d98c05b2b091cfc71957338186d26c9bdbfb03d775", "0x10d9f3c7dacc7ef8b7b60f7474d5329b95c597c4083e626a618690793228b1f358623c4c5772ecd80b3c9ac273608279", "0x8dbb8728b6da5f245cd61eb18a4a34d1382b0a44c1ed8c88c3f620b14fe9211f61d69c5cc9529da708a50e3a97aa176", "0xc12777fe64bffb84d4d0c6c409519da77a081bfb05bce0c326aad71c243b134577ef7921fd3927bf956ac0d7704f7ea", "0xcb09aa163755c68a0e912444b03f8c2c26284f784b191ceecc23922c1c6b67a2e0b86d26c8d31f2bca44df1a40628e5", "0x32281704643a5a864ec2140874d8a97299d4a552d31df0f92c3e07c745b074f42c3ffe54e7d95c0b0ce5552e684a43a", "0x15f0a4d8bae8b018138c36b4021e8b66465477f4bbbad73cd44ce790b461f3cb3b3030a39599a4db7f147ba2c75a4ec3", "0xa505444671788b4d171af1972edb140da8569c5beab9becbb9ede13407cb096491558679fc1746bd66e36b53e7c5340"]];
        let xj = [["0x6dcf1ec2bee9d55fd7c7dd01f0d89e52ce00053fb4cd271af8ac67e915aa56c1f18943cf63d7acf09f9e238c86f7575", "0x7f05f480f32402899fc238d5e397600577a07eddd78a63793400f32912e689ef50ff7298c542fcbddc8a2f30326ff28", "0x71d870e4553f214175e57f71397705b5336a8c404e29abab7505079976315ae30aea8c7fc8e47f2ce78aed551c79270", "0x37df42454ed3974bb2b32f97123a17956e452893cabef6a29a0888f8ce8b899253e37ae32f0ae88611fa10260d597c0", "0xba703f387adf415b877fd75815f8322190dde62bdc8a55e54b5dec1284a8c9177b3c945a72f0e1e9c109d242988e116", "0x14068f72159c932c910dd5126f8907d9616c496a0f51dbcc5585ddebaf32dc4e03ae577f1f07d02f85fc8a875e197521", "0x17dfc12834ee7334831b24af1174df6680c4991d4d20cc807c5e8df6083d142e2fd17ccfce6bb359366acbb7781372b9", "0x17d3b0da632dabdf4ba0f6c890308dd36ed98b5e1d50a8160a2349e79dd3de20eea74d8b95daa3bc8b9ac34a59ff12f0", "0x17ddaa28e29c2317b96c21b7fd31f8f2bab3cabf17b82c770ed0c77db94e0738119993eb4c5d01ef3358bf5ad26286cc", "0x22b2500baf6ce28a86979f31387bb67348f155192cf97f99aeb257fdcdc23c15eb5315ea817f28532b8d5198e199dd", "0x6524f53a10bd1ed1f7de6acc2d4414912600bfec37d116a4d096e4e54120fe17325dec0b0e382b90ef6654c3bd2e20c", "0xebb85352772f284d12c95bf531a0f1fc69bf6acd1695e9af23d641db780ebb70c7fbfbe8a680e766390ddaa62af47cd"]];
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
        let c = Polynomial::new(
            c.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
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
        let xi = xi
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xj = xj
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let mut i = vec![];
        let mut j = vec![];
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        let (f, p) = bit_1_init_case::<BLS12381PrimeField, Degree2ExtensionField>(
            &f, &q, &y, &x, &c, &mut i, &mut j,
        );
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
        assert_eq!(i, xi);
        assert_eq!(j, xj);
    }

    #[test]
    fn test_bit_1_case_1() {
        let f = [
            "0x6e2d5c667e253ffe1d604e9b0c0efb376aaa3e1f2fa8194a9fdd627525394de",
            "0x2dc3c5e55face7c5e2c971b204e63954fbc8ad239d2d152e532c421b7834a99d",
            "0x2ff47505930441520ea2801041714bcb5d41a0ffa81940aec94ea9901fcac97d",
            "0xdab9fd3d1ef5226f76a2af1d6b410d8639501aa55867c1f0779e0422d545f0c",
            "0x2fea029bdb6a10f53ffd60992916c6410e0f53520845bfd3e55f70e8272c8fb3",
            "0x2f329aa1c588e3e4b7d8f5bedbe3c09728563ff0c46ce45b66636cb6ba1ee436",
            "0x2290e74d07afff26a405ca3722d951cb9a512f1c100fa50e29907ad3283e7b83",
            "0x6bd6eba6eb034c98be6fdabbb6f2986a20934fe7f4ccb1aa1cff1983d7d2ae4",
            "0x1ca0c85d7f94b5c6b3543992e315765cb35d0f7d49149a6939c1e7afec80ee3c",
            "0x1f70622e79ccbeb35ecce1f7718bba441de2df4f3e916ca84262a68f9eea11f9",
            "0x2492333e1554b6d2c1ad39913d06e14c6ad3a1569e62952be0e54c3427ea8aab",
            "0x2a9baf66b1ec17ae1f6f435746d944886953830b40efced523794fd2aa17d4a",
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
        let xf = [
            "0x9cc2ac2feb91b788f180b7f837ff5880af2d8a7b2cbc2078ddbfaa7de025ab5",
            "0x2b4691bfa6539beb28208698d947d559a85b25c7a591428b92ebd2a21abec753",
            "0x27b1bda2ff2bbe089cd77810447ab3747db696a3f6ef1e002aa95b3c440d8421",
            "0xfc2973e1356ebf52ddb6a5f96f0380df66dfe01de4cd7d7910730b235b46414",
            "0x96dc0c72aa87605c1be1f3b6812a70f1d4dbdefd725e7a84302d8aa32e80fcf",
            "0xea15f5754762638499ad8458f796af631ece5e5aa4b56d786db49e831390ace",
            "0x103abf47dccc2f4d223ede9edcf039bf49c1ec61174d95d075fd3727469afe66",
            "0x26e4a5a33276fc3166bb1e1310597230fbd36c03a6cf05749310487c359ed5e3",
            "0x65373ec7b46d26577bdfb0a69f8df530bdd64ae3b63b728ddcc7c24ba04ea22",
            "0x51b781e90fe55d3767d00d134cad0d2879f07054f31198ee15d57679a07cceb",
            "0x880237565c157f17a67f4f4d74fd3acd28c325e1d25747ef4e9d6c1a688457c",
            "0x1c718116af5b9bfe4b9a0f502db2b1916a717feb5c1a016cca2b0b70d3882c4",
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
        let xi = [[
            "0xa79ee9efbaa87e84974d0064a9b0a54517dd0e329163c9af0ca337787769c76",
            "0x2e6655c0294cbfc67c5eafdd31ccb9a5bfd1bd6f6d00d86b27ee6f0f45132db9",
            "0x223aa77e00ac43da1cb9698a9bcd76dd0d4dc9e9f3361c19fbdfc575f825dfcd",
            "0xba550ec81fdab48e83ae063002c0a4363f06d42bc9fb8cd9c54bb9a738583fd",
            "0xc46766575f8ded7a90993cd70cc42210d77233b92ac51af1b37d71fdc9f03a5",
            "0x1d93b6b19feee096b780bf18a2084117c9fc934df72b39b9856368f6d621b7e0",
            "0xf790c1fea05178b7f9de1aabfb394cfafdc45716ffdb752bedf419215896403",
            "0x2e7f87004e656e2f0a90f87cc58103f6dbc75f156feb6e940594809f32468890",
            "0x1b7de56671644ff780c45f087d0b1b8f2c9603c7748e99bf81ac39475092049e",
            "0x1d4f78206e251a9dcef0c173c33a2860153e783ab6fdfca8734f90b9695e7825",
            "0x271eefd32b948443ea242ffa8d1f3c281c64272c21580c03d60b46b9cefd3903",
            "0x26d01c1ee109d33051f2f49f318c80672f843c74b859e1bb3249b20dc11f559d",
            "0x45f8774c96e9d51f4d665cffa0f9ac1b8cb75fa4ef193ed5e67609288bb62c8",
            "0x191b686c256a3b826b6f99ff6dfb1f7cb22f02515655b308d60bc4563459264c",
            "0x170eba3d98078d3d7cdadabf7e2eb4e24aed94351ef9de5ca685e544cc958cc9",
            "0x99c99ebce93adddeba403ffecc8c37691bf52cddce48fb2092b99baa9c37fc1",
            "0xa794d503fc1a9aaa6ed5c70d1452971e44ce9e14c4e33d728ca3aa71a139bac",
            "0xda34cb75f019e7077721004cef3c0ed836d7a62ac54f203f01a7ea5caeba2c9",
            "0x15284512bc0074e4ae175a7a86cca36b516e4ee6230ebcd426435f215cd7e1ba",
            "0xa4370b540cdf6a3ba34992e9b9c4c715119fe0f3307eff2a746493af08ff459",
            "0x14536aa2d190a0ceae4599fce6f4e99835d08b23d98e5217c654d41d8035cdca",
            "0x383c83dc474b9cb3d2f2b2bf0cbfc2713bd31e45cf8d30e4989451d3c929897",
            "0x23d8e6b10a662363f1b4711ed89c7f057c63679d41f3aa7e215cce1c65afeb3e",
            "0xcaaaa24187a70d233875111d0cdb09351153eada98914d9de99eee6a5ab5193",
            "0x182fcae609a86cdc19e81d291fae341048bedef4988ce4b3290e7997f9f71a80",
            "0x1f9a679a7a9aa2f6bbc8b2b7ca097db3784e7014d77a6e4b495ed3a6f2a4f727",
            "0x297aab9149267a69d02e8a75a50eae577160b740b19c2eae326fe2e8411a2818",
            "0x1b7b271c51f6252ad920dd621b69da3c60606c5ce9d8029ccbc807548c882cea",
            "0xb55add16f95fca8c970b0ae91796ce3fca1f40869b7ce250b5893f118080586",
            "0x29b43ab30d36fb285b38dd37771d6d998397e2f6a89ae62246af45d79e14becc",
            "0x23d92b8079583f2a528fcabe2d23eaaaad7e52a42d5e8b6eee647dc1d4d6e274",
            "0x138492ccab0224206a5c568fb3e7e73859e9f8f5e72da7654418a584284f5960",
            "0x2af93e8c93e9bd75f1cd46b9906b58634677b179a97288f27ef07b1b5fc9d8dd",
            "0x20fc268e39b33c7617497bdc3e7bd939a45e832ed413bb408b7d79230ce4f60b",
            "0xb9dc0788d376ac77f442031ac7bde522955a9eef3395343a6d3edce03b4a829",
            "0x15e9ec57703b3c37f621b98b75e94b0885b27936d94b8ae29f78c9f1adc0ed1e",
            "0xce8e0c66aeabaf7877a971e4043ac96f34f540c7b5aa6e074fe17407c48b071",
            "0x24567171e46bb99f25f932f8924da00f057613de43e23523768a838f3e06a3f1",
            "0xf4465460c7ff15d8a5adb5af8645cba61d4b9fcbe36a81476207fcc031e40a5",
            "0x1b8eea0e13a9845eadf38c4778cdb5a43d81cb0747a31d1b8d940ea59b149951",
            "0x13577c9318b6a3919ab6701bab529507e4b5300312ef2d6f1f958a42be9c2eb",
            "0x2d03f66a7b412e0bd1630dd126a66b046e6bbd16ea1ae05fb3ac8c34c176cc95",
            "0x2b8d2b6aad77b369fd5d502a8b00b8b6247fcacf16b1ae354c57901d6b3eb934",
            "0x8b452b0ab3e4d897e1fec5b90f0450ef9036e4966049120832a980ea5a83d29",
            "0x6af107effff47a9e2609ca233e81e6bde4bcaaca497a816c0645d039241c7d0",
            "0x26ac80e013f793ef90929288be4f84d3be8f3ba373e8fdc2897ec1d500fa86f0",
            "0x29c9bcac9752160d466ece56a3066fd4ddfde6dac1d7dd2ffc43e264bbe46fdf",
            "0x22181cddd7f75ec3e11f54f23e4a4488d762d3e0d06911a076cc0ffa57a57094",
            "0x1dbb2fde8644a40b897c3b8c87426d37c2ac98507eb2c2321d53c07c1120eae",
            "0x2be613f72c50ce45878c294c553e1d9b3929f33466f99cfca6b61dd0b38714f7",
            "0x2673bef40c708e61da5540d99a69ea7a04777ca491b53359bc19d7131cb0a73",
            "0x185efbfcab081123f13ac188e539580aa7ba31fcb1fd1464ecc52c4c597534bd",
            "0xa98fb59b21fd4a2619712941a0a1ef57964e02ec3892e46422442c6cdc0766f",
            "0x965417e5cc262886ba34dfc81b0dbce0ad7ec0f1703ae45608792577b69793f",
            "0x9fffdbf32bec4ef94ba958e1b1ec8b5da5701ffe9c9e039794fda3d60b97296",
            "0x1788f44b56ed3ededf77708e0a2e1e5523368c5731c1366fab9d6dba253525d0",
            "0x2d62c0f8a2c995ccce46c16747f8c800ce5d8f00cfb013448883f0f2c37d076c",
            "0x2487fc89973ad2a53dc502d6826c03bd8a129d37efbd987c0c8c2d224dbb0fe0",
        ]];
        let xj = [[
            "0x9cc2ac2feb91b788f180b7f837ff5880af2d8a7b2cbc2078ddbfaa7de025ab5",
            "0x2b4691bfa6539beb28208698d947d559a85b25c7a591428b92ebd2a21abec753",
            "0x27b1bda2ff2bbe089cd77810447ab3747db696a3f6ef1e002aa95b3c440d8421",
            "0xfc2973e1356ebf52ddb6a5f96f0380df66dfe01de4cd7d7910730b235b46414",
            "0x96dc0c72aa87605c1be1f3b6812a70f1d4dbdefd725e7a84302d8aa32e80fcf",
            "0xea15f5754762638499ad8458f796af631ece5e5aa4b56d786db49e831390ace",
            "0x103abf47dccc2f4d223ede9edcf039bf49c1ec61174d95d075fd3727469afe66",
            "0x26e4a5a33276fc3166bb1e1310597230fbd36c03a6cf05749310487c359ed5e3",
            "0x65373ec7b46d26577bdfb0a69f8df530bdd64ae3b63b728ddcc7c24ba04ea22",
            "0x51b781e90fe55d3767d00d134cad0d2879f07054f31198ee15d57679a07cceb",
            "0x880237565c157f17a67f4f4d74fd3acd28c325e1d25747ef4e9d6c1a688457c",
            "0x1c718116af5b9bfe4b9a0f502db2b1916a717feb5c1a016cca2b0b70d3882c4",
        ]];
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
        let c = Polynomial::new(
            c.into_iter()
                .map(|v| FieldElement::<BN254PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
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
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree2ExtensionField;
        let (f, p) = bit_1_case::<BN254PrimeField, Degree2ExtensionField>(
            &f, &q, &s, &y, &x, &c, &mut i, &mut j,
        );
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
        assert_eq!(i, xi);
        assert_eq!(j, xj);
    }

    #[test]
    fn test_bit_1_case_2() {
        let f = ["0x1727a4684524eb2175d31f506b07370100418d3fcd5ad5c5586b3c2927dbffdd38a1a44b46f601ab362202e8276c007d", "0x57d77a9e8e6cd838edc1e63052a64d020d10ab12ab460dd755dec64232750ca866647b373738bbe4943b6aee387caa1", "0x42e0115d1c759474549023340d4f01ea67f2f082b59dec03aa7e22e27bccb5d4840ac815f2c12da594e423a2108737d", "0x54735182a914667a25226c91d61ee1f8c5c6c2e40b633da27379618cb58b0b55c0acff39fe7471a196e8bd9a0db6863", "0x14276d83ecbbeddabdf9bf5d9449deaf0a40d6de94e8347d983e97ed4491a3cda57fabebeb6d788023db42ceefa73d8b", "0xda9195159528161fa4960f25523d4d906c194a134c2695ba34577b4dcbbb76911a90cbb411db147cc5627ef50c9210d", "0x9552828c7dcc07d56efc554f98880b746c6ce0f7f41377d934699dcb5cf7eab408dbe027df4506c40e2424b24c6b69b", "0x122dcaa1ba9a8a8613064735071ae0aeab8e0333d7ff3018c9d51a652303decdf4907f6e7f232224b4fe0b20245f2fd4", "0x112f00e12354b1ad57581a4dde94de861275afae359c3016f8a13e81943a4a18f4896097697c449335ca5f9d21b7f654", "0x13bbf456483cd4566ed59718bd067589e294b4d7084073073fc77a685f0e4ae94092405afc2ecc6d437c20102b74f4ae", "0xeef615cd28929e56a59bf2e2e93db68f2ed629f9872a3b1aefdccb098674950b928bb5c920a2dc4d6405a69dafd98b8", "0xebec00852daa59ee4861f6c55f01d098689453651a335e711a11c3e6606acd9cd851f8132fb24bfa3edf65997e82785"];
        let q = [("0x19e384121b7d70927c49e6d044fd8517c36bc6ed2813a8956dd64f049869e8a77f7e46930240e6984abe26fa6a89658f", "0x3f4b4e761936d90fd5f55f99087138a07a69755ad4a46e4dd1c2cfe6d11371e1cc033111a0595e3bba98d0f538db451", "0x17a31a4fccfb5f768a2157517c77a4f8aaf0dee8f260d96e02e1175a8754d09600923beae02a019afc327b65a2fdbbfc", "0x88bb5832f4a4a452edda646ebaa2853a54205d56329960b44b2450070734724a74daaa401879bad142132316e9b3401"), ("0x1604bd06ba18d6d65bdd88e22c26eaef8a620a1a9fefe016d00eac356f9ceda8bc8eee5e46f9f4736ab22cff0e8cb9e8", "0x3e5755e9bfc250ff0a03efea22428a36a247504e613980918dc5319efb7f66b10d5fe2e7e86af7e014e1456aeaeac5f", "0x5655a99f7ff904c1e41382c25ff0360d9c51d0e331bfb1e38f5dd41c6909caaf6e313f47f727922109bf8c3204fe274", "0x62ec2ed9b207f63e0d9899ed11f9a125b472586b65bb77b8a04d5d446d15a8701ba5c361a07cd85e0743f5ae2e95a9f")];
        let s = [("0x24aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8", "0x13e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e", "0xce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801", "0x606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be"), ("0x82dc9154807866eb0f36ccb665a5fc010510bd690ddd7b540e5bf3ff02d81e98b75703a3b3d3c305a70960906e6cb09", "0xdd18d077ad5bd58dabb18d84a6ceebe6375a83dd242851bb4dcf956002c4efb974ffceee6709deb0dcf81d4285e5e60", "0x4a468eb9e206b9833d8e8e2197d3446652372ce5ef50e93c91aa58105d3a281b2e84ddb61535fe1a90bae7e6692f9b0", "0x198fd0ab6249082bf7007d7e8be8992de81f47ae3341c590194fa3bf769a2e5a5253527727115c334e82ed4be8da6c10")];
        let y = ["0x6ce420ceafa50ff15baa710e1633d7893404a18b69ef5316a81b182dadbe66bb0ef4fe49ffa578c7698795e6d4a12cb", "0xf45ba6de68a0f1ab26ba5fac564f3f21a75239243fae800e2a8665fd9699e2795c674834c6ce016370aee9e4a1d38d1"];
        let x = ["0x7f2db8fbcf121365e92ce3d77bf5d9a3537b5422e894c09e00053ace96a5403a8db66fbe03950e93033c5874bbe8046", "0xb190c99770f69f3e912d3ef69f63e082a05a1e63b50eb9a5de3e07b14aed7eded07b2f2b3c42c7e365d2a47945fc285"];
        let c = ["0x521ad898cee9071ebcbf44d874b1a6540a5a24a4fd9c68f45778308171f9267fab695191d4eab620cf33a8eded7fd2c", "0x146aa46acc68a7fa2d014f4cdce6921f2f664ffafcd262db0a43e29fba239f8e7cc55a67075e7e25f7928438cd506976", "0x110012a0987f151e6eacf408ccd24b9c3e637b240a4100a3ccdc16d44e3cbdf8393eb3557a64d089a1a115a3eab1a695", "0xa3dc13d77e6eac496424ab994c230664bbb51c4abe8135d998621a4259c788d6959e539d97a534c119cdb9a394de9ad", "0x6d44964cce393f36664dfb78c36a4b56c817816904d06056f68e9017165ef8db1a4f97532d5c3bbed4da9a68948c926", "0x1191d32d29708748f35f4fbea90258a97e7b47db6986cbc73c24ba35ad601bfadab752fd1a3e438ce0686b7777654a0c", "0x18776284b17c0858f647e075e04c49ded673151413b8ce9b65bf572081d748820d57d62d54e14ea09aad1c01c5c5faac", "0x199c96383503947d119bd6be94efdb3595eead7072f8c3d67173449f6658fadb43d715c9dc54d7f547cc1525e9a566ab", "0xa97b4be53ee479681acc5ebfc4fae663d5040baacca25a862aae0152d3543705d87df48c8266658d2a03e597cfec8fc", "0x6c86339c39859d2fac14a4550fff32535a91b9b0ff23bc04475027273d9579f491b35686ba10369195fd003747b05cf", "0xe608702099837e04fc2e999cbb4b845ab04d0a51ea25ee04675bf96847cb9d629da62d1e4354c04ab5208100a0129af", "0x737a8f64f0c81b65cf9ef035b357d0017406b0c84de6a32ed1fff164d3d9531f1d9ec53b11735a58f1d611050ed258a"];
        let xf = ["0x10bbd67a2e6b8bd12ca2a8fc9ebb9d7748bb4b630bb9e8ad6ff87ec4e2647706b3fde59249168a1f3a22e43aa9131c14", "0x10b832788eae08063407690bf13628a4c95b6fc55a9eef6a4e4e1893305748d5ffd9fef14dbbf2265569906a0d24b1bb", "0x19496c56f34ced68a7cd75ca45a97406d2a99dc971e2c9ebd6ec68233a19bba472836ae01acce936e2cf8c477b127acb", "0x925d1d1ef9c0beba6f0a34cac08da0adfb221ad320d929c4a12e88d4c855c6e93e88d2422cc017e588ebe02c9d8944d", "0x63551db5a468540a882a52a9fc100a34798496f25a17711a0f7fe84c2f3b0c22ea84f0e3de8b6df17b043f047eb3d95", "0x1452bf2c3fe715937d83b5c57df5b7b9df88e4cf55e829b75743d3be8818de60a9a1a5156acb9303682c1c8ca5fac965", "0x159fe260119fbb98baf253f4e0f865fe70bcd3a215ac2d2e10d9eea83bb012f8e01a28ebe1e1ab9e46108a3da2287de", "0x2cf0869f40402c8b16429547884c156e8281d85d5a0ee4e6fa097bc9669f5a4c6e33dbebe7a9434b3beb015897656bd", "0xd2c631a38ce47d9e8f0ee1fc2ccd8f589dd387f86500444d3dded1b3595c3ce4312a36a95cdf327419c78b6710a6c8c", "0xcaa4d999eec4b8f23cb8406c8fb3405378036f4c5867363b504394fbc5fc5b04e7a846507e6f24ade84350245ac9e72", "0xdca015d5a2e52becd816f7a434f9cece5b000d281057b64de60f93bdf429d379caaf598e7e990c95a109a8caa63a02b", "0x6995ffd83bb53d7b9787c81663ec0365e65c06194887eb1591ab99d664c7bb9537bd1bd1b9bf5b1707249c394b385b4"];
        let xp = [("0x152110e866f1a6e8c5348f6e005dbd93de671b7d0fbfa04d6614bcdd27a3cb2a70f0deacb3608ba95226268481a0be7c", "0xbf78a97086750eb166986ed8e428ca1d23ae3bbf8b2ee67451d7dd84445311e8bc8ab558b0bc008199f577195fc39b7", "0x845be51ad0d708657bfb0da8eec64cd7779c50d90b59a3ac6a2045cad0561d654af9a84dd105cea5409d2adf286b561", "0xa298f69fd652551e12219252baacab101768fc6651309450e49c7d3bb52b7547f218d12de64961aa7f059025b8e0cb5"), ("0xbfa363ea499e05a429d9af2a73ba635e0ff3825edddacfab8afc6b9188700c835282a2c4c7effe70dc61c557b8d90e1", "0x5c3fefe5849b36814f32ce71dee6eba467b220e1b53f01421b9ec6d23209f6206e864539ddaa327b085ad8d78a8589b", "0x17b304f1c4f58afee1ecd75f1570b13da2ee02dfc5731f82ac55d5b6d011ce70ae42061b3d205cbe49efdfcd8d2c04b4", "0x101d88f38de6be9d7eb2c074905585f487715b3e6d8179a066ba56988207caa28f7a5f1ba2f7abd01e200ac71d198282")];
        let xi = [["0xfa0a76861031f74c3397565d1db68d2963758855de5ff1cffb69bf13a0ea4371279ac1efa65710c7f4a97919a78ff59", "0x510accb9026da5f06a82195a8b978613fda96cf96aed978cca28a204a199cedc7d167de9ed320732d244e33e99e023", "0x15c6dd3afd26f1e0be2ddbb1b37dbc396c0d3cf212cf9f913d234eff2e573adf0c3801e3e2b0000295bed5df8256241d", "0xe4b5650a1764134020a30d8b7db861be3d99eabc16f3be0c3ccd04aedd3396d12f676011cc534280d11de2c32174054", "0x92b6ac1f5ee0d203bb67f480484b3bc8e1ae220dd231a7e8551aa0f1870337992bbe9468d227d075a169fac1df2c8cd", "0xa2f8871f36609c163c8f4fdc40e2a9e929064409ecf1f5f97663ddab6050fe1d57588d8b03f2a4fbec819cecb39deb3", "0x174392a02f5845ab761133e81929786093fd6dde47f00acabcabaa7df89d108873e342125536e31efb1bdddd7093573f", "0x19b7370d6e64482d5a63c2e296b9d58c27367b340d071f0b83753b977eec6d95847ab64f51e8b2b2b86a21700fc1036a", "0x16aafd26dece43d80d70cdcb43e12f92b10667ba3c079f4714bb254dc4a87dea3329e95692ebb10341473208df09ace0", "0x100e7e1d58af9be477931364d058b55599df02466821b9b708aa273e764a0a70bc05a73457f377972563f1bcb81f11d5", "0x170d56bd6ad6c4de225b80b20ccedbdb8e8df8a04779caa0e1556af352cc3ecd056532fae73625550ca6b183fcf0a096", "0xece7f85c875c8e55edec040d13de2bdaa6d2857da5d6a015778afa6331abd58894791f3c3518c9f45ba74c620b46d41", "0x1607bb82f6dd503070001a627a4af4c14804ba89eebaf68263f9bd809f9e0c8a864dc9830ae4cdf08fcc98ca8b40946b", "0xc5768744b07f71ca9929c2eb4d1c6e7ef588be129d03e364b9a6de5363e625c35120c6457e55c9869ac77c4e68ec86", "0xaf6c9e178fb5b59b567c04cdd4aa040aab8de72fe49c1446bf5199cd13161196a9b6d91fc8ae08fe1bf7d3298713131", "0x124afd78e247a139b8cb3bb39508823c22f7e82b5c7efebe5dbb5362fd9518cc0f978862a5a6b9fa8b69845e104c6d02", "0x5d6e665e77ca1f94e0e0d1167ab09c74e1968c6c237e04da4e30581076651295154a4a5e87f457561b6d5018e45ce0", "0x10f8bc2e981e2fb9c2d3523c3133480686050d777200627b7b4618d52460a7c5e77052ebe7840f526ec51d5936e353e4", "0x10fd3968a035eb5802605b0a1a74fad870dc523e869a8a387f0c54254a837be577e145bb93f66ea2c68eda44071f2cfe", "0xf5f7384635978f87c75314add179a7da2ac4f123d1ddb75c53595c04078a212534b0a21504085f4df62156608d80212", "0x8341b253d9c0094bf3d43fdb03c965eda9e5aa299cf380e3dcf9029d38e858d3a7295bff01cb5715e8e33baa9b6977f", "0x165960db1dfc8f1762170585bd7070d53f454c1f6a9ca49e3d45d8496a5ead89adbebd3c0aa9ea01394b672c4aa894ea", "0x131c0b3cd87830c0b91ea8df14129a2cddff268498079d99e38d2be315ac4fdbcff0f825e13ba9e4a9432d4b60167f2b", "0x2f9b19cd56d9d4ca715391183b5f6e03d281b33be0c460dfabb5e0dd022bc55693304f1cc256b54eb812efd68a36d37", "0x14c0070279d9be555722b667e01e5f500d8eadbba9f5e7cdb91d46924827f5268656e8866e285c2fb4c1e51bb61a0177", "0xcb3a116c5f6723d33a71594caa68ec1c8b6c5f5dfe1b9f0a41d9a60242cdb2df01904a42c125d77f7bdb03b900abe5b", "0x18d59a51db9f1248df991f56a7d48b8e6ea57f000d4c84b0d72a74ee646c2d8925e6196f2a77660e4a77608bddc25f9", "0x19af59a0c7b6682c578e96b27ca0f1b9e253245d818e0c1edecddd98bc6f97d027b28f31dd23c32125316145dca9de58", "0x153c39704769fc40669f0a815152cb1551adbd773c24127acfeda50a2c9c12771b77af68528b524ef497a42076d31c87", "0xe2d3b3118f05cb799343c422605fb005e2e739eceaf0cfd73b770bc5d5deb4edfcac88256e8acfa2647a337312e6e65", "0x1a0100e060db5cdfcd5066fe802535e18f96907085a2952bf7a6e0dc14be04f669df6608c60262347bfa0f198a5ce318", "0xce0cebc0ca92c4c756a3d5b1d1ec42da974ff6e0e2d0c7171c3aaea7ffa0757c0fedb1761d9c4d8d9b289069dd41250", "0x160d326dedc18b7005ca481307404f7f274d900494d7e3fe5b15bec1cb78f3e4a79b19745e6323506dd9f231ae866779", "0x1af4ed07df74414ca87f776e4dd643c8bd7349cbc1e6c2de84a20743369bbb016a5993f0e66568235d44f58d9cbc38b", "0x8d0a11ab066bfc13b257f2b9b860457a3b944f78951b2f7cf3887e22bf75516749ccc5d4f91c14ffefb1cbd92409b1d", "0x23d98a00873b026887cf7eb45508774de78d2412c09f564e43093f04699ad31d05bc73d28126b35f23596da726b644", "0x14207774abb793f1d52aa7c8ac936076506a86a651134cb8ba65d95740b2f8a3ae1afe5ebe0e886326111ce837d6effc", "0xb33f8a80d98e787229da96e781febf5660519e6b448c2239665b43ca641e9c68bee7f63a1807b15d7d271945312c3c1", "0x1428ec16f781182ad72b3bf06f6218cd798f16b662c2393581b47b697b8af05a28c5da63394c737343ecb50c9d27438b", "0x17532398aac71a6c4741eee86041daa073963428b809a020bb2b83b43242f0ed2c169504a1f3007389361a1d5d78774e", "0x44224d63e381d69226405fdbafedfdd5da9456f6c4e155f82570869b69aba03a38400086f0eb8432f2d1d216b69bdd1", "0x21e0297c72148c86aa36a059f19b04c75c95e8c7344026cea29241eff3bece2d7e44645183d2b081bc846ba0cf97e16", "0x503b980fe1358a7f87af5c7eb65b389a0188da60c45be6a540bacb5b66075c991276fa6383d987e5f94ee897417a0f5", "0xc9035d2db00a9ae5f26b4adc44f00d813bb51f8726987918aa26d0eafab97c243e43cf15ab4fcb3ec97b8fca39ddb07", "0x1688460ce66c019b531545c1dab18ade5626fe61eac71df48814c0f5921d48deaab89097cb728efb319b71d29cfc8cbe", "0xb74bc33f01fbf84ebb3d80025cc8b60a2c00cb34b70ffa2903f38c7648c3c5173cae4df4d36646947688488dc6423fd", "0xb0fdff8ae056ea274693d443ed2b2abec5cbd272f090cba71b45adeda28670bb64b26968c1dea90077a422656379b4c", "0x1da52b1ef7183381d3f1557bf9cb515b38124b3f3247400248735e18ebae90b0dfe82b3ab03e48b9f61d5bdfa0885ee", "0x1062e0ee97214d084babe14f0717c2e37f30332e837499400ac3afe77017dff007f0b72ed14a05c96e435a3ef2764d11", "0x16d97325a47795dd4153640facfdf98323eebd53fe8cb69190d6fea3a2790f8ad0e608966bfeb4baf4c415a5f62d654", "0x70e8df7511e1f3476b3fe23002d2c68e9a436310c1e0d4cc099aa5909358e6bb1bbf8e1e10c2917053795568c5c3f67", "0x2e7db1c975008709135824f015babb80e570cdadd85ef1314f376d102036ce3774efc376c0cfdc73201659d99037ba9", "0x1341d5d6806f9bb5bb82898a095128304b1715d59315e7733d82f7fe91c7906d87b76d4fd03825e24eea1ea2e60ce145", "0xdcec9030cb633c339a6db2ed9639197e426e4768c74ece2ac97d78a778ebd7955f47161e041812a516257489e1a357f"]];
        let xj = [["0x10bbd67a2e6b8bd12ca2a8fc9ebb9d7748bb4b630bb9e8ad6ff87ec4e2647706b3fde59249168a1f3a22e43aa9131c14", "0x10b832788eae08063407690bf13628a4c95b6fc55a9eef6a4e4e1893305748d5ffd9fef14dbbf2265569906a0d24b1bb", "0x19496c56f34ced68a7cd75ca45a97406d2a99dc971e2c9ebd6ec68233a19bba472836ae01acce936e2cf8c477b127acb", "0x925d1d1ef9c0beba6f0a34cac08da0adfb221ad320d929c4a12e88d4c855c6e93e88d2422cc017e588ebe02c9d8944d", "0x63551db5a468540a882a52a9fc100a34798496f25a17711a0f7fe84c2f3b0c22ea84f0e3de8b6df17b043f047eb3d95", "0x1452bf2c3fe715937d83b5c57df5b7b9df88e4cf55e829b75743d3be8818de60a9a1a5156acb9303682c1c8ca5fac965", "0x159fe260119fbb98baf253f4e0f865fe70bcd3a215ac2d2e10d9eea83bb012f8e01a28ebe1e1ab9e46108a3da2287de", "0x2cf0869f40402c8b16429547884c156e8281d85d5a0ee4e6fa097bc9669f5a4c6e33dbebe7a9434b3beb015897656bd", "0xd2c631a38ce47d9e8f0ee1fc2ccd8f589dd387f86500444d3dded1b3595c3ce4312a36a95cdf327419c78b6710a6c8c", "0xcaa4d999eec4b8f23cb8406c8fb3405378036f4c5867363b504394fbc5fc5b04e7a846507e6f24ade84350245ac9e72", "0xdca015d5a2e52becd816f7a434f9cece5b000d281057b64de60f93bdf429d379caaf598e7e990c95a109a8caa63a02b", "0x6995ffd83bb53d7b9787c81663ec0365e65c06194887eb1591ab99d664c7bb9537bd1bd1b9bf5b1707249c394b385b4"]];
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
        let c = Polynomial::new(
            c.into_iter()
                .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                .collect::<Vec<_>>(),
        );
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
        let xi = xi
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let xj = xj
            .into_iter()
            .map(|v| {
                Polynomial::new(
                    v.into_iter()
                        .map(|v| FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap())
                        .collect::<Vec<_>>(),
                )
            })
            .collect::<Vec<_>>();
        let mut i = vec![];
        let mut j = vec![];
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        let (f, p) = bit_1_case::<BLS12381PrimeField, Degree2ExtensionField>(
            &f, &q, &s, &y, &x, &c, &mut i, &mut j,
        );
        let p = p
            .into_iter()
            .map(|g| (from_e2(g.x), from_e2(g.y)))
            .collect::<Vec<_>>();
        assert_eq!(f, xf);
        assert_eq!(p, xp);
        assert_eq!(i, xi);
        assert_eq!(j, xj);
    }
}
