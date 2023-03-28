from src.bls12_381.towers.e6 import e6, E6
from src.bls12_381.towers.e2 import e2, E2
from src.bls12_381.fq import fq_bigint3, BigInt3
from starkware.cairo.common.registers import get_fp_and_pc

struct E12 {
    c0: E6*,
    c1: E6*,
}

namespace e12 {
    // Returns the conjugate of x in E12
    func conjugate{range_check_ptr}(x: E12*) -> E12* {
        let c1 = e6.neg(x.c1);
        tempvar res = new E12(x.c0, c1);
        return res;
    }  // OK

    // Adds two E12 elements
    func add{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.add(x.c0, y.c0);
        let c1 = e6.add(x.c1, y.c1);
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    // Subtracts two E12 elements
    func sub{range_check_ptr}(x: E12*, y: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.sub(x.c0, y.c0);
        let c1 = e6.sub(x.c1, y.c1);
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    // Returns 2*x in E12
    func double{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let c0 = e6.double(x.c0);
        let c1 = e6.double(x.c1);
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

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
    }  // OK

    // Multiplication by sparse element (c0, c1, 0, 0, c4)
    func mul_by_014{range_check_ptr}(z: E12*, c0: E2*, c1: E2*, c4: E2*) -> E12* {
        alloc_locals;
        let a = e6.mul_by_01(z.c0, c0, c1);
        let b = e6.mul_by_1(z.c1, c4);
        let d = e2.add(c1, c4);
        let zC1 = e6.add(z.c1, z.c0);
        let zC1 = e6.mul_by_01(zC1, c0, d);
        let zC1 = e6.sub(zC1, a);
        let zC1 = e6.sub(zC1, b);
        let zC0 = e6.mul_by_non_residue(b);
        let zC0 = e6.add(zC0, a);
        tempvar res = new E12(zC0, zC1);
        return res;
    }  // OK

    // Mul014By014 multiplication of sparse element (c0,c1,0,0,c4,0) by sparse element (d0,d1,0,0,d4,0)
    func mul_014_by_014{range_check_ptr}(
        c0: E2*, c1: E2*, c4: E2*, d0: E2*, d1: E2*, d4: E2*
    ) -> E12* {
        alloc_locals;
        let x0 = e2.mul(c0, d0);
        let x1 = e2.mul(c1, d1);
        let x4 = e2.mul(c4, d4);
        let tmp = e2.add(c0, c4);
        let x04 = e2.add(d0, d4);
        let x04 = e2.mul(x04, tmp);
        let x04 = e2.sub(x04, x0);
        let x04 = e2.sub(x04, x4);
        let tmp = e2.add(c0, c1);
        let x01 = e2.add(d0, d1);
        let x01 = e2.mul(x01, tmp);
        let x01 = e2.sub(x01, x0);
        let x01 = e2.sub(x01, x1);
        let tmp = e2.add(c1, c4);
        let x14 = e2.add(d1, d4);
        let x14 = e2.mul(x14, tmp);
        let x14 = e2.sub(x14, x1);
        let x14 = e2.sub(x14, x4);
        let c0B0 = e2.mul_by_non_residue(x4);
        let c0B0 = e2.add(c0B0, x0);
        let c0B1 = x01;
        let c0B2 = x1;
        let c1B0 = e2.zero();
        let c1B1 = x04;
        let c1B2 = x14;
        tempvar res = new E12(new E6(c0B0, c0B1, c0B2), new E6(c1B0, c1B1, c1B2));
        return res;
    }  // OK

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
    }  // OK

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

    func inverse_go{range_check_ptr}(x: E12*) -> E12* {
        let t0 = e6.square(x.c0);
        let t1 = e6.square(x.c1);
        let tmp = e6.mul_by_non_residue(t1);
        let t0 = e6.sub(t0, tmp);
        let t1 = e6.inverse(t0);
        let c0 = e6.mul(x.c0, t1);
        let c1 = e6.mul(x.c1, t1);
        let c1 = e6.neg(c1);
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    func is_zero{range_check_ptr}(x: E12*) -> felt {
        let c0_is_zero = e6.is_zero(x.c0);
        if (c0_is_zero == 0) {
            return 0;
        }

        let c1_is_zero = e6.is_zero(x.c1);
        return c1_is_zero;
    }  // OK

    func zero{}() -> E12* {
        let c0 = e6.zero();
        let c1 = e6.zero();
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

    func one{}() -> E12* {
        let c0 = e6.one();
        let c1 = e6.zero();
        tempvar res = new E12(c0, c1);
        return res;
    }  // OK

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
    }  // OK?

    func n_square{range_check_ptr}(x: E12*, n: felt) -> E12* {
        if (n == 0) {
            return x;
        } else {
            let res = cyclotomic_square(x);
            return n_square(res, n - 1);
        }
    }  // OK

    // Returns x^(t/2) in E12 where
    // t/2 = 7566188111470821376 // negative
    func expt_half{range_check_ptr}(x: E12*) -> E12* {
        alloc_locals;
        let res = n_square(x, 15);
        let tmp = n_square(res, 32);
        let res = e12.mul(res, tmp);
        let tmp = n_square(tmp, 9);
        let res = e12.mul(res, tmp);
        let tmp = n_square(tmp, 3);
        let res = e12.mul(res, tmp);
        let tmp = n_square(tmp, 2);
        let res = e12.mul(res, tmp);
        let tmp = cyclotomic_square(tmp);
        let res = e12.mul(res, tmp);
        return conjugate(tmp);
    }  // OK?

    // Returns x^t
    // where t is = 15132376222941642752 // negative
    func expt{range_check_ptr}(x: E12*) -> E12* {
        let res = expt_half(x);
        return cyclotomic_square(res);
    }  // OK

    func assert_E12(x: E12*, z: E12*) {
        e6.assert_E6(x.c0, z.c0);
        e6.assert_E6(x.c1, z.c1);
        return ();
    }  // OK
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

    static_assert &res + E12.SIZE == ap;
    return (res=res);
}
