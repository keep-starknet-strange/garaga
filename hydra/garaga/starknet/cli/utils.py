import asyncio
import os
from enum import Enum

import rich
from starknet_py.contract import Contract
from starknet_py.net.account.account import Account
from starknet_py.net.client_errors import ContractNotFoundError
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.models import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair

from garaga.definitions import ProofSystem
from garaga.hints.io import to_int


class Network(Enum):
    SEPOLIA = "sepolia"
    MAINNET = "mainnet"


def load_account(network: Network):
    rpc_url = os.getenv(f"{network.name.upper()}_RPC_URL")
    account_address = os.getenv(f"{network.name.upper()}_ACCOUNT_ADDRESS")
    account_private_key = os.getenv(f"{network.name.upper()}_ACCOUNT_PRIVATE_KEY")

    client = FullNodeClient(node_url=rpc_url)
    account = Account(
        address=account_address,
        client=client,
        key_pair=KeyPair.from_private_key(to_int(account_private_key)),
        chain=StarknetChainId.SEPOLIA,
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


def complete_fee(incomplete: str):
    tokens = ["eth", "strk"]
    return [token for token in tokens if token.startswith(incomplete)]


def get_voyager_network_prefix(network: Network) -> str:
    return "" if network == Network.MAINNET else "sepolia."


def voyager_link_tx(network: Network, tx_hash: int) -> str:
    voyager_prefix = get_voyager_network_prefix(network)
    return f"https://{voyager_prefix}voyager.online/tx/{hex(tx_hash)}"


def voyager_link_class(network: Network, class_hash: int) -> str:
    voyager_prefix = get_voyager_network_prefix(network)
    return f"https://{voyager_prefix}voyager.online/class/{hex(class_hash)}"
