import { CurveId, G1Point } from "../../definitions";
import * as fs from 'fs';

const BATCHED_RELATION_PARTIAL_LENGTH = 8;
const CONST_PROOF_SIZE_LOG_N = 28;
const NUMBER_OF_ENTITIES = 44;

export enum HonkFlavor {
    KECCAK = 0,
    STARKNET = 1,
}

export interface HonkProof {
    circuitSize: number,
    publicInputsSize: number,
    publicInputsOffset: number,
    publicInputs: bigint[],
    w1: G1Point,
    w2: G1Point,
    w3: G1Point,
    w4: G1Point,
    zPerm: G1Point,
    lookupReadCounts: G1Point,
    lookupReadTags: G1Point,
    lookupInverses: G1Point,
    sumcheckUnivariates: bigint[], // flattened
    sumcheckEvaluations: bigint[],
    geminiFoldComms: G1Point[],
    geminiAEvaluations: bigint[],
    shplonkQ: G1Point,
    kzgQuotient: G1Point,
}

export interface HonkVerifyingKey {
    circuitSize: number,
    logCircuitSize: number,
    publicInputsSize: number,
    publicInputsOffset: number,
    qm: G1Point,
    qc: G1Point,
    ql: G1Point,
    qr: G1Point,
    qo: G1Point,
    q4: G1Point,
    qArith: G1Point,
    qDeltaRange: G1Point,
    qElliptic: G1Point,
    qAux: G1Point,
    qLookup: G1Point,
    qPoseidon2External: G1Point,
    qPoseidon2Internal: G1Point,
    s1: G1Point,
    s2: G1Point,
    s3: G1Point,
    s4: G1Point,
    id1: G1Point,
    id2: G1Point,
    id3: G1Point,
    id4: G1Point,
    t1: G1Point,
    t2: G1Point,
    t3: G1Point,
    t4: G1Point,
    lagrangeFirst: G1Point,
    lagrangeLast: G1Point,
}

export const parseHonkProofFromBytes = (proofPath: string): HonkProof => {
  try {
    const bytes = new Uint8Array(fs.readFileSync(proofPath));
    if (bytes.length < 4) throw new Error('Invalid length');
    let offset = 0;
    const count = Number(parseBigIntFromBytesBE(bytes, offset, 4));
    offset += 4;
    if (bytes.length !== 4 + count * 32) throw new Error('Invalid length');
    const values: bigint[] = [];
    for (let i = 0; i < count; i++) {
      const value = parseBigIntFromBytesBE(bytes, offset, 32);
      offset += 32;
      values.push(value);
    }
    const curveId = CurveId.BN254;
    let index = 0;
    function readValue(): bigint {
      return values[index++]!;
    }
    function readG1Point(): G1Point {
      const x0 = readValue();
      const x1 = readValue();
      const y0 = readValue();
      const y1 = readValue();
      const x = (x1 << 136n) + x0;
      const y = (y1 << 136n) + y0;
      return { x, y, curveId };
    }
    const circuitSize = Number(readValue());
    const publicInputsSize = Number(readValue());
    const publicInputsOffset = Number(readValue());
    const publicInputs: bigint[] = [];
    for (let i = 0; i < publicInputsSize; i++) {
      publicInputs.push(readValue());
    }
    const w1 = readG1Point();
    const w2 = readG1Point();
    const w3 = readG1Point();
    const lookupReadCounts = readG1Point();
    const lookupReadTags = readG1Point();
    const w4 = readG1Point();
    const lookupInverses = readG1Point();
    const zPerm = readG1Point();
    const sumcheckUnivariates: bigint[][] = [];
    for (let i = 0; i < CONST_PROOF_SIZE_LOG_N; i++) {
        const sumcheckUnivariate: bigint[] = [];
        for (let j = 0; j < BATCHED_RELATION_PARTIAL_LENGTH; j++) {
            sumcheckUnivariate.push(readValue());
        }
        sumcheckUnivariates.push(sumcheckUnivariate);
    }
    const sumcheckEvaluations: bigint[] = [];
    for (let i = 0; i < NUMBER_OF_ENTITIES; i++) {
        sumcheckEvaluations.push(readValue());
    }
    const geminiFoldComms: G1Point[] = [];
    for (let i = 0; i < CONST_PROOF_SIZE_LOG_N - 1; i++) {
      geminiFoldComms.push(readG1Point());
    }
    const geminiAEvaluations: bigint[] = [];
    for (let i = 0; i < CONST_PROOF_SIZE_LOG_N; i++) {
      geminiAEvaluations.push(readValue());
    }
    const shplonkQ = readG1Point();
    const kzgQuotient = readG1Point();
    return {
      circuitSize,
      publicInputsSize,
      publicInputsOffset,
      publicInputs,
      w1,
      w2,
      w3,
      w4,
      zPerm,
      lookupReadCounts,
      lookupReadTags,
      lookupInverses,
      sumcheckUnivariates: sumcheckUnivariates.flat(),
      sumcheckEvaluations,
      geminiFoldComms,
      geminiAEvaluations,
      shplonkQ,
      kzgQuotient,
    };
  } catch (err) {
    throw new Error(`Failed to parse Honk proof from ${proofPath}: ${err}`);
  }
}

export const parseHonkVerifyingKeyFromBytes = (vkPath: string): HonkVerifyingKey => {
  try {
    const bytes = new Uint8Array(fs.readFileSync(vkPath));
    if (bytes.length !== 4 * 8 + 54 * 32) throw new Error('Invalid length');
    let offset = 0;
    const values: number[] = [];
    for (let i = 0; i < 4; i++) {
      const value = parseBigIntFromBytesBE(bytes, offset, 8);
      offset += 8;
      values.push(Number(value));
    }
    const curveId = CurveId.BN254;
    const points: G1Point[] = [];
    for (let i = 0; i < 27; i++) {
      const x = parseBigIntFromBytesBE(bytes, offset, 32);
      offset += 32;
      const y = parseBigIntFromBytesBE(bytes, offset, 32);
      offset += 32;
      points.push({ x, y, curveId });
    }
    return {
      circuitSize: values[0]!,
      logCircuitSize: values[1]!,
      publicInputsSize: values[2]!,
      publicInputsOffset: values[3]!,
      qm: points[0]!,
      qc: points[1]!,
      ql: points[2]!,
      qr: points[3]!,
      qo: points[4]!,
      q4: points[5]!,
      qArith: points[6]!,
      qDeltaRange: points[7]!,
      qElliptic: points[8]!,
      qAux: points[9]!,
      qLookup: points[10]!,
      qPoseidon2External: points[11]!,
      qPoseidon2Internal: points[12]!,
      s1: points[13]!,
      s2: points[14]!,
      s3: points[15]!,
      s4: points[16]!,
      id1: points[17]!,
      id2: points[18]!,
      id3: points[19]!,
      id4: points[20]!,
      t1: points[21]!,
      t2: points[22]!,
      t3: points[23]!,
      t4: points[24]!,
      lagrangeFirst: points[25]!,
      lagrangeLast: points[26]!,
    }
  } catch (err) {
    throw new Error(`Failed to parse Honk verifying key from ${vkPath}: ${err}`);
  }
}

function parseBigIntFromBytesBE(bytes: Uint8Array, offset: number, length: number): bigint {
  if (offset + length > bytes.length) throw new Error('Invalid range');
  let value = 0n;
  for (let i = 0; i < length; i++) {
    value = (value << 8n) | BigInt(bytes[offset + i]!);
  }
  return value;
}
