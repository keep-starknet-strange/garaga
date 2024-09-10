// This files provides a ts-like interface for garaga_rs

import { msm_calldata_builder } from '../wasm/pkg/garaga_rs';

export enum CurveId {
  BN254 = 0,
  BLS12_381 = 1,
  SECP256K1 = 2,
  SECP256R1 = 3,
  X25519 = 4,
}

export type G1Point = [bigint, bigint];

export type MsmCalldataBuilderOptons = Partial<{
  includeDigitsDecomposition: boolean;
  includePointsAndScalars: boolean;
  serializeAsPureFelt252Array: boolean;
  risc0Mode: boolean;
}>;

export function msmCalldataBuilder(points: G1Point[], scalars: bigint[], curveId: CurveId, options: MsmCalldataBuilderOptons = {}): bigint[] {
  const values = points.reduce<bigint[]>((values, point) => values.concat(point), []);
  const includeDigitsDecomposition = options.includeDigitsDecomposition || true;
  const includePointsAndScalars = options.includePointsAndScalars || true;
  const serializeAsPureFelt252Array = options.serializeAsPureFelt252Array || false;
  const risc0Mode = options.risc0Mode || false;
  return msm_calldata_builder(values, scalars, curveId, includeDigitsDecomposition, includePointsAndScalars, serializeAsPureFelt252Array, risc0Mode);
}
