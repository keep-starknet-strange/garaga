use crate::algebra::g1g2pair::G1G2Pair;
use crate::algebra::polynomial::Polynomial;
use crate::definitions::{BLS12381PrimeField, BN254PrimeField, CurveID, CurveParamsProvider};
use crate::io::{
    element_from_bytes_be, field_element_to_u288_limbs, field_element_to_u384_limbs,
    field_elements_from_big_uints, parse_g1_g2_pairs_from_flattened_field_elements_list,
};
use crate::multi_miller_loop::miller_loop;
use crate::multi_pairing_check::{get_max_q_degree, multi_pairing_check};
use crate::poseidon_transcript::CairoPoseidonTranscript;
use lambdaworks_math::field::element::FieldElement;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::BigUint;

fn extra_miller_loop_result<F>(curve_id: usize, public_pair: &G1G2Pair<F>) -> [FieldElement<F>; 12]
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let p = [public_pair.g1.x.clone(), public_pair.g1.y.clone()];
    let q = (public_pair.g2.x.clone(), public_pair.g2.y.clone());
    return miller_loop(curve_id, &[p], &[q]);
}

fn multi_pairing_check_result<F>(
    curve_id: usize,
    pairs: &[G1G2Pair<F>],
    n_fixed_g2: usize,
    public_pair: &Option<G1G2Pair<F>>,
    m: &Option<[FieldElement<F>; 12]>,
) -> (
    Option<[FieldElement<F>; 12]>,
    [FieldElement<F>; 12],
    Vec<FieldElement<F>>,
    Vec<Polynomial<F>>,
    Vec<Vec<FieldElement<F>>>,
)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    assert!(pairs.len() >= 2);
    let mut p = vec![];
    let mut q = vec![];
    for pair in pairs {
        let pi = [pair.g1.x.clone(), pair.g1.y.clone()];
        let qi = (pair.g2.x.clone(), pair.g2.y.clone());
        p.push(pi);
        q.push(qi);
    }
    let (lambda_root, lambda_root_inverse, scaling_factor, qis, ris) =
        multi_pairing_check(curve_id, &p, &q, n_fixed_g2, m);
    let ris = if curve_id == 1 {
        ris
    } else {
        ris[1..].to_vec()
    };
    let ris = if let None = public_pair {
        ris
    } else {
        ris[..ris.len() - 1].to_vec()
    };
    return (lambda_root, lambda_root_inverse, scaling_factor, qis, ris);
}

fn hash_hints_and_get_base_random_rlc_coeff<F>(
    curve_id: usize,
    pairs: &[G1G2Pair<F>],
    n_fixed_g2: usize,
    lambda_root: &Option<[FieldElement<F>; 12]>,
    lambda_root_inverse: &[FieldElement<F>; 12],
    scaling_factor: &[FieldElement<F>],
    ris: &[Vec<FieldElement<F>>],
) -> FieldElement<F>
where
    F: IsPrimeField,
    FieldElement<F>: ByteConversion,
{
    let curve_name = if curve_id == 0 { "BN254" } else { "BLS12_381" };
    let init_hash_text = format!("MPCHECK_{}_{}P_{}F", curve_name, pairs.len(), n_fixed_g2);
    let init_hash_hex = "0x".to_owned()
        + &init_hash_text
            .as_bytes()
            .iter()
            .map(|byte| format!("{:02X}", byte))
            .collect::<String>();
    let init_hash = FieldElement::from_hex(&init_hash_hex).unwrap();
    let mut transcript = CairoPoseidonTranscript::new(init_hash);
    for pair in pairs {
        transcript.hash_emulated_field_element(&pair.g1.x);
        transcript.hash_emulated_field_element(&pair.g1.y);
        transcript.hash_emulated_field_elements(&pair.g2.x, None);
        transcript.hash_emulated_field_elements(&pair.g2.y, None);
    }
    if let Some(lambda_root) = lambda_root {
        assert_eq!(curve_id, 0);
        transcript.hash_emulated_field_elements(lambda_root, None);
    }
    transcript.hash_emulated_field_elements(lambda_root_inverse, None);
    transcript.hash_emulated_field_elements(scaling_factor, None);
    for ri in ris {
        assert_eq!(ri.len(), 12);
        transcript.hash_emulated_field_elements(ri, None);
    }
    return element_from_bytes_be(&transcript.state[1].to_bytes_be());
}

