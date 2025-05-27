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
import { randomBytes } from './random';

/**
 * Represents a point on an elliptic curve in affine coordinates (x, y)
 */
export type G1Point = [bigint, bigint];

/**
 * Represents a point on a twisted elliptic curve over an extension field
 * Format: [[x0, x1], [y0, y1]] where x = x0 + x1*i and y = y0 + y1*i
 */
export type G2Point = [[bigint, bigint], [bigint, bigint]];

/**
 * Represents a pairing of G1 and G2 points for pairing-based cryptography
 */
export type G1G2Pair = [G1Point, G2Point];

function flatten(data: bigint[][]): bigint[] {
  return data.reduce<bigint[]>((values, item) => values.concat(item), []);
}

function pairToList(pair: G1G2Pair): bigint[] {
  const [[x1, y1], [[x2a, x2b], [y2a, y2b]]] = pair;
  return [x1, y1, x2a, x2b, y2a, y2b];
}

/**
 * Configuration options for MSM (Multi-Scalar Multiplication) calldata builder
 */
export type MsmCalldataBuilderOptons = Partial<{
  /** Whether to include the original points and scalars in the output */
  includePointsAndScalars: boolean;
  /** Whether to serialize the output as a pure felt252 array for Cairo compatibility */
  serializeAsPureFelt252Array: boolean;
}>;

/**
 * Builds calldata for Multi-Scalar Multiplication (MSM) operations.
 * MSM computes the sum of scalar multiplications: Σ(scalar_i * point_i)
 *
 * @param points - Array of G1 points to be multiplied
 * @param scalars - Array of scalar values for multiplication
 * @param curveId - Identifier for the elliptic curve (e.g., BN254, BLS12_381)
 * @param options - Configuration options for the MSM operation
 * @returns Array of bigint values representing the MSM calldata
 *
 * @example
 * ```typescript
 * const points: G1Point[] = [[1n, 2n], [3n, 4n]];
 * const scalars = [5n, 6n];
 * const calldata = msmCalldataBuilder(points, scalars, CurveId.BN254);
 * ```
 */
export function msmCalldataBuilder(points: G1Point[], scalars: bigint[], curveId: CurveId, options: MsmCalldataBuilderOptons = {}): bigint[] {
  const values = flatten(points);
  const includePointsAndScalars = options.includePointsAndScalars ?? true;
  const serializeAsPureFelt252Array = options.serializeAsPureFelt252Array ?? false;
  return msm_calldata_builder(values, scalars, curveId, includePointsAndScalars, serializeAsPureFelt252Array);
}

/**
 * Builds calldata for Multi-Pairing Check (MPC) operations.
 * MPC verifies that a set of pairing equations hold: e(G1_i, G2_i) = 1
 *
 * @param curveId - Identifier for the elliptic curve
 * @param pairs - Array of G1-G2 point pairs for pairing
 * @param nFixedG2 - Number of fixed G2 points in the pairing
 * @param publicPair - Optional additional public pairing for verification
 * @returns Array of bigint values representing the MPC calldata
 *
 * @example
 * ```typescript
 * const pairs: G1G2Pair[] = [[[1n, 2n], [[3n, 4n], [5n, 6n]]]];
 * const calldata = mpcCalldataBuilder(CurveId.BN254, pairs, 1);
 * ```
 */
export function mpcCalldataBuilder(curveId: CurveId, pairs: G1G2Pair[], nFixedG2: number, publicPair?: G1G2Pair): bigint[] {
  const values1 = flatten(pairs.map(pairToList));
  const values2 = publicPair === undefined ? [] : pairToList(publicPair);
  return mpc_calldata_builder(curveId, values1, nFixedG2, values2);
}

/**
 * Builds calldata for Schnorr signature verification.
 * Schnorr signatures provide a simple and efficient digital signature scheme.
 *
 * @param rx - X-coordinate of the signature point R
 * @param s - Signature scalar value
 * @param e - Challenge hash value
 * @param px - X-coordinate of the public key point
 * @param py - Y-coordinate of the public key point
 * @param curveId - Identifier for the elliptic curve
 * @returns Array of bigint values representing the Schnorr verification calldata
 *
 * @example
 * ```typescript
 * const calldata = schnorrCalldataBuilder(
 *   0x123n, // rx
 *   0x456n, // s
 *   0x789n, // e
 *   0xabcn, // px
 *   0xdefn, // py
 *   CurveId.BN254
 * );
 * ```
 */
