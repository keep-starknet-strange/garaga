import * as fs from 'node:fs';
import { createHash } from 'node:crypto';
import assert from 'node:assert/strict';
import { describe, test } from 'node:test';
import * as garaga from '../../src/node/index.js';

const directory = '../../../hydra/garaga/starknet/honk_contract_generator/examples';
interface NoirVector { case: string; files: { proof: string; public_inputs: string; vk: string }; length: number; sha256: string; }
const vectors: NoirVector[] = JSON.parse(fs.readFileSync(`${directory}/noir_calldata_test_vectors.json`, 'utf8'));

describe('Barretenberg v6 Ultra Keccak ZK calldata', () => {
  for (const vector of vectors) {
    test(`matches the Python reference for ${vector.case}`, async () => {
      await garaga.init();
      const bytes = (name: keyof NoirVector["files"]) => new Uint8Array(Buffer.from(vector.files[name], 'hex'));
      const calldata = garaga.getZKHonkCallData(bytes('proof'), bytes('public_inputs'), bytes('vk'));
      assert.equal(calldata.length, vector.length);
      assert.equal(createHash('sha256').update(calldata.map(String).join('\n')).digest('hex'), vector.sha256);
    });
  }

  test('rejects a noncanonical public input', async () => {
    await garaga.init();
    const { proof, vk } = vectors[0]!.files;
    const scalarModulus = '30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001';
    assert.throws(() => garaga.getZKHonkCallData(
      new Uint8Array(Buffer.from(proof, 'hex')),
      new Uint8Array(Buffer.from(scalarModulus, 'hex')),
      new Uint8Array(Buffer.from(vk, 'hex')),
    ));
  });
});
