"""Extract Ed25519 arithmetic models from the production Cairo circuit IR."""

import argparse
import hashlib
import json
import re
from pathlib import Path

from garaga.ed25519 import CURVE, I, P
from garaga.modulo_circuit import ModBuiltinOps, WriteOps
from garaga.precompiled_circuits.compilable_circuits.ed25519 import Ed25519Circuit

if __package__:
    from .python_flow import render as python_control_flow
else:
    from python_flow import render as python_control_flow

ROOT = Path(__file__).resolve().parents[3]
DIRECTORY = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def render():
    paths = [
        "hydra/garaga/ed25519.py",
        "hydra/garaga/curves.py",
        "hydra/garaga/precompiled_circuits/compilable_circuits/ed25519.py",
        "hydra/garaga/modulo_circuit.py",
        "src/src/circuits/ed25519.cairo",
        "src/src/ec/ed25519.cairo",
        "src/src/definitions/curves.cairo",
        "src/src/ec/ec_ops.cairo",
        "src/src/signatures/eddsa_25519.cairo",
        "tools/divide_and_pair/formal/generate.py",
        "tools/divide_and_pair/formal/control_flow.py",
        "tools/divide_and_pair/formal/cairo_ast.py",
        "tools/divide_and_pair/formal/python_flow.py",
        "tools/divide_and_pair/formal/DivideAndPair/CairoFlow.lean",
    ]
    source = "module\n\npublic import Mathlib.Algebra.Field.ZMod\npublic import DivideAndPair.FieldPrimality\n\n"
    source += "-- Generated from production circuit IR. Do not edit.\n"
    for path in paths:
        source += f"-- sha256 {path}: {sha(ROOT/path)}\n"
    source += "\n@[expose] public section\n\nnamespace DivideAndPair\n"
    source += f"abbrev Fp := ZMod {P}\n\nnoncomputable section\n"
    source += f"abbrev subgroupOrder : Nat := {CURVE.n}\n\n"
    source += f"abbrev pythonCurveA : Fp := {CURVE.a}\n"
    source += f"abbrev pythonCurveB : Fp := {CURVE.b}\n\n"
    for operation in Ed25519Circuit.INPUTS:
        circuit = Ed25519Circuit(operation=operation).circuit
        if circuit.field.p != P:
            raise ValueError("Unexpected circuit field")
        names = {}
        inputs = [
            (offset, item)
            for offset, item in circuit.values_segment.segment.items()
            if item.write_source == WriteOps.INPUT
        ]
        expected = Ed25519Circuit.INPUTS[operation]
        if len(inputs) != len(expected):
            raise ValueError(f"Unexpected inputs for {operation}")
        for (offset, _), name in zip(inputs, expected, strict=True):
            names[offset] = name
        signature = " ".join(expected)
        source += f"def cairo_{operation} ({signature} : Fp) : List Fp :=\n"
        prefix = []
        if operation == "finish":
            output = circuit.values_segment.segment[
                circuit.output[0].offset
            ].instruction
            miller_offset = output.right_offset
        for offset, item in circuit.values_segment.segment.items():
            if item.write_source == WriteOps.INPUT:
                continue
            name = f"v{offset}"
            if item.write_source == WriteOps.CONSTANT:
                expression = str(item.value)
            elif item.write_source == WriteOps.BUILTIN:
                instruction = item.instruction
                if instruction.operation == ModBuiltinOps.ADD:
                    if instruction.result_offset == offset:
                        expression = f"{names[instruction.left_offset]} + {names[instruction.right_offset]}"
                    elif instruction.right_offset == offset:
                        expression = f"{names[instruction.result_offset]} - {names[instruction.left_offset]}"
                    else:
                        raise ValueError("Unsupported add-mod constraint")
                elif instruction.operation == ModBuiltinOps.MUL:
                    if (
                        instruction.right_offset is None
                        and instruction.result_offset is None
                    ):
                        expression = f"({names[instruction.left_offset]})⁻¹"
                    elif instruction.result_offset == offset:
                        expression = f"{names[instruction.left_offset]} * {names[instruction.right_offset]}"
                    else:
                        raise ValueError("Unsupported mul-mod constraint")
                else:
                    raise ValueError("Unknown circuit instruction")
            else:
                raise ValueError(f"Unsupported circuit value: {item.write_source}")
            source += f"  let {name} : Fp := {expression}\n"
            if operation == "finish" and offset <= miller_offset:
                prefix.append(f"  let {name} : Fp := {expression}\n")
            names[offset] = name
        source += "  [" + ", ".join(names[v.offset] for v in circuit.output) + "]\n\n"
        if operation == "finish":
            source += f"def cairo_miller_input ({signature} : Fp) : Fp :=\n"
            source += "".join(prefix) + f"  v{miller_offset}\n\n"
    source += "end\nend DivideAndPair\n"
    return source


