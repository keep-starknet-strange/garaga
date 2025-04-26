import asyncio
from pathlib import Path
from typing import Annotated, Optional

import rich
import typer
from dotenv import load_dotenv
from starknet_py.contract import Contract
from starknet_py.hash.address import compute_address
from starknet_py.hash.utils import pedersen_hash

from garaga.hints.io import to_hex_str, to_int
from garaga.starknet.cli.utils import (
    Network,
    get_contract_if_exists,
    get_contract_if_exists_async,
    load_account,
)

# Mainnet/Sepolia deployer address
DEPLOYER_ADDRESS = 0x41A78E741E5AF2FEC34B695679BC6891742439F7AFB8484ECD7766661AD02BF

app = typer.Typer()


async def perform_contract_deployment(
    account, class_hash: str, salt: int, precomputed_address: int
) -> Optional[Contract]:
    """Attempt to deploy a contract with the given parameters."""
    try:
        deploy_result = await Contract.deploy_contract_v3(
            account=account,
            class_hash=class_hash,
            deployer_address=DEPLOYER_ADDRESS,
            auto_estimate=True,
            salt=salt,
            cairo_version=1,
        )
        deploy_result = await deploy_result.wait_for_acceptance()
        return deploy_result.deployed_contract
    except Exception as e:
        print("Waiting for transaction to be accepted...")
        await asyncio.sleep(5.5)
        contract = await get_contract_if_exists_async(account, precomputed_address)
        if contract:
            return contract
        else:
            rich.print(f"[bold red]Deployment error: {e}[/bold red]")
        return None


def print_contract_info(contract: Contract, network: Network):
    """Print information about the deployed contract."""
    sepolia_prefix = "" if network == Network.MAINNET else "sepolia."
    rich.print(f"Contract address on {network.name}: {hex(contract.address)}")
    rich.print(
        f"Voyager link: https://{sepolia_prefix}voyager.online/contract/{hex(contract.address)}"
    )
    rich.print(f"Available endpoints: {list(contract.functions.keys())}")


def deploy(
    class_hash: Annotated[
        str,
        typer.Option(
            help="Contract class hash to deploy. Can be decimal or hex string"
        ),
    ],
    env_file: Annotated[
        Path,
        typer.Option(
            help="Path to the environment file containing rpc, address, private_key",
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
    salt: Annotated[
        int,
        typer.Option(
            help="Salt value for contract address calculation (default: 1)",
        ),
    ] = 1,
):
    """Deploy an instance of a smart contract class hash to Starknet. Obtain its address, the available endpoints and a explorer link."""

    # Validate and load environment
    if not Path(env_file).exists():
        raise FileNotFoundError(f"Environment file {env_file} does not exist")
    load_dotenv(env_file)
    # Prepare account and compute address
    account = load_account(network)
    class_hash = to_hex_str(class_hash)

    precomputed_address = compute_address(
        class_hash=to_int(class_hash),
        constructor_calldata=[],
        salt=pedersen_hash(to_int(account.address), salt),
        deployer_address=DEPLOYER_ADDRESS,
    )

    # Check if contract already exists
    contract = get_contract_if_exists(account, precomputed_address)
    if contract:
        rich.print(
            f"[bold green]Contract already deployed at {hex(contract.address)}[/bold green]"
        )
        print_contract_info(contract, network)
        return

    # Perform deployment
    rich.print(f"Deploying contract with class hash {class_hash}...")
    contract = asyncio.run(
        perform_contract_deployment(account, class_hash, salt, precomputed_address)
    )

    # Handle deployment result
    if not contract:
        # Check if the contract exists despite the error (transaction might have completed)
        contract = get_contract_if_exists(account, precomputed_address)
        if contract:
            rich.print(
                f"[bold green]Contract found at {hex(contract.address)} despite deployment errors.[/bold green]"
            )
        else:
            rich.print(
                f"[bold yellow]Contract not deployed. Try running the command again - it might be a temporary network issue.[/bold yellow]"
            )
            return
    else:
        rich.print(
            f"[bold green]Contract successfully deployed at {hex(contract.address)}[/bold green]"
        )

    # Print contract information
    print_contract_info(contract, network)
