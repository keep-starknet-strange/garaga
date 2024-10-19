import type { Config, NetworkOptions } from "https://esm.sh/@apibara/indexer";
import type { Postgres } from "https://esm.sh/@apibara/indexer/sink/postgres";
import type { Block, FieldElement, Filter } from "https://esm.sh/@apibara/indexer/starknet";
import type { Abi } from "https://esm.sh/starknet";
import { num, events, CallData } from "https://esm.sh/starknet";

type Network = 'mainnet' | 'sepolia';

const NETWORKS: readonly Network[] = ['mainnet', 'sepolia'];

function isNetwork(network: string): network is Network {
  const networks: readonly string[] = NETWORKS;
  return networks.includes(network);
}

type NetworkConfig = {
  streamUrl: string;
  startingBlock: number;
  contractAddress: FieldElement;
};

const NETWORK_CONFIG: { [key in Network]: NetworkConfig } = {
  'mainnet': {
    streamUrl: "https://mainnet.starknet.a5a.ch",
    startingBlock: 806_862, // TODO update mainnet contract deployment block number
    contractAddress: "0x0000000000000000000000000000000000000000000000000000000000000000", // TODO update mainnet contract address
    connectionString: "postgres://indexer_user:indexer_password@mainnet-postgres:5432/indexer_db",
  },
  'sepolia': {
    streamUrl: "https://sepolia.starknet.a5a.ch",
    startingBlock: 227_772,
    contractAddress: "0x02f26c14b36fe9c110301586e66e9af60861a4f91b10284362503e6d3a6a13e6",
    connectionString: "postgres://indexer_user:indexer_password@sepolia-postgres:5432/indexer_db",
  }
}

const NETWORK = Deno.env.get("NETWORK");
const network = isNetwork(NETWORK) ? NETWORK : 'mainnet';
const networkConfig = NETWORK_CONFIG[network];

const VotingContractAbi: Abi = JSON.parse(await Deno.readTextFile("./abis/voting_contract.json"));
const VotingContractAbiEvents = events.getAbiEvents(VotingContractAbi);
const VotingContractAbiStructs =  CallData.getAbiStruct(VotingContractAbi);
const VotingContractAbiEnums = CallData.getAbiEnum(VotingContractAbi);

export const config: Config<NetworkOptions, Postgres> = {
  streamUrl: networkConfig.streamUrl,
  startingBlock: networkConfig.startingBlock,
  network: "starknet",
  finality: "DATA_STATUS_ACCEPTED",
  filter: {
    header: { weak: true },
    events: [{ fromAddress: networkConfig.contractAddress, includeReceipt: false }],
  },
  sinkType: "postgres",
  sinkOptions: {
    connectionString: networkConfig.connectionString,
    tableName: "polls",
    entityMode: true,
  },
};

export default function transform(block: Block): unknown[] {
  const blockEvents = block.events.map(({ event: { keys, data } }) => ({ keys: keys.map((key) => num.cleanHex(key)), data }));
  const data = events.parseEvents(blockEvents, VotingContractAbiEvents, VotingContractAbiStructs, VotingContractAbiEnums);
  return data.flatMap((item) => {
    const [name] = Object.keys(item);
    const [values] = Object.values(item);
    switch (name) {
      case "voting::contracts::voting_contract::VotingContract::VotingCreated": {
        const id = Number(values['id']);
        const account = String(num.toStorageKey(values['creator']));
        const time = Math.floor(Date.parse(block.header.timestamp) / 1000);
        const question = String(values['question']);
        const expirationTime = Number(values['reveal_date']);
        return {
          insert: {
            'id': id,
            'account': account,
            'time': time,
            'question': question,
            'answers': [], // TODO update answers
            'expiration_time': expirationTime,
            'voter_count': 0,
            'winner': null,
            'tally': null,
          },
        };
      }
      case "voting::contracts::voting_contract::VotingContract::VotingSolved": {
        const id = Number(values['id']);
        const winner = Number(values['winner_choice_id']);
        return {
          entity: { 'id': id },
          update: { 'winner': winner, 'tally': [] }, // TODO update tally
        };
      }
      case "voting::contracts::voting_contract::VotingContract::VoterAddressAdded": {
        const id = Number(values['voting_id']);
        const account = String(num.toStorageKey(values['voter']));
        return {
          entity: { 'id': id },
          update: { 'voter_count': 1 }, // TODO increment voteCount
        };
      }
      case "voting::contracts::voting_contract::VotingContract::VoteCast": {
        const id = Number(values['voting_id']);
        const account = String(num.toStorageKey(values['voter']));
        return {
          entity: { 'id': id },
          update: { }, // do nothing
        };
      }
      default: return [];
    }
  });
}
