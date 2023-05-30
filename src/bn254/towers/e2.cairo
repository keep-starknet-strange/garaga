from src.bn254.fq import fq_bigint3, BigInt3, fq_eq_zero
from starkware.cairo.common.registers import get_fp_and_pc
from src.bn254.curve import N_LIMBS, DEGREE, BASE, P0, P1, P2, NON_RESIDUE_E2_a0, NON_RESIDUE_E2_a1

struct E2 {
    a0: BigInt3*,
    a1: BigInt3*,
}

namespace e2 {
    func zero{}() -> E2* {
        tempvar zero_bigint3: BigInt3* = new BigInt3(0, 0, 0);
        tempvar zero: E2* = new E2(zero_bigint3, zero_bigint3);
        return zero;
    }
    func one{}() -> E2* {
        tempvar one = new E2(new BigInt3(1, 0, 0), new BigInt3(0, 0, 0));
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
    func conjugate{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let a1 = fq_bigint3.neg(x.a1);
        // let res = E2(x.a0, a1);
        tempvar res: E2* = new E2(x.a0, a1);
        return res;
    }

    func inv{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        local inv0: BigInt3;
        local inv1: BigInt3;
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

        let a0 = fq_bigint3.add(x.a0, y.a0);
        let a1 = fq_bigint3.add(x.a1, y.a1);
        // let res = E2(a0, a1);
        local res: E2 = E2(a0, a1);
        return &res;
    }

    func double{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let a0 = fq_bigint3.add(x.a0, x.a0);
        let a1 = fq_bigint3.add(x.a1, x.a1);
        local res: E2 = E2(a0, a1);
        return &res;
    }
    func neg{range_check_ptr}(x: E2*) -> E2* {
        let zero_2 = e2.zero();
        let res = sub(zero_2, x);
        return res;
    }
    func sub{range_check_ptr}(x: E2*, y: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let a0 = fq_bigint3.sub(x.a0, y.a0);
        let a1 = fq_bigint3.sub(x.a1, y.a1);
        local res: E2 = E2(a0, a1);
        return &res;
    }
    func mul_by_element{range_check_ptr}(n: BigInt3*, x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let a0 = fq_bigint3.mul(x.a0, n);
        let a1 = fq_bigint3.mul(x.a1, n);
        local res: E2 = E2(a0, a1);
        return &res;
    }
    func mul{range_check_ptr}(x: E2*, y: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // // Unreduced addition
        // local a0: BigInt3 = BigInt3(x.a0.d0 + x.a1.d0, x.a0.d1 + x.a1.d1, x.a0.d2 + x.a1.d2);
        // local b0: BigInt3 = BigInt3(y.a0.d0 + y.a1.d0, y.a0.d1 + y.a1.d1, y.a0.d2 + y.a1.d2);

        let a0 = fq_bigint3.add(x.a0, x.a1);
        let b0 = fq_bigint3.add(y.a0, y.a1);
        
        let a = fq_bigint3.mul(a0, b0);
        let b = fq_bigint3.mul(x.a0, y.a0);
        let c = fq_bigint3.mul(x.a1, y.a1);
        let z_a1 = fq_bigint3.sub(a, b);
        let z_a1 = fq_bigint3.sub(z_a1, c);
        let z_a0 = fq_bigint3.sub(b, c);

        local res: E2 = E2(z_a0, z_a1);
        return &res;
    }
    func square{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        let sum = fq_bigint3.add(x.a0, x.a1);
        let diff = fq_bigint3.sub(x.a0, x.a1);
        let a0 = fq_bigint3.mul(sum, diff);

        let mul = fq_bigint3.mul(x.a0, x.a1);
        let a1 = fq_bigint3.add(mul, mul);
        local res: E2 = E2(a0, a1);
        return &res;
    }

    // MulByNonResidue multiplies a E2 by (9,1)
    func mul_by_non_residue_slow{range_check_ptr}(x: E2*) -> E2* {
        // TODO : optimize
        alloc_locals;
        tempvar y = new E2(new BigInt3(9, 0, 0), new BigInt3(1, 0, 0));
        return mul(x, y);
    }

    func mul_by_non_residue{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // Unreduced addition
        local a0: BigInt3 = BigInt3(x.a0.d0 + x.a1.d0, x.a0.d1 + x.a1.d1, x.a0.d2 + x.a1.d2);
        let a = fq_bigint3.mul_by_10(&a0);
        let b = fq_bigint3.mul_by_9(x.a0);
        let z_a1 = fq_bigint3.sub(a, b);
        let z_a1 = fq_bigint3.sub(z_a1, x.a1);
        let z_a0 = fq_bigint3.sub(b, x.a1);

        local res: E2 = E2(z_a0, z_a1);
        return &res;
    }

    func mul_by_non_residue_1_power_1{range_check_ptr}(x: E2*) -> E2* {
        // (8376118865763821496583973867626364092589906065868298776909617916018768340080,16469823323077808223889137241176536799009286646108169935659301613961712198316)
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        // let b = E2(
        //     BigInt3(
        //         56977543755103530214089840, 76718894460847708228296868, 1399212181996938186361753
        //     ),
        //     BigInt3(
        //         56554577518550867416146604, 62827697919520388799913531, 2751247659960983775503143
        //     ),
        // );
        local b0: BigInt3 = BigInt3(
            d0=56977543755103530214089840,
            d1=76718894460847708228296868,
            d2=1399212181996938186361753,
        );

        local b1: BigInt3 = BigInt3(
            d0=56554577518550867416146604,
            d1=62827697919520388799913531,
            d2=2751247659960983775503143,
        );

        local b: E2 = E2(&b0, &b1);

        return e2.mul(x, &b);
    }

    func mul_by_non_residue_1_power_2{range_check_ptr}(x: E2*) -> E2* {
        // (21575463638280843010398324269430826099269044274347216827212613867836435027261,10307601595873709700152284273816112264069230130616436755625194854815875713954)
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();
        // let b = E2(
        //     BigInt3(
        //         3867850599270032748795197, 59179910958668734089937675, 3604133613517150379884734
        //     ),
        //     BigInt3(
        //         73280762357897828345301922, 60669965255148047906141229, 1721862111946328055790156
        //     ),
        // );

        tempvar b0: BigInt3* = new BigInt3(
            d0=3867850599270032748795197,
            d1=59179910958668734089937675,
            d2=3604133613517150379884734,
        );
        tempvar b1: BigInt3* = new BigInt3(
            d0=73280762357897828345301922,
            d1=60669965255148047906141229,
            d2=1721862111946328055790156,
        );
        tempvar b: E2* = new E2(b0, b1);

        let res = e2.mul(x, b);

        return res;
    }

    func mul_by_non_residue_1_power_3{range_check_ptr}(x: E2*) -> E2* {
        // (2821565182194536844548159561693502659359617185244120367078079554186484126554,3505843767911556378687030309984248845540243509899259641013678093033130930403)
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // let b = E2(
        //     BigInt3(
        //         11303442774922253301715802, 31898913143253004590495399, 471336240387150903625196
        //     ),
        //     BigInt3(
        //         41537096460112517495238883, 27350505930295183888819774, 585643468873166363848779
        //     ),
        // );

        tempvar b0: BigInt3* = new BigInt3(
            d0=11303442774922253301715802,
            d1=31898913143253004590495399,
            d2=471336240387150903625196,
        );
        tempvar b1: BigInt3* = new BigInt3(
            d0=41537096460112517495238883,
            d1=27350505930295183888819774,
            d2=585643468873166363848779,
        );
        tempvar b: E2* = new E2(b0, b1);

        let res = e2.mul(x, b);
        return res;
    }

    func mul_by_non_residue_1_power_4{range_check_ptr}(x: E2*) -> E2* {
        // (2581911344467009335267311115468803099551665605076196740867805258568234346338,19937756971775647987995932169929341994314640652964949448313374472400716661030)
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // let b = E2(
        //     BigInt3(
        //         25295107361554634830161762, 3463420045217311122513658, 431302595379882330951484
        //     ),
        //     BigInt3(
        //         37209365669994046612537638, 3328902638244012229372015, 3330558327034787022893992
        //     ),
        // );

        tempvar b0: BigInt3* = new BigInt3(
            d0=25295107361554634830161762, d1=3463420045217311122513658, d2=431302595379882330951484
        );
        tempvar b1: BigInt3* = new BigInt3(
            d0=37209365669994046612537638,
            d1=3328902638244012229372015,
            d2=3330558327034787022893992,
        );
        tempvar b: E2* = new E2(b0, b1);

        let res = e2.mul(x, b);
        return res;
    }

    func mul_by_non_residue_1_power_5{range_check_ptr}(x: E2*) -> E2* {
        // (685108087231508774477564247770172212460312782337200605669322048753928464687,8447204650696766136447902020341177575205426561248465145919723016860428151883)
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // let b = E2(
        //     BigInt3(
        //         50906283942319705428551983, 30858614278432769585868118, 114445794884446389703587
        //     ),
        //     BigInt3(
        //         17126845291756250720906315, 11008385818236961457857950, 1411086905581811808217083
        //     ),
        // );

        tempvar b0: BigInt3* = new BigInt3(
            d0=50906283942319705428551983,
            d1=30858614278432769585868118,
            d2=114445794884446389703587,
        );
        tempvar b1: BigInt3* = new BigInt3(
            d0=17126845291756250720906315,
            d1=11008385818236961457857950,
            d2=1411086905581811808217083,
        );
        tempvar b: E2* = new E2(b0, b1);
        let res = e2.mul(x, b);
        return res;
    }

    // // MulByNonResidue2Power1 set z=x*(9,1)^(2*(p^2-1)/6) and return z
    func mul_by_non_residue_2_power_1{range_check_ptr}(x: E2*) -> E2* {
        // 21888242871839275220042445260109153167277707414472061641714758635765020556617
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // let b = BigInt3(
        //     27116970078431962302577993, 47901374225073923994320622, 3656382694611191768409821
        // );

        tempvar b: BigInt3* = new BigInt3(
            d0=27116970078431962302577993,
            d1=47901374225073923994320622,
            d2=3656382694611191768409821,
        );
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        tempvar res: E2* = new E2(a0, a1);
        return res;
    }

    // // MulByNonResidue2Power2 set z=x*(9,1)^(2*(p^2-1)/6) and return z
    func mul_by_non_residue_2_power_2{range_check_ptr}(x: E2*) -> E2* {
        // 21888242871839275220042445260109153167277707414472061641714758635765020556616
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // let b = BigInt3(
        //     27116970078431962302577992, 47901374225073923994320622, 3656382694611191768409821
        // );
        tempvar b: BigInt3* = new BigInt3(
            d0=27116970078431962302577992,
            d1=47901374225073923994320622,
            d2=3656382694611191768409821,
        );
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        tempvar res: E2* = new E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_2_power_3{range_check_ptr}(x: E2*) -> E2* {
        // 21888242871839275222246405745257275088696311157297823662689037894645226208582
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // let b = BigInt3(
        //     60193888514187762220203334, 27625954992973055882053025, 3656382694611191768777988
        // );
        tempvar b: BigInt3* = new BigInt3(
            d0=60193888514187762220203334,
            d1=27625954992973055882053025,
            d2=3656382694611191768777988,
        );
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        tempvar res: E2* = new E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_2_power_4{range_check_ptr}(x: E2*) -> E2* {
        // 2203960485148121921418603742825762020974279258880205651966
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // let b = BigInt3(33076918435755799917625342, 57095833223235399068927667, 368166);
        tempvar b: BigInt3* = new BigInt3(
            d0=33076918435755799917625342, d1=57095833223235399068927667, d2=368166
        );
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        tempvar res: E2* = new E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_2_power_5{range_check_ptr}(x: E2*) -> E2* {
        // 2203960485148121921418603742825762020974279258880205651967
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // let b = BigInt3(33076918435755799917625343, 57095833223235399068927667, 368166);

        tempvar b: BigInt3* = new BigInt3(
            d0=33076918435755799917625343, d1=57095833223235399068927667, d2=368166
        );
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        tempvar res: E2* = new E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_3_power_1{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // (11697423496358154304825782922584725312912383441159505038794027105778954184319,303847389135065887422783454877609941456349188919719272345083954437860409601)

        // tempvar b: E2* = new E2(
        //     new BigInt3(
        //         d0=26380520981114516168550015,
        //         d1=2659922689139687411300089,
        //         d2=1954028795004333741506198,
        //     ),
        //     new BigInt3(
        //         d0=24452053258059047520747777,
        //         d1=71991699407877657584963167,
        //         d2=50757036183365933362366,
        //     ),
        // );
        local b0: BigInt3 = BigInt3(
            d0=26380520981114516168550015,
            d1=2659922689139687411300089,
            d2=1954028795004333741506198,
        );
        local b1: BigInt3 = BigInt3(
            d0=24452053258059047520747777, d1=71991699407877657584963167, d2=50757036183365933362366
        );
        local b: E2 = E2(&b0, &b1);
        let res = mul(x, &b);
        return res;
    }
    func mul_by_non_residue_3_power_2{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // (3772000881919853776433695186713858239009073593817195771773381919316419345261,2236595495967245188281701248203181795121068902605861227855261137820944008926)

        // tempvar b: E2* = new E2(
        //     new BigInt3(
        //         d0=49881535950925854215568237,
        //         d1=60287325917862856540616053,
        //         d2=630104427727001517535217,
        //     ),
        //     new BigInt3(
        //         d0=76342684491321466172049118,
        //         d1=69776222374591092190805603,
        //         d2=373618344523275288878896,
        //     ),
        // );
        local b0: BigInt3 = BigInt3(
            d0=49881535950925854215568237,
            d1=60287325917862856540616053,
            d2=630104427727001517535217,
        );
        local b1: BigInt3 = BigInt3(
            d0=76342684491321466172049118,
            d1=69776222374591092190805603,
            d2=373618344523275288878896,
        );
        local b: E2 = E2(&b0, &b1);

        let res = mul(x, &b);
        return res;
    }
    func mul_by_non_residue_3_power_3{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // (19066677689644738377698246183563772429336693972053703295610958340458742082029,18382399103927718843559375435273026243156067647398564021675359801612095278180)

        // tempvar b: E2* = new E2(
        //     new BigInt3(
        //         d0=48890445739265508918487533,
        //         d1=73098294305056318472752890,
        //         d2=3185046454224040865152791,
        //     ),
        //     new BigInt3(
        //         d0=18656792054075244724964452,
        //         d1=275449062677871993233251,
        //         d2=3070739225738025404929209,
        //     ),
        // );
        local b0: BigInt3 = BigInt3(
            d0=48890445739265508918487533,
            d1=73098294305056318472752890,
            d2=3185046454224040865152791,
        );
        local b1: BigInt3 = BigInt3(
            d0=18656792054075244724964452, d1=275449062677871993233251, d2=3070739225738025404929209
        );
        local b: E2 = E2(&b0, &b1);
        let res = mul(x, &b);
        return res;
    }
    func mul_by_non_residue_3_power_4{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // (5324479202449903542726783395506214481928257762400643279780343368557297135718,16208900380737693084919495127334387981393726419856888799917914180988844123039)

        // tempvar b: E2* = new E2(
        //     new BigInt3(
        //         d0=58537478260502218559713382,
        //         d1=4679104909699726279251414,
        //         d2=889442506995496345770990,
        //     ),
        //     new BigInt3(
        //         d0=76874912822172478088160159,
        //         d1=33529748033140522925695437,
        //         d2=2707661057939728743000847,
        //     ),
        // );

        local b0: BigInt3 = BigInt3(
            d0=58537478260502218559713382, d1=4679104909699726279251414, d2=889442506995496345770990
        );
        local b1: BigInt3 = BigInt3(
            d0=76874912822172478088160159,
            d1=33529748033140522925695437,
            d2=2707661057939728743000847,
        );
        local b: E2 = E2(&b0, &b1);
        let res = mul(x, &b);
        return res;
    }
    func mul_by_non_residue_3_power_5{range_check_ptr}(x: E2*) -> E2* {
        alloc_locals;
        let (__fp__, _) = get_fp_and_pc();

        // (8941241848238582420466759817324047081148088512956452953208002715982955420483,10338197737521362862238855242243140895517409139741313354160881284257516364953)
        local b0: BigInt3 = BigInt3(
            d0=73161962261556368022838083,
            d1=48248071685730948322845273,
            d2=1493614729773225145209193,
        );

        local b1: BigInt3 = BigInt3(
            d0=3022925535795476534142105,
            d1=10430105111501082603530368,
            d2=1726973129925129896852251,
        );
        local b: E2 = E2(&b0, &b1);

        let res = mul(x, &b);
        return res;
    }
    func assert_E2(x: E2*, z: E2*) {
        assert x.a0.d0 = z.a0.d0;
        assert x.a0.d1 = z.a0.d1;
        assert x.a0.d2 = z.a0.d2;
        assert x.a1.d0 = z.a1.d0;
        assert x.a1.d1 = z.a1.d1;
        assert x.a1.d2 = z.a1.d2;
        return ();
    }
}
