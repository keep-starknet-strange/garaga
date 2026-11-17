import inspect
from collections import defaultdict

from garaga.curves import CurveID
from tabulate import tabulate

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

    curves_by_cost = defaultdict(set)

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

                cost = (
                    circuit_class.__name__,
                    str(param) if param else "",
                    summary.get("MULMOD", 0),
                    summary.get("ADDMOD", 0),
                )
                curves_by_cost[cost].add(curve_id.name)

    results = [
        {
            "circuit_class": name,
            "param": param,
            "curve_id": "GENERIC" if len(curves) > 1 else next(iter(curves)),
            "MULMOD": mulmod,
            "ADDMOD": addmod,
            "~steps": 8 * mulmod + 4 * addmod,
        }
        for (name, param, mulmod, addmod), curves in curves_by_cost.items()
    ]
    results.sort(key=lambda row: row["~steps"])

    print("\n===== Benchmark Summaries (Filtered) =====\n")
    print(tabulate(results, headers="keys", tablefmt="github"))


if __name__ == "__main__":
    benchmark_all_cairo_circuits()
