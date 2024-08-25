import functools
from dataclasses import dataclass
from pathlib import Path

import starknet_py
from starknet_py.common import create_casm_class, create_sierra_compiled_contract
from starknet_py.contract import Contract, DeclareResult
from starknet_py.hash.casm_class_hash import compute_casm_class_hash
from starknet_py.hash.sierra_class_hash import compute_sierra_class_hash
from starknet_py.net.account.account import Account

from garaga.starknet.cli.utils import get_sierra_casm_artifacts
from garaga.starknet.groth16_contract_generator.calldata import (
    groth16_calldata_from_vk_and_proof,
)
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
)


class EmptyContract(Exception):
    pass


from functools import lru_cache

import rich


@dataclass
class SmartContractProject:
    smart_contract_folder: Path  # The folder which holds Scarb.toml.

    def __hash__(self) -> int:
        return hash(self.smart_contract_folder)

    @lru_cache(maxsize=1)
    def get_contract_artifacts(self) -> tuple[str, str]:
        """
        Returns the sierra and casm artifacts for the contract (uses scarb to build the contract folder)
        """
        return get_sierra_casm_artifacts(self.smart_contract_folder)

    @lru_cache(maxsize=1)
    def get_casm_class_hash(self) -> int:
        """
        Returns the class hash for the contract (uses scarb to build the contract folder)
        """
        _, casm_artifact = self.get_contract_artifacts()
        casm_class = create_casm_class(casm_artifact)
        return compute_casm_class_hash(casm_class)

    @lru_cache(maxsize=1)
    def get_sierra_class_hash(self) -> int:
        """
        Returns the class hash for the contract (uses scarb to build the contract folder)
        """
        sierra_artifact, _ = self.get_contract_artifacts()
        return compute_sierra_class_hash(
            create_sierra_compiled_contract(sierra_artifact)
        )

    @lru_cache(maxsize=1)
    def get_abi(self) -> str:
        """
        Returns the abi for the contract (uses scarb to build the contract folder)
        """
        sierra_artifact, _ = self.get_contract_artifacts()
        return create_sierra_compiled_contract(sierra_artifact).parsed_abi

    async def declare_class_hash(self, account: Account, fee="eth") -> int | None:
        """Returns class hash and abi"""

        rich.print(
            f"[bold cyan]Contract project: {self.smart_contract_folder}[/bold cyan]"
        )
        sierra, casm = self.get_contract_artifacts()

        if sierra is None or casm is None:
            raise EmptyContract

        class_hash = self.get_sierra_class_hash()
        abi = self.get_abi()

        try:
            _ = await account.client.get_class_by_hash(class_hash)
            rich.print(
                f"[bold cyan]Contract class for {self.smart_contract_folder} already exists: {hex(class_hash)}[/bold cyan]"
            )
            return class_hash, abi
        except starknet_py.net.client_errors.ClientError as e:
            if e.code == 28:
                rich.print(
                    f"[bold cyan]class hash for {self.smart_contract_folder} not found - deploying[/bold cyan]"
                )
            else:
                raise e
        except Exception as e:
            rich.print(
                f"[bold red]Unexpected error during contract parsing: {type(e).__name__}: {e}[/bold red]"
            )
            raise e

        try:
            if "eth" in fee.lower():
                declare_result: DeclareResult = await Contract.declare_v2(
                    account=account,
                    compiled_contract=sierra,
                    compiled_contract_casm=casm,
                    auto_estimate=True,
                )
            elif "strk" in fee.lower():
                declare_result: DeclareResult = await Contract.declare_v3(
                    account=account,
                    compiled_contract=sierra,
                    compiled_contract_casm=casm,
                    auto_estimate=True,
                )
            await declare_result.wait_for_acceptance()

            rich.print(
                f"[bold green]Contract class hash declared: {hex(declare_result.class_hash)}[/bold green]"
            )
        except starknet_py.net.client_errors.ClientError as e:
            raise e
        except Exception as e:
            rich.print(
                f"[bold red]Unexpected error during contract class declaration: {type(e).__name__}: {e}[/bold red]"
            )
            raise e

        return declare_result.class_hash, abi


@dataclass
class Groth16SmartContract(SmartContractProject):
    vk_path: Path  # The json file which holds the verification key.

    def __hash__(self) -> int:
        return hash((self.smart_contract_folder, self.vk_path))

    @functools.lru_cache(maxsize=128)
    def generate_calldata(
        self, proof_path: Path, public_inputs_path: Path | None = None
    ) -> list[int]:
        """
        Generates the raw calldata for the contract.
        """
        return groth16_calldata_from_vk_and_proof(
            vk=Groth16VerifyingKey.from_json(self.vk_path),
            proof=Groth16Proof.from_json(proof_path, public_inputs_path),
        )
