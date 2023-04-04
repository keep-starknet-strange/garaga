%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_secp.bigint import BigInt3
from starkware.cairo.common.registers import get_fp_and_pc

from src.bn254.g1 import G1Point, G1PointFull, g1
from src.bn254.g2 import G2Point
from src.bn254.pairing import pair, gt_one
from src.bn254.towers.e2 import E2
from src.bn254.towers.e6 import E6
from src.bn254.towers.e12 import E12, e12

struct E2Full {
    a0: BigInt3,
    a1: BigInt3,
}

struct G2PointFull {
    x: E2Full,
    y: E2Full,
}

@external
func ecAdd{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    a: G1PointFull, b: G1PointFull
) -> (res: G1PointFull) {
    alloc_locals;
    let (res) = g1.add_full(a, b);
    return (res=res);
}

@external
func ecMul{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    a: G1PointFull, s: BigInt3
) -> (res: G1PointFull) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local a_: G1Point* = new G1Point(x=&a.x, y=&a.y);
    let (tmp) = g1.scalar_mul(a_, s);
    let res = G1PointFull(x=[tmp.x], y=[tmp.y]);
    return (res=res);
}

@external
func ecPairing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    p: G1PointFull, q: G2PointFull
) -> (res: felt) {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    local p_: G1Point* = new G1Point(x=&p.x, y=&p.y);
    local q_: G2Point* = new G2Point(
        x=new E2(a0=&q.x.a0, a1=&q.x.a1), y=new E2(a0=&q.y.a0, a1=&q.y.a1)
    );

    let pairing_value = pair(p_, q_);
    let gt = gt_one();
    let tmp = e12.sub(pairing_value, gt);
    let res = e12.is_zero(tmp);
    return (res=res);
}
