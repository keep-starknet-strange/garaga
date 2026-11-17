import hashlib
import json
from pathlib import Path, PurePosixPath
from urllib.request import urlopen

HERE = Path(__file__).resolve().parent
ARTIFACTS = (
    HERE.parent.parent
    / "hydra/garaga/starknet/groth16_contract_generator/examples/sp1_artifacts.json"
)
CHECKSUMS = {
    "ISP1Verifier.sol": "9e918032a5aa799c1319b14b013154d6a40ca6e5f2267c9f540560abd7fd7689",
    "v6.1.0/Groth16Verifier.sol": "01ab92508b9d56556ee247c7cb6b2ebd9c17835a4618896462b2a3a8708a50bf",
    "v6.1.0/SP1VerifierGroth16.sol": "48e1db5baca3b102242ebd88280b3689a088076688146cd0d98876f5dacb76d0",
}


def main():
    source = json.loads(ARTIFACTS.read_text())["verifier_source"]
    root = PurePosixPath(source["path"]).parents[1]
    repository = source["repository"].removeprefix("https://github.com/")
    base = f"https://raw.githubusercontent.com/{repository}/{source['revision']}/{root}"
    for path, checksum in CHECKSUMS.items():
        output = HERE / "target" / "reference" / path
        if (
            output.is_file()
            and hashlib.sha256(output.read_bytes()).hexdigest() == checksum
        ):
            continue
        with urlopen(f"{base}/{path}", timeout=30) as response:
            content = response.read()
        if hashlib.sha256(content).hexdigest() != checksum:
            raise ValueError(f"Checksum mismatch for {path}")
        output.parent.mkdir(parents=True, exist_ok=True)
        output.write_bytes(content)


if __name__ == "__main__":
    main()
