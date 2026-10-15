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

run_noir_combined_recursive_proof_flow() {
    echo "[INFO] Starting ultra honk combined recursive proof flow"

    # --- 1. Dummy Proof Circuit Flow ---
    cd combined_recursion/dummy_proof_circuit
    echo "[INFO] [1] Building and executing dummy proof circuit witness"
    nargo build && nargo execute witness

    local dummy_proof_suffix="_dummy_proof_circuit"
    echo "[INFO] [1.a] Generating dummy proof circuit artifacts"
    generate_and_verify_proof_and_vk "dummy_proof_circuit" "$dummy_proof_suffix" \
    generate_ultra_honk_proof generate_ultra_honk_vk verify_ultra_honk_proof

    local recursion_toml="../combined_recursive_circuit/Prover.toml"
    local dummy_vk_fields="./target/vk_fields${dummy_proof_suffix}"
    local dummy_proof_fields="./target/proof_fields${dummy_proof_suffix}"

    # Ensure directory exists
    mkdir -p "$(dirname "$recursion_toml")"

    # Check if vk & proof files exist
    if [[ ! -f "$dummy_vk_fields" || ! -f "$dummy_proof_fields" ]]; then
        echo "[Error] Missing proof or VK fields file in dummy proof circuit flow"
        return 1
    fi

     # Read the verification key fields
    local dummy_vk_content=$(cat "$dummy_vk_fields")

    local all_public_inputs modified_proof
    modify_proof_fields_output=$(modify_proof_fields "$dummy_proof_fields")
    all_public_inputs=$(echo "$modify_proof_fields_output" | head -n 1)
    modified_proof=$(echo "$modify_proof_fields_output" | tail -n 1)

    # Create the initial recursion Prover.toml
    mkdir -p "$(dirname "$recursion_toml")"
    update_prover_toml "$recursion_toml" "0" "2" "1" "$dummy_vk_content" "$modified_proof" "$all_public_inputs"

    echo "[INFO] [1.b] Created initial Prover.toml for combined circuit."

    cd ../combined_recursive_circuit

    ##################################################################
    # 2. Repeatedly run the "combined recursion circuit"
    #
    #    - On each iteration, parse the new proof fields to see
    #      if there's a final public output that we interpret as 'final_tally'
    #    - Update Prover.toml with:
    #        * verification_key
    #        * new proof (minus the public inputs/outputs)
    #        * public_inputs & outputs (the new public inputs/outputs from the last run)
    #        * is_first_run -> 0 (except for first iteration)
    #        * prev_tally -> last iteration's final tally
    #        * new_votes -> random number in [1..10]
    #
    #    - The script below uses a fixed loop count. Adapt as needed.
    ##################################################################
    echo "[INFO] [2] Starting combined recursion circuit iterations"
    nargo compile

    local recursion_suffix="_combined_recursion_circuit"
    echo "[INFO] [2.a] Generating combined recursion circuit VK artifacts"
    generate_ultra_honk_vk "combined_recursive_circuit" "$recursion_suffix"

    local recursion_vk_fields="./target/vk_fields${recursion_suffix}"

    # Check if file exists
    if [[ ! -f "$recursion_vk_fields" ]]; then
        echo "[Error] VK fields file not found at $recursion_vk_fields"
        return 1
    fi
    local recursion_vk_content="$(cat "$recursion_vk_fields")"

    # Number of runs through the recursive circuit
    local MAX_ITERATIONS=3
    for ((i = 1; i <= MAX_ITERATIONS; i++)); do
        echo ""
        echo "==== [2.$i] Running the combined circuit iteration #$i ===="

        nargo execute witness
        generate_ultra_honk_proof "combined_recursive_circuit" "$recursion_suffix"

        if verify_ultra_honk_proof "$recursion_suffix"; then
            echo "[INFO] Verification succeeded for $recursion_suffix"
        else
            echo "[ERROR] Verification failed for $recursion_suffix"
        fi

        local recursion_proof_fields="./target/proof_fields${recursion_suffix}"

        # Check if file exists
        if [[ ! -f "$recursion_proof_fields" ]]; then
            echo "[Error] Recursion proof fields file not found at $recursion_proof_fields"
            return 1
        fi

        local all_public_inputs modified_proof
        modify_proof_fields_output=$(modify_proof_fields "$recursion_proof_fields")
        all_public_inputs=$(echo "$modify_proof_fields_output" | head -n 1)
        modified_proof=$(echo "$modify_proof_fields_output" | tail -n 1)

        # Extract pub_out_1 (the 4th element) from all_public_inputs
        # Remove the leading "[" and trailing "]", then split by comma
        all_inputs_content=${all_public_inputs:1:${#all_public_inputs}-2}
        IFS=',' read -r -a input_elements <<< "$all_inputs_content"
        pub_out_1="${input_elements[3]}"  # Fourth element (index 3)

        # Extract the public output from the proof and convert to decimal
        local pub_out_noquotes="${pub_out_1//\"/}"
        local pub_out_hex_str="${pub_out_noquotes#0x}"
        local pub_out_stripped_hex="$(echo "$pub_out_hex_str" | sed 's/^0*//')"
        if [ -z "$pub_out_stripped_hex" ]; then
            pub_out_stripped_hex="0"
        fi
        local pub_out_dec=$((16#$pub_out_stripped_hex))

        # new_votes is a random number from 1..10:
        local new_votes=$(( (RANDOM % 10) + 1 ))

        update_prover_toml "$recursion_toml" "$pub_out_dec" "$new_votes" "0" "$recursion_vk_content" "$modified_proof" "$all_public_inputs"

        echo "[INFO] Created next Prover.toml for iteration #$i"

    ##################################################################
    # 2.c: If we are NOT on the last iteration, continue the loop.
    #      If we ARE on the last iteration, run the "final" prove_ultra_keccak_honk
    ##################################################################
    if [[ $i -eq $MAX_ITERATIONS ]]; then
        echo ""
        echo "==== [2.$i-final] Generating final ultra KECCAK honk proof ===="
    # This is the final proof you generate on the last run of the recursive circuit before passing the proof to the garaga calldata command

    nargo execute witness

    generate_and_verify_proof_and_vk "combined_recursive_circuit" "$recursion_suffix" \
    generate_ultra_keccak_honk_proof generate_ultra_keccak_honk_vk verify_ultra_keccak_honk_proof

    echo "[INFO] [2.${iteration_count}-final] Generating Garaga calldata"
    garaga calldata --system ultra_keccak_honk --vk ./target/vk${recursion_suffix}.bin --proof ./target/proof${recursion_suffix}.bin --format array

    echo "[INFO] Final recursive circuit iteration completed & Garaga verifier calldata generated."
    fi

    done

    cd ../
}

# -----------------------------------------------------------------------------
# Helper Functions
# -----------------------------------------------------------------------------

generate_ultra_keccak_honk_proof() {
     local circuit_name=$1
     local suffix=$2

     $BB_PATH prove_ultra_keccak_honk -b target/$circuit_name.json -w target/witness.gz -o target/proof${suffix}.bin -h 1 --recursive
}

generate_ultra_keccak_honk_vk() {
     local circuit_name=$1
     local suffix=$2

     $BB_PATH write_vk_ultra_keccak_honk -b target/$circuit_name.json -o target/vk${suffix}.bin -h 1 --recursive
}

verify_ultra_keccak_honk_proof() {
    local suffix=$1

    if $BB_PATH verify_ultra_keccak_honk -p target/proof${suffix}.bin -k target/vk${suffix}.bin -v -h 1 --recursive; then
        echo "Verification succeeded $suffix"
        return 0
    else
        echo "Verification failed $suffix"
        return 1
    fi
}

generate_ultra_honk_proof() {
     local circuit_name=$1
     local suffix=$2

     $BB_PATH prove_ultra_honk -b target/$circuit_name.json -w target/witness.gz -o target/proof${suffix}.bin -h 1 --recursive
     $BB_PATH proof_as_fields_honk -p target/proof${suffix}.bin -o target/proof_fields${suffix} -h 1 --recursive
}

generate_ultra_honk_vk() {
     local circuit_name=$1
     local suffix=$2

     $BB_PATH write_vk_ultra_honk -b target/$circuit_name.json -o target/vk${suffix}.bin -h 1 --recursive
     $BB_PATH vk_as_fields_ultra_honk -k target/vk${suffix}.bin -o target/vk_fields${suffix} -h 1 --recursive
}

verify_ultra_honk_proof() {
    local suffix=$1

    if $BB_PATH verify_ultra_honk -p target/proof${suffix}.bin -k target/vk${suffix}.bin -v -h 1 --recursive; then
        echo "Verification succeeded $suffix"
        return 0
    else
        echo "Verification failed $suffix"
        return 1
    fi
}

generate_and_verify_proof_and_vk() {
    local circuit_name=$1
    local suffix=$2
    local generator_func=$3        # e.g. generate_ultra_honk_proof
    local vk_func=$4               # e.g. generate_ultra_honk_vk
    local verifier_func=$5         # e.g. verify_ultra_honk_proof

    "$generator_func" "$circuit_name" "$suffix"
    "$vk_func"         "$circuit_name" "$suffix"
    "$verifier_func"   "$suffix"
}

modify_proof_fields() {
    local proof_fields_path=$1
    [[ ! -f "$proof_fields_path" ]] && { echo "[ERROR] Proof fields file not found: $proof_fields_path"; return 1; }

    local proof_content
    # Extract the array content
    proof_content=$(cat "$proof_fields_path")

    # Strip leading "[" and trailing "]"
    local array_content=${proof_content:1:${#proof_content}-2}

    # Split on commas
    IFS=$',\n' read -r -a array_elements <<< "$array_content"

   # Extract the 4th, 5th, 6th, 7th element (index 3, 4, 5, 6)
    local pub_in_1="${array_elements[3]}"
    local pub_in_2="${array_elements[4]}"
    local pub_in_3="${array_elements[5]}"
    local pub_out_1="${array_elements[6]}"
    local all_public_inputs="[${pub_in_1},${pub_in_2},${pub_in_3},${pub_out_1}]"

    # Remove public inputs & outputs from the proof array
    unset "array_elements[3]" "array_elements[4]" "array_elements[5]" "array_elements[6]"

    # Rebuild the proof array
    local modified_proof="["
    local first=true
    for element in "${array_elements[@]}"; do
        if [ -n "$element" ]; then  # Skip empty elements
            if $first; then
                modified_proof+="$element"
                first=false
            else
                modified_proof+=",$element"
            fi
        fi
    done
    modified_proof+="]"

    # Return values on stdout
    echo "$all_public_inputs"
    echo "$modified_proof"
}

# -----------------------------------------------------------------------------
# Prover.toml Update Function
# -----------------------------------------------------------------------------

# Function to update the Prover.toml file with new parameters
# Parameters:
#   1: file_path        - Path to the Prover.toml file
#   2: prev_tally       - Previous tally value
#   3: new_votes        - New votes value
#   4: is_first_run     - Flag indicating if it's the first run (1 or 0)
#   5: verification_key - Verification key content
#   6: proof            - Proof content
#   7: public_inputs    - Public inputs & outputs content
update_prover_toml() {
    local file_path=$1
    local prev_tally=$2
    local new_votes=$3
    local is_first_run=$4
    local verification_key=$5
    local proof=$6
    local public_inputs=$7

    cat > "$file_path" <<EOF
prev_tally = "$prev_tally"
new_votes = "$new_votes"
is_first_run = "$is_first_run"
verification_key = $verification_key
proof = $proof
public_inputs = $public_inputs
key_hash = "0x1783e34f335b616604156e79a026d3f5c5a679b4262ec2858b58ab644d87498a"
EOF
    echo "[OK] Updated Prover.toml"
}




echo $'\n ultra keccak zk honk'
# reset
run_noir_proof_ultra_keccak_zk

echo $'\n ultra honk recursive flow'
# reset
run_noir_combined_recursive_proof_flow

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
