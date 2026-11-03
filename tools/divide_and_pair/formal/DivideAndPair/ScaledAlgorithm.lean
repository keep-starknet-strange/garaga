module

public import DivideAndPair.Correctness

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192
set_option maxHeartbeats 1000000

noncomputable def genericScaledTest (outer : Fp → Option Fp)
    (inner : Fp → Option (Bool × Fp)) (power : Fp → Fp) (u w e : Fp) : Bool :=
  match outer (4*u) with
  | none => false
  | some wp =>
    let up := scaledUp montgomeryDelta u w e wp
    match inner up with
    | none => false
    | some (isSquare, root) =>
      if isSquare then
        decide (power (scaledHalfU montgomeryDelta e wp root*(root+2*sqrtMinusOne*e)^2) = 1)
      else
        let nextE := e*root
        let nextWp := wp*root
        let nextW := sqrtTwoDiscriminant*e^2
        decide (power (scaledHalfU montgomeryDelta nextE nextWp nextW*
          (-nextW+2*sqrtMinusOne*nextE)^2) = 1)

noncomputable def scaledTest (u w e : Fp) : Bool :=
  genericScaledTest sqrtModel sqrtPairModel (fun f => f^quarticExponent) u w e

theorem subgroup_has_square_u (u w : Fp) (curve : onMontgomery montgomeryDelta u w)
    (member : subgroupOrder • chartPoint montgomeryDelta u w ed25519_two_nonzero
      (montgomery_u_nonzero _ _ _ delta_nonzero curve)
      (montgomery_w_nonzero _ _ _ montgomery_discriminant_nonsquare curve) curve = 0) :
    IsSquare u := by
  rw [subgroup_iff_eight_divisible] at member
  obtain ⟨R, hR⟩ := member
  have half_eq : (2 : Nat) • ((4 : Nat) • R) = chartPoint montgomeryDelta u w
      ed25519_two_nonzero (montgomery_u_nonzero _ _ _ delta_nonzero curve)
      (montgomery_w_nonzero _ _ _ montgomery_discriminant_nonsquare curve) curve := by
    simpa [smul_smul] using hR
  obtain ⟨half, _⟩ := group_half_has_rational_chart _ _ _ _ _ _ curve _ half_eq
  refine ⟨doubleRoot montgomeryDelta half.q half.v, ?_⟩
  rw [← pow_two]
  exact half.double_u.symm

theorem generic_scaled_test_iff_spec
    (outer : Fp → Option Fp) (inner : Fp → Option (Bool × Fp)) (power : Fp → Fp)
    (outer_sound : ∀ a root, outer a = some root → root^2 = a)
    (outer_complete : ∀ a, IsSquare a → ∃ root, outer a = some root)
    (inner_complete : ∀ a, (inner a).isSome = true)
    (inner_sound : ∀ a flag root, inner a = some (flag,root) → root^2 = if flag then a else 2*a)
    (u w e : Fp) (he : e ≠ 0)
    (curve : onMontgomery montgomeryDelta u w) (member : Prop)
    (square_u : member → IsSquare u)
    (finish : ∀ r v scale : Fp, scale ≠ 0 → r^2 = u →
      v^2 = 2*u+(-4-2*montgomeryDelta)-2*r*w →
      (power (scale^4*miller4 (halfU u w r v) v sqrtMinusOne) = 1 ↔ member)) :
    genericScaledTest outer inner power (e^2*u) (e*w) e = true ↔ member := by
  unfold genericScaledTest
  cases hOuter : outer (4*(e^2*u)) with
  | none =>
    simp only [Bool.false_eq_true]
    constructor
    · exact False.elim
    · intro member
      obtain ⟨r, hr⟩ := square_u member
      have square : IsSquare (4*(e^2*u)) := by
        refine ⟨2*e*r, ?_⟩
        rw [hr]
        ring
      obtain ⟨root, hroot⟩ := outer_complete _ square
      rw [hOuter] at hroot
      contradiction
  | some wp =>
    have wp_square := outer_sound _ wp hOuter
    let r := wp/(2*e)
    have hwp : wp = 2*e*r := by dsimp [r]; field_simp [he, ed25519_two_nonzero]
    have hr : r^2 = u := by
      dsimp [r]
      field_simp [he, ed25519_two_nonzero]
      linear_combination wp_square
    have up_eq : scaledUp montgomeryDelta (e^2*u) (e*w) e wp =
        e^2*(2*u+(-4-2*montgomeryDelta)-2*r*w) := by
      rw [hwp]
      exact scaled_up_normalizes _ _ _ _ _ ed25519_two_nonzero
    dsimp only
    cases hInner : inner (scaledUp montgomeryDelta (e^2*u) (e*w) e wp) with
    | none =>
      have complete := inner_complete (scaledUp montgomeryDelta (e^2*u) (e*w) e wp)
      simp only [hInner, Option.isSome_none, Bool.false_eq_true] at complete
    | some pair =>
      obtain ⟨isSquare, root⟩ := pair
      have root_square := inner_sound _ isSquare root hInner
      rw [up_eq] at root_square
      cases isSquare with
      | true =>
        simp only [↓reduceIte, decide_eq_true_eq] at root_square ⊢
        let v := root/e
        have hv : v^2 = 2*u+(-4-2*montgomeryDelta)-2*r*w := by
          dsimp [v]
          field_simp [he]
          linear_combination root_square
        have hroot : root = e*v := by dsimp [v]; field_simp [he]
        have normalized : scaledHalfU montgomeryDelta e wp root*(root+2*sqrtMinusOne*e)^2 =
            e^4*miller4 (halfU u w r v) v sqrtMinusOne := by
          rw [hwp, hroot]
          exact scaled_miller_normalizes _ _ _ _ _ _ _ ed25519_two_nonzero hv
        rw [normalized]
        exact finish r v e he hr hv
      | false =>
        simp only [Bool.false_eq_true, ↓reduceIte, decide_eq_true_eq] at root_square ⊢
        obtain ⟨hroot, hv⟩ := nonsquare_branch_normalizes montgomeryDelta u w e r root
          sqrtTwoDiscriminant ed25519_two_nonzero he curve hr montgomery_discriminant_nonsquare
          sqrt_two_discriminant_correct root_square
        have hr' : (-r)^2 = u := by simpa using hr
        have normalized := nonsquare_miller_normalizes montgomeryDelta u w e r root
          sqrtTwoDiscriminant sqrtMinusOne ed25519_two_nonzero hroot hv
        rw [hwp, normalized]
        exact finish (-r) (-sqrtTwoDiscriminant*e/root) (e*root) (mul_ne_zero he hroot) hr' hv


theorem scaled_test_iff_subgroup (u w e : Fp) (he : e ≠ 0)
    (curve : onMontgomery montgomeryDelta u w) :
    scaledTest (e^2*u) (e*w) e = true ↔
      subgroupOrder • chartPoint montgomeryDelta u w ed25519_two_nonzero
        (montgomery_u_nonzero _ _ _ delta_nonzero curve)
        (montgomery_w_nonzero _ _ _ montgomery_discriminant_nonsquare curve) curve = 0 := by
  apply generic_scaled_test_iff_spec sqrtModel sqrtPairModel (fun f => f^quarticExponent)
    sqrt_model_sound sqrt_model_complete sqrt_pair_complete sqrt_pair_sound u w e he curve
  · exact subgroup_has_square_u u w curve
  · intro r v scale hs hr hv
    exact half_finish_iff_subgroup u w r v scale hs curve hr hv

end DivideAndPair
