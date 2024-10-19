import { StarknetConfig, publicProvider, argent, braavos, useInjectedConnectors, voyager } from '@starknet-react/core';
import { mainnet, sepolia } from '@starknet-react/chains';

export default function StarknetProvider({ children }: Readonly<{ children: React.ReactNode }>) {
  const chains = [mainnet, sepolia];
  const provider = publicProvider();
  const { connectors } = useInjectedConnectors({
    recommended: [ argent(), braavos() ],
    includeRecommended: 'onlyIfNoConnectors',
    order: 'alphabetical',
  });
  const explorer = voyager;
  return (
    <StarknetConfig chains={chains} provider={provider} connectors={connectors} explorer={explorer}>
      {children}
    </StarknetConfig>
  );
}
