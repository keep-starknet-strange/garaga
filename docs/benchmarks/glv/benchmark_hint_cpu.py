import argparse
import hashlib
import json
import platform
import random
import statistics
import subprocess
import time
from pathlib import Path

from garaga import garaga_rs
from garaga.curves import CURVES, CurveID
from garaga.points import G1Point
from garaga.starknet.tests_and_calldata_generators.msm import MSMCalldataBuilder

parser = argparse.ArgumentParser()
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
workspace = Path.cwd()
repeats = 5
results = []
for curve_id in CurveID:
    curve = CURVES[curve_id.value]
    rng = random.Random(42)
    inputs = [
        (G1Point.get_nG(curve_id, 1).scalar_mul(i + 1), rng.randrange(2, curve.n - 2))
        for i in range(20)
    ]
    for use_rust in (False, True):
        samples = []
        for index, (point, scalar) in enumerate(inputs):
            builder = MSMCalldataBuilder(
                curve_id=curve_id, points=[point], scalars=[scalar]
            )
            builder.build_msm_hint.cache_clear()
            builder.serialize_to_calldata(use_rust=use_rust)
            elapsed = []
            cpu_elapsed = []
            for repeat in range(repeats):
                builder.build_msm_hint.cache_clear()
                cpu_start = time.process_time_ns()
                start = time.perf_counter_ns()
                calldata = builder.serialize_to_calldata(use_rust=use_rust)
                elapsed.append(time.perf_counter_ns() - start)
                cpu_elapsed.append(time.process_time_ns() - cpu_start)
            samples.append(
                {
                    "sample": index,
                    "scalar": hex(scalar),
                    "elapsed_ns": elapsed,
                    "median_ns": statistics.median(elapsed),
                    "cpu_elapsed_ns": cpu_elapsed,
                    "cpu_median_ns": statistics.median(cpu_elapsed),
                    "calldata_felts": len(calldata),
                }
            )
        row = {
            "curve": curve_id.name,
            "backend": "rust" if use_rust else "python",
            "median_ns": statistics.median(s["median_ns"] for s in samples),
            "median_cpu_ns": statistics.median(s["cpu_median_ns"] for s in samples),
            "samples": samples,
        }
        results.append(row)
        print(
            f"{row['curve']} {row['backend']}: wall {row['median_ns'] / 1e6:.3f} ms, CPU {row['median_cpu_ns'] / 1e6:.3f} ms",
            flush=True,
        )
source_paths = [
    workspace / "hydra/garaga/hints/fake_glv.py",
    workspace / "tools/garaga_rs/src/hints/fake_glv.rs",
    workspace / "hydra/garaga/starknet/tests_and_calldata_generators/msm.py",
    workspace / "tools/garaga_rs/src/calldata/msm_calldata.rs",
]
meta = {
    "revision": subprocess.check_output(
        ["git", "rev-parse", "HEAD"], text=True
    ).strip(),
    "working_directory": str(workspace),
    "python": platform.python_version(),
    "platform": platform.platform(),
    "extension": str(garaga_rs.__file__),
    "extension_sha256": hashlib.sha256(
        Path(garaga_rs.__file__).read_bytes()
    ).hexdigest(),
    "source_sha256": {
        str(p.relative_to(workspace)): hashlib.sha256(p.read_bytes()).hexdigest()
        for p in source_paths
    },
    "description": "Uncached one-point MSM calldata production on 20 seeded full-width scalars per curve and subgroup points (i+1)G; Python includes typed serialization and Rust includes FFI+serialization. Five repeats per input; one untimed warmup per input/backend. Cached hint data is cleared outside timing. Median is the median of per-input medians.",
    "rust_profile": "release opt-level=3 with debug symbols (CARGO_PROFILE_RELEASE_DEBUG=1), Rust 1.97.0",
    "results": results,
}
args.output.write_text(json.dumps(meta, indent=2) + "\n")
