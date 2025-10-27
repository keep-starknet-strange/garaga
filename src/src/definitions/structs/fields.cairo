//! Field structures for degree-12 extension fields used by the circuits.
//!
//! - [`E12D`] models a polynomial representation with 12 coefficients.
//! - [`E12T`] models a 2-3-2 tower representation with named coefficients.
//!
//! Documentation follows Scarb's doc conventions (`///` and `//!` comments), so it can be
//! rendered with `scarb doc`.
use core::circuit::{u384, u96};
use core::num;
use core::num::traits::{One, Zero};
use core::serde::Serde;
use corelib_imports::bounded_int::downcast;


#[derive(Copy, Drop, Debug, PartialEq)]
pub struct u288 {
    pub limb0: u96,
    pub limb1: u96,
    pub limb2: u96,
}

/// Degree-12 extension field element (generic coefficients).
///
/// Represents an element of the extension field F_{q^12} modeled as the
/// quotient ring F_q[w]/p(w), where p(w) is an irreducible polynomial of
/// degree 12. Canonical polynomial form:
///
/// ```text
/// w0 + w1*w + w2*w^2 + w3*w^3 + w4*w^4 + w5*w^5
/// + w6*w^6 + w7*w^7 + w8*w^8 + w9*w^9 + w10*w^10 + w11*w^11
/// ```
///
/// Coefficients w0 ... w11 are of type `T`.
///
/// When `T` is a limb-based integer type used in this codebase:
/// - `T = [u384]` (4 x u96 limbs) or `T = [u288]` (3 x u96 limbs). Helpers
///   below serialize/deserialize to a flat `Array<felt252>` (12x4 for `u384`,
///   12x3 for `u288`).
/// - [`num::traits::One`] is implemented for `E12D<u384>` and `E12D<u288>`; the
///   multiplicative identity is `w0 = 1` and all other coefficients are zero.
///
/// Example: create the multiplicative identity for `u288` coefficients. HOHO
/// ```text
/// let one: E12D<u288> = E12D {
///     w0: U288One::one(),
///     w1: U288Zero::zero(),
///     w2: U288Zero::zero(),
///     w3: U288Zero::zero(),
///     w4: U288Zero::zero(),
///     w5: U288Zero::zero(),
///     w6: U288Zero::zero(),
///     w7: U288Zero::zero(),
///     w8: U288Zero::zero(),
///     w9: U288Zero::zero(),
///     w10: U288Zero::zero(),
///     w11: U288Zero::zero(),
/// };
/// ```
#[derive(Copy, Drop, Debug, PartialEq)]
pub struct E12D<T> {
    pub w0: T,
    pub w1: T,
    pub w2: T,
    pub w3: T,
    pub w4: T,
    pub w5: T,
    pub w6: T,
    pub w7: T,
    pub w8: T,
    pub w9: T,
    pub w10: T,
    pub w11: T,
}

/// Degree-12 extension field element using a 2-3-2 tower construction.
///
/// The field F_{q^12} is built in three steps:
/// - F_{q^2} ~= F_q[u]/p1(u)
/// - F_{q^6} ~= F_{q^2}[v]/p2(v)
/// - F_{q^12} ~= F_{q^6}[w]/p3(w)
///
/// Any element has the form:
///
/// ```text
/// [ (c1b2a1*u + c1b2a0)*v^2 + (c1b1a1*u + c1b1a0)*v + (c1b0a1*u + c1b0a0) ]*w
/// + [ (c0b2a1*u + c0b2a0)*v^2 + (c0b1a1*u + c0b1a0)*v + (c0b0a1*u + c0b0a0) ]
/// ```
///
/// This yields 12 base-field coefficients. Field names follow `c{c}b{b}a{a}`:
/// - `c` in {0,1} selects the coefficient of 1 (c=0) or of w (c=1)
/// - `b` in {0,1,2} selects the power of v (0, 1, or 2)
/// - `a` in {0,1} selects the component in the quadratic basis over u
///
/// All twelve attributes are [`u384`] values (unsigned 384-bit integers) used by
/// the surrounding circuits and serializers.
///
/// Example: zero element (schematic — any `u384` zero can be reused across fields).
/// ```cairo
/// let z: u384 = Zero::zero();
/// let e = E12T {
///     c0b0a0: z, c0b0a1: z,
///     c0b1a0: z, c0b1a1: z,
///     c0b2a0: z, c0b2a1: z,
///     c1b0a0: z, c1b0a1: z,
///     c1b1a0: z, c1b1a1: z,
///     c1b2a0: z, c1b2a1: z,
/// };
/// ```
#[derive(Drop, Copy, Debug, PartialEq)]
pub struct E12T {
    pub c0b0a0: u384,
    pub c0b0a1: u384,
    pub c0b1a0: u384,
    pub c0b1a1: u384,
    pub c0b2a0: u384,
    pub c0b2a1: u384,
    pub c1b0a0: u384,
    pub c1b0a1: u384,
    pub c1b1a0: u384,
    pub c1b1a1: u384,
    pub c1b2a0: u384,
    pub c1b2a1: u384,
}


