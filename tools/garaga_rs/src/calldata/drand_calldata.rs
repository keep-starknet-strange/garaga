use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::calldata::mpc_calldata;
use crate::definitions::{BLS12381PrimeField, FieldElement};
use crate::io::field_element_to_u384_limbs;
use lambdaworks_math::field::traits::IsPrimeField;
use num_bigint::BigUint;
use sha2::{Digest, Sha256};

pub fn drand_round_to_calldata(round_number: usize) -> Result<Vec<BigUint>, String> {
    let round_number = round_number.try_into().map_err(|err| format!("{}", err))?;

    let message = digest_func(round_number);

    let msg_point = hash_to_curve(message, "sha256");

    let chain = get_chain_info(get_chain_hash(DrandNetwork::Quicknet));

    let round = get_randomness_signature_point(chain.hash, round_number);

    let sig_pt = round.signature_point;

    let hash_to_curve_hint = build_hash_to_curve_hint(message).to_calldata()?;

    let pairs = [
        G1G2Pair::new(sig_pt.clone(), G2Point::generator()),
        G1G2Pair::new(msg_point, chain.public_key),
    ];
    let mpc_data = {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree6ExtensionField;
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField;
        mpc_calldata::calldata_builder::<
            false,
            BLS12381PrimeField,
            Degree2ExtensionField,
            Degree6ExtensionField,
            Degree12ExtensionField,
        >(&pairs, 2, &None)?
    };

    let size = 1 + 4 + 4 + hash_to_curve_hint.len() + mpc_data.len();
    let mut call_data = vec![size.into()];
    call_data.push(round_number.into());
    call_data.extend(field_element_to_u384_limbs(&sig_pt.x).map(BigUint::from));
    call_data.extend(field_element_to_u384_limbs(&sig_pt.y).map(BigUint::from));
    call_data.extend(hash_to_curve_hint);
    call_data.extend(mpc_data);
    assert!(call_data.len() == 1 + size);
    Ok(call_data)
}

fn digest_func(round_number: u64) -> [u8; 32] {
    let bytes = round_number.to_be_bytes();
    let digest = Sha256::digest(bytes);
    digest.try_into().unwrap()
}

fn hash_to_curve<T: IsPrimeField>(_message: [u8; 32], _hash_name: &str) -> G1Point<T> {
    // TODO
    todo!()
}

struct MapToCurveHint {
    gx1_is_square: bool,
    y1: FieldElement<BLS12381PrimeField>,
    y_flag: bool,
}

impl MapToCurveHint {
    fn to_calldata(self) -> Vec<BigUint> {
        let mut call_data = vec![];
        call_data.push(self.gx1_is_square.into());
        call_data.extend(field_element_to_u384_limbs(&self.y1).map(BigUint::from));
        call_data.push(self.y_flag.into());
        call_data
    }
}

struct HashToCurveHint {
    f0_hint: MapToCurveHint,
    f1_hint: MapToCurveHint,
    /*
    scalar_mul_hint: structs.Struct
    derive_point_from_x_hint: structs.Struct
    */
}

impl HashToCurveHint {
    fn to_calldata(self) -> Result<Vec<BigUint>, String> {
        let mut call_data = vec![];
        call_data.extend(self.f0_hint.to_calldata());
        call_data.extend(self.f1_hint.to_calldata());
        /*
        call_data.extend(self.scalar_mul_hint.serialize_to_calldata());
        call_data.extend(self.derive_point_from_x_hint.serialize_to_calldata());
        */
        Ok(call_data)
    }
}

fn build_hash_to_curve_hint(_message: [u8; 32]) -> HashToCurveHint {
    // TODO
    todo!()
}

const _BASE_URLS: [&str; 4] = [
    "https://drand.cloudflare.com",
    "https://api.drand.sh",
    "https://api2.drand.sh",
    "https://api3.drand.sh",
];

pub enum DrandNetwork {
    Default,
    Quicknet,
}

fn from_hex(hex: &str) -> [u8; 32] {
    assert!(hex.len() == 64);
    let mut bytes = [0u8; 32];
    for i in 0..32 {
        bytes[i] = u8::from_str_radix(&hex[2 * i..2 * (i + 1)], 16).unwrap();
    }
    bytes
}

fn get_chain_hash(network: DrandNetwork) -> [u8; 32] {
    match network {
        DrandNetwork::Default => {
            from_hex("8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce")
        }
        DrandNetwork::Quicknet => {
            from_hex("52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971")
        }
    }
}

use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField;
struct NetworkInfo {
    public_key: G2Point<BLS12381PrimeField, Degree2ExtensionField>,
    hash: [u8; 32],
}

fn get_chain_info(_chain_hash: [u8; 32]) -> NetworkInfo {
    // TODO
    let public_key = G2Point::generator();
    let hash = [0u8; 32];
    NetworkInfo { public_key, hash }
}

struct RandomnessBeacon {
    signature_point: G1Point<BLS12381PrimeField>,
}

fn get_randomness_signature_point(_chain_hash: [u8; 32], _round_number: u64) -> RandomnessBeacon {
    // TODO
    todo!()
}
