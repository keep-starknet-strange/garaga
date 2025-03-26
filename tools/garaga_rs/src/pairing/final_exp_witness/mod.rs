pub mod bls12_381_final_exp_witness;
pub mod bn254_final_exp_witness;
use crate::definitions::{BLS12381PrimeField, BN254PrimeField};
use crate::io::{element_from_biguint, element_to_biguint};
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381;
use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254;

use lambdaworks_math::field::element::FieldElement;
use num_bigint::BigUint;

pub fn to_bn(v: FieldElement<bn_254::field_extension::Degree12ExtensionField>) -> [BigUint; 12] {
    let [c0, c1] = v.value();
    let [c0b0, c0b1, c0b2] = c0.value();
    let [c1b0, c1b1, c1b2] = c1.value();
    let [c0b0a0, c0b0a1] = c0b0.value();
    let [c0b1a0, c0b1a1] = c0b1.value();
    let [c0b2a0, c0b2a1] = c0b2.value();
    let [c1b0a0, c1b0a1] = c1b0.value();
    let [c1b1a0, c1b1a1] = c1b1.value();
    let [c1b2a0, c1b2a1] = c1b2.value();
    [
        element_to_biguint(c0b0a0),
        element_to_biguint(c0b0a1),
        element_to_biguint(c0b1a0),
        element_to_biguint(c0b1a1),
        element_to_biguint(c0b2a0),
        element_to_biguint(c0b2a1),
        element_to_biguint(c1b0a0),
        element_to_biguint(c1b0a1),
        element_to_biguint(c1b1a0),
        element_to_biguint(c1b1a1),
        element_to_biguint(c1b2a0),
        element_to_biguint(c1b2a1),
    ]
}

pub fn to_bls(
    v: FieldElement<bls12_381::field_extension::Degree12ExtensionField>,
) -> [BigUint; 12] {
    let [c0, c1] = v.value();
    let [c0b0, c0b1, c0b2] = c0.value();
    let [c1b0, c1b1, c1b2] = c1.value();
    let [c0b0a0, c0b0a1] = c0b0.value();
    let [c0b1a0, c0b1a1] = c0b1.value();
    let [c0b2a0, c0b2a1] = c0b2.value();
    let [c1b0a0, c1b0a1] = c1b0.value();
    let [c1b1a0, c1b1a1] = c1b1.value();
    let [c1b2a0, c1b2a1] = c1b2.value();
    [
        element_to_biguint(c0b0a0),
        element_to_biguint(c0b0a1),
        element_to_biguint(c0b1a0),
        element_to_biguint(c0b1a1),
        element_to_biguint(c0b2a0),
        element_to_biguint(c0b2a1),
        element_to_biguint(c1b0a0),
        element_to_biguint(c1b0a1),
        element_to_biguint(c1b1a0),
        element_to_biguint(c1b1a1),
        element_to_biguint(c1b2a0),
        element_to_biguint(c1b2a1),
    ]
}

