use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::calldata::mpc_calldata;
use crate::definitions::{BLS12381PrimeField, CurveID, CurveParamsProvider, FieldElement};
use crate::io::{element_from_bytes_be, element_to_biguint, field_element_to_u384_limbs};
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::{BigInt, BigUint};
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

fn hash_to_curve<F>(message: [u8; 32], hash_name: &str) -> G1Point<F>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let [felt0, felt1] = hash_to_field::<F>(message, 2, hash_name)
        .try_into()
        .unwrap();

    let pt0 = map_to_curve(felt0);
    let pt1 = map_to_curve(felt1);
    assert!(pt0.iso_point, "Point {:?} is not an iso point", pt0);
    assert!(pt1.iso_point, "Point {:?} is not an iso point", pt1);

    let curve_params = F::get_curve_params();
    let cofactor = match curve_params.curve_id {
        CurveID::BLS12_381 => {
            let x = BigInt::from(curve_params.x);
            let n: BigInt = curve_params.n.try_into().unwrap();
            (BigInt::from(1) - (&x % &n)) % &n
        }
        _ => BigInt::from(curve_params.h),
    };

    let sum = pt0.add(&pt1);
    assert!(sum.iso_point, "Point {:?} is not an iso point", sum);

    /*apply_isogeny(*/
    sum /*)*/
        .scalar_mul(cofactor)
}

fn map_to_curve<F>(field_element: FieldElement<F>) -> G1Point<F>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let curve_params = F::get_curve_params();
    let swu_params = curve_params.swu_params.unwrap();
    let a = swu_params.a;
    let b = swu_params.b;
    let z = swu_params.z;

    let u = field_element;

    let zeta_u2 = &z * (&u * &u);
    let ta = (&zeta_u2 * &zeta_u2) + &zeta_u2;
    let num_x1 = &b * (&ta + FieldElement::<F>::from(1));

    let div = if ta == FieldElement::from(0) {
        &a * &z
    } else {
        &a * -ta
    };

    let num2_x1 = &num_x1 * &num_x1;
    let div2 = &div * &div;
    let div3 = &div2 * &div;
    assert!(div3 != FieldElement::from(0));

    let num_gx1 = (&num2_x1 + &a * &div2) * &num_x1 + &b * &div3;
    let num_x2 = &zeta_u2 * &num_x1;

    let gx1 = (&num_gx1 / &div3).unwrap();
    let gx1_square = false; // TODO gx1.is_quad_residue();
    let y1 = if gx1_square {
        let (y1, _) = gx1.sqrt(/*min_root=False*/).unwrap(); // TODO
        assert!(&y1 * &y1 == gx1);
        y1
    } else {
        let (y1, _) = (&z * &gx1).sqrt(/*min_root=False*/).unwrap(); // TODO
        assert!(&y1 * &y1 == &z * &gx1);
        y1
    };

    let y2 = &zeta_u2 * &u * &y1;
    let num_x = if gx1_square { num_x1 } else { num_x2 };
    let y = if gx1_square { y1.clone() } else { y2 };
    let x_affine = (&num_x / &div).unwrap();
    let y_flag = element_to_biguint(&y) % BigUint::from(2usize)
        == element_to_biguint(&u) % BigUint::from(2usize);
    let y_affine = if !y_flag { -y } else { y };
    let point_on_curve = G1Point::new(x_affine, y_affine, true).unwrap();
    point_on_curve
}

fn hash_to_field<F>(message: [u8; 32], count: usize, hash_name: &str) -> Vec<FieldElement<F>>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let len_per_elem = get_len_per_elem::<F>(None);
    let output = match hash_name {
        "sha256" => hash_to_bytes::<Sha256Hasher>(message, count, len_per_elem),
        _ => panic!("unsupported hash name"),
    };
    output.iter().map(|v| element_from_bytes_be(&v)).collect()
}

