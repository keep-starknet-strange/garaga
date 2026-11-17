module

public import DivideAndPair.Constants

@[expose] public section

namespace DivideAndPair

abbrev quarticExponent : Nat := 2^253-5
abbrev sqrtExponent : Nat := 2^252-2

theorem quartic_residue_iff_root (f : Fp) (hf : f ≠ 0) :
    f^quarticExponent = 1 ↔ ∃ z : Fp, z^4 = f := by
  constructor
  · intro h
    refine ⟨f^(2^251-1), ?_⟩
    rw [← pow_mul]
    have exponent : (2^251-1)*4 = quarticExponent+1 := by decide
    rw [exponent, pow_succ, h, one_mul]
  · rintro ⟨z, hz⟩
    have hz0 : z ≠ 0 := by
      intro h
      apply hf
      simpa [h] using hz.symm
    have fermat := FiniteField.pow_card_sub_one_eq_one z hz0
    simp only [ZMod.card] at fermat
    change z^(57896044618658097711785492504343953926634992332820282019728792003956564819949-1) = 1 at fermat
    rw [← hz, ← pow_mul]
    convert fermat using 2

noncomputable def sqrtModel (value : Fp) : Option Fp :=
  let root := value^sqrtExponent
  if root^2 = value then some root
  else if root^2 = -value then some (root*sqrtMinusOne)
  else none

noncomputable def sqrtPairModel (value : Fp) : Option (Bool × Fp) :=
  let root := value^sqrtExponent
  if root^2 = value then some (true, root)
  else if root^2 = -value then some (true, root*sqrtMinusOne)
  else if root^2 = sqrtMinusOne*value then some (false, root*(sqrtTwoI*sqrtMinusOne))
  else if root^2 = -sqrtMinusOne*value then some (false, root*sqrtTwoI)
  else none

theorem sqrt_candidate_cases (value : Fp) :
    let root := value^sqrtExponent
    root^2 = value ∨ root^2 = -value ∨ root^2 = sqrtMinusOne*value ∨
      root^2 = -sqrtMinusOne*value := by
  dsimp
  by_cases hz : value = 0
  · left
    simp [hz, sqrtExponent]
  have fermat := FiniteField.pow_card_sub_one_eq_one value hz
  simp only [ZMod.card] at fermat
  have h8 : (value^sqrtExponent)^8 = value^4 := by
    rw [← pow_mul]
    calc
      _ = value^((57896044618658097711785492504343953926634992332820282019728792003956564819949-1)+4) := by congr 1
      _ = _ := by rw [pow_add, fermat, one_mul]
  have h4 : (((value^sqrtExponent)^2)^2)^2 = (value^2)^2 := by
    simpa only [← pow_mul, Nat.mul_assoc] using h8
  rcases sq_eq_sq_iff_eq_or_eq_neg.mp h4 with plus | minus
  · rcases sq_eq_sq_iff_eq_or_eq_neg.mp plus with h | h
    · exact Or.inl h
    · exact Or.inr (Or.inl h)
  · have hm : ((value^sqrtExponent)^2)^2 = (sqrtMinusOne*value)^2 := by
      rw [mul_pow, sqrt_minus_one_correct]
      simpa using minus
    rcases sq_eq_sq_iff_eq_or_eq_neg.mp hm with h | h
    · exact Or.inr (Or.inr (Or.inl h))
    · exact Or.inr (Or.inr (Or.inr (by simpa using h)))

theorem sqrt_pair_complete (value : Fp) : (sqrtPairModel value).isSome = true := by
  have cases := sqrt_candidate_cases value
  dsimp only [sqrtPairModel]
  split
  · rfl
  · split
    · rfl
    · split
      · rfl
      · split
        · rfl
        · rcases cases with h | h | h | h <;> contradiction

theorem sqrt_pair_sound (value : Fp) (is_square : Bool) (root : Fp)
    (h : sqrtPairModel value = some (is_square, root)) :
    root^2 = if is_square then value else 2*value := by
  dsimp only [sqrtPairModel] at h
  split at h
  · rename_i equal
    rcases Prod.mk.inj (Option.some.inj h) with ⟨hs, hr⟩
    subst is_square
    change root^2 = value
    rw [← hr]
    exact equal
  · split at h
    · rename_i opposite
      rcases Prod.mk.inj (Option.some.inj h) with ⟨hs, hr⟩
      subst is_square
      change root^2 = value
      rw [← hr, mul_pow, sqrt_minus_one_correct, opposite]
      ring
    · split at h
      · rename_i imaginary
        rcases Prod.mk.inj (Option.some.inj h) with ⟨hs, hr⟩
        subst is_square
        change root^2 = 2*value
        rw [← hr, mul_pow, mul_pow, sqrt_two_i_correct, sqrt_minus_one_correct, imaginary]
        linear_combination -2*value*sqrt_minus_one_correct
      · split at h
        · rename_i imaginary
          rcases Prod.mk.inj (Option.some.inj h) with ⟨hs, hr⟩
          subst is_square
          change root^2 = 2*value
          rw [← hr, mul_pow, sqrt_two_i_correct, imaginary]
          linear_combination -2*value*sqrt_minus_one_correct
        · contradiction

theorem sqrt_model_sound (value root : Fp) (h : sqrtModel value = some root) : root^2 = value := by
  dsimp only [sqrtModel] at h
  split at h
  · rename_i equal
    simp only [Option.some.injEq] at h
    rw [← h]
    exact equal
  · split at h
    · rename_i opposite
      simp only [Option.some.injEq] at h
      rw [← h, mul_pow, sqrt_minus_one_correct, opposite]
      ring
    · contradiction

theorem sqrt_model_complete (value : Fp) (square : IsSquare value) :
    ∃ root : Fp, sqrtModel value = some root := by
  classical
  by_cases hz : value = 0
  · subst value
    exact ⟨0, by simp [sqrtModel, sqrtExponent]⟩
  have char : ringChar Fp ≠ 2 := by rw [ZMod.ringChar_zmod_n]; decide
  have euler := (FiniteField.isSquare_iff char hz).mp square
  simp only [ZMod.card] at euler
  have hs : (value^quarticExponent)^2 = 1 := by
    rw [← pow_mul]
    convert euler using 2
  have root_eq : (value^sqrtExponent)^2 = value^quarticExponent*value := by
    rw [← pow_mul, ← pow_succ]
    congr 1
  rcases sq_eq_one_iff.mp hs with plus | minus
  · refine ⟨value^sqrtExponent, ?_⟩
    dsimp only [sqrtModel]
    have equation : (value^sqrtExponent)^2 = value := by rw [root_eq, plus, one_mul]
    simp only [equation, ↓reduceIte]
  · have equation : (value^sqrtExponent)^2 = -value := by rw [root_eq, minus, neg_one_mul]
    by_cases correct : (value^sqrtExponent)^2 = value
    · refine ⟨value^sqrtExponent, ?_⟩
      dsimp only [sqrtModel]
      rw [ite_eq_left correct]
    · refine ⟨value^sqrtExponent*sqrtMinusOne, ?_⟩
      dsimp only [sqrtModel]
      rw [ite_eq_right correct, ite_eq_left equation]

end DivideAndPair
