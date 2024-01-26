import numpy as np
from dataclasses import dataclass


def inv_e2(a: (int, int), p: int) -> (int, int):
    t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
    t0 = (t0 + t1) % p
    t1 = pow(t0, -1, p)
    return a[0] * t1 % p, -(a[1] * t1) % p


@dataclass
class E2:
    a0: int
    a1: int
    p: int

    def __str__(self) -> str:
        return f"{np.base_repr(self.a0, 36)} + {np.base_repr(self.a1, 36)}*u"

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
        result = (1, 0)  # Initialize result as the multiplicative identity in F_p^2.
        temp = self.copy()  # Initialize temp as self.

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
