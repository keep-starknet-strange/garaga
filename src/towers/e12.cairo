from starkware.cairo.common.cairo_builtins import BitwiseBuiltin
from starkware.cairo.common.uint256 import Uint256, uint256_eq

from src.towers.e6 import e6, E6
from src.towers.e2 import e2, E2

struct E12 {
    c0: E6,
    c1: E6,
}

namespace e12 {
    // func (z *E12) Conjugate(x *E12) *E12 {
    // 	*z = *x
    // 	z.C1.Neg(&z.C1)
    // 	return z
    // }

    func conjugate{range_check_ptr}(x: E12) -> E12 {
        let c1 = e6.neg(x.c1);
        let res = E12(x.c0, c1);
        return res;
    }

    // // Frobenius set z to Frobenius(x), return z
    // func (z *E12) Frobenius(x *E12) *E12 {
    // 	// Algorithm 28 from https://eprint.iacr.org/2010/354.pdf
    // 	var t [6]E2

    // // Frobenius acts on fp2 by conjugation
    // 	t[0].Conjugate(&x.C0.B0)
    // 	t[1].Conjugate(&x.C0.B1)
    // 	t[2].Conjugate(&x.C0.B2)
    // 	t[3].Conjugate(&x.C1.B0)
    // 	t[4].Conjugate(&x.C1.B1)
    // 	t[5].Conjugate(&x.C1.B2)

    // t[1].MulByNonResidue1Power2(&t[1])
    // 	t[2].MulByNonResidue1Power4(&t[2])
    // 	t[3].MulByNonResidue1Power1(&t[3])
    // 	t[4].MulByNonResidue1Power3(&t[4])
    // 	t[5].MulByNonResidue1Power5(&t[5])

    // z.C0.B0 = t[0]
    // 	z.C0.B1 = t[1]
    // 	z.C0.B2 = t[2]
    // 	z.C1.B0 = t[3]
    // 	z.C1.B1 = t[4]
    // 	z.C1.B2 = t[5]

    // return z
    // }

    func frobenius{range_check_ptr}(x: E12) -> E12 {
        let c0B0 = x.c0.b0;
        let c0B1 = e2.mul_by_non_residue_1_power_2(x.c0.b1);
        let c0B2 = e2.mul_by_non_residue_1_power_4(x.c0.b2);
        let c1B0 = e2.mul_by_non_residue_1_power_1(x.c1.b0);
        let c1B1 = e2.mul_by_non_residue_1_power_3(x.c1.b1);
        let c1B2 = e2.mul_by_non_residue_1_power_5(x.c1.b2);
        let res = E12(E6(c0B0, c0B1, c0B2), E6(c1B0, c1B1, c1B2));
        return res;
    }

    // // FrobeniusSquare set z to Frobenius^2(x), and return z
    // func (z *E12) FrobeniusSquare(x *E12) *E12 {
    // 	// Algorithm 29 from https://eprint.iacr.org/2010/354.pdf
    // 	z.C0.B0 = x.C0.B0
    // 	z.C0.B1.MulByNonResidue2Power2(&x.C0.B1)
    // 	z.C0.B2.MulByNonResidue2Power4(&x.C0.B2)
    // 	z.C1.B0.MulByNonResidue2Power1(&x.C1.B0)
    // 	z.C1.B1.MulByNonResidue2Power3(&x.C1.B1)
    // 	z.C1.B2.MulByNonResidue2Power5(&x.C1.B2)

    // return z
    // }

    func frobenius_square{range_check_ptr}(x: E12) -> E12 {
        let c0B0 = x.c0.b0;
        let c0B1 = e2.mul_by_non_residue_2_power_2(x.c0.b1);
        let c0B2 = e2.mul_by_non_residue_2_power_4(x.c0.b2);
        let c1B0 = e2.mul_by_non_residue_2_power_1(x.c1.b0);
        let c1B1 = e2.mul_by_non_residue_2_power_3(x.c1.b1);
        let c1B2 = e2.mul_by_non_residue_2_power_5(x.c1.b2);
        let res = E12(E6(c0B0, c0B1, c0B2), E6(c1B0, c1B1, c1B2));
        return res;
    }

    // // FrobeniusCube set z to Frobenius^3(x), return z
    // func (z *E12) FrobeniusCube(x *E12) *E12 {
    // 	// Algorithm 30 from https://eprint.iacr.org/2010/354.pdf
    // 	var t [6]E2

    // // Frobenius^3 acts on fp2 by conjugation
    // 	t[0].Conjugate(&x.C0.B0)
    // 	t[1].Conjugate(&x.C0.B1)
    // 	t[2].Conjugate(&x.C0.B2)
    // 	t[3].Conjugate(&x.C1.B0)
    // 	t[4].Conjugate(&x.C1.B1)
    // 	t[5].Conjugate(&x.C1.B2)

