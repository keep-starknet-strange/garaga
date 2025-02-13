use crate::definitions::{
    BLS12381PrimeField, BN254PrimeField, CurveParamsProvider, GrumpkinPrimeField,
    SECP256K1PrimeField, SECP256R1PrimeField, X25519PrimeField,
};

use crate::calldata::msm_calldata::msm_calldata_builder;
use crate::io::{biguint_split, element_to_biguint};

use num_bigint::BigUint;

use crate::definitions::CurveID;

// Fix the get_curve_order function to use FieldElement
pub fn get_curve_order(curve_id: CurveID) -> BigUint {
    match curve_id {
        CurveID::BLS12_381 => BLS12381PrimeField::get_curve_params().n,
        CurveID::BN254 => BN254PrimeField::get_curve_params().n,
        CurveID::SECP256K1 => SECP256K1PrimeField::get_curve_params().n,
        CurveID::SECP256R1 => SECP256R1PrimeField::get_curve_params().n,
        CurveID::X25519 => X25519PrimeField::get_curve_params().n,
        CurveID::GRUMPKIN => GrumpkinPrimeField::get_curve_params().n,
    }
}
/// Build calldata for Schnorr signature verification
///
/// Arguments:
/// * `rx` - x-coordinate of R point
/// * `s` - signature value
/// * `e` - challenge hash
/// * `px` - public key x-coordinate
/// * `py` - public key y-coordinate
/// * `curve_id` - curve identifier
pub fn schnorr_calldata_builder(
    rx: BigUint,
    s: BigUint,
    e: BigUint,
    px: BigUint,
    py: BigUint,
    curve_id: usize,
) -> Result<Vec<BigUint>, String> {
    let mut cd = Vec::new();

    // Add base signature components
    cd.extend(biguint_split::<4, 96>(&rx).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&s).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&e).map(BigUint::from));
    cd.extend(biguint_split::<4, 96>(&px).map(BigUint::from));
    cd.extend(biguint_split::<4, 96>(&py).map(BigUint::from));

    // Calculate e_neg = -e mod n
    let curve_id = CurveID::try_from(curve_id)?;
    let n = get_curve_order(curve_id);
    let e_neg = n - e;

    // Add MSM calldata for sG + (-e)P
    let msm_cd = msm_calldata_builder(
        &[
            match curve_id {
                CurveID::BN254 => element_to_biguint(&BN254PrimeField::get_curve_params().g_x),
                CurveID::BLS12_381 => {
                    element_to_biguint(&BLS12381PrimeField::get_curve_params().g_x)
                }
                CurveID::SECP256K1 => {
                    element_to_biguint(&SECP256K1PrimeField::get_curve_params().g_x)
                }
                CurveID::SECP256R1 => {
                    element_to_biguint(&SECP256R1PrimeField::get_curve_params().g_x)
                }
                CurveID::X25519 => element_to_biguint(&X25519PrimeField::get_curve_params().g_x),
                CurveID::GRUMPKIN => {
                    element_to_biguint(&GrumpkinPrimeField::get_curve_params().g_x)
                }
            },
            match curve_id {
                CurveID::BN254 => element_to_biguint(&BN254PrimeField::get_curve_params().g_y),
                CurveID::BLS12_381 => {
                    element_to_biguint(&BLS12381PrimeField::get_curve_params().g_y)
                }
                CurveID::SECP256K1 => {
                    element_to_biguint(&SECP256K1PrimeField::get_curve_params().g_y)
                }
                CurveID::SECP256R1 => {
                    element_to_biguint(&SECP256R1PrimeField::get_curve_params().g_y)
                }
                CurveID::X25519 => element_to_biguint(&X25519PrimeField::get_curve_params().g_y),
                CurveID::GRUMPKIN => {
                    element_to_biguint(&GrumpkinPrimeField::get_curve_params().g_y)
                }
            },
            px,
            py,
        ],
        &[s, e_neg],
        curve_id as usize,
        Some(false),
        false,
        false,
        false,
    )?;

    cd.extend(msm_cd.into_iter().skip(1));
    Ok(cd)
}

/// Build calldata for ECDSA signature verification
///
/// Arguments:
/// * `r` - signature r value
/// * `s` - signature s value
/// * `v` - recovery parameter (0 or 1)
/// * `px` - public key x-coordinate
/// * `py` - public key y-coordinate
/// * `z` - message hash
/// * `curve_id` - curve identifier
pub fn ecdsa_calldata_builder(
    r: BigUint,
    s: BigUint,
    v: u8,
    px: BigUint,
    py: BigUint,
    z: BigUint,
    curve_id: usize,
) -> Result<Vec<BigUint>, String> {
    let mut cd = Vec::new();

    // Add base signature components
    cd.extend(biguint_split::<4, 96>(&r).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&s).map(BigUint::from));
    cd.push(BigUint::from(v));
    cd.extend(biguint_split::<4, 96>(&px).map(BigUint::from));
    cd.extend(biguint_split::<4, 96>(&py).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&z).map(BigUint::from));

    // Calculate s_inv, u1, u2
    let curve_id = CurveID::try_from(curve_id)?;
    let n = get_curve_order(curve_id);

    let s_inv = s.modpow(&(n.clone() - BigUint::from(2u32)), &n);
    let u1 = (z * &s_inv) % &n;
    let u2 = (r * &s_inv) % &n;

    // Add MSM calldata for u1*G + u2*P
    let msm_cd = msm_calldata_builder(
        &[
            match curve_id {
                CurveID::BN254 => element_to_biguint(&BN254PrimeField::get_curve_params().g_x),
                CurveID::BLS12_381 => {
                    element_to_biguint(&BLS12381PrimeField::get_curve_params().g_x)
                }
                CurveID::SECP256K1 => {
                    element_to_biguint(&SECP256K1PrimeField::get_curve_params().g_x)
                }
                CurveID::SECP256R1 => {
                    element_to_biguint(&SECP256R1PrimeField::get_curve_params().g_x)
                }
                CurveID::X25519 => element_to_biguint(&X25519PrimeField::get_curve_params().g_x),
                CurveID::GRUMPKIN => {
                    element_to_biguint(&GrumpkinPrimeField::get_curve_params().g_x)
                }
            },
            match curve_id {
                CurveID::BN254 => element_to_biguint(&BN254PrimeField::get_curve_params().g_y),
                CurveID::BLS12_381 => {
                    element_to_biguint(&BLS12381PrimeField::get_curve_params().g_y)
                }
                CurveID::SECP256K1 => {
                    element_to_biguint(&SECP256K1PrimeField::get_curve_params().g_y)
                }
                CurveID::SECP256R1 => {
                    element_to_biguint(&SECP256R1PrimeField::get_curve_params().g_y)
                }
                CurveID::X25519 => element_to_biguint(&X25519PrimeField::get_curve_params().g_y),
                CurveID::GRUMPKIN => {
                    element_to_biguint(&GrumpkinPrimeField::get_curve_params().g_y)
                }
            },
            px,
            py,
        ],
        &[u1, u2],
        curve_id as usize,
        Some(false),
        false,
        false,
        false,
    )?;

    cd.extend(msm_cd.into_iter().skip(1));
    Ok(cd)
}
