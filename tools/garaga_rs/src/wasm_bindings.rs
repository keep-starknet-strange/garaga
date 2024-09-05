use num_bigint::{BigInt, BigUint};
use std::str::FromStr;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn msm_calldata_builder(
    values: Vec<JsValue>,
    scalars: Vec<JsValue>,
    curve_id: usize,
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
    let result = crate::msm::msm_calldata_builder(&values, &scalars, curve_id)
        .map_err(|e| JsValue::from_str(&e.to_string()))?; // Handle error here

    let result: Vec<BigInt> = result; // Ensure result is of type Vec<BigInt>

    Ok(result.into_iter().map(bigint_to_jsvalue).collect())
}

fn jsvalue_to_biguint(v: JsValue) -> Result<BigUint, JsValue> {
    let s = (JsValue::from_str("") + v)
        .as_string()
        .ok_or_else(|| JsValue::from_str("Failed to convert JsValue to string"))?;
    BigUint::from_str(&s).map_err(|_| JsValue::from_str("Failed to convert string to BigUint"))
}

fn bigint_to_jsvalue(v: BigInt) -> JsValue {
    JsValue::bigint_from_str(&v.to_string())
}

#[cfg(test)]
mod tests {
    use super::*;
    use num_bigint::{BigInt, BigUint};
    use wasm_bindgen_test::wasm_bindgen_test;

    // This test runs only in wasm32-unknown-unknown targets
    // wasm-pack test --node --release --no-default-features
    #[wasm_bindgen_test]
    pub fn test_bigint_marshalling() {
        let v = 31415usize;
        assert_eq!(
            jsvalue_to_biguint(bigint_to_jsvalue(BigInt::from(v))).unwrap(),
            BigUint::from(v)
        );
    }
}
