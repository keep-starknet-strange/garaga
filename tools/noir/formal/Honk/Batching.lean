module

public import Mathlib.Algebra.Polynomial.Roots
public import Mathlib.Algebra.Polynomial.BigOperators
public import Mathlib.Tactic.Ring
public import Mathlib.Data.Rat.Cast.Order

@[expose] public section

namespace Honk
noncomputable section
open scoped BigOperators
open Polynomial

section Batching
variable {F : Type*} [Field F]

/-- The Cairo source starts the weights at rho, rather than at one. -/
def residualPolynomial (n : Nat) (e : Nat → F) : F[X] :=
  ∑ i ∈ Finset.range n, monomial (i + 1) (e i)

def exactRounds (n : Nat) (e : Nat → F) : Prop :=
  ∀ i < n, e i = 0

def batchRounds (n : Nat) (e : Nat → F) (rho : F) : Prop :=
  (residualPolynomial n e).eval rho = 0

/-- This premise is explicit. It is not a theorem about the concrete Poseidon transcript. -/
def batchBinding (n : Nat) (e : Nat → F) (rho : F) : Prop :=
  batchRounds n e rho → exactRounds n e

theorem exact_implies_batch (n : Nat) (e : Nat → F) (rho : F)
    (h : exactRounds n e) : batchRounds n e rho := by
  simp only [batchRounds, residualPolynomial, eval_finsetSum, eval_monomial]
  apply Finset.sum_eq_zero
  intro i hi
  simp [h i (Finset.mem_range.mp hi)]

theorem conditional_round_equivalence (n : Nat) (e : Nat → F) (rho : F)
    (binding : batchBinding n e rho) : exactRounds n e ↔ batchRounds n e rho :=
  ⟨exact_implies_batch n e rho, binding⟩

/-- The vector depends on rho. This disproves an unconditional algebraic converse, not Fiat-Shamir security. -/
theorem cancelling_nonzero_residuals (rho : F) :
    let e : Nat → F := fun i => if i = 0 then -rho else 1
    batchRounds 2 e rho ∧ ¬exactRounds 2 e := by
  dsimp
  constructor
  · simp [batchRounds, residualPolynomial, Finset.sum_range_succ]
    ring
  · intro h
    have h1 := h 1 (by decide)
    exact one_ne_zero h1

theorem residual_coefficient (n : Nat) (e : Nat → F) (i : Nat) (hi : i < n) :
    (residualPolynomial n e).coeff (i + 1) = e i := by
  classical
  simp [residualPolynomial, finsetSum_coeff, coeff_monomial, hi]

theorem residual_polynomial_nonzero (n : Nat) (e : Nat → F)
    (h : ¬exactRounds n e) : residualPolynomial n e ≠ 0 := by
  intro hz
  apply h
  intro i hi
  have he := residual_coefficient n e i hi
  simpa [hz] using he.symm

theorem residual_degree_bound (n : Nat) (e : Nat → F) :
    (residualPolynomial n e).natDegree ≤ n := by
  apply natDegree_sum_le_of_forall_le
  intro i hi
  exact (natDegree_monomial_le _).trans (Nat.succ_le_of_lt (Finset.mem_range.mp hi))

/-- A counting theorem for a fixed vector. Uniformity and independence are separate assumptions. -/
theorem bad_challenge_count [DecidableEq F] (n : Nat) (e : Nat → F) (samples : Finset F)
    (bad : ¬exactRounds n e) :
    (samples.filter fun rho => (residualPolynomial n e).eval rho = 0).card ≤ n := by
  classical
  have hp := residual_polynomial_nonzero n e bad
  apply le_trans (card_le_degree_of_subset_roots (p := residualPolynomial n e) ?_) (residual_degree_bound n e)
  intro rho hrho
  exact (mem_roots hp).mpr (Finset.mem_filter.mp hrho).2

/-- For a uniform sample set, the counting bound gives this failure fraction. -/
theorem uniform_failure_fraction [DecidableEq F] (n : Nat) (e : Nat → F) (samples : Finset F)
    (_nonempty : samples.Nonempty) (bad : ¬exactRounds n e) :
    ((samples.filter fun rho => (residualPolynomial n e).eval rho = 0).card : ℚ) / samples.card ≤
      (n : ℚ) / samples.card := by
  exact div_le_div_of_nonneg_right (by exact_mod_cast bad_challenge_count n e samples bad)
    (by exact_mod_cast Nat.zero_le samples.card)

/-- Common checks stand for the remaining verifier stages, whose source refinements are separate obligations. -/
theorem conditional_acceptance_equivalence (n : Nat) (e : Nat → F) (rho : F)
    (commonChecks : Prop) (binding : batchBinding n e rho) :
    (exactRounds n e ∧ commonChecks) ↔ (batchRounds n e rho ∧ commonChecks) := by
  rw [conditional_round_equivalence n e rho binding]

end Batching
end
end Honk
