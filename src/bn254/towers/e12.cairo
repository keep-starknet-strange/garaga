from src.bn254.towers.e6 import e6, E6
from src.bn254.towers.e2 import e2, E2
from src.bn254.fq import fq_bigint3, BigInt3
from starkware.cairo.common.registers import get_fp_and_pc

struct E12 {
    c0: E6*,
    c1: E6*,
}

namespace e12 {
    func conjugate{range_check_ptr}(x: E12*) -> E12* {
        let c1 = e6.neg(x.c1);
        tempvar res = new E12(x.c0, c1);
        return res;
    }
    // Adds two E12 elements
    func add{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.add(x.c0, y.c0);
        let c1 = e6.add(x.c1, y.c1);
        tempvar res = new E12(c0, c1);
        return res;
    }

    // Subtracts two E12 elements
    func sub{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.sub(x.c0, y.c0);
        let c1 = e6.sub(x.c1, y.c1);
        tempvar res = new E12(c0, c1);
        return res;
    }

    // Returns 2*x in E12
    func double{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.double(x.c0);
        let c1 = e6.double(x.c1);
        tempvar res = new E12(c0, c1);
        return res;
    }
    func mul{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let a = e6.add(x.c0, x.c1);
        let b = e6.add(y.c0, y.c1);
        let a = e6.mul(a, b);
        let b = e6.mul(x.c0, y.c0);
        let c = e6.mul(x.c1, y.c1);
        let zC1 = e6.sub(a, b);
        let zC1 = e6.sub(zC1, c);
        let zC0 = e6.mul_by_non_residue(c);
        let zC0 = e6.add(zC0, b);
        tempvar res = new E12(zC0, zC1);
        return res;
    }

    func mul_by_034{range_check_ptr}(z: E12*, c3: E2*, c4: E2*) -> E12* {
        alloc_locals;
        let b = e6.mul_by_01(z.c1, c3, c4);

        let c3_a0 = fq_bigint3.add(new BigInt3(1, 0, 0), c3.a0);
        tempvar c3_plus_one = new E2(c3_a0, c3.a1);
        let d = e6.add(z.c0, z.c1);
        let d = e6.mul_by_01(d, c3_plus_one, c4);

        let zC1 = e6.add(z.c0, b);
        let zC1 = e6.neg(zC1);
        let zC1 = e6.add(zC1, d);
        let zC0 = e6.mul_by_non_residue(b);
        let zC0 = e6.add(zC0, z.c0);
        tempvar res = new E12(zC0, zC1);
        return res;
    }

    func mul_034_by_034{range_check_ptr}(d3: E2*, d4: E2*, c3: E2*, c4: E2*) -> E12* {
        alloc_locals;
        let one = e2.one();
        let x3 = e2.mul(c3, d3);
        let x4 = e2.mul(c4, d4);

        let x04 = e2.add(c4, d4);
        let x03 = e2.add(c3, d3);
        let tmp = e2.add(c3, c4);
        let x34 = e2.add(d3, d4);
        let x34 = e2.mul(x34, tmp);
        let x34 = e2.sub(x34, x3);
        let x34 = e2.sub(x34, x4);

        let zC0B0 = e2.mul_by_non_residue(x4);
        let zC0B0 = e2.add(zC0B0, one);
        let zC0B1 = x3;
        let zC0B2 = x34;
        let zC1B0 = x03;
        let zC1B1 = x04;
        let zC1B2 = e2.zero();
        tempvar res = new E12(new E6(zC0B0, zC0B1, zC0B2), new E6(zC1B0, zC1B1, zC1B2));
        return res;
    }
    func square{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.sub(x.c0, x.c1);
        let c3 = e6.mul_by_non_residue(x.c1);
        let c3 = e6.neg(c3);
        let c3 = e6.add(x.c0, c3);
        let c2 = e6.mul(x.c0, x.c1);
        let c0 = e6.mul(c0, c3);
        let c0 = e6.add(c0, c2);
        let c1 = e6.double(c2);
        let c2 = e6.mul_by_non_residue(c2);
        let c0 = e6.add(c0, c2);
        tempvar res = new E12(c0, c1);
        return res;
    }

