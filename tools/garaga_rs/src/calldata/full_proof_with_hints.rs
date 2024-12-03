pub mod groth16;

#[cfg(test)]
mod tests_risc0_utils {
    use super::groth16::risc0_utils::{get_risc0_vk, ok_digest, split_digest};
    use super::groth16::{get_groth16_calldata, Groth16Proof};
    use crate::definitions::CurveID;
    use num_bigint::BigUint;
    use num_traits::Num;
    use sha2::{Digest, Sha256};
    #[test]
    fn test_ok_digest_1() {
        let image_id = vec![
            0xd0, 0x1c, 0x15, 0xaf, 0xa7, 0x68, 0xa0, 0x5b, 0x21, 0x3a, 0x9e, 0x5f, 0xcd, 0xcc,
            0x57, 0x24, 0xa2, 0x94, 0x7e, 0x00, 0x09, 0x8c, 0x7e, 0xc3, 0x4c, 0xcb, 0xe2, 0x94,
            0x6b, 0xbc, 0x00, 0x13,
        ];
        let journal = vec![
            0x6a, 0x75, 0x73, 0x74, 0x20, 0x61, 0x20, 0x73, 0x69, 0x6d, 0x70, 0x6c, 0x65, 0x20,
            0x72, 0x65, 0x63, 0x65, 0x69, 0x70, 0x74,
        ];
        let journal_digest = Sha256::digest(&journal);
        let digest = ok_digest(&image_id, &journal_digest);

        let (claim0, claim1) = split_digest(&BigUint::from_bytes_be(&digest));
        assert_eq!(
            hex::encode(digest),
            "e58e40abecebcfa4af85692fca5ed77d4ccb4b3f640f5e684e4faf3a36b0c4e0"
        );

        assert_eq!(
            hex::encode(claim0.to_bytes_be()),
            "7dd75eca2f6985afa4cfebecab408ee5"
        );

        assert_eq!(
            hex::encode(claim1.to_bytes_be()),
            "e0c4b0363aaf4f4e685e0f643f4bcb4c"
        );
    }

    #[test]
    fn test_ok_digest_2() {
        let image_id = vec![
            0x07, 0x9f, 0x23, 0xf1, 0x3e, 0xa8, 0x1b, 0xde, 0x11, 0xa9, 0x49, 0x12, 0xba, 0xdf,
            0xe8, 0xd9, 0x2d, 0x5b, 0xe1, 0x13, 0x4b, 0x2c, 0x99, 0x1b, 0x99, 0x55, 0xe9, 0xc1,
            0x89, 0x41, 0xba, 0x69,
        ];

        let journal: Vec<u8> = vec![0x01, 0x00, 0x00, 0x78];
        let journal_digest = Sha256::digest(&journal);
        let digest = ok_digest(&image_id, &journal_digest);

        let (claim0, claim1) = split_digest(&BigUint::from_bytes_be(&digest));
        assert_eq!(
            hex::encode(claim0.to_bytes_be()),
            "d284212f0d87311c45e710301d86639f"
        );
        assert_eq!(
            hex::encode(claim1.to_bytes_be()),
            "8875bcad22cdcfda1e2878df4e414108"
        );
    }
}
