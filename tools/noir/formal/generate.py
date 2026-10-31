"""Extract finite-field relation models from Solidity's typed AST and Garaga's circuit IR."""

import argparse
import hashlib
import json
import subprocess
from dataclasses import dataclass
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
MODULUS = 21888242871839275222246405745257275088548364400416034343698204186575808495617
PARAMETER_NAMES = ("beta", "gamma", "delta", "eta", "rom", "domain")


@dataclass(frozen=True)
class Expression:
    operation: str
    operands: tuple


def number(value):
    return Expression("number", (int(value),))


def variable(name):
    return Expression("variable", (name,))


def binary(operation, left, right):
    if operation not in ("+", "-", "*"):
        raise ValueError(f"Unsupported field operation: {operation}")
    return Expression(operation, (left, right))


WIRES = [variable(f"p {index}") for index in range(41)]
PARAMETERS = {
    name: variable(model)
    for name, model in zip(
        ("beta", "gamma", "publicInputsDelta", "eta", "romLogupGamma", "domainSep"),
        PARAMETER_NAMES,
    )
}
PARAMETERS["etaTwo"] = binary("*", PARAMETERS["eta"], PARAMETERS["eta"])
PARAMETERS["etaThree"] = binary("*", PARAMETERS["etaTwo"], PARAMETERS["eta"])


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


