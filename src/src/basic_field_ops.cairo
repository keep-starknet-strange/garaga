use core::circuit::{
    RangeCheck96, AddMod, MulMod, u384, u96, CircuitElement, CircuitInput, circuit_add, circuit_sub,
    circuit_mul, circuit_inverse, EvalCircuitResult, EvalCircuitTrait, CircuitOutputsTrait,
    CircuitModulus, AddInputResultTrait, CircuitInputs, CircuitInputAccumulator,
};
use garaga::core::circuit::AddInputResultTrait2;
use garaga::utils::hashing::hades_permutation;
use core::circuit::CircuitElement as CE;
use core::circuit::CircuitInput as CI;
use garaga::definitions::{E12D, get_BLS12_381_modulus, get_BN254_modulus, get_SECP256K1_modulus};

const POW_2_32_252: felt252 = 0x100000000;
const POW_2_64_252: felt252 = 0x10000000000000000;

const POW_2_256_384: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x10000000000000000, limb3: 0x0 };


pub fn neg_mod_p(a: u384, modulus: CircuitModulus) -> u384 {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let in2 = CircuitElement::<CircuitInput<1>> {};
    let neg = circuit_sub(in1, in2);

    let outputs = (neg,)
        .new_inputs()
        .next_2([0, 0, 0, 0])
        .next_2(a)
        .done_2()
        .eval(modulus)
        .unwrap();

    return outputs.get_output(neg);
}

pub fn is_even_u384(a: u384) -> bool {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let modulus = TryInto::<_, CircuitModulus>::try_into([2, 0, 0, 0]).unwrap();
    let outputs = (in1,).new_inputs().next_2(a).done_2().eval(modulus).unwrap();
    let limb0: felt252 = outputs.get_output(in1).limb0.into();
    match limb0 {
        0 => true,
        _ => false,
    }
}

#[inline(always)]
pub fn compute_yInvXnegOverY_BN254(x: u384, y: u384) -> (u384, u384) {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let in2 = CircuitElement::<CircuitInput<1>> {};
    let in3 = CircuitElement::<CircuitInput<2>> {};
    let yInv = circuit_inverse(in3);
    let xNeg = circuit_sub(in1, in2);
    let xNegOverY = circuit_mul(xNeg, yInv);

    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    let outputs = (yInv, xNegOverY)
        .new_inputs()
        .next_2([0, 0, 0, 0])
        .next_2(x)
        .next_2(y)
        .done_2()
        .eval(modulus)
        .unwrap();

    return (outputs.get_output(yInv), outputs.get_output(xNegOverY));
}

#[inline(always)]
pub fn compute_yInvXnegOverY_BLS12_381(x: u384, y: u384) -> (u384, u384) {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let in2 = CircuitElement::<CircuitInput<1>> {};
    let in3 = CircuitElement::<CircuitInput<2>> {};
    let yInv = circuit_inverse(in3);
    let xNeg = circuit_sub(in1, in2);
    let xNegOverY = circuit_mul(xNeg, yInv);

    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    let outputs = (yInv, xNegOverY)
        .new_inputs()
        .next_2([0, 0, 0, 0])
        .next_2(x)
        .next_2(y)
        .done_2()
        .eval(modulus)
        .unwrap();

    return (outputs.get_output(yInv), outputs.get_output(xNegOverY));
}

// Takes big endian u512 and returns a u384 mod bls12_381
// u512 = low_256 + high_256 * 2^256
// u512 % p = (low_256 + high_256 * 2^256) % p
// = (low_256 % p + high_256 * 2^256 % p) % p
pub fn u512_mod_bls12_381(a_high: [u32; 8], a_low: [u32; 8]) -> u384 {
    let low = CircuitElement::<CircuitInput<0>> {};
    let high = CircuitElement::<CircuitInput<1>> {};
    let shift = CircuitElement::<CircuitInput<2>> {};
    let high_shifted = circuit_mul(high, shift);
    let res = circuit_add(low, high_shifted);

    let modulus = TryInto::<
        _, CircuitModulus,
    >::try_into(
        [
            0xb153ffffb9feffffffffaaab, 0x6730d2a0f6b0f6241eabfffe, 0x434bacd764774b84f38512bf,
            0x1a0111ea397fe69a4b1ba7b6,
        ],
    )
        .unwrap(); // BLS12_381 prime field modulus

    let [al_0, al_1, al_2, al_3, al_4, al_5, al_6, al_7] = a_low;
    let ll0: felt252 = al_7.into() + al_6.into() * POW_2_32_252 + al_5.into() * POW_2_64_252;
    let ll1: felt252 = al_4.into() + al_3.into() * POW_2_32_252 + al_2.into() * POW_2_64_252;
    let ll2: felt252 = al_1.into() + al_0.into() * POW_2_32_252;

    let low_256 = u384 {
        limb0: ll0.try_into().unwrap(),
        limb1: ll1.try_into().unwrap(),
        limb2: ll2.try_into().unwrap(),
        limb3: 0,
    };

    let [ah_0, ah_1, ah_2, ah_3, ah_4, ah_5, ah_6, ah_7] = a_high;
    let hl0: felt252 = ah_7.into() + ah_6.into() * POW_2_32_252 + ah_5.into() * POW_2_64_252;
    let hl1: felt252 = ah_4.into() + ah_3.into() * POW_2_32_252 + ah_2.into() * POW_2_64_252;
    let hl2: felt252 = ah_1.into() + ah_0.into() * POW_2_32_252;
    let high_256 = u384 {
        limb0: hl0.try_into().unwrap(),
        limb1: hl1.try_into().unwrap(),
        limb2: hl2.try_into().unwrap(),
        limb3: 0,
    };

    let outputs = (res,)
        .new_inputs()
        .next_2(low_256)
        .next_2(high_256)
        .next_2(POW_2_256_384)
        .done_2()
        .eval(modulus)
        .unwrap();

    return outputs.get_output(res);
}

