import { parseGroth16ProofFromJson, parseGroth16VerifyingKeyFromJson } from "../../src/node/starknet/groth16ContractGenerator/parsingUtils.js";
import { describe, test } from 'node:test';

const PATH = '../../../hydra/garaga/starknet/groth16_contract_generator/examples';

describe('Groth16 Parsing Tests', () => {
  const vkPaths = [
    `${PATH}/snarkjs_vk_bn254.json`,
    `${PATH}/snarkjs_vk_bls12381.json`,
    `${PATH}/vk_bn254.json`,
    `${PATH}/vk_bls.json`,
    `${PATH}/gnark_vk_bn254.json`,
    `${PATH}/vk_risc0.json`,
    `${PATH}/vk_sp1.json`,
  ];

  for (const vkPath of vkPaths) {
    test(`should parse vk from ${vkPath}`, () => {
      parseGroth16VerifyingKeyFromJson(vkPath);
    });
  }

  const proofPaths = [
    `${PATH}/proof_bn254.json`,
    `${PATH}/proof_bls.json`,
    `${PATH}/proof_risc0.json`,
    `${PATH}/proof_sp1.json`,
  ];

  for (const proofPath of proofPaths) {
    test(`should parse proof from ${proofPath}`, () => {
      parseGroth16ProofFromJson(proofPath);
    });
  }

  const proofWithPublicInput = [
    [`${PATH}/snarkjs_proof_bn254.json`, `${PATH}/snarkjs_public_bn254.json`],
    [`${PATH}/snarkjs_proof_bls12381.json`, `${PATH}/snarkjs_public_bls12381.json`],
    [`${PATH}/gnark_proof_bn254.json`, `${PATH}/gnark_public_bn254.json`],
  ] as const;

  for (const [proofPath, publicInputsPath] of proofWithPublicInput) {
    test(`should parse proof with public inputs from ${proofPath} and ${publicInputsPath}`, () => {
      parseGroth16ProofFromJson(proofPath, publicInputsPath);
    });
  }
});
