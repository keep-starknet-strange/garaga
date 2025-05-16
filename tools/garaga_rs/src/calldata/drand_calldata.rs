use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::g1point::G1Point;
use crate::algebra::g2point::G2Point;
use crate::algebra::polynomial::Polynomial;
use crate::algebra::rational_function::RationalFunction;
use crate::calldata::mpc_calldata;
use crate::definitions::{BLS12381PrimeField, CurveID, CurveParamsProvider, FieldElement};
use crate::io::{
    element_from_biguint, element_from_bytes_be, element_to_biguint, field_element_to_u384_limbs,
};
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree12ExtensionField as BLS12381Degree12ExtensionField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree2ExtensionField as BLS12381Degree2ExtensionField;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::Degree6ExtensionField as BLS12381Degree6ExtensionField;
use lambdaworks_math::field::traits::{IsPrimeField, LegendreSymbol};
use lambdaworks_math::traits::ByteConversion;
use num_bigint::{BigInt, BigUint};
use num_traits::Num;
use sha2::{Digest, Sha256};

pub fn drand_calldata_builder(values: &[BigUint]) -> Result<Vec<BigUint>, String> {
    if values.len() != 3 {
        return Err(format!("Invalid data array length: {}", values.len()));
    }
    let round_number: usize = (&values[0])
        .try_into()
        .map_err(|e| format!("Invalid round number: {}", e))?;
    let randomness = {
        let bytes = values[1].to_bytes_be();
        if bytes.len() > 32 {
            return Err(format!("Invalid randomness array length: {}", bytes.len()));
        }
        let mut padded_bytes = [0; 32];
        let len = bytes.len();
        padded_bytes[32 - len..].copy_from_slice(&bytes);
        padded_bytes
    };
    let signature = {
        let bytes = values[2].to_bytes_be();
        // Only supports G1 compressed points as per Quicknet
        if bytes.len() > 48 {
            return Err(format!("Invalid signature array length: {}", bytes.len()));
        }
        let mut padded_bytes = [0; 48];
        let len = bytes.len();
        padded_bytes[48 - len..].copy_from_slice(&bytes);
        deserialize_bls_point(&padded_bytes)?
    };
    let round = RandomnessBeacon {
        round_number,
        randomness,
        signature,
        previous_signature: None,
    };
    drand_randomness_to_calldata(round)
}

pub fn drand_randomness_to_calldata(round: RandomnessBeacon) -> Result<Vec<BigUint>, String> {
    let chain = get_chain_info(get_chain_hash(DrandNetwork::Quicknet))?;

    let round_number = round.round_number.try_into().unwrap();

    let message = digest_func(round_number);

    let msg_point = hash_to_curve(message, "sha256")?;

    let sig_pt = round.signature.g1_point().unwrap().clone();

    let hash_to_curve_hint = build_hash_to_curve_hint(message)?.to_calldata()?;

    let pairs = [
        G1G2Pair::new(sig_pt.clone(), G2Point::generator()),
        G1G2Pair::new(msg_point, chain.public_key.g2_point().unwrap().neg()),
    ];
    let mpc_data = {
        mpc_calldata::calldata_builder::<
            false,
            BLS12381PrimeField,
            BLS12381Degree2ExtensionField,
            BLS12381Degree6ExtensionField,
            BLS12381Degree12ExtensionField,
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

pub fn drand_round_to_calldata(round_number: usize) -> Result<Vec<BigUint>, String> {
    let round_number = round_number.try_into().map_err(|err| format!("{}", err))?;
    let round = get_randomness(get_chain_hash(DrandNetwork::Quicknet), round_number);
    drand_randomness_to_calldata(round)
}

fn digest_func(round_number: u64) -> [u8; 32] {
    let bytes = round_number.to_be_bytes();
    let digest = Sha256::digest(bytes);
    digest.into()
}

fn hash_to_curve<F>(message: [u8; 32], hash_name: &str) -> Result<G1Point<F>, String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let [felt0, felt1] = hash_to_field::<F>(message, 2, hash_name)?
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
            let n: BigInt = curve_params.n.into();
            (BigInt::from(1) - (&x % &n)) % &n
        }
        _ => BigInt::from(curve_params.h),
    };

    let sum = pt0.add(&pt1);
    assert!(sum.iso_point, "Point {:?} is not an iso point", sum);

    Ok(apply_isogeny(sum).scalar_mul(cofactor))
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
    let gx1_square = is_quad_residue(&gx1);
    let y1 = if gx1_square {
        let y1 = max_sqrt(&gx1);
        assert!(&y1 * &y1 == gx1);
        y1
    } else {
        let y1 = max_sqrt(&(&z * &gx1));
        assert!(&y1 * &y1 == &z * &gx1);
        y1
    };

    let y2 = &zeta_u2 * &u * &y1;
    let num_x = if gx1_square { num_x1 } else { num_x2 };
    let y = if gx1_square { y1.clone() } else { y2.clone() };
    let x_affine = (&num_x / &div).unwrap();
    let y_flag = element_to_biguint(&y) % BigUint::from(2usize)
        == element_to_biguint(&u) % BigUint::from(2usize);
    let y_affine = if !y_flag { -y.clone() } else { y.clone() };

    G1Point::new(x_affine, y_affine, true).unwrap()
}

