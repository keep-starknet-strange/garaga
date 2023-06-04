%lang starknet

from starkware.cairo.common.math import assert_not_zero
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_secp.bigint import BigInt3
from starkware.cairo.common.registers import get_fp_and_pc

from src.bn254.g1 import G1Point, G1PointFull, g1
from src.bn254.g2 import G2Point
from src.bn254.pairing import miller_loop, final_exponentiation
from src.bn254.towers.e2 import E2
from src.bn254.towers.e12 import E12, e12

struct E2Full {
    a0: BigInt3,
    a1: BigInt3,
}

struct G2PointFull {
    x: E2Full,
    y: E2Full,
}

struct PairingInput {
    p: G1PointFull,
    q: G2PointFull,
}

namespace BN254Precompiles {
    //
    // Views
    //

    func ec_add{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        a: G1PointFull, b: G1PointFull
    ) -> (res: G1PointFull) {
        alloc_locals;
        let (res) = g1.add_full(a, b);
        return (res=res);
    }

    func ec_mul{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        a: G1PointFull, s: BigInt3
    ) -> (res: G1PointFull) {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local a_: G1Point = G1Point(x=&a.x, y=&a.y);
        let (tmp) = g1.scalar_mul(&a_, s);
        let res = G1PointFull(x=[tmp.x], y=[tmp.y]);
        return (res=res);
    }

    func ec_pairing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        input_len: felt, input: PairingInput*
    ) -> (res: felt) {
        alloc_locals;
        with_attr error_message("Garaga bn254: PairingInput cannot be empty.") {
            assert_not_zero(input_len);
        }
        let one = e12.one();
        let pairing_value = pairing(input_len, input, one);
        let (res) = verify_pairing(pairing_value);
        return (res=res);
    }

    //
    // Internal functions.
    //

    func verify_pairing{range_check_ptr}(pairing_value: E12*) -> (bool: felt) {
        let one = e12.one();
        let tmp = e12.sub(pairing_value, one);
        let res = e12.is_zero(tmp);
        return (bool=res);
    }

    func pairing{range_check_ptr}(input_len: felt, input: PairingInput*, acc: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        if (input_len == 0) {
            return final_exponentiation(acc);
        }

        let p: G1PointFull = input[0].p;
        let q: G2PointFull = input[0].q;

        local p_: G1Point* = new G1Point(x=&p.x, y=&p.y);
        local q_: G2Point* = new G2Point(
            x=new E2(a0=&q.x.a0, a1=&q.x.a1), y=new E2(a0=&q.y.a0, a1=&q.y.a1)
        );

        let tmp = miller_loop(p_, q_);
        let new_acc: E12* = e12.mul(tmp, acc);
        return pairing(input_len - 1, input + PairingInput.SIZE, new_acc);
    }
}
