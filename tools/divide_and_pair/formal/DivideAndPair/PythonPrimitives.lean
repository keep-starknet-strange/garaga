module

public import DivideAndPair.PythonFlow
public import DivideAndPair.FlowLemmas

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192

theorem python_sqrt_flow_eq (value : Fp) : pythonFlow_sqrt value = sqrtModel value := by
  have correction : ((value^sqrtExponent)*sqrtMinusOne)^2 = value ↔
      (value^sqrtExponent)^2 = -value := by
    simp only [mul_pow, sqrt_minus_one_correct, mul_neg_one, neg_eq_iff_eq_neg]
  simp [pythonFlow_sqrt, sqrtModel, pythonConstant_I, ← pow_two, sqrtExponent] at correction ⊢
  split_ifs <;> simp_all

theorem python_sqrt_pair_flow_eq (value : Fp) :
    pythonFlow_sqrt_or_twice value = sqrtPairModel value := by
  simp [pythonFlow_sqrt_or_twice, sqrtPairModel, pythonConstant_I, pythonConstant_SQRT_TWO_I,
    sqrtExponent, pow_two, mul_assoc, neg_mul]

theorem python_sqrt_pair_assertion_cannot_fail (value : Fp) :
    (pythonFlow_sqrt_or_twice value).isSome = true := by
  rw [python_sqrt_pair_flow_eq]
  exact sqrt_pair_complete value

theorem python_on_curve_flow_eq (x y : Fp) :
    pythonFlow_is_on_curve x y = decide (onEdwards edwardsD x y) := by
  have equivalent : y*y-x*x-1-edwardsD*x*x*y*y = 0 ↔ onEdwards edwardsD x y := by
    dsimp [onEdwards]
    constructor <;> intro h <;> linear_combination h
  exact decide_eq_decide.mpr equivalent

theorem python_small_order_flow_eq (x y : Fp) :
    pythonFlow_is_small_order x y = decide (x*y*(x^2+y^2) = 0) := by
  simp only [pythonFlow_is_small_order, pow_two]

end DivideAndPair
