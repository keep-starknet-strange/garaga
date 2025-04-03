use core::fmt;

// use arbitrary::Arbitrary;
// use bfieldcodec_derive::BFieldCodec;
// use get_size2::GetSize;
// use itertools::Itertools;
// use num_traits::Zero;
// use rand::distr::Distribution;
// use rand::distr::StandardUniform;
// use rand::Rng;
// use serde::Deserialize;
// use serde::Deserializer;
// use serde::Serialize;
// use serde::Serializer;

// use crate::crypto::poseidon_bn254::poseidon_hash_bn254;
use crate::crypto::poseidon_bn254::poseidon_hash_bn254;
use crate::definitions::{FieldElement, GrumpkinPrimeField, Random};
// use crate::error::TryFromDigestError;
// use crate::error::TryFromHexDigestError;
// use crate::math::b_field_element::BFieldElement;
// use crate::prelude::Tip5;

/// A trait defining the hash function interface
pub trait HashFunction: Clone + Copy + fmt::Debug + PartialEq {
    /// The type of elements being hashed
    type Element: Clone + Copy + PartialEq + Eq + Default + fmt::Debug + From<u64>;

    /// Hash two elements together
    fn hash_pair(left: &Self::Element, right: &Self::Element) -> Self::Element;
    fn hash_single(element: &Self::Element) -> Self::Element;
    fn random() -> Self::Element;
}

// /// A fixed-size array of BFieldElements
// #[derive(Clone, Copy, Debug, PartialEq, Eq)]
// pub struct Tip5Element([BFieldElement; 5]);

// /// Implementation for Tip5 hash function
// pub struct Tip5Hash;

// impl HashFunction for Tip5Hash {
//     type Element = Tip5Element;

//     fn hash_pair(left: &Self::Element, right: &Self::Element) -> Self::Element {
//         let result = Tip5::hash_pair(&left.0, &right.0);
//         Tip5Element(result.try_into().unwrap())
//     }
// }

/// Implementation for Poseidon BN254 hash function
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct PoseidonBn254Hash;

impl HashFunction for PoseidonBn254Hash {
    type Element = FieldElement<GrumpkinPrimeField>;

    fn hash_pair(left: &Self::Element, right: &Self::Element) -> Self::Element {
        poseidon_hash_bn254(left, right)
    }
    fn hash_single(element: &Self::Element) -> Self::Element {
        let zero = FieldElement::<GrumpkinPrimeField>::zero();
        poseidon_hash_bn254(element, &zero)
    }
    fn random() -> Self::Element {
        FieldElement::<GrumpkinPrimeField>::random()
    }
}

/// Generate a vector of n random digests for the given hash function type
pub fn random_elements<H: HashFunction>(n: usize) -> Vec<Digest<H>> {
    (0..n).map(|_| Digest::new(H::random())).collect()
}

/// A fixed-size digest for hash functions
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash)]
pub struct Digest<H: HashFunction>
where
    H::Element: Clone + Copy + PartialEq + Eq + fmt::Debug,
{
    pub data: H::Element,
}

impl<H: HashFunction> Digest<H> {
    /// The number of bytes in a digest.
    // pub const BYTES: usize = BFieldElement::BYTES;
    /// The all-zero digest.
    pub(crate) fn all_zero() -> Self {
        Self {
            data: H::Element::default(),
        }
    }

    pub const fn value(self) -> H::Element {
        self.data
    }

    pub const fn new(element: H::Element) -> Self {
        Self { data: element }
    }

    /// Hash this digest using the specified hash function H
    pub fn hash_pair(left: &Self, right: &Self) -> Self {
        Self {
            data: H::hash_pair(&left.data, &right.data),
        }
    }

    pub fn to_element(self) -> H::Element {
        self.data
    }

    pub fn from_element(element: H::Element) -> Self {
        Self { data: element }
    }
}

impl<H: HashFunction> Default for Digest<H> {
    fn default() -> Self {
        Self::all_zero()
    }
}

impl<H: HashFunction> fmt::Display for Digest<H> {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "{:?}", self.data)
    }
}

