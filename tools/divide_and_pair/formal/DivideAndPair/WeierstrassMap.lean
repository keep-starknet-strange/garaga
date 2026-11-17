module

public import DivideAndPair.EdwardsMap
public import DivideAndPair.CairoFlow

@[expose] public section

namespace DivideAndPair

noncomputable section

set_option maxRecDepth 8192
set_option maxHeartbeats 1000000

private theorem threeNonzero : (3 : Fp) ≠ 0 := by decide
private theorem fourNonzero : (4 : Fp) ≠ 0 := by decide
private theorem sixNonzero : (6 : Fp) ≠ 0 := by decide
private theorem twelveNonzero : (12 : Fp) ≠ 0 := by decide

def shortX (d x y : Fp) : Fp := nativeU d x y / 4 + (-4-2*(-1-d))/12
def shortY (d x y : Fp) : Fp := nativeU d x y / (4*x)
def shortA (d : Fp) : Fp := -(1-14*d+d^2)/48
def shortB (d : Fp) : Fp := (d-1)*(-1-34*d-d^2)/864
def shortU (d X : Fp) : Fp := 4*X-(-4-2*(-1-d))/3
def shortV (Y : Fp) : Fp := 8*Y
def fromShortY (d X : Fp) : Fp := (-5-d-12*X)/(1+5*d-12*X)
def fromShortX (d X Y : Fp) : Fp :=
  (-1-d)*(1+fromShortY d X)/(4*Y*(1-fromShortY d X))

theorem short_inverse_denominator (d x y : Fp) (hden : 1-y ≠ 0) :
    1+5*d-12*shortX d x y = -6*(-1-d)/(1-y) := by
  dsimp [shortX, nativeU]
  field_simp [hden, fourNonzero, twelveNonzero]
  ring

theorem short_inverse_denominator_nonzero (d x y : Fp) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) :
    1+5*d-12*shortX d x y ≠ 0 := by
  rw [short_inverse_denominator d x y (native_denominator_nonzero d x y hd curve hx)]
  exact div_ne_zero (mul_ne_zero (by decide) hd)
    (native_denominator_nonzero d x y hd curve hx)

theorem short_inverse_y (d x y : Fp) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) :
    fromShortY d (shortX d x y) = y := by
  have hden := native_denominator_nonzero d x y hd curve hx
  have hinverse := short_inverse_denominator_nonzero d x y hd curve hx
  dsimp only [fromShortY]
  apply (div_eq_iff hinverse).mpr
  dsimp [shortX, nativeU]
  field_simp [hden, fourNonzero, twelveNonzero]
  ring

theorem short_inverse_x_denominator (d x y : Fp) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) :
    4*shortY d x y*(1-fromShortY d (shortX d x y)) = (-1-d)*(1+y)/x := by
  rw [short_inverse_y d x y hd curve hx]
  have hden := native_denominator_nonzero d x y hd curve hx
  dsimp [shortY, nativeU]
  field_simp [hx, hden, fourNonzero, twelveNonzero]

theorem short_inverse_x_denominator_nonzero (d x y : Fp) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) :
    4*shortY d x y*(1-fromShortY d (shortX d x y)) ≠ 0 := by
  rw [short_inverse_x_denominator d x y hd curve hx]
  exact div_ne_zero (mul_ne_zero hd (native_numerator_nonzero d x y hd curve hx)) hx

theorem short_inverse_x (d x y : Fp) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) :
    fromShortX d (shortX d x y) (shortY d x y) = x := by
  dsimp only [fromShortX]
  rw [short_inverse_x_denominator d x y hd curve hx,
    short_inverse_y d x y hd curve hx]
  field_simp [hx, hd, native_numerator_nonzero d x y hd curve hx]

theorem short_coordinates (d x y : Fp) (hx : x ≠ 0) :
    shortU d (shortX d x y) = nativeU d x y ∧
      nativeU d x y*nativeW x = shortV (shortY d x y) := by
  dsimp [shortU, shortX, shortV, shortY, nativeW]
  constructor <;> field_simp [hx, threeNonzero, fourNonzero, twelveNonzero] <;> ring

