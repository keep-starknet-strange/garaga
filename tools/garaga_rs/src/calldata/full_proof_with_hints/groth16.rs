// use crate::algebra::g1g2pair::G1G2Pair;
use crate::calldata::mpc_calldata::mpc_calldata_builder;
use crate::calldata::msm_calldata::msm_calldata_builder;
use crate::calldata::G1PointBigUint;
use crate::calldata::G2PointBigUint;
use crate::constants::{get_risc0_constants, SP1_VERIFIER_HASH, SP1_VERIFIER_VERSION};
use crate::definitions::{
    BLS12381PrimeField, BN254PrimeField, CurveID, CurveParamsProvider, FieldElement,
};
use crate::io::{
    biguint_split, element_to_biguint, field_elements_from_big_uints,
    parse_g1_points_from_flattened_field_elements_list,
};
use hex;
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::{BigInt, BigUint, Sign};
use num_traits::Num;
use sha2::{Digest, Sha256};
use starknet_types_core::felt::Felt;
pub struct Groth16Proof {
    pub a: G1PointBigUint,
    pub b: G2PointBigUint,
    pub c: G1PointBigUint,
    pub public_inputs: Vec<BigUint>,
    pub image_id_journal_risc0: Option<(Vec<u8>, Vec<u8>)>, // Only used for risc0 proofs
    pub vkey_public_values_sp1: Option<(Vec<u8>, Vec<u8>)>, // Only used for sp1 proofs
}

impl Groth16Proof {
    pub fn flatten(&self) -> Vec<BigUint> {
        let mut result = Vec::new();
        result.extend(self.a.flatten());
        result.extend(self.b.flatten());
        result.extend(self.c.flatten());
        result
    }

    pub fn from(
        values: Vec<BigUint>,
        image_id_journal_risc0: Option<(Vec<u8>, Vec<u8>)>,
        vkey_public_values_sp1: Option<(Vec<u8>, Vec<u8>)>,
    ) -> Self {
        let a = G1PointBigUint::from(values[0..2].to_vec());
        let b = G2PointBigUint::from(values[2..6].to_vec());
        let c = G1PointBigUint::from(values[6..8].to_vec());
        let public_inputs = values[8..].to_vec();
        Groth16Proof {
            a,
            b,
            c,
            public_inputs,
            image_id_journal_risc0,
            vkey_public_values_sp1,
        }
    }

