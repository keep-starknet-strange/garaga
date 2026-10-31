module

public import DivideAndPair.Montgomery

@[expose] public section

namespace DivideAndPair

variable {F : Type*} [Field F]

def halfU (u w r v : F) : F := u-r*w-r*v

theorem montgomery_u_nonzero (delta u w : F) (hd : delta ≠ 0)
    (curve : onMontgomery delta u w) : u ≠ 0 := by
  intro hu
  apply hd
  dsimp [onMontgomery] at curve
  have : delta^2 = 0 := by simpa [hu] using curve.symm
  exact (pow_eq_zero_iff (by decide : (2 : Nat) ≠ 0)).mp this

theorem montgomery_w_nonzero (delta u w : F)
    (hb : ¬IsSquare (16*(1+delta))) (curve : onMontgomery delta u w) : w ≠ 0 := by
  intro hw
  apply hb
  refine ⟨2*u-4-2*delta, ?_⟩
  dsimp [onMontgomery] at curve
  rw [hw] at curve
  linear_combination 4*curve

theorem half_on_curve (delta u w r v : F)
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*delta)-2*r*w) :
    onMontgomery delta (halfU u w r v) v := by
  dsimp [onMontgomery] at curve ⊢
  dsimp [halfU]
  linear_combination (-r^2-r*v-r*w+u)*hv +
    (2*delta+2*r*w-2*u+w^2+4)*hr + curve

theorem half_numerator (delta u w r v : F)
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*delta)-2*r*w) :
    (halfU u w r v)^2-delta^2 = -2*(halfU u w r v)*v*r := by
  dsimp [onMontgomery] at curve
  dsimp [halfU]
  linear_combination (-r^2)*hv +
    (2*delta+2*r*w-2*u+w^2+4)*hr + curve

theorem half_double_w_certificate (delta u w r v : F)
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*delta)-2*r*w) :
    v^4-16*(1+delta)+4*r*v^2*w = 0 := by
  dsimp [onMontgomery] at curve
  linear_combination (-2*delta+2*r*w+2*u+v^2-4)*hv -
    (4*w^2)*hr - (4*curve)

theorem half_double_root (delta u w r v : F)
    (two : (2 : F) ≠ 0) (hq : halfU u w r v ≠ 0) (hv0 : v ≠ 0)
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*delta)-2*r*w) :
    doubleRoot delta (halfU u w r v) v = -r := by
  rw [doubleRoot, half_numerator delta u w r v curve hr hv]
  field_simp [two, hq, hv0]

theorem half_double_u (delta u w r v : F)
    (two : (2 : F) ≠ 0) (hq : halfU u w r v ≠ 0) (hv0 : v ≠ 0)
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*delta)-2*r*w) :
    montgomeryDoubleU delta (halfU u w r v) v = u := by
  rw [montgomeryDoubleU, half_double_root delta u w r v two hq hv0 curve hr hv]
  simpa using hr

theorem half_double_w (delta u w r v : F)
    (two : (2 : F) ≠ 0) (hq : halfU u w r v ≠ 0) (hv0 : v ≠ 0) (hr0 : r ≠ 0)
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*delta)-2*r*w) :
    montgomeryDoubleW delta (halfU u w r v) v = w := by
  have certificate := half_double_w_certificate delta u w r v curve hr hv
  rw [montgomeryDoubleW, half_numerator delta u w r v curve hr hv]
  field_simp [two, hq, hv0, hr0]
  linear_combination -certificate

theorem halving_sound (delta u w r v : F)
    (two : (2 : F) ≠ 0) (hd : delta ≠ 0) (hb : ¬IsSquare (16*(1+delta)))
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*delta)-2*r*w) :
    onMontgomery delta (halfU u w r v) v ∧
      montgomeryDoubleU delta (halfU u w r v) v = u ∧
      montgomeryDoubleW delta (halfU u w r v) v = w := by
  have half_curve := half_on_curve delta u w r v curve hr hv
  have hq := montgomery_u_nonzero delta _ _ hd half_curve
  have hv0 := montgomery_w_nonzero delta _ _ hb half_curve
  have hr0 : r ≠ 0 := by
    intro hr0
    have hu := montgomery_u_nonzero delta u w hd curve
    exact hu (by simpa [hr0] using hr.symm)
  exact ⟨half_curve, half_double_u delta u w r v two hq hv0 curve hr hv,
    half_double_w delta u w r v two hq hv0 hr0 curve hr hv⟩

end DivideAndPair
