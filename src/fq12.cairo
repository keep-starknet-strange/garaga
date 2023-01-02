from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq
from src.u255 import u255, Uint512
from src.fbn254 import fbn254 as fq_lib
from src.uint384_extension import uint384_extension_lib, Uint768
from src.uint384 import uint384_lib, Uint384

struct FQ12 {
    e0: Uint256,
    e1: Uint256,
    e2: Uint256,
    e3: Uint256,
    e4: Uint256,
    e5: Uint256,
    e6: Uint256,
    e7: Uint256,
    e8: Uint256,
    e9: Uint256,
    e10: Uint256,
    e11: Uint256,
}

// This library is implemented without recursvie calls, hardcoding and repeating code instead, for the sake of efficiency

namespace fq12_lib {
    func add{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x: FQ12, y: FQ12) -> (sum_mod: FQ12) {
        // TODO: check why alloc_locals seems to be needed here
        alloc_locals;
        let e0: Uint256 = fq_lib.add(x.e0, y.e0);
        let e1: Uint256 = fq_lib.add(x.e1, y.e1);
        let e2: Uint256 = fq_lib.add(x.e2, y.e2);
        let e3: Uint256 = fq_lib.add(x.e3, y.e3);
        let e4: Uint256 = fq_lib.add(x.e4, y.e4);
        let e5: Uint256 = fq_lib.add(x.e5, y.e5);
        let e6: Uint256 = fq_lib.add(x.e6, y.e6);
        let e7: Uint256 = fq_lib.add(x.e7, y.e7);
        let e8: Uint256 = fq_lib.add(x.e8, y.e8);
        let e9: Uint256 = fq_lib.add(x.e9, y.e9);
        let e10: Uint256 = fq_lib.add(x.e10, y.e10);
        let e11: Uint256 = fq_lib.add(x.e11, y.e11);
        let res = FQ12(e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11);
        return (res,);
    }

    func sub{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x: FQ12, y: FQ12) -> (sum_mod: FQ12) {
        alloc_locals;
        let (e0: Uint256) = fq_lib.sub(x.e0, y.e0);
        let (e1: Uint256) = fq_lib.sub(x.e1, y.e1);
        let (e2: Uint256) = fq_lib.sub(x.e2, y.e2);
        let (e3: Uint256) = fq_lib.sub(x.e3, y.e3);
        let (e4: Uint256) = fq_lib.sub(x.e4, y.e4);
        let (e5: Uint256) = fq_lib.sub(x.e5, y.e5);
        let (e6: Uint256) = fq_lib.sub(x.e6, y.e6);
        let (e7: Uint256) = fq_lib.sub(x.e7, y.e7);
        let (e8: Uint256) = fq_lib.sub(x.e8, y.e8);
        let (e9: Uint256) = fq_lib.sub(x.e9, y.e9);
        let (e10: Uint256) = fq_lib.sub(x.e10, y.e10);
        let (e11: Uint256) = fq_lib.sub(x.e11, y.e11);
        let res = FQ12(e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11);
        return (res,);
    }

    // func scalar_mul{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x: felt, y: FQ12) -> (
    //     product: FQ12
    // ) {
    //     alloc_locals;
    //     let (e0: Uint256) = fq_lib.scalar_mul(x, y.e0);
    //     let (e1: Uint256) = fq_lib.scalar_mul(x, y.e1);
    //     let (e2: Uint256) = fq_lib.scalar_mul(x, y.e2);
    //     let (e3: Uint256) = fq_lib.scalar_mul(x, y.e3);
    //     let (e4: Uint256) = fq_lib.scalar_mul(x, y.e4);
    //     let (e5: Uint256) = fq_lib.scalar_mul(x, y.e5);
    //     let (e6: Uint256) = fq_lib.scalar_mul(x, y.e6);
    //     let (e7: Uint256) = fq_lib.scalar_mul(x, y.e7);
    //     let (e8: Uint256) = fq_lib.scalar_mul(x, y.e8);
    //     let (e9: Uint256) = fq_lib.scalar_mul(x, y.e9);
    //     let (e10: Uint256) = fq_lib.scalar_mul(x, y.e10);
    //     let (e11: Uint256) = fq_lib.scalar_mul(x, y.e11);
    //     let res = FQ12(e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11);
    //     return (res,);
    // }

    // func scalar_mul_Uint256{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(x: Uint256, y: FQ12) -> (
    //     product: FQ12
    // ) {
    //     alloc_locals;
    //     let (e0: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e0);
    //     let (e1: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e1);
    //     let (e2: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e2);
    //     let (e3: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e3);
    //     let (e4: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e4);
    //     let (e5: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e5);
    //     let (e6: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e6);
    //     let (e7: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e7);
    //     let (e8: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e8);
    //     let (e9: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e9);
    //     let (e10: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e10);
    //     let (e11: Uint256) = fq_lib.scalar_mul_Uint256(x, y.e11);
    //     let res = FQ12(e0, e1, e2, e3, e4, e5, e6, e7, e8, e9, e10, e11);
    //     return (res,);
    // }

