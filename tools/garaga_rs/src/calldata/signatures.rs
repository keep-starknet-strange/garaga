use crate::algebra::g1point::G1Point;
use crate::definitions::{
    get_modulus_from_curve_id, BLS12381PrimeField, BN254PrimeField, CurveParamsProvider,
    GrumpkinPrimeField, SECP256K1PrimeField, SECP256R1PrimeField, ToWeierstrassCurve,
    X25519PrimeField,
};

use crate::calldata::msm_calldata::msm_calldata_builder;
use crate::io::{biguint_split, element_from_biguint, element_to_biguint};
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::unsigned_integer::element::U256;
use num_bigint::BigUint;
use num_traits::Zero;
use sha2::{Digest, Sha512};

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

pub fn eddsa_calldata_builder(
    ry_twisted: BigUint,
    s: BigUint,
    py_twisted: BigUint,
    msg: Vec<u8>,
) -> Result<Vec<BigUint>, String> {
    let mut cd = Vec::new();

    let max_value = BigUint::from(1u64) << 256;
    if ry_twisted >= max_value {
        return Err("Invalid Ry value".to_string());
    }
    if py_twisted >= max_value {
        return Err("Invalid Py value".to_string());
    }
    if s >= max_value {
        return Err("Invalid s value".to_string());
    }

    cd.extend(biguint_split::<2, 128>(&ry_twisted).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&s).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&py_twisted).map(BigUint::from));
    cd.push(BigUint::from(msg.len() as u64));
    for byte in msg.clone() {
        cd.push(BigUint::from(byte as u64));
    }

    let mut hasher = Sha512::new();

    let ry_bytes = ry_twisted.to_bytes_le();
    let py_bytes = py_twisted.to_bytes_le();

    // Ensure the byte arrays are of length 32
    let ry_bytes_padded = if ry_bytes.len() < 32 {
        let mut padded = vec![0; 32];
        padded[..ry_bytes.len()].copy_from_slice(&ry_bytes);
        padded
    } else {
        ry_bytes
    };

    let py_bytes_padded = if py_bytes.len() < 32 {
        let mut padded = vec![0; 32];
        padded[..py_bytes.len()].copy_from_slice(&py_bytes);
        padded
    } else {
        py_bytes
    };

    hasher.update(&ry_bytes_padded);
    hasher.update(&py_bytes_padded);
    hasher.update(msg);

    let hash = hasher.finalize();

    let hash_biguint = BigUint::from_bytes_le(&hash);

    fn xrecover(y_twisted: FieldElement<X25519PrimeField>) -> FieldElement<X25519PrimeField> {
        let d_twisted = FieldElement::<X25519PrimeField>::from_hex(
            "52036CEE2B6FFE738CC740797779E89800700A4D4141D8AB75EB4DCA135978A3",
        )
        .unwrap();
        let i = FieldElement::<X25519PrimeField>::from_hex(
            "2b8324804fc1df0b2b4d00993dfbd7a72f431806ad2fe478c4ee1b274a0ea0b0",
        )
        .unwrap();
        let y_sq = y_twisted.square();
        let xx = ((y_sq.clone() - FieldElement::<X25519PrimeField>::one())
            / (d_twisted * y_sq + FieldElement::<X25519PrimeField>::one()))
        .unwrap();
        // exp =(p+3) // 8
        let exp = U256::from_hex("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe")
            .unwrap();
        let x = xx.pow(exp);
        let x = if x.square() != xx { x * i } else { x };
        let is_even = element_to_biguint(&x) % 2_u32 == BigUint::zero();
        if is_even {
            x
        } else {
            -x
        }
    }
    fn decode_point(
        compressed_point_le: BigUint,
    ) -> (
        FieldElement<X25519PrimeField>,
        FieldElement<X25519PrimeField>,
    ) {
        let two_pow_255: BigUint = BigUint::from(1u64) << 255;
        let sign_bit: BigUint = compressed_point_le.clone() / two_pow_255.clone();

        let y_twisted = compressed_point_le % two_pow_255;

        let y_twisted = element_from_biguint(&y_twisted);
        let x_twisted = xrecover(y_twisted.clone());

        let x_twisted = if element_to_biguint(&x_twisted.clone()) % 2_u32 != sign_bit {
            -x_twisted
        } else {
            x_twisted
        };

        (x_twisted, y_twisted)
    }

    let (r_point_x_twisted, r_point_y_twisted) = decode_point(ry_twisted);
    let (p_point_x_twisted, p_point_y_twisted) = decode_point(py_twisted);

    let (r_point_x_weierstrass, r_point_y_weierstrass) =
        X25519PrimeField::to_weirstrass(r_point_x_twisted.clone(), r_point_y_twisted);
    let (p_point_x_weierstrass, p_point_y_weierstrass) =
        X25519PrimeField::to_weirstrass(p_point_x_twisted.clone(), p_point_y_twisted);

    let _p_pt = G1Point::new(p_point_x_weierstrass.clone(), p_point_y_weierstrass.clone())
        .expect("Invalid point P");
    let _r_pt = G1Point::new(r_point_x_weierstrass.clone(), r_point_y_weierstrass.clone())
        .expect("Invalid point R");

    let gx = element_to_biguint(&X25519PrimeField::get_curve_params().g_x);
    let modulus = get_modulus_from_curve_id(CurveID::X25519);
    let neg_gy = modulus - element_to_biguint(&X25519PrimeField::get_curve_params().g_y);

    let h = hash_biguint % get_curve_order(CurveID::X25519);

    let values = &[
        gx,
        neg_gy,
        element_to_biguint(&p_point_x_weierstrass),
        element_to_biguint(&p_point_y_weierstrass),
    ];
    let scalars = &[s, h];

    let msm_cd = msm_calldata_builder(
        values,
        scalars,
        CurveID::X25519 as usize,
        Some(false),
        false,
        false,
        false,
    )?;

    cd.extend(msm_cd.into_iter().skip(1));

    cd.extend(biguint_split::<2, 128>(&element_to_biguint(&r_point_x_twisted)).map(BigUint::from));
    cd.extend(biguint_split::<2, 128>(&element_to_biguint(&p_point_x_twisted)).map(BigUint::from));

    Ok(cd)
}
