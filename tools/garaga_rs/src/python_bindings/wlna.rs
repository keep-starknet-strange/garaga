use bp_pp::wnla::{Proof, WeightNormLinearArgument};
use hex;
use k256::elliptic_curve::scalar::FromUintUnchecked;
use k256::elliptic_curve::sec1::FromEncodedPoint;
use k256::{AffinePoint, EncodedPoint, ProjectivePoint, Scalar, U256};
use merlin::Transcript;
use pyo3::prelude::*;
/// Python-accessible WLNA proof structure
#[pyclass]
#[derive(Clone)]
pub struct PyWLNAProof {
    #[pyo3(get)]
    pub r: Vec<(String, String)>, // List of (x, y) coordinate pairs as hex strings
    #[pyo3(get)]
    pub x: Vec<(String, String)>, // List of (x, y) coordinate pairs as hex strings
    #[pyo3(get)]
    pub l: Vec<String>, // List of scalars as hex strings
    #[pyo3(get)]
    pub n: Vec<String>, // List of scalars as hex strings
}

#[pymethods]
impl PyWLNAProof {
    #[new]
    fn new(
        r: Vec<(String, String)>,
        x: Vec<(String, String)>,
        l: Vec<String>,
        n: Vec<String>,
    ) -> PyResult<Self> {
        Ok(Self { r, x, l, n })
    }

    fn __repr__(&self) -> String {
        format!(
            "PyWLNAProof(r={:?}, x={:?}, l={:?}, n={:?})",
            self.r, self.x, self.l, self.n
        )
    }

    fn __str__(&self) -> String {
        self.__repr__()
    }
}

// Register Python module - commented out to avoid submodule creation
// pub fn register_module(py: Python, parent_module: &Bound<'_, PyModule>) -> PyResult<()> {
//     let m = PyModule::new(py, "wlna")?;
//     m.add_function(wrap_pyfunction!(prove_wlna_with_challenges, &m)?)?;
//     m.add_function(wrap_pyfunction!(verify_wlna, &m)?)?;
//     m.add_class::<PyWLNAProof>()?;
//     parent_module.add_submodule(&m)?;
//     Ok(())
// }

/// Convert a ProjectivePoint to (x, y) hex string tuple
fn point_to_hex_tuple(point: &ProjectivePoint) -> (String, String) {
    use k256::elliptic_curve::sec1::ToEncodedPoint;

    let affine = point.to_affine();
    let encoded = affine.to_encoded_point(false); // false for uncompressed

    // Get x and y coordinates from the encoded point
    let x_bytes = encoded.x().expect("x coordinate should exist");
    let y_bytes = encoded
        .y()
        .expect("y coordinate should exist for uncompressed point");

    let x = hex::encode(x_bytes);
    let y = hex::encode(y_bytes);
    (x, y)
}

/// Convert a Scalar to hex string
fn scalar_to_hex(scalar: &Scalar) -> String {
    let bytes = scalar.to_bytes();
    hex::encode(&bytes)
}

/// Convert hex string to Scalar
fn hex_to_scalar(hex_str: &str) -> PyResult<Scalar> {
    let bytes = hex::decode(hex_str).map_err(|e| {
        PyErr::new::<pyo3::exceptions::PyValueError, _>(format!("Invalid hex: {}", e))
    })?;

    let x = Scalar::from_uint_unchecked(U256::from_be_slice(&bytes));
    return Ok(x);
}

/// Convert hex coordinate tuple to ProjectivePoint
pub fn hex_tuple_to_point(x_hex: &str, y_hex: &str) -> PyResult<ProjectivePoint> {
    let x_bytes = hex::decode(x_hex).map_err(|e| {
        PyErr::new::<pyo3::exceptions::PyValueError, _>(format!("Invalid x hex: {}", e))
    })?;
    let y_bytes = hex::decode(y_hex).map_err(|e| {
        PyErr::new::<pyo3::exceptions::PyValueError, _>(format!("Invalid y hex: {}", e))
    })?;

    // Create uncompressed point encoding (0x04 || x || y)
    let mut point_bytes = vec![0x04];
    point_bytes.extend_from_slice(&x_bytes);
    point_bytes.extend_from_slice(&y_bytes);

    let encoded = EncodedPoint::from_bytes(&point_bytes).map_err(|e| {
        PyErr::new::<pyo3::exceptions::PyValueError, _>(format!("Invalid point encoding: {:?}", e))
    })?;

    let affine = AffinePoint::from_encoded_point(&encoded);

    if affine.is_none().into() {
        return Err(PyErr::new::<pyo3::exceptions::PyValueError, _>(
            "Invalid point coordinates",
        ));
    }

    Ok(ProjectivePoint::from(affine.unwrap()))
}

