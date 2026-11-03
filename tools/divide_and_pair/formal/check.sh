#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"
export MATHLIB_NO_CACHE_ON_UPDATE=1
lake exe cache get \
    Mathlib.Tactic.FieldSimp \
    Mathlib.Tactic.LinearCombination \
    Mathlib.Algebra.Field.ZMod \
    Mathlib.AlgebraicGeometry.EllipticCurve.Affine.Point \
    Mathlib.GroupTheory.SpecificGroups.Cyclic.Subgroup \
    Mathlib.Data.Fintype.Option \
    Mathlib.Data.Fintype.Prod \
    Mathlib.NumberTheory.LucasPrimality \
    Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic
lake build
lake env lean Audit.lean
