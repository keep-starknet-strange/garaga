%lang starknet

from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.math import assert_nn, assert_le
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_secp.bigint import BigInt3
from starkware.cairo.common.registers import get_fp_and_pc

from src.bn254.g1 import G1Point, G1PointFull, g1
from src.bn254.g2 import G2Point
from src.bn254.pairing import pair, pair_multi
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

    func parse_g1s(g1fs_len: felt, g1fs: G1PointFull*, P_arr: G1Point**) {
        alloc_locals;
        if (g1fs_len == 0) {
            return ();
        } else {
            let p = g1fs[0];
            local p_: G1Point* = new G1Point(x=&p.x, y=&p.y);
            assert P_arr[0] = p_;
            return parse_g1s(g1fs_len - 1, g1fs + G1PointFull.SIZE, P_arr + 1);
        }
    }

    func parse_g2s(g2fs_len: felt, g2fs: G2PointFull*, Q_arr: G2Point**) {
        alloc_locals;
        if (g2fs_len != 0) {
            let q = g2fs[0];
            local q_: G2Point* = new G2Point(
                x=new E2(a0=&q.x.a0, a1=&q.x.a1), y=new E2(a0=&q.y.a0, a1=&q.y.a1)
            );
            assert Q_arr[0] = q_;
            return parse_g2s(g2fs_len - 1, g2fs + G2PointFull.SIZE, Q_arr + 1);
        } else {
            return ();
        }
    }

    func ec_pairing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
        n: felt, p_arr: G1PointFull*, q_arr: G2PointFull*
    ) -> (res: felt) {
        alloc_locals;
        with_attr error_message("Garaga bn254: Pairing input cannot be empty.") {
            assert_nn(n);
            assert_le(1, n);
        }

        let (P_arr: G1Point**) = alloc();
        parse_g1s(n, p_arr, P_arr);
        let (Q_arr: G2Point**) = alloc();
        parse_g2s(n, q_arr, Q_arr);

        if (n == 1) {
            let P = P_arr[0];
            let Q = Q_arr[0];
            let pairing_value = pair(P, Q);
            let (res) = verify_pairing(pairing_value);
            return (res=res);
        } else {
            let pairing_value = pair_multi(P_arr, Q_arr, n);
            let (res) = verify_pairing(pairing_value);
            return (res=res);
        }
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
}
