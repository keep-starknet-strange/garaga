"""Translate the production Python AST to field-level Lean control flow.

The integer-to-field interpretation removes only reductions modulo P.
Assertions become an explicit failure option. Their impossibility is proved
separately, so no Python assertion is assumed by the correctness theorem.
"""

import ast
import hashlib
from pathlib import Path

from garaga import ed25519 as ed

ROOT = Path(__file__).resolve().parents[3]
SOURCE = ROOT / "hydra/garaga/ed25519.py"
FUNCTIONS = {
    "sqrt": ("value", "Option Fp", "root"),
    "sqrt_or_twice": ("value", "Option (Bool × Fp)", "pair"),
    "is_on_curve": ("x y", "Bool", "bool"),
    "is_small_order": ("x y", "Bool", "bool"),
    "is_in_prime_order_subgroup": ("x y", "Bool", "bool"),
}
CONSTANTS = {
    name: getattr(ed, name)
    for name in ("D", "I", "A", "A_PRIME", "B_PRIME", "SQRT_2_B_PRIME", "SQRT_TWO_I")
}
GLOBALS = {
    "CURVE",
    "P",
    "D",
    "I",
    "A",
    "B",
    "A_PRIME",
    "B_PRIME",
    "SQRT_2_B_PRIME",
    "SQRT_TWO_I",
}


def indent(source):
    return "\n".join("  " + line for line in source.splitlines())


def natural(node):
    if isinstance(node, ast.Constant) and type(node.value) is int:
        return node.value
    if isinstance(node, ast.Name) and node.id == "P":
        return ed.P
    if isinstance(node, ast.UnaryOp) and isinstance(node.op, ast.USub):
        return -natural(node.operand)
    if isinstance(node, ast.BinOp):
        left, right = natural(node.left), natural(node.right)
        if isinstance(node.op, ast.Add):
            return left + right
        if isinstance(node.op, ast.Sub):
            return left - right
        if isinstance(node.op, ast.Mult):
            return left * right
        if isinstance(node.op, ast.FloorDiv):
            return left // right
    raise ValueError(f"Unsupported integer expression {ast.dump(node)}")


def pattern(node):
    if isinstance(node, ast.Name):
        if node.id in FUNCTIONS or node.id in GLOBALS or node.id == "pow":
            raise ValueError("A local binding shadows a modeled function or constant")
        return node.id
    if isinstance(node, ast.Tuple):
        return "(" + ", ".join(pattern(item) for item in node.elts) + ")"
    raise ValueError("Only local variable assignments are supported")