fn hash_to_field<F>(
    message: [u8; 32],
    count: usize,
    hash_name: &str,
) -> Result<Vec<FieldElement<F>>, String>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let len_per_elem = get_len_per_elem::<F>(None);
    let output = match hash_name {
        "sha256" => hash_to_bytes::<Sha256Hasher>(message, count, len_per_elem),
        _ => return Err(format!("Unsupported hash function: {}", hash_name)),
    };
    Ok(output
        .into_iter()
        .map(|v| element_from_bytes_be(&v))
        .collect())
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

/*
This function computes the length in bytes that a hash function should output
for hashing an element of type `Field`.

:param sec_param: The security parameter.
:return: The length in bytes.
*/
fn get_len_per_elem<F>(sec_param: Option<usize>) -> usize
where
    F: IsPrimeField,
{
    let sec_param = sec_param.unwrap_or(128);
    let base_field_size_in_bits = F::field_bit_size();
    let base_field_size_with_security_padding_in_bits = base_field_size_in_bits + sec_param;

    base_field_size_with_security_padding_in_bits.div_ceil(8)
}

fn is_quad_residue<F: IsPrimeField>(element: &FieldElement<F>) -> bool {
    if element == &FieldElement::from(0) {
        true
    } else {
        element.legendre_symbol() == LegendreSymbol::One
    }
}

fn min_sqrt<F>(element: &FieldElement<F>) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let (sqrt1, sqrt2) = element.sqrt().unwrap();
    if element_to_biguint(&sqrt1) < element_to_biguint(&sqrt2) {
        sqrt1
    } else {
        sqrt2
    }
}

fn max_sqrt<F>(element: &FieldElement<F>) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let (sqrt1, sqrt2) = element.sqrt().unwrap();
    if element_to_biguint(&sqrt1) > element_to_biguint(&sqrt2) {
        sqrt1
    } else {
        sqrt2
    }
}

pub trait Hasher: Clone {
    fn new() -> Self;
    fn reset(&mut self);
    fn update(&mut self, bytes: &[u8]);
    fn digest_size(&self) -> usize;
    fn digest(&self) -> Vec<u8>;
}

#[derive(Clone)]
pub struct Sha256Hasher {
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

pub struct ExpanderXmd<H: Hasher> {
    pub hasher: H,
    pub dst: Vec<u8>,
    pub block_size: usize,
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
        let ell = Into::<usize>::into(n).div_ceil(b_len);
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
        uniform_bytes[0..n.into()].to_vec()
    }
}

fn apply_isogeny<F>(pt: G1Point<F>) -> G1Point<F>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert!(pt.iso_point, "Point {:?} is not an iso point", pt);
    let (x_rational, y_rational) = get_isogeny_to_g1_map::<F>();
    let x_affine = x_rational.evaluate(pt.x.clone());
    let y_affine = y_rational.evaluate(pt.x) * pt.y;
    G1Point::new(x_affine, y_affine, false).unwrap()
}

