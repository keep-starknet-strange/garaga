%builtins poseidon

from starkware.cairo.common.cairo_builtins import PoseidonBuiltin
from starkware.cairo.common.poseidon_state import PoseidonBuiltinState
from starkware.cairo.common.cairo_secp.bigint import BigInt3

struct X {
    w0: BigInt3,
    w1: BigInt3,
    w2: BigInt3,
    w3: BigInt3,
}

func main{poseidon_ptr: PoseidonBuiltin*}() {
    alloc_locals;
    let x = X(
        w0=BigInt3(d0=1, d1=2, d2=3),
        w1=BigInt3(d0=4, d1=5, d2=6),
        w2=BigInt3(d0=7, d1=8, d2=9),
        w3=BigInt3(d0=10, d1=11, d2=12),
    );
    let resa = a(x=x);
    let resb = b(x=x);
    assert resa = resb;
    return ();
}

func a{poseidon_ptr: PoseidonBuiltin*}(x: X) -> felt {
    tempvar two = 2;
    assert poseidon_ptr[0].input = PoseidonBuiltinState(
        s0=x.w0.d0 * x.w0.d1, s1=x.w0.d2 * x.w1.d0, s2=two
    );
    assert poseidon_ptr[1].input = PoseidonBuiltinState(
        s0=x.w1.d1 * x.w1.d2, s1=poseidon_ptr[0].output.s0, s2=two
    );
    assert poseidon_ptr[2].input = PoseidonBuiltinState(
        s0=x.w2.d0 * x.w2.d1, s1=poseidon_ptr[1].output.s0, s2=two
    );
    assert poseidon_ptr[3].input = PoseidonBuiltinState(
        s0=x.w2.d2 * x.w3.d0, s1=poseidon_ptr[2].output.s0, s2=two
    );
    assert poseidon_ptr[4].input = PoseidonBuiltinState(
        s0=x.w3.d1 * x.w3.d2, s1=poseidon_ptr[3].output.s0, s2=two
    );
    tempvar poseidon_ptr = poseidon_ptr + 5 * PoseidonBuiltin.SIZE;
    tempvar continuable_hash = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    ret;
}

func b{poseidon_ptr: PoseidonBuiltin*}(x: X) -> felt {
    tempvar ptr = cast(poseidon_ptr, felt*);
    tempvar two = 2;
    assert ptr[0] = x.w0.d0 * x.w0.d1;
    assert ptr[1] = x.w0.d2 * x.w1.d0;
    assert ptr[2] = two;
    assert ptr[6] = x.w1.d1 * x.w1.d2;
    assert ptr[7] = [ptr + 3];
    assert ptr[8] = two;
    assert ptr[12] = x.w2.d0 * x.w2.d1;
    assert ptr[13] = ptr[9];
    assert ptr[14] = two;
    assert ptr[18] = x.w2.d2 * x.w3.d0;
    assert ptr[19] = ptr[15];
    assert ptr[20] = two;
    assert ptr[24] = x.w3.d1 * x.w3.d2;
    assert ptr[25] = ptr[21];
    assert ptr[26] = two;

    tempvar poseidon_ptr = poseidon_ptr + 5 * PoseidonBuiltin.SIZE;
    tempvar continuable_hash = [poseidon_ptr - PoseidonBuiltin.SIZE].output.s0;
    ret;
}