class Translator:
    def __init__(self, result, abstract_calls=False):
        self.result = result
        self.abstract_calls = abstract_calls

    def expression(self, node):
        if isinstance(node, ast.Name):
            return f"pythonConstant_{node.id}" if node.id in CONSTANTS else node.id
        if isinstance(node, ast.Constant):
            if type(node.value) is bool:
                return "true" if node.value else "false"
            if type(node.value) is int:
                return str(node.value)
            if node.value is None:
                return "none"
        if isinstance(node, ast.Tuple):
            return "(" + ", ".join(self.expression(item) for item in node.elts) + ")"
        if isinstance(node, ast.BinOp):
            left = self.expression(node.left)
            if (
                isinstance(node.op, ast.Mod)
                and isinstance(node.right, ast.Name)
                and node.right.id == "P"
            ):
                return left
            if isinstance(node.op, ast.Pow):
                exponent = natural(node.right)
                if exponent < 0:
                    raise ValueError("Negative powers require an explicit inverse")
                return f"({left}^{exponent})"
            operators = {ast.Add: "+", ast.Sub: "-", ast.Mult: "*"}
            operator = operators.get(type(node.op))
            if operator:
                return f"({left}{operator}{self.expression(node.right)})"
        if isinstance(node, ast.UnaryOp):
            if isinstance(node.op, ast.USub):
                return f"(-{self.expression(node.operand)})"
            if isinstance(node.op, ast.Not):
                return f"(!{self.expression(node.operand)})"
        if isinstance(node, ast.BoolOp):
            operator = " && " if isinstance(node.op, ast.And) else " || "
            return (
                "(" + operator.join(self.expression(item) for item in node.values) + ")"
            )
        if (
            isinstance(node, ast.Compare)
            and len(node.ops) == len(node.comparators) == 1
        ):
            operators = {ast.Eq: "=", ast.NotEq: "≠"}
            operator = operators.get(type(node.ops[0]))
            if operator:
                return f"decide ({self.expression(node.left)} {operator} {self.expression(node.comparators[0])})"
        if (
            isinstance(node, ast.Call)
            and isinstance(node.func, ast.Name)
            and not node.keywords
        ):
            name = node.func.id
            if (
                name == "pow"
                and len(node.args) == 3
                and isinstance(node.args[2], ast.Name)
                and node.args[2].id == "P"
            ):
                base, exponent = self.expression(node.args[0]), natural(node.args[1])
                if self.abstract_calls and exponent == (ed.P - 1) // 4:
                    return f"dependency_quartic ({base})"
                return f"({base})⁻¹" if exponent == -1 else f"({base})^{exponent}"
            if name in FUNCTIONS:
                prefix = "dependency" if self.abstract_calls else "pythonFlow"
                return f"{prefix}_{name} " + " ".join(
                    f"({self.expression(argument)})" for argument in node.args
                )
        raise ValueError(f"Unsupported Python field expression {ast.dump(node)}")

    def returned(self, node):
        if isinstance(node, ast.IfExp):
            return f"if {self.expression(node.test)} then\n{indent(self.returned(node.body))}\nelse\n{indent(self.returned(node.orelse))}"
        value = self.expression(node)
        if self.result in ("root", "pair") and value != "none":
            return f"some ({value})"
        return value

    def statements(self, statements, continuation=None):
        if not statements:
            if continuation is None:
                raise ValueError("Python path returns no value")
            return continuation()
        statement, *rest = statements
        if (
            isinstance(statement, ast.Expr)
            and isinstance(statement.value, ast.Constant)
            and isinstance(statement.value.value, str)
        ):
            return self.statements(rest, continuation)
        if isinstance(statement, ast.Return):
            return self.returned(statement.value)
        if isinstance(statement, ast.AugAssign):
            if (
                not isinstance(statement.op, ast.Mod)
                or not isinstance(statement.value, ast.Name)
                or statement.value.id != "P"
            ):
                raise ValueError(
                    "Only field normalization supports augmented assignment"
                )
            pattern(statement.target)
            return self.statements(rest, continuation)
        if isinstance(statement, ast.Assign) and len(statement.targets) == 1:
            binding = pattern(statement.targets[0])
            value = self.expression(statement.value)
            tail = self.statements(rest, continuation)
            if (
                isinstance(statement.value, ast.Call)
                and isinstance(statement.value.func, ast.Name)
                and statement.value.func.id == "sqrt_or_twice"
            ):
                if self.result != "bool":
                    raise ValueError(
                        "The assertion failure path requires a Boolean caller"
                    )
                return f"match {value} with\n| some {binding} =>\n{indent(tail)}\n| none => false"
            return f"let {binding} := {value}\n{tail}"
        if (
            isinstance(statement, ast.Assert)
            and statement.msg is None
            and self.result == "pair"
        ):
            return f"if {self.expression(statement.test)} then\n{indent(self.statements(rest, continuation))}\nelse\n  none"
        if isinstance(statement, ast.If):
            tail = lambda: self.statements(rest, continuation)
            yes = self.statements(statement.body, tail)
            no = self.statements(statement.orelse, tail)
            test = statement.test
            if (
                isinstance(test, ast.Compare)
                and len(test.ops) == 1
                and isinstance(test.ops[0], ast.Is)
                and isinstance(test.left, ast.Name)
                and isinstance(test.comparators[0], ast.Constant)
                and test.comparators[0].value is None
            ):
                variable = test.left.id
                return f"match {variable} with\n| none =>\n{indent(yes)}\n| some {variable} =>\n{indent(no)}"
            return f"if {self.expression(test)} then\n{indent(yes)}\nelse\n{indent(no)}"
        raise ValueError(f"Unsupported Python field statement {ast.dump(statement)}")


