import os
import re
from enum import Enum
from pathlib import Path
from typing import Callable, Optional

import typer
from typing_extensions import Annotated

from garaga import PACKAGE_ROOT
from garaga.definitions import CurveID

app = typer.Typer(
    no_args_is_help=True,  # Show help when no arguments are provided
    context_settings={"help_option_names": ["-h", "--help"]},
)

from garaga.definitions import ProofSystem


def complete_curve_id(incomplete: str):
    curve_ids = ["0", "1"]  # Corresponding to BN254 and BLS12_381
    return [cid for cid in curve_ids if cid.startswith(incomplete)]


def create_directory(path: str):
    if not os.path.exists(path):
        os.makedirs(path)
        print(f"Directory created: {path}")


def complete_proof_system(incomplete: str):
    systems = [ps.value for ps in ProofSystem]
    return [system for system in systems if system.startswith(incomplete)]


def complete_curve_id(incomplete: str):
    curve_ids = ["0", "1"]  # Corresponding to BN254 and BLS12_381
    return [cid for cid in curve_ids if cid.startswith(incomplete)]


@app.command()
def gen(
    system: Annotated[
        ProofSystem,
        typer.Option(help="Proof system", autocompletion=complete_proof_system),
    ],
    vk: Annotated[
        Path,
        typer.Option(
            help="Path to the verification key JSON file",
            autocompletion=lambda: [],  # See https://github.com/fastapi/typer/discussions/731
        ),
    ],
    curve_id: Annotated[
        int,
        typer.Option(
            help="Curve ID (0 for BN254, 1 for BLS12_381)",
            autocompletion=complete_curve_id,
        ),
    ],
):
    """Generate a Cairo verifier"""
    proving_curve = CurveID.get_proving_system_curve(curve_id, system)
    typer.echo(f"Generating Cairo verifier for system: {system}")
    typer.echo(f"Using verification key from: {vk}")
    typer.echo(f"Using curve: {proving_curve.name}")


@app.command()
def hi(name: Annotated[str, typer.Argument()]):
    """Say hello to someone"""
    print(f"Hello {name}")


if __name__ == "__main__":

    app()
