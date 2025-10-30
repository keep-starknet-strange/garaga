use core::circuit::{
    CircuitElement, CircuitElement as CE, CircuitInput, CircuitInput as CI, CircuitInputs,
    CircuitModulus, CircuitOutputsTrait, EvalCircuitTrait, circuit_add, circuit_inverse,
    circuit_mul, circuit_sub, u384,
};
use core::num::traits::Zero;
use corelib_imports::bounded_int::upcast;
use garaga::core::circuit::{AddInputResultTrait2, u288IntoCircuitInputValue};
use garaga::definitions::{E12D, get_BLS12_381_modulus, get_BN254_modulus, u288};
use garaga::utils::hashing::{PoseidonState, hades_permutation, hash_quadruple_u288};

const POW_2_32_252: felt252 = 0x100000000;
const POW_2_64_252: felt252 = 0x10000000000000000;

const POW_2_256_384: u384 = u384 { limb0: 0x0, limb1: 0x0, limb2: 0x10000000000000000, limb3: 0x0 };

// Reduces a u384 given a circuit modulus by computing (a + 0) mod p.
// Circuits outputs are reduced mod p.
pub fn reduce_mod_p(a: u384, modulus: CircuitModulus) -> u384 {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let in2 = CircuitElement::<CircuitInput<1>> {};
    let reduce = circuit_add(in1, in2);

    let outputs = (reduce,)
        .new_inputs()
        .next_2(a)
        .next_2([0, 0, 0, 0])
        .done_2()
        .eval(modulus)
        .unwrap();

    return outputs.get_output(reduce);
}

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

// Returns true if a == -b mod p (a + b = 0 mod p)
pub fn is_opposite_mod_p(a: u384, b: u384, modulus: CircuitModulus) -> bool {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let in2 = CircuitElement::<CircuitInput<1>> {};
    let sum = circuit_add(in1, in2);
    let outputs = (sum,).new_inputs().next_2(a).next_2(b).done_2().eval(modulus).unwrap();

    return outputs.get_output(sum).is_zero();
}

// Returns true if a == 0 mod p (p must be odd prime)
pub fn is_zero_mod_p(a: u384, modulus: CircuitModulus) -> bool {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let sum = circuit_add(in1, in1);
    let outputs = (sum,).new_inputs().next_2(a).done_2().eval(modulus).unwrap();
    return outputs.get_output(sum).is_zero();
}

pub fn is_even_u384(a: u384) -> bool {
    let limb0_u128: u128 = upcast(a.limb0);
    limb0_u128 % 2 == 0
}


pub fn u32_8_to_u384(a: [u32; 8]) -> u384 {
    let [a_0, a_1, a_2, a_3, a_4, a_5, a_6, a_7] = a;
    let l0: felt252 = a_7.into() + a_6.into() * POW_2_32_252 + a_5.into() * POW_2_64_252;
    let l1: felt252 = a_4.into() + a_3.into() * POW_2_32_252 + a_2.into() * POW_2_64_252;
    let l2: felt252 = a_1.into() + a_0.into() * POW_2_32_252;
    u384 {
        limb0: l0.try_into().unwrap(),
        limb1: l1.try_into().unwrap(),
        limb2: l2.try_into().unwrap(),
        limb3: 0,
    }
}

