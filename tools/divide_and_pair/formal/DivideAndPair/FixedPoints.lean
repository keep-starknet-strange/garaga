module

public import DivideAndPair.Curve
public import DivideAndPair.CardBound
public import Mathlib.GroupTheory.OrderOfElement

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192
set_option maxHeartbeats 1000000

abbrev EdGroup := (montgomeryCurve montgomeryDelta).toAffine.Point

noncomputable def witnessPoint (x y : Fp)
    (curve : y^2 = x^3+(-4-2*montgomeryDelta)*x^2+montgomeryDelta^2*x)
    (hy : y ≠ 0) : EdGroup :=
  .some x y (by
    refine ⟨?_, Or.inr ?_⟩
    · rw [WeierstrassCurve.Affine.equation_iff]
      simpa [montgomeryCurve] using curve
    · rw [WeierstrassCurve.Affine.evalEval_polynomialY]
      simpa [montgomeryCurve] using mul_ne_zero ed25519_two_nonzero hy)

noncomputable def generatorWitness : EdGroup := witnessPoint
  13514914299923632182470203447272636853930929078332720970873682225965926367690
  35369001153501087986156285612966153821629765263434357947020144546898839136454
  (by decide) (by decide)

noncomputable def torsionWitness : EdGroup := witnessPoint
  57808483608876531731672722078716205470754696008478603492116840778863973826129
  7210693981938505079801534392114273343858119125566402083798290009946127002276
  (by decide) (by decide)

theorem binary_smul_correct {G : Type*} [AddMonoid G] (n : Nat) (point : G) :
    nsmulBinRec n point = n • point := by
  induction n with
  | zero => simp only [nsmulBinRec_zero, zero_nsmul]
  | succ n ih => rw [nsmulBinRec_succ, ih, succ_nsmul]

theorem torsion_eight : (8 : Nat) • torsionWitness = 0 := by
  rw [← binary_smul_correct]
  decide +kernel

theorem torsion_four_nonzero : (4 : Nat) • torsionWitness ≠ 0 := by
  rw [← binary_smul_correct]
  decide +kernel

theorem generator_nonzero : generatorWitness ≠ 0 := by decide

theorem generator_order_multiple : subgroupOrder • generatorWitness = 0 := by
  rw [← binary_smul_correct]
  decide +kernel

theorem generator_order : addOrderOf generatorWitness = subgroupOrder :=
  addOrderOf_eq_prime generator_order_multiple generator_nonzero

theorem torsion_order : addOrderOf torsionWitness = 8 := by
  have h := addOrderOf_eq_prime_pow (p := 2) (n := 2) torsion_four_nonzero torsion_eight
  exact h

theorem full_order_witness : addOrderOf (generatorWitness+torsionWitness) = 8*subgroupOrder := by
  have commute : AddCommute generatorWitness torsionWitness := add_comm _ _
  have coprime : (addOrderOf generatorWitness).Coprime (addOrderOf torsionWitness) := by
    rw [generator_order, torsion_order]
    decide
  rw [commute.addOrderOf_add_eq_mul_addOrderOf_of_coprime coprime, generator_order, torsion_order,
    Nat.mul_comm]

noncomputable instance edGroupFintype : Fintype EdGroup := affine_point_fintype _

theorem ed25519_group_card : Nat.card EdGroup = 8*subgroupOrder := by
  have divides : 8*subgroupOrder ∣ Nat.card EdGroup := by
    rw [← full_order_witness, Nat.card_eq_fintype_card]
    exact addOrderOf_dvd_card
  have lower : 8*subgroupOrder ≤ Nat.card EdGroup := by
    rw [← full_order_witness]
    exact addOrderOf_le_card
  have upper := weierstrass_point_card_bound (montgomeryCurve montgomeryDelta)
  change Nat.card EdGroup ≤ _ at upper
  simp only [ZMod.card] at upper
  obtain ⟨k, hk⟩ := divides
  have hk_lower : 1 ≤ k := by
    rw [hk] at lower
    exact (Nat.le_mul_iff_le_right (by decide : 0 < 8*subgroupOrder)).mp lower
  have hk_upper : k < 2 := by
    have less : Nat.card EdGroup < 2*(8*subgroupOrder) :=
      upper.trans_lt (by decide)
    rw [hk] at less
    exact (Nat.mul_lt_mul_left (by decide : 0 < 8*subgroupOrder)).mp less
  have hk_one : k = 1 := by omega
  simpa only [hk_one, Nat.mul_one] using hk

end DivideAndPair