    func mul{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: FQ12, b: FQ12) -> (product: FQ12) {
        alloc_locals;
        // d0
        let d0: Uint256 = fq_lib.mul(a.e0, b.e0);

        // d1
        let b_0_1: Uint256 = fq_lib.mul(a.e0, b.e1);
        let b_1_0: Uint256 = fq_lib.mul(a.e1, b.e0);
        let d1: Uint256 = fq_lib.add(b_0_1, b_1_0);

        // d2
        let b_0_2: Uint256 = fq_lib.mul(a.e0, b.e2);
        let b_1_1: Uint256 = fq_lib.mul(a.e1, b.e1);
        let b_2_0: Uint256 = fq_lib.mul(a.e2, b.e0);
        let d2: Uint256 = fq_lib.add(b_0_2, b_1_1);
        let d2: Uint256 = fq_lib.add(d2, b_2_0);

        // d3
        let b_0_3: Uint256 = fq_lib.mul(a.e0, b.e3);
        let b_1_2: Uint256 = fq_lib.mul(a.e1, b.e2);
        let b_2_1: Uint256 = fq_lib.mul(a.e2, b.e1);
        let b_3_0: Uint256 = fq_lib.mul(a.e3, b.e0);
        let d3: Uint256 = fq_lib.add(b_0_3, b_1_2);
        let d3: Uint256 = fq_lib.add(d3, b_2_1);
        let d3: Uint256 = fq_lib.add(d3, b_3_0);

        // d4
        let b_0_4: Uint256 = fq_lib.mul(a.e0, b.e4);
        let b_1_3: Uint256 = fq_lib.mul(a.e1, b.e3);
        let b_2_2: Uint256 = fq_lib.mul(a.e2, b.e2);
        let b_3_1: Uint256 = fq_lib.mul(a.e3, b.e1);
        let b_4_0: Uint256 = fq_lib.mul(a.e4, b.e0);
        let d4: Uint256 = fq_lib.add(b_0_4, b_1_3);
        %{ print_u_256_info(ids.b_0_4, "b_0_4") %}
        %{ print_u_256_info(ids.b_1_3, "b_1_3") %}

        %{ print_u_256_info(ids.d4, "d4") %}
        let d4: Uint256 = fq_lib.add(d4, b_2_2);
        let d4: Uint256 = fq_lib.add(d4, b_3_1);
        let d4: Uint256 = fq_lib.add(d4, b_4_0);

        // d5
        let b_0_5: Uint256 = fq_lib.mul(a.e0, b.e5);
        let b_1_4: Uint256 = fq_lib.mul(a.e1, b.e4);
        let b_2_3: Uint256 = fq_lib.mul(a.e2, b.e3);
        let b_3_2: Uint256 = fq_lib.mul(a.e3, b.e2);
        let b_4_1: Uint256 = fq_lib.mul(a.e4, b.e1);
        let b_5_0: Uint256 = fq_lib.mul(a.e5, b.e0);
        let d5: Uint256 = fq_lib.add(b_0_5, b_1_4);
        let d5: Uint256 = fq_lib.add(d5, b_2_3);
        let d5: Uint256 = fq_lib.add(d5, b_3_2);
        let d5: Uint256 = fq_lib.add(d5, b_4_1);
        let d5: Uint256 = fq_lib.add(d5, b_5_0);

        // d6
        let b_0_6: Uint256 = fq_lib.mul(a.e0, b.e6);
        let b_1_5: Uint256 = fq_lib.mul(a.e1, b.e5);
        let b_2_4: Uint256 = fq_lib.mul(a.e2, b.e4);
        let b_3_3: Uint256 = fq_lib.mul(a.e3, b.e3);
        let b_4_2: Uint256 = fq_lib.mul(a.e4, b.e2);
        let b_5_1: Uint256 = fq_lib.mul(a.e5, b.e1);
        let b_6_0: Uint256 = fq_lib.mul(a.e6, b.e0);
        let d6: Uint256 = fq_lib.add(b_0_6, b_1_5);
        let d6: Uint256 = fq_lib.add(d6, b_2_4);
        let d6: Uint256 = fq_lib.add(d6, b_3_3);
        let d6: Uint256 = fq_lib.add(d6, b_4_2);
        let d6: Uint256 = fq_lib.add(d6, b_5_1);
        let d6: Uint256 = fq_lib.add(d6, b_6_0);

        // d7
        let b_0_7: Uint256 = fq_lib.mul(a.e0, b.e7);
        let b_1_6: Uint256 = fq_lib.mul(a.e1, b.e6);
        let b_2_5: Uint256 = fq_lib.mul(a.e2, b.e5);
        let b_3_4: Uint256 = fq_lib.mul(a.e3, b.e4);
        let b_4_3: Uint256 = fq_lib.mul(a.e4, b.e3);
        let b_5_2: Uint256 = fq_lib.mul(a.e5, b.e2);
        let b_6_1: Uint256 = fq_lib.mul(a.e6, b.e1);
        let b_7_0: Uint256 = fq_lib.mul(a.e7, b.e0);
        let d7: Uint256 = fq_lib.add(b_0_7, b_1_6);
        let d7: Uint256 = fq_lib.add(d7, b_2_5);
        let d7: Uint256 = fq_lib.add(d7, b_3_4);
        let d7: Uint256 = fq_lib.add(d7, b_4_3);
        let d7: Uint256 = fq_lib.add(d7, b_5_2);
        let d7: Uint256 = fq_lib.add(d7, b_6_1);
        let d7: Uint256 = fq_lib.add(d7, b_7_0);

        // d8
        let b_0_8: Uint256 = fq_lib.mul(a.e0, b.e8);
        let b_1_7: Uint256 = fq_lib.mul(a.e1, b.e7);
        let b_2_6: Uint256 = fq_lib.mul(a.e2, b.e6);
        let b_3_5: Uint256 = fq_lib.mul(a.e3, b.e5);
        let b_4_4: Uint256 = fq_lib.mul(a.e4, b.e4);
        let b_5_3: Uint256 = fq_lib.mul(a.e5, b.e3);
        let b_6_2: Uint256 = fq_lib.mul(a.e6, b.e2);
        let b_7_1: Uint256 = fq_lib.mul(a.e7, b.e1);
        let b_8_0: Uint256 = fq_lib.mul(a.e8, b.e0);
        let d8: Uint256 = fq_lib.add(b_0_8, b_1_7);
        let d8: Uint256 = fq_lib.add(d8, b_2_6);
        let d8: Uint256 = fq_lib.add(d8, b_3_5);
        let d8: Uint256 = fq_lib.add(d8, b_4_4);
        let d8: Uint256 = fq_lib.add(d8, b_5_3);
        let d8: Uint256 = fq_lib.add(d8, b_6_2);
        let d8: Uint256 = fq_lib.add(d8, b_7_1);
        let d8: Uint256 = fq_lib.add(d8, b_8_0);

        // d9
        let b_0_9: Uint256 = fq_lib.mul(a.e0, b.e9);
        let b_1_8: Uint256 = fq_lib.mul(a.e1, b.e8);
        let b_2_7: Uint256 = fq_lib.mul(a.e2, b.e7);
        let b_3_6: Uint256 = fq_lib.mul(a.e3, b.e6);
        let b_4_5: Uint256 = fq_lib.mul(a.e4, b.e5);
        let b_5_4: Uint256 = fq_lib.mul(a.e5, b.e4);
        let b_6_3: Uint256 = fq_lib.mul(a.e6, b.e3);
        let b_7_2: Uint256 = fq_lib.mul(a.e7, b.e2);
        let b_8_1: Uint256 = fq_lib.mul(a.e8, b.e1);
        let b_9_0: Uint256 = fq_lib.mul(a.e9, b.e0);
        let d9: Uint256 = fq_lib.add(b_0_9, b_1_8);
        let d9: Uint256 = fq_lib.add(d9, b_2_7);
        let d9: Uint256 = fq_lib.add(d9, b_3_6);
        let d9: Uint256 = fq_lib.add(d9, b_4_5);
        let d9: Uint256 = fq_lib.add(d9, b_5_4);
        let d9: Uint256 = fq_lib.add(d9, b_6_3);
        let d9: Uint256 = fq_lib.add(d9, b_7_2);
        let d9: Uint256 = fq_lib.add(d9, b_8_1);
        let d9: Uint256 = fq_lib.add(d9, b_9_0);

        // d10
        let b_0_10: Uint256 = fq_lib.mul(a.e0, b.e10);
        let b_1_9: Uint256 = fq_lib.mul(a.e1, b.e9);
        let b_2_8: Uint256 = fq_lib.mul(a.e2, b.e8);
        let b_3_7: Uint256 = fq_lib.mul(a.e3, b.e7);
        let b_4_6: Uint256 = fq_lib.mul(a.e4, b.e6);
        let b_5_5: Uint256 = fq_lib.mul(a.e5, b.e5);
        let b_6_4: Uint256 = fq_lib.mul(a.e6, b.e4);
        let b_7_3: Uint256 = fq_lib.mul(a.e7, b.e3);
        let b_8_2: Uint256 = fq_lib.mul(a.e8, b.e2);
        let b_9_1: Uint256 = fq_lib.mul(a.e9, b.e1);
        let b_10_0: Uint256 = fq_lib.mul(a.e10, b.e0);
        let d10: Uint256 = fq_lib.add(b_0_10, b_1_9);
        let d10: Uint256 = fq_lib.add(d10, b_2_8);
        let d10: Uint256 = fq_lib.add(d10, b_3_7);
        let d10: Uint256 = fq_lib.add(d10, b_4_6);
        let d10: Uint256 = fq_lib.add(d10, b_5_5);
        let d10: Uint256 = fq_lib.add(d10, b_6_4);
        let d10: Uint256 = fq_lib.add(d10, b_7_3);
        let d10: Uint256 = fq_lib.add(d10, b_8_2);
        let d10: Uint256 = fq_lib.add(d10, b_9_1);
        let d10: Uint256 = fq_lib.add(d10, b_10_0);

        // d11
        let b_0_11: Uint256 = fq_lib.mul(a.e0, b.e11);
        let b_1_10: Uint256 = fq_lib.mul(a.e1, b.e10);
        let b_2_9: Uint256 = fq_lib.mul(a.e2, b.e9);
        let b_3_8: Uint256 = fq_lib.mul(a.e3, b.e8);
        let b_4_7: Uint256 = fq_lib.mul(a.e4, b.e7);
        let b_5_6: Uint256 = fq_lib.mul(a.e5, b.e6);
        let b_6_5: Uint256 = fq_lib.mul(a.e6, b.e5);
        let b_7_4: Uint256 = fq_lib.mul(a.e7, b.e4);
        let b_8_3: Uint256 = fq_lib.mul(a.e8, b.e3);
        let b_9_2: Uint256 = fq_lib.mul(a.e9, b.e2);
        let b_10_1: Uint256 = fq_lib.mul(a.e10, b.e1);
        let b_11_0: Uint256 = fq_lib.mul(a.e11, b.e0);
        let d11: Uint256 = fq_lib.add(b_0_11, b_1_10);
        let d11: Uint256 = fq_lib.add(d11, b_2_9);
        let d11: Uint256 = fq_lib.add(d11, b_3_8);
        let d11: Uint256 = fq_lib.add(d11, b_4_7);
        let d11: Uint256 = fq_lib.add(d11, b_5_6);
        let d11: Uint256 = fq_lib.add(d11, b_6_5);
        let d11: Uint256 = fq_lib.add(d11, b_7_4);
        let d11: Uint256 = fq_lib.add(d11, b_8_3);
        let d11: Uint256 = fq_lib.add(d11, b_9_2);
        let d11: Uint256 = fq_lib.add(d11, b_10_1);
        let d11: Uint256 = fq_lib.add(d11, b_11_0);

        // d12
        let b_1_11: Uint256 = fq_lib.mul(a.e1, b.e11);
        let b_2_10: Uint256 = fq_lib.mul(a.e2, b.e10);
        let b_3_9: Uint256 = fq_lib.mul(a.e3, b.e9);
        let b_4_8: Uint256 = fq_lib.mul(a.e4, b.e8);
        let b_5_7: Uint256 = fq_lib.mul(a.e5, b.e7);
        let b_6_6: Uint256 = fq_lib.mul(a.e6, b.e6);
        let b_7_5: Uint256 = fq_lib.mul(a.e7, b.e5);
        let b_8_4: Uint256 = fq_lib.mul(a.e8, b.e4);
        let b_9_3: Uint256 = fq_lib.mul(a.e9, b.e3);
        let b_10_2: Uint256 = fq_lib.mul(a.e10, b.e2);
        let b_11_1: Uint256 = fq_lib.mul(a.e11, b.e1);
        let d12: Uint256 = fq_lib.add(b_1_11, b_2_10);
        let d12: Uint256 = fq_lib.add(d12, b_3_9);
        let d12: Uint256 = fq_lib.add(d12, b_4_8);
        let d12: Uint256 = fq_lib.add(d12, b_5_7);
        let d12: Uint256 = fq_lib.add(d12, b_6_6);
        let d12: Uint256 = fq_lib.add(d12, b_7_5);
        let d12: Uint256 = fq_lib.add(d12, b_8_4);
        let d12: Uint256 = fq_lib.add(d12, b_9_3);
        let d12: Uint256 = fq_lib.add(d12, b_10_2);
        let d12: Uint256 = fq_lib.add(d12, b_11_1);

        // d13
        let b_2_11: Uint256 = fq_lib.mul(a.e2, b.e11);
        let b_3_10: Uint256 = fq_lib.mul(a.e3, b.e10);
        let b_4_9: Uint256 = fq_lib.mul(a.e4, b.e9);
        let b_5_8: Uint256 = fq_lib.mul(a.e5, b.e8);
        let b_6_7: Uint256 = fq_lib.mul(a.e6, b.e7);
        let b_7_6: Uint256 = fq_lib.mul(a.e7, b.e6);
        let b_8_5: Uint256 = fq_lib.mul(a.e8, b.e5);
        let b_9_4: Uint256 = fq_lib.mul(a.e9, b.e4);
        let b_10_3: Uint256 = fq_lib.mul(a.e10, b.e3);
        let b_11_2: Uint256 = fq_lib.mul(a.e11, b.e2);
        let d13: Uint256 = fq_lib.add(b_2_11, b_3_10);
        let d13: Uint256 = fq_lib.add(d13, b_4_9);
        let d13: Uint256 = fq_lib.add(d13, b_5_8);
        let d13: Uint256 = fq_lib.add(d13, b_6_7);
        let d13: Uint256 = fq_lib.add(d13, b_7_6);
        let d13: Uint256 = fq_lib.add(d13, b_8_5);
        let d13: Uint256 = fq_lib.add(d13, b_9_4);
        let d13: Uint256 = fq_lib.add(d13, b_10_3);
        let d13: Uint256 = fq_lib.add(d13, b_11_2);

        // d14
        let b_3_11: Uint256 = fq_lib.mul(a.e3, b.e11);
        let b_4_10: Uint256 = fq_lib.mul(a.e4, b.e10);
        let b_5_9: Uint256 = fq_lib.mul(a.e5, b.e9);
        let b_6_8: Uint256 = fq_lib.mul(a.e6, b.e8);
        let b_7_7: Uint256 = fq_lib.mul(a.e7, b.e7);
        let b_8_6: Uint256 = fq_lib.mul(a.e8, b.e6);
        let b_9_5: Uint256 = fq_lib.mul(a.e9, b.e5);
        let b_10_4: Uint256 = fq_lib.mul(a.e10, b.e4);
        let b_11_3: Uint256 = fq_lib.mul(a.e11, b.e3);
        let d14: Uint256 = fq_lib.add(b_3_11, b_4_10);
        let d14: Uint256 = fq_lib.add(d14, b_5_9);
        let d14: Uint256 = fq_lib.add(d14, b_6_8);
        let d14: Uint256 = fq_lib.add(d14, b_7_7);
        let d14: Uint256 = fq_lib.add(d14, b_8_6);
        let d14: Uint256 = fq_lib.add(d14, b_9_5);
        let d14: Uint256 = fq_lib.add(d14, b_10_4);
        let d14: Uint256 = fq_lib.add(d14, b_11_3);

        // d15
        let b_4_11: Uint256 = fq_lib.mul(a.e4, b.e11);
        let b_5_10: Uint256 = fq_lib.mul(a.e5, b.e10);
        let b_6_9: Uint256 = fq_lib.mul(a.e6, b.e9);
        let b_7_8: Uint256 = fq_lib.mul(a.e7, b.e8);
        let b_8_7: Uint256 = fq_lib.mul(a.e8, b.e7);
        let b_9_6: Uint256 = fq_lib.mul(a.e9, b.e6);
        let b_10_5: Uint256 = fq_lib.mul(a.e10, b.e5);
        let b_11_4: Uint256 = fq_lib.mul(a.e11, b.e4);
        let d15: Uint256 = fq_lib.add(b_4_11, b_5_10);
        let d15: Uint256 = fq_lib.add(d15, b_6_9);
        let d15: Uint256 = fq_lib.add(d15, b_7_8);
        let d15: Uint256 = fq_lib.add(d15, b_8_7);
        let d15: Uint256 = fq_lib.add(d15, b_9_6);
        let d15: Uint256 = fq_lib.add(d15, b_10_5);
        let d15: Uint256 = fq_lib.add(d15, b_11_4);

        // d16
        let b_5_11: Uint256 = fq_lib.mul(a.e5, b.e11);
        let b_6_10: Uint256 = fq_lib.mul(a.e6, b.e10);
        let b_7_9: Uint256 = fq_lib.mul(a.e7, b.e9);
        let b_8_8: Uint256 = fq_lib.mul(a.e8, b.e8);
        let b_9_7: Uint256 = fq_lib.mul(a.e9, b.e7);
        let b_10_6: Uint256 = fq_lib.mul(a.e10, b.e6);
        let b_11_5: Uint256 = fq_lib.mul(a.e11, b.e5);
        let d16: Uint256 = fq_lib.add(b_5_11, b_6_10);
        let d16: Uint256 = fq_lib.add(d16, b_7_9);
        let d16: Uint256 = fq_lib.add(d16, b_8_8);
        let d16: Uint256 = fq_lib.add(d16, b_9_7);
        let d16: Uint256 = fq_lib.add(d16, b_10_6);
        let d16: Uint256 = fq_lib.add(d16, b_11_5);

        // d17
        let b_6_11: Uint256 = fq_lib.mul(a.e6, b.e11);
        let b_7_10: Uint256 = fq_lib.mul(a.e7, b.e10);
        let b_8_9: Uint256 = fq_lib.mul(a.e8, b.e9);
        let b_9_8: Uint256 = fq_lib.mul(a.e9, b.e8);
        let b_10_7: Uint256 = fq_lib.mul(a.e10, b.e7);
        let b_11_6: Uint256 = fq_lib.mul(a.e11, b.e6);
        let d17: Uint256 = fq_lib.add(b_6_11, b_7_10);
        let d17: Uint256 = fq_lib.add(d17, b_8_9);
        let d17: Uint256 = fq_lib.add(d17, b_9_8);
        let d17: Uint256 = fq_lib.add(d17, b_10_7);
        let d17: Uint256 = fq_lib.add(d17, b_11_6);

        // d18
        let b_7_11: Uint256 = fq_lib.mul(a.e7, b.e11);
        let b_8_10: Uint256 = fq_lib.mul(a.e8, b.e10);
        let b_9_9: Uint256 = fq_lib.mul(a.e9, b.e9);
        let b_10_8: Uint256 = fq_lib.mul(a.e10, b.e8);
        let b_11_7: Uint256 = fq_lib.mul(a.e11, b.e7);
        let d18: Uint256 = fq_lib.add(b_7_11, b_8_10);
        let d18: Uint256 = fq_lib.add(d18, b_9_9);
        let d18: Uint256 = fq_lib.add(d18, b_10_8);
        let d18: Uint256 = fq_lib.add(d18, b_11_7);

        // d19
        let b_8_11: Uint256 = fq_lib.mul(a.e8, b.e11);
        let b_9_10: Uint256 = fq_lib.mul(a.e9, b.e10);
        let b_10_9: Uint256 = fq_lib.mul(a.e10, b.e9);
        let b_11_8: Uint256 = fq_lib.mul(a.e11, b.e8);
        let d19: Uint256 = fq_lib.add(b_8_11, b_9_10);
        let d19: Uint256 = fq_lib.add(d19, b_10_9);
        let d19: Uint256 = fq_lib.add(d19, b_11_8);

        // d20
        let b_9_11: Uint256 = fq_lib.mul(a.e9, b.e11);
        let b_10_10: Uint256 = fq_lib.mul(a.e10, b.e10);
        let b_11_9: Uint256 = fq_lib.mul(a.e11, b.e9);
        let d20: Uint256 = fq_lib.add(b_9_11, b_10_10);
        let d20: Uint256 = fq_lib.add(d20, b_11_9);

        // d21
        let b_10_11: Uint256 = fq_lib.mul(a.e10, b.e11);
        let b_11_10: Uint256 = fq_lib.mul(a.e11, b.e10);
        let d21: Uint256 = fq_lib.add(b_10_11, b_11_10);

        // d22
        let d22: Uint256 = fq_lib.mul(a.e11, b.e11);

        // Reducing the results modulo the irreducible polynomial
        // Note that the order in which _aux_polynomial_reduction is called is important here
        let (d10: Uint256, d16: Uint256) = _aux_polynomial_reduction(d22, d10, d16);
        let (d9: Uint256, d15: Uint256) = _aux_polynomial_reduction(d21, d9, d15);
        let (d8: Uint256, d14: Uint256) = _aux_polynomial_reduction(d20, d8, d14);
        let (d7: Uint256, d13: Uint256) = _aux_polynomial_reduction(d19, d7, d13);
        let (d6: Uint256, d12: Uint256) = _aux_polynomial_reduction(d18, d6, d12);
        let (d5: Uint256, d11: Uint256) = _aux_polynomial_reduction(d17, d5, d11);
        let (d4: Uint256, d10: Uint256) = _aux_polynomial_reduction(d16, d4, d10);
        let (d3: Uint256, d9: Uint256) = _aux_polynomial_reduction(d15, d3, d9);
        let (d2: Uint256, d8: Uint256) = _aux_polynomial_reduction(d14, d2, d8);
        let (d1: Uint256, d7: Uint256) = _aux_polynomial_reduction(d13, d1, d7);
        let (d0: Uint256, d6: Uint256) = _aux_polynomial_reduction(d12, d0, d6);

        return (FQ12(d0, d1, d2, d3, d4, d5, d6, d7, d8, d9, d10, d11),);
    }