pub fn add_mod_p(a: u384, b: u384, modulus: CircuitModulus) -> u384 {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let in2 = CircuitElement::<CircuitInput<1>> {};
    let add = circuit_add(in1, in2);

    let outputs = (add,).new_inputs().next_2(a).next_2(b).done_2().eval(modulus).unwrap();

    return outputs.get_output(add);
}

pub fn sub_mod_p(a: u384, b: u384, modulus: CircuitModulus) -> u384 {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let in2 = CircuitElement::<CircuitInput<1>> {};
    let sub = circuit_sub(in1, in2);

    let outputs = (sub,).new_inputs().next_2(a).next_2(b).done_2().eval(modulus).unwrap();

    return outputs.get_output(sub);
}

pub fn mul_mod_p(a: u384, b: u384, modulus: CircuitModulus) -> u384 {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let in2 = CircuitElement::<CircuitInput<1>> {};
    let mul = circuit_mul(in1, in2);

    let outputs = (mul,).new_inputs().next_2(a).next_2(b).done_2().eval(modulus).unwrap();

    return outputs.get_output(mul);
}


pub fn batch_3_mod_p(x: u384, y: u384, z: u384, c0: u384, modulus: CircuitModulus) -> u384 {
    let _x = CircuitElement::<CircuitInput<0>> {};
    let _y = CircuitElement::<CircuitInput<1>> {};
    let _z = CircuitElement::<CircuitInput<2>> {};
    let _c0 = CircuitElement::<CircuitInput<3>> {};
    let _c1 = circuit_mul(_c0, _c0);
    let _c2 = circuit_mul(_c1, _c0);
    let _mul1 = circuit_mul(_x, _c0);
    let _mul2 = circuit_mul(_y, _c1);
    let _mul3 = circuit_mul(_z, _c2);
    let res = circuit_add(circuit_add(_mul1, _mul2), _mul3);

    let outputs = (res,)
        .new_inputs()
        .next_2(x)
        .next_2(y)
        .next_2(z)
        .next_2(c0)
        .done_2()
        .eval(modulus)
        .unwrap();

    return outputs.get_output(res);
}


fn inv_mod_p(a: u384, modulus: CircuitModulus) -> u384 {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let inv = circuit_inverse(in1);

    let outputs = (inv,).new_inputs().next_2(a).done_2().eval(modulus).unwrap();

    return outputs.get_output(inv);
}
// fn run_BN254_EVAL_AND_HASH_E12D_circuit(
//     f: E12D, z: u384, s0: felt252, s1: felt252, s2: felt252
// ) -> (u384, felt252, felt252, felt252) {
//     // INPUT stack
//     let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
//     let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
//     let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
//     let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
//     let in12 = CE::<CI<12>> {};
//     let t0 = circuit_mul(in12, in12); // Compute z^2
//     let t1 = circuit_mul(t0, in12); // Compute z^3
//     let t2 = circuit_mul(t1, in12); // Compute z^4
//     let t3 = circuit_mul(t2, in12); // Compute z^5
//     let t4 = circuit_mul(t3, in12); // Compute z^6
//     let t5 = circuit_mul(t4, in12); // Compute z^7
//     let t6 = circuit_mul(t5, in12); // Compute z^8
//     let t7 = circuit_mul(t6, in12); // Compute z^9
//     let t8 = circuit_mul(t7, in12); // Compute z^10
//     let t9 = circuit_mul(t8, in12); // Compute z^11
//     let t10 = circuit_mul(in1, in12); // Eval X step coeff_1 * z^1
//     let t11 = circuit_add(in0, t10); // Eval X step + (coeff_1 * z^1)
//     let t12 = circuit_mul(in2, t0); // Eval X step coeff_2 * z^2
//     let t13 = circuit_add(t11, t12); // Eval X step + (coeff_2 * z^2)
//     let t14 = circuit_mul(in3, t1); // Eval X step coeff_3 * z^3
//     let t15 = circuit_add(t13, t14); // Eval X step + (coeff_3 * z^3)
//     let t16 = circuit_mul(in4, t2); // Eval X step coeff_4 * z^4
//     let t17 = circuit_add(t15, t16); // Eval X step + (coeff_4 * z^4)
//     let t18 = circuit_mul(in5, t3); // Eval X step coeff_5 * z^5
//     let t19 = circuit_add(t17, t18); // Eval X step + (coeff_5 * z^5)
//     let t20 = circuit_mul(in6, t4); // Eval X step coeff_6 * z^6
//     let t21 = circuit_add(t19, t20); // Eval X step + (coeff_6 * z^6)
//     let t22 = circuit_mul(in7, t5); // Eval X step coeff_7 * z^7
//     let t23 = circuit_add(t21, t22); // Eval X step + (coeff_7 * z^7)
//     let t24 = circuit_mul(in8, t6); // Eval X step coeff_8 * z^8
//     let t25 = circuit_add(t23, t24); // Eval X step + (coeff_8 * z^8)
//     let t26 = circuit_mul(in9, t7); // Eval X step coeff_9 * z^9
//     let t27 = circuit_add(t25, t26); // Eval X step + (coeff_9 * z^9)
//     let t28 = circuit_mul(in10, t8); // Eval X step coeff_10 * z^10
//     let t29 = circuit_add(t27, t28); // Eval X step + (coeff_10 * z^10)
//     let t30 = circuit_mul(in11, t9); // Eval X step coeff_11 * z^11
//     let t31 = circuit_add(t29, t30); // Eval X step + (coeff_11 * z^11)

