import asyncio
from pathlib import Path
from typing import Annotated

import rich
import typer
from dotenv import load_dotenv
from starknet_py.contract import Contract
from starknet_py.hash.address import compute_address
from starknet_py.hash.utils import pedersen_hash

from garaga.hints.io import to_hex_str, to_int
from garaga.starknet.cli.utils import Network, get_contract_if_exists, load_account

# Mainnet/Sepolia deployer address
DEPLOYER_ADDRESS = 0x41A78E741E5AF2FEC34B695679BC6891742439F7AFB8484ECD7766661AD02BF

app = typer.Typer()


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
    fee: Annotated[
        str,
        typer.Option(
            help="Fee token type [eth, strk]",
            case_sensitive=False,
        ),
    ] = "strk",
):
    """Deploy an instance of a smart contract class hash to Starknet. Obtain its address, the available endpoints and a explorer link."""

    if Path(env_file).exists():
        load_dotenv(env_file)
    else:
        raise FileNotFoundError(f"Environment file {env_file} does not exist")

    account = load_account(network)

    class_hash = to_hex_str(class_hash)

    # Deploy the groth16 contract
    precomputed_address = compute_address(
        class_hash=to_int(class_hash),
        constructor_calldata=[],
        salt=pedersen_hash(to_int(account.address), 1),
        deployer_address=DEPLOYER_ADDRESS,
    )

    try_contract = get_contract_if_exists(account, precomputed_address)
    if try_contract is None:
        try:
            if fee.lower() == "eth":
                deploy_result = asyncio.run(
                    Contract.deploy_contract_v1(
                        account=account,
                        class_hash=class_hash,
                        deployer_address=DEPLOYER_ADDRESS,
                        auto_estimate=True,
                        salt=1,
                        cairo_version=1,
                        abi=[],
                    )
                )
            elif fee.lower() == "strk":
                deploy_result = asyncio.run(
                    Contract.deploy_contract_v3(
                        account=account,
                        class_hash=class_hash,
                        deployer_address=DEPLOYER_ADDRESS,
                        auto_estimate=True,
                        salt=1,
                        cairo_version=1,
                    )
                )
            else:
                raise ValueError(f"Invalid fee type: {fee}, must be 'eth' or 'strk'")

            asyncio.run(deploy_result.wait_for_acceptance())
            contract = deploy_result.deployed_contract

        except Exception as e:
            rich.print(f"[bold red]Error during deployment: {e}[/bold red]")
    else:
        rich.print(f"Contract already deployed at {hex(precomputed_address)}")
        contract = try_contract

    sepolia_prefix = "" if network == Network.MAINNET else "sepolia."
    rich.print(f"Contract address deployed on {network.name}: {hex(contract.address)}")
    rich.print(
        f"Check it out on https://{sepolia_prefix}voyager.online/contract/{hex(contract.address)}"
    )
    rich.print(f"Contract available endpoints: {list(contract.functions.keys())}")