def render():
    source_bytes = SOURCE.read_bytes()
    module = ast.parse(source_bytes, filename=str(SOURCE))
    functions, globals_seen = {}, set()
    for node in module.body:
        if isinstance(node, ast.FunctionDef):
            if node.name in functions:
                raise ValueError("Duplicate Python function")
            functions[node.name] = node
        elif isinstance(node, ast.ImportFrom):
            if (
                node.module != "garaga.curves"
                or node.level != 0
                or {(item.name, item.asname) for item in node.names}
                != {("CURVES", None), ("CurveID", None)}
            ):
                raise ValueError("The Python primitive import bindings changed")
        elif (
            isinstance(node, ast.Assign)
            and len(node.targets) == 1
            and isinstance(node.targets[0], ast.Name)
        ):
            name = node.targets[0].id
            if name not in GLOBALS or name in globals_seen:
                raise ValueError("Unexpected or duplicate Python global binding")
            globals_seen.add(name)
        elif isinstance(node, ast.Assert):
            test = node.test
            if (
                node.msg is not None
                or not isinstance(test, ast.Compare)
                or not isinstance(test.left, ast.Name)
                or test.left.id not in {"SQRT_2_B_PRIME", "SQRT_TWO_I"}
                or len(test.ops) != 1
                or not isinstance(test.ops[0], ast.IsNot)
                or not isinstance(test.comparators[0], ast.Constant)
                or test.comparators[0].value is not None
            ):
                raise ValueError("Unexpected Python module assertion")
        elif not (
            isinstance(node, ast.Expr)
            and isinstance(node.value, ast.Constant)
            and isinstance(node.value.value, str)
        ):
            raise ValueError("Unsupported Python module statement")
    if set(functions) != set(FUNCTIONS):
        raise ValueError("The Python API requires a model update")
    if globals_seen != GLOBALS:
        raise ValueError("The Python constants require a model update")
    output = "module\n\npublic import DivideAndPair.Generated\n\n"
    output += "-- Generated from the production Python AST. Do not edit.\n"
    output += "-- source_sha256: " + hashlib.sha256(source_bytes).hexdigest() + "\n"
    output += (
        "-- extractor_sha256: "
        + hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
        + "\n"
    )
    output += (
        "@[expose] public section\nnamespace DivideAndPair\nnoncomputable section\n\n"
    )
    for name, value in CONSTANTS.items():
        output += f"abbrev pythonConstant_{name} : Fp := {value}\n\n"
    for name, (parameters, result, return_kind) in FUNCTIONS.items():
        function = functions[name]
        args = function.args
        if (
            function.decorator_list
            or args.posonlyargs
            or args.vararg
            or args.kwarg
            or args.kwonlyargs
            or args.defaults
        ):
            raise ValueError("The Python calling convention requires a model update")
        if [argument.arg for argument in args.args] != parameters.split():
            raise ValueError("The Python parameters require a model update")
        if name == "is_in_prime_order_subgroup":
            output += f"def pythonBody_{name}\n"
            output += "    (dependency_sqrt : Fp → Option Fp)\n"
            output += "    (dependency_sqrt_or_twice : Fp → Option (Bool × Fp))\n"
            output += "    (dependency_quartic : Fp → Fp)\n"
            output += "    (dependency_is_on_curve dependency_is_small_order : Fp → Fp → Bool)\n"
            output += f"    ({parameters} : Fp) : {result} :=\n"
            output += (
                indent(
                    Translator(return_kind, abstract_calls=True).statements(
                        function.body
                    )
                )
                + "\n\n"
            )
            output += f"def pythonFlow_{name} ({parameters} : Fp) : {result} :=\n"
            output += f"  pythonBody_{name} pythonFlow_sqrt pythonFlow_sqrt_or_twice\n"
            output += f"    (fun f => f^{(ed.P - 1) // 4}) pythonFlow_is_on_curve pythonFlow_is_small_order x y\n\n"
        else:
            output += f"def pythonFlow_{name} ({parameters} : Fp) : {result} :=\n"
            output += indent(Translator(return_kind).statements(function.body)) + "\n\n"
    return output + "end\nend DivideAndPair\n"