pub fn get_final_exp_witness(curve_id: usize, f: [BigUint; 12]) -> ([BigUint; 12], [BigUint; 12]) {
    let [f_0, f_1, f_2, f_3, f_4, f_5, f_6, f_7, f_8, f_9, f_10, f_11] = f;

    if curve_id == 0 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bn_254::field_extension::{Degree12ExtensionField, Degree6ExtensionField, Degree2ExtensionField};

        let f = FieldElement::<Degree12ExtensionField>::new([
            FieldElement::<Degree6ExtensionField>::new([
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_0),
                    element_from_biguint::<BN254PrimeField>(&f_1),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_2),
                    element_from_biguint::<BN254PrimeField>(&f_3),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_4),
                    element_from_biguint::<BN254PrimeField>(&f_5),
                ]),
            ]),
            FieldElement::<Degree6ExtensionField>::new([
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_6),
                    element_from_biguint::<BN254PrimeField>(&f_7),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_8),
                    element_from_biguint::<BN254PrimeField>(&f_9),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BN254PrimeField>(&f_10),
                    element_from_biguint::<BN254PrimeField>(&f_11),
                ]),
            ]),
        ]);
        let (c, wi) = bn254_final_exp_witness::get_final_exp_witness(f);

        return (to_bn(c), to_bn(wi));
    }

    if curve_id == 1 {
        use lambdaworks_math::elliptic_curve::short_weierstrass::curves::bls12_381::field_extension::{Degree12ExtensionField, Degree6ExtensionField, Degree2ExtensionField};

        let f = FieldElement::<Degree12ExtensionField>::new([
            FieldElement::<Degree6ExtensionField>::new([
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_0),
                    element_from_biguint::<BLS12381PrimeField>(&f_1),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_2),
                    element_from_biguint::<BLS12381PrimeField>(&f_3),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_4),
                    element_from_biguint::<BLS12381PrimeField>(&f_5),
                ]),
            ]),
            FieldElement::<Degree6ExtensionField>::new([
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_6),
                    element_from_biguint::<BLS12381PrimeField>(&f_7),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_8),
                    element_from_biguint::<BLS12381PrimeField>(&f_9),
                ]),
                FieldElement::<Degree2ExtensionField>::new([
                    element_from_biguint::<BLS12381PrimeField>(&f_10),
                    element_from_biguint::<BLS12381PrimeField>(&f_11),
                ]),
            ]),
        ]);
        let (c, wi) = bls12_381_final_exp_witness::get_final_exp_witness(f);
        return (to_bls(c), to_bls(wi));
    }

    panic!("Curve ID {} not supported", curve_id);
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::definitions::{BLS12381PrimeField, BN254PrimeField, FieldElement};
    use crate::io::element_to_biguint;

    #[test]
    fn get_final_exp_witness_1() {
        let x = [
            "0x1783da1d016c7d380bab8db21a4f525528f83278c6254b13db77fe8107a60be8",
            "0x4416c4d771078798075d9cc460c7e56f7f542684531e2ee2edbac2c6ebbdbaa",
            "0xaea0397220f7c7c61e7177abe59b7dfae731041bb381ea6993f45b251ae79ce",
            "0x29b9c51055891c1a3b737806faf180242ad61412f5085b626fc947d8aee4d4c5",
            "0xa6cd400de616117bc7c37de0c125e55223b735265eca4e175be078132ad0392",
            "0x28c17a415e6aab151f632943c971274916c89f88e0826a7ad992060e110cf9a8",
            "0x218f7d922f219475c106f110a215a256f4c6853d96d4691f93ef8def3553244d",
            "0x18ba4cb6edcb80bdd3f053158786731fd54bd02afc16a4d65e82d41ee8f71269",
            "0x3ade11ccef2e9df15c2b9fa6144b5c707dd49b92fb62a4382f3c2e94ac20c84",
            "0x201b5f896062f80674ac89dc04ef8753139fbf37db26c3c7c9614977f007260d",
            "0x11f27b345af3ee8d876267a812b60c46c3868500f2e402d0493bc689dd6c5277",
            "0x2cde97e8c9b263ffbcb53d46c4ed015fdeeb692d8fbf301ad8dc0c1e656d5c27",
        ];
        let y = [
            "0x245ada43681e3fbfea7633e5b99e404689d12f34fdc497e0c8b1e9d7c0e70147",
            "0x1750bd450b85cbd62ea3f1b228beff5fd364a127d6054be99a9248497b82062a",
            "0x5fa554b43f992af3cafd815d8f8599a376aad62d4b1d5ce72258252c571032",
            "0x28d156bac04e64938816b055888399c99a954b82724e5f5589d549a709b2b5ef",
            "0x1cd18658560e13f8683504c35d79e2f868d084e0e5a1b8af88d272078bbdb360",
            "0x14853f940bf5c557c7f558d3e74e6617d7f08b54fd83597fed1d7e7b9d09e04",
            "0x212503c88e25ac77cdc82120a45b9d5886f287f15e649d4f8488d7e2b856b2fa",
            "0x1248cfad33a2147726169d3ce55db12ecafd74bc4b83377c168d89b919386546",
            "0x2b8d7a45d0b0b47e0c1f391b0bacd25e7f882f16085c7c9099e4ba82d71bf23e",
            "0x39e1ab153bd709556afece475580f453f9126f256fbb49c235bc75082f5f26e",
            "0x2cd3e748118f3965ceaf7fd505e039f23e7d6d69f8ceb25d288d1f797012a4cb",
            "0xaa480d613601947fee14a3ce2b7af4e1872fe49ae3473546aa01a618b78b125",
        ];
        let z = [
            "0x1", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0",
        ];
        let x = x
            .into_iter()
            .map(|v| element_to_biguint(&FieldElement::<BN254PrimeField>::from_hex(v).unwrap()))
            .collect::<Vec<_>>();
        let xy = y
            .into_iter()
            .map(|v| element_to_biguint(&FieldElement::<BN254PrimeField>::from_hex(v).unwrap()))
            .collect::<Vec<_>>();
        let xz = z
            .into_iter()
            .map(|v| element_to_biguint(&FieldElement::<BN254PrimeField>::from_hex(v).unwrap()))
            .collect::<Vec<_>>();
        let (y, z) = get_final_exp_witness(0, x.try_into().unwrap());
        assert_eq!(y.to_vec(), xy);
        assert_eq!(z.to_vec(), xz);
    }

    #[test]
    fn get_final_exp_witness_2() {
        let x = ["0x189edeac1525a5256ae8c76a82b4df330e0fdac10c95d7fb5f01e6c6b243a52cc62f55f9b74e8bcef7cf857ec72dce93", "0x1c5cc475a78741fb935272142f80370ecc6a698ef863d33e5e187f3cd4fcdb91c49236aafcce6c2b7e91ff0678305ee", "0x38f22b3f8377694c4b17bbea3afd26c71d6c07f64c4661a0d8d77bc9f8f1752bfcbe1e3c6ab95b6eb522fa601ea9305", "0x431d707ff3a55977c4868bc4de8c336ecf67b804ac90c2c739ff85161bbe9a730e3021edaed5902502eb385ea4cc50c", "0x14a833d75d7614710c13c79f3df94ae7d9fa9ec20fa02356381fd6755be5a71ca30e230a1bece62346f0bcfa0f10c949", "0x12bd3ae4a4aca5e0db13fd94c2c2b0127ee3d7d9491d3fa7faa9fb6046a0543f1092c5761636021e091d1a18beeccfba", "0x8577fff37edfad39505f3c47bd6df6fdd80d5f75aff4efd05edf11725abf6458c140d50d4b33c0560aaed4d8167373b", "0x71ad85945ebc453009cb5cf204e41fa0caf2075fc94cf9a57b2460ca293b6eb5c12df3ceb0d17ca563eb044181077c", "0xe17d78c3c7663a52347558b81f589708ad2e84bd32830f61b9d25f1d8f2fe668f9548e4f6bc8a2a6cbf63f72e538a1", "0x15b2f2eca1e3e6c52dc3e40ccdef2f63d0085c459442bdbf592cb6df02973c4f21c96db9ee3d7084d33b0699d260eb06", "0x110cf0e03683bd834bf62dfa7717e01f244814560f4bd540f96ab24703ecc763272a2594a640383e1496b1d6cbdd032f", "0xc54fb45e0131b724250f6b3cf02d8287133dd162bf106ab6ed3d3101b20f9045c77b25ad127a0e193d95f573796e10"];
        let y = ["0x12deecbe6648e28516e35daa1e0c318027b97f93995f24274523f4382c02ce6aacce3efefec37100737f82dfe340a4d3", "0xb417c5f4b0e31cdc36e64f4220554380793013c3a3a18557ce659630295c5e67e4cc6131699b575e3435a2c495d3d34", "0x21b2745b9213155921a4e4f1f78aa93aacf1acab10c8f49685f617c0c881fd11ccb4a00d6198229a0f329755fdaa894", "0x174ce865876ea77ee960d6a7b9eada1e4b8afab93489903fbed3dd36c52f4b70fc0d52418a67418ee47875805d80b77d", "0x11307f8213b5a5cf011068461c937525fcc1bac74e8440a0011e899805c83143f52e11e2540f90027da0a3795bdbc359", "0x1976eebc878d175bc93678c0985755703c9866091b78ec8bef5f8948f3b6fa174a284c65e9913a4346aa72b17c319aa", "0xa35d36af451eb622dc96a60848761402315cca37f2fa9e861fb1ac89348be93bf05793ed4ac0c9fd9de3befa4f2577c", "0x36837217109690a2f7f6cd5df81e0f5d49597d200624b374626abf6d941253feb172c215a05d52f76a75caf3b6ea5d2", "0x3f0bccdc44d95bf26b464dcc1a586b8521061565c1ee05cfba8cb30479aaf08448f6451ea7fdc3fff0efd54f27ec0fb", "0xb98f31f1bce837a3fee2cd18f3d43a542e2b386b893be959d87e1541dd78939de6b6e3050e52f17111ab805cf5c0434", "0x177f4b467a8559f03d1ce53454a64dd7a5fdc0e2a0d2cb6593184986d2dcc78dab7bf8e95a1e41b3ed044ebe3aa84c2f", "0xb26abddfd9c70b423b180f3ea13c507dbe3396e795d2f2f8a303718e823dfb73f1073bdf99057642a29280f237244ef"];
        let z = ["0x0", "0x0", "0x18bc5b99f39cbf0fd8d087688e9a0930581e2c940247cd0991e7a80fe41d8f58d83f1513f1ca42a0e74df934924892fb", "0x18bc5b99f39cbf0fd8d087688e9a0930581e2c940247cd0991e7a80fe41d8f58d83f1513f1ca42a0e74df934924892fb", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0", "0x0"];
        let x = x
            .into_iter()
            .map(|v| element_to_biguint(&FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap()))
            .collect::<Vec<_>>();
        let xy = y
            .into_iter()
            .map(|v| element_to_biguint(&FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap()))
            .collect::<Vec<_>>();
        let xz = z
            .into_iter()
            .map(|v| element_to_biguint(&FieldElement::<BLS12381PrimeField>::from_hex(v).unwrap()))
            .collect::<Vec<_>>();
        let (y, z) = get_final_exp_witness(1, x.try_into().unwrap());
        assert_eq!(y.to_vec(), xy);
        assert_eq!(z.to_vec(), xz);
    }
}
