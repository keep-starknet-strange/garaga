module

public import DivideAndPair.FixedPoints
public import Mathlib.GroupTheory.SpecificGroups.Cyclic.Subgroup

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192

theorem eight_divisibility {G : Type*} [AddCommGroup G] (order k : Nat)
    (inverse : 8*k = 3*order+1) (annihilator : ∀ root : G, (8*order) • root = 0)
    (point : G) : order • point = 0 ↔ ∃ root : G, (8 : Nat) • root = point := by
  constructor
  · intro member
    refine ⟨k • point, ?_⟩
    calc
      (8 : Nat) • (k • point) = (8*k) • point := by rw [← mul_nsmul, Nat.mul_comm]
      _ = (3*order+1) • point := by rw [inverse]
      _ = 3 • (order • point)+point := by
        rw [add_nsmul, one_nsmul, Nat.mul_comm 3 order, mul_nsmul]
      _ = point := by rw [member, nsmul_zero, zero_add]
  · rintro ⟨root, rfl⟩
    calc
      order • ((8 : Nat) • root) = (8*order) • root := by rw [← mul_nsmul, Nat.mul_comm]
      _ = 0 := annihilator root

theorem subgroup_iff_eight_divisible (point : EdGroup) :
    subgroupOrder • point = 0 ↔ ∃ root : EdGroup, (8 : Nat) • root = point := by
  apply eight_divisibility subgroupOrder ((3*subgroupOrder+1)/8) (by decide)
  intro root
  rw [← ed25519_group_card]
  exact card_nsmul_eq_zero'

theorem every_half_of_eight_multiple {G : Type*} [AddCommGroup G] [IsAddCyclic G]
    (card_eight : 8 ∣ Nat.card G) (H R : G)
    (equation : (2 : Nat) • H = (8 : Nat) • R) :
    ∃ Q : G, (4 : Nat) • Q = H := by
  obtain ⟨g, hg⟩ := IsAddCyclic.exists_generator (α := G)
  obtain ⟨n, rfl⟩ := AddSubgroup.mem_zmultiples_iff.mp (hg H)
  obtain ⟨m, rfl⟩ := AddSubgroup.mem_zmultiples_iff.mp (hg R)
  have order_eight : (8 : Int) ∣ (addOrderOf g : Int) := by
    rw [addOrderOf_eq_card_of_forall_mem_zmultiples hg]
    exact Int.natCast_dvd_natCast.mpr card_eight
  have equation' : (2*n : Int) • g = (8*m : Int) • g := by
    simpa only [mul_zsmul, ofNat_zsmul] using equation
  have order_divides : (addOrderOf g : Int) ∣ 2*n-8*m :=
    addOrderOf_dvd_sub_iff_zsmul_eq_zsmul.mpr equation'
  obtain ⟨k, hk⟩ := order_eight.trans order_divides
  have n_four : (4 : Int) ∣ n := by
    refine ⟨m+k, ?_⟩
    omega
  obtain ⟨q, hq⟩ := n_four
  refine ⟨q • g, ?_⟩
  calc
    (4 : Nat) • (q • g) = (4*q : Int) • g := by
      simp only [mul_zsmul, ofNat_zsmul]
    _ = n • g := by rw [hq]

theorem ed25519_every_half_of_eight_multiple (H R : EdGroup)
    (equation : (2 : Nat) • H = (8 : Nat) • R) :
    ∃ Q : EdGroup, (4 : Nat) • Q = H := by
  let : IsAddCyclic EdGroup := isAddCyclic_of_addOrderOf_eq_card
    (generatorWitness+torsionWitness) (full_order_witness.trans ed25519_group_card.symm)
  apply every_half_of_eight_multiple _ H R equation
  rw [ed25519_group_card]
  exact dvd_mul_right 8 subgroupOrder

end DivideAndPair
