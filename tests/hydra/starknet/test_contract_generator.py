from subprocess import CompletedProcess

import pytest
from garaga.curves import ProofSystem
from garaga.starknet.groth16_contract_generator import generator


@pytest.fixture
def release_checkout(monkeypatch, tmp_path):
    monkeypatch.setattr(
        generator,
        "__file__",
        str(tmp_path / "hydra/garaga/starknet/groth16_contract_generator/generator.py"),
    )
    monkeypatch.setattr(generator, "get_package_version", lambda: "1.1.0")
    return tmp_path


@pytest.mark.parametrize("cli_mode", [False, True])
def test_manifest_builds_shared_ecip_only_for_tests(release_checkout, cli_mode):
    manifest = generator.get_scarb_toml_file("verifier", cli_mode)

    assert (
        "[target-defaults.test]\n"
        'build-external-contracts = ["garaga::universal_ecip::UniversalECIP"]'
    ) in manifest
    assert "universal_ecip =" not in manifest
    if cli_mode:
        assert 'tag = "v1.1.0"' in manifest
        assert 'path = "../../../"' not in manifest
    else:
        assert 'garaga = { path = "../../../" }' in manifest


def test_editable_checkout_pins_current_source_commit(monkeypatch, release_checkout):
    (release_checkout / ".git").touch()
    revision = "1234567890abcdef1234567890abcdef12345678"

    def git_revision(command, **kwargs):
        assert command == ["git", "rev-parse", "HEAD"]
        assert kwargs["cwd"] == release_checkout
        assert kwargs["check"] is True
        return CompletedProcess(command, 0, stdout=f"{revision}\n")

    monkeypatch.setattr(generator.subprocess, "run", git_revision)
    manifest = generator.get_scarb_toml_file("verifier", cli_mode=True)

    assert f'rev = "{revision}"' in manifest
    assert "tag =" not in manifest


def test_generated_verifier_test_declares_ecip_without_network():
    code = generator.gen_test_file(
        "Verifier",
        "groth16_verifier",
        ProofSystem.Groth16,
        "verify_proof",
        "verifier",
    )
    test_body = code[code.index("fn test_verify_proof()") :]

    assert "#[fork(" not in code
    assert test_body.index('declare_contract("UniversalECIP")') < test_body.index(
        'declare_contract("Verifier")'
    )


@pytest.mark.parametrize("constants_location", ["default", "internal", "external"])
def test_generated_files_are_formatted_once(
    monkeypatch, release_checkout, constants_location
):
    output_path = release_checkout / "verifier"
    constants_path = {
        "default": output_path / "src/groth16_verifier_constants.cairo",
        "internal": output_path / "src/custom_constants.cairo",
        "external": release_checkout / "shared/constants.cairo",
    }[constants_location]
    formatter_calls = []

    def format_files(command, **kwargs):
        if kwargs["cwd"] == str(output_path):
            assert (output_path / "src/groth16_verifier.cairo").is_file()
            assert (output_path / "src/lib.cairo").is_file()
            assert (output_path / "src/circuits.cairo").is_file()
            assert (output_path / "tests/test_contract.cairo").is_file()
        assert constants_path.is_file()
        formatter_calls.append((command, kwargs))
        return CompletedProcess(command, 0)

    monkeypatch.setattr(generator.subprocess, "run", format_files)
    generator.write_verifier_files(
        str(output_path),
        "verifier",
        "pub const VALUE: felt252 = 1;\n",
        "mod verifier {}\n",
        "Verifier",
        "verify_proof",
        ProofSystem.Groth16,
        circuits_code="pub fn circuit() {}\n",
        circuits_filename="circuits.cairo",
        constants_output_path=(
            None if constants_location == "default" else str(constants_path)
        ),
    )

    assert formatter_calls[-1] == (
        ["scarb", "fmt", "."],
        {"cwd": str(output_path), "check": True},
    )
    if constants_location == "external":
        assert formatter_calls[:-1] == [
            (
                ["scarb", "fmt", constants_path.name],
                {"cwd": str(constants_path.parent), "check": True},
            )
        ]
    else:
        assert len(formatter_calls) == 1
