import {  Groth16Proof, parseGroth16ProofFromJson, parseGroth16VerifyingKeyFromJson } from "../../src/node/starknet/groth16ContractGenerator/parsingUtils";
import * as garaga from "../../src/node/index";


const PATH = '../../../hydra/garaga/starknet/groth16_contract_generator/examples';

describe('Groth16 Getting calldata', () => {

const proofAndVkWithPublicInputs = [
  [`${PATH}/proof_bn254.json`, `${PATH}/vk_bn254.json`, null],
  [`${PATH}/proof_bls.json`, `${PATH}/vk_bls.json`, null],

  [`${PATH}/gnark_proof_bn254.json`, `${PATH}/gnark_vk_bn254.json`, `${PATH}/gnark_public_bn254.json`],
  [`${PATH}/snarkjs_proof_bn254.json`, `${PATH}/snarkjs_vk_bn254.json`, `${PATH}/snarkjs_public_bn254.json`],

  [`${PATH}/proof_risc0.json`, `${PATH}/vk_risc0.json`, null],

]

  test.each(proofAndVkWithPublicInputs)("should  get groth16 calldata from proof %s, vk %s and pub inputs %s", async (proofPath, vkPath, pubInputsPath) => {

    await garaga.init();

    const vk = parseGroth16VerifyingKeyFromJson(vkPath as string);

    let proof: Groth16Proof;
    if(pubInputsPath == null){
      proof = parseGroth16ProofFromJson(proofPath as string);
    } else{
      proof = parseGroth16ProofFromJson(proofPath as string, pubInputsPath);
    }

    const curveId: garaga.CurveId = proof.a.curveId;

    console.log("proof", proof);

    console.log("vk", vk);
    console.log("curveId", curveId);
    const groth16Calldata = garaga.getGroth16CallData(proof, vk, curveId);

    console.log("groth16Calldata", groth16Calldata);

  });

});
