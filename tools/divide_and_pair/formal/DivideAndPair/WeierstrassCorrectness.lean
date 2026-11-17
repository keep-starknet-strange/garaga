module

public import DivideAndPair.WeierstrassMap
public import DivideAndPair.SourceCorrectness

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192

noncomputable def shortChartPoint (X Y : Fp) (hy : Y ≠ 0)
    (curve : Y^2 = X^3+shortA edwardsD*X+shortB edwardsD) : EdGroup :=
  .some (shortU edwardsD X) (shortV Y) (by
    refine ⟨?_, Or.inr ?_⟩
    · rw [WeierstrassCurve.Affine.equation_iff]
      simpa [montgomeryCurve] using short_to_montgomery_equation edwardsD X Y curve
    · rw [WeierstrassCurve.Affine.evalEval_polynomialY]
      simpa [montgomeryCurve, shortV] using
        mul_ne_zero ed25519_two_nonzero (mul_ne_zero (by decide : (8 : Fp) ≠ 0) hy))

theorem from_short_point_eq (X Y : Fp) (hy : Y ≠ 0)
    (curve : Y^2 = X^3+shortA edwardsD*X+shortB edwardsD) :
    nativePoint (fromShortX edwardsD X Y) (fromShortY edwardsD X)
      (from_short_on_edwards edwardsD X Y delta_nonzero edwards_d_nonsquare hy curve) =
      shortChartPoint X Y hy curve := by
  have hx := from_short_x_nonzero edwardsD X Y delta_nonzero edwards_d_nonsquare hy curve
  have coordinates := from_short_native_coordinates edwardsD X Y delta_nonzero
    edwards_d_nonsquare hy curve
  simp only [nativePoint, dite_eq_right hx, chartPoint, shortChartPoint,
    WeierstrassCurve.Affine.Point.some.injEq]
  exact coordinates

/-- The public API's field chart: the actual conversion IR followed by the extracted test. -/
noncomputable def cairoShortChartTest (X Y : Fp) : Bool :=
  let output := cairo_from_weierstrass X Y
  cairoFlow_is_in_prime_order_subgroup_edwards output[0]! output[1]!

theorem cairo_short_chart_correct (X Y : Fp) (hy : Y ≠ 0)
    (curve : Y^2 = X^3+cairoCurve_a*X+cairoCurve_b) :
    cairoShortChartTest X Y = true ↔
      subgroupOrder • shortChartPoint X Y hy
        (by simpa only [source_short_coefficients.1, source_short_coefficients.2] using curve) = 0 := by
  have modelCurve : Y^2 = X^3+shortA edwardsD*X+shortB edwardsD := by
    simpa only [source_short_coefficients.1, source_short_coefficients.2] using curve
  unfold cairoShortChartTest
  rw [cairo_from_weierstrass_eq]
  simp only [List.getElem!_cons_zero, List.getElem!_cons_succ]
  rw [cairo_source_subgroup_correct _ _
    (from_short_on_edwards edwardsD X Y delta_nonzero edwards_d_nonsquare hy modelCurve)]
  rw [from_short_point_eq X Y hy modelCurve]

end DivideAndPair