theorem cairo_from_weierstrass_eq (X Y : Fp) :
    cairo_from_weierstrass X Y =
      [fromShortX edwardsD X Y, fromShortY edwardsD X] := by
  have c1 : (20800338683988658368647408995589388737092878452977063003340006470870624536389 : Fp) =
      -5-edwardsD := by decide
  have c2 : (11790395817372903580333940030740964167805592400755249022757551653560006957929 : Fp) =
      1+5*edwardsD := by decide
  have c3 : (20800338683988658368647408995589388737092878452977063003340006470870624536393 : Fp) =
      -1-edwardsD := by decide
  dsimp only [cairo_from_weierstrass, fromShortX, fromShortY]
  rw [c1, c2, c3]
  simp only [div_eq_mul_inv]

theorem cairo_from_weierstrass_native (x y : Fp) (curve : onEdwards edwardsD x y)
    (hx : x ≠ 0) :
    cairo_from_weierstrass (shortX edwardsD x y) (shortY edwardsD x y) = [x,y] := by
  rw [cairo_from_weierstrass_eq,
    short_inverse_x edwardsD x y delta_nonzero curve hx,
    short_inverse_y edwardsD x y delta_nonzero curve hx]

theorem short_curve_identity (d X Y : Fp) :
    (shortV Y)^2 - (shortU d X)^3 - (-4-2*(-1-d))*(shortU d X)^2 -
        (-1-d)^2*shortU d X =
      64*(Y^2-X^3-shortA d*X-shortB d) := by
  have h48 : (48 : Fp) ≠ 0 := by decide
  have h864 : (864 : Fp) ≠ 0 := by decide
  dsimp [shortU, shortV, shortA, shortB]
  field_simp [threeNonzero, h48, h864]
  ring

theorem short_to_montgomery_equation (d X Y : Fp)
    (curve : Y^2 = X^3+shortA d*X+shortB d) :
    (shortV Y)^2 = (shortU d X)^3+(-4-2*(-1-d))*(shortU d X)^2+
      (-1-d)^2*shortU d X := by
  have identity := short_curve_identity d X Y
  rw [curve] at identity
  linear_combination identity

theorem short_u_nonzero (d X Y : Fp) (hy : Y ≠ 0)
    (curve : Y^2 = X^3+shortA d*X+shortB d) : shortU d X ≠ 0 := by
  intro hu
  have eqn := short_to_montgomery_equation d X Y curve
  rw [hu] at eqn
  have hz : (shortV Y)^2 = 0 := by simpa using eqn
  exact (pow_ne_zero 2 (mul_ne_zero (by decide : (8 : Fp) ≠ 0) hy)) hz

theorem short_u_plus_delta_nonzero (d X Y : Fp) (hd : -1-d ≠ 0)
    (dnsq : ¬IsSquare d) (curve : Y^2 = X^3+shortA d*X+shortB d) :
    shortU d X+(-1-d) ≠ 0 := by
  intro hzero
  have hu : shortU d X = -(-1-d) := by linear_combination hzero
  have eqn := short_to_montgomery_equation d X Y curve
  rw [hu] at eqn
  have square : (shortV Y)^2 = 4*d*(-1-d)^2 := by linear_combination eqn
  apply dnsq
  refine ⟨shortV Y/(2*(-1-d)), ?_⟩
  field_simp [hd, ed25519_two_nonzero]
  linear_combination -square

theorem short_source_denominator_eq (d X : Fp) :
    1+5*d-12*X = -3*(shortU d X+(-1-d)) := by
  dsimp [shortU]
  field_simp [threeNonzero]
  ring

theorem short_source_denominator_nonzero (d X Y : Fp) (hd : -1-d ≠ 0)
    (dnsq : ¬IsSquare d) (curve : Y^2 = X^3+shortA d*X+shortB d) :
    1+5*d-12*X ≠ 0 := by
  rw [short_source_denominator_eq]
  exact mul_ne_zero (neg_ne_zero.mpr threeNonzero)
    (short_u_plus_delta_nonzero d X Y hd dnsq curve)

