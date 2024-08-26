from pathlib import Path
from typing import Annotated

import typer
from rich import print
from rich.progress import Progress, SpinnerColumn, TextColumn
from rich.tree import Tree

from garaga.definitions import ProofSystem
from garaga.starknet.cli.utils import complete_proof_system
from garaga.starknet.groth16_contract_generator.generator import (
    ECIP_OPS_CLASS_HASH,
    Groth16VerifyingKey,
    gen_groth16_verifier,
)


def gen(
    system: Annotated[
        ProofSystem,
        typer.Option(help="Proof system", autocompletion=complete_proof_system),
    ],
    vk: Annotated[
        Path,
        typer.Option(
            help="Path to the verification key JSON file",
            file_okay=True,
            dir_okay=False,
            exists=True,
            autocompletion=lambda: [],  # See https://github.com/fastapi/typer/discussions/731
        ),
    ],
    project_name: Annotated[
        str,
        typer.Option(
            help="The verifer name (used for the folder name, scarb project name, and contract name)",
            prompt="\033[1;35mPlease enter the name of your project. Press enter for default name.\033[0m",
            default_factory=lambda: "my_project",
        ),
    ],
):
    """
    Generate a Cairo verifier for a given proof system.
    Automatically detects the curve from the verification key.
    """
    verifying_key = Groth16VerifyingKey.from_json(vk)
    print(
        f"[bold cyan]Detected curve: [bold yellow]{verifying_key.curve_id}[/bold yellow][/bold cyan]"
    )

    cwd = Path.cwd()
    with Progress(
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        transient=False,
    ) as progress:
        progress.add_task(
            f"[bold cyan]Generating Smart Contract project for [bold yellow]{system}[/bold yellow] using [bold yellow]{Path(vk).name}[/bold yellow]...[/bold cyan]",
            total=None,
        )
        gen_groth16_verifier(
            vk=verifying_key,
            output_folder_path=cwd,
            output_folder_name=project_name,
            ecip_class_hash=ECIP_OPS_CLASS_HASH,
            cli_mode=True,
        )

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
        "[bold]You can now modify the [bold yellow]groth16_verifier.cairo[/bold yellow] file to adapt the verifier to your use case.[/bold]"
    )
