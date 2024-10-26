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


# nargo version : nargo version = 0.36.0
# noirc version = 0.36.0+801c71880ecf8386a26737a5d8bb5b4cb164b2ab
# (git version hash: 801c71880ecf8386a26737a5d8bb5b4cb164b2ab, is dirty: false)
# bb version : 0.58.0

echo "nargo version : $(nargo --version)" # 0.36.0
echo "bb version : $(bb --version)" # 0.58.0


run_noir_proof_basic() {
    cd hello
    local suffix="_basic"
    bb prove -b target/hello.json -w target/witness.gz -o target/proof${suffix}.bin
    bb write_vk -b target/hello.json -o target/vk${suffix}.bin
    bb verify -p target/proof${suffix}.bin -k target/vk${suffix}.bin
    bb contract -k target/vk${suffix}.bin -o target/contract${suffix}.sol
    cd ../
}

run_noir_proof_ultra() {
    cd hello
    local suffix="_ultra"
    bb prove_ultra_honk -b target/hello.json -w target/witness.gz -o target/proof${suffix}.bin
    bb write_vk_ultra_honk -b target/hello.json -o target/vk${suffix}.bin
    if bb verify_ultra_honk -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok"
    else
        echo "Verification failed"
    fi
    bb contract_ultra_honk -k target/vk${suffix}.bin -o target/contract${suffix}.sol
    cd ../
}

run_noir_proof_ultra_keccak() {
    cd hello
    local suffix="_ultra_keccak"

    bb prove_ultra_keccak_honk -b target/hello.json -w target/witness.gz -o target/proof${suffix}.bin
    bb write_vk_ultra_keccak_honk -b target/hello.json -o target/vk${suffix}.bin
    if bb verify_ultra_keccak_honk -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok"
    else
        echo "Verification failed"
    fi
    bb contract_ultra_honk -k target/vk${suffix}.bin -o target/contract${suffix}.sol # contract_ultra_keccak_honk does not exist
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
