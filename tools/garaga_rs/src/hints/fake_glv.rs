use crate::algebra::g1point::G1Point;
use crate::definitions::CurveParamsProvider;
use crate::hints::eisenstein;
use lambdaworks_math::field::traits::IsPrimeField;
use num_bigint::{BigInt, BigUint, Sign, ToBigInt};
use num_integer::Integer;
use num_traits::Signed;

/*
Represents a 2D lattice basis (V1, V2) derived from GLV decomposition.

Attributes:
    V1: First basis vector [v11, v12].
    V2: Second basis vector [v21, v22], chosen to be short.
    Det: Determinant of the lattice basis (v11*v22 - v12*v21).
    b1: Rounding coefficient derived from V2, used in scalar decomposition.
    b2: Rounding coefficient derived from V1, used in scalar decomposition.
*/
struct Lattice {
    v1: [BigInt; 2],
    v2: [BigInt; 2],
    det: BigInt,
    b1: BigInt,
    b2: BigInt,
}

/*
Computes the first vector of a GLV lattice basis for a given modulus and input.

This is a Python adaptation of a Go function likely used for cryptographic
scalar multiplication optimizations (GLV method).

Args:
    modu (int): The modulus (often the group order `r`).
    input_val (int): The input value (often the eigenvalue `lambda`).

Returns:
    Tuple[int, int]: The components (v11, |v12|) of the first basis vector V1.
*/
pub fn half_gcd(modu: &BigInt, input_val: &BigInt) -> Result<[BigInt; 2], String> {
    let lattice = precompute_lattice(modu, input_val)?;
    let output0 = lattice.v1[0].clone();
    let output1 = lattice.v1[1].clone();

    // The GLV decomposition often requires the absolute value of the second component.
    Ok([output0, output1.abs()])
}

