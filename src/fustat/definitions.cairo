from starkware.cairo.common.cairo_builtins import UInt384

namespace bls {
    const CURVE_ID = 1;
    // p = 0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB
    const P0 = 0xb153ffffb9feffffffffaaab;
    const P1 = 0x6730d2a0f6b0f6241eabfffe;
    const P2 = 0x434bacd764774b84f38512bf;
    const P3 = 0x1a0111ea397fe69a4b1ba7b6;

    // The following constants represent the size of the curve:
    // n = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
    const N0 = 0xfffe5bfeffffffff00000001;
    const N1 = 0x3339d80809a1d80553bda402;
    const N2 = 0x73eda753299d7d48;

    // Non residue constants:
    const NON_RESIDUE_E2_a0 = 1;
    const NON_RESIDUE_E2_a1 = 1;

    // Curve equation parameters:
    const a = 0;
    const b = 4;

    // Fp generator :
    const g = 3;

    // Hardcoded (-1) mod p
    const MIN_ONE_D0 = 54880396502181392957329877674;
    const MIN_ONE_D1 = 31935979117156477062286671870;
    const MIN_ONE_D2 = 20826981314825584179608359615;
    const MIN_ONE_D3 = 8047903782086192180586325942;
}

namespace bn {
    const CURVE_ID = 0;
    // p = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47
    const P0 = 0x6871ca8d3c208c16d87cfd47;
    const P1 = 0xb85045b68181585d97816a91;
    const P2 = 0x30644e72e131a029;

    // The following constants represent the size of the curve:
    // n = n(u) = 36u^4 + 36u^3 + 18u^2 + 6u + 1
    // n = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
    const N0 = 0x79b9709143e1f593f0000001;
    const N1 = 0xb85045b68181585d2833e848;
    const N2 = 0x30644e72e131a029;

    // Non residue constants:
    const NON_RESIDUE_E2_a0 = 9;
    const NON_RESIDUE_E2_a1 = 1;
    // Curve equation parameters:
    const a = 0;
    const b = 3;
    // Fp Generator :
    const g = 3;

    // Hardcoded (-1) mod p
    const MIN_ONE_D0 = 32324006162389411176778628422;
    const MIN_ONE_D1 = 57042285082623239461879769745;
    const MIN_ONE_D2 = 3486998266802970665;
    const MIN_ONE_D3 = 0;
}

namespace secp256k1 {
    const CURVE_ID = 2;
    const P0 = 0xfffffffffffffffefffffc2f;
    const P1 = 0xffffffffffffffffffffffff;
    const P2 = 0xffffffffffffffff;
    const P3 = 0x0;
    const N0 = 0xaf48a03bbfd25e8cd0364141;
    const N1 = 0xfffffffffffffffebaaedce6;
    const N2 = 0xffffffffffffffff;
    const N3 = 0x0;
    const A0 = 0x0;
    const A1 = 0x0;
    const A2 = 0x0;
    const A3 = 0x0;
    const B0 = 0x7;
    const B1 = 0x0;
    const B2 = 0x0;
    const B3 = 0x0;
    const G0 = 0x3;
    const G1 = 0x0;
    const G2 = 0x0;
    const G3 = 0x0;
    const MIN_ONE_D0 = 0xfffffffffffffffefffffc2e;
    const MIN_ONE_D1 = 0xffffffffffffffffffffffff;
    const MIN_ONE_D2 = 0xffffffffffffffff;
    const MIN_ONE_D3 = 0x0;
}

