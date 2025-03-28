use crate::calldata::full_proof_with_hints::groth16;
use crate::calldata::full_proof_with_hints::groth16::{Groth16Proof, Groth16VerificationKey};
use crate::calldata::full_proof_with_hints::honk;
use crate::calldata::full_proof_with_hints::honk::{HonkFlavor, HonkProof, HonkVerificationKey};
use crate::calldata::full_proof_with_hints::zk_honk;
use crate::calldata::full_proof_with_hints::zk_honk::ZKHonkProof;
use crate::calldata::{G1PointBigUint, G2PointBigUint};
use crate::crypto::poseidon_bn254::poseidon_hash_bn254;
use crate::definitions::CurveID;
use crate::definitions::{
    GrumpkinPrimeField, ToTwistedEdwardsCurve, ToWeierstrassCurve, X25519PrimeField,
};
use crate::io::{element_from_biguint, element_to_biguint};
use js_sys::{Array, Uint8Array};
use num_bigint::BigUint;
use num_traits::Num;
use wasm_bindgen::prelude::*; // Import the Num trait

#[wasm_bindgen]
pub fn msm_calldata_builder(
    values: Vec<JsValue>,
    scalars: Vec<JsValue>,
    curve_id: usize,
    include_digits_decomposition: bool,
    include_points_and_scalars: bool,
    serialize_as_pure_felt252_array: bool,
    risc0_mode: bool,
) -> Result<Vec<JsValue>, JsValue> {
    let values: Vec<BigUint> = values
        .into_iter()
        .map(jsvalue_to_biguint)
        .collect::<Result<Vec<_>, _>>()?;
    let scalars: Vec<BigUint> = scalars
        .into_iter()
        .map(jsvalue_to_biguint)
        .collect::<Result<Vec<_>, _>>()?;

    // Ensure msm_calldata_builder returns a Result type
    let result = crate::calldata::msm_calldata::msm_calldata_builder(
        &values,
        &scalars,
        curve_id,
        Some(include_digits_decomposition),
        include_points_and_scalars,
        serialize_as_pure_felt252_array,
        risc0_mode,
    )
    .map_err(|e| JsValue::from_str(&e.to_string()))?; // Handle error here

    let result: Vec<BigUint> = result; // Ensure result is of type Vec<BigUint>

    Ok(result.into_iter().map(biguint_to_jsvalue).collect())
}

#[wasm_bindgen]
pub fn mpc_calldata_builder(
    curve_id: usize,
    values1: Vec<JsValue>,
    n_fixed_g2: usize,
    values2: Vec<JsValue>,
) -> Result<Vec<JsValue>, JsValue> {
    let values1: Vec<BigUint> = values1
        .into_iter()
        .map(jsvalue_to_biguint)
        .collect::<Result<Vec<_>, _>>()?;
    let values2: Vec<BigUint> = values2
        .into_iter()
        .map(jsvalue_to_biguint)
        .collect::<Result<Vec<_>, _>>()?;

    // Ensure msm_calldata_builder returns a Result type
    let result = crate::calldata::mpc_calldata::mpc_calldata_builder(
        curve_id, &values1, n_fixed_g2, &values2,
    )
    .map_err(|e| JsValue::from_str(&e.to_string()))?; // Handle error here

    let result: Vec<BigUint> = result; // Ensure result is of type Vec<BigUint>

    Ok(result.into_iter().map(biguint_to_jsvalue).collect())
}

#[wasm_bindgen]
pub fn schnorr_calldata_builder(
    rx: JsValue,
    s: JsValue,
    e: JsValue,
    px: JsValue,
    py: JsValue,
    curve_id: usize,
) -> Result<Vec<JsValue>, JsValue> {
    let rx: BigUint = jsvalue_to_biguint(rx)?;
    let s: BigUint = jsvalue_to_biguint(s)?;
    let e: BigUint = jsvalue_to_biguint(e)?;
    let px: BigUint = jsvalue_to_biguint(px)?;
    let py: BigUint = jsvalue_to_biguint(py)?;

    let result = crate::calldata::signatures::schnorr_calldata_builder(rx, s, e, px, py, curve_id)
        .map_err(|e| JsValue::from_str(&e.to_string()))?; // Handle error here

    let result: Vec<BigUint> = result; // Ensure result is of type Vec<BigUint>

    Ok(result.into_iter().map(biguint_to_jsvalue).collect())
}

#[wasm_bindgen]
pub fn ecdsa_calldata_builder(
    r: JsValue,
    s: JsValue,
    v: usize,
    px: JsValue,
    py: JsValue,
    z: JsValue,
    curve_id: usize,
) -> Result<Vec<JsValue>, JsValue> {
    let r: BigUint = jsvalue_to_biguint(r)?;
    let s: BigUint = jsvalue_to_biguint(s)?;
    let v: u8 = v
        .try_into()
        .map_err(|_| JsValue::from_str("Failed to convert value to u8"))?;
    let px: BigUint = jsvalue_to_biguint(px)?;
    let py: BigUint = jsvalue_to_biguint(py)?;
    let z: BigUint = jsvalue_to_biguint(z)?;

    let result = crate::calldata::signatures::ecdsa_calldata_builder(r, s, v, px, py, z, curve_id)
        .map_err(|e| JsValue::from_str(&e.to_string()))?; // Handle error here

    let result: Vec<BigUint> = result; // Ensure result is of type Vec<BigUint>

    Ok(result.into_iter().map(biguint_to_jsvalue).collect())
}

#[wasm_bindgen]
pub fn eddsa_calldata_builder(
    ry_twisted: JsValue,
    s: JsValue,
    py_twisted: JsValue,
    msg: JsValue,
) -> Result<Vec<JsValue>, JsValue> {
    let r: BigUint = jsvalue_to_biguint(ry_twisted)?;
    let s: BigUint = jsvalue_to_biguint(s)?;
    let py: BigUint = jsvalue_to_biguint(py_twisted)?;
    let msg: Vec<u8> = msg.dyn_into::<Uint8Array>().map(|arr| arr.to_vec())?;

    let result = crate::calldata::signatures::eddsa_calldata_builder(r, s, py, msg)
        .map_err(|e| JsValue::from_str(&e.to_string()))?; // Handle error here

    let result: Vec<BigUint> = result; // Ensure result is of type Vec<BigUint>

    Ok(result.into_iter().map(biguint_to_jsvalue).collect())
}

fn jsvalue_to_biguint(v: JsValue) -> Result<BigUint, JsValue> {
    let s = (JsValue::from_str("") + v)
        .as_string()
        .ok_or_else(|| JsValue::from_str("Failed to convert JsValue to string"))?;

    let (number_str, radix) = if s.starts_with("0x") || s.starts_with("0X") {
        // It's a hexadecimal string; remove the '0x' prefix
        (&s[2..], 16)
    } else {
        // Assume it's a decimal string
        (s.as_str(), 10)
    };
    BigUint::from_str_radix(number_str, radix)
        .map_err(|_| JsValue::from_str("Failed to convert string to BigUint"))
}

