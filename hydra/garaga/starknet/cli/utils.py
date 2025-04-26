import asyncio
import glob
import json
import os
import shutil
import subprocess
from enum import Enum
from importlib.metadata import PackageNotFoundError, version
from pathlib import Path

import rich
from starknet_py.contract import Contract
from starknet_py.net.account.account import Account
from starknet_py.net.client_errors import ClientError, ContractNotFoundError
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.models import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair

from garaga.definitions import ProofSystem
from garaga.hints.io import to_int


def get_package_version():
    try:
        __version__ = version("garaga")
    except PackageNotFoundError:
        # package is not installed
        __version__ = "dev"
    return __version__


class Network(Enum):
    SEPOLIA = "sepolia"
    MAINNET = "mainnet"


def load_account(network: Network):
    rpc_url = os.getenv(f"{network.name.upper()}_RPC_URL")
    account_address = os.getenv(f"{network.name.upper()}_ACCOUNT_ADDRESS")
    account_private_key = os.getenv(f"{network.name.upper()}_ACCOUNT_PRIVATE_KEY")
    if network == Network.MAINNET:
        chain = StarknetChainId.MAINNET
    else:
        chain = StarknetChainId.SEPOLIA

    client = FullNodeClient(node_url=rpc_url)
    account = Account(
        address=account_address,
        client=client,
        key_pair=KeyPair.from_private_key(to_int(account_private_key)),
        chain=chain,
    )
    account.ESTIMATED_AMOUNT_MULTIPLIER = 1.02
    account.ESTIMATED_FEE_MULTIPLIER = 1.02
    account.ESTIMATED_UNIT_PRICE_MULTIPLIER = 1.02
    return account


def get_contract_if_exists(account: Account, contract_address: int) -> Contract | None:
    try:
        res = asyncio.run(Contract.from_address(contract_address, account))
        return res
    except ContractNotFoundError:

        return None
    except ClientError as e:
        if "no contract with address" in e.message.lower():
            return None
        raise e


async def get_contract_if_exists_async(
    account: Account, contract_address: int
) -> Contract | None:
    try:
        res = await Contract.from_address(contract_address, account)
        return res
    except ContractNotFoundError:

        return None
    except ClientError as e:
        if "no contract with address" in e.message.lower():
            return None
        raise e


def get_contract_iff_exists(account: Account, contract_address: int) -> Contract:
    contract = get_contract_if_exists(account, contract_address)
    if contract is None:
        rich.print(
            f"[red]Contract {contract_address} does not exists on {account._chain_id.name}[/red]"
        )
        raise ValueError(f"Contract {contract_address} not found")
    return contract


def create_directory(path: str):
    if not os.path.exists(path):
        os.makedirs(path)
        # print(f"Directory created: {path}")


def complete_pairing_curve_id(incomplete: str):
    curve_ids = ["0", "1"]  # Corresponding to BN254 and BLS12_381
    return [cid for cid in curve_ids if cid.startswith(incomplete)]


def complete_proof_system(incomplete: str):
    systems = [ps.value for ps in ProofSystem]
    return [system for system in systems if system.startswith(incomplete)]


def complete_network(incomplete: str):
    networks = [network.name for network in StarknetChainId]
    return [network for network in networks if network.startswith(incomplete)]


def get_voyager_network_prefix(network: Network) -> str:
    return "" if network == Network.MAINNET else "sepolia."


def voyager_link_tx(network: Network, tx_hash: int) -> str:
    voyager_prefix = get_voyager_network_prefix(network)
    return f"https://{voyager_prefix}voyager.online/tx/{hex(tx_hash)}"


def voyager_link_class(network: Network, class_hash: int) -> str:
    voyager_prefix = get_voyager_network_prefix(network)
    return f"https://{voyager_prefix}voyager.online/class/{hex(class_hash)}"


def scarb_build_contract_folder(contract_folder_path: str):
    cmd = "scarb build"
    print(f"Running command: {cmd} in directory: {contract_folder_path}")
    try:
        subprocess.run(
            cmd,
            cwd=contract_folder_path,
            check=True,
            shell=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as e:
        print(f"Error building contract: {e}")
        print(f"Command output:\n{e.output}")
        raise
    except FileNotFoundError as e:
        print(f"Error: {e}")
        raise
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        raise


def get_sierra_casm_artifacts(
    contract_folder_path: str,
) -> tuple[None, None] | tuple[str, str]:
    """
    Get the Sierra and CASM artifacts for a contract.
    """
    target_dir = os.path.join(contract_folder_path, "target/dev/")

    # Clean the target/dev/ folder if it already exists
    if os.path.exists(target_dir):
        shutil.rmtree(target_dir)
    os.makedirs(target_dir)

    scarb_build_contract_folder(contract_folder_path)

    artifacts_file = glob.glob(os.path.join(target_dir, "*.starknet_artifacts.json"))
    assert (
        len(artifacts_file) == 1
    ), "Artifacts JSON file not found or multiple files found."

    with open(artifacts_file[0], "r") as f:
        artifacts = json.load(f)

    contracts = artifacts["contracts"]
    if len(contracts) == 0:
        return None, None

    sierra_file = contracts[0]["artifacts"]["sierra"]
    casm_file = contracts[0]["artifacts"]["casm"]

    sierra_path = os.path.join(target_dir, sierra_file)
    casm_path = os.path.join(target_dir, casm_file)

    assert os.path.exists(sierra_path), f"Sierra file not found: {sierra_path}"
    assert os.path.exists(casm_path), f"CASM file not found: {casm_path}"

    with open(sierra_path, "r") as f:
        sierra = f.read()
    with open(casm_path, "r") as f:
        casm = f.read()
    return sierra, casm


def get_default_vk_path(system: ProofSystem) -> Path:
    script_path = Path(__file__).resolve()
    script_folder_path = script_path.parent
    match system:
        case ProofSystem.Risc0Groth16:
            return (
                script_folder_path.parent
                / "groth16_contract_generator"
                / "examples"
                / "vk_risc0.json"
            )
        case _:
            raise ValueError(
                f"Proof system {system} requires an user-provided verification key"
            )
