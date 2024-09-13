import * as garaga from 'garaga';

async function main(): Promise<void> {
  await garaga.init();
  const result = garaga.msmCalldataBuilder([[1n, 2n]], [10n], garaga.CurveId.BN254);
  const json = JSON.stringify(result, (key, value) => typeof value === 'bigint' ? value + 'n' : value, 2);
  const message = 'Output of msm_calldata_builder: ' + json;
  console.log(message);
}

main()
  .catch(console.error);