    func eq{range_check_ptr}(x: FQ12, y: FQ12) -> (bool: felt) {
        let (is_e0_eq) = uint256_eq(x.e0, y.e0);
        if (is_e0_eq == 0) {
            return (0,);
        }
        let (is_e1_eq) = uint256_eq(x.e1, y.e1);
        if (is_e1_eq == 0) {
            return (0,);
        }
        let (is_e2_eq) = uint256_eq(x.e2, y.e2);
        if (is_e2_eq == 0) {
            return (0,);
        }
        let (is_e3_eq) = uint256_eq(x.e3, y.e3);
        if (is_e3_eq == 0) {
            return (0,);
        }
        let (is_e4_eq) = uint256_eq(x.e4, y.e4);
        if (is_e4_eq == 0) {
            return (0,);
        }
        let (is_e5_eq) = uint256_eq(x.e5, y.e5);
        if (is_e5_eq == 0) {
            return (0,);
        }
        let (is_e6_eq) = uint256_eq(x.e6, y.e6);
        if (is_e6_eq == 0) {
            return (0,);
        }
        let (is_e7_eq) = uint256_eq(x.e7, y.e7);
        if (is_e7_eq == 0) {
            return (0,);
        }
        let (is_e8_eq) = uint256_eq(x.e8, y.e8);
        if (is_e8_eq == 0) {
            return (0,);
        }
        let (is_e9_eq) = uint256_eq(x.e9, y.e9);
        if (is_e9_eq == 0) {
            return (0,);
        }
        let (is_e10_eq) = uint256_eq(x.e10, y.e10);
        if (is_e10_eq == 0) {
            return (0,);
        }
        let (is_e11_eq) = uint256_eq(x.e11, y.e11);
        if (is_e11_eq == 0) {
            return (0,);
        }
        return (1,);
    }