namespace secp256r1 {
    const CURVE_ID = 3;
    const P0 = 0xffffffffffffffffffffffff;
    const P1 = 0x0;
    const P2 = 0xffffffff00000001;
    const P3 = 0x0;
    const N0 = 0xa7179e84f3b9cac2fc632551;
    const N1 = 0xffffffffffffffffbce6faad;
    const N2 = 0xffffffff00000000;
    const N3 = 0x0;
    const A0 = 0xfffffffffffffffffffffffc;
    const A1 = 0x0;
    const A2 = 0xffffffff00000001;
    const A3 = 0x0;
    const B0 = 0xcc53b0f63bce3c3e27d2604b;
    const B1 = 0xb3ebbd55769886bc651d06b0;
    const B2 = 0x5ac635d8aa3a93e7;
    const B3 = 0x0;
    const G0 = 0x6;
    const G1 = 0x0;
    const G2 = 0x0;
    const G3 = 0x0;
    const MIN_ONE_D0 = 0xfffffffffffffffffffffffe;
    const MIN_ONE_D1 = 0x0;
    const MIN_ONE_D2 = 0xffffffff00000001;
    const MIN_ONE_D3 = 0x0;
}

func get_P(curve_id: felt) -> (prime: UInt384) {
    if (curve_id == bls.CURVE_ID) {
        return (UInt384(bls.P0, bls.P1, bls.P2, bls.P3),);
    } else {
        if (curve_id == bn.CURVE_ID) {
            return (UInt384(bn.P0, bn.P1, bn.P2, 0),);
        } else {
            if (curve_id == secp256k1.CURVE_ID) {
                return (UInt384(secp256k1.P0, secp256k1.P1, secp256k1.P2, secp256k1.P3),);
            } else {
                if (curve_id == secp256r1.CURVE_ID) {
                    return (UInt384(secp256r1.P0, secp256r1.P1, secp256r1.P2, secp256r1.P3),);
                } else {
                    return (UInt384(-1, 0, 0, 0),);
                }
            }
        }
    }
}

func get_b(curve_id: felt) -> (res: UInt384) {
    if (curve_id == bls.CURVE_ID) {
        return (res=UInt384(bls.b, 0, 0, 0));
    } else {
        if (curve_id == bn.CURVE_ID) {
            return (res=UInt384(bn.b, 0, 0, 0));
        } else {
            if (curve_id == secp256k1.CURVE_ID) {
                return (res=UInt384(secp256k1.B0, secp256k1.B1, secp256k1.B2, secp256k1.B3));
            } else {
                if (curve_id == secp256r1.CURVE_ID) {
                    return (res=UInt384(secp256r1.B0, secp256r1.B1, secp256r1.B2, secp256r1.B3));
                } else {
                    return (res=UInt384(-1, 0, 0, 0));
                }
            }
        }
    }
}

func get_b2(curve_id: felt) -> (b20: UInt384, b21: UInt384) {
    if (curve_id == bls.CURVE_ID) {
        return (b20=UInt384(4, 0, 0, 0), b21=UInt384(4, 0, 0, 0));
    } else {
        if (curve_id == bn.CURVE_ID) {
            return (
                b20=UInt384(
                    27810052284636130223308486885,
                    40153378333836448380344387045,
                    3104278944836790958,
                    0,
                ),
                b21=UInt384(
                    70926583776874220189091304914,
                    63498449372070794915149226116,
                    42524369107353300,
                    0,
                ),
            );
        } else {
            return (b20=UInt384(-1, 0, 0, 0), b21=UInt384(-1, 0, 0, 0));
        }
    }
}

func get_min_one(curve_id: felt) -> (res: UInt384) {
    if (curve_id == bls.CURVE_ID) {
        return (res=UInt384(bls.MIN_ONE_D0, bls.MIN_ONE_D1, bls.MIN_ONE_D2, bls.MIN_ONE_D3));
    } else {
        if (curve_id == bn.CURVE_ID) {
            return (res=UInt384(bn.MIN_ONE_D0, bn.MIN_ONE_D1, bn.MIN_ONE_D2, bn.MIN_ONE_D3));
        } else {
            if (curve_id == secp256k1.CURVE_ID) {
                return (
                    res=UInt384(
                        secp256k1.MIN_ONE_D0,
                        secp256k1.MIN_ONE_D1,
                        secp256k1.MIN_ONE_D2,
                        secp256k1.MIN_ONE_D3,
                    ),
                );
            } else {
                if (curve_id == secp256r1.CURVE_ID) {
                    return (
                        res=UInt384(
                            secp256r1.MIN_ONE_D0,
                            secp256r1.MIN_ONE_D1,
                            secp256r1.MIN_ONE_D2,
                            secp256r1.MIN_ONE_D3,
                        ),
                    );
                } else {
                    return (res=UInt384(-1, 0, 0, 0));
                }
            }
        }
    }
}

