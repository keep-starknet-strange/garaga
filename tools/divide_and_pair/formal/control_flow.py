"""Extract field-level control flow from the pinned Cairo compiler AST.

The supported subset has pure field primitives, tuples, local assignments,
conditionals, options, and early returns. Unsupported syntax fails closed.
The field primitives retain the Cairo compiler and circuit builtin boundary.
"""

import argparse
import hashlib
from pathlib import Path

if __package__:
    from .cairo_ast import export
else:
    from cairo_ast import export

ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent
SOURCE = ROOT / "src/src/ec/ed25519.cairo"
FUNCTIONS = {
    "is_small_order_edwards": ("x y", "Bool"),
    "sqrt": ("value", "Option Fp"),
    "sqrt_or_twice": ("value", "Option (Bool × Fp)"),
    "is_in_prime_order_subgroup_edwards": ("x y", "Bool"),
}
CIRCUITS = {
    "run_ED25519_LOW_ORDER_circuit": ("low_order", 1),
    "run_ED25519_PREPARE_circuit": ("prepare", 3),
    "run_ED25519_SQRT_circuit": ("sqrt", 3),
    "run_ED25519_SQRT_OR_TWICE_circuit": ("sqrt_or_twice", 5),
    "run_ED25519_HALVE_UP_circuit": ("halve_up", 1),
    "run_ED25519_HALVE_NQR_circuit": ("halve_nqr", 3),
    "run_ED25519_FINISH_circuit": ("finish", 1),
}
IMPORTS = {
    "usecore::circuit::u384;",
    "usecore::num::traits::{One,Zero};",
    "usegaraga::basic_field_ops::mul_mod_p;",
    "usegaraga::circuits::ed25519::{run_ED25519_FINISH_circuit,run_ED25519_FROM_WEIERSTRASS_circuit,"
    "run_ED25519_HALVE_NQR_circuit,run_ED25519_HALVE_UP_circuit,run_ED25519_LOW_ORDER_circuit,"
    "run_ED25519_PREPARE_circuit,run_ED25519_SQRT_OR_TWICE_circuit,run_ED25519_SQRT_circuit,};",
    "usegaraga::definitions::{ED25519,G1Point,get_ED25519_modulus};",
    "usegaraga::ec::ec_ops::G1PointTrait;",
}


def tokens(node):
    if node["kind"].startswith("Token"):
        return node["text"]
    return "".join(tokens(item) for item in node["children"])


def child(node, field):
    found = [item for item in node["children"] if item["field"] == field]
    if len(found) != 1:
        raise ValueError(f"Expected one {field} in {node['kind']}")
    return found[0]


def items(node):
    return [
        item
        for item in node["children"]
        if item["field"].startswith(("item #", "child #"))
    ]


def path(node):
    if node["kind"] != "ExprPath":
        raise ValueError(f"Expected an unqualified path, got {node['kind']}")
    segments = items(child(node, "segments"))
    if any(segment["kind"] != "PathSegmentSimple" for segment in segments):
        raise ValueError("Generic paths are outside the field model")
    return "::".join(child(segment, "ident")["text"] for segment in segments)


def arguments(node):
    output = []
    for argument in items(child(child(node, "arguments"), "arguments")):
        if child(argument, "modifiers")["children"]:
            raise ValueError("Reference arguments are outside the pure field model")
        clause = child(argument, "arg_clause")
        if clause["kind"] != "ArgClauseUnnamed":
            raise ValueError("Named arguments are outside the field model")
        output.append(child(clause, "value"))
    return output


def names(node):
    if node["kind"] == "ExprPath":
        name = path(node)
        if "::" in name:
            raise ValueError("Qualified local binding")
        if (
            name in FUNCTIONS
            or name in CIRCUITS
            or name in {"mul_mod_p", "get_ED25519_modulus"}
            or name.isupper()
        ):
            raise ValueError("A local binding shadows a modeled primitive or constant")
        return [name]
    if node["kind"] == "PatternIdentifier":
        modifiers = child(node, "modifiers")["children"]
        if any(modifier["kind"] != "TokenMut" for modifier in modifiers):
            raise ValueError("Unsupported binding modifier")
        return [child(node, "name")["text"]]
    if node["kind"] == "PatternTuple":
        return [name for item in items(child(node, "patterns")) for name in names(item)]
    raise ValueError(f"Unsupported binding pattern {node['kind']}")


