# Development cycle improvements

This work starts from PR 521. It preserves that PR's Cairo, Python, and runtime compatibility decisions.

The measurements and historical CI results refer to the source checkpoints before the PR history cleanup.
The cleanup removed raw benchmark records from every PR commit. The raw evidence remains outside this repository.

## CI dependency coverage

Node tests consume proof fixtures outside `tools/`. WASM builds consume the root Cargo manifests, lockfile, and configuration.
The setup smoke test consumes Python dependencies, Rust sources, and the Python package.
Each workflow now includes those inputs in its path filters.

The path regression suite failed for 18 dependency-change cases before this change.
All 35 current cases pass, including unrelated documentation changes that still skip these workflows.
The added canonical toolchain source is also a setup input.
The package README remains a setup input because maturin reads it during the native build.
The existing test jobs, release conditions, and matrices remain unchanged.

Run the regression suite:

```sh
source venv/bin/activate
pytest tests/ci/test_workflow_paths.py
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
pytest tests/tools/make/test_setup_dependencies.py
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

## Install the WASM test tool without compilation

The WASM test job downloads `wasm-pack@0.13.1`, the same version that the existing Docker generator uses.
The [installer action](https://github.com/taiki-e/install-action#security-on-installation-from-github-releases) checks the archive SHA256 before extraction.
The `fallback: none` input stops installation if the pinned binary is unavailable. It prevents an unexpected source build.
The test command, test coverage, package build, and release conditions remain unchanged.

The [baseline CI job](https://github.com/keep-starknet-strange/garaga/actions/runs/38467549883/job/115538190551) used PR 521 commit `998b013` on Ubuntu.
That job compiled an unpinned `wasm-pack@0.15.0` from source in 77 seconds before the project build and tests.
The new installation step does not compile the CLI.

A local check downloaded, checked, and extracted the pinned Linux archive in 0.35 seconds on macOS arm64.
The archive contained 2,871,133 bytes and matched the SHA256 in the [installer manifest](https://github.com/taiki-e/install-action/blob/main/manifests/wasm-pack.json).
This local check excludes GitHub Action overhead. Different systems and network conditions prevent a direct timing comparison with the Ubuntu baseline.
The pinned release has no native macOS arm64 binary.
The Ubuntu CI job passed all five WASM tests and one doctest after a 0.37-second installation.

## Faster native edit-build cycles

Use the debug extension for short Rust edit-build cycles:

```sh
make maturin-dev
```

Use the existing optimized build before performance measurements:

```sh
make maturin
```

`make setup`, CI, and release builds retain their optimized profile.
The debug extension can run cryptographic operations more slowly. It does not replace the optimized build.

Five alternating warm rebuilds used the same source and interpreter on an Apple M4 Pro.
The tools were Rust 1.93.0, CPython 3.14.7, and maturin 1.12.4.
Each sample touched `tools/garaga_rs/src/lib.rs` to force recompilation, then ran the complete Make target.
The measurement includes compilation, wheel creation, and editable installation. Both profiles were warm before measurement.

- `make maturin`: 18.9323s, 19.3033s, 19.1324s, 18.7739s, 18.5382s. Median: 18.9323s.
- `make maturin-dev`: 1.0603s, 0.9806s, 0.9391s, 0.9303s, 0.9331s. Median: 0.9391s.

The measured rebuild time decreased by 95.0%. These results do not predict cold builds or full test-suite time.

After the debug build, run the existing Python/Rust parity checks:

```sh
source venv/bin/activate
pytest tests/hydra/starknet/test_calldata.py -k test_msm_calldata_builder
```

## One formatter across the contributor loop

The CLI, CI, and commit hook now use the Black executable from `venv`.
Its version comes from `uv.lock`. The hook retains its Python 3.11 target and file filters.
`make setup` installs this environment before it installs the hooks.

The old hook selected Black 26.1.0 independently of the locked Black 26.5.1 environment.
The change reduces two formatter-version owners to one and removes the separate Black hook environment.
Three real hook tests prove locked-version selection, CLI-equivalent formatting, and invalid-syntax rejection.
They also prove that a conflicting global Black executable cannot change the result.

Run the focused checks:

```sh
source venv/bin/activate
pytest tests/configuration/test_black_hook.py
pre-commit run black --all-files
```

## Regenerate only the affected circuit family

Run a focused circuit regeneration:

```sh
make circuits CIRCUITS=ec
make circuits CIRCUITS="ec rsa"
```

Each selector names a complete output file family, not an individual function.
This preserves sibling functions in the selected file. Unknown selectors fail before any writes.
Unselected files retain their bytes and modification times.
The full `make rewrite` gate remains unchanged.

Five real Scarb runs compared the same registry and source with temporary output projects:

- Full circuit generation: 84 variants, seven files, median 1.0806s.
- EC generation: 24 variants, one file, median 0.5831s.
- RSA generation: one variant, one file, median 0.1243s.

The default generation remained byte-identical and measured 1.0835s after the change.
Every selected family matched the corresponding formatted full-generation file.
The focused command also avoids the five verifier projects and application-test generation in `make rewrite`.
These circuit-only timings do not include verifier generation or Cairo compilation.

Run the selection and preservation checks:

```sh
source venv/bin/activate
pytest tests/hydra/circuits/test_circuit_generation.py
```

All 18 cases pass, including every family, duplicate selectors, and invalid-selection safety.
This PR does not change any Cairo cryptographic source file.

## Profile the package under investigation

Select the package and test through the existing profiler:

```sh
make profile-test PACKAGE=garaga TEST=test_msm_SECP256K1_1P
```

The selector uses the existing package registry. Omitting it retains the six-package workflow.
Unknown packages fail before subprocess execution. The selected package keeps the same test filter and trace options.

The test-running phase measured three alternating warm runs after one warm-up per mode.
Both modes found the same one relevant MSM test.
The full mode invoked six packages and had a median of 5.7966s.
The selected mode invoked one package and had a median of 3.3738s.
These timings exclude trace processing and report generation. The stable work reduction is six subprocess invocations to one.

Eight profiler regression cases pass, including selected library and contract packages, default coverage, and invalid-selection rejection.

## Reuse the generated-test worker pool

Full test generation now creates one process pool for its six parallel stages.
The pool stays open until all stages finish and closes if a stage fails.
Arithmetic, seeds, submission order, and result order remain unchanged.

Three balanced runs per version generated all seven files in fresh projects, including real Scarb formatting.
On macOS with 12 CPUs and Python 3.14.7, the median fell from 15.5554s to 9.9269s (36.2%).
Pool creation fell from six to one; instrumented worker starts fell from 48 to 12 in every run.
All seven files matched both the baseline and the tracked Cairo fixtures byte-for-byte.
Four regression cases cover pool ownership, error cleanup, ordered results, and unchanged seeds.

```sh
source venv/bin/activate
pytest tests/hydra/starknet/test_test_writer.py
```

## Synchronize the Cairo toolchain from one owner

Edit `release_info.cairo_version` and, for an intentional Foundry update, `release_info.starknet_foundry_version` in `tools/make/constants.json`.
Then run:

```sh
make sync-toolchain
make check-toolchain
```

One command synchronizes 57 derived pins across 28 files from that single owner.
The previous upgrade procedure required separate edits across manifests, tool-version files, CI inputs, and Python generator constants.
The command covers every tracked Scarb manifest and `.tool-versions` file, including manual and generated projects.
Setup reads the required Scarb version from the same source instead of three duplicated literals.
Hydra checks consistency before dependency installation.

Check mode reports drift, returns a failure status, and writes nothing.
Update mode accepts only known toolchain fields and checks every input before writing any file.
It preserves comments, package versions, unrelated constants, and cryptographic source files.
This PR changes no toolchain versions or deployment hashes.
An actual upgrade still requires installation, regeneration, class-hash recomputation, and the full compatibility checks.
The [upgrade command](../.claude/commands/upgrade-cairo.md) describes those separate steps.

Run the synchronization and setup regressions:

```sh
source venv/bin/activate
pytest tests/tools/make/test_sync_toolchain.py tests/tools/make/test_setup_dependencies.py
```

The 15 cases include deliberate drift, all 57 pin updates, unsupported-format rejection before writes, and unchanged cryptographic snapshots.
They also preserve both complete offline setup checks and require the warning to match the canonical version exactly.

Nine process runs on macOS arm64 measured a 44.1ms median for check mode and 43.1ms for a no-op synchronization.
Repairing deliberate Cairo-version drift across 23 files took 45.7ms (nine runs).
These measurements cover configuration synchronization, not compilation, regeneration, or a complete toolchain upgrade.

## Group connected dependency updates

Dependabot coverage increases from zero configured inputs to 24 tracked dependency inputs across six native ecosystems.
The configuration covers uv, Cargo, npm, GitHub Actions, Docker, and pre-commit.
It includes the three independent Cargo workspace roots, both npm roots, and their workspace members.
Locked projects use their existing lockfile roots. Python updates use `uv.lock` rather than a parallel pip owner.
The local `garaga.tgz` package remains excluded from npm updates because it is the package under test.

Each ecosystem groups patch and minor version updates into weekly review PRs.
Major version updates remain separate. Version-update PRs have a three-PR cap per ecosystem.
This change does not configure automatic merging.
Dependency PRs still require the existing test, regeneration, and package integration gates.

The [GitHub service reads this configuration from the default branch](https://docs.github.com/en/code-security/concepts/supply-chain-security/about-the-dependabot-yml-file).
The first hosted update run remains pending until this configuration merges there.
The local regression checks configuration coverage, not a successful hosted dependency upgrade.

```sh
source venv/bin/activate
pytest tests/ci/test_dependency_updates.py
```

## Load E2E fixture plugins only for E2E tests

The E2E test module registers its three fixture plugins instead of loading them from the global pytest configuration.
Unit-only runs avoid the account, client, and devnet imports.
E2E collection retains all nine fixtures and pytest assertion rewriting.
The Hypothesis profile and storage configuration remain unchanged.

Five warm runs of the actual 13-test PyFelt suite compared the same environment and test selection.
The median decreased from 0.9455s to 0.3878s.
Full Hydra collection showed no gain; those tests also load SDK modules through other imports.
These results describe a unit-only inner loop, not faster E2E execution.

```sh
source venv/bin/activate
pytest tests/configuration/test_pytest_configuration.py
pytest tests/hydra/algebra/test_pyfelt.py
```

## Share Groth16 calldata conformance vectors

Python and TypeScript now consume one six-case catalog instead of two independently maintained case lists.
The catalog stores fixture paths, output lengths, and compact SHA256 fingerprints, not duplicate calldata arrays.
The independent pure-Python oracle still compares every output element with native Rust.
Both suites also require the expected length, ABI length prefix, and full output fingerprint.
The fingerprint includes the prefix and uses decimal ASCII integers separated by newlines, without a trailing newline.

All six former TypeScript callbacks accepted empty output in the mutation experiment.
Each updated callback rejects empty output, changed payload, an incorrect ABI prefix, and a mismatched fingerprint.
The Python assertions reject the same four mutations for every vector.
All 20 Python parsing/parity cases and all six TypeScript conformance cases pass with the unchanged valid outputs.
Node CI does not need a Python runtime.

Run the existing suites:

```sh
source venv/bin/activate
pytest tests/hydra/starknet/test_groth16_vk_proof_parsing.py
(cd tools/npm/garaga_ts && npm test -- --runTestsByPath tests/starknet/groth16Calldata.test.ts --runInBand)
```

For an intentional output change, review the proof fixtures and ABI before updating the golden fingerprints:

```sh
source venv/bin/activate
python tests/hydra/starknet/test_groth16_vk_proof_parsing.py --update-golden
```

The opt-in updater requires pure-Python/native Rust array equality and valid ABI prefixes before writing the catalog.
It never derives expected fingerprints from WASM. Review the catalog diff and rerun both suites before committing it.

## Compile TypeScript once per declaration build

The declaration-only Rollup pass no longer repeats the TypeScript plugin already used by the JavaScript pass.
The existing `tsc` gate, JavaScript compilation, and declaration bundler remain in place.
Five paired warm runs measured the complete `npm run build:node` command.
The median decreased from 1.6566s to 1.4496s, a 12.5% reduction.
Median CPU time decreased from 3.1063s to 2.7167s.

A second five-pair run reproduced the result: wall time decreased from 1.5911s to 1.3741s (13.6%).
Child CPU time decreased from 3.0186s to 2.6317s.
The reproduction used Node 24.19.0 and npm 11.17.0 on macOS arm64.

All five CJS, ESM, source-map, and declaration artifacts remained byte-identical in every pair.
All 34 Jest cases pass. These timings exclude Rust/WASM compilation and npm dependency installation.

```sh
cd tools/npm/garaga_ts
npm run build:node
npm test -- --runInBand
```

## Local verification at 85d843d

The local verification checkpoint used source commit `85d843d` and baseline `a01fad0`.
All 83 tracked Cairo source files match the baseline byte-for-byte.
The full regeneration gate also leaves every tracked generated artifact unchanged.

The local checks at that checkpoint passed:

- Python: 907 passed, five skipped, with the optimized native extension.
- Rust: 54 unit tests, one doctest, and workspace Clippy.
- Node: 37 cases, TypeScript checking, and four package integration consumers.
- Toolchain: 57 matching pins across 28 files.
- Formatting and workflow checks: Black, commit hooks, and actionlint with the existing npm publish-glob warning excluded.

Scarb 2.21.0 and Foundry 0.64.1 report unchanged L2 gas estimates with `--tracked-resource cairo-steps`:

- `test_msm_SECP256K1_1P`: 12,320,000.
- `test_BN254_mpcheck_2P_2F`: 52,880,000.

These numbers are the tool's estimates, not a new gas calculation.
The max-log-N bytecode check passes at 67,136 elements against the 81,290 limit.
Full regeneration reports 16 seconds. The full Python verification reports 53.40 seconds.
These verification timings are not matched speed comparisons.
Hosted CI status remains separate and belongs to each pushed commit.

## Keep optimized macOS extensions loadable

Older Rust compilers can produce stripped Mach-O libraries that the current macOS loader rejects.
The original release extension failed twice with `mis-aligned LINKEDIT string pool`.
The failure matches [Rust issue 157750](https://github.com/rust-lang/rust/issues/157750).

The Cargo configuration disables stripping only for macOS targets. Release optimization level 3 and LTO remain enabled.
Linux and WASM compiler flags remain unchanged.
The source distribution explicitly includes that configuration, so source builds retain the fix.

The ordinary Maturin release build, installed Python import, native loader, and known Poseidon vector now pass.
Five regression cases run Cargo target probes for both macOS architectures, Linux, and WASM, then inspect the actual source archive.
The cases pass in 1.18s. The locked dependency check leaves `uv.lock` unchanged.
The probes request plain output even when CI forces color.
The forced-color regression changed from four failures and one pass to five passes in 1.34s.
One configuration-triggered release build took 26.61s. This is not a paired build-speed comparison.
The loadable Maturin artifact contains 2,395,992 bytes, a 4.17% increase from the broken artifact.
No Rust algorithm, WASM byte, or Cairo source changes.

```sh
make maturin
source venv/bin/activate
pytest tests/configuration/test_native_build_config.py
```

## Cache Rust dependencies only in the measured WASM test job

The WASM unit-test job caches Rust dependencies through `Swatinem/rust-cache@v2`.
The cache uses the actual Cargo target directory, `.cargo/garaga_rs/target`, and a WASM-specific key.
The existing `RUSTFLAGS` value is available before cache-key computation and remains unchanged.

The action retains its [compiler, platform, environment, and Cargo input hashing](https://github.com/Swatinem/rust-cache#cache-key).
An explicit root `Cargo.toml` hash also covers the virtual workspace's release-profile inputs.
The default dependency-only cache leaves workspace crates to rebuild.
Native, setup smoke, and release jobs remain uncached. Scarb retains `cache: false`.
The existing test, regeneration, bytecode, artifact-build, and integration gates remain unchanged.

One hosted cold/warm pair used head `641909b`, Rust 1.99.0, and the same Ubuntu 24.04.5 image.
The [cold job](https://github.com/keep-starknet-strange/garaga/actions/runs/38477888642/job/115573071769) missed the cache.
The [warm job](https://github.com/keep-starknet-strange/garaga/actions/runs/38477888642/job/115575102716) restored the exact key and all six tests passed again.
The two release compilation phases decreased from 40.07s + 49.95s to 29.30s + 31.43s.
The restore-through-final-test-report envelope decreased from 100.856s to 69.990s, including binary installation and cache overhead.
The cache step took 0.566s on the cold miss and 2.296s on the warm hit.
These single paired-run results do not predict other runs or full-suite performance.

The native-cache experiment did not establish a meaningful end-to-end benefit.
Native release compilation remained 35.66s versus 35.25s, while warm restoration added 3.876s.
The restore-through-Rust-test envelope changed only from 64.240s to 63.053s.
Hydra and E2E cache entries were therefore removed instead of retaining unproven configuration.

Three focused cases check the target directory, compiler flags, hash inputs, and unchanged uncached jobs:

```sh
source venv/bin/activate
pytest tests/ci/test_rust_cache.py
```

## Verify the MPCheck equation once

MPCheck validation previously evaluated every relation twice.
The second loop only computed an unused debug value. It performed no assertion and produced no calldata.
The builder now evaluates the live equation once and retains the original assertion.

Five alternating process pairs exercised all eight existing BN254 and BLS12-381 configurations with the same optimized extension.
The complete Python/native builder workload decreased from a 1.5022s median to 1.4281s (4.9%).
Child CPU decreased from 1.4593s to 1.4067s (3.6%).
One candidate wall sample had a scheduler outlier.
An earlier comparison before debug-counter cleanup measured a smaller 2.7% reduction.
These process timings include native parity checks and do not describe faster native Rust computation.

Every sample produced eight byte-identical, stable calldata artifacts and required complete Python/native equality.
Eight independent equation checks retain acceptance and reject corrupted quotients, remainders, and challenges on both curves.
Those checks and all eight existing native-parity cases pass.
Full `make rewrite` leaves every tracked generated artifact unchanged.

```sh
source venv/bin/activate
pytest tests/hydra/starknet/test_mpcheck_invariants.py
pytest tests/hydra/starknet/test_calldata.py -k test_mpcheck_calldata_builder
```

## Evaluate polynomials with one multiplication per coefficient

Normal-field polynomial evaluation now uses Horner's method in one pass.
The loop detects mixed coefficient moduli and retains the previous algorithm for those accepted inputs.
The point-type assertion, empty-storage result, and input coefficient lists remain unchanged.

Five alternating process pairs used the eight MPCheck configurations after the duplicate-loop cleanup.
The complete Python/native workload decreased from a 1.3146s median to 1.2994s (1.15%).
Child CPU decreased from 1.3111s to 1.2952s (1.21%). Every candidate sample was faster than its paired baseline.
The gain is small and applies to this workload. It does not establish a generation or native-Rust speedup.

All eight serialized calldata artifacts remained byte-identical and stable across samples, with complete Python/native equality.
A separate comparison preserved all eight generated Cairo pairing tests. Its single-pair timings are not a speedup claim.
Forty-two evaluation cases include independent direct-power property checks over PyFelt and Fp2.
Those cases, eight equation-invariant checks, and eight native-parity cases pass (58 focused checks).
A separate peer review compared 600 additional cases with the old evaluator, including mixed coefficient and point moduli.

```sh
source venv/bin/activate
pytest tests/hydra/algebra/test_polynomial_evaluate.py
```

## Compare commands with one measurement tool

The dependency-free `tools.measure` command replaces separate timing scripts for each language.
It alternates baseline and candidate runs, excludes warmups, and records every wall-time and child-CPU sample in JSON.
The report includes medians, percentage changes, platform details, and Git source fingerprints before and after the commands.

Use separate checkouts with identical installed toolchains and native build profiles.
For example, compare full regeneration and require identical circuit output:

```sh
venv/bin/python -m tools.measure \
  --baseline ../garaga-baseline --candidate . \
  --runs 5 --warmups 1 \
  --artifact 'src/src/circuits/*.cairo' \
  --output /tmp/generation.json -- make rewrite
