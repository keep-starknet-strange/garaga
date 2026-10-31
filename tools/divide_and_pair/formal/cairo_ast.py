"""Export CairoLS 2.21 parser nodes without third-party Python dependencies."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import re
import select
import shutil
import subprocess
import tempfile
import time
from pathlib import Path

NODE = re.compile(
    r"^((?:(?:│   |    ))*)(?:├── |└── )(.+?) \(kind: ([A-Za-z0-9_]+)\)(.*)$"
)
ANSI = re.compile(r"\x1b\[[0-?]*[ -/]*[@-~]")


class Client:
    def __init__(self, sdk: Path, scratch: Path, stderr):
        env = os.environ.copy()
        env["PATH"] = str(sdk) + ":" + env["PATH"]
        env["SCARB"] = str(sdk / "scarb")
        env["SCARB_TARGET_DIR"] = str(scratch / "target")
        env["NO_COLOR"] = "1"
        env["CLICOLOR"] = "0"
        env.pop("CLICOLOR_FORCE", None)
        env.pop("FORCE_COLOR", None)
        self.process = subprocess.Popen(
            [str(sdk / "scarb-cairo-language-server")],
            cwd=scratch,
            env=env,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=stderr,
            bufsize=0,
        )
        self.buffer = bytearray()
        self.next_id = 1
        self.notifications = []

    def send(self, value):
        raw = json.dumps(value, ensure_ascii=False).encode("utf-8")
        frame = b"Content-Length: " + str(len(raw)).encode() + b"\r\n\r\n" + raw
        view = memoryview(frame)
        while view:
            count = os.write(self.process.stdin.fileno(), view)
            view = view[count:]

    def receive(self, deadline):
        while True:
            separator = self.buffer.find(b"\r\n\r\n")
            if separator >= 0:
                headers = {}
                for line in self.buffer[:separator].decode("ascii").split("\r\n"):
                    key, value = line.split(":", 1)
                    headers[key.lower()] = value.strip()
                length = int(headers["content-length"])
                if length < 0 or length > 20_000_000:
                    raise ValueError("Unsupported LSP frame length")
                end = separator + 4 + length
                if len(self.buffer) >= end:
                    raw = bytes(self.buffer[separator + 4 : end])
                    del self.buffer[:end]
                    return json.loads(raw)
            remaining = deadline - time.monotonic()
            if (
                remaining <= 0
                or not select.select([self.process.stdout], [], [], remaining)[0]
            ):
                raise TimeoutError("Language server response timed out")
            raw = os.read(self.process.stdout.fileno(), 65536)
            if not raw:
                raise RuntimeError("Language server exited before its response")
            self.buffer.extend(raw)

    def notify(self, method, params):
        self.send({"jsonrpc": "2.0", "method": method, "params": params})

    def request(self, method, params, timeout=20):
        request_id = self.next_id
        self.next_id += 1
        self.send(
            {"jsonrpc": "2.0", "id": request_id, "method": method, "params": params}
        )
        deadline = time.monotonic() + timeout
        while True:
            message = self.receive(deadline)
            if message.get("id") == request_id and (
                "result" in message or "error" in message
            ):
                return message
            if "method" in message and "id" in message:
                if message["method"] == "workspace/configuration":
                    result = [{} for _ in message.get("params", {}).get("items", [])]
                elif message["method"] in (
                    "client/registerCapability",
                    "window/workDoneProgress/create",
                ):
                    result = None
                else:
                    self.send(
                        {
                            "jsonrpc": "2.0",
                            "id": message["id"],
                            "error": {
                                "code": -32601,
                                "message": "Unsupported client request",
                            },
                        }
                    )
                    continue
                self.send({"jsonrpc": "2.0", "id": message["id"], "result": result})
            else:
                self.notifications.append(message)

    def close(self):
        try:
            self.request("shutdown", None, timeout=5)
            self.notify("exit", None)
            self.process.wait(timeout=5)
        except Exception:
            self.process.terminate()
            try:
                self.process.wait(timeout=2)
            except subprocess.TimeoutExpired:
                self.process.kill()
                self.process.wait()


def dump_tree(sdk: Path, source: str, scratch: Path, stderr):
    file = scratch / "input.cairo"
    file.write_bytes(source.encode("utf-8"))
    client = Client(sdk, scratch, stderr)
    try:
        initialize = client.request(
            "initialize",
            {
                "processId": None,
                "rootUri": scratch.as_uri(),
                "capabilities": {"workspace": {"configuration": True}},
                "workspaceFolders": [
                    {"uri": scratch.as_uri(), "name": "cairo-source-extraction"}
                ],
            },
        )
        if "error" in initialize:
            raise RuntimeError(initialize)
        client.notify("initialized", {})
        client.notify(
            "textDocument/didOpen",
            {
                "textDocument": {
                    "uri": file.as_uri(),
                    "languageId": "cairo",
                    "version": 1,
                    "text": source,
                }
            },
        )
        for attempt in range(8):
            response = client.request(
                "cairo/viewSyntaxTree",
                {
                    "textDocument": {"uri": file.as_uri()},
                    "position": {"line": 0, "character": 0},
                },
            )
            if isinstance(response.get("result"), str):
                return ANSI.sub("", response["result"])
            if "result" in response and response["result"] is not None:
                raise RuntimeError("Unexpected syntax response type")
            error = response.get("error", {})
            if error.get("code") not in (-32800, -32802) and "result" not in response:
                raise RuntimeError(response)
            time.sleep(0.05 * (attempt + 1))
        raise RuntimeError(
            "Syntax tree remained unavailable after bounded cancellation retries"
        )
    finally:
        client.close()


def parse_tree(dump: str):
    # The response appends a cursor-ancestor display after the complete tree.
    full, separator, _branch = dump.partition("\n\n")
    if not separator:
        raise ValueError("Expected CairoLS full-tree/cursor-branch separator")
    stack = []
    root = None
    for line in full.splitlines():
        match = NODE.fullmatch(line)
        if not match:
            raise ValueError(f"Unsupported or missing syntax node: {line!r}")
        prefix, field, kind, suffix = match.groups()
        depth = len(prefix) // 4
        node = {"field": field, "kind": kind, "children": []}
        if "Missing" in kind or "Skipped" in kind or "Bad" in kind:
            raise ValueError(f"Invalid parser node: {kind}")
        if kind.startswith("Token"):
            if kind == "TokenEndOfFile" and suffix == ".":
                node["text"] = ""
            elif suffix.startswith(": '") and suffix.endswith("'"):
                node["text"] = suffix[3:-1]
            else:
                raise ValueError(f"Unsupported token encoding: {line!r}")
        elif suffix not in ("", " []"):
            raise ValueError(f"Unsupported internal-node encoding: {line!r}")
        if depth == 0:
            if root is not None or kind != "SyntaxFile":
                raise ValueError("Expected a single SyntaxFile root")
            root = node
        else:
            if depth > len(stack):
                raise ValueError("Syntax tree indentation skipped a parent")
            stack[depth - 1]["children"].append(node)
        stack = stack[:depth]
        stack.append(node)
    if root is None:
        raise ValueError("Empty parser tree")
    return root, full + "\n"


def attach_source_spans(root, source: str):
    # Spans are derived token spans, excluding trivia. CairoLS does not export offsets.
    cursor = 0
    byte_offsets = [0]
    for character in source:
        byte_offsets.append(byte_offsets[-1] + len(character.encode("utf-8")))

    def skip_trivia(position):
        while position < len(source):
            if source[position] in " \t\r\n":
                position += 1
            elif source.startswith("//", position):
                newline = source.find("\n", position + 2)
                position = len(source) if newline == -1 else newline + 1
            elif source.startswith("/*", position):
                position += 2
                nesting = 1
                while nesting:
                    if position >= len(source):
                        raise ValueError("Unterminated block comment")
                    if source.startswith("/*", position):
                        nesting += 1
                        position += 2
                    elif source.startswith("*/", position):
                        nesting -= 1
                        position += 2
                    else:
                        position += 1
            else:
                break
        return position

    def visit(node):
        nonlocal cursor
        start = skip_trivia(cursor)
        if node["kind"].startswith("Token"):
            cursor = start
            text = node["text"]
            if not source.startswith(text, cursor):
                raise ValueError(f"Token/source mismatch at {cursor}: {text!r}")
            cursor += len(text)
            if node["kind"] == "TokenEndOfFile" and cursor != len(source):
                raise ValueError("Parser omitted nontrivia source before end of file")
            node["span_bytes"] = [byte_offsets[start], byte_offsets[cursor]]
        else:
            for child in node["children"]:
                visit(child)
            occupied = [
                child["span_bytes"]
                for child in node["children"]
                if child["span_bytes"][0] != child["span_bytes"][1]
            ]
            node["span_bytes"] = (
                [occupied[0][0], occupied[-1][1]]
                if occupied
                else [byte_offsets[start], byte_offsets[start]]
            )

    visit(root)
    if skip_trivia(cursor) != len(source):
        raise ValueError("Parser omitted trailing source")


def export(source_path: Path, sdk: Path | None = None):
    """Read the pinned compiler AST and bind every token to the source bytes."""
    if sdk is None:
        executable = shutil.which("scarb-cairo-language-server")
        if executable is None:
            raise RuntimeError("Install Scarb 2.21.0 and add its bin directory to PATH")
        sdk = Path(executable).resolve().parent
    expected = {
        "scarb": "fc5ec751cb5e495f85c4e77da61a587845ae3c2354999b0dc31c56bfb9f5fc45",
        "scarb-cairo-language-server": "6d054d42e021c40d763232f4bc2341a681bcbfdbdf2caedc22553da219b96422",
    }
    actual = {
        name: hashlib.sha256((sdk / name).read_bytes()).hexdigest() for name in expected
    }
    if actual != expected:
        raise ValueError(
            "The Cairo frontend requires the pinned Linux x86_64 Scarb 2.21.0 binaries"
        )
    source_bytes = source_path.read_bytes()
    with tempfile.TemporaryDirectory(prefix="cairo-formal-ast-") as directory:
        scratch = Path(directory)
        with (scratch / "server.stderr").open("w") as stderr:
            dump = dump_tree(sdk, source_bytes.decode("utf-8"), scratch, stderr)
    root, full = parse_tree(dump)
    attach_source_spans(root, source_bytes.decode("utf-8"))
    if source_path.read_bytes() != source_bytes:
        raise RuntimeError("Source changed during extraction")
    return root, {
        "source_sha256": hashlib.sha256(source_bytes).hexdigest(),
        "syntax_tree_sha256": hashlib.sha256(full.encode("utf-8")).hexdigest(),
        "tool_sha256": actual,
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path)
    parser.add_argument("--sdk", type=Path)
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()
    tree, metadata = export(args.source, args.sdk)
    args.out.mkdir(parents=True, exist_ok=True)
    (args.out / "syntax-tree.json").write_text(
        json.dumps(tree, indent=2, sort_keys=True) + "\n"
    )
    (args.out / "metadata.json").write_text(
        json.dumps(metadata, indent=2, sort_keys=True) + "\n"
    )


if __name__ == "__main__":
    main()
