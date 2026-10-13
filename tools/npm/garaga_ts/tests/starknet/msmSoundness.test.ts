import * as garaga from "../../src/node/index";
import { CURVES, CurveId } from "../../src/node/definitions";

const scalar = 0x123456789abcdef123456789abcdef123456789abcdef123456789abcdef1234n;
const signBit = 1n << 128n;
const limbMask = (1n << 96n) - 1n;
const glvCases = [
  {
    curveId: CurveId.BN254,
    order: 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001n,
    eigenvalue: 0xb3c4d79d41a917585bfc41088d8daaa78b17ea66b99c90ddn,
    hintLength: 12,
  },
  {
    curveId: CurveId.BLS12_381,
    order: CURVES[CurveId.BLS12_381].n,
    eigenvalue: 0xac45a4010001a40200000000ffffffffn,
    hintLength: 28,
  },
  {
    curveId: CurveId.SECP256K1,
    order: CURVES[CurveId.SECP256K1].n,
    eigenvalue: 0x5363ad4cc05c30e0a5261c028812645a122e22ea20816678df02967c1b23bd72n,
    hintLength: 12,
  },
];

function generator(curveId: CurveId): garaga.G1Point {
  const curve = CURVES[curveId];
  return curveId === CurveId.ED25519
    ? garaga.toWeirstrass(curve.Gx, curve.Gy)
    : [curve.Gx, curve.Gy];
}

function pointFromHint(hint: bigint[]): garaga.G1Point {
  const coordinate = (offset: number): bigint => hint
    .slice(offset, offset + 4)
    .reduce((value, limb, index) => value + (limb << BigInt(96 * index)), 0n);
  return [coordinate(0), coordinate(4)];
}

describe("MSM GLV and cofactor hint soundness", () => {
  beforeAll(async () => { await garaga.init(); });

  test.each(glvCases)("bounds the GLV reconstruction for curve $curveId", ({ curveId, order, eigenvalue, hintLength }) => {
    const hint = garaga.msmCalldataBuilder([generator(curveId)], [scalar], curveId, { includePointsAndScalars: false });
    expect(hint).toHaveLength(hintLength);
    const coefficients = hint.slice(8, 12).map((encoded) => {
      expect(encoded >> 128n).toBeLessThanOrEqual(1n);
      const magnitude = encoded % signBit;
      expect(magnitude).toBeLessThan(1n << 65n);
      return encoded >= signBit ? -magnitude : magnitude;
    }) as [bigint, bigint, bigint, bigint];
    const [u1, u2, v1, v2] = coefficients;
    const denominator = (v1 + eigenvalue * v2) % order;
    expect(denominator).not.toBe(0n);
    expect((u1 + eigenvalue * u2 + scalar * denominator) % order).toBe(0n);
  });

  test.each([
    { curveId: CurveId.BLS12_381, hintLength: 28 },
    { curveId: CurveId.ED25519, hintLength: 18 },
  ])("retains cofactor records at scalar edges for curve $curveId", ({ curveId, hintLength }) => {
    const curve = CURVES[curveId];
    const point = generator(curveId);
    for (const value of [0n, 1n, curve.n - 1n]) {
      const hint = garaga.msmCalldataBuilder([point], [value], curveId, { includePointsAndScalars: false });
      expect(hint).toHaveLength(hintLength);
      expect(hint.slice(0, 8).every((limb) => limb >= 0n && limb <= limbMask)).toBe(true);
      const expected: garaga.G1Point = value === 0n ? [0n, 0n]
        : value === 1n ? point : [point[0], curve.p - point[1]];
      expect(pointFromHint(hint)).toEqual(expected);
    }
  });

  test.each([0n, 1n, 2n])("rejects BLS torsion inputs for scalar %s", (value) => {
    expect(() => garaga.msmCalldataBuilder([[0n, 2n]], [value], CurveId.BLS12_381)).toThrow("prime-order subgroup");
  });

  test.each([CurveId.BN254, CurveId.BLS12_381, CurveId.SECP256K1, CurveId.SECP256R1, CurveId.ED25519])("rejects noncanonical coordinates for curve %s", (curveId) => {
    const point = generator(curveId);
    expect(() => garaga.msmCalldataBuilder([[point[0], point[1] + CURVES[curveId].p]], [2n], curveId)).toThrow("canonical");
  });

  test.each(glvCases)("rejects the unreduced scalar for curve $curveId", ({ curveId, order }) => {
    expect(() => garaga.msmCalldataBuilder([generator(curveId)], [order], curveId)).toThrow("less than the curve order");
  });
});
