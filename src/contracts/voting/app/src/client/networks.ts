import { constants, RpcProvider } from 'starknet';

export type Network = 'mainnet' | 'sepolia';

export const NETWORKS: readonly Network[] = ['mainnet', 'sepolia'];

export function isNetwork(network: string): network is Network {
  const networks: readonly string[] = NETWORKS;
  return networks.includes(network);
}

export function getChainId(network: Network): string {
  switch (network) {
  case 'mainnet': return constants.StarknetChainId.SN_MAIN;
  case 'sepolia': return constants.StarknetChainId.SN_SEPOLIA;
  }
}

export function getRpcProvider(network: Network): RpcProvider {
  // TODO replace public node url to remove warning
  switch (network) {
  case 'mainnet': return new RpcProvider({ nodeUrl: constants.NetworkName.SN_MAIN });
  case 'sepolia': return new RpcProvider({ nodeUrl: constants.NetworkName.SN_SEPOLIA });
  }
}

export function addressFromValue(value: bigint): string {
  return '0x' + value.toString(16).toLowerCase().padStart(64, '0');
}