fn get_isogeny_to_g1_map<F>() -> (RationalFunction<F>, RationalFunction<F>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let curve_params = F::get_curve_params();
    match curve_params.curve_id {
        CurveID::BLS12_381 => {
            let f1 = RationalFunction::new(
                Polynomial::new(
                    vec![
                        BigUint::from_str_radix("11A05F2B1E833340B809101DD99815856B303E88A2D7005FF2627B56CDB4E2C85610C2D5F2E62D6EAEAC1662734649B7", 16).unwrap(),
                        BigUint::from_str_radix("17294ED3E943AB2F0588BAB22147A81C7C17E75B2F6A8417F565E33C70D1E86B4838F2A6F318C356E834EEF1B3CB83BB", 16).unwrap(),
                        BigUint::from_str_radix("D54005DB97678EC1D1048C5D10A9A1BCE032473295983E56878E501EC68E25C958C3E3D2A09729FE0179F9DAC9EDCB0", 16).unwrap(),
                        BigUint::from_str_radix("1778E7166FCC6DB74E0609D307E55412D7F5E4656A8DBF25F1B33289F1B330835336E25CE3107193C5B388641D9B6861", 16).unwrap(),
                        BigUint::from_str_radix("E99726A3199F4436642B4B3E4118E5499DB995A1257FB3F086EEB65982FAC18985A286F301E77C451154CE9AC8895D9", 16).unwrap(),
                        BigUint::from_str_radix("1630C3250D7313FF01D1201BF7A74AB5DB3CB17DD952799B9ED3AB9097E68F90A0870D2DCAE73D19CD13C1C66F652983", 16).unwrap(),
                        BigUint::from_str_radix("D6ED6553FE44D296A3726C38AE652BFB11586264F0F8CE19008E218F9C86B2A8DA25128C1052ECADDD7F225A139ED84", 16).unwrap(),
                        BigUint::from_str_radix("17B81E7701ABDBE2E8743884D1117E53356DE5AB275B4DB1A682C62EF0F2753339B7C8F8C8F475AF9CCB5618E3F0C88E", 16).unwrap(),
                        BigUint::from_str_radix("80D3CF1F9A78FC47B90B33563BE990DC43B756CE79F5574A2C596C928C5D1DE4FA295F296B74E956D71986A8497E317", 16).unwrap(),
                        BigUint::from_str_radix("169B1F8E1BCFA7C42E0C37515D138F22DD2ECB803A0C5C99676314BAF4BB1B7FA3190B2EDC0327797F241067BE390C9E", 16).unwrap(),
                        BigUint::from_str_radix("10321DA079CE07E272D8EC09D2565B0DFA7DCCDDE6787F96D50AF36003B14866F69B771F8C285DECCA67DF3F1605FB7B", 16).unwrap(),
                        BigUint::from_str_radix("6E08C248E260E70BD1E962381EDEE3D31D79D7E22C837BC23C0BF1BC24C6B68C24B1B80B64D391FA9C8BA2E8BA2D229", 16).unwrap(),
                    ].iter().map(element_from_biguint).collect()
                ),
                Polynomial::new(
                    vec![
                        BigUint::from_str_radix("8CA8D548CFF19AE18B2E62F4BD3FA6F01D5EF4BA35B48BA9C9588617FC8AC62B558D681BE343DF8993CF9FA40D21B1C", 16).unwrap(),
                        BigUint::from_str_radix("12561A5DEB559C4348B4711298E536367041E8CA0CF0800C0126C2588C48BF5713DAA8846CB026E9E5C8276EC82B3BFF", 16).unwrap(),
                        BigUint::from_str_radix("B2962FE57A3225E8137E629BFF2991F6F89416F5A718CD1FCA64E00B11ACEACD6A3D0967C94FEDCFCC239BA5CB83E19", 16).unwrap(),
                        BigUint::from_str_radix("3425581A58AE2FEC83AAFEF7C40EB545B08243F16B1655154CCA8ABC28D6FD04976D5243EECF5C4130DE8938DC62CD8", 16).unwrap(),
                        BigUint::from_str_radix("13A8E162022914A80A6F1D5F43E7A07DFFDFC759A12062BB8D6B44E833B306DA9BD29BA81F35781D539D395B3532A21E", 16).unwrap(),
                        BigUint::from_str_radix("E7355F8E4E667B955390F7F0506C6E9395735E9CE9CAD4D0A43BCEF24B8982F7400D24BC4228F11C02DF9A29F6304A5", 16).unwrap(),
                        BigUint::from_str_radix("772CAACF16936190F3E0C63E0596721570F5799AF53A1894E2E073062AEDE9CEA73B3538F0DE06CEC2574496EE84A3A", 16).unwrap(),
                        BigUint::from_str_radix("14A7AC2A9D64A8B230B3F5B074CF01996E7F63C21BCA68A81996E1CDF9822C580FA5B9489D11E2D311F7D99BBDCC5A5E", 16).unwrap(),
                        BigUint::from_str_radix("A10ECF6ADA54F825E920B3DAFC7A3CCE07F8D1D7161366B74100DA67F39883503826692ABBA43704776EC3A79A1D641", 16).unwrap(),
                        BigUint::from_str_radix("95FC13AB9E92AD4476D6E3EB3A56680F682B4EE96F7D03776DF533978F31C1593174E4B4B7865002D6384D168ECDD0A", 16).unwrap(),
                        BigUint::from_str_radix("1", 16).unwrap(),
                    ].iter().map(element_from_biguint).collect()
                ),
            );
            let f2 = RationalFunction::new(
                Polynomial::new(
                    vec![
                        BigUint::from_str_radix("90d97c81ba24ee0259d1f094980dcfa11ad138e48a869522b52af6c956543d3cd0c7aee9b3ba3c2be9845719707bb33", 16).unwrap(),
                        BigUint::from_str_radix("134996a104ee5811d51036d776fb46831223e96c254f383d0f906343eb67ad34d6c56711962fa8bfe097e75a2e41c696", 16).unwrap(),
                        BigUint::from_str_radix("cc786baa966e66f4a384c86a3b49942552e2d658a31ce2c344be4b91400da7d26d521628b00523b8dfe240c72de1f6", 16).unwrap(),
                        BigUint::from_str_radix("1f86376e8981c217898751ad8746757d42aa7b90eeb791c09e4a3ec03251cf9de405aba9ec61deca6355c77b0e5f4cb", 16).unwrap(),
                        BigUint::from_str_radix("8cc03fdefe0ff135caf4fe2a21529c4195536fbe3ce50b879833fd221351adc2ee7f8dc099040a841b6daecf2e8fedb", 16).unwrap(),
                        BigUint::from_str_radix("16603fca40634b6a2211e11db8f0a6a074a7d0d4afadb7bd76505c3d3ad5544e203f6326c95a807299b23ab13633a5f0", 16).unwrap(),
                        BigUint::from_str_radix("4ab0b9bcfac1bbcb2c977d027796b3ce75bb8ca2be184cb5231413c4d634f3747a87ac2460f415ec961f8855fe9d6f2", 16).unwrap(),
                        BigUint::from_str_radix("987c8d5333ab86fde9926bd2ca6c674170a05bfe3bdd81ffd038da6c26c842642f64550fedfe935a15e4ca31870fb29", 16).unwrap(),
                        BigUint::from_str_radix("9fc4018bd96684be88c9e221e4da1bb8f3abd16679dc26c1e8b6e6a1f20cabe69d65201c78607a360370e577bdba587", 16).unwrap(),
                        BigUint::from_str_radix("e1bba7a1186bdb5223abde7ada14a23c42a0ca7915af6fe06985e7ed1e4d43b9b3f7055dd4eba6f2bafaaebca731c30", 16).unwrap(),
                        BigUint::from_str_radix("19713e47937cd1be0dfd0b8f1d43fb93cd2fcbcb6caf493fd1183e416389e61031bf3a5cce3fbafce813711ad011c132", 16).unwrap(),
                        BigUint::from_str_radix("18b46a908f36f6deb918c143fed2edcc523559b8aaf0c2462e6bfe7f911f643249d9cdf41b44d606ce07c8a4d0074d8e", 16).unwrap(),
                        BigUint::from_str_radix("b182cac101b9399d155096004f53f447aa7b12a3426b08ec02710e807b4633f06c851c1919211f20d4c04f00b971ef8", 16).unwrap(),
                        BigUint::from_str_radix("245a394ad1eca9b72fc00ae7be315dc757b3b080d4c158013e6632d3c40659cc6cf90ad1c232a6442d9d3f5db980133", 16).unwrap(),
                        BigUint::from_str_radix("5c129645e44cf1102a159f748c4a3fc5e673d81d7e86568d9ab0f5d396a7ce46ba1049b6579afb7866b1e715475224b", 16).unwrap(),
                        BigUint::from_str_radix("15e6be4e990f03ce4ea50b3b42df2eb5cb181d8f84965a3957add4fa95af01b2b665027efec01c7704b456be69c8b604", 16).unwrap(),
                    ].iter().map(element_from_biguint).collect()
                ),
                Polynomial::new(
                    vec![
                        BigUint::from_str_radix("16112c4c3a9c98b252181140fad0eae9601a6de578980be6eec3232b5be72e7a07f3688ef60c206d01479253b03663c1", 16).unwrap(),
                        BigUint::from_str_radix("1962d75c2381201e1a0cbd6c43c348b885c84ff731c4d59ca4a10356f453e01f78a4260763529e3532f6102c2e49a03d", 16).unwrap(),
                        BigUint::from_str_radix("58df3306640da276faaae7d6e8eb15778c4855551ae7f310c35a5dd279cd2eca6757cd636f96f891e2538b53dbf67f2", 16).unwrap(),
                        BigUint::from_str_radix("16b7d288798e5395f20d23bf89edb4d1d115c5dbddbcd30e123da489e726af41727364f2c28297ada8d26d98445f5416", 16).unwrap(),
                        BigUint::from_str_radix("be0e079545f43e4b00cc912f8228ddcc6d19c9f0f69bbb0542eda0fc9dec916a20b15dc0fd2ededda39142311a5001d", 16).unwrap(),
                        BigUint::from_str_radix("8d9e5297186db2d9fb266eaac783182b70152c65550d881c5ecd87b6f0f5a6449f38db9dfa9cce202c6477faaf9b7ac", 16).unwrap(),
                        BigUint::from_str_radix("166007c08a99db2fc3ba8734ace9824b5eecfdfa8d0cf8ef5dd365bc400a0051d5fa9c01a58b1fb93d1a1399126a775c", 16).unwrap(),
                        BigUint::from_str_radix("16a3ef08be3ea7ea03bcddfabba6ff6ee5a4375efa1f4fd7feb34fd206357132b920f5b00801dee460ee415a15812ed9", 16).unwrap(),
                        BigUint::from_str_radix("1866c8ed336c61231a1be54fd1d74cc4f9fb0ce4c6af5920abc5750c4bf39b4852cfe2f7bb9248836b233d9d55535d4a", 16).unwrap(),
                        BigUint::from_str_radix("167a55cda70a6e1cea820597d94a84903216f763e13d87bb5308592e7ea7d4fbc7385ea3d529b35e346ef48bb8913f55", 16).unwrap(),
                        BigUint::from_str_radix("4d2f259eea405bd48f010a01ad2911d9c6dd039bb61a6290e591b36e636a5c871a5c29f4f83060400f8b49cba8f6aa8", 16).unwrap(),
                        BigUint::from_str_radix("accbb67481d033ff5852c1e48c50c477f94ff8aefce42d28c0f9a88cea7913516f968986f7ebbea9684b529e2561092", 16).unwrap(),
                        BigUint::from_str_radix("ad6b9514c767fe3c3613144b45f1496543346d98adf02267d5ceef9a00d9b8693000763e3b90ac11e99b138573345cc", 16).unwrap(),
                        BigUint::from_str_radix("2660400eb2e4f3b628bdd0d53cd76f2bf565b94e72927c1cb748df27942480e420517bd8714cc80d1fadc1326ed06f7", 16).unwrap(),
                        BigUint::from_str_radix("e0fa1d816ddc03e6b24255e0d7819c171c40f65e273b853324efcd6356caa205ca2f570f13497804415473a1d634b8f", 16).unwrap(),
                        BigUint::from_str_radix("1", 16).unwrap(),
                    ].iter().map(element_from_biguint).collect()
                ),
            );
            (f1, f2)
        }
        curve_id => unimplemented!("Isogeny for curve {:?} is not implemented", curve_id),
    }
}

