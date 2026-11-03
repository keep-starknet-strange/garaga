# Ed25519 Divide-and-Pair measurements

The baseline is `9b327b4ab3e1e2535df689765adb88b99762f739`.
The [results file](results.json) records source hashes and the exact tool versions.
All measurements use Scarb 2.21.0 and Starknet Foundry 0.64.1.

## What changed

Garaga supports one group that matches the paper's small-cofactor instantiations: Ed25519, with order $8\ell$.
BN254, BLS12-381, and their companion Edwards curves are different groups.
The [applicability note](../../notes/divide-and-pair.md) records this distinction and the primary sources.

The Python subgroup API previously computed $[\ell]P$.
The corresponding Cairo API was unimplemented.
Both APIs now use one rational halving followed by a quartic test.
The Cairo comparison uses an independent full-integer multiplication oracle on identical points.
It does not describe an existing Cairo implementation that already ran on main.

Let $p=2^{255}-19$, $a=-1$, $d=-121665/121666$, and $i^2=-1$.
The algorithm first maps an Edwards point into scaled Montgomery coordinates:

$$
e=x(1-y),\qquad u=(a-d)(1+y)xe,\qquad w=2(1-y).
$$

After one halving, the remaining condition is

$$
f=u(w+2ie)^2\ne0,\qquad f^{(p-1)/4}=1.
$$

This replaces hundreds of point additions and doublings with fixed field circuits.
Each power chain for $z^{2^{252}-3}$ uses 251 squarings and 11 other multiplications.
The circuit builtins perform these operations without a VM loop over point operations.

The nonresidue branch also reuses its square-root power.
Set $t=z^{(p+3)/8}$ and choose $k$ with $k^2=2i$.
The four possible cases give:

$$
\begin{aligned}
t^2=z&\Rightarrow \sqrt z=t,\\
t^2=-z&\Rightarrow \sqrt z=it,\\
t^2=iz&\Rightarrow \sqrt{2z}=ikt,\\
t^2=-iz&\Rightarrow \sqrt{2z}=kt.
\end{aligned}
$$

Thus, that branch needs no second exponentiation for $\sqrt{2z}$.
No additional calldata or untrusted square-root hint is necessary.

## Full subgroup test

For the prime-subgroup point with the first halving branch:

$$
S_{\mathrm{generic}}=158399,\qquad S_{\mathrm{divide\text{-}and\text{-}pair}}=1450.
$$

For the prime-subgroup point with the nonresidue branch:

$$
S_{\mathrm{generic}}=158399,\qquad S_{\mathrm{divide\text{-}and\text{-}pair}}=1572.
$$

Both valid-point cases consume the same Sierra gas:

$$
G_{\mathrm{generic}}=28018310,\qquad G_{\mathrm{divide\text{-}and\text{-}pair}}=944652.
$$

This is a 96.63% reduction in Sierra gas for these inputs.
The VM-step reductions are 99.08% and 99.01%, respectively.
The mixed-order cases also reject correctly: 819 steps for an odd torsion coset and 1268 for an even torsion coset.
Both consume 944832 Sierra gas, compared with 28017690 for the oracle.

Sierra gas charges a compiled resource bound across branches.
Consequently, the shorter rejection path does not produce a proportional Sierra-gas reduction.
The report records VM steps and actual Sierra gas from separate Foundry runs.
It does not substitute a weighted profiler estimate for actual Sierra gas.

## EdDSA verification

EdDSA retains its existing policy: reject pure small-order points, without requiring full prime-subgroup membership.
For valid Edwards points, the new guard is

$$
[8]P=\mathcal O\quad\Longleftrightarrow\quad xy(x^2+y^2)=0.
$$

The verifier applies this guard before the birational map.
This removes two Weierstrass doublings per point and two redundant curve checks.
The decompression equation already establishes that each Edwards point lies on the curve.
The verifier also rejects noncanonical coordinates and encodings explicitly.

The three active signature benchmarks measure the complete verification function:

- Empty message: 51802 → 51234 steps; 10398026 → 10283718 Sierra gas.
- 32-byte message: 52378 → 51810 steps; 10455732 → 10341424 Sierra gas.
- 64-byte message: 88156 → 87588 steps; 15786278 → 15671970 Sierra gas.

Each case saves 568 steps and 114308 Sierra gas, including the new canonical-encoding checks.
The signature structure and calldata layout do not change.

## Pairing verifier bytecode

The generic G1 subgroup dispatcher also serves Groth16.
Without specialization, that dispatcher retains the Ed25519 branch in BN254 contracts.
The two inline annotations propagate each verifier's known curve into the dispatcher.
This removes unrelated subgroup implementations from its bytecode.
It preserves the existing BN254 and BLS12-381 subgroup conditions.

The same proof fixtures give these before/after results:

- Groth16 BN254: 233180 → 233039 steps; 35527207 → 35512947 gas; 58914 → 45575 CASM felts.
- Groth16 BLS12-381: 337397 → 337279 steps; 51703072 → 51687852 gas; 51003 → 50935 CASM felts.
- RISC Zero: 274148 → 274009 steps; 45632235 → 45618175 gas; 64039 → 50704 CASM felts.
- SP1: 278145 → 278006 steps; 44088644 → 44074584 gas; 63978 → 50657 CASM felts.

Gas in this list means actual Sierra gas from a separate Foundry run.
These reductions come from compiler specialization, rather than a new subgroup formula for the pairing curves.
Their deployable class hashes therefore change.
The sample applications must use the corresponding rebuilt verifier class.

## Reproduce

The [Lean package](../../../tools/divide_and_pair/formal/README.md) proves both extracted subgroup decisions against the concrete Ed25519 group.
Its field, group-order, halving, and quartic proofs discharge the assumptions used in the final decision theorem.
The source checks and the theorem dependency audit run in the dedicated Lean CI workflow.

Install the repository's pinned tools and development environment.
Then run:

```bash
PYTHONPATH=hydra uv run --no-project --python .venv/bin/python \
  -m tools.divide_and_pair.benchmark \
  --output docs/benchmarks/divide-and-pair/results.json
```

The script extracts the baseline from Git into a temporary directory.
It runs both resource modes and rejects source changes during measurement.
Sibling log files contain the raw Foundry output.
These figures exclude transaction fees and calldata costs.
