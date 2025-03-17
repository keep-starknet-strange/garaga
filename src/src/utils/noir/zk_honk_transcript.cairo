use core::poseidon::hades_permutation;
use core::array::array_slice;
use garaga::utils::noir::{HonkVk, ZKHonkProof, G1Point256, G1PointProof};
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
        honk_vk: @HonkVk, honk_proof: ZKHonkProof,
    ) -> (ZKHonkTranscript, felt252) {
        let (etas, challenge) = get_eta_challenges::<
            T,
        >(
            (*honk_vk.circuit_size).into(),
            (*honk_vk.public_inputs_size).into(),
            (*honk_vk.public_inputs_offset).into(),
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
    use garaga::utils::noir::{get_vk, get_zk_proof_keccak, get_zk_proof_starknet};
    #[test]
    fn test_zk_transcript_keccak() {
        let vk = get_vk();
        let proof = get_zk_proof_keccak();
        let (transcript, _) = ZKHonkTranscriptTrait::from_proof::<KeccakHasherState>(@vk, proof);
        let expected = ZKHonkTranscript {
            eta: 0x8f552b09842921c3d8e179c45df06f60,
            eta_two: 0x12fbf1fd24f38c808ec773d904e06a74,
            eta_three: 0x31848febf1a2baa2787dce151b3af87f,
            beta: 0xd862459f6b68ff32eb00329415abbeb4,
            gamma: 0x490beb870562adcb4b5b369ecaad99a,
            alphas: array![
                0xeb60fa249708fce6448e9d3b01921b45,
                0x2dcc3670321250579136fa1f0cdcb82c,
                0x2fdd6fb0ec0576290d75a3787fab4943,
                0x23bfbbb4313d4d62912624d0c7af3778,
                0x2ea2f2d064271b5ba8ea40a93e5508a3,
                0x2e44916f8a2a4ae7397f4d70a32bee1b,
                0x53d85eacf5d74ec893c9642feab95374,
                0x1c68457e0064ae9ca5cdb7dc9a6a9877,
                0xf9967d7ff15b716e4732d03d770b4b7c,
                0x16ec6f6fe2cdeda6a992e17c5d84e9f5,
                0x2f3f85623409fdc6a2ff32dcdae23e47,
                0xb7ed594e3690a48788d067c3c6eab49,
                0x47083760a50211d763a0e28c85ca0ab2,
                0x17f16c9ed3ef1d10ea5adf32add4a5bd,
                0xd8ef1260fa77b69b5af8bd9e8839fbfa,
                0x457b064b31e9c7c3f8df87132c3be60,
                0xa0f795db922a9c0f842c25cd129bee7,
                0x2bd5e75480cfd6d8bdf15239c4ee2de1,
                0x6acf0ddbb7736b7c60ef36f3602d7644,
                0x184ca1e15327827bfb91b6ff00c63c35,
                0x599e7c7c1b77951ef0f9c29e4767b721,
                0x218203e486042d51b09588fcc37f3f6,
                0xd6467fb2e7bb03ce03b52206b69a2af7,
                0x1671504835ea499e8eca67268db3e28e,
                0xb60028b150a4357f47682e533f5f9992,
            ],
            gate_challenges: array![
                0x81f4f81b706ba682619d2f5ba0729be6,
                0x21c790fac296d7c844d88f1dd2f60035,
                0x1a6dee6be12c075b76ec039da01e8abb,
                0x3edb03832d3937d142722417c84b2b3,
                0xc0a2e585fb420359ea6117221d1454c5,
                0x23c1677ee0de9bad0de211e565ea8519,
                0x4dba9384b4bca6565b27d243ea5ee01d,
                0x6f0e395b8793e96026e680365360946f,
                0x871b3dc857c8c4b0298e140955651769,
                0xcc7bc68b460a5ab986da8cdbb19ceadd,
                0xbd5522614f0f52b01f111a68e78847be,
                0x82662ff38da8507e9fc1aa266d7cac19,
                0x365548359170099aaf47b8b28e2ec001,
                0xf2b5ef5d5820d73eae40593062af0a13,
                0x10e84f11b06b083aa8dfb3610dee6591,
                0xac8c27816a32284cc9894b8c17f0960a,
                0xfb17ebba25c7145f502f9bfaf3ed7bd3,
                0x91720e68e07f55ceaa0dc6aa64d0c119,
                0x23f4b1dff3848ed7d629279b639dd5b3,
                0x7865fd4964ea388a73d507a08c4c30e8,
                0xcb1c8bb2b147c5a65ca5cccfa22a2c64,
                0xbe176fab8c0c15b088af4cb51073a2b6,
                0x833f40aaaa002056498d064923f6fa2e,
                0x5591d25fdc27a8115a7df89b873bea0,
                0x535eca64b27d035c67e6ef51992fab71,
                0x9844b56d7dc0be5d3666264c83edb8c0,
                0x8c614118f36b73944f7650d110cf2023,
                0xd45a9a753c738faf5af35cd808904ae2,
            ],
            libra_challenge: 0xd4fb129007db630983f7c70bf6342b28,
            sum_check_u_challenges: array![
                0x7e53e37231311b2180ec351d92d21ee2,
                0x68c4a0e55444a76525ec8e9321e62c0,
                0x37aa48611971c2ba964867f6cecec070,
                0x22af099d897c19f087bf43aac71277dc,
                0x3cc5b1ca87e99832ff676e94083a3245,
                0xa9f386f5f3801744b3a120c9e82f51af,
                0x657bb457fd9869fb595b68702af6f545,
                0xa0ba7864eb626fc94af5e05f0d068ef8,
                0x78aa1e3189015361ef655dd6bda80809,
                0xddfe61381100615eacb1560efadd3ad2,
                0xbfb17816c24424d26d2a243f8ddaf41e,
                0xd403371cf8b4c8809bea07bffdb770c8,
                0x1e39873562d3436f68f51e6767fe47cc,
                0x93d4376fd35365b3bdd4a29961681211,
                0xf9585efa7b3471ede116c728442f87e5,
                0x533ea0e18f500dada1647fbfa7a14fc0,
                0x94e3a4fefd808432e2351272129637ed,
                0x878e468cc7780de90fef6a6992a935e6,
                0x1f0a96c4b6326b1572b3aacd5f2bfdd6,
                0xa902fa36d1ff20532eeb3fbbd3e9646a,
                0xcfdcc19ac9680ceaf9aa004c121f6305,
                0x3357007fce7941deffedc7b8bfb53782,
                0x6b1b2a5d08b7245961475e1b2629c4aa,
                0x8ac77e473b3e4976d4a9303fc8e01dc1,
                0xac96422ce0f71aa1c56a1a1af58ee70e,
                0x780a7487d940d06552169b069773afc4,
                0xc5b9578cd903bcaecc9bcc3d4c36f87f,
                0xd40d9d1986abe5c22fbbdc59092be9f4,
            ],
            rho: 0x595cf494c61c617a238ac1c691863d0e,
            gemini_r: 0xd5b974a62db588616db9170c8cf6793f,
            shplonk_nu: 0x4e8d908c16853f6b69a07de1453684bb,
            shplonk_z: 0x9d8cda2f1785e898909b054ecd90ed16,
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
        let vk = get_vk();
        let proof = get_zk_proof_starknet();
        let (transcript, _) = ZKHonkTranscriptTrait::from_proof::<StarknetHasherState>(@vk, proof);
        let expected = ZKHonkTranscript {
            eta: 0xacab94703ab6d0ac76a257baf5b3cc47,
            eta_two: 0x48aa9b84794b8501475d1acdde7c12,
            eta_three: 0x75e7a26159152b2e8ffe0d819208882a,
            beta: 0x964133a1e77ef97b1e8f861fc2c60723,
            gamma: 0x5f6f7c58fa879b7ce52e395dfdce364,
            alphas: array![
                0xe7911296f60df1760a5be7afee898a12,
                0x6fb11a8bcf4528a66e537cd7ec05e34,
                0x2f586b8a5e1b275bfdf60dbdb2608fd5,
                0x685bfbd08ddad1709c19634a02c9f77,
                0xbd0ba4fcee9fd962935586e8a7d5339e,
                0x6a6fb02b6aba4e2445383eaf0520be7,
                0x9022363a8d8b370b056fac4ff4fa7a,
                0x441c400cf1827b3466bed56e84e2cf9,
                0x18a3e1de86d1c66cba855a5fe580daea,
                0x742ce348dc252d7b70722f123cc2cba,
                0x221fd3dab521b999036b1a3b5208ee0b,
                0xa449dec06766699424ccf3db36acd3,
                0x76397a396545e559b9d760d10709b00e,
                0x69ee542904a0fb3acb14f9a31110346,
                0xced4926c55cad486c97940a7c7a50358,
                0x13cfa991749b10cb201df1d4694e567,
                0xa0eb8ec6324d4ae17efb7b6cfa659a1,
                0x42644dc16c5395ab1c06f98dd37e7b3,
                0x969d8263384583d371bcad8d4cf069ea,
                0x70cf93d413328ff7d168e0000751abf,
                0x126e690d2bc4a9082d9be37a26ca4306,
                0x5caf12ab713e66155c9f8235fabbfbf,
                0x6d6241b94e8cb208f1dd22dd76effc64,
                0x6deb65afd65fbb307c503d7106cdfd9,
                0x2f71118a04e7451931fd629d305f0164,
            ],
            gate_challenges: array![
                0x69c37c6c2ffba2f07e39d26432181f2e,
                0x23ac910b6f51fb3d81a9d968f6f00b44,
                0x7d16fc9dc0f496c5dfaad141b7ff2785,
                0xfda0c15eddaa9c5deb5f3ada049925b5,
                0x4e979fc84f06b5823fe74b430dd22d12,
                0x8d1b8e63324d96c697f7e7b0ef9ab032,
                0x1b2a8f9bad182647bb0808319ae8802b,
                0xf798302b1d90fa22890f106f73fd52c3,
                0xdf416794a76cf1a268eb3800bdbb7a27,
                0xc3070672a9d001a3e201f3567d3cf26,
                0x1173d7336be0ca588ddb468918c30d44,
                0x443fccd696e9694ccb17c5f41e718827,
                0x7d36241e3cbf818664a14e89d5db7e1b,
                0x8c382222a14ad2e385dcb00929dead66,
                0x39b3f265f401af6c81164c854f792c37,
                0x3739d9af74ff462191040a49b332e701,
                0x369acb748865636da7853ae51af388b,
                0xcb801712dd82470e1aafb760e5447c6c,
                0x9dccfa35df07b05ba983d4bd27606431,
                0xfb170e32c43c8934ba2b03c4b7efe738,
                0x75d7f7c00e6f9ca5f65e34581fac33f0,
                0xc5b490a4215093be8f547c1c521ce016,
                0x25cfd09a174499d84b961cc1c6434797,
                0x33371c22958a398e5e257d1e5aeb29fe,
                0xd8d4d07688225e278de2e7dd5f01f1f,
                0x60be980e8c25ee53c7f6cdbfa3d43b4,
                0xbcfe51021c0c9b872c999ca50c883273,
                0xdef59c8cc9e2e6d841a4559b7f559b18,
            ],
            libra_challenge: 0x539ba67e895526f656a1dfb56e1d415,
            sum_check_u_challenges: array![
                0xe97a46ca70251d00fcf9c5fbefdbb054,
                0x8635c2c2559b8c1a357b89494e72515,
                0x5aaf593aa07fbf7b984d253850bfeeb0,
                0x21f3831a1ce1c88fe14e8d8219f98072,
                0x704a893ba7c105c7490abec5d2b367f5,
                0xa45306b04199cc0a21da73d143cc8bff,
                0x4efd30a54329c937da048f9a7566f44a,
                0x15a356dbc98166aa763edb07ab0f5dc7,
                0xdc14e7c9f6b01f797ed4568030a62a86,
                0x6fb007806a010a6dc2dfba99ec6e3226,
                0x87c75fee15d5bc1f44615c93af88adb1,
                0xa7d6e57c48416d53e38a68c25b326f84,
                0x1cbabf4b97bc466438ad8adc7d8ffa7b,
                0x98f37cc8bc37c3c603dd04375f0feb6b,
                0x813891fb146c7396839405184af44c5d,
                0xd03ee9b26cd4a12d7b9e0be30457f803,
                0x82deadb73c7f9853e612ff8417ba78d1,
                0xdea605777871b391a83d9849c05dee85,
                0x74f4740c388beba7f7dd2719953e574f,
                0x60fddc34b9329563b8e5e8d67d475cca,
                0x859a3ee11bf479e760871a23d7e52dff,
                0xae632501ce75db0767328ab2f16da4e5,
                0xd6d08f6222f5a98f1e24d4f26ce4ae15,
                0xf75c2351b351f4a6e4950ce8e24d90b0,
                0x8d21784dfb476549b19a7653259ead15,
                0x79dcf53d4585eb76b3bc9580f739e711,
                0x12f750f220aaa9c8659a00787eb652b5,
                0xb10bb318c2fb6a3fdad2c0f9fa5da22b,
            ],
            rho: 0xfcc00989e1c7984ab8f42d47ff4c03f0,
            gemini_r: 0xd93a2cb2cde87a25342b9843ce90e30d,
            shplonk_nu: 0xba335f21eb111f553ae87bfb611a9833,
            shplonk_z: 0xd6980295e0f8d60a5e190e09c4651bb9,
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
