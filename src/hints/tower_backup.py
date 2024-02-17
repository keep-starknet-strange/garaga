import numpy as np
from dataclasses import dataclass
from src.definitions import CURVES
from src.algebra import PyFelt


@dataclass(slots=True)
class E2:
    a0: int
    a1: int
    p: int

    def __str__(self) -> str:
        return f"({(self.a0)} + {self.a1}*u)"

    def __eq__(self, other):
        return self.a0 == other.a0 and self.a1 == other.a1

    @staticmethod
    def zero(p: int):
        return E2(0, 0, p)

    @staticmethod
    def one(p: int):
        return E2(1, 0, p)

    def __add__(self, other):
        if isinstance(other, E2):
            return E2(
                (self.a0 + other.a0) % self.p, (self.a1 + other.a1) % self.p, self.p
            )
        elif isinstance(other, int):
            return E2((self.a0 + other) % self.p, (self.a1 + other) % self.p, self.p)
        return NotImplemented

    def __radd__(self, other):
        return self.__add__(other)

    def __sub__(self, other):
        if isinstance(other, E2):
            return E2(
                (self.a0 - other.a0) % self.p, (self.a1 - other.a1) % self.p, self.p
            )
        elif isinstance(other, int):
            return E2((self.a0 - other) % self.p, (self.a1 - other) % self.p, self.p)
        return NotImplemented

    def __rsub__(self, other):
        return self.__neg__().__add__(other)

    def __mul__(self, other):
        if isinstance(other, E2):
            a = (self.a0 + self.a1) * (other.a0 + other.a1) % self.p
            b, c = self.a0 * other.a0 % self.p, self.a1 * other.a1 % self.p
            return E2((b - c) % self.p, (a - b - c) % self.p, self.p)
        elif isinstance(other, int):
            return E2(self.a0 * other % self.p, self.a1 * other % self.p, self.p)
        return NotImplemented

    def __rmul__(self, other):
        return self.__mul__(other)

    def __inv__(self):
        t0, t1 = (self.a0 * self.a0 % self.p, self.a1 * self.a1 % self.p)
        t0 = (t0 + t1) % self.p
        t1 = pow(t0, -1, self.p)
        return E2(self.a0 * t1 % self.p, -(self.a1 * t1) % self.p, self.p)

    def __pow__(self, p: int):
        """
        Compute x**p in F_p^2 using square-and-multiply algorithm.
        Args:
        p: The exponent, a non-negative integer.
        Returns:
        x**p in F_p^2, represented similarly as x.
        """
        assert isinstance(p, int) and p >= 0

        # Handle the easy cases.
        if p == 0:
            # x**0 = 1, where 1 is the multiplicative identity in F_p^2.
            return E2(1, 0, self.p)
        elif p == 1:
            # x**1 = x.
            return self

        # Start the computation.
        result = self.one(
            self.p
        )  # Initialize result as the multiplicative identity in F_p^2.
        temp = self  # Initialize temp as self.

        # Loop through each bit of the exponent p.
        for bit in reversed(bin(p)[2:]):  # [2:] to strip the "0b" prefix.
            if bit == "1":
                result = result * temp
            temp = temp * temp

        return result

    def __truediv__(self, other):
        if isinstance(other, E2):
            return self * other.__inv__()
        elif isinstance(other, int):
            return self * pow(other, -1, self.p)

        return NotImplemented

    def __rtruediv__(self, other):
        if isinstance(other, E2):
            return other * self.__inv__()
        elif isinstance(other, int):
            return other * self.__inv__()

        return NotImplemented

    def __neg__(self):
        return E2(-self.a0 % self.p, -self.a1 % self.p, self.p)

    def conjugate(self):
        return E2(self.a0, -self.a1 % self.p, self.p)


