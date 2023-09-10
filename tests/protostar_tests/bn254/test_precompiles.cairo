%lang starknet

// Starkware dependencies
from starkware.cairo.common.alloc import alloc
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.registers import get_fp_and_pc

// Project dependencies
from openzeppelin.upgrades.library import Proxy

// Local dependencies
from src.bn254.fq import BigInt3
from src.bn254.g1 import G1Point, G1, g1, G1PointFull
from src.bn254.g2 import G2Point, g2, get_g2_generator, get_n_g2_generator
from src.bn254.towers.e12 import E12, e12
from contracts.cairo_bn254.library import G2PointFull, E2Full, BN254Precompiles

@view
func test_ec_add{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local one) = G1();
    let (local two) = BN254Precompiles.ec_mul(one, BigInt3(2, 0, 0));
    let (local res) = BN254Precompiles.ec_add(one, two);
    let (local three) = BN254Precompiles.ec_mul(one, BigInt3(3, 0, 0));
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
    let (local res_mul_1) = BN254Precompiles.ec_mul(one, BigInt3(123456789 * 987654321, 0, 0));
    let (local tmp_mul) = BN254Precompiles.ec_mul(one, BigInt3(123456789, 0, 0));
    let (local res_mul_2) = BN254Precompiles.ec_mul(tmp_mul, BigInt3(987654321, 0, 0));
    local res_mul_1_: G1Point* = new G1Point(x=&res_mul_1.x, y=&res_mul_1.y);
    local res_mul_2_: G1Point* = new G1Point(x=&res_mul_2.x, y=&res_mul_2.y);
    g1.assert_equal(res_mul_1_, res_mul_2_);
    return ();
}

@view
func test_pair_two_inputs{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    alloc_locals;
    let (__fp__, _) = get_fp_and_pc();
    let (local pt_g1: G1PointFull) = G1();
    local pt_g1_: G1Point* = new G1Point(x=&pt_g1.x, y=&pt_g1.y);
    let minus_g1_: G1Point* = g1.neg(pt_g1_);
    local minus_g1: G1PointFull = G1PointFull(x=[minus_g1_.x], y=[minus_g1_.y]);
    let pt_g2_: G2Point* = get_g2_generator();
    local pt_g2: G2PointFull = G2PointFull(
        x=E2Full(a0=[pt_g2_.x.a0], a1=[pt_g2_.x.a1]), y=E2Full(a0=[pt_g2_.y.a0], a1=[pt_g2_.y.a1])
    );

    let (local p_arr: G1PointFull*) = alloc();
    let (local q_arr: G2PointFull*) = alloc();
    assert p_arr[0] = minus_g1;
    assert q_arr[0] = pt_g2;
    assert p_arr[1] = pt_g1;
    assert q_arr[1] = pt_g2;

    let (res: felt) = BN254Precompiles.ec_pairing(
        n=2,
        p_arr=p_arr,
        q_arr=q_arr,
    );

    assert 1 = res;
    return ();
}
