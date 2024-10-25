CREATE TABLE IF NOT EXISTS polls (
  id integer,
  account char(66),
  time integer,
  question text,
  answers text[],
  expiration_time integer,
  voter_count integer,
  winner integer,
  tally integer[],
  _cursor int8range
);

CREATE INDEX IF NOT EXISTS idx_id ON polls(id);
CREATE INDEX IF NOT EXISTS idx_account ON polls(account);
CREATE INDEX IF NOT EXISTS idx_time ON polls(time);
CREATE INDEX IF NOT EXISTS idx_question ON polls(question);
CREATE INDEX IF NOT EXISTS idx_expiration_time ON polls(expiration_time);
CREATE INDEX IF NOT EXISTS idx_voter_count ON polls(voter_count);

CREATE OR REPLACE VIEW polls_latest AS
SELECT * FROM polls WHERE upper_inf(_cursor);