def literal(node):
    if node["kind"] == "TokenLiteralNumber":
        return int(node["text"], 0)
    if node["kind"] != "ExprStructCtorCall" or path(child(node, "path")) != "u384":
        raise ValueError("Expected a u384 literal")
    limbs = {}
    for argument in items(child(child(node, "arguments"), "arguments")):
        key = child(argument, "identifier")["text"]
        if key in limbs or key not in {f"limb{i}" for i in range(4)}:
            raise ValueError("Unexpected u384 limb")
        limbs[key] = literal(child(child(argument, "arg_expr"), "expr"))
    if len(limbs) != 4 or any(value >= 2**96 for value in limbs.values()):
        raise ValueError("Invalid u384 limbs")
    return sum(limbs[f"limb{i}"] << (96 * i) for i in range(4))


class Translator:
    def __init__(self, constants, abstract_calls=False):
        self.constants = constants
        self.abstract_calls = abstract_calls

    def expression(self, node):
        kind = node["kind"]
        if kind == "ExprPath":
            name = path(node)
            if name == "None":
                return "none"
            return f"cairoConstant_{name}" if name in self.constants else name
        if kind in ("TokenTrue", "TokenFalse"):
            return node["text"]
        if kind in ("TokenLiteralNumber", "ExprStructCtorCall"):
            return str(literal(node))
        if kind == "ExprListParenthesized":
            values = [
                self.expression(item) for item in items(child(node, "expressions"))
            ]
            if len(values) < 2:
                raise ValueError("Expected a tuple with two or more elements")
            return "(" + ", ".join(values) + ")"
        if kind == "ExprUnary" and child(node, "op")["kind"] == "TokenNot":
            return f"(!{self.expression(child(node, 'expr'))})"
        if kind == "ExprBinary":
            op = child(node, "op")["kind"]
            lhs, rhs = child(node, "lhs"), child(node, "rhs")
            if op == "TokenDot":
                if rhs["kind"] != "ExprFunctionCall" or arguments(rhs):
                    raise ValueError("Unsupported field method")
                method = path(child(rhs, "path"))
                if method not in ("is_zero", "is_one"):
                    raise ValueError(f"Unsupported field method {method}")
                return f"decide ({self.expression(lhs)} = {0 if method == 'is_zero' else 1})"
            if op in ("TokenAndAnd", "TokenOrOr"):
                operator = "&&" if op == "TokenAndAnd" else "||"
                return f"({self.expression(lhs)} {operator} {self.expression(rhs)})"
            raise ValueError(f"Unsupported field binary operation {op}")
        if kind == "ExprFunctionCall":
            name = path(child(node, "path"))
            args = arguments(node)
            values = [self.expression(argument) for argument in args]
            if name == "get_ED25519_modulus" and not values:
                return "()"
            if (
                name == "mul_mod_p"
                and len(values) == 3
                and values[2] in ("modulus", "()")
            ):
                return f"({values[0]}*{values[1]})"
            if name == "One::one" and not values:
                return "(1 : Fp)"
            if name == "Some" and len(values) == 1:
                return f"some ({values[0]})"
            if name in FUNCTIONS:
                prefix = "dependency" if self.abstract_calls else "cairoFlow"
                return f"{prefix}_{name} " + " ".join(f"({value})" for value in values)
            if name in CIRCUITS:
                operation, _arity = CIRCUITS[name]
                if self.abstract_calls and operation == "finish":
                    return "dependency_finish " + " ".join(
                        f"({value})" for value in values
                    )
                return f"cairo_{operation} " + " ".join(
                    f"({value})" for value in values
                )
            raise ValueError(f"Unsupported field call {name}")
        raise ValueError(f"Unsupported pure field expression {kind}")

    def pattern(self, node):
        if node["kind"] == "PatternEnum":
            if path(child(node, "path")) != "Some":
                raise ValueError("Unsupported option constructor")
            return "some " + self.pattern(child(child(node, "pattern"), "pattern"))
        if node["kind"] == "ExprPath":
            name = path(node)
            return "none" if name == "None" else name
        if node["kind"] == "PatternTuple":
            return (
                "("
                + ", ".join(
                    self.pattern(item) for item in items(child(node, "patterns"))
                )
                + ")"
            )
        raise ValueError(f"Unsupported match pattern {node['kind']}")

    def block(self, node, continuation=None):
        if node["kind"] != "ExprBlock":
            raise ValueError("Expected a block")
        return self.statements(items(child(node, "statements")), continuation)

    def value(self, node, continuation):
        kind = node["kind"]
        if kind == "ExprBlock":
            return self.block(node, continuation)
        if kind == "ExprIf":
            conditions = items(child(node, "conditions"))
            if len(conditions) != 1 or conditions[0]["kind"] != "ConditionExpr":
                raise ValueError("Unsupported if condition")
            condition = self.expression(child(conditions[0], "expr"))
            yes = self.block(child(node, "if_block"), continuation)
            clause = child(node, "else_clause")
            if clause["kind"] == "OptionElseClauseEmpty":
                if continuation is None:
                    raise ValueError("Missing else value")
                no = continuation(None)
            elif clause["kind"] == "ElseClause":
                no = self.value(child(clause, "else_block_or_if"), continuation)
            else:
                raise ValueError("Unsupported else clause")
            return f"if {condition} then\n{indent(yes)}\nelse\n{indent(no)}"
        if kind == "ExprMatch":
            arms = []
            for arm in items(child(node, "arms")):
                patterns = items(child(arm, "patterns"))
                if len(patterns) != 1:
                    raise ValueError("Alternative patterns are outside the model")
                pattern = self.pattern(patterns[0])
                value = self.value(child(arm, "expression"), continuation)
                arms.append(f"| {pattern} =>\n{indent(value)}")
            return f"match {self.expression(child(node, 'expr'))} with\n" + "\n".join(
                arms
            )
        value = self.expression(node)
        return value if continuation is None else continuation(value)

    def statements(self, statements, continuation):
        if not statements:
            if continuation is None:
                raise ValueError("Empty return path")
            return continuation(None)
        statement, *rest = statements
        kind = statement["kind"]
        if child(statement, "attributes")["children"]:
            raise ValueError("Statement attributes are outside the field model")
        if kind == "StatementReturn":
            return self.expression(child(child(statement, "expr_clause"), "expr"))
        if kind == "StatementLet":
            if child(statement, "type_clause")["kind"] != "OptionTypeClauseEmpty":
                raise ValueError("Explicit local types require a model update")
            if (
                child(statement, "let_else_clause")["kind"]
                != "OptionLetElseClauseEmpty"
            ):
                raise ValueError("Let-else is outside the model")
            bindings = names(child(statement, "pattern"))
            rhs = child(statement, "rhs")
            circuit = (
                path(child(rhs, "path")) if rhs["kind"] == "ExprFunctionCall" else None
            )

            def bind(value):
                if value is None:
                    raise ValueError("A binding path returns no value")
                tail = self.statements(rest, continuation)
                if circuit in CIRCUITS:
                    if len(bindings) != CIRCUITS[circuit][1]:
                        raise ValueError("Circuit output arity changed")
                    lets = [
                        f"let {name} : Fp := ({value})[{index}]!"
                        for index, name in enumerate(bindings)
                    ]
                    return "\n".join(lets) + "\n" + tail
                pattern = (
                    bindings[0]
                    if len(bindings) == 1
                    else "(" + ", ".join(bindings) + ")"
                )
                if pattern == "modulus" and value == "()":
                    pattern = "_modulus"
                return f"let {pattern} := {value}\n{tail}"

            return self.value(rhs, bind)
        if kind == "StatementExpr":
            expression = child(statement, "expr")
            if (
                expression["kind"] == "ExprBinary"
                and child(expression, "op")["kind"] == "TokenEq"
            ):
                binding = names(child(expression, "lhs"))
                if len(binding) != 1:
                    raise ValueError("Assignment to a nonlocal place")
                return (
                    f"let {binding[0]} := {self.expression(child(expression, 'rhs'))}\n"
                    + self.statements(rest, continuation)
                )
            if rest:
                return self.value(
                    expression, lambda _value: self.statements(rest, continuation)
                )
            return self.value(expression, continuation)
        raise ValueError(f"Unsupported statement {kind}")


