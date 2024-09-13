


const N_LIMBS: number = 4
const BASE: number = 2**96
const STARK: bigint = BigInt("0x800000000000011000000000000000000000000000000000000000000000001");
const BN254_ID: number = 0
const BLS12_381_ID: number = 1
const SECP256K1_ID: number = 2
const SECP256R1_ID: number = 3
const ED25519_ID: number = 4


enum CurveID {
    BN254 = 'BN254',
    BLS12_381 = 'BLS12_381',
    SECP256K1 = 'SECP256K1',
    SECP256R1 = 'SECP256R1',
    ED25519 = 'ED25519',
}


const CURVES: { [key in CurveID]: WeierstrassCurve } = {
    'BN254': {
        cairoZeroNamespaceName: "bn254",
        id: CurveID.BN254,
        p: 0x2523648240000001BA344D80000000086121000000000013A700000000000013,
        n: 0x2523648240000001BA344D8000000007FF9F800000000010A10000000000000D,
        h: 1,
        a: 2,
        b: 3,
        fpGenerator: 1,
        Gx: 1,
        Gy: 2
    },
}


CURVES['BN254']








class G1Point {
    // Represents a point on G1, the group of rational points on an elliptic curve over the base field.

    // Attributes:
    //     x (int): The x-coordinate of the point.
    //     y (int): The y-coordinate of the point.
    //     curve_id (CurveID): The identifier of the elliptic curve.

    x: bigint;
    y: bigint;
    
}


class WeierstrassCurve{
    cairoZeroNamespaceName: string;
    id: number;
    p: number;
    n: number; // order
    h: number // cofactor
    a: number; //  y^2 = x^3 + ax + b
    b: number;
    fpGenerator: number; // A generator of the field of the curve. To verify it, use is_generator function.
    Gx: number; // x-coordinate of the generator point
    Gy: number; // y-coordinate of the generator point







    

}
