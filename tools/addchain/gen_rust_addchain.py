#!/usr/bin/env python3
from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path
from typing import List, Tuple

ACC_DIR = Path(__file__).resolve().parent
OUTPUT_FILE = (
    ACC_DIR.parent
    / "garaga_rs"
    / "src"
    / "pairing"
    / "final_exp_witness"
    / "addchain_pow_generated.rs"
)

CHAINS: List[Tuple[str, str, str]] = [
    ("bn254_exp.acc", "bn254", "pow_exp"),
    ("bn254_exp0.acc", "bn254", "pow_exp0"),
    ("bn254_r_m_d_inv.acc", "bn254", "pow_r_m_d_inv"),
    ("bls12_381_h3_s.acc", "bls12_381", "pow_h3_s"),
    ("bls12_381_e.acc", "bls12_381", "pow_e"),
]


@dataclass(frozen=True)
class Var:
    name: str


@dataclass(frozen=True)
class Add:
    left: "Expr"
    right: "Expr"


@dataclass(frozen=True)
class Shift:
    value: "Expr"
    amount: int


Expr = Var | Add | Shift


@dataclass(frozen=True)
class Token:
    kind: str
    value: str | int


def tokenize(expr: str) -> List[Token]:
    tokens: List[Token] = []
    i = 0
    while i < len(expr):
        ch = expr[i]
        if ch.isspace():
            i += 1
            continue
        if expr.startswith("<<", i):
            tokens.append(Token("SYMBOL", "<<"))
            i += 2
            continue
        if ch.isdigit():
            j = i + 1
            while j < len(expr) and expr[j].isdigit():
                j += 1
            tokens.append(Token("NUMBER", int(expr[i:j])))
            i = j
            continue
        if ch.isalpha() or ch == "_":
            j = i + 1
            while j < len(expr) and (expr[j].isalnum() or expr[j] == "_"):
                j += 1
            tokens.append(Token("NAME", expr[i:j]))
            i = j
            continue
        if ch in "+*()":
            tokens.append(Token("SYMBOL", ch))
            i += 1
            continue
        raise ValueError(f"Unexpected character {ch!r} in {expr!r}")
    return tokens


class Parser:
    def __init__(self, tokens: List[Token]) -> None:
        self.tokens = tokens
        self.pos = 0

    def _peek(self) -> Token | None:
        if self.pos >= len(self.tokens):
            return None
        return self.tokens[self.pos]

    def _peek_next(self) -> Token | None:
        if self.pos + 1 >= len(self.tokens):
            return None
        return self.tokens[self.pos + 1]

    def _match(self, kind: str, value: str | None = None) -> bool:
        tok = self._peek()
        if tok is None or tok.kind != kind:
            return False
        if value is not None and tok.value != value:
            return False
        self.pos += 1
        return True

    def _expect(self, kind: str, value: str | None = None) -> Token:
        tok = self._peek()
        if (
            tok is None
            or tok.kind != kind
            or (value is not None and tok.value != value)
        ):
            raise ValueError(
                f"Expected {kind} {value or ''} at {self.pos}, got {tok!r}"
            )
        self.pos += 1
        return tok

    def parse(self) -> Expr:
        expr = self._parse_expr()
        if self._peek() is not None:
            raise ValueError(f"Unexpected trailing tokens at {self.pos}")
        return expr

    def _parse_expr(self) -> Expr:
        expr = self._parse_chain()
        while self._match("SYMBOL", "+"):
            rhs = self._parse_chain()
            expr = Add(expr, rhs)
        return expr

    def _parse_chain(self) -> Expr:
        expr = self._parse_term()
        while self._match("SYMBOL", "<<"):
            amount = self._expect("NUMBER").value
            if not isinstance(amount, int):
                raise ValueError("Shift amount must be integer")
            expr = Shift(expr, amount)
            if self._match("SYMBOL", "+"):
                rhs = self._parse_term()
                expr = Add(expr, rhs)
        return expr

    def _parse_term(self) -> Expr:
        tok = self._peek()
        if tok and tok.kind == "NUMBER" and tok.value == 2:
            if self._peek_next() and self._peek_next().kind == "SYMBOL":
                if self._peek_next().value == "*":
                    self._expect("NUMBER", None)
                    self._expect("SYMBOL", "*")
                    atom = self._parse_atom()
                    return Shift(atom, 1)
        return self._parse_atom()

    def _parse_atom(self) -> Expr:
        if self._match("SYMBOL", "("):
            expr = self._parse_expr()
            self._expect("SYMBOL", ")")
            return expr
        tok = self._peek()
        if tok is None:
            raise ValueError("Unexpected end of expression")
        if tok.kind == "NAME":
            self.pos += 1
            return Var(str(tok.value))
        if tok.kind == "NUMBER":
            self.pos += 1
            if tok.value != 1:
                raise ValueError(f"Unsupported literal {tok.value}")
            return Var("1")
        raise ValueError(f"Unexpected token {tok!r}")