fn biguint_to_jsvalue(v: BigUint) -> JsValue {
    JsValue::bigint_from_str(&v.to_string())
}
// Helper function to get a property from an object
fn get_property(obj: &js_sys::Object, key: &str) -> Result<JsValue, JsValue> {
    js_sys::Reflect::get(obj, &JsValue::from_str(key))
}

fn set_property(obj: &js_sys::Object, key: &str, value: &JsValue) -> Result<(), JsValue> {
    let success = js_sys::Reflect::set(obj, &JsValue::from_str(key), value)?;
    if !success {
        return Err(JsValue::from_str(&format!(
            "Failed to set property: {}",
            key
        )));
    }
    Ok(())
}

// Parsing helper for G1PointBigUint
fn parse_g1_point(value: JsValue) -> Result<G1PointBigUint, JsValue> {
    let obj = value
        .dyn_into::<js_sys::Object>()
        .map_err(|_| JsValue::from_str("Failed to parse G1PointBigUint"))?;

    let x = jsvalue_to_biguint(get_property(&obj, "x")?)?;

    let y = jsvalue_to_biguint(get_property(&obj, "y")?)?;

    Ok(G1PointBigUint { x, y })
}

fn jsvalue_from_g1_point(point: &G1PointBigUint, curve_id: usize) -> Result<JsValue, JsValue> {
    let point_obj = js_sys::Object::new();
    set_property(&point_obj, "x", &biguint_to_jsvalue(point.x.clone()))?;
    set_property(&point_obj, "y", &biguint_to_jsvalue(point.y.clone()))?;
    set_property(&point_obj, "curveId", &curve_id.into())?;
    Ok(point_obj.into())
}

// Parsing helper for G2PointBigUint
fn parse_g2_point(value: JsValue) -> Result<G2PointBigUint, JsValue> {
    let obj = value
        .dyn_into::<js_sys::Object>()
        .map_err(|_| JsValue::from_str("Failed to parse G2PointBigUint"))?;
    let x_tuple = get_property(&obj, "x")?
        .dyn_into::<Array>()
        .map_err(|_| JsValue::from_str("x is not an array"))?;
    let y_tuple = get_property(&obj, "y")?
        .dyn_into::<Array>()
        .map_err(|_| JsValue::from_str("y is not an array"))?;

    let x0 = jsvalue_to_biguint(x_tuple.get(0))?;
    let x1 = jsvalue_to_biguint(x_tuple.get(1))?;

    let y0 = jsvalue_to_biguint(y_tuple.get(0))?;
    let y1 = jsvalue_to_biguint(y_tuple.get(1))?;

    Ok(G2PointBigUint { x0, x1, y0, y1 })
}

// Parsing helper for an array of BigUint
fn parse_biguint_array(value: JsValue) -> Result<Vec<BigUint>, JsValue> {
    let array = value
        .dyn_into::<Array>()
        .map_err(|_| JsValue::from_str("public_inputs is not an array"))?;

    array
        .iter()
        .map(|v| {
            // let s = v
            //     .as_string()
            //     .ok_or_else(|| JsValue::from_str("public_inputs element is not a string"))?;

            // Parse the string into BigUint using the helper function
            jsvalue_to_biguint(v)
        })
        .collect()
}

fn jsvalue_from_biguint_array(values: &[BigUint]) -> Result<JsValue, JsValue> {
    let values = values
        .iter()
        .cloned()
        .map(biguint_to_jsvalue)
        .collect::<Vec<_>>();
    Ok(values.into())
}

// Parses an array of G1 points from JsValue
fn parse_g1_point_array(value: JsValue) -> Result<Vec<G1PointBigUint>, JsValue> {
    let array = value
        .dyn_into::<Array>()
        .map_err(|_| JsValue::from_str("ic is not an array"))?;
    let mut points = Vec::new();
    for i in 0..array.length() {
        let point = parse_g1_point(array.get(i))?;
        points.push(point);
    }
    Ok(points)
}

fn jsvalue_from_g1_point_array(
    points: &[G1PointBigUint],
    curve_id: usize,
) -> Result<JsValue, JsValue> {
    let points = points
        .iter()
        .map(|point| jsvalue_from_g1_point(point, curve_id))
        .collect::<Result<Vec<_>, _>>()?;
    Ok(points.into())
}

// Optional parsing helper for Uint8Array
fn parse_optional_uint8_array(value: JsValue) -> Option<Vec<u8>> {
    value.dyn_into::<Uint8Array>().ok().map(|arr| arr.to_vec())
}

#[wasm_bindgen]
pub fn to_weirstrass(x_twisted: JsValue, y_twisted: JsValue) -> Result<Vec<JsValue>, JsValue> {
    let x_twisted_biguint = jsvalue_to_biguint(x_twisted).unwrap();
    let x_twisted = element_from_biguint::<X25519PrimeField>(&x_twisted_biguint);

    let y_twisted_biguint = jsvalue_to_biguint(y_twisted).unwrap();
    let y_twisted = element_from_biguint::<X25519PrimeField>(&y_twisted_biguint);

    let result = crate::definitions::X25519PrimeField::to_weirstrass(x_twisted, y_twisted);

    let x_weirstrass = element_to_biguint::<X25519PrimeField>(&result.0);
    let y_weirstrass = element_to_biguint::<X25519PrimeField>(&result.1);

    let result = vec![
        biguint_to_jsvalue(x_weirstrass),
        biguint_to_jsvalue(y_weirstrass),
    ];

    Ok(result)
}

#[wasm_bindgen]
pub fn to_twistededwards(
    x_weirstrass: JsValue,
    y_weirstrass: JsValue,
) -> Result<Vec<JsValue>, JsValue> {
    let x_weirstrass_biguint = jsvalue_to_biguint(x_weirstrass).unwrap();
    let x_weirstrass = element_from_biguint::<X25519PrimeField>(&x_weirstrass_biguint);

    let y_weirstrass_biguint = jsvalue_to_biguint(y_weirstrass).unwrap();
    let y_weirstrass = element_from_biguint::<X25519PrimeField>(&y_weirstrass_biguint);

    let result =
        crate::definitions::X25519PrimeField::to_twistededwards(x_weirstrass, y_weirstrass);

    let x_twisted = element_to_biguint::<X25519PrimeField>(&result.0);
    let y_twisted = element_to_biguint::<X25519PrimeField>(&result.1);

    let result = vec![biguint_to_jsvalue(x_twisted), biguint_to_jsvalue(y_twisted)];

    Ok(result)
}