pub struct MapToCurveHint {
    pub gx1_is_square: bool,
    pub y1: FieldElement<BLS12381PrimeField>,
    pub y_flag: bool,
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

pub struct HashToCurveHint {
    pub f0_hint: MapToCurveHint,
    pub f1_hint: MapToCurveHint,
}

impl HashToCurveHint {
    fn to_calldata(self) -> Result<Vec<BigUint>, String> {
        let mut call_data = vec![];
        call_data.extend(self.f0_hint.to_calldata());
        call_data.extend(self.f1_hint.to_calldata());
        Ok(call_data)
    }
}

fn build_hash_to_curve_hint(message: [u8; 32]) -> Result<HashToCurveHint, String> {
    let [felt0, felt1] = hash_to_field::<BLS12381PrimeField>(message, 2, "sha256")?
        .try_into()
        .unwrap();
    let f0_hint = build_map_to_curve_hint(felt0);
    let f1_hint = build_map_to_curve_hint(felt1);
    Ok(HashToCurveHint { f0_hint, f1_hint })
}

fn build_map_to_curve_hint(u: FieldElement<BLS12381PrimeField>) -> MapToCurveHint {
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

    let gx1 = (&num_gx1 / &div3).unwrap();
    let gx1_square = is_quad_residue(&gx1);
    let y1 = if gx1_square {
        let y1 = max_sqrt(&gx1);
        assert!(&y1 * &y1 == gx1);
        y1
    } else {
        let y1 = max_sqrt(&(&z * &gx1));
        assert!(&y1 * &y1 == &z * &gx1);
        y1
    };

    let y2 = &zeta_u2 * &u * &y1;
    let y = if gx1_square { y1.clone() } else { y2 };
    let y_flag = element_to_biguint(&y) % BigUint::from(2usize)
        == element_to_biguint(&u) % BigUint::from(2usize);

    MapToCurveHint {
        gx1_is_square: gx1_square,
        y1,
        y_flag,
    }
}

pub fn get_base_urls() -> Vec<&'static str> {
    vec![
        "https://drand.cloudflare.com",
        "https://api.drand.sh",
        "https://api2.drand.sh",
        "https://api3.drand.sh",
    ]
}