//     let modulus = TryInto::<
//         _, CircuitModulus
//     >::try_into([0x6871ca8d3c208c16d87cfd47, 0xb85045b68181585d97816a91, 0x30644e72e131a029,
//     0x0])
//         .unwrap(); // BN254 prime field modulus

//     let mut circuit_inputs = (t31,).new_inputs();
//     // Prefill constants:

//     // Fill inputs:
//     circuit_inputs = circuit_inputs.next_2(f.w0); // in0
//     circuit_inputs = circuit_inputs.next_2(f.w1); // in1
//     circuit_inputs = circuit_inputs.next_2(f.w2); // in2
//     circuit_inputs = circuit_inputs.next_2(f.w3); // in3
//     circuit_inputs = circuit_inputs.next_2(f.w4); // in4
//     circuit_inputs = circuit_inputs.next_2(f.w5); // in5
//     circuit_inputs = circuit_inputs.next_2(f.w6); // in6
//     circuit_inputs = circuit_inputs.next_2(f.w7); // in7
//     circuit_inputs = circuit_inputs.next_2(f.w8); // in8
//     circuit_inputs = circuit_inputs.next_2(f.w9); // in9
//     circuit_inputs = circuit_inputs.next_2(f.w10); // in10
//     circuit_inputs = circuit_inputs.next_2(f.w11); // in11
//     circuit_inputs = circuit_inputs.next_2(z); // in12

//     // Hash F:
//     let base: felt252 = 34;
//     let in_1 = s0 + f.w0.limb0.into() + base * f.w0.limb1.into();
//     let in_2 = s1 + f.w0.limb2.into() + base * f.w0.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s2);
//     let in_1 = _s0 + f.w1.limb0.into() + base * f.w1.limb1.into();
//     let in_2 = _s1 + f.w1.limb2.into() + base * f.w1.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w2.limb0.into() + base * f.w2.limb1.into();
//     let in_2 = _s1 + f.w2.limb2.into() + base * f.w2.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w3.limb0.into() + base * f.w3.limb1.into();
//     let in_2 = _s1 + f.w3.limb2.into() + base * f.w3.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w4.limb0.into() + base * f.w4.limb1.into();
//     let in_2 = _s1 + f.w4.limb2.into() + base * f.w4.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w5.limb0.into() + base * f.w5.limb1.into();
//     let in_2 = _s1 + f.w5.limb2.into() + base * f.w5.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w6.limb0.into() + base * f.w6.limb1.into();
//     let in_2 = _s1 + f.w6.limb2.into() + base * f.w6.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w7.limb0.into() + base * f.w7.limb1.into();
//     let in_2 = _s1 + f.w7.limb2.into() + base * f.w7.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w8.limb0.into() + base * f.w8.limb1.into();
//     let in_2 = _s1 + f.w8.limb2.into() + base * f.w8.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w9.limb0.into() + base * f.w9.limb1.into();
//     let in_2 = _s1 + f.w9.limb2.into() + base * f.w9.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w10.limb0.into() + base * f.w10.limb1.into();
//     let in_2 = _s1 + f.w10.limb2.into() + base * f.w10.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
//     let in_1 = _s0 + f.w11.limb0.into() + base * f.w11.limb1.into();
//     let in_2 = _s1 + f.w11.limb2.into() + base * f.w11.limb3.into();
//     let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);

//     let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
//     let f_of_z: u384 = outputs.get_output(t31);
//     return (f_of_z, _s0, _s1, _s2);
// }


