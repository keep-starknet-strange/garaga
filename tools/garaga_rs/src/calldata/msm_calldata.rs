use crate::algebra::{g1point::G1Point, rational_function::FunctionFelt};
use crate::definitions::{
    BLS12381PrimeField, BN254PrimeField, CurveParamsProvider, FieldElement, GrumpkinPrimeField,
    SECP256K1PrimeField, SECP256R1PrimeField, Stark252PrimeField, X25519PrimeField,
};
use crate::{
    ecip::core::{neg_3_base_le, run_ecip},
    io::{
        element_to_biguint, felt252_to_element, field_element_to_u288_limbs,
        field_element_to_u384_limbs, field_elements_from_big_uints, padd_function_felt,
        parse_g1_points_from_flattened_field_elements_list, scalar_to_limbs,
    },
    poseidon_transcript::CairoPoseidonTranscript,
};
use lambdaworks_crypto::hash::poseidon::{starknet::PoseidonCairoStark252, Poseidon};
use lambdaworks_math::{
    field::traits::{IsPrimeField, LegendreSymbol},
    traits::ByteConversion,
};

use num_bigint::BigUint;

use crate::definitions::CurveID;

pub fn msm_calldata_builder(
    values: &[BigUint],
    scalars: &[BigUint],
    curve_id: usize,
    include_digits_decomposition: Option<bool>,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
    risc0_mode: bool,
) -> Result<Vec<BigUint>, String> {
    if values.len() != 2 * scalars.len() {
        return Err("Values length must be twice the scalars length".to_string());
    }
    let curve_id = CurveID::try_from(curve_id)?;
    match curve_id {
        CurveID::BN254 => handle_curve::<BN254PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::BLS12_381 => handle_curve::<BLS12381PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::SECP256K1 => handle_curve::<SECP256K1PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::SECP256R1 => handle_curve::<SECP256R1PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::X25519 => handle_curve::<X25519PrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
        CurveID::GRUMPKIN => handle_curve::<GrumpkinPrimeField>(
            values,
            scalars,
            curve_id as usize,
            include_digits_decomposition,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
            risc0_mode,
        ),
    }
}

fn handle_curve<F>(
    values: &[BigUint],
    scalars: &[BigUint],
    curve_id: usize,
    include_digits_decomposition: Option<bool>,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
    risc0_mode: bool,
) -> Result<Vec<BigUint>, String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let elements = field_elements_from_big_uints::<F>(values);
    let points = parse_g1_points_from_flattened_field_elements_list(&elements)?;
    let limit = if risc0_mode {
        &(BigUint::from(1usize) << 128)
    } else {
        &F::get_curve_params().n
    };
    if !scalars.iter().all(|x| x < limit) {
        if risc0_mode {
            return Err("Scalar value must be less than 2**128".to_string());
        } else {
            return Err("Scalar value must be less than the curve order".to_string());
        }
    }

    let use_288 = curve_id != 1;

    Ok(calldata_builder::<F>(
        &points,
        scalars,
        curve_id,
        include_digits_decomposition,
        include_points_and_scalars,
        serialize_as_pure_felt252_array,
        risc0_mode,
        Option::None,
        use_288,
    ))
}

