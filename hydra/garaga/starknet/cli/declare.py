import typer

app = typer.Typer()


@app.command()
def declare_project(project_name: str):
    """Declare your smart contract to Starknet"""
    print(f"Declaring project {project_name}")
