from garaga.algebra import ModuloCircuitElement
from garaga.definitions import CurveID
from garaga.precompiled_circuits.ec import BasicEC, BasicECG2


class SlowG2CofactorClearing(BasicECG2):
    """
    Implements cofactor clearing for G2 points on BLS12-381 curve.
    Based on Teku's implementation of BLS signatures.
    """

    def h2_chain(
        self, P: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]
    ):
        """
        Addition chain for multiplication by the E2 cofactor.

        Reference implementation:
        https://github.com/Consensys/teku/blob/55d04f87b422112312f79c1b4d662b3d58e3ca74/bls/src/main/java/tech/pegasys/teku/bls/impl/mikuli/hash2g2/Chains.java#L569
        """
        assert (
            self.curve_id == CurveID.BLS12_381.value
        ), "This circuit is only supported for BLS12-381"

        # Initial point is t0 = P
        t0 = P

        t1 = self.double_point_a_eq_0(t0)
        t4 = self.add_points(t1, t0)
        t2 = self.add_points(t4, t1)
        t3 = self.add_points(t2, t1)
        t11 = self.add_points(t3, t1)
        t9 = self.add_points(t11, t1)
        t10 = self.add_points(t9, t1)
        t5 = self.add_points(t10, t1)
        t7 = self.add_points(t5, t1)
        t15 = self.add_points(t7, t1)
        t13 = self.add_points(t15, t1)
        t6 = self.add_points(t13, t1)
        t14 = self.add_points(t6, t1)
        t12 = self.add_points(t14, t1)
        t8 = self.add_points(t12, t1)

        # Start the main computation chain
        t1 = self.double_point_a_eq_0(t6)  # t6.dbl()
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t13)  # .add(t13)
        t1 = self.double_n_times(t1, 2)  # .dbls(2)
        t1 = self.add_points(t1, t0)  # .add(t0)
        t1 = self.double_n_times(t1, 9)  # .dbls(9)
        t1 = self.add_points(t1, t8)  # .add(t8)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t11)  # .add(t11)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t13)  # .add(t13)
        t1 = self.double_n_times(t1, 8)  # .dbls(8)
        t1 = self.add_points(t1, t2)  # .add(t2)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t5)  # .add(t5)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t0)  # .add(t0)
        t1 = self.double_n_times(t1, 8)  # .dbls(8)
        t1 = self.add_points(t1, t11)  # .add(t11)
        t1 = self.double_n_times(t1, 8)  # .dbls(8)
        t1 = self.add_points(t1, t8)  # .add(t8)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t2)  # .add(t2)
        t1 = self.double_n_times(t1, 9)  # .dbls(9)
        t1 = self.add_points(t1, t5)  # .add(t5)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t11)  # .add(t11)
        t1 = self.double_n_times(t1, 2)  # .dbls(2)
        t1 = self.add_points(t1, t0)  # .add(t0)
        t1 = self.double_n_times(t1, 9)  # .dbls(9)
        t1 = self.add_points(t1, t8)  # .add(t8)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t13)  # .add(t13)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t0)  # .add(t0)
        t1 = self.double_n_times(t1, 11)  # .dbls(11)
        t1 = self.add_points(t1, t9)  # .add(t9)
        t1 = self.double_n_times(t1, 7)  # .dbls(7)
        t1 = self.add_points(t1, t12)  # .add(t12)
        t1 = self.double_n_times(t1, 7)  # .dbls(7)
        t1 = self.add_points(t1, t7)  # .add(t7)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t12)  # .add(t12)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t14)  # .add(t14)
        t1 = self.double_n_times(t1, 8)  # .dbls(8)
        t1 = self.add_points(t1, t13)  # .add(t13)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t0)  # .add(t0)
        t1 = self.double_n_times(t1, 8)  # .dbls(8)
        t1 = self.add_points(t1, t9)  # .add(t9)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t13)  # .add(t13)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t10)  # .add(t10)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t2)  # .add(t2)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t10)  # .add(t10)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t2)  # .add(t2)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t0)  # .add(t0)
        t1 = self.double_n_times(t1, 10)  # .dbls(10)
        t1 = self.add_points(t1, t9)  # .add(t9)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t14)  # .add(t14)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t9)  # .add(t9)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t15)  # .add(t15)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t8)  # .add(t8)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t12)  # .add(t12)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t5)  # .add(t5)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t15)  # .add(t15)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t2)  # .add(t2)
        t1 = self.double_n_times(t1, 7)  # .dbls(7)
        t1 = self.add_points(t1, t5)  # .add(t5)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t9)  # .add(t9)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t15)  # .add(t15)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t14)  # .add(t14)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t8)  # .add(t8)
        t1 = self.double_n_times(t1, 10)  # .dbls(10)
        t1 = self.add_points(t1, t6)  # .add(t6)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t5)  # .add(t5)
        t1 = self.double_n_times(t1, 3)  # .dbls(3)
        t1 = self.add_points(t1, t0)  # .add(t0)
        t1 = self.double_n_times(t1, 9)  # .dbls(9)
        t1 = self.add_points(t1, t13)  # .add(t13)
        t1 = self.double_n_times(t1, 7)  # .dbls(7)
        t1 = self.add_points(t1, t12)  # .add(t12)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t5)  # .add(t5)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t2)  # .add(t2)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t11)  # .add(t11)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t10)  # .add(t10)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t4)  # .add(t4)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t10)  # .add(t10)
        t1 = self.double_n_times(t1, 7)  # .dbls(7)
        t1 = self.add_points(t1, t7)  # .add(t7)
        t1 = self.double_n_times(t1, 3)  # .dbls(3)
        t1 = self.add_points(t1, t2)  # .add(t2)
        t1 = self.double_n_times(t1, 4)  # .dbls(4)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 8)  # .dbls(8)
        t1 = self.add_points(t1, t9)  # .add(t9)
        t1 = self.double_n_times(t1, 8)  # .dbls(8)
        t1 = self.add_points(t1, t9)  # .add(t9)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t8)  # .add(t8)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t7)  # .add(t7)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t6)  # .add(t6)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t5)  # .add(t5)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t4)  # .add(t4)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t5)  # .add(t5)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t4)  # .add(t4)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t4)  # .add(t4)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t5)  # .add(t5)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 7)  # .dbls(7)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t4)  # .add(t4)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 3)  # .dbls(3)
        t1 = self.add_points(t1, t0)  # .add(t0)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 6)  # .dbls(6)
        t1 = self.add_points(t1, t3)  # .add(t3)
        t1 = self.double_n_times(t1, 5)  # .dbls(5)
        t1 = self.add_points(t1, t2)  # .add(t2)

        return t1

    def mx_chain(self, P):
        """
        Addition chain for multiplication by 0xd201000000010000 == -x,
        where x is the BLS parameter.
        """
        q = self.double_point_a_eq_0(P)

        # Sequence of doubles and adds as per Java implementation
        ndoubles = [2, 3, 9, 32, 16]
        for n in ndoubles:
            q = self.add_points(q, P)
            for _ in range(n):
                q = self.double_point_a_eq_0(q)

        return q

    def clear_cofactor(self, P):
        """
        Complete cofactor clearing implementation following Teku's approach.

        This implements an optimized cofactor clearing method for BLS12-381 G2 that avoids
        patent-encumbered endomorphism techniques. Instead of directly multiplying by the G2
        cofactor, it uses an efficient addition chain to compute an equivalent operation.

        The method follows the approach specified in draft-irtf-cfrg-hash-to-curve-05 section 8.9.2,
        which breaks down the operation into:
        1. Apply h2 chain
        2. Multiply by 3
        3. Apply mx chain twice (z^2)
        4. Subtract 3 * h2 result

        This gives the same result as multiplying by the effective cofactor, but is more
        computationally efficient due to the optimized addition chain implementation.

        Args:
            P: The point to clear the cofactor from

        Returns:
            A point in the correct subgroup after cofactor clearing
        """
        assert (
            self.curve_id == CurveID.BLS12_381.value
        ), "This circuit is only supported for BLS12-381"

        # Step 1: Apply h2 chain
        work = self.h2_chain(P)

        # Step 2: Multiply by 3 (add + double)
        work3 = self.add_points(work, self.double_point_a_eq_0(work))

        # Step 3: Apply mx chain twice (z^2)
        work = self.mx_chain(work3)  # First z
        work = self.mx_chain(work)  # Second z

        # Step 4: Subtract 3 * h2
        neg_work3 = self.negate_point(work3)
        final = self.add_points(work, neg_work3)

        return final