export function schnorrCalldataBuilder(rx: bigint, s: bigint, e: bigint, px: bigint, py: bigint, curveId: CurveId): bigint[] {
  return schnorr_calldata_builder(rx, s, e, px, py, curveId);
}

/**
 * Builds calldata for ECDSA signature verification.
 * ECDSA is the standard elliptic curve digital signature algorithm.
 *
 * @param r - R component of the ECDSA signature
 * @param s - S component of the ECDSA signature
 * @param v - Recovery ID (0 or 1) for public key recovery
 * @param px - X-coordinate of the public key point
 * @param py - Y-coordinate of the public key point
 * @param z - Hash of the signed message
 * @param curveId - Identifier for the elliptic curve
 * @returns Array of bigint values representing the ECDSA verification calldata
 *
 * @example
 * ```typescript
 * const calldata = ecdsaCalldataBuilder(
 *   0x123n, // r
 *   0x456n, // s
 *   0,      // v
 *   0x789n, // px
 *   0xabcn, // py
 *   0xdefn, // z (message hash)
 *   CurveId.SECP256K1
 * );
 * ```
 */
export function ecdsaCalldataBuilder(r: bigint, s: bigint, v: number, px: bigint, py: bigint, z: bigint, curveId: CurveId): bigint[] {
  return ecdsa_calldata_builder(r, s, v, px, py, z, curveId);
}

/**
 * Builds calldata for EdDSA signature verification for Ed25519.
 * EdDSA provides deterministic signatures with strong security properties.
 *
 * @param ry_twisted_le - Y-coordinate of signature point R in twisted Edwards form (little-endian)
 * @param s - Signature scalar value
 * @param py_twisted_le - Y-coordinate of public key in twisted Edwards form (little-endian)
 * @param msg - Raw message bytes that were signed
 * @returns Array of bigint values representing the EdDSA verification calldata
 *
 * @example
 * ```typescript
 * const message = new Uint8Array([1, 2, 3, 4]);
 * const calldata = eddsaCalldataBuilder(
 *   0x123n, // ry_twisted_le
 *   0x456n, // s
 *   0x789n, // py_twisted_le
 *   message
 * );
 * ```
 */
export function eddsaCalldataBuilder(ry_twisted_le: bigint, s: bigint, py_twisted_le: bigint, msg: Uint8Array): bigint[] {
  return eddsa_calldata_builder(ry_twisted_le, s, py_twisted_le, msg);
}

/**
 * Converts a point from twisted Edwards form to Weierstrass form for Ed25519.
 * This is useful for interoperability between different curve representations.
 *
 * @param x_twisted - X-coordinate in twisted Edwards form
 * @param y_twisted - Y-coordinate in twisted Edwards form
 * @returns Tuple of [x_weierstrass, y_weierstrass] coordinates
 * @throws Error if the conversion fails or produces invalid results
 *
 * @example
 * ```typescript
 * const [x_w, y_w] = toWeirstrass(0x123n, 0x456n);
 * console.log(`Weierstrass form: (${x_w}, ${y_w})`);
 * ```
 */
export function toWeirstrass(x_twisted: bigint, y_twisted: bigint): [bigint, bigint] {
  const result = to_weirstrass(x_twisted, y_twisted);

  if (result.length !== 2) {
    throw new Error('Invalid result length');
  }

  return [result[0], result[1]];
}

/**
 * Converts a point from Weierstrass form to twisted Edwards form for Ed25519.
 * This is useful for interoperability between different curve representations.
 *
 * @param x_weierstrass - X-coordinate in Weierstrass form
 * @param y_weierstrass - Y-coordinate in Weierstrass form
 * @returns Tuple of [x_twisted, y_twisted] coordinates
 * @throws Error if the conversion fails or produces invalid results
 *
 * @example
 * ```typescript
 * const [x_t, y_t] = toTwistedEdwards(0x789n, 0xabcn);
 * console.log(`Twisted Edwards form: (${x_t}, ${y_t})`);
 * ```
 */
export function toTwistedEdwards(x_weierstrass: bigint, y_weierstrass: bigint): [bigint, bigint] {
  const result = to_twistededwards(x_weierstrass, y_weierstrass);

  if (result.length !== 2) {
    throw new Error('Invalid result length');
  }

  return [result[0], result[1]];
}

