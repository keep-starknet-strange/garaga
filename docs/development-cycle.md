# Development cycle improvements

This work starts from PR 521. It preserves that PR's Cairo, Python, and runtime compatibility decisions.

## CI dependency coverage

Node tests consume proof fixtures outside `tools/`. WASM builds consume the root Cargo manifests, lockfile, and configuration.
The setup smoke test consumes Python dependencies, Rust sources, and the Python package.
Each workflow now includes those inputs in its path filters.

The path regression suite failed for 18 dependency-change cases before this change.
All 34 cases now pass, including unrelated documentation changes that still skip these workflows.
The package README remains a setup input because maturin reads it during the native build.
The existing test jobs, release conditions, and matrices remain unchanged.

Run the regression suite:

```sh
source venv/bin/activate
pytest tests/hydra/test_workflow_paths.py
```

## Locked setup dependencies

`make setup` installs development dependencies from `uv.lock` instead of resolving package versions into a second requirements file.
Setup stops if the lockfile does not match `pyproject.toml`.
It keeps `venv`, the selected Python interpreter, user-installed packages, and the explicit `maturin develop --release --features python` build.
The `--no-install-project` flag avoids a second project build. The `--inexact` flag preserves unrelated packages.
These flags follow the [uv synchronization documentation](https://docs.astral.sh/uv/concepts/projects/sync/).

Both measurements used PR 521 commit `a01fad0`, the same `pyproject.toml`, and CPython 3.14.7 on macOS arm64.
The old dependency commands installed 56 versions that differed from the 88 applicable packages in `uv.lock`.
Locked synchronization reduced this count to zero.
Five warm dependency-step runs had medians of 29.8ms for compile/install and 15.5ms for locked synchronization.
These timings exclude Rust compilation and do not predict total setup time.

Run the offline regression suite:

```sh
source venv/bin/activate
pytest tests/hydra/test_setup_dependencies.py
```

The tests run the setup script with real uv and local wheels, without network access.
They check lockfile rejection, the active environment, preserved packages, and the absence of a project build during dependency installation.

After an intentional dependency change, update the lockfile:

```sh
uv lock
```

Commit the updated `uv.lock` with the dependency change.

## Format generated verifiers once

The verifier writer formats each complete project once.
Constants inside the project no longer require a separate formatter process.
For external constants, such as SP1 constants, it formats only the generated file, then the verifier project.
It does not format neighboring handwritten files.

The measurement compared PR 521 commit `a01fad0` with this change, using Scarb 2.21.0 on the same machine.
Each run generated both bundled Groth16 verifiers, BN254 and BLS12-381, in fresh temporary directories.
Five repetitions included key parsing, line precomputation, file writes, and real Scarb formatting.

| Measurement | Before | After |
| --- | --- | --- |
| Formatter processes for ten verifier projects | 20 | 10 |
| Median generation time for two verifiers | 0.5765s | 0.3442s |

The measured generation time decreased by 40.3%.
All 12 generated files in the output comparison remained byte-identical.
A separate external-constants check preserved identical generated constants and left an unformatted handwritten neighbor unchanged.

Run the focused regression suite:

```sh
uv run --no-project --python venv/bin/python python -m pytest tests/hydra/starknet/test_contract_generator.py
```

The tests cover default constants, custom constants inside the project, and external constants.

## Supported CI action runtimes

The workflows use `dtolnay/rust-toolchain` instead of the obsolete `actions-rs/toolchain` action.
They retain the same Rust channels, the 1.87.0 E2E pin, and the requested `rustfmt` components.
Four checkout actions now use the existing repository standard, `actions/checkout@v4`.
These substitutions remove 10 obsolete-runtime errors from actionlint 1.7.12 and delete 20 lines of configuration.
The test matrices, test commands, and release conditions remain unchanged.

Run the workflow checks:

```sh
actionlint -ignore 'SC2035:info:1:29' .github/workflows/*.yml
```

The ignore expression covers the existing npm publish-glob warning. This change does not modify that command.
