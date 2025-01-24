import { useEffect } from "react";
import { Button } from "@nextui-org/button";
import { Chip } from "@nextui-org/chip";
import { Link } from "@nextui-org/link";
import { Modal, ModalContent, ModalHeader, ModalBody, ModalFooter, useDisclosure} from "@nextui-org/modal";
import { Connector, useAccount, useConnect, useDisconnect } from '@starknet-react/core';

import Address from '@/components/Address';
import { CopyIcon } from '@/components/icons';
import { brief } from '@/lib';

export default function WalletConnector() {
  const { isConnected, isDisconnected } = useAccount();

  return (
    <>
      {isDisconnected ? (<Connect />) : null}
      {isConnected ? (<Disconnect />) : null}
    </>
  );
}

function Connect() {
  const { connect, connectors, isIdle, isPending, isSuccess, isError, error, reset } = useConnect();
  const { isOpen, onOpen, onClose } = useDisclosure();

  function onConnectAndClose(connector: Connector): void {
    connect({ connector });
    onClose();
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
      <Button
        color="primary"
        variant="ghost"
        isDisabled={!isIdle && !isSuccess}
        isLoading={isPending}
        onPress={onOpen}
      >
        Connect wallet
      </Button>
      {isError ? errorBox : null}
      <Modal
        size="sm"
        isOpen={isOpen}
        onClose={onClose}
      >
        <ModalContent>
          {(onClose) => (
            <>
              <ModalHeader>Connect wallet</ModalHeader>
              <ModalBody>
                {connectors.map((connector) => (
                  <Button
                    key={connector.id}
                    color="primary"
                    disabled={!connector.available()}
                    isLoading={isPending}
                    onPress={() => onConnectAndClose(connector)}
                  >
                    {connector.name}
                  </Button>
                ))}
              </ModalBody>
              <ModalFooter />
            </>
          )}
        </ModalContent>
      </Modal>
    </>
  );
}

function Disconnect() {
  const { disconnect, isIdle, isPending, isSuccess, isError, error, reset } = useDisconnect({});
  const { address } = useAccount();

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
      <Address
        address={address ?? ''}
        />
      <Button
        color="primary"
        variant="ghost"
        isDisabled={!isIdle && !isSuccess}
        isLoading={isPending}
        onPress={() => disconnect()}
      >
        Disconnect wallet
      </Button>
      {isError ? errorBox : null}
    </>
  );
}