```

Artifact hashes exclude modification times and run outside the timed command.
The tool checks every measured output, not only the final sample.
Changed paths, changed bytes, or nondeterministic output cause a failure exit.
Commands must finish their child work. Background work is outside the measurement scope.
The command inherits the environment and does not record environment variables.

The Cairo profiler now records its input Git revision, dirty state, and local-change fingerprint before tests start.
Generated reports cannot relabel a clean input as dirty or overwrite the provenance of historical entries.
Ignored files and installed toolchains are not part of the Git fingerprint.
For directories without Git, the report records unknown provenance instead of inventing a revision.

Thirty-five focused checks pass, including a dependency-free CLI run, failure handling, output mismatch, nondeterminism, and pre-test capture.
Nine source-fingerprint runs measured a 32.9ms wall median and a 26.6ms child-CPU median.
Fingerprint and artifact work stays outside command timings.

```sh
source venv/bin/activate
pytest tests/tools/test_measure.py tests/tools/test_profile_provenance.py tests/tools/test_profile_tests.py
```

## Initialize embedded WASM directly

The wrapper decodes embedded WASM bytes directly when `Buffer` is available.
Without `Buffer`, it retains the existing data-URI loader.
Concurrent and repeated calls share one initialization promise. Failed initialization can retry.
The public Promise API, declarations, raw WASM bytes, and cryptographic implementations remain unchanged.

The new measurement tool ran 15 alternating fresh-process pairs per module format, after one warmup pair.
On Node 24.19.0 and macOS arm64, CJS process time decreased from 90.1ms to 56.3ms (37.6%).
ESM process time decreased from 88.2ms to 54.8ms (37.9%).
These times include Node startup, module loading, initialization, a known Poseidon vector, and output writes.
Inner initialization time decreased from 41.7ms to 10.3ms for CJS and from 42.5ms to 10.2ms for ESM.
CJS median peak RSS decreased from 111,744KiB to 81,904KiB. ESM decreased from 107,120KiB to 79,872KiB.

Five paired runs of the unchanged seven Jest suites (34 cases) decreased from 5.8646s to 5.5532s (5.3%).
The three new initialization cases are outside that timing comparison.
Five paired Node builds did not establish a build-time change: 1.2548s before and 1.2617s after.
The declaration artifact remained byte-identical in every pair.

Every sample preserved the export list, Poseidon result, and WASM memory size.
The temporary package snapshots had no Git metadata. Their source and bundle SHA256 values identify the measured inputs separately.
All 37 Jest cases, TypeScript checking, and all four CJS, ESM, Next.js, and Webpack integration consumers pass.
The browser integrations preserve their fixture output, including browsers with a bundled `Buffer` implementation.

```sh
cd tools/npm/garaga_ts
npm run build:node
npm test -- --runInBand
```

## Reuse Python Euclidean remainders

Polynomial extended GCD now reuses the remainder returned by division.
The old loop computed that remainder twice, including an extra polynomial multiply and subtraction.
A check at entry retains the old normalization and errors for accepted noncanonical, mixed-modulus, and mismatched coefficient types.
The public API and padded coefficient storage remain unchanged.

Five alternating paired runs compared the same four real ECIP hint-and-verification workloads after one warmup pair.
They covered two-point G1 and G2 hints on BN254 and BLS12-381, including native G1 parity checks.
Median command time decreased from 2.9534s to 2.6103s (11.6%).
Median child CPU time decreased from 2.9490s to 2.6074s (11.6%).
Every complete hint coefficient artifact remained byte-identical and stable across the runs.
These results apply to this ECIP workload, not all proof generation.

Twenty focused mathematical and compatibility cases cover Bézout identities, divisibility, unchanged inputs, padded storage, and legacy failures.
No Cairo source or circuit operation changed.

```sh
source venv/bin/activate
pytest tests/hydra/algebra/test_polynomial_xgcd.py tests/hydra/algebra/test_polynomial.py
```

## Remove Rust polynomial allocation work

Rust polynomial division now consumes and updates the numerator buffer in place.
It no longer builds scaled, shifted, negated subtraction polynomials at every step.
Extended GCD also reuses each division remainder and avoids cloning the quotient.
The field operations, normalized quotient/remainder values, and public interfaces remain unchanged.

Five alternating paired runs used Rust 1.93.0, the same optimized release profile, and one warmup pair.
The complete native workload decreased from 1.0793s to 0.9823s (9.0%); child CPU decreased by 8.9%.
It includes dense division cases, one/two/eight-point ECIP hints for all six curves, and eight native MPCheck calldata configurations.
Individual ECIP cases improved by 6.0–14.3%; MPCheck cases improved by 2.3–7.0%.
The dense division loops improved by 18.1–54.5%; those inner timings cover repeated divisions, not one call.
All hint, quotient/remainder, and calldata artifacts stayed byte-identical and stable.
These results do not predict all proof workloads or total build time.

Seven new mathematical tests cover constructed quotient/remainder values, zero/lower-degree numerators, padding, input preservation, Bézout identities, and zero-denominator failure across all six fields.
All 54 existing Rust unit tests and the doctest pass; workspace Clippy and TypeScript checks pass.
The optimized Python extension and matching WASM package were regenerated with the existing compiler pins.
All 37 Node cases and the forced four-consumer integration build pass.
The full Python run passed 926 cases; its sole manifest-read failure raced the concurrent WASM generator's temporary file replacement.
After generation, all eight dependency-manifest checks passed, including the affected case.
These gate runtimes are verification results under concurrent functional work, not speed comparisons.

Full Cairo regeneration left all 83 tracked Cairo source files byte-identical to PR 521.

All four forced CJS, ESM, Next.js, and Webpack consumer tests also pass.
The representative MSM test retains its 12,320,000 L2 gas estimate under Cairo-step tracking.

## Install the generator CLI without compiling it

The Docker generator downloads the same pinned wasm-pack 0.13.1 release on amd64 and arm64.
It checks each archive's reviewed SHA256 before extraction and removes the archive in the same layer.
Other architectures retain the original locked source-install command.
One local version value drives the release URL, archive member, and fallback.
A version change requires new verified hashes; stale hashes fail before extraction.
Rust 1.87.0, Node 20.17.0, build commands, and generated package interfaces remain unchanged.

The CLI installation layer decreased from 141MB to 7.2MB.
A fresh local production image build took 14.8966s, with 1.0s in the CLI-install RUN.
The historical Ubuntu CI source-install step took 49.9s.
These are different environments, not a paired timing comparison; no percentage or total-generation speedup is claimed.
Two isolated source snapshots on the same Docker foundation produced 11 byte-identical WASM, JS, declaration, distribution, and npm-package artifacts.
Five installer self-checks cover both architectures, wrong/stale checksums, and the locked fallback's exit status.
The existing 57-pin/28-file Cairo/Foundry checker remains passing.

## Execute the Noir build once

The mutator-set Make recipe now runs only `nargo execute witness`.
That command compiles when needed, including from an absent target directory.
The removed `nargo build` command was a valid hidden alias, but performed redundant compiler work before execution.
No Noir source, proving dependency, proof flag, compiler pin, or Cairo artifact changed.

Three alternating actual-Make pairs used the repository-pinned Nargo 1.0.0-beta.16 compiler.
Warm target time decreased from 0.3984s to 0.2717s (31.8%); child CPU decreased by 35.3%.
With a deleted target before each sample, time decreased from 2.1112s to 1.9702s (6.7%); child CPU decreased by 7.7%.
Every complete ACIR JSON and compressed witness remained byte-identical and stable in both comparisons.
The same absolute source path and committed Prover inputs prevented debug-path or fixture differences.
Hello's one Noir test and the mutator's two Noir tests pass; both programs execute from deleted targets.
Barretenberg was not installed, so these results do not claim proof-generation or verification speed changes.

## Compile only the Rust features used by Garaga

The Rust crate no longer requests the unused Rayon dependency or test-strategy macro dependency.
Its pinned Lambdaworks math dependency retains `std` without the unused default parallel feature.
Garaga's field, curve, polynomial, and Merkle construction paths remain unchanged.
The Merkle method's documentation now describes its existing sequential implementation; the public method name remains unchanged.
No dependency version or cryptographic algorithm changed.

Three alternating cold `cargo test --locked --no-run -p garaga_rs` pairs used new empty target directories and the same warm registry.
The source snapshots start from b968847 and differ only in the manifest/lock feature selection.
Median command time decreased from 5.4418s to 4.8517s (10.8%); child CPU decreased from 26.9046s to 23.4627s (12.8%).
Compiled packages decreased from 48 to 40 in every sample; the last target's logical file size decreased from 368.9MB to 335.4MB (9.1%).
Production native, Python, and WASM graphs each remove five unused packages; test graphs remove eight.
These measurements isolate dependency compilation and do not predict full CI time or runtime performance.

Both frozen source variants pass the same 54 native tests with identical test lists.
The current source also passes all 61 Rust tests and its doctest; workspace Clippy passes.
The matching WASM package was regenerated through the normal `make wasm` target.

All 37 Node cases, all four forced consumer builds/tests, and 116 Python calldata/signature parity cases pass with the regenerated feature-selected artifacts.
No tracked Cairo source differs from PR 521.

## Preserve sparse Frobenius outputs

The runtime checks exposed an existing Rust Frobenius bug, not a speed improvement.
Normalized short polynomials could panic when the map read an absent coefficient.
Limiting output rows to the input length could also discard valid higher-degree output.
The fix evaluates every extension-field output row and treats absent input coefficients as zero, without cloning or padding the input.

Independent tower-field exponentiation checks cover 120 comparisons across BN254 and BLS12-381, including every basis monomial and stored input length.
Pairing each G1 generator and its negation with the same G2 generator previously panicked on both curves.
All six Python/native cases now pass with exact complete-calldata equality, covering zero, one, and two fixed G2 points.
The existing eight full-width calldata artifacts remain byte-identical.

Five alternating full-width MPCheck pairs after one warmup measured 0.3571s before and 0.3599s after: a 0.8% off-chain wall-time cost, with a 0.8% CPU cost.
This small cost fixes valid inputs; it is not presented as a performance gain.
The native suite, optimized Python binding, and regenerated WASM package pass their checks.
Full Cairo regeneration leaves all 83 tracked Cairo source files byte-identical to PR 521.
No Cairo algorithm or gas cost changed.

## Skip inversion for monic divisors

Rust polynomial division now reuses a leading coefficient of one as its own inverse.
Other leading coefficients retain the existing inverse operation.
This matters in the Montgomery fields: inverting field one still runs the general inversion loop.
No multiplication shortcut, extra helper, or size threshold is needed.

Five alternating matched release pairs after one warmup compared 42 cases: 18 ECIP workloads across six curves, eight MPCheck configurations, and 16 monic/nonmonic dense-division cases.
Median process time decreased from 0.9990s to 0.9253s (7.4%); child CPU decreased by 7.4%.
All 18 ECIP cases improved by 6.8–17.0%; their summed case medians decreased by 11.5%.
MPCheck's summed case medians changed by only -0.4%, not a substantial gain.
Every complete payload stayed byte-identical and stable.

A separate five-pair dense run repeated each of the 16 cases 20 times per process.
Monic summed case medians decreased by 15.5%; nonmonic medians decreased by 1.7%.
The nonmonic BN254 cases ranged from a 2.0% improvement to a 0.1% increase, with no material slowdown.
These comparisons use the same feature selection and macOS configuration, before the separate sparse-Frobenius fix; only polynomial division differs between the timed sources.
Earlier exploratory runs with mismatched configuration are excluded.

The existing mathematical suite now covers 480 constructed monic/nonmonic divisions across six fields, plus Bézout identities and zero-denominator failure.

The combined current source passes 933 Python cases with five skips, 65 Rust tests plus one doctest, workspace Clippy, and 37 Node cases.
The optimized extension, matching WASM package, TypeScript checks, and all four forced consumer builds/tests pass.
All twelve CJS/ESM sparse-pairing array comparisons retain the Python output after the binary change.
Full regeneration preserves all 83 Cairo source files; the MSM/pairing gas estimates remain 12,320,000/52,880,000, and max-log-N bytecode remains 67,136 against its 81,290 limit.

## Reject architecture-dependent generation

An isolated native-arm64 Docker trial compared the same clean `8aeeb61` source at `/garaga` with the canonical amd64 build.
Both used Rust 1.87.0, Node 20.17.0, npm 10.8.2, wasm-pack 0.13.1, wasm-bindgen 0.2.100, and wasm-opt 117.
Both generations succeeded, but six of the eleven complete artifacts differed: WASM, CJS/ESM bundles and maps, and the npm archive.
The declaration, glue, and package metadata artifacts matched.
The retained Rust-produced WASM inputs already differed before wasm-opt; the canonical amd64 output matched the tracked artifact.
The candidate failed the required byte-identity gate before timing; no speed claim or shared architecture change was made.
The generator retains its canonical `linux/amd64` platform.

## Final preservation checkpoint

The final local checkpoint used runtime source commit `8aeeb61` and Cairo baseline `a01fad0`.
All 83 tracked Cairo files match the baseline byte-for-byte after full regeneration.
The selected MSM and pairing tests retain their reported L2 gas estimates, and the max-log-N contract remains below the unchanged bytecode limit.

The final optimized bindings pass 933 Python tests with five skips, 65 Rust tests plus a doctest, 37 Node tests, TypeScript checking, and all four forced consumer builds/tests.
Workspace Clippy passes with its three existing test warnings.
The complete sparse-pairing outputs also match Python in both CJS and ESM after the final WASM rebuild.
The 57-pin/28-file toolchain check and commit hooks pass.
These gate runtimes are functional verification, not aggregate speed comparisons.

The accepted changes cover Python, native Rust, TypeScript/Node, Cairo development tools, CI, and Noir compiler/witness work.
Actual Barretenberg proof generation/verification and RISC0 guest compiler/prover execution remain unmeasured because those tools were unavailable.
No proof-generation speed claim or speculative proving dependency upgrade is made.
Rejected or configuration-mismatched experiments are not included in the improvement claims.

Hosted CI at `8aeeb61` completed all six workflows successfully: 21 successful checks and two expected skips.
The Python 3.11/3.12/3.14 matrices, both Devnet matrices, all three setup platforms, and the Node/WASM/four-consumer gates passed.
The skipped checks were the input-filtered Cairo job and tag-only npm release.