def indent(source):
    return "\n".join("  " + line for line in source.splitlines())


def curve_parameters():
    source = ROOT / "src/src/definitions/curves.cairo"
    tree, metadata = export(source)
    curves = [
        item
        for item in items(child(tree, "items"))
        if item["kind"] == "ItemConstant" and child(item, "name")["text"] == "ED25519"
    ]
    if len(curves) != 1:
        raise ValueError("Expected one ED25519 curve declaration")
    value = child(curves[0], "value")
    if path(child(value, "path")) != "Curve":
        raise ValueError("The ED25519 curve type changed")
    fields = {
        child(argument, "identifier")["text"]: child(
            child(argument, "arg_expr"), "expr"
        )
        for argument in items(child(child(value, "arguments"), "arguments"))
    }
    result = {name: literal(fields[name]) for name in ("p", "a", "b")}
    order = fields["n"]
    if path(child(order, "path")) != "u256":
        raise ValueError("Expected a u256 curve order")
    limbs = {
        child(argument, "identifier")["text"]: literal(
            child(child(argument, "arg_expr"), "expr")
        )
        for argument in items(child(child(order, "arguments"), "arguments"))
    }
    if set(limbs) != {"low", "high"} or any(
        value >= 2**128 for value in limbs.values()
    ):
        raise ValueError("Invalid curve order limbs")
    result["n"] = limbs["low"] + (limbs["high"] << 128)
    modulus = fields["modulus"]
    if modulus["kind"] != "ExprFixedSizeArray":
        raise ValueError("Expected a literal curve modulus")
    values = [literal(item) for item in items(child(modulus, "exprs"))]
    if len(values) != 4 or any(value >= 2**96 for value in values):
        raise ValueError("Invalid circuit modulus limbs")
    if sum(value << (96 * index) for index, value in enumerate(values)) != result["p"]:
        raise ValueError("The ED25519 circuit modulus differs from its curve field")
    return result, metadata


