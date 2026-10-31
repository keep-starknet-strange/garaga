module

public import DivideAndPair.Generated
public import DivideAndPair.LowOrder
public import DivideAndPair.PowerProofs
public import DivideAndPair.Constants

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192
set_option maxHeartbeats 3000000

theorem cairo_low_order_eq (x y : Fp) : cairo_low_order x y = [x^2+y^2] := by
  dsimp [cairo_low_order]
  congr 1
  ring

theorem cairo_prepare_eq (x y : Fp) : cairo_prepare x y =
    [montgomeryDelta*(1+y)*x*(x*(1-y)), 2*(1-y), x*(1-y)] := by
  have constant : (20800338683988658368647408995589388737092878452977063003340006470870624536393 : Fp) =
      montgomeryDelta := by decide
  dsimp [cairo_prepare]
  rw [constant]

theorem cairo_halve_up_eq (u w e wp : Fp) : cairo_halve_up u w e wp =
    [(4*u-(-2*(-4-2*montgomeryDelta))*e^2-2*wp*w)/2] := by
  have constant : (25305310117296535762804143478013601021736521479087969993631233879525933325631 : Fp) =
      -2*(-4-2*montgomeryDelta) := by decide
  have inverse : (28948022309329048855892746252171976963317496166410141009864396001978282409975 : Fp) =
      (2 : Fp)⁻¹ := by
    apply (mul_eq_one_iff_eq_inv₀ ed25519_two_nonzero).mp
    decide
  dsimp [cairo_halve_up]
  rw [constant, inverse]
  congr 1
  ring

theorem cairo_halve_nqr_eq (e wp root : Fp) : cairo_halve_nqr e wp root =
    [e*root, wp*root, sqrtTwoDiscriminant*e^2] := by
  dsimp [cairo_halve_nqr, sqrtTwoDiscriminant]
  simp only [pow_two]

theorem cairo_miller_input_eq (e wp w sign : Fp) : cairo_miller_input e wp w sign =
    ((w^2-(-4-2*montgomeryDelta)*e^2-w*wp)/2)*(sign*w+2*sqrtMinusOne*e)^2 := by
  have constant : (16295367250680780974490674513165176452449235426866156013048779062215315747159 : Fp) =
      -4-2*montgomeryDelta := by decide
  have inverse : (28948022309329048855892746252171976963317496166410141009864396001978282409975 : Fp) =
      (2 : Fp)⁻¹ := by
    apply (mul_eq_one_iff_eq_inv₀ ed25519_two_nonzero).mp
    decide
  have imaginary : (39362322753415011913614158609977084030892133031847780325488042146247659569504 : Fp) =
      2*sqrtMinusOne := by decide
  dsimp [cairo_miller_input]
  rw [constant, inverse, imaginary]
  ring

end DivideAndPair
