from src.definitions import CurveID, CURVES
from tools.make.utils import create_directory
import json
import random

INPUTS_DIR = "build/program_inputs"
create_directory(INPUTS_DIR)


def generate_input_file(n: int, curve_id: int, n1s: list[int], n2s: list[int]) -> str:
    """
    Generates an input file and returns its path.
    """
    file_path = f"{INPUTS_DIR}/test_pairing_input_{curve_id.name}_{n}_pairs.json"
    with open(file_path, "w") as f:
        json.dump(
            {"n_pairs": n, "curve_id": curve_id.value, "n1s": n1s, "n2s": n2s},
            f,
            indent=4,
        )
    return file_path


def main():
    # Generate input files
    curve_ids = [CurveID.BN254, CurveID.BLS12_381]
    for n in [1, 2, 3]:
        for curve_id in curve_ids:
            order = CURVES[curve_id.value].n
            n1s = [random.randint(1, order) for _ in range(n)]
            n2s = [random.randint(1, order) for _ in range(n)]
            generate_input_file(n, curve_id, n1s, n2s)
    print("Input files generated successfully.")


if __name__ == "__main__":
    main()
