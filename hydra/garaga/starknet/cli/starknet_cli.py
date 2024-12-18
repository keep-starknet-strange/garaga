import typer

from garaga.starknet.cli.declare import declare
from garaga.starknet.cli.deploy import deploy
from garaga.starknet.cli.gen import gen
from garaga.starknet.cli.verify import calldata, verify_onchain

app = typer.Typer(
    no_args_is_help=True,  # Show help when no arguments are provided
    context_settings={"help_option_names": ["-h", "--help"]},
)

app.command(no_args_is_help=True)(gen)
app.command(no_args_is_help=True)(declare)
app.command(no_args_is_help=True)(deploy)
app.command(no_args_is_help=True)(verify_onchain)
app.command(no_args_is_help=True)(calldata)


if __name__ == "__main__":

    app()
