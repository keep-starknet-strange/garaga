use core::keccak;
use core::traits::Into;
use garaga::definitions::G1Point;
use garaga::utils::noir::{HonkProof, G1Point256, G1PointProof};

const POW2_136: u256 = 0x10000000000000000000000000000000000;
const POW2_136_NZ: NonZero<u256> = 0x10000000000000000000000000000000000;
const Fr: u256 = 21888242871839275222246405745257275088548364400416034343698204186575808495617;

const NUMBER_OF_SUBRELATIONS: usize = 26;
const NUMBER_OF_ALPHAS: usize = NUMBER_OF_SUBRELATIONS - 1;
const CONST_PROOF_SIZE_LOG_N: usize = 28;
const BATCHED_RELATION_PARTIAL_LENGTH: usize = 8;
const NUMBER_OF_ENTITIES: usize = 44;


impl ProofPointIntoPoint256 of Into<G1PointProof, G1Point256> {
    fn into(self: G1PointProof) -> G1Point256 {
        G1Point256 { x: self.x0 + self.x1 * POW2_136, y: self.y0 + self.y1 * POW2_136, }
    }
}

impl Point256IntoProofPoint of Into<G1Point256, G1PointProof> {
    fn into(self: G1Point256) -> G1PointProof {
        let (x1, x0) = DivRem::div_rem(self.x, POW2_136_NZ);
        let (y1, y0) = DivRem::div_rem(self.y, POW2_136_NZ);
        G1PointProof { x0: x0, x1: x1, y0: y0, y1: y1 }
    }
}

impl ProofPointIntoCircuitPoint of Into<G1PointProof, G1Point> {
    fn into(self: G1PointProof) -> G1Point {
        let pt_256: G1Point256 = self.into();
        let pt: G1Point = G1Point { x: pt_256.x.into(), y: pt_256.y.into() };
        pt
    }
}

impl Point256IntoCircuitPoint of Into<G1Point256, G1Point> {
    fn into(self: G1Point256) -> G1Point {
        G1Point { x: self.x.into(), y: self.y.into() }
    }
}

#[derive(Drop, Debug)]
struct HonkTranscript {
    eta: u128,
    etaTwo: u128,
    etaThree: u128,
    beta: u128,
    gamma: u128,
    alphas: Array<u128>,
    gate_challenges: Array<u128>,
    sum_check_u_challenges: Array<u128>,
    rho: u128,
    gemini_r: u128,
    shplonk_nu: u128,
    shplonk_z: u128,
}

#[generate_trait]
impl HonkTranscriptImpl of HonkTranscriptTrait {
    fn from_proof(honk_proof: HonkProof) -> HonkTranscript {
        let (etas, challenge) = get_eta_challenges(
            honk_proof.circuit_size,
            honk_proof.public_inputs_size,
            honk_proof.public_inputs_offset,
            honk_proof.public_inputs,
            honk_proof.w1.into(),
            honk_proof.w2.into(),
            honk_proof.w3.into()
        );
        let beta_gamma = get_beta_gamma_challenges(
            challenge,
            honk_proof.lookup_read_counts.into(),
            honk_proof.lookup_read_tags.into(),
            honk_proof.w4.into()
        );
        let (alphas, challenge) = generate_alpha_challenges(
            beta_gamma, honk_proof.lookup_inverses.into(), honk_proof.z_perm.into()
        );
        let (gate_challenges, challenge) = generate_gate_challenges(challenge);

        let (sum_check_u_challenges, challenge) = generate_sumcheck_u_challenges(
            challenge, honk_proof.sumcheck_univariates
        );

        let rho = generate_rho_challenge(challenge, honk_proof.sumcheck_evaluations);
        let gemini_r = generate_gemini_r_challenge(rho, honk_proof.gemini_fold_comms);

        let shplonk_nu = generate_shplonk_nu_challenge(gemini_r, honk_proof.gemini_a_evaluations);
        let shplonk_z = generate_shplonk_z_challenge(shplonk_nu, honk_proof.shplonk_q.into());

        return HonkTranscript {
            eta: etas.eta,
            etaTwo: etas.eta2,
            etaThree: etas.eta3,
            beta: beta_gamma.low,
            gamma: beta_gamma.high,
            alphas: alphas,
            gate_challenges: gate_challenges,
            sum_check_u_challenges: sum_check_u_challenges,
            rho: rho.low,
            gemini_r: gemini_r.low,
            shplonk_nu: shplonk_nu.low,
            shplonk_z: shplonk_z.low,
        };
    }
}

