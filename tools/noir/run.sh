reset() {
    rm -rf hello/
    nargo new hello
    cd hello
    nargo check
    cat << EOF > Prover.toml
x = "1"
y = "2"
EOF
    nargo execute witness
    cd ../
}

# Setup Foundry for testing the generated Solidity verifier
setup_foundry() {
    cd hello

    # Create foundry.toml configuration
    cat << 'EOF' > foundry.toml
# Foundry configuration for testing the Honk verifier
[profile.default]
src = "target"
out = "out"
libs = ["lib"]
test = "test"

# Enable optimizer for faster execution
optimizer = true
optimizer_runs = 200
# Increase memory limit for large proof verification
memory_limit = 134217728  # 128MB
# Show more output
verbosity = 3
# EVM version
evm_version = "cancun"
# Allow reading binary files for proof verification tests
fs_permissions = [{ access = "read", path = "./target" }]
[fuzz]
runs = 256
EOF

    # Create test directory
    mkdir -p test

    # Create the Foundry test file
    cat << 'EOF' > test/VerifierTest.t.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// Import the verifier contract
import "../target/contract_ultra_keccak_zk.sol";

/**
 * @title VerifierTest
 * @notice Test contract for debugging the ZK Honk verifier
 * @dev This test loads the proof from binary files and verifies it,
 *      logging intermediate values for comparison with Python implementation.
 *
 * HOW TO RUN:
 *   From the project root:
 *     make sol-verify-debug
 *
 *   Or manually from tools/noir/hello/:
 *     forge test -vvvv --match-test testVerifyProof
 *
 * HOW TO ADD MORE LOGGING:
 *   1. Import console.sol in the contract you want to debug
 *   2. Add console.log() calls, e.g.:
 *      console.log("variableName:", value);
 *      console.log("Fr value:", Fr.unwrap(someField));
 *   3. Run with -vvvv for maximum verbosity
 */
contract VerifierTest is Test {
    HonkVerifier verifier;

    function setUp() public {
        verifier = new HonkVerifier();
        console.log("=== Verifier deployed ===");
        console.log("VK_HASH:", VK_HASH);
        console.log("N:", N);
        console.log("LOG_N:", LOG_N);
        console.log("NUMBER_OF_PUBLIC_INPUTS:", NUMBER_OF_PUBLIC_INPUTS);
    }

    function testVerifyProof() public {
        console.log("\n=== Loading proof and public inputs ===");

        // Load proof bytes from file
        bytes memory proofBytes = vm.readFileBinary("target/proof_ultra_keccak_zk.bin");
        console.log("Proof length (bytes):", proofBytes.length);
        console.log("Proof length (field elements):", proofBytes.length / 32);

        // Load public inputs from file
        bytes memory pubInputsBytes = vm.readFileBinary("target/public_inputs_ultra_keccak_zk.bin");
        console.log("Public inputs length (bytes):", pubInputsBytes.length);

        // Parse public inputs into bytes32 array
        uint256 numPubInputs = pubInputsBytes.length / 32;
        console.log("Number of public inputs:", numPubInputs);

        bytes32[] memory publicInputs = new bytes32[](numPubInputs);
        for (uint256 i = 0; i < numPubInputs; i++) {
            bytes32 val;
            uint256 offset = i * 32;
            assembly {
                val := mload(add(add(pubInputsBytes, 32), offset))
            }
            publicInputs[i] = val;
            console.log("publicInput[%d]:", i);
            console.logBytes32(val);
        }

        console.log("\n=== Calling verify() ===");

        // Call verify and check result
        bool result = verifier.verify(proofBytes, publicInputs);

        console.log("\n=== Result ===");
        console.log("Verification result:", result);

        assertTrue(result, "Proof verification failed!");
    }

    /**
     * @notice Test with manual proof parsing to log intermediate values
     * @dev Uncomment and modify this to debug specific parts of the proof
     */
    function testVerifyProofWithDetailedLogging() public {
        console.log("\n=== Detailed Proof Parsing ===");

        bytes memory proofBytes = vm.readFileBinary("target/proof_ultra_keccak_zk.bin");
        bytes memory pubInputsBytes = vm.readFileBinary("target/public_inputs_ultra_keccak_zk.bin");

        // Parse first few elements of proof (pairing point object)
        console.log("\n--- Pairing Point Object (first 16 field elements) ---");
        for (uint256 i = 0; i < 16; i++) {
            uint256 val;
            uint256 offset = i * 32;
            assembly {
                val := mload(add(add(proofBytes, 32), offset))
            }
            console.log("pairingPointObject[%d]:", i);
            console.log("  hex:", val);
        }

        // Parse commitment points (after pairing point object)
        console.log("\n--- Wire Commitments ---");
        uint256 baseOffset = 16 * 32; // After pairing point object

        // W1
        uint256 w1x;
        uint256 w1y;
        assembly {
            w1x := mload(add(add(proofBytes, 32), baseOffset))
            w1y := mload(add(add(proofBytes, 64), baseOffset))
        }
        console.log("W1.x:", w1x);
        console.log("W1.y:", w1y);

        // W2
        uint256 w2x;
        uint256 w2y;
        assembly {
            w2x := mload(add(add(proofBytes, 32), add(baseOffset, 64)))
            w2y := mload(add(add(proofBytes, 64), add(baseOffset, 64)))
        }
        console.log("W2.x:", w2x);
        console.log("W2.y:", w2y);

        // W3
        uint256 w3x;
        uint256 w3y;
        assembly {
            w3x := mload(add(add(proofBytes, 32), add(baseOffset, 128)))
            w3y := mload(add(add(proofBytes, 64), add(baseOffset, 128)))
        }
        console.log("W3.x:", w3x);
        console.log("W3.y:", w3y);

        // Now verify
        uint256 numPubInputs = pubInputsBytes.length / 32;
        bytes32[] memory publicInputs = new bytes32[](numPubInputs);
        for (uint256 i = 0; i < numPubInputs; i++) {
            bytes32 val;
            uint256 offset = i * 32;
            assembly {
                val := mload(add(add(pubInputsBytes, 32), offset))
            }
            publicInputs[i] = val;
        }

        bool result = verifier.verify(proofBytes, publicInputs);
        console.log("\nVerification result:", result);
        assertTrue(result, "Proof verification failed!");
    }
}
EOF

    # Install forge-std if not already present
    if [ ! -d "lib/forge-std" ]; then
        echo "Installing forge-std..."
        forge install foundry-rs/forge-std --no-git
    fi

    cd ../
    echo "Foundry setup complete!"
}

