cd src/cairo/contracts/groth16_example
scarb build
bytecode_length=$(jq '.bytecode | length' ./target/dev/groth16_example_Groth16VerifierBN254.compiled_contract_class.json)
echo "Bytecode length: $bytecode_length"
