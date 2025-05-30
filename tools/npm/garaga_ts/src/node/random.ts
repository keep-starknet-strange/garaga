/* This code was extracted from https://github.com/paulmillr/noble-hashes.git */

/**
 * Internal webcrypto alias.
 * We use WebCrypto aka globalThis.crypto, which exists in browsers and node.js 16+.
 */
declare const globalThis: Record<string, any> | undefined;
export const crypto: any =
  typeof globalThis === 'object' && 'crypto' in globalThis ? globalThis.crypto : undefined;

/** Cryptographically secure PRNG. Uses internal OS-level `crypto.getRandomValues`. */
export function randomBytes(bytesLength = 32): Uint8Array {
  if (crypto && typeof crypto.getRandomValues === 'function') {
    return crypto.getRandomValues(new Uint8Array(bytesLength));
  }
  // Legacy Node.js compatibility
  if (crypto && typeof crypto.randomBytes === 'function') {
    return Uint8Array.from(crypto.randomBytes(bytesLength));
  }
  throw new Error('crypto.getRandomValues must be defined');
}
