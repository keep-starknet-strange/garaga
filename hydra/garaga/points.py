import functools
import random
from dataclasses import dataclass

from fastecdsa import curvemath

from garaga.algebra import Fp2, ModuloCircuitElement, Polynomial, PyFelt, get_sparsity
from garaga.curves import (
    CURVES,
    GARAGA_RS_SUPPORTED_CURVES,
    CurveID,
    PairingCurve,
    get_base_field,
    get_irreducible_poly,
)
from garaga.hints.io import int_to_u384


@dataclass(slots=True)
class G1Point:
    """
    Represents a point on G1, the group of rational points on an elliptic curve over the base field.

    Attributes:
        x (int): The x-coordinate of the point.
        y (int): The y-coordinate of the point.
        curve_id (CurveID): The identifier of the elliptic curve.
    """

    x: int
    y: int
    curve_id: CurveID
    iso_point: bool = False

    def __repr__(self) -> str:
        return f"G1Point({hex(self.x)}, {hex(self.y)}) on {self.curve_id.value}"

    def __str__(self) -> str:
        return f"G1Point({self.x}, {self.y}) on curve {self.curve_id}"

    def __hash__(self):
        return hash((self.x, self.y, self.curve_id, self.iso_point))

    def __eq__(self, other: object) -> bool:
        """
        Checks if two G1Point instances are equal.

        Args:
            other (G1Point): The other point to compare.

        Returns:
            bool: True if the points are equal, False otherwise.
        """
        if not isinstance(other, G1Point):
            raise ValueError(f"Cannot compare G1Point with {type(other)}")
        return (
            self.x == other.x
            and self.y == other.y
            and self.curve_id.value == other.curve_id.value
            and self.iso_point == other.iso_point
        )

    def __post_init__(self):
        """
        Post-initialization checks to ensure the point is valid.
        """
        if self.is_infinity():
            return
        if not self.is_on_curve():
            raise ValueError(f"Point {self} is not on the curve {self.curve_id}")

    @staticmethod
    def infinity(curve_id: CurveID) -> "G1Point":
        """
        Returns the point at infinity for the given curve.

        Args:
            curve_id (CurveID): The identifier of the elliptic curve.

        Returns:
            G1Point: The point at infinity.
        """
        return G1Point(0, 0, curve_id)

    def is_infinity(self) -> bool:
        """
        Checks if the point is the point at infinity.

        Returns:
            bool: True if the point is at infinity, False otherwise.
        """
        return self.x == 0 and self.y == 0

    def to_cairo_1(self, as_hex: bool = True) -> str:
        """
        Converts the point to a Cairo 1 representation.

        Returns:
            str: The Cairo 1 representation of the point.
        """
        return f"G1Point{{x: {int_to_u384(self.x, as_hex)}, y: {int_to_u384(self.y, as_hex)}}}"

    @staticmethod
    def gen_random_point_not_in_subgroup(
        curve_id: CurveID, force_gen: bool = False
    ) -> "G1Point":
        """
        Generates a random point not in the prime order subgroup.

        Args:
            curve_id (CurveID): The identifier of the elliptic curve.
            force_gen (bool): Force generation even if the cofactor is 1.

        Returns:
            G1Point: A random point not in the prime order subgroup.

        Raises:
            ValueError: If the cofactor is 1 and force_gen is False.
        """
        curve_idx = curve_id.value
        if CURVES[curve_idx].h == 1:
            if force_gen:
                return G1Point.gen_random_point(curve_id)
            else:
                raise ValueError(
                    "Cofactor is 1, cannot generate a point not in the subgroup"
                )
        else:
            field = get_base_field(curve_idx)
            while True:
                x = field.random()
                y2 = x**3 + CURVES[curve_idx].a * x + CURVES[curve_idx].b
                try:
                    tentative_point = G1Point(x.value, y2.sqrt().value, curve_id)
                except ValueError:
                    continue
                if not tentative_point.is_in_prime_order_subgroup_generic():
                    return tentative_point

    def is_in_prime_order_subgroup_generic(self) -> bool:
        """
        Checks if the point is in the prime order subgroup.

        Returns:
            bool: True if the point is in the prime order subgroup, False otherwise.
        """
        return self.scalar_mul(CURVES[self.curve_id.value].n).is_infinity()

    def is_in_prime_order_subgroup(self) -> bool:
        if CURVES[self.curve_id.value].h == 1:
            # Cofactor is 1 : points on the curve <=> points in the prime order subgroup
            return self.is_on_curve() or self.is_infinity()
        else:
            if self.curve_id == CurveID.BLS12_381:
                # we check that p+x²ϕ(p)
                # is the infinity.
                third_root_of_unity = 0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC
                phi_p = G1Point(
                    self.x * third_root_of_unity % CURVES[self.curve_id.value].p,
                    self.y,
                    self.curve_id,
                )
                x_seed_sq = (CURVES[self.curve_id.value].x) ** 2
                return phi_p.scalar_mul(x_seed_sq).add(self).is_infinity()
            else:
                return self.is_in_prime_order_subgroup_generic()

    def is_on_curve(self) -> bool:
        """
        Checks if the point is on the curve using the curve equation y^2 = x^3 + ax + b.

        Returns:
            bool: True if the point is on the curve, False otherwise.
        """
        if self.iso_point:
            a = CURVES[self.curve_id.value].swu_params.A
            b = CURVES[self.curve_id.value].swu_params.B
        else:
            a = CURVES[self.curve_id.value].a
            b = CURVES[self.curve_id.value].b

        p = CURVES[self.curve_id.value].p
        lhs = self.y**2 % p
        rhs = (self.x**3 + a * self.x + b) % p
        return lhs == rhs

    @staticmethod
    def gen_random_point(curve_id: CurveID) -> "G1Point":
        """
        Generates a random point on a given curve.

        Args:
            curve_id (CurveID): The identifier of the elliptic curve.

        Returns:
            G1Point: A random point on the curve.
        """
        scalar = random.randint(1, CURVES[curve_id.value].n - 1)

        return G1Point.get_nG(curve_id, scalar)

    @staticmethod
    def get_nG(curve_id: CurveID, n: int) -> "G1Point":
        """
        Returns the scalar multiplication of the generator point on a given curve by the scalar n.

        Args:
            curve_id (CurveID): The identifier of the elliptic curve.
            n (int): The scalar to multiply by.

        Returns:
            G1Point: The resulting point after scalar multiplication.

        Raises:
            AssertionError: If n is not less than the order of the curve.
        """
        assert (
            n < CURVES[curve_id.value].n
        ), "n must be less than the order of the curve"

        gen = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
        return gen.scalar_mul(n)

    @staticmethod
    def msm(points: list["G1Point"], scalars: list[int]) -> "G1Point":
        """
        Performs multi-scalar multiplication (MSM) on a list of points and scalars.

        Args:
            points (list[G1Point]): The list of points.
            scalars (list[int]): The list of scalars.

        Returns:
            G1Point: The resulting point after MSM.
        """
        assert len(points) == len(
            scalars
        ), f"Points and scalar length mismatch: {len(points)} points and {len(scalars)} scalars"
        muls = [P.scalar_mul(s) for P, s in zip(points, scalars)]
        scalar_mul = functools.reduce(lambda acc, p: acc.add(p), muls)
        return scalar_mul

    def scalar_mul(self, scalar: int) -> "G1Point":
        """
        Performs scalar multiplication on the point.

        Args:
            scalar (int): The scalar to multiply by. abs(scalar) should be less than the order of the curve.

        Returns:
            G1Point: The resulting point after scalar multiplication.
        """
        if self.is_infinity():
            return self
        if scalar == 0:
            return G1Point(0, 0, self.curve_id, self.iso_point)
        if self.iso_point:
            a = CURVES[self.curve_id.value].swu_params.A
            b = CURVES[self.curve_id.value].swu_params.B
        else:
            a = CURVES[self.curve_id.value].a
            b = CURVES[self.curve_id.value].b
        # Fastecdsa C binding.
        x, y = curvemath.mul(
            str(self.x),
            str(self.y),
            str(abs(scalar)),
            str(CURVES[self.curve_id.value].p),
            str(a),
            str(b),
            str(CURVES[self.curve_id.value].n),
            str(CURVES[self.curve_id.value].Gx),
            str(CURVES[self.curve_id.value].Gy),
        )
        # Fastecdsa already returns (0, 0) for the identity element.
        if scalar < 0:
            return -G1Point(int(x), int(y), self.curve_id, self.iso_point)
        else:
            return G1Point(int(x), int(y), self.curve_id, self.iso_point)

    def add(self, other: "G1Point") -> "G1Point":
        """
        Adds two points on the elliptic curve.

        Args:
            other (G1Point): The other point to add.

        Returns:
            G1Point: The resulting point after addition.

        Raises:
            ValueError: If the points are not on the same curve.
        """
        if self.is_infinity():
            return other
        if other.is_infinity():
            return self
        if self.curve_id != other.curve_id:
            raise ValueError("Points are not on the same curve")
        if self.iso_point != other.iso_point:
            raise ValueError("Points are not on the same curve")
        if self.iso_point:
            a = CURVES[self.curve_id.value].swu_params.A
            b = CURVES[self.curve_id.value].swu_params.B
        else:
            a = CURVES[self.curve_id.value].a
            b = CURVES[self.curve_id.value].b

        x, y = curvemath.add(
            str(self.x),
            str(self.y),
            str(other.x),
            str(other.y),
            str(CURVES[self.curve_id.value].p),
            str(a),
            str(b),
            str(CURVES[self.curve_id.value].n),
            str(CURVES[self.curve_id.value].Gx),
            str(CURVES[self.curve_id.value].Gy),
        )
        # NB : Fastecdsa returns (0, 0) for the identity element.
        return G1Point(int(x), int(y), self.curve_id, self.iso_point)

    def __neg__(self) -> "G1Point":
        """
        Negates the point on the elliptic curve.

        Returns:
            G1Point: The negated point.
        """
        return G1Point(
            self.x,
            -self.y % CURVES[self.curve_id.value].p,
            self.curve_id,
            self.iso_point,
        )

    def to_pyfelt_list(self) -> list[PyFelt]:
        field = get_base_field(self.curve_id.value)
        return [field(self.x), field(self.y)]

    def serialize_to_cairo(self, name: str, raw: bool = False) -> str:
        import garaga.modulo_circuit_structs as structs

        return structs.G1PointCircuit(name=name, elmts=self.to_pyfelt_list()).serialize(
            raw
        )


