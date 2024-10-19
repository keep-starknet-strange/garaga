import { Contract, Call, CallData, byteArray } from 'starknet';

import { Poll } from '@/interfaces';

import { VotingContract, ZERO_ADDRESS } from './addresses';
import { VotingContractAbi } from './interfaces';
import { Network, getRpcProvider, addressFromValue } from './networks';

function sleep(delay: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, delay));
}

export async function readAllPollsOrRetry(network: Network): Promise<Poll[]> {
  let polls: Poll[] = [];
  while (true) {
    try {
      polls = await readAllPolls(network);
    } catch (e) {
      // TODO hack to make it work on public rpc node for development
      const message = String(e);
      if (message === 'TypeError: Cannot read properties of undefined (reading \'flat\')') {
        await sleep(1000);
        continue;
      }
    }
    break;
  }
  return polls;
}

// TODO, replace by indexer, use as fallback
export async function readAllPolls(network: Network): Promise<Poll[]> {
  const abi = VotingContractAbi;
  const address = VotingContract[network];
  if (address === ZERO_ADDRESS) return [];
  const provider = getRpcProvider(network);
  const contract = new Contract(abi, address, provider);
  const result: Record<string, unknown>[] = await contract.get_all_votings();
  const polls = await Promise.all(result.map(async (data) => {
    const id = Number(data['id']);
    const [list, value]: [unknown[], unknown] = await Promise.all([
      contract.get_voting_choices(id),
      contract.get_number_voters(id),
    ]);
    const account = addressFromValue(BigInt(String(data['creator'])));
    const time = 0; // TODO set poll creation time
    const question = String(data['question']);
    const answers = list.map((value) => String(value)); 
    const expirationTime = Number(data['reveal_date']);
    const voterCount = Number(value);
    let winner = null;
    let tally = null;
    const done = Boolean(data['is_solved']);
    if (done) {
      const [value, list]: [unknown, unknown[]] = await Promise.all([
        contract.get_voting_winner_choice_id(id),
        contract.get_voting_results(id),
      ]);
      winner = Number(value);
      tally = list.map((value) => Number(value));
    }
    return { id, account, time, question, answers, expirationTime, voterCount, winner, tally };
  }));
  return polls;
}

// TODO replace by indexer, use as fallback
export async function readPoll(network: Network, id: number): Promise<Poll | null> {
  const abi = VotingContractAbi;
  const address = VotingContract[network];
  if (address === ZERO_ADDRESS) return null;
  const provider = getRpcProvider(network);
  const contract = new Contract(abi, address, provider);
  const result: Record<string, unknown> = await contract.get_voting(id);
  const poll = await (async (data) => {
    const id = Number(data['id']);
    const [list, value]: [unknown[], unknown] = await Promise.all([
      contract.get_voting_choices(id),
      contract.get_number_voters(id),
    ]);
    const account = addressFromValue(BigInt(String(data['creator'])));
    const time = 0; // TODO set poll creation time
    const question = String(data['question']);
    const answers = list.map((value) => String(value)); 
    const expirationTime = Number(data['reveal_date']);
    const voterCount = Number(value);
    let winner = null;
    let tally = null;
    const done = Boolean(data['is_solved']);
    if (done) {
      const [value, list]: [unknown, unknown[]] = await Promise.all([
        contract.get_voting_winner_choice_id(id),
        contract.get_voting_results(id),
      ]);
      winner = Number(value);
      tally = list.map((value) => Number(value));
    }
    return { id, account, time, question, answers, expirationTime, voterCount, winner, tally };
  })(result);
  if (poll.id !== id) return null;
  return poll;
}

export async function readPollAnswers(network: Network, id: number): Promise<string[]> {
  const abi = VotingContractAbi;
  const address = VotingContract[network];
  if (address === ZERO_ADDRESS) return [];
  const provider = getRpcProvider(network);
  const contract = new Contract(abi, address, provider);
  const list: unknown[] = await contract.get_voting_choices(id);
  const answers = list.map((value) => String(value));
  return answers;
}

export async function readPollVoterCount(network: Network, id: number): Promise<number> {
  const abi = VotingContractAbi;
  const address = VotingContract[network];
  if (address === ZERO_ADDRESS) return 0;
  const provider = getRpcProvider(network);
  const contract = new Contract(abi, address, provider);
  const value: unknown = await contract.get_number_voters(id);
  const voterCount = Number(value);
  return voterCount;
}

export async function readPollTally(network: Network, id: number): Promise<number[]> {
  const abi = VotingContractAbi;
  const address = VotingContract[network];
  if (address === ZERO_ADDRESS) return [];
  const provider = getRpcProvider(network);
  const contract = new Contract(abi, address, provider);
  const list: unknown[] = await contract.get_voting_results(id);
  const tally = list.map((value) => Number(value));
  return tally;
}

export function buildCreatePoll(network: Network, question: string, answers: string[], expirationTime: number): Call {
  const abi = VotingContractAbi;
  const address = VotingContract[network];
  const contract = new Contract(abi, address);
  const _question = byteArray.byteArrayFromString(question);
  const _answers = answers.map((answer) => byteArray.byteArrayFromString(answer));
  const calldata = CallData.compile([_question, expirationTime, _answers]);
  return contract.populate('create_voting', calldata);
}

export function buildVote(network: Network, pollId: number, answerId: number): Call {
  const abi = VotingContractAbi;
  const address = VotingContract[network];
  const contract = new Contract(abi, address);
  const calldata = CallData.compile([pollId, answerId]);
  return contract.populate('vote', calldata);
}

export function buildTally(network: Network, pollId: number): Call {
  const abi = VotingContractAbi;
  const address = VotingContract[network];
  const contract = new Contract(abi, address);
  const calldata = CallData.compile([pollId]);
  return contract.populate('solve_voting', calldata);
}
