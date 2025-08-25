use core::circuit::u384;
use core::num::traits::Zero;
use core::serde::Serde;
use garaga::definitions::{deserialize_u384, serialize_u384};

#[derive(Copy, Drop, Debug, PartialEq)]
pub struct G1Point {
    pub x: u384,
    pub y: u384,
}

pub impl G1PointSerde of Serde<G1Point> {
    fn serialize(self: @G1Point, ref output: Array<felt252>) {
        serialize_u384(self.x, ref output);
        serialize_u384(self.y, ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<G1Point> {
        let x = deserialize_u384(ref serialized);
        let y = deserialize_u384(ref serialized);
        return Option::Some(G1Point { x: x, y: y });
    }
}


#[derive(Copy, Drop, Debug, PartialEq)]
pub struct G2Point {
    pub x0: u384,
    pub x1: u384,
    pub y0: u384,
    pub y1: u384,
}
pub impl G2PointSerde of Serde<G2Point> {
    fn serialize(self: @G2Point, ref output: Array<felt252>) {
        serialize_u384(self.x0, ref output);
        serialize_u384(self.x1, ref output);
        serialize_u384(self.y0, ref output);
        serialize_u384(self.y1, ref output);
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<G2Point> {
        let x0 = deserialize_u384(ref serialized);
        let x1 = deserialize_u384(ref serialized);
        let y0 = deserialize_u384(ref serialized);
        let y1 = deserialize_u384(ref serialized);
        return Option::Some(G2Point { x0: x0, x1: x1, y0: y0, y1: y1 });
    }
}


#[derive(Copy, Drop, Debug, PartialEq)]
pub struct G2Line<T> {
    pub r0a0: T,
    pub r0a1: T,
    pub r1a0: T,
    pub r1a1: T,
}

#[derive(Copy, Drop, Debug, PartialEq, Serde)]
pub struct G1G2Pair {
    pub p: G1Point,
    pub q: G2Point,
}


// Represents the point at infinity
pub impl G1PointZero of Zero<G1Point> {
    fn zero() -> G1Point {
        G1Point { x: Zero::zero(), y: Zero::zero() }
    }
    fn is_zero(self: @G1Point) -> bool {
        *self == Self::zero()
    }
    fn is_non_zero(self: @G1Point) -> bool {
        !self.is_zero()
    }
}

// Represents the point at infinity
pub impl G2PointZero of Zero<G2Point> {
    fn zero() -> G2Point {
        G2Point { x0: Zero::zero(), x1: Zero::zero(), y0: Zero::zero(), y1: Zero::zero() }
    }
    fn is_zero(self: @G2Point) -> bool {
        *self == Self::zero()
    }
    fn is_non_zero(self: @G2Point) -> bool {
        !self.is_zero()
    }
}