#[cfg(test)]
mod tests {
    use super::{HonkProof, G1Point256, HonkTranscript, HonkTranscriptTrait};
    #[test]
    fn test_transcript() {
        let proof = HonkProof {
            circuit_size: 32,
            public_inputs_size: 1,
            public_inputs_offset: 1,
            public_inputs: array![0x2],
            w1: G1Point256 {
                x: 0x2465e9ff1629df572d7ae9fd1b9bd98946560392b669c03f9a4a496ae7e4cace,
                y: 0x17bce8fc74ab3b9430b6485da928ea6951ebee411689e29dc324843ee1708142
            },
            w2: G1Point256 {
                x: 0xeb93267e664634c1ae1a608b81785cfec11669ee95a1dbc6386717066310cb1,
                y: 0x23169272f91d323ced584549d31020c12f7cbf314c309c0ee105c3bbfef28399
            },
            w3: G1Point256 {
                x: 0xd394ffb5eb2d33c6a2540db125d27fb60665db10ae3f80d91eb189b318d7d58,
                y: 0xa325d606966d0ecbf514d787c3440de179ff8427f66be54fcabe05420fc14d0
            },
            w4: G1Point256 {
                x: 0xca7365a8a7d92bd713e8625cde47db105835a557cf68ce01414ede87a1ce97b,
                y: 0x26bf12dceab316d64651db4ea03663d3d9478d6ea9a1f20bbe215561e139c7f7
            },
            z_perm: G1Point256 {
                x: 0x69b493db1ad1bcb140505bc5a806d425af4e78b20794bc813a7669eba382a02,
                y: 0x2d6c35a33c91dd52432099ee20f87ed823919ed60347a56b4678b3a485e58197
            },
            lookup_read_counts: G1Point256 {
                x: 0xddfdbbdefc4ac1580ed38e12cfa490d9d719a8b9f020ad3642d60fe704e696f,
                y: 0xff3e0896bdea021253b3d360fa6788289fe9754ce48cd01b7be96a861b5e157
            },
            lookup_read_tags: G1Point256 {
                x: 0xddfdbbdefc4ac1580ed38e12cfa490d9d719a8b9f020ad3642d60fe704e696f,
                y: 0xff3e0896bdea021253b3d360fa6788289fe9754ce48cd01b7be96a861b5e157
            },
            lookup_inverses: G1Point256 {
                x: 0x1fad315eb3f489658734a3aff63bfb846255a077783e50444d60ac2b104b1ad4,
                y: 0x1067a4d8157c660c69e7022dd32ab0e30dd9987dae02f54e15edab896b9469a2
            },
            sumcheck_univariates: array![
                array![
                    0x285e5ff7d3c0d15f59c2761a965696bf749065fe4cac90b7c5310afb3df3b3b,
                    0x2dde687363f59313c2b41e54d81beef130eae1e894eea785c78ee4e43c20c4c6,
                    0x13c19d3e42c8b355492f1d756884dea3957b5bf6e2e8193ffb4e7fc3f158efc,
                    0x1e4d71cffdc20a5a19dd68d4cfe2cdf067a2aa1f44b89cecab6caaf55dae3417,
                    0x1907ec4e632967f4f16250f16fa97ec7c9e8d7b72fec50a60adf7f77e14fb1b5,
                    0x125582c3c04f25ef9b7c841edc3a461f112e792fed4296f2bcc67372e41bfaa3,
                    0x23f1075c04d207789c601197be8d38a22a11e5d035bce960f9dc69baa6af03c2,
                    0x12895dcc211378d9eb6614866aa0bb1a8cf720ee34451efcd92dc82c43504c13
                ]
                    .span(),
                array![
                    0x2280f8067080c8f83123f8d052b5a181c0a5f3baa905f42d4549057585e69821,
                    0x78dc17e403e81e7abb5353b62a897955e9596f56744cd931e7063f7937418d9,
                    0x1e2c998e66e78dbfb4bb9658d8637f618baf885995fbd76d7922cc4e26dba669,
                    0x262cd1b8fdc741c2073c3c669b12e6deac6705f6214410306a8ecc6bdbec8d71,
                    0x2228b8dca9925fee72e5587e58bafbd45947c386446f3bdb63c4e010d72a0e56,
                    0x2bda190568fdecabb525a7745c2d7d5242f264daeef67f932268e72b5adcf6d1,
                    0x4266918448a9ec8cac8f881c0bc1ba9c42959111b9f2991c93b169f38dca51a,
                    0x1150a038bbadb896d080e0158f85e7b0df710c1910a6503774bdcf08ef39a393
                ]
                    .span(),
                array![
                    0x92a9fd6fe59243760042ddcaf85dcf2c9268e52c5208d75cb9125b2daa42700,
                    0x123d711e98a50c8eef600161bc486d62069e13ad4d12064603d30e8f2d6e5265,
                    0x25b58d132934afdccc480a8c964e477b88cbafdf91370ee9b4b4a1cc2e4e1a8e,
                    0x1537803983a0459d1e3ed61aa59cbf0856a2a510df7901046b79a4257a9fcb30,
                    0x13c08cf9426d1e2f7e132e9c6e13e8b93b6905ccc539cb357e69e0f5d66ddfd7,
                    0x1f1cc54b85b64db929daf476a572212d852ad2e7666921e603bb50a1097c870f,
                    0x17cfeb6ab26a28116fe3d4b5156c1512223d86e3528cd667536f1c170a4cb755,
                    0x1610c336fc031be68c629c990e755afcbb43e7630726af1dfb32ff7de2a1f903
                ]
                    .span(),
                array![
                    0x78c2e9fcb11a9ff1dabdc022f77c29a52ff10e9bfc25a8e1c2f38eeb9a7b314,
                    0x24df74453b540fc68c0a5bd1c618d3ccf49e7513983cd8fd4cf0899ad5cef4e2,
                    0x252ed9cd7ef0d0e60aa1b3fed302a1314450edf6ebce5036cc81b5f21f166a35,
                    0x27b4ef390baa1c9773a170ac64b0dea0dfd02fbe3a43d8061e77c487ef097245,
                    0x25b39250035ebe1756ec1085919d0a90a973aafcdc1b4cc77844dc81c81f017e,
                    0x28b32ee8f4dd8c62de8140dd3730fc52de4abc0cab9289bceeffb1469484b318,
                    0x53b798117b11aee0c5bccfb2a8d926dd45c7b3f560f8d3133d42f4deab22d45,
                    0x9eacab815d72783fdf291121be7af695260916f8f9bd74b980317f9c6ff4cea
                ]
                    .span(),
                array![
                    0x22fd30a934d68c2b3d1763e038f5f41eaaefa2311abbe8e38f00a4edc500b322,
                    0x62e1857e2ed5546ce6ec7b4e2210329eb169f5695e3a04d48acf52f5359e55d,
                    0xba09b18683d296cf830d2da7515d381e431fe1ac792c3117007dd2e7ad8de35,
                    0x16bf0a5f2abce1fdc44461687d611ef8b4a2b538249fec1d8d32f25c3325ae4f,
                    0x90d1aabada01c6d1ef8e122169f88bc36d80462934ac786ed7f63568a815f72,
                    0x263a15eb7a5d4da20cd74bda64acd6bfd515fd57e001f571ee7f25dbbc819935,
                    0x1a6da135c8b1c95f0ebac3186421c4bf62c71f27fe9b2e34279afe65270e21a0,
                    0x2d928d40bc62836da72eadced3c96f846cf0440b939d746db2a987e41f8b7356
                ]
                    .span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span(),
                array![0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0].span()
            ]
                .span(),
            sumcheck_evaluations: array![
                0x1a06a87012710fd1c416ee0a81de014dc12da6bd44c812868d4d8d91705294f3,
                0x2012afa46741d05cb85c40093907abdb7574bf246de6693c0bcb500c024bed49,
                0x16d2dcca0c4c5dd38a1cbdf00f94cc0f41954ae8a21b2ef2bafb8007f380ef1,
                0x1d767c5dbac46ebf8a7013691ea0891882b5007674b35bbfde9cd4bc2e527a32,
                0x2072966d339011498d1331276eee58f2716229236f13d7ac10775b81a2c70271,
                0x29615adfdc896c3c4bc11a471fddea935de1dbcc34695acb83bc52c1535a1fc7,
                0x1cbd3abddb824aab725a3e87f5202aecf7a87932dd8cd8aa01e86841f2025a5b,
                0x2197c5a29e67ebce890221a058378114009b563c25a66c334de5a6f8dcc53094,
                0x109d8838a44b820b35b284797baa972b32ecac1e785c28bf6fd46f538ef657cb,
                0xc5ce9a7dba32f117596969c584075ba0be089b3179250b54b4de0f8b82306c9,
                0x136b79129f5cbbee2ac685099e0182bbf1b19d1a71ce8e1c988b096f63e63c9b,
                0x9ebda9fbb822762ed663d8f2900916556fd179eaaa9ea934b7e8a7d20e3e63b,
                0x219f37dedd2feb7e2fc8732ff3a4f9744a0ade748cc5ded5871788b08161f1ba,
                0x1cbe60346abb4bb1e5a18f5a3ae1bebb0131281bc771e514646801bcaaaa7b19,
                0x25c6182d057785e9974b649d809ba61f02f1b57f0285524f7fcfd846dae74449,
                0xec9d62836acb4405a03d4b6de597612ab38a7d4d7db95c84b63ac9fed6e8e64,
                0xb7c8f939f6fa71843efcea2c04a8039a8f7b8fdd6626709c4aa17ab385349d9,
                0x1654259afe3affe4832121f56a178087dbccabb19b86c25505a81befe75c45fe,
                0x172c26ec9dc7ba6a44a801982a38df0d66e7f0fba528d13f8044e081bc42b50f,
                0x28119325d0559d33e0ebd0d8a0da55ff95092c22605a33b36cf68b61d065f7b0,
                0xf8af0669a895c3c83d38e2a2d8d91df30,
                0xa30795ccb3a688c8fa73e641b6b9378c6b16ee60e343b7956d76425403ac5e7,
                0x2b0bb083ab6d90ddd5e5a21825f3a617262bc47aa93f52a20d3264284b311bb4,
                0x1eb2d76140d9256752ba21ef4ed4ee8ef021591a723b15889a1e188e2333f3a9,
                0x370704ed29ed5ba64b5690f3bac66b1fd991f58b9df2d5485c44a2880717ab2,
                0x26f2ff7fc2b01cef7d34571cf0e6c1efabb0f52fa3abc4e240ac5b74ec777aeb,
                0x2d545b9152db90404ecfaa00e4afe0d028f91370f587e97944335cf752030eea,
                0x182530062026dca5e7f8fae24ac91eefbaa64cadd9fd5ce77edb9a993aad6024,
                0x2334e657023ebe2d46fd71af9ca0d42089ae8b1b3025926e1e090e6425232ed4,
                0x4880bbfa8d664f43a1987a81d17c5346eb08bf4e2471146e1f501b38a6ef8a8,
                0x23426d30a8d4e7874c7835e9d8b5365bfc06a64aeea18fcedb89271b35a1b490,
                0x177ab630e0a4fb877db50b2a8a06e7dbc4b5ee690ed3276e50cdeb10c53fa882,
                0x1d288d5d4bb236954164d2db3bb053a79a18bdf2e29d1a0d148feba5e6807a9e,
                0x6ba070d3082e755a2f0477735bcd07d421b38db6babb576cac465d1524cccaf,
                0x6ba070d3082e755a2f0477735bcd07d421b38db6babb576cac465d1524cccaf,
                0x27c81bc615a22abf1fac518dd5e5989568a6c1a9e01c232dce80fcaae6d2483d,
                0x161ffed97d6de369ad85a1f0ece8a2b78c2ad4c18e3ce0aa68970a210fc8cdac,
                0xf4ab79878c744dc417e449d77d865f631040751c61751f26a5c47cc6103394c,
                0x104a5d1f1fcddce2daa6e7f1ab0c26493e2a01e32dedf0fb4fe5e1330eb8298f,
                0x185aa4d67dfc4877aea3c4019cdc087b504d06bdb54709c5a9e535e0a1001f6,
                0x13f4dbcb20e54a15649d2a911e55e4148fdfceb790222f87f2870ea0f2faea7a,
                0x182c615f4962dd5e9e2bcaa2148668c2967b30cbde78cdd953d5efa1ee7305e7,
                0x10e60eadf16da6ae5691b91f92bef89ba9c5a60574f6b23f8ac6fc39b0d73141,
                0x12cebf3da6a166ed7f43f707c64cb377f4cf76063f8c5afe9fb5a52c612e4cae
            ]
                .span(),
            gemini_fold_comms: array![
                G1Point256 {
                    x: 0x30f6ead299b812a9d0e34913e4897baa11cec4f4364333bd02c3ddb15b2796,
                    y: 0xe2c88de5ecff9e5e57f587f11a581f95e8311abc9cbc8b79f71f5043aa54178
                },
                G1Point256 {
                    x: 0x24c191be28e3c61bc03e45da0e82ef589a4e35476322229e437e049dbdf633a9,
                    y: 0x190ea556eee073ab057011ff249806fce345419ce1c38dc47e6eac312132d8c0
                },
                G1Point256 {
                    x: 0xdca2271951c15f10fe1bd6b142ae96d710cbe11e7f67b885ba8cf553f9b7a89,
                    y: 0x222d3b8adfc808eccc9b6be870295d686f2f78a47a20070faa67ac921a0d62ec
                },
                G1Point256 {
                    x: 0x3518fba7088a6f8103d8bc2f72a67a68cff759c9e8e70071a0c0d67a89bd684,
                    y: 0x2796e48e3909df2b389f68123329adb1994e35d6faad76671de81ead27b3bef0
                },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 },
                G1Point256 { x: 0x1, y: 0x2 }
            ]
                .span(),
            gemini_a_evaluations: array![
                0x6d88005bac7d50eaf47b0321f0075d0892f453254935ef79c503047f177ac3c,
                0x1f22b729740dcd28043721670fa5c3f6ec7c6e8f7150848eb590a57bb2c774a1,
                0x27af7bd3cb339be63a51d2305fc2ddf2c887b0a59511ec160aacec44308c9ffd,
                0x16368d4a8fc2dee62530847567ad8d75ecd96aaa541c487628f56c47c5bb1771,
                0xe405cd6caac953006162d7c72468986e014792ee1e09e041c69bea39def7c6d,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0,
                0x0
            ]
                .span(),
            shplonk_q: G1Point256 {
                x: 0x1e3ce2491c516e0e06eaa5dcad936bce2677c1867be2aeb5720375ffc79b6e21,
                y: 0xd1133764157bc108c1e4e201a02968887c77e16afdbb635b2729af6424c9e9e
            },
            kzg_quotient: G1Point256 {
                x: 0x1068dd1d211c8b30fdbfa561f69a4d062daa8998dd609fd7de22ed5babb86c4b,
                y: 0x216af708e0184bcac66514720a6bffaa7fee53f2f7ae34dc374df8ede0c3c09b
            },
        };

