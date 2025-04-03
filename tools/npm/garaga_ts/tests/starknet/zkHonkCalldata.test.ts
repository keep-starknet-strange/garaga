import { HonkFlavor } from "../../src/node/starknet/honkContractGenerator/parsingUtils";
import * as fs from 'fs';
import * as garaga from "../../src/node/index";

const PATH = '../../../hydra/garaga/starknet/honk_contract_generator/examples';

describe('ZK Honk Getting calldata', () => {

  const proofAndVkWithFlavors = [
    [`${PATH}/proof_ultra_keccak_zk.bin`, `${PATH}/vk_ultra_keccak.bin`, HonkFlavor.KECCAK],
    [`${PATH}/proof_ultra_starknet_zk.bin`, `${PATH}/vk_ultra_keccak.bin`, HonkFlavor.STARKNET],
  ]

  test.each(proofAndVkWithFlavors)("should  get zk honk calldata from proof %s, vk %s and pub inputs %s", async (proofPath, vkPath, flavor) => {

    await garaga.init();

    const vkBytes = new Uint8Array(fs.readFileSync(vkPath as string));

    const proofBytes = new Uint8Array(fs.readFileSync(proofPath as string));

    console.log("proof", proofBytes);
    console.log("vk", vkBytes);
    console.log("flavor", flavor);

    const honkCalldata = garaga.getZKHonkCallData(proofBytes, vkBytes, flavor as HonkFlavor);

    console.log("honkCalldata", honkCalldata);

  });

});
