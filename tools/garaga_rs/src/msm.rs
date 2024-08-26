use crate::{
    ecip::{
        core::{neg_3_base_le, run_ecip},
        curve::CurveParamsProvider,
        g1point::G1Point,
        rational_function::FunctionFelt,
    },
    io::parse_field_elements_from_list,
    poseidon_transcript::CairoPoseidonTranscript,
};
use lambdaworks_math::{
    elliptic_curve::short_weierstrass::curves::{
        bls12_381::field_extension::BLS12381PrimeField, bn_254::field_extension::BN254PrimeField,
    },
    field::{
        element::FieldElement, fields::fft_friendly::stark_252_prime_field::Stark252PrimeField,
        traits::IsPrimeField,
    },
    traits::ByteConversion,
};
use num_bigint::{BigInt, BigUint};

const CURVE_BN254: usize = 0;
const CURVE_BLS12_381: usize = 1;

pub fn msm_calldata_builder(
    values: &[BigUint],
    scalars: &[BigUint],
    curve_id: usize,
) -> Vec<BigInt> {
    assert_eq!(values.len(), 2 * scalars.len());

    if curve_id == CURVE_BN254 {
        let values = parse_field_elements_from_list::<BN254PrimeField>(values).unwrap();
        let points = values
            .chunks(2)
            .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
            .collect::<Vec<G1Point<BN254PrimeField>>>();
        let n = &BigUint::from_bytes_be(&BN254PrimeField::get_curve_params().n.to_bytes_be());
        if !scalars.iter().all(|x| x < n) {
            panic!("Scalar value must be less than the curve order");
        }
        return calldata_builder(curve_id, &points, scalars, true, true, false);
    }

    if curve_id == CURVE_BLS12_381 {
        let values = parse_field_elements_from_list::<BLS12381PrimeField>(values).unwrap();
        let points = values
            .chunks(2)
            .map(|chunk| G1Point::new(chunk[0].clone(), chunk[1].clone()))
            .collect::<Vec<G1Point<BLS12381PrimeField>>>();
        let n = &BigUint::from_bytes_be(&BLS12381PrimeField::get_curve_params().n.to_bytes_be());
        if !scalars.iter().all(|x| x < n) {
            panic!("Scalar value must be less than the curve order");
        }
        return calldata_builder(curve_id, &points, scalars, true, true, false);
    }

    panic!("Curve ID {} not supported", curve_id);
}