pub fn serialize_u384(self: @u384, ref output: Array<felt252>) {
    output.append((*self.limb0).into());
    output.append((*self.limb1).into());
    output.append((*self.limb2).into());
    output.append((*self.limb3).into());
}
pub fn deserialize_u384(ref serialized: Span<felt252>) -> u384 {
    let [l0, l1, l2, l3] = (*serialized.multi_pop_front::<4>().unwrap()).unbox();
    let limb0: u96 = downcast(l0).unwrap();
    let limb1: u96 = downcast(l1).unwrap();
    let limb2: u96 = downcast(l2).unwrap();
    let limb3: u96 = downcast(l3).unwrap();
    return u384 { limb0: limb0, limb1: limb1, limb2: limb2, limb3: limb3 };
}

pub fn serialize_u384_array(self: @Array<u384>, ref output: Array<felt252>) {
    self.len().serialize(ref output);
    serialize_u384_array_helper(self.span(), ref output);
}

pub fn serialize_u384_array_helper(mut input: Span<u384>, ref output: Array<felt252>) {
    if let Option::Some(value) = input.pop_front() {
        serialize_u384(value, ref output);
        serialize_u384_array_helper(input, ref output);
    }
}

pub fn deserialize_u384_array(ref serialized: Span<felt252>) -> Array<u384> {
    let length = *serialized.pop_front().unwrap();
    let mut arr = array![];
    deserialize_u384_array_helper(ref serialized, arr, length)
}

pub fn deserialize_u384_array_helper(
    ref serialized: Span<felt252>, mut curr_output: Array<u384>, remaining: felt252,
) -> Array<u384> {
    if remaining == 0 {
        return curr_output;
    }
    curr_output.append(deserialize_u384(ref serialized));
    deserialize_u384_array_helper(ref serialized, curr_output, remaining - 1)
}

pub impl u288Serde of Serde<u288> {
    fn serialize(self: @u288, ref output: Array<felt252>) {
        output.append((*self.limb0).into());
        output.append((*self.limb1).into());
        output.append((*self.limb2).into());
    }
    fn deserialize(ref serialized: Span<felt252>) -> Option<u288> {
        let [l0, l1, l2] = (*serialized.multi_pop_front::<3>().unwrap()).unbox();
        let limb0 = downcast(l0).unwrap();
        let limb1 = downcast(l1).unwrap();
        let limb2 = downcast(l2).unwrap();
        return Option::Some(u288 { limb0: limb0, limb1: limb1, limb2: limb2 });
    }
}


impl U288Zero of num::traits::Zero<u288> {
    fn zero() -> u288 {
        u288 { limb0: 0, limb1: 0, limb2: 0 }
    }
    fn is_zero(self: @u288) -> bool {
        *self == Self::zero()
    }
    fn is_non_zero(self: @u288) -> bool {
        !self.is_zero()
    }
}

impl U288One of num::traits::One<u288> {
    fn one() -> u288 {
        u288 { limb0: 1, limb1: 0, limb2: 0 }
    }
    fn is_one(self: @u288) -> bool {
        *self == Self::one()
    }
    fn is_non_one(self: @u288) -> bool {
        !self.is_one()
    }
}

impl E12DOneU384 of num::traits::One<E12D<u384>> {
    fn one() -> E12D<u384> {
        E12D {
            w0: One::one(),
            w1: Zero::zero(),
            w2: Zero::zero(),
            w3: Zero::zero(),
            w4: Zero::zero(),
            w5: Zero::zero(),
            w6: Zero::zero(),
            w7: Zero::zero(),
            w8: Zero::zero(),
            w9: Zero::zero(),
            w10: Zero::zero(),
            w11: Zero::zero(),
        }
    }

