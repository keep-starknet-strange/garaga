// This files provides a ts-like interface for garaga_rs

import {
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
  const includeDigitsDecomposition = options.includeDigitsDecomposition ?? true;
  const includePointsAndScalars = options.includePointsAndScalars ?? true;
  const serializeAsPureFelt252Array = options.serializeAsPureFelt252Array ?? false;
  const risc0Mode = options.risc0Mode ?? false;
  return msm_calldata_builder(values, scalars, curveId, includeDigitsDecomposition, includePointsAndScalars, serializeAsPureFelt252Array, risc0Mode);
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

export function getHonkCallData(proof: Uint8Array, verifyingKey: Uint8Array, flavor: HonkFlavor): bigint[] {
  return get_honk_calldata(proof, verifyingKey, flavor);
}

export function getZKHonkCallData(proof: Uint8Array, verifyingKey: Uint8Array, flavor: HonkFlavor): bigint[] {
  return get_zk_honk_calldata(proof, verifyingKey, flavor);
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
