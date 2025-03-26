use core::circuit::{CircuitModulus, u384, u96};
use core::num::traits::{One, Zero};
use core::result::Result;
use core::serde::Serde;
use core::{RangeCheck, num};

extern fn downcast<felt252, u96>(x: felt252) -> Option<u96> implicits(RangeCheck) nopanic;

pub mod fields;
pub mod points;
