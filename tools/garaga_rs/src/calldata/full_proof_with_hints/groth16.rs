// use crate::algebra::g1g2pair::G1G2Pair;
use crate::calldata::mpc_calldata::mpc_calldata_builder;
use crate::calldata::msm_calldata::msm_calldata_builder;
use crate::calldata::G1PointBigUint;
use crate::calldata::G2PointBigUint;
use crate::definitions::{
    BLS12381PrimeField, BN254PrimeField, CurveID, CurveParamsProvider, FieldElement,
};
use crate::io::{
    biguint_split, element_to_biguint, field_elements_from_big_uints,
    parse_g1_points_from_flattened_field_elements_list,
};
use lambdaworks_math::field::traits::IsPrimeField;
use lambdaworks_math::traits::ByteConversion;
use num_bigint::{BigInt, BigUint, Sign};

pub struct Groth16Proof {
    pub a: G1PointBigUint,
    pub b: G2PointBigUint,
    pub c: G1PointBigUint,
    pub public_inputs: Vec<BigUint>,
    pub image_id: Option<Vec<u8>>, // Only used for risc0 proofs
    pub journal: Option<Vec<u8>>,  // Only used for risc0 proofs
}

impl Groth16Proof {
    pub fn flatten(&self) -> Vec<BigUint> {
        let mut result = Vec::new();
        result.extend(self.a.flatten());
        result.extend(self.b.flatten());
        result.extend(self.c.flatten());
        result
    }

    pub fn from(values: Vec<BigUint>, image_id: Option<Vec<u8>>, journal: Option<Vec<u8>>) -> Self {
        let a = G1PointBigUint::from(values[0..2].to_vec());
        let b = G2PointBigUint::from(values[2..6].to_vec());
        let c = G1PointBigUint::from(values[6..8].to_vec());
        let public_inputs = values[8..].to_vec();
        Groth16Proof {
            a,
            b,
            c,
            public_inputs,
            image_id,
            journal,
        }
    }

    pub fn serialize_to_calldata(&self) -> Vec<BigUint> {
        let ints = self.flatten();
        let mut cd: Vec<BigUint> = vec![];

        let risc0_mode: bool = self.image_id.is_some() && self.journal.is_some();

        for int in ints {
            cd.extend(
                biguint_split::<4, 96>(&int)
                    .iter()
                    .map(|&x| BigUint::from(x)),
            );
        }

        //     if self.image_id and self.journal:
        //     # Risc0 mode.
        //     # Public inputs will be reconstructed from image id and journal.
        //     image_id_u256 = io.bigint_split(
        //         int.from_bytes(self.image_id, "big"), 8, 2**32
        //     )[::-1]
        //     journal = list(self.journal)
        //     # Span of u32, length 8.
        //     cd.append(8)
        //     cd.extend(image_id_u256)
        //     # Span of u8, length depends on input
        //     cd.append(len(self.journal))
        //     cd.extend(journal)
        // else:
        //     cd.append(len(self.public_inputs))
        //     for pub in self.public_inputs:
        //         cd.extend(io.bigint_split(pub, 2, 2**128))
        match risc0_mode {
            true => {
                let image_id_u256 = BigUint::from_bytes_be(self.image_id.as_ref().unwrap());
                let image_id_u256_split = biguint_split::<8, 32>(&image_id_u256).map(BigUint::from);
                let image_id_u256_split_reversed = image_id_u256_split.iter().rev().cloned();
                // Span of u32, length 8.
                cd.push(BigUint::from(8u64));
                cd.extend(image_id_u256_split_reversed);
                // Span of u8, length depends on input
                cd.push(BigUint::from(self.journal.as_ref().unwrap().len()));
                cd.extend(
                    self.journal
                        .as_ref()
                        .unwrap()
                        .iter()
                        .map(|&x| BigUint::from(x)),
                );
            }
            false => {
                cd.push(BigUint::from(self.public_inputs.len()));
                for pub_input in self.public_inputs.iter() {
                    cd.extend(biguint_split::<2, 128>(pub_input).map(BigUint::from));
                }
            }
        }
        cd
    }
}

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

pub fn get_groth16_calldata(
    proof: &Groth16Proof,
    vk: &Groth16VerificationKey,
    curve_id: CurveID,
    risc0_mode: bool,
) -> Result<Vec<BigUint>, String> {
    let mut calldata: Vec<BigUint> = Vec::new();

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
            true,
            false,
            true,
            false,
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
            true,
            false,
            true,
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
