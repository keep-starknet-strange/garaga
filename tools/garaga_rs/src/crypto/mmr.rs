pub mod mmr_accumulator;
pub mod mmr_membership_proof;
pub mod mmr_successor_proof;
pub mod mmr_trait;
pub mod shared_advanced;
pub mod shared_basic;

const TOO_MANY_LEAFS_ERR: &str =
    "internal error: Merkle Mountain Ranges should have at most 2^63 leafs";
