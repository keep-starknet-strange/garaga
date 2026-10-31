module

public import Mathlib.Algebra.Field.ZMod
public import Honk.Relations
public import Honk.Batching

@[expose] public section

namespace Honk
noncomputable section

def solidityRelations (p : Nat → Fr) (beta gamma delta eta rom domain : Fr) : List Fr :=
  [solidity_0 p beta gamma delta eta rom domain,
    solidity_1 p beta gamma delta eta rom domain,
    solidity_2 p beta gamma delta eta rom domain,
    solidity_3 p beta gamma delta eta rom domain,
    solidity_4 p beta gamma delta eta rom domain,
    solidity_5 p beta gamma delta eta rom domain,
    solidity_6 p beta gamma delta eta rom domain,
    solidity_7 p beta gamma delta eta rom domain,
    solidity_8 p beta gamma delta eta rom domain,
    solidity_9 p beta gamma delta eta rom domain,
    solidity_10 p beta gamma delta eta rom domain,
    solidity_11 p beta gamma delta eta rom domain,
    solidity_12 p beta gamma delta eta rom domain,
    solidity_13 p beta gamma delta eta rom domain,
    solidity_14 p beta gamma delta eta rom domain,
    solidity_15 p beta gamma delta eta rom domain,
    solidity_16 p beta gamma delta eta rom domain,
    solidity_17 p beta gamma delta eta rom domain,
    solidity_18 p beta gamma delta eta rom domain,
    solidity_19 p beta gamma delta eta rom domain,
    solidity_20 p beta gamma delta eta rom domain,
    solidity_21 p beta gamma delta eta rom domain,
    solidity_22 p beta gamma delta eta rom domain,
    solidity_23 p beta gamma delta eta rom domain,
    solidity_24 p beta gamma delta eta rom domain,
    solidity_25 p beta gamma delta eta rom domain,
    solidity_26 p beta gamma delta eta rom domain,
    solidity_27 p beta gamma delta eta rom domain,
    solidity_28 p beta gamma delta eta rom domain,
    solidity_29 p beta gamma delta eta rom domain,
    solidity_30 p beta gamma delta eta rom domain]

def cairoRelations (p : Nat → Fr) (beta gamma delta eta rom domain : Fr) : List Fr :=
  [cairo_0 p beta gamma delta eta rom domain,
    cairo_1 p beta gamma delta eta rom domain,
    cairo_2 p beta gamma delta eta rom domain,
    cairo_3 p beta gamma delta eta rom domain,
    cairo_4 p beta gamma delta eta rom domain,
    cairo_5 p beta gamma delta eta rom domain,
    cairo_6 p beta gamma delta eta rom domain,
    cairo_7 p beta gamma delta eta rom domain,
    cairo_8 p beta gamma delta eta rom domain,
    cairo_9 p beta gamma delta eta rom domain,
    cairo_10 p beta gamma delta eta rom domain,
    cairo_11 p beta gamma delta eta rom domain,
    cairo_12 p beta gamma delta eta rom domain,
    cairo_13 p beta gamma delta eta rom domain,
    cairo_14 p beta gamma delta eta rom domain,
    cairo_15 p beta gamma delta eta rom domain,
    cairo_16 p beta gamma delta eta rom domain,
    cairo_17 p beta gamma delta eta rom domain,
    cairo_18 p beta gamma delta eta rom domain,
    cairo_19 p beta gamma delta eta rom domain,
    cairo_20 p beta gamma delta eta rom domain,
    cairo_21 p beta gamma delta eta rom domain,
    cairo_22 p beta gamma delta eta rom domain,
    cairo_23 p beta gamma delta eta rom domain,
    cairo_24 p beta gamma delta eta rom domain,
    cairo_25 p beta gamma delta eta rom domain,
    cairo_26 p beta gamma delta eta rom domain,
    cairo_27 p beta gamma delta eta rom domain,
    cairo_28 p beta gamma delta eta rom domain,
    cairo_29 p beta gamma delta eta rom domain,
    cairo_30 p beta gamma delta eta rom domain]

theorem all_relations_equal (p : Nat → Fr) (beta gamma delta eta rom domain : Fr) :
    solidityRelations p beta gamma delta eta rom domain = cairoRelations p beta gamma delta eta rom domain := by
  simp only [solidityRelations, cairoRelations, relation_0, relation_1, relation_2, relation_3, relation_4, relation_5, relation_6, relation_7, relation_8, relation_9, relation_10, relation_11, relation_12, relation_13, relation_14, relation_15, relation_16, relation_17, relation_18, relation_19, relation_20, relation_21, relation_22, relation_23, relation_24, relation_25, relation_26, relation_27, relation_28, relation_29, relation_30]

/-- The weights are 1, alpha, ..., alpha^30, in source subrelation order. -/
def batchRelations (alpha : Fr) : List Fr → Fr
  | [] => 0
  | relation :: rest => relation + alpha * batchRelations alpha rest

def solidityFinalCheck (relations : List Fr) (alpha mask libra challenge target : Fr) : Prop :=
  batchRelations alpha relations * mask + libra * challenge = target

def cairoFinalCheck (relations : List Fr) (alpha mask libra challenge target : Fr) : Prop :=
  batchRelations alpha relations * mask + libra * challenge - target = 0

/-- This theorem proves the relation checks, with the source models as its operands. -/
theorem final_relation_check_equivalence (p : Nat → Fr)
    (beta gamma delta eta rom domain alpha mask libra challenge target : Fr) :
    solidityFinalCheck (solidityRelations p beta gamma delta eta rom domain) alpha mask libra challenge target ↔
      cairoFinalCheck (cairoRelations p beta gamma delta eta rom domain) alpha mask libra challenge target := by
  rw [all_relations_equal]
  exact sub_eq_zero.symm

/-- The backend premise represents the remaining stages. Their source refinements are not proved in this package. -/
theorem conditional_math_verifier_equivalence
    [Fact (Nat.Prime 21888242871839275222246405745257275088548364400416034343698204186575808495617)]
    (p : Nat → Fr) (beta gamma delta eta rom domain alpha mask libra challenge target rho : Fr)
    (n : Nat) (residuals : Nat → Fr) (solidityBackend cairoBackend : Prop)
    (backendCompatibility : solidityBackend ↔ cairoBackend)
    (binding : batchBinding n residuals rho) :
    (exactRounds n residuals ∧ solidityFinalCheck (solidityRelations p beta gamma delta eta rom domain) alpha mask libra challenge target ∧ solidityBackend) ↔
      (batchRounds n residuals rho ∧ cairoFinalCheck (cairoRelations p beta gamma delta eta rom domain) alpha mask libra challenge target ∧ cairoBackend) := by
  rw [conditional_round_equivalence n residuals rho binding,
      final_relation_check_equivalence, backendCompatibility]

end
end Honk