        let transcript = HonkTranscriptTrait::from_proof(proof);
        println!("{:?}", transcript);
    }
}


#[derive(Drop)]
struct Etas {
    eta: u128,
    eta2: u128,
    eta3: u128,
}

#[inline]
fn u64_byte_reverse(word: u64) -> u64 {
    (core::integer::u128_byte_reverse(word.into()) / 0x10000000000000000).try_into().unwrap()
}

#[inline]
fn u256_byte_reverse(word: u256) -> u256 {
    u256 {
        low: core::integer::u128_byte_reverse(word.high),
        high: core::integer::u128_byte_reverse(word.low)
    }
}


// Add u64 as u256 to keccak input
// Expects u64 big endian.
#[inline]
fn append_u64_as_u256(ref arr: Array<u64>, val: u64) {
    arr.append(0);
    arr.append(0);
    arr.append(0);
    arr.append(u64_byte_reverse(val));
}

#[inline]
fn append_proof_point(ref arr: Array<u64>, point: G1PointProof) {
    keccak::keccak_add_u256_be(ref arr, point.x0);
    keccak::keccak_add_u256_be(ref arr, point.x1);
    keccak::keccak_add_u256_be(ref arr, point.y0);
    keccak::keccak_add_u256_be(ref arr, point.y1);
}

