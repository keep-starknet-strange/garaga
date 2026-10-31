# Why the Cairo step count decreased

The largest measured reduction comes from the Cairo compiler's inlining threshold: `2` → `50`.
The field arithmetic stays the same. The compiler removes much of the surrounding function-call and data-transfer overhead.

## Before and after

Let $S$ denote the complete Foundry test step count, including ECIP and the test harness.

$$
S_{\mathrm{before}}=1\,220\,719,
\qquad S_{\mathrm{after}}=648\,642.
$$

$$
\Delta S=572\,077,
\qquad
\frac{S_{\mathrm{before}}-S_{\mathrm{after}}}{S_{\mathrm{before}}}\times100
=46.86\%.
$$

The full comparison includes the protocol migration and the Cairo optimizations.
The old receipt uses Barretenberg v3. The new receipt uses v6 for the same Noir statement.
This comparison does not isolate a protocol-only gain.

The inlining comparison uses the same v6 receipt, key, public input, and arithmetic implementation:

$$
S_{\mathrm{inline}=2}=1\,068\,406,
\qquad S_{\mathrm{inline}=50}=648\,642.
$$

$$
\Delta S_{\mathrm{inline}}=419\,764
\quad\text{or}\quad
\frac{419\,764}{572\,077}\times100=73.38\%
\quad\text{of the total measured reduction}.
$$

Both runs use 41,372 add-mod builtin instances and 40,267 mul-mod builtin instances.
They also use 377,190 range-check96 instances, 73 Keccak instances, and 461 Poseidon instances.
Thus, the main inlining gain does not come from fewer field gates or hashes.
It comes from the Cairo VM instructions around these operations.
The normal range-check counts differ by seven instances between the retained experiment records.

## Contribution of each retained stage

These deltas follow the recorded implementation sequence. They are not independent optimization estimates.

- Baseline → first v6 implementation: 1,220,719 → 1,075,193 steps, a reduction of 145,526.
  This stage combines the protocol port, new receipt, encoding guards, and initial Cairo layout.
- Shared scalar multiplication: 1,075,193 → 1,082,246 steps, an **increase of 7,053**.
  Its purpose is bytecode reduction: 87,243 → 67,321 felts.
- Remove constant identity commitments from the MSM: 1,082,246 → 1,072,746 steps, a reduction of 9,500.
- Specialize inactive relations and compact circuit inputs: 1,072,746 → 1,072,534 steps, a reduction of 212.
  This stage also removes 550 bytecode felts.
- Compress BN254 hints: 1,072,534 → 1,068,406 steps, a reduction of 4,128.
- Increase the inlining threshold: 1,068,406 → 648,642 steps, a reduction of 419,764.

The step deltas account for the complete reduction:

$$
145\,526-7\,053+9\,500+212+4\,128+419\,764
=572\,077.
$$

The shared function saves bytecode, but increases steps. It is not a step-count optimization.
Small source-layout changes also affect gas and size between experiments with the same step count.
The final compiler comparison uses [after.json](after.json) and the frozen threshold-2 measurement described in the main report.

## Mathematical meaning of the code changes

For MSM inputs $C_i$ and scalars $s_i$, define $I=\{i\mid C_i=\mathcal O\}$.
Identity commitments contribute zero:

$$
\sum_i [s_i]C_i
=\sum_{i\notin I}[s_i]C_i,
\qquad [s]\mathcal O=\mathcal O.
$$

For a relation family whose selector evaluation is $q=0$, every term with that factor vanishes:

$$
R_j(\mathbf e)=qF_j(\mathbf e)=0.
$$

The generated contract checks the relevant claimed evaluations before it uses the specialized circuit.
The specialization does not infer zero from arbitrary runtime values.

A BN254 coordinate satisfies $0\le x<p<2^{254}$.
The hint encoding changes its representation, without changing its value:

$$
x=\sum_{j=0}^{3}x_j2^{96j}
=x_{\mathrm{lo}}+2^{128}x_{\mathrm{hi}}.
$$

A scalar multiplication hint contains two coordinates and four signed coefficients.
Its size changes from $2\cdot4+4=12$ felts to $2\cdot2+4=8$ felts.
The Barretenberg proof bytes stay the same during these optimization experiments.

Inlining changes the placement of function bodies, without changing the mathematical expressions.
Threshold 50 reduces both steps and bytecode compared with threshold 2.
Higher thresholds save more gas, but produce larger contracts.
For example, threshold 75 uses 133,101,006 gas and 67,594 bytecode felts, compared with 141,418,616 gas and 64,379 felts at 50.

## Scope of the equivalence claim

Solidity checks each sumcheck residual separately. Define the residual at round $i$ as

$$
e_i=g_i(0)+g_i(1)-t_i.
$$

The current Cairo circuit uses the challenge $\rho$ and checks

$$
B_{\mathbf e}(\rho)=\sum_{i=0}^{n-1}\rho^{i+1}e_i=0.
$$

The exponent starts at **one**, as in the source code.
Exact round checks imply the combined check. The converse needs a binding assumption for this challenge and residual vector.
For example, $e_0=-\rho$ and $e_1=1$ give a zero combined check with a nonzero residual.
This example concerns the algebraic implication. It is not a forged complete proof against the concrete transcript.

For a fixed nonzero residual vector, $B_{\mathbf e}$ is a nonzero polynomial of degree at most $n$.
It has at most $n$ roots over a field.
For an independent uniform challenge from a finite set $\mathcal S$:

$$
\Pr[B_{\mathbf e}(\rho)=0]\le\frac{n}{|\mathcal S|}.
$$

Cairo derives $\rho$ from Starknet Poseidon, so its source field is the Starknet field, not BN254 Fr.
The concrete Fiat–Shamir construction needs an additional cryptographic argument about independence, adaptive queries, and grinding.
The polynomial root bound alone does not prove that argument.

The Lean work distinguishes exact arithmetic identities from these explicit soundness assumptions.
It does not claim an unconditional equivalence of accepted calldata or a proof of CASM and EVM execution.

See the [Lean proof scope and remaining obligations](../../../tools/noir/formal/README.md) for the exact theorem coverage.
