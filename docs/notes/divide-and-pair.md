# Divide-and-Pair in Garaga

This note records the applicability, formulas, and proof obligations for Divide-and-Pair in Garaga.
The research snapshot is October 31, 2026.
The Garaga baseline is commit `9b327b4ab3e1e2535df689765adb88b99762f739`.

## Sources and review status

- [Paper 2026/749](https://eprint.iacr.org/2026/749): the archive lists a revision dated July 15, 2026.
- [Companion implementation](https://github.com/yelhousni/divide-and-pair/tree/ef2e77be1a4b39eee2f12aff1aebe39f789de263): commit `ef2e77be1a4b39eee2f12aff1aebe39f789de263`.
- [Rust cross-check](https://github.com/yelhousni/crrl/blob/69cead92403999d2ce4a6ccc46d46462c8099402/src/ed25519.rs): submodule commit `69cead92403999d2ce4a6ccc46d46462c8099402`.
- [Author's companion-curve note](https://hackmd.io/@yelhousni/divide-and-pair): downloaded Markdown SHA-256 `4b45036ffee76915f33a2ee1f3c5394db6f4fc690d7791fed0aad58c90877568`.
- [Mathlib source](https://github.com/leanprover-community/mathlib4/tree/56a005855ea17e0b0958f73ec801ae140b0a1679): the commit that Garaga pins with Lean 4.35.0.

The PDF endpoint returned a Cloudflare challenge with HTTP 403 during this research.
The archive metadata, complete companion implementation, Rust cross-check, and author note were available.
Consequently, this note attributes exact formulas to the pinned implementation.
It does not claim a complete PDF review.

## Applicable groups

Garaga defines Ed25519 over `p = 2^255 - 19`, with cofactor eight and subgroup order `ell`.
Its point API stores the equivalent short Weierstrass coordinates.
This group matches the reference implementation's Curve25519 twisted Edwards model.
[Garaga curve definitions](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/hydra/garaga/curves.py#L438),
[reference parameters](https://github.com/yelhousni/divide-and-pair/blob/ef2e77be1a4b39eee2f12aff1aebe39f789de263/curve25519/curve.go).

BN254 G1, secp256k1, secp256r1, and Grumpkin have cofactor one in Garaga.
For these groups, a correct curve-membership check already establishes subgroup membership.
Divide-and-Pair adds no subgroup condition.
[Garaga curve definitions](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/hydra/garaga/curves.py#L307).

BLS12-381 G1 has the large odd cofactor `0x396c8c005555e1568c00aaab0000aaab`.
Garaga already uses its curve-specific endomorphism criterion.
The Curve25519 quartic formula does not establish membership in this group.
[Garaga G1 implementation](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/src/src/ec/ec_ops.cairo#L40).

BN254 G2 and BLS12-381 G2 also have nontrivial odd cofactors.
The low limbs are respectively `0x345f2299c0f9fa8d` and `0xcf1c38e31c7238e5`.
Therefore, tests that detect only two-power cofactor components cannot establish their prime-subgroup membership.
The companion repository supplies no Divide-and-Pair instantiation for these groups.
[BN254 G2 cofactor](https://github.com/arkworks-rs/curves/blob/e2d16a27e2cfa9f972ae9772df827a22730011b4/bn254/src/curves/g2.rs#L18),
[BLS12-381 G2 cofactor](https://github.com/arkworks-rs/curves/blob/e2d16a27e2cfa9f972ae9772df827a22730011b4/bls12_381/src/curves/g2.rs#L34).

Garaga's `CURVES[id].h` describes G1 and does not describe the corresponding G2 twist.
The baseline BN254 G2 branch nevertheless uses this value to skip the subgroup check.
This separate issue does not justify a Curve25519 formula on G2.
The baseline BLS12-381 G2 comment also claims three rational two-torsion points.
That claim conflicts with the odd order of this specific twist.
[Python G2 branch](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/hydra/garaga/points.py#L430),
[Cairo G2 branch and comments](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/src/src/ec/ec_ops_g2.cairo#L43).

The author note's “BN254” means Baby Jubjub over the BN254 scalar field.
Its “BLS12-381 (Jubjub)” also means a companion Edwards curve over a scalar field.
Neither name identifies Garaga's pairing-curve G1 or G2.
[Author note](https://hackmd.io/@yelhousni/divide-and-pair).

## Two different Ed25519 predicates

Let `E(Fp)` have order `8 * ell`, where `ell` is odd and prime.
The full subgroup predicate is `[ell]P = O`.
The pure small-order predicate is `[8]P = O`.
These predicates are different.

For nonzero subgroup point `Q` and nonzero eight-torsion point `T`, the point `P = Q + T` fails full membership.
However, `[8]P = [8]Q` is nonzero.
Thus, rejection of pure small-order points permits nonzero torsion cosets.
This conclusion follows from the group decomposition and does not require a pairing assumption.

Garaga's baseline Python `G1Point.is_in_prime_order_subgroup` uses `[ell]P` for Ed25519.
The Cairo `G1PointTrait.assert_in_subgroup_excluding_infinity` branch for Ed25519 is unimplemented.
These entry points require the full predicate.
[Python G1 predicate](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/hydra/garaga/points.py#L149),
[Cairo G1 predicate](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/src/src/ec/ec_ops.cairo#L40).

Garaga's EdDSA verifier instead rejects pure small-order points in both `R` and the public key.
A full-membership replacement changes this acceptance policy.
The direct small-order formula in the next section preserves the intended predicate.
[EdDSA verifier](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/src/src/signatures/eddsa_25519.cairo#L68).

## Direct small-order formula

For a valid affine Edwards point `(x, y)`, the reference identifies pure small order through:

```text
x = 0 or y = 0 or x = i*y or x = -i*y
```

Here, `i^2 = -1` in `Fp`.
The equivalent polynomial condition is:

```text
x*y*(x^2 + y^2) = 0
```

The identity `(0, 1)` satisfies this condition.
Full membership accepts that identity, while EdDSA's pure small-order rejection rejects it.
The formula requires a valid Edwards point.
[Reference exceptional-point guard](https://github.com/yelhousni/divide-and-pair/blob/ef2e77be1a4b39eee2f12aff1aebe39f789de263/curve25519/subgroup_membership.go#L54).

The doubling formulas give a direct algebraic proof:

```text
x(2P) = 2*x*y / (1 + d*x^2*y^2)
y(2P) = (x^2 + y^2) / (1 - d*x^2*y^2)
```

For Ed25519, these denominators are nonzero on valid affine Edwards points.
An Edwards point has order dividing two exactly when its `x` coordinate is zero.
Therefore, `[8]P = O` exactly when `x(2P)*y(2P) = 0`.
Substitution gives the polynomial condition.
The nonsquare parameter `d` and square parameter `a = -1` support the denominator argument.
[Reference addition formulas and parameters](https://github.com/yelhousni/divide-and-pair/blob/ef2e77be1a4b39eee2f12aff1aebe39f789de263/curve25519/point.go#L77),
[RFC 8032, Section 5.1](https://www.rfc-editor.org/rfc/rfc8032.html#section-5.1).

## Exact Curve25519 Divide-and-Pair formula

All operations in this section use `Fp`.
The reference uses:

```text
a = -1
d = -121665/121666
delta = a - d
A = 2*(a + d)
B = delta^2
A_prime = -2*A
B_prime = A^2 - 4*B
i = 19681161376707505956807079304988542015446066515923890162744021073123829784752
c^2 = 2*B_prime
```

The reference first handles the pure small-order set.
It accepts only the identity from that set.
For every other valid Edwards point, it initializes:

```text
e = x*(1 - y)
u = delta*(1 + y)*x*e
w = 2*(1 - y)
```

The maintained curve equation is:

```text
u*w^2 = u^2 + A*e^2*u + B*e^4
```

The scale `e` remains nonzero outside the excluded exceptional cases.
These coordinates avoid the initial field inversion.
[Reference constants and scaled map](https://github.com/yelhousni/divide-and-pair/blob/ef2e77be1a4b39eee2f12aff1aebe39f789de263/curve25519/subgroup_membership.go#L10).

One division by two uses:

```text
u_s = 4*u
w_s = 2*w
w_prime = sqrt(u_s)
u_prime = (u_s - A_prime*e^2 - w_prime*w_s)/2
```

If `u_s` has no square root, the point fails full membership.
If `u_prime` is a square, the next values are:

```text
w_new = sqrt(u_prime)
e_new = e
u_new = (w_new^2 - A*e_new^2 - w_new*w_prime)/2
```

Otherwise, the reference changes the scale:

```text
t = sqrt(2*u_prime)
e_new = e*t
w_prime_scaled = w_prime*t
w_abs = c*e^2
u_new = (w_abs^2 - A*e_new^2 - w_abs*w_prime_scaled)/2
w_new = -w_abs
```

The last formula uses the old value of `e` in `w_abs`.
The new scale uses the nonzero value `t`.
The nonresidue `B_prime` makes the alternate inverse-isogeny branch available.
[Reference halving implementation](https://github.com/yelhousni/divide-and-pair/blob/ef2e77be1a4b39eee2f12aff1aebe39f789de263/curve25519/subgroup_membership.go#L97),
[Rust explanation of the inverse isogenies](https://github.com/yelhousni/crrl/blob/69cead92403999d2ce4a6ccc46d46462c8099402/src/ed25519.rs#L610).

After that single division, the final field element is:

```text
f = u_new*(w_new + 2*i*e_new)^2
```

Full membership requires:

```text
f != 0 and f^((p - 1)/4) = 1
```

The exponent is `2^253 - 5`.
Multiplication of `f` by a nonzero fourth power preserves this condition.
That property explains why the scale does not change the quartic condition.
[Quartic input and membership functions](https://github.com/yelhousni/divide-and-pair/blob/ef2e77be1a4b39eee2f12aff1aebe39f789de263/curve25519/subgroup_membership.go#L166),
[Rust exponentiation criterion](https://github.com/yelhousni/crrl/blob/69cead92403999d2ce4a6ccc46d46462c8099402/src/ed25519.rs#L766).

The Go quartic helper encodes the multiplicative value one as integer zero.
It also returns zero for field input zero.
Thus, the integer condition `QuarticSymbolExp() == 0` needs the preceding exceptional-point argument.
A port can avoid this encoding ambiguity through the explicit field condition above.
[Go quartic helper](https://github.com/yelhousni/divide-and-pair/blob/ef2e77be1a4b39eee2f12aff1aebe39f789de263/curve25519/fp/quartic_symbol.go#L405).

## Coordinate and hint constraints

Garaga's Edwards-to-Weierstrass map divides by `1-y` and `x*(1-y)`.
Its inverse map also has exceptional denominators.
The full test therefore needs explicit identity and torsion branches before conversion.
The synthetic Weierstrass infinity `(0, 0)` is not the affine Edwards identity `(0, 1)`.
[Garaga coordinate maps](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/hydra/garaga/curves.py#L225),
[Cairo conversion](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/src/src/signatures/eddsa_25519.cairo#L275).

A deterministic Cairo implementation can compute square roots and the quartic symbol through fixed exponentiation chains.
The existing G1 trait takes no explicit root hints.
A hint-assisted API can instead require roots and prove their polynomial relations in Cairo.
It must constrain every branch choice and every nonzero denominator.
For example, a fourth-root witness `z` requires `z^4 = f` and `f != 0`.
An unconstrained hint that states the quartic symbol does not establish membership.

The full test receives arbitrary curve points, including torsion cosets.
It cannot assume subgroup membership to justify a scalar-multiplication hint inside that same test.
Garaga's generic Python scalar multiplication explicitly avoids scalar reduction outside the subgroup.
[Generic scalar multiplication](https://github.com/keep-starknet-strange/garaga/blob/9b327b4ab3e1e2535df689765adb88b99762f739/hydra/garaga/points.py#L257).

## Lean correctness argument

Mathlib supplies a verified group law for nonsingular Weierstrass points and finite-field arithmetic.
Its pinned elliptic-curve directory contains no Edwards model or Tate-pairing implementation.
Therefore, a direct application of a library theorem does not close the subgroup-to-quartic bridge.
[Affine point group law](https://github.com/leanprover-community/mathlib4/blob/56a005855ea17e0b0958f73ec801ae140b0a1679/Mathlib/AlgebraicGeometry/EllipticCurve/Affine/Point.lean),
[Finite-field arithmetic](https://github.com/leanprover-community/mathlib4/blob/56a005855ea17e0b0958f73ec801ae140b0a1679/Mathlib/FieldTheory/Finite/Basic.lean).

A complete proof needs all of the following facts:

1. The concrete parameters define a field and the stated elliptic curve.
2. The coordinate maps preserve valid points and group operations, with explicit exceptional branches.
3. Every halving branch preserves the scaled equation and represents an actual half of the input.
4. The quartic condition characterizes divisibility by four for the resulting point.
5. One division followed by that condition characterizes divisibility by eight.
6. Divisibility by eight equals membership in the order-`ell` subgroup.
7. The mathematical formulas correspond to the emitted Cairo circuits and Boolean branches.

The [Lean package](../../tools/divide_and_pair/formal/README.md) now implements the elementary derivation in the next section.
It proves the concrete field and subgroup primes, the group order, both halving branches, and the quartic bridge.
Its final source theorems characterize acceptance on every Edwards point.
The models come from the Python AST, the Cairo compiler AST, and the production circuit IR.
The package records the translation and execution boundaries explicitly.

The EdDSA optimization also has an independent proof.
`cairo_source_small_order_correct` equates the extracted polynomial guard with three complete Edwards doublings.
The coordinate lemmas record the exceptional points and denominator conditions.

For an alternative division certificate, Cairo can require an on-curve point `Q` with `[8]Q = P`.
The finite-group cardinality `8*ell` gives soundness through `[ell]P = [8*ell]Q = O`.
Conversely, Bezout coefficients for eight and `ell` give completeness on the order-`ell` subgroup.
This certificate proves a division relation.
It does not prove equivalence of the quartic implementation without the fourth fact above.

## Derived elementary proof of the quartic bridge

This section gives derived formulas, rather than quotations from the paper or reference code.
The derivation uses the reference's curve model and inverse isogenies.
The identities admit direct polynomial proofs.
They do not require a Tate-pairing assumption.

### Curve model and positive doubling

The normalized curve has parameters:

```text
delta = -1 - d
A = -4 - 2*delta
B = delta^2
B_prime = A^2 - 4*B = 16*(1 + delta) = -16*d
```

A pair `(q, v)` represents the ordinary Weierstrass point `(q, q*v)` on:

```text
Y^2 = X^3 + A*X^2 + B*X
q*v^2 = q^2 + A*q + B
```

For nonexceptional `R = (q, v)`, positive doubling gives `P = 2*R = (u, w)` through:

```text
r = (q^2 - B)/(2*q*v)
u = r^2
w = q*(v^4 - B_prime)/(2*v*(q^2 - B))
```

The ordinary Weierstrass slope is:

```text
m = (3*q^2 + 2*A*q + B)/(2*q*v)
u = m^2 - A - 2*q
u*w = -q*v + m*(q - u)
```

Substitution of the curve equation equates these two descriptions.
In particular, the displayed `w` represents positive doubling, including its sign.

### The duplication identity

Define:

```text
f4(u, w) = u*(w + 2*i)^2
g(q, v) = ((q - delta)*v + 2*i*(q + delta))/(2*v)
```

For `P = 2*R`, the following identities hold:

```text
r*(w + 2*i) = g(q, v)^2/q
f4(P) = g(q, v)^4/q^2
```

There is a short polynomial certificate for the first identity.
Let:

```text
C = q*v^2 - q^2 - A*q - B
N = q*(v^4 - B_prime) + 4*i*v*(q^2 - B)
    - ((q - delta)*v + 2*i*(q + delta))^2
```

Expansion gives the exact ring identity:

```text
N = (v^2 - 4)*C - 4*(i^2 + 1)*(q + delta)^2
```

The curve equation gives `C = 0`, and the fixed constant gives `i^2 + 1 = 0`.
Division by `4*q*v^2` then proves the first identity.
Squaring proves the second identity.

### An ordinary half exists exactly when the input coordinate is a square

For a nonexceptional input `(u, w)`, let `rho^2 = 4*u`.
Define:

```text
t = 2*u + A - rho*w
```

The curve equation gives:

```text
t*rho^2 = t^2 - 2*A*t + B_prime
t_alt = B_prime/t = 2*u + A + rho*w
```

The two inverse-isogeny candidates are `(t, rho)` and `(t_alt, -rho)`.
Their first coordinates have product `B_prime`.
Since `B_prime` is a nonzero nonsquare, exactly one coordinate is a square in this finite field.
For a candidate `(t, rho)` with `v^2 = t`, define:

```text
q = (t - A - v*rho)/2
```

Then `(q, v)` lies on the normalized curve and doubles to `(u, w)`.
The same formulas apply to the alternate candidate, including the sign change on `rho`.
These claims follow from the displayed polynomial relations.
Conversely, the doubling formula gives `u = r^2` for every nonexceptional half.

This argument uses the finite-field square classes.
A nonzero product is a nonsquare exactly when one factor is a square and the other factor is a nonsquare.
Mathlib's `FiniteField.isSquare_iff` and quadratic-character multiplicativity provide these field facts.
[Pinned finite-field square criterion](https://github.com/leanprover-community/mathlib4/blob/56a005855ea17e0b0958f73ec801ae140b0a1679/Mathlib/FieldTheory/Finite/Basic.lean#L831),
[Pinned quadratic character](https://github.com/leanprover-community/mathlib4/blob/56a005855ea17e0b0958f73ec801ae140b0a1679/Mathlib/NumberTheory/LegendreSymbol/QuadraticChar/Basic.lean).

### A fourth power characterizes two successive divisions

Suppose that `f4(P) = z^4` is nonzero.
Then:

```text
u = (z^2/(w + 2*i))^2
```

Thus, the ordinary halving lemma supplies a half `R = (q, v)` of `P`.
The duplication identity gives:

```text
z^4*q^2 = g(q, v)^4
(z^2*q)^2 = (g(q, v)^2)^2
```

Equality of squares gives `q = (g/z)^2` or `q = -(g/z)^2`.
Both alternatives are squares because `-1 = i^2`.
Therefore, `R` also has a half.
This argument applies to every valid choice of the first half.

Conversely, suppose that `P = 2*R` and `R` has a half.
The doubling formula gives `q = s^2` for some nonzero `s`.
The duplication identity then gives:

```text
f4(P) = (g(q, v)/s)^4
```

Thus, `f4(P)` is a nonzero fourth power exactly when `P` admits two successive divisions by two.
For nonzero `f`, cyclicity of `Fp` units equates fourth powers with `f^((p-1)/4) = 1`.
This last equivalence is a finite-field theorem, rather than an elliptic-curve pairing theorem.

### Scales and the reference's alternate branch

A scaled triple `(U, W, e)` satisfies:

```text
U*W^2 = U^2 + A*e^2*U + B*e^4
u = U/e^2
w = W/e
```

The represented ordinary Weierstrass point is `(U/e^2, U*W/e^3)`.
Its scaled quartic input satisfies:

```text
U*(W + 2*i*e)^2 = e^4*f4(u, w)
```

Since `e` is nonzero, the fourth-power condition is unchanged.

In the reference's nonsquare branch, let `T^2 = 2*t_scaled` and `c^2 = 2*B_prime`.
The returned values use `e_new = e*T` and `W_new = -c*e^2`.
After normalization, the new second coordinate is `-c*e/T`.
Its square is `B_prime/(t_scaled/e^2)`.
The normalized inverse-isogeny coordinate also changes sign.
Therefore, this branch represents the alternate candidate from the ordinary halving lemma.
The minus sign on `W_new` is necessary for positive doubling.

### Exceptions and the outer subgroup argument

The formulas require `q != 0`, `v != 0`, `q^2 != B`, and nonzero scales.
The baseline algorithm handles pure eight-torsion before these formulas.
That branch includes the identity and all finite points of orders two, four, and eight.

The point `q = 0` is the finite two-torsion point in the ordinary Weierstrass model.
For nonzero `q`, the case `v = 0` requires a root of `q^2 + A*q + B`.
Its discriminant `B_prime` is a nonsquare, so that case has no rational solution.
The case `q = delta` gives order-four points with `v = +/-2*i`.
The case `q = -delta` requires `v^2 = 4*d`, which is impossible because `d` is a nonsquare.
Thus, `q^2 = B` gives only the order-four exceptions.

Likewise, `f4(P) = 0` requires `u = 0` or `w = -2*i`.
The latter case gives `u = delta` through `u*(w^2 + 4) = (u - delta)^2`.
These cases lie in the explicit torsion branch.
Halves and quarterpoints of a point outside pure eight-torsion also lie outside pure eight-torsion.
Otherwise, doubling their eightfold multiple gives a contradiction.
Consequently, the nonzero conditions hold throughout the quartic bridge.

The outer argument still needs the concrete finite-group facts.
For `|E(Fp)| = 8*ell`, divisibility by eight implies `[ell]P = O`.
Bezout coefficients for eight and `ell` prove the converse.
To cover an arbitrary first half, the rational two-torsion point must itself admit two successive divisions.
An explicit point of order eight proves that fact.
The reference supplies such a point in its coset tests.
[Reference order-eight point](https://github.com/yelhousni/crrl/blob/69cead92403999d2ce4a6ccc46d46462c8099402/src/ed25519.rs#L8787).

The concrete curve order also has an elementary proof route.
An order-`ell` generator and an order-eight point imply that `8*ell` divides the curve order.
Each `X` admits at most two `Y` values, so the curve has at most `2*p + 1` points.
For these parameters, `8*ell > p + 1` and `2*p + 1 < 2*(8*ell)`.
Therefore, the curve order equals `8*ell`.
This route still requires kernel-checked primality and point-order certificates.
It avoids an assumed curve order or a Hasse-bound theorem.

Symbolic expansion checked the polynomial certificate in this section.
Numerical checks also covered 48 mixed-order points across all eight torsion cosets.
Those checks compared positive doubling, the duplication identity, and the square-half condition.
They also covered nonzero scales `7`, `13`, and `-11`.
These checks support the derivation, but they do not replace the Lean proof.

## Correctness tests and benchmarks

The reference Rust tests include the identity, subgroup points, and all seven nonzero eight-torsion cosets.
The Go agreement test adds only the order-two torsion point to generated subgroup points.
Garaga needs the broader coverage for root choices, conversion exceptions, and mixed-order points.
[Rust coset coverage](https://github.com/yelhousni/crrl/blob/69cead92403999d2ce4a6ccc46d46462c8099402/src/ed25519.rs#L8787),
[Go agreement coverage](https://github.com/yelhousni/divide-and-pair/blob/ef2e77be1a4b39eee2f12aff1aebe39f789de263/curve25519/subgroup_membership_test.go#L71).

Two comparisons preserve the tested predicates:

- Full membership: generic `[ell]P` against one division and the quartic condition.
- Pure small order: the baseline doubling check against the direct Edwards polynomial condition.

The full test and pure small-order test require separate benchmark labels.
A comparison between them measures different acceptance policies.
Cairo steps, builtin counts, and gas need measurements from the same toolchain and inputs.
The Go CPU timings in the paper do not predict Cairo gas.
Rejected cosets, accepted points, and each halving branch need separate measurements.
