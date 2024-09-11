use crate::algebra::{g1point::G1Point, rational_function::FunctionFelt};
use crate::definitions::{
    BLS12381PrimeField, BN254PrimeField, CurveParamsProvider, FieldElement, SECP256K1PrimeField,
    SECP256R1PrimeField, Stark252PrimeField, X25519PrimeField,
};
use crate::{
    ecip::core::{neg_3_base_le, run_ecip},
    io::{
        element_to_biguint, felt252_to_element, field_element_to_u384_limbs,
        field_elements_from_big_uints, padd_function_felt,
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
    include_digits_decomposition: bool,
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
    }
}

fn handle_curve<F>(
    values: &[BigUint],
    scalars: &[BigUint],
    curve_id: usize,
    include_digits_decomposition: bool,
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
        &element_to_biguint(&F::get_curve_params().n)
    };
    if !scalars.iter().all(|x| x < limit) {
        if risc0_mode {
            return Err("Scalar value must be less than 2**128".to_string());
        } else {
            return Err("Scalar value must be less than the curve order".to_string());
        }
    }
    Ok(calldata_builder(
        &points,
        scalars,
        curve_id,
        include_digits_decomposition,
        include_points_and_scalars,
        serialize_as_pure_felt252_array,
        risc0_mode,
    ))
}

