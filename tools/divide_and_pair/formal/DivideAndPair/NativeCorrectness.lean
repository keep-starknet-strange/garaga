module

public import DivideAndPair.ScaledAlgorithm
public import DivideAndPair.EdwardsMap

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192

theorem prepared_test_iff_subgroup (x y : Fp) (curve : onEdwards edwardsD x y)
    (hx : x ≠ 0) :
    scaledTest (montgomeryDelta*(1+y)*x*(x*(1-y))) (2*(1-y)) (x*(1-y)) = true ↔
      subgroupOrder • nativePoint x y curve = 0 := by
  have hden := native_denominator_nonzero edwardsD x y delta_nonzero curve hx
  have he : x*(1-y) ≠ 0 := mul_ne_zero hx hden
  obtain ⟨first, second⟩ := native_prepare_scale edwardsD x y hx hden
  rw [first, second]
  simp only [nativePoint, dite_eq_right hx]
  exact scaled_test_iff_subgroup (nativeU edwardsD x y) (nativeW x) (x*(1-y)) he
    (native_on_montgomery edwardsD x y delta_nonzero curve hx)

theorem native_decision_iff_subgroup (x y : Fp) (curve : onEdwards edwardsD x y) :
    (if x*y*(x^2+y^2) = 0 then decide (x = 0 ∧ y = 1)
      else scaledTest (montgomeryDelta*(1+y)*x*(x*(1-y))) (2*(1-y)) (x*(1-y))) = true ↔
      subgroupOrder • nativePoint x y curve = 0 := by
  by_cases guard : x*y*(x^2+y^2) = 0
  · simp only [guard, ↓reduceIte, decide_eq_true_eq]
    exact (guarded_subgroup_iff_identity x y curve guard).symm
  · have hx : x ≠ 0 := by
      intro hx
      apply guard
      simp only [hx, zero_mul]
    simp only [guard, ↓reduceIte]
    exact prepared_test_iff_subgroup x y curve hx

end DivideAndPair
