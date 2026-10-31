# Source-linked Lean proofs for Ultra Keccak ZK

This package proves equality of the 31 relation formulas and their four key specializations.
It also proves the algebraic guarantees of several optimizations and the RLC root-count bound.
It does **not** establish equivalence of the complete concrete Cairo and Solidity verifiers.
The conditional verifier theorem retains an explicit, unproved backend compatibility premise.

## Exact arithmetic results

The scalar domain is

$$
\mathbb F_r=\mathbb Z/r\mathbb Z,\qquad
r=21888242871839275222246405745257275088548364400416034343698204186575808495617.
$$

For every assignment of the 41 evaluations and six relation parameters, Lean proves

$$
\forall j\in\{0,\ldots,30\},\quad
R_j^{\mathrm{Solidity}}(\mathbf e,\beta,\gamma,\delta,\eta,\gamma_{\mathrm{ROM}},D)
=
R_j^{\mathrm{Cairo}}(\mathbf e,\beta,\gamma,\delta,\eta,\gamma_{\mathrm{ROM}},D).
$$

These are universally quantified identities, rather than tests of stored receipts.
The four specialized results use the zero evaluations that the generated contracts enforce for identity commitments.
Together, the generic and specialized results comprise **155 relation identities**.

`Acceptance.lean` proves that equal relation vectors give equal batched and final relation checks.
`Optimizations.lean` proves that identity commitments contribute zero to an abstract MSM.
It also proves that the compact coordinate representation preserves the value and satisfies the u128 bounds.
The recursive aggregation lemma requires a correct scalar multiplication result from the hint backend.
It does not prove correctness of the GLV checker itself.

## RLC guarantees and assumptions

The source uses weights that start at $\rho$, rather than at one:

$$
B_{\mathbf e}(X)=\sum_{i=0}^{n-1}e_iX^{i+1}.
$$

Lean proves all of the following:

- Exact round checks imply the RLC check for every challenge.
- A fixed nonzero residual vector gives a nonzero polynomial of degree at most $n$.
- The number of bad challenges in any finite sample set is at most $n$.
- For an independent uniform challenge, the failure fraction is at most $n/|\mathcal S|$.
- The converse fails without a binding condition. The formal counterexample uses $e_0=-\rho$ and $e_1=1$.

The counterexample does not construct a complete forged proof for the concrete transcript.
Its residual vector depends on the challenge.

The actual challenge comes from Starknet Poseidon applied to the final transcript challenge.
Its source field has size $p_{\mathrm{Stark}}=2^{251}+17\cdot2^{192}+1$.
An argument for the actual Fiat–Shamir construction must justify independence or account for adaptive queries and grinding.
The Lean polynomial theorem does not prove that cryptographic argument.

The conditional acceptance theorem has two explicit premises:

$$
\mathsf{Binding}(\mathbf e,\rho):
B_{\mathbf e}(\rho)=0\Longrightarrow\forall i<n,\ e_i=0,
$$

$$
\mathsf{BackendCompatibility}:
\mathsf{SolidityBackend}\Longleftrightarrow\mathsf{CairoBackend}.
$$

The first premise is the RLC soundness condition for a particular challenge and residual vector.
The second premise is a separate source-refinement obligation.
It includes transcript construction, public-input delta, Libra consistency, KZG coefficient construction, curve operations, and hint checking.
This package does not prove that second premise.
The theorem also treats residual vectors, transcript parameters, and the row-disabling factor as shared mathematical inputs.
Their correspondence to the complete source implementations remains a separate obligation.
Consequently, the conditional theorem is **not a completed end-to-end equivalence proof**.

The root-count theorem assumes a field. The BN254 acceptance specialization explicitly assumes primality of $r$.
The relation identities themselves need only the ring structure of `ZMod r`.

## Relation to the source code

`generate.py` extracts the two models independently:

- The Solidity model comes from the typed AST produced by solc for the actual `bb write_solidity_verifier` output.
- The Cairo model comes from the circuit IR that the production relation factory builds.
- The specialized models use the committed verification keys and their identity commitment indexes.

The extractor supports the arithmetic subset present in these functions and rejects unsupported constructs.
It checks the field modulus, the overloaded field operators, and coverage of all 31 subrelations.
Each changed integer constant has a separate Lean proof that its normalized representation denotes the same element of `ZMod r`.
The generated files record source, key, and extractor hashes.

The Python extractor, solc frontend, and correspondence between the circuit IR and emitted Cairo remain trusted translation boundaries.
The Lean kernel checks the generated mathematical identities. It does not verify those translators.
This distinction also applies to the trust in the standard field arithmetic interfaces.

## Continuous checks

The Noir workflow rebuilds the Solidity AST and rejects a stale Solidity model.
`make rewrite` regenerates the Cairo model from the production factory and committed keys.
A Python regression test rejects stale Cairo models before regeneration.
The same Noir workflow builds the Lean proofs and audits their axiom dependencies.

The audit permits only Lean's standard logical axioms: `propext`, `Classical.choice`, and `Quot.sound`.
It rejects placeholder axioms and compiler-trust axioms.
The project pins Lean 4.35.0, its Linux archive checksum, Mathlib, and all transitive dependencies.

## Commands

From the repository root, with the pinned SDKs and Foundry in `PATH`:

```bash
make -C tools/noir solidity
PYTHONPATH=hydra uv run tools/noir/formal/generate.py --check
```

With the pinned Lean SDK in `PATH`:

```bash
tools/noir/formal/check.sh
```

To update mathematical models after a deliberate source change:

```bash
PYTHONPATH=hydra uv run tools/noir/formal/generate.py
```

The cache command downloads only the Mathlib modules required by these proofs.
It does not regenerate Barretenberg proofs.

See the [before/after note](../../../docs/benchmarks/barretenberg-v6/BEFORE_AFTER.md) for the measured step reductions and equations.
