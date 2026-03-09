---
name: cairo-coding
description: Use when writing or optimizing Cairo functions — fixing slow loops, expensive arithmetic, integer splitting or limb assembly, modular reduction, storage slot packing, or BoundedInt type bounds
---

# Coding Cairo

Rules and patterns for writing efficient Cairo code. Sourced from audit findings and production profiling.

## When to Use

- Implementing arithmetic (modular, parity checks, quotient/remainder)
- Optimizing loops (slow iteration, repeated `.len()` calls, index-based access)
- Splitting or assembling integer limbs (u256 → u128, u32s → u128, felt252 → u96)
- Packing struct fields into storage slots
- Using `BoundedInt` for zero-overhead arithmetic with compile-time bounds
- Choosing integer types (u128 vs u256, BoundedInt vs native types)

**Not for:** Profiling/benchmarking (use benchmarking-cairo)

## Quick Reference — All Rules

| # | Rule | Instead of | Use |
|---|------|-----------|-----|
| 1 | Combined quotient+remainder | `x / m` + `x % m` | `DivRem::div_rem(x, m)` |
| 2 | Cheap loop conditions | `while i < n` | `while i != n` |
| 3 | Constant powers of 2 | `2_u32.pow(k)` | `match`-based lookup table |
| 4 | Pointer-based iteration | `*data.at(i)` in index loop | `pop_front` / `for` / `multi_pop_front` |
| 5 | Cache array length | `.len()` in loop condition | `let n = data.len();` before loop |
| 6 | Pointer-based slicing | Manual loop extraction | `span.slice(start, length)` |
| 7 | Cheap parity/halving | `index & 1`, `index / 2` | `DivRem::div_rem(index, 2)` |
| 8 | Smallest integer type | `u256` when range < 2^128 | `u128` (type encodes constraint) |
| 9 | Storage slot packing | One slot per field | `StorePacking` trait |
| 10 | BoundedInt for limbs | Bitwise ops / raw u128 math | `bounded_int::{div_rem, mul, add}` |
| 11 | Fast 2-input Poseidon | `poseidon_hash_span([x,y])` | `hades_permutation(x, y, 2)` |
| 12 | Bulk felt252→BoundedInt | `downcast` / `try_into` (4 steps) | `u128s_from_felt252` + `upcast` (2 steps) |

## Always / Never Rules

### 1. Always use `DivRem::div_rem` — never separate `%` and `/`

Cairo computes quotient and remainder in a single operation. Using both `%` and `/` on the same value doubles the cost.

```cairo
// BAD
let q = x / m;
let r = x % m;

// GOOD
let (q, r) = DivRem::div_rem(x, m);
```

### 2. Never use `<` or `>` in while loop conditions — use `!=`

Equality checks are cheaper than comparisons in Cairo.

```cairo
// BAD
while i < n { ... i += 1; }

// GOOD
while i != n { ... i += 1; }
```

### 3. Never compute `2^k` with `pow()` — use a lookup table

`u32::pow()` is expensive. Use a `match` lookup for known ranges.

```cairo
// BAD
let p = 2_u32.pow(depth.into());

// GOOD — match-based lookup
fn pow2(n: u32) -> u32 {
    match n {
        0 => 1, 1 => 2, 2 => 4, 3 => 8, 4 => 16, 5 => 32,
        6 => 64, 7 => 128, 8 => 256, 9 => 512, 10 => 1024,
        // extend as needed
        _ => core::panic_with_felt252('pow2 out of range'),
    }
}
```

### 4. Always iterate arrays with `pop_front` / `for` / `multi_pop_front` — never index-loop

Index-based access (`array.at(i)`) is more expensive than pointer-based iteration.

```cairo
// BAD
let mut i = 0;
while i != data.len() {
    let val = *data.at(i);
    i += 1;
}

// GOOD — pop_front
while let Option::Some(val) = data.pop_front() { ... }

// GOOD — for loop (equivalent)
for val in data { ... }

// GOOD — batch iteration
while let Option::Some(chunk) = data.multi_pop_front::<4>() { ... }
```

### 5. Never call `.len()` inside a loop condition — cache it

`.len()` recomputes every iteration. Store it once.

