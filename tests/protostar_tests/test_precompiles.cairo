%lang starknet

from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.registers import get_fp_and_pc

from src.bn254.fq import BigInt3
from src.bn254.g1 import G1Point, G1, g1, G1PointFull
from src.bn254.g1 import g1_two, g1_three, g1_negone, g1_negtwo, g1_negthree
from src.bn254.g2 import G2Point, g2, get_g2_generator
from src.bn254.towers.e12 import E12, e12
from contracts.bn254_precompiles import ecAdd, ecMul, ecPairing, G2PointFull, E2Full

@view
func test_ec_add{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local one) = G1();
    let (local two) = g1_two();
    let (local res) = ecAdd(one, two);
    let (local three) = g1_three();
    local three_: G1Point* = new G1Point(x=&three.x, y=&three.y);
    local res_: G1Point* = new G1Point(x=&res.x, y=&res.y);
    g1.assert_equal(three_, res_);
    return ();
}

@view
func test_ec_mul{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local one) = G1();
    let (local two) = g1_two();
    local two_: G1Point* = new G1Point(x=&two.x, y=&two.y);
    let (local three) = g1_three();
    local three_: G1Point* = new G1Point(x=&three.x, y=&three.y);
    let (local res_two) = ecMul(one, BigInt3(2, 0, 0));
    local res_two_: G1Point* = new G1Point(x=&res_two.x, y=&res_two.y);
    g1.assert_equal(two_, res_two_);
    let (local res_three) = ecMul(one, BigInt3(3, 0, 0));
    local res_three_: G1Point* = new G1Point(x=&res_three.x, y=&res_three.y);
    g1.assert_equal(three_, res_three_);

    let (local res_mul_1) = ecMul(one, BigInt3(123456789 * 987654321, 0, 0));
    let (local tmp_mul) = ecMul(one, BigInt3(123456789, 0, 0));
    let (local res_mul_2) = ecMul(tmp_mul, BigInt3(987654321, 0, 0));
    local res_mul_1_: G1Point* = new G1Point(x=&res_mul_1.x, y=&res_mul_1.y);
    local res_mul_2_: G1Point* = new G1Point(x=&res_mul_2.x, y=&res_mul_2.y);
    g1.assert_equal(res_mul_1_, res_mul_2_);
    return ();
}

@view
func test_pair{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local pt_g1: G1PointFull) = G1();
    let pt_g2: G2Point* = get_g2_generator();
    let pt_g2_: G2PointFull = G2PointFull(
        x=E2Full(a0=[pt_g2.x.a0], a1=[pt_g2.x.a1]), y=E2Full(a0=[pt_g2.y.a0], a1=[pt_g2.y.a1])
    );
    %{
        import time
        tic = time.perf_counter()
    %}
    let (res: felt) = ecPairing(pt_g1, pt_g2_);
    %{
        tac = time.perf_counter()
        print(f"Pairing computed in {tac - tic:0.4f} seconds")
    %}
    assert 1 = res;
    return ();
}