// Keccak little endian output to big endian challenge.
// Converts to big endian, then takes modulo Fr.
fn ke_le_out_to_ch_be(ke_le_out: u256) -> u256 {
    let ke_be: u256 = u256_byte_reverse(ke_le_out);
    let ch_be: u256 = ke_be % Fr;
    ch_be
}

// Return eta and last keccak output
pub fn get_eta_challenges(
    circuit_size: u64,
    pub_inputs_size: u64,
    pub_inputs_offset: u64,
    pub_inputs: Array<u256>,
    w1: G1PointProof,
    w2: G1PointProof,
    w3: G1PointProof
) -> (Etas, u256) {
    let mut k_input: Array<u64> = array![];
    append_u64_as_u256(ref k_input, circuit_size);
    append_u64_as_u256(ref k_input, pub_inputs_size);
    append_u64_as_u256(ref k_input, pub_inputs_offset);
    for pub_i in pub_inputs {
        keccak::keccak_add_u256_be(ref k_input, pub_i);
    };
    append_proof_point(ref k_input, w1);
    append_proof_point(ref k_input, w2);
    append_proof_point(ref k_input, w3);

    let ke_out: u256 = keccak::cairo_keccak(
        ref k_input, last_input_word: 0, last_input_num_bytes: 0
    );
    let ch_be: u256 = ke_le_out_to_ch_be(ke_out);

    let mut k_input_2: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input_2, ch_be);

    let ke_out_2: u256 = keccak::cairo_keccak(
        ref k_input_2, last_input_word: 0, last_input_num_bytes: 0
    );

    let ch_2_be: u256 = ke_le_out_to_ch_be(ke_out_2);

    (Etas { eta: ch_be.low, eta2: ch_be.high, eta3: ch_2_be.low, }, ch_2_be,)
}