/// Run the instrumented WLNA prove function and return proof + challenges
#[pyfunction]
pub fn prove_wlna_with_challenges(
    _py: Python,
    // Public parameters
    g_x: String,
    g_y: String,
    g_vec: Vec<(String, String)>,
    h_vec: Vec<(String, String)>,
    c_vec: Vec<String>,
    rho: String,
    mu: String,
    // Private inputs
    l_vec: Vec<String>,
    n_vec: Vec<String>,
) -> PyResult<PyWLNAProof> {
    // Convert inputs from hex strings
    let g = hex_tuple_to_point(&g_x, &g_y)?;

    let g_vec: Result<Vec<_>, _> = g_vec
        .iter()
        .map(|(x, y)| hex_tuple_to_point(x, y))
        .collect();
    let g_vec = g_vec?;

    let h_vec: Result<Vec<_>, _> = h_vec
        .iter()
        .map(|(x, y)| hex_tuple_to_point(x, y))
        .collect();
    let h_vec = h_vec?;

    let c_vec: Result<Vec<_>, _> = c_vec.iter().map(|s| hex_to_scalar(s)).collect();
    let c_vec = c_vec?;

    let rho = hex_to_scalar(&rho)?;
    let mu = hex_to_scalar(&mu)?;

    let l_vec: Result<Vec<_>, _> = l_vec.iter().map(|s| hex_to_scalar(s)).collect();
    let l_vec = l_vec?;

    let n_vec: Result<Vec<_>, _> = n_vec.iter().map(|s| hex_to_scalar(s)).collect();
    let n_vec = n_vec?;

    // Create WLNA instance
    let wnla = WeightNormLinearArgument {
        g,
        g_vec,
        h_vec,
        c: c_vec,
        rho,
        mu,
    };

    // Compute commitment
    let commitment = wnla.commit(&l_vec, &n_vec);

    // Debug print commitment
    // let commitment_affine = commitment.to_affine();
    // // let commitment_encoded = commitment_affine.to_encoded_point(false);
    // // // println!(
    // // //     "Rust commitment: x={}, y={}",
    // // //     hex::encode(commitment_encoded.x().unwrap()),
    // // //     hex::encode(commitment_encoded.y().unwrap())
    // // // );

    // Create transcript
    let mut transcript = Transcript::new(b"WLNA");

    // Run instrumented prove function
    let proof = wnla.prove(&commitment, &mut transcript, l_vec, n_vec);

    // Convert proof to Python types by extracting the fields
    let r: Vec<(String, String)> = proof.r.iter().map(point_to_hex_tuple).collect();
    let x: Vec<(String, String)> = proof.x.iter().map(point_to_hex_tuple).collect();
    let l: Vec<String> = proof.l.iter().map(scalar_to_hex).collect();
    let n: Vec<String> = proof.n.iter().map(scalar_to_hex).collect();

    // Create PyWLNAProof using the constructor
    let py_proof = PyWLNAProof::new(r, x, l, n)?;

    Ok(py_proof)
}

/// Verify a WLNA proof
#[pyfunction]
pub fn verify_wlna(
    _py: Python,
    // Public parameters
    g_x: String,
    g_y: String,
    g_vec: Vec<(String, String)>,
    h_vec: Vec<(String, String)>,
    c_vec: Vec<String>,
    rho: String,
    mu: String,
    // Commitment
    commitment_x: String,
    commitment_y: String,
    // Proof
    proof: &PyWLNAProof,
) -> PyResult<bool> {
    // Convert inputs
    let g = hex_tuple_to_point(&g_x, &g_y)?;
    let commitment = hex_tuple_to_point(&commitment_x, &commitment_y)?;

    let g_vec: Result<Vec<_>, _> = g_vec
        .iter()
        .map(|(x, y)| hex_tuple_to_point(x, y))
        .collect();
    let g_vec = g_vec?;

    let h_vec: Result<Vec<_>, _> = h_vec
        .iter()
        .map(|(x, y)| hex_tuple_to_point(x, y))
        .collect();
    let h_vec = h_vec?;

    let c_vec: Result<Vec<_>, _> = c_vec.iter().map(|s| hex_to_scalar(s)).collect();
    let c_vec = c_vec?;

    let rho = hex_to_scalar(&rho)?;
    let mu = hex_to_scalar(&mu)?;

    // Convert proof
    let r: Result<Vec<_>, _> = proof
        .r
        .iter()
        .map(|(x, y)| hex_tuple_to_point(x, y))
        .collect();
    let r = r?;

    let x: Result<Vec<_>, _> = proof
        .x
        .iter()
        .map(|(x, y)| hex_tuple_to_point(x, y))
        .collect();
    let x = x?;

    let l: Result<Vec<_>, _> = proof.l.iter().map(|s| hex_to_scalar(s)).collect();
    let l = l?;

    let n: Result<Vec<_>, _> = proof.n.iter().map(|s| hex_to_scalar(s)).collect();
    let n = n?;

    let rust_proof = Proof { r, x, l, n };

    // Create WLNA instance
    let wnla = WeightNormLinearArgument {
        g,
        g_vec,
        h_vec,
        c: c_vec,
        rho,
        mu,
    };

    // Create transcript and verify
    let mut transcript = Transcript::new(b"WLNA");
    Ok(wnla.verify(&commitment, &mut transcript, rust_proof))
}