fn hash_to_bytes<H: Hasher>(message: [u8; 32], count: usize, len_per_elem: usize) -> Vec<Vec<u8>> {
    let len_in_bytes = count * len_per_elem;
    assert!(
        len_in_bytes < (1 << 16),
        "Length should be smaller than 2^16"
    );
    let mut expander = ExpanderXmd::<H>::new(DST, len_per_elem);
    let uniform_bytes = expander.expand_message_xmd(&message, len_in_bytes.try_into().unwrap());
    let mut output = vec![];
    for i in (0..len_in_bytes).step_by(len_per_elem) {
        output.push(uniform_bytes[i..i + len_per_elem].to_vec());
    }
    output
}

fn get_len_per_elem<F>(sec_param: Option<usize>) -> usize
where
    F: IsPrimeField,
{
    let sec_param = match sec_param {
        Option::None => 128,
        Option::Some(sec_param) => sec_param,
    };
    let base_field_size_in_bits = F::field_bit_size();
    let base_field_size_with_security_padding_in_bits = base_field_size_in_bits + sec_param;
    let bytes_per_base_field_elem = (base_field_size_with_security_padding_in_bits + 7) / 8;
    bytes_per_base_field_elem
}

trait Hasher: Clone {
    fn new() -> Self;
    fn reset(&mut self);
    fn update(&mut self, bytes: &[u8]);
    fn digest_size(&self) -> usize;
    fn digest(&self) -> Vec<u8>;
}

#[derive(Clone)]
struct Sha256Hasher {
    data: Vec<u8>,
}

impl Hasher for Sha256Hasher {
    fn new() -> Self {
        Self { data: vec![] }
    }
    fn reset(&mut self) {
        self.data = vec![];
    }
    fn update(&mut self, bytes: &[u8]) {
        self.data.extend_from_slice(bytes);
    }
    fn digest_size(&self) -> usize {
        32
    }
    fn digest(&self) -> Vec<u8> {
        Sha256::digest(&self.data).to_vec()
    }
}

const G1_DOMAIN: &[u8] = b"BLS_SIG_BLS12381G1_XMD:SHA-256_SSWU_RO_NUL_";
const DST: &[u8] = G1_DOMAIN;
const LONG_DST_PREFIX: &[u8] = b"H2C-OVERSIZE-DST-";
const MAX_DST_LENGTH: usize = 255;

struct ExpanderXmd<H: Hasher> {
    hasher: H,
    dst: Vec<u8>,
    block_size: usize,
}

