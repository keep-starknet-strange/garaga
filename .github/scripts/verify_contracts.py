import ast
import asyncio
import sys
from enum import Enum
from pathlib import Path

from starknet_py.net.full_node_client import FullNodeClient

import garaga.hints.io as io
from garaga.starknet.cli.smart_contract_project import SmartContractProject


class Network(Enum):
    SEPOLIA = "sepolia"
    MAINNET = "mainnet"


def get_class_hash_from_generator():
    try:
        with open(
            "hydra/garaga/starknet/groth16_contract_generator/generator.py", "r"
        ) as f:
            tree = ast.parse(f.read())
            for node in ast.walk(tree):
                if isinstance(node, ast.Assign) and len(node.targets) == 1:
                    if getattr(node.targets[0], "id", None) == "ECIP_OPS_CLASS_HASH":
                        return hex(node.value.value)
        raise ValueError("ECIP_OPS_CLASS_HASH not found in generator.py")
    except Exception as e:
        print(f"Error parsing generator.py: {str(e)}", file=sys.stderr)
        sys.exit(1)


async def verify_network(network: Network, class_hash: str):
    class_hash = io.to_hex_str(class_hash)
    print(f"\nVerifying class hash {class_hash} on {network.value}...")
    client = FullNodeClient(f"https://free-rpc.nethermind.io/{network.value}-juno")
    try:
        result = await client.get_class_by_hash(class_hash)
        if not result:
            print(f"Error: Contract not declared on {network.value}", file=sys.stderr)
            sys.exit(1)
        print(f"✓ Contract verified on {network.value}")
    except Exception as e:
        print(f"Error checking {network.value}: {str(e)}", file=sys.stderr)
        sys.exit(1)


async def verify_ecip_contract():
    class_hash = get_class_hash_from_generator()
    print(f"Verifying ECIP contract using class hash: {class_hash}")

    await verify_network(Network.SEPOLIA, class_hash)
    await verify_network(Network.MAINNET, class_hash)

    print("\n✓ Contract verified on both networks")


async def verify_contract_from_path(path: Path):
    contract = SmartContractProject(smart_contract_folder=path)
    class_hash = contract.get_sierra_class_hash()
    print(f"Verifying contract {path} with class hash {io.to_hex_str(class_hash)}")
    await verify_network(Network.SEPOLIA, class_hash)
    await verify_network(Network.MAINNET, class_hash)


if __name__ == "__main__":
    asyncio.run(verify_ecip_contract())
    asyncio.run(verify_contract_from_path(Path("src/contracts/drand_quicknet")))
    asyncio.run(verify_contract_from_path(Path("src/contracts/risc0_verifier_bn254")))