```cairo
// BAD
while i != data.len() { ... i += 1; }

// GOOD
let n = data.len();
while i != n { ... i += 1; }
```

### 6. Always use `span.slice()` instead of manual loop extraction

`slice()` manipulates pointers directly — no element-by-element copying.

```cairo
// BAD
let mut result: Array<felt252> = array![];
let mut i = 0;
while i != length {
    result.append(*data.at(start + i));
    i += 1;
}

// GOOD
let result = data.slice(start, length);
```

### 7. Always use `DivRem` for parity checks — never use bitwise ops

Bitwise AND is more expensive than `div_rem` in Cairo. Use `DivRem::div_rem(x, 2)` to get both the halved value and parity in one operation.

```cairo
// BAD
let is_odd = (index & 1) == 1;
index = index / 2;

// GOOD
let (q, r) = DivRem::div_rem(index, 2);
if r == 1 { /* odd branch */ }
index = q;
```

### 8. Always use the smallest integer type that fits the value range

`u128` instead of `u256` when the range is known. Adds clarity, prevents intermediate overflow.

```cairo
// BAD — u256 for a value known to be < 2^128
fn deposit(value: u256) { assert(value < MAX_U128, '...'); ... }

// GOOD — type encodes the constraint
fn deposit(value: u128) { ... }
```

### 9. Always use `StorePacking` to pack small fields into one storage slot

Multiple small fields (basis points, flags, bounded amounts) can share a single `felt252` slot.

```cairo
use starknet::storage_access::StorePacking;

const POW_2_128: felt252 = 0x100000000000000000000000000000000;

impl MyStorePacking of StorePacking<MyStruct, felt252> {
    fn pack(value: MyStruct) -> felt252 {
        value.amount.into() + value.fee_bps.into() * POW_2_128
    }
    fn unpack(value: felt252) -> MyStruct {
        let u256 { low, high } = value.into();
        MyStruct { amount: low, fee_bps: high.try_into().unwrap() }
    }
}
```

### 10. Always use BoundedInt for byte cutting, limb assembly, and type conversions

Never use bitwise ops (`&`, `|`, shifts) or raw `u128`/`u256` arithmetic for splitting or combining integer limbs. Use `bounded_int::div_rem` to extract parts and `bounded_int::mul` + `bounded_int::add` to assemble them. BoundedInt tracks bounds at compile time, eliminating overflow checks.

**Assembling limbs** (e.g., 4 x u32 → u128):

```cairo
// BAD — direct u128 arithmetic (28,340 gas)
fn u32s_to_u128(d0: u32, d1: u32, d2: u32, d3: u32) -> u128 {
    d0.into() + d1.into() * POW_2_32 + d2.into() * POW_2_64 + d3.into() * POW_2_96
}

// GOOD — BoundedInt (13,840 gas, 2x faster)
fn u32s_to_u128(d0: u32, d1: u32, d2: u32, d3: u32) -> u128 {
    let d0_bi: u32_bi = upcast(d0);
    let d1_bi: u32_bi = upcast(d1);
    let d2_bi: u32_bi = upcast(d2);
    let d3_bi: u32_bi = upcast(d3);
    let r: u128_bi = add(add(add(d0_bi, mul(d1_bi, POW_32_UI)), mul(d2_bi, POW_64_UI)), mul(d3_bi, POW_96_UI));
    upcast(r)
}
```

**Splitting values** (e.g., felt252 → two u96 limbs):

```cairo
// GOOD — div_rem to split, mul+add to reassemble
fn felt252_to_two_u96(value: felt252) -> (u96, u96) {
    match u128s_from_felt252(value) {
        U128sFromFelt252Result::Narrow(low) => {
            let (hi32, lo96) = bounded_int::div_rem(low, NZ_POW96_TYPED);
            (lo96, upcast(hi32))
        },
        U128sFromFelt252Result::Wide((high, low)) => {
            let (lo_hi32, lo96) = bounded_int::div_rem(low, NZ_POW96_TYPED);
            let hi64: BoundedInt<0, { POW64 - 1 }> = downcast(high).unwrap();
            (lo96, bounded_int::add(bounded_int::mul(hi64, POW32_TYPED), lo_hi32))
        },
    }
}
```

**Extracting bits** (e.g., building a 4-bit selector):

