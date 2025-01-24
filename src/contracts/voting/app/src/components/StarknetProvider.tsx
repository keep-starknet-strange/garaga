import { InjectedConnector, StarknetConfig, publicProvider, argent, braavos, useInjectedConnectors, voyager } from '@starknet-react/core';
import { mainnet, sepolia } from '@starknet-react/chains';

function okxwallet(): InjectedConnector {
  return new InjectedConnector({
    options: {
      id: "okxwallet",
      name: "OKX Wallet",
    },
  });
}

export default function StarknetProvider({ children }: Readonly<{ children: React.ReactNode }>) {
  const chains = [mainnet, sepolia];
  const provider = publicProvider();
  const { connectors } = useInjectedConnectors({
    recommended: [ argent(), braavos(), okxwallet() ],
    includeRecommended: 'always',
    order: 'alphabetical',
  });
  const explorer = voyager;
  return (
    <StarknetConfig chains={chains} provider={provider} connectors={connectors} explorer={explorer}>
      {children}
    </StarknetConfig>
  );
}
