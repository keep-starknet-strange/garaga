import { HonkFlavor } from "../../src/node/starknet/honkContractGenerator/parsingUtils";
import * as fs from 'fs';
import * as garaga from "../../src/node/index";

const PATH = '../../../hydra/garaga/starknet/honk_contract_generator/examples';

describe('Honk Getting calldata', () => {

  const proofAndVkWithFlavors = [
    [`${PATH}/proof_ultra_keccak.bin`, `${PATH}/vk_ultra_keccak.bin`, HonkFlavor.KECCAK],
    [`${PATH}/proof_ultra_starknet.bin`, `${PATH}/vk_ultra_keccak.bin`, HonkFlavor.STARKNET],
  ]

  test.each(proofAndVkWithFlavors)("should  get honk calldata from proof %s, vk %s and pub inputs %s", async (proofPath, vkPath, flavor) => {

    await garaga.init();

    const vkBytes = new Uint8Array(fs.readFileSync(vkPath as string));
    const vk = garaga.parseHonkVerifyingKeyFromBytes(vkBytes);

    const proofBytes = new Uint8Array(fs.readFileSync(proofPath as string));
    const proof = garaga.parseHonkProofFromBytes(proofBytes);

    console.log("proof", proof);
    console.log("vk", vk);
    console.log("flavor", flavor);

    const honkCalldata = garaga.getHonkCallData(proof, vk, flavor as HonkFlavor);

    console.log("honkCalldata", honkCalldata);

  });

});