class FastG2CofactorClearing(BasicECG2):
    """
    Implements an efficient cofactor clearing method for G2 points on BLS12-381 curve
    using endomorphisms. This implementation avoids expensive scalar multiplications
    by utilizing the Frobenius endomorphism (ψ) and efficient addition chains.

    The cofactor clearing ensures that points are in the correct order-r subgroup of G2,
    which is essential for cryptographic operations like BLS signatures.

    Key operations:
    - ψ (psi): Frobenius endomorphism
    - ψ² (psi²): Double application of Frobenius
    - mul_by_x: Multiplication by BLS parameter x
    """

    def psi(
        self, P: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]
    ) -> tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]:
        """
        Implements the ψ (Frobenius endomorphism) map for BLS12-381 G₂ points.

        The Frobenius endomorphism ψ is defined as:
        ψ(P) = π(P) · [1/(u+1)^((p-1)/3), 1/(u+1)^((p-1)/2)]
        where π is the p-power Frobenius map that conjugates coordinates in Fp2.

        Args:
            P: A G2 point represented as ((x0, x1), (y0, y1)) where each coordinate
               is in Fp and (x0, x1) and (y0, y1) represent elements in Fp2

        Returns:
            A new G2 point after applying the Frobenius endomorphism
        """
        assert (
            self.curve_id == CurveID.BLS12_381.value
        ), "This circuit is only supported for BLS12-381"

        x, y = P  # x and y are lists [x0, x1] representing elements in Fp²

        # Apply the Frobenius map (conjugation in Fp2)
        x_frob = self.fp2_frobenius_map(x)
        y_frob = self.fp2_frobenius_map(y)

        # Constants for scaling after Frobenius map
        # PSI_X = 1/(u+1)^((p-1)/3)
        psi_coeff_x = [
            self.set_or_get_constant(self.field(0)),
            self.set_or_get_constant(
                self.field(
                    0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAD
                )
            ),
        ]

        # PSI_Y = 1/(u+1)^((p-1)/2)
        psi_coeff_y = [
            self.set_or_get_constant(
                self.field(
                    0x135203E60180A68EE2E9C448D77A2CD91C3DEDD930B1CF60EF396489F61EB45E304466CF3E67FA0AF1EE7B04121BDEA2
                )
            ),
            self.set_or_get_constant(
                self.field(
                    0x6AF0E0437FF400B6831E36D6BD17FFE48395DABC2D3435E77F76E17009241C5EE67992F72EC05F4C81084FBEDE3CC09
                )
            ),
        ]

        # Scale the coordinates with the appropriate constants
        psi_x = self.fp2_mul(x_frob, psi_coeff_x)
        psi_y = self.fp2_mul(y_frob, psi_coeff_y)

        return (psi_x, psi_y)

    def mul_by_x(
        self, P: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]
    ) -> tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]:
        """
        Multiplies a point by x = -0xd201000000010001 (BLS parameter) using double-and-add.

        The binary representation of x is:
        1101 0010 0000 0001 0000 0000 0000 0000 0000 0000 0000 0001 0000 0000 0000 0000

        Args:
            P: A G2 point to be multiplied by x

        Returns:
            [-x]P: The point multiplied by the negation of x
        """
        assert (
            self.curve_id == CurveID.BLS12_381.value
        ), "This circuit is only supported for BLS12-381"

        result = P  # 1: Start with P. As a result we skip the first bit.
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)  # 2: Double and add
        result = self.double_point_a_eq_0(result)  # 0: Double
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)
        result = self.double_n_times(result, 2)  # 2x 0: Double
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)
        result = self.double_n_times(result, 8)  # 8x 0: Double
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)
        result = self.double_n_times(result, 31)  # 31x 0: Double
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)
        result = self.double_n_times(result, 16)  # 16x 0: Double

        return self.negate_point(result)

    def double_psi(
        self, P: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]
    ) -> tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]:
        """
        Implements ψ² (double Frobenius endomorphism) by applying psi twice.

        For BLS12-381, ψ² is a much cheaper operation than scalar multiplication
        and is used to optimize the cofactor clearing operation.

        Args:
            P: A G2 point

        Returns:
            ψ²(P): The point after applying the Frobenius endomorphism twice
        """
        return self.psi(self.psi(P))

    def clear_cofactor(
        self, P: tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]
    ) -> tuple[list[ModuloCircuitElement], list[ModuloCircuitElement]]:
        """
        Clears the cofactor of a G2 point using an optimized endomorphism-based method.

        This implementation follows the efficient approach described in:
        https://eprint.iacr.org/2017/419.pdf

        The formula implemented is:
        [h(ψ)]P = [x²-x-1]P + [x-1]ψ(P) + ψ²(2P)
        where x is the BLS parameter = -0xd201000000010000

        This method is more efficient than the traditional scalar multiplication
        by the cofactor h, as it uses the efficiently computable endomorphism ψ
        and optimized multiplication by x.

        Args:
            P: A G2 point to clear the cofactor from

        Returns:
            A point in the correct order-r subgroup of G2
        """
        # Calculate [-x]P
        t1 = self.mul_by_x(P)

        # Calculate ψ(P)
        t2 = self.psi(P)

        # Calculate 2P and ψ²(2P)
        t3 = self.double_point_a_eq_0(P)  # 2P
        t3 = self.double_psi(t3)  # ψ²(2P)

        # Following steps compute: [x²-x-1]P + [x-1]ψ(P) + ψ²(2P)
        t3 = self.add_points(t3, self.negate_point(t2))  # ψ²(2P) - ψ(P)
        t2 = self.add_points(t1, t2)  # [-x]P + ψ(P)
        t2 = self.mul_by_x(t2)  # [x²]P - [x]ψ(P)
        t3 = self.add_points(t3, t2)  # ψ²(2P) - ψ(P) + [x²]P - [x]ψ(P)
        t3 = self.add_points(t3, self.negate_point(t1))  # Add [x]P
        final = self.add_points(t3, self.negate_point(P))  # Subtract P

        return final