    pub fn serialize_to_calldata(&self) -> Vec<BigUint> {
        let mut cd: Vec<BigUint> = vec![];

        // Serialize a.x, a.y, b.x[0], b.x[1], b.y[0], b.y[1], c.x, c.y directly
        // This matches the Python: cd.extend(io.bigint_split(self.a.x)) etc.
        for v in vec![
            &self.a.x, &self.a.y, &self.b.x0, &self.b.x1, &self.b.y0, &self.b.y1, &self.c.x,
            &self.c.y,
        ] {
            cd.extend(biguint_split::<4, 96>(v).iter().map(|&x| BigUint::from(x)));
        }

        let risc0_mode = self.image_id_journal_risc0.is_some();
        let _sp1_mode = self.vkey_public_values_sp1.is_some();

        if risc0_mode && !_sp1_mode {
            // Risc0 mode.
            // Public inputs will be reconstructed from image id and journal.
            let (image_id, journal) = self.image_id_journal_risc0.as_ref().unwrap();
            let image_id_u256 = BigUint::from_bytes_be(image_id);
            let image_id_u256_split = biguint_split::<8, 32>(&image_id_u256).map(BigUint::from);
            let image_id_u256_split_reversed: Vec<BigUint> =
                image_id_u256_split.iter().rev().cloned().collect();
            // Span of u32, length 8.
            cd.push(BigUint::from(8u64));
            cd.extend(image_id_u256_split_reversed);
            // Span of u8, length depends on input
            cd.push(BigUint::from(journal.len()));
            cd.extend(journal.iter().map(|&x| BigUint::from(x)));
        } else if _sp1_mode && !risc0_mode {
            // SP1 mode - matches Python implementation exactly
            let (_vkey, public_values) = self.vkey_public_values_sp1.as_ref().unwrap();

            // public_inputs[0] is the vkey as BigUint - serialize as 2 limbs of 128 bits
            // This matches Python: cd.extend(io.bigint_split(self.public_inputs[0], 2, 2**128))
            let vkey_int = &self.public_inputs[0]; // This should already be the vkey as BigUint
            let vkey_limbs = biguint_split::<2, 128>(vkey_int);
            cd.extend(vkey_limbs.iter().map(|&x| BigUint::from(x)));

            // Serialize public_values (public_inputs_sp1) as u32 array
            // This matches Python SP1 serialization exactly
            let n_bytes = public_values.len();
            assert_eq!(
                n_bytes % 32,
                0,
                "SP1 public inputs must be a multiple of 32 bytes"
            );
            let n_words = n_bytes / 32;

            // Add number of words first (matches Python: cd.append(n_words))
            cd.push(BigUint::from(n_words));

            // Then serialize as u32 values (matches Python: for i in range(0, n_bytes, 4): cd.append(int.from_bytes(...)))
            for i in (0..n_bytes).step_by(4) {
                let word = u32::from_be_bytes([
                    public_values[i],
                    public_values[i + 1],
                    public_values[i + 2],
                    public_values[i + 3],
                ]);
                cd.push(BigUint::from(word));
            }
        } else if risc0_mode && _sp1_mode {
            panic!("Cannot have both RISC0 and SP1 modes enabled");
        } else {
            // Normal mode.
            cd.push(BigUint::from(self.public_inputs.len()));
            for pub_input in &self.public_inputs {
                cd.extend(
                    biguint_split::<2, 128>(pub_input)
                        .iter()
                        .map(|&x| BigUint::from(x)),
                );
            }
        }

        cd
    }

