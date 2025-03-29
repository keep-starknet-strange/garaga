from typing import Optional

import typer

from garaga.starknet.cli.declare import declare
from garaga.starknet.cli.deploy import deploy
from garaga.starknet.cli.gen import gen
from garaga.starknet.cli.utils import get_package_version
from garaga.starknet.cli.verify import calldata, verify_onchain


def version_callback(value: bool):
    if value:
        print(f"garaga version: {get_package_version()}")
        raise typer.Exit()


app = typer.Typer(
    no_args_is_help=True,  # Show help when no arguments are provided
    context_settings={"help_option_names": ["-h", "--help"]},
)


# Add version option that will be processed first
@app.callback(invoke_without_command=True)
def main(
    version: Optional[bool] = typer.Option(
        None,
        "--version",
        callback=version_callback,
        is_eager=True,
        help="Show the version and exit.",
    ),
):
    pass


app.command(no_args_is_help=True)(gen)
app.command(no_args_is_help=True)(declare)
app.command(no_args_is_help=True)(deploy)
app.command(no_args_is_help=True)(verify_onchain)
app.command(no_args_is_help=True)(calldata)


if __name__ == "__main__":
    app()