// impl<H: HashFunction> fmt::LowerHex for Digest<H> {
//     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
//         let bytes = <[u8; Self::BYTES]>::from(*self);
//         write!(f, "{}", hex::encode(bytes))
//     }
// }

// impl<H: HashFunction> fmt::UpperHex for Digest<H> {
//     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
//         let bytes = <[u8; Self::BYTES]>::from(*self);
//         write!(f, "{}", hex::encode_upper(bytes))
//     }
// }

// impl<H: HashFunction> Distribution<Digest<H>> for StandardUniform {
//     fn sample<R: Rng + ?Sized>(&self, rng: &mut R) -> Digest<H> {
//         Digest::new(rng.random())
//     }
// }

// impl<H: HashFunction> FromStr for Digest<H> {
//     type Err = TryFromDigestError;

//     fn from_str(string: &str) -> Result<Self, Self::Err> {
//         let bfes: Vec<_> = string
//             .split(',')
//             .map(str::parse::<H::Element>)
//             .try_collect()?;
//         let invalid_len_err = Self::Err::InvalidLength(bfes.len());
//         let digest_innards = bfes.try_into().map_err(|_| invalid_len_err)?;

//         Ok(Digest {
//             data: digest_innards,
//         })
//     }
// }

#[derive(Debug)]
pub struct TryFromDigestError;

#[derive(Debug)]
pub struct TryFromHexDigestError;

// impl<H: HashFunction> TryFrom<Vec<H::Element>> for Digest<H> {
//     type Error = TryFromDigestError;

//     fn try_from(value: Vec<H::Element>) -> Result<Self, Self::Error> {
//         Digest::try_from(&value as &[H::Element])
//     }
// }

// impl<H: HashFunction> From<Digest<H>> for Vec<H::Element> {
//     fn from(val: Digest<H>) -> Self {
//         val.data.to_vec()
//     }
// }

// impl<H: HashFunction> From<Digest<H>> for [u8; BFieldElement::BYTES] {
//     fn from(Digest { data }: Digest<H>) -> Self {
//         // This needs to be implemented based on how you want to serialize your Element type
//         unimplemented!("Implement byte serialization for Element type")
//     }
// }

// impl<H: HashFunction> TryFrom<[u8; BFieldElement::BYTES]> for Digest<H> {
//     type Error = TryFromDigestError;

//     fn try_from(bytes: [u8; BFieldElement::BYTES]) -> Result<Self, Self::Error> {
//         // This needs to be implemented based on how you want to deserialize your Element type
//         unimplemented!("Implement byte deserialization for Element type")
//     }
// }

// impl<H: HashFunction> TryFrom<BigUint> for Digest<H>
// where
//     H::Element: TryFrom<BigUint, Error = TryFromDigestError>,
// {
//     type Error = TryFromDigestError;

//     fn try_from(value: BigUint) -> Result<Self, Self::Error> {
//         let mut remaining = value;
//         let mut digest_innards = H::Element::ZERO;
//         let modulus: BigUint = BFieldElement::P.into();
//         for digest_element in &mut digest_innards {
//             let element = u64::try_from(remaining.clone() % modulus.clone()).unwrap();
//             *digest_element = H::Element::new(element);
//             remaining /= modulus.clone();
//         }

//         if !remaining.is_zero() {
//             return Err(Self::Error::Overflow);
//         }

//         Ok(Self {
//             data: digest_innards,
//         })
//     }
// }

// impl<H: HashFunction> From<Digest<H>> for BigUint
// where
//     H::Element: Into<BigUint>,
// {
//     fn from(digest: Digest<H>) -> Self {
//         let Digest { data } = digest;
//         let mut ret = BigUint::zero();
//         let modulus: BigUint = BFieldElement::P.into();
//         for i in (0..BFieldElement::BYTES).rev() {
//             ret *= modulus.clone();
//             let digest_element: BigUint = data[i].value().into();
//             ret += digest_element;
//         }

//         ret
//     }
// }

