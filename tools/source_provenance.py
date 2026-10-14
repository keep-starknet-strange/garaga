"""Fingerprint a Git revision and its local source changes without dependencies."""

import hashlib
import os
import subprocess
from pathlib import Path


def capture_source_provenance(workspace_root: Path) -> dict:
    """Fingerprint this Git repository's patches and nonignored untracked files."""

    def git(*arguments, cwd=workspace_root):
        return subprocess.run(
            ["git", *arguments], cwd=cwd, check=True, capture_output=True
        ).stdout

    try:
        repo_root = Path(os.fsdecode(git("rev-parse", "--show-toplevel").rstrip(b"\n")))
        revision = git("rev-parse", "HEAD", cwd=repo_root).decode().strip()
        diff_arguments = (
            "--binary",
            "--no-ext-diff",
            "--no-textconv",
            "--no-color",
            "--full-index",
        )
        staged = git("diff", "--cached", *diff_arguments, cwd=repo_root)
        unstaged = git("diff", *diff_arguments, cwd=repo_root)
        untracked = sorted(
            name
            for name in git(
                "ls-files", "--others", "--exclude-standard", "-z", cwd=repo_root
            ).split(b"\0")
            if name
        )
        digest = hashlib.sha256()
        for label, patch in [(b"staged", staged), (b"unstaged", unstaged)]:
            digest.update(label + b"\0" + len(patch).to_bytes(8, "big") + patch)
        for name in untracked:
            path = repo_root / os.fsdecode(name)
            if path.is_symlink():
                content = os.fsencode(os.readlink(path))
            elif path.is_file():
                content = path.read_bytes()
            else:
                raise OSError(f"Cannot fingerprint {path}")
            digest.update(name + b"\0" + str(path.lstat().st_mode).encode() + b"\0")
            digest.update(len(content).to_bytes(8, "big") + content)
        dirty = bool(staged or unstaged or untracked)
        return {
            "source_revision": revision,
            "source_dirty": dirty,
            "source_changes_sha256": digest.hexdigest() if dirty else None,
        }
    except (OSError, subprocess.CalledProcessError):
        return {
            "source_revision": None,
            "source_dirty": None,
            "source_changes_sha256": None,
        }
