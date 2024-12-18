import { Network } from './networks';

type Address = `0x${string}`;

type NetworkAddressMap = Readonly<{ [key in Network]: Address }>;

export const ZERO_ADDRESS: Address = '0x0000000000000000000000000000000000000000000000000000000000000000';

export const ETH: NetworkAddressMap = {
  'mainnet': '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7',
  'sepolia': '0x049d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7',
};

export const STRK: NetworkAddressMap = {
  'mainnet': '0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d',
  'sepolia': '0x04718f5a0fc34cc1af16a1cdee98ffb20c31f5cd61d6ab07201858f4287c938d',
};

export const VotingContract: NetworkAddressMap = {
  'mainnet': '0x0000000000000000000000000000000000000000000000000000000000000000', // TODO set mainnet address
  'sepolia': '0x02f26c14b36fe9c110301586e66e9af60861a4f91b10284362503e6d3a6a13e6',
};