def exponent_invariants(circuit, base, base_name, maximum=None):
    nodes = {base: (base_name, 1)}
    source = ""
    for offset, item in circuit.values_segment.segment.items():
        if offset <= base or (maximum is not None and offset > maximum):
            continue
        instruction = item.instruction
        if instruction.operation != ModBuiltinOps.MUL:
            continue
        if (
            instruction.left_offset not in nodes
            or instruction.right_offset not in nodes
        ):
            raise ValueError("Non-power operation in the sqrt exponentiation")
        left, le = nodes[instruction.left_offset]
        right, re = nodes[instruction.right_offset]
        exponent = le + re
        name = f"v{offset}"
        proofs = list(
            dict.fromkeys(
                f"h{index}"
                for index in [instruction.left_offset, instruction.right_offset]
                if index != base
            )
        )
        source += f"  have h{offset} : {name} = {base_name}^{exponent} := by\n"
        source += f"    change {left}*{right} = _\n"
        if proofs:
            source += "    rw [" + ", ".join(proofs) + "]\n"
        source += "    ring\n"
        nodes[offset] = (name, exponent)
    return source


def extract_lets(circuit):
    return (
        "  extract_lets "
        + " ".join(
            f"v{offset}"
            for offset, item in circuit.values_segment.segment.items()
            if item.write_source != WriteOps.INPUT
        )
        + "\n"
    )


def sqrt_power_proof(operation):
    circuit = Ed25519Circuit(operation=operation).circuit
    name = f"cairo_{operation}"
    target = ["value^(2^252-2)", "value^(2^253-4)-value", "value^(2^253-4)+value"]
    root = circuit.output[0].offset
    subtraction = circuit.values_segment.segment[circuit.output[1].offset].instruction
    square = subtraction.result_offset
    actual = [f"v{root}", f"v{square}-value", f"v{square}+value"]
    if operation == "sqrt_or_twice":
        for sign in ["-", "+"]:
            target.append(f"value^(2^253-4){sign}({I}:Fp)*value")
            actual.append(f"v{square}{sign}({I}:Fp)*value")
    source = f"theorem {name}_eq (value : Fp) :\n"
    source += f"    {name} value = [" + ", ".join(target) + "] := by\n"
    source += f"  unfold {name}\n" + extract_lets(circuit)
    source += exponent_invariants(circuit, 0, "value", maximum=square)
    source += "  change [" + ", ".join(actual) + "] = _\n"
    source += f"  rw [h{root}, h{square}]\n  rfl\n\n"
    return source


def power_proofs():
    """Emit a kernel-checked exponent invariant at each multiplication gate."""
    source = """module

public import DivideAndPair.Generated
public import DivideAndPair.LowOrder

-- Generated per-gate certificates. Every exponent is checked by Lean.
@[expose] public section
namespace DivideAndPair
set_option maxRecDepth 8192
set_option maxHeartbeats 1000000
"""
    source += sqrt_power_proof("sqrt")
    source += sqrt_power_proof("sqrt_or_twice")
    circuit = Ed25519Circuit(operation="finish").circuit
    output = circuit.output[0].offset
    base = circuit.values_segment.segment[output].instruction.right_offset
    source += """theorem cairo_finish_power (e wp w sign : Fp) :
    cairo_finish e wp w sign = [(cairo_miller_input e wp w sign)^(2^253-5)] := by
  unfold cairo_finish
"""
    source += extract_lets(circuit)
    source += f"  have miller_input : v{base} = cairo_miller_input e wp w sign := rfl\n"
    source += f"  clear_value v{base}\n"
    source += exponent_invariants(circuit, base, f"v{base}")
    source += f"  change [v{output}] = _\n  rw [h{output}, miller_input]\n  rfl\n\nend DivideAndPair\n"
    return source


