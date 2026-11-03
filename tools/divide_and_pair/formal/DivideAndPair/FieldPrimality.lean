module

public import Mathlib.NumberTheory.LucasPrimality

-- Generated Lucas certificates. No native_decide or primality oracle is trusted.
@[expose] public section
namespace DivideAndPair
set_option maxRecDepth 8192
set_option maxHeartbeats 1000000

theorem prime_2 : Nat.Prime 2 := by decide

theorem prime_3 : Nat.Prime 3 := by decide

theorem prime_5 : Nat.Prime 5 := by decide

theorem prime_7 : Nat.Prime 7 := by decide

theorem prime_11 : Nat.Prime 11 := by decide

theorem prime_13 : Nat.Prime 13 := by decide

theorem prime_17 : Nat.Prime 17 := by decide

theorem prime_19 : Nat.Prime 19 := by decide

theorem prime_23 : Nat.Prime 23 := by decide

theorem prime_29 : Nat.Prime 29 := by decide

theorem prime_31 : Nat.Prime 31 := by decide

theorem prime_37 : Nat.Prime 37 := by decide

theorem prime_41 : Nat.Prime 41 := by decide

theorem prime_43 : Nat.Prime 43 := by decide

theorem prime_47 : Nat.Prime 47 := by decide

theorem prime_53 : Nat.Prime 53 := by decide

theorem prime_59 : Nat.Prime 59 := by decide

theorem prime_67 : Nat.Prime 67 := by decide

theorem prime_73 : Nat.Prime 73 := by decide

theorem prime_79 : Nat.Prime 79 := by decide

theorem prime_83 : Nat.Prime 83 := by decide

theorem prime_97 : Nat.Prime 97 := by decide

theorem prime_103 : Nat.Prime 103 := by
  apply lucas_primality 103 (5 : ZMod 103) (by decide)
  intro q hq hdiv
  have factorization : 103-1 = 2 * 3 * 17 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 17 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_17, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_107 : Nat.Prime 107 := by
  apply lucas_primality 107 (2 : ZMod 107) (by decide)
  intro q hq hdiv
  have factorization : 107-1 = 2 * 53 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 53 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_53, or_assoc] using hdiv
  rcases cases with rfl | rfl <;> decide

theorem prime_113 : Nat.Prime 113 := by
  apply lucas_primality 113 (3 : ZMod 113) (by decide)
  intro q hq hdiv
  have factorization : 113-1 = 2 * 2 * 2 * 2 * 7 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 7 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_7, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_127 : Nat.Prime 127 := by
  apply lucas_primality 127 (3 : ZMod 127) (by decide)
  intro q hq hdiv
  have factorization : 127-1 = 2 * 3 * 3 * 7 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 3 ∨ q = 7 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_7, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_131 : Nat.Prime 131 := by
  apply lucas_primality 131 (2 : ZMod 131) (by decide)
  intro q hq hdiv
  have factorization : 131-1 = 2 * 5 * 13 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 5 ∨ q = 13 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_13, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_173 : Nat.Prime 173 := by
  apply lucas_primality 173 (2 : ZMod 173) (by decide)
  intro q hq hdiv
  have factorization : 173-1 = 2 * 2 * 43 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 43 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_43, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_223 : Nat.Prime 223 := by
  apply lucas_primality 223 (3 : ZMod 223) (by decide)
  intro q hq hdiv
  have factorization : 223-1 = 2 * 3 * 37 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 37 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_37, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_239 : Nat.Prime 239 := by
  apply lucas_primality 239 (7 : ZMod 239) (by decide)
  intro q hq hdiv
  have factorization : 239-1 = 2 * 7 * 17 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 7 ∨ q = 17 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_17, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_269 : Nat.Prime 269 := by
  apply lucas_primality 269 (2 : ZMod 269) (by decide)
  intro q hq hdiv
  have factorization : 269-1 = 2 * 2 * 67 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 67 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_67, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_307 : Nat.Prime 307 := by
  apply lucas_primality 307 (5 : ZMod 307) (by decide)
  intro q hq hdiv
  have factorization : 307-1 = 2 * 3 * 3 * 17 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 3 ∨ q = 17 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_17, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_353 : Nat.Prime 353 := by
  apply lucas_primality 353 (3 : ZMod 353) (by decide)
  intro q hq hdiv
  have factorization : 353-1 = 2 * 2 * 2 * 2 * 2 * 11 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 11 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_11, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_419 : Nat.Prime 419 := by
  apply lucas_primality 419 (2 : ZMod 419) (by decide)
  intro q hq hdiv
  have factorization : 419-1 = 2 * 11 * 19 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 11 ∨ q = 19 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_11, Nat.prime_dvd_prime_iff_eq hq prime_19, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_479 : Nat.Prime 479 := by
  apply lucas_primality 479 (13 : ZMod 479) (by decide)
  intro q hq hdiv
  have factorization : 479-1 = 2 * 239 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 239 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_239, or_assoc] using hdiv
  rcases cases with rfl | rfl <;> decide

