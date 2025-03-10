use core::poseidon::hades_permutation;
use core::array::array_slice;
use garaga::utils::noir::{ZKHonkProof, G1Point256, G1PointProof};
use garaga::utils::noir::honk_transcript::{
    CONST_PROOF_SIZE_LOG_N, NUMBER_OF_ENTITIES, IHasher, Point256IntoProofPoint, append_proof_point,
    get_eta_challenges, get_beta_gamma_challenges, generate_alpha_challenges,
    generate_gate_challenges, generate_gemini_r_challenge, generate_shplonk_z_challenge,
};

const ZK_BATCHED_RELATION_PARTIAL_LENGTH: usize = 9;


#[derive(Drop, Debug, PartialEq)]
struct ZKHonkTranscript {
    eta: u128,
    eta_two: u128,
    eta_three: u128,
    beta: u128,
    gamma: u128,
    alphas: Array<u128>,
    gate_challenges: Array<u128>,
    libra_challenge: u128,
    sum_check_u_challenges: Array<u128>,
    rho: u128,
    gemini_r: u128,
    shplonk_nu: u128,
    shplonk_z: u128,
}

#[generate_trait]
impl ZKHonkTranscriptImpl of ZKHonkTranscriptTrait {
    fn from_proof<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
        honk_proof: ZKHonkProof,
    ) -> (ZKHonkTranscript, felt252) {
        let (etas, challenge) = get_eta_challenges::<
            T,
        >(
            honk_proof.circuit_size,
            honk_proof.public_inputs_size,
            honk_proof.public_inputs_offset,
            honk_proof.public_inputs,
            honk_proof.w1.into(),
            honk_proof.w2.into(),
            honk_proof.w3.into(),
        );
        let beta_gamma = get_beta_gamma_challenges::<
            T,
        >(
            challenge,
            honk_proof.lookup_read_counts.into(),
            honk_proof.lookup_read_tags.into(),
            honk_proof.w4.into(),
        );
        let (alphas, challenge) = generate_alpha_challenges::<
            T,
        >(beta_gamma, honk_proof.lookup_inverses.into(), honk_proof.z_perm.into());
        let (gate_challenges, challenge) = generate_gate_challenges::<T>(challenge);

        let libra_challenge = generate_libra_challenge::<
            T,
        >(challenge, honk_proof.libra_commitments, honk_proof.libra_sum);

        let (sum_check_u_challenges, challenge) = generate_sumcheck_u_challenges::<
            T,
        >(libra_challenge, honk_proof.sumcheck_univariates);

        let rho = generate_rho_challenge::<
            T,
        >(
            challenge,
            honk_proof.sumcheck_evaluations,
            honk_proof.libra_evaluation,
            honk_proof.libra_commitments,
            honk_proof.gemini_masking_poly.into(),
            honk_proof.gemini_masking_eval,
        );

        let gemini_r = generate_gemini_r_challenge::<T>(rho, honk_proof.gemini_fold_comms);

        let shplonk_nu = generate_shplonk_nu_challenge::<
            T,
        >(gemini_r, honk_proof.gemini_a_evaluations, honk_proof.libra_poly_evals);
        let shplonk_z = generate_shplonk_z_challenge::<T>(shplonk_nu, honk_proof.shplonk_q.into());

        let (base_rlc, _, _) = hades_permutation(shplonk_z.low.into(), shplonk_z.high.into(), 2);

        return (
            ZKHonkTranscript {
                eta: etas.eta,
                eta_two: etas.eta2,
                eta_three: etas.eta3,
                beta: beta_gamma.low,
                gamma: beta_gamma.high,
                alphas: alphas,
                gate_challenges: gate_challenges,
                libra_challenge: libra_challenge.low,
                sum_check_u_challenges: sum_check_u_challenges,
                rho: rho.low,
                gemini_r: gemini_r.low,
                shplonk_nu: shplonk_nu.low,
                shplonk_z: shplonk_z.low,
            },
            base_rlc,
        );
    }
}

