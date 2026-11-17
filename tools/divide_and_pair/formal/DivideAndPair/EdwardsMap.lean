module

public import DivideAndPair.FixedPoints
public import DivideAndPair.LowOrder

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192
set_option maxHeartbeats 1000000

variable {F : Type*} [Field F]

def nativeU (d _x y : F) : F := (-1-d)*(1+y)/(1-y)
def nativeW (x : F) : F := 2/x

theorem native_y_square_ne_one (d x y : F) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) : y^2 ≠ 1 := by
  intro hy
  have product : x^2*(-1-d) = 0 := by
    dsimp [onEdwards] at curve
    rw [hy] at curve
    linear_combination curve
  exact mul_ne_zero (pow_ne_zero 2 hx) hd product

theorem native_y_ne_one (d x y : F) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) : y ≠ 1 := by
  intro hy
  apply native_y_square_ne_one d x y hd curve hx
  rw [hy, one_pow]

theorem native_y_ne_neg_one (d x y : F) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) : y ≠ -1 := by
  intro hy
  apply native_y_square_ne_one d x y hd curve hx
  rw [hy]
  ring

theorem native_denominator_nonzero (d x y : F) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) : 1-y ≠ 0 := by
  intro hz
  apply native_y_square_ne_one d x y hd curve hx
  have hy : y = 1 := by linear_combination -hz
  rw [hy, one_pow]

theorem native_numerator_nonzero (d x y : F) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) : 1+y ≠ 0 := by
  intro hz
  apply native_y_square_ne_one d x y hd curve hx
  have hy : y = -1 := by linear_combination hz
  rw [hy]
  ring

theorem native_u_nonzero (d x y : F) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) : nativeU d x y ≠ 0 :=
  div_ne_zero (mul_ne_zero hd (native_numerator_nonzero d x y hd curve hx))
    (native_denominator_nonzero d x y hd curve hx)

theorem native_w_nonzero (x : F) (two : (2 : F) ≠ 0) (hx : x ≠ 0) :
    nativeW x ≠ 0 := div_ne_zero two hx

theorem native_on_montgomery (d x y : F) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) :
    onMontgomery (-1-d) (nativeU d x y) (nativeW x) := by
  have hden := native_denominator_nonzero d x y hd curve hx
  dsimp [nativeU, nativeW, onMontgomery]
  simp only [div_pow]
  field_simp [hx, hden]
  dsimp [onEdwards] at curve
  linear_combination -4*curve

theorem native_prepare_scale (d x y : F) (hx : x ≠ 0) (hden : 1-y ≠ 0) :
    let e := x*(1-y)
    ((-1-d)*(1+y)*x*e = e^2*nativeU d x y) ∧
      (2*(1-y) = e*nativeW x) := by
  dsimp [nativeU, nativeW]
  constructor <;> field_simp [hx, hden]

theorem native_x_zero_cases (d x y : F) (curve : onEdwards d x y) (hx : x = 0) :
    y = 1 ∨ y = -1 := by
  have hy : y^2 = (1 : F)^2 := by simpa [onEdwards, hx] using curve
  exact sq_eq_sq_iff_eq_or_eq_neg.mp hy