theorem prime_487 : Nat.Prime 487 := by
  apply lucas_primality 487 (3 : ZMod 487) (by decide)
  intro q hq hdiv
  have factorization : 487-1 = 2 * 3 * 3 * 3 * 3 * 3 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 3 ∨ q = 3 ∨ q = 3 ∨ q = 3 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_991 : Nat.Prime 991 := by
  apply lucas_primality 991 (6 : ZMod 991) (by decide)
  intro q hq hdiv
  have factorization : 991-1 = 2 * 3 * 3 * 5 * 11 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 3 ∨ q = 5 ∨ q = 11 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_11, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_1361 : Nat.Prime 1361 := by
  apply lucas_primality 1361 (3 : ZMod 1361) (by decide)
  intro q hq hdiv
  have factorization : 1361-1 = 2 * 2 * 2 * 2 * 5 * 17 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 5 ∨ q = 17 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_17, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_1723 : Nat.Prime 1723 := by
  apply lucas_primality 1723 (3 : ZMod 1723) (by decide)
  intro q hq hdiv
  have factorization : 1723-1 = 2 * 3 * 7 * 41 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 7 ∨ q = 41 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_41, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_2437 : Nat.Prime 2437 := by
  apply lucas_primality 2437 (2 : ZMod 2437) (by decide)
  intro q hq hdiv
  have factorization : 2437-1 = 2 * 2 * 3 * 7 * 29 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 7 ∨ q = 29 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_29, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_2551 : Nat.Prime 2551 := by
  apply lucas_primality 2551 (6 : ZMod 2551) (by decide)
  intro q hq hdiv
  have factorization : 2551-1 = 2 * 3 * 5 * 5 * 17 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 5 ∨ q = 5 ∨ q = 17 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_17, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_2851 : Nat.Prime 2851 := by
  apply lucas_primality 2851 (2 : ZMod 2851) (by decide)
  intro q hq hdiv
  have factorization : 2851-1 = 2 * 3 * 5 * 5 * 19 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 5 ∨ q = 5 ∨ q = 19 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_19, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_2939 : Nat.Prime 2939 := by
  apply lucas_primality 2939 (2 : ZMod 2939) (by decide)
  intro q hq hdiv
  have factorization : 2939-1 = 2 * 13 * 113 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 13 ∨ q = 113 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_13, Nat.prime_dvd_prime_iff_eq hq prime_113, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_3727 : Nat.Prime 3727 := by
  apply lucas_primality 3727 (3 : ZMod 3727) (by decide)
  intro q hq hdiv
  have factorization : 3727-1 = 2 * 3 * 3 * 3 * 3 * 23 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 3 ∨ q = 3 ∨ q = 3 ∨ q = 23 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_23, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_3797 : Nat.Prime 3797 := by
  apply lucas_primality 3797 (2 : ZMod 3797) (by decide)
  intro q hq hdiv
  have factorization : 3797-1 = 2 * 2 * 13 * 73 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 13 ∨ q = 73 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_13, Nat.prime_dvd_prime_iff_eq hq prime_73, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_4153 : Nat.Prime 4153 := by
  apply lucas_primality 4153 (5 : ZMod 4153) (by decide)
  intro q hq hdiv
  have factorization : 4153-1 = 2 * 2 * 2 * 3 * 173 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 173 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_173, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_5879 : Nat.Prime 5879 := by
  apply lucas_primality 5879 (11 : ZMod 5879) (by decide)
  intro q hq hdiv
  have factorization : 5879-1 = 2 * 2939 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2939 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_2939, or_assoc] using hdiv
  rcases cases with rfl | rfl <;> decide

