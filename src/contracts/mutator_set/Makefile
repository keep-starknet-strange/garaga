regen:
	python3 ./scripts/regenerate_verifier.py


NOIR_FOLDER = "zk_program"

build:
	cd ${NOIR_FOLDER} && nargo build && nargo execute witness

prove:
	cd ${NOIR_FOLDER} && bb prove -s ultra_honk --oracle_hash keccak -b ./target/zk_program.json -w ./target/witness.gz -o ./target/

verify:
	cd ${NOIR_FOLDER} && bb verify -s ultra_honk -p ./target/proof -k ./target/vk --oracle_hash keccak
