from src.definitions import STARK, CurveID, CURVES, PyFelt, Curve
from random import randint
from src.extension_field_modulo_circuit import ExtensionFieldModuloCircuit
from src.precompiled_circuits.final_exp import FinalExpTorusCircuit, test_final_exp


def test_extf_mul_circuit_amortized(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = ExtensionFieldModuloCircuit(
        f"{curve_id.name}_mul_amortized_Fp{extension_degree}",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    X = circuit.write_elements(X)
    circuit.extf_mul(X, X, extension_degree)
    return circuit.summarize()


def test_extf_square_amortized(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = ExtensionFieldModuloCircuit(
        f"{curve_id.name}_square_amortized_Fp{extension_degree}",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    X = circuit.write_elements(X)
    circuit.extf_square(X, extension_degree)
    return circuit.summarize()


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
    return circuit.summarize()


def test_square_torus_amortized(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = FinalExpTorusCircuit(
        f"{curve_id.name}_square_torus_amortized_Fp{extension_degree}",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    X = circuit.write_elements(X)
    circuit.square_torus(X)
    return circuit.summarize()


def test_mul_torus_amortized(curve_id: CurveID, extension_degree: int):
    curve: Curve = CURVES[curve_id.value]
    p = curve.p
    X = [PyFelt(randint(0, p - 1), p) for _ in range(extension_degree)]
    circuit = FinalExpTorusCircuit(
        f"{curve_id.name}_mul_torus_amortized_Fp{extension_degree}",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    X = circuit.write_elements(X)
    circuit.mul_torus(X, X)
    return circuit.summarize()


def test_final_exp_circuit(curve_id: CurveID):
    part1, part2 = test_final_exp(curve_id)
    summ1 = part1.summarize()
    summ1["circuit"] = summ1["circuit"]
    summ2 = part2.summarize()
    summ2["circuit"] = summ2["circuit"]
    part1.print_value_segment()
    part1.compile_circuit()
    summ = {
        "circuit": summ1["circuit"],
        "MULMOD": summ1["MULMOD"] + summ2["MULMOD"],
        "ADDMOD": summ1["ADDMOD"] + summ2["ADDMOD"],
        "POSEIDON": summ1["POSEIDON"] + summ2["POSEIDON"],
    }
    return summ


if __name__ == "__main__":
    data = []
    data.append(
        {
            "circuit": "BLS12FinalExp Fp12 Karabina No EXTF Trick",
            "MULMOD": 7774,
            "ADDMOD": 26038 + 16964,  # ADD + SUBS.
            "POSEIDON": 0,
        }
    )
    for curveID in [CurveID.BN254, CurveID.BLS12_381]:
        # data.append(test_extf_mul_circuit_amortized(curveID, 6))
        # data.append(test_extf_mul_circuit_full(curveID, 6))
        # data.append(test_extf_mul_circuit_amortized(curveID, 12))
        # data.append(test_extf_mul_circuit_full(curveID, 12))
        # data.append(test_square_torus_amortized(curveID, 6))
        # data.append(test_extf_square_amortized(curveID, 12))
        # data.append(test_mul_torus_amortized(curveID, 6))
        data.append(test_final_exp_circuit(curveID))

    import pandas as pd
    from tabulate import tabulate

    df = pd.DataFrame(data)

    costs = {"MULMOD": 8, "ADDMOD": 4, "POSEIDON": 7}  # , "ASSERT_EQ": 3}
    acc = pd.Series([0] * len(df))

    for column, multiplier in costs.items():
        acc += df[column] * multiplier

    # Calculate percentages based on total weights without adding _w columns and ensure rounding is correct
    # for column in costs.keys():
    #     df[f"{column}_%"] = ((df[column] * costs[column] / acc) * 100).round(2)
    pd.set_option("display.colheader_justify", "center")
    df["~steps"] = acc
    print("\n\n")
    print(f"Weights: {costs}")

    df.sort_values(by="~steps", inplace=True)
    print(
        tabulate(
            df,
            headers="keys",
            tablefmt="psql",
            showindex=False,
            floatfmt=".2f",
        )
    )