    pub fn from_risc0(seal: Vec<u8>, image_id: Vec<u8>, journal: Vec<u8>) -> Self {
        assert!(image_id.len() <= 32, "image_id must be 32 bytes");

        let (control_root, bn254_control_id) = get_risc0_constants();

        let (control_root_0, control_root_1) = risc0_utils::split_digest(&control_root);

        let proof = &seal[4..];

        let mut hasher = Sha256::new();
        hasher.update(&journal);
        let journal_digest = hasher.finalize();

        let claim_digest = risc0_utils::ok_digest(&image_id, &journal_digest);
        let claim_digest_biguint = BigUint::from_bytes_be(&claim_digest);
        let (claim0, claim1) = risc0_utils::split_digest(&claim_digest_biguint);

        Groth16Proof {
            a: G1PointBigUint {
                x: BigUint::from_bytes_be(&proof[0..32]),
                y: BigUint::from_bytes_be(&proof[32..64]),
            },
            b: G2PointBigUint {
                x0: BigUint::from_bytes_be(&proof[96..128]),
                x1: BigUint::from_bytes_be(&proof[64..96]),
                y0: BigUint::from_bytes_be(&proof[160..192]),
                y1: BigUint::from_bytes_be(&proof[128..160]),
            },
            c: G1PointBigUint {
                x: BigUint::from_bytes_be(&proof[192..224]),
                y: BigUint::from_bytes_be(&proof[224..256]),
            },
            public_inputs: vec![
                control_root_0,
                control_root_1,
                claim0,
                claim1,
                bn254_control_id,
            ],
            image_id_journal_risc0: Some((image_id, journal)),
            vkey_public_values_sp1: None,
        }
    }
    pub fn from_sp1(vkey: Vec<u8>, public_values: Vec<u8>, proof: Vec<u8>) -> Self {
        // Skip the first 4 bytes (selector)
        let selector = &proof[..4];
        let proof = &proof[4..];

        // Validate SP1 verifier version by checking selector against expected hash
        let expected_selector = hex::decode(&SP1_VERIFIER_HASH[2..]).unwrap()[..4].to_vec();
        if selector != expected_selector {
            panic!(
                "Invalid SP1 proof version. Expected {:02x}{:02x}{:02x}{:02x} for version {}, got {:02x}{:02x}{:02x}{:02x}\nPlease use SP1 verifier version {} or contact garaga developers to update the SP1 verifier version.",
                expected_selector[0], expected_selector[1], expected_selector[2], expected_selector[3],
                SP1_VERIFIER_VERSION,
                selector[0], selector[1], selector[2], selector[3],
                SP1_VERIFIER_VERSION
            );
        }

        // sha256(public_values) % 2**253
        assert!(
            public_values.len() % 32 == 0,
            "public_values must be a multiple of 32 bytes"
        );
        let pub_input_hash = BigUint::from_bytes_be(&Sha256::digest(&public_values));
        // 2^253 as BigUint to avoid overflow
        let modulus = BigUint::from(2u64).pow(253);
        let pub_input_hash = pub_input_hash % modulus;

        let mut public_inputs_sp1 = Vec::new();
        for i in 0..public_values.len() / 32 {
            let public_input = BigUint::from_bytes_be(&public_values[i * 32..(i + 1) * 32]);
            public_inputs_sp1.push(public_input);
        }

        Groth16Proof {
            a: G1PointBigUint {
                x: BigUint::from_bytes_be(&proof[0..32]),
                y: BigUint::from_bytes_be(&proof[32..64]),
            },
            b: G2PointBigUint {
                x0: BigUint::from_bytes_be(&proof[96..128]),
                x1: BigUint::from_bytes_be(&proof[64..96]),
                y0: BigUint::from_bytes_be(&proof[160..192]),
                y1: BigUint::from_bytes_be(&proof[128..160]),
            },
            c: G1PointBigUint {
                x: BigUint::from_bytes_be(&proof[192..224]),
                y: BigUint::from_bytes_be(&proof[224..256]),
            },
            public_inputs: vec![BigUint::from_bytes_be(&vkey), pub_input_hash],
            image_id_journal_risc0: None,
            vkey_public_values_sp1: Some((vkey, public_values)),
        }
    }
}

#[derive(Debug, PartialEq)]
pub struct Groth16VerificationKey {
    pub alpha: G1PointBigUint,
    pub beta: G2PointBigUint,
    pub gamma: G2PointBigUint,
    pub delta: G2PointBigUint,
    pub ic: Vec<G1PointBigUint>,
}

impl Groth16VerificationKey {
    pub fn from(values: Vec<BigUint>) -> Self {
        let alpha = G1PointBigUint::from(values[0..2].to_vec());
        let beta = G2PointBigUint::from(values[2..6].to_vec());
        let gamma = G2PointBigUint::from(values[6..10].to_vec());
        let delta = G2PointBigUint::from(values[10..14].to_vec());
        let ic = values[14..]
            .chunks(2)
            .map(|chunk| G1PointBigUint::from(chunk.to_vec()))
            .collect();

        Groth16VerificationKey {
            alpha,
            beta,
            gamma,
            delta,
            ic,
        }
    }
}

