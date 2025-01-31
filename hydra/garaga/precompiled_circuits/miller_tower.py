from typing import Iterator

from garaga.definitions import BLS12_381_ID, BN254_ID, CURVES
from garaga.extension_field_modulo_circuit import ModuloCircuitElement
from garaga.precompiled_circuits.multi_miller_loop import MultiMillerLoopCircuit


def tower_line_function_sparsity(curve_id: int) -> list[int]:
    match curve_id:
        case 0:
            return [2, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0]
        case 1:
            return [1, 1, 1, 1, 0, 0, 0, 0, 2, 0, 0, 0]
        case _:
            raise ValueError(f"Invalid curve ID: {curve_id}")


class MillerTowerCircuit(MultiMillerLoopCircuit):
    def __init__(
        self,
        name: str,
        curve_id: int,
        n_pairs: int,
        compilation_mode: int = 1,
    ):
        super().__init__(
            name=name,
            curve_id=curve_id,
            n_pairs=n_pairs,
            compilation_mode=compilation_mode,
        )

    def eval_tower_line(self, line: Iterator[ModuloCircuitElement], yInv, xNegOverY):
        assert len(line) == 4
        # Input is R0 = slope, R1 = intercept
        r0 = [line[0], line[1]]
        r1 = [line[2], line[3]]
        if self.curve_id == BN254_ID:
            return [
                self.mul(r0[0], xNegOverY),
                self.mul(r0[1], xNegOverY),
                self.mul(r1[0], yInv),
                self.mul(r1[1], yInv),
            ]
        elif self.curve_id == BLS12_381_ID:
            return [
                self.mul(r1[0], yInv),
                self.mul(r1[1], yInv),
                self.mul(r0[0], xNegOverY),
                self.mul(r0[1], xNegOverY),
            ]
        else:
            raise NotImplementedError

    def mul_by_line_tower(
        self,
        tower_fp12: list[ModuloCircuitElement],
        line_evaluated: list[ModuloCircuitElement],
    ):
        assert len(tower_fp12) == 12
        assert (
            len(line_evaluated) == 4
        ), f"Expected 4 elements, got {len(line_evaluated)}"
        c0_fp6, c1_fp6 = tower_fp12[0:6], tower_fp12[6:12]
        # c0_b0, c0_b1, c0_b2 = c0[0:2], c0[2:4], c0[4:6]
        # c1_b0, c1_b1, c1_b2 = c1[0:2], c1[2:4], c1[4:6]

        # MulBy34. multiplication by sparse element (1,0,0,c3,c4,0)
        if self.curve_id == 0:
            a = c0_fp6
            b = c1_fp6
            c3, c4 = line_evaluated[0:2], line_evaluated[2:4]
            b = self._fp6_by_01(b, c3, c4)

            d0 = self.vector_add(
                [self.set_or_get_constant(1), self.set_or_get_constant(0)], c3
            )
            d = self.vector_add(c0_fp6, c1_fp6)
            d = self._fp6_by_01(d, d0, c4)

            z_c1 = self.vector_add(self.vector_neg(self.vector_add(a, b)), d)
            z_c0 = self.vector_add(self.fp6_mul_by_non_residue(b), a)

            return z_c0 + z_c1
        elif self.curve_id == 1:
            # Mul By 01
            # // MulBy01 multiplication by sparse element (c0, c1, 0, 0, 1)
            # func (z *E12) MulBy01(c0, c1 *E2) *E12 {

            # 	var a, b E6
            # 	var d E2

            # 	a.Set(&z.C0)
            # 	a.MulBy01(c0, c1)

            # 	b.MulByNonResidue(&z.C1)
            # 	d.SetOne().Add(c1, &d)

            # 	z.C1.Add(&z.C1, &z.C0)
            # 	z.C1.MulBy01(c0, &d)
            # 	z.C1.Sub(&z.C1, &a)
            # 	z.C1.Sub(&z.C1, &b)
            # 	z.C0.MulByNonResidue(&b)
            # 	z.C0.Add(&z.C0, &a)

            # 	return z
            # }
            c0, c1 = line_evaluated[0:2], line_evaluated[2:4]

            a = c0_fp6
            a = self._fp6_by_01(a, c0, c1)
            b = self.fp6_mul_by_non_residue(c1_fp6)

            d = [self.add(self.set_or_get_constant(1), c1[0]), c1[1]]

            z_c1 = self.vector_add(c1_fp6, c0_fp6)
            z_c1 = self._fp6_by_01(z_c1, c0, d)
            z_c1 = self.vector_sub(z_c1, a)
            z_c1 = self.vector_sub(z_c1, b)

            z_c0 = self.fp6_mul_by_non_residue(b)
            z_c0 = self.vector_add(z_c0, a)
            return z_c0 + z_c1

    def mul_by_line_line_tower(self, tower_fp12, line_line):
        assert len(tower_fp12) == 12
        assert len(line_line) == 10
        c0_fp6, c1_fp6 = tower_fp12[0:6], tower_fp12[6:12]

    def mul_line_by_line_tower(self, l1, l2):
        assert len(l1) == 4
        assert len(l2) == 4
        if self.curve_id == 0:
            d3, d4 = l1[0:2], l1[2:4]
            c3, c4 = l2[0:2], l2[2:4]

            x3 = self.fp2_mul(c3, d3)
            x4 = self.fp2_mul(c4, d4)
            x04 = self.vector_add(c4, d4)
            x03 = self.vector_add(c3, d3)
            tmp = self.vector_add(c3, c4)
            x34 = self.vector_sub(
                self.vector_sub(self.fp2_mul(self.vector_add(d3, d4), tmp), x3), x4
            )
            z00 = self.fp2_mul_by_non_residue(x4)
            z00 = [self.add(z00[0], self.set_or_get_constant(1)), z00[1]]

            return z00 + x3 + x34 + x03 + x04
        if self.curve_id == 1:

            c0, c1 = l2[0:2], l2[2:4]
            d0, d1 = l1[0:2], l1[2:4]

            x0 = self.fp2_mul(c0, d0)
            x1 = self.fp2_mul(c1, d1)

            x04 = self.vector_add(d0, c0)
            tmp = self.vector_add(c0, c1)
            x01 = self.vector_sub(
                self.vector_sub(self.fp2_mul(self.vector_add(d0, d1), tmp), x0), x1
            )
            x14 = self.vector_add(d1, c1)
            z00 = self.fp2_mul_by_non_residue(
                [self.set_or_get_constant(1), self.set_or_get_constant(0)]
            )
            z00 = self.vector_add(z00, x0)

            # C0B0 + C0B1 + C0B2 + C1B1 + C1B2
            return z00 + x01 + x1 + x04 + x14

    def _fp6_by_01(self, e6: list[ModuloCircuitElement], c0, c1):
        assert len(e6) == 6
        assert len(c0) == 2
        assert len(c1) == 2
        b0, b1, b2 = e6[0:2], e6[2:4], e6[4:6]
        a = self.fp2_mul(b0, c0)
        b = self.fp2_mul(b1, c1)
        tmp = self.vector_add(b1, b2)
        t0 = self.fp2_mul(c1, tmp)
        t0 = self.vector_sub(t0, b)
        t0 = self.fp2_mul_by_non_residue(t0)
        t0 = self.vector_add(t0, a)

        tmp = self.vector_add(b0, b2)
        t2 = self.fp2_mul(c0, tmp)
        t2 = self.vector_sub(t2, a)
        t2 = self.vector_add(t2, b)

        t1 = self.vector_add(c0, c1)
        tmp = self.vector_add(b0, b1)
        t1 = self.fp2_mul(t1, tmp)
        t1 = self.vector_sub(t1, a)
        t1 = self.vector_sub(t1, b)

        b0 = t0
        b1 = t1
        b2 = t2
        # flatten lists:
        return b0 + b1 + b2

    def fp6_mul_by_non_residue(self, a: list[ModuloCircuitElement]):
        assert len(a) == 6
        a = list(a)
        b0, b1, b2 = a[0:2], a[2:4], a[4:6]
        return self.fp2_mul_by_non_residue(b2) + b0 + b1

    def fp12_square(self, a: list[ModuloCircuitElement]):
        assert len(a) == 12

        xc0, xc1 = a[0:6], a[6:12]
        c0 = self.vector_sub(xc0, xc1)
        c3 = self.vector_add(xc0, self.vector_neg(self.fp6_mul_by_non_residue(xc1)))
        c2 = self.fp6_mul(xc0, xc1)
        c0 = self.vector_add(self.fp6_mul(c0, c3), c2)
        z_c1 = self.vector_add(c2, c2)
        z_c0 = self.vector_add(c0, self.fp6_mul_by_non_residue(c2))

        return z_c0 + z_c1

    def fp12_mul(self, x: list[ModuloCircuitElement], y: list[ModuloCircuitElement]):
        assert len(x) == 12
        assert len(y) == 12

        x_c0, x_c1 = x[0:6], x[6:12]
        y_c0, y_c1 = y[0:6], y[6:12]

        a = self.vector_add(x_c0, x_c1)
        b = self.vector_add(y_c0, y_c1)
        a = self.fp6_mul(a, b)
        b = self.fp6_mul(x_c0, y_c0)
        c = self.fp6_mul(x_c1, y_c1)
        z_c1 = self.vector_sub(a, b)
        z_c1 = self.vector_sub(z_c1, c)
        z_c0 = self.fp6_mul_by_non_residue(c)
        z_c0 = self.vector_add(z_c0, b)

        return z_c0 + z_c1

    def fp6_mul(self, a: list[ModuloCircuitElement], b: list[ModuloCircuitElement]):
        assert len(a) == 6
        assert len(b) == 6

        xb0, xb1, xb2 = a[0:2], a[2:4], a[4:6]
        yb0, yb1, yb2 = b[0:2], b[2:4], b[4:6]

        t0 = self.fp2_mul(xb0, yb0)
        t1 = self.fp2_mul(xb1, yb1)
        t2 = self.fp2_mul(xb2, yb2)

        c0 = self.vector_add(xb1, xb2)
        tmp = self.vector_add(yb1, yb2)

        c0 = self.vector_add(
            self.fp2_mul_by_non_residue(
                self.vector_sub(self.vector_sub(self.fp2_mul(c0, tmp), t1), t2)
            ),
            t0,
        )

        c1 = self.vector_add(xb0, xb1)
        tmp = self.vector_add(yb0, yb1)
        c1 = self.vector_sub(self.vector_sub(self.fp2_mul(c1, tmp), t0), t1)
        tmp = self.fp2_mul_by_non_residue(t2)
        c1 = self.vector_add(c1, tmp)

        tmp = self.vector_add(xb0, xb2)
        c2 = self.vector_add(
            self.vector_sub(
                self.vector_sub(self.fp2_mul(self.vector_add(yb0, yb2), tmp), t0), t2
            ),
            t1,
        )

        return c0 + c1 + c2

    def fp12_inverse(self, a: list[ModuloCircuitElement]):

        assert len(a) == 12

        xc0, xc1 = a[0:6], a[6:12]

        t0 = self.fp6_square(xc0)
        t1 = self.fp6_square(xc1)
        tmp = self.fp6_mul_by_non_residue(t1)
        t0 = self.vector_sub(t0, tmp)
        t1 = self.fp6_inverse(t0)
        z_c0 = self.fp6_mul(xc0, t1)
        z_c1 = self.fp6_mul(xc1, t1)
        z_c1 = self.vector_neg(z_c1)

        return z_c0 + z_c1

    def fp6_inverse(self, a: list[ModuloCircuitElement]):
        assert len(a) == 6
        # func (z *E6) Inverse(x *E6) *E6 {
        # 	// Algorithm 17 from https://eprint.iacr.org/2010/354.pdf
        # 	// step 9 is wrong in the paper it's t1-t4
        # 	var t0, t1, t2, t3, t4, t5, t6, c0, c1, c2, d1, d2 E2
        # 	t0.Square(&x.B0)
        # 	t1.Square(&x.B1)
        # 	t2.Square(&x.B2)
        # 	t3.Mul(&x.B0, &x.B1)
        # 	t4.Mul(&x.B0, &x.B2)
        # 	t5.Mul(&x.B1, &x.B2)
        # 	c0.MulByNonResidue(&t5).Neg(&c0).Add(&c0, &t0)
        # 	c1.MulByNonResidue(&t2).Sub(&c1, &t3)
        # 	c2.Sub(&t1, &t4)
        # 	t6.Mul(&x.B0, &c0)
        # 	d1.Mul(&x.B2, &c1)
        # 	d2.Mul(&x.B1, &c2)
        # 	d1.Add(&d1, &d2).MulByNonResidue(&d1)
        # 	t6.Add(&t6, &d1)
        # 	t6.Inverse(&t6)
        # 	z.B0.Mul(&c0, &t6)
        # 	z.B1.Mul(&c1, &t6)
        # 	z.B2.Mul(&c2, &t6)
        xb0, xb1, xb2 = a[0:2], a[2:4], a[4:6]
        t0 = self.fp2_square(xb0)
        t1 = self.fp2_square(xb1)
        t2 = self.fp2_square(xb2)

        t3 = self.fp2_mul(xb0, xb1)
        t4 = self.fp2_mul(xb0, xb2)
        t5 = self.fp2_mul(xb1, xb2)
        c0 = self.vector_add(self.vector_neg(self.fp2_mul_by_non_residue(t5)), t0)
        c1 = self.vector_sub(self.fp2_mul_by_non_residue(t2), t3)
        c2 = self.vector_sub(t1, t4)

        t6 = self.fp2_mul(xb0, c0)
        d1 = self.fp2_mul(xb2, c1)
        d2 = self.fp2_mul(xb1, c2)
        d1 = self.fp2_mul_by_non_residue(self.vector_add(d1, d2))
        t6 = self.vector_add(t6, d1)
        t6 = self.fp2_inv(t6)
        zb0 = self.fp2_mul(c0, t6)
        zb1 = self.fp2_mul(c1, t6)
        zb2 = self.fp2_mul(c2, t6)

        return zb0 + zb1 + zb2

    def fp6_square(self, a: list[ModuloCircuitElement]):
        assert len(a) == 6

        xb0, xb1, xb2 = a[0:2], a[2:4], a[4:6]
        c4 = self.fp2_mul(xb0, xb1)
        c4 = self.vector_add(c4, c4)
        c5 = self.fp2_square(xb2)
        c1 = self.vector_add(self.fp2_mul_by_non_residue(c5), c4)
        c2 = self.vector_sub(c4, c5)
        c3 = self.fp2_square(xb0)
        c4 = self.vector_add(self.vector_sub(xb0, xb1), xb2)
        c5 = self.fp2_mul(xb1, xb2)
        c5 = self.vector_add(c5, c5)

        c4 = self.fp2_square(c4)
        c0 = self.vector_add(self.fp2_mul_by_non_residue(c5), c3)
        zb2 = self.vector_sub(self.vector_add(self.vector_add(c2, c4), c5), c3)
        zb0 = c0
        zb1 = c1

        return zb0 + zb1 + zb2

    def fp12_conjugate(self, a: list[ModuloCircuitElement]):
        assert len(a) == 12

        raise NotImplementedError("Not implemented")

    def fp12_cyclotomic_square(self, a: list[ModuloCircuitElement]):
        assert len(a) == 12

        xc0, xc1 = a[0:6], a[6:12]
        xc0b0 = xc0[0:2]
        xc0b1 = xc0[2:4]
        xc0b2 = xc0[4:6]
        xc1b0 = xc1[0:2]
        xc1b1 = xc1[2:4]
        xc1b2 = xc1[4:6]

        t0 = self.fp2_square(xc1b1)
        t1 = self.fp2_square(xc0b0)
        t6 = self.vector_add(xc1b1, xc0b0)
        t6 = self.fp2_square(t6)
        t6 = self.vector_sub(t6, t0)
        t6 = self.vector_sub(t6, t1)
        t2 = self.fp2_square(xc0b2)
        t3 = self.fp2_square(xc1b0)
        t7 = self.vector_add(xc0b2, xc1b0)
        t7 = self.fp2_square(t7)
        t7 = self.vector_sub(t7, t2)
        t7 = self.vector_sub(t7, t3)

        t4 = self.fp2_square(xc1b2)
        t5 = self.fp2_square(xc0b1)
        t8 = self.vector_add(xc1b2, xc0b1)
        t8 = self.fp2_square(t8)
        t8 = self.vector_sub(t8, t4)
        t8 = self.vector_sub(t8, t5)
        t8 = self.fp2_mul_by_non_residue(t8)

        t0 = self.fp2_mul_by_non_residue(t0)
        t0 = self.vector_add(t0, t1)
        t2 = self.fp2_mul_by_non_residue(t2)
        t2 = self.vector_add(t2, t3)
        t4 = self.fp2_mul_by_non_residue(t4)
        t4 = self.vector_add(t4, t5)

        zc0b0 = self.vector_sub(t0, xc0b0)
        zc0b0 = self.vector_add(zc0b0, zc0b0)
        zc0b0 = self.vector_add(zc0b0, t0)

        zc0b1 = self.vector_sub(t2, xc0b1)
        zc0b1 = self.vector_add(zc0b1, zc0b1)
        zc0b1 = self.vector_add(zc0b1, t2)

        zc0b2 = self.vector_sub(t4, xc0b2)
        zc0b2 = self.vector_add(zc0b2, zc0b2)
        zc0b2 = self.vector_add(zc0b2, t4)

        zc1b0 = self.vector_add(t8, xc1b0)
        zc1b0 = self.vector_add(zc1b0, zc1b0)
        zc1b0 = self.vector_add(zc1b0, t8)

        zc1b1 = self.vector_add(t6, xc1b1)
        zc1b1 = self.vector_add(zc1b1, zc1b1)
        zc1b1 = self.vector_add(zc1b1, t6)

        zc1b2 = self.vector_add(t7, xc1b2)
        zc1b2 = self.vector_add(zc1b2, zc1b2)
        zc1b2 = self.vector_add(zc1b2, t7)

        return zc0b0 + zc0b1 + zc0b2 + zc1b0 + zc1b1 + zc1b2

    def fp2_conjugate(self, a: list[ModuloCircuitElement]):
        assert len(a) == 2
        return [a[0], self.neg(a[1])]

    def mul_by_non_residue_k_power_n(
        self, x: list[ModuloCircuitElement], k: int, n: int
    ):
        from garaga.hints.tower_backup import E2

        assert len(x) == 2
        curve = CURVES[self.curve_id]
        non_residue = E2(curve.nr_a0, curve.nr_a1, curve.p)
        # nr^(n*(p^k-1)/6)
        res: E2 = non_residue ** ((n * (curve.p**k - 1) // 6))
        if res.a1 != 0:
            factor = [
                self.set_or_get_constant(res.a0),
                self.set_or_get_constant(res.a1),
            ]
            return self.fp2_mul(factor, x)
        else:
            factor = self.set_or_get_constant(res.a0)
            return [self.mul(factor, x[0]), self.mul(factor, x[1])]

    def fp12_frob(self, a: list[ModuloCircuitElement]):
        assert len(a) == 12

        c0b0 = self.fp2_conjugate(a[0:2])
        c0b0[0] = self.add(
            c0b0[0], self.set_or_get_constant(0)
        )  # Input cannot be output. # TODO: Make a manual circuit or something better.
        c0b1 = self.fp2_conjugate(a[2:4])
        c0b2 = self.fp2_conjugate(a[4:6])
        c1b0 = self.fp2_conjugate(a[6:8])
        c1b1 = self.fp2_conjugate(a[8:10])
        c1b2 = self.fp2_conjugate(a[10:12])

        c0b1 = self.mul_by_non_residue_k_power_n(c0b1, 1, 2)
        c0b2 = self.mul_by_non_residue_k_power_n(c0b2, 1, 4)
        c1b0 = self.mul_by_non_residue_k_power_n(c1b0, 1, 1)
        c1b1 = self.mul_by_non_residue_k_power_n(c1b1, 1, 3)
        c1b2 = self.mul_by_non_residue_k_power_n(c1b2, 1, 5)

        return c0b0 + c0b1 + c0b2 + c1b0 + c1b1 + c1b2

    def fp12_frob_square(self, a: list[ModuloCircuitElement]):
        assert len(a) == 12
        c0b0 = [
            self.add(a[0], self.set_or_get_constant(0)),
            self.add(a[1], self.set_or_get_constant(0)),
        ]  # Input cannot be output. # TODO: Make a manual circuit or something better.
        c0b1 = self.mul_by_non_residue_k_power_n(a[2:4], 2, 2)
        c0b2 = self.mul_by_non_residue_k_power_n(a[4:6], 2, 4)
        c1b0 = self.mul_by_non_residue_k_power_n(a[6:8], 2, 1)
        c1b1 = self.mul_by_non_residue_k_power_n(a[8:10], 2, 3)
        c1b2 = self.mul_by_non_residue_k_power_n(a[10:12], 2, 5)

        return c0b0 + c0b1 + c0b2 + c1b0 + c1b1 + c1b2

    def fp12_frob_cube(self, a: list[ModuloCircuitElement]):
        assert len(a) == 12

        c0b0 = self.fp2_conjugate(a[0:2])
        c0b0[0] = self.add(
            c0b0[0], self.set_or_get_constant(0)
        )  # Input cannot be output. # TODO: Make a manual circuit or something better.
        c0b1 = self.fp2_conjugate(a[2:4])
        c0b2 = self.fp2_conjugate(a[4:6])
        c1b0 = self.fp2_conjugate(a[6:8])
        c1b1 = self.fp2_conjugate(a[8:10])
        c1b2 = self.fp2_conjugate(a[10:12])

        c0b1 = self.mul_by_non_residue_k_power_n(c0b1, 3, 2)
        c0b2 = self.mul_by_non_residue_k_power_n(c0b2, 3, 4)
        c1b0 = self.mul_by_non_residue_k_power_n(c1b0, 3, 1)
        c1b1 = self.mul_by_non_residue_k_power_n(c1b1, 3, 3)
        c1b2 = self.mul_by_non_residue_k_power_n(c1b2, 3, 5)

        return c0b0 + c0b1 + c0b2 + c1b0 + c1b1 + c1b2

    def fp12_cyclotomic_square_compressed(
        self,
        xc0b1: list[ModuloCircuitElement],
        xc0b2: list[ModuloCircuitElement],
        xc1b0: list[ModuloCircuitElement],
        xc1b2: list[ModuloCircuitElement],
    ):
        assert len(xc0b1) == len(xc0b2) == len(xc1b0) == len(xc1b2) == 2

        t0 = self.fp2_square(xc0b1)
        t1 = self.fp2_square(xc1b2)
        t5 = self.vector_add(xc0b1, xc1b2)
        t2 = self.fp2_square(t5)

        t3 = self.vector_add(t0, t1)
        t5 = self.vector_sub(t2, t3)

        t6 = self.vector_add(xc1b0, xc0b2)
        t3 = self.fp2_square(t6)
        t2 = self.fp2_square(xc1b0)

        t6 = self.fp2_mul_by_non_residue(t5)
        t5 = self.vector_add(t6, xc1b0)
        t5 = self.vector_add(t5, t5)

        zc1b0 = self.vector_add(t5, t6)

        t4 = self.fp2_mul_by_non_residue(t1)
        t5 = self.vector_add(t0, t4)
        t6 = self.vector_sub(t5, xc0b2)

        t1 = self.fp2_square(xc0b2)
        t6 = self.vector_add(t6, t6)
        zc0b2 = self.vector_add(t6, t5)

        t4 = self.fp2_mul_by_non_residue(t1)
        t5 = self.vector_add(t2, t4)
        t6 = self.vector_sub(t5, xc0b1)
        t6 = self.vector_add(t6, t6)
        zc0b1 = self.vector_add(t6, t5)

        t0 = self.vector_add(t2, t1)
        t5 = self.vector_sub(t3, t0)
        t6 = self.vector_add(t5, xc1b2)
        t6 = self.vector_add(t6, t6)
        zc1b2 = self.vector_add(t5, t6)

        return zc0b1 + zc0b2 + zc1b0 + zc1b2

    def fp12_decompress_karabina_pt_I_c1b2_Z(self, xc0b1, xc1b2):

        assert len(xc0b1) == len(xc1b2) == 2

        t0 = self.fp2_mul(xc0b1, xc1b2)
        t0 = self.vector_add(t0, t0)

        # t1 = xc0b2

        return t0

    def fp12_decompress_karabina_pt_I_c1b2_NZ(
        self,
        xc0b1: list[ModuloCircuitElement],
        xc0b2: list[ModuloCircuitElement],
        xc1b0: list[ModuloCircuitElement],
        xc1b2: list[ModuloCircuitElement],
    ):
        assert len(xc0b1) == len(xc0b2) == len(xc1b0) == len(xc1b2) == 2

        t0 = self.fp2_square(xc0b1)
        t1 = self.vector_sub(t0, xc0b2)
        t1 = self.vector_add(t1, t1)
        t1 = self.vector_add(t1, t0)

        t2 = self.fp2_square(xc1b2)
        t0 = self.vector_add(self.fp2_mul_by_non_residue(t2), t1)
        t1 = self.vector_add(xc1b0, xc1b0)
        t1 = self.vector_add(t1, t1)

        return t0, t1

    def fp12_decompress_karabina_pt_II(
        self,
        t0: list[ModuloCircuitElement],
        t1: list[ModuloCircuitElement],
        xc0b1: list[ModuloCircuitElement],
        xc0b2: list[ModuloCircuitElement],
        xc1b0: list[ModuloCircuitElement],
        xc1b2: list[ModuloCircuitElement],
    ):
        assert len(t0) == len(t1) == 2
        assert len(xc0b1) == len(xc0b2) == len(xc1b0) == len(xc1b2) == 2

        zc1b1 = self.fp2_div(t0, t1)

        t1 = self.fp2_mul(xc0b2, xc0b1)
        t2 = self.vector_sub(self.fp2_square(zc1b1), t1)
        t2 = self.vector_add(t2, t2)
        t2 = self.vector_sub(t2, t1)
        t1 = self.fp2_mul(xc1b0, xc1b2)
        t2 = self.vector_add(t2, t1)
        zc0b0 = self.fp2_mul_by_non_residue(t2)
        zc0b0 = [
            self.add(zc0b0[0], self.set_or_get_constant(1)),
            zc0b0[1],
        ]

        return zc0b0, zc1b1
