from src.definitions import STARK, CurveID, CURVES, PyFelt, Curve
from random import randint
from src.extension_field_modulo_circuit import ExtensionFieldModuloCircuit
from src.precompiled_circuits.final_exp import FinalExpCircuit


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
    circuit = FinalExpCircuit(
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
    circuit = FinalExpCircuit(
        f"{curve_id.name}_mul_torus_amortized_Fp{extension_degree}",
        curve_id=curve_id.value,
        extension_degree=extension_degree,
    )
    circuit.create_powers_of_Z(PyFelt(2, STARK), mock=True)
    X = circuit.write_elements(X)
    circuit.mul_torus(X, X)
    return circuit.summarize()


if __name__ == "__main__":
    data = []
    for curveID in [CurveID.BLS12_381]:
        data.append(test_extf_mul_circuit_amortized(curveID, 6))
        data.append(test_extf_mul_circuit_full(curveID, 6))
        data.append(test_extf_mul_circuit_amortized(curveID, 12))
        data.append(test_extf_mul_circuit_full(curveID, 12))
        data.append(test_square_torus_amortized(curveID, 6))
        data.append(test_extf_square_amortized(curveID, 12))
        data.append(test_mul_torus_amortized(curveID, 6))

    import pandas as pd

    df = pd.DataFrame(data)

    costs = {"MULMOD": 8, "ADDMOD": 4, "POSEIDON": 7}  # , "ASSERT_EQ": 3}
    acc = pd.Series([0] * len(df))

    for column, multiplier in costs.items():
        tmp = df[column] * multiplier
        df[f"{column}_w"] = tmp
        acc += tmp

    df[f"Total with weights"] = acc

    print("\n\n")
    print(f"Weights: {costs}")
    print(df.sort_values(by="Total with weights"))
    print("\n")
