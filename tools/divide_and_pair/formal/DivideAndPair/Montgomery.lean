module

public import DivideAndPair.LowOrder

@[expose] public section

namespace DivideAndPair

variable {F : Type*} [Field F]

def onMontgomery (delta u w : F) : Prop :=
  u*w^2 = u^2 + (-4-2*delta)*u + delta^2

def doubleRoot (delta q v : F) : F := (q^2-delta^2)/(2*q*v)
def montgomeryDoubleU (delta q v : F) : F := (doubleRoot delta q v)^2
def montgomeryDoubleW (delta q v : F) : F :=
  q*(v^4-16*(1+delta))/(2*v*(q^2-delta^2))

def miller4 (u w i : F) : F := u*(w+2*i)^2
def duplicationRoot (delta q v i : F) : F :=
  ((q-delta)*v+2*i*(q+delta))/(2*v)

/-- A polynomial certificate for the quartic Miller value under duplication. -/
theorem duplication_certificate (delta q v i : F)
    (curve : onMontgomery delta q v) (hi : i^2 = -1) :
    q*(v^4-16*(1+delta)) + 4*i*v*(q^2-delta^2) -
      ((q-delta)*v+2*i*(q+delta))^2 = 0 := by
  dsimp [onMontgomery] at curve
  linear_combination (v^2-4)*curve - 4*(q+delta)^2*hi

theorem duplication_root_identity (delta q v i : F)
    (two : (2 : F) ≠ 0) (hq : q ≠ 0) (hv : v ≠ 0) (hqd : q^2-delta^2 ≠ 0)
    (curve : onMontgomery delta q v) (hi : i^2 = -1) :
    doubleRoot delta q v * (montgomeryDoubleW delta q v + 2*i) =
      (duplicationRoot delta q v i)^2/q := by
  have certificate := duplication_certificate delta q v i curve hi
  dsimp [doubleRoot, montgomeryDoubleW, duplicationRoot]
  field_simp [two, hq, hv, hqd]
  linear_combination certificate

theorem miller_double (delta q v i : F)
    (two : (2 : F) ≠ 0) (hq : q ≠ 0) (hv : v ≠ 0) (hqd : q^2-delta^2 ≠ 0)
    (curve : onMontgomery delta q v) (hi : i^2 = -1) :
    miller4 (montgomeryDoubleU delta q v) (montgomeryDoubleW delta q v) i =
      (duplicationRoot delta q v i)^4/q^2 := by
  have identity := duplication_root_identity delta q v i two hq hv hqd curve hi
  dsimp [miller4, montgomeryDoubleU]
  calc
    _ = (doubleRoot delta q v * (montgomeryDoubleW delta q v + 2*i))^2 := by ring
    _ = _ := by rw [identity]; ring

/-- Two rational divisions imply a quartic Miller value. -/
theorem square_half_implies_quartic (delta q v i s : F)
    (two : (2 : F) ≠ 0) (hq : q ≠ 0) (hv : v ≠ 0) (hqd : q^2-delta^2 ≠ 0)
    (curve : onMontgomery delta q v) (hi : i^2 = -1) (hs : s^2 = q) :
    ∃ z : F, z^4 = miller4 (montgomeryDoubleU delta q v) (montgomeryDoubleW delta q v) i := by
  refine ⟨duplicationRoot delta q v i/s, ?_⟩
  rw [miller_double delta q v i two hq hv hqd curve hi]
  rw [div_pow, ← hs]
  congr 1
  ring

/-- The converse uses only the duplication identity and i squared equals -1. -/
theorem quartic_implies_square_half (delta q v i z : F)
    (two : (2 : F) ≠ 0) (hq : q ≠ 0) (hv : v ≠ 0) (hqd : q^2-delta^2 ≠ 0)
    (curve : onMontgomery delta q v) (hi : i^2 = -1) (hz : z ≠ 0)
    (root : z^4 = miller4 (montgomeryDoubleU delta q v) (montgomeryDoubleW delta q v) i) :
    IsSquare q := by
  rw [miller_double delta q v i two hq hv hqd curve hi] at root
  have equation := (eq_div_iff (pow_ne_zero 2 hq)).mp root
  have hs : q^2 = ((duplicationRoot delta q v i/z)^2)^2 := by
    rw [← pow_mul, div_pow]
    apply (eq_div_iff (pow_ne_zero 4 hz)).mpr
    linear_combination equation
  rcases (sq_eq_sq_iff_eq_or_eq_neg).mp hs with positive | negative
  · exact ⟨duplicationRoot delta q v i/z, positive.trans (by ring)⟩
  · refine ⟨i*(duplicationRoot delta q v i/z), ?_⟩
    apply negative.trans
    calc
      _ = i^2*(duplicationRoot delta q v i/z)^2 := by rw [hi]; ring
      _ = _ := by ring

theorem quartic_implies_square_u (u w i z : F) (hshift : w+2*i ≠ 0)
    (root : z^4 = miller4 u w i) : IsSquare u := by
  refine ⟨z^2/(w+2*i), ?_⟩
  calc
    u = z^4/(w+2*i)^2 := by
      apply (eq_div_iff (pow_ne_zero 2 hshift)).mpr
      exact root.symm
    _ = _ := by simp only [div_eq_mul_inv, ← inv_pow]; ring

end DivideAndPair