pub fn get_sp1_vk() -> Groth16VerificationKey {
    let vk_hex = [
        "2d4d9aa7e302d9df41749d5507949d05dbea33fbb16c643b22f599a2be6df2e2",
        "14bedd503c37ceb061d8ec60209fe345ce89830a19230301f076caff004d1926",
        "e187847ad4c798374d0d6732bf501847dd68bc0e071241e0213bc7fc13db7ab",
        "967032fcbf776d1afc985f88877f182d38480a653f2decaa9794cbc3bf3060c",
        "1739c1b1a457a8c7313123d24d2f9192f896b7c63eea05a9d57f06547ad0cec8",
        "304cfbd1e08a704a99f5e847d93f8c3caafddec46b7a0d379da69a4d112346a7",
        "1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed",
        "198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2",
        "12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa",
        "90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b",
        "3ff41f4ba0c37fe2caf27354d28e4b8f83d3b76777a63b327d736bffb0122ed",
        "1cc7cb8de715675f21f01ecc9b46d236e0865e0cc020024521998269845f74e6",
        "17387b4b9cf03927909b4f1c3d80fcd6865afc4a264a04499f7e2f6df690dd85",
        "2ed3b19b5eb39db0d19a3d72dcd590ac85a971def614f4fd11b56b3c5e53c44c",
        "26091e1cafb0ad8a4ea0a694cd3743ebf524779233db734c451d28b58aa9758e",
        "9ff50a6b8b11c3ca6fdb2690a124f8ce25489fefa65a3e782e7ba70b66690e",
        "61c3fd0fd3da25d2607c227d090cca750ed36c6ec878755e537c1c48951fb4c",
        "fa17ae9c2033379df7b5c65eff0e107055e9a273e6119a212dd09eb51707219",
        "4eab241388a79817fe0e0e2ead0b2ec4ffdec51a16028dee020634fd129e71c",
        "7236256d21c60d02f0bdbf95cff83e03ea9e16fca56b18d5544b0889a65c1f5",
    ];

    Groth16VerificationKey::from(
        vk_hex
            .iter()
            .map(|s| BigUint::from_str_radix(s, 16).unwrap())
            .collect::<Vec<BigUint>>(),
    )
}

pub fn get_groth16_calldata_felt(
    proof: &Groth16Proof,
    vk: &Groth16VerificationKey,
    curve_id: CurveID,
) -> Result<Vec<Felt>, String> {
    let calldata = get_groth16_calldata(proof, vk, curve_id)?;

    Ok(calldata.into_iter().map(Felt::from).collect())
}

pub fn get_groth16_calldata(
    proof: &Groth16Proof,
    vk: &Groth16VerificationKey,
    curve_id: CurveID,
) -> Result<Vec<BigUint>, String> {
    let mut calldata: Vec<BigUint> = Vec::new();
    let risc0_mode = proof.image_id_journal_risc0.is_some();
    let _sp1_mode = proof.vkey_public_values_sp1.is_some();
    // Calculate vk_x
    let vk_x = calculate_vk_x(vk, &proof.public_inputs, curve_id);

    // MPC calldata
    let mut mpc_values: Vec<BigUint> = vec![];
    mpc_values.extend(vk_x.flatten());
    mpc_values.extend(vk.gamma.flatten());
    mpc_values.extend(proof.c.flatten());
    mpc_values.extend(vk.delta.flatten());
    mpc_values.extend(proof.a.neg(curve_id).flatten());
    mpc_values.extend(proof.b.flatten());

    let mut mpc_public_pair: Vec<BigUint> = vec![];
    mpc_public_pair.extend(vk.alpha.flatten());
    mpc_public_pair.extend(vk.beta.flatten());

    let mpc_calldata = mpc_calldata_builder(curve_id as usize, &mpc_values, 2, &mpc_public_pair)?;

    // MSM calldata
    let msm_calldata = match risc0_mode {
        false => msm_calldata_builder(
            &vk.ic
                .iter()
                .skip(1)
                .flat_map(|point| vec![point.x.clone(), point.y.clone()])
                .collect::<Vec<BigUint>>(),
            &proof.public_inputs,
            curve_id as usize,
            false,
            true,
        )?,
        true => msm_calldata_builder(
            &[
                vk.ic[3].x.clone(),
                vk.ic[3].y.clone(),
                vk.ic[4].x.clone(),
                vk.ic[4].y.clone(),
            ],
            &[
                proof.public_inputs[2].clone(),
                proof.public_inputs[3].clone(),
            ],
            curve_id as usize,
            false,
            true,
        )?,
    };

    calldata.push(BigUint::from(0u64)); // Len Placeholder.
    calldata.extend(proof.serialize_to_calldata());
    calldata.extend(mpc_calldata);
    calldata.extend(msm_calldata);

    // Update length
    calldata[0] = BigUint::from(calldata.len() - 1);

    Ok(calldata)
}

