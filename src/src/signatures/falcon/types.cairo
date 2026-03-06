use super::zq::Zq;

#[derive(Drop, Serde)]
pub struct FalconPublicKey {
    pub h_ntt: Array<Zq>,
}

#[derive(Drop, Serde)]
pub struct FalconSignature {
    pub s1: Array<Zq>,
    pub salt: Array<felt252>,
}

#[derive(Drop, Serde)]
pub struct FalconVerificationHint {
    pub mul_hint: Array<Zq>,
}

#[derive(Drop, Serde)]
pub struct FalconSignatureWithHint {
    pub signature: FalconSignature,
    pub hint: FalconVerificationHint,
}

pub trait HashToPoint<H> {
    fn hash_to_point(message: Span<felt252>, salt: Span<felt252>) -> Array<Zq>;
}
use super::packing::PackedPolynomial512;

#[derive(Drop, Serde)]
pub struct PackedFalconSignature {
    pub s1: PackedPolynomial512,
    pub salt: Array<felt252>,
}

#[derive(Drop, Serde)]
pub struct PackedFalconVerificationHint {
    pub mul_hint: PackedPolynomial512,
}

#[derive(Drop, Serde)]
pub struct PackedFalconSignatureWithHint {
    pub signature: PackedFalconSignature,
    pub hint: PackedFalconVerificationHint,
}
