use num_bigint::BigInt;
use num_integer::Integer;
use num_traits::{One, Signed, Zero};

/*
Computes quotient and remainder using truncated division (towards zero).

This mimics the behavior of Go's `big.Int.QuoRem` method.
q = x / y (truncated towards zero)
r = x - y * q

Args:
    x: Dividend.
    y: Divisor.

Returns:
    A tuple (q, r) representing the quotient and remainder.

Raises:
    ZeroDivisionError: If y is 0.
*/
pub fn quo_rem_truncated(x: &BigInt, y: &BigInt) -> Result<[BigInt; 2], String> {
    if *y == 0.into() {
        return Err("division by zero".into());
    }

    // Standard division produces a float. int() truncates floats towards zero.
    let q = x / y;
    // The remainder is defined as r = x - y*q based on the truncated quotient.
    let r = x - y * &q;

    // --- Verification (optional but useful) ---
    // Check remainder properties for truncated division:
    // 1. abs(r) < abs(y)
    // 2. x = y * q + r
    // 3. sign(r) == sign(x) or r == 0
    assert!(
        r.abs() < y.abs(),
        "Truncated: Remainder magnitude |{}| >= divisor magnitude |{}|",
        r,
        y
    );
    assert!(
        *x == y * &q + &r,
        "Truncated: Definition x = y*q + r failed: {} != {}*{} + {}",
        x,
        y,
        q,
        r
    );
    assert!(
        r == 0.into() || r.sign() == x.sign(),
        "Truncated: Remainder sign mismatch: sign({}) != sign({})",
        r,
        x
    );
    // --- End Verification ---

    Ok([q, r])
}

/*
Computes the quotient using Euclidean division (floor division).

This mimics the behavior of Go's `big.Int.Div` method.
For Euclidean division:
q = floor(x / y)
r = x - y * q, such that 0 <= r < |y|

Python's // operator directly performs Euclidean (floor) division.

Args:
    x: Dividend.
    y: Divisor.

Returns:
    The Euclidean quotient q.

Raises:
    ZeroDivisionError: If y is 0.
*/
fn div_euclidean(x: &BigInt, y: &BigInt) -> Result<BigInt, String> {
    if *y == 0.into() {
        return Err("division by zero".into());
    }

    // Python's // operator performs floor division, which corresponds
    // to the Euclidean division quotient.
    let q = x.div_floor(y);

    // --- Verification (optional but useful) ---
    // Calculate the corresponding Euclidean remainder
    let r = x.mod_floor(y); // Or r = x - y * q
                            // Check remainder properties for Euclidean division:
                            // 1. 0 <= r < |y|
                            // 2. x = y * q + r
    assert!(
        r >= 0.into() && r < y.abs(),
        "Euclidean: Remainder {} not in [0, |{}|)",
        r,
        y
    );
    assert!(
        *x == y * &q + &r,
        "Euclidean: Definition x = y*q + r failed: {} != {}*{} + {}",
        x,
        y,
        q,
        r
    );
    // --- End Verification ---

    Ok(q)
}

/*
Represents an Eisenstein integer z = a0 + a1*ω, where ω = exp(2πi/3).

ω satisfies ω^2 + ω + 1 = 0.
Uses Python's built-in arbitrary-precision integers.

Attributes:
    a0: The integer coefficient of 1.
    a1: The integer coefficient of ω.
*/
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct EisensteinInteger {
    pub a0: BigInt,
    pub a1: BigInt,
}

impl EisensteinInteger {
    /*Initializes an EisensteinInteger.*/
    pub fn new(a0: BigInt, a1: BigInt) -> Self {
        Self { a0, a1 }
    }
    /*Sets the value of self to the value of other. Returns self.*/
    pub fn set(&mut self, other: &Self) -> &Self {
        self.a0 = other.a0.clone();
        self.a1 = other.a1.clone();
        self
    }
    /*Sets the value of self to zero. Returns self.*/
    pub fn set_zero(&mut self) -> &Self {
        self.a0 = 0.into();
        self.a1 = 0.into();
        self
    }
    /*Sets the value of self to one. Returns self.*/
    pub fn set_one(&mut self) -> &Self {
        self.a0 = 1.into();
        self.a1 = 0.into();
        self
    }
    /*
    Computes the complex conjugate.

    conj(a0 + a1*ω) = (a0 - a1) - a1*ω
    */
    pub fn conjugate(&self) -> Self {
        Self::new(&self.a0 - &self.a1, -&self.a1)
    }
    /*
    Computes the norm N(self).

    N(a0 + a1*ω) = a0^2 + a1^2 - a0*a1
    The norm is always non-negative.
    */
    pub fn norm(&self) -> BigInt {
        &self.a0.pow(2) + &self.a1.pow(2) - &self.a0 * &self.a1
    }
    /*
    Performs Euclidean division self / y using rounding to the NEAREST Eisenstein integer.

    This method guarantees norm(remainder) < norm(divisor).

    Args:
        y: The divisor (must be non-zero).

    Returns:
        A tuple (quotient, remainder).

    Raises:
        ZeroDivisionError: If y is zero.
        TypeError: If y is not an EisensteinInteger.
    */
    pub fn quo_rem(&self, y: &Self) -> Result<[Self; 2], String> {
        let norm_y = y.norm();
        if norm_y == 0.into() {
            return Err("division by zero EisensteinInteger".into());
        }

        // Calculate numerator = self * y.conjugate() = num0 + num1*ω
        let num = self.clone() * y.conjugate();

        // Calculate quotient q by rounding components of num/norm_y to nearest int
        let q_a0 = div_euclidean(&num.a0, &norm_y)?;
        let q_a1 = div_euclidean(&num.a1, &norm_y)?;
        let q = Self::new(q_a0, q_a1);

        // Calculate remainder r = self - y * q
        let r = self.clone() - q.clone() * y.clone(); // Corrected order from previous edit

        Ok([q, r])
    }
}

