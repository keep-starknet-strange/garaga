from src.definitions import (
    STARK,
    CurveID,
    CURVES,
    PyFelt,
    Curve,
    Polynomial,
    get_base_field,
    get_irreducible_poly,
    tower_to_direct,
    direct_to_tower,
    precompute_lineline_sparsity,
)
from random import randint
from src.extension_field_modulo_circuit import ExtensionFieldModuloCircuit, WriteOps
from src.precompiled_circuits.final_exp import FinalExpTorusCircuit, test_final_exp
from src.precompiled_circuits.multi_miller_loop import MultiMillerLoopCircuit
from tools.gnark import GnarkCLI
from src.hints.tower_backup import E12


def test_extf_mul(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = ExtensionFieldModuloCircuit(
        f"Fp{extension_degree} MUL",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    X = circuit.write_elements(X)
    circuit.extf_mul(X, X, extension_degree)
    return circuit.summarize(), circuit.ops_counter


def test_extf_square(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = ExtensionFieldModuloCircuit(
        f"Fp{extension_degree} SQUARE",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    X = circuit.write_elements(X)
    circuit.extf_square(X, extension_degree)
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
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=False)
    X = circuit.write_elements(X)
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
    )
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    X = circuit.write_elements(X)
    circuit.square_torus(X)
    return circuit.summarize(), circuit.ops_counter


def test_mul_torus(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = FinalExpTorusCircuit(
        f"Fp{extension_degree} MUL_TORUS",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    X = circuit.write_elements(X)
    circuit.mul_torus(X, X)
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
    }
    ops_counter = {
        key: part1.ops_counter.get(key) + part2.ops_counter.get(key)
        for key in set(part1.ops_counter) | set(part2.ops_counter)
        if key != "Circuit"
    }
    ops_counter["Circuit"] = part1.ops_counter["Circuit"]
    return summ, ops_counter


def test_finalize_circuit(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    finalize_circuit = ExtensionFieldModuloCircuit(
        f"Finalize_Circuit_{extension_degree}",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    field = finalize_circuit.field
    finalize_circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    finalize_circuit.acc.xy = finalize_circuit.write_element(field(0), WriteOps.INPUT)
    finalize_circuit.acc.R = finalize_circuit.write_elements(
        [field(0)] * extension_degree, WriteOps.INPUT
    )
    finalize_circuit.finalize_circuit()
    finalize_circuit.values_segment = (
        finalize_circuit.values_segment.non_interactive_transform()
    )
    # finalize_circuit.print_value_segment()
    # print(finalize_circuit.compile_circuit())
    return finalize_circuit.summarize(), finalize_circuit.ops_counter


def test_double_step(curve_id):
    cli = GnarkCLI(curve_id)
    field = get_base_field(curve_id.value)
    p, q = cli.nG1nG2_operation(1, 1)
    c = MultiMillerLoopCircuit(
        f"Double Step {curve_id.name}",
        curve_id.value,
        [(field(p.x), field(p.y))],
        [((field(q.x[0]), field(q.x[1])), (field(q.y[0]), field(q.y[1])))],
        1,
    )
    c.double_step(c.Q[0], 0)
    return c.summarize(), c.ops_counter


def test_double_and_add_step(curve_id):
    cli = GnarkCLI(curve_id)
    field = get_base_field(curve_id.value)
    p, q = cli.nG1nG2_operation(1, 1)
    _, s = cli.nG1nG2_operation(3, 3)
    c = MultiMillerLoopCircuit(
        f"Double-and-Add Step {curve_id.name}",
        curve_id.value,
        [(field(p.x), field(p.y))],
        [((field(q.x[0]), field(q.x[1])), (field(q.y[0]), field(q.y[1])))],
        1,
    )
    c.double_and_add_step(
        c.Q[0],
        (
            c.write_elements([field(s.x[0]), field(s.x[1])]),
            c.write_elements([field(s.y[0]), field(s.y[1])]),
        ),
        0,
    )
    return c.summarize(), c.ops_counter


def test_triple_step(curve_id):
    cli = GnarkCLI(curve_id)
    field = get_base_field(curve_id.value)
    p, q = cli.nG1nG2_operation(1, 1)
    c = MultiMillerLoopCircuit(
        "Triple Step",
        curve_id.value,
        [(field(p.x), field(p.y))],
        [((field(q.x[0]), field(q.x[1])), (field(q.y[0]), field(q.y[1])))],
        1,
    )
    c.triple_step(c.Q[0], 0)
    return c.summarize(), c.ops_counter


def test_mul_l_by_l(curve_id: CurveID):
    field = get_base_field(curve_id.value)
    c = ExtensionFieldModuloCircuit(
        "Mul L by L",
        curve_id=curve_id.value,
        extension_degree=12,
    )
    c.create_powers_of_Z(field(2), mock=True)
    line_line_sparsity = precompute_lineline_sparsity(curve_id.value)
    line_sparsity = CURVES[curve_id.value].line_function_sparsity
    line = c.write_elements([field(x) for x in line_sparsity])
    c.extf_mul(
        line,
        line,
        12,
        x_sparsity=line_sparsity,
        y_sparsity=line_sparsity,
        r_sparsity=line_line_sparsity,
    )
    return c.summarize(), c.ops_counter


def test_mul_ll_by_ll(curve_id: CurveID):
    field = get_base_field(curve_id.value)
    c = ExtensionFieldModuloCircuit(
        "Mul LL by LL",
        curve_id=curve_id.value,
        extension_degree=12,
    )
    c.create_powers_of_Z(field(2), mock=True)
    line_line_sparsity = precompute_lineline_sparsity(curve_id.value)
    line = c.write_elements([field(x) for x in line_line_sparsity])
    c.extf_mul(
        line,
        line,
        12,
        x_sparsity=line_line_sparsity,
        y_sparsity=line_line_sparsity,
    )
    return c.summarize(), c.ops_counter


def test_mul_ll_by_l(curve_id: CurveID):
    field = get_base_field(curve_id.value)
    c = ExtensionFieldModuloCircuit(
        "Mul LL by L",
        curve_id=curve_id.value,
        extension_degree=12,
    )
    c.create_powers_of_Z(field(2), mock=True)
    line_line_sparsity = precompute_lineline_sparsity(curve_id.value)
    line_sparsity = CURVES[curve_id.value].line_function_sparsity
    ll = c.write_elements([field(x) for x in line_line_sparsity])
    l = c.write_elements([field(x) for x in line_sparsity])
    c.extf_mul(
        ll,
        l,
        12,
        x_sparsity=line_line_sparsity,
        y_sparsity=line_sparsity,
    )
    return c.summarize(), c.ops_counter


def test_mul_by_l(curve_id: CurveID):
    field = get_base_field(curve_id.value)
    c = ExtensionFieldModuloCircuit(
        "Mul by L",
        curve_id=curve_id.value,
        extension_degree=12,
    )
    c.create_powers_of_Z(field(2), mock=True)
    line_sparsity = CURVES[curve_id.value].line_function_sparsity
    line = c.write_elements([field(x) for x in line_sparsity])
    c.extf_mul(
        line,
        line,
        12,
        y_sparsity=line_sparsity,
    )
    return c.summarize(), c.ops_counter


def test_mul_by_ll(curve_id: CurveID):
    field = get_base_field(curve_id.value)
    c = ExtensionFieldModuloCircuit(
        "Mul by LL",
        curve_id=curve_id.value,
        extension_degree=12,
    )
    c.create_powers_of_Z(field(2), mock=True)
    line_line_sparsity = precompute_lineline_sparsity(curve_id.value)
    line = c.write_elements([field(x) for x in line_line_sparsity])
    c.extf_mul(
        line,
        line,
        12,
        y_sparsity=line_line_sparsity,
    )
    return c.summarize(), c.ops_counter


def test_miller_n(curve_id, n):
    cli = GnarkCLI(curve_id)
    order = CURVES[curve_id.value].n
    field = get_base_field(curve_id.value)
    pairs = []
    for _ in range(n):
        n1, n2 = randint(1, order), randint(1, order)
        pairs.append(cli.nG1nG2_operation(n1, n2))

    g1_points = [(field(p.x), field(p.y)) for p, _ in pairs]
    g2_points = [
        ((field(q.x[0]), field(q.x[1])), (field(q.y[0]), field(q.y[1])))
        for _, q in pairs
    ]

    c = MultiMillerLoopCircuit(
        f"Miller n={n} {curve_id.name}", curve_id.value, g1_points, g2_points, n
    )
    c.create_powers_of_Z(field(2))
    if n == 1:
        f = c.miller_loop(k=1, lines=None)
    elif n == 2:
        lines = c.compute_double_pair_lines(0, 1)
        f = c.miller_loop(2, lines)
    elif n == 3:
        lines = c.compute_double_pair_lines(0, 1)
        lines = c.accumulate_single_pair_lines(lines, 2)
        f = c.miller_loop(3, lines)
    else:
        raise NotImplementedError

    f_tower = E12(
        direct_to_tower([x.felt for x in f], curve_id.value, 12), curve_id.value
    )
    cofactor = CURVES[curve_id.value].final_exp_cofactor

    f = f_tower ** (
        cofactor * (CURVES[curve_id.value].p ** 12 - 1) // CURVES[curve_id.value].n
    )

    res_gnark = cli.pair(P=[x[0] for x in pairs], Q=[x[1] for x in pairs])

    c.finalize_circuit()

    for i, (rg, fv) in enumerate(zip(res_gnark, f.value_coeffs)):
        assert rg == fv, f"Mismatch at index {i}: {rg=} != {fv=}, {curve_id} {n}"

    return c.summarize(), c.ops_counter


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
        }
    )
    sub_circuit_count = []
    print(f"Running...")
    for curveID in [CurveID.BN254, CurveID.BLS12_381]:
        builtin_ops, sub_circuits = test_final_exp_circuit(curveID)
        builtin_ops_data.append(builtin_ops)
        sub_circuit_count.append(sub_circuits)

    # Sub circuits. Same values for both curves
    for test_func, curve_id, ext_degree in [
        (test_finalize_circuit, CurveID.BLS12_381, 12),
        (test_finalize_circuit, CurveID.BLS12_381, 6),
        (test_extf_square, CurveID.BLS12_381, 12),
        (test_mul_torus, CurveID.BLS12_381, 6),
        (test_square_torus_amortized, CurveID.BLS12_381, 6),
        (test_extf_mul, CurveID.BLS12_381, 12),
    ]:
        builtin_ops, _ = test_func(curve_id, ext_degree)
        builtin_ops_data.append(builtin_ops)

    for test_func, curve_id in [
        (test_double_step, CurveID.BLS12_381),
        (test_double_and_add_step, CurveID.BLS12_381),
        (test_double_step, CurveID.BN254),
        (test_double_and_add_step, CurveID.BN254),
        (test_triple_step, CurveID.BLS12_381),
        (test_mul_l_by_l, CurveID.BLS12_381),
        (test_mul_ll_by_ll, CurveID.BLS12_381),
        (test_mul_ll_by_l, CurveID.BLS12_381),
        (test_mul_by_l, CurveID.BLS12_381),
        (test_mul_by_ll, CurveID.BLS12_381),
    ]:
        builtin_ops, _ = test_func(curve_id)
        builtin_ops_data.append(builtin_ops)

    for n in [1, 2, 3]:
        for curve_id in [CurveID.BLS12_381, CurveID.BN254]:

            print(f"Running {curve_id} {n}")
            builtin_ops, sub_circuits = test_miller_n(curve_id, n)
            builtin_ops_data.append(builtin_ops)
            sub_circuit_count.append(sub_circuits)

    df = pd.DataFrame(builtin_ops_data)

    costs = {
        "MULMOD": 8,
        "ADDMOD": 4,
        "ASSERT_EQ": 2,
        "POSEIDON": 7,
    }
    acc = pd.Series([0] * len(df))

    for column, multiplier in costs.items():
        acc += df[column] * multiplier

    pd.set_option("display.colheader_justify", "center")
    df["~steps"] = acc
    print("\n\n")
    print(f"Weights: {costs}")

    df.sort_values(by="~steps", inplace=True)
    print(
        tabulate(
            df,
            headers="keys",
            tablefmt="grid",
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

    print(
        tabulate(
            df_sub_circuits,
            headers="keys",
            tablefmt="simple_grid",
            showindex=True,
        )
    )
    print("\n")
