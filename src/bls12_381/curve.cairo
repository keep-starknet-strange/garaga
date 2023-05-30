// Basic definitions for the BLS12-381 elliptic curve.
// The curve is given by the equation
//   y^2 = x^3 + 4
// over the field Z/p for
// const p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
const CURVE = 'bls12_381';
const P0 = 0xb153ffffb9feffffffffaaab;
const P1 = 0x6730d2a0f6b0f6241eabfffe;
const P2 = 0x434bacd764774b84f38512bf;
const P3 = 0x1a0111ea397fe69a4b1ba7b6;

// The following constants represent the size of the curve:
// const n = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
const N0 = 0x3e5bfeffffffff00000001;
const N1 = 0x2020268760154ef6900bff;
const N2 = 0x73eda753299d7d483339d;

// Base for BigInt4
const BASE = 2 ** 96;
const DEGREE = 3;
const N_LIMBS = 4;
const N_LIMBS_UNREDUCED = 7;

// Non residue constants:
const NON_RESIDUE_E2_a0 = 1;
const NON_RESIDUE_E2_a1 = 1;
