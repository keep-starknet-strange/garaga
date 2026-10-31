const fixture = require('../../../hydra/garaga/starknet/groth16_contract_generator/examples/proof_sp1.json');
const vk = require('../../../hydra/garaga/starknet/groth16_contract_generator/examples/vk_sp1.json');
const vectors = require('../../../hydra/garaga/starknet/groth16_contract_generator/examples/groth16_calldata_test_vectors.json');

module.exports = async function verifySp1(garaga) {
  const proof = garaga.parseGroth16ProofFromObject(fixture);
  const key = garaga.parseGroth16VerifyingKeyFromObject(vk);
  const calldata = garaga.getGroth16CallData(proof, key, garaga.CurveId.BN254);
  const expected = vectors.find(vector => vector.proof === 'proof_sp1.json');
  const bytes = new TextEncoder().encode(calldata.map(String).join('\n'));
  const digest = await globalThis.crypto.subtle.digest('SHA-256', bytes);
  const hash = Array.from(new Uint8Array(digest), b => b.toString(16).padStart(2, '0')).join('');
  if (calldata.length !== expected.length || hash !== expected.sha256) {
    throw new Error('SP1 v6 calldata differs from the Python reference');
  }
};