pub fn calldata_builder<F: IsPrimeField + CurveParamsProvider<F>>(
    points: &[G1Point<F>],
    scalars: &[BigUint],
    curve_id: usize,
    include_digits_decomposition: Option<bool>,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
    risc0_mode: bool,
    external_points_scalars_hash: Option<(
        FieldElement<Stark252PrimeField>,
        FieldElement<Stark252PrimeField>,
    )>,
    use_288: bool,
) -> Vec<BigUint>
where
    FieldElement<F>: ByteConversion,
{
    let mut scalars_low = vec![];
    let mut scalars_high = vec![];
    for scalar in scalars {
        let [low, high] = scalar_to_limbs(scalar);
        scalars_low.push(BigUint::from(low));
        scalars_high.push(BigUint::from(high));
    }

    let (q_low, sum_dlog_div_low) = run_ecip::<F>(points, &scalars_low);
    let (q_high, sum_dlog_div_high) = run_ecip::<F>(points, &scalars_high);
    let (q_high_shifted, sum_dlog_div_high_shifted) =
        run_ecip::<F>(&[q_high.clone()], &[BigUint::from(1usize) << 128]);

    let mut transcript = hash_inputs_points_scalars_and_result_points(
        points,
        scalars,
        [&q_low, &q_high, &q_high_shifted],
        curve_id,
        risc0_mode,
        external_points_scalars_hash,
    );
    let sum_dlog_div_maybe_batched = match risc0_mode {
        true => &sum_dlog_div_low,
        false => {
            let c0 = felt252_to_element(&transcript.state[1]);
            let c1 = c0.clone().square();
            let c2 = c1.clone() * c0.clone();
            &(sum_dlog_div_low.scale_by_coeff(c0)
                + sum_dlog_div_high.scale_by_coeff(c1)
                + sum_dlog_div_high_shifted.scale_by_coeff(c2))
        }
    };
    let x = retrieve_random_x_coordinate(
        &mut transcript,
        sum_dlog_div_maybe_batched,
        scalars.len(),
        !risc0_mode,
    );
    let (point, roots) = derive_ec_point_from_x(&x);

    let mut call_data = vec![];
    let call_data_ref = &mut call_data;

    fn push<T>(call_data_ref: &mut Vec<BigUint>, value: T)
    where
        BigUint: From<T>,
    {
        call_data_ref.push(value.into());
    }

    fn push_digit(call_data_ref: &mut Vec<BigUint>, digit: i8) {
        let mut value = FieldElement::<Stark252PrimeField>::from(0);
        if digit >= 0 {
            value += FieldElement::<Stark252PrimeField>::from(digit as u64);
        } else {
            value = value - FieldElement::<Stark252PrimeField>::from(-digit as u64);
        }
        push(call_data_ref, element_to_biguint(&value));
    }

    fn push_element<F>(call_data_ref: &mut Vec<BigUint>, element: &FieldElement<F>, use_288: bool)
    where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        if use_288 {
            let limbs = field_element_to_u288_limbs(element);
            for limb in limbs {
                push(call_data_ref, limb);
            }
        } else {
            let limbs = field_element_to_u384_limbs(element);
            for limb in limbs {
                push(call_data_ref, limb);
            }
        }
    }

    if serialize_as_pure_felt252_array {
        // placeholder, actual length is updated at the end
        push(call_data_ref, 0usize);
    }

    // scalars_digits_decompositions
    if let Some(include_digits_decomposition) = include_digits_decomposition {
        let flag: usize = if include_digits_decomposition { 0 } else { 1 };
        push(call_data_ref, flag);
        if include_digits_decomposition {
            push(call_data_ref, scalars.len());
            for i in 0..scalars.len() {
                let limbs = [&scalars_low[i], &scalars_high[i]];
                for limb in limbs {
                    let digits = neg_3_base_le(limb);
                    push(call_data_ref, digits.len());
                    for digit in digits {
                        push_digit(call_data_ref, digit);
                    }
                    if risc0_mode {
                        break;
                    }
                }
            }
        }
    }

    // msm_hint
    {
        // Q_low, Q_high, Q_high_shifted
        let q_list = [&q_low, &q_high, &q_high_shifted];
        for q in q_list {
            push_element(call_data_ref, &q.x, false);
            push_element(call_data_ref, &q.y, false);
            if risc0_mode {
                break;
            }
        }

        let ff_4_polys = padd_function_felt(sum_dlog_div_maybe_batched, scalars.len(), !risc0_mode);
        for poly in ff_4_polys {
            push(call_data_ref, poly.len());
            for coeff in poly {
                push_element::<F>(call_data_ref, &coeff, use_288);
            }
        }
    }

    // derive_point_from_x_hint
    {
        // y_last_attempt
        {
            push_element::<F>(call_data_ref, &point.y, false);
        }

        // g_rhs_sqrt
        {
            push(call_data_ref, roots.len());
            for root in roots {
                push_element::<F>(call_data_ref, &root, false);
            }
        }
    }

    if include_points_and_scalars {
        // points
        {
            push(call_data_ref, points.len());
            for point in points {
                push_element(call_data_ref, &point.x, false);
                push_element(call_data_ref, &point.y, false);
            }
        }

        // scalars
        {
            push(call_data_ref, scalars.len());
            for i in 0..scalars.len() {
                push(call_data_ref, scalars_low[i].clone());
                if !risc0_mode {
                    push(call_data_ref, scalars_high[i].clone());
                }
            }
        }

        // curve id
        push(call_data_ref, curve_id);
    }

    if serialize_as_pure_felt252_array {
        // updates overall length
        call_data[0] = (call_data.len() - 1).into();
    }

    call_data
}

