module

public import Mathlib.NumberTheory.LegendreSymbol.QuadraticChar.Basic
public import DivideAndPair.Halving

@[expose] public section

namespace DivideAndPair

variable {F : Type*} [Field F] [Fintype F]

theorem square_or_square_partner (a b : F) (hb : b ≠ 0) (hab : ¬IsSquare (a*b)) :
    IsSquare a ∨ IsSquare b := by
  classical
  by_cases ha : IsSquare a
  · exact Or.inl ha
  · right
    apply (quadraticChar_one_iff_isSquare hb).mp
    have hprod := quadraticChar_neg_one_iff_not_isSquare.mpr hab
    have hchar := quadraticChar_neg_one_iff_not_isSquare.mpr ha
    rw [map_mul, hchar] at hprod
    linear_combination -hprod

theorem square_or_twice_square (a : F) (ha : a ≠ 0) (two : ¬IsSquare (2 : F)) :
    IsSquare a ∨ IsSquare (2*a) := by
  classical
  by_cases square : IsSquare a
  · exact Or.inl square
  · right
    apply (quadraticChar_one_iff_isSquare (mul_ne_zero ?_ ha)).mp
    · rw [map_mul, quadraticChar_neg_one_iff_not_isSquare.mpr two,
        quadraticChar_neg_one_iff_not_isSquare.mpr square]
      decide
    · intro h
      exact two (by rw [h]; exact IsSquare.zero)

end DivideAndPair