def parse_expr(expr: str) -> Expr:
    tokens = tokenize(expr)
    return Parser(tokens).parse()


def load_chain(path: Path) -> Tuple[List[Tuple[str, Expr]], Expr]:
    defs: List[Tuple[str, Expr]] = []
    return_expr: Expr | None = None
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line:
            continue
        if line.startswith("return"):
            expr = line[len("return") :].strip()
            return_expr = parse_expr(expr)
            continue
        name, expr = line.split("=", 1)
        defs.append((name.strip(), parse_expr(expr.strip())))
    if return_expr is None:
        raise ValueError(f"{path} missing return expression")
    return defs, return_expr


class Emitter:
    def __init__(self) -> None:
        self.temp_counter = 0

    def _temp(self) -> str:
        name = f"t{self.temp_counter}"
        self.temp_counter += 1
        return name

    def emit_expr(self, expr: Expr, lines: List[str]) -> str:
        if isinstance(expr, Var):
            if expr.name == "1":
                return "base"
            return expr.name
        if isinstance(expr, Add):
            left = self.emit_expr(expr.left, lines)
            right = self.emit_expr(expr.right, lines)
            temp = self._temp()
            lines.append(f"let {temp} = &{left} * &{right};")
            return temp
        if isinstance(expr, Shift):
            value = self.emit_expr(expr.value, lines)
            temp = self._temp()
            lines.append(f"let {temp} = square_n(&{value}, {expr.amount});")
            return temp
        raise TypeError(f"Unknown expr type {expr}")

    def emit_assignment(self, name: str, expr: Expr, indent: str) -> str:
        self.temp_counter = 0
        lines: List[str] = []
        result = self.emit_expr(expr, lines)
        if not lines:
            return f"{indent}let {name} = {result}.clone();"
        lines.append(result)
        inner = "\n".join(f"{indent}    {line}" for line in lines)
        return f"{indent}let {name} = {{\n{inner}\n{indent}}};"


def emit_chain_function(name: str, defs: List[Tuple[str, Expr]], ret: Expr) -> str:
    emitter = Emitter()
    indent = "        "
    body_lines: List[str] = [f"{indent}let base = base.clone();"]
    for var, expr in defs:
        body_lines.append(emitter.emit_assignment(var, expr, indent))
    body_lines.append(emitter.emit_assignment("result", ret, indent))
    body_lines.append(f"{indent}result")
    return "\n".join(body_lines)


def main() -> int:
    header_lines = [
        "// AUTO-GENERATED: DO NOT EDIT BY HAND.",
        "// Generated by tools/addchain/gen_rust_addchain.py from:",
    ]
    for acc_name, _, _ in CHAINS:
        header_lines.append(f"//   - tools/addchain/{acc_name}")
    header = "\n".join(header_lines)

    blocks: List[str] = [
        header,
        "",
        "use lambdaworks_math::field::element::FieldElement;",
        "use lambdaworks_math::field::traits::IsField;",
        "",
        "fn square_n<F: IsField>(x: &FieldElement<F>, n: usize) -> FieldElement<F> {",
        "    let mut t = x.clone();",
        "    for _ in 0..n {",
        "        t = t.square();",
        "    }",
        "    t",
        "}",
        "",
        "pub mod bn254 {",
        "    use super::square_n;",
        "    use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::Degree12ExtensionField;",
        "    use lambdaworks_math::field::element::FieldElement;",
        "",
    ]

    for acc_name, module, func_name in CHAINS:
        acc_path = ACC_DIR / acc_name
        defs, ret = load_chain(acc_path)
        if module != "bn254":
            continue
        blocks.append(f"    /// Generated from tools/addchain/{acc_name}")
        blocks.append(
            f"    pub fn {func_name}(base: &FieldElement<Degree12ExtensionField>) -> FieldElement<Degree12ExtensionField> {{"
        )
        blocks.append(emit_chain_function(func_name, defs, ret))
        blocks.append("    }")
        blocks.append("")

    blocks.append("}")
    blocks.append("")
    blocks.append("pub mod bls12_381 {")
    blocks.append("    use super::square_n;")
    blocks.append(
        "    use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField;"
    )
    blocks.append("    use lambdaworks_math::field::element::FieldElement;")
    blocks.append("")

    for acc_name, module, func_name in CHAINS:
        acc_path = ACC_DIR / acc_name
        defs, ret = load_chain(acc_path)
        if module != "bls12_381":
            continue
        blocks.append(f"    /// Generated from tools/addchain/{acc_name}")
        blocks.append(
            f"    pub fn {func_name}(base: &FieldElement<Degree12ExtensionField>) -> FieldElement<Degree12ExtensionField> {{"
        )
        blocks.append(emit_chain_function(func_name, defs, ret))
        blocks.append("    }")
        blocks.append("")

    blocks.append("}")
    blocks.append("")

    OUTPUT_FILE.write_text("\n".join(blocks), encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
