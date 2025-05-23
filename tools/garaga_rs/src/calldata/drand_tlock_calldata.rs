use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::calldata::drand_calldata::{
    digest_func, get_chain_hash, get_chain_info, hash_to_curve, DrandNetwork,
};
use crate::definitions::{BLS12381PrimeField, CurveParamsProvider, FieldElement};
use crate::pairing::final_exp_witness::{bls12_381_final_exp_witness, to_bls};
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField as BLS12381Degree12ExtensionField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField as BLS12381Degree2ExtensionField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::pairing::BLS12381AtePairing;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::twist::BLS12381TwistCurve;
use lambdaworks_math::elliptic_curve::short_weierstrass::point::ShortWeierstrassProjectivePoint;
use lambdaworks_math::elliptic_curve::traits::{FromAffine, IsPairing};
use num_bigint::BigUint;
use sha2::{Digest, Sha256};

pub fn drand_tlock_calldata_builder(values: &[BigUint]) -> Result<Vec<BigUint>, String> {
    if values.len() != 3 {
        return Err(format!("Invalid data array length: {}", values.len()));
    }
    let round_number: usize = (&values[0])
        .try_into()
        .map_err(|e| format!("Invalid round number: {}", e))?;
    let message = {
        let bytes = values[1].to_bytes_be();
        if bytes.len() > 16 {
            return Err(format!("Invalid message array length: {}", bytes.len()));
        }
        let mut padded_bytes = [0; 16];
        let len = bytes.len();
        padded_bytes[16 - len..].copy_from_slice(&bytes);
        padded_bytes
    };
    let sigma = {
        let bytes = values[2].to_bytes_be();
        if bytes.len() > 16 {
            return Err(format!("Invalid sigma array length: {}", bytes.len()));
        }
        let mut padded_bytes = [0; 16];
        let len = bytes.len();
        padded_bytes[16 - len..].copy_from_slice(&bytes);
        padded_bytes
    };
    let chain = get_chain_info(get_chain_hash(DrandNetwork::Quicknet))?;
    let public_key = chain.public_key.g2_point().unwrap().clone();
    let cipher_text = encrypt_for_round(public_key, round_number, message, sigma)?;
    let call_data = cipher_text.serialize_to_calldata();
    Ok(call_data)
}

pub struct CipherText {
    pub u: G2Point<BLS12381PrimeField, BLS12381Degree2ExtensionField>,
    pub v: [u8; 16],
    pub w: [u8; 16],
}

impl CipherText {
    pub fn serialize_to_calldata(&self) -> Vec<BigUint> {
        todo!() // TODO
    }
}

pub fn encrypt_for_round(
    public_key: G2Point<BLS12381PrimeField, BLS12381Degree2ExtensionField>,
    round_number: usize,
    message: [u8; 16],
    sigma: [u8; 16],
) -> Result<CipherText, String> {
    let round_number = round_number.try_into().unwrap();
    let msg_at_round = digest_func(round_number);
    let pt_at_round = hash_to_curve::<BLS12381PrimeField>(msg_at_round, "sha256")?;

    let gid = bls12381_single_pairing(pt_at_round, public_key)?;

    let r = {
        let mut bytes = vec![];
        bytes.extend(b"IBE-H3");
        bytes.extend(sigma);
        bytes.extend(message);
        let output = sha256_digest(&bytes);
        BigUint::from_bytes_le(&expand_message_drand(&output, 32))
    };
    let r = {
        let curve_params = BLS12381PrimeField::get_curve_params();
        r % curve_params.n
    };

    let u = G2Point::generator().scalar_mul::<BLS12381TwistCurve>(r.clone().into());

    let r_gid = bls12_381_final_exp_witness::pow_custom(&gid, &r);

    let r_gid_serialized = {
        let mut bytes = vec![];
        let mut values = to_bls(r_gid);
        values.reverse();
        for value in values {
            let mut padded_value_bytes = [0u8; 48];
            let value_bytes = value.to_bytes_be();
            let len = value_bytes.len();
            assert!(len <= 48);
            padded_value_bytes[48 - len..].copy_from_slice(&value_bytes);
            bytes.extend(padded_value_bytes);
        }
        bytes
    };

    let r_gid_hash: [u8; 16] = {
        let mut bytes = vec![];
        bytes.extend(b"IBE-H2");
        bytes.extend(r_gid_serialized);
        let output = sha256_digest(&bytes);
        output[..16].to_vec().try_into().unwrap()
    };

    let v: [u8; 16] = {
        let bytes = sigma
            .into_iter()
            .zip(r_gid_hash.into_iter())
            .map(|(a, b)| a ^ b)
            .collect::<Vec<_>>();
        bytes.try_into().unwrap()
    };

    let sigma_hash: [u8; 16] = {
        let mut bytes = vec![];
        bytes.extend(b"IBE-H4");
        bytes.extend(sigma);
        let output = sha256_digest(&bytes);
        output[..16].to_vec().try_into().unwrap()
    };

    let w: [u8; 16] = {
        let bytes = message
            .into_iter()
            .zip(sigma_hash.into_iter())
            .map(|(a, b)| a ^ b)
            .collect::<Vec<_>>();
        bytes.try_into().unwrap()
    };

    Ok(CipherText { u, v, w })
}

fn bls12381_single_pairing(
    g1_point: G1Point<BLS12381PrimeField>,
    g2_point: G2Point<BLS12381PrimeField, BLS12381Degree2ExtensionField>,
) -> Result<FieldElement<BLS12381Degree12ExtensionField>, String> {
    let g1_point = ShortWeierstrassProjectivePoint::from_affine(g1_point.x, g1_point.y)
        .map_err(|err| format!("{:?}", err))?;
    let g2_point = ShortWeierstrassProjectivePoint::from_affine(g2_point.x, g2_point.y)
        .map_err(|err| format!("{:?}", err))?;
    let product = BLS12381AtePairing::compute_batch(&[(&g1_point, &g2_point)])
        .map_err(|err| format!("{:?}", err))?;
    Ok(product)
}

fn expand_message_drand(msg: &[u8], buf_size: usize) -> Vec<u8> {
    assert!(buf_size <= 32);
    const BITS_TO_MASK_FOR_BLS12381: usize = 1;
    let curve_params = BLS12381PrimeField::get_curve_params();
    let order = curve_params.n;
    for i in 0..65536 {
        // u16::MAX is 65535
        let i: u16 = i.try_into().unwrap();

        // Hash iteratively: H(i || msg)
        let hash_result = {
            let mut bytes = vec![];
            bytes.extend(i.to_le_bytes());
            bytes.extend(msg);
            sha256_digest(&bytes)
        };

        // Mask the first byte
        let hash_result = {
            let mut bytes = hash_result;
            bytes[0] >>= BITS_TO_MASK_FOR_BLS12381;
            bytes
        };

        let reversed_hash = {
            let mut bytes = hash_result;
            bytes.reverse();
            bytes
        };

        let scalar = &BigUint::from_bytes_le(&reversed_hash) % &order;
        if scalar != BigUint::from(0usize) {
            return reversed_hash[..buf_size].to_vec();
        }
    }
    panic!("You are insanely unlucky and should have been hit by a meteor before now");
}

fn sha256_digest(data: &[u8]) -> [u8; 32] {
    Sha256::digest(data).into()
}
