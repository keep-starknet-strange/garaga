from garaga.algebra import Fp2, ModuloCircuitElement
from garaga.hints.extf_mul import nondeterministic_extension_field_div
from garaga.modulo_circuit import ModuloCircuit, PyFelt, WriteOps


class Fp2Circuits(ModuloCircuit):
    """
    Implements circuits for Fp2 field operations.
    """

    def __init__(
        self,
        name: str,
        curve_id: int,
        generic_circuit: bool = False,
        compilation_mode: int = 0,
    ):
        super().__init__(
            name=name,
            curve_id=curve_id,
            generic_circuit=generic_circuit,
            compilation_mode=compilation_mode,
        )

    def fp2_is_non_zero(
        self, a: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Returns [1,0] if a ≠ 0, [0,0] if a == 0, working in Fp2.
        An Fp2 element is non-zero if either its real or imaginary part is non-zero.
        """
        # Check if real part is non-zero
        real_is_non_zero = self.fp_is_non_zero(a[0])

        # Check if imaginary part is non-zero
        imag_is_non_zero = self.fp_is_non_zero(a[1])

        # Either part must be non-zero for the Fp2 element to be non-zero
        # Using 1-(1-a)(1-b) = a + b - ab to compute OR
        result = self.sub(
            self.add(real_is_non_zero, imag_is_non_zero),
            self.mul(real_is_non_zero, imag_is_non_zero),
        )

        # Return as Fp2 element [result, 0]
        return [result, self.set_or_get_constant(0)]

    def fp2_mul(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]):
        # Assumes the irreducible poly is X^2 + 1.
        assert len(X) == len(Y) == 2 and all(
            isinstance(x, ModuloCircuitElement) and isinstance(y, ModuloCircuitElement)
            for x, y in zip(X, Y)
        )
        # xy = (x0 + i*x1) * (y0 + i*y1) = (x0*y0 - x1*y1) + i * (x0*y1 + x1*y0)
        return [
            self.sub(
                self.mul(X[0], Y[0], comment="Fp2 mul start"),
                self.mul(X[1], Y[1]),
                comment="Fp2 mul real part end",
            ),
            self.add(
                self.mul(X[0], Y[1]),
                self.mul(X[1], Y[0]),
                comment="Fp2 mul imag part end",
            ),
        ]

    def fp2_mul_by_non_residue(self, X: list[ModuloCircuitElement]):
        assert len(X) == 2 and all(isinstance(x, ModuloCircuitElement) for x in X)
        if self.curve_id == 1:
            # Non residue (1,1)
            # (a0 + i*a1) * (1 + i)
            a_tmp = self.add(X[0], X[1])
            a = self.add(a_tmp, a_tmp)
            b = X[0]
            z_a0 = self.sub(b, X[1])
            z_a1 = self.sub(self.sub(a, b), X[1])
            return [z_a0, z_a1]
        elif self.curve_id == 0:
            # Non residue (9, 1)
            # (a0 + i*a1) * (9 + i)
            a_tmp = self.add(X[0], X[1])
            a = self.mul(a_tmp, self.set_or_get_constant(10))
            b = self.mul(X[0], self.set_or_get_constant(9))
            z_a0 = self.sub(b, X[1])
            z_a1 = self.sub(self.sub(a, b), X[1])
            return [z_a0, z_a1]

        else:
            raise ValueError(
                f"Unsupported curve id for fp2 mul by non residue: {self.curve_id}"
            )

    def fp2_square(self, X: list[ModuloCircuitElement]):
        # Assumes the irreducible poly is X^2 + 1.
        # x² = (x0 + i x1)² = (x0² - x1²) + 2 * i * x0 * x1 = (x0+x1)(x0-x1) + i * 2 * x0 * x1.
        # (x0+x1)*(x0-x1) is cheaper than x0² - x1². (2 ADD + 1 MUL) vs (1 ADD + 2 MUL) (16 vs 20 steps)
        assert len(X) == 2 and all(isinstance(x, ModuloCircuitElement) for x in X)
        return [
            self.mul(self.add(X[0], X[1]), self.sub(X[0], X[1])),
            self.double(self.mul(X[0], X[1])),
        ]

    def fp2_sqrt(
        self, element: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        assert self.compilation_mode == 0, "fp2_sqrt is not supported in cairo 1 mode"

        root = Fp2(element[0].felt, element[1].felt).sqrt()
        if root is None:
            raise ValueError("No square root found for the given element")

        # ToDo: the selection of which root to select is an unvalidated hint. Not sure if this can stay like this
        if not root.lexicographically_largest:
            root = Fp2.zero(element[0].p).__sub__(root)

        root = self.write_elements([root.a0, root.a1], WriteOps.WITNESS)
        self.fp2_mul_and_assert(root, root, element, comment="Fp2 sqrt")
        return root

    def fp2_inv(self, X: list[ModuloCircuitElement]):
        assert len(X) == 2 and all(isinstance(x, ModuloCircuitElement) for x in X)
        t0 = self.mul(X[0], X[0], comment="Fp2 Inv start")
        t1 = self.mul(X[1], X[1])
        t0 = self.add(t0, t1)
        t1 = self.inv(t0)
        inv0 = self.mul(X[0], t1, comment="Fp2 Inv real part end")
        inv1 = self.neg(self.mul(X[1], t1), comment="Fp2 Inv imag part end")
        return [inv0, inv1]

    def fp2_div(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]):
        assert len(X) == len(Y) == 2 and all(
            isinstance(x, ModuloCircuitElement) and isinstance(y, ModuloCircuitElement)
            for x, y in zip(X, Y)
        )
        if self.compilation_mode == 0:
            x_over_y = nondeterministic_extension_field_div(X, Y, self.curve_id, 2)
            x_over_y = self.write_elements(x_over_y, WriteOps.WITNESS)
            # x_over_y = d0 + i * d1
            # y = y0 + i * y1
            # x = x_over_y*y = d0*y0 - d1*y1 + i * (d0*y1 + d1*y0)
            self.sub_and_assert(
                a=self.mul(x_over_y[0], Y[0]), b=self.mul(x_over_y[1], Y[1]), c=X[0]
            )
            self.add_and_assert(
                a=self.mul(x_over_y[0], Y[1]), b=self.mul(x_over_y[1], Y[0]), c=X[1]
            )
            return x_over_y
        elif self.compilation_mode == 1:
            # Todo : consider passing as calldata if possible.
            inv = self.fp2_inv(Y)
            return self.fp2_mul(X, inv)

    def fp2_frobenius_map(
        self, element: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Applies the Frobenius map to an element in F_{p^2}.
        For an element a + bi, returns a - bi.

        This is because:
        (a + bi)^p = a^p + (bi)^p = a^p + b^p * i^p
        In Fp: a^p = a, b^p = b
        In Fp2: i^p = -i
        Therefore: (a + bi)^p = a - bi
        """
        a, b = element  # element = a + bi
        return [a, self.neg(b)]  # return a - bi

    def fp2_add(
        self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        # Assumes elements are represented as pairs (a + bi)
        assert len(X) == len(Y) == 2 and all(
            isinstance(x, ModuloCircuitElement) and isinstance(y, ModuloCircuitElement)
            for x, y in zip(X, Y)
        )
        # (x0 + i*x1) + (y0 + i*y1) = (x0 + y0) + i*(x1 + y1)
        return [
            self.add(X[0], Y[0], comment="Fp2 add real part"),
            self.add(X[1], Y[1], comment="Fp2 add imag part"),
        ]

    def fp2_sub(self, X: list[ModuloCircuitElement], Y: list[ModuloCircuitElement]):
        # Assumes elements are represented as pairs (a + bi)
        assert len(X) == len(Y) == 2 and all(
            isinstance(x, ModuloCircuitElement) and isinstance(y, ModuloCircuitElement)
            for x, y in zip(X, Y)
        )
        # (x0 + i*x1) - (y0 + i*y1) = (x0 - y0) + i*(x1 - y1)
        return [
            self.sub(X[0], Y[0], comment="Fp2 sub real part"),
            self.sub(X[1], Y[1], comment="Fp2 sub imag part"),
        ]

    def fp2_mul_and_assert(
        self,
        a: list[ModuloCircuitElement],
        b: list[ModuloCircuitElement],
        c: list[ModuloCircuitElement],
        comment: str | None = None,
    ):
        """
        Multiplies two Fp2 elements a and b and asserts the result equals c.
        For a = (a0 + i*a1) and b = (b0 + i*b1), asserts:
        c0 = a0*b0 - a1*b1
        c1 = a0*b1 + a1*b0
        """
        assert (
            self.compilation_mode == 0
        ), "fp2_mul_and_assert is not supported in cairo 1 mode"

        assert len(a) == len(b) == len(c) == 2, "Fp2 elements must be length 2"

        # Calculate intermediate products
        a0b0 = self.mul(a[0], b[0], comment=f"{comment}: a0*b0" if comment else None)
        a1b1 = self.mul(a[1], b[1], comment=f"{comment}: a1*b1" if comment else None)
        a0b1 = self.mul(a[0], b[1], comment=f"{comment}: a0*b1" if comment else None)
        a1b0 = self.mul(a[1], b[0], comment=f"{comment}: a1*b0" if comment else None)

        # Assert real part: c0 = a0*b0 - a1*b1
        self.add_and_assert(
            a=a0b0,
            b=self.neg(a1b1),
            c=c[0],
            comment=f"{comment}: assert real part" if comment else None,
        )

        # Assert imaginary part: c1 = a0*b1 + a1*b0
        self.add_and_assert(
            a=a0b1,
            b=a1b0,
            c=c[1],
            comment=f"{comment}: assert imaginary part" if comment else None,
        )

        return c

    def fp2_parity(
        self, element: list[ModuloCircuitElement]
    ) -> list[ModuloCircuitElement]:
        """
        Computes the parity of the first non-zero coefficient of the Fp2 element (element[0], element[1])
        Returns [parity, 0]

        For an Fp2 element a + bi:
        1. If a ≠ 0, returns parity of a
        2. If a = 0 and b ≠ 0, returns parity of b
        3. If both are 0, returns [0, 0] (even)

        Implements sgn0_m_eq_2 from RFC9380 using witness variables for validation.
        """
        assert len(element) == 2 and all(
            isinstance(x, ModuloCircuitElement) for x in element
        )

        two = self.set_or_get_constant(2)
        one = self.set_or_get_constant(1)
        zero = self.set_or_get_constant(0)

        # For element[0] (real part)
        # Witnesses: q0 (quotient), r0 (remainder)
        q0 = self.write_element(
            PyFelt(element[0].value // 2, element[0].p), WriteOps.WITNESS
        )  # Witness for q0
        r0 = self.write_element(
            PyFelt(element[0].value % 2, element[0].p), WriteOps.WITNESS
        )  # Witness for r0 (parity of x0)

        # Enforce that r0 ∈ {0, 1}
        r0_sub_1 = self.sub(r0, one)
        r0_times_r0_sub_1 = self.mul(r0, r0_sub_1)
        self.sub_and_assert(r0_times_r0_sub_1, zero, zero, comment="Ensure r0 ∈ {0,1}")

        # Enforce x0 = 2 * q0 + r0
        two_q0 = self.mul(q0, two)
        self.add_and_assert(two_q0, r0, element[0], comment="Validate x0 decomposition")

        # Similarly for element[1] (imaginary part)
        q1 = self.write_element(
            PyFelt(element[1].value // 2, element[1].p), WriteOps.WITNESS
        )  # Witness for q1
        r1 = self.write_element(
            PyFelt((element[1].value % 2), element[1].p), WriteOps.WITNESS
        )  # Witness for r1 (parity of x1)

        # Enforce that r1 ∈ {0, 1}
        r1_sub_1 = self.sub(r1, one)
        r1_times_r1_sub_1 = self.mul(r1, r1_sub_1)
        self.sub_and_assert(r1_times_r1_sub_1, zero, zero, comment="Ensure r1 ∈ {0,1}")

        # Enforce x1 = 2 * q1 + r1
        two_q1 = self.mul(q1, two)
        self.add_and_assert(two_q1, r1, element[1], comment="Validate x1 decomposition")

        # Compute zero_0 = 1 - fp_is_non_zero(x0)
        real_is_non_zero = self.fp_is_non_zero(
            element[0]
        )  # Returns 1 if x0 ≠ 0, else 0
        zero_0 = self.sub(one, real_is_non_zero)

        # Compute s = r0 OR (zero_0 AND r1)
        # Implementing logical operations using arithmetic operations
        # zero_0 AND r1
        zero_0_and_r1 = self.mul(zero_0, r1)

        # r0 OR (zero_0 AND r1)
        # OR(a, b) = a + b - a * b
        or_input = self.sub(self.add(r0, zero_0_and_r1), self.mul(r0, zero_0_and_r1))
        s = or_input  # Since values are in {0,1}, this computes the logical OR

        # Return parity as [s, 0]
        return [s, zero]

    def fp2_eval_horner(
        self,
        poly: list[ModuloCircuitElement],  # [a0_real, a0_imag, a1_real, a1_imag, ...]
        z: list[ModuloCircuitElement],  # z = [real, imag]
        poly_name: str = None,
        var_name: str = "z",
    ) -> list[ModuloCircuitElement]:
        """
        Evaluates a polynomial with Fp2 coefficients at point z using Horner's method.
        Assumes that the polynomial is in the form a0 + a1*z + a2*z^2 + ... + an*z^n,
        indexed with the constant coefficient first.
        Coefficients are stored in a flat array where each consecutive pair represents
        the real and imaginary parts of an Fp2 element.

        Args:
            poly: Flat list of coefficients [a0_real, a0_imag, a1_real, a1_imag, ...]
            z: The Fp2 point to evaluate at, represented as [real, imag]
            poly_name: Optional name for debugging
            var_name: Optional variable name for debugging

        Returns:
            [real, imag] representing the result in Fp2
        """
        if poly_name is None:
            poly_name = "UnnamedPoly"

        assert len(poly) % 2 == 0, "Polynomial coefficients array must have even length"
        n_coeffs = len(poly) // 2

        # Start with the highest degree coefficient
        acc = [poly[-2], poly[-1]]  # Get last pair [real, imag]

        # Iterate through remaining coefficients in reverse order
        for i in range(n_coeffs - 2, -1, -1):
            acc = self.fp2_add(
                self.fp2_mul(
                    acc,
                    z,
                ),
                [poly[2 * i], poly[2 * i + 1]],  # Get i-th coefficient pair
            )

        return acc
