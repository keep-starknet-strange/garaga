# Rust -> Python bindings

This guide explains how to add new Python bindings for Rust functions in the `garaga_rs` crate.

## Overview

The Python bindings are implemented using PyO3, which provides a safe and ergonomic way to create Python extensions in Rust. The bindings are located in the `tools/garaga_rs/src/python_bindings` directory.

## Adding a new binding

1. Create a new file in `tools/garaga_rs/src/python_bindings/` for your binding
2. Add the module to `mod.rs`
3. Implement your binding function
4. Register the function in the `garaga_rs` module

## Type Conversions

### Common Type Conversions

1. **Python Int -> Rust BigUint**
```rust
let py_int: &Bound<'_, PyInt> = ...;
let biguint: BigUint = py_int.extract()?;
```

2. **Rust BigUint -> Python Int**
```rust
let biguint: BigUint = ...;
Ok(biguint.into_pyobject(py)?.into())
```

3. **Python List -> Rust Vec**
```rust
let py_list: &Bound<'_, PyList> = ...;
let values: Vec<BigUint> = py_list
    .into_iter()
    .map(|x| x.extract())
    .collect::<Result<Vec<BigUint>, _>>()?;
```

4. **Python Bytes -> Rust Bytes**
```rust
let py_bytes: &Bound<'_, PyBytes> = ...;
let bytes = py_bytes.as_bytes();
```

5. **Field Elements**
```rust
// Python Int -> Field Element
let fe = element_from_biguint::<YourField>(&biguint);

// Field Element -> Python Int
let biguint = element_to_biguint(&fe);
```

### Error Handling

1. **Converting Rust Errors to Python**
```rust
// For custom errors
.map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

// For simple error propagation
.map_err(|e| PyErr::new::<pyo3::exceptions::PyValueError, _>(e.to_string()))?
```

2. **Enum Conversion**
```rust
let value = YourEnum::try_from(py_value)
    .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;
```

### Common Patterns

1. **Function Declaration**
```rust
#[pyfunction]
#[allow(clippy::too_many_arguments)]  // If needed for complex functions
pub fn your_function(
    py: Python,
    // ... parameters ...
) -> PyResult<PyObject> {
    // Implementation
}
```

2. **Returning Results**
```rust
// For single values
Ok(result.into_pyobject(py)?.into())

// For lists
let py_list = PyList::new(py, result);
Ok(py_list?.into())

// For tuples
Ok(PyTuple::new(py, &[x, y]).into())
```

## Example Implementation

Here's a complete example showing common patterns:

```rust
use pyo3::prelude::*;
use pyo3::types::{PyInt, PyList, PyBytes};
use num_bigint::BigUint;

#[pyfunction]
pub fn example_function(
    py: Python,
    input_int: &Bound<'_, PyInt>,
    input_list: &Bound<'_, PyList>,
    input_bytes: &Bound<'_, PyBytes>,
) -> PyResult<PyObject> {
    // Convert Python int to BigUint
    let value: BigUint = input_int.extract()?;

    // Convert Python list to Vec
    let values: Vec<BigUint> = input_list
        .into_iter()
        .map(|x| x.extract())
        .collect::<Result<Vec<BigUint>, _>>()?;

    // Get bytes
    let bytes = input_bytes.as_bytes();

    // Do your computation
    let result = process_data(&value, &values, bytes)
        .map_err(PyErr::new::<pyo3::exceptions::PyValueError, _>)?;

    // Return as Python list
    let py_list = PyList::new(py, result);
    Ok(py_list?.into())
}
```

## Registering Your Function

Add your function to the `garaga_rs` module in `mod.rs`:

```rust
#[pymodule]
fn garaga_rs(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(your_function, m)?)?;
    Ok(())
}
```

## Using the Bindings

After implementing and registering your binding, you can use it in Python like this:

```python
from garaga import garaga_rs

# For simple integer operations
result = garaga_rs.example_function(
    input_int=42,
    input_list=[1, 2, 3],
    input_bytes=b"some bytes"
)
```

## Testing

1. Add Python tests in `tests/hydra/`
2. Test both successful and error cases
3. Test edge cases (empty lists, zero values)

## Common Pitfalls

1. Always use `PyResult` for error handling
2. Remember to propagate errors with `?`
3. Handle edge cases (e.g., zero values, maximum values)
4. Be careful with memory management for large data structures

## Available Utilities

The following utilities are available in the codebase:

- `element_from_biguint`: Convert BigUint to Field Element
- `element_to_biguint`: Convert Field Element to BigUint
- `biguint_to_u256`: Convert BigUint to u256

## Building and Testing

1. Build/Update the Rust extension:
```bash
maturin develop --release --features python
```

2. Run tests:
```bash
pytest -xs
```

## Best Practices

1. Keep bindings simple and focused
2. Use appropriate error handling
3. Test edge cases thoroughly
4. Follow existing patterns in the codebase