pub enum DrandNetwork {
    Default,
    Quicknet,
}

pub fn get_chain_hash(network: DrandNetwork) -> [u8; 32] {
    match network {
        DrandNetwork::Default => {
            from_hex("8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce")
        }
        DrandNetwork::Quicknet => {
            from_hex("52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971")
        }
    }
}

pub enum CurvePoint {
    G1Point(G1Point<BLS12381PrimeField>),
    G2Point(G2Point<BLS12381PrimeField, BLS12381Degree2ExtensionField>),
}

impl CurvePoint {
    pub fn g1_point(&self) -> Option<&G1Point<BLS12381PrimeField>> {
        match self {
            Self::G1Point(point) => Some(point),
            _ => None,
        }
    }
    pub fn g2_point(&self) -> Option<&G2Point<BLS12381PrimeField, BLS12381Degree2ExtensionField>> {
        match self {
            Self::G2Point(point) => Some(point),
            _ => None,
        }
    }
}

pub fn deserialize_bls_point(s_string: &[u8]) -> Result<CurvePoint, String> {
    let m_byte = s_string[0] & 0xE0;
    if [0x20, 0x60, 0xE0].contains(&m_byte) {
        return Err("Invalid encoding".to_string());
    }

    let c_bit = (m_byte & 0x80) >> 7; // Compression bit
    let i_bit = (m_byte & 0x40) >> 6; // Infinity bit
    let s_bit = (m_byte & 0x20) >> 5; // Sign bit

    let mut s_string = s_string.to_vec();
    s_string[0] &= 0x1F;

    if i_bit == 1 {
        if !s_string.iter().all(|&b| b == 0) {
            return Err("Invalid encoding for point at infinity".to_string());
        }
        let point = if [48, 96].contains(&s_string.len()) {
            CurvePoint::G1Point(G1Point::new_infinity())
        } else {
            CurvePoint::G2Point(G2Point::new_infinity())
        };
        return Ok(point);
    }

    if c_bit == 0 {
        if s_string.len() == 96 {
            // G1 point (uncompressed)
            let x = element_from_bytes_be(&s_string[..48]);
            let y = element_from_bytes_be(&s_string[48..]);
            return Ok(CurvePoint::G1Point(G1Point::new(x, y, false)?));
        }
        if s_string.len() == 192 {
            // G2 point (uncompressed)
            let x0 = element_from_bytes_be(&s_string[..48]);
            let x1 = element_from_bytes_be(&s_string[48..96]);
            let y0 = element_from_bytes_be(&s_string[96..144]);
            let y1 = element_from_bytes_be(&s_string[144..]);
            return Ok(CurvePoint::G2Point(G2Point::new([x0, x1], [y0, y1])?));
        }
        Err(format!(
            "Invalid length for uncompressed point: {}",
            s_string.len()
        ))
    } else {
        // C_bit == 1
        if s_string.len() == 48 {
            // G1 point (compressed)
            let x = element_from_bytes_be(&s_string);
            let y2 = &x * &x * &x + FieldElement::from(4);
            let y = if s_bit == 1 {
                max_sqrt(&y2)
            } else {
                min_sqrt(&y2)
            };
            return Ok(CurvePoint::G1Point(G1Point::new(x, y, false)?));
        }
        if s_string.len() == 96 {
            // G2 point (compressed)
            unimplemented!("Decoding of compressed G2 points not yet supported");
        }
        Err(format!(
            "Invalid length for compressed point: {}",
            s_string.len()
        ))
    }
}

