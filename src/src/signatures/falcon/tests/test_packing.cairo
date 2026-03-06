use corelib_imports::bounded_int::downcast;
use garaga::signatures::falcon::packing::{
    PackedPolynomial512, PackedPolynomial512Trait, pack_public_key, unpack_public_key,
};
use garaga::signatures::falcon::zq::Zq;

/// Test that pack -> unpack roundtrips correctly with known values.
#[test]
fn test_packing_roundtrip() {
    // Create 512 Zq values with varied pattern
    let mut values: Array<Zq> = array![];
    let mut i: u32 = 0;
    while i != 512 {
        let val: u16 = (i * 37 % 12289).try_into().unwrap();
        let zq: Zq = downcast(val).expect('val exceeds Q-1');
        values.append(zq);
        i += 1;
    }

    let packed = pack_public_key(values.span());
    assert!(packed.len() == 29, "expected 29 packed slots");
    let unpacked = unpack_public_key(packed.span());
    assert!(unpacked.len() == 512, "expected 512 unpacked values");

    // Verify roundtrip
    let mut j: u32 = 0;
    while j != 512 {
        assert!(*unpacked.at(j) == *values.at(j), "mismatch at index");
        j += 1;
    };
}

/// Test PackedPolynomial512 struct roundtrip.
#[test]
fn test_packed_polynomial_roundtrip() {
    let mut values: Array<Zq> = array![];
    let mut i: u32 = 0;
    while i != 512 {
        let val: u16 = (i * 13 % 12289).try_into().unwrap();
        let zq: Zq = downcast(val).expect('val exceeds Q-1');
        values.append(zq);
        i += 1;
    }

    let packed_struct = PackedPolynomial512Trait::from_coeffs(values.span());
    let unpacked = packed_struct.to_coeffs();

    let mut j: u32 = 0;
    while j != 512 {
        assert!(*unpacked.at(j) == *values.at(j), "struct roundtrip mismatch");
        j += 1;
    };
}
