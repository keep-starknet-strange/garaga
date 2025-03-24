#!/bin/bash

cd src/contracts
echo "----------------------------------------"

# Function to build and check bytecode length
check_bytecode_length() {
    local contract_dir=$1

    cd $contract_dir
    scarb build
    # Find the compiled contract class JSON file
    compiled_file=$(find ./target/dev -name '*.compiled_contract_class.json' -print -quit)
    if [[ -f $compiled_file ]]; then
        bytecode_length=$(jq '.bytecode | length' "$compiled_file")

        # Color the output: use green for the bytecode length line
        echo -e "\e[32mBytecode length [$contract_dir] = $bytecode_length\e[0m"
        echo "----------------------------------------"
    else
        echo "Compiled contract class JSON not found in $contract_dir"
        echo "----------------------------------------"
    fi
    cd ../
}

# List of contract directories
contracts=(
    "groth16_example_bn254"
    "groth16_example_bls12_381"
    "noir_ultra_keccak_honk_example"
    "noir_ultra_keccak_zk_honk_example"
    "noir_ultra_starknet_honk_example"
    "noir_ultra_starknet_zk_honk_example"
    "universal_ecip"
    "drand_quicknet"
    "risc0_verifier_bn254"
)

# Number of CPUs to use
n_cpus=4

# Export the function for parallel
export -f check_bytecode_length

# Use parallel to run the function
parallel -j $n_cpus check_bytecode_length ::: "${contracts[@]}"
