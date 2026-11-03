module

public import DivideAndPair.CairoFlow
public import DivideAndPair.Scaled

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192

theorem cairo_sqrt_flow_eq (value : Fp) : cairoFlow_sqrt value = sqrtModel value := by
  have power : (value^sqrtExponent)^2 = value^(2^253-4) := by
    rw [← pow_mul]
    rfl
  have imaginary : cairoConstant_SQRT_MINUS_ONE = sqrtMinusOne := rfl
  simp [cairoFlow_sqrt, cairo_sqrt_eq, sqrtModel, imaginary,
    ← pow_mul, sqrtExponent, sub_eq_zero, add_eq_zero_iff_eq_neg]

theorem cairo_sqrt_pair_flow_eq (value : Fp) :
    cairoFlow_sqrt_or_twice value = sqrtPairModel value := by
  have power : (value^sqrtExponent)^2 = value^(2^253-4) := by
    rw [← pow_mul]
    rfl
  have imaginary : cairoConstant_SQRT_MINUS_ONE = sqrtMinusOne := rfl
  have constant : cairoConstant_SQRT_TWO_I = sqrtTwoI := rfl
  have product : cairoConstant_I_SQRT_TWO_I = sqrtTwoI*sqrtMinusOne := by decide
  simp [cairoFlow_sqrt_or_twice, cairo_sqrt_or_twice_eq, sqrtPairModel,
    imaginary, constant, product, ← pow_mul, sqrtExponent, sub_eq_zero, add_eq_zero_iff_eq_neg]

theorem cairo_small_order_flow_eq (x y : Fp) :
    cairoFlow_is_small_order_edwards x y = decide (x*y*(x^2+y^2) = 0) := by
  simp [cairoFlow_is_small_order_edwards, cairo_low_order_eq, mul_eq_zero, or_assoc]
  exact Bool.or_assoc _ _ _

end DivideAndPair