const INIT_HASH: &str = "0x4D534D5F4731"; // "MSM_G1" in hex
const INIT_HASH_U128: &str = "0x4D534D5F47315F55313238"; // "MSM_G1_U128" in hex

fn hash_inputs_points_scalars_and_result_points<F>(
    points: &[G1Point<F>],
    scalars: &[BigUint],
    q_list: [&G1Point<F>; 3],
    curve_id: usize,
    risc0_mode: bool,
    external_points_scalars_hash: Option<(
        FieldElement<Stark252PrimeField>,
        FieldElement<Stark252PrimeField>,
    )>,
) -> CairoPoseidonTranscript
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let init_hash = if risc0_mode {
        INIT_HASH_U128
    } else {
        INIT_HASH
    };
    let mut transcript = CairoPoseidonTranscript::new(FieldElement::from_hex_unchecked(init_hash));
    let transcript_ref = &mut transcript;
    // curve id, msm size
    transcript_ref.update_sponge_state(
        FieldElement::<Stark252PrimeField>::from(curve_id as u64),
        FieldElement::<Stark252PrimeField>::from(scalars.len() as u64),
    );

    if let Some((x, y)) = external_points_scalars_hash {
        transcript_ref.update_sponge_state(x, y);
    }
    // points
    if external_points_scalars_hash.is_none() {
        for point in points {
            transcript_ref.hash_emulated_field_element(&point.x);
            transcript_ref.hash_emulated_field_element(&point.y);
        }
    }

    // Q_low, Q_high, Q_high_shifted
    for q in q_list {
        transcript_ref.hash_emulated_field_element(&q.x);
        transcript_ref.hash_emulated_field_element(&q.y);
        if risc0_mode {
            break;
        }
    }

    // scalars
    if external_points_scalars_hash.is_none() {
        if risc0_mode {
            transcript_ref.hash_u128_multi(scalars);
        } else {
            transcript_ref.hash_u256_multi(scalars);
        }
    }

    transcript
}

fn retrieve_random_x_coordinate<F>(
    transcript: &mut CairoPoseidonTranscript,
    sum_dlog_div_maybe_batched: &FunctionFelt<F>,
    msm_size: usize,
    batched: bool,
) -> FieldElement<Stark252PrimeField>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    // SumDlogDivLow, SumDlogDivHigh, SumDlogDivHighShifted
    let parts = padd_function_felt(sum_dlog_div_maybe_batched, msm_size, batched);
    for coeffs in parts {
        transcript.hash_emulated_field_elements(&coeffs, Option::None);
    }

    transcript.state[0]
}

