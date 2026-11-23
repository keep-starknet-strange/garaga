//! Reference BLS12-381 min-sig-size verifier (drand DST).
//!
//! Counterpart to `drand_quicknet/src/drand_verifier.cairo` but with
//! the chain-specific gates lifted: caller supplies the message hash
//! and a per-call G2 public key, so the same class verifies arbitrary
//! BLS signatures (validator multisigs, DAO governance keys, backend
//! signers).
//!
//! Calldata layout matches `garaga::calldata::bls_calldata_builder`'s
//! output (minus the size prefix consumed by the Span<felt252>
//! transport). See `tools/garaga_rs/src/calldata/bls_calldata.rs` for
//! the full envelope description.

#[starknet::interface]
pub trait IBlsVerifier<TContractState> {
    fn verify_bls_signature(
        self: @TContractState,
        message_hash: felt252,
        pubkey: garaga::definitions::G2Point,
        full_proof_with_hints: Span<felt252>,
    ) -> bool;
}

#[starknet::contract]
pub mod BlsVerifier {
    use core::array::{ArrayTrait, SpanTrait};
    use core::circuit::u384;
    use core::option::OptionTrait;
    use core::serde::Serde;
    use core::traits::{Into, TryInto};
    use garaga::apps::drand::{HashToCurveHint, hash_to_curve_bls12_381};
    use garaga::definitions::structs::fields::deserialize_u384;
    use garaga::definitions::structs::points::G2Line;
    use garaga::definitions::{BLS_G2_GENERATOR, G1G2Pair, G1Point, G2Point};
    use garaga::ec::ec_ops::G1PointTrait;
    use garaga::ec::ec_ops_g2::G2PointTrait;
    use garaga::ec::pairing::pairing_check::multi_pairing_check_bls12_381_2P_2F;
    use garaga::pairing_check::MPCheckHintBLS12_381;
    use garaga::utils::calldata::deserialize_mpcheck_hint_bls12_381;

    /// Number of precomputed Miller-loop lines for `multi_pairing_check_bls12_381_2P_2F`
    /// with two precomputed G2 points.
    const BLS_2P_2F_LINES_LEN: u32 = 136;

    /// BLS12-381 curve index used by Garaga's subgroup checks.
    const BLS_CURVE_INDEX: usize = 1;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl IBlsVerifierImpl of super::IBlsVerifier<ContractState> {
        fn verify_bls_signature(
            self: @ContractState,
            message_hash: felt252,
            pubkey: G2Point,
            mut full_proof_with_hints: Span<felt252>,
        ) -> bool {
            // ---------- 1. parse signature G1 ----------
            let signature_g1: G1Point =
                match Serde::<G1Point>::deserialize(ref full_proof_with_hints) {
                Option::Some(s) => s,
                Option::None => { return false; },
            };

            // ---------- 2. parse hash-to-curve hint ----------
            let h2c_hint: HashToCurveHint =
                match Serde::<HashToCurveHint>::deserialize(ref full_proof_with_hints) {
                Option::Some(h) => h,
                Option::None => { return false; },
            };

            // ---------- 3. parse precomputed Miller-loop lines ----------
            let lines_len_felt: felt252 = match full_proof_with_hints.pop_front() {
                Option::Some(v) => *v,
                Option::None => { return false; },
            };
            let lines_len: u32 = match lines_len_felt.try_into() {
                Option::Some(n) => n,
                Option::None => { return false; },
            };
            if lines_len != BLS_2P_2F_LINES_LEN {
                return false;
            }
            let mut lines_arr: Array<G2Line<u384>> = ArrayTrait::new();
            let mut i: u32 = 0;
            while i != lines_len {
                let r0a0 = deserialize_u384(ref full_proof_with_hints);
                let r0a1 = deserialize_u384(ref full_proof_with_hints);
                let r1a0 = deserialize_u384(ref full_proof_with_hints);
                let r1a1 = deserialize_u384(ref full_proof_with_hints);
                lines_arr.append(G2Line { r0a0, r0a1, r1a0, r1a1 });
                i += 1;
            }

            // ---------- 4. parse mpcheck hint ----------
            // Helper consumes the rest of the span; panics on truncation
            // (correct failure mode for a structurally malformed envelope).
            let mpcheck_hint: MPCheckHintBLS12_381 = deserialize_mpcheck_hint_bls12_381(
                ref full_proof_with_hints,
            );

            // ---------- 5. subgroup checks ----------
            pubkey.assert_in_subgroup_excluding_infinity(BLS_CURVE_INDEX);
            signature_g1.assert_in_subgroup_excluding_infinity(BLS_CURVE_INDEX);

            // ---------- 6. felt252 → [u32; 8] big-endian ----------
            let msg_u32s = felt252_to_u32x8_be(message_hash);

            // ---------- 7. compute H(m) on chain ----------
            let msg_pt = hash_to_curve_bls12_381(msg_u32s, h2c_hint);

            // ---------- 8. multi-pairing check ----------
            // BLS verify identity: e(sig, G2_GEN) == e(H(m), pubkey)
            //   ⇔ e(sig, G2_GEN) · e(H(m), -pubkey) == 1
            let neg_pubkey = pubkey.negate(BLS_CURVE_INDEX);
            let result = multi_pairing_check_bls12_381_2P_2F(
                pair0: G1G2Pair { p: signature_g1, q: BLS_G2_GENERATOR },
                pair1: G1G2Pair { p: msg_pt, q: neg_pubkey },
                lines: lines_arr.span(),
                hint: mpcheck_hint,
            );
            match result {
                Result::Ok(_) => true,
                Result::Err(_) => false,
            }
        }
    }

    /// Convert a `felt252` (≤252 bits) to its 32-byte big-endian
    /// representation, then split into eight u32 big-endian words.
    fn felt252_to_u32x8_be(m: felt252) -> [u32; 8] {
        let m_u256: u256 = m.into();
        let high: u128 = m_u256.high;
        let low: u128 = m_u256.low;

        let h0: u32 = (high / 0x1000000000000000000000000_u128).try_into().unwrap();
        let h1: u32 = ((high / 0x10000000000000000_u128) & 0xffffffff_u128).try_into().unwrap();
        let h2: u32 = ((high / 0x100000000_u128) & 0xffffffff_u128).try_into().unwrap();
        let h3: u32 = (high & 0xffffffff_u128).try_into().unwrap();
        let l0: u32 = (low / 0x1000000000000000000000000_u128).try_into().unwrap();
        let l1: u32 = ((low / 0x10000000000000000_u128) & 0xffffffff_u128).try_into().unwrap();
        let l2: u32 = ((low / 0x100000000_u128) & 0xffffffff_u128).try_into().unwrap();
        let l3: u32 = (low & 0xffffffff_u128).try_into().unwrap();
        [h0, h1, h2, h3, l0, l1, l2, l3]
    }
}