@dataclass(frozen=True)
class G2Point:
    """
    Represents a point on G2, the group of rational points on an elliptic curve over an extension field.
    """

    x: tuple[int, int]
    y: tuple[int, int]
    curve_id: CurveID

    def __repr__(self):
        return f"G2Point({hex(self.x[0])}, {hex(self.x[1])}, {hex(self.y[0])}, {hex(self.y[1])}, {self.curve_id})"

    def __post_init__(self):
        assert isinstance(CURVES[self.curve_id.value], PairingCurve)
        if self.is_infinity():
            return
        if not self.is_on_curve():
            raise ValueError(f"G2 Point is not on the curve {self.curve_id}")

    @staticmethod
    def infinity(curve_id: CurveID) -> "G2Point":
        return G2Point((0, 0), (0, 0), curve_id)

    def __eq__(self, other: "G2Point") -> bool:
        return (
            self.x[0] == other.x[0]
            and self.x[1] == other.x[1]
            and self.y[0] == other.y[0]
            and self.y[1] == other.y[1]
            and self.curve_id == other.curve_id
        )

    def is_infinity(self) -> bool:
        return self.x == (0, 0) and self.y == (0, 0)

    def is_on_curve(self) -> bool:
        """
        Check if the point is on the curve using the curve equation y^2 = x^3 + ax + b in the extension field.
        """
        from garaga.hints.tower_backup import E2

        curve = CURVES[self.curve_id.value]
        assert isinstance(curve, PairingCurve)
        a = curve.a
        p = curve.p
        b = E2(curve.b20, curve.b21, p)
        y = E2(*self.y, p)
        x = E2(*self.x, p)
        return y**2 == x**3 + a * x + b

    @staticmethod
    def gen_random_point(curve_id: CurveID) -> "G2Point":
        """
        Generates a random point on a given curve.
        """
        from garaga import garaga_rs

        curve = CURVES[curve_id.value]
        assert isinstance(curve, PairingCurve)
        scalar = random.randint(1, curve.n - 1)
        a = (curve.G2x[0], curve.G2x[1], curve.G2y[0], curve.G2y[1])
        b = garaga_rs.g2_scalar_mul(curve_id.value, a, scalar)
        return G2Point((b[0], b[1]), (b[2], b[3]), curve_id)

    def is_in_prime_order_subgroup_generic(self) -> bool:
        return self.scalar_mul(CURVES[self.curve_id.value].n).is_infinity()

    def is_in_prime_order_subgroup(self) -> bool:
        if CURVES[self.curve_id.value].h == 1:
            # Cofactor is 1 : points on the curve <=> points in the prime order subgroup
            return self.is_on_curve() or self.is_infinity()
        else:
            if self.curve_id == CurveID.BLS12_381:
                # https://github.com/Consensys/gnark/blob/9ed0eab21e8935cb180d1f75713cd2c29c91a3c9/std/algebra/emulated/sw_bls12381/g2.go
                field = get_base_field(self.curve_id.value)
                seed_Q = self.scalar_mul(
                    -CURVES[self.curve_id.value].x
                )  # Note the negative sign.
                u1 = 0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAD
                v = Fp2(
                    field(
                        0x135203E60180A68EE2E9C448D77A2CD91C3DEDD930B1CF60EF396489F61EB45E304466CF3E67FA0AF1EE7B04121BDEA2
                    ),
                    field(
                        0x6AF0E0437FF400B6831E36D6BD17FFE48395DABC2D3435E77F76E17009241C5EE67992F72EC05F4C81084FBEDE3CC09
                    ),
                )

                psi_Qx = (
                    (field(self.x[1]) * u1).value,
                    (field(self.x[0]) * u1).value,
                )  # Note the reversal of x and y

                psi_Qy = Fp2(field(self.y[0]), -field(self.y[1])) * v

                psi_Qy = (psi_Qy.a0.value, psi_Qy.a1.value)

                psi_Q = G2Point(psi_Qx, psi_Qy, self.curve_id)

                # [r]Q == 0 <==>  ψ(Q) == [x₀]Q <=> ψ(Q) + [-x₀]Q = 0

                return psi_Q.add(seed_Q).is_infinity()
            else:
                return self.is_in_prime_order_subgroup_generic()

    @staticmethod
    def gen_random_point_not_in_subgroup(
        curve_id: CurveID, force_gen: bool = False
    ) -> "G2Point":
        """
        Generates a random point not in the prime order subgroup.

        Args:
            curve_id (CurveID): The identifier of the elliptic curve.
            force_gen (bool): Force generation even if the cofactor is 1.

        Returns:
            G2Point: A random point not in the prime order subgroup.

        Raises:
            ValueError: If the cofactor is 1 and force_gen is False.
        """
        curve_idx = curve_id.value
        if CURVES[curve_idx].h == 1:
            if force_gen:
                return G2Point.gen_random_point(curve_id)
            else:
                raise ValueError(
                    "Cofactor is 1, cannot generate a point not in the subgroup"
                )
        else:
            field = get_base_field(curve_idx)
            while True:
                x = field.random()
                y2 = x**3 + CURVES[curve_idx].a * x + CURVES[curve_idx].b
                try:
                    tentative_point = G1Point(x.value, y2.sqrt().value, curve_id)
                except ValueError:
                    continue
                if not tentative_point.is_in_prime_order_subgroup_generic():
                    return tentative_point

    @staticmethod
    def get_nG(curve_id: CurveID, n: int) -> "G2Point":
        """
        Returns the scalar multiplication of the generator point on a given curve by the scalar n.
        """
        from garaga import garaga_rs

        assert (
            n < CURVES[curve_id.value].n
        ), "n must be less than the order of the curve"

        if curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            curve = CURVES[curve_id.value]
            a = (curve.G2x[0], curve.G2x[1], curve.G2y[0], curve.G2y[1])
            b = garaga_rs.g2_scalar_mul(curve_id.value, a, n)
            return G2Point((b[0], b[1]), (b[2], b[3]), curve_id)
        else:
            raise NotImplementedError(
                "G2Point.get_nG is not implemented for this curve"
            )

    def scalar_mul(self, scalar: int) -> "G2Point":
        if self.is_infinity():
            return self
        if scalar == 0:
            return G2Point((0, 0), (0, 0), self.curve_id)
        if scalar < 0:
            return -self.scalar_mul(-scalar)
        if self.curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            from garaga import garaga_rs

            a = (self.x[0], self.x[1], self.y[0], self.y[1])
            b = garaga_rs.g2_scalar_mul(self.curve_id.value, a, scalar)
            return G2Point((b[0], b[1]), (b[2], b[3]), self.curve_id)
        else:
            raise NotImplementedError(
                "G2Point.scalar_mul is not implemented for this curve"
            )

    def add(self, other: "G2Point") -> "G2Point":
        if self.is_infinity():
            return other
        if other.is_infinity():
            return self
        if self.curve_id != other.curve_id:
            raise ValueError("Points are not on the same curve")
        if self.curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            from garaga import garaga_rs

            a = (self.x[0], self.x[1], self.y[0], self.y[1])
            b = (other.x[0], other.x[1], other.y[0], other.y[1])
            c = garaga_rs.g2_add(self.curve_id.value, a, b)
            return G2Point((c[0], c[1]), (c[2], c[3]), self.curve_id)
        else:
            raise NotImplementedError("G2Point.add is not implemented for this curve")

    def __neg__(self) -> "G2Point":
        p = CURVES[self.curve_id.value].p
        return G2Point(
            (self.x[0], self.x[1]), (-self.y[0] % p, -self.y[1] % p), self.curve_id
        )

    @staticmethod
    def msm(points: list["G2Point"], scalars: list[int]) -> "G2Point":
        assert all(isinstance(p, G2Point) for p in points)
        assert len(points) == len(scalars)
        muls = [P.scalar_mul(s) for P, s in zip(points, scalars)]
        scalar_mul = functools.reduce(lambda acc, p: acc.add(p), muls)
        return scalar_mul

    def to_pyfelt_list(self) -> list[PyFelt]:
        field = get_base_field(self.curve_id.value)
        return [field(x) for x in self.x + self.y]

    def serialize_to_cairo(self, name: str, raw: bool = False) -> str:
        import garaga.modulo_circuit_structs as structs

        return structs.G2PointCircuit(name=name, elmts=self.to_pyfelt_list()).serialize(
            raw
        )


