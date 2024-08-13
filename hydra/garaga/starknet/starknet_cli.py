import os
import re
from enum import Enum
from pathlib import Path
from typing import Optional

import typer

from garaga.definitions import CurveID

app = typer.Typer()


from garaga.definitions import ProofSystem


def create_directory(path: str):
    if not os.path.exists(path):
        os.makedirs(path)
        print(f"Directory created: {path}")


@app.command()
def gen(
    system: ProofSystem = typer.Option(..., help="Proof system"),
    vk: Path = typer.Option(..., help="Path to the verification key JSON file"),
    curve_id: int = typer.Option(..., help="Curve ID (0 for BN254, 1 for BLS12_381)"),
):
    """Generate a Cairo verifier"""
    print(type(curve_id))
    proving_curve = CurveID.get_proving_system_curve(curve_id, system)
    typer.echo(f"Generating Cairo verifier for system: {system}")
    typer.echo(f"Using verification key from: {vk}")
    typer.echo(f"Using curve: {proving_curve.name}")


@app.command()
def hi(name: str):
    print(f"Hello {name}")


if __name__ == "__main__":
    app()
