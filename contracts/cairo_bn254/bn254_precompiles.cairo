%lang starknet

// Starkware dependencies.
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_secp.bigint import BigInt3
from starkware.starknet.common.syscalls import get_caller_address

// Project dependencies.
from openzeppelin.upgrades.library import Proxy

// Local dependencies.
from src.bn254.g1 import G1PointFull
from contracts.cairo_bn254.library import BN254Precompiles, PairingInput

@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (owner) = get_caller_address();
    Proxy.initializer(owner);
    return ();
}

@view
func ecAdd{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    a: G1PointFull, b: G1PointFull
) -> (res: G1PointFull) {
    let (res) = BN254Precompiles.ec_add(a, b);
    return (res=res);
}

@view
func ecMul{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    a: G1PointFull, s: BigInt3
) -> (res: G1PointFull) {
    alloc_locals;
    let (res) = BN254Precompiles.ec_mul(a, s);
    return (res=res);
}

@view
func ecPairing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    input_len: felt, input: PairingInput*
) -> (res: felt) {
    let (res) = BN254Precompiles.ec_pairing(input_len, input);
    return (res=res);
}

//
// Proxy administration
//

// @notice Return the current implementation hash.
// @return implementation The implementation class hash.
@view
func getImplementationHash{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (
    implementation: felt
) {
    return Proxy.get_implementation_hash();
}

// @notice Return the current admin address.
// @return admin The admin address.
@view
func getAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() -> (admin: felt) {
    return Proxy.get_admin();
}

// @notice Upgrade the contract to the new implementation.
// @dev This function is only callable by the admin.
// @param new_implementation The new implementation class hash.
@external
func upgrade{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    new_implementation: felt
) {
    Proxy.assert_only_admin();
    Proxy._set_implementation_hash(new_implementation);
    return ();
}

// @notice Transfer admin rights to a new admin.
// @dev This function is only callable by the admin.
// @param new_admin The new admin address.
@external
func setAdmin{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(new_admin: felt) {
    Proxy.assert_only_admin();
    Proxy._set_admin(new_admin);
    return ();
}