@dataclass(slots=True)
class G1G2Pair:
    p: G1Point
    q: G2Point
    curve_id: CurveID = None

    def __hash__(self):
        return hash((self.p, self.q, self.curve_id))

    def __post_init__(self):
        if self.p.curve_id != self.q.curve_id:
            raise ValueError("Points are not on the same curve")
        self.curve_id = self.p.curve_id

    def to_pyfelt_list(self) -> list[PyFelt]:
        field = get_base_field(self.curve_id.value)
        return [
            field(x)
            for x in [
                self.p.x,
                self.p.y,
                self.q.x[0],
                self.q.x[1],
                self.q.y[0],
                self.q.y[1],
            ]
        ]

    @staticmethod
    def pair(pairs: list["G1G2Pair"], curve_id: CurveID = None):
        from garaga.hints.tower_backup import E12  # avoids cycle

        if curve_id is None:
            if len(pairs) == 0:
                raise ValueError("Unspecified curve")
            curve_id = pairs[0].curve_id
        if curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            from garaga import garaga_rs

            args = []
            for pair in pairs:
                if pair.curve_id != curve_id:
                    raise ValueError("Pairs are not on the same curve")
                args.append(pair.p.x)
                args.append(pair.p.y)
                args.append(pair.q.x[0])
                args.append(pair.q.x[1])
                args.append(pair.q.y[0])
                args.append(pair.q.y[1])
            res = garaga_rs.multi_pairing(curve_id.value, args)
            return E12(res, curve_id.value)
        else:
            raise NotImplementedError("G1G2Pair.pair is not implemented for this curve")

    @staticmethod
    def miller(pairs: list["G1G2Pair"], curve_id: CurveID = None):
        from garaga.hints.tower_backup import E12  # avoids cycle

        if curve_id is None:
            if len(pairs) == 0:
                raise ValueError("Unspecified curve")
            curve_id = pairs[0].curve_id
        if curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            from garaga import garaga_rs

            args = []
            for pair in pairs:
                if pair.curve_id != curve_id:
                    raise ValueError("Pairs are not on the same curve")
                args.append(pair.p.x)
                args.append(pair.p.y)
                args.append(pair.q.x[0])
                args.append(pair.q.x[1])
                args.append(pair.q.y[0])
                args.append(pair.q.y[1])
            res = garaga_rs.multi_miller_loop(curve_id.value, args)
            return E12(res, curve_id.value)
        else:
            raise NotImplementedError(
                "G1G2Pair.miller is not implemented for this curve"
            )