func get_a(curve_id: felt) -> (res: UInt384) {
    if (curve_id == bls.CURVE_ID) {
        return (res=UInt384(bls.a, 0, 0, 0));
    } else {
        if (curve_id == bn.CURVE_ID) {
            return (res=UInt384(bn.a, 0, 0, 0));
        } else {
            if (curve_id == secp256k1.CURVE_ID) {
                return (res=UInt384(secp256k1.A0, secp256k1.A1, secp256k1.A2, secp256k1.A3));
            } else {
                if (curve_id == secp256r1.CURVE_ID) {
                    return (res=UInt384(secp256r1.A0, secp256r1.A1, secp256r1.A2, secp256r1.A3));
                } else {
                    return (res=UInt384(-1, 0, 0, 0));
                }
            }
        }
    }
}

func get_fp_gen(curve_id: felt) -> (res: UInt384) {
    if (curve_id == bls.CURVE_ID) {
        return (res=UInt384(bls.g, 0, 0, 0));
    } else {
        if (curve_id == bn.CURVE_ID) {
            return (res=UInt384(bn.g, 0, 0, 0));
        } else {
            if (curve_id == secp256k1.CURVE_ID) {
                return (res=UInt384(secp256k1.G0, secp256k1.G1, secp256k1.G2, secp256k1.G3));
            } else {
                if (curve_id == secp256r1.CURVE_ID) {
                    return (res=UInt384(secp256r1.G0, secp256r1.G1, secp256r1.G2, secp256r1.G3));
                } else {
                    return (res=UInt384(-1, 0, 0, 0));
                }
            }
        }
    }
}
const SUPPORTED_CURVE_ID = 0;
const UNSUPPORTED_CURVE_ID = 1;

func is_curve_id_supported(curve_id: felt) -> (res: felt) {
    if (curve_id == bls.CURVE_ID) {
        return (res=SUPPORTED_CURVE_ID);
    } else {
        if (curve_id == bn.CURVE_ID) {
            return (res=SUPPORTED_CURVE_ID);
        } else {
            return (res=UNSUPPORTED_CURVE_ID);
        }
    }
}

// Base for UInt384 / BigInt4
const BASE = 2 ** 96;
const N_LIMBS = 4;

const STARK_MIN_ONE_D2 = 0x800000000000011;

struct G1Point {
    x: UInt384,
    y: UInt384,
}

func G1Point_eq_zero(p: G1Point) -> (res: felt) {
    if (p.x.d0 != 0) {
        return (res=0);
    }
    if (p.x.d1 != 0) {
        return (res=0);
    }
    if (p.x.d2 != 0) {
        return (res=0);
    }
    if (p.x.d3 != 0) {
        return (res=0);
    }
    if (p.y.d0 != 0) {
        return (res=0);
    }
    if (p.y.d1 != 0) {
        return (res=0);
    }
    if (p.y.d2 != 0) {
        return (res=0);
    }
    if (p.y.d3 != 0) {
        return (res=0);
    }
    return (res=1);
}

struct G2Point {
    x0: UInt384,
    x1: UInt384,
    y0: UInt384,
    y1: UInt384,
}

struct G1G2Pair {
    P: G1Point,
    Q: G2Point,
}

struct E6D {
    v0: UInt384,
    v1: UInt384,
    v2: UInt384,
    v3: UInt384,
    v4: UInt384,
    v5: UInt384,
}

