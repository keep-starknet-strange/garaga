rm -rf src/src/tests/*
rm -rf src/src/circuits/*
rm -rf src/contracts/groth16_example_bls12_381/*
rm -rf src/contracts/groth16_example_bn254/*
rm -rf src/contracts/risc0_verifier_bn254/*
rm -rf src/contracts/noir_ultra_keccak_honk_example/*

set -e  # Exit immediately if a command exits with a non-zero status

python hydra/garaga/starknet/honk_contract_generator/generator_honk.py || { echo "Error in generator_honk.py"; exit 1; }
python hydra/garaga/precompiled_circuits/all_circuits.py || { echo "Error in all_circuits.py"; exit 1; }
python hydra/garaga/starknet/tests_and_calldata_generators/test_writer.py || { echo "Error in test_writer.py"; exit 1; }
python hydra/garaga/starknet/groth16_contract_generator/generator.py || { echo "Error in generator.py"; exit 1; }
python hydra/garaga/starknet/groth16_contract_generator/generator_risc0.py || { echo "Error in generator_risc0.py"; exit 1; }