class SolidityExtractor:
    """Interpret only the straight-line Fr arithmetic used by the 31 relations."""

    def __init__(self, ast):
        self.nodes = {}
        self.environment = {}
        self.evaluations = [number(0)] * 31
        self.assigned = set()
        self.index(ast)
        modulus = next(node for node in ast["nodes"] if node.get("name") == "MODULUS")
        if int(modulus["value"]["value"], 0) != MODULUS:
            raise ValueError("Unexpected Solidity scalar modulus")
        enum = next(node for node in ast["nodes"] if node.get("name") == "WIRE")
        self.wires = {node["id"]: index for index, node in enumerate(enum["members"])}
        self.wire_names = [node["name"] for node in enum["members"]]
        self.library = next(
            node for node in ast["nodes"] if node.get("name") == "RelationsLib"
        )
        self.functions = [
            node
            for node in self.library["nodes"]
            if node.get("nodeType") == "FunctionDefinition"
            and node["name"].startswith("accumulate")
            and node["name"] != "accumulateRelationEvaluations"
        ]
        if len(self.functions) != 10 or len(self.wires) != 41:
            raise ValueError("Unexpected Solidity relation or wire count")

    def index(self, value):
        if isinstance(value, dict):
            if "id" in value:
                self.nodes[value["id"]] = value
            for child in value.values():
                self.index(child)
        elif isinstance(value, list):
            for child in value:
                self.index(child)

    def expression(self, node):
        kind = node["nodeType"]
        if kind == "Literal":
            return number(int(node["value"], 0))
        if kind == "TupleExpression":
            values = node["components"]
            if node.get("isInlineArray"):
                return [self.expression(value) for value in values]
            if len(values) != 1:
                raise ValueError("Unexpected tuple expression")
            return self.expression(values[0])
        if kind == "Identifier":
            ident = node["referencedDeclaration"]
            if ident in self.environment:
                return self.environment[ident]
            if node["name"] == "domainSep":
                return PARAMETERS["domainSep"]
            declaration = self.nodes[ident]
            if declaration["nodeType"] != "VariableDeclaration" or not declaration.get(
                "constant"
            ):
                raise ValueError(f"Unbound Solidity value: {node['name']}")
            return self.expression(declaration["value"])
        if kind == "MemberAccess":
            base = node["expression"]
            if base.get("name") == "rp":
                return PARAMETERS[node["memberName"]]
            if node["referencedDeclaration"] in self.wires:
                return self.wires[node["referencedDeclaration"]]
            return self.environment[(base["referencedDeclaration"], node["memberName"])]
        if kind == "IndexAccess":
            base = node["baseExpression"]
            index = self.expression(node["indexExpression"])
            if index.operation != "number":
                raise ValueError("Dynamic array index in a relation")
            index = index.operands[0]
            if base.get("name") == "evals":
                return self.evaluations[index]
            return self.expression(base)[index]
        if kind == "BinaryOperation":
            left = self.expression(node["leftExpression"])
            right = self.expression(node["rightExpression"])
            if node["operator"] == "<<":
                if left.operation != "number" or right.operation != "number":
                    raise ValueError("Nonconstant integer shift")
                return number(left.operands[0] << right.operands[0])
            if node["typeDescriptions"]["typeString"] != "Fr":
                if left.operation != "number" or right.operation != "number":
                    raise ValueError("Nonconstant integer arithmetic")
                a, b = left.operands[0], right.operands[0]
                value = {"+": lambda: a + b, "-": lambda: a - b, "*": lambda: a * b}[
                    node["operator"]
                ]()
                if not 0 <= value < 2**256:
                    raise ValueError("Integer constant outside uint256")
                return number(value)
            function = self.nodes[node["function"]]["name"]
            if function != {"+": "add", "-": "sub", "*": "mul"}.get(node["operator"]):
                raise ValueError("Unexpected overloaded field operator")
            return binary(node["operator"], left, right)
        if kind == "FunctionCall":
            function, arguments = node["expression"], node["arguments"]
            if function.get("name") == "wire":
                if len(arguments) != 2 or arguments[0].get("name") != "p":
                    raise ValueError("Unexpected wire call")
                return WIRES[self.expression(arguments[1])]
            if function.get("nodeType") == "ElementaryTypeNameExpression":
                if function["typeName"]["name"] != "uint256":
                    raise ValueError("Unexpected integer cast")
                return self.expression(arguments[0])
            if function.get("memberName") in ("wrap", "from"):
                if (
                    function["expression"]["name"] not in ("Fr", "FrLib")
                    or len(arguments) != 1
                ):
                    raise ValueError("Unexpected field conversion")
                value = self.expression(arguments[0])
                if value.operation != "number" or not 0 <= value.operands[0] < MODULUS:
                    raise ValueError("FrLib.from requires a canonical constant")
                return value
        raise ValueError(f"Unsupported Solidity expression: {kind}")

    def statement(self, node):
        kind = node["nodeType"]
        if kind == "Block":
            for child in node["statements"]:
                self.statement(child)
            return
        if kind == "VariableDeclarationStatement":
            if len(node["declarations"]) != 1:
                raise ValueError("Unexpected multiple declaration")
            if node.get("initialValue") is not None:
                self.environment[node["declarations"][0]["id"]] = self.expression(
                    node["initialValue"]
                )
            return
        if kind == "ExpressionStatement":
            assignment = node["expression"]
            if assignment["nodeType"] != "Assignment" or assignment["operator"] != "=":
                raise ValueError("Unexpected statement")
            target = assignment["leftHandSide"]
            value = self.expression(assignment["rightHandSide"])
            if target["nodeType"] == "Identifier":
                self.environment[target["referencedDeclaration"]] = value
            elif target["nodeType"] == "MemberAccess":
                self.environment[
                    (
                        target["expression"]["referencedDeclaration"],
                        target["memberName"],
                    )
                ] = value
            elif (
                target["nodeType"] == "IndexAccess"
                and target["baseExpression"]["name"] == "evals"
            ):
                index = self.expression(target["indexExpression"]).operands[0]
                self.evaluations[index] = value
                self.assigned.add(index)
            else:
                raise ValueError("Unexpected assignment target")
            return
        raise ValueError(f"Unsupported Solidity statement: {kind}")

    def extract(self):
        for function in self.functions:
            self.environment = {}
            self.statement(function["body"])
        if self.assigned != set(range(31)):
            raise ValueError("Missing Solidity subrelations")
        return self.evaluations


