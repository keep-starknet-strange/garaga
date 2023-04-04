// Basic definitions for the BLS12-381 elliptic curve.
// The curve is given by the equation
//   y^2 = x^3 + 4
// over the field Z/p for
// const p = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
const P0 = 0x13ffffb9feffffffffaaab;
const P1 = 0x0a83dac3d8907aaffffac5;
const P2 = 0x364774b84f38512bf6730d;
const P3 = 0x1ff9a692c6e9ed90d2eb35;
const P4 = 0x1a0111ea39;

// The following constants represent the size of the curve:
// const n = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
const N0 = 0x3e5bfeffffffff00000001;
const N1 = 0x2020268760154ef6900bff;
const N2 = 0x73eda753299d7d483339d;

// Base for BigInt4
const BASE = 2 ** 96;
