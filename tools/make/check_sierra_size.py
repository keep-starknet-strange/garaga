import json

data = json.load(
    open("src/cairo/target/dev/garaga_contracts_Garaga.contract_class.json")
)

print(len(data["sierra_program"]))