    func inverse{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local inv0: BigInt3;
        local inv1: BigInt3;
        local inv2: BigInt3;
        local inv3: BigInt3;
        local inv4: BigInt3;
        local inv5: BigInt3;
        local inv6: BigInt3;
        local inv7: BigInt3;
        local inv8: BigInt3;
        local inv9: BigInt3;
        local inv10: BigInt3;
        local inv11: BigInt3;
        tempvar inv = new E12(
            new E6(new E2(&inv0, &inv1), new E2(&inv2, &inv3), new E2(&inv4, &inv5)),
            new E6(new E2(&inv6, &inv7), new E2(&inv8, &inv9), new E2(&inv10, &inv11)),
        );

        %{
            from starkware.cairo.common.cairo_secp.secp_utils import pack
            def rgetattr(obj, attr, *args):
                def _getattr(obj, attr):
                    return getattr(obj, attr, *args)
                return functools.reduce(_getattr, [obj] + attr.split('.'))

            def rsetattr(obj, attr, val):
                pre, _, post = attr.rpartition('.')
                return setattr(rgetattr(obj, pre) if pre else obj, post, val)
            def parse_e12(x):
                return [pack(x.c0.b0.a0, PRIME), pack(x.c0.b0.a1, PRIME), pack(x.c0.b1.a0, PRIME), pack(x.c0.b1.a1, PRIME), 
                pack(x.c0.b2.a0, PRIME), pack(x.c0.b2.a1, PRIME), pack(x.c1.b0.a0, PRIME), pack(x.c1.b0.a1, PRIME),
                pack(x.c1.b1.a0, PRIME), pack(x.c1.b1.a1, PRIME), pack(x.c1.b2.a0, PRIME), pack(x.c1.b2.a1, PRIME)]
            def fill_e12(e2:str, *args):
                for i in range(12):
                    splitted = split(args[i])
                    for j in range(3):
                        rsetattr(ids,e2+str(i)+'.d'+str(j),splitted[j])
                return None
            def parse_fp_elements(input_string:str):
                pattern = re.compile(r'\[([^\[\]]+)\]')
                substrings = pattern.findall(input_string)
                sublists = [substring.split(' ') for substring in substrings]
                sublists = [[int(x) for x in sublist] for sublist in sublists]
                fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
                return fp_elements
            inputs=parse_e12(ids.x)
            cmd = ['./tools/parser_go/main', 'e12', 'inv'] + 2*[str(x) for x in inputs]
            out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
            fp_elements:list = parse_fp_elements(out)
            assert len(fp_elements) == 12
            fill_e12('inv', *fp_elements)
        %}
        let check = e12.mul(x, inv);
        let one = e12.one();
        let check = e12.sub(check, one);
        let check_is_zero: felt = e12.is_zero(check);
        assert check_is_zero = 1;
        return inv;
    }

    func pow3{range_check_ptr}(x: E12*) -> E12* {
        let x2 = square(x);
        let res = mul(x2, x);
        return res;
    }

    func is_zero{range_check_ptr}(x: E12*) -> felt {
        let c0_is_zero = e6.is_zero(x.c0);
        if (c0_is_zero == 0) {
            return 0;
        }

        let c1_is_zero = e6.is_zero(x.c1);
        return c1_is_zero;
    }
    func zero{}() -> E12* {
        let c0 = e6.zero();
        let c1 = e6.zero();
        tempvar res = new E12(c0, c1);
        return res;
    }
    func one{}() -> E12* {
        let c0 = e6.one();
        let c1 = e6.zero();
        tempvar res = new E12(c0, c1);
        return res;
    }
    func frobenius{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0B0 = e2.conjugate(x.c0.b0);
        let c0B1 = e2.conjugate(x.c0.b1);
        let c0B2 = e2.conjugate(x.c0.b2);
        let c1B0 = e2.conjugate(x.c1.b0);
        let c1B1 = e2.conjugate(x.c1.b1);
        let c1B2 = e2.conjugate(x.c1.b2);

        let c0B1 = e2.mul_by_non_residue_1_power_2(c0B1);
        let c0B2 = e2.mul_by_non_residue_1_power_4(c0B2);
        let c1B0 = e2.mul_by_non_residue_1_power_1(c1B0);
        let c1B1 = e2.mul_by_non_residue_1_power_3(c1B1);
        let c1B2 = e2.mul_by_non_residue_1_power_5(c1B2);

        tempvar res = new E12(new E6(c0B0, c0B1, c0B2), new E6(c1B0, c1B1, c1B2));
        return res;
    }

