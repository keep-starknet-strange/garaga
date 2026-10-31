module

public import DivideAndPair.Curve
public import DivideAndPair.Arithmetic
public import DivideAndPair.Quartic

@[expose] public section

namespace DivideAndPair

variable {F : Type*} [Field F]

def scaledUp (delta u w e wp : F) : F :=
  (4*u-(-2*(-4-2*delta))*e^2-2*wp*w)/2

def scaledHalfU (delta e wp w : F) : F :=
  (w^2-(-4-2*delta)*e^2-w*wp)/2

theorem scaled_up_normalizes (delta u w e r : F) (two : (2 : F) ≠ 0) :
    scaledUp delta (e^2*u) (e*w) e (2*e*r) =
      e^2*(2*u+(-4-2*delta)-2*r*w) := by
  dsimp [scaledUp]
  field_simp [two]
  ring

theorem scaled_half_normalizes (delta u w e r v : F) (two : (2 : F) ≠ 0)
    (root : v^2 = 2*u+(-4-2*delta)-2*r*w) :
    scaledHalfU delta e (2*e*r) (e*v) = e^2*halfU u w r v := by
  dsimp [scaledHalfU, halfU]
  field_simp [two]
  linear_combination e^2*root

theorem scaled_miller_normalizes (delta u w e r v i : F) (two : (2 : F) ≠ 0)
    (root : v^2 = 2*u+(-4-2*delta)-2*r*w) :
    scaledHalfU delta e (2*e*r) (e*v)*(e*v+2*i*e)^2 =
      e^4*miller4 (halfU u w r v) v i := by
  rw [scaled_half_normalizes delta u w e r v two root]
  dsimp [miller4]
  ring

theorem nonsquare_branch_normalizes (delta u w e r root constant : F)
    (two : (2 : F) ≠ 0) (he : e ≠ 0)
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (discriminant : ¬IsSquare (16*(1+delta)))
    (hc : constant^2 = 2*(16*(1+delta)))
    (root_eq : root^2 = 2*(e^2*(2*u+(-4-2*delta)-2*r*w))) :
    root ≠ 0 ∧
      (-constant*e/root)^2 = 2*u+(-4-2*delta)-2*(-r)*w := by
  have product := half_product delta u w r curve hr
  have ha : 2*u+(-4-2*delta)-2*r*w ≠ 0 := by
    intro hz
    apply discriminant
    have zero : (16*(1+delta)) = 0 := by simpa [hz] using product.symm
    rw [zero]
    exact IsSquare.zero
  have hroot : root ≠ 0 := by
    intro hz
    have nonzero := mul_ne_zero two (mul_ne_zero (pow_ne_zero 2 he) ha)
    exact nonzero (by simpa [hz] using root_eq.symm)
  refine ⟨hroot, ?_⟩
  rw [div_pow]
  apply (div_eq_iff (pow_ne_zero 2 hroot)).mpr
  rw [root_eq, mul_pow, neg_pow, hc]
  linear_combination -2*e^2*product

theorem nonsquare_miller_normalizes (delta u w e r root constant i : F)
    (two : (2 : F) ≠ 0) (hroot : root ≠ 0)
    (hv : (-constant*e/root)^2 = 2*u+(-4-2*delta)-2*(-r)*w) :
    scaledHalfU delta (e*root) ((2*e*r)*root) (constant*e^2)*
        (-(constant*e^2)+2*i*(e*root))^2 =
      (e*root)^4*miller4 (halfU u w (-r) (-constant*e/root)) (-constant*e/root) i := by
  have scale : constant*e^2 = -(e*root*(-constant*e/root)) := by
    field_simp [hroot]
  rw [scale]
  have h := scaled_miller_normalizes delta u w (e*root) (-r) (-constant*e/root) i two hv
  convert h using 1
  dsimp [scaledHalfU]
  ring

end DivideAndPair
