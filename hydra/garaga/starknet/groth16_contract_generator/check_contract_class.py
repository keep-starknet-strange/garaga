import json


def check_contract_class(path: str) -> bool:
    with open(path, "r") as f:
        contract_class = json.load(f)
    print(len(contract_class["sierra_program"]))
    return True


if __name__ == "__main__":
    check_contract_class(
        "src/cairo/target/dev/garaga_contracts_Groth16VerifierBN254.contract_class.json"
    )