/**
 * Generates calldata for Groth16 zero-knowledge proof verification.
 * Groth16 is a succinct non-interactive zero-knowledge proof system.
 *
 * @param proof - The Groth16 proof containing points A, B, C and public inputs
 * @param verifyingKey - The verification key containing curve points for verification
 * @param curveId - Identifier for the elliptic curve used in the proof
 * @returns Array of bigint values representing the complete verification calldata
 *
 * @example
 * ```typescript
 * const proof: Groth16Proof = {
 *   a: [0x123n, 0x456n],
 *   b: [[0x789n, 0xabcn], [0xdefn, 0x111n]],
 *   c: [0x222n, 0x333n],
 *   publicInputs: [0x444n, 0x555n]
 * };
 * const calldata = getGroth16CallData(proof, verifyingKey, CurveId.BN254);
 * ```
 */
export function getGroth16CallData(proof: Groth16Proof, verifyingKey: Groth16VerifyingKey, curveId: CurveId): bigint[] {
  return get_groth16_calldata(proof, verifyingKey, curveId);
}

/**
 * Generates calldata for Honk zero-knowledge proof verification.
 * Honk is a universal SNARK that supports arbitrary circuits.
 *
 * @param proof - Raw proof bytes from the Honk prover
 * @param publicInputs - Public input bytes for the circuit
 * @param verifyingKey - Verification key bytes for the specific circuit
 * @param flavor - The Honk flavor (variant) being used
 * @returns Array of bigint values representing the complete verification calldata
 *
 * @example
 * ```typescript
 * const proofBytes = new Uint8Array([...]);
 * const publicInputsBytes = new Uint8Array([...]);
 * const vkBytes = new Uint8Array([...]);
 * const calldata = getHonkCallData(proofBytes, publicInputsBytes, vkBytes, HonkFlavor.STARKNET);
 * ```
 */
export function getHonkCallData(proof: Uint8Array, publicInputs: Uint8Array, verifyingKey: Uint8Array, flavor: HonkFlavor): bigint[] {
  return get_honk_calldata(proof, publicInputs, verifyingKey, flavor);
}

/**
 * Generates calldata for ZK-Honk zero-knowledge proof verification.
 * ZK-Honk provides zero-knowledge properties on top of the Honk system.
 *
 * @param proof - Raw ZK proof bytes from the ZK-Honk prover
 * @param publicInputs - Public input bytes for the circuit
 * @param verifyingKey - Verification key bytes for the specific circuit
 * @param flavor - The Honk flavor (variant) being used with ZK properties
 * @returns Array of bigint values representing the complete verification calldata
 *
 * @example
 * ```typescript
 * const zkProofBytes = new Uint8Array([...]);
 * const publicInputsBytes = new Uint8Array([...]);
 * const vkBytes = new Uint8Array([...]);
 * const calldata = getZKHonkCallData(zkProofBytes, publicInputsBytes, vkBytes, HonkFlavor.KECCAK);
 * ```
 */
export function getZKHonkCallData(proof: Uint8Array, publicInputs: Uint8Array, verifyingKey: Uint8Array, flavor: HonkFlavor): bigint[] {
  return get_zk_honk_calldata(proof, publicInputs, verifyingKey, flavor);
}

/**
 * Default base URLs for accessing drand randomness beacons
 */
const DRAND_BASE_URLS = [
  'https://drand.cloudflare.com',
  'https://api.drand.sh',
  'https://api2.drand.sh',
  'https://api3.drand.sh',
];

/**
 * Hash identifier for the drand quicknet chain
 */
const DRAND_QUICKNET_HASH = '52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971';

/**
 * Represents a randomness beacon from the drand network
 */
type DrandRandomnessBeacon = {
  /** The round number of this randomness beacon */
  roundNumber: number;
  /** The random value generated for this round */
  randomness: bigint;
  /** The BLS signature proving the randomness */
  signature: bigint;
};

/**
 * Fetches drand randomness and generates verification calldata in one step.
 * This is a convenience function that combines fetching and calldata generation.
 *
 * @param roundNumber - The specific round to fetch, or 'latest' for the most recent
 * @param chainHash - Hash identifier of the drand chain (defaults to quicknet)
 * @param baseUrls - Array of drand API endpoints to try
 * @returns Promise resolving to calldata array for verifying the drand randomness
 *
 * @example
 * ```typescript
 * // Fetch latest randomness and generate calldata
 * const calldata = await fetchAndGetDrandCallData();
 *
 * // Fetch specific round
 * const roundCalldata = await fetchAndGetDrandCallData(12345);
 * ```
 */
