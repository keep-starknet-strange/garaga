module

public import Honk.Field
public import Mathlib.Algebra.Module.Basic
public import Mathlib.Algebra.BigOperators.Group.Finset.Basic

@[expose] public section

namespace Honk
open scoped BigOperators

/-- Infinity is the zero element of the abstract curve group. -/
theorem remove_identity_commitments {I G : Type*} [AddCommGroup G] [DecidableEq G] [Module Fr G]
    (indices : Finset I) (scalars : I → Fr) (points : I → G) :
    ∑ i ∈ indices, scalars i • points i =
      ∑ i ∈ indices.filter (fun i => points i ≠ 0), scalars i • points i := by
  classical
  rw [Finset.sum_filter]
  apply Finset.sum_congr rfl
  intro i _
  by_cases h : points i = 0 <;> simp [h]

/-- This proves the coordinate value and u128 bounds, independently of a serialization runtime. -/
theorem compact_coordinate (x : Nat) (hx : x < 2^256) :
    x % 2^128 + 2^128 * (x / 2^128) = x ∧
      x % 2^128 < 2^128 ∧ x / 2^128 < 2^128 := by
  refine ⟨Nat.mod_add_div x _, Nat.mod_lt x (by decide), ?_⟩
  exact (Nat.div_lt_iff_lt_mul (by decide)).mpr hx

/-- Correct GLV hints must realize the same scalar multiplication as the curve model. -/
theorem recursive_accumulator_equivalence {G : Type*} [AddCommGroup G] [Module Fr G]
    (hintResult outer inner : G) (separator : Fr)
    (hintCorrect : hintResult = separator • outer) :
    hintResult + inner = inner + separator • outer := by
  rw [hintCorrect, add_comm]

end Honk