impl<H: Hasher> ExpanderXmd<H> {
    fn new(dst: &[u8], block_size: usize) -> Self {
        Self {
            hasher: H::new(),
            dst: dst.to_vec(),
            block_size,
        }
    }
    fn construct_dst_prime(&self) -> Vec<u8> {
        let mut dst_prime = if self.dst.len() > MAX_DST_LENGTH {
            let mut hasher_copy = self.hasher.clone();
            hasher_copy.update(LONG_DST_PREFIX);
            hasher_copy.update(&self.dst);
            hasher_copy.digest()
        } else {
            self.dst.clone()
        };
        dst_prime.push(dst_prime.len().try_into().unwrap());
        dst_prime
    }
    fn expand_message_xmd(&mut self, msg: &[u8], n: u16) -> Vec<u8> {
        let mut uniform_bytes = vec![];

        let b_len = self.hasher.digest_size();
        let ell = (TryInto::<usize>::try_into(n).unwrap() + (b_len - 1)) / b_len;
        assert!(
            ell <= 255,
            "The ratio of desired output to the output size of hash function is too large!"
        );

        let dst_prime = self.construct_dst_prime();
        let z_pad = vec![0u8; self.block_size];
        let lib_str: [u8; 2] = n.to_be_bytes();

        self.hasher.update(&z_pad);
        self.hasher.update(msg);
        let mut lib_str_dst_prime = lib_str.to_vec();
        lib_str_dst_prime.push(0);
        lib_str_dst_prime.extend_from_slice(&dst_prime);
        self.hasher.update(&lib_str_dst_prime);
        let b0 = self.hasher.digest();
        let mut hasher = self.hasher.clone();
        hasher.reset();
        hasher.update(&b0);
        let mut one_dst_prime = vec![1];
        one_dst_prime.extend_from_slice(&dst_prime);
        hasher.update(&one_dst_prime);
        let mut bi = hasher.digest();

        uniform_bytes.extend_from_slice(&bi);

        for i in 2..ell + 1 {
            let b0_xor_bi = b0
                .iter()
                .zip(bi.iter())
                .map(|(&x, &y)| x ^ y)
                .collect::<Vec<u8>>();
            let mut hasher = self.hasher.clone();
            hasher.reset();
            hasher.update(&b0_xor_bi);
            let mut bytes_i_dst_prime = vec![i.try_into().unwrap()];
            bytes_i_dst_prime.extend_from_slice(&dst_prime);
            hasher.update(&bytes_i_dst_prime);
            bi = hasher.digest();
            uniform_bytes.extend_from_slice(&bi);
        }
        uniform_bytes[0..n.try_into().unwrap()].to_vec()
    }
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

fn build_hash_to_curve_hint(message: [u8; 32]) -> HashToCurveHint {
    let [felt0, felt1] = hash_to_field::<BLS12381PrimeField>(message, 2, "sha256")
        .try_into()
        .unwrap();
    let (pt0, f0_hint) = build_map_to_curve_hint(felt0);
    let (pt1, f1_hint) = build_map_to_curve_hint(felt1);
    let _sum_pt = pt0.add(&pt1);
    /*
    sum_pt = apply_isogeny(sum_pt)
    */
    let curve_params = BLS12381PrimeField::get_curve_params();
    let x = BigInt::from(curve_params.x);
    let n = BigInt::from(curve_params.n);
    let _cofactor: BigUint = ((BigInt::from(1) - (&x % &n)) % &n).try_into().unwrap();

    /*
    msm_builder = MSMCalldataBuilder(
        curve_id=CurveID.BLS12_381, points=[sum_pt], scalars=[cofactor], risc0_mode=True
    )
    msm_hint, derive_point_from_x_hint = msm_builder.build_msm_hints()
    */

    HashToCurveHint {
        f0_hint,
        f1_hint,
        //scalar_mul_hint=msm_hint,
        //derive_point_from_x_hint=derive_point_from_x_hint,
    }
}

fn build_map_to_curve_hint(
    u: FieldElement<BLS12381PrimeField>,
) -> (G1Point<BLS12381PrimeField>, MapToCurveHint) {
    let curve_params = BLS12381PrimeField::get_curve_params();
    let swu_params = curve_params.swu_params.unwrap();
    let a = swu_params.a;
    let b = swu_params.b;
    let z = swu_params.z;

    let zeta_u2 = &z * (&u * &u);
    let ta = (&zeta_u2 * &zeta_u2) + &zeta_u2;
    let num_x1 = &b * (&ta + FieldElement::<BLS12381PrimeField>::from(1));

    let div = if ta == FieldElement::from(0) {
        &a * &z
    } else {
        &a * -ta
    };

    let num2_x1 = &num_x1 * &num_x1;
    let div2 = &div * &div;
    let div3 = &div2 * &div;
    assert!(div3 != FieldElement::from(0));

    let num_gx1 = (&num2_x1 + &a * &div2) * &num_x1 + &b * &div3;
    let num_x2 = &zeta_u2 * &num_x1;

    let gx1 = (&num_gx1 / &div3).unwrap();
    let gx1_square = false; // TODO gx1.is_quad_residue();
    let y1 = if gx1_square {
        let (y1, _) = gx1.sqrt(/*min_root=False*/).unwrap(); // TODO
        assert!(&y1 * &y1 == gx1);
        y1
    } else {
        let (y1, _) = (&z * &gx1).sqrt(/*min_root=False*/).unwrap(); // TODO
        assert!(&y1 * &y1 == &z * &gx1);
        y1
    };

    let y2 = &zeta_u2 * &u * &y1;
    let y = if gx1_square { y1.clone() } else { y2 };
    let y_flag = element_to_biguint(&y) % BigUint::from(2usize)
        == element_to_biguint(&u) % BigUint::from(2usize);

    let num_x = if gx1_square { num_x1 } else { num_x2 };
    let x_affine = (&num_x / &div).unwrap();
    let y_affine = if !y_flag { -y } else { y };

    let point_on_curve = G1Point::new(x_affine, y_affine, true).unwrap();
    (
        point_on_curve,
        MapToCurveHint {
            gx1_is_square: gx1_square,
            y1,
            y_flag,
        },
    )
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
