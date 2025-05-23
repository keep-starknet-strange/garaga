// This files provides a ts-like interface for garaga_rs

import {
  drand_calldata_builder,
  drand_tlock_encrypt_calldata_builder,
  msm_calldata_builder,
  mpc_calldata_builder,
  schnorr_calldata_builder,
  ecdsa_calldata_builder,
  eddsa_calldata_builder,
  to_twistededwards,
  to_weirstrass,
  get_groth16_calldata,
  get_honk_calldata,
  get_zk_honk_calldata,
  poseidon_hash,
} from '../wasm/pkg/garaga_rs';
import { CurveId } from './definitions';
import { Groth16Proof, Groth16VerifyingKey } from './starknet/groth16ContractGenerator/parsingUtils';
import { HonkFlavor } from './starknet/honkContractGenerator/parsingUtils';

export type G1Point = [bigint, bigint];
export type G2Point = [[bigint, bigint], [bigint, bigint]];
export type G1G2Pair = [G1Point, G2Point];

function flatten(data: bigint[][]): bigint[] {
  return data.reduce<bigint[]>((values, item) => values.concat(item), []);
}

function pairToList(pair: G1G2Pair): bigint[] {
  const [[x1, y1], [[x2a, x2b], [y2a, y2b]]] = pair;
  return [x1, y1, x2a, x2b, y2a, y2b];
}

export type MsmCalldataBuilderOptons = Partial<{
  includeDigitsDecomposition: boolean;
  includePointsAndScalars: boolean;
  serializeAsPureFelt252Array: boolean;
  risc0Mode: boolean;
}>;

export function msmCalldataBuilder(points: G1Point[], scalars: bigint[], curveId: CurveId, options: MsmCalldataBuilderOptons = {}): bigint[] {
  const values = flatten(points);
  const includePointsAndScalars = options.includePointsAndScalars ?? true;
  const serializeAsPureFelt252Array = options.serializeAsPureFelt252Array ?? false;
  return msm_calldata_builder(values, scalars, curveId, includePointsAndScalars, serializeAsPureFelt252Array);
}

export function mpcCalldataBuilder(curveId: CurveId, pairs: G1G2Pair[], nFixedG2: number, publicPair?: G1G2Pair): bigint[] {
  const values1 = flatten(pairs.map(pairToList));
  const values2 = publicPair === undefined ? [] : pairToList(publicPair);
  return mpc_calldata_builder(curveId, values1, nFixedG2, values2);
}

export function schnorrCalldataBuilder(rx: bigint, s: bigint, e: bigint, px: bigint, py: bigint, curveId: CurveId): bigint[] {
  return schnorr_calldata_builder(rx, s, e, px, py, curveId);
}

export function ecdsaCalldataBuilder(r: bigint, s: bigint, v: number, px: bigint, py: bigint, z: bigint, curveId: CurveId): bigint[] {
  return ecdsa_calldata_builder(r, s, v, px, py, z, curveId);
}

export function eddsaCalldataBuilder(ry_twisted_le: bigint, s: bigint, py_twisted_le: bigint, msg: Uint8Array): bigint[] {
  return eddsa_calldata_builder(ry_twisted_le, s, py_twisted_le, msg);
}

export function toWeirstrass(x_twisted: bigint, y_twisted: bigint): [bigint, bigint] {
  const result = to_weirstrass(x_twisted, y_twisted);

  if (result.length !== 2) {
    throw new Error('Invalid result length');
  }

  return [result[0], result[1]];
}

export function toTwistedEdwards(x_weierstrass: bigint, y_weierstrass: bigint): [bigint, bigint] {
  const result = to_twistededwards(x_weierstrass, y_weierstrass);

  if (result.length !== 2) {
    throw new Error('Invalid result length');
  }

  return [result[0], result[1]];
}

export function getGroth16CallData(proof: Groth16Proof, verifyingKey: Groth16VerifyingKey, curveId: CurveId): bigint[] {
  return get_groth16_calldata(proof, verifyingKey, curveId);
}

export function getHonkCallData(proof: Uint8Array, publicInputs: Uint8Array, verifyingKey: Uint8Array, flavor: HonkFlavor): bigint[] {
  return get_honk_calldata(proof, publicInputs, verifyingKey, flavor);
}

export function getZKHonkCallData(proof: Uint8Array, publicInputs: Uint8Array, verifyingKey: Uint8Array, flavor: HonkFlavor): bigint[] {
  return get_zk_honk_calldata(proof, publicInputs, verifyingKey, flavor);
}

const DRAND_BASE_URLS = [
  'https://drand.cloudflare.com',
  'https://api.drand.sh',
  'https://api2.drand.sh',
  'https://api3.drand.sh',
];

const DRAND_QUICKNET_HASH = '52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971';

type DrandRandomnessBeacon = {
  roundNumber: number;
  randomness: bigint;
  signature: bigint;
};

export async function fetchAndGetDrandCallData(roundNumber: number | 'latest' = 'latest', chainHash = DRAND_QUICKNET_HASH, baseUrls = DRAND_BASE_URLS): Promise<bigint[]> {
  return getDrandCallData(await fetchDrandRandomness(roundNumber, chainHash, baseUrls));
}

export function getDrandCallData({ roundNumber, randomness, signature }: DrandRandomnessBeacon): bigint[] {
  return drand_calldata_builder([roundNumber, randomness, signature]);
}

export async function fetchDrandRandomness(roundNumberArg: number | 'latest' = 'latest', chainHash = DRAND_QUICKNET_HASH, baseUrls = DRAND_BASE_URLS): Promise<DrandRandomnessBeacon> {
  if (baseUrls.length == 0) {
    throw new Error('No base url provided');
  }
  const endpoint = '/' + chainHash + '/public/' + roundNumberArg;
  const promises = baseUrls.map((baseUrl) => fetch(baseUrl + endpoint));
  let response;
  try {
    response = await Promise.any(promises);
  } catch (e) {
    throw new Error('All urls failed: ' + e);
  }
  const data = await response?.json();
  if (!data || !data.round || !data.randomness || !data.signature) {
    throw new Error('Unexpected response: ' + JSON.stringify(data));
  }
  const roundNumber = Number(data.round);
  if (roundNumberArg !== 'latest' && roundNumber !== roundNumberArg) {
    throw new Error('Inconsistent roundNumber: found ' + roundNumber + ', expected ' + roundNumberArg);
  }
  const randomness = BigInt('0x' + data.randomness.replace(/^0x/i, ''));
  const signature = BigInt('0x' + data.signature.replace(/^0x/i, ''));
  return { roundNumber, randomness, signature };
}

export function encryptToDrandRoundAndGetCallData(roundNumber: number, message: Uint8Array, randomness: bigint): bigint[] {
  if (message.length != 16) throw new Error('Message size should be 16');
  const value = message.reduce((acc, b) => (acc << 8n) | BigInt(b), 0n);
  randomness = randomness % (1n << 128n);
  return drand_tlock_encrypt_calldata_builder([roundNumber, value, randomness]);
}

export function poseidonHashBN254(x: bigint, y: bigint): bigint {
  try {
    const result = poseidon_hash(x, y);

    if (typeof result === 'bigint') {
      return result;
    }
    throw new Error('Invalid result from poseidon_hash');
  } catch (error) {
    throw new Error(`Failed to compute Poseidon hash: ${error}`);
  }
}
