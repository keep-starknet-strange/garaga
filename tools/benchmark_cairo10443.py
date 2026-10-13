"""Measure Cairo PR #10443 without changing repository sources or build targets."""

import argparse
import hashlib
import json
import os
import shutil
import subprocess
import tempfile
from pathlib import Path

CAIRO_VERSION = "2.21.0"
REPO = Path(__file__).resolve().parents[1]
MICRO = """
use core::circuit::{CircuitElement, CircuitInput, CircuitInputs, AddInputResultTrait,
    CircuitModulus, EvalCircuitTrait, circuit_add, u384, u96};
use corelib_imports::circuit::{CircuitOutputs, get_circuit_output, IntoU96Guarantee};

#[inline]
fn get_output<C, Output>(outputs: CircuitOutputs<C>, output: CircuitElement<Output>) -> u384 {
    let (value, guarantee) = get_circuit_output::<C, Output>(outputs);
    DESTRUCTOR
    value
}

#[executable]
pub fn main(branch: u8, repetitions: u32) -> felt252 {
    let value: [u96; 4] = match branch {
        0 => [1, 0, 0, 0], 1 => [1, 1, 0, 0],
        2 => [1, 1, 1, 0], 3 => [1, 1, 1, 1], _ => panic!("invalid branch"),
    };
    let modulus: CircuitModulus = match branch {
        0 => [2, 0, 0, 0], 1 => [1, 2, 0, 0],
        2 => [1, 1, 2, 0], 3 => [1, 1, 1, 2], _ => panic!("invalid branch"),
    }.try_into().unwrap();
    let input = CircuitElement::<CircuitInput<0>> {};
    let zero = CircuitElement::<CircuitInput<1>> {};
    let output = circuit_add(input, zero);
    let mut checksum: felt252 = 0;
    for _ in 0..repetitions {
        let outputs = (output,).new_inputs().next(value).next([0, 0, 0, 0])
            .done().eval(modulus).unwrap();
        let result = get_output(outputs, output);
        let [limb0, limb1, limb2, limb3] = value;
        assert!(result == u384 {limb0, limb1, limb2, limb3});
        checksum += result.limb0.into();
    };
    checksum
}
"""


def run(command, cwd, env):
    result = subprocess.run(command, cwd=cwd, env=env, capture_output=True, text=True)
    if result.returncode:
        raise RuntimeError(f"{command} failed:\n{result.stdout}\n{result.stderr}")
    return result.stdout


def execute(project, arguments, env):
    command = [
        "scarb",
        "execute",
        "--no-build",
        "--target",
        "standalone",
        "--output",
        "none",
        "--print-program-output",
        "--print-resource-usage",
        "--json",
    ]
    if arguments is not None:
        command += ["--arguments", arguments]
    payload = [
        json.loads(line)
        for line in run(command, project, env).splitlines()
        if line.startswith("{")
    ][-1]
    resources = payload["resources"]
    resources["builtin_instance_counter"] = dict(resources["builtin_instance_counter"])
    resources["memory_segment_sizes"] = dict(resources["memory_segment_sizes"])
    assert not resources["syscalls"]
    return payload