/*
Computes a short 2D lattice basis related to parameters (r, lambda).

Uses a variant of the Extended Euclidean Algorithm to find short vectors
(v1, v2) such that v1 = [a, b] and v2 = [c, d] satisfy
a + b*lambda = 0 (mod r) and c + d*lambda = 0 (mod r).
See https://www.iacr.org/archive/crypto2001/21390189.pdf (Algorithm 3.7)

Args:
    r (int): The modulus.
    lam (int): The lambda value (e.g., eigenvalue in GLV).

Returns:
    Lattice: An object containing the lattice basis vectors (V1, V2),
             determinant (Det), and rounding coefficients (b1, b2).

Raises:
    ValueError: If intermediate steps lead to division by zero (e.g., lam=0 mod r)
                or if the final determinant is zero.
*/
fn precompute_lattice(r: &BigInt, lam: &BigInt) -> Result<Lattice, String> {
    // Extended Euclidean Algorithm State: [[value, s_coeff, t_coeff], ...]
    // We maintain two states [ri, si, ti] such that ri = si*r + ti*lambda
    let mut euclidean_state = [
        [r.clone(), 1.into(), 0.into()], // Corresponds to r = 1*r + 0*lambda
        [lam.clone(), 0.into(), 1.into()], // Corresponds to lam = 0*r + 1*lambda
    ];

    // Compute the integer square root of r as the termination threshold
    let sqrt_r = r.sqrt();

    // Run Euclidean algorithm until the remainder (state[1][0]) is smaller than sqrt(r)
    while euclidean_state[1][0].abs() >= sqrt_r {
        let [current_rem, s_curr, t_curr] = euclidean_state[1].clone();
        let [prev_rem, s_prev, t_prev] = euclidean_state[0].clone();

        if current_rem == 0.into() {
            // This occurs if lambda is a multiple of r or lambda is 0.
            return Err("Division by zero in Euclidean algorithm. Check inputs r and lam.".into());
        }

        let quotient = prev_rem.div_floor(&current_rem);
        let next_rem = prev_rem.mod_floor(&current_rem);

        // Update coefficients using the identity: R_next = R_prev - q * R_curr
        // where R represents [rem, s, t]
        let s_next = &s_prev - &s_curr * &quotient;
        let t_next = &t_prev - &t_curr * &quotient;

        // Shift states: current becomes previous, new becomes current
        euclidean_state[0] = [current_rem, s_curr, t_curr];
        euclidean_state[1] = [next_rem, s_next, t_next];
    }

    // One final step to potentially find a shorter vector combination
    let [current_rem, _s_curr, t_curr] = euclidean_state[1].clone();
    let [prev_rem, _s_prev, t_prev] = euclidean_state[0].clone();

    if current_rem == 0.into() {
        return Err(
            "Division by zero in Euclidean algorithm final step. Check inputs r and lam.".into(),
        );
    }

    let quotient = prev_rem.div_floor(&current_rem);
    // Calculate the next potential remainder and t-coefficient
    let final_rem = prev_rem.mod_floor(&current_rem);
    let final_t = &t_prev - &t_curr * &quotient;

    // First basis vector: V1 = [current_rem, -t_curr]
    // Satisfies current_rem + (-t_curr)*lambda = 0 mod r (since current_rem = s_curr*r + t_curr*lambda)
    let v1_list = [current_rem.clone(), -t_curr];

    // Candidate vectors for the second basis vector V2
    // Candidate 1: [prev_rem, -t_prev]
    let cand1 = [prev_rem.clone(), -t_prev];
    // Candidate 2: [final_rem, -final_t]
    let cand2 = [final_rem.clone(), -final_t];

    // Choose the shorter candidate vector based on squared Euclidean norm (||v||^2 = x^2 + y^2)
    let norm1_sq = cand1[0].pow(2) + cand1[1].pow(2);
    let norm2_sq = cand2[0].pow(2) + cand2[1].pow(2);

    let v2_list = if norm1_sq > norm2_sq { cand2 } else { cand1 };

    // Calculate the determinant of the chosen basis {V1, V2}
    let det = &v1_list[0] * &v2_list[1] - &v1_list[1] * &v2_list[0];

    if det == 0.into() {
        // Basis vectors are linearly dependent, which shouldn't happen for typical inputs.
        return Err("Lattice determinant is zero. Input parameters might be unsuitable.".into());
    }

    /*
    Computes round(a / b), rounding ties away from zero.

    Equivalent to standard mathematical rounding, differs from Python's
    default round() which rounds ties to the nearest even number.
    Needed to potentially match specific Go implementation behavior.
    */
    fn round_half_away_from_zero(a: &BigInt, b: &BigInt) -> Result<BigInt, String> {
        if *b == 0.into() {
            return Err("Division by zero in rounding.".into());
        }
        // Perform division using absolute values
        let (mut quotient, remainder) = a.abs().div_rem(&b.abs());
        // Check if the remainder is large enough to round up (away from zero)
        if remainder * 2 >= b.abs() {
            quotient += 1;
        }
        // Restore the sign based on the original signs of a and b
        if (*a < 0.into()) != (*b < 0.into()) {
            Ok(-quotient) // Result is negative
        } else {
            Ok(quotient) // Result is positive
        }
    }

    // Compute rounding coefficients b1, b2 used in scalar decomposition
    // n is calculated to ensure 2^n is sufficiently larger than |det|,
    // potentially matching Go's fixed-size integer/word alignment logic.
    // The `+ 32 >> 6 << 6` part aligns the bit length to a multiple of 64.
    let n_bit_length = std::cmp::max(&1.into(), &det).bits(); // Use max(1,...) for robustness if det=0 (though checked above)
    let n = 2 * (((n_bit_length + 32) >> 6) << 6);

    // Calculate b1 = round(2^n * V2[1] / det)
    let b1 = round_half_away_from_zero(&(&v2_list[1] << n), &det)?;
    // Calculate b2 = round(2^n * V1[1] / det)
    let b2 = round_half_away_from_zero(&(&v1_list[1] << n), &det)?;

    // Return the results structured in the Lattice dataclass
    Ok(Lattice {
        v1: v1_list,
        v2: v2_list,
        det,
        b1,
        b2,
    })
}

/*
Splits a scalar s into components (u, v) using a precomputed GLV lattice.

Based on the approach described in https://www.iacr.org/archive/crypto2001/21390189.pdf,
this function finds a vector (u, v) such that s = u + v*lambda (mod r),
where lambda and r are the parameters used to generate the lattice l.
The vector (u, v) is typically chosen such that u and v have smaller magnitudes than s.

Args:
    s: The scalar to split.
    l: The precomputed Lattice object containing basis V1, V2, determinant Det,
       and rounding coefficients b1, b2.

Returns:
    A tuple (u, v) representing the scalar decomposition.
*/
fn split_scalar(s: &BigInt, l: &Lattice) -> [BigInt; 2] {
    // Calculate intermediate values k1, k2 using the scalar and rounding coefficients
    let mut k1 = s * &l.b1;
    let mut k2 = -(s * &l.b2);

    // Determine the shift amount 'n' used during lattice precomputation
    // This should match the logic in precompute_lattice
    let n_bit_length = std::cmp::max(1.into(), l.det.clone()).bits();
    let n = 2 * (((n_bit_length + 32) >> 6) << 6);

    // Right-shift k1 and k2 to effectively divide by 2^n,
    // approximating division by the determinant Det.
    // This gives the integer coefficients for the closest lattice vector approximation.
    k1 >>= n;
    k2 >>= n;

    // Calculate the lattice vector w = k1*V1 + k2*V2
    let w_vec0 = &k1 * &l.v1[0] + &k2 * &l.v2[0];
    let w_vec1 = &k1 * &l.v1[1] + &k2 * &l.v2[1];

    // Calculate the final decomposition (u, v)
    // u = s - w[0]
    // v = -w[1]
    let u = s - &w_vec0;
    let v = -w_vec1;

    [u, v]
}