```cairo
// GOOD — div_rem by 2 extracts LSB, quotient is right-shifted value
let (qu1, bit0) = bounded_int::div_rem(u1, TWO_NZ);  // bit0 in {0,1}
let (qu2, bit1) = bounded_int::div_rem(u2, TWO_NZ);
let selector = add(bit0, mul(bit1, TWO_UI));  // selector in {0..3}
```

See [garaga/selectors.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/src/ec/selectors.cairo) and [cairo-perfs-snippets](https://github.com/feltroidprime/cairo-perfs-snippets) for production examples.

## Code Quality

- **DRY:** Extract repeated validation into helper functions. If two functions validate-then-write the same struct, extract a shared `_set_config()`.
- **`scarb fmt`:** Run before every commit.
- **`.tool-versions`:** Pin Scarb and Starknet Foundry versions with ASDF for reproducible builds.
- **Keep dependencies updated:** Newer Scarb/Foundry versions include gas optimizations and compiler improvements.

---

## BoundedInt Optimization

`BoundedInt<MIN, MAX>` encodes value constraints in the type system, eliminating runtime overflow checks. Use the CLI tool to compute bounds — do NOT calculate manually.

### Critical Architecture Decision: Avoid Downcast

**The #1 optimization pitfall:** Converting between `u16`/`u32`/`u64` and `BoundedInt` at function boundaries.

#### The Problem

If your functions take `u16` and return `u16`, you must:
1. `downcast` input to `BoundedInt` (expensive — requires range check)
2. Do bounded arithmetic (cheap)
3. `upcast` result back to `u16` (cheap but wasteful)

The `downcast` operation adds a range check that **dominates the savings** from bounded arithmetic. In profiling:
- `downcast`: 161,280 steps (18.86%)
- `bounded_int_div_rem`: 204,288 steps (23.89%)
- Total bounded approach: worse than original!

#### The Solution: BoundedInt Throughout

**Use `BoundedInt` types as function inputs AND outputs.** This eliminates downcast entirely.

```cairo
// BAD: Converts at every call (downcast overhead kills performance)
pub fn add_mod(a: u16, b: u16) -> u16 {
    let a: Zq = downcast(a).expect('overflow');  // EXPENSIVE
    let b: Zq = downcast(b).expect('overflow');  // EXPENSIVE
    let sum: ZqSum = add(a, b);
    let (_q, rem) = bounded_int_div_rem(sum, nz_q);
    upcast(rem)
}

// GOOD: BoundedInt in, BoundedInt out (no downcast)
pub fn add_mod(a: Zq, b: Zq) -> Zq {
    let sum: ZqSum = add(a, b);
    let (_q, rem) = bounded_int_div_rem(sum, nz_q);
    rem
}
```

#### Refactoring Strategy

When optimizing existing code:
1. **Identify the hot path** — profile to find which functions use modular arithmetic heavily
2. **Change signatures** — update function inputs/outputs to use `BoundedInt` types
3. **Propagate types outward** — callers must also use `BoundedInt`
4. **Downcast only at boundaries** — convert from u16/u32 only at system entry points (e.g., deserialization)

#### Type Conversion Rules

| From | To | Operation | Cost |
|------|-----|-----------|------|
| `u16` | `BoundedInt<0, 65535>` | `upcast` | Free (superset) |
| `u16` | `BoundedInt<0, 12288>` | `downcast` | **Expensive** (range check) |
| `BoundedInt<0, 12288>` | `u16` | `upcast` | Free (subset) |
| `BoundedInt<A, B>` | `BoundedInt<C, D>` where [A,B] ⊆ [C,D] | `upcast` | Free |
| `BoundedInt<A, B>` | `BoundedInt<C, D>` where [A,B] ⊄ [C,D] | `downcast` | **Expensive** |

**Key insight:** `upcast` only works when target range is a **superset** of source range. You cannot upcast `u32` to `BoundedInt<0, 150994944>` because `u32` max (4294967295) > 150994944.

### Prerequisites

```toml
# Scarb.toml
[dependencies]
corelib_imports = "0.1.2"
```

```cairo
// CORRECT imports — copy exactly
use corelib_imports::bounded_int::{
    BoundedInt, upcast, downcast, bounded_int_div_rem,
    AddHelper, MulHelper, DivRemHelper, UnitInt,
};
use corelib_imports::bounded_int::bounded_int::{SubHelper, add, sub, mul};
```

### Copy-Paste Template

Working example for modular arithmetic mod 100:

```cairo
use corelib_imports::bounded_int::{
    BoundedInt, upcast, downcast, bounded_int_div_rem,
    AddHelper, MulHelper, DivRemHelper, UnitInt,
};
use corelib_imports::bounded_int::bounded_int::{SubHelper, add, sub, mul};

type Val = BoundedInt<0, 99>;           // [0, 99]
type ValSum = BoundedInt<0, 198>;       // [0, 198]
type ValConst = UnitInt<100>;           // singleton {100}

impl AddValImpl of AddHelper<Val, Val> {
    type Result = ValSum;
}

impl DivRemValImpl of DivRemHelper<ValSum, ValConst> {
    type DivT = BoundedInt<0, 1>;
    type RemT = Val;
}

fn add_mod_100(a: Val, b: Val) -> Val {
    let sum: ValSum = add(a, b);
    let nz_100: NonZero<ValConst> = 100;
    let (_q, rem) = bounded_int_div_rem(sum, nz_100);
    rem
}
```

### CLI Tool

Use `bounded_int_calc.py` in this skill directory. **Always use CLI — never calculate manually.**

```bash
# Addition: [a_lo, a_hi] + [b_lo, b_hi]
python3 bounded_int_calc.py add 0 12288 0 12288
# -> BoundedInt<0, 24576>

# Subtraction: [a_lo, a_hi] - [b_lo, b_hi]
python3 bounded_int_calc.py sub 0 12288 0 12288
# -> BoundedInt<-12288, 12288>

# Multiplication
python3 bounded_int_calc.py mul 0 12288 0 12288
# -> BoundedInt<0, 150994944>

# Division: quotient and remainder bounds
python3 bounded_int_calc.py div 0 24576 12289 12289
# -> DivT: BoundedInt<0, 1>, RemT: BoundedInt<0, 12288>

# Custom impl name
python3 bounded_int_calc.py mul 0 12288 0 12288 --name MulZqImpl
```

### BoundedInt Bounds Quick Reference

| Operation | Formula |
|-----------|---------|
| Add | `[a_lo + b_lo, a_hi + b_hi]` |
| Sub | `[a_lo - b_hi, a_hi - b_lo]` |
| Mul (unsigned) | `[a_lo * b_lo, a_hi * b_hi]` |
| Div quotient | `[a_lo / b_hi, a_hi / b_lo]` |
| Div remainder | `[0, b_hi - 1]` |

### Negative Dividends: SHIFT Pattern

`bounded_int_div_rem` doesn't support negative lower bounds. When a subtraction produces a negative-bounded result that needs reduction, add a multiple of the modulus first:

```cairo
// sub_mod: (a - b) mod Q via SHIFT
pub fn sub_mod(a: Zq, b: Zq) -> Zq {
    let a_plus_q: BoundedInt<12289, 24577> = add(a, Q_CONST);  // shift by +Q
    let diff: BoundedInt<1, 24577> = sub(a_plus_q, b);           // now non-negative
    let (_q, rem) = bounded_int_div_rem(diff, nz_q());
    rem
}

// fused_sub_mul_mod: a - (b*c) mod Q via large SHIFT
// OFFSET = 12288 * Q = 151007232 (smallest multiple of Q >= max product)
pub fn fused_sub_mul_mod(a: Zq, b: Zq, c: Zq) -> Zq {
    let prod: ZqProd = mul(b, c);
    let a_offset: BoundedInt<151007232, 151019520> = add(a, OFFSET_CONST);
    let diff: BoundedInt<12288, 151019520> = sub(a_offset, prod);
    let (_q, rem) = bounded_int_div_rem(diff, nz_q());
    rem
}
```

Rule: SHIFT = `ceil(|min_possible_value| / modulus) * modulus`. Adding SHIFT preserves the result mod Q (since SHIFT ≡ 0 mod Q) while making all values non-negative.

### felt252 → BoundedInt: Prefer u128 Decomposition Over Downcast

`u128s_from_felt252` is a native VM operation (2 steps/call). `downcast` (used by `try_into()`) performs a range check (4 steps/call). When converting many felt252 values to BoundedInt, decompose to u128 first, then upcast to `BoundedInt<0, u128_max>`. You lose tight compile-time bounds but save 2 steps per conversion — significant at scale.

Benchmarked per-call costs (isolated loop, 512 iterations, varying input):

| Libfunc | Steps/call | Source |
|---------|-----------|--------|
| `u128s_from_felt252` | 2 | 1,024 flat / 512 calls |
| `downcast` (try_into) | 4 | 2,048 flat / 512 calls |
| `bounded_int_div_rem` | 7 | 3,584 flat / 512 calls (same both) |

| Approach | Per-conversion cost | Sierra bloat | Notes |
|----------|-------------------|--------------|-------|
| `try_into().unwrap()` | 4 steps (downcast) | **O(N^2)** — panic drops all live vars | Never in unrolled code |
| `match try_into() { Some/None }` | 4 steps (downcast) | OK | No panic but pays downcast cost |
| `u128s_from_felt252` + `upcast` | 2 steps | OK | **Preferred** — native decomposition |

End-to-end impact (512-point NTT verify): u128 approach saves 1,024 steps / ~1.6M L2 gas (4.4%) vs match-based downcast.

```cairo
use corelib_imports::integer::{U128sFromFelt252Result, u128s_from_felt252};

type U128AsBounded = BoundedInt<0, 340282366920938463463374607431768211455>;

#[inline(always)]
fn felt252_as_u128(x: felt252) -> u128 {
    match u128s_from_felt252(x) {
        U128sFromFelt252Result::Narrow(low) => low,
        U128sFromFelt252Result::Wide((_, low)) => low,
    }
}

// Convert felt252 to BoundedInt via u128 (no range-check overhead)
let r: U128AsBounded = upcast(felt252_as_u128(value + SHIFT));
let (_, r) = bounded_int_div_rem(r, NZ_Q);  // DivRemHelper<U128AsBounded, QConst>
```

**Trade-off:** `U128AsBounded` has max=2^128-1 instead of the tight shifted bound. The `DivRemHelper` quotient type is wider, but `bounded_int_div_rem` cost is the same. Fine for most cases — only matters if downstream code needs tight bounds on the quotient.

**When to use which:**
- **Bulk conversions (generated/unrolled code):** Always `u128s_from_felt252` + `upcast`
- **One-off boundary conversions (deserialization):** `downcast` is fine — per-call overhead negligible
- **Never in hot paths:** `try_into().unwrap()` — panic path causes quadratic Sierra bloat

### Common BoundedInt Mistakes

- **Downcast at every function call** — the biggest performance killer. Use `BoundedInt` types throughout, not just inside arithmetic functions.
- **Trying to upcast to a narrower type** — `upcast(val: u32)` to `BoundedInt<0, 150994944>` fails because u32 max > 150994944.
- **Wrong imports** — use exact imports from Prerequisites section above.
- **Wrong subtraction bounds** — it's `[a_lo - b_hi, a_hi - b_lo]`, NOT `[a_lo - b_lo, a_hi - b_hi]`.
- **Negative dividend in `bounded_int_div_rem`** — div_rem doesn't support negative lower bounds. Add a SHIFT (multiple of modulus) before reducing. See SHIFT pattern above.
- **Missing intermediate types** — always annotate: `let sum: ZqSum = add(a, b);`
- **Division quotient off-by-one** — integer division floors: `24576 / 12289 = 1`, not 2.
- **Using `UnitInt` vs `BoundedInt` for constants** — use `UnitInt<N>` for singleton constants like divisors.
- **Using `div_rem` vs `bounded_int_div_rem`** — the function is `bounded_int_div_rem`, not `div_rem`.
- **Bounds exceed u128::max** — BoundedInt bounds are hard-capped at 2^128. Larger values crash the Sierra specializer: 'Provided generic argument is unsupported.'
- **Using `downcast`/`try_into` for bulk felt252 → BoundedInt** — use `u128s_from_felt252` + `upcast` instead (2 vs 4 steps/call). See "felt252 → BoundedInt" section above.
