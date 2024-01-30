%lang starknet

// Starkware dependencies.
from starkware.cairo.common.cairo_builtins import HashBuiltin
from starkware.cairo.common.cairo_secp.bigint import BigInt3
from starkware.starknet.common.syscalls import get_caller_address

// Project dependencies.
from openzeppelin.upgrades.library import Proxy

// Local dependencies.
from src.bn254.g1 import G1PointFull
from src.bn254.g2 import G2PointFull
from contracts.cairo_bn254.library import BN254Precompiles

//
// Initializer
//

// @notice Initialize the contract with the given parameters.
//   This constructor uses a dedicated function initialize the proxy.
@external
func initializer{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}() {
    let (owner) = get_caller_address();
    Proxy.initializer(owner);
    return ();
}

//
// Views
//

// @notice Add two G1 Points.
// @param a The first G1 Point.
// @param b The second G1 Point.
// @return res The addition result.
@view
func ecAdd{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    a: G1PointFull, b: G1PointFull
) -> (res: G1PointFull) {
    let (res) = BN254Precompiles.ec_add(a, b);
    return (res=res);
}

// @notice Multiply a G1 Point by a scalar.
// @param a The G1 Point.
// @param s The scalar.
// @return res The multiplication result.
@view
func ecMul{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    a: G1PointFull, s: BigInt3
) -> (res: G1PointFull) {
    alloc_locals;
    let (res) = BN254Precompiles.ec_mul(a, s);
    return (res=res);
}

// @notice Computes the pairing of an array of (G1,G2) points.
// @param p_len The length of G1 points array.
// @param p_arr The G1 point array.
// @param q_len The length of G2 points array.
// @param q_len The G1 point array.
// @return res The result of the pairing success as a boolean.
@view
func ecPairing{syscall_ptr: felt*, pedersen_ptr: HashBuiltin*, range_check_ptr}(
    n: felt, p_arr: G1PointFull*, q_arr: G2PointFull*
) -> (res: felt) {
    let (res) = BN254Precompiles.ec_pairing(n, p_arr, q_arr);
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

//
// Externals
//

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
