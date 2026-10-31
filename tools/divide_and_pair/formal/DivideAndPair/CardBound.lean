module

public import Mathlib.AlgebraicGeometry.EllipticCurve.Affine.Point
public import Mathlib.FieldTheory.Finite.Basic
public import Mathlib.Data.Fintype.Option
public import Mathlib.Data.Fintype.Prod

@[expose] public section

open WeierstrassCurve

namespace DivideAndPair

variable {F : Type*} [Field F]

lemma normalized_xRep (W : WeierstrassCurve.Affine F)
    (P : W.Point) (hP : P ≠ 0) :
    P.xRep = ![P.xRep 0, 1] := by
  cases P with
  | zero => exact (hP rfl).elim
  | some x y h => rfl

@[instance_reducible]
noncomputable def affine_point_fintype [Fintype F] (W : WeierstrassCurve.Affine F) :
    Fintype W.Point := by
  classical
  let : Fintype {xy : F × F // W.Nonsingular xy.fst xy.snd} := Fintype.ofFinite _
  let : Fintype (WithZero {xy : F × F // W.Nonsingular xy.fst xy.snd}) := by
    change Fintype (Option {xy : F × F // W.Nonsingular xy.fst xy.snd})
    infer_instance
  exact Fintype.ofEquiv
    (WithZero {xy : F × F // W.Nonsingular xy.fst xy.snd})
    W.nonsingularPointEquiv.symm

theorem affine_point_card_bound [Fintype F] (W : WeierstrassCurve.Affine F) :
    Nat.card W.Point ≤ 2 * Fintype.card F + 1 := by
  classical
  let : Fintype W.Point := affine_point_fintype W
  let s : Finset W.Point := Finset.univ.erase 0
  have hfiber : ∀ x ∈ (Finset.univ : Finset F),
      (s.filter fun P => P.xRep 0 = x).card ≤ 2 := by
    intro x _
    by_cases empty : (s.filter fun P => P.xRep 0 = x) = ∅
    · simp [empty]
    obtain ⟨Q, hQ⟩ := Finset.nonempty_iff_ne_empty.mpr empty
    have hQ' := Finset.mem_filter.mp hQ
    have hQ0 : Q ≠ 0 := (Finset.mem_erase.mp hQ'.1).1
    have subset : (s.filter fun P => P.xRep 0 = x) ⊆ {Q, -Q} := by
      intro P hP
      obtain ⟨hPs, hPx⟩ := Finset.mem_filter.mp hP
      have hP0 : P ≠ 0 := (Finset.mem_erase.mp hPs).1
      have reps : P.xRep = Q.xRep := by
        rw [normalized_xRep W P hP0, normalized_xRep W Q hQ0, hPx, hQ'.2]
      have alternatives := WeierstrassCurve.Affine.Point.eq_or_eq_neg_of_xRep_eq_xRep reps
      simpa only [Finset.mem_insert, Finset.mem_singleton] using alternatives
    exact (Finset.card_le_card subset).trans Finset.card_le_two
  have bound : s.card ≤ 2 * Fintype.card F := by
    simpa only [Finset.card_univ] using
      (Finset.card_le_mul_card_image_of_maps_to
        (f := fun P : W.Point => P.xRep 0)
        (s := s) (t := Finset.univ) (fun _ _ => Finset.mem_univ _) 2 hfiber)
  have total : s.card + 1 = Fintype.card W.Point := by
    simpa only [s, Finset.card_univ] using
      (Finset.card_erase_add_one (a := (0 : W.Point)) (s := Finset.univ)
        (Finset.mem_univ 0))
  rw [Nat.card_eq_fintype_card, ← total]
  exact Nat.add_le_add_right bound 1

theorem weierstrass_point_card_bound [Fintype F] (W : WeierstrassCurve F) :
    Nat.card W.toAffine.Point ≤ 2 * Fintype.card F + 1 :=
  affine_point_card_bound W.toAffine

theorem affine_point_nat_card_bound [Finite F] (W : WeierstrassCurve.Affine F) :
    Nat.card W.Point ≤ 2 * Nat.card F + 1 := by
  let : Fintype F := Fintype.ofFinite F
  simpa only [Nat.card_eq_fintype_card] using affine_point_card_bound W

end DivideAndPair
