import { Pool } from 'pg';

import { Network, readPollAnswers, readPollVoterCount, readPollTally } from '@/client';
import { Poll } from '@/interfaces';

const INTERNAL_USE = false;

const INTERNAL_CONFIG: { [key in Network]: [string, number] } = {
  'mainnet': ['mainnet-postgres', 5432],
  'sepolia': ['sepolia-postgres', 5432],
} 

const EXTERNAL_CONFIG: { [key in Network]: [string, number] } = {
  'mainnet': ['localhost', 5432],
  'sepolia': ['localhost', 5433],
} 

function instantiatePool(network: Network): Pool {
  const config = INTERNAL_USE ? INTERNAL_CONFIG : EXTERNAL_CONFIG;
  const [host, port] = config[network];
  const user = 'indexer_user';
  const password = 'indexer_password';
  const database = 'indexer_db';
  return new Pool({ host, port, user, password, database });
}

async function parsePoll(network: Network, data: Record<string, unknown>): Promise<Poll> {
  const id = Number(data['id']);
  const account = String(data['account']);
  const time = Number(data['time']);
  const question = String(data['question']);
  let answers = Array.isArray(data['answers']) ? data['answers'].map((answer) => String(answer)) : [];
  const expirationTime = Number(data['expiration_time']);
  let voterCount = Number(data['voter_count']);
  const winner = data['winner'] === null ? null : Number(data['winner']);
  let tally = Array.isArray(data['tally']) ? data['tally'].map((count) => Number(count)) : null;
  if (answers.length === 0) {
    // TODO remove this once contract/indexer is patched
    answers = await readPollAnswers(network, id);
    voterCount = await readPollVoterCount(network, id);
    if (winner !== null) {
      tally = await readPollTally(network, id);
    }
  }
  return { id, account, time, question, answers, expirationTime, voterCount, winner, tally };
}

export async function queryPolls(network: Network, offset: number, limit: number): Promise<{ count: number; polls: Poll[] }> {
  const filter = 'TRUE'; // TODO implement filters
  const sorter = 'id ASC'; // TODO implement sorters
  const pool = instantiatePool(network);
  const result = await pool.query(`
    SELECT
      *,
      (SELECT COUNT(*) FROM polls_latest WHERE ${filter}) AS count
    FROM polls_latest
    WHERE ${filter}
    ORDER BY ${sorter}
    LIMIT ${limit}
    OFFSET ${offset};
  `);
  const count = result.rows.length == 0 ? 0 : Number(result.rows[0].count);
  const polls = await Promise.all(result.rows.map((row) => parsePoll(network, row)));
  return { count, polls };
}

export async function queryPoll(network: Network, id: number): Promise<Poll | null> {
  const pool = instantiatePool(network);
  const result = await pool.query(`SELECT * FROM polls_latest WHERE id = ${id};`);
  const poll = result.rows.length == 0 ? null : await parsePoll(network, result.rows[0]);
  return poll;
}
