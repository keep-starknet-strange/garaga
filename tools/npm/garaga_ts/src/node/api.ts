// This files provides a ts-like interface for garaga_rs

import { msm_calldata_builder, mpc_calldata_builder, to_twistededwards, to_weirstrass, get_groth16_calldata } from '../wasm/pkg/garaga_rs';
import { CurveId } from './definitions';
import { Groth16Proof, Groth16VerifyingKey } from './starknet/groth16ContractGenerator/parsingUtils';

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

export function toWeirstrass(x_twisted: bigint, y_twisted: bigint): [bigint, bigint] {
  const result = to_weirstrass(x_twisted, y_twisted);

  if(result.length !== 2) {
    throw new Error('Invalid result length');
  }

  return [result[0], result[1]];
}

export function toTwistedEdwards(x_weierstrass: bigint, y_weierstrass: bigint): [bigint, bigint] {
  const result = to_twistededwards(x_weierstrass, y_weierstrass);

  if(result.length !== 2) {
    throw new Error('Invalid result length');
  }

  return [result[0], result[1]];
}

export function getGroth16CallData(proof: Groth16Proof, verifyingKey: Groth16VerifyingKey, curveId: CurveId){

  return get_groth16_calldata(proof, verifyingKey, curveId);

}