pub fn half_gcd_eisenstein_hint(
    modulus: &BigInt,
    scalar: &BigInt,
    eigen_value: &BigInt,
) -> Result<[BigInt; 4], String> {
    let glv_basis = precompute_lattice(modulus, eigen_value)?;
    let r = eisenstein::EisensteinInteger::new(glv_basis.v1[0].clone(), glv_basis.v1[1].clone());
    let scalar = if scalar % modulus == modulus - 1 {
        BigInt::from(1)
    } else {
        scalar.clone()
    };

    let sp = split_scalar(&scalar, &glv_basis);
    let s = eisenstein::EisensteinInteger::new(sp[0].clone(), sp[1].clone());
    // in-circuit we check that Q - [s]P = 0 or equivalently Q + [-s]P = 0
    // so here we return -s instead of s.
    let s = -s;
    // println!("r: {}, \ns: {}", r, s);
    let [w, v_res, _] = eisenstein::half_gcd(&r, &s)?;

    // Note : outputs can be negative.
    Ok([
        w.a0.clone(),
        w.a1.clone(),
        v_res.a0.clone(),
        v_res.a1.clone(),
    ])
}

fn encode_value(value: &BigInt) -> BigUint {
    // Corresponds to Python: abs(value) + 2**128 if value < 0 else value
    let power_128_bigint: BigInt = BigInt::from(1) << 128;
    let power_128_biguint = power_128_bigint.to_biguint().unwrap(); // Safe because 2^128 > 0

    if value.sign() == Sign::Minus {
        // Convert `value.abs()` (BigInt) to BigUint before adding power_128 (BigUint)
        value.abs().to_biguint().unwrap() + power_128_biguint
    } else {
        // value is non-negative, safe to convert to BigUint
        value.to_biguint().unwrap()
    }
}

fn encode_glv_fake_glv_hint(u1: &BigInt, u2: &BigInt, v1: &BigInt, v2: &BigInt) -> [BigUint; 4] {
    // Re-use the standalone encode_value function
    [
        encode_value(u1),
        encode_value(u2),
        encode_value(v1),
        encode_value(v2),
    ]
}

/// Corresponds to Python `get_glv_fake_glv_hint`.
/// Computes the GLV hint components (u1, u2, v1, v2) encoded for Cairo, and the scalar multiplication result Q.
pub fn get_glv_fake_glv_hint<F>(
    point: &G1Point<F>,
    scalar: &BigUint,
) -> Result<(G1Point<F>, BigUint, BigUint, BigUint, BigUint), String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    let curve_params = F::get_curve_params();
    let curve_n_bigint = curve_params.n.to_bigint().unwrap();
    let scalar_bigint = scalar.to_bigint().unwrap();

    // Get eigen_value from curve_params
    let eigen_value = match &curve_params.eigen_value {
        Some(ev) => ev,
        None => {
            return Err(format!(
                "Curve {:?} does not have a known endomorphism eigenvalue or is not supported here.",
                curve_params.curve_id
            ));
        }
    };

    // Call half_gcd_eisenstein_hint to get raw u1, u2, v1, v2
    let hint_result = half_gcd_eisenstein_hint(&curve_n_bigint, &scalar_bigint, eigen_value)?;
    let [u1_raw, u2_raw, v1_raw, v2_raw] = hint_result;

    // Encode the results for Cairo compatibility
    let encoded_hints = encode_glv_fake_glv_hint(&u1_raw, &u2_raw, &v1_raw, &v2_raw);
    let [u1_encoded, u2_encoded, v1_encoded, v2_encoded] = encoded_hints;

    // Compute Q = [scalar]P
    let q = point.scalar_mul(scalar_bigint.clone()); // Assumes G1Point::scalar_mul takes BigInt

    Ok((q, u1_encoded, u2_encoded, v1_encoded, v2_encoded))
}