theorem prime_9463 : Nat.Prime 9463 := by
  apply lucas_primality 9463 (3 : ZMod 9463) (by decide)
  intro q hq hdiv
  have factorization : 9463-1 = 2 * 3 * 19 * 83 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 19 ∨ q = 83 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_19, Nat.prime_dvd_prime_iff_eq hq prime_83, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_17231 : Nat.Prime 17231 := by
  apply lucas_primality 17231 (13 : ZMod 17231) (by decide)
  intro q hq hdiv
  have factorization : 17231-1 = 2 * 5 * 1723 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 5 ∨ q = 1723 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_1723, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_22111 : Nat.Prime 22111 := by
  apply lucas_primality 22111 (6 : ZMod 22111) (by decide)
  intro q hq hdiv
  have factorization : 22111-1 = 2 * 3 * 5 * 11 * 67 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 5 ∨ q = 11 ∨ q = 67 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_11, Nat.prime_dvd_prime_iff_eq hq prime_67, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_30703 : Nat.Prime 30703 := by
  apply lucas_primality 30703 (3 : ZMod 30703) (by decide)
  intro q hq hdiv
  have factorization : 30703-1 = 2 * 3 * 7 * 17 * 43 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 7 ∨ q = 17 ∨ q = 43 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_17, Nat.prime_dvd_prime_iff_eq hq prime_43, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_32573 : Nat.Prime 32573 := by
  apply lucas_primality 32573 (2 : ZMod 32573) (by decide)
  intro q hq hdiv
  have factorization : 32573-1 = 2 * 2 * 17 * 479 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 17 ∨ q = 479 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_17, Nat.prime_dvd_prime_iff_eq hq prime_479, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_34123 : Nat.Prime 34123 := by
  apply lucas_primality 34123 (2 : ZMod 34123) (by decide)
  intro q hq hdiv
  have factorization : 34123-1 = 2 * 3 * 11 * 11 * 47 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 11 ∨ q = 11 ∨ q = 47 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_11, Nat.prime_dvd_prime_iff_eq hq prime_47, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_37853 : Nat.Prime 37853 := by
  apply lucas_primality 37853 (2 : ZMod 37853) (by decide)
  intro q hq hdiv
  have factorization : 37853-1 = 2 * 2 * 9463 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 9463 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_9463, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_41081 : Nat.Prime 41081 := by
  apply lucas_primality 41081 (3 : ZMod 41081) (by decide)
  intro q hq hdiv
  have factorization : 41081-1 = 2 * 2 * 2 * 5 * 13 * 79 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 5 ∨ q = 13 ∨ q = 79 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_13, Nat.prime_dvd_prime_iff_eq hq prime_79, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_57467 : Nat.Prime 57467 := by
  apply lucas_primality 57467 (2 : ZMod 57467) (by decide)
  intro q hq hdiv
  have factorization : 57467-1 = 2 * 59 * 487 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 59 ∨ q = 487 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_59, Nat.prime_dvd_prime_iff_eq hq prime_487, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_65147 : Nat.Prime 65147 := by
  apply lucas_primality 65147 (2 : ZMod 65147) (by decide)
  intro q hq hdiv
  have factorization : 65147-1 = 2 * 32573 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 32573 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_32573, or_assoc] using hdiv
  rcases cases with rfl | rfl <;> decide

theorem prime_75707 : Nat.Prime 75707 := by
  apply lucas_primality 75707 (2 : ZMod 75707) (by decide)
  intro q hq hdiv
  have factorization : 75707-1 = 2 * 37853 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 37853 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_37853, or_assoc] using hdiv
  rcases cases with rfl | rfl <;> decide

