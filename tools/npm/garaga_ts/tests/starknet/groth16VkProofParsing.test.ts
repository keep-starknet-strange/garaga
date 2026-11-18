import assert from 'node:assert/strict';
import { readFileSync } from 'node:fs';
import { describe, test } from 'node:test';
import { parseGroth16ProofFromJson, parseGroth16ProofFromObject, parseGroth16VerifyingKeyFromJson } from "../../src/node/starknet/groth16ContractGenerator/parsingUtils.js";

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

  test('rejects a RISC Zero seal with an unsupported selector', () => {
    const receipt = JSON.parse(readFileSync(`${PATH}/proof_risc0.json`, 'utf8'));
    receipt.seal = '0x00000000' + receipt.seal.slice(10);
    assert.throws(() => parseGroth16ProofFromObject(receipt), /Unsupported RISC Zero Groth16 selector/);
  });

  test('preserves leading zero bytes in the RISC Zero journal', () => {
    const receipt = JSON.parse(readFileSync(`${PATH}/proof_risc0.json`, 'utf8'));
    receipt.journal = '0x00ff';
    assert.deepEqual(
      parseGroth16ProofFromObject(receipt).imageIdJournalRisc0?.journal,
      Uint8Array.from([0, 255]),
    );
  });

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