struct E12D {
    w0: UInt384,
    w1: UInt384,
    w2: UInt384,
    w3: UInt384,
    w4: UInt384,
    w5: UInt384,
    w6: UInt384,
    w7: UInt384,
    w8: UInt384,
    w9: UInt384,
    w10: UInt384,
    w11: UInt384,
}

func zero_E12D() -> (res: E12D) {
    return (
        res=E12D(
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
        ),
    );
}

func one_E12D() -> (res: E12D) {
    return (
        res=E12D(
            UInt384(1, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
        ),
    );
}

func one_E6D() -> (res: E6D) {
    return (
        res=E6D(
            UInt384(1, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
            UInt384(0, 0, 0, 0),
        ),
    );
}

struct UnreducedBigInt7 {
    d0: felt,
    d1: felt,
    d2: felt,
    d3: felt,
    d4: felt,
    d5: felt,
    d6: felt,
}

func UInt384_mul(x: UInt384, y: UInt384) -> (res: UnreducedBigInt7) {
    return (
        UnreducedBigInt7(
            d0=x.d0 * y.d0,
            d1=x.d0 * y.d1 + x.d1 * y.d0,
            d2=x.d0 * y.d2 + x.d1 * y.d1 + x.d2 * y.d0,
            d3=x.d0 * y.d3 + x.d1 * y.d2 + x.d2 * y.d1 + x.d3 * y.d0,
            d4=x.d1 * y.d3 + x.d2 * y.d2 + x.d3 * y.d1,
            d5=x.d2 * y.d3 + x.d3 * y.d2,
            d6=x.d3 * y.d3,
        ),
    );
}

func is_zero_mod_P{range_check_ptr, range_check96_ptr: felt*}(x: UInt384, p: UInt384) -> (
    res: felt
) {
    alloc_locals;
    %{
        from garaga.hints.io import bigint_pack
        x = bigint_pack(ids.x, 4, 2**96)
        p = bigint_pack(ids.p, 4, 2**96)
        x=x%p
    %}
    if (nondet %{ x == 0 %} != 0) {
        verify_zero4(x, p);
        return (res=1);
    }

    local x_inv: UInt384;
    %{
        from garaga.hints.io import bigint_fill
        bigint_fill(pow(x, -1, p), ids.x_inv, ids.N_LIMBS, ids.BASE)
    %}
    assert [range_check96_ptr] = x_inv.d0;
    assert [range_check96_ptr + 1] = x_inv.d1;
    assert [range_check96_ptr + 2] = x_inv.d2;
    assert [range_check96_ptr + 3] = x_inv.d3;

    tempvar range_check96_ptr = range_check96_ptr + 4;

    let (x_x_inv) = UInt384_mul(x, x_inv);

    // Check that x * x_inv = 1 to verify that x != 0.
    verify_zero7(
        UnreducedBigInt7(
            d0=x_x_inv.d0 - 1,
            d1=x_x_inv.d1,
            d2=x_x_inv.d2,
            d3=x_x_inv.d3,
            d4=x_x_inv.d4,
            d5=x_x_inv.d5,
            d6=x_x_inv.d6,
        ),
        p,
    );
    return (res=0);
}

func verify_zero4{range_check_ptr, range_check96_ptr: felt*}(x: UInt384, p: UInt384) {
    alloc_locals;
    local q: felt;
    %{
        from garaga.hints.io import bigint_pack

        x = bigint_pack(ids.x, 4, 2**96)
        p = bigint_pack(ids.p, 4, 2**96)

        q, r = divmod(x, p)
        assert r == 0, f"verify_zero: Invalid input."
        ids.q=q
    %}

    assert [range_check96_ptr] = q;

    tempvar carry1 = (q * p.d0 - x.d0) / BASE;
    assert [range_check_ptr] = carry1 + 2 ** 127;

    tempvar carry2 = (q * p.d1 - x.d1 + carry1) / BASE;
    assert [range_check_ptr + 1] = carry2 + 2 ** 127;

    tempvar carry3 = (q * p.d2 - x.d2 + carry2) / BASE;
    assert [range_check_ptr + 2] = carry3 + 2 ** 127;

    assert q * p.d3 - x.d3 + carry3 = 0;

    let range_check_ptr = range_check_ptr + 3;
    let range_check96_ptr = range_check96_ptr + 1;

    return ();
}

func verify_zero7{range_check_ptr, range_check96_ptr: felt*}(val: UnreducedBigInt7, p: UInt384) {
    alloc_locals;
    local q: UInt384;
    %{
        from garaga.hints.io import bigint_pack, bigint_fill

        val = bigint_pack(ids.val, 7, 2**96)
        p = bigint_pack(ids.p, 4, 2**96)

        q, r = divmod(val, p)
        assert r == 0, f"verify_zero: Invalid input {val%p}."
        bigint_fill(q, ids.q, ids.N_LIMBS, ids.BASE)
    %}

    assert [range_check_ptr] = q.d0 + 2 ** 127;
    assert [range_check_ptr + 1] = q.d1 + 2 ** 127;
    assert [range_check_ptr + 2] = q.d2 + 2 ** 127;
    assert [range_check_ptr + 3] = q.d3 + 2 ** 127;

    tempvar q_P: UnreducedBigInt7 = UnreducedBigInt7(
        d0=q.d0 * p.d0,
        d1=q.d0 * p.d1 + q.d1 * p.d0,
        d2=q.d0 * p.d2 + q.d1 * p.d1 + q.d2 * p.d0,
        d3=q.d0 * p.d3 + q.d1 * p.d2 + q.d2 * p.d1 + q.d3 * p.d0,
        d4=q.d1 * p.d3 + q.d2 * p.d2 + q.d3 * p.d1,
        d5=q.d2 * p.d3 + q.d3 * p.d2,
        d6=q.d3 * p.d3,
    );

    tempvar carry1 = (q_P.d0 - val.d0) / BASE;
    assert [range_check_ptr + 4] = carry1 + 2 ** 127;

    tempvar carry2 = (q_P.d1 - val.d1 + carry1) / BASE;
    assert [range_check_ptr + 5] = carry2 + 2 ** 127;

    tempvar carry3 = (q_P.d2 - val.d2 + carry2) / BASE;
    assert [range_check_ptr + 6] = carry3 + 2 ** 127;

    tempvar carry4 = (q_P.d3 - val.d3 + carry3) / BASE;
    assert [range_check_ptr + 7] = carry4 + 2 ** 127;

    tempvar carry5 = (q_P.d4 - val.d4 + carry4) / BASE;
    assert [range_check_ptr + 8] = carry5 + 2 ** 127;

    tempvar carry6 = (q_P.d5 - val.d5 + carry5) / BASE;
    assert [range_check_ptr + 9] = carry6 + 2 ** 127;

    assert q_P.d6 - val.d6 + carry6 = 0;

    tempvar range_check_ptr = range_check_ptr + 10;
    return ();
}

func is_zero_E6D{range_check_ptr, range_check96_ptr: felt*}(x: E6D, curve_id: felt) -> (res: felt) {
    alloc_locals;
    let (P) = get_P(curve_id);
    let (is_zero_v0) = is_zero_mod_P(x.v0, P);
    let (is_zero_v1) = is_zero_mod_P(x.v1, P);
    let (is_zero_v2) = is_zero_mod_P(x.v2, P);
    let (is_zero_v3) = is_zero_mod_P(x.v3, P);
    let (is_zero_v4) = is_zero_mod_P(x.v4, P);
    let (is_zero_v5) = is_zero_mod_P(x.v5, P);
    if (is_zero_v0 == 0) {
        return (res=0);
    }
    if (is_zero_v1 == 0) {
        return (res=0);
    }
    if (is_zero_v2 == 0) {
        return (res=0);
    }
    if (is_zero_v3 == 0) {
        return (res=0);
    }
    if (is_zero_v4 == 0) {
        return (res=0);
    }
    if (is_zero_v5 == 0) {
        return (res=0);
    }
    return (res=1);
}
