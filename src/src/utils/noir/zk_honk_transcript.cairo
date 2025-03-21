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
            eta: 0xc6dad1dc44b188472495d4205dd6c884,
            eta_two: 0x2f223ec75ca4deba48a47b78e5c5099,
            eta_three: 0x2be0c284f4eecc00ef5dcda42585ce4e,
            beta: 0x63f849548e517f95e2d51e89f0e29349,
            gamma: 0x242d8e2987c9369001fab639d7a3ca6,
            alphas: array![
                0x668b311da6a4bec92c835a022a0fc41,
                0x6f024142370b422d291e98ddd558894,
                0x95441c17b0bd3bb825bb6ed3761ce697,
                0x5595eb632841c1e87678275cde90a6c,
                0xdfa7de42b4614f851e34081abcdef08,
                0x57856ed182d83606d93a6f85ffd2ef8,
                0x69f570b63d4fe5ad3aeb5300097b37d1,
                0x300bd3447b2924146575687a9156458,
                0x3fde53eaee5ecf04e61154ea1193e91f,
                0x598752e1e10d5ac61a1dcd0c46d0437,
                0x2f510456ebdd955293514023684af89a,
                0x31f76bef5edb659ca1ae54d71a68be2,
                0xcf3cd1699f2c609a0eb5f87e094e09f,
                0x421f0d24df5c395062636f7529631ed,
                0x81cb565dc3f3652e7a3b9956270a9db8,
                0xe95cba5da7a70cc7b0d1d4f0392de9,
                0xf7858ae93c51b77949b53cfd01d343f3,
                0x79e1a969d466e73cb00eb192d2f36e7,
                0xc85a127ae652aa307101864d08468857,
                0x7918e51c9708dc0a820afc21ae0c71b,
                0x4c85e5797ae03a1eafeb79c4fd4c1c6f,
                0x2926cb1ad9c0f686c05a0ea55b5a6da,
                0x3aba799bb7b1c3d17169c0e33d350564,
                0x5292c0e7a02448b3465550bb44358f7,
                0x4aafbb4960d0f80fd1848101b263222,
            ],
            gate_challenges: array![
                0x1c3304eaed35eefff52562fd923d4be4,
                0xdbd52d5588b922959564a3a01d99a29b,
                0xfd23554f3322b098d558f40e4c3cb298,
                0xe25965d350066bcbc09cfc0f33a12a2b,
                0x49b339c6167aa62aa293ec32bbe696dc,
                0x99c368d575c99971b0cc96306381ca59,
                0x372f001f44c25f8e1b9ce2ed68b8631a,
                0x632579956402946b7e361fa1168bc267,
                0x39958a4d6cbd9a7d0dd8f36c43581b70,
                0xad67cc007e33f11a6c5b739a3ed64c36,
                0x108a30c60f012f486b43e1537d3ffc7c,
                0x90d67748954f9e2c2e20e3618104e77b,
                0xe930533b91cd7175c710bb670e598e2b,
                0xc081b4c2fefc71bceec1d7166181e41d,
                0xf904d7079099af69ba86e35fd0d99cb7,
                0x44b04a7ceb1ce2564def3a28aeb4c381,
                0xb066a8cb2391fc115583954d07d01ba0,
                0x362606d0c7a5e652eabbf3fe79c417ca,
                0xebaed21305101d3a962734a07a0676f7,
                0xbae22a46673a24bed7862bf8d00cf90c,
                0x4363545f1117b13c50f83d04ac194ad9,
                0x8af9db22a5d49639c84a1870df000829,
                0x68b4da39c00e051400e7cfa56ed14526,
                0x35340d34968e7a88883e9949bf6fcf64,
                0xc39a22a8749a8e6ffdd8162816292ab6,
                0xbb1ee29a81ed334190f31682d6cd4f81,
                0xd9bda39d9ca506d5327fb7f9b00e46d2,
                0x9a82ae506611a71c6cb005e4d47fe72f,
            ],
            libra_challenge: 0xf787754e89c37fc71f3a94d49ecfaf2a,
            sum_check_u_challenges: array![
                0xa0f5830ad9f72ac10dd84b8ea9cd0133,
                0x214933e82248f91eda15ada8c32d1eb3,
                0x3d63ef5dbc8294acd0785f824433169e,
                0x65b6c7386e6aac49cf99ede73c18af64,
                0xe3aec16175324df39e81ddeca3863fc6,
                0x89dfd351a823a266e8c9e5426826672c,
                0x78ebb5dfe3c2e84a0cb35e619bce72fc,
                0xfa24d0566a0c047b0537fe33fe22159b,
                0xf02d592bf158f115e017e018c6339b17,
                0x52ca41bdec0f4d7c94892a5979763272,
                0x40deb654062803a68d2a711f6371fbce,
                0x4b479e4a0280efd4032318a1e3caad56,
                0x92293011df2189ce58ccd23dcf184a0e,
                0x318fed356b0e0f626edeb4d291dc143f,
                0x1d0e2c98cc60bf0ed6c9165f14fce996,
                0x4e48c2fbda63703d881d5872a1dea1e8,
                0x8ec4c5d0a51f52fde2793905219afded,
                0xdec29120f6ac3b6083d1c4da9e034d02,
                0x4242a7d37c5028570d9babb31a1e1001,
                0x370abc3660bdf7450a7f53d310913a66,
                0x7794c28cada8c0096b5ad733346cb009,
                0xe9c912720ae72125405c52f8a2936f04,
                0x568968c1ff17d3267495e326e4a8c71a,
                0x138635f0982876f7b8ff834a54028940,
                0xacb7b5b1482d387ef17ebae58f05b0f6,
                0x5a980252a40908462295f1fe0a9b35d0,
                0x4516c58f5c034eda509260c7b5095919,
                0x5707c773cacd6981fa8677e6c745ab91,
            ],
            rho: 0x41f692054029ba83d9a2238aeb691db,
            gemini_r: 0xa684d90a843880694dcceffe52cf0f19,
            shplonk_nu: 0xfc5a49d398d6d3d87de5c93d9dd7db5,
            shplonk_z: 0xe2b524c9e21e56f66050a385422aaa02,
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
