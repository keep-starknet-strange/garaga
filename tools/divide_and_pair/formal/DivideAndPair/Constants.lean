module

public import DivideAndPair.Generated
public import DivideAndPair.Squares

@[expose] public section

namespace DivideAndPair

set_option maxRecDepth 8192
set_option maxHeartbeats 1000000

abbrev edwardsD : Fp :=
  37095705934669439343138083508754565189542113879843219016388785533085940283555
abbrev sqrtMinusOne : Fp :=
  19681161376707505956807079304988542015446066515923890162744021073123829784752
abbrev montgomeryDelta : Fp := -1-edwardsD
abbrev sqrtTwoI : Fp :=
  38214883241950591754978413199355411911188925816896391856984770930832735035196
abbrev sqrtTwoDiscriminant : Fp :=
  46902340116190997102098187643918485604163952319255431191182728563730867863457

theorem ed25519_two_nonzero : (2 : Fp) ≠ 0 := by decide
theorem sqrt_minus_one_correct : sqrtMinusOne^2 = (-1 : Fp) := by decide
theorem sqrt_two_i_correct : sqrtTwoI^2 = 2*sqrtMinusOne := by decide
theorem sqrt_two_discriminant_correct :
    sqrtTwoDiscriminant^2 = 2*(16*(1+montgomeryDelta)) := by decide
theorem delta_nonzero : montgomeryDelta ≠ 0 := by decide

private theorem char_ne_two : ringChar Fp ≠ 2 := by
  rw [ZMod.ringChar_zmod_n]
  decide

theorem edwards_d_nonsquare : ¬IsSquare edwardsD := by
  rw [FiniteField.isSquare_iff char_ne_two (by decide : edwardsD ≠ 0)]
  simp only [ZMod.card]
  decide

theorem montgomery_discriminant_nonsquare : ¬IsSquare (16*(1+montgomeryDelta)) := by
  rw [FiniteField.isSquare_iff char_ne_two (by decide : (16*(1+montgomeryDelta) : Fp) ≠ 0)]
  simp only [ZMod.card]
  decide

theorem ed25519_two_nonsquare : ¬IsSquare (2 : Fp) := by
  rw [FiniteField.isSquare_iff char_ne_two ed25519_two_nonzero]
  simp only [ZMod.card]
  decide

end DivideAndPair
