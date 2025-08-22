use core::poseidon::hades_permutation;
use corelib_imports::array::array_slice;
use garaga::utils::noir::honk_transcript::{
    CONST_PROOF_SIZE_LOG_N, IHasher, Point256IntoProofPoint, append_proof_point,
    generate_alpha_challenges, generate_gate_challenges, generate_gemini_r_challenge,
    generate_shplonk_z_challenge, get_beta_gamma_challenges, get_eta_challenges,
};
use garaga::utils::noir::{G1Point256, G1PointProof, ZKHonkProof};

const ZK_BATCHED_RELATION_PARTIAL_LENGTH: usize = 9;


#[derive(Drop, Debug, PartialEq)]
pub struct ZKHonkTranscript {
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
    ) -> (ZKHonkTranscript, felt252, felt252) {
        let (etas, challenge) = get_eta_challenges::<
            T,
        >(
            circuit_size.into(),
            public_inputs_size.into(),
            public_inputs_offset.into(),
            honk_proof.public_inputs,
            honk_proof.pairing_point_object,
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

        let (transcript_state, base_rlc, _) = hades_permutation(
            shplonk_z.low.into(), shplonk_z.high.into(), 2,
        );

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
            transcript_state,
            base_rlc,
        );
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
            sumcheck_univariates.into(),
            i * ZK_BATCHED_RELATION_PARTIAL_LENGTH,
            ZK_BATCHED_RELATION_PARTIAL_LENGTH,
        ) {
            Option::Some(slice) => {
                for j in 0..ZK_BATCHED_RELATION_PARTIAL_LENGTH {
                    hasher.update(*slice.at(j));
                };
            },
            Option::None => {
                for _ in 0..ZK_BATCHED_RELATION_PARTIAL_LENGTH {
                    hasher.update_0_256();
                };
            },
        }
        challenge = hasher.digest();
        sum_check_u_challenges.append(challenge.low);
    }

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
    for eval in sumcheck_evaluations {
        hasher.update(*eval);
    }

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
    }
    let implied_log_n = gemini_a_evaluations.len();
    for _ in 0..(CONST_PROOF_SIZE_LOG_N - implied_log_n) {
        hasher.update_0_256();
    }

    for eval in libra_poly_evals {
        hasher.update(*eval);
    }

    hasher.digest()
}

