import { HttpCachingChain, HttpChainClient, roundAt, timelockEncrypt, timelockDecrypt } from 'tlock-js';

export type Beacon = 'quicknet' | 'default';

export const BEACONS: readonly Beacon[] = ['quicknet', 'default'];

export function isBeacon(beacon: string): beacon is Beacon {
  const beacons: readonly string[] = BEACONS;
  return beacons.includes(beacon);
}

type ChainParams = Readonly<{
  chainHash: string;
  publicKey: string;
}>;

type BeaconChainParamsMap = Readonly<{ [key in Beacon]: ChainParams }>;

const CHAIN_PARAMS: BeaconChainParamsMap = {
  'quicknet': {
    chainHash: '52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971',
    publicKey: '83cf0f2896adee7eb8b5f01fcad3912212c437e0073e911fb90022d3e760183c8c4b450b6a0a6c3ac6a5776a2d1064510d1fec758c921cc22b0e17e63aaf4bcb5ed66304de9cf809bd274ca73bab4af5a6e9c76a4bc09e76eae8991ef5ece45a',
  },
  'default': {
    chainHash: '8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce',
    publicKey: '868f005eb8e6e4ca0a47c8a77ceaa5309a47978a7c71bc5cce96366b5d7a569937c529eeda66c7293784a9402801af31',
  },
}

function getHttpChainClient(beacon: Beacon): HttpChainClient {
  const { chainHash, publicKey } = CHAIN_PARAMS[beacon];
  const chainUrl = 'https://api.drand.sh/' + chainHash;
  const chainVerificationParams = { chainHash, publicKey };
  const disableBeaconVerification = false;
  const noCache = false;
  const clientOptions = { chainVerificationParams, disableBeaconVerification, noCache };
  return new HttpChainClient(new HttpCachingChain(chainUrl, clientOptions), clientOptions, {});
}

export async function encrypt(beacon: Beacon, plainText: string, decryptTime: number): Promise<string> {
  const client = getHttpChainClient(beacon);
  const chainInfo = await client.chain().info();
  const roundNumber = roundAt(decryptTime * 1000, chainInfo);
  const inputBuffer = Buffer.from(plainText);
  const cipherText = await timelockEncrypt(roundNumber, inputBuffer, client);
  return cipherText;
}

export async function decrypt(beacon: Beacon, cipherText: string): Promise<string> {
  const client = getHttpChainClient(beacon);
  const outputBuffer = await timelockDecrypt(cipherText, client); 
  const plainText = outputBuffer.toString(); 
  return plainText;
}
