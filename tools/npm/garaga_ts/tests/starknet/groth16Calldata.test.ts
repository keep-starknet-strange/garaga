import { createHash } from "crypto";
import { readFileSync } from "fs";
import assert from "node:assert/strict";
import { describe, test } from "node:test";
import {
  parseGroth16ProofFromJson,
  parseGroth16VerifyingKeyFromJson,
} from "../../src/node/starknet/groth16ContractGenerator/parsingUtils.js";
import * as garaga from "../../src/node/index.js";

const PATH = "../../../hydra/garaga/starknet/groth16_contract_generator/examples";

type CalldataVector = {
  name: string;
  proof: string;
  vk: string;
  public_inputs: string | null;
  length: number;
  sha256: string;
};

const vectors: CalldataVector[] = JSON.parse(
  readFileSync(PATH + "/groth16_calldata_test_vectors.json", "utf8"),
);

describe("Groth16 calldata conformance", () => {
  for (const vector of vectors) {
    test(`${vector.name} matches the Python reference`, async () => {
      await garaga.init();

      const vk = parseGroth16VerifyingKeyFromJson(PATH + "/" + vector.vk);
      const proof = parseGroth16ProofFromJson(
        PATH + "/" + vector.proof,
        vector.public_inputs ? PATH + "/" + vector.public_inputs : null,
      );
      const calldata = garaga.getGroth16CallData(proof, vk, proof.a.curveId);

      assert.equal(calldata.length, vector.length);
      assert.equal(calldata[0], BigInt(calldata.length - 1));
      // Decimal ASCII words, separated by one newline with no trailing newline.
      const digest = createHash("sha256")
        .update(calldata.map(String).join("\n"), "ascii")
        .digest("hex");
      assert.equal(digest, vector.sha256);
    });
  }
});