    // t[1].MulByNonResidue3Power2(&t[1])
    // 	t[2].MulByNonResidue3Power4(&t[2])
    // 	t[3].MulByNonResidue3Power1(&t[3])
    // 	t[4].MulByNonResidue3Power3(&t[4])
    // 	t[5].MulByNonResidue3Power5(&t[5])

    // z.C0.B0 = t[0]
    // 	z.C0.B1 = t[1]
    // 	z.C0.B2 = t[2]
    // 	z.C1.B0 = t[3]
    // 	z.C1.B1 = t[4]
    // 	z.C1.B2 = t[5]

    // return z
    // }

    func frobenius_cube{range_check_ptr}(x: E12) -> E12 {
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

        let res = E12(E6(c0B0, c0B1, c0B2), E6(c1B0, c1B1, c1B2));
        return res;
    }

    // Multiplies x and y
    // var a, b, c E6
    // a.Add(&x.C0, &x.C1)
    // b.Add(&y.C0, &y.C1)
    // a.Mul(&a, &b)
    // b.Mul(&x.C0, &y.C0)
    // c.Mul(&x.C1, &y.C1)
    // z.C1.Sub(&a, &b).Sub(&z.C1, &c)
    // z.C0.MulByNonResidue(&c).Add(&z.C0, &b)
    func mul{range_check_ptr}(x: E12, y: E12) -> E12 {
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
        let res = E12(zC0, zC1);
        return res;
    }
    func inverse{range_check_ptr}(x: E12) -> E12 {
        alloc_locals;
        local inverse: E12;
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
                return [pack(x.c0.b0.a0), pack(x.c0.b0.a1), pack(x.c0.b1.a0), pack(x.c0.b1.a1), 
                pack(x.c0.b2.a0), pack(x.c0.b2.a1), pack(x.c1.b0.a0), pack(x.c1.b0.a1),
                pack(x.c1.b1.a0), pack(x.c1.b1.a1), pack(x.c1.b2.a0), pack(x.c1.b2.a1)]
            def fill_e12(e2:str, *args):
                structs = ['c0.b0.a0','c0.b0.a1','c0.b1.a0','c0.b1.a1','c0.b2.a0','c0.b2.a1',
                'c1.b0.a0','c1.b0.a1','c1.b1.a0','c1.b1.a1','c1.b2.a0','c1.b2.a1']
                for i, s in enumerate(structs):
                    splitted = split(args[i])
                    for j in range(3):
                        rsetattr(ids,e2+'.'+s+'.d'+str(j),splitted[j])
                return None
            def parse_fp_elements(input_string:str):
                pattern = re.compile(r'\[([^\[\]]+)\]')
                substrings = pattern.findall(input_string)
                sublists = [substring.split(' ') for substring in substrings]
                sublists = [[int(x) for x in sublist] for sublist in sublists]
                fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
                return fp_elements
            x=parse_e12(ids.x)
            cmd = ['./tools/parser_go/main', 'e12', 'inv'] + [str(x) for x in inputs]
            out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
            fp_elements:list = parse_fp_elements(out)

            fill_e12('inverse', *fp_elements)
        %}
        let check: E12 = e12.mul(x, inverse);
        let one = e12.one();
        let check: E12 = e12.sub(check, one);
        let check_is_zero: felt = e12.is_zero(check);
        assert check_is_zero = 1;
        return inverse;
    }
    // Adds two E12 elements
    func add{range_check_ptr}(x: E12, y: E12) -> E12 {
        alloc_locals;
        let c0 = e6.add(x.c0, y.c0);
        let c1 = e6.add(x.c1, y.c1);
        let res = E12(c0, c1);
        return res;
    }

    // Subtracts two E6 elements
    func sub{range_check_ptr}(x: E12, y: E12) -> E12 {
        alloc_locals;
        let c0 = e6.sub(x.c0, y.c0);
        let c1 = e6.sub(x.c1, y.c1);
        let res = E12(c0, c1);
        return res;
    }

    // Returns 2*x in E12
    func double{range_check_ptr}(x: E12) -> E12 {
        let c0 = e6.double(x.c0);
        let c1 = e6.double(x.c1);
        let res = E12(c0, c1);
    }

    // var c0, c2, c3 E6
    // c0.Sub(&x.C0, &x.C1)
    // c3.MulByNonResidue(&x.C1).Neg(&c3).Add(&x.C0, &c3)
    // c2.Mul(&x.C0, &x.C1)
    // c0.Mul(&c0, &c3).Add(&c0, &c2)
    // z.C1.Double(&c2)
    // c2.MulByNonResidue(&c2)
    // z.C0.Add(&c0, &c2)
    func square{range_check_ptr}(x: E12) -> E12 {
        alloc_locals;
        let c0 = e6.sub(x.c0, x.c1);
        let c3 = e6.mul_by_non_residue(x.c1);
        let c3 = e6.neg(c3);
        let c3 = e6.add(x.c0, c3);
        let c2 = e6.mul(x.c0, x.c1);
        let c0 = e6.mul(c0, c3);
        let c0 = e6.add(c0, c2);
        let zC1 = e6.double(c2);
        let c2 = e6.mul_by_non_residue(c2);
        let zC0 = e6.mul(c0, c2);
        let res = E12(zC0, zC1);
        return res;
    }
    func n_square{range_check_ptr}(x: E12, n: felt) -> E12 {
        let res = x;
        if (n == 0) {
            return x;
        } else {
            let res = cyclotomic_square(x);
            return n_square(res, n - 1);
        }
    }

    func pow3{range_check_ptr}(x: E12) -> E12 {
        let x2 = square(x);
        let res = mul(x2, x);
        return res;
    }

    func is_zero{range_check_ptr}(x: E12) -> felt {
        let c0_is_zero = e6.is_zero(x.c0);
        if (c0_is_zero == 0) {
            return 0;
        }

        let c1_is_zero = e6.is_zero(x.c1);
        return c1_is_zero;
    }
    func zero{}() -> E12 {
        let c0 = e6.zero();
        let c1 = e6.zero();
        let res = E12(c0, c1);
        return res;
    }
    func one{}() -> E12 {
        let c0 = e6.one();
        let c1 = e6.zero();
        let res = E12(c0, c1);
        return res;
    }
    func cyclotomic_square{range_check_ptr}(x: E12) -> E12 {
        // // x=(x0,x1,x2,x3,x4,x5,x6,x7) in E2^6
        // // cyclosquare(x)=(3*x4^2*u + 3*x0^2 - 2*x0,
        // //					3*x2^2*u + 3*x3^2 - 2*x1,
        // //					3*x5^2*u + 3*x1^2 - 2*x2,
        // //					6*x1*x5*u + 2*x3,
        // //					6*x0*x4 + 2*x4,
        // //					6*x2*x3 + 2*x5)

        // var t [9]E2

        // t[0].Square(&x.C1.B1)
        // t[1].Square(&x.C0.B0)
        // t[6].Add(&x.C1.B1, &x.C0.B0).Square(&t[6]).Sub(&t[6], &t[0]).Sub(&t[6], &t[1]) // 2*x4*x0
        // t[2].Square(&x.C0.B2)
        // t[3].Square(&x.C1.B0)
        // t[7].Add(&x.C0.B2, &x.C1.B0).Square(&t[7]).Sub(&t[7], &t[2]).Sub(&t[7], &t[3]) // 2*x2*x3
        // t[4].Square(&x.C1.B2)
        // t[5].Square(&x.C0.B1)
        // t[8].Add(&x.C1.B2, &x.C0.B1).Square(&t[8]).Sub(&t[8], &t[4]).Sub(&t[8], &t[5]).MulByNonResidue(&t[8]) // 2*x5*x1*u

        // t[0].MulByNonResidue(&t[0]).Add(&t[0], &t[1]) // x4^2*u + x0^2
        // t[2].MulByNonResidue(&t[2]).Add(&t[2], &t[3]) // x2^2*u + x3^2
        // t[4].MulByNonResidue(&t[4]).Add(&t[4], &t[5]) // x5^2*u + x1^2

        // z.C0.B0.Sub(&t[0], &x.C0.B0).Double(&z.C0.B0).Add(&z.C0.B0, &t[0])
        // z.C0.B1.Sub(&t[2], &x.C0.B1).Double(&z.C0.B1).Add(&z.C0.B1, &t[2])
        // z.C0.B2.Sub(&t[4], &x.C0.B2).Double(&z.C0.B2).Add(&z.C0.B2, &t[4])

        // z.C1.B0.Add(&t[8], &x.C1.B0).Double(&z.C1.B0).Add(&z.C1.B0, &t[8])
        // z.C1.B1.Add(&t[6], &x.C1.B1).Double(&z.C1.B1).Add(&z.C1.B1, &t[6])
        // z.C1.B2.Add(&t[7], &x.C1.B2).Double(&z.C1.B2).Add(&z.C1.B2, &t[7])
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

        let res = E12(E6(zc0b0, zc0b1, zc0b2), E6(zc1b0, zc1b1, zc1b2));
        return res;
    }
    func expt{range_check_ptr}(x: E12) -> E12 {
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