#[cfg(test)]
mod tests {
    use super::{ZKHonkProof, G1Point256, ZKHonkTranscript, ZKHonkTranscriptTrait};
    use garaga::utils::noir::honk_transcript::{KeccakHasherState, StarknetHasherState};
    use garaga::utils::noir::{get_zk_proof_keccak, get_zk_proof_starknet};
    #[test]
    fn test_zk_transcript_keccak() {
        let proof = get_zk_proof_keccak();
        let (transcript, _) = ZKHonkTranscriptTrait::from_proof::<KeccakHasherState>(proof);
        let expected = ZKHonkTranscript {
            eta: 0x3dd115032b71dd37313f75cbfa36d4b4,
            eta_two: 0xac7f8aec0ae883e27bc66210524ff5d,
            eta_three: 0x582b7cb2f6ea52193d9657f63ddc4fdd,
            beta: 0x862b642f8b76eee81d7a6b35d01969a2,
            gamma: 0x20b10044374c765f889d5804ae79627a,
            alphas: array![
                0xdacf9bb7ee2a497f0891fdec5c10529d,
                0x16097398e99f5a5a5c13b76ddf5e8953,
                0x702aeca9bd2314af5924bd5fdaec18a3,
                0x95d0f240a1141506d8648b9d133c707,
                0xf286dc2252b4430c63d3391ac0835b46,
                0x19a975c11be7401d6123b92ee32a63b,
                0x68449a2d763de3767fd94826d6b1ea23,
                0x14a0ab37d16ba14619c169273e390cc6,
                0xd7a1aac8c9758868eeb03d825c0c2957,
                0x92ffc33f4ee81af7634a0700a1a08bb,
                0x3b94ae0f50c532b1e2479fadf9d0bd4,
                0x26e0627c9f46325f2af25f4d875d08ba,
                0x8caafd58ca033fffbdd702ac2c07f5b3,
                0x6988e9ed8671e56ac41dc4580684d93,
                0xa5946af31af5615ffea036e7893ff1c1,
                0x1858a75cab3baa2fee6e2912bbec295c,
                0x1c872eabf767ad5b71e894d963d7cdc4,
                0x1b4e260701b2e3d6a02dca4ffc109382,
                0xe7b26d18568ff9ad38a3a7bd5b2dbcd3,
                0x2e3e5d146235ad729fb1f2bb52cf4586,
                0x511e828c092fa17128062687296c44d1,
                0x1b2e2c78b43098d9ee6955c673d2461d,
                0xc6e355efc9c2a2fe967cdad970bf5f63,
                0x3bd4b05d9d0e00085523874b02af07c,
                0x3944758f00e58c1e053e0a48d574238,
            ],
            gate_challenges: array![
                0x7377c9a20a2b51705db59af23a5f827b,
                0x400f1c46f3e071163a911216bbff568c,
                0xfcf8f3d3f96264471f602e9617e46aaa,
                0x5111aa5ce5d59a2f7f1893d9a0d7b94b,
                0x18b141b86027cde1dbfbd99dfbe7be7b,
                0x580ea078bba9c778ee87383a1d690d31,
                0x2e7d439f50bedcb5f45d1495bb733bcd,
                0xc01c0c0bf39157386189097a1e2d9d4,
                0x1f88c677d2a4570abff85ce9ecf25848,
                0xf923df0344c90ca5e8b8e3a9a57932c4,
                0xf38537ff53ed3af3cb7c7d168cab3b64,
                0x88bd37f989de70bf49e82f373fc47824,
                0x47cce3dacaf68e0d1163c9a59059628d,
                0x54f3a0d001c4ddd913eb1213e2e164e0,
                0x49a7ada96258a48d61b47ebe4703d982,
                0xf307c00bb69f517c17e43daa0e3278d6,
                0xd264de36b32b5956daebc47d919da2f1,
                0xe166a488dc479ab1f87e14509df3cf1,
                0xf1feb01130beb65c1ebcd20b3d21cb5a,
                0x531bce9297cd367be473b300501372a7,
                0x39f5052db730549f690e101ceb35e96a,
                0x963867b5d03cb4307accdb33abc333ae,
                0xa8a5603d902009c4a8e2a9360f1dcaec,
                0xaed82460c6fd7afa2a36e1b67984f7bc,
                0x68e167c3e52b7b75feac14ea6e8da067,
                0xd527895d16e8e3248db719b6c3cfbf61,
                0xcf58724b7a22b04201b53b4a7899ef68,
                0x70598d7058df7e394af33263a617343,
            ],
            libra_challenge: 0xd6dfe746698bfea401130100862f55e1,
            sum_check_u_challenges: array![
                0x17bdaa8bfb281f6eed101dea2e0b7d37,
                0x5918285ac4a8d941574be582a38f594f,
                0x20dce1d687f2de70dbaa1533905685cc,
                0x947a8a912d1dd233450783ea80c586be,
                0x8fd06cdfe4ca1934afbcf3e49a09a0f1,
                0x387c0097d4ea2fc4ed19bf609309f058,
                0xc87996dde83da5925e3d19b1fe9cd463,
                0x73dd16417d7acb246678062f61b3c1bf,
                0x92e5d98b2ca5b4e721dd8846e8d27ad2,
                0xef49e06e3952919901a2e507d82525ed,
                0xd1ad93cfe6d11c64307c2f8fc49f3d3e,
                0x1043eb7485c7843acfdb0ac2a045167e,
                0xe9f93224d82cce96e810484e7e217afe,
                0xe5b0d2ba96344243a2fa2d705530e875,
                0xad1fe6e55e76638c81b0b719ad47c4c7,
                0x8d81d2fc143b59874e2cd9ac89c0330,
                0xe78e4c901a584a0e6e8a61733a139188,
                0x154fe8b8cc8497444c5db50efb0828de,
                0x2f9c4338d1e2afa83d60954a417cf9db,
                0x5ef6544cd29ca75936ee3cc1a42adb3e,
                0xb5d245d1aa38935d751610404fec4f34,
                0x35b61acf9044cd1776b5cc8d6787f5ef,
                0x19c820d7e72c60b98e92ab021612982b,
                0x8e445310515a0fc38c38316f99e93a38,
                0xd075b05d35ba2eb7c3d878bf65433be,
                0xf1c2020e5b5dbecaa3cf5fba6c9f8198,
                0xb753d187cc7514f9082c4b57ae82c148,
                0xdf90caf502efedcc473e121e1c90123c,
            ],
            rho: 0x85104410d0b1467d4f1bd667b37a2416,
            gemini_r: 0xf38be19978aba5f9af01d5dd4be54eeb,
            shplonk_nu: 0x645a6978b9351e10235abdaf26bb3f0f,
            shplonk_z: 0x2da55129a41efa6b0d45ed5e3dea6601,
        };
        assert_eq!(transcript.eta, expected.eta);
        assert_eq!(transcript.eta_two, expected.eta_two);
        assert_eq!(transcript.eta_three, expected.eta_three);
        assert_eq!(transcript.beta, expected.beta);
        assert_eq!(transcript.gamma, expected.gamma);
        assert_eq!(transcript.alphas, expected.alphas);
        assert_eq!(transcript.gate_challenges, expected.gate_challenges);
        assert_eq!(transcript.libra_challenge, expected.libra_challenge);
        assert_eq!(transcript.sum_check_u_challenges, expected.sum_check_u_challenges);
        assert_eq!(transcript.rho, expected.rho);
        assert_eq!(transcript.gemini_r, expected.gemini_r);
        assert_eq!(transcript.shplonk_nu, expected.shplonk_nu);
        assert_eq!(transcript.shplonk_z, expected.shplonk_z);
    }
    #[test]
    fn test_zk_transcript_starknet() {
        let proof = get_zk_proof_starknet();
        let (transcript, _) = ZKHonkTranscriptTrait::from_proof::<StarknetHasherState>(proof);
        let expected = ZKHonkTranscript {
            eta: 0x8eb612d5c1b653040673d99544654162,
            eta_two: 0x4ead0803989f187cde4e0cc89022837,
            eta_three: 0xcfb2bd9ecaf1f54735381c9a785d3f8b,
            beta: 0x97cce689c2e8cd96274c98a6d7ec8e7,
            gamma: 0x6e8c2f94f767998f31ca52e46d9a4a,
            alphas: array![
                0x56fff183e2e8cc738f46281e28de493d,
                0x41bbcc7600dd89ad10633023e63e414,
                0x67f48ea64c17e4c175933c986da198cd,
                0x326ce404a7b73ad923b5722e29518f4,
                0xf82e331252727b791a6a745422cb9a7,
                0x5931caec8f242663b6d6f9d7b6ea128,
                0x2a7bb36a41b17dea9228a7b8dc185eb0,
                0x67098521d585fc24473142522032d4,
                0x60c129ed1b5adafb980665163d240928,
                0x4a4553668c6739a3decd991b0aa0f5,
                0x2b17dbe9741da9fd0e3b4fb85c03b7cf,
                0x6df4d34a1560508303bbcbc23076afe,
                0xd7db3a982e4aef88ff8caa72746ed207,
                0x257d54712404efebd660b00d4a84db6,
                0xea31f6463505a01d772e3b5555e7a800,
                0x3580cdf8f0c79bfaddfa1d67e44824a,
                0x7cda194e4129d15c3c9d0a6adef21f3f,
                0x7fe931390d6c3c0d172c1a2ce3dd8cb,
                0xa7170e2d738ec7bc39b1fe70f137d4c2,
                0x2c01151d63062d50c5efc5639375f98,
                0xd45a5b8e6fef1169bea35ccd4646607d,
                0x52490aeff0483573974cea46f3c17e9,
                0x5f4484552110d273f35449b51ebb8a6c,
                0x4343c7664e0264d796b85700d423314,
                0x7eda3da98bf1cd9eb8855bad151d97ac,
            ],
            gate_challenges: array![
                0x8fa01da5d9cf0c6af25fece5ddab4413,
                0xc661ed73e8dc0365bff37925cac993e1,
                0x11b50c22fa6fc392a24428828c78697f,
                0xcfd0dcc7152a41140e1b47da604c44ef,
                0x5cd7f6884f26e143a71400604c17470d,
                0x1b0fd4f06b675e894ca65ec1938c047d,
                0x932a3bf24fd4abeb70ace8f9ddca0077,
                0x4d19415096c22d3da707e6dd90f5bbae,
                0x58cea11b9710c04815edd6769ea746fd,
                0x7dcfb20ef0fae7f8ffa245f077c26ad8,
                0xb1d2b7483a77a24d6e6b8e6de6e4223f,
                0x1d22a638c3c15d2c42de9000e02264ae,
                0xa71ac617dad33a1265bc1bd8db911331,
                0x5a75315e71bcb9970f6d4c11775ff530,
                0xeb3be063f74b73b8a5a7fdc7f901e8b4,
                0xbc09f90b048362d3028e701baa4f8032,
                0x290774fd8dfa648a7817c5cca34620c9,
                0xee41fc1c7f3c5458fd452c698c283dbd,
                0xa03394634fd25f065c9bfae7c0cddaf3,
                0xb4bff5339e92c3b1673c221c4d2bb29a,
                0x39ffc1d83e05e801e4bb04a9224352f5,
                0x390128cee0eb9e749af380ffe14c030b,
                0xd9b53b9aaacbfaca34676362abaa8982,
                0xcb6752d052765a00ba1b1d5d20dd6c7e,
                0xd004d76c7debd0b2a810f0596494a7bc,
                0x71857f1b8e7b79ad82b7e20ca006cef9,
                0xabda0e2c3d00d31dfcd8d04d1e245ffa,
                0x7c0d2e610812fcd74f099fd78d6161c8,
            ],
            libra_challenge: 0x775e31e91585715cc1e9f755cc402c15,
            sum_check_u_challenges: array![
                0x863df66b6acb782ebeff709b69d66dd9,
                0xcbeaa7ecf7dc50fd37b81c6ca97486be,
                0xf967ff1a9d7ea69865dfb2e29cfdb945,
                0x5b060b75042ca8ec6d22b73c1157b10a,
                0x10588623caea17cbbb961a3daaddae00,
                0x59abc5c72c8ff46b0d041b65cd618ed1,
                0x625f4d41d20529a7a936538b4f896fff,
                0x37aebdf9282e605021cb49fa3e67c307,
                0x6442d05b2ec2a4e28c173c831a6bfc7e,
                0xc512d738b6ac8cea61c5f6938b41a423,
                0x488ef99cd90a27fea9b6f73c2c9c419c,
                0x9420aa07d7e08e68bb862798de12e753,
                0x9645f3920258aa8cce4e0d104842f74c,
                0x64fcd83e2ec73ac5d2641213640aed49,
                0xa8d3b31c9c14924a57f3d660a983df3,
                0x96c25c530fa02c4aec15966ed456ed93,
                0xdc412dcd79e6bdec51eada2657bb55a4,
                0xea4ea67c2c0d8b1356ae23d61b9562b3,
                0xcf9105412dc575d67446ef88f9ad10f6,
                0x7876605119d63a81759d1a7a737f3ce,
                0xcacc262651f95f1782614bc3b6f40f5e,
                0x1b9b4c927e1e6c890b401b3d63d05440,
                0x62cded4032258f62402f295f7c1764a2,
                0x97a217133a30dd76648f1765599550a7,
                0x21e89eb896cc1086de7559b15eb2a982,
                0x4a2817584869047a9cd9b863ce75bd76,
                0xda89d9e850593c5104bb2371b9901c61,
                0x55166437fec21cbb518f012eb4acb7a6,
            ],
            rho: 0x367702bdac7b8cb3006e8c56fbbc33cc,
            gemini_r: 0x168735f13164395d16772d57e717716f,
            shplonk_nu: 0x4c664817966da52bf1838af795058a91,
            shplonk_z: 0x37861e5091985ccfc8fdf5ac7cc4443a,
        };
        assert_eq!(transcript.eta, expected.eta);
        assert_eq!(transcript.eta_two, expected.eta_two);
        assert_eq!(transcript.eta_three, expected.eta_three);
        assert_eq!(transcript.beta, expected.beta);
        assert_eq!(transcript.gamma, expected.gamma);
        assert_eq!(transcript.alphas, expected.alphas);
        assert_eq!(transcript.gate_challenges, expected.gate_challenges);
        assert_eq!(transcript.libra_challenge, expected.libra_challenge);
        assert_eq!(transcript.sum_check_u_challenges, expected.sum_check_u_challenges);
        assert_eq!(transcript.rho, expected.rho);
        assert_eq!(transcript.gemini_r, expected.gemini_r);
        assert_eq!(transcript.shplonk_nu, expected.shplonk_nu);
        assert_eq!(transcript.shplonk_z, expected.shplonk_z);
    }
}