    func frobenius_square{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0B0 = x.c0.b0;
        let c0B1 = e2.mul_by_non_residue_2_power_2(x.c0.b1);
        let c0B2 = e2.mul_by_non_residue_2_power_4(x.c0.b2);
        let c1B0 = e2.mul_by_non_residue_2_power_1(x.c1.b0);
        let c1B1 = e2.mul_by_non_residue_2_power_3(x.c1.b1);
        let c1B2 = e2.mul_by_non_residue_2_power_5(x.c1.b2);
        tempvar res = new E12(new E6(c0B0, c0B1, c0B2), new E6(c1B0, c1B1, c1B2));
        return res;
    }

    func frobenius_cube{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0B0 = e2.conjugate(x.c0.b0);
        let c0B1 = e2.conjugate(x.c0.b1);
        let c0B2 = e2.conjugate(x.c0.b2);
        let c1B0 = e2.conjugate(x.c1.b0);
        let c1B1 = e2.conjugate(x.c1.b1);
        let c1B2 = e2.conjugate(x.c1.b2);

        let c0B1 = e2.mul_by_non_residue_3_power_2(c0B1);
        let c0B2 = e2.mul_by_non_residue_3_power_4(c0B2);
        let c1B0 = e2.mul_by_non_residue_3_power_1(c1B0);
        let c1B1 = e2.mul_by_non_residue_3_power_3(c1B1);
        let c1B2 = e2.mul_by_non_residue_3_power_5(c1B2);

        tempvar res = new E12(new E6(c0B0, c0B1, c0B2), new E6(c1B0, c1B1, c1B2));
        return res;
    }
    func cyclotomic_square{range_check_ptr}(x: E12*) -> E12* {
        // // x=(x0,x1,x2,x3,x4,x5,x6,x7) in E2^6
        // // cyclosquare(x)=(3*x4^2*u + 3*x0^2 - 2*x0,
        // //					3*x2^2*u + 3*x3^2 - 2*x1,
        // //					3*x5^2*u + 3*x1^2 - 2*x2,
        // //					6*x1*x5*u + 2*x3,
        // //					6*x0*x4 + 2*x4,
        // //					6*x2*x3 + 2*x5)

        alloc_locals;
        let t0 = e2.square(x.c1.b1);
        let t1 = e2.square(x.c0.b0);
        let t6 = e2.add(x.c1.b1, x.c0.b0);
        let t6 = e2.square(t6);
        let t6 = e2.sub(t6, t0);
        let t6 = e2.sub(t6, t1);  // 2*x4*x0
        let t2 = e2.square(x.c0.b2);
        let t3 = e2.square(x.c1.b0);
        let t7 = e2.add(x.c0.b2, x.c1.b0);
        let t7 = e2.square(t7);
        let t7 = e2.sub(t7, t2);
        let t7 = e2.sub(t7, t3);  // 2*x2*x3

        let t4 = e2.square(x.c1.b2);
        let t5 = e2.square(x.c0.b1);

        let t8 = e2.add(x.c1.b2, x.c0.b1);
        let t8 = e2.square(t8);
        let t8 = e2.sub(t8, t4);
        let t8 = e2.sub(t8, t5);
        let t8 = e2.mul_by_non_residue(t8);  // 2*x5*x1*u

        let t0 = e2.mul_by_non_residue(t0);
        let t0 = e2.add(t0, t1);  // x4^2*u + x0^2
        let t2 = e2.mul_by_non_residue(t2);
        let t2 = e2.add(t2, t3);  // x2^2*u + x3^2
        let t4 = e2.mul_by_non_residue(t4);
        let t4 = e2.add(t4, t5);  // x5^2*u + x1^2

        let zc0b0 = e2.sub(t0, x.c0.b0);
        let zc0b0 = e2.double(zc0b0);
        let zc0b0 = e2.add(zc0b0, t0);

        let zc0b1 = e2.sub(t2, x.c0.b1);
        let zc0b1 = e2.double(zc0b1);
        let zc0b1 = e2.add(zc0b1, t2);

        let zc0b2 = e2.sub(t4, x.c0.b2);
        let zc0b2 = e2.double(zc0b2);
        let zc0b2 = e2.add(zc0b2, t4);

        let zc1b0 = e2.add(t8, x.c1.b0);
        let zc1b0 = e2.double(zc1b0);
        let zc1b0 = e2.add(zc1b0, t8);

        let zc1b1 = e2.add(t6, x.c1.b1);
        let zc1b1 = e2.double(zc1b1);
        let zc1b1 = e2.add(zc1b1, t6);

        let zc1b2 = e2.add(t7, x.c1.b2);
        let zc1b2 = e2.double(zc1b2);
        let zc1b2 = e2.add(zc1b2, t7);

        tempvar res = new E12(new E6(zc0b0, zc0b1, zc0b2), new E6(zc1b0, zc1b1, zc1b2));
        return res;
    }
    func n_square{range_check_ptr}(x: E12*, n: felt) -> E12* {
        let res = x;
        if (n == 0) {
            return x;
        } else {
            let res = cyclotomic_square(x);
            return n_square(res, n - 1);
        }
    }
    func expt{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        // Step 1: t3 = x^0x2
        let t3 = cyclotomic_square(x);
        // Step 2: t5 = x^0x4
        let t5 = cyclotomic_square(t3);
        // Step 3: result = x^0x8
        let result = cyclotomic_square(t5);
        // Step 4: t0 = x^0x10
        let t0 = cyclotomic_square(result);
        // Step 5: t2 = x^0x11
        let t2 = mul(x, t0);
        // Step 6: t0 = x^0x13
        let t0 = mul(t3, t2);
        // Step 7: t1 = x^0x14
        let t1 = mul(x, t0);
        // Step 8: t4 = x^0x19
        let t4 = mul(result, t2);
        // Step 9: t6 = x^0x22
        let t6 = cyclotomic_square(t2);
        // Step 10: t1 = x^0x27
        let t1 = mul(t0, t1);
        // Step 11: t0 = x^0x29
        let t0 = mul(t3, t1);
        // Step 17: t6 = x^0x880
        let t6 = n_square(t6, 6);
        // Step 18: t5 = x^0x884
        let t5 = mul(t5, t6);
        // Step 19: t5 = x^0x89d
        let t5 = mul(t4, t5);
        // Step 26: t5 = x^0x44e80
        let t5 = n_square(t5, 7);
        // Step 27: t4 = x^0x44e99
        let t4 = mul(t4, t5);
        // Step 35: t4 = x^0x44e9900
        let t4 = n_square(t4, 8);
        // Step 36: t4 = x^0x44e9929
        let t4 = mul(t0, t4);
        // Step 37: t3 = x^0x44e992b
        let t3 = mul(t3, t4);
        // Step 43: t3 = x^0x113a64ac0
        let t3 = n_square(t3, 6);
        // Step 44: t2 = x^0x113a64ad1
        let t2 = mul(t2, t3);
        // Step 52: t2 = x^0x113a64ad100
        let t2 = n_square(t2, 8);
        // Step 53: t2 = x^0x113a64ad129
        let t2 = mul(t0, t2);
        // Step 59: t2 = x^0x44e992b44a40
        let t2 = n_square(t2, 6);
        // Step 60: t2 = x^0x44e992b44a69
        let t2 = mul(t0, t2);
        // Step 70: t2 = x^0x113a64ad129a400
        let t2 = n_square(t2, 10);
        // Step 71: t1 = x^0x113a64ad129a427
        let t1 = mul(t1, t2);
        // Step 77: t1 = x^0x44e992b44a6909c0
        let t1 = n_square(t1, 6);
        // Step 78: t0 = x^0x44e992b44a6909e9
        let t0 = mul(t0, t1);
        // Step 79: result = x^0x44e992b44a6909f1
        let result = mul(result, t0);

        return result;
    }
    func assert_E12(x: E12*, z: E12*) {
        e6.assert_E6(x.c0, z.c0);
        e6.assert_E6(x.c1, z.c1);
        return ();
    }
}