theorem low_order_coordinate_classification (d x y i t : F)
    (curve : onEdwards d x y) (hd : ¬IsSquare d) (hi : i^2 = -1)
    (ht : d*t^4+2*t^2-1 = 0) (guard : x*y*(x^2+y^2) = 0) :
    (x = 0 ∧ (y = 1 ∨ y = -1)) ∨
      (y = 0 ∧ (x = i ∨ x = -i)) ∨
      ((y = t ∨ y = -t) ∧ (x = i*t ∨ x = -(i*t))) := by
  rcases mul_eq_zero.mp guard with hxy | hsum
  · rcases mul_eq_zero.mp hxy with hx | hy
    · exact Or.inl ⟨hx, native_x_zero_cases d x y curve hx⟩
    · have square : x^2 = i^2 := by
        dsimp [onEdwards] at curve
        rw [hy] at curve
        linear_combination -curve-hi
      exact Or.inr (Or.inl ⟨hy, sq_eq_sq_iff_eq_or_eq_neg.mp square⟩)
  · have quartic_y : d*y^4+2*y^2-1 = 0 := by
      dsimp [onEdwards] at curve
      linear_combination curve+(1+d*y^2)*hsum
    have factor : (y^2-t^2)*(d*y^2+d*t^2+2) = 0 := by
      linear_combination quartic_y-ht
    have same_square : y^2 = t^2 := by
      rcases mul_eq_zero.mp factor with same | other
      · exact sub_eq_zero.mp same
      · exfalso
        apply denominator_add_nonzero d (y*t) i hd hi
        linear_combination t^2*other-ht
    have x_square : x^2 = (i*t)^2 := by
      rw [mul_pow, hi, ← same_square]
      linear_combination hsum
    exact Or.inr (Or.inr
      ⟨sq_eq_sq_iff_eq_or_eq_neg.mp same_square,
       sq_eq_sq_iff_eq_or_eq_neg.mp x_square⟩)

theorem zero_coordinate_nonsingular (delta : F) (hd : delta ≠ 0) :
    (montgomeryCurve delta).toAffine.Nonsingular 0 0 := by
  refine ⟨?_, Or.inl ?_⟩
  · rw [WeierstrassCurve.Affine.equation_iff]
    simp [montgomeryCurve]
  · rw [WeierstrassCurve.Affine.evalEval_polynomialX]
    simpa [montgomeryCurve] using neg_ne_zero.mpr (pow_ne_zero 2 hd)

noncomputable def twoTorsionPoint : EdGroup :=
  .some 0 0 (zero_coordinate_nonsingular montgomeryDelta delta_nonzero)

noncomputable def nativePoint (x y : Fp) (curve : onEdwards edwardsD x y) : EdGroup :=
  if hx : x = 0 then
    if y = 1 then 0 else twoTorsionPoint
  else
    chartPoint montgomeryDelta (nativeU edwardsD x y) (nativeW x) ed25519_two_nonzero
      (native_u_nonzero edwardsD x y delta_nonzero curve hx)
      (native_w_nonzero x ed25519_two_nonzero hx)
      (native_on_montgomery edwardsD x y delta_nonzero curve hx)

theorem native_point_zero_iff (x y : Fp) (curve : onEdwards edwardsD x y) :
    nativePoint x y curve = 0 ↔ x = 0 ∧ y = 1 := by
  classical
  unfold nativePoint
  split
  · rename_i hx
    split
    · rename_i hy
      simp [hx, hy]
    · rename_i hy
      have hz : twoTorsionPoint ≠ 0 := WeierstrassCurve.Affine.Point.some_ne_zero _
      simp [hx, hy, hz]
  · rename_i hx
    have hz : chartPoint montgomeryDelta (nativeU edwardsD x y) (nativeW x)
        ed25519_two_nonzero
        (native_u_nonzero edwardsD x y delta_nonzero curve hx)
        (native_w_nonzero x ed25519_two_nonzero hx)
        (native_on_montgomery edwardsD x y delta_nonzero curve hx) ≠ 0 :=
      WeierstrassCurve.Affine.Point.some_ne_zero _
    simp [hx, hz]

abbrev torsionEightY : Fp :=
  55188659117513257062467267217118295137698188065244968500265048394206261417927
abbrev torsionEightX : Fp := sqrtMinusOne*torsionEightY

theorem torsion_eight_y_quartic : edwardsD*torsionEightY^4+2*torsionEightY^2-1 = 0 := by
  decide

