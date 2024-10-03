use crate::definitions::{ToTwistedEdwardsCurve, ToWeierstrassCurve, X25519PrimeField};
use crate::io::{element_from_biguint, element_to_biguint};
use num_bigint::BigUint;
use std::str::FromStr;
use wasm_bindgen::prelude::*;

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
    let result = crate::msm::msm_calldata_builder(
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
    let result =
        crate::mpc_calldata::mpc_calldata_builder(curve_id, &values1, n_fixed_g2, &values2)
            .map_err(|e| JsValue::from_str(&e.to_string()))?; // Handle error here

    let result: Vec<BigUint> = result; // Ensure result is of type Vec<BigUint>

    Ok(result.into_iter().map(biguint_to_jsvalue).collect())
}

fn jsvalue_to_biguint(v: JsValue) -> Result<BigUint, JsValue> {
    let s = (JsValue::from_str("") + v)
        .as_string()
        .ok_or_else(|| JsValue::from_str("Failed to convert JsValue to string"))?;
    BigUint::from_str(&s).map_err(|_| JsValue::from_str("Failed to convert string to BigUint"))
}

fn biguint_to_jsvalue(v: BigUint) -> JsValue {
    JsValue::bigint_from_str(&v.to_string())
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

#[cfg(test)]
mod tests {
    use super::*;
    use crate::definitions::CurveParamsProvider;
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
}
