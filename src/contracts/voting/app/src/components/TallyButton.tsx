import { useEffect } from "react";
import { Button } from "@nextui-org/button";
import { Chip } from "@nextui-org/chip";
import { Divider } from "@nextui-org/divider";
import { Link } from "@nextui-org/link";
import { Modal, ModalContent, ModalHeader, ModalBody, ModalFooter, useDisclosure } from "@nextui-org/modal";
import { useAccount, useNetwork, useSendTransaction, useExplorer } from '@starknet-react/core';

import { LinkIcon } from '@/components/icons';
import { isNetwork, buildTally } from '@/client';
import { Poll } from '@/interfaces';
import { brief } from '@/lib';

export default function TallyButton({ poll }: { poll: Poll }) {
  const { isOpen, onOpen, onClose } = useDisclosure();
  const { chain } = useNetwork();
  const { isConnected } = useAccount();
  const network = isNetwork(chain.network) ? chain.network : 'mainnet';
  const { data, send, isIdle, isPending, isSuccess, isError, error, reset } = useSendTransaction({
    calls: [buildTally(network, poll.id)],
  });
  const explorer = useExplorer();

  function clear(): void {
    reset();
  }

  function clearAndOpen(): void {
    clear();
    onOpen();
  }

  function validateAndSend(): void {
    send()
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

  const successBox = (
    <Chip
      color="success"
      size="md"
      radius="sm"
      variant="flat"
      >
      Transaction hash: <Link
        isExternal
        color="foreground"
        href={explorer.transaction(data?.transaction_hash ?? '')}
        >
        {brief(data?.transaction_hash ?? '', 6, 4)}&nbsp;<LinkIcon />
      </Link>
    </Chip>
  );

  return (
    <>
      <Button
        color="secondary"
        isDisabled={!isConnected}
        onPress={clearAndOpen}
      >
        Tally
      </Button>
      <Modal
        size="xl"
        scrollBehavior="inside"
        isOpen={isOpen}
        onClose={onClose}
      >
        <ModalContent>
          {(onClose) => (
            <>
              <ModalHeader>Tally poll</ModalHeader>
              <ModalBody>
                {isError ? errorBox : null}
                {isSuccess ? successBox : null}
                <span>{`Q: ${poll.question}`}</span>
                <Divider />
                <Chip color="warning" variant="dot">This will totalize and publish the results for this poll.</Chip>
              </ModalBody>
              <ModalFooter>
                <Button
                  variant="light"
                  onPress={onClose}
                  >
                  Dismiss
                </Button>
                {isSuccess ? null : (
                  <Button
                    color="primary"
                    isDisabled={!isIdle && !isSuccess}
                    isLoading={isPending}
                    onPress={validateAndSend}
                    >
                    Transact
                  </Button>
                )}
              </ModalFooter>
            </>
          )}
        </ModalContent>
      </Modal>
    </>
  );
}