def render(tree, metadata):
    functions, constants, imports = {}, {}, set()
    for item in items(child(tree, "items")):
        if item["kind"] == "FunctionWithBody":
            declaration = child(item, "declaration")
            name = child(declaration, "name")["text"]
            if name in functions:
                raise ValueError("Duplicate function")
            functions[name] = item
        elif item["kind"] == "ItemConstant":
            name = child(item, "name")["text"]
            if name in constants:
                raise ValueError("Duplicate constant")
            constants[name] = literal(child(item, "value"))
        elif item["kind"] == "ItemUse":
            imports.add(tokens(item))
        else:
            raise ValueError(f"Unsupported module item {item['kind']}")
    if imports != IMPORTS:
        raise ValueError("The primitive import bindings changed")
    if set(functions) != set(FUNCTIONS) | {"is_in_prime_order_subgroup"}:
        raise ValueError("The Cairo API requires a model update")
    translator = Translator(constants)
    curve, curve_metadata = curve_parameters()
    output = "module\n\npublic import DivideAndPair.Generated\n\n"
    output += "-- Generated from the Cairo compiler AST. Do not edit.\n"
    for name, value in metadata.items():
        output += f"-- {name}: {value}\n"
    output += f"-- curve_source_sha256: {curve_metadata['source_sha256']}\n"
    output += f"-- curve_ast_sha256: {curve_metadata['syntax_tree_sha256']}\n"
    output += (
        "-- extractor_sha256: "
        + hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
        + "\n"
    )
    output += (
        "@[expose] public section\nnamespace DivideAndPair\nnoncomputable section\n\n"
    )
    for name, value in constants.items():
        output += f"abbrev cairoConstant_{name} : Fp := {value}\n\n"
    for name, value in curve.items():
        output += f"abbrev cairoCurve_{name} : {'Nat' if name in ('p', 'n') else 'Fp'} := {value}\n\n"
    for name, (parameters, result) in FUNCTIONS.items():
        function = functions[name]
        if child(function, "attributes")["children"]:
            raise ValueError("Function attributes require a model update")
        signature = child(child(function, "declaration"), "signature")
        actual = items(child(signature, "parameters"))
        if [
            child(parameter, "name")["text"] for parameter in actual
        ] != parameters.split():
            raise ValueError(f"Unexpected parameters for {name}")
        if any(
            path(child(child(parameter, "type_clause"), "ty")) != "u384"
            for parameter in actual
        ):
            raise ValueError("Only canonical field parameters are supported")
        if name == "is_in_prime_order_subgroup_edwards":
            output += f"def cairoBody_{name}\n"
            output += "    (dependency_is_small_order_edwards : Fp → Fp → Bool)\n"
            output += "    (dependency_sqrt : Fp → Option Fp)\n"
            output += "    (dependency_sqrt_or_twice : Fp → Option (Bool × Fp))\n"
            output += "    (dependency_finish : Fp → Fp → Fp → Fp → List Fp)\n"
            output += f"    ({parameters} : Fp) : {result} :=\n"
            output += (
                indent(
                    Translator(constants, abstract_calls=True).block(
                        child(function, "body")
                    )
                )
                + "\n\n"
            )
            output += f"def cairoFlow_{name} ({parameters} : Fp) : {result} :=\n"
            output += f"  cairoBody_{name} cairoFlow_is_small_order_edwards\n"
            output += "    cairoFlow_sqrt cairoFlow_sqrt_or_twice cairo_finish x y\n\n"
        else:
            output += f"def cairoFlow_{name} ({parameters} : Fp) : {result} :=\n"
            output += indent(translator.block(child(function, "body"))) + "\n\n"
    output += "end\nend DivideAndPair\n"
    return output


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    tree, metadata = export(SOURCE)
    artifact = DIRECTORY / "DivideAndPair" / "CairoFlow.lean"
    content = render(tree, metadata)
    if args.check:
        if not artifact.exists() or artifact.read_text() != content:
            raise SystemExit(
                "Stale Cairo control-flow model: run tools/divide_and_pair/formal/control_flow.py"
            )
    else:
        artifact.write_text(content)


if __name__ == "__main__":
    main()