// Return beta, gamma, and last keccak output.
// Outut :
// ch_be.
// beta = ch_be.low, gamma = ch_be.high, last_keccak_output = ch_be.
pub fn get_beta_gamma_challenges(
    prev_keccak_output: u256,
    lookup_read_counts: G1PointProof,
    lookup_read_tags: G1PointProof,
    w4: G1PointProof,
) -> u256 {
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    append_proof_point(ref k_input, lookup_read_counts);
    append_proof_point(ref k_input, lookup_read_tags);
    append_proof_point(ref k_input, w4);

    let ke_out: u256 = keccak::cairo_keccak(
        ref k_input, last_input_word: 0, last_input_num_bytes: 0
    );
    let ch_be: u256 = ke_le_out_to_ch_be(ke_out);

    ch_be
}


pub fn generate_alpha_challenges(
    prev_keccak_output: u256, lookup_inverse: G1PointProof, z_perm: G1PointProof,
) -> (Array<u128>, u256) { // -> [u256; NUMBER_OF_ALPHAS]
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    append_proof_point(ref k_input, lookup_inverse);
    append_proof_point(ref k_input, z_perm);

    let mut alpha_XY: u256 = ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0)
    );

    let mut alphas: Array<u128> = array![];
    alphas.append(alpha_XY.low);
    alphas.append(alpha_XY.high);

    // Asumme N_alphas > 2 and N_alphas is odd.
    for _ in 1
        ..NUMBER_OF_ALPHAS
            / 2 {
                let mut k_input_i: Array<u64> = array![];
                keccak::keccak_add_u256_be(ref k_input_i, alpha_XY);
                let _alpha_XY: u256 = ke_le_out_to_ch_be(
                    keccak::cairo_keccak(ref k_input_i, last_input_word: 0, last_input_num_bytes: 0)
                );

                alphas.append(_alpha_XY.low);
                alphas.append(_alpha_XY.high);

                alpha_XY = _alpha_XY;
            };

    // Last alpha (odd number of alphas)

    let mut k_input_last: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input_last, alpha_XY);
    let alpha_last: u256 = ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input_last, last_input_word: 0, last_input_num_bytes: 0)
    );

    alphas.append(alpha_last.low);

    assert(alphas.len() == NUMBER_OF_ALPHAS, 'Wrong number of alphas');

    (alphas, alpha_last)
}


