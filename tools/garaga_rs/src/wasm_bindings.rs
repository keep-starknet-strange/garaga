use num_bigint::{BigInt, BigUint};
use std::str::FromStr;
use wasm_bindgen::prelude::*;

#[wasm_bindgen]
pub fn msm_calldata_builder(
    values: Vec<JsValue>,
    scalars: Vec<JsValue>,
    curve_id: usize,
) -> Vec<JsValue> {
    let values: Vec<BigUint> = values.into_iter().map(jsvalue_to_biguint).collect();
    let scalars: Vec<BigUint> = scalars.into_iter().map(jsvalue_to_biguint).collect();
    let result = crate::msm::msm_calldata_builder(&values, &scalars, curve_id);
    result.into_iter().map(bigint_to_jsvalue).collect()
}

fn jsvalue_to_biguint(v: JsValue) -> BigUint {
    let s = (JsValue::from_str("") + v).as_string().unwrap();
    BigUint::from_str(&s).expect("Failed to convert value to non-negative bigint")
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
            jsvalue_to_biguint(bigint_to_jsvalue(BigInt::from(v))),
            BigUint::from(v)
        );
    }
}