#[wasm_bindgen]
pub fn get_groth16_calldata(
    proof_js: JsValue,
    vk_js: JsValue,
    curve_id_js: JsValue,
) -> Result<Vec<JsValue>, JsValue> {
    let proof_obj = proof_js
        .dyn_into::<js_sys::Object>()
        .map_err(|_| JsValue::from_str("proof_js is not an object"))?;
    let property = get_property(&proof_obj, "a")?;

    let a = parse_g1_point(property)?;
    let b = parse_g2_point(get_property(&proof_obj, "b")?)?;
    let c = parse_g1_point(get_property(&proof_obj, "c")?)?;

    let public_inputs = parse_biguint_array(get_property(&proof_obj, "publicInputs")?)?;

    let image_id = parse_optional_uint8_array(get_property(&proof_obj, "imageId")?);
    let journal = parse_optional_uint8_array(get_property(&proof_obj, "journal")?);

    let proof = Groth16Proof {
        a,
        b,
        c,
        public_inputs,
        image_id,
        journal,
    };

    let vk_obj = vk_js
        .dyn_into::<js_sys::Object>()
        .map_err(|_| JsValue::from_str("vk_js is not an object"))?;

    let alpha = parse_g1_point(get_property(&vk_obj, "alpha")?)?;
    let beta = parse_g2_point(get_property(&vk_obj, "beta")?)?;
    let gamma = parse_g2_point(get_property(&vk_obj, "gamma")?)?;
    let delta = parse_g2_point(get_property(&vk_obj, "delta")?)?;
    let ic = parse_g1_point_array(get_property(&vk_obj, "ic")?)?;

    let vk = Groth16VerificationKey {
        alpha,
        beta,
        gamma,
        delta,
        ic,
    };

    //Parse curve_id_js into usize
    let curve_id_num = curve_id_js
        .as_f64()
        .ok_or_else(|| JsValue::from_str("curve_id_js is not a number"))?
        as usize;

    // Convert usize to CurveID using TryFrom
    let curve_id = CurveID::try_from(curve_id_num).map_err(|e| JsValue::from_str(&e))?;

    let groth16_calldata_biguint = groth16::get_groth16_calldata(&proof, &vk, curve_id);

    let groth16_calldata_js = groth16_calldata_biguint?
        .into_iter()
        .map(biguint_to_jsvalue)
        .collect::<Vec<_>>();

    Ok(groth16_calldata_js)
}

