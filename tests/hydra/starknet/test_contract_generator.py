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