// impl<H: HashFunction> Digest<H> {
//     /// Encode digest as hex.
//     ///
//     /// Since `Digest` also implements [`LowerHex`][lo] and [`UpperHex`][up], it is
//     /// possible to `{:x}`-format directly, _e.g._, `print!("{digest:x}")`.
//     ///
//     /// [lo]: fmt::LowerHex
//     /// [up]: fmt::UpperHex
//     pub fn to_hex(self) -> String {
//         format!("{self:x}")
//     }

//     /// Decode hex string to [`Digest`]. Must not include leading "0x".
//     pub fn try_from_hex(data: impl AsRef<[u8]>) -> Result<Self, TryFromHexDigestError> {
//         let slice = hex::decode(data)?;
//         Ok(Self::try_from(&slice as &[u8])?)
//     }
// }

// we implement Serialize so that we can serialize as hex for human readable
// formats like JSON but use default serializer for other formats likes bincode
// impl<H: HashFunction> Serialize for Digest<H>
// where
//     H::Element: Serialize,
// {
//     fn serialize<S>(&self, serializer: S) -> Result<S::Ok, S::Error>
//     where
//         S: Serializer,
//     {
//         if serializer.is_human_readable() {
//             self.to_hex().serialize(serializer)
//         } else {
//             self.data.serialize(serializer)
//         }
//     }
// }

// we impl Deserialize so that we can deserialize as hex for human readable
// formats like JSON but use default deserializer for other formats like bincode
// impl<'de, H: HashFunction> Deserialize<'de> for Digest<H>
// where
//     H::Element: Deserialize<'de>,
// {
//     fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
//     where
//         D: Deserializer<'de>,
//     {
//         if deserializer.is_human_readable() {
//             let hex_string = String::deserialize(deserializer)?;
//             Self::try_from_hex(hex_string).map_err(serde::de::Error::custom)
//         } else {
//             Ok(Self::new(H::Element::deserialize(deserializer)?))
//         }
//     }
// }

// Implement conversion between Digest and FieldElement for PoseidonBn254
impl From<Digest<PoseidonBn254Hash>> for FieldElement<GrumpkinPrimeField> {
    fn from(_digest: Digest<PoseidonBn254Hash>) -> Self {
        // Implement conversion logic here
        // This might need to be adjusted based on your specific requirements
        unimplemented!("Need to implement conversion from Digest to FieldElement")
    }
}

impl From<FieldElement<GrumpkinPrimeField>> for Digest<PoseidonBn254Hash> {
    fn from(_field: FieldElement<GrumpkinPrimeField>) -> Self {
        // Implement conversion logic here
        // This might need to be adjusted based on your specific requirements
        unimplemented!("Need to implement conversion from FieldElement to Digest")
    }
}

// // Keep existing implementations but make them generic over H
// impl<H: HashFunction> PartialOrd for Digest<H> {
//     fn partial_cmp(&self, other: &Self) -> Option<std::cmp::Ordering> {
//         self.data.partial_cmp(&other.data)
//     }
// }

// impl<H: HashFunction> Ord for Digest<H> {
//     fn cmp(&self, other: &Self) -> std::cmp::Ordering {
//         self.data.cmp(&other.data)
//     }
// }

// impl<H: HashFunction> GetSize for Digest<H>
// where
//     H::Element: GetSize,
// {
//     fn get_stack_size() -> usize {
//         std::mem::size_of::<Self>()
//     }

//     fn get_heap_size(&self) -> usize {
//         self.data.get_heap_size()
//     }
// }

// impl fmt::Display for Tip5Element {
//     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
//         write!(f, "{:?}", self.0)
//     }
// }

// // Implement conversion between array and Tip5Element
// impl From<[BFieldElement; 5]> for Tip5Element {
//     fn from(array: [BFieldElement; 5]) -> Self {
//         Self(array)
//     }
// }

// impl From<Tip5Element> for [BFieldElement; 5] {
//     fn from(element: Tip5Element) -> Self {
//         element.0
//     }
// }

// // Add AsRef for convenient slice access
// impl AsRef<[BFieldElement]> for Tip5Element {
//     fn as_ref(&self) -> &[BFieldElement] {
//         &self.0
//     }
// }

