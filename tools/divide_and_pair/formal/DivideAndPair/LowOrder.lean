module

public import Mathlib.Tactic.FieldSimp
public import Mathlib.Tactic.LinearCombination
public import Mathlib.Tactic.Ring

@[expose] public section

namespace DivideAndPair

variable {F : Type*} [Field F]

def onEdwards (d x y : F) : Prop := y^2 - x^2 = 1 + d*x^2*y^2

instance [DecidableEq F] (d x y : F) : Decidable (onEdwards d x y) :=
  inferInstanceAs (Decidable (y^2-x^2 = 1+d*x^2*y^2))

def doubleX (d x y : F) : F := (2*x*y)/(1+d*x^2*y^2)
def doubleY (d x y : F) : F := (x^2+y^2)/(1-d*x^2*y^2)

theorem denominator_sub_nonzero (d z : F) (hd : ¬IsSquare d) : 1-d*z^2 ≠ 0 := by
  intro h
  have hz : z ≠ 0 := by
    intro hz
    simp [hz] at h
  apply hd
  refine ⟨z⁻¹, ?_⟩
  field_simp
  linear_combination -h

theorem denominator_add_nonzero (d z i : F) (hd : ¬IsSquare d)
    (hi : i^2 = -1) : 1+d*z^2 ≠ 0 := by
  intro h
  have hz : z ≠ 0 := by
    intro hz
    simp [hz] at h
  apply hd
  refine ⟨i/z, ?_⟩
  field_simp
  linear_combination h - hi

theorem double_on_curve (d x y : F)
    (h : onEdwards d x y)
    (hp : 1+d*x^2*y^2 ≠ 0) (hm : 1-d*x^2*y^2 ≠ 0) :
    onEdwards d (doubleX d x y) (doubleY d x y) := by
  dsimp [onEdwards] at h ⊢
  dsimp [doubleX, doubleY]
  simp only [div_pow]
  field_simp (disch := first |
    (simpa only [mul_comm, mul_left_comm, mul_assoc] using hp) |
    (simpa only [mul_comm, mul_left_comm, mul_assoc] using hm))
  linear_combination (d*x^2*y^2-1)^2 * (d*x^2*y^2-x^2+y^2+1) * h

theorem double_eq_identity_iff (d x y : F) (two : (2 : F) ≠ 0)
    (h : onEdwards d x y)
    (hp : 1+d*x^2*y^2 ≠ 0) :
    (doubleX d x y = 0 ∧ doubleY d x y = 1) ↔ x = 0 := by
  constructor
  · rintro ⟨hx, hy⟩
    have hxy : x = 0 ∨ y = 0 := by
      simpa [doubleX, div_eq_zero_iff, hp, mul_eq_zero, two] using hx
    rcases hxy with hx | hy0
    · exact hx
    · dsimp [doubleY] at hy
      simp only [hy0, ne_eq, OfNat.ofNat_ne_zero, not_false_eq_true, zero_pow,
        mul_zero, sub_zero, add_zero, div_one] at hy
      dsimp [onEdwards] at h
      have hneg : -(x^2) = 1 := by simpa [hy0] using h
      exfalso
      apply two
      linear_combination -hy - hneg
  · intro hx
    subst x
    have hy : y^2 = 1 := by simpa [onEdwards] using h
    simp [doubleX, doubleY, hy]

theorem four_x_zero_iff (d x y : F) (two : (2 : F) ≠ 0)
    (hp : 1+d*x^2*y^2 ≠ 0) (hm : 1-d*x^2*y^2 ≠ 0)
    (hp2 : 1+d*(doubleX d x y)^2*(doubleY d x y)^2 ≠ 0) :
    doubleX d (doubleX d x y) (doubleY d x y) = 0 ↔
      x = 0 ∨ y = 0 ∨ x^2+y^2 = 0 := by
  change (2*doubleX d x y*doubleY d x y) /
    (1+d*(doubleX d x y)^2*(doubleY d x y)^2) = 0 ↔ _
  rw [div_eq_zero_iff]
  simp only [hp2, or_false, mul_eq_zero, two, false_or]
  simp [doubleX, doubleY, div_eq_zero_iff, hp, hm, mul_eq_zero, two, or_assoc]

/-- The polynomial guard equals three complete Edwards doublings.
    Denominator hypotheses state the domain of the rational formulas. -/
theorem low_order_iff_eight_eq_identity (d x y : F) (two : (2 : F) ≠ 0)
    (h : onEdwards d x y)
    (hp : 1+d*x^2*y^2 ≠ 0) (hm : 1-d*x^2*y^2 ≠ 0)
    (hp2 : 1+d*(doubleX d x y)^2*(doubleY d x y)^2 ≠ 0)
    (hm2 : 1-d*(doubleX d x y)^2*(doubleY d x y)^2 ≠ 0)
    (hp4 : 1+d*(doubleX d (doubleX d x y) (doubleY d x y))^2*
      (doubleY d (doubleX d x y) (doubleY d x y))^2 ≠ 0) :
    let x2 := doubleX d x y
    let y2 := doubleY d x y
    let x4 := doubleX d x2 y2
    let y4 := doubleY d x2 y2
    (doubleX d x4 y4 = 0 ∧ doubleY d x4 y4 = 1) ↔
      x*y*(x^2+y^2) = 0 := by
  dsimp
  have h2 := double_on_curve d x y h hp hm
  have h4 := double_on_curve d _ _ h2 hp2 hm2
  rw [double_eq_identity_iff d _ _ two h4 hp4, four_x_zero_iff d x y two hp hm hp2]
  simp only [mul_eq_zero, or_assoc]

theorem low_order_complete (d x y i : F) (two : (2 : F) ≠ 0)
    (hd : ¬IsSquare d) (hi : i^2 = -1) (h : onEdwards d x y) :
    let x2 := doubleX d x y
    let y2 := doubleY d x y
    let x4 := doubleX d x2 y2
    let y4 := doubleY d x2 y2
    (doubleX d x4 y4 = 0 ∧ doubleY d x4 y4 = 1) ↔
      x*y*(x^2+y^2) = 0 := by
  have hp (u v : F) : 1+d*u^2*v^2 ≠ 0 := by
    simpa only [mul_pow, mul_assoc] using denominator_add_nonzero d (u*v) i hd hi
  have hm (u v : F) : 1-d*u^2*v^2 ≠ 0 := by
    simpa only [mul_pow, mul_assoc] using denominator_sub_nonzero d (u*v) hd
  exact low_order_iff_eight_eq_identity d x y two h (hp _ _) (hm _ _) (hp _ _) (hm _ _) (hp _ _)

end DivideAndPair
