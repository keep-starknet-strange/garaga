import * as fs from 'fs';
import * as garaga from "../../src/node/index";

const PATH = '../../../hydra/garaga/starknet/honk_contract_generator/examples';

describe('ZK Honk Parsing Tests', () => {
  const vkPaths = [
    `${PATH}/vk_ultra_keccak.bin`,
  ];

  test.each(vkPaths)('should parse vk from %s', async (vkPath) => {
    await garaga.init();
    const bytes = new Uint8Array(fs.readFileSync(vkPath));
    const vk = garaga.parseHonkVerifyingKeyFromBytes(bytes);
    console.log(vk);
  });

  const proofPaths = [
    `${PATH}/proof_ultra_keccak_zk.bin`,
    `${PATH}/proof_ultra_starknet_zk.bin`,
  ];

  test.each(proofPaths)('should parse proof from %s', async (proofPath) => {
    await garaga.init();
    const bytes = new Uint8Array(fs.readFileSync(proofPath));
    const proof = garaga.parseZKHonkProofFromBytes(bytes);
    console.log(proof);
  });
});