    fn is_one(self: @E12D<u384>) -> bool {
        *self == Self::one()
    }

    fn is_non_one(self: @E12D<u384>) -> bool {
        !self.is_one()
    }
}

impl E12DOneU288 of num::traits::One<E12D<u288>> {
    fn one() -> E12D<u288> {
        E12D {
            w0: U288One::one(),
            w1: U288Zero::zero(),
            w2: U288Zero::zero(),
            w3: U288Zero::zero(),
            w4: U288Zero::zero(),
            w5: U288Zero::zero(),
            w6: U288Zero::zero(),
            w7: U288Zero::zero(),
            w8: U288Zero::zero(),
            w9: U288Zero::zero(),
            w10: U288Zero::zero(),
            w11: U288Zero::zero(),
        }
    }

    fn is_one(self: @E12D<u288>) -> bool {
        *self == Self::one()
    }

    fn is_non_one(self: @E12D<u288>) -> bool {
        !self.is_one()
    }
}

pub impl E12TOne of One<E12T> {
    fn one() -> E12T {
        E12T {
            c0b0a0: One::one(),
            c0b0a1: Zero::zero(),
            c0b1a0: Zero::zero(),
            c0b1a1: Zero::zero(),
            c0b2a0: Zero::zero(),
            c0b2a1: Zero::zero(),
            c1b0a0: Zero::zero(),
            c1b0a1: Zero::zero(),
            c1b1a0: Zero::zero(),
            c1b1a1: Zero::zero(),
            c1b2a0: Zero::zero(),
            c1b2a1: Zero::zero(),
        }
    }
    fn is_one(self: @E12T) -> bool {
        *self == Self::one()
    }
    fn is_non_one(self: @E12T) -> bool {
        !Self::is_one(self)
    }
}