#[wasm_bindgen]
pub fn parse_honk_proof(uint8_array: JsValue) -> Result<JsValue, JsValue> {
    let bytes = uint8_array
        .dyn_into::<Uint8Array>()
        .map(|arr| arr.to_vec())?;

    let proof = HonkProof::from_bytes(&bytes).map_err(|s| JsValue::from_str(&s))?;

    let curve_id = CurveID::BN254 as usize;

    let proof_obj = js_sys::Object::new();
    set_property(
        &proof_obj,
        "publicInputs",
        &jsvalue_from_biguint_array(&proof.public_inputs)?,
    )?;
    set_property(
        &proof_obj,
        "w1",
        &jsvalue_from_g1_point(&proof.w1, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "w2",
        &jsvalue_from_g1_point(&proof.w2, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "w3",
        &jsvalue_from_g1_point(&proof.w3, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "w4",
        &jsvalue_from_g1_point(&proof.w4, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "zPerm",
        &jsvalue_from_g1_point(&proof.z_perm, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "lookupReadCounts",
        &jsvalue_from_g1_point(&proof.lookup_read_counts, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "lookupReadTags",
        &jsvalue_from_g1_point(&proof.lookup_read_tags, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "lookupInverses",
        &jsvalue_from_g1_point(&proof.lookup_inverses, curve_id)?,
    )?;
    let sumcheck_univariates = proof
        .sumcheck_univariates
        .iter()
        .flat_map(|v| v.clone())
        .collect::<Vec<_>>();
    set_property(
        &proof_obj,
        "sumcheckUnivariates",
        &jsvalue_from_biguint_array(&sumcheck_univariates)?,
    )?; // flattened
    set_property(
        &proof_obj,
        "sumcheckEvaluations",
        &jsvalue_from_biguint_array(&proof.sumcheck_evaluations)?,
    )?;
    set_property(
        &proof_obj,
        "geminiFoldComms",
        &jsvalue_from_g1_point_array(&proof.gemini_fold_comms, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "geminiAEvaluations",
        &jsvalue_from_biguint_array(&proof.gemini_a_evaluations)?,
    )?;
    set_property(
        &proof_obj,
        "shplonkQ",
        &jsvalue_from_g1_point(&proof.shplonk_q, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "kzgQuotient",
        &jsvalue_from_g1_point(&proof.kzg_quotient, curve_id)?,
    )?;

    Ok(proof_obj.into())
}

#[wasm_bindgen]
pub fn parse_zk_honk_proof(uint8_array: JsValue) -> Result<JsValue, JsValue> {
    let bytes = uint8_array
        .dyn_into::<Uint8Array>()
        .map(|arr| arr.to_vec())?;

    let proof = ZKHonkProof::from_bytes(&bytes).map_err(|s| JsValue::from_str(&s))?;

    let curve_id = CurveID::BN254 as usize;

    let proof_obj = js_sys::Object::new();
    set_property(
        &proof_obj,
        "publicInputs",
        &jsvalue_from_biguint_array(&proof.public_inputs)?,
    )?;
    set_property(
        &proof_obj,
        "w1",
        &jsvalue_from_g1_point(&proof.w1, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "w2",
        &jsvalue_from_g1_point(&proof.w2, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "w3",
        &jsvalue_from_g1_point(&proof.w3, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "w4",
        &jsvalue_from_g1_point(&proof.w4, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "zPerm",
        &jsvalue_from_g1_point(&proof.z_perm, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "lookupReadCounts",
        &jsvalue_from_g1_point(&proof.lookup_read_counts, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "lookupReadTags",
        &jsvalue_from_g1_point(&proof.lookup_read_tags, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "lookupInverses",
        &jsvalue_from_g1_point(&proof.lookup_inverses, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "libraCommitments",
        &jsvalue_from_g1_point_array(&proof.libra_commitments, curve_id)?,
    )?;
    set_property(&proof_obj, "libraSum", &biguint_to_jsvalue(proof.libra_sum))?;
    let sumcheck_univariates = proof
        .sumcheck_univariates
        .iter()
        .flat_map(|v| v.clone())
        .collect::<Vec<_>>();
    set_property(
        &proof_obj,
        "sumcheckUnivariates",
        &jsvalue_from_biguint_array(&sumcheck_univariates)?,
    )?; // flattened
    set_property(
        &proof_obj,
        "sumcheckEvaluations",
        &jsvalue_from_biguint_array(&proof.sumcheck_evaluations)?,
    )?;
    set_property(
        &proof_obj,
        "libraEvaluation",
        &biguint_to_jsvalue(proof.libra_evaluation),
    )?;
    set_property(
        &proof_obj,
        "geminiMaskingPoly",
        &jsvalue_from_g1_point(&proof.gemini_masking_poly, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "geminiMaskingEval",
        &biguint_to_jsvalue(proof.gemini_masking_eval),
    )?;
    set_property(
        &proof_obj,
        "geminiFoldComms",
        &jsvalue_from_g1_point_array(&proof.gemini_fold_comms, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "geminiAEvaluations",
        &jsvalue_from_biguint_array(&proof.gemini_a_evaluations)?,
    )?;
    set_property(
        &proof_obj,
        "libraPolyEvals",
        &jsvalue_from_biguint_array(&proof.libra_poly_evals)?,
    )?;
    set_property(
        &proof_obj,
        "shplonkQ",
        &jsvalue_from_g1_point(&proof.shplonk_q, curve_id)?,
    )?;
    set_property(
        &proof_obj,
        "kzgQuotient",
        &jsvalue_from_g1_point(&proof.kzg_quotient, curve_id)?,
    )?;

    Ok(proof_obj.into())
}

#[wasm_bindgen]
pub fn parse_honk_verification_key(uint8_array: JsValue) -> Result<JsValue, JsValue> {
    let bytes = uint8_array
        .dyn_into::<Uint8Array>()
        .map(|arr| arr.to_vec())?;

    let vk = HonkVerificationKey::from_bytes(&bytes).map_err(|s| JsValue::from_str(&s))?;

    let curve_id = CurveID::BN254 as usize;

    let vk_obj = js_sys::Object::new();
    set_property(&vk_obj, "circuitSize", &vk.circuit_size.into())?;
    set_property(&vk_obj, "logCircuitSize", &vk.log_circuit_size.into())?;
    set_property(&vk_obj, "publicInputsSize", &vk.public_inputs_size.into())?;
    set_property(
        &vk_obj,
        "publicInputsOffset",
        &vk.public_inputs_offset.into(),
    )?;
    set_property(&vk_obj, "qm", &jsvalue_from_g1_point(&vk.qm, curve_id)?)?;
    set_property(&vk_obj, "qc", &jsvalue_from_g1_point(&vk.qc, curve_id)?)?;
    set_property(&vk_obj, "ql", &jsvalue_from_g1_point(&vk.ql, curve_id)?)?;
    set_property(&vk_obj, "qr", &jsvalue_from_g1_point(&vk.qr, curve_id)?)?;
    set_property(&vk_obj, "qo", &jsvalue_from_g1_point(&vk.qo, curve_id)?)?;
    set_property(&vk_obj, "q4", &jsvalue_from_g1_point(&vk.q4, curve_id)?)?;
    set_property(
        &vk_obj,
        "qLookup",
        &jsvalue_from_g1_point(&vk.q_lookup, curve_id)?,
    )?;
    set_property(
        &vk_obj,
        "qArith",
        &jsvalue_from_g1_point(&vk.q_arith, curve_id)?,
    )?;
    set_property(
        &vk_obj,
        "qDeltaRange",
        &jsvalue_from_g1_point(&vk.q_delta_range, curve_id)?,
    )?;
    set_property(
        &vk_obj,
        "qElliptic",
        &jsvalue_from_g1_point(&vk.q_elliptic, curve_id)?,
    )?;
    set_property(
        &vk_obj,
        "qAux",
        &jsvalue_from_g1_point(&vk.q_aux, curve_id)?,
    )?;
    set_property(
        &vk_obj,
        "qPoseidon2External",
        &jsvalue_from_g1_point(&vk.q_poseidon2_external, curve_id)?,
    )?;
    set_property(
        &vk_obj,
        "qPoseidon2Internal",
        &jsvalue_from_g1_point(&vk.q_poseidon2_internal, curve_id)?,
    )?;
    set_property(&vk_obj, "s1", &jsvalue_from_g1_point(&vk.s1, curve_id)?)?;
    set_property(&vk_obj, "s2", &jsvalue_from_g1_point(&vk.s2, curve_id)?)?;
    set_property(&vk_obj, "s3", &jsvalue_from_g1_point(&vk.s3, curve_id)?)?;
    set_property(&vk_obj, "s4", &jsvalue_from_g1_point(&vk.s4, curve_id)?)?;
    set_property(&vk_obj, "id1", &jsvalue_from_g1_point(&vk.id1, curve_id)?)?;
    set_property(&vk_obj, "id2", &jsvalue_from_g1_point(&vk.id2, curve_id)?)?;
    set_property(&vk_obj, "id3", &jsvalue_from_g1_point(&vk.id3, curve_id)?)?;
    set_property(&vk_obj, "id4", &jsvalue_from_g1_point(&vk.id4, curve_id)?)?;
    set_property(&vk_obj, "t1", &jsvalue_from_g1_point(&vk.t1, curve_id)?)?;
    set_property(&vk_obj, "t2", &jsvalue_from_g1_point(&vk.t2, curve_id)?)?;
    set_property(&vk_obj, "t3", &jsvalue_from_g1_point(&vk.t3, curve_id)?)?;
    set_property(&vk_obj, "t4", &jsvalue_from_g1_point(&vk.t4, curve_id)?)?;
    set_property(
        &vk_obj,
        "lagrangeFirst",
        &jsvalue_from_g1_point(&vk.lagrange_first, curve_id)?,
    )?;
    set_property(
        &vk_obj,
        "lagrangeLast",
        &jsvalue_from_g1_point(&vk.lagrange_last, curve_id)?,
    )?;

    Ok(vk_obj.into())
}

#[wasm_bindgen]
pub fn get_honk_calldata(
    proof_js: JsValue,
    vk_js: JsValue,
    flavor_js: JsValue,
) -> Result<Vec<JsValue>, JsValue> {
    let proof_obj = proof_js
        .dyn_into::<js_sys::Object>()
        .map_err(|_| JsValue::from_str("proof_js is not an object"))?;

    let public_inputs = parse_biguint_array(get_property(&proof_obj, "publicInputs")?)?;
    let w1 = parse_g1_point(get_property(&proof_obj, "w1")?)?;
    let w2 = parse_g1_point(get_property(&proof_obj, "w2")?)?;
    let w3 = parse_g1_point(get_property(&proof_obj, "w3")?)?;
    let w4 = parse_g1_point(get_property(&proof_obj, "w4")?)?;
    let z_perm = parse_g1_point(get_property(&proof_obj, "zPerm")?)?;
    let lookup_read_counts = parse_g1_point(get_property(&proof_obj, "lookupReadCounts")?)?;
    let lookup_read_tags = parse_g1_point(get_property(&proof_obj, "lookupReadTags")?)?;
    let lookup_inverses = parse_g1_point(get_property(&proof_obj, "lookupInverses")?)?;
    let sumcheck_univariates =
        parse_biguint_array(get_property(&proof_obj, "sumcheckUnivariates")?)?;
    let sumcheck_evaluations =
        parse_biguint_array(get_property(&proof_obj, "sumcheckEvaluations")?)?;
    let gemini_fold_comms = parse_g1_point_array(get_property(&proof_obj, "geminiFoldComms")?)?;
    let gemini_a_evaluations =
        parse_biguint_array(get_property(&proof_obj, "geminiAEvaluations")?)?;
    let shplonk_q = parse_g1_point(get_property(&proof_obj, "shplonkQ")?)?;
    let kzg_quotient = parse_g1_point(get_property(&proof_obj, "kzgQuotient")?)?;

    fn g1_point_split(point: G1PointBigUint) -> [BigUint; 4] {
        let x = &point.x;
        let y = &point.y;
        let mask = &((BigUint::from(1usize) << 136) - 1usize);
        [x & mask, x >> 136, y & mask, y >> 136]
    }

    let mut values = vec![];
    values.extend(public_inputs);
    values.extend(g1_point_split(w1));
    values.extend(g1_point_split(w2));
    values.extend(g1_point_split(w3));
    values.extend(g1_point_split(lookup_read_counts));
    values.extend(g1_point_split(lookup_read_tags));
    values.extend(g1_point_split(w4));
    values.extend(g1_point_split(lookup_inverses));
    values.extend(g1_point_split(z_perm));
    values.extend(sumcheck_univariates);
    values.extend(sumcheck_evaluations);
    for gemini_fold_comm in gemini_fold_comms {
        values.extend(g1_point_split(gemini_fold_comm));
    }
    values.extend(gemini_a_evaluations);
    values.extend(g1_point_split(shplonk_q));
    values.extend(g1_point_split(kzg_quotient));
    let proof = HonkProof::from(values).map_err(|s| JsValue::from_str(&s))?;

    let vk_obj = vk_js
        .dyn_into::<js_sys::Object>()
        .map_err(|_| JsValue::from_str("vk_js is not an object"))?;

    let circuit_size = jsvalue_to_biguint(get_property(&vk_obj, "circuitSize")?)?;
    let log_circuit_size = jsvalue_to_biguint(get_property(&vk_obj, "logCircuitSize")?)?;
    let public_inputs_size = jsvalue_to_biguint(get_property(&vk_obj, "publicInputsSize")?)?;
    let public_inputs_offset = jsvalue_to_biguint(get_property(&vk_obj, "publicInputsOffset")?)?;
    let qm = parse_g1_point(get_property(&vk_obj, "qm")?)?;
    let qc = parse_g1_point(get_property(&vk_obj, "qc")?)?;
    let ql = parse_g1_point(get_property(&vk_obj, "ql")?)?;
    let qr = parse_g1_point(get_property(&vk_obj, "qr")?)?;
    let qo = parse_g1_point(get_property(&vk_obj, "qo")?)?;
    let q4 = parse_g1_point(get_property(&vk_obj, "q4")?)?;
    let q_lookup = parse_g1_point(get_property(&vk_obj, "qLookup")?)?;
    let q_arith = parse_g1_point(get_property(&vk_obj, "qArith")?)?;
    let q_delta_range = parse_g1_point(get_property(&vk_obj, "qDeltaRange")?)?;
    let q_elliptic = parse_g1_point(get_property(&vk_obj, "qElliptic")?)?;
    let q_aux = parse_g1_point(get_property(&vk_obj, "qAux")?)?;
    let q_poseidon2_external = parse_g1_point(get_property(&vk_obj, "qPoseidon2External")?)?;
    let q_poseidon2_internal = parse_g1_point(get_property(&vk_obj, "qPoseidon2Internal")?)?;
    let s1 = parse_g1_point(get_property(&vk_obj, "s1")?)?;
    let s2 = parse_g1_point(get_property(&vk_obj, "s2")?)?;
    let s3 = parse_g1_point(get_property(&vk_obj, "s3")?)?;
    let s4 = parse_g1_point(get_property(&vk_obj, "s4")?)?;
    let id1 = parse_g1_point(get_property(&vk_obj, "id1")?)?;
    let id2 = parse_g1_point(get_property(&vk_obj, "id2")?)?;
    let id3 = parse_g1_point(get_property(&vk_obj, "id3")?)?;
    let id4 = parse_g1_point(get_property(&vk_obj, "id4")?)?;
    let t1 = parse_g1_point(get_property(&vk_obj, "t1")?)?;
    let t2 = parse_g1_point(get_property(&vk_obj, "t2")?)?;
    let t3 = parse_g1_point(get_property(&vk_obj, "t3")?)?;
    let t4 = parse_g1_point(get_property(&vk_obj, "t4")?)?;
    let lagrange_first = parse_g1_point(get_property(&vk_obj, "lagrangeFirst")?)?;
    let lagrange_last = parse_g1_point(get_property(&vk_obj, "lagrangeLast")?)?;

    let mut values = vec![];
    values.push(circuit_size);
    values.push(log_circuit_size);
    values.push(public_inputs_size);
    values.push(public_inputs_offset);
    values.extend([qm.x, qm.y]);
    values.extend([qc.x, qc.y]);
    values.extend([ql.x, ql.y]);
    values.extend([qr.x, qr.y]);
    values.extend([qo.x, qo.y]);
    values.extend([q4.x, q4.y]);
    values.extend([q_lookup.x, q_lookup.y]);
    values.extend([q_arith.x, q_arith.y]);
    values.extend([q_delta_range.x, q_delta_range.y]);
    values.extend([q_elliptic.x, q_elliptic.y]);
    values.extend([q_aux.x, q_aux.y]);
    values.extend([q_poseidon2_external.x, q_poseidon2_external.y]);
    values.extend([q_poseidon2_internal.x, q_poseidon2_internal.y]);
    values.extend([s1.x, s1.y]);
    values.extend([s2.x, s2.y]);
    values.extend([s3.x, s3.y]);
    values.extend([s4.x, s4.y]);
    values.extend([id1.x, id1.y]);
    values.extend([id2.x, id2.y]);
    values.extend([id3.x, id3.y]);
    values.extend([id4.x, id4.y]);
    values.extend([t1.x, t1.y]);
    values.extend([t2.x, t2.y]);
    values.extend([t3.x, t3.y]);
    values.extend([t4.x, t4.y]);
    values.extend([lagrange_first.x, lagrange_first.y]);
    values.extend([lagrange_last.x, lagrange_last.y]);
    let vk = HonkVerificationKey::from(values).map_err(|s| JsValue::from_str(&s))?;

    //Parse flavor_js into usize
    let flavor_num = flavor_js
        .as_f64()
        .ok_or_else(|| JsValue::from_str("flavor_js is not a number"))?
        as usize;

    // Convert usize to HonkFlavor using TryFrom
    let flavor = HonkFlavor::try_from(flavor_num).map_err(|e| JsValue::from_str(&e))?;

    let honk_calldata_biguint = honk::get_honk_calldata(&proof, &vk, flavor);

    let honk_calldata_js = honk_calldata_biguint?
        .into_iter()
        .map(biguint_to_jsvalue)
        .collect::<Vec<_>>();

    Ok(honk_calldata_js)
}

#[wasm_bindgen]
pub fn get_zk_honk_calldata(
    proof_js: JsValue,
    vk_js: JsValue,
    flavor_js: JsValue,
) -> Result<Vec<JsValue>, JsValue> {
    let proof_obj = proof_js
        .dyn_into::<js_sys::Object>()
        .map_err(|_| JsValue::from_str("proof_js is not an object"))?;

    let public_inputs = parse_biguint_array(get_property(&proof_obj, "publicInputs")?)?;
    let w1 = parse_g1_point(get_property(&proof_obj, "w1")?)?;
    let w2 = parse_g1_point(get_property(&proof_obj, "w2")?)?;
    let w3 = parse_g1_point(get_property(&proof_obj, "w3")?)?;
    let w4 = parse_g1_point(get_property(&proof_obj, "w4")?)?;
    let z_perm = parse_g1_point(get_property(&proof_obj, "zPerm")?)?;
    let lookup_read_counts = parse_g1_point(get_property(&proof_obj, "lookupReadCounts")?)?;
    let lookup_read_tags = parse_g1_point(get_property(&proof_obj, "lookupReadTags")?)?;
    let lookup_inverses = parse_g1_point(get_property(&proof_obj, "lookupInverses")?)?;
    let libra_commitments = parse_g1_point_array(get_property(&proof_obj, "libraCommitments")?)?;
    let libra_sum = jsvalue_to_biguint(get_property(&proof_obj, "libraSum")?)?;
    let sumcheck_univariates =
        parse_biguint_array(get_property(&proof_obj, "sumcheckUnivariates")?)?;
    let sumcheck_evaluations =
        parse_biguint_array(get_property(&proof_obj, "sumcheckEvaluations")?)?;
    let libra_evaluation = jsvalue_to_biguint(get_property(&proof_obj, "libraEvaluation")?)?;
    let gemini_masking_poly = parse_g1_point(get_property(&proof_obj, "geminiMaskingPoly")?)?;
    let gemini_masking_eval = jsvalue_to_biguint(get_property(&proof_obj, "geminiMaskingEval")?)?;
    let gemini_fold_comms = parse_g1_point_array(get_property(&proof_obj, "geminiFoldComms")?)?;
    let gemini_a_evaluations =
        parse_biguint_array(get_property(&proof_obj, "geminiAEvaluations")?)?;
    let libra_poly_evals = parse_biguint_array(get_property(&proof_obj, "libraPolyEvals")?)?;
    let shplonk_q = parse_g1_point(get_property(&proof_obj, "shplonkQ")?)?;
    let kzg_quotient = parse_g1_point(get_property(&proof_obj, "kzgQuotient")?)?;

    fn g1_point_split(point: G1PointBigUint) -> [BigUint; 4] {
        let x = &point.x;
        let y = &point.y;
        let mask = &((BigUint::from(1usize) << 136) - 1usize);
        [x & mask, x >> 136, y & mask, y >> 136]
    }

    let [libra_commitments_0, libra_commitments_1, libra_commitments_2] =
        libra_commitments.try_into().unwrap();

    let mut values = vec![];
    values.extend(public_inputs);
    values.extend(g1_point_split(w1));
    values.extend(g1_point_split(w2));
    values.extend(g1_point_split(w3));
    values.extend(g1_point_split(lookup_read_counts));
    values.extend(g1_point_split(lookup_read_tags));
    values.extend(g1_point_split(w4));
    values.extend(g1_point_split(lookup_inverses));
    values.extend(g1_point_split(z_perm));
    values.extend(g1_point_split(libra_commitments_0));
    values.push(libra_sum);
    values.extend(sumcheck_univariates);
    values.extend(sumcheck_evaluations);
    values.push(libra_evaluation);
    values.extend(g1_point_split(libra_commitments_1));
    values.extend(g1_point_split(libra_commitments_2));
    values.extend(g1_point_split(gemini_masking_poly));
    values.push(gemini_masking_eval);
    for gemini_fold_comm in gemini_fold_comms {
        values.extend(g1_point_split(gemini_fold_comm));
    }
    values.extend(gemini_a_evaluations);
    values.extend(libra_poly_evals);
    values.extend(g1_point_split(shplonk_q));
    values.extend(g1_point_split(kzg_quotient));
    let proof = ZKHonkProof::from(values).map_err(|s| JsValue::from_str(&s))?;

    let vk_obj = vk_js
        .dyn_into::<js_sys::Object>()
        .map_err(|_| JsValue::from_str("vk_js is not an object"))?;

    let circuit_size = jsvalue_to_biguint(get_property(&vk_obj, "circuitSize")?)?;
    let log_circuit_size = jsvalue_to_biguint(get_property(&vk_obj, "logCircuitSize")?)?;
    let public_inputs_size = jsvalue_to_biguint(get_property(&vk_obj, "publicInputsSize")?)?;
    let public_inputs_offset = jsvalue_to_biguint(get_property(&vk_obj, "publicInputsOffset")?)?;
    let qm = parse_g1_point(get_property(&vk_obj, "qm")?)?;
    let qc = parse_g1_point(get_property(&vk_obj, "qc")?)?;
    let ql = parse_g1_point(get_property(&vk_obj, "ql")?)?;
    let qr = parse_g1_point(get_property(&vk_obj, "qr")?)?;
    let qo = parse_g1_point(get_property(&vk_obj, "qo")?)?;
    let q4 = parse_g1_point(get_property(&vk_obj, "q4")?)?;
    let q_lookup = parse_g1_point(get_property(&vk_obj, "qLookup")?)?;
    let q_arith = parse_g1_point(get_property(&vk_obj, "qArith")?)?;
    let q_delta_range = parse_g1_point(get_property(&vk_obj, "qDeltaRange")?)?;
    let q_elliptic = parse_g1_point(get_property(&vk_obj, "qElliptic")?)?;
    let q_aux = parse_g1_point(get_property(&vk_obj, "qAux")?)?;
    let q_poseidon2_external = parse_g1_point(get_property(&vk_obj, "qPoseidon2External")?)?;
    let q_poseidon2_internal = parse_g1_point(get_property(&vk_obj, "qPoseidon2Internal")?)?;
    let s1 = parse_g1_point(get_property(&vk_obj, "s1")?)?;
    let s2 = parse_g1_point(get_property(&vk_obj, "s2")?)?;
    let s3 = parse_g1_point(get_property(&vk_obj, "s3")?)?;
    let s4 = parse_g1_point(get_property(&vk_obj, "s4")?)?;
    let id1 = parse_g1_point(get_property(&vk_obj, "id1")?)?;
    let id2 = parse_g1_point(get_property(&vk_obj, "id2")?)?;
    let id3 = parse_g1_point(get_property(&vk_obj, "id3")?)?;
    let id4 = parse_g1_point(get_property(&vk_obj, "id4")?)?;
    let t1 = parse_g1_point(get_property(&vk_obj, "t1")?)?;
    let t2 = parse_g1_point(get_property(&vk_obj, "t2")?)?;
    let t3 = parse_g1_point(get_property(&vk_obj, "t3")?)?;
    let t4 = parse_g1_point(get_property(&vk_obj, "t4")?)?;
    let lagrange_first = parse_g1_point(get_property(&vk_obj, "lagrangeFirst")?)?;
    let lagrange_last = parse_g1_point(get_property(&vk_obj, "lagrangeLast")?)?;

    let mut values = vec![];
    values.push(circuit_size);
    values.push(log_circuit_size);
    values.push(public_inputs_size);
    values.push(public_inputs_offset);
    values.extend([qm.x, qm.y]);
    values.extend([qc.x, qc.y]);
    values.extend([ql.x, ql.y]);
    values.extend([qr.x, qr.y]);
    values.extend([qo.x, qo.y]);
    values.extend([q4.x, q4.y]);
    values.extend([q_lookup.x, q_lookup.y]);
    values.extend([q_arith.x, q_arith.y]);
    values.extend([q_delta_range.x, q_delta_range.y]);
    values.extend([q_elliptic.x, q_elliptic.y]);
    values.extend([q_aux.x, q_aux.y]);
    values.extend([q_poseidon2_external.x, q_poseidon2_external.y]);
    values.extend([q_poseidon2_internal.x, q_poseidon2_internal.y]);
    values.extend([s1.x, s1.y]);
    values.extend([s2.x, s2.y]);
    values.extend([s3.x, s3.y]);
    values.extend([s4.x, s4.y]);
    values.extend([id1.x, id1.y]);
    values.extend([id2.x, id2.y]);
    values.extend([id3.x, id3.y]);
    values.extend([id4.x, id4.y]);
    values.extend([t1.x, t1.y]);
    values.extend([t2.x, t2.y]);
    values.extend([t3.x, t3.y]);
    values.extend([t4.x, t4.y]);
    values.extend([lagrange_first.x, lagrange_first.y]);
    values.extend([lagrange_last.x, lagrange_last.y]);
    let vk = HonkVerificationKey::from(values).map_err(|s| JsValue::from_str(&s))?;

    //Parse flavor_js into usize
    let flavor_num = flavor_js
        .as_f64()
        .ok_or_else(|| JsValue::from_str("flavor_js is not a number"))?
        as usize;

    // Convert usize to HonkFlavor using TryFrom
    let flavor = HonkFlavor::try_from(flavor_num).map_err(|e| JsValue::from_str(&e))?;

    let honk_calldata_biguint = zk_honk::get_zk_honk_calldata(&proof, &vk, flavor);

    let honk_calldata_js = honk_calldata_biguint?
        .into_iter()
        .map(biguint_to_jsvalue)
        .collect::<Vec<_>>();

    Ok(honk_calldata_js)
}

#[wasm_bindgen]
pub fn poseidon_hash(x: JsValue, y: JsValue) -> Result<JsValue, JsValue> {
    // Convert hex strings to field elements, handling potential errors

    let x_biguint =
        jsvalue_to_biguint(x).map_err(|_| JsValue::from_str("Failed to parse x input as hex"))?;
    let x_fe = element_from_biguint::<GrumpkinPrimeField>(&x_biguint);

    let y_biguint =
        jsvalue_to_biguint(y).map_err(|_| JsValue::from_str("Failed to parse y input as hex"))?;
    let y_fe = element_from_biguint::<GrumpkinPrimeField>(&y_biguint);

    // Compute hash
    let result = poseidon_hash_bn254(&x_fe, &y_fe);
    let res_biguint = element_to_biguint::<GrumpkinPrimeField>(&result);
    // Convert result to hex string
    Ok(biguint_to_jsvalue(res_biguint))
}

#[allow(dead_code)]
#[cfg(test)]
mod tests {
    use super::*;
    use crate::definitions::CurveParamsProvider;
    use js_sys::Object;
    use num_bigint::BigUint;
    use wasm_bindgen_test::wasm_bindgen_test;

    // This test runs only in wasm32-unknown-unknown targets
    // wasm-pack test --node --release --no-default-features
    #[wasm_bindgen_test]
    pub fn test_biguint_marshalling() {
        let v = 31415usize;
        assert_eq!(
            jsvalue_to_biguint(biguint_to_jsvalue(BigUint::from(v))).unwrap(),
            BigUint::from(v)
        );
    }

    #[wasm_bindgen_test]
    pub fn test_to_weierstrass_and_back() {
        let curve = X25519PrimeField::get_curve_params();

        let x_weirstrass = curve.g_x;
        let y_weirstrass = curve.g_y;

        let (x_twisted, y_twisted) =
            X25519PrimeField::to_twistededwards(x_weirstrass.clone(), y_weirstrass.clone());
        let (x_weirstrass_back, y_weirstrass_back) =
            X25519PrimeField::to_weirstrass(x_twisted, y_twisted);

        assert_eq!(x_weirstrass, x_weirstrass_back);
        assert_eq!(y_weirstrass, y_weirstrass_back);
    }

    #[wasm_bindgen_test]
    pub fn test_to_twistededwards_and_back_from_js() {
        let curve = X25519PrimeField::get_curve_params();

        let x_weirstrass = curve.g_x;
        let y_weirstrass = curve.g_y;

        let x_weirstrass_js =
            biguint_to_jsvalue(element_to_biguint::<X25519PrimeField>(&x_weirstrass));
        let y_weirstrass_js =
            biguint_to_jsvalue(element_to_biguint::<X25519PrimeField>(&y_weirstrass));
        let result_js = to_twistededwards(x_weirstrass_js, y_weirstrass_js).unwrap();
        assert_eq!(result_js.len(), 2);

        let x_twisted_js = result_js.get(0).unwrap();
        let y_twisted_js = result_js.get(1).unwrap();

        let x_twisted_biguint = jsvalue_to_biguint(x_twisted_js.clone()).unwrap();
        let y_twisted_biguint = jsvalue_to_biguint(y_twisted_js.clone()).unwrap();

        let x_twisted = element_from_biguint::<X25519PrimeField>(&x_twisted_biguint);
        let y_twisted = element_from_biguint::<X25519PrimeField>(&y_twisted_biguint);

        let (x_weirstrass_back, y_weirstrass_back) =
            X25519PrimeField::to_weirstrass(x_twisted, y_twisted);

        assert_eq!(x_weirstrass, x_weirstrass_back);
        assert_eq!(y_weirstrass, y_weirstrass_back);
    }

    #[wasm_bindgen_test]
    pub fn test_get_groth16_calldata() {
        let proof_js = mock_proof_js();
        assert!(proof_js.is_object(), "Failed to parse proof");

        let vk_js = mock_vk_js();
        assert!(vk_js.is_object(), "Failed to parse Verifying Key");
        let curve_id_js = JsValue::from_f64(0.0);

        let result = get_groth16_calldata(proof_js, vk_js, curve_id_js);

        assert!(
            result.is_ok(),
            "Expected successful result, got {:?}",
            result
        );
        let result_values = result.unwrap();

        // Add specific assertions here to validate expected output structure or content
        assert!(
            !result_values.is_empty(),
            "Expected non-empty result values"
        );
    }

    // Mock helper to create G1 and G2 points as JsValues
    fn mock_g1_point(x: &str, y: &str) -> JsValue {
        let obj = Object::new();
        js_sys::Reflect::set(&obj, &JsValue::from_str("x"), &JsValue::from_str(x)).unwrap();
        js_sys::Reflect::set(&obj, &JsValue::from_str("y"), &JsValue::from_str(y)).unwrap();
        obj.into()
    }

    fn mock_g2_point(x0: &str, x1: &str, y0: &str, y1: &str) -> JsValue {
        let obj = Object::new();
        let x_tuple = Array::of2(&JsValue::from_str(x0), &JsValue::from_str(x1));
        let y_tuple = Array::of2(&JsValue::from_str(y0), &JsValue::from_str(y1));
        js_sys::Reflect::set(&obj, &JsValue::from_str("x"), &x_tuple).unwrap();
        js_sys::Reflect::set(&obj, &JsValue::from_str("y"), &y_tuple).unwrap();
        obj.into()
    }

    fn mock_proof_js() -> JsValue {
        let obj = Object::new();
        js_sys::Reflect::set(
            &obj,
            &JsValue::from_str("a"),
            &mock_g1_point(
                "0x2abaae3dd6e4c662f5e071bca525a26d21e2400d01d02c87bce2e8363285990a",
                "0x24211ff0aa742a6dd1651aadce6f72757beb89de2cff83a6162de7c15674c2",
            ),
        )
        .unwrap();
        js_sys::Reflect::set(
            &obj,
            &JsValue::from_str("b"),
            &mock_g2_point(
                "0x2335f1564c154d7a2ec5d11faf6d991a205bef2858f1687976d0a46502f5224a",
                "0x223af0bb0912d8ebc535ed489d06cd01fcf4a8ab4596cc28164edf9041d97080",
                "0x182e8fd86a44983de1d1d9dc4f12f134535b75d39f7aeb21adbf57e1a32ee603",
                "0xecb11668a0dd5d5031b0837e62ba14222b45718dc101c1278f44a9ed823c16b",
            ),
        )
        .unwrap();
        js_sys::Reflect::set(
            &obj,
            &JsValue::from_str("c"),
            &mock_g1_point(
                "0x290243624a4c11868e7cb0c0f7cfd690dac08e4205d19795b0a8f686dddcdfd6",
                "0x15de00cc8af159fbdbdc802592e83e1ac61a8026b97e8889b8c5def59ec50b16",
            ),
        )
        .unwrap();

        let public_inputs = Array::new();
        public_inputs.push(&JsValue::from_str(
            "0x1e17db88c1d2e83e49f692cce4bb8169309de90afb2b141156243106aa34b474",
        ));
        js_sys::Reflect::set(&obj, &JsValue::from_str("publicInputs"), &public_inputs).unwrap();

        obj.into()
    }

    fn mock_vk_js() -> JsValue {
        let obj = Object::new();
        js_sys::Reflect::set(
            &obj,
            &JsValue::from_str("alpha"),
            &mock_g1_point(
                "0xef3cb41414ad20b4fc5891f6b41a263d9f0c0509ee5ab16f866ff6a33fb9e73",
                "0x1b30646c7d96cf7830a42b1f2f7c0527c38601f1030674b0f14cf7c67de5027b",
            ),
        )
        .unwrap();
        js_sys::Reflect::set(
            &obj,
            &JsValue::from_str("beta"),
            &mock_g2_point(
                "0x21f7077b68f4faa9dcbfdc868e9a0b5c76eb0d62b919772a83b34a8bc1108489",
                "0x8693a2418c12721dddb0d4f9f3811645c372de7400061b6c6cebc4b3b799bb2",
                "0x3062e0c71d392fb15f33a8d7f87bf689709cb28f87d554e29dc92d92d1b0ce46",
                "0x4976fda5a1cd2a69e5b4fd77116cf638be2063a3359e40d8f3e8ec0c90ffd90",
            ),
        )
        .unwrap();
        js_sys::Reflect::set(
            &obj,
            &JsValue::from_str("gamma"),
            &mock_g2_point(
                "0x3541dacedd860ef884359c76cc9c6b81d289d3389e732f5f87195d15a4ce637",
                "0x2eb7d1fa8416da97272d9cc4aa2e71146c83c13be313e222b376d9a9da02f080",
                "0x8dce093ad7f7fe20efcb8bbb160b0f2ecb7cd98a7d48b949e86c8b00eef73f9",
                "0x29a4b793edc639746eb4af5910b954a713c49174d917839a146ea15cd7493f1d",
            ),
        )
        .unwrap();
        js_sys::Reflect::set(
            &obj,
            &JsValue::from_str("delta"),
            &mock_g2_point(
                "0x34fc9ba8eba1e49185580c9ee198f6cac8bc78463d786683ef471af4434acdc",
                "0x17f115a16975c6f261912be284ecae3a3f0899bb161153d19ebc7f594246b9b0",
                "0x17fd1ad43bbc8ef931c92abab72ef0ed83a3c195b4dbc7294e1eacf59b3e2054",
                "0x1bd7d75bf918b6766ff9481052ddb780a4cc43da055b6e98c187b34ca3e7cd1b",
            ),
        )
        .unwrap();

        let ic_array = Array::new();
        ic_array.push(&mock_g1_point(
            "0x124e30bf4dff3ae9c9da665a8bebfd01ce6489a462587fa0f6c879156e7390bc",
            "0x1fdc3a96cea49b085e101dd2383fdc600dcb4a3450c0471724e1b022791c7532",
        ));
        ic_array.push(&mock_g1_point(
            "0x164668f89d9d6c6126a8465790ba44ddb5716750edaa0ed100691cceb974c6a1",
            "0x1d9c7309625ec7cf153290e7b5c8497412386c61f3d9d0426a702f368be936da",
        ));
        js_sys::Reflect::set(&obj, &JsValue::from_str("ic"), &ic_array).unwrap();

        obj.into()
    }

    #[wasm_bindgen_test]
    fn test_poseidon_hash() {
        // Test with valid inputs
        let x_js = JsValue::from_str("1");
        let y_js = JsValue::from_str("2");
        let result = poseidon_hash(x_js, y_js);
        let expected_js = biguint_to_jsvalue(
            BigUint::from_str_radix(
                "115CC0F5E7D690413DF64C6B9662E9CF2A3617F2743245519E19607A4417189A",
                16,
            )
            .unwrap(),
        );
        assert_eq!(result.unwrap(), expected_js);
    }
}