pub fn calldata_builder<F: IsPrimeField + CurveParamsProvider<F>>(
    points: &[G1Point<F>],
    scalars: &[BigUint],
    curve_id: usize,
    include_digits_decomposition: bool,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
    risc0_mode: bool,
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

    let x = retrieve_random_x_coordinate(
        points,
        scalars,
        curve_id,
        risc0_mode,
        [&q_low, &q_high, &q_high_shifted],
        [
            (&sum_dlog_div_low, scalars.len()),
            (&sum_dlog_div_high, scalars.len()),
            (&sum_dlog_div_high_shifted, 1),
        ],
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

    fn push_element<F>(call_data_ref: &mut Vec<BigUint>, element: &FieldElement<F>)
    where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        let limbs = field_element_to_u384_limbs(element);
        for limb in limbs {
            push(call_data_ref, limb);
        }
    }

    if serialize_as_pure_felt252_array {
        // placeholder, actual length is updated at the end
        push(call_data_ref, 0usize);
    }

    // scalars_digits_decompositions
    {
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
            push_element(call_data_ref, &q.x);
            push_element(call_data_ref, &q.y);
            if risc0_mode {
                break;
            }
        }

        // SumDlogDivLow, SumDlogDivHigh, SumDlogDivHighShifted
        let f_n_list = [
            (&sum_dlog_div_low, scalars.len()),
            (&sum_dlog_div_high, scalars.len()),
            (&sum_dlog_div_high_shifted, 1),
        ];
        for (f, n) in f_n_list {
            let parts = padd_function_felt(f, n);
            for coeffs in parts {
                push(call_data_ref, coeffs.len());
                for coeff in coeffs {
                    push_element(call_data_ref, &coeff);
                }
            }
            if risc0_mode {
                break;
            }
        }
    }

    // derive_point_from_x_hint
    {
        // y_last_attempt
        {
            push_element(call_data_ref, &point.y);
        }

        // g_rhs_sqrt
        {
            push(call_data_ref, roots.len());
            for root in roots {
                push_element(call_data_ref, &root);
            }
        }
    }

    if include_points_and_scalars {
        // points
        {
            push(call_data_ref, points.len());
            for point in points {
                push_element(call_data_ref, &point.x);
                push_element(call_data_ref, &point.y);
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

fn retrieve_random_x_coordinate<F>(
    points: &[G1Point<F>],
    scalars: &[BigUint],
    curve_id: usize,
    risc0_mode: bool,
    q_list: [&G1Point<F>; 3],
    f_n_list: [(&FunctionFelt<F>, usize); 3],
) -> FieldElement<Stark252PrimeField>
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

    // SumDlogDivLow, SumDlogDivHigh, SumDlogDivHighShifted
    for (f, msm_size) in f_n_list {
        let parts = padd_function_felt(f, msm_size);
        for coeffs in parts {
            transcript_ref.hash_emulated_field_elements(&coeffs, Option::None);
        }
        if risc0_mode {
            break;
        }
    }

    // points
    for point in points {
        transcript_ref.hash_emulated_field_element(&point.x);
        transcript_ref.hash_emulated_field_element(&point.y);
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
    if risc0_mode {
        transcript_ref.hash_u128_multi(scalars);
    } else {
        transcript_ref.hash_u256_multi(scalars);
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
    use super::*;
    use num_bigint::BigUint;

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
    fn test_msm_1p_bn254() {
        let values = vec![
            "17752150426707023160896145033289182224151429257237962872500708232035549528353",
            "5624652954399631991820579009793795026629257929959730223927648120625404966111",
        ];
        let values = values
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let scalars =
            vec!["5488185871528857373452098697086130411467123274305500681494416103833528174182"];
        let scalars = scalars
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let expected = vec![
            "0",
            "1",
            "81",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "1",
            "1",
            "1",
            "1",
            "0",
            "0",
            "0",
            "0",
            "1",
            "0",
            "0",
            "1",
            "1",
            "0",
            "0",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "0",
            "0",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "0",
            "1",
            "0",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "1",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "1",
            "1",
            "0",
            "1",
            "1",
            "0",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "1",
            "1",
            "1",
            "0",
            "0",
            "0",
            "1",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "1",
            "1",
            "79",
            "0",
            "1",
            "0",
            "1",
            "1",
            "0",
            "0",
            "1",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "1",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "1",
            "1",
            "1",
            "1",
            "1",
            "1",
            "0",
            "0",
            "1",
            "1",
            "1",
            "0",
            "1",
            "1",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "1",
            "1",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "1",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "1",
            "0",
            "1",
            "0",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "1",
            "1",
            "0",
            "1",
            "1",
            "0",
            "0",
            "1",
            "0",
            "1",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "1",
            "3618502788666131213697322783095070105623107215331596699973092056135872020480",
            "0",
            "0",
            "0",
            "1",
            "55545317686235191091318856526",
            "127545108061084845680916344",
            "1343630505121918906",
            "0",
            "58050240331269443361250959434",
            "52910855361298413822456220787",
            "2417811551116210091",
            "0",
            "4386421157602274996729133530",
            "48367467627753054536872356728",
            "2735083941318314895",
            "0",
            "44762336008600836782008429893",
            "22470996594338772969431406981",
            "2372597256385359735",
            "0",
            "54174604611295383482133277186",
            "55514818401533322906052683758",
            "1655343276015202350",
            "0",
            "62408157425676898832190573451",
            "70584154254754317379417117405",
            "1273663894312586395",
            "0",
            "2",
            "63766186954932314969162183645",
            "22705331698219268428581026854",
            "2058932832584071925",
            "0",
            "56709934103430165929014714024",
            "68135223798443788528308290835",
            "1743499133401485332",
            "0",
            "3",
            "46557668692489516877701804648",
            "19255999001899034543770310456",
            "375472148113123502",
            "0",
            "43444440254537250118042721823",
            "29263258957437461966260267120",
            "2802285303484675454",
            "0",
            "1",
            "0",
            "0",
            "0",
            "3",
            "16160736822092523854063503744",
            "32931063787871913997716805887",
            "871243612966920606",
            "0",
            "41817908413497252192812953238",
            "74336255094411178490492782010",
            "2223507181083018580",
            "0",
            "8477759942019686544266405686",
            "14271698841254107733802497840",
            "2779727535500518809",
            "0",
            "6",
            "60444843563204213039561463608",
            "57767997005697103631310931369",
            "1126416444339370506",
            "0",
            "65685308438832928000570908623",
            "52933369221330244568565212206",
            "1432859376848085031",
            "0",
            "3",
            "0",
            "0",
            "0",
            "46557668692489516877701804648",
            "19255999001899034543770310456",
            "375472148113123502",
            "0",
            "43444440254537250118042721823",
            "29263258957437461966260267120",
            "2802285303484675454",
            "0",
            "1",
            "0",
            "0",
            "0",
            "2",
            "16575400227436988376218826742",
            "34665240465940749909297415657",
            "387660307362535378",
            "0",
            "60775790491462369405533287485",
            "68135223798443788527816512161",
            "1743499133401485332",
            "0",
            "3",
            "48079939579734708787499955289",
            "69205609434058286184290922681",
            "2071256972889883744",
            "0",
            "15375174268905828619088494483",
            "60251498952009829868612777073",
            "1410831867288279464",
            "0",
            "1",
            "0",
            "0",
            "0",
            "3",
            "54506116140109294418161872003",
            "63582820648449356556640852342",
            "2792040469979738282",
            "0",
            "39453626981933823118567798792",
            "43873271731120371117890972024",
            "1510139911507757242",
            "0",
            "51267722214622535087676445281",
            "48260591775451849888466082047",
            "1441506848959514676",
            "0",
            "6",
            "32687650062550377592177287108",
            "71346380705287281497449047963",
            "2726772651866680568",
            "0",
            "13801516644328074680486855026",
            "44484049259141912550414611138",
            "745497335061867728",
            "0",
            "3",
            "0",
            "0",
            "0",
            "48079939579734708787499955289",
            "69205609434058286184290922681",
            "2071256972889883744",
            "0",
            "15375174268905828619088494483",
            "60251498952009829868612777073",
            "1410831867288279464",
            "0",
            "1",
            "0",
            "0",
            "0",
            "2",
            "28218073663745214356881332831",
            "24839784910530090619443756822",
            "868962960421267859",
            "0",
            "43247575710167986853886076169",
            "68135223798443788525497744092",
            "1743499133401485332",
            "0",
            "3",
            "38799906529841710969635143971",
            "7904731285732535980700613101",
            "1844103407952427850",
            "0",
            "6086986555881163874694846130",
            "10202284135960101480834499004",
            "2583569316272424085",
            "0",
            "1",
            "0",
            "0",
            "0",
            "3",
            "29662638243352958806310504450",
            "9808206542174162505060727109",
            "785746497619692964",
            "0",
            "55120265752532127650776989821",
            "59836836337796716913053859416",
            "1800450914250594101",
            "0",
            "7248175160897973186246200008",
            "37193735822825061875385016474",
            "2736897321272475420",
            "0",
            "6",
            "4847550912871384138582853154",
            "45900071288838706073766019895",
            "2045311957054312884",
            "0",
            "32841109857129006864071231880",
            "74978607271162500705831858193",
            "776711415211330923",
            "0",
            "3",
            "0",
            "0",
            "0",
            "38799906529841710969635143971",
            "7904731285732535980700613101",
            "1844103407952427850",
            "0",
            "6086986555881163874694846130",
            "10202284135960101480834499004",
            "2583569316272424085",
            "0",
            "1",
            "0",
            "0",
            "0",
            "12901105342242691731001547399",
            "47589069440988811011434198962",
            "513687518442945155",
            "0",
            "3",
            "35126167625510687633039409067",
            "72109938629211885509861516725",
            "924366439034055155",
            "0",
            "12037300279107951797048639301",
            "2251139965229358461839194094",
            "1377237181661091165",
            "0",
            "71565083873266010161214639123",
            "31296437441104678384530239059",
            "998939318555314304",
            "0",
            "1",
            "44886416898270718737739628833",
            "5465603585483594518274405689",
            "2828080724999346971",
            "0",
            "31495664379410490933391258847",
            "70145709189263518448437858912",
            "896058912458130367",
            "0",
            "1",
            "106625320074685558741560858198442247782",
            "16128328720612160970043686497646299400",
            "0",
        ];
        let expected = expected
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let result = msm_calldata_builder(
            &values,
            &scalars,
            CurveID::BN254 as usize,
            true,
            true,
            false,
            false,
        )
        .unwrap();
        assert_eq!(result, expected);
    }

    #[test]
    fn test_msm_1p_bn254_risc0_mode() {
        let values = vec!["1", "2"];
        let values = values
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let scalars = vec!["10"];
        let scalars = scalars
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let expected = [
            "91",
            "0",
            "1",
            "3",
            "1",
            "0",
            "1",
            "75759116906411131289250842036",
            "1443316740970346987535705368",
            "708088064087366360",
            "0",
            "31894839170900604627010243180",
            "26562388390640533846098233871",
            "1678682860455561629",
            "0",
            "2",
            "26217156025717979489861508966",
            "38732762661950955458369152605",
            "1690057079767624198",
            "0",
            "55776084338326874385161289385",
            "68135223798443788527711860040",
            "1743499133401485332",
            "0",
            "3",
            "75759116906411131289250842036",
            "1443316740970346987535705368",
            "708088064087366360",
            "0",
            "35793051770242617481071736722",
            "55598968341652892474344064376",
            "2778910202715604305",
            "0",
            "1",
            "0",
            "0",
            "0",
            "3",
            "19631865022986903110643570472",
            "75611758646426461743237732951",
            "853236432195926662",
            "0",
            "11812074862058673201969127714",
            "39063420668175062792989597255",
            "1051876075291068046",
            "0",
            "20990372166390382667110319757",
            "42018508523564723974054925340",
            "1475001652048253687",
            "0",
            "6",
            "68821025690704718680664625436",
            "4329950222911040962607116106",
            "2124264192262099080",
            "0",
            "42731142985949030089657953320",
            "52712334859712198499272653638",
            "1362734074540871585",
            "0",
            "3",
            "0",
            "0",
            "0",
            "75759116906411131289250842036",
            "1443316740970346987535705368",
            "708088064087366360",
            "0",
            "35793051770242617481071736722",
            "55598968341652892474344064376",
            "2778910202715604305",
            "0",
            "1",
            "0",
            "0",
            "0",
            "55393786136547617102399599652",
            "54108526909404909864370672884",
            "1166018927207804617",
            "0",
            "0",
            "1",
            "1",
            "0",
            "0",
            "0",
            "2",
            "0",
            "0",
            "0",
            "1",
            "10",
            "0",
        ];
        let expected = expected
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let result = msm_calldata_builder(
            &values,
            &scalars,
            CurveID::BN254 as usize,
            true,
            true,
            true,
            true,
        )
        .unwrap();
        assert_eq!(result, expected);
    }
}
