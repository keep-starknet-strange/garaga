import * as fs from 'fs';
import * as garaga from "../../src/node/index";

const PATH = '../../../hydra/garaga/starknet/honk_contract_generator/examples';

describe('ZK Honk Getting calldata', () => {

  const proofAndVks = [
    [`${PATH}/proof_ultra_keccak_zk.bin`, `${PATH}/public_inputs_ultra_keccak.bin`, `${PATH}/vk_ultra_keccak.bin`],
    [`${PATH}/proof_ultra_keccak_zk_recursive.bin`, `${PATH}/public_inputs_ultra_keccak_recursive.bin`, `${PATH}/vk_ultra_keccak_recursive.bin`],
  ]

  test.each(proofAndVks)("should get zk honk calldata from proof %s, public inputs %s and vk %s", async (proofPath, publicInputsPath, vkPath) => {

    await garaga.init();

    const vkBytes = new Uint8Array(fs.readFileSync(vkPath as string));

    const publicInputsBytes = new Uint8Array(fs.readFileSync(publicInputsPath as string));

    const proofBytes = new Uint8Array(fs.readFileSync(proofPath as string));

    console.log("proof", proofBytes);
    console.log("publicInputs", publicInputsBytes);
    console.log("vk", vkBytes);

    const honkCalldata = garaga.getZKHonkCallData(proofBytes, publicInputsBytes, vkBytes);

    console.log("honkCalldata", honkCalldata);

  });

});