fn derive_ec_point_from_x<F>(
    x_252: &FieldElement<Stark252PrimeField>,
) -> (G1Point<F>, Vec<FieldElement<F>>)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let params = F::get_curve_params();
    let a = params.a;
    let b = params.b;
    let g = params.fp_generator;
    let rhs_compute = |x: &FieldElement<F>| x * x * x + &a * x + &b;

    let mut x_252 = *x_252;
    let mut rhs = rhs_compute(&felt252_to_element(&x_252));
    let mut g_rhs_roots = vec![];
    let mut attempt = 0;
    while rhs.legendre_symbol() != LegendreSymbol::One {
        let g_rhs = &rhs * &g;
        g_rhs_roots.push(sqrt(&g_rhs));
        let mut state = [x_252, FieldElement::from(attempt), FieldElement::from(2)];
        PoseidonCairoStark252::hades_permutation(&mut state);
        x_252 = state[0];
        rhs = rhs_compute(&felt252_to_element(&x_252));
        attempt += 1;
    }
    let y = sqrt(&rhs);
    (
        G1Point::new_unchecked(felt252_to_element(&x_252), y),
        g_rhs_roots,
    )
}

fn sqrt<F>(value: &FieldElement<F>) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let (root1, root2) = value.sqrt().expect("there is no root");
    if element_to_biguint(&root1) < element_to_biguint(&root2) {
        root1
    } else {
        root2
    }
}

#[cfg(test)]
mod tests {
    use num_traits::Num;

    use super::*;

    #[test]
    fn test_init_hashes() {
        {
            let key = "MSM_G1";
            let bytes = key.as_bytes();
            let hex_string = bytes
                .iter()
                .map(|byte| format!("{:02X}", byte))
                .collect::<String>();
            assert_eq!(String::from("0x") + &hex_string, INIT_HASH);
        }
        {
            let key = "MSM_G1_U128";
            let bytes = key.as_bytes();
            let hex_string = bytes
                .iter()
                .map(|byte| format!("{:02X}", byte))
                .collect::<String>();
            assert_eq!(String::from("0x") + &hex_string, INIT_HASH_U128);
        }
    }

