import inspect

import pandas as pd
from tabulate import tabulate

from garaga.curves import CurveID
from hydra.garaga.precompiled_circuits.all_circuits import ALL_CAIRO_CIRCUITS


def benchmark_all_cairo_circuits():
    """
    For each circuit class in ALL_CAIRO_CIRCUITS:
      - Instantiate the circuit (with any params, for each listed curve_id).
      - Safe-construct them by removing any kwargs that aren't accepted by their __init__.
      - finalize the circuit (if not already done).
      - gather the summary info (MULMOD, ADDMOD, etc.).
    Then we mark circuits as "GENERIC" if they have the same MULMOD/ADDMOD on multiple curves.
    """

    results = []

    for circuit_id, circuit_info in ALL_CAIRO_CIRCUITS.items():
        # If no curve_ids present, default to [BN254, BLS12_381]
        curve_ids = circuit_info.get("curve_ids", [CurveID.BN254, CurveID.BLS12_381])
        # If params is None, turn that into a list of length 1 containing None
        params_list = circuit_info["params"] or [None]
        circuit_class = circuit_info["class"]

        # Use inspect to see valid parameters on the circuit class's __init__
        init_signature = inspect.signature(circuit_class.__init__)
        valid_params = set(init_signature.parameters.keys())

        for curve_id in curve_ids:
            for param in params_list:
                # Build default kwargs
                kwargs = {
                    "name": f"{circuit_class.__name__}_bench",
                    "curve_id": curve_id.value,
                    "auto_run": True,
                    "compilation_mode": 1,
                }

                # Possibly update with param dict
                if isinstance(param, dict):
                    kwargs.update(param)

                # Remove any keys the constructor doesn't accept
                safe_kwargs = {k: v for k, v in kwargs.items() if k in valid_params}

                # Now instantiate the circuit safely
                circuit_instance = circuit_class(**safe_kwargs)

                # Summarize
                summary = circuit_instance.circuit.summarize()

                # Build row for DataFrame, including separate columns for the class, param, curve
                row = {
                    "circuit_class": circuit_class.__name__,
                    "param": str(param) if param else "",
                    "curve_id": curve_id.name,
                    "MULMOD": summary.get("MULMOD", 0),
                    "ADDMOD": summary.get("ADDMOD", 0),
                }
                results.append(row)

    # Create a DataFrame
    df = pd.DataFrame(results)

    # If you want to compute a simple "~steps" metric:
    costs = {"MULMOD": 8, "ADDMOD": 4}

    def compute_steps(row):
        return sum(row[op] * wt for op, wt in costs.items())

    df["~steps"] = df.apply(compute_steps, axis=1)

    # Sort by ~steps first
    df.sort_values(by="~steps", inplace=True, ignore_index=True)

    # 1) Group by (circuit_class, param, MULMOD, ADDMOD).
    # 2) If multiple distinct curves appear in a group, mark curve_id as "GENERIC".
    df["curve_id"] = df.groupby(["circuit_class", "param", "MULMOD", "ADDMOD"])[
        "curve_id"
    ].transform(lambda g: "GENERIC" if g.nunique() > 1 else g)

    # Drop duplicates, so "GENERIC" appears only once per group
    df_unique = df.drop_duplicates(
        subset=["circuit_class", "param", "MULMOD", "ADDMOD", "curve_id"], keep="first"
    )

    print("\n===== Benchmark Summaries (Filtered) =====\n")
    print(tabulate(df_unique, headers="keys", tablefmt="github", showindex=False))


if __name__ == "__main__":
    benchmark_all_cairo_circuits()
