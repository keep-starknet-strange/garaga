rm -rf src/src/tests/
rm -rf src/src/circuits/
rm -rf src/contracts/groth16_example_bls12_381
rm -rf src/contracts/groth16_example_bn254

python hydra/garaga/precompiled_circuits/all_circuits.py
python hydra/garaga/starknet/tests_and_calldata_generators/test_writer.py
python hydra/garaga/starknet/groth16_contract_generator/generator.py
