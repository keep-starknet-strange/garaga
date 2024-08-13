%builtins range_check poseidon range_check96 add_mod mul_mod

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin, ModBuiltin
from starkware.cairo.common.registers import get_fp_and_pc
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.uint256 import Uint256

from definitions import bn, bls, secp256k1, secp256r1, UInt384, N_LIMBS, BASE, G1Point

from ec_ops import compute_slope_intercept_same_point, msm, add_ec_points

func main{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}() {
    alloc_locals;

    test_add_ec_points(curve_id=bn.CURVE_ID);
    test_add_ec_points(curve_id=bls.CURVE_ID);
    test_add_ec_points(curve_id=secp256k1.CURVE_ID);
    test_add_ec_points(curve_id=secp256r1.CURVE_ID);

    let (res) = test_msm_n_points(curve_id=bn.CURVE_ID, n=1);
    let (res) = test_msm_n_points(curve_id=bn.CURVE_ID, n=2);
    let (res) = test_msm_n_points(curve_id=bn.CURVE_ID, n=3);

    let (res) = test_msm_n_points(curve_id=bls.CURVE_ID, n=1);
    let (res) = test_msm_n_points(curve_id=bls.CURVE_ID, n=2);
    let (res) = test_msm_n_points(curve_id=bls.CURVE_ID, n=3);

    let (res) = test_msm_n_points(curve_id=secp256k1.CURVE_ID, n=1);
    let (res) = test_msm_n_points(curve_id=secp256k1.CURVE_ID, n=2);
    let (res) = test_msm_n_points(curve_id=secp256k1.CURVE_ID, n=3);

    let (res) = test_msm_n_points(curve_id=secp256r1.CURVE_ID, n=1);
    let (res) = test_msm_n_points(curve_id=secp256r1.CURVE_ID, n=2);
    let (res) = test_msm_n_points(curve_id=secp256r1.CURVE_ID, n=3);

    return ();
}

func test_msm_n_points{
    range_check_ptr,
    poseidon_ptr: PoseidonBuiltin*,
    range_check96_ptr: felt*,
    add_mod_ptr: ModBuiltin*,
    mul_mod_ptr: ModBuiltin*,
}(curve_id: felt, n: felt) -> (res: G1Point) {
    alloc_locals;
    let (points, scalars, expected_msm_res) = get_random_g1_points_and_scalars(n, curve_id);
    let (res) = msm(curve_id, points, scalars, n);

    assert res = expected_msm_res;
    return (res,);
}

func test_add_ec_points{
    range_check_ptr, range_check96_ptr: felt*, add_mod_ptr: ModBuiltin*, mul_mod_ptr: ModBuiltin*
}(curve_id: felt) {
    alloc_locals;
    local P: G1Point;
    local Q: G1Point;
    local expected_res: G1Point;
    %{
        from garaga.definitions import G1Point, CurveID, CURVES
        from garaga.hints.io import flatten, fill_bigint_array_into_felt_ptr, split_128, fill_felt_ptr, fill_g1_point
        import random
        random.seed(0)
        curve_id = CurveID(ids.curve_id)
        order = CURVES[curve_id.value].n
        P = G1Point.gen_random_point(curve_id)
        Q = G1Point.gen_random_point(curve_id)
        fill_g1_point((P.x, P.y), ids.P)
        fill_g1_point((Q.x, Q.y), ids.Q)

        expected_res = P.add(Q)
        fill_g1_point((expected_res.x, expected_res.y), ids.expected_res)
    %}
    let (res) = add_ec_points(curve_id, P, Q);
    assert res = expected_res;
    return ();
}

func get_random_g1_points_and_scalars(n: felt, curve_id: felt) -> (
    points: G1Point*, scalars: Uint256*, expected_msm_res: G1Point
) {
    alloc_locals;
    let (local points: felt*) = alloc();
    let (local scalars: felt*) = alloc();
    local expected_msm_res: G1Point;
    %{
        from garaga.definitions import G1Point, CurveID, CURVES
        from garaga.hints.io import flatten, fill_bigint_array_into_felt_ptr, split_128, fill_felt_ptr, fill_g1_point
        import random
        random.seed(0)
        curve_id = CurveID(ids.curve_id)
        order = CURVES[curve_id.value].n
        points_g1 = [G1Point.gen_random_point(curve_id) for _ in range(ids.n)]

        points = flatten([(p.x, p.y) for p in points_g1])
        scalars = [random.randint(0, order) for _ in range(ids.n)]
        scalars_split = flatten([split_128(s) for s in scalars])

        fill_bigint_array_into_felt_ptr(points, memory, ids.points, ids.BASE, ids.N_LIMBS)
        fill_felt_ptr(scalars_split, memory, ids.scalars)

        Q = G1Point.msm(points_g1, scalars)
        fill_g1_point((Q.x, Q.y), ids.expected_msm_res)
    %}
    return (
        points=cast(points, G1Point*),
        scalars=cast(scalars, Uint256*),
        expected_msm_res=expected_msm_res,
    );
}