pub struct NetworkInfo {
    pub public_key: CurvePoint,
    pub period: usize,
    pub genesis_time: usize,
    pub hash: [u8; 32],
    pub group_hash: [u8; 32],
    pub scheme_id: String,
    pub beacon_id: DrandNetwork,
}

pub fn get_chain_info(chain_hash: [u8; 32]) -> Result<NetworkInfo, String> {
    let network = if chain_hash == get_chain_hash(DrandNetwork::Default) {
        DrandNetwork::Default
    } else if chain_hash == get_chain_hash(DrandNetwork::Quicknet) {
        DrandNetwork::Quicknet
    } else {
        return Err(format!("Unknown chain hash: {:?}", chain_hash));
    };
    let info = match network {
        DrandNetwork::Default => {
            let x = FieldElement::from_hex_unchecked("68f005eb8e6e4ca0a47c8a77ceaa5309a47978a7c71bc5cce96366b5d7a569937c529eeda66c7293784a9402801af31");
            let y = FieldElement::from_hex_unchecked("26fa5eef143aaa17c53b3c150d96a18051b718531af576803cfb9acf29b8774a8184e63c62da81ddf4d76fb0a65895c");
            NetworkInfo {
                public_key: CurvePoint::G1Point(G1Point::new(x, y, false).unwrap()),
                period: 30,
                genesis_time: 1595431050,
                hash: chain_hash,
                group_hash: from_hex(
                    "176f93498eac9ca337150b46d21dd58673ea4e3581185f869672e59fa4cb390a",
                ),
                scheme_id: "pedersen-bls-chained".to_string(),
                beacon_id: DrandNetwork::Default,
            }
        }
        DrandNetwork::Quicknet => {
            let x = [
                FieldElement::from_hex_unchecked("d1fec758c921cc22b0e17e63aaf4bcb5ed66304de9cf809bd274ca73bab4af5a6e9c76a4bc09e76eae8991ef5ece45a"),
                FieldElement::from_hex_unchecked("3cf0f2896adee7eb8b5f01fcad3912212c437e0073e911fb90022d3e760183c8c4b450b6a0a6c3ac6a5776a2d106451"),
            ];
            let y = [
                FieldElement::from_hex_unchecked("e5db2b6bfbb01c867749cadffca88b36c24f3012ba09fc4d3022c5c37dce0f977d3adb5d183c7477c442b1f04515273"),
                FieldElement::from_hex_unchecked("1a714f2edb74119a2f2b0d5a7c75ba902d163700a61bc224ededd8e63aef7be1aaf8e93d7a9718b047ccddb3eb5d68b"),
            ];
            NetworkInfo {
                public_key: CurvePoint::G2Point(G2Point::new(x, y).unwrap()),
                period: 3,
                genesis_time: 1692803367,
                hash: chain_hash,
                group_hash: from_hex(
                    "f477d5c89f21a17c863a7f937c6a6d15859414d2be09cd448d4279af331c5d3e",
                ),
                scheme_id: "bls-unchained-g1-rfc9380".to_string(),
                beacon_id: DrandNetwork::Quicknet,
            }
        }
    };
    Ok(info)
}

