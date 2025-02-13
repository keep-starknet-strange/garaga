use core::circuit::{u96, u384, CircuitModulus};
use core::result::Result;
use core::serde::{Serde};
use core::num;
use core::num::traits::{Zero, One};
use core::RangeCheck;

extern fn downcast<felt252, u96>(x: felt252) -> Option<u96> implicits(RangeCheck) nopanic;

pub mod points;
pub mod fields;
