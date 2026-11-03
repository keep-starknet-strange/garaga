module

public import DivideAndPair.FlowLemmas
public import DivideAndPair.ChartHalves
public import DivideAndPair.Subgroup

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192
set_option maxHeartbeats 1000000

theorem miller_nonzero_of_numerator {F : Type*} [Field F] (delta q v i : F)
    (hq : q ≠ 0) (hn : q^2-delta^2 ≠ 0) (curve : onMontgomery delta q v)
    (hi : i^2 = -1) : miller4 q v i ≠ 0 := by
  intro hz
  have shift : v+2*i = 0 := by
    simpa [miller4, mul_eq_zero, hq] using hz
  have v_eq : v = -2*i := by linear_combination shift
  have sq : (q-delta)^2 = 0 := by
    dsimp [onMontgomery] at curve
    rw [v_eq] at curve
    linear_combination -curve+4*q*hi
  have equal : q = delta := sub_eq_zero.mp (sq_eq_zero_iff.mp sq)
  exact hn (by rw [equal]; ring)

theorem quartic_scale_invariant (scale f : Fp) (hs : scale ≠ 0) :
    (scale^4*f)^quarticExponent = 1 ↔ f^quarticExponent = 1 := by
  have fermat := FiniteField.pow_card_sub_one_eq_one scale hs
  simp only [ZMod.card] at fermat
  have power : (scale^4)^quarticExponent = 1 := by
    rw [← pow_mul]
    convert fermat using 2
  rw [mul_pow, power, one_mul]

/-- Every root choice in the halving branch gives the same subgroup decision. -/
theorem half_finish_iff_subgroup (u w r v scale : Fp) (hs : scale ≠ 0)
    (curve : onMontgomery montgomeryDelta u w) (hr : r^2 = u)
    (hv : v^2 = 2*u+(-4-2*montgomeryDelta)-2*r*w) :
    (scale^4*miller4 (halfU u w r v) v sqrtMinusOne)^quarticExponent = 1 ↔
      subgroupOrder • chartPoint montgomeryDelta u w ed25519_two_nonzero
        (montgomery_u_nonzero _ _ _ delta_nonzero curve)
        (montgomery_w_nonzero _ _ _ montgomery_discriminant_nonsquare curve) curve = 0 := by
  let half := halfFromRoots montgomeryDelta u w r v ed25519_two_nonzero
    delta_nonzero montgomery_discriminant_nonsquare curve hr hv
  let P := chartPoint montgomeryDelta u w ed25519_two_nonzero
    (montgomery_u_nonzero _ _ _ delta_nonzero curve)
    (montgomery_w_nonzero _ _ _ montgomery_discriminant_nonsquare curve) curve
  let H := halfChartPoint montgomeryDelta u w ed25519_two_nonzero half
  have twice : (2 : Nat) • H = P := rational_half_is_group_half _ _ _ _ _ _ curve half
  have nonzero : miller4 half.q half.v sqrtMinusOne ≠ 0 :=
    miller_nonzero_of_numerator _ _ _ _ half.q_ne_zero half.numerator_ne_zero
      half.curve sqrt_minus_one_correct
  rw [quartic_scale_invariant scale _ hs]
  change (miller4 half.q half.v sqrtMinusOne)^quarticExponent = 1 ↔ subgroupOrder • P = 0
  rw [ed25519_quartic_exponent_iff_group_four_divisible half.q half.v
    half.q_ne_zero half.v_ne_zero half.curve nonzero]
  change (∃ Q : EdGroup, (4 : Nat) • Q = H) ↔ subgroupOrder • P = 0
  rw [subgroup_iff_eight_divisible]
  constructor
  · rintro ⟨Q, hQ⟩
    refine ⟨Q, ?_⟩
    calc
      (8 : Nat) • Q = (2 : Nat) • ((4 : Nat) • Q) := by
        simp only [smul_smul]
        rfl
      _ = P := by rw [hQ, twice]
  · rintro ⟨R, hR⟩
    exact ed25519_every_half_of_eight_multiple H R (twice.trans hR.symm)

end DivideAndPair
