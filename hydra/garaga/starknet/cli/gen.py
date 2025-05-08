import subprocess
from pathlib import Path
from typing import Annotated

import typer
from rich import print
from rich.console import Console
from rich.panel import Panel
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.tree import Tree

from garaga.definitions import ProofSystem
from garaga.starknet.cli.utils import (
    complete_proof_system,
    get_default_vk_path,
    get_package_version,
)
from garaga.starknet.groth16_contract_generator.generator import (
    ECIP_OPS_CLASS_HASH,
    gen_groth16_verifier,
)
from garaga.starknet.honk_contract_generator.generator_honk import (
    BB_VERSION,
    BBUP_VERSION,
    NARGO_VERSION,
    gen_honk_verifier,
)


def check_nargo_version(version: str) -> tuple[bool, str]:
    return check_version("nargo", version)


def check_bb_version(version: str) -> tuple[bool, str]:
    return check_version("bb", version)


def check_version(cmd: str, version: str) -> tuple[bool, str]:
    result = subprocess.run(
        [cmd, "--version"], capture_output=True, text=True, check=True
    )
    result_version = result.stdout.strip()
    return (
        result.returncode == 0 and version in result_version,
        result_version,
    )


def _get_bb_oracle_hash_options() -> list[str]:
    """Get the available oracle hash options from bb command"""
    result_hash = subprocess.run(
        ["bb", "prove", "-h"], capture_output=True, text=True, check=True
    )
    # Extract oracle hash options
    oracle_hash_options = []
    lines = result_hash.stdout.splitlines()
    for i, line in enumerate(lines):
        if "--oracle_hash" in line:
            # Look in the next few lines for the options
            for j in range(i + 1, min(i + 100, len(lines))):
                if "Options: {" in lines[j]:
                    options_str = lines[j].split("{")[1].split("}")[0]
                    oracle_hash_options = [
                        opt.strip() for opt in options_str.split(",")
                    ]
                    break
            break

    return oracle_hash_options


def check_bb_starknet_support(
    version: str, with_starknet: bool = False
) -> tuple[bool, str, bool]:
    """Check if bb supports starknet and meets the version requirement"""
    version_ok, version_str = check_bb_version(version)
    oracle_options = _get_bb_oracle_hash_options()
    has_starknet = "starknet" in oracle_options
    if with_starknet:
        return (version_ok and has_starknet, version_str, has_starknet)
    else:
        return (version_ok, version_str, has_starknet)


def print_bb_warning(soft: bool = False, with_starknet: bool = False):
    bb_version_ok, bb_version, has_starknet = check_bb_starknet_support(
        BB_VERSION, with_starknet
    )
    nargo_version_ok, nargo_version = check_version("nargo", NARGO_VERSION)
    if not bb_version_ok or not nargo_version_ok:
        console = Console()
        console.print(
            Panel(
                f"[bold]Detected versions of bb and nargo are not compatible with the required versions by garaga {get_package_version()}.[/bold]\n"
                + (f"This is the most likely cause of the error." if not soft else f""),
                title="[bold red]Warning[/bold red]",
                border_style="red",
            )
        )
        console.print(
            f"Detected bb version: [bold red]{bb_version}[/bold red] with support for starknet optimized oracle hash: [bold red]{has_starknet}[/bold red]\n"
            f"Detected nargo version: [bold red]{nargo_version}[/bold red]"
        )
        console.print(
            Panel(
                "[bold]Please ensure you have the expected versions of bb and nargo installed for garaga to work correctly.[/bold]\n"
                + "You can install the required versions using the following commands:\n"
                + f"[bold yellow]bbup --version {BBUP_VERSION}[/bold yellow]\n"
                + f"[bold yellow]noirup --version {NARGO_VERSION}[/bold yellow]\n"
                + (
                    f"Check [blue]https://noir-lang.org/docs/getting_started/quick_start[/blue] for more information.\n"
                    if not soft
                    else ""
                )
                + f"Please ensure the verifying key was generated with the correct versions of bb and nargo before generating the verifier.",
                border_style="yellow",
                title="[bold yellow]Fixing the issue[/bold yellow]",
            )
        )
    else:
        print(
            f"The detected versions of bb and nargo are correctly aligned with garaga {get_package_version()}. "
        )


