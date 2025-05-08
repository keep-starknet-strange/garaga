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


echo "nargo version : $(nargo --version)" # 1.0.0-beta.3
echo "bb version : $($BB_PATH --version)" # 0.86.0 || 0.86.0-starknet.1


run_noir_proof_basic() {
    cd hello
    local suffix="_basic"

    mkdir -p target/proof${suffix}/
    $BB_PATH prove --write_vk --output_format bytes -b target/hello.json -w target/witness.gz -o target/proof${suffix}/
    mv -f target/proof${suffix}/public_inputs target/public_inputs${suffix}.bin
    mv -f target/proof${suffix}/proof target/proof${suffix}.bin
    mv -f target/proof${suffix}/vk target/vk${suffix}.bin
    mv -f target/proof${suffix}/vk_fields.json target/vk${suffix}.json
    rmdir target/proof${suffix}/

    if $BB_PATH verify -i target/public_inputs${suffix}.bin -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    cd ../
}

run_noir_proof_ultra() {
    cd hello
    local suffix="_ultra"

    mkdir -p target/proof${suffix}/
    $BB_PATH prove -s ultra_honk --write_vk --output_format bytes -b target/hello.json -w target/witness.gz -o target/proof${suffix}/
    mv -f target/proof${suffix}/public_inputs target/public_inputs${suffix}.bin
    mv -f target/proof${suffix}/proof target/proof${suffix}.bin
    mv -f target/proof${suffix}/vk target/vk${suffix}.bin
    mv -f target/proof${suffix}/vk_fields.json target/vk${suffix}.json
    rmdir target/proof${suffix}/

    if $BB_PATH verify -s ultra_honk -i target/public_inputs${suffix}.bin -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    cd ../
}

run_noir_proof_ultra_keccak() {
    cd hello
    local suffix="_ultra_keccak"

    mkdir -p target/proof${suffix}/
    $BB_PATH prove -s ultra_honk --oracle_hash keccak --write_vk --output_format bytes -b target/hello.json -w target/witness.gz -o target/proof${suffix}/
    mv -f target/proof${suffix}/public_inputs target/public_inputs${suffix}.bin
    mv -f target/proof${suffix}/proof target/proof${suffix}.bin
    mv -f target/proof${suffix}/vk target/vk${suffix}.bin
    mv -f target/proof${suffix}/vk_fields.json target/vk${suffix}.json
    rmdir target/proof${suffix}/

    if $BB_PATH verify -s ultra_honk --oracle_hash keccak -i target/public_inputs${suffix}.bin -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    $BB_PATH write_solidity_verifier -s ultra_honk -k target/vk${suffix}.bin -o target/contract${suffix}.sol
    cd ../
}

run_noir_proof_ultra_starknet() {
    cd hello
    local suffix="_ultra_starknet"

    mkdir -p target/proof${suffix}/
    $BB_PATH prove -s ultra_honk --oracle_hash starknet --write_vk --output_format bytes -b target/hello.json -w target/witness.gz -o target/proof${suffix}/
    mv -f target/proof${suffix}/public_inputs target/public_inputs${suffix}.bin
    mv -f target/proof${suffix}/proof target/proof${suffix}.bin
    mv -f target/proof${suffix}/vk target/vk${suffix}.bin
    mv -f target/proof${suffix}/vk_fields.json target/vk${suffix}.json
    rmdir target/proof${suffix}/

    if $BB_PATH verify -s ultra_honk --oracle_hash starknet -i target/public_inputs${suffix}.bin -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    cd ../
}

run_noir_proof_ultra_keccak_zk() {
    cd hello
    local suffix="_ultra_keccak_zk"

    mkdir -p target/proof${suffix}/
    $BB_PATH prove -s ultra_honk --oracle_hash keccak --zk --write_vk --output_format bytes -b target/hello.json -w target/witness.gz -o target/proof${suffix}/
    mv -f target/proof${suffix}/public_inputs target/public_inputs${suffix}.bin
    mv -f target/proof${suffix}/proof target/proof${suffix}.bin
    mv -f target/proof${suffix}/vk target/vk${suffix}.bin
    mv -f target/proof${suffix}/vk_fields.json target/vk${suffix}.json
    rmdir target/proof${suffix}/

    if $BB_PATH verify -s ultra_honk --oracle_hash keccak --zk -i target/public_inputs${suffix}.bin -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    $BB_PATH write_solidity_verifier -s ultra_honk --zk -k target/proof${suffix}.bin -o target/contract${suffix}.sol
    cd ../
}

run_noir_proof_ultra_starknet_zk() {
    cd hello
    local suffix="_ultra_starknet_zk"

    mkdir -p target/proof${suffix}/
    $BB_PATH prove -s ultra_honk --oracle_hash starknet --zk --write_vk --output_format bytes -b target/hello.json -w target/witness.gz -o target/proof${suffix}/
    mv -f target/proof${suffix}/public_inputs target/public_inputs${suffix}.bin
    mv -f target/proof${suffix}/proof target/proof${suffix}.bin
    mv -f target/proof${suffix}/vk target/vk${suffix}.bin
    mv -f target/proof${suffix}/vk_fields.json target/vk${suffix}.json
    rmdir target/proof${suffix}/

    if $BB_PATH verify -s ultra_honk --oracle_hash starknet --zk -i target/public_inputs${suffix}.bin -p target/proof${suffix}.bin -k target/vk${suffix}.bin; then
        echo "ok $suffix"
    else
        echo "Verification failed $suffix"
    fi
    cd ../
}



echo $'\n basic'
# reset
run_noir_proof_basic

echo $'\n ultra honk'
# reset
run_noir_proof_ultra

echo $'\n ultra keccak honk'
reset
run_noir_proof_ultra_keccak

echo $'\n ultra starknet honk'
# reset
run_noir_proof_ultra_starknet

echo $'\n ultra keccak zk honk'
# reset
run_noir_proof_ultra_keccak_zk

echo $'\n ultra starknet zk honk'
# reset
run_noir_proof_ultra_starknet_zk


echo $'\n'
# Print sha256 hash of of .sol files :
for file in hello/target/*.sol; do
    echo $(md5sum $file)
done

# Print sha256 hash of of .bin files :
for file in hello/target/*.bin; do
    echo $(md5sum $file)
done