fn compute_big_q_coeffs<F: IsPrimeField>(
    curve_id: usize,
    n_pairs: usize,
    qis: &[Polynomial<F>],
    ris: &[Vec<FieldElement<F>>],
    c0: &FieldElement<F>,
) -> Vec<FieldElement<F>> {
    let n_relations_with_ci = ris.len() + (if curve_id == 0 { 1 } else { 0 });
    let (mut ci, mut big_q) = (c0.clone(), Polynomial::<F>::zero());
    for i in 0..n_relations_with_ci {
        big_q = big_q + (&qis[i] * &Polynomial::new(vec![ci.clone()]));
        ci *= ci.clone();
    }
    let big_q_expected_len = get_max_q_degree(curve_id, n_pairs) + 1;
    let mut big_q_coeffs = big_q.coefficients;
    while big_q_coeffs.len() < big_q_expected_len {
        big_q_coeffs.push(FieldElement::from(0));
    }
    return big_q_coeffs;
}

fn build_mpcheck_hint<F>(
    curve_id: usize,
    pairs: &[G1G2Pair<F>],
    n_fixed_g2: usize,
    public_pair: &Option<G1G2Pair<F>>,
) -> (
    Option<[FieldElement<F>; 12]>,
    [FieldElement<F>; 12],
    Vec<FieldElement<F>>,
    Vec<Vec<FieldElement<F>>>,
    Vec<FieldElement<F>>,
    Option<Vec<FieldElement<F>>>,
)
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let n_pairs = pairs.len();
    assert!(n_pairs >= 2);
    assert!(n_fixed_g2 <= n_pairs);

    let m = if let Some(public_pair) = public_pair {
        Some(extra_miller_loop_result(curve_id, public_pair))
    } else {
        None
    };
    let (lambda_root, lambda_root_inverse, scaling_factor, qis, ris) =
        multi_pairing_check_result(curve_id, pairs, n_fixed_g2, public_pair, &m);
    let c0 = hash_hints_and_get_base_random_rlc_coeff(
        curve_id,
        pairs,
        n_fixed_g2,
        &lambda_root,
        &lambda_root_inverse,
        &scaling_factor,
        &ris,
    );
    let big_q_coeffs = compute_big_q_coeffs(curve_id, n_pairs, &qis, &ris, &c0);

    let small_q = if let None = public_pair {
        None
    } else {
        let mut coeffs = qis[qis.len() - 1].coefficients.clone();
        while coeffs.len() < 11 {
            coeffs.push(FieldElement::from(0));
        }
        Some(coeffs)
    };

    return (
        lambda_root,
        lambda_root_inverse,
        scaling_factor,
        ris,
        big_q_coeffs,
        small_q,
    );
}

fn calldata_builder<const B288: bool, F>(
    curve_id: usize,
    pairs: &[G1G2Pair<F>],
    n_fixed_g2: usize,
    public_pair: &Option<G1G2Pair<F>>,
) -> Vec<BigUint>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let (lambda_root, lambda_root_inverse, scaling_factor, ris, big_q_coeffs, small_q) =
        build_mpcheck_hint(curve_id, pairs, n_fixed_g2, public_pair);

    let mut call_data = vec![];
    let call_data_ref = &mut call_data;

    fn push<T>(call_data_ref: &mut Vec<BigUint>, value: T)
    where
        BigUint: From<T>,
    {
        call_data_ref.push(value.into());
    }

    fn push_element<const B288: bool, F>(
        call_data_ref: &mut Vec<BigUint>,
        element: &FieldElement<F>,
    ) where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        if B288 {
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

    fn push_elements<const B288: bool, F>(
        call_data_ref: &mut Vec<BigUint>,
        elements: &[FieldElement<F>],
        prepend_length: bool,
    ) where
        F: IsPrimeField,
        FieldElement<F>: ByteConversion,
    {
        if prepend_length {
            push(call_data_ref, elements.len());
        }
        for element in elements {
            push_element::<B288, F>(call_data_ref, element);
        }
    }

    if let Some(lambda_root) = lambda_root {
        push_elements::<B288, F>(call_data_ref, &lambda_root, false);
    }
    push_elements::<B288, F>(call_data_ref, &lambda_root_inverse, false);
    push_elements::<B288, F>(call_data_ref, &scaling_factor, false);
    push(call_data_ref, ris.len());
    for ri in ris {
        push_elements::<B288, F>(call_data_ref, &ri, false);
    }
    push_elements::<B288, F>(call_data_ref, &big_q_coeffs, true);
    if let Some(small_q) = small_q {
        push_elements::<B288, F>(call_data_ref, &small_q, false);
    }

    call_data
}

pub fn mpc_calldata_builder(
    curve_id: usize,
    values1: &[BigUint],
    n_fixed_g2: usize,
    values2: &[BigUint],
) -> Result<Vec<BigUint>, String> {
    if !(values1.len() % 6 == 0 && values1.len() >= 12) {
        return Err("Pairs values length must be a multiple of 6, at least 12".to_string());
    }
    if !(values2.len() == 0 || values2.len() == 6) {
        return Err("Public pair values length must be 0 or 6".to_string());
    }
    if !(n_fixed_g2 <= values1.len() / 6) {
        return Err("Fixed G2 count must be less than or equal to pairs count".to_string());
    }
    let curve_id = CurveID::try_from(curve_id)?;
    match curve_id {
        CurveID::BN254 => {
            handle_curve::<true, BN254PrimeField>(curve_id as usize, values1, n_fixed_g2, values2)
        }
        CurveID::BLS12_381 => handle_curve::<false, BLS12381PrimeField>(
            curve_id as usize,
            values1,
            n_fixed_g2,
            values2,
        ),
        _ => Err("Unsupported curve".to_string()),
    }
}

