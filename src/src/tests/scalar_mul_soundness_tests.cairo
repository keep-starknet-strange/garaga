use core::circuit::u384;
use garaga::definitions::{
    G1Point, G1PointZero, get_G, get_curve_order_modulus, get_eigenvalue, get_min_one_order,
    get_modulus, get_n, get_nG_glv_fake_glv, get_third_root_of_unity,
};
use garaga::ec::ec_ops::{
    FakeGlvHint, G1PointTrait, GlvFakeGlvHint, _scalar_mul_glv_and_fake_glv, double_and_add_8,
    ec_safe_add, msm_g1,
};
use garaga::ec::selectors::build_selectors_inlined;

const SIGN: felt252 = 0x100000000000000000000000000000000;

fn bls_generator_preimage() -> G1Point {
    G1Point {
        x: u384 {
            limb0: 0xacad9e91be475966f7413a26,
            limb1: 0x6d8640c18c1caec0ab474874,
            limb2: 0x98fc6d8bd7e8482362c69b41,
            limb3: 0x7f127a0a6f06434698a6b65,
        },
        y: u384 {
            limb0: 0xbc4e22cd69b8519cb9bfd662,
            limb1: 0xa6caa6937bed9116b52ad54f,
            limb2: 0xf27a4ff60e8ca9060651b98f,
            limb3: 0x5be03c7afc54a0b30376055,
        },
    }
}

fn glv_mul(point: G1Point, scalar: u256, curve_index: usize, hint: GlvFakeGlvHint) -> G1Point {
    let mut data = array![];
    hint.serialize(ref data);
    if curve_index == 1 {
        bls_generator_preimage().serialize(ref data);
        let q_preimage = ec_safe_add(bls_generator_preimage(), bls_generator_preimage(), 1);
        let q_preimage = if scalar == 3 {
            ec_safe_add(q_preimage, bls_generator_preimage(), 1)
        } else if scalar == 4 {
            ec_safe_add(q_preimage, q_preimage, 1)
        } else {
            q_preimage
        };
        q_preimage.serialize(ref data);
    }
    msm_g1(array![point].span(), array![scalar].span(), curve_index, data.span())
}

fn fake_mul(
    point: G1Point, scalar: u256, curve_index: usize, hint: FakeGlvHint, cofactor_preimage: G1Point,
) -> G1Point {
    let mut data = array![];
    hint.serialize(ref data);
    if curve_index == 4 {
        cofactor_preimage.serialize(ref data);
    }
    msm_g1(array![point].span(), array![scalar].span(), curve_index, data.span())
}

fn direct_glv_mul(point: G1Point, scalar: u256, hint: GlvFakeGlvHint) -> G1Point {
    _scalar_mul_glv_and_fake_glv(
        point,
        scalar.into(),
        get_curve_order_modulus(1),
        get_modulus(1),
        hint,
        get_eigenvalue(1),
        get_third_root_of_unity(1),
        get_min_one_order(1),
        get_nG_glv_fake_glv(1),
        1,
    )
}

#[test]
#[should_panic]
fn test_direct_bls_core_rejects_torsion_input() {
    let torsion = G1Point { x: 0_u128.into(), y: 2_u128.into() };
    direct_glv_mul(torsion, 1, GlvFakeGlvHint { Q: torsion, u1: 0, u2: 0, v1: 0, v2: 0 });
}

#[test]
#[should_panic]
fn test_direct_bls_core_rejects_torsion_output() {
    let point = get_G(1);
    let torsion = G1Point { x: 0_u128.into(), y: 2_u128.into() };
    let q = ec_safe_add(ec_safe_add(point, point, 1), torsion, 1);
    direct_glv_mul(point, 2, GlvFakeGlvHint { Q: q, u1: SIGN + 6, u2: 0, v1: 3, v2: 0 });
}

#[test]
#[should_panic(expected: ('Wrong Glv&FakeGLV result',))]
fn test_glv_complete_fallback_rejects_wrong_output() {
    let point = get_G(0);
    glv_mul(point, 2, 0, GlvFakeGlvHint { Q: point, u1: SIGN + 2, u2: 0, v1: 1, v2: 0 });
}

#[test]
#[should_panic(expected: ('wrong FakeGLV result',))]
fn test_fake_glv_complete_fallback_rejects_wrong_output() {
    let point = get_G(3);
    let q = ec_safe_add(point, ec_safe_add(point, point, 3), 3);
    fake_mul(point, 2, 3, FakeGlvHint { Q: q, s1: 2, s2: SIGN + 1 }, G1PointZero::zero());
}

#[test]
#[should_panic(expected: ('Wrong Ed25519 cofactor preimage',))]
fn test_ed25519_even_denominator_cannot_hide_torsion() {
    let point = get_G(4);
    let q = ec_safe_add(ec_safe_add(point, point, 4), ed25519_torsion(), 4);
    fake_mul(point, 2, 4, FakeGlvHint { Q: q, s1: 4, s2: SIGN + 2 }, G1PointZero::zero());
}

