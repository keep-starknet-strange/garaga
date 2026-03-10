import * as garaga from 'garaga';
import { proofBn254, vkBn254 } from './examples.js';

async function main(): Promise<void> {
  await garaga.init();
  const result = garaga.msmCalldataBuilder([[1n, 2n]], [10n], garaga.CurveId.BN254);
  const json = JSON.stringify(result, (key, value) => typeof value === 'bigint' ? value + 'n' : value, 2);
  const message = 'Output of msm_calldata_builder: ' + json;
  console.log(message);

  const groth16Calldata = garaga.getGroth16CallData(proofBn254, vkBn254,garaga.CurveId.BN254);

  const jsonCalldata = JSON.stringify(groth16Calldata, (key, value) => typeof value === 'bigint' ? value + 'n' : value, 2);

  const messageCalldata = 'Output of get_groth16_calldata: ' + jsonCalldata;

  console.log(messageCalldata);

  // Tlock encrypt
  const message2 = new Uint8Array(16);
  message2.set(new TextEncoder().encode('Hello, world!'));
  const randomness = new Uint8Array(16);
  randomness.set(new TextEncoder().encode('fixed_random_val'));
  const tlockCalldata = garaga.encryptToDrandRoundAndGetCallData(1, message2, randomness);
  console.log('Output of encryptToDrandRoundAndGetCallData:', tlockCalldata.length, 'elements');
}

main()
  .catch(console.error);
