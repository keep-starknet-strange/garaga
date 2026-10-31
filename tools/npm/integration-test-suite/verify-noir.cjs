const vectors = require('../../../hydra/garaga/starknet/honk_contract_generator/examples/noir_calldata_test_vectors.json');

function fromHex(hex) {
  return Uint8Array.from(hex.match(/../g), byte => parseInt(byte, 16));
}

module.exports = async function verifyNoir(garaga) {
  for (const vector of vectors) {
    const { proof, public_inputs, vk } = vector.files;
    const calldata = garaga.getZKHonkCallData(fromHex(proof), fromHex(public_inputs), fromHex(vk));
    const bytes = new TextEncoder().encode(calldata.map(String).join('\n'));
    const digest = await globalThis.crypto.subtle.digest('SHA-256', bytes);
    const hash = Array.from(new Uint8Array(digest), byte => byte.toString(16).padStart(2, '0')).join('');
    if (calldata.length !== vector.length || hash !== vector.sha256) {
      throw new Error(`Noir ${vector.case} calldata differs from the Python reference`);
    }
  }
};