// Takes big endian u512 and returns a u384 mod modulus
// u512 = low_256 + high_256 * 2^256
// u512 % p = (low_256 + high_256 * 2^256) % p
// = (low_256 % p + high_256 * 2^256 % p) % p
// CAUTION : a_high and a_low are expected to be < 2^256. No check is performed.
pub fn u512_mod_p(high_256: u384, low_256: u384, modulus: CircuitModulus) -> u384 {
    let low = CircuitElement::<CircuitInput<0>> {};
    let high = CircuitElement::<CircuitInput<1>> {};
    let shift = CircuitElement::<CircuitInput<2>> {};
    let high_shifted = circuit_mul(high, shift);
    let res = circuit_add(low, high_shifted);

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

#[inline(always)]
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


pub fn inv_mod_p(a: u384, modulus: CircuitModulus) -> u384 {
    let in1 = CircuitElement::<CircuitInput<0>> {};
    let inv = circuit_inverse(in1);

    let outputs = (inv,).new_inputs().next_2(a).done_2().eval(modulus).unwrap();

    return outputs.get_output(inv);
}


#[inline(always)]
pub fn eval_and_hash_E12D_u288_transcript(
    transcript: Span<E12D<u288>>, mut s: PoseidonState, z: u384,
) -> (PoseidonState, Array<u384>) {
    let base: felt252 = 79228162514264337593543950336; // 2**96
    let mut evals: Array<u384> = array![];
    let modulus = get_BN254_modulus(); // BN254 prime field modulus

    for elmt in transcript {
        let elmt = *elmt;
        let _s = hash_quadruple_u288(elmt.w0, elmt.w1, elmt.w2, elmt.w3, base, s);
        let _s = hash_quadruple_u288(elmt.w4, elmt.w5, elmt.w6, elmt.w7, base, _s);
        let _s = hash_quadruple_u288(elmt.w8, elmt.w9, elmt.w10, elmt.w11, base, _s);
        s = _s;

        let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
        let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
        let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
        let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
        let in12 = CE::<CI<12>> {};
        let t0 = circuit_mul(in11, in12); // Eval X Horner step: multiply by z
        let t1 = circuit_add(in10, t0); // Eval X Horner step: add coefficient_10
        let t2 = circuit_mul(t1, in12); // Eval X Horner step: multiply by z
        let t3 = circuit_add(in9, t2); // Eval X Horner step: add coefficient_9
        let t4 = circuit_mul(t3, in12); // Eval X Horner step: multiply by z
        let t5 = circuit_add(in8, t4); // Eval X Horner step: add coefficient_8
        let t6 = circuit_mul(t5, in12); // Eval X Horner step: multiply by z
        let t7 = circuit_add(in7, t6); // Eval X Horner step: add coefficient_7
        let t8 = circuit_mul(t7, in12); // Eval X Horner step: multiply by z
        let t9 = circuit_add(in6, t8); // Eval X Horner step: add coefficient_6
        let t10 = circuit_mul(t9, in12); // Eval X Horner step: multiply by z
        let t11 = circuit_add(in5, t10); // Eval X Horner step: add coefficient_5
        let t12 = circuit_mul(t11, in12); // Eval X Horner step: multiply by z
        let t13 = circuit_add(in4, t12); // Eval X Horner step: add coefficient_4
        let t14 = circuit_mul(t13, in12); // Eval X Horner step: multiply by z
        let t15 = circuit_add(in3, t14); // Eval X Horner step: add coefficient_3
        let t16 = circuit_mul(t15, in12); // Eval X Horner step: multiply by z
        let t17 = circuit_add(in2, t16); // Eval X Horner step: add coefficient_2
        let t18 = circuit_mul(t17, in12); // Eval X Horner step: multiply by z
        let t19 = circuit_add(in1, t18); // Eval X Horner step: add coefficient_1
        let t20 = circuit_mul(t19, in12); // Eval X Horner step: multiply by z
        let t21 = circuit_add(in0, t20); // Eval X Horner step: add coefficient_0

        let mut circuit_inputs = (t21,).new_inputs();
        // Prefill constants:

        // Fill inputs:
        circuit_inputs = circuit_inputs.next_2(elmt.w0); // in0
        circuit_inputs = circuit_inputs.next_2(elmt.w1); // in1
        circuit_inputs = circuit_inputs.next_2(elmt.w2); // in2
        circuit_inputs = circuit_inputs.next_2(elmt.w3); // in3
        circuit_inputs = circuit_inputs.next_2(elmt.w4); // in4
        circuit_inputs = circuit_inputs.next_2(elmt.w5); // in5
        circuit_inputs = circuit_inputs.next_2(elmt.w6); // in6
        circuit_inputs = circuit_inputs.next_2(elmt.w7); // in7
        circuit_inputs = circuit_inputs.next_2(elmt.w8); // in8
        circuit_inputs = circuit_inputs.next_2(elmt.w9); // in9
        circuit_inputs = circuit_inputs.next_2(elmt.w10); // in10
        circuit_inputs = circuit_inputs.next_2(elmt.w11); // in11
        circuit_inputs = circuit_inputs.next_2(z); // in12

        let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
        let f_of_z: u384 = outputs.get_output(t21);
        evals.append(f_of_z);
    }
    return (s, evals);
}


#[inline(always)]
pub fn eval_and_hash_E12D_u384_transcript(
    transcript: Span<E12D<u384>>, mut s: PoseidonState, z: u384,
) -> (PoseidonState, Array<u384>) {
    let base: felt252 = 79228162514264337593543950336; // 2**96
    let mut evals: Array<u384> = array![];
    let modulus = get_BLS12_381_modulus(); // BLS12_381 prime field modulus

    for elmt in transcript {
        let elmt = *elmt;
        let in_1 = s.s0 + elmt.w0.limb0.into() + base * elmt.w0.limb1.into();
        let in_2 = s.s1 + elmt.w0.limb2.into() + base * elmt.w0.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, s.s2);
        let in_1 = _s0 + elmt.w1.limb0.into() + base * elmt.w1.limb1.into();
        let in_2 = _s1 + elmt.w1.limb2.into() + base * elmt.w1.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w2.limb0.into() + base * elmt.w2.limb1.into();
        let in_2 = _s1 + elmt.w2.limb2.into() + base * elmt.w2.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w3.limb0.into() + base * elmt.w3.limb1.into();
        let in_2 = _s1 + elmt.w3.limb2.into() + base * elmt.w3.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w4.limb0.into() + base * elmt.w4.limb1.into();
        let in_2 = _s1 + elmt.w4.limb2.into() + base * elmt.w4.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w5.limb0.into() + base * elmt.w5.limb1.into();
        let in_2 = _s1 + elmt.w5.limb2.into() + base * elmt.w5.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w6.limb0.into() + base * elmt.w6.limb1.into();
        let in_2 = _s1 + elmt.w6.limb2.into() + base * elmt.w6.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w7.limb0.into() + base * elmt.w7.limb1.into();
        let in_2 = _s1 + elmt.w7.limb2.into() + base * elmt.w7.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w8.limb0.into() + base * elmt.w8.limb1.into();
        let in_2 = _s1 + elmt.w8.limb2.into() + base * elmt.w8.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w9.limb0.into() + base * elmt.w9.limb1.into();
        let in_2 = _s1 + elmt.w9.limb2.into() + base * elmt.w9.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w10.limb0.into() + base * elmt.w10.limb1.into();
        let in_2 = _s1 + elmt.w10.limb2.into() + base * elmt.w10.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);
        let in_1 = _s0 + elmt.w11.limb0.into() + base * elmt.w11.limb1.into();
        let in_2 = _s1 + elmt.w11.limb2.into() + base * elmt.w11.limb3.into();
        let (_s0, _s1, _s2) = hades_permutation(in_1, in_2, _s2);

        s = PoseidonState { s0: _s0, s1: _s1, s2: _s2 };

        let (in0, in1, in2) = (CE::<CI<0>> {}, CE::<CI<1>> {}, CE::<CI<2>> {});
        let (in3, in4, in5) = (CE::<CI<3>> {}, CE::<CI<4>> {}, CE::<CI<5>> {});
        let (in6, in7, in8) = (CE::<CI<6>> {}, CE::<CI<7>> {}, CE::<CI<8>> {});
        let (in9, in10, in11) = (CE::<CI<9>> {}, CE::<CI<10>> {}, CE::<CI<11>> {});
        let in12 = CE::<CI<12>> {};
        let t0 = circuit_mul(in11, in12); // Eval X Horner step: multiply by z
        let t1 = circuit_add(in10, t0); // Eval X Horner step: add coefficient_10
        let t2 = circuit_mul(t1, in12); // Eval X Horner step: multiply by z
        let t3 = circuit_add(in9, t2); // Eval X Horner step: add coefficient_9
        let t4 = circuit_mul(t3, in12); // Eval X Horner step: multiply by z
        let t5 = circuit_add(in8, t4); // Eval X Horner step: add coefficient_8
        let t6 = circuit_mul(t5, in12); // Eval X Horner step: multiply by z
        let t7 = circuit_add(in7, t6); // Eval X Horner step: add coefficient_7
        let t8 = circuit_mul(t7, in12); // Eval X Horner step: multiply by z
        let t9 = circuit_add(in6, t8); // Eval X Horner step: add coefficient_6
        let t10 = circuit_mul(t9, in12); // Eval X Horner step: multiply by z
        let t11 = circuit_add(in5, t10); // Eval X Horner step: add coefficient_5
        let t12 = circuit_mul(t11, in12); // Eval X Horner step: multiply by z
        let t13 = circuit_add(in4, t12); // Eval X Horner step: add coefficient_4
        let t14 = circuit_mul(t13, in12); // Eval X Horner step: multiply by z
        let t15 = circuit_add(in3, t14); // Eval X Horner step: add coefficient_3
        let t16 = circuit_mul(t15, in12); // Eval X Horner step: multiply by z
        let t17 = circuit_add(in2, t16); // Eval X Horner step: add coefficient_2
        let t18 = circuit_mul(t17, in12); // Eval X Horner step: multiply by z
        let t19 = circuit_add(in1, t18); // Eval X Horner step: add coefficient_1
        let t20 = circuit_mul(t19, in12); // Eval X Horner step: multiply by z
        let t21 = circuit_add(in0, t20); // Eval X Horner step: add coefficient_0

        let mut circuit_inputs = (t21,).new_inputs();
        // Prefill constants:

        // Fill inputs:
        circuit_inputs = circuit_inputs.next_2(elmt.w0); // in0
        circuit_inputs = circuit_inputs.next_2(elmt.w1); // in1
        circuit_inputs = circuit_inputs.next_2(elmt.w2); // in2
        circuit_inputs = circuit_inputs.next_2(elmt.w3); // in3
        circuit_inputs = circuit_inputs.next_2(elmt.w4); // in4
        circuit_inputs = circuit_inputs.next_2(elmt.w5); // in5
        circuit_inputs = circuit_inputs.next_2(elmt.w6); // in6
        circuit_inputs = circuit_inputs.next_2(elmt.w7); // in7
        circuit_inputs = circuit_inputs.next_2(elmt.w8); // in8
        circuit_inputs = circuit_inputs.next_2(elmt.w9); // in9
        circuit_inputs = circuit_inputs.next_2(elmt.w10); // in10
        circuit_inputs = circuit_inputs.next_2(elmt.w11); // in11
        circuit_inputs = circuit_inputs.next_2(z); // in12

        let outputs = circuit_inputs.done_2().eval(modulus).unwrap();
        let f_of_z: u384 = outputs.get_output(t21);
        evals.append(f_of_z);
    }
    return (s, evals);
}
