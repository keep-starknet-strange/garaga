# Used with bb 0.51.0 compiled from source (clang 16)
# Used with noir 0.31 with noirup from latest commit.
rm -rf hello/
nargo new hello
cd hello
nargo check
cat << EOF > Prover.toml
x = "1"
y = "2"
EOF
nargo execute witness
bb prove_keccak_ultra_honk -b target/hello.json -w target/witness.gz -o target/proof
bb write_vk_ultra_honk -b target/hello.json -o target/vk
bb vk_as_fields_ultra_honk -k target/vk
bb verify_keccak_ultra_honk -p target/proof -k target/vk
bb contract_ultra_honk
cd ../
