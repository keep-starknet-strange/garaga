---
name: benchmarking-cairo
description: Use when profiling Cairo functions, measuring step counts, analyzing resource usage, generating call-graph PNGs, or launching pprof to visualize Cairo execution traces
---

# Benchmarking Cairo

## Overview

Profile Cairo function execution to identify hotspots by steps, calls, range checks, and other builtins. Works with both `scarb execute` (standalone programs) and `snforge test` (Starknet Foundry tests).

If tools are missing, see `installation.md` in this skill directory. The CLI script is `profile.py` in this skill directory.

## REQUIRED: Use the CLI

**Always use `python3 profile.py profile` (from this skill directory) for profiling.** Do NOT run snforge/cairo-profiler/pprof manually — the CLI handles the full pipeline deterministically (trace generation, profile building, PNG export, naming).

### snforge mode (test functions)

```bash
python3 profile.py profile \
  --mode snforge \
  --package falcon \
  --test test_ntt_zknox_vs_felt252 \
  --name ntt-zknox-reduced \
  --metric steps
```

### scarb mode (standalone executables)

```bash
python3 profile.py profile \
  --mode scarb \
  --package falcon \
  --executable bench_ntt \
  --args-file tests/data/ntt_input_512.json \
  --name ntt-felt252 \
  --metric steps
```

### CLI arguments

| Argument | Required | Description |
|----------|----------|-------------|
| `--mode` | yes | `snforge` or `scarb` |
| `--package` | yes | Scarb package name (e.g. `falcon`) |
| `--name` | yes | Human-friendly profile label (e.g. `ntt-zknox-reduced`) |
| `--test` | snforge | Test filter passed to `snforge test` |
| `--executable` | scarb | Executable name for `scarb execute` |
| `--args-file` | no | Arguments file for `scarb execute` |
| `--metric` | no | `steps` (default), `rc`, `sierra-gas`, `l2-gas` |
| `--output` | no | Output directory (default: `profiles/`) |
| `--nodefraction` | no | Hide PNG nodes below this fraction of total (default: `0.005`). Use `0` to show all nodes. |
| `--edgefraction` | no | Hide PNG edges below this fraction of total (default: `0.001`). Use `0` to show all edges. |

### CLI exit codes — act on errors

| Code | Meaning | What to do |
|------|---------|------------|
| 0 | Success | Read the PNG path from output |
| 1 | Argument error | Fix the CLI invocation |
| 2 | snforge/scarb failed | Check compilation errors, test failures |
| 3 | Trace file not found | Test must PASS to produce a trace. Check test name matches exactly. |
| 4 | cairo-profiler failed | Check trace JSON is valid |
| 5 | pprof PNG export failed | Check graphviz is installed (`apt install graphviz`) |
| 6 | Missing tool | Install the missing tool (see `installation.md`) |

### Output

The CLI produces two files in `profiles/`:
```
profiles/YY-MM-DD-HH:MM_<package>_<name>_<metric>_<commit>.pb.gz
profiles/YY-MM-DD-HH:MM_<package>_<name>_<metric>_<commit>.png
```

After running the CLI, **always read the PNG** to verify the profile shows the expected functions.

## Pitfalls

### Stale trace files

`snfoundry_trace/` keeps old traces. If you change code and re-profile, you MUST re-run `snforge test --save-trace-data` (the CLI does this automatically). **Never build a profile from a trace that predates your code change.**

### Missing functions in the PNG

If a function doesn't appear in the PNG, it may be below the `--nodefraction` threshold. Use `--nodefraction 0` to show all nodes. You can also check the text output (printed by the CLI) — functions with 0 flat steps but high cumulative steps are wrappers that delegate all work to callees.

### Timestamp mismatch between pb.gz and png

When running steps manually, the pb.gz and png may get different timestamps if they cross a minute boundary. The CLI computes the timestamp once so both files always match.

## Manual profiling (advanced)

For interactive exploration beyond what the CLI provides:

```bash
# Launch web UI for interactive flame graphs
pprof -http=:8080 profiles/<name>.pb.gz

# View specific sample in terminal
cairo-profiler view profiles/<name>.pb.gz --sample steps --limit 20

# List available samples
cairo-profiler view profiles/<name>.pb.gz --list-samples
```

## Metric reference

| `--metric` | tracked-resource | Samples in profile |
|------------|------------------|--------------------|
| `steps` | `cairo-steps` | steps, calls, range check builtin, memory holes, casm size |
| `rc` | `cairo-steps` | (same as steps, PNG shows range check builtin) |
| `sierra-gas` | `sierra-gas` | sierra gas, calls, casm size |
| `l2-gas` | `sierra-gas` | l2 gas (requires `enable-gas = true` + dispatcher pattern) |

## L2 Gas profiling (snforge)

L2 gas requires **all three**:

1. `[cairo] enable-gas = true` in Scarb.toml
2. `--metric l2-gas` (uses sierra-gas tracking)
3. **Dispatcher pattern** — profiled code must run inside a deployed contract

```cairo
#[starknet::interface]
trait IBench<TContractState> {
    fn my_function(self: @TContractState) -> felt252;
}

#[starknet::contract]
mod bench { /* ... */ }

// Test using dispatcher
#[test]
fn bench_my_function() {
    let contract = declare("bench").unwrap().contract_class();
    let (addr, _) = contract.deploy(@array![]).unwrap();
    let dispatcher = IBenchDispatcher { contract_address: addr };
    dispatcher.my_function();
}
```

**Known limitation:** Syscall execution costs (secp256r1, keccak, etc.) are not attributed in the l2 gas profile. Use snforge test output for total gas; use profiler for relative hotspot analysis within Cairo code.