def build_project(root, name, dependency, code, env):
    project = root / name
    (project / "src").mkdir(parents=True)
    (project / "src/lib.cairo").write_text(code)
    (project / "Scarb.toml").write_text(f"""[package]
name = "{name}"
version = "0.1.0"
edition = "2024_07"
[dependencies]
cairo_execute = "{CAIRO_VERSION}"
{dependency}
[cairo]
enable-gas = false
sierra-replace-ids = false
inlining-strategy = 2
[lib]
sierra = true
casm = true
[[target.executable]]
function = "{name}::main"
""")
    run(["scarb", "build"], project, env)
    target = project / "target/dev"
    executable = json.loads((target / f"{name}.executable.json").read_text())
    sierra = json.loads((target / f"{name}.sierra.json").read_text())
    sizes = {
        "casm_felts": len(executable["program"]["bytecode"]),
        "sierra_statements": len(sierra["statements"]),
        "sierra_libfuncs": len(sierra["libfunc_declarations"]),
        "verify_libfuncs": sorted(
            {
                item["long_id"]["generic_id"]
                for item in sierra["libfunc_declarations"]
                if "u96_limbs_less_than_guarantee" in item["long_id"]["generic_id"]
            }
        ),
    }
    return project, sizes


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--iterations", type=int, default=1000)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    if args.iterations < 1:
        parser.error("--iterations must be positive")
    env = os.environ.copy()
    env["ASDF_SCARB_VERSION"] = CAIRO_VERSION
    version = run(["scarb", "--version"], REPO, env).strip()
    assert version.startswith(f"scarb {CAIRO_VERSION} "), version
    results = {
        "scarb": version,
        "runner": run(["scarb", "execute", "--version"], REPO, env).strip(),
        "source_revision": run(["git", "rev-parse", "HEAD"], REPO, env).strip(),
        "source_dirty": bool(run(["git", "status", "--porcelain"], REPO, env)),
        "iterations": args.iterations,
        "micro": {},
        "pairing": {},
    }
    with tempfile.TemporaryDirectory(prefix="garaga-cairo10443-") as directory:
        root = Path(directory)
        shutil.copy(REPO / "README.md", root / "README.md")
        for mode in ("v1", "v2"):
            library = root / f"garaga_{mode}"
            if mode == "v1":
                shutil.copytree(REPO / "src/src", library / "src")
                shutil.copy(REPO / "src/Scarb.toml", library / "Scarb.toml")
                shutil.copytree(
                    REPO / "src/corelib_imports",
                    library / "corelib_imports",
                    ignore=shutil.ignore_patterns("target", "Scarb.lock"),
                )
                digest = hashlib.sha256()
                for path in sorted(library.rglob("*")):
                    if path.is_file():
                        digest.update(str(path.relative_to(library)).encode())
                        digest.update(path.read_bytes())
                results["cairo_source_sha256"] = digest.hexdigest()
            else:
                shutil.copytree(
                    root / "garaga_v1",
                    library,
                    ignore=shutil.ignore_patterns("target", "Scarb.lock"),
                )
                path = library / "src/core/circuit.cairo"
                code = path.read_text()
                old = "        guarantee.into_u96_guarantee().destruct();"
                assert code.count(old) == 1
                path.write_text(code.replace(old, "        guarantee.destruct();"))

            destructor = (
                "guarantee.into_u96_guarantee().destruct();"
                if mode == "v1"
                else "guarantee.destruct();"
            )
            project, sizes = build_project(
                root,
                f"micro_{mode}",
                f'corelib_imports = {{ path = "{root / "garaga_v1/corelib_imports"}" }}',
                MICRO.replace("DESTRUCTOR", destructor),
                env,
            )
            metadata_output = run(
                ["scarb", "metadata", "--format-version", "1"], project, env
            )
            metadata = json.loads(metadata_output[metadata_output.index("{") :])
            core = next(
                package for package in metadata["packages"] if package["name"] == "core"
            )
            core_source = Path(core["manifest_path"]).parent / "src/circuit.cairo"
            assert "u96_limbs_less_than_guarantee_verify_v2" in core_source.read_text()
            results["core_version"] = core["version"]
            results["core_circuit_sha256"] = hashlib.sha256(
                core_source.read_bytes()
            ).hexdigest()
            results["micro"][mode] = {"sizes": sizes, "branches": {}}
            for branch in range(4):
                baseline = execute(project, f"{branch},0", env)
                measured = execute(project, f"{branch},{args.iterations}", env)
                assert measured["program_output"] == str(args.iterations)
                measured["baseline_resources"] = baseline["resources"]
                measured["steps_per_iteration"] = (
                    measured["resources"]["n_steps"] - baseline["resources"]["n_steps"]
                ) / args.iterations
                results["micro"][mode]["branches"][branch] = measured

            fixture = (
                library / "src/tests/autogenerated/pairing_tests.cairo"
            ).read_text()
            header = fixture.split("#[test]", 1)[0]
            for case, function in (
                ("bn254_2p_2f", "test_BN254_mpcheck_2P_2F"),
                (
                    "groth16_bn254_pairing",
                    "test_BN254_mpcheck_3P_2F_with_extra_miller_loop_result",
                ),
            ):
                body = fixture.split(f"fn {function}()", 1)[1].split("\n#[test]", 1)[0]
                project, sizes = build_project(
                    root,
                    f"{case}_{mode}",
                    f'garaga = {{ path = "{library}" }}',
                    header + "#[executable]\npub fn main()" + body,
                    env,
                )
                measured = execute(project, None, env)
                results["pairing"].setdefault(case, {})[mode] = {
                    "sizes": sizes,
                    **measured,
                }
        for branch in range(4):
            assert (
                results["micro"]["v1"]["branches"][branch]["resources"][
                    "builtin_instance_counter"
                ]
                == results["micro"]["v2"]["branches"][branch]["resources"][
                    "builtin_instance_counter"
                ]
            )
        for case in results["pairing"].values():
            assert (
                case["v1"]["resources"]["builtin_instance_counter"]
                == case["v2"]["resources"]["builtin_instance_counter"]
            )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(results, indent=2, sort_keys=True) + "\n")
    print(args.output)


if __name__ == "__main__":
    main()