#[inline]
pub fn generate_libra_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, libra_commitments: Span<G1Point256>, libra_sum: u256,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);

    append_proof_point(ref hasher, (*libra_commitments.at(0)).into());

    hasher.update(libra_sum);

    hasher.digest()
}

#[inline]
pub fn generate_sumcheck_u_challenges<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, sumcheck_univariates: Span<u256>,
) -> (Array<u128>, u256) {
    let mut sum_check_u_challenges: Array<u128> = array![];
    let mut challenge: u256 = prev_hasher_output;
    for i in 0..CONST_PROOF_SIZE_LOG_N {
        let mut hasher = Hasher::new();
        hasher.update(challenge);

        match array_slice(
            sumcheck_univariates.snapshot,
            i * ZK_BATCHED_RELATION_PARTIAL_LENGTH,
            ZK_BATCHED_RELATION_PARTIAL_LENGTH,
        ) {
            Option::Some(slice) => {
                let sumcheck_univariates_i = Span { snapshot: slice };
                for j in 0..ZK_BATCHED_RELATION_PARTIAL_LENGTH {
                    hasher.update(*sumcheck_univariates_i.at(j));
                };
            },
            Option::None => {
                for _ in 0..ZK_BATCHED_RELATION_PARTIAL_LENGTH {
                    hasher.update_0_256();
                };
            },
        };
        challenge = hasher.digest();
        sum_check_u_challenges.append(challenge.low);
    };

    (sum_check_u_challenges, challenge)
}