pub fn calldata_builder<F: IsPrimeField + CurveParamsProvider<F>>(
    curve_id: usize,
    points: &[G1Point<F>],
    scalars: &[BigUint],
    include_digits_decomposition: bool,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
) -> Vec<BigInt> {
    let mut call_data = vec![];

    let one = &BigUint::from(1usize);

    // scalars_digits_decompositions
    // StructSpan.serialize_to_calldata(include_points_and_scalars)
    {
        call_data.push(BigInt::from(if include_digits_decomposition {
            0
        } else {
            1
        }));
        call_data.push(BigInt::from(scalars.len()));
        for scalar in scalars {
            let low = scalar & ((one << 128) - one);
            let high = scalar >> 128;
            let low_digits = neg_3_base_le(&low);
            let high_digits = neg_3_base_le(&high);
            call_data.push(BigInt::from(low_digits.len()));
            call_data.extend(
                low_digits
                    .iter()
                    .map(|x| BigInt::from(*x))
                    .collect::<Vec<BigInt>>(),
            );
            call_data.push(BigInt::from(high_digits.len()));
            call_data.extend(
                high_digits
                    .iter()
                    .map(|x| BigInt::from(*x))
                    .collect::<Vec<BigInt>>(),
            );
        }
    }

    let scalars_low = scalars
        .iter()
        .map(|scalar| scalar & ((one << 128) - one))
        .collect::<Vec<BigUint>>();
    let scalars_high = scalars
        .iter()
        .map(|scalar| scalar >> 128)
        .collect::<Vec<BigUint>>();
    let (q_low, sum_dlog_div_low) = run_ecip::<F>(points, &scalars_low);
    let (q_high, sum_dlog_div_high) = run_ecip::<F>(points, &scalars_high);
    let (q_high_shifted, sum_dlog_div_high_shifted) =
        run_ecip::<F>(&[q_high.clone()], &[one << 128]);

    // MSMHint
    // Struct.serialize_to_calldata()
    {
        let q_points = [q_low.clone(), q_high.clone(), q_high_shifted.clone()];
        for q_point in q_points {
            let x = convert::<F>(&q_point.x);
            let y = convert::<F>(&q_point.y);
            let limbs_x = bigint_split_4_96(&x);
            let limbs_y = bigint_split_4_96(&y);
            call_data.extend(
                limbs_x
                    .iter()
                    .map(|x| BigInt::from(x.clone()))
                    .collect::<Vec<BigInt>>(),
            );
            call_data.extend(
                limbs_y
                    .iter()
                    .map(|x| BigInt::from(x.clone()))
                    .collect::<Vec<BigInt>>(),
            );
        }
        // TODO
    }

    // DerivePointFromXHint
    // Struct.serialize_to_calldata()
    {
        let random_x_coordinate = retrieve_random_x_coordinate(
            curve_id,
            points,
            scalars,
            &q_low,
            &q_high,
            &q_high_shifted,
            &sum_dlog_div_low,
            &sum_dlog_div_high,
            &sum_dlog_div_high_shifted,
        );
        let (_x, y, roots) = derive_ec_point_from_x(&random_x_coordinate, curve_id);
        {
            let y = convert(&y);
            let limbs_y = bigint_split_4_96(&y);
            call_data.extend(
                limbs_y
                    .iter()
                    .map(|x| BigInt::from(x.clone()))
                    .collect::<Vec<BigInt>>(),
            );
        }
        call_data.push(BigInt::from(roots.len()));
        for root in roots {
            let root = convert(&root);
            let limbs_root = bigint_split_4_96(&root);
            call_data.extend(
                limbs_root
                    .iter()
                    .map(|x| BigInt::from(x.clone()))
                    .collect::<Vec<BigInt>>(),
            );
        }
    }

    if include_points_and_scalars {
        // points
        // StructSpan.serialize_to_calldata()
        {
            call_data.push(BigInt::from(points.len()));
            for point in points {
                let x = convert(&point.x);
                let y = convert(&point.y);
                let limbs_x = bigint_split_4_96(&x);
                let limbs_y = bigint_split_4_96(&y);
                call_data.extend(
                    limbs_x
                        .iter()
                        .map(|x| BigInt::from(x.clone()))
                        .collect::<Vec<BigInt>>(),
                );
                call_data.extend(
                    limbs_y
                        .iter()
                        .map(|x| BigInt::from(x.clone()))
                        .collect::<Vec<BigInt>>(),
                );
            }
        }

        // scalars
        // StructSpan.serialize_to_calldata()
        {
            call_data.push(BigInt::from(scalars.len()));
            for scalar in scalars {
                let low = scalar & ((one << 128) - one);
                let high = scalar >> 128;
                call_data.push(BigInt::from(low));
                call_data.push(BigInt::from(high));
            }
        }

        call_data.push(BigInt::from(curve_id));
    }
    if serialize_as_pure_felt252_array {
        call_data.insert(0, BigInt::from(call_data.len()));
    }
    call_data
}

const INIT_HASH: &str = "0x4D534D5F4731"; // "MSM_G1" in hex