    #[test]
    fn test_calldata_builder() {
        use std::time::Instant;
        let points = vec![G1Point::<BN254PrimeField>::generator(); 100];
        let scalars = [
            BigUint::from_str_radix(
                "a91a9d1d7ed6ae224a6403e0136b6e3c4f4e34e5e7d3c796e78ac0c9ed7c891",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "1409a9e336fed4698fca5001498df1e7d5ffa42053be09e091a9e631b151e6b3",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "16bd601a44e08e1c32598a61a3d25553a963d7a1c478f86ef96cf0f6a6677ec6",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "13c27ddaa097439633bf37e1b8f086a0c715c73bf3446132720b215da4124f4c",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "2c4428bcf4a38f6343a97db1236f1b3c9d5f7f2ea62265ffdd3f9a6e03fc6b6",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "a16dd490c2ae848acaa66d591ee541a15004a3d4e6a30e34796abfea2263d97",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "1a71e13011c21a61cec12278c71f1fb89ad2501d4a325b67025f8f5d9326dcc8",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "d80b00e3c9170232003942789f307cc1d0ae34e72e734e34c33a768498d1c99",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "26b759f9b556f832e6542778729466c24d9100e030ca54ec1deb58f38523ac26",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "e36e3926939e76ae25378cda726cf63cdddd0e408340dbfa9848128d2b63360",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "21a60d83ffd64fe1b1001f5c2394db28cba0d043d2c0396d96742d452cda2b9",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "326ca09ca5bf7036bf4c5eb1b38e0881af77c53d4d30cbb52726389427c71e1",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "69e1031ff116357d00e6c43f9df8dce2ca24de52fcd1ed6d041dbe1ccc44856",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "1292219ec8f0c2d9eee9f83aaddd882bd1fc3f64f4b52decae8ffd0889adeda1",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "3546e543e5b42288c2d8aef19b29d011d3ea1314e149b30657b0de3fa6fab30",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "1ed9af5b243ab299063c26eb6cc0a7af8ede1708d34330c07ec22eda0089dad6",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "cbf522d0c4d5deba5aae379792b93aa88494c5ce8693b54797a0f861dc9c91d",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "1931833de79187c55166feef4599c49f2709d4608a99439979f4d1536c3335f9",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "21c156647877e47131dac4ac1808aa9ad66f2918ffec2e0b39814ce027a98763",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "c4cacf3e41a7ea8dbe2bdbae9ae9f434aabc97b924e561e78863d4aaa55932f",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "2b80bb12c3c1570a16a51089c3084b91e63dcdaf1376b71668ab8215017d1acf",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "21c91e132aa7be3dfe0b39eb719e0ff20583ea5137cc4cc8dfe1797bfc3237ff",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "18621ceb3f5f9d551012dc57ea9c36d1a8863dd5ad5389c375a1fed219a0150",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "1b78fe41f7c350659e8f37c0fd453dd33b922ef300143164311a080e3864c4d2",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "2d35b9fd32ae6c9948b0489b3bf75a80429405c6810e156ba202837391409721",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "9fbd63ebca2df4eb5b27edd40f5015e14b4251430224abc7e7b810b2281912a",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "12a9a69749a0836678c7c0c28d28606de98b05d821c2f7bc6ac273030c339c17",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "141fec47bd26da09b875247f2ec09e0e5db9a753a7b4c0a7ede6726637001a11",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "46c9350a8775ce95f2c0e55490588334531326af1060a5385c016f040d13ec0",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "18385fab28a3397b68f36a419b619325749f5c46fdfdbb90509f61beab6124f4",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "6ba7f326e64ec5b34ce5996a92f15f0df5d90f0097b52ca9c1a1176f203d766",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "1f13c9823dd9185107ee32f97fb7b3bd90ee5b75c3b9a8b06e47a4ee55faedd2",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "7da4b7bc0300cee19bcbc1612c265002c5de5b90045b6fd704babef074cc003",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "1db798064ad9f8b3b33d69916236d7769dc9de701f761a801cba21971df870c2",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "f44d57c7d1a93c9f5b7a6e495366a020edc648ec196abf90d113f2a5cd24dca",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "cba523bc60b7e713f662a4ab6429862091f37d4f4aab9ed87a440d603911a86",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "6649961822c0c701f543f2f8f7d2c17e7c733dbc52237497fae65c71851a228",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "2a26fd0c06d5335cdc5c3e9e2bb212d6388a6276e8fcf2edba21aed7e389eeb2",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "56c7a6cc61caa751b4d5645095708e97005e87534bb0ac167ddf2d8b5c49b59",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "ac5d6c219e2b3259353041ee06046dd6b920e8177547e3bd9671f6106b56aae",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "7c2ddfd8cb04f703922bb8259fa8052dde34bbf993dc021861947a42d3d259e",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "2f497e0237356984094eb300d43ddf823e36b95b994989957601a932ffeb9f94",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "202726c63ffc6ecc78ea6d77b33ff3c54788aa61f93f3a5122e7c992c6d357b",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "166be9d9c233972212b0db786791cef44e94e52d3ec6fd06c47e0c3b1c94e6d",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "28ae7321559d1016e5c8b23232f430a95b41b0f8c601dc6df2bb183398de9a2e",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "434d0333913117eb517f0369f5dedd41a867db5cc0c5c6d407445a96c917c1b",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "2583cffdde3a0e999112407a02d6b68e1cc8a8d8e470cfb5eda9562a6fb885ef",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "2cc03b02108abc1ee58143e73142075e7a9cdeeb745f5b3fa0e9be03f0ac0c8e",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "7583723df153f931b4aae6f2fcbbfc3564a666921aac6a3c59296ec8d51b8f1",
                16,
            )
            .unwrap(),
            BigUint::from_str_radix(
                "e2b6c9803f26a2e9c3be76094c6f72188364f7ba2d9d3b8be577d1e99d08399",
                16,
            )
            .unwrap(),
        ];

        let scalars_doubled = scalars
            .iter()
            .cloned()
            .chain(scalars.iter().cloned())
            .collect::<Vec<_>>();

        let curve_id = 0;
        let start_time = Instant::now();
        let _ = calldata_builder(
            &points,
            &scalars_doubled,
            curve_id,
            None,
            false,
            false,
            false,
            None,
            false,
        );
        let end_time = Instant::now();
        println!("Time taken: {:?}", end_time.duration_since(start_time));
    }
}