    func zero() -> (zero: FQ12) {
        return (
            zero=FQ12(
            e0=Uint256(0, 0),
            e1=Uint256(0, 0),
            e2=Uint256(0, 0),
            e3=Uint256(0, 0),
            e4=Uint256(0, 0),
            e5=Uint256(0, 0),
            e6=Uint256(0, 0),
            e7=Uint256(0, 0),
            e8=Uint256(0, 0),
            e9=Uint256(0, 0),
            e10=Uint256(0, 0),
            e11=Uint256(0, 0),
            ),
        );
    }

    func one() -> (zero: FQ12) {
        return (
            zero=FQ12(
            e0=Uint256(1, 0),
            e1=Uint256(0, 0),
            e2=Uint256(0, 0),
            e3=Uint256(0, 0),
            e4=Uint256(0, 0),
            e5=Uint256(0, 0),
            e6=Uint256(0, 0),
            e7=Uint256(0, 0),
            e8=Uint256(0, 0),
            e9=Uint256(0, 0),
            e10=Uint256(0, 0),
            e11=Uint256(0, 0),
            ),
        );
    }

    // small utility to turn 128 bit number to an fq12
    // do not input number >= 128 bits
    func bit_128_to_fq12(input: felt) -> (res: FQ12) {
        return (
            res=FQ12(
            e0=Uint256(input, 0),
            e1=Uint256(0, 0),
            e2=Uint256(0, 0),
            e3=Uint256(0, 0),
            e4=Uint256(0, 0),
            e5=Uint256(0, 0),
            e6=Uint256(0, 0),
            e7=Uint256(0, 0),
            e8=Uint256(0, 0),
            e9=Uint256(0, 0),
            e10=Uint256(0, 0),
            e11=Uint256(0, 0),
            ),
        );
    }

