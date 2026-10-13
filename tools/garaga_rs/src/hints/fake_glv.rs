use crate::algebra::g1point::G1Point;
use crate::definitions::CurveParamsProvider;
use crate::hints::eisenstein::{half_gcd as half_gcd_ext, EisensteinInteger};
use lambdaworks_math::field::traits::IsPrimeField;
use num_bigint::{BigInt, BigUint, Sign, ToBigInt};
use num_integer::Integer;
use num_traits::Signed;

struct Lattice {
    v1: [BigInt; 2],
}

/// Return the first GLV lattice vector, with its second coordinate nonnegative.
pub fn half_gcd(modu: &BigInt, input_val: &BigInt) -> Result<[BigInt; 2], String> {
    let lattice = precompute_lattice(modu, input_val)?;
    let output0 = lattice.v1[0].clone();
    let output1 = lattice.v1[1].clone();

    // The GLV decomposition often requires the absolute value of the second component.
    Ok([output0, output1.abs()])
}

/// Return the half-GCD vector (a,b) with a+b*λ=0 modulo r.
fn precompute_lattice(r: &BigInt, lam: &BigInt) -> Result<Lattice, String> {
    let sqrt_r = r.sqrt();
    let mut previous = r.clone();
    let mut remainder = lam.clone();
    let mut previous_coefficient = BigInt::from(0);
    let mut coefficient = BigInt::from(1);
    while remainder.abs() >= sqrt_r {
        if remainder == BigInt::from(0) {
            return Err("Division by zero in scalar decomposition".into());
        }
        let quotient = previous.div_floor(&remainder);
        let next_remainder = previous.mod_floor(&remainder);
        let next_coefficient = &previous_coefficient - &coefficient * quotient;
        previous = remainder;
        remainder = next_remainder;
        previous_coefficient = coefficient;
        coefficient = next_coefficient;
    }
    if remainder == BigInt::from(0) {
        return Err("The scalar decomposition has a zero numerator".into());
    }
    Ok(Lattice {
        v1: [remainder, -coefficient],
    })
}