impl E12DSerde384 of Serde<E12D<u384>> {
    fn serialize(self: @E12D<u384>, ref output: Array<felt252>) {
        let val = *self;
        output.append(val.w0.limb0.into());
        output.append(val.w0.limb1.into());
        output.append(val.w0.limb2.into());
        output.append(val.w0.limb3.into());
        output.append(val.w1.limb0.into());
        output.append(val.w1.limb1.into());
        output.append(val.w1.limb2.into());
        output.append(val.w1.limb3.into());

        output.append(val.w2.limb0.into());
        output.append(val.w2.limb1.into());
        output.append(val.w2.limb2.into());
        output.append(val.w2.limb3.into());

        output.append(val.w3.limb0.into());
        output.append(val.w3.limb1.into());
        output.append(val.w3.limb2.into());
        output.append(val.w3.limb3.into());

        output.append(val.w4.limb0.into());
        output.append(val.w4.limb1.into());
        output.append(val.w4.limb2.into());
        output.append(val.w4.limb3.into());

        output.append(val.w5.limb0.into());
        output.append(val.w5.limb1.into());
        output.append(val.w5.limb2.into());
        output.append(val.w5.limb3.into());

        output.append(val.w6.limb0.into());
        output.append(val.w6.limb1.into());
        output.append(val.w6.limb2.into());
        output.append(val.w6.limb3.into());

        output.append(val.w7.limb0.into());
        output.append(val.w7.limb1.into());
        output.append(val.w7.limb2.into());
        output.append(val.w7.limb3.into());

        output.append(val.w8.limb0.into());
        output.append(val.w8.limb1.into());
        output.append(val.w8.limb2.into());
        output.append(val.w8.limb3.into());

        output.append(val.w9.limb0.into());
        output.append(val.w9.limb1.into());
        output.append(val.w9.limb2.into());
        output.append(val.w9.limb3.into());

        output.append(val.w10.limb0.into());
        output.append(val.w10.limb1.into());
        output.append(val.w10.limb2.into());
        output.append(val.w10.limb3.into());

        output.append(val.w11.limb0.into());
        output.append(val.w11.limb1.into());
        output.append(val.w11.limb2.into());
        output.append(val.w11.limb3.into());
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<E12D<u384>> {
        let [
            w0l0,
            w0l1,
            w0l2,
            w0l3,
            w1l0,
            w1l1,
            w1l2,
            w1l3,
            w2l0,
            w2l1,
            w2l2,
            w2l3,
            w3l0,
            w3l1,
            w3l2,
            w3l3,
            w4l0,
            w4l1,
            w4l2,
            w4l3,
            w5l0,
            w5l1,
            w5l2,
            w5l3,
            w6l0,
            w6l1,
            w6l2,
            w6l3,
            w7l0,
            w7l1,
            w7l2,
            w7l3,
            w8l0,
            w8l1,
            w8l2,
            w8l3,
            w9l0,
            w9l1,
            w9l2,
            w9l3,
            w10l0,
            w10l1,
            w10l2,
            w10l3,
            w11l0,
            w11l1,
            w11l2,
            w11l3,
        ] =
            (*serialized
            .multi_pop_front::<48>()
            .unwrap())
            .unbox();
        Option::Some(
            E12D {
                w0: u384 {
                    limb0: downcast(w0l0).unwrap(),
                    limb1: downcast(w0l1).unwrap(),
                    limb2: downcast(w0l2).unwrap(),
                    limb3: downcast(w0l3).unwrap(),
                },
                w1: u384 {
                    limb0: downcast(w1l0).unwrap(),
                    limb1: downcast(w1l1).unwrap(),
                    limb2: downcast(w1l2).unwrap(),
                    limb3: downcast(w1l3).unwrap(),
                },
                w2: u384 {
                    limb0: downcast(w2l0).unwrap(),
                    limb1: downcast(w2l1).unwrap(),
                    limb2: downcast(w2l2).unwrap(),
                    limb3: downcast(w2l3).unwrap(),
                },
                w3: u384 {
                    limb0: downcast(w3l0).unwrap(),
                    limb1: downcast(w3l1).unwrap(),
                    limb2: downcast(w3l2).unwrap(),
                    limb3: downcast(w3l3).unwrap(),
                },
                w4: u384 {
                    limb0: downcast(w4l0).unwrap(),
                    limb1: downcast(w4l1).unwrap(),
                    limb2: downcast(w4l2).unwrap(),
                    limb3: downcast(w4l3).unwrap(),
                },
                w5: u384 {
                    limb0: downcast(w5l0).unwrap(),
                    limb1: downcast(w5l1).unwrap(),
                    limb2: downcast(w5l2).unwrap(),
                    limb3: downcast(w5l3).unwrap(),
                },
                w6: u384 {
                    limb0: downcast(w6l0).unwrap(),
                    limb1: downcast(w6l1).unwrap(),
                    limb2: downcast(w6l2).unwrap(),
                    limb3: downcast(w6l3).unwrap(),
                },
                w7: u384 {
                    limb0: downcast(w7l0).unwrap(),
                    limb1: downcast(w7l1).unwrap(),
                    limb2: downcast(w7l2).unwrap(),
                    limb3: downcast(w7l3).unwrap(),
                },
                w8: u384 {
                    limb0: downcast(w8l0).unwrap(),
                    limb1: downcast(w8l1).unwrap(),
                    limb2: downcast(w8l2).unwrap(),
                    limb3: downcast(w8l3).unwrap(),
                },
                w9: u384 {
                    limb0: downcast(w9l0).unwrap(),
                    limb1: downcast(w9l1).unwrap(),
                    limb2: downcast(w9l2).unwrap(),
                    limb3: downcast(w9l3).unwrap(),
                },
                w10: u384 {
                    limb0: downcast(w10l0).unwrap(),
                    limb1: downcast(w10l1).unwrap(),
                    limb2: downcast(w10l2).unwrap(),
                    limb3: downcast(w10l3).unwrap(),
                },
                w11: u384 {
                    limb0: downcast(w11l0).unwrap(),
                    limb1: downcast(w11l1).unwrap(),
                    limb2: downcast(w11l2).unwrap(),
                    limb3: downcast(w11l3).unwrap(),
                },
            },
        )
    }
}


impl E12DSerde288 of Serde<E12D<u288>> {
    fn serialize(self: @E12D<u288>, ref output: Array<felt252>) {
        let val = *self;
        output.append(val.w0.limb0.into());
        output.append(val.w0.limb1.into());
        output.append(val.w0.limb2.into());
        output.append(val.w1.limb0.into());
        output.append(val.w1.limb1.into());
        output.append(val.w1.limb2.into());

        output.append(val.w2.limb0.into());
        output.append(val.w2.limb1.into());
        output.append(val.w2.limb2.into());

        output.append(val.w3.limb0.into());
        output.append(val.w3.limb1.into());
        output.append(val.w3.limb2.into());

        output.append(val.w4.limb0.into());
        output.append(val.w4.limb1.into());
        output.append(val.w4.limb2.into());

        output.append(val.w5.limb0.into());
        output.append(val.w5.limb1.into());
        output.append(val.w5.limb2.into());

        output.append(val.w6.limb0.into());
        output.append(val.w6.limb1.into());
        output.append(val.w6.limb2.into());

        output.append(val.w7.limb0.into());
        output.append(val.w7.limb1.into());
        output.append(val.w7.limb2.into());

        output.append(val.w8.limb0.into());
        output.append(val.w8.limb1.into());
        output.append(val.w8.limb2.into());

        output.append(val.w9.limb0.into());
        output.append(val.w9.limb1.into());
        output.append(val.w9.limb2.into());

        output.append(val.w10.limb0.into());
        output.append(val.w10.limb1.into());
        output.append(val.w10.limb2.into());

        output.append(val.w11.limb0.into());
        output.append(val.w11.limb1.into());
        output.append(val.w11.limb2.into());
    }