fn handle_curve<const B288: bool, F>(
    curve_id: usize,
    values1: &[BigUint],
    n_fixed_g2: usize,
    values2: &[BigUint],
) -> Result<Vec<BigUint>, String>
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    let elements = field_elements_from_big_uints::<F>(values1);
    let pairs = parse_g1_g2_pairs_from_flattened_field_elements_list(&elements)?;
    let public_pair = if values2.len() == 6 {
        let elements = field_elements_from_big_uints::<F>(values2);
        let pairs = parse_g1_g2_pairs_from_flattened_field_elements_list(&elements)?;
        Some(pairs[0].clone())
    } else {
        None
    };
    Ok(calldata_builder::<B288, F>(
        curve_id,
        &pairs,
        n_fixed_g2,
        &public_pair,
    ))
}

#[cfg(test)]
mod tests {
    use super::*;
    use num_bigint::BigUint;

    #[test]
    fn test_mpc_calldata_1() {
        let pairs = vec![
            "13128039158878578405311101440433196197030750671434609739599152813953777597656",
            "16631698573870232878372968498141532512853508045651172429828485171181737347448",
            "10857046999023057135944570762232829481370756359578518086990519993285655852781",
            "11559732032986387107991004021392285783925812861821192530917403151452391805634",
            "8495653923123431417604973247489272438418190587263600148770280649306958101930",
            "4082367875863433681332203403145435568316851327593401208105741076214120093531",
            "16972146358605338978832925186803183426611046226825606566434356706141393838202",
            "13196854042874744296847103784920665732531458138601311807468784567343458201148",
            "8630460879186894947848746851564051176975823064935525955379247650715829661361",
            "9389668753221064628742664410943220866829007376428958982009035349098161661555",
            "101507912060041238383964462637314541762953824224282578232200414402984982761",
            "11031616073657490505344868059178485237553945591986939457256393364699871632182",
        ];
        let pairs = pairs
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let public_pair: Vec<String> = vec![];
        let public_pair = public_pair
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let result =
            mpc_calldata_builder(CurveID::BN254 as usize, &pairs, 2, &public_pair).unwrap();
        assert_eq!(result.len(), 2225);
    }

    #[test]
    fn test_mpc_calldata_2() {
        let pairs = vec![
            "3249498908318273722312450266561342384744351408145152472888574144128159241614",
            "18326965304442076244056364783642758184171133965386785868619945604645667798645",
            "6810322487272704684756846727684393468621070322625759305702914229660436807870",
            "659340959365535995846878029322462398780992604972635422373414064580963856167",
            "4753110947822659997230336129016503773479834620252828350963402604279211100876",
            "513277914363735126912695057642473103134316971932897950349518725870890255169",
            "3249498908318273722312450266561342384744351408145152472888574144128159241614",
            "18326965304442076244056364783642758184171133965386785868619945604645667798645",
            "6810322487272704684756846727684393468621070322625759305702914229660436807870",
            "659340959365535995846878029322462398780992604972635422373414064580963856167",
            "4753110947822659997230336129016503773479834620252828350963402604279211100876",
            "513277914363735126912695057642473103134316971932897950349518725870890255169",
            "3249498908318273722312450266561342384744351408145152472888574144128159241614",
            "18326965304442076244056364783642758184171133965386785868619945604645667798645",
            "6810322487272704684756846727684393468621070322625759305702914229660436807870",
            "659340959365535995846878029322462398780992604972635422373414064580963856167",
            "4753110947822659997230336129016503773479834620252828350963402604279211100876",
            "513277914363735126912695057642473103134316971932897950349518725870890255169",
        ];
        let pairs = pairs
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let public_pair = vec![
            "5035166447272886279885233439320848476728293829349840313987248323970429023730",
            "9145874345871415217695572387681529432130338804607494663711237906768538072795",
            "6810322487272704684756846727684393468621070322625759305702914229660436807870",
            "659340959365535995846878029322462398780992604972635422373414064580963856167",
            "4753110947822659997230336129016503773479834620252828350963402604279211100876",
            "513277914363735126912695057642473103134316971932897950349518725870890255169",
        ];
        let public_pair = public_pair
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let result =
            mpc_calldata_builder(CurveID::BN254 as usize, &pairs, 2, &public_pair).unwrap();
        assert_eq!(result.len(), 2339);
    }