theorem prime_82163 : Nat.Prime 82163 := by
  apply lucas_primality 82163 (2 : ZMod 82163) (by decide)
  intro q hq hdiv
  have factorization : 82163-1 = 2 * 41081 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 41081 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_41081, or_assoc] using hdiv
  rcases cases with rfl | rfl <;> decide

theorem prime_132049 : Nat.Prime 132049 := by
  apply lucas_primality 132049 (26 : ZMod 132049) (by decide)
  intro q hq hdiv
  have factorization : 132049-1 = 2 * 2 * 2 * 2 * 3 * 3 * 7 * 131 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 3 ∨ q = 7 ∨ q = 131 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_131, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_132667 : Nat.Prime 132667 := by
  apply lucas_primality 132667 (5 : ZMod 132667) (by decide)
  intro q hq hdiv
  have factorization : 132667-1 = 2 * 3 * 22111 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 22111 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_22111, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_137849 : Nat.Prime 137849 := by
  apply lucas_primality 137849 (3 : ZMod 137849) (by decide)
  intro q hq hdiv
  have factorization : 137849-1 = 2 * 2 * 2 * 17231 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 17231 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_17231, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_409477 : Nat.Prime 409477 := by
  apply lucas_primality 409477 (2 : ZMod 409477) (by decide)
  intro q hq hdiv
  have factorization : 409477-1 = 2 * 2 * 3 * 34123 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 34123 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_34123, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_430751 : Nat.Prime 430751 := by
  apply lucas_primality 430751 (17 : ZMod 430751) (by decide)
  intro q hq hdiv
  have factorization : 430751-1 = 2 * 5 * 5 * 5 * 1723 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 5 ∨ q = 5 ∨ q = 5 ∨ q = 1723 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_1723, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_531581 : Nat.Prime 531581 := by
  apply lucas_primality 531581 (2 : ZMod 531581) (by decide)
  intro q hq hdiv
  have factorization : 531581-1 = 2 * 2 * 5 * 7 * 3797 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 5 ∨ q = 7 ∨ q = 3797 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_3797, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_569003 : Nat.Prime 569003 := by
  apply lucas_primality 569003 (2 : ZMod 569003) (by decide)
  intro q hq hdiv
  have factorization : 569003-1 = 2 * 7 * 97 * 419 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 7 ∨ q = 97 ∨ q = 419 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_97, Nat.prime_dvd_prime_iff_eq hq prime_419, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_1224481 : Nat.Prime 1224481 := by
  apply lucas_primality 1224481 (13 : ZMod 1224481) (by decide)
  intro q hq hdiv
  have factorization : 1224481-1 = 2 * 2 * 2 * 2 * 2 * 3 * 5 * 2551 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 5 ∨ q = 2551 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_2551, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_1923133 : Nat.Prime 1923133 := by
  apply lucas_primality 1923133 (2 : ZMod 1923133) (by decide)
  intro q hq hdiv
  have factorization : 1923133-1 = 2 * 2 * 3 * 43 * 3727 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 43 ∨ q = 3727 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_43, Nat.prime_dvd_prime_iff_eq hq prime_3727, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_8574133 : Nat.Prime 8574133 := by
  apply lucas_primality 8574133 (2 : ZMod 8574133) (by decide)
  intro q hq hdiv
  have factorization : 8574133-1 = 2 * 2 * 3 * 7 * 103 * 991 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 7 ∨ q = 103 ∨ q = 991 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_103, Nat.prime_dvd_prime_iff_eq hq prime_991, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_14741173 : Nat.Prime 14741173 := by
  apply lucas_primality 14741173 (2 : ZMod 14741173) (by decide)
  intro q hq hdiv
  have factorization : 14741173-1 = 2 * 2 * 3 * 3 * 409477 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 3 ∨ q = 409477 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_409477, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_58964693 : Nat.Prime 58964693 := by
  apply lucas_primality 58964693 (2 : ZMod 58964693) (by decide)
  intro q hq hdiv
  have factorization : 58964693-1 = 2 * 2 * 14741173 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 14741173 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_14741173, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_292386187 : Nat.Prime 292386187 := by
  apply lucas_primality 292386187 (2 : ZMod 292386187) (by decide)
  intro q hq hdiv
  have factorization : 292386187-1 = 2 * 3 * 3 * 3 * 3 * 307 * 5879 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 3 ∨ q = 3 ∨ q = 3 ∨ q = 307 ∨ q = 5879 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_307, Nat.prime_dvd_prime_iff_eq hq prime_5879, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_2773320623 : Nat.Prime 2773320623 := by
  apply lucas_primality 2773320623 (5 : ZMod 2773320623) (by decide)
  intro q hq hdiv
  have factorization : 2773320623-1 = 2 * 2437 * 569003 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2437 ∨ q = 569003 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_2437, Nat.prime_dvd_prime_iff_eq hq prime_569003, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_72106336199 : Nat.Prime 72106336199 := by
  apply lucas_primality 72106336199 (7 : ZMod 72106336199) (by decide)
  intro q hq hdiv
  have factorization : 72106336199-1 = 2 * 13 * 2773320623 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 13 ∨ q = 2773320623 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_13, Nat.prime_dvd_prime_iff_eq hq prime_2773320623, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_213441916511 : Nat.Prime 213441916511 := by
  apply lucas_primality 213441916511 (13 : ZMod 213441916511) (by decide)
  intro q hq hdiv
  have factorization : 213441916511-1 = 2 * 5 * 73 * 292386187 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 5 ∨ q = 73 ∨ q = 292386187 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_73, Nat.prime_dvd_prime_iff_eq hq prime_292386187, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_1257559732178653 : Nat.Prime 1257559732178653 := by
  apply lucas_primality 1257559732178653 (2 : ZMod 1257559732178653) (by decide)
  intro q hq hdiv
  have factorization : 1257559732178653-1 = 2 * 2 * 3 * 7 * 23 * 531581 * 1224481 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 7 ∨ q = 23 ∨ q = 531581 ∨ q = 1224481 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_23, Nat.prime_dvd_prime_iff_eq hq prime_531581, Nat.prime_dvd_prime_iff_eq hq prime_1224481, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_1919519569386763 : Nat.Prime 1919519569386763 := by
  apply lucas_primality 1919519569386763 (2 : ZMod 1919519569386763) (by decide)
  intro q hq hdiv
  have factorization : 1919519569386763-1 = 2 * 3 * 7 * 19 * 47 * 47 * 127 * 8574133 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 7 ∨ q = 19 ∨ q = 47 ∨ q = 47 ∨ q = 127 ∨ q = 8574133 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_19, Nat.prime_dvd_prime_iff_eq hq prime_47, Nat.prime_dvd_prime_iff_eq hq prime_127, Nat.prime_dvd_prime_iff_eq hq prime_8574133, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_31757755568855353 : Nat.Prime 31757755568855353 := by
  apply lucas_primality 31757755568855353 (10 : ZMod 31757755568855353) (by decide)
  intro q hq hdiv
  have factorization : 31757755568855353-1 = 2 * 2 * 2 * 3 * 31 * 107 * 223 * 4153 * 430751 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 31 ∨ q = 107 ∨ q = 223 ∨ q = 4153 ∨ q = 430751 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_31, Nat.prime_dvd_prime_iff_eq hq prime_107, Nat.prime_dvd_prime_iff_eq hq prime_223, Nat.prime_dvd_prime_iff_eq hq prime_4153, Nat.prime_dvd_prime_iff_eq hq prime_430751, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_4434155615661930479 : Nat.Prime 4434155615661930479 := by
  apply lucas_primality 4434155615661930479 (17 : ZMod 4434155615661930479) (by decide)
  intro q hq hdiv
  have factorization : 4434155615661930479-1 = 2 * 41 * 43 * 1257559732178653 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 41 ∨ q = 43 ∨ q = 1257559732178653 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_41, Nat.prime_dvd_prime_iff_eq hq prime_43, Nat.prime_dvd_prime_iff_eq hq prime_1257559732178653, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_3044861653679985063343 : Nat.Prime 3044861653679985063343 := by
  apply lucas_primality 3044861653679985063343 (5 : ZMod 3044861653679985063343) (by decide)
  intro q hq hdiv
  have factorization : 3044861653679985063343-1 = 2 * 3 * 11 * 30703 * 82163 * 132667 * 137849 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 11 ∨ q = 30703 ∨ q = 82163 ∨ q = 132667 ∨ q = 137849 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_11, Nat.prime_dvd_prime_iff_eq hq prime_30703, Nat.prime_dvd_prime_iff_eq hq prime_82163, Nat.prime_dvd_prime_iff_eq hq prime_132667, Nat.prime_dvd_prime_iff_eq hq prime_137849, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_172054593956031949258510691 : Nat.Prime 172054593956031949258510691 := by
  apply lucas_primality 172054593956031949258510691 (2 : ZMod 172054593956031949258510691) (by decide)
  intro q hq hdiv
  have factorization : 172054593956031949258510691-1 = 2 * 5 * 1361 * 2851 * 4434155615661930479 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 5 ∨ q = 1361 ∨ q = 2851 ∨ q = 4434155615661930479 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_1361, Nat.prime_dvd_prime_iff_eq hq prime_2851, Nat.prime_dvd_prime_iff_eq hq prime_4434155615661930479, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_198211423230930754013084525763697 : Nat.Prime 198211423230930754013084525763697 := by
  apply lucas_primality 198211423230930754013084525763697 (5 : ZMod 198211423230930754013084525763697) (by decide)
  intro q hq hdiv
  have factorization : 198211423230930754013084525763697-1 = 2 * 2 * 2 * 2 * 3 * 23 * 58964693 * 3044861653679985063343 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 23 ∨ q = 58964693 ∨ q = 3044861653679985063343 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_23, Nat.prime_dvd_prime_iff_eq hq prime_58964693, Nat.prime_dvd_prime_iff_eq hq prime_3044861653679985063343, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_75445702479781427272750846543864801 : Nat.Prime 75445702479781427272750846543864801 := by
  apply lucas_primality 75445702479781427272750846543864801 (7 : ZMod 75445702479781427272750846543864801) (by decide)
  intro q hq hdiv
  have factorization : 75445702479781427272750846543864801-1 = 2 * 2 * 2 * 2 * 2 * 3 * 3 * 5 * 5 * 75707 * 1919519569386763 * 72106336199 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 3 ∨ q = 5 ∨ q = 5 ∨ q = 75707 ∨ q = 1919519569386763 ∨ q = 72106336199 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_5, Nat.prime_dvd_prime_iff_eq hq prime_75707, Nat.prime_dvd_prime_iff_eq hq prime_1919519569386763, Nat.prime_dvd_prime_iff_eq hq prime_72106336199, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_19757330305831588566944191468367130476339 : Nat.Prime 19757330305831588566944191468367130476339 := by
  apply lucas_primality 19757330305831588566944191468367130476339 (2 : ZMod 19757330305831588566944191468367130476339) (by decide)
  intro q hq hdiv
  have factorization : 19757330305831588566944191468367130476339-1 = 2 * 269 * 213441916511 * 172054593956031949258510691 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 269 ∨ q = 213441916511 ∨ q = 172054593956031949258510691 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_269, Nat.prime_dvd_prime_iff_eq hq prime_213441916511, Nat.prime_dvd_prime_iff_eq hq prime_172054593956031949258510691, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl <;> decide

