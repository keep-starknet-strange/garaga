#!/bin/bash
# Generates a recursive UltraKeccakZKHonk proof fixture: the outer circuit verifies an inner
# UltraHonk ZK proof, so its public inputs carry a non-default pairing point accumulator.
# Requires the nargo and bb versions from tools/make/constants.json.
set -euo pipefail

SCRIPT_PATH=$(dirname "$(realpath "$0")")
HONK_FIXTURES_PATH="$SCRIPT_PATH/../../../hydra/garaga/starknet/honk_contract_generator/examples"
BB_VERSION=$(python3 -c "import json; print(json.load(open('$SCRIPT_PATH/../../make/constants.json'))['noir']['bb_version'])")

cd "$SCRIPT_PATH"

echo "nargo version : $(nargo --version)"
echo "bb version : $(bb --version)"

# Fetch the bb_proof_verification Noir library matching the bb version.
if [ ! -d bb_proof_verification ]; then
    tmp=$(mktemp -d)
    git clone --quiet --depth 1 --branch "v$BB_VERSION" --filter=blob:none --sparse \
        https://github.com/AztecProtocol/aztec-packages.git "$tmp"
    git -C "$tmp" sparse-checkout set barretenberg/noir/bb_proof_verification
    cp -r "$tmp/barretenberg/noir/bb_proof_verification" bb_proof_verification
    rm -rf "$tmp"
fi

# Inner proof, with fields output for in-circuit verification.
(
    cd inner
    nargo execute witness
    rm -rf target/out && mkdir -p target/out
    bb prove -t noir-recursive --write_vk --output_format json -b target/inner.json -w target/witness.gz -o target/out
)

python3 - <<'PY'
import json
d = "inner/target/out/"
vk = json.load(open(d + "vk.json"))
proof = json.load(open(d + "proof.json"))
public_inputs = json.load(open(d + "public_inputs.json"))
q = lambda l: "[" + ", ".join(f'"{x}"' for x in l) + "]"
open("outer/Prover.toml", "w").write(
    f'verification_key = {q(vk["vk"])}\n'
    f'proof = {q(proof["proof"])}\n'
    f'public_inputs = {q(public_inputs["public_inputs"])}\n'
    f'key_hash = "{vk["hash"]}"\n'
)
PY

# Outer proof, verified by Garaga (keccak, ZK).
(
    cd outer
    nargo execute witness
    rm -rf target/out && mkdir -p target/out
    bb prove -t evm --write_vk -b target/outer.json -w target/witness.gz -o target/out
    bb verify -t evm -k target/out/vk -p target/out/proof -i target/out/public_inputs
    cp target/out/vk "$HONK_FIXTURES_PATH/vk_ultra_keccak_recursive.bin"
    cp target/out/vk_hash "$HONK_FIXTURES_PATH/vk_hash_ultra_keccak_recursive.bin"
    cp target/out/proof "$HONK_FIXTURES_PATH/proof_ultra_keccak_zk_recursive.bin"
    cp target/out/public_inputs "$HONK_FIXTURES_PATH/public_inputs_ultra_keccak_recursive.bin"
)
