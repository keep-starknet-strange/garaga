"""Install the checksum-pinned Lean SDK in an isolated Linux x86_64 directory."""

import argparse
import hashlib
import platform
import subprocess
import sys
import urllib.request
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    args = parser.parse_args()
    if (platform.system(), platform.machine()) != ("Linux", "x86_64"):
        raise ValueError("This installer targets the Linux x86_64 CI runner")
    source = Path(__file__).resolve().parent
    version = (
        (source / "lean-toolchain")
        .read_text()
        .strip()
        .removeprefix("leanprover/lean4:v")
    )
    expected, filename = (source / "lean-linux-x86_64.sha256").read_text().split()
    if filename != f"lean-{version}-linux.tar.zst":
        raise ValueError("Lean version and archive checksum pins differ")
    args.directory.mkdir(parents=True, exist_ok=True)
    archive = args.directory / filename
    digest = hashlib.sha256()
    with (
        urllib.request.urlopen(
            f"https://github.com/leanprover/lean4/releases/download/v{version}/{filename}",
            timeout=120,
        ) as response,
        archive.open("wb") as output,
    ):
        while chunk := response.read(1024 * 1024):
            output.write(chunk)
            digest.update(chunk)
    if digest.hexdigest() != expected:
        archive.unlink()
        raise ValueError("Lean archive checksum mismatch")
    subprocess.run(
        [
            "tar",
            "--zstd",
            "--no-same-owner",
            "-xf",
            str(archive),
            "-C",
            str(args.directory),
        ],
        check=True,
    )
    directory = args.directory / f"lean-{version}-linux/bin"
    result = subprocess.run(
        [str(directory / "lean"), "--version"],
        check=True,
        text=True,
        capture_output=True,
    )
    if f"version {version}," not in result.stdout:
        raise ValueError("The Lean SDK reports an unexpected version")
    print(result.stdout.strip(), file=sys.stderr)
    print(directory.resolve())


if __name__ == "__main__":
    main()