theorem prime_276602624281642239937218680557139826668747 : Nat.Prime 276602624281642239937218680557139826668747 := by
  apply lucas_primality 276602624281642239937218680557139826668747 (2 : ZMod 276602624281642239937218680557139826668747) (by decide)
  intro q hq hdiv
  have factorization : 276602624281642239937218680557139826668747-1 = 2 * 7 * 19757330305831588566944191468367130476339 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 7 ∨ q = 19757330305831588566944191468367130476339 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_7, Nat.prime_dvd_prime_iff_eq hq prime_19757330305831588566944191468367130476339, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl <;> decide

theorem prime_74058212732561358302231226437062788676166966415465897661863160754340907 : Nat.Prime 74058212732561358302231226437062788676166966415465897661863160754340907 := by
  apply lucas_primality 74058212732561358302231226437062788676166966415465897661863160754340907 (2 : ZMod 74058212732561358302231226437062788676166966415465897661863160754340907) (by decide)
  intro q hq hdiv
  have factorization : 74058212732561358302231226437062788676166966415465897661863160754340907-1 = 2 * 3 * 353 * 57467 * 132049 * 1923133 * 31757755568855353 * 75445702479781427272750846543864801 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 3 ∨ q = 353 ∨ q = 57467 ∨ q = 132049 ∨ q = 1923133 ∨ q = 31757755568855353 ∨ q = 75445702479781427272750846543864801 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_353, Nat.prime_dvd_prime_iff_eq hq prime_57467, Nat.prime_dvd_prime_iff_eq hq prime_132049, Nat.prime_dvd_prime_iff_eq hq prime_1923133, Nat.prime_dvd_prime_iff_eq hq prime_31757755568855353, Nat.prime_dvd_prime_iff_eq hq prime_75445702479781427272750846543864801, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_7237005577332262213973186563042994240857116359379907606001950938285454250989 : Nat.Prime 7237005577332262213973186563042994240857116359379907606001950938285454250989 := by
  apply lucas_primality 7237005577332262213973186563042994240857116359379907606001950938285454250989 (2 : ZMod 7237005577332262213973186563042994240857116359379907606001950938285454250989) (by decide)
  intro q hq hdiv
  have factorization : 7237005577332262213973186563042994240857116359379907606001950938285454250989-1 = 2 * 2 * 3 * 11 * 198211423230930754013084525763697 * 276602624281642239937218680557139826668747 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 11 ∨ q = 198211423230930754013084525763697 ∨ q = 276602624281642239937218680557139826668747 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_11, Nat.prime_dvd_prime_iff_eq hq prime_198211423230930754013084525763697, Nat.prime_dvd_prime_iff_eq hq prime_276602624281642239937218680557139826668747, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl | rfl <;> decide

