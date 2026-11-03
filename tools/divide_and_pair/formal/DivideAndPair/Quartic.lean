module

public import DivideAndPair.Squares

@[expose] public section

namespace DivideAndPair

variable {F : Type*} [Field F]

structure RationalHalf (delta u w : F) where
  q : F
  v : F
  curve : onMontgomery delta q v
  q_ne_zero : q ≠ 0
  v_ne_zero : v ≠ 0
  numerator_ne_zero : q^2-delta^2 ≠ 0
  double_u : montgomeryDoubleU delta q v = u
  double_w : montgomeryDoubleW delta q v = w

theorem half_product (delta u w r : F) (curve : onMontgomery delta u w) (hr : r^2 = u) :
    (2*u+(-4-2*delta)-2*r*w)*(2*u+(-4-2*delta)+2*r*w) = 16*(1+delta) := by
  dsimp [onMontgomery] at curve
  linear_combination -4*curve - 4*w^2*hr

noncomputable def halfFromRoots (delta u w r v : F) (two : (2 : F) ≠ 0)
    (hd : delta ≠ 0) (hb : ¬IsSquare (16*(1+delta)))
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*delta)-2*r*w) : RationalHalf delta u w := by
  obtain ⟨hc, hdu, hdw⟩ := halving_sound delta u w r v two hd hb curve hr hv
  have hq := montgomery_u_nonzero delta _ _ hd hc
  have hv0 := montgomery_w_nonzero delta _ _ hb hc
  have hr0 : r ≠ 0 := by
    intro hr0
    exact montgomery_u_nonzero delta u w hd curve (by simpa [hr0] using hr.symm)
  refine ⟨halfU u w r v, v, hc, hq, hv0, ?_, hdu, hdw⟩
  rw [half_numerator delta u w r v curve hr hv]
  exact mul_ne_zero (mul_ne_zero (mul_ne_zero (neg_ne_zero.mpr two) hq) hv0) hr0

theorem construct_half (delta u w r v : F) (two : (2 : F) ≠ 0)
    (hd : delta ≠ 0) (hb : ¬IsSquare (16*(1+delta)))
    (curve : onMontgomery delta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*delta)-2*r*w) : Nonempty (RationalHalf delta u w) :=
  ⟨halfFromRoots delta u w r v two hd hb curve hr hv⟩

theorem square_u_has_half [Fintype F] (delta u w : F) (two : (2 : F) ≠ 0)
    (hd : delta ≠ 0) (hb : ¬IsSquare (16*(1+delta)))
    (curve : onMontgomery delta u w) (square : IsSquare u) :
    Nonempty (RationalHalf delta u w) := by
  classical
  obtain ⟨r, hr⟩ := square
  have hr : r^2 = u := by simpa [pow_two] using hr.symm
  let a := 2*u+(-4-2*delta)-2*r*w
  let b := 2*u+(-4-2*delta)+2*r*w
  have product : a*b = 16*(1+delta) := half_product delta u w r curve hr
  have hb0 : b ≠ 0 := by
    intro hz
    have hz' : 16*(1+delta) = 0 := by simpa [hz] using product.symm
    exact hb (by rw [hz']; exact IsSquare.zero)
  have nonsquare : ¬IsSquare (a*b) := by simpa only [product] using hb
  rcases square_or_square_partner a b hb0 nonsquare with ha | hb'
  · obtain ⟨v, hv⟩ := ha
    exact construct_half delta u w r v two hd hb curve hr (by simpa [pow_two] using hv.symm)
  · obtain ⟨v, hv⟩ := hb'
    apply construct_half delta u w (-r) v two hd hb curve (by simpa using hr)
    calc
      v^2 = b := by simpa [pow_two] using hv.symm
      _ = _ := by dsimp [b]; ring

/-- The quartic test is exactly two rational divisions, without a Tate assumption. -/
theorem quartic_iff_two_halves [Fintype F] (delta u w i : F)
    (two : (2 : F) ≠ 0) (hd : delta ≠ 0) (hb : ¬IsSquare (16*(1+delta)))
    (curve : onMontgomery delta u w) (hi : i^2 = -1)
    (nonzero : miller4 u w i ≠ 0) :
    (∃ z : F, z^4 = miller4 u w i) ↔
      ∃ h : RationalHalf delta u w, Nonempty (RationalHalf delta h.q h.v) := by
  constructor
  · rintro ⟨z, root⟩
    have shift : w+2*i ≠ 0 := by
      intro hz
      apply nonzero
      simp [miller4, hz]
    have square := quartic_implies_square_u u w i z shift root
    obtain ⟨half⟩ := square_u_has_half delta u w two hd hb curve square
    have hz : z ≠ 0 := by
      intro hz
      exact nonzero (by simpa [hz] using root.symm)
    have square_half := quartic_implies_square_half delta half.q half.v i z two
      half.q_ne_zero half.v_ne_zero half.numerator_ne_zero half.curve hi hz
      (by simpa only [half.double_u, half.double_w] using root)
    exact ⟨half, square_u_has_half delta half.q half.v two hd hb half.curve square_half⟩
  · rintro ⟨half, ⟨quarter⟩⟩
    have hs : (doubleRoot delta quarter.q quarter.v)^2 = half.q := quarter.double_u
    obtain ⟨z, hz⟩ := square_half_implies_quartic delta half.q half.v i _ two
      half.q_ne_zero half.v_ne_zero half.numerator_ne_zero half.curve hi hs
    exact ⟨z, by simpa only [half.double_u, half.double_w] using hz⟩

end DivideAndPair