impl std::fmt::Display for EisensteinInteger {
    /*Returns a user-friendly string representation (e.g., '3 + 2*ω').*/
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        if self.a1 == 0.into() {
            write!(f, "{}", self.a0)
        } else {
            let a0_str = if self.a0 != 0.into() {
                format!("{}", self.a0)
            } else {
                "".into()
            };

            let a1_str = if self.a1 == 1.into() {
                "ω".into()
            } else {
                if self.a1 == (-1).into() {
                    "-ω".into()
                } else {
                    format!("{}*ω", self.a1)
                }
            };

            if a0_str.len() == 0 {
                write!(f, "{}", a1_str)
            } else {
                let sign = if self.a1 > 0.into() { " + " } else { " - " };
                let a1_abs_str = if self.a1.abs() == 1.into() {
                    "ω".into()
                } else {
                    format!("{}*ω", self.a1.abs())
                };
                write!(f, "{}{}{}", a0_str, sign, a1_abs_str)
            }
        }
    }
}

impl std::ops::Neg for EisensteinInteger {
    type Output = Self;

    /*Computes the negation -self.*/
    fn neg(self) -> Self::Output {
        Self {
            a0: -self.a0,
            a1: -self.a1,
        }
    }
}

impl std::ops::Add for EisensteinInteger {
    type Output = Self;

    /*Computes the sum self + other.*/
    fn add(self, other: Self) -> Self::Output {
        &self + &other
    }
}

impl<'a> std::ops::Add<&'a EisensteinInteger> for &'a EisensteinInteger {
    type Output = EisensteinInteger;

    /*Computes the sum self + other.*/
    fn add(self, other: Self) -> Self::Output {
        EisensteinInteger::new(&self.a0 + &other.a0, &self.a1 + &other.a1)
    }
}

impl std::ops::Sub for EisensteinInteger {
    type Output = Self;

    /*Computes the difference self - other.*/
    fn sub(self, other: Self) -> Self::Output {
        &self - &other
    }
}

impl<'a> std::ops::Sub<&'a EisensteinInteger> for &'a EisensteinInteger {
    type Output = EisensteinInteger;

    /*Computes the difference self - other.*/
    fn sub(self, other: Self) -> Self::Output {
        EisensteinInteger::new(&self.a0 - &other.a0, &self.a1 - &other.a1)
    }
}

impl std::ops::Mul for EisensteinInteger {
    type Output = Self;

    /*
    Computes the product self * other.

    Supports multiplication by another EisensteinInteger.
    Uses the identity (x0+x1ω)(y0+y1ω) = (x0y0 - x1y1) + (x0y1 + x1y0 - x1y1)ω.
    */
    fn mul(self, other: Self) -> Self::Output {
        &self * &other
    }
}

impl<'a> std::ops::Mul<&'a EisensteinInteger> for &'a EisensteinInteger {
    type Output = EisensteinInteger;

    /*
    Computes the product self * other.

    Supports multiplication by another EisensteinInteger.
    Uses the identity (x0+x1ω)(y0+y1ω) = (x0y0 - x1y1) + (x0y1 + x1y0 - x1y1)ω.
    */
    fn mul(self, other: Self) -> Self::Output {
        let (x0, x1) = (&self.a0, &self.a1);
        let (y0, y1) = (&other.a0, &other.a1);
        let res_a0 = x0 * y0 - x1 * y1;
        let res_a1 = x0 * y1 + x1 * y0 - x1 * y1;
        EisensteinInteger::new(res_a0, res_a1)
    }
}

impl std::ops::Mul<BigInt> for EisensteinInteger {
    type Output = Self;

    /*Computes the product self * int.*/
    fn mul(self, other: BigInt) -> Self::Output {
        &self * &other
    }
}

