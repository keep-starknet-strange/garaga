import { HonkFlavor } from "../../src/node/starknet/honkContractGenerator/parsingUtils";
import * as fs from 'fs';
import * as garaga from "../../src/node/index";

const PATH = '../../../hydra/garaga/starknet/honk_contract_generator/examples';

describe('Honk Getting calldata', () => {

    const proofAndVkWithFlavors = [
        [`${PATH}/proof_ultra_keccak.bin`, `${PATH}/public_inputs_ultra_keccak_zk.bin`, `${PATH}/vk_ultra_keccak.bin`, HonkFlavor.KECCAK],
        [`${PATH}/proof_ultra_starknet.bin`, `${PATH}/public_inputs_ultra_keccak_zk.bin`, `${PATH}/vk_ultra_keccak.bin`, HonkFlavor.STARKNET],
    ]

    test.each(proofAndVkWithFlavors)("should  get honk calldata from proof %s, public inputs %s, vk %s and pub inputs %s", async (proofPath, publicInputsPath, vkPath, flavor) => {

        await garaga.init();

        const vkBytes = new Uint8Array(fs.readFileSync(vkPath as string));

        const publicInputsBytes = new Uint8Array(fs.readFileSync(publicInputsPath as string));

        const proofBytes = new Uint8Array(fs.readFileSync(proofPath as string));

        console.log("proof", proofBytes);
        console.log("publicInputs", publicInputsBytes);
        console.log("vk", vkBytes);
        console.log("flavor", flavor);

        const honkCalldata = garaga.getHonkCallData(proofBytes, publicInputsBytes, vkBytes, flavor as HonkFlavor);

        console.log("honkCalldata", honkCalldata);

    });

});
