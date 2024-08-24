import typer
from rich import print
from typing_extensions import Annotated

from garaga.starknet.cli.declare import declare_project
from garaga.starknet.cli.deploy import deploy_project
from garaga.starknet.cli.gen import gen
from garaga.starknet.cli.verify import verify_onchain

app = typer.Typer(
    no_args_is_help=True,  # Show help when no arguments are provided
    context_settings={"help_option_names": ["-h", "--help"]},
)

app.command(no_args_is_help=True)(gen)
app.command(no_args_is_help=True)(declare_project)
app.command(no_args_is_help=True)(deploy_project)
app.command(no_args_is_help=True)(verify_onchain)


@app.command()
def hi(name: Annotated[str, typer.Argument()]):
    """Say hello to someone"""
    print(f"Hello {name}")


if __name__ == "__main__":

    app()