impl<'a> std::ops::Mul<&'a BigInt> for &'a EisensteinInteger {
    type Output = EisensteinInteger;

    /*Computes the product self * int.*/
    fn mul(self, other: &BigInt) -> Self::Output {
        other * self 
    }
}

impl std::ops::Mul<EisensteinInteger> for BigInt {
    type Output = EisensteinInteger;

    /*Computes the product int * self.*/
    fn mul(self, other: EisensteinInteger) -> Self::Output {
        &self * &other
    }
}

impl<'a> std::ops::Mul<&'a EisensteinInteger> for &'a BigInt {
    type Output = EisensteinInteger;

    /*Computes the product int * self.*/
    fn mul(self, other: &EisensteinInteger) -> Self::Output {
        EisensteinInteger::new(self * &other.a0, self * &other.a1)
    }
}

impl std::ops::Div for EisensteinInteger {
    type Output = Self;

    /*Computes the quotient self // other using Euclidean rounding division.*/
    fn div(self, other: Self) -> Self::Output {
        &self / &other
    }
}

impl<'a> std::ops::Div<&'a EisensteinInteger> for &'a EisensteinInteger {
    type Output = EisensteinInteger;

    /*Computes the quotient self // other using Euclidean rounding division.*/
    fn div(self, other: Self) -> Self::Output {
        let [q, _] = self.quo_rem(other).unwrap();
        q
    }
}

impl std::ops::Rem for EisensteinInteger {
    type Output = Self;

    /*Computes the remainder self % other using Euclidean rounding division.*/
    fn rem(self, other: Self) -> Self::Output {
        &self % &other
    }
}

impl<'a> std::ops::Rem<&'a EisensteinInteger> for &'a EisensteinInteger {
    type Output = EisensteinInteger;

    /*Computes the remainder self % other using Euclidean rounding division.*/
    fn rem(self, other: Self) -> Self::Output {
        let [_, r] = self.quo_rem(other).unwrap();
        r
    }
}

impl Zero for EisensteinInteger {
    fn zero() -> Self {
        Self::new(0.into(), 0.into())
    }

    /*Checks if the value is zero.*/
    fn is_zero(&self) -> bool {
        self.a0.is_zero() && self.a1.is_zero()
    }
}

impl One for EisensteinInteger {
    fn one() -> Self {
        Self::new(1.into(), 0.into())
    }
}

/*
Computes the partial GCD result using the Half-GCD approach based on norm reduction.

Args:
    a: The first EisensteinInteger.
    b: The second EisensteinInteger.

Returns:
    A tuple (w, v, u) such that w = a*u + b*v and norm(w) is approximately
    less than sqrt(norm(a)). The identity w = a*u + b*v always holds.

Raises:
    TypeError: If inputs are not EisensteinInteger instances.
    ValueError: If the norm of 'a' is unexpectedly negative.
    RuntimeError: If the algorithm takes an excessive number of iterations.
*/
pub fn half_gcd(
    a: &EisensteinInteger,
    b: &EisensteinInteger,
) -> Result<[EisensteinInteger; 3], String> {
    // Initialize variables for the Extended Euclidean Algorithm
    let mut a_run = a.clone();
    let mut b_run = b.clone();
    let mut u = EisensteinInteger::one(); // Use class constant copies
    let mut v = EisensteinInteger::zero();
    let mut u_ = EisensteinInteger::zero();
    let mut v_ = EisensteinInteger::one();
    // Invariants: a_run = a*u + b*v,  b_run = a*u_ + b*v_

    let norm_a = a.norm();
    if norm_a < 0.into() {
        return Err("Norm of input 'a' cannot be negative".into());
    }
    // Calculate the termination threshold
    let limit = norm_a.sqrt();

    // Loop while the norm of the 'smaller' value (b_run) is >= the limit
    let mut iteration = 0;
    let max_iterations = 20000; // Safety limit

    while b_run.norm() >= limit {
        if iteration > max_iterations {
            return Err(format!(
                "HalfGCD exceeded {} iterations for a={}, b={}",
                max_iterations, a, b
            ));
        }

        if b_run.is_zero() {
            break; // GCD is a_run
        }

        let [quotient, remainder] = match a_run.quo_rem(&b_run) {
            Ok(result) => result,
            _ => break, // Should ideally not happen if b_run.is_zero() check works
        };

        // Update coefficients
        let next_u_ = u - &quotient * &u_;
        let next_v_ = v - &quotient * &v_;

        // Update state
        (a_run, b_run) = (b_run, remainder);
        (u, u_) = (u_, next_u_);
        (v, v_) = (v_, next_v_);

        iteration += 1;
    }

    // Return the final state corresponding to the Go implementation's return values
    // (b_run, v_, u_) which satisfy b_run = a*u_ + b*v_
    Ok([b_run, v_, u_])
}
