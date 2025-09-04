# Corelib Imports

This package provides controlled access to non-public functions, structs, and traits from the Cairo Corelib library through selective re-exports.

## Overview

The package leverages Cairo edition 2023_10 to access internal Cairo Corelib components that are not part of the standard public API. These utilities expose performance-critical operations for cryptographic computations, particularly optimized bounded integer arithmetic and circuit operations used throughout the Garaga ecosystem.

## Visibility Rules and Architecture

Cairo's visibility system restricts access to internal modules by default. This package uses feature flags (e.g., `#[feature("bounded-int-utils")]`) to expose specific internal APIs that would otherwise be inaccessible. The approach follows established patterns in the Cairo ecosystem, similar to the [Stwo Cairo verifier's bounded integer utilities](https://github.com/starkware-libs/stwo-cairo/blob/a9cc98cc78f39e30a5aea71af7421a09f764df0a/stwo_cairo_verifier/crates/bounded_int/src/lib.cairo).

## Exported Modules

### `bounded_int`
Re-exports core bounded integer utilities with compile-time guarantees:
- `BoundedInt<T>`: Type-safe integer arithmetic with compile-time bounds
- `AddHelper`, `MulHelper`, `DivRemHelper`: Optimized arithmetic operations
- `upcast`, `downcast`: Safe type conversions between integer bounds
- `bounded_int_div_rem`: Efficient division with remainder operations

### `circuit`
Circuit construction and optimization utilities:
- `CircuitData`, `CircuitDefinition`: Circuit representation types
- `u384`, `u96`: Extended precision integer types for cryptographic operations
- `AddInputResult`: Circuit input accumulation
- `conversions`: Specialized arithmetic helpers for multi-precision operations

### `integer`
Extended integer operations:
- `u128s_from_felt252`: Efficient felt252 to u128 conversion utilities
- `U128sFromFelt252Result`: Result type for safe conversions

### `array` & `keccak`
Utility functions:
- `array_slice`: Efficient array slicing operations
- `cairo_keccak`, `keccak_add_u256_be`: Keccak hash operations

## Usage Examples

### Bounded Integer Arithmetic
```cairo
use corelib_imports::bounded_int::{BoundedInt, DivRemHelper, bounded_int_div_rem};

// Efficient division with compile-time bounds checking
let result = bounded_int_div_rem(dividend, divisor);
```

### Circuit Operations
```cairo
use corelib_imports::circuit::conversions::{
    DivRemU96By32, NZ_POW64_TYPED, POW32, UnitInt
};

// High-precision arithmetic for cryptographic circuits
let quotient = DivRemU96By32::div_rem(value, NZ_POW32_TYPED);
```

### Type Conversions
```cairo
use corelib_imports::bounded_int::{downcast, upcast};
use corelib_imports::integer::{u128s_from_felt252};

// Safe conversions between integer types
let converted = upcast(bounded_value);
let (low, high) = u128s_from_felt252(felt_value);
```

These utilities are extensively used across Garaga's elliptic curve operations, finite field arithmetic, and cryptographic circuit implementations for optimal performance.