// // Add AsMut for convenient mutable slice access
// impl AsMut<[BFieldElement]> for Tip5Element {
//     fn as_mut(&mut self) -> &mut [BFieldElement] {
//         &mut self.0
//     }
// }

// // Add these impls
// impl<H: HashFunction> From<Digest<H>> for H::Element {
//     fn from(digest: Digest<H>) -> Self {
//         digest.data
//     }
// }

impl<H: HashFunction> AsRef<H::Element> for Digest<H> {
    fn as_ref(&self) -> &H::Element {
        &self.data
    }
}

impl<'a, H: HashFunction> arbitrary::Arbitrary<'a> for Digest<H> {
    fn arbitrary(_u: &mut arbitrary::Unstructured<'a>) -> arbitrary::Result<Self> {
        Ok(Self::new(H::random()))
    }
}

// #[cfg(test)]
// pub(crate) mod digest_tests {
//     use num_traits::One;
//     use proptest::collection::vec;
//     use proptest::prelude::Arbitrary as ProptestArbitrary;
//     use proptest::prelude::*;
//     use proptest_arbitrary_interop::arb;
//     use test_strategy::proptest;

//     use super::*;
//     // use crate::prelude::*;

//     impl ProptestArbitrary for Digest<PoseidonBn254Hash> {
//         type Parameters = ();
//         fn arbitrary_with(_args: Self::Parameters) -> Self::Strategy {
//             arb().prop_map(|d| d).no_shrink().boxed()
//         }

//         type Strategy = BoxedStrategy<Self>;
//     }

//     /// Test helper struct for corrupting digests. Primarily used for negative tests.
//     #[derive(Debug, Clone, PartialEq, Eq, test_strategy::Arbitrary)]
//     pub(crate) struct DigestCorruptor;

//     impl DigestCorruptor {
//         pub fn corrupt_digest<H: HashFunction>(&self, digest: Digest<H>) -> Digest<H> {
//             // Generate a new random digest different from the input
//             loop {
//                 let new_digest = Digest::new(H::random());
//                 if new_digest != digest {
//                     return new_digest;
//                 }
//             }
//         }
//     }

//     // mod serde_test {
//     //     use super::hex_test::hex_examples;
//     //     use super::*;

//     //     mod json_test {
//     //         use super::*;

//     //         #[test]
//     //         fn serialize() -> Result<(), serde_json::Error> {
//     //             for (digest, hex) in hex_examples() {
//     //                 assert_eq!(serde_json::to_string(&digest)?, format!("\"{}\"", hex));
//     //             }
//     //             Ok(())
//     //         }

//     //         #[test]
//     //         fn deserialize() -> Result<(), serde_json::Error> {
//     //             for (digest, hex) in hex_examples() {
//     //                 let json_hex = format!("\"{}\"", hex);
//     //                 let digest_deserialized: Digest = serde_json::from_str::<Digest>(&json_hex)?;
//     //                 assert_eq!(digest_deserialized, digest);
//     //             }
//     //             Ok(())
//     //         }
//     //     }

//     //     mod bincode_test {
//     //         use super::*;

//     //         fn bincode_examples() -> Vec<(Digest, [u8; Digest::BYTES])> {
//     //             vec![
//     //                 (Digest::default(), [0u8; Digest::BYTES]),
//     //                 (
//     //                     Digest::new(bfe_array![0, 1, 10, 15, 255]),
//     //                     [
//     //                         0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0,
//     //                         0, 15, 0, 0, 0, 0, 0, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0,
//     //                     ],
//     //                 ),
//     //             ]
//     //         }

//     //         #[test]
//     //         fn serialize() {
//     //             for (digest, bytes) in bincode_examples() {
//     //                 assert_eq!(bincode::serialize(&digest).unwrap(), bytes);
//     //             }
//     //         }

//     //         #[test]
//     //         fn deserialize() {
//     //             for (digest, bytes) in bincode_examples() {
//     //                 assert_eq!(bincode::deserialize::<Digest>(&bytes).unwrap(), digest);
//     //             }
//     //         }
//     //     }
//     // }
// }