theorem ed25519_low_order_coordinate_classification (x y : Fp)
    (curve : onEdwards edwardsD x y) (guard : x*y*(x^2+y^2) = 0) :
    (x = 0 ∧ (y = 1 ∨ y = -1)) ∨
      (y = 0 ∧ (x = sqrtMinusOne ∨ x = -sqrtMinusOne)) ∨
      ((y = torsionEightY ∨ y = -torsionEightY) ∧
        (x = torsionEightX ∨ x = -torsionEightX)) :=
  low_order_coordinate_classification edwardsD x y sqrtMinusOne torsionEightY
    curve edwards_d_nonsquare sqrt_minus_one_correct torsion_eight_y_quartic guard

theorem torsion_closed_eight :
    ((8 : Nat) • nativePoint 0 1 (by unfold onEdwards; decide) = 0) ∧
    ((8 : Nat) • nativePoint 0 (-1) (by unfold onEdwards; decide) = 0) ∧
    ((8 : Nat) • nativePoint sqrtMinusOne 0 (by unfold onEdwards; decide) = 0) ∧
    ((8 : Nat) • nativePoint (-sqrtMinusOne) 0 (by unfold onEdwards; decide) = 0) ∧
    ((8 : Nat) • nativePoint torsionEightX torsionEightY (by unfold onEdwards; decide) = 0) ∧
    ((8 : Nat) • nativePoint (-torsionEightX) torsionEightY (by unfold onEdwards; decide) = 0) ∧
    ((8 : Nat) • nativePoint torsionEightX (-torsionEightY) (by unfold onEdwards; decide) = 0) ∧
    ((8 : Nat) • nativePoint (-torsionEightX) (-torsionEightY) (by unfold onEdwards; decide) = 0) := by
  decide +kernel

theorem native_low_order_eight (x y : Fp) (curve : onEdwards edwardsD x y)
    (guard : x*y*(x^2+y^2) = 0) : (8 : Nat) • nativePoint x y curve = 0 := by
  rcases ed25519_low_order_coordinate_classification x y curve guard with first | second | third
  · obtain ⟨hx, hy⟩ := first
    subst x
    rcases hy with hy | hy
    · subst y
      exact torsion_closed_eight.1
    · subst y
      exact torsion_closed_eight.2.1
  · obtain ⟨hy, hx⟩ := second
    subst y
    rcases hx with hx | hx
    · subst x
      exact torsion_closed_eight.2.2.1
    · subst x
      exact torsion_closed_eight.2.2.2.1
  · obtain ⟨hy, hx⟩ := third
    rcases hy with hy | hy <;> rcases hx with hx | hx
    · subst x
      subst y
      exact torsion_closed_eight.2.2.2.2.1
    · subst x
      subst y
      exact torsion_closed_eight.2.2.2.2.2.1
    · subst x
      subst y
      exact torsion_closed_eight.2.2.2.2.2.2.1
    · subst x
      subst y
      exact torsion_closed_eight.2.2.2.2.2.2.2

theorem guarded_subgroup_iff_identity (x y : Fp) (curve : onEdwards edwardsD x y)
    (guard : x*y*(x^2+y^2) = 0) :
    subgroupOrder • nativePoint x y curve = 0 ↔ x = 0 ∧ y = 1 := by
  constructor
  · intro member
    have eight_divides : addOrderOf (nativePoint x y curve) ∣ 8 :=
      addOrderOf_dvd_iff_nsmul_eq_zero.mpr (native_low_order_eight x y curve guard)
    have ell_divides : addOrderOf (nativePoint x y curve) ∣ subgroupOrder :=
      addOrderOf_dvd_iff_nsmul_eq_zero.mpr member
    have order_one : addOrderOf (nativePoint x y curve) = 1 := by
      apply Nat.dvd_one.mp
      simpa only [show Nat.gcd 8 subgroupOrder = 1 from by decide] using
        Nat.dvd_gcd eight_divides ell_divides
    have zero := AddMonoid.addOrderOf_eq_one_iff.mp order_one
    exact (native_point_zero_iff x y curve).mp zero
  · intro identity
    rw [(native_point_zero_iff x y curve).mpr identity, nsmul_zero]


end DivideAndPair
