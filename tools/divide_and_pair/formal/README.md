# Ed25519 Divide-and-Pair correctness

The package proves the subgroup decision over the concrete Ed25519 field.
Its final theorems use models extracted from the production Python and Cairo sources.

```text
Python AST ───────────────→ PythonFlow.lean ──────┐
Cairo compiler AST ───────→ CairoFlow.lean ───────┤
Production circuit IR ───→ Generated.lean ───────┤
                                                ↓
                           SourceCorrectness.lean
                           accept ↔ [ell]P = O
```

## Checked statements

For every point on the Edwards curve, `cairo_source_subgroup_correct` and
`python_source_subgroup_correct` prove:

$$
\operatorname{accept}(x,y)\iff[\ell]\operatorname{nativePoint}(x,y)=\mathcal O.
$$

`nativePoint` maps the Edwards chart into Mathlib's actual Weierstrass point group.
It also handles the identity and the order-two point explicitly.
The theorems include all torsion cosets, both square-root branches, and every root choice.
They have no backend-compatibility or Tate-pairing premise.

`cairo_short_chart_correct` connects the actual Weierstrass conversion circuit to this decision.
It covers every finite source-curve point with nonzero $Y$ and proves the transformed coordinates $(4X-A/3,8Y)$.
The conversion lemmas prove that both denominators are nonzero on this domain.
The source AST also supplies the Cairo field, order, and curve coefficients.
Lean checks these against the Python parameters and the mathematical curve.

`cairo_python_subgroup_agree` proves that both extracted tests return the same Boolean on every Edwards point.
`python_source_rejects_off_curve` covers Python's curve guard.
`python_sqrt_pair_assertion_cannot_fail` proves that the source assertion always succeeds over the field.

The signature verifier retains its separate small-order policy.
`cairo_source_small_order_correct` proves that its extracted polynomial guard equals three complete Edwards doublings:

$$
xy(x^2+y^2)=0\iff[8]P=\mathcal O.
$$

## Proof structure

The field and subgroup primes have recursive Lucas certificates in `field-primality.json`.
Lean checks every factorization and modular exponentiation through kernel reduction.
No primality oracle supplies a theorem.

Two concrete points have independently checked orders $\ell$ and $8$.
Their sum has order $8\ell$.
`CardBound.lean` proves $\#E\le2p+1$, including infinity.
Lagrange's theorem and $2p+1<2(8\ell)$ then give:

$$
\#E(\mathbb F_p)=8\ell.
$$

The checked halving formulas and the quartic duplication identity give:

$$
[\ell]P=\mathcal O
\iff P\in8E(\mathbb F_p)
\iff H\in4E(\mathbb F_p)
\iff f_4(H)^{(p-1)/4}=1,
\qquad [2]H=P.
$$

The middle equivalence holds for every rational half of the admitted point.
`Subgroup.lean` proves this from cyclicity and the checked group order.
`ChartHalves.lean` relates rational halving to Mathlib's group addition in both directions.
`ScaledAlgorithm.lean` proves correctness of the exact rescaling in the nonresidue branch.
`EdwardsMap.lean` proves the chart conditions and classifies all eight exceptional torsion points.

The exponentiation proofs follow each multiplication in the production circuit IR.
They check the square-root exponent and the final quartic exponent.
`SourceCorrectness.lean` composes these results with both extracted control-flow models.

The generic intermediate lemmas take arithmetic functions as parameters.
The final theorems instantiate every parameter with a checked concrete implementation.
This prevents expensive interpreter reductions during proof checking.
It introduces no unproved premise in the final statements.

## Source connection and boundaries

`python_flow.py` parses the production module with Python's `ast` frontend.
`control_flow.py` uses the pinned Scarb 2.21.0 language server's `cairo/viewSyntaxTree` request.
The Cairo frontend checks every token against the source bytes.
It rejects missing tokens, skipped syntax, source races, and unexpected import bindings.
The translators reject unsupported syntax and primitive shadowing.

The models interpret canonical field values as `ZMod p`.
Integer reduction modulo $p$, field primitives, and the circuit builtin retain their usual mathematical meanings.
Cairo's internal Edwards helper requires an on-curve input, as its source comment states.
The public wrapper checks canonical coordinates and the curve equation before this call.
The Python model includes its curve guard and represents assertion failure explicitly.

The trusted translation boundary includes the two AST frontends, the small extractors, and the circuit IR compiler.
Scarb compilation, CASM execution, and the VM implementation of circuit builtins are outside this mathematical proof.
Tests cover these execution boundaries and the public coordinate wrappers.

`Audit.lean` checks the transitive dependencies of every public theorem.
It permits only `propext`, `Classical.choice`, and `Quot.sound`.
It rejects placeholders and compiler-trust axioms, including `sorryAx` and `Lean.ofReduceBool`.
`decide +kernel` is permitted because the kernel checks its reduction.

## Run the checks

Use Lean 4.35.0 and the Mathlib commit in `lakefile.toml`.
Use the checksum-pinned Linux x86_64 Scarb 2.21.0 binaries for Cairo source extraction.

```bash
python tools/divide_and_pair/formal/control_flow.py --check
PYTHONPATH=hydra python tools/divide_and_pair/formal/generate.py --check
tools/divide_and_pair/formal/check.sh
```

`make rewrite` regenerates the circuit, vector, and source-model artifacts.
The Python configuration test rejects stale generated models.
The dedicated Lean workflow also extracts the current Cairo AST and runs the kernel checks and dependency audit.
Ordinary tests reuse the stored deterministic vectors.

The [measurement report](../../../docs/benchmarks/divide-and-pair/README.md) records the baseline, source hashes, VM steps, and Sierra gas.
