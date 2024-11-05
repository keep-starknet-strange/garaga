import asyncio
import os
from enum import Enum
from pathlib import Path

import dotenv
from starknet_py.net.account.account import Account
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.models import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair

from garaga.hints.io import to_int
from garaga.starknet.cli.smart_contract_project import SmartContractProject

dotenv.load_dotenv(".secrets")


class Network(Enum):
    SEPOLIA = "sepolia"
    MAINNET = "mainnet"

    def to_starknet_chain_id(self):
        if self == Network.SEPOLIA:
            return StarknetChainId.SEPOLIA
        elif self == Network.MAINNET:
            return StarknetChainId.MAINNET
        else:
            raise ValueError(f"Unknown network: {self}")


class Fee(Enum):
    ETH = "eth"
    STRK = "strk"


def get_account(network: Network):
    rpc_url = os.getenv(f"{network.value.upper()}_RPC_URL")
    account_address = os.getenv(f"{network.value.upper()}_ACCOUNT_ADDRESS")
    account_private_key = os.getenv(f"{network.value.upper()}_ACCOUNT_PRIVATE_KEY")

    client = FullNodeClient(node_url=rpc_url)
    account = Account(
        address=account_address,
        client=client,
        key_pair=KeyPair.from_private_key(to_int(account_private_key)),
        chain=network.to_starknet_chain_id(),
    )
    return account


async def declare_contract_from_path(path: Path, network: Network, fee: Fee):
    contract = SmartContractProject(smart_contract_folder=path)
    account = get_account(network)
    await contract.declare_class_hash(account=account, fee=fee.value)


async def declare_contract_from_path_both_networks(path: Path, fee: Fee):
    await declare_contract_from_path(path, Network.SEPOLIA, fee)
    await declare_contract_from_path(path, Network.MAINNET, fee)


if __name__ == "__main__":
    asyncio.run(
        declare_contract_from_path_both_networks(
            Path("src/contracts/universal_ecip"), Fee.STRK
        )
    )
    asyncio.run(
        declare_contract_from_path_both_networks(
            Path("src/contracts/drand_quicknet"), Fee.STRK
        )
    )

    asyncio.run(
        declare_contract_from_path_both_networks(
            Path("src/contracts/risc0_verifier_bn254"), Fee.STRK
        )
    )
