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
            libra_challenge: 0x598204f702f87d8fc603f6600b5ef0de,
            sum_check_u_challenges: array![
                0xab3ec2af03342be380645b89619edfe,
                0x2e3c173d4adfdeb980a6a795b2991b09,
                0x68609925c542d417935e3adcbc492b61,
                0xd34638414c3670bc5ce30f81a36e015a,
                0x122c6f508caa87731509c35bf3546661,
                0x8e627ef66a38cb04aec072a8f4056029,
                0xa4343d640a2ebc177c802393562ecb27,
                0x3c0b9e8c474680e92aa9a38001128b7f,
                0x192c055b1a7f90dd807eb2a7dc4503fd,
                0x802435d5412b620b52b71e140b063de9,
                0x85d1e0d5fd7cca37455bc89a4bd4dd3,
                0x73b4674a18f2988128472b4c942441f6,
                0xdd2a5b583602236696372fa0ba9eb261,
                0xab0206a98a0a917637ea54067a73a659,
                0xb4bca7151b0afe5b76e74482bcb85348,
                0x66738f92aa5d3963a1d8f6e4b804e2e,
                0x7d6cd25a271cc5ac9243d22947748b03,
                0x4ad4fd6df40360903baa64ac0d1a95c5,
                0x17ce9ae1618bfca4f54329efea603473,
                0x1517ab3a920e8e1e13377c221247e2f8,
                0x483b2beee5c8a6b649e0e222d42760f0,
                0xba9c2f282186486b64a338b22315be3b,
                0x5419ae5410fa6f5368b2201d74a491ae,
                0x38f8adc351c3a20a27fbe75ccc22cc98,
                0x9efdcb94d924f0cab24a49ef2373fbd7,
                0x70496657851f90e2ae013ff679471123,
                0x1be3eb4cbe7f815706c948161fa73469,
                0xde32e81425fc1ef4eb7786c3cad8a03e,
            ],
            rho: 0x7e4aa915e59b3f91b69480877a95f6db,
            gemini_r: 0x50034cfe34fd19c02422fe009adcc008,
            shplonk_nu: 0x83cb8a1eb02e6aab2d993324657867d3,
            shplonk_z: 0x30cb5fa4c72fad4c5330faa0de684144,
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
            libra_challenge: 0x52169b4628341a5c3208cf0ff8777c18,
            sum_check_u_challenges: array![
                0x35a1e4a4251666e5fd18b0ad272ad49f,
                0x4a64d6d4c3255eade89e021c3141ea9,
                0xc31ffd4e96dc4d43b9cb1bcf3dae41f5,
                0xb8d8772b269487bebd17bc53564bf6cb,
                0xad05584dd9299f0d9803c1cd5987020d,
                0xb9a10bfa98da994cab5641919eff3480,
                0x13ba696bec8d15b10020bc87f4415a21,
                0x46e4aa66eb2b548e56ec50e69e49dbbb,
                0xa6c0b21fd387214380b81210839d96c,
                0x20384a3cd9b016d2ca27f3b8d3f38008,
                0xdc8a5db28c6187fb2d7a1a04c28ca003,
                0xae29c4b46ee4ba277645e61a42b5fb88,
                0xb02da407a5743ac37ced2c98f635a060,
                0x23d5056870f7f3e6dc298de58ca96a67,
                0xe2d3a2a842c85b1043a13237175dc601,
                0x4c5f56e9412b548b9d09fa83577857f3,
                0xbe4001ceebe9dc03b3bda116667132e0,
                0x5790ac0035f1c073be1eedc7c37c50ac,
                0xd11966ba2db9bc30da910212706fa7ac,
                0xf33f811c90943120d28c59316975eb61,
                0x93561990f9064013ebc3c6945db8bf07,
                0x5918ed666bc77e67f72683e189a88782,
                0x92e50910ace797a6db21e6a28e269efa,
                0xc7fa815a37a2566499e780dbed6335dc,
                0xac3e1f5b058e2d0e705b26e2ba339445,
                0xb9292415a4ec031e2cbf79f5261a2ebf,
                0xd269d2cfdb7a6cf2a135d66c64628459,
                0x83396c49faf0f8a733521b935462d501,
            ],
            rho: 0xafc6b66605ac0ff2e3bb3092150eed59,
            gemini_r: 0x4ac02274c987e347a1112db9f6c547ae,
            shplonk_nu: 0xb13fa84dbc6b4ceb713a9c03960c8539,
            shplonk_z: 0xcb40314a4ebcc1a82fa0f3da915b0803,
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
