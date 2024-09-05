import garaga_rs from 'garaga_rs';

async function main(): Promise<void> {
  await garaga_rs.init();
  const result = garaga_rs.msm_calldata_builder([1, 2], [10], 0);
  console.log('Output of msm_calldata_builder:', result);
}

main()
  .catch(console.error);