#[inline]
pub fn generate_rho_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256,
    sumcheck_evaluations: Span<u256>,
    libra_evaluation: u256,
    libra_commitments: Span<G1Point256>,
    gemini_masking_poly: G1PointProof,
    gemini_masking_eval: u256,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    for i in 0..NUMBER_OF_ENTITIES {
        hasher.update(*sumcheck_evaluations.at(i));
    };

    hasher.update(libra_evaluation);
    append_proof_point(ref hasher, (*libra_commitments.at(1)).into());
    append_proof_point(ref hasher, (*libra_commitments.at(2)).into());
    append_proof_point(ref hasher, gemini_masking_poly);
    hasher.update(gemini_masking_eval);

    hasher.digest()
}

#[inline]
pub fn generate_shplonk_nu_challenge<T, impl Hasher: IHasher<T>, impl Drop: Drop<T>>(
    prev_hasher_output: u256, gemini_a_evaluations: Span<u256>, libra_poly_evals: Span<u256>,
) -> u256 {
    let mut hasher = Hasher::new();
    hasher.update(prev_hasher_output);
    for eval in gemini_a_evaluations {
        hasher.update(*eval);
    };
    let implied_log_n = gemini_a_evaluations.len();
    for _ in 0..(CONST_PROOF_SIZE_LOG_N - implied_log_n) {
        hasher.update_0_256();
    };

    for eval in libra_poly_evals {
        hasher.update(*eval);
    };

    hasher.digest()
}