    fn deserialize(ref serialized: Span<felt252>) -> Option<E12D<u288>> {
        let [
            w0l0,
            w0l1,
            w0l2,
            w1l0,
            w1l1,
            w1l2,
            w2l0,
            w2l1,
            w2l2,
            w3l0,
            w3l1,
            w3l2,
            w4l0,
            w4l1,
            w4l2,
            w5l0,
            w5l1,
            w5l2,
            w6l0,
            w6l1,
            w6l2,
            w7l0,
            w7l1,
            w7l2,
            w8l0,
            w8l1,
            w8l2,
            w9l0,
            w9l1,
            w9l2,
            w10l0,
            w10l1,
            w10l2,
            w11l0,
            w11l1,
            w11l2,
        ] =
            (*serialized
            .multi_pop_front::<36>()
            .unwrap())
            .unbox();
        Option::Some(
            E12D {
                w0: u288 {
                    limb0: downcast(w0l0).unwrap(),
                    limb1: downcast(w0l1).unwrap(),
                    limb2: downcast(w0l2).unwrap(),
                },
                w1: u288 {
                    limb0: downcast(w1l0).unwrap(),
                    limb1: downcast(w1l1).unwrap(),
                    limb2: downcast(w1l2).unwrap(),
                },
                w2: u288 {
                    limb0: downcast(w2l0).unwrap(),
                    limb1: downcast(w2l1).unwrap(),
                    limb2: downcast(w2l2).unwrap(),
                },
                w3: u288 {
                    limb0: downcast(w3l0).unwrap(),
                    limb1: downcast(w3l1).unwrap(),
                    limb2: downcast(w3l2).unwrap(),
                },
                w4: u288 {
                    limb0: downcast(w4l0).unwrap(),
                    limb1: downcast(w4l1).unwrap(),
                    limb2: downcast(w4l2).unwrap(),
                },
                w5: u288 {
                    limb0: downcast(w5l0).unwrap(),
                    limb1: downcast(w5l1).unwrap(),
                    limb2: downcast(w5l2).unwrap(),
                },
                w6: u288 {
                    limb0: downcast(w6l0).unwrap(),
                    limb1: downcast(w6l1).unwrap(),
                    limb2: downcast(w6l2).unwrap(),
                },
                w7: u288 {
                    limb0: downcast(w7l0).unwrap(),
                    limb1: downcast(w7l1).unwrap(),
                    limb2: downcast(w7l2).unwrap(),
                },
                w8: u288 {
                    limb0: downcast(w8l0).unwrap(),
                    limb1: downcast(w8l1).unwrap(),
                    limb2: downcast(w8l2).unwrap(),
                },
                w9: u288 {
                    limb0: downcast(w9l0).unwrap(),
                    limb1: downcast(w9l1).unwrap(),
                    limb2: downcast(w9l2).unwrap(),
                },
                w10: u288 {
                    limb0: downcast(w10l0).unwrap(),
                    limb1: downcast(w10l1).unwrap(),
                    limb2: downcast(w10l2).unwrap(),
                },
                w11: u288 {
                    limb0: downcast(w11l0).unwrap(),
                    limb1: downcast(w11l1).unwrap(),
                    limb2: downcast(w11l2).unwrap(),
                },
            },
        )
    }
}
