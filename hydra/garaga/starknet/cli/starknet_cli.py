import typer
from rich import print
from typing_extensions import Annotated

from garaga.starknet.cli.declare import declare_project
from garaga.starknet.cli.gen import gen

# curve_id: Annotated[
#     int,
#     typer.Option(
#         help="Curve ID (0 for BN254, 1 for BLS12_381)",
#         autocompletion=complete_pairing_curve_id,
#     ),
# ],


app = typer.Typer(
    no_args_is_help=True,  # Show help when no arguments are provided
    context_settings={"help_option_names": ["-h", "--help"]},
)

app.command(no_args_is_help=True)(gen)
app.command(no_args_is_help=True)(declare_project)


@app.command()
def hi(name: Annotated[str, typer.Argument()]):
    """Say hello to someone"""
    print(f"Hello {name}")


if __name__ == "__main__":

    app()
