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