#[test]
fn test_glv_selectors_consume_65_bits() {
    let max: u128 = 0x1ffffffffffffffff;
    let (mut selectors, a, b, c, d) = build_selectors_inlined(max, max, max, max);
    assert!(selectors.len() == 64);
    assert!(a == 1 && b == 1 && c == 1 && d == 1);
    while let Some(selector) = selectors.pop_front() {
        assert!(*selector == 15);
    }
}

#[test]
#[should_panic(expected: ('GLV coefficient out of range',))]
fn test_glv_selectors_reject_high_u1() {
    build_selectors_inlined(0x20000000000000000, 0, 0, 0);
}

#[test]
#[should_panic(expected: ('GLV coefficient out of range',))]
fn test_glv_selectors_reject_high_u2() {
    build_selectors_inlined(0, 0x20000000000000000, 0, 0);
}

#[test]
#[should_panic(expected: ('GLV coefficient out of range',))]
fn test_glv_selectors_reject_high_v1() {
    build_selectors_inlined(0, 0, 0x20000000000000000, 0);
}

#[test]
#[should_panic(expected: ('GLV coefficient out of range',))]
fn test_glv_selectors_reject_high_v2() {
    build_selectors_inlined(0, 0, 0, 0x20000000000000000);
}

#[test]
#[should_panic(expected: ('GLV denominator is zero',))]
fn test_glv_rejects_zero_denominator() {
    let point = get_G(0);
    let q = ec_safe_add(point, ec_safe_add(point, point, 0), 0);
    glv_mul(point, 2, 0, GlvFakeGlvHint { Q: q, u1: 0, u2: 0, v1: 0, v2: 0 });
}

#[test]
#[should_panic(expected: ('GLV coefficient out of range',))]
fn test_glv_msm_rejects_truncated_coefficients_before_fallback() {
    let point = get_G(0);
    let q = ec_safe_add(point, ec_safe_add(point, point, 0), 0);
    glv_mul(
        point,
        3,
        0,
        GlvFakeGlvHint {
            Q: q, u1: SIGN + 0x30000000000000000, u2: 0, v1: 0x10000000000000000, v2: 0,
        },
    );
}

#[test]
fn test_glv_small_scalars_all_curves() {
    for curve_index in 0_usize..3_usize {
        let point = get_G(curve_index);
        let q2 = ec_safe_add(point, point, curve_index);
        let q3 = ec_safe_add(q2, point, curve_index);
        let q4 = ec_safe_add(q2, q2, curve_index);
        assert!(
            glv_mul(
                point, 2, curve_index, GlvFakeGlvHint { Q: q2, u1: SIGN + 2, u2: 0, v1: 1, v2: 0 }
            ) == q2
        );
        assert!(
            glv_mul(
                point, 3, curve_index, GlvFakeGlvHint { Q: q3, u1: SIGN + 3, u2: 0, v1: 1, v2: 0 }
            ) == q3
        );
        assert!(
            glv_mul(
                point, 4, curve_index, GlvFakeGlvHint { Q: q4, u1: SIGN + 4, u2: 0, v1: 1, v2: 0 }
            ) == q4
        );
    }
}

#[test]
fn test_fake_glv_small_scalars_all_curves() {
    for curve_index in 3_usize..6_usize {
        let point = get_G(curve_index);
        let q2 = ec_safe_add(point, point, curve_index);
        let q3 = ec_safe_add(q2, point, curve_index);
        let q4 = ec_safe_add(q2, q2, curve_index);
        assert!(
            fake_mul(
                point,
                2,
                curve_index,
                FakeGlvHint { Q: q2, s1: 2, s2: SIGN + 1 },
                G1PointZero::zero()
            ) == q2
        );
        assert!(
            fake_mul(
                point,
                3,
                curve_index,
                FakeGlvHint { Q: q3, s1: 3, s2: SIGN + 1 },
                G1PointZero::zero()
            ) == q3
        );
        assert!(
            fake_mul(
                point,
                4,
                curve_index,
                FakeGlvHint { Q: q4, s1: 4, s2: SIGN + 1 },
                G1PointZero::zero()
            ) == q4
        );
    }
}