fn retrieve_random_x_coordinate<F: IsPrimeField>(
    curve_id: usize,
    points: &[G1Point<F>],
    scalars: &[BigUint],
    q_low: &G1Point<F>,
    q_high: &G1Point<F>,
    q_high_shifted: &G1Point<F>,
    sum_dlog_div_low: &FunctionFelt<F>,
    sum_dlog_div_high: &FunctionFelt<F>,
    sum_dlog_div_high_shifted: &FunctionFelt<F>,
) -> FieldElement<Stark252PrimeField> {
    let msm_size = scalars.len();
    let mut transcript = CairoPoseidonTranscript::new(FieldElement::from_hex_unchecked(INIT_HASH));
    transcript.update_sponge_state(
        FieldElement::from(curve_id as u64),
        FieldElement::from(msm_size as u64),
    );
    for _sum_dlog_div in [sum_dlog_div_low, sum_dlog_div_high] {
        // TODO
        /*
                _a_num, _a_den, _b_num, _b_den = io.padd_function_felt(
                    SumDlogDiv, self.msm_size, py_felt=True
                )
                transcript.hash_limbs_multi(_a_num)
                transcript.hash_limbs_multi(_a_den)
                transcript.hash_limbs_multi(_b_num)
                transcript.hash_limbs_multi(_b_den)
        */
    }
    for _sum_dlog_div in [sum_dlog_div_high_shifted] {
        // TODO
        /*
                _a_num, _a_den, _b_num, _b_den = io.padd_function_felt(
                    SumDlogDiv, 1, py_felt=True
                )
                transcript.hash_limbs_multi(_a_num)
                transcript.hash_limbs_multi(_a_den)
                transcript.hash_limbs_multi(_b_num)
                transcript.hash_limbs_multi(_b_den)
        */
    }
    for point in points {
        transcript.hash_element(&convert(&point.x));
        transcript.hash_element(&convert(&point.y));
    }
    for q_point in [q_low, q_high, q_high_shifted] {
        transcript.hash_element(&convert(&q_point.x));
        transcript.hash_element(&convert(&q_point.y));
    }
    for scalar in scalars {
        transcript.hash_u256(scalar);
    }
    transcript.state[0]
}

fn derive_ec_point_from_x<F: IsPrimeField>(
    _x: &FieldElement<F>,
    _curve_id: usize,
) -> (FieldElement<F>, FieldElement<F>, Vec<FieldElement<F>>) {
    // TODO
    unimplemented!();
}

fn convert<F: IsPrimeField>(x: &FieldElement<F>) -> BigUint {
    // TODO improve this to use BigUint::from_bytes_be(x.to_bytes_be())
    let mut s = x.representative().to_string();
    if let Some(stripped) = s.strip_prefix("0x") {
        s = stripped.to_string();
    }
    BigUint::parse_bytes(s.as_bytes(), 16).unwrap()
}

fn bigint_split_4_96(x: &BigUint) -> [BigUint; 4] {
    let one = &BigUint::from(1usize);
    assert!(x < &(one << 384));
    let base = one << 96;
    let mask = &(base - one);
    [x & mask, (x >> 96) & mask, (x >> 192) & mask, x >> 288]
}

#[cfg(test)]
mod tests {
    use super::{msm_calldata_builder, CURVE_BN254, INIT_HASH};
    use num_bigint::{BigInt, BigUint};

    #[test]
    fn test_init_hash() {
        let key = "MSM_G1";
        let bytes = key.as_bytes();
        let hex_string: String = bytes.iter().map(|byte| format!("{:02X}", byte)).collect();
        assert_eq!(String::from("0x") + &hex_string, INIT_HASH);
    }

    #[test]
    fn test_msm() {
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
            "-1",
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
            "-1",
            "-1",
            "0",
            "0",
            "0",
            "0",
            "-1",
            "0",
            "0",
            "1",
            "0",
            "1",
            "-1",
            "-1",
            "0",
            "1",
            "0",
            "-1",
            "0",
            "-1",
            "0",
            "1",
            "1",
            "0",
            "1",
            "1",
            "0",
            "1",
            "-1",
            "0",
            "1",
            "-1",
            "1",
            "1",
            "1",
            "0",
            "0",
            "0",
            "1",
            "0",
            "-1",
            "0",
            "1",
            "-1",
            "1",
            "-1",
            "0",
            "-1",
            "-1",
            "-1",
            "0",
            "-1",
            "-1",
            "0",
            "-1",
            "0",
            "1",
            "-1",
            "1",
            "-1",
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
            "-1",
            "-1",
            "-1",
            "0",
            "1",
            "0",
            "-1",
            "-1",
            "-1",
            "-1",
            "-1",
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
            "-1",
            "1",
            "1",
            "1",
            "-1",
            "1",
            "0",
            "-1",
            "0",
            "1",
            "-1",
            "1",
            "0",
            "1",
            "0",
            "1",
            "-1",
            "-1",
            "-1",
            "0",
            "-1",
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
            "-1",
            "-1",
            "-1",
            "0",
            "-1",
            "1",
            "-1",
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
            .map(|s| BigInt::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigInt>>();
        let result = msm_calldata_builder(&values, &scalars, CURVE_BN254);
        assert_eq!(result, expected);
    }
}
