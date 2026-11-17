import { proofBn254, vkBn254 } from './browser-examples.mjs';
import verifySp1 from './verify-sp1.cjs';
import verifyNoir from './verify-noir.cjs';

function formatCalldata(calldata) {
  return JSON.stringify(calldata, (_, value) => typeof value === 'bigint' ? value + 'n' : value, 2);
}

export async function conformanceOutput(garaga) {
  await garaga.init();
  await verifySp1(garaga);
  await verifyNoir(garaga);

  const msm = garaga.msmCalldataBuilder([[1n, 2n]], [10n], garaga.CurveId.BN254);
  const groth16 = garaga.getGroth16CallData(proofBn254, vkBn254, garaga.CurveId.BN254);
  const message = new Uint8Array(16);
  message.set(new TextEncoder().encode('Hello, world!'));
  const randomness = new Uint8Array(16);
  randomness.set(new TextEncoder().encode('fixed_random_val'));
  const tlock = garaga.encryptToDrandRoundAndGetCallData(1, message, randomness);
  return [
    'Output of msm_calldata_builder: ' + formatCalldata(msm),
    'Output of get_groth16_calldata: ' + formatCalldata(groth16),
    'Output of encryptToDrandRoundAndGetCallData: ' + tlock.length + ' elements',
  ].join('\n');
}