    // TODO: test
    // TODO: Should the exponent go further than 768 bits?
    // Computes (a**exp). Uses the fast exponentiation algorithm
    func pow{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: FQ12, exp: Uint512) -> (res: FQ12) {
        alloc_locals;
        %{ print_u_512_info(ids.exp, "exp_") %}

        let is_exp_zero = u255.eq_512(exp, Uint512(0, 0, 0, 0));

        if (is_exp_zero == 1) {
            let (zero_fq12: FQ12) = zero();
            return (zero_fq12,);
        }

        let is_exp_one = u255.eq_512(exp, Uint512(1, 0, 0, 0));
        if (is_exp_one == 1) {
            return (a,);
        }

        let (exp_div_2: Uint512, remainder: Uint256) = fq_lib.u512_unsigned_div_rem(
            exp, Uint256(2, 0)
        );
        %{ print_u_512_info(ids.exp_div_2, "exp_div_2") %}
        let is_remainder_zero = u255.eq(remainder, Uint256(0, 0));

        if (is_remainder_zero == 1) {
            // NOTE: Code is repeated in the if-else to avoid declaring a_squared as a local variable
            let (a_squared: FQ12) = mul(a, a);
            let (res: FQ12) = pow(a_squared, exp_div_2);
            return (res,);
        } else {
            let (a_squared: FQ12) = mul(a, a);
            let (res: FQ12) = pow(a_squared, exp_div_2);
            let (res_mul: FQ12) = mul(a, res);
            return (res_mul,);
        }
    }