    #[test]
    fn test_mpc_calldata_3() {
        let pairs = vec![
            "54003925790512728529734636557978809665494174139666588559721696027818618841955410766936796549298246037061238557741",
            "442070654644991189413420335442826859288657263005211651211465782750858927963217288344089708201407132823820816254377",
            "352701069587466618187139116011060144890029952792775240219908644239793785735715026873347600343865175952761926303160",
            "3059144344244213709971259814753781636986470325476647558659373206291635324768958432433509563104347017837885763365758",
            "1985150602287291935568054521177171638300868978215655730859378665066344726373823718423869104263333984641494340347905",
            "927553665492332455747201965776037880757740193453592970025027978793976877002675564980949289727957565575433344219582",
            "2519019305560024360348177065589339011121876012630404576125613689972669081700673957096424545789913828791674380155859",
            "3662327302685666861417936839242640980855694319377399897002405525453047489734053757539205056345650283566843020165967",
            "1258840156485142658461631936837188333931786745480976768055292190021560297444321508204201439522693725173379471166217",
            "2126870762633422554730623947755814554495198949002678337997105982104545108633224520310857958409200781392926644002400",
            "714503968597760893023853746464499533517790482713985264043773683610663338124112103921472991399418413015930145798576",
            "3934317683619246201431803132687663067086081304030769485888408342863757437021952308047494783760053819602684039818256",
        ];
        let pairs = pairs
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let public_pair: Vec<String> = vec![];
        let public_pair = public_pair
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let result =
            mpc_calldata_builder(CurveID::BLS12_381 as usize, &pairs, 2, &public_pair).unwrap();
        assert_eq!(result.len(), 2126);
    }

    #[test]
    fn test_mpc_calldata_4() {
        let pairs = vec![
            "3706731792363101107042463949212802329423106373243880227920212798685091194919869452764077810695156795704434503385948",
            "169774197169282120473054426880424937876705011602365201846104000533295103889617213746120968768572894783105711740759",
            "2776774723596415229842346335056985786333423411046299117648446872771923878144524835135998122930215439000378027481685",
            "3310071061263468266022734421683880917934071100706816007998135747373307960012136085415120225145325870977286945138997",
            "421579814991759445734865663688297954274726228850537489624876471288545264773224903102410800560756298916876945983803",
            "1231064076993223546112860073897212458718138720533546584775364663937008591369223624135784578147603546497729161224272",
            "3706731792363101107042463949212802329423106373243880227920212798685091194919869452764077810695156795704434503385948",
            "169774197169282120473054426880424937876705011602365201846104000533295103889617213746120968768572894783105711740759",
            "2776774723596415229842346335056985786333423411046299117648446872771923878144524835135998122930215439000378027481685",
            "3310071061263468266022734421683880917934071100706816007998135747373307960012136085415120225145325870977286945138997",
            "421579814991759445734865663688297954274726228850537489624876471288545264773224903102410800560756298916876945983803",
            "1231064076993223546112860073897212458718138720533546584775364663937008591369223624135784578147603546497729161224272",
            "3706731792363101107042463949212802329423106373243880227920212798685091194919869452764077810695156795704434503385948",
            "169774197169282120473054426880424937876705011602365201846104000533295103889617213746120968768572894783105711740759",
            "2776774723596415229842346335056985786333423411046299117648446872771923878144524835135998122930215439000378027481685",
            "3310071061263468266022734421683880917934071100706816007998135747373307960012136085415120225145325870977286945138997",
            "421579814991759445734865663688297954274726228850537489624876471288545264773224903102410800560756298916876945983803",
            "1231064076993223546112860073897212458718138720533546584775364663937008591369223624135784578147603546497729161224272",
        ];
        let pairs = pairs
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let public_pair =
            vec![
                "2493235149414937090342598732346340953140426744071698812750048518316696168502607876745343502496461355407793011430276",
                "2377594448062446884751299027564636333966837548202129162398968229684427910690340765575360547995602251195058548909247",
                "2776774723596415229842346335056985786333423411046299117648446872771923878144524835135998122930215439000378027481685",
                "3310071061263468266022734421683880917934071100706816007998135747373307960012136085415120225145325870977286945138997",
                "421579814991759445734865663688297954274726228850537489624876471288545264773224903102410800560756298916876945983803",
                "1231064076993223546112860073897212458718138720533546584775364663937008591369223624135784578147603546497729161224272",
            ];
        let public_pair = public_pair
            .iter()
            .map(|s| BigUint::parse_bytes(s.as_bytes(), 10).unwrap())
            .collect::<Vec<BigUint>>();
        let result =
            mpc_calldata_builder(CurveID::BLS12_381 as usize, &pairs, 2, &public_pair).unwrap();
        assert_eq!(result.len(), 2266);
    }
}
