"""Generate Noir proof bundles or verify their source and SDK bindings without proving."""

import argparse
import base64
import hashlib
import json
import os
import shutil
import subprocess
import tempfile
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
EXAMPLES = ROOT / "hydra/garaga/starknet/honk_contract_generator/examples"
MANIFEST = EXAMPLES / "noir_artifacts.json"
PINS = json.loads((ROOT / "tools/make/constants.json").read_text())["noir"]
FILES = {
    "hello": {
        "proof": "proof_ultra_keccak_zk.bin",
        "vk": "vk_ultra_keccak.bin",
        "vk_hash": "vk_hash_ultra_keccak.bin",
        "public_inputs": "public_inputs_ultra_keccak.bin",
    },
    "memory": {
        name: f"memory/{name}.bin"
        for name in ("proof", "vk", "vk_hash", "public_inputs")
    },
    "recursive": {
        name: f"recursive/{name}.bin"
        for name in ("proof", "vk", "vk_hash", "public_inputs")
    },
}

FILES["mutator_set"] = {
    name: f"mutator_set/{name}.bin"
    for name in ("proof", "vk", "vk_hash", "public_inputs")
}
PROGRAMS = {name: ROOT / "tools/noir" / name for name in FILES}
PROGRAMS["mutator_set"] = ROOT / "src/contracts/mutator_set/zk_program"


def sha(data):
    return hashlib.sha256(data).hexdigest()


def run(command, cwd, *, reject=False):
    result = subprocess.run(
        [str(item) for item in command], cwd=cwd, text=True, capture_output=True
    )
    if reject:
        assert result.returncode != 0, f"Modified receipt was accepted: {command}"
    elif result.returncode:
        raise RuntimeError(f"{command}:\n{result.stdout}\n{result.stderr}")
    return result.stdout.strip()


def sources(program, directory=None):
    directory = directory or PROGRAMS[program]
    paths = [
        directory / "Nargo.toml",
        directory / "Prover.toml",
        *sorted((directory / "src").rglob("*.nr")),
    ]
    return {
        str(PROGRAMS[program].relative_to(ROOT) / path.relative_to(directory)): sha(
            path.read_bytes()
        )
        for path in paths
    }


def native_verify(bb, files, cwd, *, reject=False):
    run(
        [
            bb,
            "verify",
            "-t",
            "evm",
            "-k",
            files["vk"],
            "-p",
            files["proof"],
            "-i",
            files["public_inputs"],
        ],
        cwd,
        reject=reject,
    )