    // // Finds and FQ12 x such that a * x = 1
    // func inverse{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(a: FQ12) -> (res: FQ12) {
    //     alloc_locals;

    // let (one_fq12: FQ12) = one();
    //     let (is_a_one) = eq(a, one_fq12);
    //     if (is_a_one == 1) {
    //         return (a,);
    //     }

    // local a_inverse: FQ12;
    //     let (field_modulus: Uint384) = get_modulus();

    // %{
    //         print("findme0")
    //         def split(num: int, num_bits_shift : int = 128, length: int = 3):
    //             a = []
    //             for _ in range(length):
    //                 a.append( num & ((1 << num_bits_shift) - 1) )
    //                 num = num >> num_bits_shift
    //             return tuple(a)

    // def pack(z, num_bits_shift: int = 128) -> int:
    //             limbs = (z.d0, z.d1, z.d2)
    //             return sum(limb << (num_bits_shift * i) for i, limb in enumerate(limbs))

    // # TODO: Do this with a loop?
    //         e0 = pack(ids.a.e0)
    //         e1 = pack(ids.a.e1)
    //         e2 = pack(ids.a.e2)
    //         e3 = pack(ids.a.e3)
    //         e4 = pack(ids.a.e4)
    //         e5 = pack(ids.a.e5)
    //         e6 = pack(ids.a.e6)
    //         e7 = pack(ids.a.e7)
    //         e8 = pack(ids.a.e8)
    //         e9 = pack(ids.a.e9)
    //         e10 = pack(ids.a.e10)
    //         e11 = pack(ids.a.e11)
    //         coeffs_of_a = [e0, e1 , e2, e3, e4, e5, e6, e7, e8, e9,e10, e11]
    //         print("findme1")
    //         field_modulus = pack(ids.field_modulus)

