import random
from random import randint

from garaga.algebra import ModuloCircuitElement
from garaga.curves import CURVES, STARK, Curve, CurveID, PyFelt, get_base_field
from garaga.extension_field_modulo_circuit import ExtensionFieldModuloCircuit, WriteOps
from garaga.hints import neg_3
from garaga.hints.ecip import zk_ecip_hint
from garaga.hints.io import padd_function_felt, split_128
from garaga.hints.tower_backup import E12
from garaga.points import G1G2Pair, G1Point, G2Point, direct_to_tower
from garaga.precompiled_circuits.ec import BasicEC, DerivePointFromX, ECIPCircuits
from garaga.precompiled_circuits.final_exp import FinalExpTorusCircuit, test_final_exp
from garaga.precompiled_circuits.multi_miller_loop import MultiMillerLoopCircuit

random.seed(0)


def test_extf_mul(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    Y = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = ExtensionFieldModuloCircuit(
        f"Fp{extension_degree} MUL",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
        hash_input=False,
    )
    X = circuit.write_elements(X, WriteOps.INPUT)
    Y = circuit.write_elements(Y, WriteOps.INPUT)
    circuit.extf_mul([X, Y], extension_degree)
    circuit.finalize_circuit()
    return circuit.summarize(), circuit.ops_counter


def test_extf_square(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = ExtensionFieldModuloCircuit(
        f"Fp{extension_degree} SQUARE",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
        hash_input=False,
    )
    X = circuit.write_elements(X, WriteOps.INPUT)
    circuit.extf_mul([X, X], extension_degree)
    circuit.finalize_circuit()

    return circuit.summarize(), circuit.ops_counter


def test_extf_mul_circuit_full(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = ExtensionFieldModuloCircuit(
        f"{curve_id.name}_mul_zpow_verif_Fp{extension_degree}",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    X = circuit.write_elements(X, WriteOps.INPUT)
    circuit.extf_mul(X, X, extension_degree)
    circuit.finalize_circuit()
    circuit.values_segment = circuit.values_segment.non_interactive_transform()
    circuit.print_value_segment()
    return circuit.summarize(), circuit.ops_counter


def test_square_torus_amortized(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = FinalExpTorusCircuit(
        f"Fp{extension_degree} SQUARE_TORUS",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
        hash_input=False,
    )
    X = circuit.write_elements(X, WriteOps.INPUT)
    circuit.square_torus(X)
    circuit.finalize_circuit()
    return circuit.summarize(), circuit.ops_counter


def test_mul_torus(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    Y = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = FinalExpTorusCircuit(
        f"Fp{extension_degree} MUL_TORUS",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
        hash_input=False,
    )
    X = circuit.write_elements(X, WriteOps.INPUT)
    Y = circuit.write_elements(Y, WriteOps.INPUT)
    circuit.mul_torus(X, Y)
    circuit.finalize_circuit()
    return circuit.summarize(), circuit.ops_counter


def test_final_exp_circuit(curve_id: CurveID):
    part1, part2 = test_final_exp(curve_id)
    summ1 = part1.summarize()
    summ1["circuit"] = summ1["circuit"]
    summ2 = part2.summarize()
    summ2["circuit"] = summ2["circuit"]
    # part1.print_value_segment()
    # part1.compile_circuit()
    summ = {
        "circuit": summ1["circuit"],
        "MULMOD": summ1["MULMOD"] + summ2["MULMOD"],
        "ADDMOD": summ1["ADDMOD"] + summ2["ADDMOD"],
        "ASSERT_EQ": summ1["ASSERT_EQ"] + summ2["ASSERT_EQ"],
        "POSEIDON": summ1["POSEIDON"] + summ2["POSEIDON"],
        "RLC": summ1["RLC"] + summ2["RLC"],
    }
    ops_counter = {
        key: part1.ops_counter.get(key) + part2.ops_counter.get(key)
        for key in set(part1.ops_counter) | set(part2.ops_counter)
        if key != "Circuit"
    }
    ops_counter["Circuit"] = part1.ops_counter["Circuit"]
    return summ, ops_counter


def test_miller_n(curve_id, n):
    order = CURVES[curve_id.value].n
    field = get_base_field(curve_id.value)
    pair_list = []
    pairs = []
    for k in range(n):
        n1, n2 = randint(1, order), randint(1, order)
        p1, p2 = G1Point.get_nG(curve_id, n1), G2Point.get_nG(curve_id, n2)
        pair_list.append(G1G2Pair(p1, p2))
        pairs.extend([p1.x, p1.y, p2.x[0], p2.x[1], p2.y[0], p2.y[1]])

    c = MultiMillerLoopCircuit(f"Miller n={n} {curve_id.name}", curve_id.value, n)
    c.write_p_and_q_raw([field(x) for x in pairs])

    f = c.miller_loop(n_pairs=n)

    f_tower = E12(
        direct_to_tower([x.felt for x in f], curve_id.value, 12), curve_id.value
    )
    cofactor = CURVES[curve_id.value].final_exp_cofactor

    f = f_tower ** (
        cofactor * (CURVES[curve_id.value].p ** 12 - 1) // CURVES[curve_id.value].n
    )

    res = G1G2Pair.pair(pair_list).value_coeffs

    c.finalize_circuit()

    for i, (rg, fv) in enumerate(zip(res, f.value_coeffs)):
        assert rg == fv, f"Mismatch at index {i}: {rg=} != {fv=}, {curve_id} {n}"

    return c.summarize(), c.ops_counter


def test_derive_point_from_x(curve_id: CurveID):
    field = get_base_field(curve_id.value)
    c = DerivePointFromX(
        "Derive Point From X",
        curve_id.value,
    )
    x = c.write_element(field(randint(0, STARK - 1)))
    a = c.write_element(field(CURVES[curve_id.value].a))
    b = c.write_element(field(CURVES[curve_id.value].b))
    g = c.write_element(field(CURVES[curve_id.value].fp_generator))
    c._derive_point_from_x(x, a, b, g)
    return c.summarize(), None


def test_msm_n_points(curve_id: CurveID, n: int):
    order = CURVES[curve_id.value].n
    field = get_base_field(curve_id.value)
    points_g1 = [G1Point.get_nG(curve_id, i + 1) for i in range(n)]
    points_values = [(p.x, p.y) for p in points_g1]
    scalars = [randint(1, order) for _ in range(n)]
    scalars_split = [split_128(s) for s in scalars]
    scalars_low, scalars_high = zip(*scalars_split)

    circuit: ECIPCircuits = ECIPCircuits(f"MSM {n} points", curve_id.value)

    A0 = G1Point.gen_random_point(curve_id)
    # A0 = G1Point(
    #     18428833980079511615272996143804193211436754676692982772704777987001013940329,
    #     11912813278234620045155380611021998667623598196864500681264424672047345567217,
    #     curve_id,
    # )
    A0: tuple(ModuloCircuitElement, ModuloCircuitElement) = (
        circuit.write_element(field(A0.x)),
        circuit.write_element(field(A0.y)),
    )
    A_weirstrass = circuit.write_element(field(CURVES[curve_id.value].a))
    m_A0, b_A0, xA0, yA0, xA2, yA2, coeff0, coeff2 = (
        circuit._slope_intercept_same_point(A0, A_weirstrass)
    )
    points = [
        (circuit.write_element(field(x)), circuit.write_element(field(y)))
        for x, y in points_values
    ]

    def msm_inner(points, scalars):
        epns = [
            neg_3.positive_negative_multiplicities(neg_3.neg_3_base_le(s))
            for s in scalars
        ]

        first_B = points[0]
        if isinstance(first_B, G1Point):
            points_g1 = points
        elif isinstance(first_B, tuple):
            if isinstance(first_B[0], int):
                points_g1 = [G1Point(B[0], B[1], curve_id) for B in points]
            else:
                points_g1 = [G1Point(B[0].value, B[1].value, curve_id) for B in points]
        else:
            raise ValueError("Invalid Bs type")

        Q, SumDlog = zk_ecip_hint(points_g1, scalars)
        rhs_acc = circuit.write_element(field(0))
        for index, (point, epn) in enumerate(zip(points, epns)):
            # print(f"RHS INDEX : {index}")
            ep = circuit.write_element(field(abs(epn[0])))
            en = circuit.write_element(field(abs(epn[1])))
            p_sign = circuit.write_element(field(epn[0] // abs(epn[0])))
            n_sign = circuit.write_element(field(epn[1] // abs(epn[1])))
            rhs_acc = circuit._accumulate_eval_point_challenge_signed_same_point(
                rhs_acc, (m_A0, b_A0), xA0, point, ep, en, p_sign, n_sign
            )
            # print(f"\trhs_acc_intermediate: {rhs_acc.value}")
        Q = (Q.x, Q.y)
        if Q != (0, 0):
            Q = (circuit.write_element(field(Q[0])), circuit.write_element(field(Q[1])))
            rhs_acc = circuit._RHS_finalize_acc(rhs_acc, (m_A0, b_A0), xA0, Q)

        a_num, a_den, b_num, b_den = padd_function_felt(SumDlog, n)
        a_num, a_den, b_num, b_den = (
            circuit.write_elements([field(x) for x in a_num], WriteOps.INPUT),
            circuit.write_elements([field(x) for x in a_den], WriteOps.INPUT),
            circuit.write_elements([field(x) for x in b_num], WriteOps.INPUT),
            circuit.write_elements([field(x) for x in b_den], WriteOps.INPUT),
        )
        lhs = circuit._eval_function_challenge_dupl(
            (xA0, yA0), (xA2, yA2), coeff0, coeff2, a_num, a_den, b_num, b_den
        )

        assert lhs.value == rhs_acc.value, f"{lhs.value} != {rhs_acc.value}"

        if Q == (0, 0):
            return G1Point.infinity(curve_id)
        return G1Point(Q[0].value, Q[1].value, curve_id)
        # print(f"\tlhs: {lhs.value}")
        # print(f"\trhs_acc_final: {rhs_acc.value}")

    Q_low = msm_inner(points, scalars_low)
    Q_high = msm_inner(points, scalars_high)
    Q_shift = msm_inner(
        [
            (
                circuit.write_element(field(Q_high.x)),
                circuit.write_element(field(Q_high.y)),
            )
        ],
        [2**128],
    )

    scalar_mul_low = G1Point.msm(points_g1, scalars_low)
    scalar_mul_high = G1Point.msm(points_g1, scalars_high)
    scalar_mul = G1Point.msm(points_g1, scalars)

    assert Q_low == scalar_mul_low, f"{Q_low} != {scalar_mul_low}"
    assert Q_high == scalar_mul_high, f"{Q_high} != {scalar_mul_high}"
    assert Q_high.scalar_mul(2**128) == Q_shift

    assert Q_low.add(Q_shift) == scalar_mul

    basic_ec = BasicEC("Basic EC", curve_id.value)
    final_res = basic_ec.add_points(
        basic_ec.write_elements([field(Q_low.x), field(Q_low.y)], WriteOps.INPUT),
        basic_ec.write_elements([field(Q_shift.x), field(Q_shift.y)], WriteOps.INPUT),
    )
    assert G1Point(final_res[0].value, final_res[1].value, curve_id) == Q_low.add(
        Q_shift
    )
    ec_summary = basic_ec.summarize()
    circuit.values_segment = circuit.values_segment.non_interactive_transform()

    summary = circuit.summarize()
    summary["MULMOD"] = summary["MULMOD"] + ec_summary["MULMOD"]
    summary["ADDMOD"] = summary["ADDMOD"] + ec_summary["ADDMOD"]
    summary["POSEIDON"] = n * 2  # N points
    summary["POSEIDON"] += n * 2  # N scalars (spliited in low_high)
    summary["POSEIDON"] += 3 * 2  # 3 Q result points
    summary["POSEIDON"] += 2 * (4 * n + 10)  # 2 * Total # of coefficients in SumDlogDiv
    summary["POSEIDON"] += (
        4 + 10
    )  # Total # of coefficients in SumDlogDivShifted (1 point MSM)
    return summary, None


if __name__ == "__main__":
    import pandas as pd
    from tabulate import tabulate

    pd.set_option("display.max_rows", None)  # None means show all rows
    pd.set_option("display.max_columns", None)  # None means show all columns
    pd.set_option("display.width", None)  # None means auto-detect the display width
    pd.set_option("display.max_colwidth", None)  # None means show full width of columns

    builtin_ops_data = []
    builtin_ops_data.append(
        {
            "circuit": "BLS12FinalExp Fp12 Karabina No EXTF Trick",
            "MULMOD": 7774,
            "ADDMOD": 26038 + 16964,  # ADD + SUBS.
            "ASSERT_EQ": 0,
            "POSEIDON": 0,
            "RLC": 0,
        }
    )

    final_exp_data = {CurveID.BN254: None, CurveID.BLS12_381: None}
    sub_circuit_count = []
    # print(f"Running...")
    for curveID in [CurveID.BN254, CurveID.BLS12_381]:
        builtin_ops, sub_circuits = test_final_exp_circuit(curveID)
        builtin_ops_data.append(builtin_ops)
        final_exp_data[curveID] = builtin_ops
        sub_circuit_count.append(sub_circuits)

    # Sub circuits. Same values for both curves
    for test_func, curve_id, ext_degree in [
        (test_extf_square, CurveID.BLS12_381, 12),
        (test_mul_torus, CurveID.BLS12_381, 6),
        (test_square_torus_amortized, CurveID.BLS12_381, 6),
        (test_extf_mul, CurveID.BLS12_381, 12),
    ]:
        builtin_ops, _ = test_func(curve_id, ext_degree)
        builtin_ops_data.append(builtin_ops)

    for test_func, curve_id in [
        (test_derive_point_from_x, CurveID.BN254),
    ]:
        builtin_ops, _ = test_func(curve_id)
        builtin_ops_data.append(builtin_ops)

    for n in [1, 2, 3]:
        for curve_id in [CurveID.BLS12_381, CurveID.BN254]:

            # print(f"Running {curve_id} {n}")
            builtin_ops, sub_circuits = test_miller_n(curve_id, n)
            builtin_ops_data.append(builtin_ops)
            builtin_ops_data.append(
                {
                    "circuit": f"MultiPairing {n=} {curve_id.name}",
                    "MULMOD": builtin_ops["MULMOD"]
                    + final_exp_data[curve_id]["MULMOD"],
                    "ADDMOD": builtin_ops["ADDMOD"]
                    + final_exp_data[curve_id]["ADDMOD"],
                    "ASSERT_EQ": builtin_ops["ASSERT_EQ"]
                    + final_exp_data[curve_id]["ASSERT_EQ"],
                    "POSEIDON": builtin_ops["POSEIDON"]
                    + final_exp_data[curve_id]["POSEIDON"],
                    "RLC": builtin_ops["RLC"] + final_exp_data[curve_id]["RLC"],
                }
            )
            sub_circuit_count.append(sub_circuits)

    for n in [1, 2, 3, 10, 50]:
        builtin_ops, _ = test_msm_n_points(CurveID.BN254, n)
        builtin_ops_data.append(builtin_ops)

    df = pd.DataFrame(builtin_ops_data)

    costs = [
        {
            "OP": "MULMOD",
            "Weight in steps": 8,
            "Comment": "Equivalent cost of a*b % p with the modulo builtin in VM steps",
        },
        {
            "OP": "ADDMOD",
            "Weight in steps": 4,
            "Comment": "Equivalent cost of a+b % p with the modulo builtin in VM steps",
        },
        {
            "OP": "ASSERT_EQ",
            "Weight in steps": 2,
            "Comment": "Equivalent cost of a==b % p with the modulo builtin in VM steps",
        },
        {
            "OP": "POSEIDON",
            "Weight in steps": 16,
            "Comment": "Cost of hashing the first 3 limbs of 384 bits emulated field element with Poseidon",
        },
        {
            "OP": "RLC",
            "Weight in steps": 28,
            "Comment": "Cost of writing a field element to the value segment and retrieving random coefficients",
        },
    ]

    def get_poseidon_cost(curve_name: CurveID) -> int:
        poseidon_costs = {
            CurveID.BN254: 14,
            CurveID.BLS12_381: 17,
        }
        return poseidon_costs.get(curve_name, 0)  # Default to 0 if curve_name not found

    def calculate_row_cost(row):
        total_cost = 0
        for _row in costs:
            op, weight = _row["OP"], _row["Weight in steps"]
            if "POSEIDON" in op:
                # Dynamically adjust Poseidon cost based on the 'circuit' column
                for curve_id in CurveID:
                    if curve_id.name in row["circuit"]:
                        weight = get_poseidon_cost(curve_id)
                        break  # Stop checking once the first matching CurveID is found
            total_cost += row[op] * weight
        return total_cost

    # Apply the function to each row to calculate the total cost
    df["~steps"] = df.apply(calculate_row_cost, axis=1)

    pd.set_option("display.colheader_justify", "center")
    print("\n\n")

    costs = [cost for cost in costs if cost["OP"] != "POSEIDON"]
    costs.extend(
        [
            {
                "OP": "POSEIDON 4 LIMBS",
                "Weight in steps": 17,
                "Comment": "Cost of hashing the 4 limbs of 384 bits emulated field element with Poseidon",
            },
        ]
    )

    df_costs = pd.DataFrame(costs)

    print(tabulate(df_costs, headers="keys", tablefmt="github", showindex=False))
    print("\n")
    df.sort_values(by="~steps", inplace=True)
    print(
        tabulate(
            df,
            headers="keys",
            tablefmt="github",
            showindex=False,
            floatfmt=".2f",
        )
    )

    df_sub_circuits = (
        pd.DataFrame(sub_circuit_count)
        .set_index("Circuit")
        .fillna(0)
        .astype(int)
        .transpose()
    )

    # print("\n")
    # print(
    #     tabulate(
    #         df_sub_circuits,
    #         headers="keys",
    #         tablefmt="github",
    #         showindex=True,
    #     )
    # )
    # print("\n")
