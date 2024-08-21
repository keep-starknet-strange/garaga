import glob
import json
import os
import shutil
import subprocess


def scarb_build_contract_folder(contract_folder_path: str):
    cmd = "scarb build"
    print(f"Running command: {cmd} in directory: {contract_folder_path}")
    try:
        subprocess.run(
            cmd,
            cwd=contract_folder_path,
            check=True,
            shell=True,
            capture_output=True,
            text=True,
        )
    except subprocess.CalledProcessError as e:
        print(f"Error building contract: {e}")
        print(f"Command output:\n{e.output}")
        raise
    except FileNotFoundError as e:
        print(f"Error: {e}")
        raise
    except Exception as e:
        print(f"An unexpected error occurred: {e}")
        raise


def get_sierra_casm_artifacts(
    contract_folder_path: str,
) -> tuple[None, None] | tuple[str, str]:
    """
    Get the Sierra and CASM artifacts for a contract.
    """
    target_dir = os.path.join(contract_folder_path, "target/dev/")

    # Clean the target/dev/ folder if it already exists
    if os.path.exists(target_dir):
        shutil.rmtree(target_dir)
    os.makedirs(target_dir)

    scarb_build_contract_folder(contract_folder_path)

    artifacts_file = glob.glob(os.path.join(target_dir, "*.starknet_artifacts.json"))
    assert (
        len(artifacts_file) == 1
    ), "Artifacts JSON file not found or multiple files found."

    with open(artifacts_file[0], "r") as f:
        artifacts = json.load(f)

    contracts = artifacts["contracts"]
    if len(contracts) == 0:
        return None, None

    sierra_file = contracts[0]["artifacts"]["sierra"]
    casm_file = contracts[0]["artifacts"]["casm"]

    sierra_path = os.path.join(target_dir, sierra_file)
    casm_path = os.path.join(target_dir, casm_file)

    assert os.path.exists(sierra_path), f"Sierra file not found: {sierra_path}"
    assert os.path.exists(casm_path), f"CASM file not found: {casm_path}"

    with open(sierra_path, "r") as f:
        sierra = f.read()
    with open(casm_path, "r") as f:
        casm = f.read()
    return sierra, casm
