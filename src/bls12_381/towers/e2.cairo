from src.bls12_381.fq import (
    fq_bigint4,
    BigInt4,
    fq_eq_zero,
    fq_eq_one,
    UnreducedBigInt7,
    bigint4_mul,
    bigint4_sq,
)
from starkware.cairo.common.registers import get_fp_and_pc
from src.bls12_381.curve import N_LIMBS, DEGREE, BASE, P0, P1, P2, P3
struct E2 {
    a0: BigInt4*,
    a1: BigInt4*,
}

// def mul_e2(x:(int,int), y:(int,int)):
//     a = (x[0] + x[1]) * (y[0] + y[1]) % p
//     b, c  = x[0]*y[0] % p, x[1]*y[1] % p
//     return (b - c) % p, (a - b - c) % p
func mul_e2_unreduced{range_check_ptr}(x: E2*, y: E2*) -> (
    x_unreduced: UnreducedBigInt7, y_unreduced: UnreducedBigInt7
) {
    let x_s: BigInt4 = BigInt4(
        x.a0.d0 + x.a1.d0, x.a0.d1 + x.a1.d1, x.a0.d2 + x.a1.d2, x.a0.d3 + x.a1.d3
    );
    let y_s: BigInt4 = BigInt4(
        y.a0.d0 + y.a1.d0, y.a0.d1 + y.a1.d1, y.a0.d2 + y.a1.d2, y.a0.d3 + y.a1.d3
    );
    let (a) = bigint4_mul(x_s, y_s);
    let (b) = bigint4_mul([x.a0], [y.a0]);
    let (c) = bigint4_mul([x.a1], [y.a1]);

    return (
        UnreducedBigInt7(
            d0=b.d0 - c.d0,
            d1=b.d1 - c.d1,
            d2=b.d2 - c.d2,
            d3=b.d3 - c.d3,
            d4=b.d4 - c.d4,
            d5=b.d5 - c.d5,
            d6=b.d6 - c.d6,
        ),
        UnreducedBigInt7(
            d0=a.d0 - b.d0 - c.d0,
            d1=a.d1 - b.d1 - c.d1,
            d2=a.d2 - b.d2 - c.d2,
            d3=a.d3 - b.d3 - c.d3,
            d4=a.d4 - b.d4 - c.d4,
            d5=a.d5 - b.d5 - c.d5,
            d6=a.d6 - b.d6 - c.d6,
        ),
    );
}

func square_e2_unreduced{range_check_ptr}(x: E2*) -> (
    x_unreduced: UnreducedBigInt7, y_unreduced: UnreducedBigInt7
) {
    let x_s: BigInt4 = BigInt4(
        x.a0.d0 + x.a1.d0, x.a0.d1 + x.a1.d1, x.a0.d2 + x.a1.d2, x.a0.d3 + x.a1.d3
    );
    let (a) = bigint4_sq(x_s);
    let (b) = bigint4_sq([x.a0]);
    let (c) = bigint4_sq([x.a1]);

    return (
        UnreducedBigInt7(
            d0=b.d0 - c.d0,
            d1=b.d1 - c.d1,
            d2=b.d2 - c.d2,
            d3=b.d3 - c.d3,
            d4=b.d4 - c.d4,
            d5=b.d5 - c.d5,
            d6=b.d6 - c.d6,
        ),
        UnreducedBigInt7(
            d0=a.d0 - b.d0 - c.d0,
            d1=a.d1 - b.d1 - c.d1,
            d2=a.d2 - b.d2 - c.d2,
            d3=a.d3 - b.d3 - c.d3,
            d4=a.d4 - b.d4 - c.d4,
            d5=a.d5 - b.d5 - c.d5,
            d6=a.d6 - b.d6 - c.d6,
        ),
    );
}