pub fn get_fake_glv_hint<F>(
    point: &G1Point<F>,
    scalar: &BigUint,
) -> Result<(G1Point<F>, BigUint, BigUint), String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    let curve_params = F::get_curve_params();
    let curve_n_bigint = curve_params.n.to_bigint().unwrap();
    let scalar_bigint = scalar.to_bigint().unwrap();

    // Check if the curve has an endomorphism; if so, this hint shouldn't be used.
    if curve_params.eigen_value.is_some() {
        return Err(format!(
            "Curve {:?} has an endomorphism, use get_glv_fake_glv_hint instead",
            curve_params.curve_id
        ));
    }

    // Call precompute_lattice using the scalar as the 'lambda' parameter,
    // mimicking the Python implementation.
    let glv_basis = precompute_lattice(&curve_n_bigint, &scalar_bigint)?;
    let s1 = &glv_basis.v1[0];
    let s2 = &glv_basis.v1[1];

    // Assertions from Python code converted to Rust checks
    if (s1 + &scalar_bigint * s2).mod_floor(&curve_n_bigint) != BigInt::from(0) {
        return Err("Assertion failed: (s1 + scalar * s2) % curve.n != 0".to_string());
    }
    // Check s1 > 0 and s2 != 0
    if !(s1.sign() == Sign::Plus && s2.sign() != Sign::NoSign) {
        return Err("Assertion failed: !(s1 > 0 and s2 != 0)".to_string());
    }

    // Compute Q = [scalar]P
    let q = point.scalar_mul(scalar_bigint.clone());

    // Convert s1 (known positive) to BigUint
    let s1_biguint = s1.to_biguint().unwrap();
    // Encode s2
    let s2_encoded = encode_value(s2);

    Ok((q, s1_biguint, s2_encoded))
}

#[allow(unused_imports)]
mod tests {
    use super::*;
    use num_traits::Num;
    use rand::Rng;
    use std::str::FromStr;

    #[test]
    fn test_bn254() -> Result<(), String> {
        let mut rng = rand::rng();
        for _ in 0..100 {
            let scalar = rng.random::<u128>().into();
            let curve_n = BigInt::from_str_radix(
                "30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001",
                16,
            )
            .unwrap();
            let eigen_value =
                BigInt::from_str_radix("B3C4D79D41A917585BFC41088D8DAAA78B17EA66B99C90DD", 16)
                    .unwrap();
            let [u1, u2, v1, v2] = half_gcd_eisenstein_hint(&curve_n, &scalar, &eigen_value)?;
            assert!(
                (&scalar * (&v1 + &eigen_value * &v2) + &u1 + &eigen_value * &u2)
                    .mod_floor(&curve_n)
                    == 0.into()
            );
        }
        Ok(())
    }

    #[test]
    fn test_bls12_381() -> Result<(), String> {
        use rand::Rng;
        let mut rng = rand::rng();
        for _ in 0..100 {
            let scalar = rng.random::<u128>().into();
            let curve_n = BigInt::from_str_radix(
                "73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001",
                16,
            )
            .unwrap();
            let eigen_value =
                BigInt::from_str_radix("AC45A4010001A40200000000FFFFFFFF", 16).unwrap();
            let [u1, u2, v1, v2] = half_gcd_eisenstein_hint(&curve_n, &scalar, &eigen_value)?;
            assert!(
                (&scalar * (&v1 + &eigen_value * &v2) + &u1 + &eigen_value * &u2)
                    .mod_floor(&curve_n)
                    == 0.into()
            );
        }
        Ok(())
    }

    #[test]
    fn test_secp256k1() -> Result<(), String> {
        use rand::Rng;
        let mut rng = rand::rng();
        for _ in 0..100 {
            let scalar = rng.random::<u128>().into();
            let curve_n = BigInt::from_str_radix(
                "FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141",
                16,
            )
            .unwrap();
            let eigen_value = BigInt::from_str_radix(
                "5363AD4CC05C30E0A5261C028812645A122E22EA20816678DF02967C1B23BD72",
                16,
            )
            .unwrap();
            let [u1, u2, v1, v2] = half_gcd_eisenstein_hint(&curve_n, &scalar, &eigen_value)?;
            assert!(
                (&scalar * (&v1 + &eigen_value * &v2) + &u1 + &eigen_value * &u2)
                    .mod_floor(&curve_n)
                    == 0.into()
            );
        }
        Ok(())
    }
}
