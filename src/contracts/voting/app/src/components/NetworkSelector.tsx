import { useEffect } from "react";
import { Chip } from "@nextui-org/chip";
import { Select, SelectItem } from "@nextui-org/select";
import { Chain } from "@starknet-react/chains";
import { useAccount, useNetwork, useSwitchChain } from '@starknet-react/core';

import { NETWORKS, isNetwork, getChainId } from '@/client';

export default function NetworkSelector() {
  const { chain } = useNetwork();
  const { switchChain, isIdle, isPending, isSuccess, isError, error, reset } = useSwitchChain({});
  const { isConnected } = useAccount();

  function selectNetwork(network: string): void {
    if (isNetwork(network)) {
      switchChain({ chainId: getChainId(network) });
    }
  }

  useEffect(() => {
    if (!isError) return;
    const timer = setTimeout(reset, 10000); // 10s
    return () => clearTimeout(timer);
  }, [isError, reset]);

  const errorBox = (
    <Chip
      color="warning"
      size="md"
      radius="sm"
      variant="flat"
      onClose={reset}
      >
      {error?.message}
    </Chip>
  );

  return (
    <>
      <Select
        size="md"
        label="Network"
        disallowEmptySelection={true}
        isDisabled={!isIdle && !isSuccess}
        isLoading={isPending}
        selectedKeys={[chain.network]}
        disabledKeys={isConnected ? [] : ['sepolia']}
        onSelectionChange={({ currentKey }) => selectNetwork(currentKey ?? '')}
      >
        {NETWORKS.map((network) => (
          <SelectItem key={network}>
            {network}
          </SelectItem>
        ))}
      </Select>
      {isError ? errorBox : null}
    </>
  );
}