pub fn generate_gate_challenges(prev_keccak_output: u256,) -> (Array<u128>, u256) {
    let mut gate_challenges: Array<u128> = array![];

    let mut gate_challenge: u256 = prev_keccak_output;
    for _ in 0
        ..CONST_PROOF_SIZE_LOG_N {
            let mut k_input: Array<u64> = array![];
            keccak::keccak_add_u256_be(ref k_input, gate_challenge);
            let _gate_challenge: u256 = ke_le_out_to_ch_be(
                keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0)
            );
            gate_challenges.append(_gate_challenge.low);
            gate_challenges.append(_gate_challenge.high);
            gate_challenge = _gate_challenge;
        };

    (gate_challenges, gate_challenge)
}


pub fn generate_sumcheck_u_challenges(
    prev_keccak_output: u256, sumcheck_univariates: Span<Span<u256>>
) -> (Array<u128>, u256) {
    let mut sum_check_u_challenges: Array<u128> = array![];
    let mut challenge: u256 = prev_keccak_output;
    for i in 0
        ..CONST_PROOF_SIZE_LOG_N {
            let mut k_input: Array<u64> = array![];
            keccak::keccak_add_u256_be(ref k_input, challenge);
            for j in 0
                ..BATCHED_RELATION_PARTIAL_LENGTH {
                    keccak::keccak_add_u256_be(ref k_input, *(*sumcheck_univariates.at(i)).at(j));
                };

            challenge =
                ke_le_out_to_ch_be(
                    keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0)
                );
            sum_check_u_challenges.append(challenge.low);
            sum_check_u_challenges.append(challenge.high);
        };

    (sum_check_u_challenges, challenge)
}


