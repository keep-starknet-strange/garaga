module

public import DivideAndPair.PythonPrimitives
public import DivideAndPair.ScaledAlgorithm
public import DivideAndPair.EdwardsMap

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192
set_option maxHeartbeats 500000

theorem nonzero_quartic_test_eq (f : Fp) :
    (decide (f ≠ 0) && decide (f^quarticExponent = 1)) = decide (f^quarticExponent = 1) := by
  by_cases accept : f^quarticExponent = 1
  · have nonzero : f ≠ 0 := by
      intro hz
      rw [hz, zero_pow (by decide : quarticExponent ≠ 0)] at accept
      exact zero_ne_one accept
    simp [accept, nonzero]
  · simp [accept]

theorem python_up_expression (u w e wp : Fp) :
    (4*u-pythonConstant_A_PRIME*e*e-2*wp*w)*(2 : Fp)⁻¹ =
      scaledUp montgomeryDelta u w e wp := by
  have ap : pythonConstant_A_PRIME = -2*(-4-2*montgomeryDelta) := by decide
  rw [ap]
  dsimp [scaledUp]
  ring

theorem python_half_expression (e wp w : Fp) :
    (w*w-pythonConstant_A*e*e-w*wp)*(2 : Fp)⁻¹ = scaledHalfU montgomeryDelta e wp w := by
  have a : pythonConstant_A = -4-2*montgomeryDelta := by decide
  rw [a]
  dsimp [scaledHalfU]
  ring

theorem python_body_refines_scaled_test
    (outer : Fp → Option Fp) (inner : Fp → Option (Bool × Fp))
    (power : Fp → Fp) (onCurve smallOrder : Fp → Fp → Bool)
    (valid : ∀ f, (decide (f ≠ 0) && decide (power f = 1)) = decide (power f = 1))
    (x y : Fp) :
    pythonBody_is_in_prime_order_subgroup outer inner power onCurve smallOrder x y =
      if !onCurve x y then false
      else if smallOrder x y then decide (x = 0 ∧ y = 1)
      else genericScaledTest outer inner power
        (montgomeryDelta*(1+y)*x*(x*(1-y))) (2*(1-y)) (x*(1-y)) := by
  have c (e : Fp) : pythonConstant_SQRT_2_B_PRIME*e*e = sqrtTwoDiscriminant*e^2 := by
    change sqrtTwoDiscriminant*e*e = _
    ring
  simp only [pythonBody_is_in_prime_order_subgroup, genericScaledTest,
    python_up_expression, python_half_expression, c, valid,
    Bool.false_eq_true, ↓reduceIte, Bool.decide_and]
  cases hCurve : onCurve x y <;> cases hSmall : smallOrder x y <;>
    simp only [Bool.not_true, Bool.not_false, Bool.false_eq_true, ↓reduceIte]
  cases hOuter : outer (4*(montgomeryDelta*(1+y)*x*(x*(1-y)))) with
  | none => rfl
  | some wp =>
    dsimp only
    cases hInner : inner (scaledUp montgomeryDelta
        (montgomeryDelta*(1+y)*x*(x*(1-y))) (2*(1-y)) (x*(1-y)) wp) with
    | none => rfl
    | some pair =>
      obtain ⟨flag, root⟩ := pair
      cases flag <;> rfl

theorem python_subgroup_flow_eq (x y : Fp) :
    pythonFlow_is_in_prime_order_subgroup x y =
      if onEdwards edwardsD x y then
        if x*y*(x^2+y^2) = 0 then decide (x = 0 ∧ y = 1)
        else scaledTest (montgomeryDelta*(1+y)*x*(x*(1-y))) (2*(1-y)) (x*(1-y))
      else false := by
  unfold pythonFlow_is_in_prime_order_subgroup
  change pythonBody_is_in_prime_order_subgroup pythonFlow_sqrt pythonFlow_sqrt_or_twice
    (fun f => f^quarticExponent) pythonFlow_is_on_curve pythonFlow_is_small_order x y = _
  rw [python_body_refines_scaled_test (valid := nonzero_quartic_test_eq)]
  have outer : pythonFlow_sqrt = sqrtModel := funext python_sqrt_flow_eq
  have inner : pythonFlow_sqrt_or_twice = sqrtPairModel := funext python_sqrt_pair_flow_eq
  rw [outer, inner, python_on_curve_flow_eq, python_small_order_flow_eq]
  simp only [Bool.not_eq_true', decide_eq_false_iff_not, decide_eq_true_eq, ite_not]
  rfl

end DivideAndPair
