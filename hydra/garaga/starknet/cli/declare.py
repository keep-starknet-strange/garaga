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
from garaga.starknet.cli.smart_contract_project import SmartContractProject
from garaga.starknet.cli.utils import Network, voyager_link_class

app = typer.Typer()


def declare(
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
    """Declare your smart contract to Starknet. Obtain its class hash and a explorer link."""

    if Path(env_file).exists():
        load_dotenv(env_file)
    else:
        raise FileNotFoundError(f"Environment file {env_file} does not exist")

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

    rich.print(
        f"Declaring project [bold cyan] {project_path}[/bold cyan] on [bold]{network.name}[/bold]"
    )
    project = SmartContractProject(project_path)

    try:
        class_hash, _ = asyncio.run(project.declare_class_hash(account=account))
        rich.print(
            f"[bold green]Class hash: {hex(class_hash)} [/bold green] is available on [bold]{network.name}[/bold]"
        )
        rich.print(
            f"[bold green]Check it out on[/bold green] {voyager_link_class(network, class_hash)}"
        )
    except Exception as e:
        rich.print(f"[bold red]Error during declaration: {e}[/bold red]")