def gen(
    system: Annotated[
        ProofSystem,
        typer.Option(help="Proof system", autocompletion=complete_proof_system),
    ],
    project_name: Annotated[
        str,
        typer.Option(
            help="The verifer name (used for the folder name, scarb project name, and contract name)",
            prompt="\033[1;35mPlease enter the name of your project. Press enter for default name.\033[0m",
            default_factory=lambda: "my_project",
        ),
    ],
    vk: Annotated[
        Path,
        typer.Option(
            help="Path to the verification key file. Expects a JSON for groth16, binary format for Honk. Must be provided, except when the system supports an universal key (ex: Risc0)",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],  # See https://github.com/fastapi/typer/discussions/731
        ),
    ] = None,
):
    """
    Generate a Cairo verifier for a given proof system.
    Automatically detects the curve from the verification key.
    """
    cwd = Path.cwd()
    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        transient=False,
        console=Console(color_system="truecolor"),
    ) as progress:
        progress.add_task(
            f"[bold cyan]Generating Smart Contract project for [bold yellow]{system}[/bold yellow] using [bold yellow]{Path(vk).name}[/bold yellow]...[/bold cyan]",
            total=None,
        )
        if vk == None:
            vk = get_default_vk_path(system)
        match system:
            case ProofSystem.Groth16 | ProofSystem.Risc0Groth16:
                gen_groth16_verifier(
                    vk=vk,
                    output_folder_path=cwd,
                    output_folder_name=project_name,
                    ecip_class_hash=ECIP_OPS_CLASS_HASH,
                    cli_mode=True,
                )
            case (
                ProofSystem.UltraKeccakHonk
                | ProofSystem.UltraStarknetHonk
                | ProofSystem.UltraKeccakZKHonk
                | ProofSystem.UltraStarknetZKHonk
            ):
                try:
                    gen_honk_verifier(
                        vk=vk,
                        output_folder_path=cwd,
                        output_folder_name=project_name,
                        system=system,
                        cli_mode=True,
                    )
                except Exception as e:
                    import traceback

                    print(
                        f"\n[bold red]Error:[/bold red] An error occurred while generating the verifier: \n{traceback.format_exc()}"
                    )
                    print_bb_warning(
                        with_starknet=system == ProofSystem.UltraStarknetHonk
                        or system == ProofSystem.UltraStarknetZKHonk
                    )

                    raise typer.Exit(code=1)

            case _:
                raise ValueError(f"Unsupported proof system: {system}")

    print("[bold green]Done![/bold green]")
    print("[bold cyan]Smart Contract project created:[/bold cyan]")

    def generate_tree(path: Path, tree: Tree) -> None:
        for entry in sorted(path.iterdir(), key=lambda e: e.name):
            if entry.is_dir():
                branch = tree.add(f"[bold blue]{entry.name}/[/bold blue]")
                generate_tree(entry, branch)
            else:
                tree.add(f"[green]{entry.name}[/green]")

    root = Tree(f"[bold yellow]{cwd}/{project_name}/[/bold yellow]")
    generate_tree(cwd / project_name, root)
    print(root)

    print(
        f"[bold]You can now test the main endpoint of the verifier using a proof and `garaga calldata` command.[/bold]"
    )
    if system in [
        ProofSystem.UltraKeccakHonk,
        ProofSystem.UltraStarknetHonk,
        ProofSystem.UltraKeccakZKHonk,
        ProofSystem.UltraStarknetZKHonk,
    ]:
        if (
            system == ProofSystem.UltraStarknetHonk
            or system == ProofSystem.UltraStarknetZKHonk
        ):
            print_bb_warning(soft=True, with_starknet=True)
        else:
            print_bb_warning(soft=True)
