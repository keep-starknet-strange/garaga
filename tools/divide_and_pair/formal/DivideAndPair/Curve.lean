module

public import Mathlib.AlgebraicGeometry.EllipticCurve.Affine.Point
public import DivideAndPair.Residues

@[expose] public section

namespace DivideAndPair

variable {F : Type*} [Field F]

def montgomeryCurve (delta : F) : WeierstrassCurve F :=
  ⟨0, -4-2*delta, 0, delta^2, 0⟩

theorem chart_equation (delta u w : F) (curve : onMontgomery delta u w) :
    (montgomeryCurve delta).toAffine.Equation u (u*w) := by
  rw [WeierstrassCurve.Affine.equation_iff]
  dsimp [montgomeryCurve, onMontgomery] at curve ⊢
  linear_combination u*curve

theorem chart_nonsingular (delta u w : F) (two : (2 : F) ≠ 0)
    (hu : u ≠ 0) (hw : w ≠ 0) (curve : onMontgomery delta u w) :
    (montgomeryCurve delta).toAffine.Nonsingular u (u*w) := by
  refine ⟨chart_equation delta u w curve, Or.inr ?_⟩
  rw [WeierstrassCurve.Affine.evalEval_polynomialY]
  simpa [montgomeryCurve] using mul_ne_zero two (mul_ne_zero hu hw)

noncomputable def chartPoint (delta u w : F) (two : (2 : F) ≠ 0)
    (hu : u ≠ 0) (hw : w ≠ 0) (curve : onMontgomery delta u w) :
    (montgomeryCurve delta).toAffine.Point :=
  .some u (u*w) (chart_nonsingular delta u w two hu hw curve)

def tangentSlope (delta q v : F) : F :=
  (3*q^2+2*(-4-2*delta)*q+delta^2)/(2*q*v)

theorem double_x_formula (delta q v : F) (two : (2 : F) ≠ 0)
    (hq : q ≠ 0) (hv : v ≠ 0) (curve : onMontgomery delta q v) :
    (tangentSlope delta q v)^2-(-4-2*delta)-2*q = montgomeryDoubleU delta q v := by
  dsimp [tangentSlope, montgomeryDoubleU, doubleRoot]
  simp only [div_pow]
  field_simp [two, hq, hv]
  dsimp [onMontgomery] at curve
  linear_combination (-4*q*(-4-2*delta+2*q))*curve

theorem double_y_formula (delta q v : F) (two : (2 : F) ≠ 0)
    (hq : q ≠ 0) (hv : v ≠ 0)
    (curve : onMontgomery delta q v) :
    tangentSlope delta q v*(q-montgomeryDoubleU delta q v)-q*v =
      montgomeryDoubleU delta q v*montgomeryDoubleW delta q v := by
  dsimp [tangentSlope, montgomeryDoubleU, doubleRoot, montgomeryDoubleW]
  simp only [div_pow]
  field_simp [two, hq, hv]
  dsimp [onMontgomery] at curve
  linear_combination
    (delta^4-2*delta^3*q-4*delta^2*q^2+delta^2*q*v^2-4*delta^2*q+
      2*delta*q^3+3*q^4-9*q^3*v^2+4*q^3)*curve

theorem chart_double [DecidableEq F] (delta q v : F) (two : (2 : F) ≠ 0)
    (hq : q ≠ 0) (hv : v ≠ 0)
    (curve : onMontgomery delta q v) :
    ∃ h : (montgomeryCurve delta).toAffine.Nonsingular
      (montgomeryDoubleU delta q v)
      (montgomeryDoubleU delta q v*montgomeryDoubleW delta q v),
    chartPoint delta q v two hq hv curve + chartPoint delta q v two hq hv curve =
      .some _ _ h := by
  classical
  let W := (montgomeryCurve delta).toAffine
  have hy : q*v ≠ W.negY q (q*v) := by
    intro h
    apply mul_ne_zero (mul_ne_zero two hq) hv
    dsimp [W, montgomeryCurve, WeierstrassCurve.Affine.negY] at h
    linear_combination h
  have slope : W.slope q q (q*v) (q*v) = tangentSlope delta q v := by
    rw [WeierstrassCurve.Affine.slope_of_Y_ne rfl hy]
    dsimp [W, montgomeryCurve, WeierstrassCurve.Affine.negY, tangentSlope]
    congr 1 <;> ring
  have hx : W.addX q q (W.slope q q (q*v) (q*v)) = montgomeryDoubleU delta q v := by
    rw [slope]
    dsimp [WeierstrassCurve.Affine.addX, W, montgomeryCurve]
    convert double_x_formula delta q v two hq hv curve using 1
    ring
  have hy' : W.addY q q (q*v) (W.slope q q (q*v) (q*v)) =
      montgomeryDoubleU delta q v*montgomeryDoubleW delta q v := by
    dsimp only [WeierstrassCurve.Affine.addY, WeierstrassCurve.Affine.negAddY]
    rw [hx, slope]
    dsimp [WeierstrassCurve.Affine.negY, W, montgomeryCurve]
    convert double_y_formula delta q v two hq hv curve using 1
    ring
  unfold chartPoint
  rw [WeierstrassCurve.Affine.Point.add_self_of_Y_ne hy]
  have nonsingular := W.nonsingular_add
    (chart_nonsingular delta q v two hq hv curve)
    (chart_nonsingular delta q v two hq hv curve)
    (by rintro ⟨_, opposite⟩; exact hy opposite)
  refine ⟨by simpa only [hx, hy'] using nonsingular, ?_⟩
  simp only [WeierstrassCurve.Affine.Point.some.injEq]
  exact ⟨hx, hy'⟩

end DivideAndPair
