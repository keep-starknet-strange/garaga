import { useState, useEffect } from "react";
import { parseAbsoluteToLocal } from "@internationalized/date";
import { Button } from "@nextui-org/button";
import { Chip } from "@nextui-org/chip";
import { DatePicker } from "@nextui-org/date-picker";
import { Divider } from "@nextui-org/divider";
import { Input } from "@nextui-org/input";
import { Link } from "@nextui-org/link";
import { Modal, ModalContent, ModalHeader, ModalBody, ModalFooter, useDisclosure } from "@nextui-org/modal";
import { RadioGroup, Radio } from "@nextui-org/radio";
import { Select, SelectItem } from "@nextui-org/select";
import { useAccount, useNetwork, useSendTransaction, useExplorer } from '@starknet-react/core';

import { LinkIcon } from '@/components/icons';
import { isNetwork, buildCreatePoll } from '@/client';
import { brief } from '@/lib';

type Mode = 'duration' | 'deadline';

const MODES: readonly Mode[] = ['duration', 'deadline'];

function isMode(mode: string): mode is Mode {
  const modes: readonly string[] = MODES;
  return modes.includes(mode);
}

type Interval = 'minutes' | 'hours' | 'days' | 'weeks';

const INTERVALS: readonly Interval[] = ['minutes', 'hours', 'days', 'weeks'];

function isInterval(interval: string): interval is Interval {
  const intervals: readonly string[] = INTERVALS;
  return intervals.includes(interval);
}

const UNITS: Readonly<{ [key in Interval]: number }> = {
  'minutes': 60,
  'hours': 60 * 60,
  'days': 24 * 60 * 60,
  'weeks': 7 * 24 * 60 * 60,
};

export default function CreatePollButton() {
  const now = Math.floor(Date.now() / 1000);
  const [question, setQuestion] = useState('');
  const [answers, setAnswers] = useState<string[]>([]);
  const [mode, setMode] = useState<Mode>('duration');
  const [duration, setDuration] = useState<[number, Interval]>([0, 'minutes']);
  const [deadline, setDeadline] = useState(0);
  const [validating, setValidating] = useState(false);
  const expirationTime = mode === 'deadline' ? deadline : now + duration[0] * UNITS[duration[1]];
  const { isOpen, onOpen, onClose } = useDisclosure();
  const { chain } = useNetwork();
  const { isConnected } = useAccount();
  const network = isNetwork(chain.network) ? chain.network : 'mainnet';
  const { data, send, isIdle, isPending, isSuccess, isError, error, reset } = useSendTransaction({
    calls: [buildCreatePoll(network, question, answers, expirationTime)],
  });
  const explorer = useExplorer();

  function clear(): void {
    setQuestion('');
    setAnswers(['', '']);
    setMode('deadline');
    setDuration([0, 'hours']);
    setDeadline(now);
    setValidating(false);
    reset();
  }

  function setAnswer(index: number, value: string): void {
    setAnswers([...answers.slice(0, index), value, ...answers.slice(index + 1)]);
  }

  function insertAnswer(): void {
    setAnswers([...answers, '']);
  };

  function removeAnswer(): void {
    setAnswers(answers.slice(0, -1));
  };

  function clearAndOpen(): void {
    clear();
    onOpen();
  }

  function validateAndSend(): void {
    if (isInvalidText(question) || answers.length < 2 || answers.some(isInvalidText) || (mode === 'duration' && duration[0] <= 0) || (mode === 'deadline' && deadline <= now)) {
      setValidating(true);
    } else {
      send()
    }
  }

  function isInvalidText(text: string): boolean {
    return text.length === 0;
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
        New poll
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
              <ModalHeader>Create a new poll</ModalHeader>
              <ModalBody>
                {isError ? errorBox : null}
                {isSuccess ? successBox : null}
                <Input
                  size="lg"
                  type="text"
                  variant="underlined"
                  labelPlacement="outside-left"
                  label="Q:"
                  placeholder="Question?"
                  defaultValue={question}
                  isDisabled={!isIdle}
                  isInvalid={validating && isInvalidText(question)}
                  errorMessage="Please enter a valid text"
                  onValueChange={(value) => setQuestion(value.trim())}
                  />
                <Divider />
                {answers.map((answer, index) => (
                  <Input
                    key={index}
                    size="md"
                    type="text"
                    variant="underlined"
                    labelPlacement="outside-left"
                    label={`A${index + 1}:`}
                    placeholder={`Answer #${index + 1}`}
                    defaultValue={answer}
                    isDisabled={!isIdle}
                    isInvalid={validating && isInvalidText(answer)}
                    errorMessage="Please enter a valid text"
                    onValueChange={(value) => setAnswer(index, value.trim())}
                    />
                ))}
                <div>
                  <Button size="sm" isDisabled={!isIdle || answers.length <= 2} onPress={removeAnswer}>-</Button>
                  <Button size="sm" isDisabled={!isIdle} onPress={insertAnswer}>+</Button>
                </div>
                <Divider />
                {/*
                <RadioGroup
                  size="md"
                  label="Duration"
                  isDisabled={!isIdle}
                  value={mode}
                  onValueChange={(value) => setMode(isMode(value) ? value : 'duration')}
                  >
                */}
                  {/*
                  <div>
                    <Radio value="duration">For</Radio>
                    <Input
                      size="sm"
                      type="number"
                      placeholder="0"
                      value={String(duration[0])}
                      isDisabled={!isIdle || mode !== 'duration'}
                      isInvalid={validating && mode === 'duration' && duration[0] <= 0}
                      errorMessage="Please enter a positive number"
                      onValueChange={(value) => setDuration([Number(value), duration[1]])}
                      />
                    <Select
                      aria-label="unit"
                      size="sm"
                      disallowEmptySelection={true}
                      isDisabled={!isIdle || mode !== 'duration'}
                      selectedKeys={[duration[1]]}
                      onSelectionChange={({ currentKey }) => {
                        const value = currentKey ?? '';
                        setDuration([duration[0], isInterval(value) ? value : 'hours']);
                      }}
                    >
                      {INTERVALS.map((interval) => (
                        <SelectItem key={interval}>{interval}</SelectItem>
                      ))}
                    </Select>
                  </div>
                  */}
                  <div>
                    {/*
                    <Radio value="deadline">Until</Radio>
                    */}
                    <DatePicker
                      aria-label="date and time"
                      size="sm"
                      hideTimeZone
                      hourCycle={24}
                      granularity="second"
                      label="Closes"
                      isDisabled={!isIdle || mode !== 'deadline'}
                      isInvalid={validating && mode === 'deadline' && deadline <= now}
                      errorMessage="Please enter a future date/time"
                      value={parseAbsoluteToLocal(new Date(deadline * 1000).toISOString().slice(0, -5) + 'Z')}
                      onChange={(value) => setDeadline(Math.floor(new Date(value.toString().slice(0, 25)).getTime() / 1000))}
                      />
                  </div>
                {/*
                </RadioGroup>
                */}
                <Chip color="warning" variant="dot">This will create and open a new poll.</Chip>
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