def cairo_relations(zero_indexes=()):
    # These imports belong only to the Cairo side. The Solidity CI needs no Python extension.
    from garaga.modulo_circuit import ModBuiltinOps, WriteOps
    from garaga.precompiled_circuits.zk_honk import Wire, ZKHonkVerifierCircuits

    circuit = ZKHonkVerifierCircuits("formal", 12, zero_commitments=zero_indexes)
    if circuit.field.p != MODULUS or len(Wire) != 41:
        raise ValueError("Unexpected field or wire layout")
    points = circuit.write_elements(list(range(1, 42)))
    beta, gamma, delta, eta, rom, domain = circuit.write_elements(
        [43, 44, 45, 46, 47, 48]
    )
    outputs = circuit.accumulate_relation_evaluations(
        points,
        beta,
        gamma,
        delta,
        eta,
        circuit.square(eta),
        circuit.product([eta, eta, eta]),
        rom,
        domain,
    )
    environment = {value.offset: WIRES[index] for index, value in enumerate(points)}
    environment.update(
        {
            value.offset: PARAMETERS[name]
            for name, value in zip(
                (
                    "beta",
                    "gamma",
                    "publicInputsDelta",
                    "eta",
                    "romLogupGamma",
                    "domainSep",
                ),
                (beta, gamma, delta, eta, rom, domain),
            )
        }
    )
    for offset, value in circuit.values_segment.segment.items():
        if offset in environment:
            continue
        if value.write_source == WriteOps.CONSTANT:
            environment[offset] = number(value.value)
            continue
        instruction = value.instruction
        if instruction is None:
            raise ValueError("Unbound Cairo circuit input")
        if instruction.operation == ModBuiltinOps.ADD:
            if instruction.result_offset == offset:
                result = binary(
                    "+",
                    environment[instruction.left_offset],
                    environment[instruction.right_offset],
                )
            elif instruction.right_offset == offset:
                result = binary(
                    "-",
                    environment[instruction.result_offset],
                    environment[instruction.left_offset],
                )
            else:
                raise ValueError("Unsupported add-mod constraint")
        elif (
            instruction.operation == ModBuiltinOps.MUL
            and instruction.result_offset == offset
        ):
            result = binary(
                "*",
                environment[instruction.left_offset],
                environment[instruction.right_offset],
            )
        else:
            raise ValueError("Unsupported or nonpolynomial circuit instruction")
        environment[offset] = result
    return [environment[value.offset] for value in outputs]


class Renderer:
    def __init__(self):
        self.constants = set()

    def normalize_constant(self, value):
        residue = value % MODULUS
        normalized = residue - MODULUS if residue > MODULUS // 2 else residue
        self.constants.add((value, normalized))
        return normalized

    def definition(self, name, expression):
        statements, seen = [], {}

        def visit(node):
            if node.operation == "variable":
                return f"({node.operands[0]})"
            if node.operation == "number":
                return f"({self.normalize_constant(node.operands[0])})"
            if node in seen:
                return seen[node]
            left, right = (visit(value) for value in node.operands)
            reference = f"t{len(statements)}"
            seen[node] = reference
            statements.append(f"  let {reference} := {left} {node.operation} {right}")
            return reference

        result = visit(expression)
        signature = f"def {name} (p : Nat → Fr) (beta gamma delta eta rom domain : Fr) : Fr :=\n"
        return signature + "\n".join(statements) + "\n  " + result + "\n"

    def literal_proofs(self, side):
        return (
            "\n".join(
                f"theorem {side}_literal_{index} : ({original} : Fr) = ({normalized} : Fr) := by decide"
                for index, (original, normalized) in enumerate(sorted(self.constants))
            )
            + "\n"
        )