pub struct RandomnessBeacon {
    pub round_number: usize,
    pub randomness: [u8; 32],
    pub signature: CurvePoint,
    pub previous_signature: Option<CurvePoint>,
}

fn from_hex(hex: &str) -> [u8; 32] {
    assert!(hex.len() == 64);
    let mut bytes = [0u8; 32];
    for i in 0..32 {
        bytes[i] = u8::from_str_radix(&hex[2 * i..2 * (i + 1)], 16).unwrap();
    }
    bytes
}

fn get_randomness(chain_hash: [u8; 32], round_number: u64) -> RandomnessBeacon {
    /* hardcoded for testing */
    if chain_hash == get_chain_hash(DrandNetwork::Quicknet) {
        match round_number {
            1 => {
                let x = FieldElement::from_hex_unchecked("155e7cb2d5c613ee0b2e28d6750aabbb78c39dcc96bd9d38c2c2e12198df95571de8e8e402a0cc48871c7089a2b3af4b");
                let y = FieldElement::from_hex_unchecked("0fbb74ee8788264320f2501b0fa0dd56363bcec5ce4b113b2bf1de6e331116c79191af99234824f03aeb10ab1c4c7771");
                return RandomnessBeacon {
                    round_number: round_number.try_into().unwrap(),
                    randomness: from_hex(
                        "1466a6cd24e327188770752f6134001c64d6efcc590ccc26b721611ad96f165a",
                    ),
                    signature: CurvePoint::G1Point(G1Point::new(x, y, false).unwrap()),
                    previous_signature: None,
                };
            }
            2 => {
                let x = FieldElement::from_hex_unchecked("16b6a585449b66eb12e875b64fcbab3799861a00e4dbf092d99e969a5eac57dd3f798acf61e705fe4f093db926626807");
                let y = FieldElement::from_hex_unchecked("15ff2dfd0adad43e0219d11f00f14d4e14cb0d8292bd2c0a8ec634c1b402c2a067fc5d9c53aa2aa0aab8214ca1fce58c");
                return RandomnessBeacon {
                    round_number: round_number.try_into().unwrap(),
                    randomness: from_hex(
                        "5782d6987841c654515a0e72b2d1ebb4e741234042c37cb19608ae50d93fb60c",
                    ),
                    signature: CurvePoint::G1Point(G1Point::new(x, y, false).unwrap()),
                    previous_signature: None,
                };
            }
            3 => {
                let x = FieldElement::from_hex_unchecked("13fab6df720b68cc47175f2c777e86d84187caab5770906f515ff1099cb01e4deaa027075d860823e49477b93c72bd64");
                let y = FieldElement::from_hex_unchecked("18a83e0a35ee138a879bebc1ac56ab46832bf67deaa63061fb98c8d35333557003c4cde8c2b5320ce2be2073a12b6112");
                return RandomnessBeacon {
                    round_number: round_number.try_into().unwrap(),
                    randomness: from_hex(
                        "7ef4621ace1c6da4eb2eee7cd901f81385bca5b189771ec0f08d0d2566dd1a21",
                    ),
                    signature: CurvePoint::G1Point(G1Point::new(x, y, false).unwrap()),
                    previous_signature: None,
                };
            }
            _ => (),
        }
    }
    unimplemented!("Not to be used in production");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_drand_round_to_calldata_1() {
        let _ = drand_round_to_calldata(1).unwrap();
    }

    #[test]
    fn test_drand_round_to_calldata_2() {
        let _ = drand_round_to_calldata(2).unwrap();
    }

    #[test]
    fn test_drand_round_to_calldata_3() {
        let _ = drand_round_to_calldata(3).unwrap();
    }
}