namespace e2 {
    func zero{}() -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local zero_bigint4: BigInt4 = BigInt4(0, 0, 0, 0);
        local zero: E2 = E2(&zero_bigint4, &zero_bigint4);
        return &zero;
    }
    func one{}() -> E2* {
        tempvar one = new E2(new BigInt4(1, 0, 0, 0), new BigInt4(0, 0, 0, 0));
        return one;
    }
    func is_zero{}(x: E2*) -> felt {
        let a0_is_zero = fq_eq_zero(x.a0);
        if (a0_is_zero == 0) {
            return 0;
        }

        let a1_is_zero = fq_eq_zero(x.a1);
        return a1_is_zero;
    }
    func is_one{}(x: E2*) -> felt {
        let a1_is_zero = fq_eq_zero(x.a1);
        if (a1_is_zero == 0) {
            return 0;
        }

        let a0_is_one = fq_eq_one(x.a0);
        return a0_is_one;
    }
    func conjugate{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let a1 = fq_bigint4.neg(x.a1);
        // let res = E2(x.a0, a1);
        tempvar res: E2* = new E2(x.a0, a1);
        return res;
    }

    func inv{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local inv0: BigInt4;
        local inv1: BigInt4;
        %{
            from starkware.cairo.common.math_utils import as_int    
            assert 1 < ids.N_LIMBS <= 12
            assert ids.DEGREE == ids.N_LIMBS-1
            a0,a1,p=0,0,0

            def split(x, degree=ids.DEGREE, base=ids.BASE):
                coeffs = []
                for n in range(degree, 0, -1):
                    q, r = divmod(x, base ** n)
                    coeffs.append(q)
                    x = r
                coeffs.append(x)
                return coeffs[::-1]

            for i in range(ids.N_LIMBS):
                a0+=as_int(getattr(ids.x.a0, 'd'+str(i)), PRIME) * ids.BASE**i
                a1+=as_int(getattr(ids.x.a1, 'd'+str(i)), PRIME) * ids.BASE**i
                p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

            def inv_e2(a0:int, a1:int):
                t0, t1 = (a0 * a0 % p, a1 * a1 % p)
                t0 = (t0 + t1) % p
                t1 = pow(t0, -1, p)
                return (a0 * t1 % p, -(a1 * t1) % p)

            inverse0, inverse1 = inv_e2(a0, a1)
            inv0, inv1 =split(inverse0), split(inverse1)
            for i in range(ids.N_LIMBS):
                setattr(ids.inv0, 'd'+str(i),  inv0[i])
                setattr(ids.inv1, 'd'+str(i),  inv1[i])
        %}
        local inverse: E2 = E2(&inv0, &inv1);

        let check = e2.mul(x, &inverse);
        let one = e2.one();
        let check = e2.sub(check, one);
        let check_is_zero: felt = e2.is_zero(check);
        assert check_is_zero = 1;
        return &inverse;
    }
    func add{range_check_ptr}(x: E2*, y: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let a0 = fq_bigint4.add(x.a0, y.a0);
        let a1 = fq_bigint4.add(x.a1, y.a1);
        // let res = E2(a0, a1);
        local res: E2 = E2(a0, a1);
        return &res;
    }
    func add_one{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local one: BigInt4 = BigInt4(1, 0, 0, 0);
        let a0 = fq_bigint4.add(x.a0, &one);
        local res: E2 = E2(a0, x.a1);
        return &res;
    }

    func double{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let a0 = fq_bigint4.add(x.a0, x.a0);
        let a1 = fq_bigint4.add(x.a1, x.a1);
        local res: E2 = E2(a0, a1);
        return &res;
    }
    func neg{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let zero_2 = e2.zero();
        let res = sub(zero_2, x);
        return res;
    }
    func sub{range_check_ptr}(x: E2*, y: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let a0 = fq_bigint4.sub(x.a0, y.a0);
        let a1 = fq_bigint4.sub(x.a1, y.a1);
        local res: E2 = E2(a0, a1);
        return &res;
    }
    func mul_by_element{range_check_ptr}(n: BigInt4*, x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let a0 = fq_bigint4.mul(x.a0, n);
        let a1 = fq_bigint4.mul(x.a1, n);
        local res: E2 = E2(a0, a1);
        return &res;
    }
    func mul{range_check_ptr}(x: E2*, y: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // Unreduced addition
        tempvar a = new BigInt4(
            x.a0.d0 + x.a1.d0, x.a0.d1 + x.a1.d1, x.a0.d2 + x.a1.d2, x.a0.d3 + x.a1.d3
        );
        tempvar b = new BigInt4(
            y.a0.d0 + y.a1.d0, y.a0.d1 + y.a1.d1, y.a0.d2 + y.a1.d2, y.a0.d3 + y.a1.d3
        );

        let a = fq_bigint4.mul(a, b);
        let b = fq_bigint4.mul(x.a0, y.a0);
        let c = fq_bigint4.mul(x.a1, y.a1);
        let z_a1 = fq_bigint4.sub(a, b);
        let z_a1 = fq_bigint4.sub(z_a1, c);
        let z_a0 = fq_bigint4.sub(b, c);

        local res: E2 = E2(z_a0, z_a1);
        return &res;
    }

    func square{range_check_ptr}(x: E2*) -> E2* {
        // z.A0 = (x.A0 + x.A1) * (x.A0 - x.A1)
        // z.A1 = 2 * x.A0 * x.A1
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let sum = fq_bigint4.add(x.a0, x.a1);
        let diff = fq_bigint4.sub(x.a0, x.a1);
        let a0 = fq_bigint4.mul(sum, diff);

        let mul = fq_bigint4.mul(x.a0, x.a1);
        let a1 = fq_bigint4.add(mul, mul);
        local res: E2 = E2(a0, a1);
        return &res;
    }

    // MulByNonResidue multiplies a E2 by (1,1)
    func mul_by_non_residue{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        let a = fq_bigint4.add(x.a0, x.a1);
        let a = fq_bigint4.add(a, a);  // mul by 2
        let b = x.a0;  // mul by 1
        let z_a1 = fq_bigint4.sub(a, b);
        let z_a1 = fq_bigint4.sub(z_a1, x.a1);
        let z_a0 = fq_bigint4.sub(b, x.a1);

        local res: E2 = E2(z_a0, z_a1);
        return &res;
    }
    func mul_by_non_residue_1_power_1{range_check_ptr}(x: E2*) -> E2* {
        // 3850754370037169011952147076051364057158807420970682438676050522613628423219637725072182697113062777891589506424760
        // 151655185184498381465642749684540099398075398968325446656007613510403227271200139370504932015952886146304766135027
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b0: BigInt4 = BigInt4(
            d0=30918888157334040571029970872,
            d1=38110497911700059231495300413,
            d2=9956775014100533415029595983,
            d3=7742960891664846859912986292,
        );

        local b1: BigInt4 = BigInt4(
            d0=23961508344847352386299906803,
            d1=73053643719720755424335321793,
            d2=10870206300725050764578763631,
            d3=304942890421345320673339650,
        );

        local b: E2 = E2(&b0, &b1);

        return e2.mul(x, &b);
    }

    func mul_by_non_residue_1_power_2{range_check_ptr}(x: E2*) -> E2* {
        // (0,4002409555221667392624310435006688643935503118305586438271171395842971157480381377015405980053539358417135540939436)
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b0: BigInt4 = BigInt4(d0=0, d1=0, d2=0, d3=0);

        local b1: BigInt4 = BigInt4(
            d0=24538776241284729507437128364,
            d1=42550757554255812588943452139,
            d2=30896359077101218988767419092,
            d3=8047903782086192178990825606,
        );

        local b: E2 = E2(&b0, &b1);

        return e2.mul(x, &b);
    }

    func mul_by_non_residue_1_power_3{range_check_ptr}(x: E2*) -> E2* {
        // (1028732146235106349975324479215795277384839936929757896155643118032610843298655225875571310552543014690878354869257,1028732146235106349975324479215795277384839936929757896155643118032610843298655225875571310552543014690878354869257)
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b0: BigInt4 = BigInt4(
            d0=35566625740316527277988105225,
            d1=37127840730814273605658450223,
            d2=33368165978403992854926148446,
            d3=2068538268313381196677636973,
        );

        local b1: BigInt4 = BigInt4(
            d0=35566625740316527277988105225,
            d1=37127840730814273605658450223,
            d2=33368165978403992854926148446,
            d3=2068538268313381196677636973,
        );

        local b: E2 = E2(&b0, &b1);

        return e2.mul(x, &b);
    }

    func mul_by_non_residue_1_power_4{range_check_ptr}(x: E2*) -> E2* {
        // 4002409555221667392624310435006688643935503118305586438271171395842971157480381377015405980053539358417135540939437
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b: BigInt4 = BigInt4(
            d0=24538776241284729507437128365,
            d1=42550757554255812588943452139,
            d2=30896359077101218988767419092,
            d3=8047903782086192178990825606,
        );
        let a0 = fq_bigint4.mul(x.a0, &b);
        let a1 = fq_bigint4.mul(x.a1, &b);
        local res: E2 = E2(a0, a1);
        return &res;
    }

    func mul_by_non_residue_1_power_5{range_check_ptr}(x: E2*) -> E2* {
        // (877076961050607968509681729531255177986764537961432449499635504522207616027455086505066378536590128544573588734230,3125332594171059424908108096204648978570118281977575435832422631601824034463382777937621250592425535493320683825557)        alloc_locals;
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b0: BigInt4 = BigInt4(
            d0=11605117395469174891688198422,
            d1=43302359525357855774867078766,
            d2=22497959677678942090347384814,
            d3=1763595377892035876004297323,
        );

        local b1: BigInt4 = BigInt4(
            d0=43275279106712218065641679253,
            d1=67861782106062958880963543440,
            d2=77557184151410979682804925136,
            d3=6284308404194156304582028618,
        );

        local b: E2 = E2(&b0, &b1);

        return e2.mul(x, &b);
    }

    func mul_by_non_residue_2_power_1{range_check_ptr}(x: E2*) -> E2* {
        // 793479390729215512621379701633421447060886740281060493010456487427281649075476305620758731620351
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b: BigInt4 = BigInt4(
            d0=30341620260896663449892749311,
            d1=68613384077165002066887170067,
            d2=69158784751988702784384890858,
            d3=1595500335,
        );
        let a0 = fq_bigint4.mul(x.a0, &b);
        let a1 = fq_bigint4.mul(x.a1, &b);
        local res: E2 = E2(a0, a1);
        return &res;
    }

    func mul_by_non_residue_2_power_2{range_check_ptr}(x: E2*) -> E2* {
        // 793479390729215512621379701633421447060886740281060493010456487427281649075476305620758731620350
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b: BigInt4 = BigInt4(
            d0=30341620260896663449892749310,
            d1=68613384077165002066887170067,
            d2=69158784751988702784384890858,
            d3=1595500335,
        );
        let a0 = fq_bigint4.mul(x.a0, &b);
        let a1 = fq_bigint4.mul(x.a1, &b);
        local res: E2 = E2(a0, a1);
        return &res;
    }

    func mul_by_non_residue_2_power_3{range_check_ptr}(x: E2*) -> E2* {
        // 4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559786
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b: BigInt4 = BigInt4(
            d0=54880396502181392957329877674,
            d1=31935979117156477062286671870,
            d2=20826981314825584179608359615,
            d3=8047903782086192180586325942,
        );
        let a0 = fq_bigint4.mul(x.a0, &b);
        let a1 = fq_bigint4.mul(x.a1, &b);
        local res: E2 = E2(a0, a1);
        return &res;
    }

    func mul_by_non_residue_2_power_4{range_check_ptr}(x: E2*) -> E2* {
        // 4002409555221667392624310435006688643935503118305586438271171395842971157480381377015405980053539358417135540939436
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b: BigInt4 = BigInt4(
            d0=24538776241284729507437128364,
            d1=42550757554255812588943452139,
            d2=30896359077101218988767419092,
            d3=8047903782086192178990825606,
        );
        let a0 = fq_bigint4.mul(x.a0, &b);
        let a1 = fq_bigint4.mul(x.a1, &b);
        local res: E2 = E2(a0, a1);
        return &res;
    }

    func mul_by_non_residue_2_power_5{range_check_ptr}(x: E2*) -> E2* {
        // 4002409555221667392624310435006688643935503118305586438271171395842971157480381377015405980053539358417135540939437
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        local b: BigInt4 = BigInt4(
            d0=24538776241284729507437128365,
            d1=42550757554255812588943452139,
            d2=30896359077101218988767419092,
            d3=8047903782086192178990825606,
        );
        let a0 = fq_bigint4.mul(x.a0, &b);
        let a1 = fq_bigint4.mul(x.a1, &b);
        local res: E2 = E2(a0, a1);
        return &res;
    }

    func assert_E2(x: E2*, z: E2*) {
        assert x.a0.d0 = z.a0.d0;
        assert x.a0.d1 = z.a0.d1;
        assert x.a0.d2 = z.a0.d2;
        assert x.a0.d3 = z.a0.d3;
        assert x.a1.d0 = z.a1.d0;
        assert x.a1.d1 = z.a1.d1;
        assert x.a1.d2 = z.a1.d2;
        assert x.a1.d3 = z.a1.d3;
        return ();
    }
}
