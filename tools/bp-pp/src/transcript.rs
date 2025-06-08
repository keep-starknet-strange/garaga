use k256::elliptic_curve::group::GroupEncoding;
use k256::elliptic_curve::PrimeField;
use k256::{FieldBytes, ProjectivePoint, Scalar};
use merlin::Transcript;

pub fn app_u64(label: &'static [u8], value: u64, t: &mut Transcript) {
    // println!(
    //     "[RUST] Append u64 {:?} = {}",
    //     String::from_utf8_lossy(label),
    //     value
    // );
    t.append_u64(label, value);
}

pub fn app_point(label: &'static [u8], p: &ProjectivePoint, t: &mut Transcript) {
    let bytes = p.to_bytes();
    let bytes_slice = bytes.as_slice();

    // println!(
    //     "[RUST] Append point {:?} = {}",
    //     String::from_utf8_lossy(label),
    //     hex::encode(bytes_slice)
    // );

    t.append_message(label, bytes_slice);
}

pub fn get_challenge(label: &'static [u8], t: &mut Transcript) -> Scalar {
    let mut buf = [0u8; 32];
    t.challenge_bytes(label, &mut buf);

    // println!(
    //     "[RUST] Challenge {:?} = {}",
    //     String::from_utf8_lossy(label),
    //     hex::encode(&buf)
    // );

    Scalar::from_repr(*FieldBytes::from_slice(&buf)).unwrap()
}