export async function fetchAndGetDrandCallData(roundNumber: number | 'latest' = 'latest', chainHash = DRAND_QUICKNET_HASH, baseUrls = DRAND_BASE_URLS): Promise<bigint[]> {
  return getDrandCallData(await fetchDrandRandomness(roundNumber, chainHash, baseUrls));
}

/**
 * Generates calldata for drand randomness beacon verification.
 * This prepares the data needed to verify a drand signature on-chain.
 *
 * @param beacon - The drand randomness beacon containing round, randomness, and signature
 * @returns Array of bigint values representing the verification calldata
 *
 * @example
 * ```typescript
 * const beacon = {
 *   round: 12345,
 *   randomness: 0x123456789n,
 *   signature: 0xabcdef123n
 * };
 * const calldata = getDrandCallData(beacon);
 * ```
 */
export function getDrandCallData({ roundNumber, randomness, signature }: DrandRandomnessBeacon): bigint[] {
  return drand_calldata_builder([roundNumber, randomness, signature]);
}

/**
 * Fetches randomness data from the drand distributed randomness beacon network.
 * Tries multiple endpoints for reliability and returns the first successful response.
 *
 * @param roundNumberArg - The specific round to fetch, or 'latest' for the most recent
 * @param chainHash - Hash identifier of the drand chain to query
 * @param baseUrls - Array of drand API endpoints to attempt
 * @returns Promise resolving to the randomness beacon data
 * @throws Error if all endpoints fail or return invalid data
 *
 * @example
 * ```typescript
 * // Fetch latest round
 * const latest = await fetchDrandRandomness();
 *
 * // Fetch specific round
 * const round12345 = await fetchDrandRandomness(12345);
 *
 * // Use custom endpoints
 * const custom = await fetchDrandRandomness('latest', 'custom-hash', ['https://custom-drand.com']);
 * ```
 */
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

/**
 * Encrypts the given message for a given drand round number and returns the resulting call data.
 *
 * @param roundNumber The target drand round number to be used in the encryption process.
 * @param message The 16-byte message to be encrypted.
 * @param randomness An optional 16-byte random array used for encryption. Must be generated using a CSPRNG.
 * @return An array of `bigint` values representing the call data for the encryption result.
 * @throws Error if the `message` length is not 16 bytes.
 *
 * @example
 * ```typescript
 * // The round for when the message can be decrypted
 * const roundNumber = 12345;
 *
 * // The clear text for the message
 * const text = 'Hello, world!';
 * const message = new Uint8Array(16);
 * message.set(new TextEncoder().encode(text));
 *
 * // Call data generation
 * const calldata = encryptToDrandRoundAndGetCallData(roundNumber, message);
 * ```
 */
export function encryptToDrandRoundAndGetCallData(roundNumber: number, message: Uint8Array, randomness = randomBytes(16)): bigint[] {
  if (message.length != 16) throw new Error('Message size should be 16');
  if (randomness.length != 16) throw new Error('Randomness size should be 16');
  const messageValue = message.reduce((acc, b) => (acc << 8n) | BigInt(b), 0n);
  const randomnessValue = randomness.reduce((acc, b) => (acc << 8n) | BigInt(b), 0n);
  return drand_tlock_encrypt_calldata_builder([roundNumber, messageValue, randomnessValue]);
}

/**
 * Computes the Poseidon hash function over the BN254 curve.
 * Poseidon is a cryptographic hash function optimized for zero-knowledge circuits.
 *
 * @param x - First input field element
 * @param y - Second input field element
 * @returns The Poseidon hash result as a bigint
 * @throws Error if the hash computation fails or inputs are invalid
 *
 * @example
 * ```typescript
 * const hash = poseidonHashBN254(1n, 2n);
 * console.log(`Poseidon(1, 2) = ${hash.toString(16)}`);
 *
 * // Expected output for (1, 2):
 * // 115CC0F5E7D690413DF64C6B9662E9CF2A3617F2743245519E19607A4417189A
 * ```
 */
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
