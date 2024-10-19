import { useState, useEffect } from "react";
import { Button } from "@nextui-org/button";
import { Chip } from "@nextui-org/chip";
import { Divider } from "@nextui-org/divider";
import { Link } from "@nextui-org/link";
import { Modal, ModalContent, ModalHeader, ModalBody, ModalFooter, useDisclosure } from "@nextui-org/modal";
import { RadioGroup, Radio } from "@nextui-org/radio";
import { useAccount, useNetwork, useSendTransaction, useExplorer } from '@starknet-react/core';

import { LinkIcon } from '@/components/icons';
import { isNetwork, buildVote } from '@/client';
import { Poll } from '@/interfaces';
import { brief } from '@/lib';

export default function VoteButton({ poll }: { poll: Poll }) {
  const [answerId, setAnswerId] = useState(-1);
  const [validating, setValidating] = useState(false);
  const { isOpen, onOpen, onClose } = useDisclosure();
  const { chain } = useNetwork();
  const { isConnected } = useAccount();
  const network = isNetwork(chain.network) ? chain.network : 'mainnet';
  const { data, send, isIdle, isPending, isSuccess, isError, error, reset } = useSendTransaction({
    calls: [buildVote(network, poll.id, answerId)],
  });
  const explorer = useExplorer();

  function clear(): void {
    setAnswerId(-1);
    setValidating(false);
    reset();
  }

  function clearAndOpen(): void {
    clear();
    onOpen();
  }

  function validateAndSend(): void {
    if (!(0 <= answerId && answerId < poll.answers.length)) {
      setValidating(true);
    } else {
      send()
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
        color="primary"
        isDisabled={!isConnected}
        onPress={clearAndOpen}
      >
        Vote
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
              <ModalHeader>Vote in poll</ModalHeader>
              <ModalBody>
                {isError ? errorBox : null}
                {isSuccess ? successBox : null}
                <span>{`Q: ${poll.question}`}</span>
                <Divider />
                <RadioGroup
                  size="md"
                  label="Your answer"
                  isDisabled={!isIdle}
                  value={String(answerId)}
                  isInvalid={validating && !(0 <= answerId && answerId < poll.answers.length)}
                  errorMessage="Please select an answer"
                  onValueChange={(value) => setAnswerId(Number(value))}
                  >
                  {poll.answers.map((answer, index) => (
                    <span>
                    {`A${index + 1}:`}&nbsp;<Radio key={index} value={String(index)} >{answer}</Radio>
                    </span>
                  ))}
                </RadioGroup>
                <Chip color="warning" variant="dot">This will cast or change your vote in this poll.</Chip>
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
