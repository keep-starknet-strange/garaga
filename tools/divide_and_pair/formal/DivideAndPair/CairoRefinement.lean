module

public import DivideAndPair.ScaledAlgorithm

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192
set_option maxHeartbeats 1000000

attribute [local irreducible] cairo_sqrt cairo_sqrt_or_twice cairo_finish
  sqrtModel sqrtPairModel

theorem cairo_body_eq_generic
    (small : Fp → Fp → Bool) (outer : Fp → Option Fp)
    (inner : Fp → Option (Bool × Fp)) (finish : Fp → Fp → Fp → Fp → List Fp)
    (power : Fp → Fp)
    (hSmall : ∀ x y, small x y = decide (x*y*(x^2+y^2) = 0))
    (hFinish : ∀ e wp w sign, finish e wp w sign = [power (cairo_miller_input e wp w sign)])
    (x y : Fp) :
    cairoBody_is_in_prime_order_subgroup_edwards small outer inner finish x y =
      if x*y*(x^2+y^2) = 0 then decide (x = 0 ∧ y = 1)
      else genericScaledTest outer inner power
        (montgomeryDelta*(1+y)*x*(x*(1-y))) (2*(1-y)) (x*(1-y)) := by
  have sign : cairoConstant_MINUS_ONE = (-1 : Fp) := by decide
  have hFinishProjection (e wp w s : Fp) :
      (finish e wp w s)[0]! =
        power (scaledHalfU montgomeryDelta e wp w*(s*w+2*sqrtMinusOne*e)^2) := by
    rw [hFinish, cairo_miller_input_eq]
    rfl
  have hUpProjection (u w e wp : Fp) :
      (cairo_halve_up u w e wp)[0]! = scaledUp montgomeryDelta u w e wp := by
    rw [cairo_halve_up_eq]
    rfl
  have four (u : Fp) : u*4 = 4*u := mul_comm _ _
  simp only [cairoBody_is_in_prime_order_subgroup_edwards, hSmall, cairo_prepare_eq,
    hUpProjection, hFinishProjection, cairo_halve_nqr_eq, sign,
    List.getElem!_cons_zero, List.getElem!_cons_succ, four,
    genericScaledTest, one_mul, neg_one_mul, Bool.decide_and, decide_eq_true_eq]
  by_cases guard : x*y*(x^2+y^2) = 0
  · rw [ite_eq_left guard, ite_eq_left guard]
  · rw [ite_eq_right guard, ite_eq_right guard]
    cases out : outer (4*(montgomeryDelta*(1+y)*x*(x*(1-y)))) with
    | none => rfl
    | some wp =>
      dsimp only
      cases inside : inner (scaledUp montgomeryDelta
          (montgomeryDelta*(1+y)*x*(x*(1-y))) (2*(1-y)) (x*(1-y)) wp) with
      | none => rfl
      | some pair =>
        obtain ⟨flag, root⟩ := pair
        rfl

theorem cairo_subgroup_flow_eq (x y : Fp) :
    cairoFlow_is_in_prime_order_subgroup_edwards x y =
      if x*y*(x^2+y^2) = 0 then decide (x = 0 ∧ y = 1)
      else scaledTest (montgomeryDelta*(1+y)*x*(x*(1-y))) (2*(1-y)) (x*(1-y)) := by
  have h := cairo_body_eq_generic cairoFlow_is_small_order_edwards cairoFlow_sqrt
    cairoFlow_sqrt_or_twice cairo_finish (fun f => f^quarticExponent)
    cairo_small_order_flow_eq cairo_finish_power x y
  change cairoFlow_is_in_prime_order_subgroup_edwards x y = _ at h
  rw [funext cairo_sqrt_flow_eq, funext cairo_sqrt_pair_flow_eq] at h
  exact h

end DivideAndPair