theorem prime_57896044618658097711785492504343953926634992332820282019728792003956564819949 : Nat.Prime 57896044618658097711785492504343953926634992332820282019728792003956564819949 := by
  apply lucas_primality 57896044618658097711785492504343953926634992332820282019728792003956564819949 (2 : ZMod 57896044618658097711785492504343953926634992332820282019728792003956564819949) (by decide)
  intro q hq hdiv
  have factorization : 57896044618658097711785492504343953926634992332820282019728792003956564819949-1 = 2 * 2 * 3 * 65147 * 74058212732561358302231226437062788676166966415465897661863160754340907 := by decide
  rw [factorization] at hdiv
  have cases : q = 2 ∨ q = 2 ∨ q = 3 ∨ q = 65147 ∨ q = 74058212732561358302231226437062788676166966415465897661863160754340907 := by
    simpa only [hq.dvd_mul, Nat.prime_dvd_prime_iff_eq hq prime_2, Nat.prime_dvd_prime_iff_eq hq prime_3, Nat.prime_dvd_prime_iff_eq hq prime_65147, Nat.prime_dvd_prime_iff_eq hq prime_74058212732561358302231226437062788676166966415465897661863160754340907, or_assoc] using hdiv
  rcases cases with rfl | rfl | rfl | rfl | rfl <;> decide

instance field_prime : Fact (Nat.Prime 57896044618658097711785492504343953926634992332820282019728792003956564819949) := ⟨prime_57896044618658097711785492504343953926634992332820282019728792003956564819949⟩

instance subgroup_prime : Fact (Nat.Prime 7237005577332262213973186563042994240857116359379907606001950938285454250989) := ⟨prime_7237005577332262213973186563042994240857116359379907606001950938285454250989⟩

end DivideAndPair