# v^6 - 18v^3 + 82
# w^12 - 18w^6 + 82
# v^6 - 2v^3 + 2
# w^12 - 2w^6 + 2


def tower_to_direct(
    X: list[PyFelt], curve_id: int, extension_degree: int
) -> list[PyFelt]:
    """
    Convert Tower to Direct extension field representation:
    T(u,v) = t0+t1u + (t2+t3u)v + (t4+t5u)v^2
    D(v) = d0+d1v+d2v^2+d3v^3+d4v^4+d5v^5

    Only tested with BN254 and BLS12_381 6th and 12th towers defined in this file.
    They were computed by hand then abstracted away with no guarantee of genericity under different tower constructions.
    """
    assert len(X) == extension_degree and isinstance(
        X[0], PyFelt
    ), f"len(X)={len(X)}, type(X[0])={type(X[0])}"
    if extension_degree == 2:
        return X
    if extension_degree == 6:
        return TD6(X, curve_id)
    elif extension_degree == 12:
        return TD12(X, curve_id)
    else:
        raise ValueError(f"Unsupported extension degree {extension_degree}")


def direct_to_tower(
    X: list[PyFelt | ModuloCircuitElement], curve_id: int, extension_degree: int
) -> list[PyFelt]:
    """
    Convert Direct to Tower extension field representation:
    Input : D(v) = d0+d1v+d2v^2+d3v^3+d4v^4+d5v^5
    Output: T(u,v) = t0+t1u + (t2+t3u)v + (t4+t5u)v^2

    Only tested with BN254 and BLS12_381 6th and 12th towers defined in this file.
    They were computed by hand then abstracted away with no guarantee of genericity under different tower constructions.
    """
    assert len(X) == extension_degree and isinstance(
        X[0], (PyFelt, ModuloCircuitElement)
    ), f"{type(X[0])}, len(X)={len(X)}"
    X = [x.felt for x in X]
    if extension_degree == 2:
        return X
    if extension_degree == 6:
        return DT6(X, curve_id)
    elif extension_degree == 12:
        return DT12(X, curve_id)
    else:
        raise ValueError(f"Unsupported extension degree {extension_degree}")


