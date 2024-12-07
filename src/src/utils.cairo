pub mod neg_3;
pub mod hashing;
pub mod calldata;
pub mod risc0;
pub mod drand;
pub mod noir;

use core::circuit::{u384, u96};
use core::panic_with_felt252;

pub fn u384_assert_zero(x: u384) {
    if x.limb0 != 0 {
        panic_with_felt252('not zero l0');
    }
    if x.limb1 != 0 {
        panic_with_felt252('not zero l1');
    }
    if x.limb2 != 0 {
        panic_with_felt252('not zero l2');
    }
    if x.limb3 != 0 {
        panic_with_felt252('not zero l3');
    }
}

pub fn u384_assert_eq(x: u384, y: u384) {
    if x.limb0 != y.limb0 {
        panic_with_felt252('not equal l0');
    }
    if x.limb1 != y.limb1 {
        panic_with_felt252('not equal l1');
    }
    if x.limb2 != y.limb2 {
        panic_with_felt252('not equal l2');
    }
    if x.limb3 != y.limb3 {
        panic_with_felt252('not equal l3');
    }
}
pub fn usize_assert_eq(x: usize, y: usize) {
    if x != y {
        panic_with_felt252('not equal usize');
    }
}


// Returns true if all limbs of x are zero, false otherwise.
pub fn u384_eq_zero(x: u384) -> bool {
    if x.limb0 != 0 {
        return false;
    }
    if x.limb1 != 0 {
        return false;
    }
    if x.limb2 != 0 {
        return false;
    }
    if x.limb3 != 0 {
        return false;
    }
    true
}