#[test]
fn test_bls_preimage_with_torsion_clears_correctly() {
    let point = get_G(1);
    let q = ec_safe_add(point, point, 1);
    let torsion = G1Point { x: 0_u128.into(), y: 2_u128.into() };
    let mut data = array![];
    GlvFakeGlvHint { Q: q, u1: SIGN + 2, u2: 0, v1: 1, v2: 0 }.serialize(ref data);
    ec_safe_add(bls_generator_preimage(), torsion, 1).serialize(ref data);
    ec_safe_add(ec_safe_add(bls_generator_preimage(), bls_generator_preimage(), 1), torsion, 1)
        .serialize(ref data);
    assert!(msm_g1(array![point].span(), array![2].span(), 1, data.span()) == q);
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_bls_rejects_offcurve_input_preimage() {
    let point = get_G(1);
    let mut data = array![];
    GlvFakeGlvHint { Q: point, u1: 0, u2: 0, v1: 0, v2: 0 }.serialize(ref data);
    G1Point { x: 0_u128.into(), y: 1_u128.into() }.serialize(ref data);
    G1PointZero::zero().serialize(ref data);
    msm_g1(array![point].span(), array![1].span(), 1, data.span());
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_bls_rejects_offcurve_output_preimage() {
    let point = get_G(1);
    let q = ec_safe_add(point, point, 1);
    let mut data = array![];
    GlvFakeGlvHint { Q: q, u1: SIGN + 2, u2: 0, v1: 1, v2: 0 }.serialize(ref data);
    bls_generator_preimage().serialize(ref data);
    G1Point { x: 0_u128.into(), y: 1_u128.into() }.serialize(ref data);
    msm_g1(array![point].span(), array![2].span(), 1, data.span());
}

#[test]
#[should_panic(expected: ('GLV: invalid sign',))]
fn test_glv_rejects_nonboolean_sign() {
    let point = get_G(0);
    let q = ec_safe_add(point, point, 0);
    glv_mul(point, 2, 0, GlvFakeGlvHint { Q: q, u1: 2 * SIGN + 2, u2: 0, v1: 1, v2: 0 });
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_glv_rejects_offcurve_output() {
    let q = G1Point { x: 0_u128.into(), y: 1_u128.into() };
    glv_mul(get_G(0), 2, 0, GlvFakeGlvHint { Q: q, u1: SIGN + 2, u2: 0, v1: 1, v2: 0 });
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_fake_glv_rejects_offcurve_output() {
    let q = G1Point { x: 0_u128.into(), y: 1_u128.into() };
    fake_mul(get_G(3), 2, 3, FakeGlvHint { Q: q, s1: 2, s2: SIGN + 1 }, G1PointZero::zero());
}

#[test]
#[should_panic(expected: ('FakeGLV: invalid sign',))]
fn test_fake_glv_rejects_nonboolean_sign() {
    let point = get_G(3);
    let q = ec_safe_add(point, point, 3);
    fake_mul(point, 2, 3, FakeGlvHint { Q: q, s1: 2, s2: 2 * SIGN + 1 }, G1PointZero::zero());
}

#[test]
#[should_panic(expected: ('FakeGLV: s2=0',))]
fn test_fake_glv_rejects_zero_denominator() {
    let point = get_G(3);
    let q = ec_safe_add(point, point, 3);
    fake_mul(point, 2, 3, FakeGlvHint { Q: q, s1: 0, s2: 0 }, G1PointZero::zero());
}

#[test]
#[should_panic]
fn test_bls_glv_rejects_torsion_input_even_scalar_one() {
    let torsion = G1Point { x: 0_u128.into(), y: 2_u128.into() };
    glv_mul(torsion, 1, 1, GlvFakeGlvHint { Q: torsion, u1: 0, u2: 0, v1: 0, v2: 0 });
}

#[test]
#[should_panic]
fn test_bls_glv_rejects_torsion_shifted_output() {
    let point = get_G(1);
    let torsion = G1Point { x: 0_u128.into(), y: 2_u128.into() };
    let q = ec_safe_add(ec_safe_add(point, point, 1), torsion, 1);
    glv_mul(point, 2, 1, GlvFakeGlvHint { Q: q, u1: SIGN + 6, u2: 0, v1: 3, v2: 0 });
}

#[test]
fn test_bls_glv_subgroup_scalar_edges() {
    let point = get_G(1);
    assert!(
        glv_mul(point, 0, 1, GlvFakeGlvHint { Q: point, u1: 0, u2: 0, v1: 0, v2: 0 }).is_infinity()
    );
    assert!(glv_mul(point, 1, 1, GlvFakeGlvHint { Q: point, u1: 0, u2: 0, v1: 0, v2: 0 }) == point);
    assert!(
        glv_mul(
            point, get_n(1) - 1, 1, GlvFakeGlvHint { Q: point, u1: 0, u2: 0, v1: 0, v2: 0 }
        ) == point
            .negate(1)
    );
}

fn ed25519_torsion() -> G1Point {
    G1Point {
        x: u384 {
            limb0: 0xe035a41c93a737a1ade43eb9,
            limb1: 0xeccbe0143e94516eaabd570c,
            limb2: 0x63009227b1e7ffbd,
            limb3: 0x0,
        },
        y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    }
}

#[test]
fn test_ed25519_pure_torsion_scalars() {
    assert!(
        fake_mul(
            ed25519_torsion(),
            u256 { low: 0x0, high: 0x0 },
            4,
            FakeGlvHint {
                Q: G1Point {
                    x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                },
                s1: 0,
                s2: 0
            },
            G1PointZero::zero()
        ) == G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        }
    );
    assert!(
        fake_mul(
            ed25519_torsion(),
            u256 { low: 0x1, high: 0x0 },
            4,
            FakeGlvHint {
                Q: G1Point {
                    x: u384 {
                        limb0: 0xe035a41c93a737a1ade43eb9,
                        limb1: 0xeccbe0143e94516eaabd570c,
                        limb2: 0x63009227b1e7ffbd,
                        limb3: 0x0
                    },
                    y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                },
                s1: 0,
                s2: 0
            },
            G1PointZero::zero()
        ) == G1Point {
            x: u384 {
                limb0: 0xe035a41c93a737a1ade43eb9,
                limb1: 0xeccbe0143e94516eaabd570c,
                limb2: 0x63009227b1e7ffbd,
                limb3: 0x0
            },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        }
    );
    assert!(
        fake_mul(
            ed25519_torsion(),
            u256 { low: 0x2, high: 0x0 },
            4,
            FakeGlvHint {
                Q: G1Point {
                    x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                },
                s1: 0,
                s2: 0
            },
            G1PointZero::zero()
        ) == G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        }
    );
    assert!(
        fake_mul(
            ed25519_torsion(),
            u256 { low: 0x3, high: 0x0 },
            4,
            FakeGlvHint {
                Q: G1Point {
                    x: u384 {
                        limb0: 0xe035a41c93a737a1ade43eb9,
                        limb1: 0xeccbe0143e94516eaabd570c,
                        limb2: 0x63009227b1e7ffbd,
                        limb3: 0x0
                    },
                    y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                },
                s1: 0,
                s2: 0
            },
            G1PointZero::zero()
        ) == G1Point {
            x: u384 {
                limb0: 0xe035a41c93a737a1ade43eb9,
                limb1: 0xeccbe0143e94516eaabd570c,
                limb2: 0x63009227b1e7ffbd,
                limb3: 0x0
            },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        }
    );
    assert!(
        fake_mul(
            ed25519_torsion(),
            u256 {
                low: 0x14def9dea2f79cd65812631a5cf5d3ec, high: 0x10000000000000000000000000000000
            },
            4,
            FakeGlvHint {
                Q: G1Point {
                    x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
                    y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
                },
                s1: 0,
                s2: 0
            },
            G1PointZero::zero()
        ) == G1Point {
            x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
            y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 }
        }
    );
}

#[test]
fn test_ed25519_mixed_order_even_scalar() {
    let point = G1Point {
        x: u384 {
            limb0: 0xd74925344227cacdd80550bf,
            limb1: 0x61c6572d50980af8aaba3a51,
            limb2: 0x199ceb92db5dc6e5,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x7e5519020d897196ebd15c3,
            limb1: 0x432e84011e6079a3e750cadc,
            limb2: 0x4399a04463baefc,
            limb3: 0x0,
        },
    };
    let q = G1Point {
        x: u384 {
            limb0: 0x595cb5059b3e18dfda41ab60,
            limb1: 0x33d5f745b28873cf8e9471da,
            limb2: 0x3ee30304b5d8c096,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x33781c1571e25bf6463bb212,
            limb1: 0x415da41d52c739243ab23035,
            limb2: 0x54a87393811d6105,
            limb3: 0x0,
        },
    };
    let preimage = G1Point {
        x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    };
    assert!(
        fake_mul(
            point,
            u256 { low: 0x2, high: 0x0 },
            4,
            FakeGlvHint { Q: q, s1: 0x2, s2: 0x100000000000000000000000000000001 },
            preimage
        ) == q
    );
}

#[test]
fn test_ed25519_mixed_order_odd_scalar() {
    let point = G1Point {
        x: u384 {
            limb0: 0xd74925344227cacdd80550bf,
            limb1: 0x61c6572d50980af8aaba3a51,
            limb2: 0x199ceb92db5dc6e5,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x7e5519020d897196ebd15c3,
            limb1: 0x432e84011e6079a3e750cadc,
            limb2: 0x4399a04463baefc,
            limb3: 0x0,
        },
    };
    let q = G1Point {
        x: u384 {
            limb0: 0xb15d6c8c3819a155650a4c85,
            limb1: 0x9880bede51305423ecfec3c9,
            limb2: 0x70ce75702b62d5ed,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xb308a6710fd4c779c2811a60,
            limb1: 0x743503a7d3a4cac3eb6473a1,
            limb2: 0x5be850264821d7f3,
            limb3: 0x0,
        },
    };
    let preimage = G1Point {
        x: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
        y: u384 { limb0: 0x0, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    };
    assert!(
        fake_mul(
            point,
            u256 { low: 0x3, high: 0x0 },
            4,
            FakeGlvHint { Q: q, s1: 0x3, s2: 0x100000000000000000000000000000001 },
            preimage
        ) == q
    );
}

#[test]
fn test_ed25519_mixed_order_order_minus_one() {
    let point = G1Point {
        x: u384 {
            limb0: 0xd74925344227cacdd80550bf,
            limb1: 0x61c6572d50980af8aaba3a51,
            limb2: 0x199ceb92db5dc6e5,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x7e5519020d897196ebd15c3,
            limb1: 0x432e84011e6079a3e750cadc,
            limb2: 0x4399a04463baefc,
            limb3: 0x0,
        },
    };
    let q = G1Point {
        x: u384 {
            limb0: 0xd617c9aca55c89b025aef35,
            limb1: 0xf00b8f02f1c20618a9c13fdf,
            limb2: 0x2a78dd0fd02c0339,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x7f8ece9a6487cf0c09d3e2d9,
            limb1: 0x41b7c45a9c867cdc30902f9e,
            limb2: 0x5639bb5a38e25dd1,
            limb3: 0x0,
        },
    };
    let preimage = G1Point {
        x: u384 {
            limb0: 0xf7abbc38db6094091213fd01,
            limb1: 0x280820f69a7219be2f549f08,
            limb2: 0x792c5602b6b379f9,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x7c9bc7ea298cea5acf74a2fc,
            limb1: 0x681ca6e04da32efff1633b38,
            limb2: 0x6876e6fcd4a849ba,
            limb3: 0x0,
        },
    };
    assert!(
        fake_mul(
            point,
            u256 {
                low: 0x14def9dea2f79cd65812631a5cf5d3ec, high: 0x10000000000000000000000000000000
            },
            4,
            FakeGlvHint { Q: q, s1: 0x1, s2: 0x1 },
            preimage
        ) == q
    );
}

#[test]
#[should_panic(expected: ('Wrong Ed25519 cofactor preimage',))]
fn test_ed25519_rejects_torsion_shifted_output() {
    let q = G1Point {
        x: u384 {
            limb0: 0xc34bdff8aa520a3b0330ac34,
            limb1: 0x5d90fb8e6eb4ddc763052d29,
            limb2: 0x3c0561f38a2828d7,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xe80be32f65404e6bc695a914,
            limb1: 0x94d517c1bce81a3d64edd42e,
            limb2: 0x1bdc256852781490,
            limb3: 0x0,
        },
    };
    fake_mul(get_G(4), 2, 4, FakeGlvHint { Q: q, s1: 2, s2: SIGN + 1 }, G1PointZero::zero());
}

#[test]
#[should_panic(expected: ('Wrong Ed25519 cofactor preimage',))]
fn test_ed25519_rejects_wrong_preimage() {
    let point = get_G(4);
    let q = ec_safe_add(point, point, 4);
    fake_mul(point, 2, 4, FakeGlvHint { Q: q, s1: 2, s2: SIGN + 1 }, point);
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_ed25519_rejects_offcurve_preimage() {
    let point = get_G(4);
    let q = ec_safe_add(point, point, 4);
    fake_mul(
        point,
        2,
        4,
        FakeGlvHint { Q: q, s1: 2, s2: SIGN + 1 },
        G1Point { x: 0_u128.into(), y: 1_u128.into() },
    );
}

#[test]
fn test_glv_all_coefficient_sign_patterns() {
    let q = G1Point {
        x: u384 {
            limb0: 0xc0fd54b257517881cbc3cddf,
            limb1: 0x8d8c2f36d9a9b24b4fe79feb,
            limb2: 0xa0bb6ad5ed3fdbf,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xa2d54afe9e9b08337f09f0c3,
            limb1: 0x60d8920e18267b337f1849f6,
            limb2: 0x1609960753d47f00,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x82c0b8af87bc2d94fb90bca1bc69082d, high: 0xad97efbfff6e7c24488454f25157e38
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x336f7ce4538d42d4,
                u2: 0x920aa3243628e4d5,
                v1: 0x1e71eec498435cef,
                v2: 0x5f7ffe509718533
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x8787f4277bb811c0563b9adc,
            limb1: 0xd12e342e0552eee674763cdc,
            limb2: 0x145f6d17d0c46e0c,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x3c50c4bddc1fcda76f2fd7f3,
            limb1: 0x4ffc80bc6c957514eb7276f4,
            limb2: 0x4c487f8723f1c62,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0xa61b0bde4a5104d131d0302ed4dae313, high: 0x25a457070040eb3a507239a780c47bed
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x13761f79078840b9,
                u2: 0x24e90f8a58d033b,
                v1: 0x561d1e4b6732cca5,
                v2: 0x10000000000000000056c8f2341f46091
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x161649bb62e2d49f9f24074d,
            limb1: 0xcdb8b02b11abe878a9251abd,
            limb2: 0x1019df50f0a2e78a,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x887532ee8a975e0d5b7a6c75,
            limb1: 0x1e36ef907a9ecc959a5fb4e8,
            limb2: 0xd5e75f7f43e0ae7,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x37d92426b0d41997a2140c2157ada766, high: 0xc535ff0b77f907a158f7a29e10479ec
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x8a21bddf29f62b21,
                u2: 0x89bd9bc78f489e62,
                v1: 0x10000000000000000648d23c05fe6f392,
                v2: 0xd2278e626bcb7ad
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x77d55bb4979244a45bbe5ab5,
            limb1: 0x39fbfd0f1f9eb40032243059,
            limb2: 0xb7567c798ce1507,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x7914e0babae5443d40b3d59b,
            limb1: 0x5c2cc4f1c42548acba098501,
            limb2: 0x126d8c7777d66e70,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x7eb9d8348528f5de84cf57b9625c53fb, high: 0x2216caa97acf717a24c6a37034cbd689
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x1760521510cccbf0,
                u2: 0x44d1f93cee8d41f5,
                v1: 0x10000000000000000495b774ca08f3975,
                v2: 0x1000000000000000007b222eb39ce4258
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x162c438b6c0fc4689a85244a,
            limb1: 0x9c3cda4a4bdf2159b297d85e,
            limb2: 0xd76ed079628e354,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x2fbcb361799ea543f5daf3d7,
            limb1: 0xeed10dcde3d892d81f709d24,
            limb2: 0x1156bd7566469877,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0xf4775e3187a82f4b14fe1fa40999684c, high: 0xfbc59655a2ea07a3ae1d4df86266fa9
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0xa55cb39f3accfcfe,
                u2: 0x10000000000000000255d735dcb0e1a15,
                v1: 0x237a71af7f99a561,
                v2: 0xf40476319f62b6b
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x3953692fc9020641453bf652,
            limb1: 0x49b03425143872cfd2a05513,
            limb2: 0x1665794bbc1f3c09,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x9f365bb4175295d309505e22,
            limb1: 0xe60cbc893856cdd712fce035,
            limb2: 0x77fd49b8b7fc34b,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x1bfc608a9c4d1e7ca8902ba12f259c41, high: 0x9e5f19c96e94c2c5e73782b6b7a9066
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x584b2159a0489d3d,
                u2: 0x100000000000000000265dde5b46ae46f,
                v1: 0x44723a0a2f12a997,
                v2: 0x10000000000000000121d2822d59fd983
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x82f634207c3e8097660b7cc,
            limb1: 0xaa8123c9a3896c7a73c0aa27,
            limb2: 0x2e2ba24b51fa184a,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x80bda248445b86d7372c4f3c,
            limb1: 0x5b394bd44c8ff19d31d16157,
            limb2: 0x1a7e0ffe12002aa2,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x604b6f615a990b3eefb389df2dc77b52, high: 0x23d177d73b0b8b9939bc4b1bce366bbf
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x81d70a4d1e96aed3,
                u2: 0x100000000000000004bcc6b329a3e85a4,
                v1: 0x100000000000000002ec007bf8a6da80d,
                v2: 0x241cecaa9d18cecb
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x1d8e39c3f5aa52c805d2d8d1,
            limb1: 0xa8e2050ca80f1426c7bae1e4,
            limb2: 0x2fa82bf2969befe7,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x8d49e8da8f43874d950decd0,
            limb1: 0x1c39388d1c48953764cfc4d3,
            limb2: 0xb7fe93170433138,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x32d71ce27b59fb6918d509a1858ada29, high: 0x161f6c1c37243597d4959ea8b82924b6
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x116229be0e86a544,
                u2: 0x100000000000000008c5a85ea9d22d2d9,
                v1: 0x1000000000000000022d2ea579b86cc9c,
                v2: 0x1000000000000000009ec586d4dbeeeaa
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0xdc3d781cc55cf14ffea1ce36,
            limb1: 0xd735a6d15b385095a06045ca,
            limb2: 0x28a94e919b4891ca,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x4476d32e275841c602a84274,
            limb1: 0x9898a94147537cb4d22e87c3,
            limb2: 0xe4a00116ff2a6ac,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x9facb7f015b6f82fd7c9cff8e441fc13, high: 0x14bc3e01611da5625ae8130896882de3
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x100000000000000004b4b6383702bd018,
                u2: 0x351c3221a5dabf6,
                v1: 0x86df6a5b7b1b7665,
                v2: 0x26f91dcabe1f3262
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x3b0dcbc4cdf6fc5ca0ab17b4,
            limb1: 0x72c29be53d47b8d23b611dfb,
            limb2: 0x4415297862d57b4,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xcce2e76b545b50fa31620314,
            limb1: 0x83daebf4c077dff5c0d2618b,
            limb2: 0x1fd33500aa26a0e9,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0xfeab3431d0701e04b8d04ad3a8fc66b3, high: 0x2b6d0bcf0114a1dc7f7b96e96a4d5f4a
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x100000000000000001108e836ae11edcd,
                u2: 0x20b71651bf2d6272,
                v1: 0x4a462bc006c4f56d,
                v2: 0x1000000000000000022d5a270b6bec9cb
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0xb9ce4b4eb686c0b48997654c,
            limb1: 0x51943aaacef26b72b2ef0a9,
            limb2: 0x2c48345d0d5bb609,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x912c9bdff3d5ade156a7bc3c,
            limb1: 0x31d59915663d49325d6008aa,
            limb2: 0x13e663482b96cb8e,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x62a5a553d9b3a4485f43a565f0418b63, high: 0x77a336a0c72d0e2a64fdd40a716772d
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x1000000000000000080f050a48301432b,
                u2: 0x1070a1544f782402,
                v1: 0x100000000000000004baf27bdd0f74417,
                v2: 0x8de6bfa2591122a
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x1dfef0d02e5a6534397cb050,
            limb1: 0x1f7fcf7f0cc26a304240faf3,
            limb2: 0x22a92064aefe8b9e,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xac59a309d0314e9a8dd083fa,
            limb1: 0xc1b722385b82279325864fa9,
            limb2: 0x28bd8d5971b8589c,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0xe43ecbd00bcee805e2eea4b6e2106869, high: 0x5bd52e7810513fb883f81db158dc7d0
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x100000000000000000b74ed451fcf3bea,
                u2: 0x1df74bccf1af21f0,
                v1: 0x100000000000000005ee4c83762d25cdd,
                v2: 0x10000000000000000226fdbfedac1c223
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x291bd87908ce29cfdf1eaa7f,
            limb1: 0xb6414e90f354a7588635e3de,
            limb2: 0xe83969e4e44e607,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x3d2766c4615d25b4454b0797,
            limb1: 0x498bec342714af4dca66c7c3,
            limb2: 0x26b94eae6c73594b,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x5e86a1b5562994532d4ef5f32a7f63f5, high: 0x3047c57e2966570cd21514adebf63aa1
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x100000000000000008fdba2166aa7a29f,
                u2: 0x1000000000000000098859859d14ef351,
                v1: 0x326d0b0cffaae963,
                v2: 0xe8bbf34c10a3308
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x5ee681ed3cecb3fe214ff25a,
            limb1: 0xd371a67880144d9014b991ad,
            limb2: 0x20a7b298e62ae089,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x3fcd060d8b1fac49f6d806a5,
            limb1: 0xae8fa9b16c0367c4a2b71504,
            limb2: 0x12f776625dd9693c,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x27a37706b42e219ec96ef963c2d56fe8, high: 0x1f130887936703e2a197bb3b79ef2ae2
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x10000000000000000237752dae10afaa9,
                u2: 0x1000000000000000000d9ae0442ace195,
                v1: 0x9360afc2e59b7750,
                v2: 0x1000000000000000003e4f9c6af9216bc
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0xd67039ac841057cb7bd7017d,
            limb1: 0xf3ff76513b12018488ac0676,
            limb2: 0x10a8464d05745f2,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xef56650fb1ba02216b9ed735,
            limb1: 0x5676abf96d99ba21d4a8c08,
            limb2: 0x26fb596561cad263,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0x81bd3a7a7f1d16a78a127612483f445c, high: 0x1a6575f42a73609e1545625f05a7198d
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x10000000000000000799566248137bf64,
                u2: 0x1000000000000000060d81fd3e6d1d4ff,
                v1: 0x10000000000000000223b6a33c43f1275,
                v2: 0xc9eb6a318d4245d
            }
        ) == q
    );
    let q = G1Point {
        x: u384 {
            limb0: 0x23f28724a467dbce66808636,
            limb1: 0xbf71a604b7b04ad9f12af6c0,
            limb2: 0x1286e62ceac20cd2,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x457f4a2652e9d84233a5305f,
            limb1: 0xba70060e3c8aaaa27b8166b3,
            limb2: 0x1d1ca03217f8de39,
            limb3: 0x0,
        },
    };
    assert!(
        glv_mul(
            get_G(0),
            u256 {
                low: 0xebd34a440ab6ac78eb6a5b2981724735, high: 0x29bb528b63329371d71e1cae53089f82
            },
            0,
            GlvFakeGlvHint {
                Q: q,
                u1: 0x10000000000000000206539ae94716e6a,
                u2: 0x10000000000000000109ba8c50f657e41,
                v1: 0x1000000000000000082aad2def813c57d,
                v2: 0x10000000000000000233e78b44fd5ae4c
            }
        ) == q
    );
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_curve_0_rejects_noncanonical_output_x() {
    let q = G1Point {
        x: u384 {
            limb0: 0x7ef8e7360fe294d84604cd1a,
            limb1: 0x53d54a11e9996de370f9813a,
            limb2: 0x336a935a0f44ba2c,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0xe3538fc7ff3ebf7a5a18a2c4,
            limb1: 0xe7845f96b2ae9c0a68a6a449,
            limb2: 0x15ed738c0e0a7c92,
            limb3: 0x0,
        },
    };
    glv_mul(get_G(0), 2, 0, GlvFakeGlvHint { Q: q, u1: SIGN + 2, u2: 0, v1: 1, v2: 0 });
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_curve_0_rejects_noncanonical_output_y() {
    let q = G1Point {
        x: u384 {
            limb0: 0x16871ca8d3c208c16d87cfd3,
            limb1: 0x9b85045b68181585d97816a9,
            limb2: 0x30644e72e131a02,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x4bc55a553b5f4b913295a00b,
            limb1: 0x9fd4a54d342ff46800280edb,
            limb2: 0x4651c1feef3c1cbc,
            limb3: 0x0,
        },
    };
    glv_mul(get_G(0), 2, 0, GlvFakeGlvHint { Q: q, u1: SIGN + 2, u2: 0, v1: 1, v2: 0 });
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_curve_3_rejects_noncanonical_output_x() {
    let q = G1Point {
        x: u384 {
            limb0: 0x77f21b35a60b48fc47669977,
            limb1: 0x8a52380304b51ac3c08969e3,
            limb2: 0x17cf27b178d034f7f,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x3ce982299e04b79d227873d1,
            limb1: 0x293d9ac69f7430dbba7dade6,
            limb2: 0x7775510db8ed040,
            limb3: 0x0,
        },
    };
    fake_mul(get_G(3), 2, 3, FakeGlvHint { Q: q, s1: 2, s2: SIGN + 1 }, G1PointZero::zero());
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_curve_3_rejects_noncanonical_output_y() {
    let q = G1Point {
        x: u384 {
            limb0: 0x77f21b35a60b48fc47669978,
            limb1: 0x8a52380304b51ac3c08969e2,
            limb2: 0x7cf27b188d034f7e,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x3ce982299e04b79d227873d0,
            limb1: 0x293d9ac69f7430dbba7dade7,
            limb2: 0x10777550fdb8ed041,
            limb3: 0x0,
        },
    };
    fake_mul(get_G(3), 2, 3, FakeGlvHint { Q: q, s1: 2, s2: SIGN + 1 }, G1PointZero::zero());
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_curve_4_rejects_noncanonical_output_x() {
    let q = G1Point {
        x: u384 {
            limb0: 0x595cb5059b3e18dfda41ab4d,
            limb1: 0x33d5f745b28873cf8e9471da,
            limb2: 0xbee30304b5d8c096,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x33781c1571e25bf6463bb212,
            limb1: 0x415da41d52c739243ab23035,
            limb2: 0x54a87393811d6105,
            limb3: 0x0,
        },
    };
    fake_mul(get_G(4), 2, 4, FakeGlvHint { Q: q, s1: 2, s2: SIGN + 1 }, G1PointZero::zero());
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_curve_4_rejects_noncanonical_output_y() {
    let q = G1Point {
        x: u384 {
            limb0: 0x595cb5059b3e18dfda41ab60,
            limb1: 0x33d5f745b28873cf8e9471da,
            limb2: 0x3ee30304b5d8c096,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x33781c1571e25bf6463bb1ff,
            limb1: 0x415da41d52c739243ab23035,
            limb2: 0xd4a87393811d6105,
            limb3: 0x0,
        },
    };
    fake_mul(get_G(4), 2, 4, FakeGlvHint { Q: q, s1: 2, s2: SIGN + 1 }, G1PointZero::zero());
}

#[test]
#[should_panic(expected: ('point not on curve',))]
fn test_glv_scalar_one_rejects_noncanonical_input() {
    let point = G1Point {
        x: u384 {
            limb0: 0x6871ca8d3c208c16d87cfd48,
            limb1: 0xb85045b68181585d97816a91,
            limb2: 0x30644e72e131a029,
            limb3: 0x0,
        },
        y: u384 { limb0: 0x2, limb1: 0x0, limb2: 0x0, limb3: 0x0 },
    };
    glv_mul(point, 1, 0, GlvFakeGlvHint { Q: get_G(0), u1: 0, u2: 0, v1: 0, v2: 0 });
}

#[test]
fn test_public_double_and_add_8_nonzero_a() {
    let point = get_G(3);
    let q = ec_safe_add(point, point, 3);
    let expected = G1Point {
        x: u384 {
            limb0: 0xeb06d315cb694027f436bea7,
            limb1: 0x49b7de080c3036cfea66a8a3,
            limb2: 0xd132fcfcededb8b2,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x4d447269ece6dd3e5bfb9cf4,
            limb1: 0xf074f7b6adc3ed45e063d192,
            limb2: 0x686d3b0af98c2a4e,
            limb3: 0x0,
        },
    };
    assert!(double_and_add_8(point, q, q, q, q, q, q, q, q, get_modulus(3)) == expected);
    let point = get_G(4);
    let q = ec_safe_add(point, point, 4);
    let expected = G1Point {
        x: u384 {
            limb0: 0x457ac5126f3846047dfc04ad,
            limb1: 0xb0c3a300ca650136db4b6a93,
            limb2: 0x533d230422d21351,
            limb3: 0x0,
        },
        y: u384 {
            limb0: 0x3d04be8d17e35bd7c4ea049b,
            limb1: 0xf639ea733939d39aaad2145b,
            limb2: 0x4ed3ef9f474a1df8,
            limb3: 0x0,
        },
    };
    assert!(double_and_add_8(point, q, q, q, q, q, q, q, q, get_modulus(4)) == expected);
}