def TD6(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] - nr_a0 * X[1],
        X[2] - nr_a0 * X[3],
        X[4] - nr_a0 * X[5],
        X[1],
        X[3],
        X[5],
    ]


def DT6(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] + nr_a0 * X[3],
        X[3],
        X[1] + nr_a0 * X[4],
        X[4],
        X[2] + nr_a0 * X[5],
        X[5],
    ]


def TD12(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] - nr_a0 * X[1],
        X[6] - nr_a0 * X[7],
        X[2] - nr_a0 * X[3],
        X[8] - nr_a0 * X[9],
        X[4] - nr_a0 * X[5],
        X[10] - nr_a0 * X[11],
        X[1],
        X[7],
        X[3],
        X[9],
        X[5],
        X[11],
    ]


def DT12(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    X += (12 - len(X)) * [0]
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] + nr_a0 * X[6],
        X[6],
        X[2] + nr_a0 * X[8],
        X[8],
        X[4] + nr_a0 * X[10],
        X[10],
        X[1] + nr_a0 * X[7],
        X[7],
        X[3] + nr_a0 * X[9],
        X[9],
        X[5] + nr_a0 * X[11],
        X[11],
    ]


def precompute_lineline_sparsity(curve_id: int):
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    field = get_base_field(curve_id)
    line_sparsity = curve.line_function_sparsity
    line = Polynomial([field(x) for x in line_sparsity])
    ll = line * line % get_irreducible_poly(curve_id, 12)
    ll_sparsity = get_sparsity(ll.coefficients)
    return ll_sparsity[0:12]
