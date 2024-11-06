import garaga.modulo_circuit_structs as structs
from garaga.algebra import ModuloCircuitElement, PyFelt
from garaga.definitions import CURVES
from garaga.modulo_circuit import WriteOps
from garaga.precompiled_circuits.ec import BasicECG2


class EffectiveCofactorClearingG2(BasicECG2):
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


if __name__ == "__main__":
    circuit = EffectiveCofactorClearingG2(name="cofactor_clearing", curve_id=1)
    values = [
        PyFelt(
            3789617024712504402204306620295003375951143917889162928515122476381982967144814366712031831841518399614182231387665,
            CURVES[1].p,
        ),
        PyFelt(
            1467567314213963969852279817989131104935039564231603908576814773321528757289376676761397368853965316423532584391899,
            CURVES[1].p,
        ),
        PyFelt(
            1292375129422168617658520396283100687686347104559592203462491249161639006037671760603453326853098986903549775136448,
            CURVES[1].p,
        ),
        PyFelt(
            306655960768766438834866368706782505873384691666290681181893693450298456233972904889955517117016529975705729523733,
            CURVES[1].p,
        ),
    ]

    px0, px1, py0, py1 = circuit.write_struct(
        structs.G2PointCircuit("G2", values), WriteOps.INPUT
    )

    print(circuit.clear_cofactor(([px0, px1], [py0, py1])))