fn calculate_vk_x(
    vk: &Groth16VerificationKey,
    pub_inputs: &[BigUint],
    curve_id: CurveID,
) -> G1PointBigUint {
    match curve_id {
        CurveID::BN254 => vk_x_handle_curve::<BN254PrimeField>(vk, pub_inputs),
        CurveID::BLS12_381 => vk_x_handle_curve::<BLS12381PrimeField>(vk, pub_inputs),
        _ => panic!("Unsupported curve ID for vk_x"),
    }
}

fn vk_x_handle_curve<F>(vk: &Groth16VerificationKey, pub_inputs: &[BigUint]) -> G1PointBigUint
where
    F: IsPrimeField + CurveParamsProvider<F>,
    FieldElement<F>: ByteConversion,
{
    // Parse IC points from BigUint to FieldElement
    let ic_elements = field_elements_from_big_uints::<F>(
        &vk.ic
            .iter()
            .flat_map(|point| vec![point.x.clone(), point.y.clone()])
            .collect::<Vec<BigUint>>(),
    );
    let ic_points = parse_g1_points_from_flattened_field_elements_list(&ic_elements).unwrap();

    // Start with IC[0]
    let mut vk_x = ic_points[0].clone();

    // Compute IC[0] + pub_input_i * IC[i] for each public input
    for (i, pub_input) in pub_inputs.iter().enumerate() {
        let pub_input_bigint = BigInt::from_biguint(Sign::Plus, pub_input.clone());
        let scaled_ic = ic_points[i + 1].scalar_mul(pub_input_bigint);
        vk_x = vk_x.add(&scaled_ic);
    }

    // Convert G1Point back to G1PointBigUint
    G1PointBigUint {
        x: element_to_biguint(&vk_x.x),
        y: element_to_biguint(&vk_x.y),
    }
}

pub mod risc0_utils {
    use super::Groth16VerificationKey;
    use hex;
    use num_bigint::BigUint;
    use num_traits::Num;
    use sha2::{Digest, Sha256};

