module

public import DivideAndPair.CairoRefinement
public import DivideAndPair.PythonRefinement
public import DivideAndPair.NativeCorrectness

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192

/-- Correctness of the compiler-AST-derived Cairo test on every Edwards point. -/
theorem cairo_source_subgroup_correct (x y : Fp) (curve : onEdwards edwardsD x y) :
    cairoFlow_is_in_prime_order_subgroup_edwards x y = true ↔
      subgroupOrder • nativePoint x y curve = 0 := by
  rw [cairo_subgroup_flow_eq]
  exact native_decision_iff_subgroup x y curve

/-- Correctness of the Python-AST-derived test, including its assertion path. -/
theorem python_source_subgroup_correct (x y : Fp) (curve : onEdwards edwardsD x y) :
    pythonFlow_is_in_prime_order_subgroup x y = true ↔
      subgroupOrder • nativePoint x y curve = 0 := by
  rw [python_subgroup_flow_eq, ite_eq_left curve]
  exact native_decision_iff_subgroup x y curve

theorem cairo_python_subgroup_agree (x y : Fp) (curve : onEdwards edwardsD x y) :
    cairoFlow_is_in_prime_order_subgroup_edwards x y = pythonFlow_is_in_prime_order_subgroup x y := by
  apply Bool.eq_iff_iff.mpr
  exact (cairo_source_subgroup_correct x y curve).trans
    (python_source_subgroup_correct x y curve).symm

theorem python_source_rejects_off_curve (x y : Fp) (off : ¬onEdwards edwardsD x y) :
    pythonFlow_is_in_prime_order_subgroup x y = false := by
  rw [python_subgroup_flow_eq, ite_eq_right off]

/-- The signature policy equals three complete Edwards doublings. -/
theorem cairo_source_small_order_correct (x y : Fp) (curve : onEdwards edwardsD x y) :
    cairoFlow_is_small_order_edwards x y = true ↔
      let x2 := doubleX edwardsD x y
      let y2 := doubleY edwardsD x y
      let x4 := doubleX edwardsD x2 y2
      let y4 := doubleY edwardsD x2 y2
      doubleX edwardsD x4 y4 = 0 ∧ doubleY edwardsD x4 y4 = 1 := by
  rw [cairo_small_order_flow_eq, decide_eq_true_eq]
  exact (low_order_complete edwardsD x y sqrtMinusOne ed25519_two_nonzero
    edwards_d_nonsquare sqrt_minus_one_correct curve).symm

end DivideAndPair
