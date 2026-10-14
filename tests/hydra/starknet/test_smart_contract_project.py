import json
from types import SimpleNamespace
from unittest.mock import AsyncMock

import pytest
from marshmallow import ValidationError
from starknet_py.common import create_casm_class
from starknet_py.hash.casm_class_hash import compute_casm_class_hash
from starknet_py.hash.hash_method import HashMethod

from garaga.starknet.cli.smart_contract_project import SmartContractProject


@pytest.fixture
def signed_hint_casm():
    return json.dumps(
        {
            "prime": "0x800000000000011000000000000000000000000000000000000000000000001",
            "compiler_version": "2.21.0",
            "bytecode": ["0x1"],
            "bytecode_segment_lengths": [1],
            "entry_points_by_type": {
                "EXTERNAL": [{"selector": "0x1", "offset": 0, "builtins": []}],
                "L1_HANDLER": [],
                "CONSTRUCTOR": [],
            },
            "hints": [
                [
                    0,
                    [
                        {
                            "TestLessThanOrEqual": {
                                "lhs": {"Immediate": "0x1"},
                                "rhs": {"Immediate": "-0x1"},
                                "dst": {"register": "AP", "offset": 0},
                            }
                        }
                    ],
                ]
            ],
        }
    )


def expected_hash(casm_artifact, hash_method):
    casm = json.loads(casm_artifact)
    casm["hints"] = []
    return compute_casm_class_hash(create_casm_class(json.dumps(casm)), hash_method)


def test_casm_hash_accepts_signed_hints_and_preserves_raw_artifact(
    monkeypatch, tmp_path, signed_hint_casm
):
    with pytest.raises(ValidationError):
        create_casm_class(signed_hint_casm)

    project = SmartContractProject(tmp_path)
    monkeypatch.setattr(
        project, "get_contract_artifacts", lambda: ("", signed_hint_casm)
    )

    assert project.get_casm_class_hash() == expected_hash(
        signed_hint_casm, HashMethod.BLAKE2S
    )
    assert project.get_contract_artifacts()[1] == signed_hint_casm


@pytest.mark.asyncio
@pytest.mark.parametrize(
    "starknet_version, hash_method",
    [("0.14.0", HashMethod.POSEIDON), ("0.14.1", HashMethod.BLAKE2S)],
)
async def test_declaration_preserves_sierra_and_network_hash_selection(
    monkeypatch, tmp_path, signed_hint_casm, starknet_version, hash_method
):
    sierra = "original Sierra artifact"
    project = SmartContractProject(tmp_path)
    monkeypatch.setattr(
        project, "get_contract_artifacts", lambda: (sierra, signed_hint_casm)
    )
    monkeypatch.setattr(project, "get_sierra_class_hash", lambda: 123)
    monkeypatch.setattr(project, "get_abi", lambda: [])
    monkeypatch.setattr(project, "_check_class_exists", AsyncMock(return_value=False))
    account = SimpleNamespace(
        client=SimpleNamespace(
            get_block=AsyncMock(
                return_value=SimpleNamespace(starknet_version=starknet_version)
            )
        ),
        sign_declare_v3=AsyncMock(),
    )
    result = SimpleNamespace(class_hash=123, wait_for_acceptance=AsyncMock())
    monkeypatch.setattr(
        "starknet_py.contract._declare_contract", AsyncMock(return_value=result)
    )

    assert await project.declare_class_hash(account) == (123, [])
    signed = account.sign_declare_v3.call_args.kwargs
    assert signed["compiled_contract"] == sierra
    assert signed["compiled_class_hash"] == expected_hash(signed_hint_casm, hash_method)
    assert project.get_contract_artifacts() == (sierra, signed_hint_casm)
