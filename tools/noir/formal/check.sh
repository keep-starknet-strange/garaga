#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
export MATHLIB_NO_CACHE_ON_UPDATE=1
lake exe cache get \
    Mathlib.Tactic.Ring \
    Mathlib.Data.ZMod.Basic \
    Mathlib.Algebra.Field.ZMod \
    Mathlib.Algebra.Polynomial.Roots \
    Mathlib.Algebra.Polynomial.BigOperators \
    Mathlib.Algebra.Module.Basic \
    Mathlib.Algebra.BigOperators.Group.Finset.Basic \
    Mathlib.Data.Rat.Cast.Order
lake build
lake env lean Audit.lean