def header(sources):
    lines = [
        "-- Generated by tools/noir/formal/generate.py. Do not edit.",
        f"-- sha256 extractor: {sha(Path(__file__))}",
    ]
    if any("Solidity" in path for path, _ in sources):
        lines[:0] = [
            "-- SPDX-License-Identifier: Apache-2.0",
            "-- Derived from Barretenberg v6.0.0 generated Solidity (Copyright 2022 Aztec).",
        ]
    lines.extend(f"-- sha256 {path}: {digest}" for path, digest in sources)
    return (
        "\n".join(lines)
        + "\nmodule\npublic import Honk.Field\n\n@[expose] public section\nset_option linter.unusedVariables false\nnamespace Honk\n\n"
    )


def update(path, content, check):
    if check:
        if not path.is_file() or path.read_text() != content:
            raise ValueError(f"Stale formal model: {path.relative_to(ROOT)}")
    else:
        path.write_text(content)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--side", choices=("all", "cairo", "solidity"), default="all")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    if args.side in ("all", "solidity"):
        subprocess.run(
            ["forge", "build", "--root", str(ROOT / "tools/noir"), "--ast"],
            cwd=ROOT,
            check=True,
            capture_output=True,
        )
        artifact = json.loads(
            (
                ROOT / "tools/noir/target/solidity/hello.sol/RelationsLib.json"
            ).read_text()
        )
        extractor = SolidityExtractor(artifact["ast"])
        source = (ROOT / "tools/noir/target/references/hello.sol").read_bytes()
        start, length, _ = map(int, extractor.library["src"].split(":"))
        renderer = Renderer()
        content = header(
            [
                ("generated Solidity hello.sol", hashlib.sha256(source).hexdigest()),
                (
                    "generated Solidity RelationsLib",
                    hashlib.sha256(source[start : start + length]).hexdigest(),
                ),
            ]
        )
        content += "\n".join(
            renderer.definition(f"solidity_{index}", expression)
            for index, expression in enumerate(extractor.extract())
        )
        content += renderer.literal_proofs("solidity") + "\nend Honk\n"
        update(DIRECTORY / "Honk/GeneratedSolidity.lean", content, args.check)
    if args.side in ("all", "cairo"):
        from garaga.precompiled_circuits.zk_honk import HonkVk

        sources = [
            "hydra/garaga/precompiled_circuits/zk_honk.py",
            "hydra/garaga/modulo_circuit.py",
            "hydra/garaga/precompiled_circuits/compilable_circuits/ultra_honk.py",
        ]
        renderer = Renderer()
        content = header([(name, sha(ROOT / name)) for name in sources])
        content += "\n".join(
            renderer.definition(f"cairo_{index}", expression)
            for index, expression in enumerate(cairo_relations())
        )
        manifest = json.loads(
            (
                ROOT
                / "hydra/garaga/starknet/honk_contract_generator/examples/noir_artifacts.json"
            ).read_text()
        )
        for case, metadata in manifest["cases"].items():
            key_path = (
                ROOT
                / "hydra/garaga/starknet/honk_contract_generator/examples"
                / metadata["files"]["vk"]["path"]
            )
            indexes = HonkVk.from_bytes(key_path.read_bytes()).zero_commitment_indexes()
            content += f"\n-- sha256 key {case}: {sha(key_path)}\n"
            members = ", ".join(map(str, indexes))
            content += f"def zeroed_{case} (p : Nat → Fr) (i : Nat) : Fr :=\n  if i ∈ ([{members}] : List Nat) then 0 else p i\n\n"
            content += "\n".join(
                renderer.definition(f"cairo_{case}_{index}", expression)
                for index, expression in enumerate(cairo_relations(indexes))
            )
        content += renderer.literal_proofs("cairo") + "\nend Honk\n"
        update(DIRECTORY / "Honk/GeneratedCairo.lean", content, args.check)
    print(f"Formal source models {'match' if args.check else 'updated'}: {args.side}")


if __name__ == "__main__":
    main()
