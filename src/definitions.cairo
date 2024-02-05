namespace bls {
    const CURVE_ID = 'bls12_381';
    const P0 = 0xb153ffffb9feffffffffaaab;
    const P1 = 0x6730d2a0f6b0f6241eabfffe;
    const P2 = 0x434bacd764774b84f38512bf;
    const P3 = 0x1a0111ea397fe69a4b1ba7b6;

    // The following constants represent the size of the curve:
    // const n = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
    const N0 = 0x3e5bfeffffffff00000001;
    const N1 = 0x2020268760154ef6900bff;
    const N2 = 0x73eda753299d7d483339d;

    // Non residue constants:
    const NON_RESIDUE_E2_a0 = 1;
    const NON_RESIDUE_E2_a1 = 1;
}

namespace bn {
    const CURVE_ID = 'bn254';
    const P0 = 60193888514187762220203335;
    const P1 = 27625954992973055882053025;
    const P2 = 3656382694611191768777988;

    // The following constants represent the size of the curve:
    // n = n(u) = 36u^4 + 36u^3 + 18u^2 + 6u + 1
    // const n = 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001
    const N0 = 0x39709143e1f593f0000001;
    const N1 = 0x16da06056174a0cfa121e6;
    const N2 = 0x30644e72e131a029b8504;

    // Non residue constants:
    const NON_RESIDUE_E2_a0 = 9;
    const NON_RESIDUE_E2_a1 = 1;
}

// Base for UInt384 / BigInt4
const BASE = 2 ** 96;
const N_LIMBS = 4;

const STARK_MIN_ONE_D2 = 576460752303423505;