pub fn generate_rho_challenge(prev_keccak_output: u256, sumcheck_evaluations: Span<u256>) -> u256 {
    // # Rho challenge :
    // hasher.update(ch4)
    // for i in range(NUMBER_OF_ENTITIES):
    //     hasher.update(int.to_bytes(proof.sumcheck_evaluations[i], 32, "big"))

    // c5 = hasher.digest_reset()
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    for i in 0
        ..NUMBER_OF_ENTITIES {
            keccak::keccak_add_u256_be(ref k_input, *sumcheck_evaluations.at(i));
        };

    ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0)
    )
}

pub fn generate_gemini_r_challenge(
    prev_keccak_output: u256, gemini_fold_comms: Span<G1Point256>
) -> u256 {
    // # Gemini R :
    // hasher.update(c5)
    // for i in range(CONST_PROOF_SIZE_LOG_N - 1):
    //     x0, x1, y0, y1 = g1_to_g1_proof_point(proof.gemini_fold_comms[i])
    //     hasher.update(int.to_bytes(x0, 32, "big"))
    //     hasher.update(int.to_bytes(x1, 32, "big"))
    //     hasher.update(int.to_bytes(y0, 32, "big"))
    //     hasher.update(int.to_bytes(y1, 32, "big"))

    // c6 = hasher.digest_reset()
    // gemini_r, _ = split_challenge(c6)

    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    for i in 0
        ..CONST_PROOF_SIZE_LOG_N
            - 1 {
                append_proof_point(ref k_input, (*gemini_fold_comms.at(i)).into());
            };

    ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0)
    )
}

pub fn generate_shplonk_nu_challenge(
    prev_keccak_output: u256, gemini_a_evaluations: Span<u256>
) -> u256 {
    // # Shplonk Nu :
    // hasher.update(c6)
    // for i in range(CONST_PROOF_SIZE_LOG_N):
    //     hasher.update(int.to_bytes(proof.gemini_a_evaluations[i], 32, "big"))

    // c7 = hasher.digest_reset()
    // shplonk_nu, _ = split_challenge(c7)

    // print(f"shplonk_nu: {hex(shplonk_nu)}")
    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    for i in 0
        ..CONST_PROOF_SIZE_LOG_N {
            keccak::keccak_add_u256_be(ref k_input, *gemini_a_evaluations.at(i));
        };

    ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0)
    )
}

pub fn generate_shplonk_z_challenge(prev_keccak_output: u256, shplonk_q: G1PointProof) -> u256 {
    // # Shplonk Z :
    // hasher.update(c7)
    // x0, x1, y0, y1 = g1_to_g1_proof_point(proof.shplonk_q)
    // hasher.update(int.to_bytes(x0, 32, "big"))
    // hasher.update(int.to_bytes(x1, 32, "big"))
    // hasher.update(int.to_bytes(y0, 32, "big"))
    // hasher.update(int.to_bytes(y1, 32, "big"))

    // c8 = hasher.digest_reset()
    // shplonk_z, _ = split_challenge(c8)

    let mut k_input: Array<u64> = array![];
    keccak::keccak_add_u256_be(ref k_input, prev_keccak_output);
    append_proof_point(ref k_input, shplonk_q);

    ke_le_out_to_ch_be(
        keccak::cairo_keccak(ref k_input, last_input_word: 0, last_input_num_bytes: 0)
    )
}

