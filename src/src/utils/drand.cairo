use core::sha256::compute_sha256_u32_array;
use garaga::utils::usize_assert_eq;

use garaga::definitions::{G1Point, G2Point, u384};


// Chain: 52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971
//   Public Key:
//   G2Point(x=(2020076495541918814736776030432697997716141464538799718886374996015782362070437455929656164150586936230283253179482,
//   586231829158603972936263795113906716025771067144631327612230935308837823978471744132589153452744931590357767971921),
//   y=(1791278522428100783277199431487181031376873968689022069271761201187685493801088467849610331824611383166297460070456,
//   3748041376541174045371877684805027382480271890984968787916314231755985669195299696440090936404461850913289003455520),
//   curve_id=<CurveID.BLS12_381: 1>)
//   Period: 3 seconds
//   Genesis Time: 1692803367
//   Hash: 52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971
//   Group Hash: f477d5c89f21a17c863a7f937c6a6d15859414d2be09cd448d4279af331c5d3e
//   Scheme ID: bls-unchained-g1-rfc9380
//   Beacon ID: quicknet
// ----------------------------------------
// Note : Negated to use in pairing check.
const DRAND_QUICKNET_PUBLIC_KEY: G2Point =
    G2Point {
        x0: u384 {
            limb0: 0x4bc09e76eae8991ef5ece45a,
            limb1: 0xbd274ca73bab4af5a6e9c76a,
            limb2: 0x3aaf4bcb5ed66304de9cf809,
            limb3: 0xd1fec758c921cc22b0e17e6
        },
        x1: u384 {
            limb0: 0x6a0a6c3ac6a5776a2d106451,
            limb1: 0xb90022d3e760183c8c4b450b,
            limb2: 0xcad3912212c437e0073e911f,
            limb3: 0x3cf0f2896adee7eb8b5f01f
        },
        y0: u384 {
            limb0: 0xd183c7477c442b1f04515273,
            limb1: 0xd3022c5c37dce0f977d3adb5,
            limb2: 0xffca88b36c24f3012ba09fc4,
            limb3: 0xe5db2b6bfbb01c867749cad
        },
        y1: u384 {
            limb0: 0xd7a9718b047ccddb3eb5d68b,
            limb1: 0x4ededd8e63aef7be1aaf8e93,
            limb2: 0xa7c75ba902d163700a61bc22,
            limb3: 0x1a714f2edb74119a2f2b0d5
        }
    };


// pub fn round_to_message(round: u64) -> G1Point {
//     let mut message = G1Point::default();
//     let mut hash = compute_sha256_u32_array([round as u32]);
//     message.x0 = u384::from_bytes(&hash[..56]);
//     message.x1 = u384::from_bytes(&hash[56..112]);
//     message.y0 = u384::from_bytes(&hash[112..168]);
//     message.y1 = u384::from_bytes(&hash[168..224]);

// }

#[cfg(test)]
mod tests {
    use super::DRAND_QUICKNET_PUBLIC_KEY;
    use garaga::ec_ops::{G2PointTrait};

    #[test]
    fn test_drand_quicknet_public_key() {
        DRAND_QUICKNET_PUBLIC_KEY.assert_on_curve(1);
    }
}
