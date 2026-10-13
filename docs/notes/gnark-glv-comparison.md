# gnark GLV and fake-GLV comparison

## Scope and source snapshot

This comparison covers emulated short-Weierstrass scalar multiplication, its hints, and its public consumers. The source review date is October 14, 2026.

The gnark snapshot is [`57d003082259089d776b4fa7dbce591eb731e87a`](https://github.com/Consensys/gnark/tree/57d003082259089d776b4fa7dbce591eb731e87a). The latest relevant scalar-multiplication changes are October 5 and October 7, 2026.

The gnark-crypto snapshot is [`8911ee45d22bdf9d1c6ab4affe2d4f7ffaedd557`](https://github.com/Consensys/gnark-crypto/tree/8911ee45d22bdf9d1c6ab4affe2d4f7ffaedd557). Its reconstruction implementation is in [`algebra/lattice/lattice.go`](https://github.com/Consensys/gnark-crypto/blob/8911ee45d22bdf9d1c6ab4affe2d4f7ffaedd557/algebra/lattice/lattice.go).

The Garaga comparison baseline is PR #521 at [`a01fad00d0f77fe8e252ca8c2c64423e5efeb812`](https://github.com/keep-starknet-strange/garaga/tree/a01fad00d0f77fe8e252ca8c2c64423e5efeb812). Findings in this document describe that baseline unless a section states otherwise.

## Required soundness invariants

Let `P` denote the input point, `Q` the hinted result, `s` the scalar, and `r` the prime subgroup order.

The fake-GLV scalar relation is:

```text
s1 + s*s2 = 0 mod r
s2 != 0 mod r
[s1]P + [s2]Q = O
```

The GLV+fake-GLV scalar relation is:

```text
U = u1 + lambda*u2 mod r
V = v1 + lambda*v2 mod r
U + s*V = 0 mod r
V != 0 mod r
[u1]P + [u2]phi(P) + [v1]Q + [v2]phi(Q) = O
```

The short accumulator must consume every bit of the coefficients used in the scalar relation. A wider modular relation cannot justify a truncated accumulator.

Both relations also require genuine curve points. The GLV eigenvalue relation requires the intended prime-order subgroup.

These obligations are independent. Correct hints do not replace constraints against malicious hints. See the [current gnark scalar-multiplication implementation](https://github.com/Consensys/gnark/blob/57d003082259089d776b4fa7dbce591eb731e87a/std/algebra/emulated/sw_emulated/point.go).

## Upstream changes and Garaga mapping

### 1. Half-GCD convergence: May 2025

The original Eisenstein quotient could leave a remainder without a smaller norm. Some witnesses then caused extremely slow hint execution.

The fix uses symmetric integer rounding and nearby hexagonal-lattice quotients. It preserves the strict Euclidean norm decrease.

The fix is gnark-crypto [`56600883e0e9f9b159e9c7000b94e76185ec3d0d`](https://github.com/Consensys/gnark-crypto/commit/56600883e0e9f9b159e9c7000b94e76185ec3d0d), consumed by gnark [`68be6cede36e387ab760725beabd3c96cc94e6dc`](https://github.com/Consensys/gnark/commit/68be6cede36e387ab760725beabd3c96cc94e6dc). [GHSA-9fvj-xqr2-xwg8](https://github.com/Consensys/gnark/security/advisories/GHSA-9fvj-xqr2-xwg8) records the availability impact.

Garaga already contains symmetric rounding, neighboring quotient selection, and a Half-GCD iteration limit. Its Python and Rust implementations use these mechanisms. This specific fix is present. Sources: baseline [`eisenstein.py`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/hydra/garaga/hints/eisenstein.py) and [`eisenstein.rs`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/tools/garaga_rs/src/hints/eisenstein.rs).

### 2. Shared selectors and signed-Y symmetry: February 2026

gnark shares selector decomposition between coordinates. It also replaces a 16-entry Y multiplexer with eight entries and conditional negation.

The optimization is [`cbcf55973872d220e73f28a5e591c33ee6572530`](https://github.com/Consensys/gnark/commit/cbcf55973872d220e73f28a5e591c33ee6572530), PR [#1704](https://github.com/Consensys/gnark/pull/1704).

Garaga already shares coefficient selectors and reuses X coordinates between opposite points. Its Cairo implementation directly indexes a point array. Therefore, gnark's emulated multiplexer gate reduction does not directly apply. Sources: baseline [`selectors.cairo`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/selectors.cairo) and [`ec_ops.cairo`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/ec_ops.cairo).

### 3. Complete arithmetic and zero denominators: May and October 2026

gnark changed elliptic-curve arithmetic to complete mode by default. Incomplete mode became an explicit request. It added nontrivial denominator constraints for fake-GLV relations.

Sources: [`e6bbfe1a9166740cfa14b99687309243bdaf301e`](https://github.com/Consensys/gnark/commit/e6bbfe1a9166740cfa14b99687309243bdaf301e), PR [#1751](https://github.com/Consensys/gnark/pull/1751), and [`25df7811e308bf3efc61e2ffc6b4e989cd376939`](https://github.com/Consensys/gnark/commit/25df7811e308bf3efc61e2ffc6b4e989cd376939), PR [#1762](https://github.com/Consensys/gnark/pull/1762).

Garaga already rejects `s2 = 0` in ordinary fake-GLV. Its GLV+fake-GLV baseline lacks an explicit nonzero denominator constraint. This gap requires a Cairo constraint, not an honest-hint assertion. Source: baseline [`ec_ops.cairo`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/ec_ops.cairo).

gnark's October fix also corrects `AddUnified` on curves with nonzero `a`. Opposite Y coordinates do not imply opposite points unless X coordinates also agree. Garaga's safe-add dispatcher uses X equality. Its generated affine circuits use explicit inverses instead of free `0/0` slope hints. The same formula defect is not present. Sources: [`4d476392b169eaffaaafe0796ba750e2a5081652`](https://github.com/Consensys/gnark/commit/4d476392b169eaffaaafe0796ba750e2a5081652) and baseline [`ec.py`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/hydra/garaga/precompiled_circuits/ec.py).

Completeness and soundness remain separate properties. A zero denominator that rejects a valid witness is a completeness defect. A free slope that accepts a false statement is a soundness defect.

### 4. Lattice reconstruction and shorter accumulators: May 2026

gnark replaces Eisenstein Half-GCD with rank-four lattice reconstruction for GLV+fake-GLV. The new lattice has determinant `r`:

```text
L = {(x,y,z,t) in Z^4: x + lambda*y = k*(z + lambda*t) mod r}
```

The reducer uses LLL with `delta = 99/100`. It first tries a vector with coordinates at most `floor(r^(1/4))`. Otherwise, it selects the shortest eligible reduced row by infinity norm.

The hint reconstructs `k = -s`, then returns `(u1,u2,v1,v2) = (x,y,z,t)`. It retains independent signs for all four coordinates.

The two-dimensional reconstruction still uses exact integer Half-GCD. A new lattice backend does not imply LLL for ordinary fake-GLV.

Sources: gnark [`ff8195878c19c3e60b6050f61625611ab22765ed`](https://github.com/Consensys/gnark/commit/ff8195878c19c3e60b6050f61625611ab22765ed), PR [#1763](https://github.com/Consensys/gnark/pull/1763), and gnark-crypto [`34878ac34e3e59e8a12ce5df5cccad4c464e82d0`](https://github.com/Consensys/gnark-crypto/commit/34878ac34e3e59e8a12ce5df5cccad4c464e82d0).

Garaga's baseline uses Eisenstein Half-GCD for the four-dimensional hints and a 73-bit selector schedule. The lattice replacement is absent. A full migration requires matching Python and Rust hints, Cairo selectors, generator constants, generated callers, and WASM artifacts. Sources: baseline [`fake_glv.py`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/hydra/garaga/hints/fake_glv.py), [`fake_glv.rs`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/tools/garaga_rs/src/hints/fake_glv.rs), and [`generate_selector_code.py`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/generate_selector_code.py).

### 5. Coefficient width constraints: June 2026

The decomposition relation originally accepted wider values than the accumulator consumed. A malicious hint could put meaningful bits outside the short accumulator.

gnark now constrains each hint output to the actual scalar-loop width. The fix is [`a3ad59ad083caac7691cba84a497d4d7c1759d2a`](https://github.com/Consensys/gnark/commit/a3ad59ad083caac7691cba84a497d4d7c1759d2a), PR [#1778](https://github.com/Consensys/gnark/pull/1778). The [#1763 review](https://github.com/Consensys/gnark/pull/1763) explains a concrete truncated-coefficient attack.

Garaga decodes four-dimensional absolute values into `u96`, but its baseline selectors consume only 73 bits. Thus, the baseline accepts 23 unused high bits. The selector generator requires an explicit remainder-zero constraint. Ordinary fake-GLV uses `u128` coefficients and consumes their full width. Sources: baseline [`ec_ops.cairo`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/ec_ops.cairo) and [`generate_selector_code.py`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/generate_selector_code.py).

### 6. Cofactor torsion and independent GLV signs: August 2026

An on-curve result alone does not bind GLV+fake-GLV on a cofactor curve. The accumulator proves `[V](Q - [s]P) = O`. Nonzero `V mod r` does not eliminate cofactor torsion.

gnark routes BLS12-381 G1 public multiplication through classic GLV. That path computes the output instead of trusting a hinted output. Its alternative subgroup binding hints an on-curve preimage `S` and proves `[c]S = Q`.

The same update fixes GLV tables that accidentally include another coefficient's sign. Each Phi-table entry must use only its own coefficient's sign.

Sources: [GHSA-3mvx-pp85-pm65](https://github.com/Consensys/gnark/security/advisories/GHSA-3mvx-pp85-pm65), merge [`e3ce978e43e269d42d5c1d2f11c6023849af5bd4`](https://github.com/Consensys/gnark/commit/e3ce978e43e269d42d5c1d2f11c6023849af5bd4), and PR [#1797](https://github.com/Consensys/gnark/pull/1797).

Garaga routes BLS12-381 G1 through GLV+fake-GLV without subgroup constraints on the hinted result. This gap requires subgroup binding in the public and generated-helper paths. Garaga's Phi tables already use independently signed Phi operands. The upstream sign defect is absent from that construction. Sources: baseline [`ec_ops.cairo`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/ec_ops.cairo) and [`ec.py`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/hydra/garaga/precompiled_circuits/ec.py).

### 7. Latest bound and cheaper subgroup binding: October 5, 2026

The latest rank-four coefficient width is `ceil(bitlen(r)/4) + 1`, or 65 bits for Garaga's three GLV curves.

The LLL bound is `1.2534*r^(1/4)`. It is an approximation guarantee, not the Hermite constant. A 64-bit bound does not cover the fallback reducer.

BLS12-381 G1 subgroup binding now uses `c = 0xd201000000010001`, the exponent of the cofactor torsion. It does not require the full 126-bit cofactor. The multiplication map satisfies `[c]E(Fp) = G1`, and `gcd(c,r) = 1` preserves honest preimages.

gnark's guarded fixed-constant ladder rejects infinity and checks nonzero denominators at each step. Its curve parameters also mark cofactor-one curves explicitly. A missing subgroup method fails closed.

Source: [`8df228fcec35914e1b22961dc9de8cc28c179fed`](https://github.com/Consensys/gnark/commit/8df228fcec35914e1b22961dc9de8cc28c179fed), PR [#1826](https://github.com/Consensys/gnark/pull/1826).

Garaga already has a BLS subgroup test through the 128-bit seed-square relation. The cheaper 64-bit preimage method is absent. Its migration needs a new point hint and a verified clearing ladder. The full migration can preserve the existing calldata shape only through another subgroup method. Source: baseline [`ec_ops.cairo`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/ec_ops.cairo).

### 8. Hinted output curve membership: October 7, 2026

gnark failed to constrain fake-GLV hinted outputs to the curve. A malicious prover could choose off-curve outputs and satisfy a degenerate accumulator relation.

The fix explicitly constrains both hinted-output algorithms. It also documents their curve and subgroup contracts. Sources: [GHSA-7fx8-hmgc-82jp](https://github.com/Consensys/gnark/security/advisories/GHSA-7fx8-hmgc-82jp) and [`4d476392b169eaffaaafe0796ba750e2a5081652`](https://github.com/Consensys/gnark/commit/4d476392b169eaffaaafe0796ba750e2a5081652).

Garaga already constrains `hint.Q` on the curve in both ordinary paths. Scalars `0`, `1`, and `r-1` bypass the hint and compute their result directly. The fix is present for those paths. Direct helper preconditions still require review. Source: baseline [`ec_ops.cairo`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/ec_ops.cairo).

## Garaga-specific Ed25519 full-curve binding

Garaga also supports Ed25519 in Weierstrass form. Its group order is `8*r`, with odd prime `r`. Ed25519 parameters appear in [RFC 8032, section 5.1](https://www.rfc-editor.org/rfc/rfc8032.html#section-5.1). Garaga's EdDSA consumer accepts curve points outside the prime-order subgroup. Source: baseline [`eddsa_25519.cairo`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/signatures/eddsa_25519.cairo).

Ordinary fake-GLV over the full curve also needs cofactor protection. Nonzero `s2 mod r` does not exclude an even denominator that annihilates a nonzero torsion offset.

The following construction preserves exact multiplication on the full curve. This proof is a Garaga-specific derivation, not an upstream gnark implementation.

```text
P8 = [8]P
Q8 = [8]Q
t = s mod 8, with 0 <= t < 8

1. Prove Q8 = [s]P8 through subgroup fake-GLV.
2. Constrain an on-curve witness S and prove [8]S = Q - [t]P.
```

Let `D = Q - [s]P`. The first equation gives `[8]D = O`. The second equation places `D` in the image of multiplication by eight:

```text
D = [8](S - [floor(s/8)]P)
```

This image has prime order `r`. Multiplication by eight is invertible on that image because `gcd(8,r) = 1`. Therefore, `D = O` and `Q = [s]P` exactly.

An honest witness is `S = [floor(s/8)]P`. This witness exists for subgroup points, mixed-order points, pure torsion, and infinity.

The implementation must use complete operations for the small cofactor ladders and torsion correction. If `P8 = O`, it must compute the pure-torsion result directly or constrain both equations without the affine fake-GLV circuit. Infinity requires an explicit accepted encoding. Curve constraints apply to every non-infinity point witness.

## Adjacent changes without a matching Garaga path

gnark adds arbitrary G2 GLV+fake-GLV multiplication in [`8e4363f1a60dc2febaa872fbda8847d78ce8cf48`](https://github.com/Consensys/gnark/commit/8e4363f1a60dc2febaa872fbda8847d78ce8cf48), PR [#1764](https://github.com/Consensys/gnark/pull/1764). Garaga's Cairo G2 operations expose fixed seed multiplication and subgroup checks, not arbitrary G2 scalar multiplication. There is no matching variable-scalar path to migrate. Source: baseline [`ec_ops_g2.cairo`](https://github.com/keep-starknet-strange/garaga/blob/a01fad00d0f77fe8e252ca8c2c64423e5efeb812/src/src/ec/ec_ops_g2.cairo).

gnark's October update also tunes fixed-base comb windows for R1CS and PLONK. It selects backend-specific widths and uses bilinear one-hot selection. Garaga's existing G1 MSM API uses hinted scalar multiplication, not this comb gadget. Its Cairo builtin cost model differs from both gnark backends. Source: [`#1826 fixed-base changes`](https://github.com/Consensys/gnark/commit/8df228fcec35914e1b22961dc9de8cc28c179fed).

gnark's deferred carry-range fix protects its polynomial-check emulated field arithmetic. Garaga's Cairo circuit path uses modular builtins instead of that deferred multicommit protocol. This fix does not have a matching implementation. Source: [GHSA-3mvx-pp85-pm65](https://github.com/Consensys/gnark/security/advisories/GHSA-3mvx-pp85-pm65).

## Migration wire formats and security purpose

The branch now generates BLS12-381 cofactor preimages in Python and Rust. Each preimage satisfies `[0xd201000000010001]S = target`. Host hints reject pure or mixed cofactor torsion.

BLS12-381 MSM records now contain 28 felts. Their order is the existing 12-felt GLV record, the eight-felt input preimage, then the eight-felt result preimage. The input and result preimages let Cairo enforce subgroup membership through the shorter 64-bit clearing ladder. Existing 12-felt BLS calldata requires regeneration.

Ed25519 MSM records contain 18 felts. Their order is the existing ten-felt fake-GLV record, then the eight-felt full-curve preimage. This preimage binds the torsion class without excluding mixed-order inputs.

BN254 and secp256k1 records retain 12 felts. Secp256r1 and Grumpkin records retain ten felts.

Sources: branch [`fake_glv.py`](../../hydra/garaga/hints/fake_glv.py), [`fake_glv.rs`](../../tools/garaga_rs/src/hints/fake_glv.rs), [`msm.py`](../../hydra/garaga/starknet/tests_and_calldata_generators/msm.py), and [`msm_calldata.rs`](../../tools/garaga_rs/src/calldata/msm_calldata.rs).

Rust relation tests cover scalar `0`, `1`, `2`, and `r-1` results. They also reject pure and mixed three-torsion inputs. Rust record tests establish the 28-felt BLS format.

The rebuilt extension passes 41 targeted Python tests for preimages, full-curve arithmetic, input constraints, and Python/Rust calldata parity. Sources: [`test_bls_cofactor_preimages.py`](../../tests/hydra/hints/test_bls_cofactor_preimages.py) and [`test_cofactor_binding.py`](../../tests/hydra/hints/test_cofactor_binding.py).

## Current Cairo enforcement

The coefficient range constraint precedes both the fast path and complete fallback. The GLV denominator has a constrained inverse modulo `r`. Independent signs preserve the same coefficients in the scalar relation and point operations.

BLS12-381 public MSM uses the input and output cofactor preimages. Its direct GLV helper instead retains the exact seed-square subgroup constraint. The unchecked shared core is private.

Exceptional inversions select complete arithmetic only after Cairo verifies the circuit failure guarantee. The fallback computes the full signed relation, without truncated coefficients. Source: [`ec_ops.cairo`](../../src/src/ec/ec_ops.cairo) and [`core/circuit.cairo`](../../src/src/core/circuit.cairo).

The fallback producer uses a full-rank kernel basis of determinant `r`. Its exact rational Gram-Schmidt updates match the Python and Rust implementations. Both producers constrain the fallback output to 65 bits. Sources: [`lattice.py`](../../hydra/garaga/hints/lattice.py) and [`lattice.rs`](../../tools/garaga_rs/src/hints/lattice.rs).

A checked Eisenstein fast path avoids the host cost of exact LLL on ordinary inputs. The kernel has norm `r` and evaluates to zero modulo `r`. The fast path reduces the scalar modulo that kernel, then applies Half-GCD to the negative remainder.

The producer accepts a candidate only after all three contract constraints pass: the 65-bit width, nonzero effective denominator, and exact scalar relation. Otherwise, it uses the ported LLL reconstruction. The Cairo constraints do not trust the producer's algorithm choice.

Regression tests inject invalid, wide, and zero-denominator fast candidates. They require the actual LLL result, not a replacement test value. A deterministic fallback example also exceeds the early-exit fourth-root bound, while it fits the final bit bound. Sources: [`test_checked_glv_reconstruction.py`](../../tests/hydra/hints/test_checked_glv_reconstruction.py) and [`fake_glv.rs`](../../tools/garaga_rs/src/hints/fake_glv.rs).

## Cairo impact requirements

gnark constraint counts cannot establish Cairo performance. Cairo measurements must use the same compiler, runner, test inputs, and optimization settings before and after the changes.

A 73-to-65-bit GLV schedule removes eight double-and-add stages per scalar. New coefficient, denominator, and subgroup constraints add costs. The net result requires execution-resource measurements.

The measured security result requires adversarial Cairo tests, not only honest scalar-multiplication tests. Relevant vectors include unused high bits, a zero GLV denominator, off-curve hints, torsion-shifted BLS outputs, and direct-helper scalar boundaries.

End-to-end evidence also requires Python/Rust calldata parity and regenerated WASM artifacts. Generated Honk and Groth16 consumers must exercise the same checked helpers as the library API.

This source comparison does not claim that implementation, benchmarks, or CI are complete. Those claims require the final branch's test and CI evidence.

## Independent Cairo encoding review

Cairo circuit inputs can contain unreduced `u384` values. The existing `reduce_mod_p` helper explicitly converts these inputs to canonical outputs. A curve equation modulo `p` alone therefore accepts coordinate aliases such as `y + p`.

Returned hint coordinates also reach representation-sensitive operations. ECDSA reads the raw Y parity and reduces the raw X modulo `r`. Canonical coordinates require separate constraints before that use.

This finding comes from the Garaga code review, not an upstream advisory. The branch adds reduced X and Y outputs to the curve constraint. It requires both coordinates to equal those outputs. Python and Rust builders also reject noncanonical input coordinates.

Relevant sources are [`basic_field_ops.cairo`](../../src/src/basic_field_ops.cairo), [`ec_ops.cairo`](../../src/src/ec/ec_ops.cairo), and [`ecdsa.cairo`](../../src/src/signatures/ecdsa.cairo). The [Cairo regression tests](../../src/src/tests/scalar_mul_soundness_tests.cairo) reject X and Y aliases on hinted-output paths.
