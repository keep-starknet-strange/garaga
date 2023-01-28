from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from src.u255 import u255, Uint512
from src.fq import fq as fq_lib, fq_eq_zero
from src.fq2 import FQ2, fq2

struct FQ6 {
    e0: Uint256,
    e1: Uint256,
    e2: Uint256,
    e3: Uint256,
    e4: Uint256,
    e5: Uint256,
}

namespace fq6 {

    func mul_tower_fq2{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: FQ2, b: FQ2) -> FQ2 {
        alloc_locals;
        
        //let a0 = a.e0;
        //let a1 = a.e1;

        //let b0 = b.e0;
        //let b1 = b.e1;
        
        let res = fq2.mul(a,b);
        return res;

    }
    
    func add_tower{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: FQ6, b: FQ6) -> FQ6 {
        alloc_locals;
        let a0 = FQ2(a.e0, a.e1);
        let a1 = FQ2(a.e2, a.e3);
        let a2 = FQ2(a.e4, a.e5);

        let b0 = FQ2(b.e0, b.e1);
        let b1 = FQ2(b.e2, b.e3);
        let b2 = FQ2(b.e4, b.e5);

        let c0 = fq2.add(a0, b0);
        let c1 = fq2.add(a1, b1);
        let c2 = fq2.add(a2, b2);

        let res = FQ6(c0.e0, c0.e1, c1.e0, c1.e1, c2.e0, c2.e1);
        return res;
    }

    func sub_tower{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: FQ6, b: FQ6) -> FQ6 {
        alloc_locals;
        let a0 = FQ2(a.e0, a.e1);
        let a1 = FQ2(a.e2, a.e3);
        let a2 = FQ2(a.e4, a.e5);

        let b0 = FQ2(b.e0, b.e1);
        let b1 = FQ2(b.e2, b.e3);
        let b2 = FQ2(b.e4, b.e5);

        let c0 = fq2.sub(a0, b0);
        let c1 = fq2.sub(a1, b1);
        let c2 = fq2.sub(a2, b2);

        let res = FQ6(c0.e0, c0.e1, c1.e0, c1.e1, c2.e0, c2.e1);
        return res;
    }

    func mul_tower{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: FQ6, b: FQ6) -> FQ6 {
        alloc_locals;
        
        let a0 = FQ2(a.e0, a.e1);
        let a1 = FQ2(a.e2, a.e3);
        let a2 = FQ2(a.e4, a.e5);

        let b0 = FQ2(b.e0, b.e1);
        let b1 = FQ2(b.e2, b.e3);
        let b2 = FQ2(b.e4, b.e5);
        
        let t0 = mul_tower_fq2(a0, b0);
        let t1 = mul_tower_fq2(a1, b1);
        let t2 = mul_tower_fq2(a2, b2);

        let nonresidue = FQ2(Uint256(low=9, high=0),Uint256(low=1, high=0));

        //  c0 = [(a1 + a2) · (b1 + b2) − t1 − t2] · ξ + t0;
        let a1_plus_a2 = fq2.add(a1, a2);
        let b1_plus_b2 = fq2.add(b1, b2);
        let product = fq2.mul(a1_plus_a2, b1_plus_b2);
        let minus_t1 = fq2.sub(product, t1);
        let minus_t2 = fq2.sub(minus_t1, t2);

        //mul by non resiude
        let mul_xi = fq2.mul(minus_t2, nonresidue);
        let c0 = fq2.add(mul_xi, t0);


        // c1 = (a0 + a1) · (b0 + b1) − t0 − t1 + ξ · t2;
        let a0_plus_a1 = fq2.add(a0, a1);
        let b0_plus_b1 = fq2.add(b0, b1);
        let product = fq2.mul(a0_plus_a1, b0_plus_b1);
        let minus_t0 = fq2.sub(product, t0);
        let minus_t1 = fq2.sub(minus_t0, t1);
        let nonresidue_mul_t2 = fq2.mul(t2, nonresidue);
        let c1 = fq2.add(minus_t1, nonresidue_mul_t2);


        // c2 = (a0 + a2) · (b0 + b2) − t0 − t2 + t1;
        let a0_plus_a2 = fq2.add(a0, a2);
        let b0_plus_b2 = fq2.add(b0, b2);
        let product = fq2.mul(a0_plus_a2, b0_plus_b2);
        let minus_t0 = fq2.sub(product, t0);
        let minus_t2 = fq2.sub(minus_t0, t2);
        let c2 = fq2.add(minus_t2, t1);
        
        let res = FQ6(c0.e0, c0.e1, c1.e0, c1.e1, c2.e0, c2.e1);
        return res;
    }


    func mul_nonresidue{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: FQ6, rho: FQ2) -> FQ6 {
        alloc_locals;
        let a2 = FQ2(a.e4, a.e5);

        let c0  = fq2.mul(a2, rho);

        let e0 = c0.e0;
        let e1 = c0.e1;

        let res = FQ6(e0,e1,a.e0,a.e1,a.e2,a.e3);
        return res;
    }

}