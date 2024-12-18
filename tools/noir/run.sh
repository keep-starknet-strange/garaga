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

reset


BB_PATH="bb"


echo "nargo version : $(nargo --version)" # 0.36.0
echo "bb version : $($BB_PATH --version)" # 0.61.0


run_noir_proof_basic() {
    cd hello
    local suffix="_basic"
    $BB_PATH prove -b target/hello.json -w target/witness.gz -o target/proof${suffix}.bin
    $BB_PATH write_vk -b target/hello.json -o target/vk${suffix}.bin
    if $BB_PATH verify -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    $BB_PATH contract -k target/vk${suffix}.bin -o target/contract${suffix}.sol
    cd ../
}

run_noir_proof_ultra() {
    cd hello
    local suffix="_ultra"
    $BB_PATH prove_ultra_honk -b target/hello.json -w target/witness.gz -o target/proof${suffix}.bin
    $BB_PATH write_vk_ultra_honk -b target/hello.json -o target/vk${suffix}.bin
    if $BB_PATH verify_ultra_honk -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    $BB_PATH contract_ultra_honk -k target/vk${suffix}.bin -o target/contract${suffix}.sol
    cd ../
}

run_noir_proof_ultra_keccak() {
    cd hello
    local suffix="_ultra_keccak"

    $BB_PATH prove_ultra_keccak_honk -b target/hello.json -w target/witness.gz -o target/proof${suffix}.bin
    $BB_PATH write_vk_ultra_keccak_honk -b target/hello.json -o target/vk${suffix}.bin
    $BB_PATH vk_as_fields_ultra_keccak_honk -b target/hello.json -k target/vk${suffix}.bin -o target/vk_fields${suffix}.bin

    if $BB_PATH verify_ultra_keccak_honk -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    $BB_PATH contract_ultra_honk -k target/vk${suffix}.bin -o target/contract${suffix}.sol # contract_ultra_keccak_honk does not exist
    cd ../
}




echo $'\n basic'
# reset
run_noir_proof_basic

echo $'\n ultra honk'
# reset
run_noir_proof_ultra

echo $'\n ultra keccak honk'
# reset
run_noir_proof_ultra_keccak


echo $'\n'
# Print sha256 hash of of .sol files :
for file in hello/target/*.sol; do
    echo $(md5sum $file)
done

# Print sha256 hash of of .bin files :
for file in hello/target/*.bin; do
    echo $(md5sum $file)
done