theorem from_short_one_minus_y (d X : Fp) (hden : 1+5*d-12*X ≠ 0) :
    1-fromShortY d X = -6*(-1-d)/(1+5*d-12*X) := by
  dsimp [fromShortY]
  field_simp [hden]
  ring

theorem from_short_one_plus_y (d X : Fp) (hden : 1+5*d-12*X ≠ 0) :
    1+fromShortY d X = -6*shortU d X/(1+5*d-12*X) := by
  dsimp [fromShortY, shortU]
  field_simp [hden, threeNonzero]
  ring

theorem from_short_one_minus_y_nonzero (d X : Fp) (hd : -1-d ≠ 0)
    (hden : 1+5*d-12*X ≠ 0) : 1-fromShortY d X ≠ 0 := by
  rw [from_short_one_minus_y d X hden]
  exact div_ne_zero (mul_ne_zero (by decide) hd) hden

theorem from_short_x_eq (d X Y : Fp) (hd : -1-d ≠ 0) (hy : Y ≠ 0)
    (hden : 1+5*d-12*X ≠ 0) : fromShortX d X Y = shortU d X/(4*Y) := by
  dsimp only [fromShortX]
  rw [from_short_one_minus_y d X hden, from_short_one_plus_y d X hden]
  have hden' : 1+d*5-12*X ≠ 0 := by simpa only [mul_comm 5 d] using hden
  field_simp [hd, hy, hden, hden', fourNonzero, sixNonzero]

theorem from_short_x_nonzero (d X Y : Fp) (hd : -1-d ≠ 0) (dnsq : ¬IsSquare d)
    (hy : Y ≠ 0) (curve : Y^2 = X^3+shortA d*X+shortB d) :
    fromShortX d X Y ≠ 0 := by
  rw [from_short_x_eq d X Y hd hy (short_source_denominator_nonzero d X Y hd dnsq curve)]
  exact div_ne_zero (short_u_nonzero d X Y hy curve) (mul_ne_zero fourNonzero hy)

theorem from_short_native_coordinates (d X Y : Fp) (hd : -1-d ≠ 0)
    (dnsq : ¬IsSquare d) (hy : Y ≠ 0)
    (curve : Y^2 = X^3+shortA d*X+shortB d) :
    nativeU d (fromShortX d X Y) (fromShortY d X) = shortU d X ∧
      nativeU d (fromShortX d X Y) (fromShortY d X)*nativeW (fromShortX d X Y) =
        shortV Y := by
  have hden := short_source_denominator_nonzero d X Y hd dnsq curve
  have hu := short_u_nonzero d X Y hy curve
  have xeq := from_short_x_eq d X Y hd hy hden
  have ueq : nativeU d (fromShortX d X Y) (fromShortY d X) = shortU d X := by
    dsimp only [nativeU]
    rw [from_short_one_minus_y d X hden, from_short_one_plus_y d X hden]
    have hden' : 1+d*5-12*X ≠ 0 := by simpa only [mul_comm 5 d] using hden
    field_simp [hd, hden, hden', sixNonzero]
  refine ⟨ueq, ?_⟩
  rw [ueq, xeq]
  dsimp [nativeW, shortV]
  field_simp [hy, hu, fourNonzero]
  ring

theorem from_short_on_edwards (d X Y : Fp) (hd : -1-d ≠ 0)
    (dnsq : ¬IsSquare d) (hy : Y ≠ 0)
    (curve : Y^2 = X^3+shortA d*X+shortB d) :
    onEdwards d (fromShortX d X Y) (fromShortY d X) := by
  have hden := short_source_denominator_nonzero d X Y hd dnsq curve
  have hu := short_u_nonzero d X Y hy curve
  have eqn := short_to_montgomery_equation d X Y curve
  have hyformula : fromShortY d X = (shortU d X-(-1-d))/(shortU d X+(-1-d)) := by
    have hplus := short_u_plus_delta_nonzero d X Y hd dnsq curve
    dsimp only [fromShortY]
    apply (div_eq_div_iff hden hplus).mpr
    dsimp [shortU]
    field_simp [threeNonzero]
    ring
  rw [from_short_x_eq d X Y hd hy hden]
  dsimp only [onEdwards]
  rw [hyformula]
  have hplus := short_u_plus_delta_nonzero d X Y hd dnsq curve
  field_simp [hy, hplus, fourNonzero]
  dsimp [shortV] at eqn
  linear_combination (d+1)*shortU d X*eqn

theorem native_on_short (d x y : Fp) (hd : -1-d ≠ 0)
    (curve : onEdwards d x y) (hx : x ≠ 0) :
    (shortY d x y)^2 = (shortX d x y)^3+shortA d*shortX d x y+shortB d := by
  have native := native_on_montgomery d x y hd curve hx
  obtain ⟨uEq, vEq⟩ := short_coordinates d x y hx
  have identity := short_curve_identity d (shortX d x y) (shortY d x y)
  rw [uEq, ← vEq] at identity
  dsimp only [onMontgomery] at native
  have hz : 64*((shortY d x y)^2-(shortX d x y)^3-shortA d*shortX d x y-shortB d) = 0 := by
    linear_combination nativeU d x y*native - identity
  have zero := (mul_eq_zero.mp hz).resolve_left (by decide : (64 : Fp) ≠ 0)
  linear_combination zero

theorem ed25519_short_coefficients :
    shortA edwardsD =
      42204101795669822316448953119945047945709099015225996174933988943478124189485 ∧
    shortB edwardsD =
      13148341720542919587570920744190446479425344491440436116213316435534172959396 := by
  constructor
  · dsimp only [shortA]
    apply (div_eq_iff (by decide : (48 : Fp) ≠ 0)).mpr
    decide
  · dsimp only [shortB]
    apply (div_eq_iff (by decide : (864 : Fp) ≠ 0)).mpr
    decide

theorem source_curve_parameters :
    cairoCurve_p = 57896044618658097711785492504343953926634992332820282019728792003956564819949 ∧
    cairoCurve_n = subgroupOrder ∧ cairoCurve_a = pythonCurveA ∧ cairoCurve_b = pythonCurveB := by
  decide

theorem source_short_coefficients :
    shortA edwardsD = cairoCurve_a ∧ shortB edwardsD = cairoCurve_b :=
  ed25519_short_coefficients

theorem cairo_from_weierstrass_chart (X Y : Fp) (hy : Y ≠ 0)
    (curve : Y^2 = X^3+shortA edwardsD*X+shortB edwardsD) :
    ∃ x y, cairo_from_weierstrass X Y = [x,y] ∧ onEdwards edwardsD x y ∧ x ≠ 0 ∧
      1+5*edwardsD-12*X ≠ 0 ∧ 4*Y*(1-y) ≠ 0 ∧
      nativeU edwardsD x y = shortU edwardsD X ∧
      nativeU edwardsD x y*nativeW x = shortV Y := by
  have hden := short_source_denominator_nonzero edwardsD X Y delta_nonzero
    edwards_d_nonsquare curve
  have hcoordinates := from_short_native_coordinates edwardsD X Y delta_nonzero
    edwards_d_nonsquare hy curve
  refine ⟨fromShortX edwardsD X Y, fromShortY edwardsD X,
    cairo_from_weierstrass_eq X Y,
    from_short_on_edwards edwardsD X Y delta_nonzero edwards_d_nonsquare hy curve,
    from_short_x_nonzero edwardsD X Y delta_nonzero edwards_d_nonsquare hy curve,
    hden, ?_, hcoordinates⟩
  exact mul_ne_zero (mul_ne_zero fourNonzero hy)
    (from_short_one_minus_y_nonzero edwardsD X delta_nonzero hden)


end
end DivideAndPair
