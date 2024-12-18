export type Poll = {
  id: number;
  account: string;
  time: number;
  question: string;
  answers: string[];
  expirationTime: number;
  voterCount: number;
  winner: number | null;
  tally: number[] | null;
};

export type Vote = {
  id: number;
  account: string;
  time: number;
  encryptedVote: string;
};
