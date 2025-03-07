BB_PATH="bb"


echo "nargo version : $(nargo --version)" # 1.0.0-beta.2
echo "bb version : $($BB_PATH --version)" # 0.74.0

run_noir_proof_ultra_honk_combined_recursive_flow() {
    cd combined_recursion/dummy_proof_circuit
    nargo build
    nargo execute witness

    local dummy_proof_suffix="_dummy_proof_circuit"

    $BB_PATH prove_ultra_honk -b target/dummy_proof_circuit.json -w target/witness.gz -o target/proof${dummy_proof_suffix}.bin -h 1 --recursive
    $BB_PATH proof_as_fields_honk -p target/proof${dummy_proof_suffix}.bin -o target/proof_fields${dummy_proof_suffix} -h 1 --recursive
    $BB_PATH write_vk_ultra_honk -b target/dummy_proof_circuit.json -o target/vk${dummy_proof_suffix}.bin -h 1 --recursive
    $BB_PATH vk_as_fields_ultra_honk -k target/vk${dummy_proof_suffix}.bin -o target/vk_fields${dummy_proof_suffix} -h 1 --recursive
    if $BB_PATH verify_ultra_honk -p target/proof${dummy_proof_suffix}.bin -k target/vk${dummy_proof_suffix}.bin -v -h 1 --recursive; then
        echo "[INFO] Verification succeeded for $dummy_proof_suffix"
    else
        echo "[ERROR] Verification failed for $dummy_proof_suffix"
    fi

    local recursion_toml="../combined_recursive_circuit/Prover.toml"
    local dummy_vk_fields="./target/vk_fields${dummy_proof_suffix}"
    local dummy_proof_fields="./target/proof_fields${dummy_proof_suffix}"

    # Ensure directory exists
    mkdir -p "$(dirname "$recursion_toml")"

    # Check if file exists
    if [[ ! -f "$dummy_vk_fields" ]]; then
        echo "[Error] VK fields file not found at $dummy_vk_fields"
        return 1
    fi

    if [[ ! -f "$dummy_proof_fields" ]]; then
        echo "[Error] VK fields file not found at $dummy_proof_fields"
        return 1
    fi

     # Read the verification key fields
    local dummy_vk_content=$(cat "$dummy_vk_fields")
    local dummy_proof_content=$(cat "$dummy_proof_fields")

    # Extract the array content (remove outer brackets)
    local dummy_array_content=${dummy_proof_content:1:${#dummy_proof_content}-2}

    # Split the array content by commas and preserve newlines
    IFS=$',\n' read -r -a dummy_array_elements <<< "$dummy_array_content"

    # Extract the 4th, 5th, 6th, 7th element (index 3, 4, 5, 6)
    local pub_in_1="${dummy_array_elements[3]}"
    local pub_in_2="${dummy_array_elements[4]}"
    local pub_in_3="${dummy_array_elements[5]}"
    local pub_out_1="${dummy_array_elements[6]}"
    local all_public_inputs="[${pub_in_1},${pub_in_2},${pub_in_3},${pub_out_1}]"

    # Remove the 4th, 5th, 6th, 7th element from the array
    unset "dummy_array_elements[3]"
    unset "dummy_array_elements[4]"
    unset "dummy_array_elements[5]"
    unset "dummy_array_elements[6]"

    # Rebuild the array without the 4th element
    local modified_proof="["
    local first=true
    for element in "${dummy_array_elements[@]}"; do
        if $first; then
            modified_proof+="$element"
            first=false
        else
            modified_proof+=",$element"
        fi
    done
    modified_proof+="]"

    # Create the initial recursion Prover.toml
    cat > "$recursion_toml" << EOF
    prev_tally = "0"
    new_votes = "2"
    is_first_run = "1"
    verification_key = $dummy_vk_content
    proof = $modified_proof
    public_inputs = $all_public_inputs
    key_hash = "0x1783e34f335b616604156e79a026d3f5c5a679b4262ec2858b58ab644d87498a"
EOF

    echo "[INFO] Created initial Prover.toml for combined circuit."

    cd ../combined_recursive_circuit

    ##################################################################
    # 2. Repeatedly run the "combined recursion circuit"
    #
    #    - On each iteration, parse the new proof fields to see
    #      if there's a final public output that we interpret as 'final_tally'
    #    - Update Prover.toml with:
    #        * verification_key
    #        * new proof (minus the public inputs/outputs)
    #        * public_inputs (the new public inputs/outputs from the last run)
    #        * is_first_run -> 0 (except for first iteration)
    #        * prev_tally -> last iteration's final tally
    #        * new_votes -> random number in [1..10]
    #
    #    - The script below uses a fixed loop count. Adapt as needed.
    ##################################################################

    local MAX_ITERATIONS=3
    for ((i = 1; i <= MAX_ITERATIONS; i++)); do
        echo ""
        echo "==== [2.$i] Running the combined circuit iteration #$i ===="

        nargo compile

        nargo execute witness

        local recursion_suffix="_combined_recursion_circuit"

        $BB_PATH prove_ultra_honk -b target/combined_recursive_circuit.json -w target/witness.gz -o target/proof${recursion_suffix}.bin -h 1 --recursive
        $BB_PATH proof_as_fields_honk -p target/proof${recursion_suffix}.bin -o target/proof_fields${recursion_suffix} -h 1 --recursive
        $BB_PATH write_vk_ultra_honk -b target/combined_recursive_circuit.json -o target/vk${recursion_suffix}.bin -h 1 --recursive
        $BB_PATH vk_as_fields_ultra_honk -k target/vk${recursion_suffix}.bin -o target/vk_fields${recursion_suffix} -h 1 --recursive
        if $BB_PATH verify_ultra_honk -p target/proof${recursion_suffix}.bin -k target/vk${recursion_suffix}.bin -v -h 1 --recursive; then
            echo "[INFO] Verification succeeded for $recursion_suffix"
        else
            echo "[ERROR] Verification failed for $recursion_suffix"
        fi

        local recursion_vk_fields="./target/vk_fields${recursion_suffix}"
        local recursion_proof_fields="./target/proof_fields${recursion_suffix}"

        # Check if file exists
        if [[ ! -f "$recursion_vk_fields" ]]; then
            echo "[Error] VK fields file not found at $recursion_vk_fields"
            return 1
        fi

        if [[ ! -f "$recursion_proof_fields" ]]; then
            echo "[Error] VK fields file not found at $recursion_proof_fields"
            return 1
        fi

        local recursion_vk_content="$(cat "$recursion_vk_fields")"
        local recursion_proof_content="$(cat "$recursion_proof_fields")"

        # Extract array content (remove outer brackets)
        local recursion_array_content="${recursion_proof_content:1:${#recursion_proof_content}-2}"

        # Split the array content by commas and preserve newlines
        IFS=$',\n' read -r -a recursion_array_elements <<< "$recursion_array_content"

        # Extract the 4th, 5th, 6th, 7th element (index 3, 4, 5, 6)
        local pub_in_1="${recursion_array_elements[3]}"
        local pub_in_2="${recursion_array_elements[4]}"
        local pub_in_3="${recursion_array_elements[5]}"
        local pub_out_1="${recursion_array_elements[6]}"
        local all_public_inputs="[${pub_in_1},${pub_in_2},${pub_in_3},${pub_out_1}]"

        # Remove the 4th, 5th, 6th, 7th element from the array
        unset "recursion_array_elements[3]"
        unset "recursion_array_elements[4]"
        unset "recursion_array_elements[5]"
        unset "recursion_array_elements[6]"

        # Rebuild the proof array
        local modified_proof="["
        local first_el=true
        for element in "${recursion_array_elements[@]}"; do
            if $first_el; then
                modified_proof+="$element"
                first_el=false
            else
                modified_proof+=",$element"
            fi
        done
        modified_proof+="]"

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

        # Create the updated recursion Prover.toml
        cat > "$recursion_toml" <<EOF
        prev_tally = "$pub_out_dec"
        new_votes = "$new_votes"
        is_first_run = "0"
        verification_key = $recursion_vk_content
        proof = $modified_proof
        public_inputs = $all_public_inputs
        key_hash = "0x1783e34f335b616604156e79a026d3f5c5a679b4262ec2858b58ab644d87498a"
EOF

        echo "[INFO] Created next Prover.toml for iteration #$i"

    ##################################################################
    # 2.c: If we are NOT on the last iteration, continue the loop.
    #      If we ARE on the last iteration, run the "final" prove_ultra_keccak_honk
    ##################################################################
    if [[ $i -eq $MAX_ITERATIONS ]]; then
        echo ""
        echo "==== [2.$i-final] Generating final ultra KECCAK honk proof ===="
    # This is the final proof you generate on the last run of the recursive circuit
    $BB_PATH prove_ultra_keccak_honk -b target/combined_recursive_circuit.json -w target/witness.gz -o target/proof${recursion_suffix}.bin -h 1 --recursive

    $BB_PATH write_vk_ultra_keccak_honk -b ./target/combined_recursive_circuit.json -o ./target/vk${recursion_suffix}.bin -h 1 --recursive

    if $BB_PATH verify_ultra_keccak_honk -p ./target/proof${recursion_suffix}.bin -k ./target/vk${recursion_suffix}.bin -v -h 1 --recursive; then
        echo "[INFO] Verification succeeded for $recursion_suffix"
    else
        echo "[ERROR] Verification failed for $recursion_suffix"
    fi

    garaga calldata --system ultra_keccak_honk --vk ./target/vk${recursion_suffix}.bin --proof ./target/proof${recursion_suffix}.bin --format array

    echo "[INFO] Final recursive circuit iteration completed & Garaga verifier calldata generated."
    fi

    done

    cd ../
}

echo $'\n ultra honk recursive flow'
# reset
run_noir_proof_ultra_honk_combined_recursive_flow
