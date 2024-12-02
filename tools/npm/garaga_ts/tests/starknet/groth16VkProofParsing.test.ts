import {  parseGroth16ProofFromJson, parseGroth16VerifyingKeyFromJson } from "../../src/node/starknet/groth16ContractGenerator/parsingUtils";

const PATH = '../../../hydra/garaga/starknet/groth16_contract_generator/examples';

describe('Groth16 Parsing Tests', () => {
  const vkPaths = [
    `${PATH}/snarkjs_vk_bn254.json`,
    `${PATH}/snarkjs_vk_bls12381.json`,
    `${PATH}/vk_bn254.json`,
    `${PATH}/vk_bls.json`,
    `${PATH}/gnark_vk_bn254.json`,
    `${PATH}/vk_risc0.json`,
  ];

  test.each(vkPaths)('should parse vk from %s', (vkPath) => {
    const vk = parseGroth16VerifyingKeyFromJson(vkPath);
    console.log(vk);
  });



  const proofPaths = [
    `${PATH}/proof_bn254.json`,
    `${PATH}/proof_bls.json`
  ];

  test.each(proofPaths)('should parse proof from %s', (proofPath) => {
    const proof = parseGroth16ProofFromJson(proofPath);
    console.log(proof);
  });

  const proofWithPublicInput = [
    [`${PATH}/snarkjs_proof_bn254.json`, `${PATH}/snarkjs_public_bn254.json`],
    [`${PATH}/snarkjs_proof_bls12381.json`, `${PATH}/snarkjs_public_bls12381.json`],
    [`${PATH}/gnark_proof_bn254.json`, `${PATH}/gnark_public_bn254.json`],
  ];

  test.each(proofWithPublicInput)(
    'should parse proof with public inputs from %s and %s',
    (proofPath, pubInputsPath) => {
      const proof = parseGroth16ProofFromJson(proofPath, pubInputsPath);
      console.log(proof);
    }
  );
});
