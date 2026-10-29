import { createHash } from "crypto";
import { readFileSync } from "fs";
import {
  parseGroth16ProofFromJson,
  parseGroth16VerifyingKeyFromJson,
} from "../../src/node/starknet/groth16ContractGenerator/parsingUtils";
import * as garaga from "../../src/node/index";

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
  test.each(vectors)("$name matches the Python reference", async (vector) => {
    await garaga.init();

    const vk = parseGroth16VerifyingKeyFromJson(PATH + "/" + vector.vk);
    const proof = parseGroth16ProofFromJson(
      PATH + "/" + vector.proof,
      vector.public_inputs ? PATH + "/" + vector.public_inputs : null,
    );
    const calldata = garaga.getGroth16CallData(proof, vk, proof.a.curveId);

    expect(calldata).toHaveLength(vector.length);
    expect(calldata[0]).toBe(BigInt(calldata.length - 1));
    // Decimal ASCII words, separated by one newline with no trailing newline.
    const digest = createHash("sha256")
      .update(calldata.map(String).join("\n"), "ascii")
      .digest("hex");
    expect(digest).toBe(vector.sha256);
  });
});