    pub fn get_risc0_vk() -> Groth16VerificationKey {
        let vk_hex = [
            "2d4d9aa7e302d9df41749d5507949d05dbea33fbb16c643b22f599a2be6df2e2",
            "14bedd503c37ceb061d8ec60209fe345ce89830a19230301f076caff004d1926",
            "e187847ad4c798374d0d6732bf501847dd68bc0e071241e0213bc7fc13db7ab",
            "967032fcbf776d1afc985f88877f182d38480a653f2decaa9794cbc3bf3060c",
            "1739c1b1a457a8c7313123d24d2f9192f896b7c63eea05a9d57f06547ad0cec8",
            "304cfbd1e08a704a99f5e847d93f8c3caafddec46b7a0d379da69a4d112346a7",
            "1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed",
            "198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2",
            "12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa",
            "90689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b",
            "1aa085ff28179a12d922dba0547057ccaae94b9d69cfaa4e60401fea7f3e0333",
            "3b03cd5effa95ac9bee94f1f5ef907157bda4812ccf0b4c91f42bb629f83a1c",
            "1e60f31fcbf757e837e867178318832d0b2d74d59e2fea1c7142df187d3fc6d3",
            "110c10134f200b19f6490846d518c9aea868366efb7228ca5c91d2940d030762",
            "12ac9a25dcd5e1a832a9061a082c15dd1d61aa9c4d553505739d0f5d65dc3be4",
            "25aa744581ebe7ad91731911c898569106ff5a2d30f3eee2b23c60ee980acd4",
            "707b920bc978c02f292fae2036e057be54294114ccc3c8769d883f688a1423f",
            "2e32a094b7589554f7bc357bf63481acd2d55555c203383782a4650787ff6642",
            "bca36e2cbe6394b3e249751853f961511011c7148e336f4fd974644850fc347",
            "2ede7c9acf48cf3a3729fa3d68714e2a8435d4fa6db8f7f409c153b1fcdf9b8b",
            "1b8af999dbfbb3927c091cc2aaf201e488cbacc3e2c6b6fb5a25f9112e04f2a7",
            "2b91a26aa92e1b6f5722949f192a81c850d586d81a60157f3e9cf04f679cccd6",
            "2b5f494ed674235b8ac1750bdfd5a7615f002d4a1dcefeddd06eda5a076ccd0d",
            "2fe520ad2020aab9cbba817fcbb9a863b8a76ff88f14f912c5e71665b2ad5e82",
            "f1c3c0d5d9da0fa03666843cde4e82e869ba5252fce3c25d5940320b1c4d493",
            "214bfcff74f425f6fe8c0d07b307482d8bc8bb2f3608f68287aa01bd0b69e809",
        ];

        Groth16VerificationKey::from(
            vk_hex
                .iter()
                .map(|s| BigUint::from_str_radix(s, 16).unwrap())
                .collect::<Vec<BigUint>>(),
        )
    }

    pub fn split_digest(digest: &BigUint) -> (BigUint, BigUint) {
        // Convert to bytes, ensure 32 bytes, and reverse
        let mut bytes = digest.to_bytes_be();
        bytes.resize(32, 0);
        bytes.reverse();

        // Split into two 128-bit parts
        let lower = BigUint::from_bytes_be(&bytes[0..16]);
        let upper = BigUint::from_bytes_be(&bytes[16..32]);

        (upper, lower)
    }

    struct ExitCode {
        system: u32,
        user: u32,
    }

    struct Output {
        journal_digest: Vec<u8>,
        assumptions_digest: Vec<u8>,
    }

    impl Output {
        fn digest(&self) -> Vec<u8> {
            let mut hasher = Sha256::new();
            hasher.update(Sha256::digest(b"risc0.Output"));
            hasher.update(&self.journal_digest);
            hasher.update(&self.assumptions_digest);
            hasher.update((2u16 << 8).to_be_bytes());
            hasher.finalize().to_vec()
        }
    }

    struct ReceiptClaim {
        pre_state_digest: Vec<u8>,
        post_state_digest: Vec<u8>,
        exit_code: ExitCode,
        input: Vec<u8>,
        output: Vec<u8>,
        tag_digest: Vec<u8>,
    }

    impl ReceiptClaim {
        fn digest(&self) -> Vec<u8> {
            let mut hasher = Sha256::new();
            hasher.update(&self.tag_digest);
            hasher.update(&self.input);
            hasher.update(&self.pre_state_digest);
            hasher.update(&self.post_state_digest);
            hasher.update(&self.output);
            hasher.update((self.exit_code.system << 24).to_be_bytes());
            hasher.update((self.exit_code.user << 24).to_be_bytes());
            hasher.update((4u16 << 8).to_be_bytes());
            hasher.finalize().to_vec()
        }
    }

    pub fn ok_digest(image_id: &[u8], journal_digest: &[u8]) -> Vec<u8> {
        let system_state_zero_digest =
            hex::decode("A3ACC27117418996340B84E5A90F3EF4C49D22C79E44AAD822EC9C313E1EB8E2")
                .unwrap();
        let output = Output {
            journal_digest: journal_digest.to_vec(),
            assumptions_digest: vec![0; 32],
        };
        let receipt_claim = ReceiptClaim {
            pre_state_digest: image_id.to_vec(),
            post_state_digest: system_state_zero_digest,
            exit_code: ExitCode { system: 0, user: 0 },
            input: vec![0; 32],
            output: output.digest(),
            tag_digest: Sha256::digest(b"risc0.ReceiptClaim").to_vec(),
        };
        receipt_claim.digest()
    }
}