reset


BB_PATH="bb"


echo "nargo version : $(nargo --version)" # See constants.json for recommended nargo version
echo "bb version : $($BB_PATH --version)" # See constants.json for recommended bb version

SCRIPT_PATH=$(dirname $(realpath $0))
HONK_FIXTURES_PATH="$SCRIPT_PATH/../../hydra/garaga/starknet/honk_contract_generator/examples"


run_noir_proof_ultra_keccak_zk() {
    cd hello
    local suffix="_ultra_keccak_zk"

    mkdir -p target/proof${suffix}/
    $BB_PATH prove -s ultra_honk --oracle_hash keccak --write_vk -b target/hello.json -w target/witness.gz -o target/proof${suffix}/
    mv -f target/proof${suffix}/public_inputs target/public_inputs${suffix}.bin
    mv -f target/proof${suffix}/proof target/proof${suffix}.bin
    mv -f target/proof${suffix}/vk target/vk${suffix}.bin
    mv -f target/proof${suffix}/vk_hash target/vk_hash${suffix}.bin

    # Copy and replace proof.bin to HONK_FIXTURES_PATH/ (no renaming)
    cp target/proof${suffix}.bin $HONK_FIXTURES_PATH/

    rmdir target/proof${suffix}/

    if $BB_PATH verify -s ultra_honk --oracle_hash keccak -i target/public_inputs${suffix}.bin -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    $BB_PATH write_solidity_verifier -s ultra_honk -k target/vk${suffix}.bin -o target/contract${suffix}.sol
    cd ../
}






echo $'\n ultra keccak zk honk'
# reset
run_noir_proof_ultra_keccak_zk


echo $'\n'
# Print sha256 hash of of .sol files :
for file in hello/target/*.sol; do
    echo $(md5sum $file)
done

# Print sha256 hash of of .bin files :
for file in hello/target/*.bin; do
    echo $(md5sum $file)
done

# Setup Foundry for testing the Solidity verifier
echo $'\n Setting up Foundry...'
setup_foundry
