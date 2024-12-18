use core::sha256::{compute_sha256_u32_array, compute_sha256_byte_array};
use garaga::utils::usize_assert_eq;
use core::integer;

// sha256(b"risc0.ReceiptClaim") =
// 0xcb1fefcd1f2d9a64975cbbbf6e161e2914434b0cbb9960b84df5d717e86b48af
const TAG_DIGEST: [u32; 8] = [
    0xcb1fefcd, 0x1f2d9a64, 0x975cbbbf, 0x6e161e29, 0x14434b0c, 0xbb9960b8, 0x4df5d717, 0xe86b48af,
];

// 0xA3ACC27117418996340B84E5A90F3EF4C49D22C79E44AAD822EC9C313E1EB8E2
// https://github.com/risc0/risc0-ethereum/blob/34d2fee4ca6b5fb354a8a1a00c43f8945097bfe5/contracts/src/IRiscZeroVerifier.sol#L60
const SYSTEM_STATE_ZERO_DIGEST: [u32; 8] = [
    0xa3acc271, 0x17418996, 0x340b84e5, 0xa90f3ef4, 0xc49d22c7, 0x9e44aad8, 0x22ec9c31, 0x3e1eb8e2,
];

const INPUT_ZERO: [u32; 8] = [0, 0, 0, 0, 0, 0, 0, 0];

// sha256(b"risc0.Output") =
// 0x77eafeb366a78b47747de0d7bb176284085ff5564887009a5be63da32d3559d4
const RISC0_OUTPUT_TAG: [u32; 8] = [
    0x77eafeb3, 0x66a78b47, 0x747de0d7, 0xbb176284, 0x85ff556, 0x4887009a, 0x5be63da3, 0x2d3559d4,
];

fn uint256_byte_reverse(x: u256) -> u256 {
    let new_low = integer::u128_byte_reverse(x.high);
    let new_high = integer::u128_byte_reverse(x.low);
    return u256 { low: new_low, high: new_high };
}

pub fn journal_sha256(journal: Span<u8>) -> Span<u32> {
    let journal_arr: Array<u8> = journal.into();
    let mut journal_byte_arr = "";

    for byte in journal_arr {
        journal_byte_arr.append_byte(byte);
    };

    let journal_digest = compute_sha256_byte_array(@journal_byte_arr);

    return journal_digest.span();
}

// https://github.com/risc0/risc0-ethereum/blob/34d2fee4ca6b5fb354a8a1a00c43f8945097bfe5/contracts/src/IRiscZeroVerifier.sol#L71-L98
pub fn compute_receipt_claim(image_id: Span<u32>, journal_digest: Span<u32>) -> u256 {
    usize_assert_eq(image_id.len(), 8);

    let mut array = array![];

    // Tag digest
    for v in TAG_DIGEST.span() {
        array.append(*v);
    };

    // Input
    for v in INPUT_ZERO.span() {
        array.append(*v);
    };

    // Pre state digest
    for v in image_id {
        array.append(*v);
    };

    // Post state digest
    for v in SYSTEM_STATE_ZERO_DIGEST.span() {
        array.append(*v);
    };

    // Output
    let output_digest = output_digest(journal_digest);
    for v in output_digest.span() {
        array.append(*v);
    };

    // Exit_code system (0) (4 bytes) + Exit Code User (0) (4 bytes)
    array.append(0);
    array.append(0);

    // Append 4 << 8 = 1024 to the end of the array (2 bytes)
    let res_u32 = compute_sha256_u32_array(
        input: array, last_input_word: 1024, last_input_num_bytes: 2,
    )
        .span();

    let res_low: felt252 = (*res_u32[7]).into()
        + (*res_u32[6]).into() * 0x100000000
        + (*res_u32[5]).into() * 0x10000000000000000
        + (*res_u32[4]).into() * 0x1000000000000000000000000;

    let res_high: felt252 = (*res_u32[3]).into()
        + (*res_u32[2]).into() * 0x100000000
        + (*res_u32[1]).into() * 0x10000000000000000
        + (*res_u32[0]).into() * 0x1000000000000000000000000;

    return uint256_byte_reverse(
        u256 { low: res_low.try_into().unwrap(), high: res_high.try_into().unwrap() },
    );
}


fn output_digest(journal_digest: Span<u32>) -> [u32; 8] {
    let mut array = array![];
    usize_assert_eq(journal_digest.len(), 8);

    for v in RISC0_OUTPUT_TAG.span() {
        array.append(*v);
    };

    for v in journal_digest {
        array.append(*v);
    };

    // Assumptions digest
    for v in INPUT_ZERO.span() {
        array.append(*v);
    };

    // Add 2 << 8 = 512 to the end of the array (2 bytes)
    compute_sha256_u32_array(input: array, last_input_word: 512, last_input_num_bytes: 2)
}

#[cfg(test)]
mod risc0_utils_tests {
    use super::{compute_receipt_claim, output_digest, uint256_byte_reverse};
    #[test]
    fn test_receipt_claim() {
        let image_id: [u32; 8] = [
            3491501487, 2808651867, 557489759, 3452720932, 2727640576, 160202435, 1288430228,
            1807482899,
        ];
        let journal_digest: [u32; 8] = [
            998783442, 2641348904, 1804572153, 3329687312, 3249394632, 3219372246, 356247808,
            552440254,
        ];
        let receipt_claim = compute_receipt_claim(image_id.span(), journal_digest.span());
        assert_eq!(
            receipt_claim,
            uint256_byte_reverse(
                0xe58e40abecebcfa4af85692fca5ed77d4ccb4b3f640f5e684e4faf3a36b0c4e0,
            ),
        );
    }
    #[test]
    fn test_output_digest() {
        let journal_digest: [u32; 8] = [
            998783442, 2641348904, 1804572153, 3329687312, 3249394632, 3219372246, 356247808,
            552440254,
        ];
        let out = output_digest(journal_digest.span());
        assert_eq!(
            out,
            [
                0x6293f84a, 0xf9e28fcc, 0x43eb4d3d, 0xf962d8d8, 0x1364db76, 0x22a407a1, 0xab5be010,
                0x1a1f0a26,
            ],
        );
    }
}