class G1CofactorClearing(BasicEC):

    def mul_by_x(
        self, P: tuple[ModuloCircuitElement, ModuloCircuitElement]
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        """
        Multiplies a point by x = 0xd201000000010000 (BLS parameter) using double-and-add.

        The binary representation of x is:
        1101 0010 0000 0001 0000 0000 0000 0000 0000 0000 0000 0001 0000 0000 0000 0000

        Args:
            P: A G1 point to be multiplied by x

        Returns:
            [x]P: The point multiplied by x
        """

        # Todo : Incude automatic addition chain for any number computed at runtime ?
        assert (
            self.curve_id == CurveID.BLS12_381.value
        ), "This circuit is only supported for BLS12-381"

        result = P  # 1: Start with P. As a result we skip the first bit.
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)  # 2: Double and add
        result = self.double_point_a_eq_0(result)  # 0: Double
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)
        result = self.double_n_times(result, 2)  # 2x 0: Double
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)
        result = self.double_n_times(result, 8)  # 8x 0: Double
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)
        result = self.double_n_times(result, 31)  # 31x 0: Double
        result = self.double_point_a_eq_0(result)  # 1: Double and add
        result = self.add_points(result, P)
        return self.double_n_times(result, 16)  # 16x 0: Double

    def clear_cofactor(
        self, P: tuple[ModuloCircuitElement, ModuloCircuitElement]
    ) -> tuple[ModuloCircuitElement, ModuloCircuitElement]:
        """
        Clears the cofactor of a G1 point using an efficient scalar multiplication method.

        Implementation follows the approach from:
        https://eprint.iacr.org/2019/403

        The formula is: h_eff(P) = P - [-x]P = P + [x]P
        where x is the BLS parameter = -0xd201000000010000

        This method is more efficient than multiplying by the full cofactor h,
        as it uses an optimized addition chain for multiplication by x.

        Args:
            P: A G1 point to clear the cofactor from

        Returns:
            A point in the correct order-r subgroup of G1
        """
        assert (
            self.curve_id == CurveID.BLS12_381.value
        ), "This circuit is only supported for BLS12-381"

        # Calculate [x]P using the existing mul_by_x method
        # As shown below, we can save negation
        xP = self.mul_by_x(P)

        # Return P - [-x]P = P + [x]P
        return self.add_points(P, xP)


if __name__ == "__main__":
    circuit = G1CofactorClearing(name="cofactor_clearing", curve_id=1)
    val_x = circuit.write_element(
        circuit.field(
            3789617024712504402204306620295003375951143917889162928515122476381982967144814366712031831841518399614182231387665
        )
    )

    val_y = circuit.write_element(
        circuit.field(
            1292375129422168617658520396283100687686347104559592203462491249161639006037671760603453326853098986903549775136448
        )
    )

    print(circuit.clear_cofactor((val_x, val_y)))
