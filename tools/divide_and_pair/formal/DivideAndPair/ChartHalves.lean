module

public import DivideAndPair.FixedPoints
public import DivideAndPair.Quartic

@[expose] public section

namespace DivideAndPair

variable {F : Type*} [Field F]

noncomputable def halfChartPoint (delta u w : F) (two : (2 : F) ≠ 0)
    (half : RationalHalf delta u w) : (montgomeryCurve delta).toAffine.Point :=
  chartPoint delta half.q half.v two half.q_ne_zero half.v_ne_zero half.curve

theorem rational_half_is_group_half [DecidableEq F] (delta u w : F)
    (two : (2 : F) ≠ 0) (hu : u ≠ 0) (hw : w ≠ 0)
    (curve : onMontgomery delta u w) (half : RationalHalf delta u w) :
    (2 : Nat) • halfChartPoint delta u w two half = chartPoint delta u w two hu hw curve := by
  obtain ⟨hn, equation⟩ := chart_double delta half.q half.v two
    half.q_ne_zero half.v_ne_zero half.curve
  change (2 : Nat) • chartPoint delta half.q half.v two
    half.q_ne_zero half.v_ne_zero half.curve = _
  rw [two_nsmul, equation]
  unfold chartPoint
  simp only [WeierstrassCurve.Affine.Point.some.injEq]
  exact ⟨half.double_u, by rw [half.double_u, half.double_w]⟩

theorem group_half_has_rational_chart [DecidableEq F] (delta u w : F)
    (two : (2 : F) ≠ 0) (hu : u ≠ 0) (hw : w ≠ 0)
    (curve : onMontgomery delta u w)
    (Q : (montgomeryCurve delta).toAffine.Point)
    (equation : (2 : Nat) • Q = chartPoint delta u w two hu hw curve) :
    ∃ half : RationalHalf delta u w, Q = halfChartPoint delta u w two half := by
  classical
  have target_nonzero : chartPoint delta u w two hu hw curve ≠ 0 :=
    WeierstrassCurve.Affine.Point.some_ne_zero _
  cases Q with
  | zero =>
    have target_zero : chartPoint delta u w two hu hw curve = 0 := by
      simpa only [← WeierstrassCurve.Affine.Point.zero_def, nsmul_zero] using equation.symm
    exact (target_nonzero target_zero).elim
  | some q y hQ =>
    have raw : y^2 = q^3+(-4-2*delta)*q^2+delta^2*q := by
      have h := hQ.1
      rw [WeierstrassCurve.Affine.equation_iff] at h
      simpa [montgomeryCurve] using h
    have hy : y ≠ 0 := by
      intro hy
      have opposite : y = (montgomeryCurve delta).toAffine.negY q y := by
        simp [montgomeryCurve, WeierstrassCurve.Affine.negY, hy]
      have doubled : (WeierstrassCurve.Affine.Point.some q y hQ :
          (montgomeryCurve delta).toAffine.Point) + .some q y hQ = 0 :=
        WeierstrassCurve.Affine.Point.add_self_of_Y_eq opposite
      apply target_nonzero
      rw [← equation, two_nsmul, doubled]
    have hq : q ≠ 0 := by
      intro hq
      apply hy
      have hy2 : y^2 = 0 := by simpa [hq] using raw
      exact eq_zero_of_pow_eq_zero hy2
    let v := y/q
    have hv : v ≠ 0 := div_ne_zero hy hq
    have y_eq : q*v = y := by dsimp [v]; field_simp [hq]
    have source_curve : onMontgomery delta q v := by
      dsimp [onMontgomery, v]
      field_simp [hq]
      linear_combination raw
    have source_point : (WeierstrassCurve.Affine.Point.some q y hQ :
        (montgomeryCurve delta).toAffine.Point) = chartPoint delta q v two hq hv source_curve := by
      unfold chartPoint
      simp only [WeierstrassCurve.Affine.Point.some.injEq]
      exact ⟨True.intro, y_eq.symm⟩
    obtain ⟨hn, doubled⟩ := chart_double delta q v two hq hv source_curve
    have equal_points : (WeierstrassCurve.Affine.Point.some
        (montgomeryDoubleU delta q v)
        (montgomeryDoubleU delta q v*montgomeryDoubleW delta q v) hn :
        (montgomeryCurve delta).toAffine.Point) = chartPoint delta u w two hu hw curve := by
      rw [← doubled, ← two_nsmul, ← source_point]
      exact equation
    have coordinates := WeierstrassCurve.Affine.Point.some.inj equal_points
    have double_u : montgomeryDoubleU delta q v = u := coordinates.1
    have double_w : montgomeryDoubleW delta q v = w := by
      apply mul_left_cancel₀ hu
      simpa only [double_u] using coordinates.2
    have numerator : q^2-delta^2 ≠ 0 := by
      intro hz
      apply hu
      rw [← double_u]
      simp [montgomeryDoubleU, doubleRoot, hz]
    exact ⟨⟨q,v,source_curve,hq,hv,numerator,double_u,double_w⟩, source_point⟩

