"""Install the pinned Linux SDK binaries into an isolated directory for CI."""

import argparse
import hashlib
import io
import json
import platform
import tarfile
import urllib.request
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    args = parser.parse_args()
    assert platform.system() == "Linux" and platform.machine() == "x86_64"
    root = Path(__file__).resolve().parents[2]
    pins = json.loads((root / "tools/make/constants.json").read_text())["noir"]
    args.directory.mkdir(parents=True, exist_ok=True)
    archives = {
        "bb": (
            f"https://github.com/AztecProtocol/aztec-packages/releases/download/v{pins['bb_version']}/barretenberg-amd64-linux.tar.gz",
            pins["bb_linux_x86_64_sha256"],
        ),
        "nargo": (
            f"https://github.com/noir-lang/noir/releases/download/v{pins['nargo_version']}/noir-x86_64-unknown-linux-gnu.tar.gz",
            pins["noir_linux_x86_64_sha256"],
        ),
    }
    for name, (url, expected) in archives.items():
        with urllib.request.urlopen(url, timeout=120) as response:
            data = response.read()
        assert (
            hashlib.sha256(data).hexdigest() == expected
        ), f"Archive checksum mismatch: {name}"
        with tarfile.open(fileobj=io.BytesIO(data), mode="r:gz") as archive:
            members = [
                member
                for member in archive.getmembers()
                if member.isfile() and Path(member.name).name == name
            ]
            assert len(members) == 1, f"Expected one {name} binary"
            path = args.directory / name
            path.write_bytes(archive.extractfile(members[0]).read())
            path.chmod(0o755)
        print(f"Installed {name} with the pinned archive checksum")


if __name__ == "__main__":
    main()
