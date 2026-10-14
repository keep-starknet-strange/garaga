#!/usr/bin/env python3
"""Sync toolchain config from constants.json without regenerating Cairo code."""

import argparse
import ast
import json
import re
import subprocess
import sys
import tomllib
from pathlib import Path

CAIRO_DEPENDENCIES = {"starknet", "cairo_test", "assert_macros", "cairo_execute"}
DEPENDENCY_SECTIONS = {"dependencies", "dev-dependencies", "workspace.dependencies"}
TOML_STRING = re.compile(
    r"^([ \t]*([\w-]+)[ \t]*=[ \t]*)(['\"])([^'\"\r\n]*)\3([ \t]*(?:#.*)?(?:\r?\n)?)$"
)
WORKFLOW_INPUT = re.compile(
    r"^([ \t]*(scarb-version|starknet-foundry-version):[ \t]*)(['\"]?)"
    r"(\d+\.\d+\.\d+)\3([ \t]*(?:#.*)?(?:\r?\n)?)$"
)


def dependency_version(name, cairo, foundry):
    return foundry if name == "snforge_std" else cairo


def sync_manifest(content, cairo, foundry):
    manifest = tomllib.loads(content)
    if '"""' in content or "'''" in content:
        raise ValueError("Multi-line TOML strings require a format-preserving parser")
    expected = {}
    for section in DEPENDENCY_SECTIONS:
        table = manifest
        for part in section.split("."):
            if not isinstance(table, dict):
                raise ValueError(f"Unsupported dependency table: [{section}]")
            table = table.get(part, {})
        if not isinstance(table, dict):
            raise ValueError(f"Unsupported dependency table: [{section}]")
        for key in CAIRO_DEPENDENCIES | {"snforge_std"}:
            if key not in table:
                continue
            value = table[key]
            if isinstance(value, dict) and value == {"workspace": True}:
                continue
            if not isinstance(value, str):
                raise ValueError(f"Unsupported toolchain dependency: [{section}] {key}")
            expected[(section, key)] = dependency_version(key, cairo, foundry)

    section = ""
    seen = set()
    lines = []
    for line in content.splitlines(keepends=True):
        header = line.split("#", 1)[0].strip()
        if header.startswith("["):
            section = header.strip("[]")
        match = TOML_STRING.fullmatch(line)
        if match and (section, match[2]) in expected:
            key = (section, match[2])
            seen.add(key)
            line = f"{match[1]}{match[3]}{expected[key]}{match[3]}{match[5]}"
        lines.append(line)
    if seen != expected.keys():
        missing = sorted(expected.keys() - seen)
        raise ValueError(f"Unsupported toolchain dependency format: {missing}")
    return "".join(lines), len(seen)


def sync_tool_versions(content, cairo, foundry):
    versions = {"scarb": cairo, "starknet-foundry": foundry}
    seen = set()
    lines = []
    for line in content.splitlines(keepends=True):
        parts = line.strip().split()
        if parts and parts[0] in versions:
            name = parts[0]
            match = re.fullmatch(
                rf"([ \t]*{re.escape(name)}[ \t]+)(\S+)([ \t]*(?:#.*)?(?:\r?\n)?)",
                line,
            )
            if not match or name in seen:
                raise ValueError(f"Unsupported or duplicate tool version: {name}")
            seen.add(name)
            line = f"{match[1]}{versions[name]}{match[3]}"
        lines.append(line)
    return "".join(lines), len(seen)


def sync_workflow(content, cairo, foundry):
    versions = {"scarb-version": cairo, "starknet-foundry-version": foundry}
    count = 0
    lines = []
    for line in content.splitlines(keepends=True):
        key = line.lstrip().partition(":")[0]
        if key in versions:
            match = WORKFLOW_INPUT.fullmatch(line)
            if not match:
                raise ValueError(f"Unsupported workflow input format: {key}")
            line = f"{match[1]}{match[3]}{versions[key]}{match[3]}{match[5]}"
            count += 1
        lines.append(line)
    return "".join(lines), count


def sync_generator_constants(content, cairo, foundry):
    versions = {"CAIRO_VERSION": cairo, "STARKNET_FOUNDRY_VERSION": foundry}
    lines = content.splitlines(keepends=True)
    seen = set()
    for node in ast.parse(content).body:
        if not isinstance(node, ast.Assign) or len(node.targets) != 1:
            continue
        target = node.targets[0]
        if not isinstance(target, ast.Name) or target.id not in versions:
            continue
        if (
            target.id in seen
            or not isinstance(node.value, ast.Constant)
            or not isinstance(node.value.value, str)
            or node.value.lineno != node.value.end_lineno
        ):
            raise ValueError(f"Unsupported generator version assignment: {target.id}")
        seen.add(target.id)
        line = lines[node.value.lineno - 1]
        start, end = node.value.col_offset, node.value.end_col_offset
        quote = line[start]
        if quote not in {"'", '"'} or line[start:end].startswith(quote * 3):
            raise ValueError(f"Unsupported generator string format: {target.id}")
        lines[node.value.lineno - 1] = (
            line[:start] + quote + versions[target.id] + quote + line[end:]
        )
    if seen != versions.keys():
        raise ValueError("Missing generator toolchain version assignments")
    return "".join(lines), len(seen)


def toolchain_plan(root):
    source = json.loads((root / "tools/make/constants.json").read_text())
    cairo = source["release_info"]["cairo_version"]
    foundry = source["release_info"]["starknet_foundry_version"]
    for value in (cairo, foundry):
        if not isinstance(value, str) or not re.fullmatch(r"\d+\.\d+\.\d+", value):
            raise ValueError("Toolchain versions must use the format major.minor.patch")

    tracked = subprocess.check_output(
        ["git", "-C", str(root), "ls-files", "-z"], text=True
    ).split("\0")
    if "hydra/garaga/starknet/constants.py" not in tracked:
        raise ValueError("Missing tracked generator constants file")
    plan = []
    for name in sorted(tracked):
        path = Path(name)
        if path.name == "Scarb.toml":
            transform = sync_manifest
        elif path.name == ".tool-versions":
            transform = sync_tool_versions
        elif path.parent == Path(".github/workflows") and path.suffix in {
            ".yml",
            ".yaml",
        }:
            transform = sync_workflow
        elif name == "hydra/garaga/starknet/constants.py":
            transform = sync_generator_constants
        else:
            continue
        content = (root / path).read_bytes().decode("utf-8")
        try:
            updated, count = transform(content, cairo, foundry)
        except (ValueError, SyntaxError) as error:
            raise ValueError(f"{name}: {error}") from error
        if count:
            plan.append((path, content, updated, count))
    return plan


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--check", action="store_true", help="Report drift without writes"
    )
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[2]
    try:
        plan = toolchain_plan(root)
        changed = [(path, after) for path, before, after, _ in plan if before != after]
        for path, after in changed:
            print(f"{'Drift' if args.check else 'Sync'}: {path}")
            if not args.check:
                (root / path).write_bytes(after.encode("utf-8"))
        pins = sum(count for _, _, _, count in plan)
        print(f"Checked {pins} toolchain pins in {len(plan)} files")
        if changed and args.check:
            print(
                "Run python tools/make/sync_toolchain.py to sync the toolchain config.",
                file=sys.stderr,
            )
            return 1
        return 0
    except (
        OSError,
        ValueError,
        KeyError,
        TypeError,
        subprocess.CalledProcessError,
    ) as error:
        print(f"Toolchain config error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
