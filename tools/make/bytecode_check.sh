#!/bin/bash
c1="bn254"
c2="bls12_381"



cd src/contracts/groth16_example_$c1
scarb build
bytecode_length=$(jq '.bytecode | length' ./target/dev/groth16_example_${c1}_Groth16Verifier${c1^^}.compiled_contract_class.json)
echo "Bytecode length BN254: $bytecode_length"

cd ../noir_ultra_keccak_honk_example
scarb build
bytecode_length=$(jq '.bytecode | length' ./target/dev/noir_ultra_keccak_honk_example_UltraKeccakHonkVerifier.compiled_contract_class.json)
echo "Bytecode length NOIR: $bytecode_length"


cd ../groth16_example_$c2
scarb build
bytecode_length=$(jq '.bytecode | length' ./target/dev/groth16_example_${c2}_Groth16Verifier${c2^^}.compiled_contract_class.json)
echo "Bytecode length BLS12_381: $bytecode_length"


cd ../universal_ecip
scarb build
bytecode_length=$(jq '.bytecode | length' ./target/dev/universal_ecip_UniversalECIP.compiled_contract_class.json)
echo "Bytecode length ECIP: $bytecode_length"

cd ../drand_quicknet
scarb build
bytecode_length=$(jq '.bytecode | length' ./target/dev/drand_quicknet_DrandQuicknet.compiled_contract_class.json)
echo "Bytecode length DRAND: $bytecode_length"


cd ../risc0_verifier_bn254
scarb build
bytecode_length=$(jq '.bytecode | length' ./target/dev/risc0_bn254_verifier_Risc0Groth16VerifierBN254.compiled_contract_class.json)
echo "Bytecode length RISC0: $bytecode_length"
