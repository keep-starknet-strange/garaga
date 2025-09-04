This package re-exports non-public functions, structs, and traits from the cairo Corelib library.
The edition is set to 2023_10 to allow for the use of the non-public functions, structs, and traits.
Those functions are mostly useful for their performance within Garaga, but they can be used in other Cairo projects as well.
For example, the stwo cairo verifier uses a similar process https://github.com/starkware-libs/stwo-cairo/blob/a9cc98cc78f39e30a5aea71af7421a09f764df0a/stwo_cairo_verifier/crates/bounded_int/src/lib.cairo to uses the BoundedInt related utilities.

This package re-exports BoundedInt and other useful things.