@dataclass(slots=True, init=False)
class E6:
    b0: E2
    b1: E2
    b2: E2
    curve_id: int
    non_residue: E2

    def __init__(self, x: list[int | PyFelt | E2], curve_id: int):
        curve = CURVES[curve_id]
        self.curve_id = curve_id
        self.non_residue = E2(curve.nr_a0, curve.nr_a1, curve.p)
        if type(x[0]) == int:
            self.b0 = E2(x[0], x[1], curve.p)
            self.b1 = E2(x[2], x[3], curve.p)
            self.b2 = E2(x[4], x[5], curve.p)
        elif type(x[0]) == E2:
            self.b0 = x[0]
            self.b1 = x[1]
            self.b2 = x[2]
        elif type(x[0]) == PyFelt:
            self.b0 = E2(x[0].value, x[1].value, curve.p)
            self.b1 = E2(x[2].value, x[3].value, curve.p)
            self.b2 = E2(x[4].value, x[5].value, curve.p)
        else:
            raise ValueError(f"Invalid type {type(x[0])}")

    @property
    def coeffs(self) -> list[int]:
        return [self.b0.a0, self.b0.a1, self.b1.a0, self.b1.a1, self.b2.a0, self.b2.a1]

    @property
    def felt_coeffs(self) -> list[PyFelt]:
        return [PyFelt(c, self.b0.p) for c in self.coeffs]

    @staticmethod
    def zero(p: int, non_residue: E2):
        return E6(E2.zero(p), E2.zero(p), E2.zero(p), non_residue)

    def __str__(self) -> str:
        return f"{self.b0} + {self.b1}*v + {self.b2}*v^2"

    def __add__(self, other):
        if isinstance(other, E6):
            return E6(
                [self.b0 + other.b0, self.b1 + other.b1, self.b2 + other.b2],
                self.curve_id,
            )
        raise NotImplementedError

    def __sub__(self, other):
        if isinstance(other, E6):
            return E6(
                [self.b0 - other.b0, self.b1 - other.b1, self.b2 - other.b2],
                self.curve_id,
            )
        raise NotImplementedError

    def __neg__(self):
        return E6([-self.b0, -self.b1, -self.b2], self.curve_id)

    def __mul__(self, other):
        if isinstance(other, E6):
            x0, x1, x2 = self.b0, self.b1, self.b2
            y0, y1, y2 = other.b0, other.b1, other.b2

            t0 = x0 * y0
            t1 = x1 * y1
            t2 = x2 * y2

            c0 = t0 + self.non_residue * ((x1 + x2) * (y1 + y2) - t1 - t2)
            c1 = (x0 + x1) * (y0 + y1) - t0 - t1 + self.non_residue * t2
            c2 = (x0 + x2) * (y0 + y2) - t0 - t2 + t1
            return E6([c0, c1, c2], self.curve_id)
        raise NotImplementedError

    def __rmul__(self, other):
        return self.__mul__(other)

    def __inv__(self):
        t0, t1, t2 = self.b0 * self.b0, self.b1 * self.b1, self.b2 * self.b2
        t3, t4, t5 = self.b0 * self.b1, self.b0 * self.b2, self.b1 * self.b2
        c0 = t0 - self.non_residue * t5
        c1 = self.non_residue * t2 - t3
        c2 = t1 - t4
        t6 = self.b0 * c0
        d1 = self.b2 * c1
        d2 = self.b1 * c2
        d1 = self.non_residue * (d1 + d2)
        t6 = t6 + d1
        t6 = t6.__inv__()
        return E6([c0 * t6, c1 * t6, c2 * t6], self.curve_id)

    def mul_by_non_residue(self):
        return E6([self.non_residue * self.b2, self.b0, self.b1], self.curve_id)

    def square_torus(self):
        # SQ = 1/2(x+ v/x) <=> v = x (2SQ - x)
        one_over_2 = E6([pow(2, -1, self.b0.p), 0, 0, 0, 0, 0], self.curve_id)
        v = E6([0, 0, 1, 0, 0, 0], self.curve_id)
        x_inv = self.__inv__()
        v_x_inv = v * x_inv
        sq = one_over_2 * (self + v_x_inv)
        return sq

    def div(self, other):
        if isinstance(other, E6):
            return self * other.__inv__()
        return NotImplementedError


@dataclass(slots=True, init=False)
class E12:
    c0: E6
    c1: E6
    curve_id: int

    @property
    def coeffs(self) -> list[int]:
        return [
            self.c0.b0.a0,
            self.c0.b0.a1,
            self.c0.b1.a0,
            self.c0.b1.a1,
            self.c0.b2.a0,
            self.c0.b2.a1,
            self.c1.b0.a0,
            self.c1.b0.a1,
            self.c1.b1.a0,
            self.c1.b1.a1,
            self.c1.b2.a0,
            self.c1.b2.a1,
        ]

    @property
    def felt_coeffs(self) -> list[PyFelt]:
        return [PyFelt(c, self.c0.b0.p) for c in self.coeffs]

    def __init__(self, x: list[PyFelt | E6], curve_id: int):
        self.curve_id = curve_id
        if type(x[0]) == PyFelt and len(x) == 12:
            self.c0 = E6(x=x[0:6], curve_id=curve_id)
            self.c1 = E6(x=x[6:12], curve_id=curve_id)
        elif type(x[0] == E6 and len(x) == 2):
            self.c0 = x[0]
            self.c1 = x[1]
        else:
            raise ValueError

    def __mul__(self, other):
        if isinstance(other, E12):
            a = self.c0 + self.c1
            b = other.c0 + other.c1
            a = a * b
            b = self.c0 * other.c0
            c = self.c1 * other.c1
            z1 = a - b - c
            c = c.mul_by_non_residue()
            z0 = c + b
            return E12([z0, z1], self.curve_id)

    def __inv__(self):
        t0, t1 = self.c0 * self.c0, self.c1 * self.c1
        tmp = t1.mul_by_non_residue()
        t0 = t0 - tmp
        t1 = t0.__inv__()
        c0 = self.c0 * t1
        c1 = -self.c1 * t1
        return E12([c0, c1], curve_id=self.curve_id)

    def div(self, other):
        if isinstance(other, E12):
            return self * other.__inv__()
        raise NotImplementedError


def get_tower_object(x: list[PyFelt], curve_id: int, extension_degree: int):
    if extension_degree == 6:
        return E6(x, curve_id)
    elif extension_degree == 12:
        return E12(x, curve_id)
    else:
        raise ValueError