pub fn half_gcd_eisenstein_hint(
    modulus: &BigInt,
    scalar: &BigInt,
    eigen_value: &BigInt,
) -> Result<[BigInt; 4], String> {
    if modulus <= &BigInt::from(1) {
        return Err("The lattice modulus must be greater than one".into());
    }
    let scalar = scalar.mod_floor(modulus);
    let scalar = if scalar == modulus - 1 {
        BigInt::from(1)
    } else {
        scalar
    };
    // Accept the cheap reconstruction only when it meets the exact circuit contract.
    if let Ok(basis) = precompute_lattice(modulus, &eigen_value.mod_floor(modulus)) {
        let kernel = EisensteinInteger::new(basis.v1[0].clone(), basis.v1[1].clone());
        if kernel.norm() == *modulus {
            let [_, remainder] =
                EisensteinInteger::new(scalar.clone(), 0.into()).quo_rem(&kernel)?;
            let [w, v, _] = half_gcd_ext(&kernel, &(-remainder))?;
            let denominator = (&v.a0 + eigen_value * &v.a1).mod_floor(modulus);
            let relation =
                (&w.a0 + eigen_value * &w.a1 + &scalar * &denominator).mod_floor(modulus);
            let candidate = [w.a0, w.a1, v.a0, v.a1];
            let width = modulus.bits().div_ceil(4) + 1;
            if denominator != BigInt::from(0)
                && relation == BigInt::from(0)
                && candidate
                    .iter()
                    .all(|coordinate| coordinate.bits() <= width)
            {
                return Ok(candidate);
            }
        }
    }
    crate::hints::lattice::rational_reconstruct_extension(modulus, &scalar, eigen_value)
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

    if curve_params.curve_id == crate::definitions::CurveID::BLS12_381
        && !point.scalar_mul(curve_n_bigint.clone()).is_infinity()
    {
        return Err("BLS12-381 MSM points must be in the prime-order subgroup".into());
    }

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
    let decomposition_scalar = if scalar_bigint == BigInt::from(0) {
        BigInt::from(1)
    } else {
        scalar_bigint.clone()
    };

    // Check if the curve has an endomorphism; if so, this hint shouldn't be used.
    if curve_params.eigen_value.is_some() {
        return Err(format!(
            "Curve {:?} has an endomorphism, use get_glv_fake_glv_hint instead",
            curve_params.curve_id
        ));
    }

    // Call precompute_lattice using the scalar as the 'lambda' parameter,
    // mimicking the Python implementation.
    let glv_basis = precompute_lattice(&curve_n_bigint, &decomposition_scalar)?;
    let s1 = &glv_basis.v1[0];
    let s2 = &glv_basis.v1[1];

    // Assertions from Python code converted to Rust checks
    if (s1 + &decomposition_scalar * s2).mod_floor(&curve_n_bigint) != BigInt::from(0) {
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

pub fn get_ed25519_cofactor_hint<F>(point: &G1Point<F>, scalar: &BigUint) -> G1Point<F>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    point.scalar_mul((scalar / BigUint::from(8u64)).to_bigint().unwrap())
}

pub fn get_bls12_381_cofactor_hint<F>(point: &G1Point<F>) -> Result<G1Point<F>, String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
{
    let curve = F::get_curve_params();
    if curve.curve_id != crate::definitions::CurveID::BLS12_381 {
        return Err("The cofactor hint is only for BLS12-381".into());
    }
    if !point.is_on_curve() {
        return Err("The cofactor hint requires an on-curve point".into());
    }
    let clearing_factor = BigInt::from(0xd201000000010001u64);
    let order = curve.n.to_bigint().unwrap();
    let inverse = clearing_factor.extended_gcd(&order).x.mod_floor(&order);
    let preimage = point.scalar_mul(inverse);
    if !preimage.scalar_mul(clearing_factor).eq(point) {
        return Err("BLS12-381 MSM points must be in the prime-order subgroup".into());
    }
    Ok(preimage)
}

#[allow(unused_imports)]
mod tests {
    use super::*;
    use num_traits::Num;
    use rand::Rng;
    use std::str::FromStr;

    #[test]
    fn test_checked_eisenstein_fast_path_matches_python() {
        let modulus = BigInt::from(13);
        let eigenvalue = BigInt::from(3);
        for scalar in [5, 18, -8] {
            let scalar = BigInt::from(scalar);
            let result = half_gcd_eisenstein_hint(&modulus, &scalar, &eigenvalue).unwrap();
            assert_eq!(result, [1.into(), 0.into(), (-2).into(), (-2).into()]);
            let denominator = &result[2] + &eigenvalue * &result[3];
            assert_ne!(denominator.mod_floor(&modulus), BigInt::from(0));
            assert_eq!(
                (&result[0] + &eigenvalue * &result[1] + &scalar * denominator).mod_floor(&modulus),
                BigInt::from(0),
            );
            assert!(result.iter().all(|coordinate| coordinate.bits() <= 2));
        }
    }

    #[test]
    fn test_checked_eisenstein_full_lll_fallback_accepts_extra_bit() {
        let modulus = BigInt::from(13);
        let scalar = BigInt::from(5);
        let eigenvalue = BigInt::from(0);
        let result = half_gcd_eisenstein_hint(&modulus, &scalar, &eigenvalue).unwrap();
        assert_eq!(
            result,
            crate::hints::lattice::rational_reconstruct_extension(&modulus, &scalar, &eigenvalue)
                .unwrap(),
        );
        let maximum = result.iter().map(Signed::abs).max().unwrap();
        assert_eq!(maximum, BigInt::from(3));
        assert!(maximum > modulus.sqrt().sqrt());
        assert_ne!(result[2].mod_floor(&modulus), BigInt::from(0));
        assert_eq!(
            (&result[0] + &scalar * &result[2]).mod_floor(&modulus),
            BigInt::from(0),
        );
        assert!(result.iter().all(|coordinate| coordinate.bits() <= 2));
    }

    #[test]
    fn test_checked_eisenstein_rejects_invalid_modulus() {
        for modulus in [0, 1, -13] {
            assert!(
                half_gcd_eisenstein_hint(&modulus.into(), &5.into(), &3.into())
                    .unwrap_err()
                    .contains("modulus")
            );
        }
    }

    #[test]
    fn test_checked_eisenstein_precompute_failure_uses_lll() {
        let modulus = BigInt::from(15);
        let scalar = BigInt::from(5);
        let eigenvalue = BigInt::from(5);
        assert_eq!(
            half_gcd_eisenstein_hint(&modulus, &scalar, &eigenvalue).unwrap(),
            crate::hints::lattice::rational_reconstruct_extension(&modulus, &scalar, &eigenvalue)
                .unwrap(),
        );
    }

    #[test]
    fn test_bls12_381_cofactor_preimage() -> Result<(), String> {
        use crate::definitions::{BLS12381PrimeField, FieldElement};
        let generator = G1Point::<BLS12381PrimeField>::generator();
        let order = BLS12381PrimeField::get_curve_params().n;
        for scalar in [BigUint::from(0u64), 1u64.into(), 2u64.into(), order - 1u64] {
            let point = generator.scalar_mul(scalar.into());
            let preimage = get_bls12_381_cofactor_hint(&point)?;
            assert!(preimage.is_on_curve());
            assert_eq!(preimage.scalar_mul(0xd201000000010001u64.into()), point);
        }
        let torsion = G1Point::<BLS12381PrimeField>::new(
            FieldElement::zero(),
            FieldElement::from(2u64),
            false,
        )?;
        for point in [torsion.clone(), generator.add(&torsion)] {
            assert!(get_bls12_381_cofactor_hint(&point)
                .unwrap_err()
                .contains("prime-order subgroup"));
        }
        Ok(())
    }

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