    // print("findme2")
    //         # Adapted from py_ecc: TODO: add link

    // # Utility methods for polynomial math
    //         # Given the list of the coefficients of a polynomial p,
    //         # finds the degree of p
    //         def deg(list_of_polynomial_coefficients):
    //             d = len(list_of_polynomial_coefficients) - 1
    //             while list_of_polynomial_coefficients[d] == 0 and d:
    //                 d -= 1
    //             return d

    // # Computes the division without residue of a polynomial a by another polynomial b
    //         # a and b are given as lists of coefficients
    //         def optimized_poly_rounded_div(a, b):
    //             dega = deg(a)
    //             degb = deg(b)
    //             temp = [x for x in a]
    //             o = [0 for x in a]
    //             for i in range(dega - degb, -1, -1):
    //                 o[i] = int(o[i] + temp[degb + i] * pow(int(b[degb]), -1, field_modulus))
    //                 for c in range(degb + 1):
    //                     temp[c + i] = (temp[c + i] - o[c])
    //             return [x % field_modulus for x in o[:deg(o) + 1]]

    // # Extended euclidean algorithm used to find the modular inverse
    //         # of a polynomial given as a list of coefficients.
    //         # Returns the inverse as a list of coefficients
    //         def inv(coeffs_of_a):
    //             lm, hm = [1] + [0] * 12, [0] * 13
    //             low, high = (
    //                 coeffs_of_a + [0],
    //                 [2, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0] + [1] # modulus coefficients
    //             )
    //             print("findme21")

