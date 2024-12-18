import { useState } from 'react';
import { Button } from "@nextui-org/button";
import { Checkbox } from "@nextui-org/checkbox";
import { Divider } from "@nextui-org/divider";
import { Modal, ModalContent, ModalHeader, ModalBody, ModalFooter, useDisclosure } from "@nextui-org/modal";
import { Progress } from "@nextui-org/progress";

import { Poll } from '@/interfaces';

export default function ViewResultButton({ poll }: { poll: Poll }) {
  const [showDetails, setShowDetails] = useState(false);
  const { isOpen, onOpen, onClose } = useDisclosure();

  function clear(): void {
    setShowDetails(false);
  }

  function clearAndOpen(): void {
    clear();
    onOpen();
  }

  function votesLabel(count: number): string {
    return count + ' vote' + (count !== 1 ? 's' : '');
  } 

  function votesPercent(count: number): number {
    if (poll.voterCount === 0) return 0; 
    return 100 * count / poll.voterCount;
  }

  return (
    <>
      <Button
        color="primary"
        variant="ghost"
        onPress={clearAndOpen}
      >
        View results
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
              <ModalHeader>Results for poll</ModalHeader>
              <ModalBody>
                <span>{`Q: ${poll.question}`}</span>
                <Divider />
                {poll.answers.map((answer, index) => (
                  <>
                    <span>{`A${index + 1}:`}&nbsp;{answer}</span>
                    <Progress
                      size="md"
                      aria-label={answer}
                      color={poll.winner === index ? "success" : "default"}
                      label={showDetails ? votesLabel(poll.tally![index] ?? 0) : ''}
                      value={votesPercent(poll.tally![index] ?? 0)}
                      showValueLabel={showDetails}
                      />
                  </>
                ))}
                {showDetails ? <span>Total: {votesLabel(poll.voterCount)}</span> : null}
                <Checkbox
                  size="sm"
                  defaultSelected={showDetails}
                  onValueChange={setShowDetails}
                  >
                  Show details
                </Checkbox>
              </ModalBody>
              <ModalFooter>
                <Button
                  variant="light"
                  onPress={onClose}
                  >
                  Dismiss
                </Button>
              </ModalFooter>
            </>
          )}
        </ModalContent>
      </Modal>
    </>
  );
}
