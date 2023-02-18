from src.bn254.fq import fq_bigint3, BigInt3, fq_eq_zero

struct E2 {
    a0: BigInt3,
    a1: BigInt3,
}

namespace e2 {
    func zero{}() -> E2 {
        let zero_bigint3 = BigInt3(0, 0, 0);
        let zero = E2(zero_bigint3, zero_bigint3);
        return zero;
    }
    func one{}() -> E2 {
        let one_bigint3 = BigInt3(1, 0, 0);
        let zero_bigint3 = BigInt3(0, 0, 0);
        let one = E2(one_bigint3, zero_bigint3);
        return one;
    }
    func is_zero{}(x: E2) -> felt {
        let a0_is_zero = fq_eq_zero(x.a0);
        if (a0_is_zero == 0) {
            return 0;
        }

        let a1_is_zero = fq_eq_zero(x.a1);
        return a1_is_zero;
    }
    func conjugate{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;
        let a1 = fq_bigint3.neg(x.a1);
        let res = E2(x.a0, a1);
        return res;
    }
    func add{range_check_ptr}(x: E2, y: E2) -> E2 {
        alloc_locals;
        let a0 = fq_bigint3.add(x.a0, y.a0);
        let a1 = fq_bigint3.add(x.a1, y.a1);
        let res = E2(a0, a1);
        return res;
    }

    func double{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;
        let a0 = fq_bigint3.add(x.a0, x.a0);
        let a1 = fq_bigint3.add(x.a1, x.a1);
        let res = E2(a0, a1);
        return res;
    }
    func neg{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;
        let zero_bigint3 = BigInt3(0, 0, 0);
        let zero = E2(zero_bigint3, zero_bigint3);
        let res = sub(zero, x);
        return res;
    }
    func sub{range_check_ptr}(x: E2, y: E2) -> E2 {
        alloc_locals;
        // %{ print('subbing 2 E2 : \n', ) %}
        let a0 = fq_bigint3.sub(x.a0, y.a0);
        let a1 = fq_bigint3.sub(x.a1, y.a1);
        let res = E2(a0, a1);
        return res;
    }
    func mul{range_check_ptr}(x: E2, y: E2) -> E2 {
        alloc_locals;
        // var a, b, c fp.Element
        // a.Add(&x.A0, &x.A1)
        // b.Add(&y.A0, &y.A1)
        // a.Mul(&a, &b)
        // b.Mul(&x.A0, &y.A0)
        // c.Mul(&x.A1, &y.A1)
        // z.A1.Sub(&a, &b).Sub(&z.A1, &c)
        // z.A0.Sub(&b, &c)
        let a = fq_bigint3.add(x.a0, x.a1);
        let b = fq_bigint3.add(y.a0, y.a1);
        let a = fq_bigint3.mul(a, b);
        let b = fq_bigint3.mul(x.a0, y.a0);
        let c = fq_bigint3.mul(x.a1, y.a1);
        let z_a1 = fq_bigint3.sub(a, b);
        let z_a1 = fq_bigint3.sub(z_a1, c);
        let z_a0 = fq_bigint3.sub(b, c);
        let res = E2(z_a0, z_a1);
        return res;
    }
    func square{range_check_ptr}(x: E2) -> E2 {
        // z.A0 = (x.A0 + x.A1) * (x.A0 - x.A1)
        // z.A1 = 2 * x.A0 * x.A1
        alloc_locals;
        let sum = fq_bigint3.add(x.a0, x.a1);
        let diff = fq_bigint3.sub(x.a0, x.a1);
        let a0 = fq_bigint3.mul(sum, diff);

        let mul = fq_bigint3.mul(x.a0, x.a1);
        let a1 = fq_bigint3.add(mul, mul);
        let res = E2(a0, a1);
        return res;
    }
    func mul2{range_check_ptr}(x: E2, y: E2) -> E2 {
        alloc_locals;

        let t1 = fq_bigint3.mul(x.a0, y.a0);
        let t2 = fq_bigint3.mul(x.a1, y.a1);
        let t3 = fq_bigint3.add(y.a0, y.a1);

        let imag = fq_bigint3.add(x.a1, x.a0);
        let imag = fq_bigint3.mul(imag, t3);
        let imag = fq_bigint3.sub(imag, t1);
        let imag = fq_bigint3.sub(imag, t2);

        let real = fq_bigint3.sub(t1, t2);

        let res: E2 = E2(real, imag);
        return res;
    }

