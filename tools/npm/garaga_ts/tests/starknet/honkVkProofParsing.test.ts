import { parseHonkProofFromBytes, parseHonkVerifyingKeyFromBytes } from "../../src/node/starknet/honkContractGenerator/parsingUtils";

const PATH = '../../../hydra/garaga/starknet/honk_contract_generator/examples';

describe('Honk Parsing Tests', () => {
  const vkPaths = [
    `${PATH}/vk_ultra_keccak.bin`,
  ];

  test.each(vkPaths)('should parse vk from %s', (vkPath) => {
    const vk = parseHonkVerifyingKeyFromBytes(vkPath);
    console.log(vk);
  });

  const proofPaths = [
    `${PATH}/proof_ultra_keccak.bin`,
    `${PATH}/proof_ultra_starknet.bin`,
  ];

  test.each(proofPaths)('should parse proof from %s', (proofPath) => {
    const proof = parseHonkProofFromBytes(proofPath);
    console.log(proof);
  });
});
