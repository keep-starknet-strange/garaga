use core::sha256::compute_sha256_u32_array;
use garaga::utils::usize_assert_eq;

use garaga::definitions::{G1Point, G2Point, u384};


// Chain: 52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971
//   Public Key:
//   G2Point(x=(586231829158603972936263795113906716025771067144631327612230935308837823978471744132589153452744931590357767971921,
//   2020076495541918814736776030432697997716141464538799718886374996015782362070437455929656164150586936230283253179482),
//   y=(157365276123249055794009974722810729546735968119670709969124448693118085998446145254163043778273191605902036062307,
//   3628216628216130791012162643151307964576253676876037136272253230355582876849871985183130736411906174333527348545824),
//   curve_id=<CurveID.BLS12_381: 1>)
//   Period: 3 seconds
//   Genesis Time: 1692803367
//   Hash: 52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971
//   Group Hash: f477d5c89f21a17c863a7f937c6a6d15859414d2be09cd448d4279af331c5d3e
//   Scheme ID: bls-unchained-g1-rfc9380
//   Beacon ID: quicknet

const DRAND_QUICKNET_PUBLIC_KEY: G2Point =
    G2Point {
        x0: u384 {
            limb0: 0x6a0a6c3ac6a5776a2d106451,
            limb1: 0xb90022d3e760183c8c4b450b,
            limb2: 0xcad3912212c437e0073e911f,
            limb3: 0x3cf0f2896adee7eb8b5f01f
        },
        x1: u384 {
            limb0: 0x4bc09e76eae8991ef5ece45a,
            limb1: 0xbd274ca73bab4af5a6e9c76a,
            limb2: 0x3aaf4bcb5ed66304de9cf809,
            limb3: 0xd1fec758c921cc22b0e17e6
        },
        y0: u384 {
            limb0: 0x27b89e599f4e2420d69e5063,
            limb1: 0x76d7cb6ff8b2e4c81bf1c332,
            limb2: 0x3e04ee36c01d0972974f80e5,
            limb3: 0x105bd80aa07cbb3813e5686
        },
        y1: u384 {
            limb0: 0xd8e5ca9e04f893e0a4d50920,
            limb1: 0xf0696f89e0eb427dc9160525,
            limb2: 0x4ba5c2d4bfc7e5a24c5b985b,
            limb3: 0x1792b011c2d94b5ca056817b
        }
    };


#[cfg(test)]
mod tests {
    use super::DRAND_QUICKNET_PUBLIC_KEY;
    use garaga::ec_ops::{G2PointTrait};

    #[test]
    fn test_drand_quicknet_public_key() {
        DRAND_QUICKNET_PUBLIC_KEY.assert_on_curve(1);
    }
}
