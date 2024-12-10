import asyncio
from enum import Enum
from pathlib import Path
from typing import Annotated

import rich
import typer
from dotenv import load_dotenv
from starknet_py.contract import (
    ContractFunction,
    InvokeResult,
    PreparedFunctionInvokeV1,
    PreparedFunctionInvokeV3,
)

from garaga.definitions import ProofSystem
from garaga.hints.io import to_int
from garaga.starknet.cli.utils import (
    Network,
    complete_fee,
    complete_proof_system,
    get_contract_iff_exists,
    load_account,
    voyager_link_tx,
)
from garaga.starknet.groth16_contract_generator.calldata import (
    groth16_calldata_from_vk_and_proof,
)
from garaga.starknet.groth16_contract_generator.parsing_utils import (
    Groth16Proof,
    Groth16VerifyingKey,
    find_item_from_key_patterns,
)
from garaga.starknet.honk_contract_generator.calldata import (
    HonkProof,
    HonkVk,
    get_ultra_keccak_honk_calldata_from_vk_and_proof,
)

app = typer.Typer()


def verify_onchain(
    system: Annotated[
        ProofSystem,
        typer.Option(help="Proof system", autocompletion=complete_proof_system),
    ],
    contract_address: Annotated[
        str,
        typer.Option(
            help="Starknet contract address",
        ),
    ],
    vk: Annotated[
        Path,
        typer.Option(
            help="Path to the verification key JSON file",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],
        ),
    ],
    proof: Annotated[
        Path,
        typer.Option(
            help="Path to the proof JSON file",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],
        ),
    ],
    public_inputs: Annotated[
        Path,
        typer.Option(
            help="Path to the public inputs JSON file",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],
        ),
    ] = None,
    endpoint: Annotated[
        str,
        typer.Option(
            help="Smart contract function name. If not provided, the default 'verify_[proof_system]_proof_[curve_name]' will be used.",
        ),
    ] = "",
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
            autocompletion=complete_fee,
        ),
    ] = "eth",
):
    """Invoke a SNARK verifier on Starknet given a contract address, a proof and a verification key."""

    load_dotenv(env_file)
    account = load_account(network)

    contract = get_contract_iff_exists(account, to_int(contract_address))

    try:
        function_call: ContractFunction = find_item_from_key_patterns(
            contract.functions, ["verify"]
        )
    except ValueError:
        rich.print(
            f"[red]Function {endpoint} not found on contract {contract_address}[/red]"
        )
        raise ValueError(
            f"Function {endpoint} not found on contract {contract_address}"
        )

    if public_inputs == "":
        public_inputs = None

    calldata = get_calldata_generic(system, vk, proof, public_inputs)

    if "eth" in fee.lower():
        prepare_invoke = PreparedFunctionInvokeV1(
            to_addr=function_call.contract_data.address,
            calldata=calldata,
            selector=function_call.get_selector(function_call.name),
            max_fee=None,
            _contract_data=function_call.contract_data,
            _client=function_call.client,
            _account=function_call.account,
            _payload_transformer=function_call._payload_transformer,
        )
    elif "strk" in fee.lower():
        prepare_invoke = PreparedFunctionInvokeV3(
            to_addr=function_call.contract_data.address,
            calldata=calldata,
            selector=function_call.get_selector(function_call.name),
            l1_resource_bounds=None,
            _contract_data=function_call.contract_data,
            _client=function_call.client,
            _account=function_call.account,
            _payload_transformer=function_call._payload_transformer,
        )

    invoke_result: InvokeResult = asyncio.run(prepare_invoke.invoke(auto_estimate=True))

    asyncio.run(invoke_result.wait_for_acceptance())

    rich.print(f"[bold]Transaction hash : {hex(invoke_result.hash)}[/bold]")
    rich.print(
        f"[bold green]Check it out on[/bold green] {voyager_link_tx(network, invoke_result.hash)}"
    )


class CalldataFormat(str, Enum):
    starkli = "starkli"
    array = "array"


def get_calldata_generic(
    system: ProofSystem, vk: Path, proof: Path, public_inputs: Path | None
) -> list[int]:
    match system:
        case ProofSystem.Groth16:
            vk_obj = Groth16VerifyingKey.from_json(vk)
            proof_obj = Groth16Proof.from_json(proof, public_inputs)
            return groth16_calldata_from_vk_and_proof(vk, proof)
        case ProofSystem.UltraKeccakHonk:
            vk_obj = HonkVk.from_bytes(open(vk, "rb").read())
            proof_obj = HonkProof.from_bytes(open(proof, "rb").read())
            return get_ultra_keccak_honk_calldata_from_vk_and_proof(vk_obj, proof_obj)
        case _:
            raise ValueError(f"Proof system {system} not supported")


def calldata(
    system: Annotated[
        ProofSystem,
        typer.Option(help="Proof system", autocompletion=complete_proof_system),
    ],
    vk: Annotated[
        Path,
        typer.Option(
            help="Path to the verification key file",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],
        ),
    ],
    proof: Annotated[
        Path,
        typer.Option(
            help="Path to the proof file",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],
        ),
    ],
    public_inputs: Annotated[
        Path,
        typer.Option(
            help="Path to the public inputs file. Optional, only used for Groth16 when pub inputs are not in the json proof (ex: SnarkJS)",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],
        ),
    ] = None,
    format: Annotated[
        CalldataFormat,
        typer.Option(
            help="Format",
            case_sensitive=False,
            show_choices=True,
        ),
    ] = CalldataFormat.starkli,
):
    """Generate Starknet verifier calldata given a proof and a verification key."""

    calldata = get_calldata_generic(system, vk, proof, public_inputs)

    if format == CalldataFormat.starkli:
        print(" ".join([str(x) for x in calldata]))
    elif format == CalldataFormat.array:
        print(calldata[1:])
