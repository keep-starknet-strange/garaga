# Barretenberg v6 Cairo measurements

The new verifier reduces Sierra gas by 36.01% and steps by 46.86% on the stored `hello` example.
The final bytecode is 64,379 felts, compared with 63,663 on `main` (+1.12%).
The first v6 implementation exceeded the bytecode limit at 87,243 felts.

The [before/after explanation](BEFORE_AFTER.md) attributes the step reductions and gives the mathematical equations.

## Measurement scope

- Steps: 1,220,719 → 648,642 (-46.86%).
- Sierra gas: 221,002,260 → 141,418,616 (-36.01%).
- CASM bytecode: 63,663 → 64,379 felts (+1.12%).

The baseline is commit `0509ebfb7966d03da8135b21287372d74214071e`.
Both measurements use Scarb 2.21.0, Starknet Foundry 0.64.1, and cairo-profiler 0.17.0.
The baseline uses the committed Barretenberg v3 receipt. The final version uses the v6 receipt for the same Noir statement.
The receipt formats differ, so they cannot use the same proof bytes.
Each optimization experiment used the same v6 receipt, key, and public input.
The JSON files record their hashes and the compiler manifests.

These numbers cover the Foundry library-dispatch test, including ECIP and the test harness.
They are resource measurements, rather than live transaction fees.
`cairo-steps` and `sierra-gas` are separate test runs.
The general README table uses the profiler's weighted Sierra gas estimate; this report uses Foundry's actual Sierra gas accounting.

## Retained optimizations

The main MSM and recursive aggregation share one non-inlined scalar multiplication function.
This avoids duplicating the GLV implementation at three call sites.
The generated MSM removes constant identity commitments and their scalars and hints.

A verifier specialized to its trusted key omits inactive relation families.
It first rejects nonzero evaluations for every identity commitment.
Randomized tests compare all 31 relations against the generic implementation.
An opt-in compiler pass removes unused gates, constants, and circuit inputs while retaining function signatures.
Other proof systems retain the existing compiler behavior.

BN254 hint coordinates use `u256`, reducing each scalar multiplication hint from 12 to 8 felts.
The two recursive multiplication hints use 16 felts instead of 24.
These changes affect calldata hints, without changing the stored Barretenberg proof.

The Noir generator uses an inlining threshold of 50.
Compared with threshold 2, this saves gas and bytecode: 191,988,316 → 141,418,616 gas and 65,818 → 64,379 felts.
Threshold 75 uses 133,101,006 gas and 67,594 felts.
Threshold 100 uses 132,756,926 gas and 68,059 felts.
The default compiler setting uses 131,835,846 gas and 70,431 felts.
Threshold 50 retains the more compact result; the alternatives cost another 3,215–7,458 felts.
The full experiment records are in [optimization-variants.json](optimization-variants.json).

The maximum-size build uses `log_n = 25`, four user public inputs, and nonzero commitments for every relation family.
It compiles to **70,020 felts**, below the repository's conservative 81,290-felt ceiling.
This is a synthetic capacity key without a corresponding proof.
Real `hello`, ROM/RAM, recursive, and MMR receipts are tested separately.

## Profiles and reproduction

The named profiles preserve both production CASM bytecode and the full test step count.
The benchmark command checks these equalities before it accepts a named profile.
The profiler excludes some test harness frames, so its totals differ from the complete Foundry test counts.
Scalar multiplication remains the largest cost: 63.42% of profiled steps in the final version.

- [Before measurement](before.json) and [after measurement](after.json).
- [Before function profile](before-named-profile-steps.txt) and [after function profile](after-named-profile-steps.txt).
- The corresponding compressed profiles can be opened with `cairo-profiler view`.

```bash
PYTHONPATH=hydra uv run tools/benchmark_noir.py --output /tmp/noir-after.json --named-profile
make check-max-log-n
make -C tools/noir check
```

The pinned tools must be in `PATH`. `tools/noir/install.py` installs the checksum-pinned Noir and Barretenberg binaries.
The normal CI compiles sources, rebuilds keys, and verifies stored proofs. It does not generate proofs.