// Hint argument: value
// a 12 element list of field elements
func nondet_E12{range_check_ptr}() -> (res: E12) {
    let res: E12 = [cast(ap + 38, E12*)];
    %{
        from starkware.cairo.common.cairo_secp.secp_utils import split

        r = ids.res
        var_list = [r.c0.b0.a0, r.c0.b0.a1, r.c0.b1.a0, r.c0.b1.a1, r.c0.b2.a0, r.c0.b2.a1, 
                    r.c1.b0.a0, r.c1.b0.a1, r.c1.b1.a0, r.c1.b1.a1, r.c1.b2.a0, r.c1.b2.a1]
        #segments.write_arg(ids.res.e0.address_, split(val[0]))
        for (var, val) in zip(var_list, value):
            segments.write_arg(var.address_, split(val))
    %}
    const MAX_SUM = 12 * 3 * (2 ** 86 - 1);
    // TODO RANGE CHECKS? (WHY THE ASSERT LIKE THS BTW?)
    assert [range_check_ptr] = MAX_SUM - (
        res.c0.b0.a0.d0 +
        res.c0.b0.a0.d1 +
        res.c0.b0.a0.d2 +
        res.c0.b0.a1.d0 +
        res.c0.b0.a1.d1 +
        res.c0.b0.a1.d2 +
        res.c0.b1.a0.d0 +
        res.c0.b1.a0.d1 +
        res.c0.b1.a0.d2 +
        res.c0.b1.a1.d0 +
        res.c0.b1.a1.d1 +
        res.c0.b1.a1.d2 +
        res.c0.b2.a0.d0 +
        res.c0.b2.a0.d1 +
        res.c0.b2.a0.d2 +
        res.c0.b2.a1.d0 +
        res.c0.b2.a1.d1 +
        res.c0.b2.a1.d2 +
        res.c1.b0.a0.d0 +
        res.c1.b0.a0.d1 +
        res.c1.b0.a0.d2 +
        res.c1.b0.a1.d0 +
        res.c1.b0.a1.d1 +
        res.c1.b0.a1.d2 +
        res.c1.b1.a0.d0 +
        res.c1.b1.a0.d1 +
        res.c1.b1.a0.d2 +
        res.c1.b1.a1.d0 +
        res.c1.b1.a1.d1 +
        res.c1.b1.a1.d2 +
        res.c1.b2.a0.d0 +
        res.c1.b2.a0.d1 +
        res.c1.b2.a0.d2 +
        res.c1.b2.a1.d0 +
        res.c1.b2.a1.d1 +
        res.c1.b2.a1.d2
    );

    tempvar range_check_ptr = range_check_ptr + 37;
    [range_check_ptr - 1] = res.c0.b0.a0.d0, ap++;
    [range_check_ptr - 2] = res.c0.b0.a0.d1, ap++;
    [range_check_ptr - 3] = res.c0.b0.a0.d2, ap++;
    [range_check_ptr - 4] = res.c0.b0.a1.d0, ap++;
    [range_check_ptr - 5] = res.c0.b0.a1.d1, ap++;
    [range_check_ptr - 6] = res.c0.b0.a1.d2, ap++;
    [range_check_ptr - 7] = res.c0.b1.a0.d0, ap++;
    [range_check_ptr - 8] = res.c0.b1.a0.d1, ap++;
    [range_check_ptr - 9] = res.c0.b1.a0.d2, ap++;
    [range_check_ptr - 10] = res.c0.b1.a1.d0, ap++;
    [range_check_ptr - 11] = res.c0.b1.a1.d1, ap++;
    [range_check_ptr - 12] = res.c0.b1.a1.d2, ap++;
    [range_check_ptr - 13] = res.c0.b2.a0.d0, ap++;
    [range_check_ptr - 14] = res.c0.b2.a0.d1, ap++;
    [range_check_ptr - 15] = res.c0.b2.a0.d2, ap++;
    [range_check_ptr - 16] = res.c0.b2.a1.d0, ap++;
    [range_check_ptr - 17] = res.c0.b2.a1.d1, ap++;
    [range_check_ptr - 18] = res.c0.b2.a1.d2, ap++;
    [range_check_ptr - 19] = res.c1.b0.a0.d0, ap++;
    [range_check_ptr - 20] = res.c1.b0.a0.d1, ap++;
    [range_check_ptr - 21] = res.c1.b0.a0.d2, ap++;
    [range_check_ptr - 22] = res.c1.b0.a1.d0, ap++;
    [range_check_ptr - 23] = res.c1.b0.a1.d1, ap++;
    [range_check_ptr - 24] = res.c1.b0.a1.d2, ap++;
    [range_check_ptr - 25] = res.c1.b1.a0.d0, ap++;
    [range_check_ptr - 26] = res.c1.b1.a0.d1, ap++;
    [range_check_ptr - 27] = res.c1.b1.a0.d2, ap++;
    [range_check_ptr - 28] = res.c1.b1.a1.d0, ap++;
    [range_check_ptr - 29] = res.c1.b1.a1.d1, ap++;
    [range_check_ptr - 30] = res.c1.b1.a1.d2, ap++;
    [range_check_ptr - 31] = res.c1.b2.a0.d0, ap++;
    [range_check_ptr - 32] = res.c1.b2.a0.d1, ap++;
    [range_check_ptr - 33] = res.c1.b2.a0.d2, ap++;
    [range_check_ptr - 34] = res.c1.b2.a1.d0, ap++;
    [range_check_ptr - 35] = res.c1.b2.a1.d1, ap++;
    [range_check_ptr - 36] = res.c1.b2.a1.d2, ap++;

    // [range_check_ptr - 5] = res.e1.d1, ap++;
    // [range_check_ptr - 6] = res.e1.d2, ap++;
    // [range_check_ptr - 7] = res.e2.d0, ap++;
    // [range_check_ptr - 8] = res.e2.d1, ap++;
    // [range_check_ptr - 9] = res.e2.d2, ap++;
    // [range_check_ptr - 10] = res.e3.d0, ap++;
    // [range_check_ptr - 11] = res.e3.d1, ap++;
    // [range_check_ptr - 12] = res.e3.d2, ap++;
    // [range_check_ptr - 13] = res.e4.d0, ap++;
    // [range_check_ptr - 14] = res.e4.d1, ap++;
    // [range_check_ptr - 15] = res.e4.d2, ap++;
    // [range_check_ptr - 16] = res.e5.d0, ap++;
    // [range_check_ptr - 17] = res.e5.d1, ap++;
    // [range_check_ptr - 18] = res.e5.d2, ap++;
    // [range_check_ptr - 19] = res.e6.d0, ap++;
    // [range_check_ptr - 20] = res.e6.d1, ap++;
    // [range_check_ptr - 21] = res.e6.d2, ap++;
    // [range_check_ptr - 22] = res.e7.d0, ap++;
    // [range_check_ptr - 23] = res.e7.d1, ap++;
    // [range_check_ptr - 24] = res.e7.d2, ap++;
    // [range_check_ptr - 25] = res.e8.d0, ap++;
    // [range_check_ptr - 26] = res.e8.d1, ap++;
    // [range_check_ptr - 27] = res.e8.d2, ap++;
    // [range_check_ptr - 28] = res.e9.d0, ap++;
    // [range_check_ptr - 29] = res.e9.d1, ap++;
    // [range_check_ptr - 30] = res.e9.d2, ap++;
    // [range_check_ptr - 31] = res.e10.d0, ap++;
    // [range_check_ptr - 32] = res.e10.d1, ap++;
    // [range_check_ptr - 33] = res.e10.d2, ap++;
    // [range_check_ptr - 34] = res.e11.d0, ap++;
    // [range_check_ptr - 35] = res.e11.d1, ap++;
    // [range_check_ptr - 36] = res.e11.d2, ap++;
    static_assert &res + E12.SIZE == ap;
    return (res=res);
}
