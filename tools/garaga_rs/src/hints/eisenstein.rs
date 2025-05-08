use num_bigint::BigInt;
use num_traits::{One, Signed, Zero};

/// Axial coordinates of the 6 unit directions in the hexagonal lattice.
const NEIGHBOURS: [(i32, i32); 6] = [(1, 0), (0, 1), (-1, 1), (-1, 0), (0, -1), (1, -1)];

/// Symmetric integer rounding  ⌊(z + d/2) / d⌋  valid for *any* sign of `z`.
fn round_nearest(z: &BigInt, d: &BigInt) -> BigInt {
    debug_assert!(*d > BigInt::zero());
    let half = d >> 1; // d / 2
    if *z >= BigInt::zero() {
        (z + &half) / d
    } else {
        let quotient: BigInt = ((-z) + &half) / d;
        -quotient
    }
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
        self.a0 = BigInt::zero();
        self.a1 = BigInt::zero();
        self
    }
    /*Sets the value of self to one. Returns self.*/
    pub fn set_one(&mut self) -> &Self {
        self.a0 = BigInt::one();
        self.a1 = BigInt::zero();
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
    /* ---------- Euclidean division in ℤ[ω] ---------- */
    pub fn quo_rem(&self, y: &Self) -> Result<[Self; 2], String> {
        if y.is_zero() {
            return Err("division by zero EisensteinInteger".into());
        }
        let nrm = y.norm(); // positive
        let num = self * &y.conjugate(); // still integer-only

        // first guess by independent symmetric rounding
        let mut q0 = round_nearest(&num.a0, &nrm);
        let mut q1 = round_nearest(&num.a1, &nrm);
        let mut q = Self::new(q0.clone(), q1.clone());
        // Calculate product first, then subtract its reference
        let qy = &q * y;
        let mut r = self - &qy;

        // walk the neighbourhood until  N(r) < N(y)  (≤ 2 iterations)
        while r.norm() >= nrm {
            let mut best_q = None;
            let mut best_r = None;
            let mut best_n2 = r.norm(); // current (worst) remainder

            for (dp, dq) in NEIGHBOURS.iter() {
                let cand_q = Self::new(&q0 + dp, &q1 + dq);
                // Calculate product first, then subtract its reference
                let cand_qy = &cand_q * y;
                let cand_r = self - &cand_qy;
                let cand_n2 = cand_r.norm();
                if cand_n2 < best_n2 {
                    best_q = Some(cand_q);
                    best_r = Some(cand_r);
                    best_n2 = cand_n2;
                }
            }
            q = best_q.expect("Euclidean property violated");
            r = best_r.unwrap();
            q0 = q.a0.clone();
            q1 = q.a1.clone(); // centre for 2nd lap
        }
        Ok([q, r])
    }
}

impl std::fmt::Display for EisensteinInteger {
    /*Returns a user-friendly string representation (e.g., '3 + 2*ω').*/
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        if self.a1.is_zero() {
            write!(f, "{}", self.a0)
        } else {
            let a0_str = if !self.a0.is_zero() {
                format!("{}", self.a0)
            } else {
                "".into()
            };

            let a1_str = if self.a1 == BigInt::one() {
                "ω".into()
            } else if self.a1 == (-1).into() {
                "-ω".into()
            } else {
                format!("{}*ω", self.a1)
            };

            if a0_str.is_empty() {
                write!(f, "{}", a1_str)
            } else {
                let sign = if self.a1 > BigInt::zero() {
                    " + "
                } else {
                    " - "
                };
                let a1_abs_str = if self.a1.abs() == BigInt::one() {
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
        Self::new(BigInt::zero(), BigInt::zero())
    }

    /*Checks if the value is zero.*/
    fn is_zero(&self) -> bool {
        self.a0.is_zero() && self.a1.is_zero()
    }
}

impl One for EisensteinInteger {
    fn one() -> Self {
        Self::new(BigInt::one(), BigInt::zero())
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
    if norm_a < BigInt::zero() {
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

#[allow(unused_imports)]
mod tests {
    use super::*;

    #[test]
    fn test_01() -> Result<(), String> {
        let z1 = EisensteinInteger::new(3.into(), 2.into()); // 3 + 2ω
        let z2 = EisensteinInteger::new(1.into(), (-1).into()); // 1 - ω

        println!("z1 = {}", z1);
        println!("z2 = {}", z2);
        println!("z1 + z2 = {}", &z1 + &z2);
        println!("z1 - z2 = {}", &z1 - &z2);
        println!("z1 * z2 = {}", &z1 * &z2);
        println!("Norm(z1) = {}", z1.norm());
        println!("Conj(z1) = {}", z1.conjugate());
        println!("-z1 = {}", -z1.clone());

        let [q, r] = z1.quo_rem(&z2)?;
        println!("z1 // z2 = {}", q);
        println!("z1 % z2 = {}", r);
        println!("Check: z2 * q + r = {}, Expected: {}", &(&z2 * &q) + &r, z1);
        assert_eq!(&(&z2 * &q) + &r, z1);

        // Half GCD example
        let a = EisensteinInteger::new(10.into(), 3.into());
        let b = EisensteinInteger::new(3.into(), 1.into());
        println!("\nHalf GCD for a = {}, b = {}", a, b);
        let [w, v_res, u_res] = half_gcd(&a, &b)?;
        println!("  w = {}", w);
        println!("  v = {}", v_res);
        println!("  u = {}", u_res);
        let check = &a * &u_res + &b * &v_res;
        println!("  Check: a*u + b*v = {}, Expected w: {}", check, w);
        println!("  Norm(w) = {}, Limit = {}", w.norm(), a.norm().sqrt());
        assert_eq!(check, w);

        // a = EisensteinInteger(8+7j * (math.sqrt(3)/2 + 0.5j)) # Approximate large number
        let a_int = EisensteinInteger::new(13.into(), 14.into()); // Example large int coeffs
        let b_int = EisensteinInteger::new(5.into(), 3.into());
        println!("\nHalf GCD for a = {}, b = {}", a_int, b_int);
        let [w, v_res, u_res] = half_gcd(&a_int, &b_int)?;
        println!("  w = {}", w);
        println!("  v = {}", v_res);
        println!("  u = {}", u_res);
        let check = &a_int * &u_res + &b_int * &v_res;
        println!("  Check: a*u + b*v = {}, Expected w: {}", check, w);
        println!("  Norm(w) = {}, Limit = {}", w.norm(), a_int.norm().sqrt());
        assert_eq!(check, w);

        Ok(())
    }
}