    // MulByNonResidue multiplies a E2 by (9,1)
    func mul_by_non_residue{range_check_ptr}(x: E2) -> E2 {
        // TODO : optimize
        alloc_locals;
        let y = E2(BigInt3(9, 0, 0), BigInt3(1, 0, 0));
        let res = mul(x, y);
        return res;
    }

    func mul_by_non_residue_1_power_1{range_check_ptr}(x: E2) -> E2 {
        // (8376118865763821496583973867626364092589906065868298776909617916018768340080,16469823323077808223889137241176536799009286646108169935659301613961712198316)
        // let b = E2(
        //     BigInt3(8376118865763821496, 5839718637626364092, 5899060658682987769),
        //     BigInt3(1646982332307780822, 3889137299009286646, 1081699356593011699),
        // );
        alloc_locals;
        let b0 = BigInt3(8376118865763821496, 5839718637626364092, 5899060658682987769);
        let b1 = BigInt3(1646982332307780822, 3889137299009286646, 1081699356593011699);

        let a0 = fq_bigint3.mul(x.a0, b0);
        let a1 = fq_bigint3.mul(x.a1, b1);
        let res = E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_1_power_2{range_check_ptr}(x: E2) -> E2 {
        // (21575463638280843010398324269430826099269044274347216827212613867836435027261,10307601595873709700152284273816112264069230130616436755625194854815875713954)
        alloc_locals;
        let b = E2(
            BigInt3(2157546363828084301, 8398324269490826029, 926904427439721682),
            BigInt3(1030760159587370970, 5152284273816112264, 264069230130616436),
        );
        let b0 = BigInt3(2157546363828084301, 8398324269490826029, 926904427439721682);
        let b1 = BigInt3(1030760159587370970, 5152284273816112264, 264069230130616436);

        let a0 = fq_bigint3.mul(x.a0, b0);
        let a1 = fq_bigint3.mul(x.a1, b1);
        let res = E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_1_power_3{range_check_ptr}(x: E2) -> E2 {
        // (2821565182194536844548159561693502659359617185244120367078079554186484126554,3505843767911556378687030309984248845540243509899259641013678093033130930403)
        alloc_locals;

        let b0 = BigInt3(2821565182194536844, 5481595616935026593, 5935961718524412036);
        let b1 = BigInt3(3505843767911556378, 6870303099842488454, 5540243509899259641);

        let a0 = fq_bigint3.mul(x.a0, b0);
        let a1 = fq_bigint3.mul(x.a1, b1);
        let res = E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_1_power_4{range_check_ptr}(x: E2) -> E2 {
        // (2581911344467009335267311115468803099551665605076196740867805258568234346338,19937756971775647987995932169929341994314640652964949448313374472400716661030)
        alloc_locals;

        let b0 = BigInt3(2581911344467009335, 2673111154688030995, 5955166560507619674);
        let b1 = BigInt3(1993775697177564798, 7995932169934319431, 9431464065296494944);

        let a0 = fq_bigint3.mul(x.a0, b0);
        let a1 = fq_bigint3.mul(x.a1, b1);
        let res = E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_1_power_5{range_check_ptr}(x: E2) -> E2 {
        // (685108087231508774477564247770172212460312782337200605669322048753928464687,8447204650696766136447902020341177575205426561248465145919723016860428151883)
        alloc_locals;

        let b0 = BigInt3(685108087231508774, 4775642477701722124, 603669322048753928);
        let b1 = BigInt3(844720465069676613, 6447902020341177575, 2054265612484651459);

        let a0 = fq_bigint3.mul(x.a0, b0);
        let a1 = fq_bigint3.mul(x.a1, b1);
        let res = E2(a0, a1);
        return res;
    }

    // // MulByNonResidue2Power1 set z=x*(9,1)^(2*(p^2-1)/6) and return z
    func mul_by_non_residue_2_power_1{range_check_ptr}(x: E2) -> E2 {
        // 21888242871839275220042445260109153167277707414472061641714758635765020556617
        alloc_locals;

        let b = BigInt3(14595462726357228530, 17349508522658994025, 1017833795229664280);
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        let res = E2(a0, a1);
        return res;
    }

    // // MulByNonResidue2Power2 set z=x*(9,1)^(2*(p^2-1)/6) and return z
    func mul_by_non_residue_2_power_2{range_check_ptr}(x: E2) -> E2 {
        // 21888242871839275220042445260109153167277707414472061641714758635765020556616
        alloc_locals;

        let b = BigInt3(3697675806616062876, 9065277094688085689, 6918009208039626314);
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        let res = E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_2_power_3{range_check_ptr}(x: E2) -> E2 {
        // 21888242871839275222246405745257275088696311157297823662689037894645226208582
        alloc_locals;

        let b = BigInt3(7548957153968385962, 10162512645738643279, 5900175412809962033);
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        let res = E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_2_power_4{range_check_ptr}(x: E2) -> E2 {
        // 2203960485148121921418603742825762020974279258880205651966
        alloc_locals;

        let b = BigInt3(8183898218631979349, 12014359695528440611, 12263358156045030468);
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        let res = E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_2_power_5{range_check_ptr}(x: E2) -> E2 {
        // 2203960485148121921418603742825762020974279258880205651967
        alloc_locals;

        let b = BigInt3(634941064663593387, 1851847049789797332, 6363182743235068435);
        let a0 = fq_bigint3.mul(x.a0, b);
        let a1 = fq_bigint3.mul(x.a1, b);
        let res = E2(a0, a1);
        return res;
    }

    func mul_by_non_residue_3_power_1{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;

        // (11697423496358154304825782922584725312912383441159505038794027105778954184319,303847389135065887422783454877609941456349188919719272345083954437860409601)
        let b = E2(
            a0=BigInt3(11697423496358154304, 8292258472531291238, 11595050387840271057),
            a1=BigInt3(30384738913506588742, 2783454879609445649, 1919719272345071927),
        );
        let res = mul(x, b);
        return res;
    }
    func mul_by_non_residue_3_power_2{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;

        // (3772000881919853776433695186713858239009073593817195771773381919316419345261,2236595495967245188281701248203181795121068902605861227855261137820944008926)
        let b = E2(
            a0=BigInt3(37720008819198537764, 3369518671385823900, 7900358079381719378),
            a1=BigInt3(22365954959672451882, 8170124820318179124, 15121068902605861227),
        );
        let res = mul(x, b);
        return res;
    }
    func mul_by_non_residue_3_power_3{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;

        // (19066677689644738377698246183563772429336693972053703295610958340458742082029,18382399103927718843559375435273026243156067647398564021675359801612095278180)
        let b = E2(
            a0=BigInt3(19066677689644738377, 6982461835637724293, 2043736939720537032),
            a1=BigInt3(18382399103927718843, 5593754352730262352, 14730866764739856402),
        );
        let res = mul(x, b);
        return res;
    }
    func mul_by_non_residue_3_power_4{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;

        // (5324479202449903542726783395506214481928257762400643279780343368557297135718,16208900380737693084919495127334387981393726419856888799917914180988844123039)
        let b = E2(
            a0=BigInt3(53244792024499035427, 2678339550621448192, 19282577624006432797),
            a1=BigInt3(16208900380737693084, 9194951273343879812, 33438798131393726419),
        );
        let res = mul(x, b);
        return res;
    }
    func mul_by_non_residue_3_power_5{range_check_ptr}(x: E2) -> E2 {
        alloc_locals;

        // (8941241848238582420466759817324047081148088512956452953208002715982955420483,10338197737521362862238855242243140895517409139741313354160881284257516364953)
        let b = E2(
            a0=BigInt3(89412418482385824204, 6675981732404708114, 8088512956452953208),
            a1=BigInt3(10338197737521362862, 2388552422431408955, 21740913974131335416),
        );
        let res = mul(x, b);
        return res;
    }
}