def primality_proofs():
    """Lucas certificates use modular powers reduced by the Lean kernel."""
    certificates = json.loads((DIRECTORY / "field-primality.json").read_text())
    if str(P) not in certificates or str(CURVE.n) not in certificates:
        raise ValueError("Missing field primality certificate")
    primes = set(map(int, certificates))
    for record in certificates.values():
        primes.update(map(int, record["factors"]))
    source = """module

public import Mathlib.NumberTheory.LucasPrimality

-- Generated Lucas certificates. No native_decide or primality oracle is trusted.
@[expose] public section
namespace DivideAndPair
set_option maxRecDepth 8192
set_option maxHeartbeats 1000000

"""
    for prime in sorted(primes):
        name = f"prime_{prime}"
        if prime < 100:
            source += f"theorem {name} : Nat.Prime {prime} := by decide\n\n"
            continue
        record = certificates[str(prime)]
        factors = [
            int(q) for q, power in record["factors"].items() for _ in range(power)
        ]
        product = " * ".join(map(str, factors))
        cases = " ∨ ".join(f"q = {factor}" for factor in factors)
        source += f"theorem {name} : Nat.Prime {prime} := by\n"
        source += f"  apply lucas_primality {prime} ({record['generator']} : ZMod {prime}) (by decide)\n"
        source += "  intro q hq hdiv\n"
        source += f"  have factorization : {prime}-1 = {product} := by decide\n"
        source += "  rw [factorization] at hdiv\n"
        source += f"  have cases : {cases} := by\n"
        simp = (
            ["hq.dvd_mul"]
            + [
                f"Nat.prime_dvd_prime_iff_eq hq prime_{factor}"
                for factor in dict.fromkeys(factors)
            ]
            + ["or_assoc"]
        )
        source += "    simpa only [" + ", ".join(simp) + "] using hdiv\n"
        source += (
            "  rcases cases with "
            + " | ".join("rfl" for _ in factors)
            + " <;> decide\n\n"
        )
    source += f"instance field_prime : Fact (Nat.Prime {P}) := ⟨prime_{P}⟩\n\n"
    source += (
        f"instance subgroup_prime : Fact (Nat.Prime {CURVE.n}) := ⟨prime_{CURVE.n}⟩\n\n"
    )
    source += "end DivideAndPair\n"
    return source


def audit_proofs(generated):
    # Imported constants can be lazy in Lean. Enumerate the actual theorem names
    # instead of relying on the environment's currently materialized entries.
    files = {
        path.name: path.read_text()
        for path in (DIRECTORY / "DivideAndPair").glob("*.lean")
    }
    files.update(generated)
    names = sorted(
        {
            name
            for content in files.values()
            for name in re.findall(r"^theorem ([A-Za-z0-9_]+)", content, re.MULTILINE)
        }
    )
    source = """module

import DivideAndPair
import Lean.Util.CollectAxioms

open Lean Elab Command

-- Generated from all public theorem declarations. Imported constants are lazy.
run_cmd do
  let allowed := [`propext, `Classical.choice, `Quot.sound]
  let names := #[
"""
    source += ",\n".join(f"    `DivideAndPair.{name}" for name in names)
    source += """
  ]
  for name in names do
    unless (← getEnv).contains name do
      throwError "Missing audited theorem {name}"
    for axiomName in (← Lean.collectAxioms name) do
      unless allowed.contains axiomName do
        throwError "Forbidden axiom {axiomName} in {name}"
  logInfo m!"Audited {names.size} theorem dependencies. No placeholder or compiler-trust axioms."
"""
    return source


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    generated = {
        "Generated.lean": render(),
        "PowerProofs.lean": power_proofs(),
        "FieldPrimality.lean": primality_proofs(),
        "PythonFlow.lean": python_control_flow(),
    }
    artifacts = {
        DIRECTORY / "DivideAndPair" / name: content
        for name, content in generated.items()
    }
    artifacts[DIRECTORY / "Audit.lean"] = audit_proofs(generated)
    for path, content in artifacts.items():
        if args.check:
            if not path.exists() or path.read_text() != content:
                raise SystemExit(
                    "Stale Ed25519 formal model: run tools/divide_and_pair/formal/generate.py"
                )
        else:
            path.write_text(content)


if __name__ == "__main__":
    main()
