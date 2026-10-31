import { readFileSync } from 'fs';
import { createGroth16ProofFromSp1, parseGroth16ProofFromObject } from '../../src/node/starknet/groth16ContractGenerator/parsingUtils';
import { SP1_VK_ROOT } from '../../src/constants';

const fixture = JSON.parse(readFileSync('../../../hydra/garaga/starknet/groth16_contract_generator/examples/proof_sp1.json', 'utf8'));
const bytes = (hex: string) => Uint8Array.from(Buffer.from(hex.slice(2), 'hex'));

test('SP1 v6 exposes all five public inputs', () => {
  const parsed = parseGroth16ProofFromObject(fixture);
  expect(parsed.publicInputs).toHaveLength(5);
  expect(parsed.publicInputs[2]).toBe(0n);
  expect(parsed.publicInputs[3]).toBe(SP1_VK_ROOT);
});

test.each(['selector', 'exit', 'root', 'nonce', 'short', 'long', 'vkey'])('SP1 parser rejects invalid %s', kind => {
  let proof = bytes(fixture.proof);
  let vkey = bytes(fixture.vkey);
  if (kind === 'selector') proof[0] = proof[0]! ^ 1;
  if (kind === 'exit') proof[35] = 1;
  if (kind === 'root') proof[67] = proof[67]! ^ 1;
  if (kind === 'nonce') proof.fill(255, 68, 100);
  if (kind === 'short') proof = proof.slice(0, -1);
  if (kind === 'long') proof = Uint8Array.from([...proof, 0]);
  if (kind === 'vkey') vkey = vkey.slice(1);
  expect(() => createGroth16ProofFromSp1(vkey, bytes(fixture.publicValues), proof)).toThrow();
});

test('SP1 object parser preserves invalid header errors', () => {
  const proof = bytes(fixture.proof);
  proof[35] = 1;
  expect(() => parseGroth16ProofFromObject({...fixture, proof: '0x' + Buffer.from(proof).toString('hex')})).toThrow('exit code');
});
