from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.math_cmp import is_not_zero
from starkware.cairo.common.bitwise import bitwise_and, bitwise_or
from starkware.cairo.common.uint256 import Uint256
from src.fbn254 import fbn254

struct FQ2 {
    e0: Uint256,
    e1: Uint256,
}

namespace fq2 {
    func add{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x: FQ2, y: FQ2) -> FQ2 {
        // TODO: check why these alloc_locals need to be used
        alloc_locals;
        let e0: Uint256 = fbn254.add(x.e0, y.e0);
        let e1: Uint256 = fbn254.add(x.e1, y.e1);
        let res = FQ2(e0=e0, e1=e1);
        return res;
    }

    func sub{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x: FQ2, y: FQ2) -> FQ2 {
        alloc_locals;
        let e0: Uint256 = fbn254.sub(x.e0, y.e0);
        let e1: Uint256 = fbn254.sub(x.e1, y.e1);
        let res = FQ2(e0=e0, e1=e1);
        return res;
    }

    // Multiplies an element of FQ2 by an element of FQ
    func scalar_mul{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x: Uint256, y: FQ2) -> (
        product: FQ2
    ) {
        alloc_locals;
        let e0: Uint256 = fbn254.mul(x, y.e0);
        let e1: Uint256 = fbn254.mul(x, y.e1);

        let res = FQ2(e0=e0, e1=e1);
        return res;
    }

    func mul{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: FQ2, b: FQ2) -> FQ2 {
        alloc_locals;
        let t1 = fbn254.mul(a.e0, b.e0);
        let t2 = fbn254.mul(a.e1, b.e1);
        let t3 = fbn254.add(b.e0, b.e1);
        %{
            print_u_256_info(ids.a.e0,"a.e0")
            print_u_256_info(ids.b.e0,"b.e0")

            print_u_256_info(ids.t1,"t1")
            print_u_256_info(ids.t2,"t2")    
            print_u_256_info(ids.t3,"t3")
        %}
        let imag = fbn254.add(a.e1, a.e0);
        let imag = fbn254.mul(imag, t3);
        let imag = fbn254.sub(imag, t1);
        let imag = fbn254.sub(imag, t2);

        let real = fbn254.sub(t1, t2);

        let res: FQ2 = FQ2(real, imag);

        // let first_term: Uint256 = fbn254.mul(a.e0, b.e0);
        // let b_0_1: Uint256 = fbn254.mul(a.e0, b.e1);
        // let b_1_0: Uint256 = fbn254.mul(a.e1, b.e0);
        // let second_term: Uint256 = fbn254.add(b_0_1, b_1_0);
        // let third_term: Uint256 = fbn254.mul(a.e1, b.e1);

        // // Using the irreducible polynomial x**2 + 1 as modulus, we get that
        // // x**2 = -1, so the term `a.e1 * b.e1 * x**2` becomes
        // // `- a.e1 * b.e1` (always reducing mod p). This way the first term of
        // // the multiplicaiton is `a.e0 * b.e0 - a.e1 * b.e1`
        // let first_term = fbn254.sub(first_term, third_term);

        // let res = FQ2(first_term, second_term);
        return res;
    }

    func div_by_2{range_check_ptr}(a: FQ2) -> FQ2 {
        alloc_locals;
        let new_x: Uint256 = fbn254.div(a.e0, Uint256(2, 0));
        let new_y: Uint256 = fbn254.div(a.e1, Uint256(2, 0));

        let res = FQ2(new_x, new_y);
        return res;
    }
}
