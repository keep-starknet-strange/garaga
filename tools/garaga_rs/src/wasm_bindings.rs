use crate::calldata::full_proof_with_hints::groth16;
use crate::calldata::full_proof_with_hints::groth16::{Groth16Proof, Groth16VerificationKey};
use crate::calldata::{G1PointBigUint, G2PointBigUint};
use crate::definitions::CurveID;
use crate::definitions::{ToTwistedEdwardsCurve, ToWeierstrassCurve, X25519PrimeField};
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
        include_digits_decomposition,
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

// Parsing helper for G1PointBigUint
fn parse_g1_point(value: JsValue) -> Result<G1PointBigUint, JsValue> {
    let obj = value
        .dyn_into::<js_sys::Object>()
        .map_err(|_| JsValue::from_str("Failed to parse G1PointBigUint"))?;

    let x = jsvalue_to_biguint(get_property(&obj, "x")?)?;

    let y = jsvalue_to_biguint(get_property(&obj, "y")?)?;

    Ok(G1PointBigUint { x, y })
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
        .map_err(|_| JsValue::from_str("proof_js is not an object"))?;

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
}
