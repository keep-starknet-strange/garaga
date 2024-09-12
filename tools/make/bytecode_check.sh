#!/bin/bash
c="bn254"

cd src/contracts/groth16_example_$c
scarb build
bytecode_length=$(jq '.bytecode | length' ./target/dev/groth16_example_${c}_Groth16Verifier${c^^}.compiled_contract_class.json)
echo "Bytecode length BN254: $bytecode_length"

cd ../universal_ecip
scarb build
bytecode_length=$(jq '.bytecode | length' ./target/dev/universal_ecip_UniversalECIP.compiled_contract_class.json)
echo "Bytecode length ECIP: $bytecode_length"
scarb build