#[cfg(test)]
mod test_groth16_calldata {
    use super::risc0_utils::{ok_digest, split_digest};
    use super::Groth16Proof;
    use hex;
    use num_bigint::BigUint;
    use num_traits::Num;
    use sha2::{Digest, Sha256};

    #[test]
    fn test_ok_digest_1() {
        let image_id = vec![
            0xd0, 0x1c, 0x15, 0xaf, 0xa7, 0x68, 0xa0, 0x5b, 0x21, 0x3a, 0x9e, 0x5f, 0xcd, 0xcc,
            0x57, 0x24, 0xa2, 0x94, 0x7e, 0x00, 0x09, 0x8c, 0x7e, 0xc3, 0x4c, 0xcb, 0xe2, 0x94,
            0x6b, 0xbc, 0x00, 0x13,
        ];
        let journal = vec![
            0x6a, 0x75, 0x73, 0x74, 0x20, 0x61, 0x20, 0x73, 0x69, 0x6d, 0x70, 0x6c, 0x65, 0x20,
            0x72, 0x65, 0x63, 0x65, 0x69, 0x70, 0x74,
        ];
        let journal_digest = Sha256::digest(&journal);
        let digest = ok_digest(&image_id, &journal_digest);

        let (claim0, claim1) = split_digest(&BigUint::from_bytes_be(&digest));
        assert_eq!(
            hex::encode(digest),
            "e58e40abecebcfa4af85692fca5ed77d4ccb4b3f640f5e684e4faf3a36b0c4e0"
        );

        assert_eq!(
            hex::encode(claim0.to_bytes_be()),
            "7dd75eca2f6985afa4cfebecab408ee5"
        );

        assert_eq!(
            hex::encode(claim1.to_bytes_be()),
            "e0c4b0363aaf4f4e685e0f643f4bcb4c"
        );
    }

    #[test]
    fn test_ok_digest_2() {
        let image_id = vec![
            0x07, 0x9f, 0x23, 0xf1, 0x3e, 0xa8, 0x1b, 0xde, 0x11, 0xa9, 0x49, 0x12, 0xba, 0xdf,
            0xe8, 0xd9, 0x2d, 0x5b, 0xe1, 0x13, 0x4b, 0x2c, 0x99, 0x1b, 0x99, 0x55, 0xe9, 0xc1,
            0x89, 0x41, 0xba, 0x69,
        ];

        let journal: Vec<u8> = vec![0x01, 0x00, 0x00, 0x78];
        let journal_digest = Sha256::digest(&journal);
        let digest = ok_digest(&image_id, &journal_digest);

        let (claim0, claim1) = split_digest(&BigUint::from_bytes_be(&digest));
        assert_eq!(
            hex::encode(claim0.to_bytes_be()),
            "d284212f0d87311c45e710301d86639f"
        );
        assert_eq!(
            hex::encode(claim1.to_bytes_be()),
            "8875bcad22cdcfda1e2878df4e414108"
        );
    }
    #[test]
    #[should_panic(expected = "Invalid SP1 proof version")]
    fn test_from_sp1_invalid_selector() {
        // Create test data with invalid selector (wrong first 4 bytes)
        let vkey = vec![0u8; 32];
        let public_values = vec![0u8; 64]; // Must be multiple of 32
        let mut proof = vec![0xde, 0xad, 0xbe, 0xef]; // Invalid selector
        proof.extend(vec![0u8; 252]); // Add remaining proof data

        // This should panic with our error message
        Groth16Proof::from_sp1(vkey, public_values, proof);
    }
}
