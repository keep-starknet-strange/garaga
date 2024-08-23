import asyncio
import os
from pathlib import Path
from typing import Annotated

import rich
import typer
from dotenv import load_dotenv
from starknet_py.net.account.account import Account
from starknet_py.net.full_node_client import FullNodeClient
from starknet_py.net.models import StarknetChainId
from starknet_py.net.signer.stark_curve_signer import KeyPair

from garaga.hints.io import to_int
from garaga.starknet.cli.smart_contract_project import Groth16SmartContract

app = typer.Typer()

from enum import Enum


class Network(Enum):
    SEPOLIA = "sepolia"
    MAINNET = "mainnet"


def declare_project(
    project_path: Annotated[
        Path,
        typer.Option(
            help="Path to the Cairo project holding the Scarb.toml file to declare",
            file_okay=False,
            dir_okay=True,
            exists=True,
            autocompletion=lambda: [],
        ),
    ] = Path.cwd(),
    vk: Annotated[
        Path,
        typer.Option(
            help="Path to the verification key JSON file",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],
        ),
    ] = Path.cwd()
    / "vk.json",
    env_file: Annotated[
        Path,
        typer.Option(
            help="Path to the environment file",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],
        ),
    ] = str(Path.cwd() / ".secrets"),
    network: Annotated[
        Network,
        typer.Option(
            help="Starknet network",
            case_sensitive=False,
        ),
    ] = Network.SEPOLIA.value,
):
    """Declare your smart contract to Starknet"""

    if Path(env_file).exists():
        load_dotenv(env_file)
    else:
        raise FileNotFoundError(f"Environment file {env_file} does not exist")

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

    rich.print(f"[blue]Declaring project {project_path}")
    project = Groth16SmartContract(project_path, vk)

    try:
        class_hash, _ = asyncio.run(project.declare_class_hash(account))
        rich.print(
            f"[bold green]Class hash: {hex(class_hash)} [/bold green] is available on [bold]{network.name}[/bold]"
        )
    except Exception as e:
        rich.print(f"[bold red]Error during declaration: {e}[/bold red]")
