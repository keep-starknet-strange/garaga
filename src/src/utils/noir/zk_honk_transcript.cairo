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
        circuit_size: usize,
        public_inputs_size: usize,
        public_inputs_offset: usize,
        honk_proof: ZKHonkProof,
    ) -> (ZKHonkTranscript, felt252) {
        let (etas, challenge) = get_eta_challenges::<
            T,
        >(
            circuit_size.into(),
            public_inputs_size.into(),
            public_inputs_offset.into(),
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
        let (transcript, _) = ZKHonkTranscriptTrait::from_proof::<
            KeccakHasherState,
        >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, proof);
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
            libra_challenge: 0x63eab35a08e1f1d689e9f7459262d5,
            sum_check_u_challenges: array![
                0x40ed688108f7da1e1cdca9b2aa0f3685,
                0x6c68d78a0b032b5780954f1872cc68f7,
                0x7c60cf6eb247dd41326dd08a8901ef40,
                0x2daf230357393ead32a456d95fd763e9,
                0xba78ca461ade070f2ce981f0ea8062d0,
                0xbfa42d0dda20348bc857bc05151675eb,
                0xab1f19541c3b0bea03da77bb02b78b91,
                0xe90c852cfb7e2747525f575915a12846,
                0x26d81224c3f00aece2b527c778b3b4a7,
                0x7b7a33d669ac68671eebfdc3eec3e94e,
                0x29a38e8e192784bd2f44f13700ff8e33,
                0x7b7e00efef2a57aab6b54b0a27b791a3,
                0x76abdf0f84f75a33ee2af2743b1dcd95,
                0x94a051fbf991abd6cc1c4b57c563eaac,
                0x923f48c03b9c7b0943ab9558dbb9e5e2,
                0xc6cb53fae5e589b822b3d685566cdf02,
                0x91c907009a490d257f3971e009db5460,
                0xe35472445555403140312965b3f65b63,
                0xb70a77068e88c231ed0c950a8d170c6,
                0x8dfa50857f0393da457669337a2c3034,
                0x44c68ed573d8034b00d571cc788c3fc8,
                0xdc66203454894a9985be04a7ed55e0b3,
                0x4de49b0d8932c729743f8027d03243f8,
                0xa6af2e583ab03478a388704799c8343f,
                0xdbae4b11e5c1220d257f0a01c1afcdbf,
                0xb8454996ed721452124ee93606d8fb5b,
                0xb9d26200bbed96d14698c3de39d37098,
                0x488e0ae875ca2215e07f97a3f0c1f55b,
            ],
            rho: 0x1281a2504a5dc369040923303b80fc35,
            gemini_r: 0xc7d9e9bcdd7ac486057b675ef125232e,
            shplonk_nu: 0x927eda8dc9db0b14032f1894ee3f9d8f,
            shplonk_z: 0x40f148a10d3e8a8f25c9b517fabb6cdf,
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
        let (transcript, _) = ZKHonkTranscriptTrait::from_proof::<
            StarknetHasherState,
        >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, proof);
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
            libra_challenge: 0x360961945eebea443474af2f3f09c119,
            sum_check_u_challenges: array![
                0xfc8bb52433fb083c5d62f4757f6751a8,
                0x2ddab647c5be750670e2e66c165766da,
                0xfb2437fa0ef45cdcaa8f2499fef7a14e,
                0x79b746a1f37deff092c75299da5c0e9,
                0xba31f2d3a73a59307c7b1dfd9c4d0423,
                0x398a6564822145dfd6186b5ff5911db2,
                0xbb6527d509cbce2804939101117f6f43,
                0x6d60ed6d966a3776572248ac71e8fdd0,
                0x38bb886460cc1a86a112392a2955506c,
                0x25c2f78af6f3bb59b8aca2f0efc04312,
                0x13b790e78e535e6b0e1725ce1cd060,
                0x2c0a18c4589692c12bdaed35e6fe835,
                0x281ed459191d2bfc0ca873ccf96a3e1,
                0xbf33c6f5c7c6a080b43bc8d927f69892,
                0x9c917db1504deb2e0531ad936acf0197,
                0x65c5edd3cd5b2202b7ba25347c1cd627,
                0x26fe5d9bd1df64b4e470f449fb09eafd,
                0x8bf4fc3fc55cd245bf6e9bc9629039c8,
                0x7cab23221790f46f5ea66e97679347e0,
                0x1f2b97bd1ddff129297e303cf4f1e7f,
                0x3bf47f6fc1c3d5e47510fdd0d20e49fd,
                0x24cb01c417cd65f84d64e726193efb9,
                0x2a7b42ae652595aee492b7e13d45b820,
                0xa4fb9c5c2e05f6fbbef7719163e378f5,
                0x2c19791c0d67d3ecf654a4d9ad753923,
                0xc800be160cdaa9a1b92e86667fca116f,
                0xec79cecce9873f00ea5566e8259c06ad,
                0x2d7665e33950d7e46ccc98c2c75526f6,
            ],
            rho: 0xcce8fc730464235b2dfc00458d8eb0c4,
            gemini_r: 0xf3f1c40deddb9409b92540f3619dccf7,
            shplonk_nu: 0x73b5064cf60169304068138c5b007310,
            shplonk_z: 0x2603b0b2d745058ceb2f321af8b38188,
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