#[cfg(test)]
mod tests {
    use garaga::utils::noir::honk_transcript::{KeccakHasherState, StarknetHasherState};
    use garaga::utils::noir::{get_vk, get_zk_proof_keccak, get_zk_proof_starknet};
    use super::{ZKHonkTranscript, ZKHonkTranscriptTrait};
    #[test]
    fn test_zk_transcript_keccak() {
        let vk = get_vk();
        let proof = get_zk_proof_keccak();
        let (transcript, _, _) = ZKHonkTranscriptTrait::from_proof::<
            KeccakHasherState,
        >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, proof);
        let expected = ZKHonkTranscript {
            eta: 0x81449664406b2c544fd773a4d820db52,
            eta_two: 0x2aa005da0dd5ef1401e119b0b1f738f7,
            eta_three: 0x863462414ec04ca0e0e91a6c3965231e,
            beta: 0x604c278e0c72fbd86ef3e3bbde363865,
            gamma: 0x168ec02b631f05e16790ee12d21ed409,
            alphas: array![
                0x43cdce95650cbbaf5d05a35d89e9f8b1, 0x285c0bc95ad27412b868265c01ca8cb0,
                0x439c3b0dcd57faa630343a0a965a80fd, 0xc57a78fadeae1fcec46f33d75ed1d11,
                0x2ef3bc7fa63b03165c75c380a35fb19, 0xa0e6d6e24292f96198c1a1500385fb2,
                0x17f9843c502fb788369765f9717185dd, 0x1958333b88d7408e4617627257cc1d0a,
                0xf32ecd3da7d3c86f2a4ea2b4ab9a0022, 0x1820c5cf609718a7841ae88afa48e851,
                0x44dbd3e1d4873a7050afa40cfe13fcee, 0x2adb60f2bc264b3097a1b6c9c15e4a35,
                0x67ea19a0c938d09dbcf6ccee4310f30, 0x6db185b24f73846fc02424126873ab7,
                0x6d1d2ddd71a1b1b74d6046a4eb47c282, 0x15a787a3c268932902da57d72dfafa32,
                0xc92fe5683f7efbada5281436093184ad, 0xa8dee57b80b4cb6259943efcb4eea15,
                0x37e772c22cc2a5883c1598d41cb18ae2, 0x2de0e3e172f11a10393d87d50c61d305,
                0xca0db2bdc7bf2d859cc5e8337490aec7, 0x662870934a365a485c2862bb15ebdb1,
                0xc417e5ed715ab83f899c8733b9943597, 0xc4f1dd04940c562760fbba8637b9578,
                0x93cd537f1fd290456b0274b9e575104e,
            ],
            gate_challenges: array![
                0xc54ac7689f8e02c2cbb4988785ae01a6, 0x3eb182398d85b978ebe9920470abd918,
                0x36af4fd32bd3db26242f5e0737ef9d9f, 0x1d6da2346be625defa6c7a7bb0281b93,
                0x64c41e673f2c0839e7ba5f40b2a7e49b, 0xf76adf9dbe8b4a899f8b3317930f7c7,
                0xdac2a874b859e70d3c85cd3f8c130580, 0x3e5b5372c83c32e3930dbe4c1f7fa92b,
                0xfce1d6ad5724b43287b2fc361b1d52ed, 0x58e085988b3d64b1fc48b9a6afe56df3,
                0x4153739767440e25690378ccccd0366b, 0x3b60de8b83eb6a97ff86d29708320d14,
                0x8761e1ede5cac8aaa31371a286c55e5b, 0xe6c3b0924839ff646661503d95111ff9,
                0xd6ec57c9469f345d4ee0452249e043b, 0x94d70f26b3c407db1993caa0b94375aa,
                0x669fd20b75b303956696653fd0c63c2e, 0x1e8e8f719cf82d094883c59c5033a013,
                0x41b5272eb8c3ecd7bf58f002b350e064, 0x643a02941cd2e6886bc5cd2e8cfae79,
                0xcae4819c376bc3e7bc4b3c34a6297b, 0xc04db78015b9df15e81c484d746904df,
                0x4c8f5b55f5a209c95b254613edb1648b, 0x82ee6f9873f87adedd459719d4977663,
                0x1c3c7219527ac0bafb79ae6baf965f58, 0x38f1e341436f5793eb3476ab1d86bd9,
                0x8d593a1828e367d46e851b873bdd359a, 0x1efbdf8a646125fa35e2c706ac376971,
            ],
            libra_challenge: 0xec1a090b0551036db36b32ab47316157,
            sum_check_u_challenges: array![
                0x3cc66148723069fb715a841993968570, 0x2539bd02a161a66e1cc670969c553ce1,
                0x7aa5e5fd1dfe9a512b5ed65db9d0869b, 0x4fa1eb8e43adbf9cdd33dabe478d03cd,
                0xf9a8135831839cada2cd53ca7a8b24dd, 0xe506f65f731972e92d79ff5c97da536e,
                0xaf6b7611f95fe515ed769719839daebb, 0x3d31080da8849873e0783106d64dbc6e,
                0x2883a3df1f76fac7cf154111b8bb72e7, 0x3d05496bdba30917dba9e2276261ddd0,
                0xac808aed8b61c71e7fcb9f28a688f522, 0xd318d6cfc6967d0ac00c84825b5b6e70,
                0x45a760cf3329696d06ec6da2790c379b, 0xd5714bd3e98692abec31a9848cab3453,
                0xa4cd413191aeb00f5189173721d93134, 0x3adb2676522c5940bfcc68bc8b1113c5,
                0x741554cba7286dfa520502de76c85446, 0x5aac159c15ab0287fe9efee07b0c6317,
                0x5e39284ea6bfac2a36cb05b256a3593b, 0x8151167815589903be3fa9f280a423a9,
                0xd4769c4016c7957ef644e4db172d932, 0xc610b2134a07af81635b6260a1fbe0c8,
                0xc65b56754be777ef0a8d39304976ade8, 0xbbee22c61aa4d90c006a8be371892da9,
                0xc1512071f2cbc80559069948583b4cb6, 0xeceb644609a23058c9de4ec89d48879a,
                0xed3c4cd83cdc6c8a552a908f0b89f3a0, 0xf9068da7f03c434c99c01a6620eebb0d,
            ],
            rho: 0x7093345debc86591c0ddd38f05e319e6,
            gemini_r: 0x2c8c5ab488a2786d3528cab25ea68ee3,
            shplonk_nu: 0x91131986da7376a7e92bbaaf704af7d,
            shplonk_z: 0x101b2dcbe22a6b9eb8487c24aad27d27,
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
        let (transcript, _, _) = ZKHonkTranscriptTrait::from_proof::<
            StarknetHasherState,
        >(vk.circuit_size, vk.public_inputs_size, vk.public_inputs_offset, proof);
        let expected = ZKHonkTranscript {
            eta: 0x3494d04286117bd3d2a7f31a40eea13c,
            eta_two: 0x466fc6f88a7eaa2e18ed92dac08db33,
            eta_three: 0x9cab832ea7155194d1bc3d034c220857,
            beta: 0x19e1faa49da5288b8fba6b593c434386,
            gamma: 0x27558ea5018881cc59eb43be5c76cf7,
            alphas: array![
                0xda216e4cfc4c58f7e066034b500919d, 0x72e6c973202be62eb45f496c2af46cb,
                0xbc1e7ecced3a6deccb4641ae7147d965, 0x65fe48931ac0706e1a73da5eb6ef752,
                0xc5d2bb8fbb9dac07b3bf806b3a674744, 0x3f8818ba2afa50cd4edc115e626637,
                0x9589c0884a1b61c5f37985ad35ae41cc, 0x321e8a9695b204ad301ad855a030a2c,
                0xac6da9a6272e04283433263af51d6591, 0x3681445b28d8724e7f47733ba3df2b6,
                0xcd326a2ca4daffa8481692b1043860dd, 0x49f17ad0cdabad239e90c49e9bba1e1,
                0xee5b079861cc905b773ea51cf5139ace, 0x4c7477d2db0b0d73f49854d369845c4,
                0x47582ae8db8b430565abca17ec0432cd, 0x32dfe5ee3eb5b66c9cb1c53a22339d6,
                0x633a8443499f12de84fcc44048090c4e, 0x7ec199a25fd5fc4828bf62fba7362f4,
                0xb6d5c2bad6f04ea1587b4967ea220efc, 0x467ac87f31970edca9c0a4854531263,
                0xa7d071eace90d6a6325fef2c1963ea5b, 0x2435ce21fb4336b340581549360bce4,
                0x5d4e2c655b1bdc56931456e71542bfb, 0x2880fc73a5a84f26ab5f083d21a36f5,
                0x23ca39f5f2df5cdd31099903be4db840,
            ],
            gate_challenges: array![
                0x6167253d591e8fe360dc1321447f62ed, 0xa98abc953f197e1d8f36902a4c94f0cd,
                0x97b5c95a191570820727e0d328db2763, 0x336b7f7e0e1eccdabbf9ea0c15fd8fbd,
                0xf573e2044d7708775501acb99f1cb3f4, 0x5f7d0d85411ba70b9b2a223e424ef1c9,
                0x6c6b38a3187f69e1dc5fa0c7a40f93a9, 0x4ea6c30bf37ac476d6efd5f691dfa930,
                0x50b0340617f3f988cb806c51a0715a91, 0xe9d37b5b3538901b2b50fb9a3ff7324a,
                0x3078d9eb37b713200320380364e24f4d, 0x1bf7af9d47fc40c9d8d2f4ef6c508a18,
                0x1b9d23edc492dd50ad622da0bf765235, 0x8a0379a4eee27c098cb150d8859336eb,
                0xe2ee6031f632ff410c81eb01ddf86ef5, 0x6f5386dcc08a01b1ce8e3912000702ff,
                0x3eccb7b8d8fb40ce0460ed6dd7d90141, 0x37e4be1e9c28eaf5793c61fbb4e8180,
                0x6fffbae69eefed06cdd09b4378913cf1, 0xde2abfa08b258e1609e516e0bbfea711,
                0x3c10c916843f54ae85279bbcec017bd0, 0xa119f037d7e6a52219b25b1ce0d659,
                0x48557c402d02a5596c67e3392fa2ab4c, 0x1a0088f6071f5e047dc79d7f8877f3ed,
                0x9a3979d0d6ed696fde562397dd023ccf, 0xc2baf82b8310ebfc21f0aa02c178504f,
                0xc3e49b4272d1568c00531a31ddfd8bab, 0x8b9cf8b386acd6d1177a87da69770435,
            ],
            libra_challenge: 0xd75efeedfd81a67a824351fee06672fe,
            sum_check_u_challenges: array![
                0xb75656021800f7d6bcca27d9db19f141, 0x2c04045e83b6f0ace217edc84f7bca1f,
                0x7156aa2e695d9e679cd36a4a2a3a2e95, 0xf13d2e858fb41a2073ed80b49fb770f4,
                0xf1e9dfcf921063ab098e3b354cac2475, 0x6d1a2ccdb1ef5258ed51a53e4b68a4a7,
                0x2db7927e3e0fa46fae1080c5aab69b90, 0x754afc141116312d601c833696109423,
                0x8e553b62e41205001b2d88e1ede3d6ab, 0x489b16a8052d7b7136f087349d64c69e,
                0x876c3c9c810a1f97dec7e677700d5953, 0xd10eb6555cbf1b5177b3b2a0fdaa7cc0,
                0xd728de66bc3a1a7ab7f52f288d789ab7, 0x8658542086776b6b3fb369cd1b6ed81d,
                0x334ab5dc8eb73056297b3b0fd9ce0b0b, 0xfb8c133166975a6c16ba410779701dbe,
                0xb37332a3e36713a3b6d76d052de107d6, 0x9366887d233750cbf807e603c55da589,
                0xa77f00e55ac39c306f85e27c74409f4a, 0x8916299dcbf0951e9b288567be1a4c8a,
                0xb9d9a254647b85de9b19a8261c37c555, 0x7d7b8ad4175c4224340d76d2073bc841,
                0xe898a0a26a81c5cd4652ed524c2fe702, 0x823108dccd289ac5254185cfdd481be9,
                0xb3cc67c507cf42a78c8bc0f6ef5ae85e, 0xb0b06482b82a623d975939cbc6c3d1f,
                0xdad40452d9ed0ac441f0058f106e04f4, 0x465b46e7ab7eb59a91e7edbc572677fb,
            ],
            rho: 0x2367a84cb8103878f268a39831d2639d,
            gemini_r: 0x4f947062d6a56e85ef152432bc5c876c,
            shplonk_nu: 0x61e58e5f8e3514e06d2bb6033759b5c,
            shplonk_z: 0xdf551a3043bf10175684e0023d1ebad2,
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
