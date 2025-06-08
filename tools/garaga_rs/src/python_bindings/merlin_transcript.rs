use k256::elliptic_curve::generic_array::{typenum::U32, GenericArray};
use k256::elliptic_curve::sec1::FromEncodedPoint;
use k256::elliptic_curve::PrimeField;
use k256::{AffinePoint, EncodedPoint};
use k256::{FieldBytes, ProjectivePoint, Scalar};
use merlin::Transcript;
/// Python bindings for testing Transcript operations against Rust implementation
use pyo3::prelude::*;

#[pyclass]
pub struct PyMerlinTranscript {
    transcript: Transcript,
}

pub const MERLIN_PROTOCOL_LABEL: &[u8] = b"Merlin v1.0";

fn to_static(bytes: Vec<u8>) -> &'static [u8] {
    // 1. Turn the Vec into a boxed slice (keeps the same heap buffer).
    let boxed: Box<[u8]> = bytes.into_boxed_slice();

    // 2. Leak the Box, returning a &'static [u8].
    Box::leak(boxed)
}

#[pymethods]
impl PyMerlinTranscript {
    #[new]
    fn new(label: Vec<u8>) -> Self {
        PyMerlinTranscript {
            transcript: Transcript::new(to_static(label)),
        }
    }

    fn append_u64(&mut self, label: Vec<u8>, value: u64) {
        self.transcript.append_u64(to_static(label), value);
    }

    fn append_point(&mut self, label: Vec<u8>, x_bytes: Vec<u8>, y_bytes: Vec<u8>) -> PyResult<()> {
        let x_array = GenericArray::<u8, U32>::from_slice(&x_bytes);
        let y_array = GenericArray::<u8, U32>::from_slice(&y_bytes);

        let encoded = EncodedPoint::from_affine_coordinates(x_array, y_array, false);

        let affine = AffinePoint::from_encoded_point(&encoded);
        if affine.is_none().into() {
            return Err(PyErr::new::<pyo3::exceptions::PyValueError, _>(
                "Invalid point coordinates",
            ));
        }

        let point = ProjectivePoint::from(affine.unwrap());

        // Use compressed encoding for transcript (k256 default)
        use k256::elliptic_curve::group::GroupEncoding;
        let bytes = point.to_bytes();

        // println!(
        //     "[PYTHONBIND] Append point {:?} = {}",
        //     String::from_utf8_lossy(&label),
        //     hex::encode(&bytes)
        // );

        self.transcript.append_message(to_static(label), &bytes);
        Ok(())
    }

    fn challenge_scalar(&mut self, label: Vec<u8>) -> Vec<u8> {
        let length = 32;

        let mut result = vec![0u8; length];
        self.transcript
            .challenge_bytes(to_static(label.clone()), &mut result);

        let scalar = Scalar::from_repr(*FieldBytes::from_slice(&result)).unwrap();
        let scalar_bytes: Vec<u8> = scalar.to_bytes().to_vec();
        // println!(
        //     "[PYTHONBIND] Challenge {:?} = {}",
        //     String::from_utf8_lossy(&label),
        //     hex::encode(&scalar_bytes)
        // );

        scalar_bytes
    }
}
