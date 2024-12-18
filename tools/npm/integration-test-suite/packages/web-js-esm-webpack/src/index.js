import * as garaga from 'garaga';
import { proofBn254, vkBn254 } from './examples';

async function main() {
  await garaga.init();
  const result = garaga.msmCalldataBuilder([[1n, 2n]], [10n], garaga.CurveId.BN254);
  const json = JSON.stringify(result, (key, value) => typeof value === 'bigint' ? value + 'n' : value, 2);
  const message = 'Output of msm_calldata_builder: ' + json;
  const element = document.createElement('pre');
  element.textContent = message;

  const groth16Calldata = garaga.getGroth16CallData(proofBn254, vkBn254,garaga.CurveId.BN254);

  const jsonCalldata = JSON.stringify(groth16Calldata, (key, value) => typeof value === 'bigint' ? value + 'n' : value, 2);

  const messageCalldata = 'Output of get_groth16_calldata: ' + jsonCalldata;

  element.textContent += "\n" + messageCalldata;


  document.body.appendChild(element);
}

main()
  .catch(console.error);