def reject_modified_receipts(bb, files, directory):
    """Verify that altered points, accumulator limbs, lengths, and public inputs fail upstream verification."""
    proof = files["proof"].read_bytes()
    candidates = [proof[:255], proof[:-32], proof + bytes(32)]
    for offset in (0, 256, len(proof) - 1):
        changed = bytearray(proof)
        changed[offset] ^= 1
        candidates.append(bytes(changed))
    for index, candidate in enumerate(candidates):
        path = directory / f"invalid-{index}.bin"
        path.write_bytes(candidate)
        native_verify(bb, files | {"proof": path}, directory, reject=True)
    changed_inputs = bytearray(files["public_inputs"].read_bytes())
    changed_inputs[-1] ^= 1
    path = directory / "invalid-inputs.bin"
    path.write_bytes(changed_inputs)
    native_verify(bb, files | {"public_inputs": path}, directory, reject=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument(
        "--prove",
        action="store_true",
        help="Generate and store real receipts with the pinned SDK",
    )
    mode.add_argument(
        "--check",
        action="store_true",
        help="Verify stored receipts and rebuild their keys without proving",
    )
    parser.add_argument("--bb", default=os.getenv("BB_PATH", "bb"))
    parser.add_argument("--nargo", default=os.getenv("NARGO_PATH", "nargo"))
    parser.add_argument(
        "--solidity",
        action="store_true",
        help="Regenerate the Solidity reference without generating proofs",
    )
    parser.add_argument(
        "--case",
        choices=tuple(FILES),
        action="append",
        help="Select cases to update or check; defaults to all cases",
    )
    args = parser.parse_args()
    selected = args.case or list(FILES)
    if "recursive" in selected and "hello" not in selected:
        parser.error("The recursive case also requires --case hello")
    assert (
        run([args.bb, "--version"], ROOT) == PINS["bb_version"]
    ), "Use the pinned Barretenberg version"
    noir_version = run([args.nargo, "--version"], ROOT)
    assert noir_version.splitlines()[0] == f"nargo version = {PINS['nargo_version']}"
    assert (
        PINS["noir_source_revision"] in noir_version
    ), "Unexpected Noir compiler revision"
    metadata = {
        "bb_version": PINS["bb_version"],
        "bb_source_revision": PINS["bb_source_revision"],
        "nargo_version": PINS["nargo_version"],
        "noir_source_revision": PINS["noir_source_revision"],
        "flavor": "ultra_keccak_zk",
        "verifier_target": "evm",
    }
    stored = None if args.prove else json.loads(MANIFEST.read_text())
    if stored:
        assert (
            stored["toolchain"] == metadata
        ), "Proof bundle toolchain differs from constants.json"
    cases = (
        json.loads(MANIFEST.read_text())["cases"]
        if args.prove and MANIFEST.exists()
        else {}
    )
    pending = {}
    pending_sources = {}
    with tempfile.TemporaryDirectory(prefix="garaga-noir-") as temporary:
        for program, names in FILES.items():
            if program not in selected:
                continue
            directory = Path(temporary) / program
            source = PROGRAMS[program]
            shutil.copytree(
                source,
                directory,
                ignore=shutil.ignore_patterns("target", "lib", "out", "test", "cache"),
            )
            run([args.nargo, "test"], directory)
            package = tomllib.loads((directory / "Nargo.toml").read_text())["package"][
                "name"
            ]
            if program == "recursive":
                # The recursive program fixes the inner circuit's key hash in its source.
                inner_bytecode = Path(temporary) / "hello/target/hello.json"
                run(
                    [
                        args.bb,
                        "write_vk",
                        "-t",
                        "noir-recursive",
                        "--output_format",
                        "json",
                        "-b",
                        inner_bytecode,
                        "-o",
                        "target/inner-key",
                    ],
                    directory,
                )
                key = json.loads((directory / "target/inner-key/vk.json").read_text())
                key_source = f"// Generated by tools/noir/run.sh --prove from the hello circuit.\npub global VK_HASH: Field = {key['hash']};\n"
                if args.prove:
                    run(
                        [
                            args.bb,
                            "prove",
                            "-t",
                            "noir-recursive",
                            "--write_vk",
                            "--verify",
                            "--output_format",
                            "json",
                            "-b",
                            inner_bytecode,
                            "-w",
                            Path(temporary) / "hello/target/witness.gz",
                            "-o",
                            "target/inner-proof",
                        ],
                        directory,
                    )
                    proof = json.loads(
                        (directory / "target/inner-proof/proof.json").read_text()
                    )
                    values = json.loads(
                        (
                            directory / "target/inner-proof/public_inputs.json"
                        ).read_text()
                    )
                    (directory / "src/inner_key.nr").write_text(key_source)
                    (directory / "Prover.toml").write_text(
                        "verification_key = "
                        + json.dumps(key["vk"])
                        + "\nproof = "
                        + json.dumps(proof["proof"])
                        + "\npublic_inputs = "
                        + json.dumps(values["public_inputs"])
                        + "\nkey_hash = "
                        + json.dumps(key["hash"])
                        + "\n"
                    )
                    for name in ("src/inner_key.nr", "Prover.toml"):
                        pending_sources[source / name] = (directory / name).read_bytes()
                else:
                    assert (
                        directory / "src/inner_key.nr"
                    ).read_text() == key_source, (
                        "Recursive source uses an obsolete inner key"
                    )
            if args.prove:
                run([args.nargo, "execute", "witness"], directory)
                run(
                    [
                        args.bb,
                        "prove",
                        "-t",
                        "evm",
                        "--write_vk",
                        "--verify",
                        "-b",
                        f"target/{package}.json",
                        "-w",
                        "target/witness.gz",
                        "-o",
                        "target/proof",
                    ],
                    directory,
                )
                files = {name: directory / "target/proof" / name for name in names}
            else:
                run([args.nargo, "compile"], directory)
                files = {name: EXAMPLES / path for name, path in names.items()}
            bytecode = json.loads((directory / f"target/{package}.json").read_text())[
                "bytecode"
            ]
            case = {
                "source_sha256": sources(program, directory),
                "acir_sha256": sha(base64.b64decode(bytecode)),
                "files": {
                    name: {"path": names[name], "sha256": sha(path.read_bytes())}
                    for name, path in files.items()
                },
            }
            if stored:
                assert (
                    stored["cases"][program] == case
                ), f"Source or proof bundle changed: {program}"
            # Rebuild the key from the current source. This performs no proof generation.
            run(
                [
                    args.bb,
                    "write_vk",
                    "-t",
                    "evm",
                    "-b",
                    f"target/{package}.json",
                    "-o",
                    "target/key",
                ],
                directory,
            )
            for name in ("vk", "vk_hash"):
                assert (directory / "target/key" / name).read_bytes() == files[
                    name
                ].read_bytes(), (
                    f"Stored {program} {name} does not match the compiled circuit"
                )
            native_verify(args.bb, files, directory)
            reject_modified_receipts(args.bb, files, directory)
            if args.prove:
                for name, path in files.items():
                    pending[EXAMPLES / names[name]] = path.read_bytes()
            if args.prove or args.solidity:
                # Preserve the generated Solidity reference for optional local debugging.
                run(
                    [
                        args.bb,
                        "write_solidity_verifier",
                        "-t",
                        "evm",
                        "-k",
                        files["vk"],
                        "-o",
                        "target/contract_ultra_keccak_zk.sol",
                    ],
                    directory,
                )
                reference = ROOT / "tools/noir/target/references" / f"{program}.sol"
                reference.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy(
                    directory / "target/contract_ultra_keccak_zk.sol", reference
                )
                target = source / "target"
                target.mkdir(exist_ok=True)
                for path in (directory / "target").iterdir():
                    if path.is_file():
                        shutil.copy(path, target / path.name)
            cases[program] = case
            print(
                f"Verified {program}: source, key, receipt, and rejection cases",
                flush=True,
            )
    if args.prove:
        for path, data in pending_sources.items():
            path.write_bytes(data)
        for path, data in pending.items():
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_bytes(data)
        MANIFEST.write_text(
            json.dumps({"toolchain": metadata, "cases": cases}, indent=2) + "\n"
        )
        print(
            "Stored verified receipts. Run make constants and make rewrite to update Cairo artifacts."
        )
    else:
        print(
            "All stored receipts match the pinned SDK and current Noir sources. No proof was generated."
        )


if __name__ == "__main__":
    main()