theorem rational_two_halves_iff_group_four_divisible [DecidableEq F] (delta u w : F)
    (two : (2 : F) ≠ 0) (hu : u ≠ 0) (hw : w ≠ 0)
    (curve : onMontgomery delta u w) :
    (∃ half : RationalHalf delta u w, Nonempty (RationalHalf delta half.q half.v)) ↔
      ∃ Q : (montgomeryCurve delta).toAffine.Point,
        (4 : Nat) • Q = chartPoint delta u w two hu hw curve := by
  constructor
  · rintro ⟨half, ⟨quarter⟩⟩
    have first := rational_half_is_group_half delta u w two hu hw curve half
    have second := rational_half_is_group_half delta half.q half.v two
      half.q_ne_zero half.v_ne_zero half.curve quarter
    refine ⟨halfChartPoint delta half.q half.v two quarter, ?_⟩
    calc
      (4 : Nat) • halfChartPoint delta half.q half.v two quarter =
          (2 : Nat) • ((2 : Nat) • halfChartPoint delta half.q half.v two quarter) := by
        simp only [smul_smul]
        rfl
      _ = (2 : Nat) • halfChartPoint delta u w two half := by
        change (2 : Nat) • ((2 : Nat) • halfChartPoint delta half.q half.v two quarter) =
          (2 : Nat) • chartPoint delta half.q half.v two
            half.q_ne_zero half.v_ne_zero half.curve
        rw [second]
      _ = chartPoint delta u w two hu hw curve := first
  · rintro ⟨Q, hQ⟩
    let H := (2 : Nat) • Q
    have first : (2 : Nat) • H = chartPoint delta u w two hu hw curve := by
      simpa [H, smul_smul] using hQ
    obtain ⟨half, hH⟩ := group_half_has_rational_chart delta u w two hu hw curve H first
    have second : (2 : Nat) • Q = chartPoint delta half.q half.v two
        half.q_ne_zero half.v_ne_zero half.curve := hH
    obtain ⟨quarter, _⟩ := group_half_has_rational_chart delta half.q half.v two
      half.q_ne_zero half.v_ne_zero half.curve Q second
    exact ⟨half, ⟨quarter⟩⟩

theorem quartic_iff_group_four_divisible [Fintype F] [DecidableEq F]
    (delta u w i : F) (two : (2 : F) ≠ 0) (hd : delta ≠ 0)
    (hb : ¬IsSquare (16*(1+delta)))
    (hu : u ≠ 0) (hw : w ≠ 0) (curve : onMontgomery delta u w)
    (hi : i^2 = -1) (nonzero : miller4 u w i ≠ 0) :
    (∃ z : F, z^4 = miller4 u w i) ↔
      ∃ Q : (montgomeryCurve delta).toAffine.Point,
        (4 : Nat) • Q = chartPoint delta u w two hu hw curve :=
  (quartic_iff_two_halves delta u w i two hd hb curve hi nonzero).trans
    (rational_two_halves_iff_group_four_divisible delta u w two hu hw curve)

theorem ed25519_quartic_exponent_iff_group_four_divisible (u w : Fp)
    (hu : u ≠ 0) (hw : w ≠ 0) (curve : onMontgomery montgomeryDelta u w)
    (nonzero : miller4 u w sqrtMinusOne ≠ 0) :
    (miller4 u w sqrtMinusOne)^quarticExponent = 1 ↔
      ∃ Q : EdGroup, (4 : Nat) • Q =
        chartPoint montgomeryDelta u w ed25519_two_nonzero hu hw curve :=
  (quartic_residue_iff_root _ nonzero).trans
    (quartic_iff_group_four_divisible montgomeryDelta u w sqrtMinusOne
      ed25519_two_nonzero delta_nonzero montgomery_discriminant_nonsquare
      hu hw curve sqrt_minus_one_correct nonzero)


end DivideAndPair