    // while deg(low):
    //                 print("findme22")
    //                 r = optimized_poly_rounded_div(high, low)
    //                 r += [0] * (13 - len(r))
    //                 nm = [x for x in hm]
    //                 new = [x for x in high]
    //                 for i in range(13):
    //                     for j in range(13 - i):
    //                         nm[i + j] -= lm[i] * int(r[j])
    //                         new[i + j] -= low[i] * r[j]
    //                 nm = [x % field_modulus for x in nm]
    //                 new = [int(x) % field_modulus for x in new]
    //                 lm, low, hm, high = nm, new, lm, low
    //             print("findme23", low)
    //             if low[0] % field_modulus == 0:
    //                 inverse_of_low0 = 1
    //             else:
    //                 inverse_of_low0 = pow(low[0], -1, field_modulus)
    //             print("findme24")
    //             return [(coeff*inverse_of_low0) % field_modulus for coeff in lm[:12]]

    // res = inv(coeffs_of_a)
    //         print("findme3", res)
    //         res = [split(coeff) for coeff in res]

    // ids.a_inverse.e0.d0 = res[0][0]
    //         ids.a_inverse.e0.d1 = res[0][1]
    //         ids.a_inverse.e0.d2 = res[0][2]

    // ids.a_inverse.e1.d0 = res[1][0]
    //         ids.a_inverse.e1.d1 = res[1][1]
    //         ids.a_inverse.e1.d2 = res[1][2]

    // ids.a_inverse.e2.d0 = res[2][0]
    //         ids.a_inverse.e2.d1 = res[2][1]
    //         ids.a_inverse.e2.d2 = res[2][2]

    // ids.a_inverse.e3.d0 = res[3][0]
    //         ids.a_inverse.e3.d1 = res[3][1]
    //         ids.a_inverse.e3.d2 = res[3][2]

    // ids.a_inverse.e4.d0 = res[4][0]
    //         ids.a_inverse.e4.d1 = res[4][1]
    //         ids.a_inverse.e4.d2 = res[4][2]

    // ids.a_inverse.e5.d0 = res[5][0]
    //         ids.a_inverse.e5.d1 = res[5][1]
    //         ids.a_inverse.e5.d2 = res[5][2]

    // ids.a_inverse.e6.d0 = res[6][0]
    //         ids.a_inverse.e6.d1 = res[6][1]
    //         ids.a_inverse.e6.d2 = res[6][2]

    // ids.a_inverse.e7.d0 = res[7][0]
    //         ids.a_inverse.e7.d1 = res[7][1]
    //         ids.a_inverse.e7.d2 = res[7][2]

    // ids.a_inverse.e8.d0 = res[8][0]
    //         ids.a_inverse.e8.d1 = res[8][1]
    //         ids.a_inverse.e8.d2 = res[8][2]

    // ids.a_inverse.e9.d0 = res[9][0]
    //         ids.a_inverse.e9.d1 = res[9][1]
    //         ids.a_inverse.e9.d2 = res[9][2]

    // ids.a_inverse.e10.d0 = res[10][0]
    //         ids.a_inverse.e10.d1 = res[10][1]
    //         ids.a_inverse.e10.d2 = res[10][2]

    // ids.a_inverse.e11.d0 = res[11][0]
    //         ids.a_inverse.e11.d1 = res[11][1]
    //         ids.a_inverse.e11.d2 = res[11][2]
    //         print("findme4")
    //     %}

    // let (a_inverse_times_a: FQ12) = mul(a_inverse, a);
    //     let (one_fq12: FQ12) = one();
    //     let (is_one) = eq(a_inverse_times_a, one_fq12);
    //     assert is_one = 1;
    //     return (a_inverse,);
    // }

    func mul_three_terms{range_check_ptr, bitwise_ptr: BitwiseBuiltin*}(
        x: FQ12, y: FQ12, z: FQ12
    ) -> (res: FQ12) {
        let (x_times_y: FQ12) = mul(x, y);
        let (res: FQ12) = mul(x_times_y, z);
        return (res,);
    }
}

func _aux_polynomial_reduction{bitwise_ptr: BitwiseBuiltin*, range_check_ptr}(
    coeff_to_reduce: Uint256, first_coef: Uint256, second_coef: Uint256
) -> (new_first_coef: Uint256, new_second_coef: Uint256) {
    // TODO: some way to avoid using local variables? (to improve efficiency)
    alloc_locals;
    let twice_coeff_to_reduce: Uint256 = fq_lib.mul(Uint256(2, 0), coeff_to_reduce);
    let first_coef: Uint256 = fq_lib.sub(first_coef, twice_coeff_to_reduce);
    let second_coef: Uint256 = fq_lib.add(second_coef, twice_coeff_to_reduce);
    return (first_coef, second_coef);
}
