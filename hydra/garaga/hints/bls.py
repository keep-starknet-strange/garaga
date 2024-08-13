from math import gcd

from garaga.definitions import CURVES, CurveID
from garaga.hints.tower_backup import E12

"""
The goal of this script is to provide aux witness for efficient proving that Miller loop outputs of BLS12-381 curve are λ residues.
Co-factor h = 27 * p * h3 and λ = r * 3 * p^2.
We know that when pairings are equal multi Miller loop output is always r-th residue,
but it is λ residue only when it is a cube and p-th residue too.
This happens with a very small probability (1/3*p), but both 27th and p-th roots of unity are in the subfields of Fp12, Fp3 and Fp respectively.
Thus we can simply clear their contribution and not affect he soundness of the method.

Note that gcd(27*p, h3) = 1, therefore we do the following:

i := inverse_mod(h3, 27*p)
s := -i % 27*p

Then given the Miller loop output x, computing w = (x^h3)^s gives exactly the inverse of 27*p-th root of unity contribution in x.
By computing x_sh = w * x we are left with an element that is of order exactly h3.

Since gcd(h1, λ) = 1 computing λ root of x_sh can be simply done by just raising x_sh^e where e = inverse_mod(h3, λ)
"""

# Bls

x = CURVES[CurveID.BLS12_381.value].x
k = 12
r = x**4 - x**2 + 1
q = ((x - 1) ** 2) // 3 * r + x
h = (q**k - 1) // r

lam = -x + q
m = lam // r

p = 5044125407647214251
h3 = h // (27 * p)

e = pow(lam, -1, h3)
s = (-1 * pow(h3, -1, p * 27)) % (p * 27)


assert h % (27 * p) == 0
assert m == 3 * p**2

assert gcd(3, h3) == 1
assert gcd(p**2, h3) == 1
assert gcd(3, h3) == 1
assert gcd(p, h3) == 1
assert gcd(p, 27 * h3) == 1
assert gcd(27, p * h3) == 1

ONE = E12.one(curve_id=1)

assert (q**3 - 1) % 27 == 0


def get_root_and_scaling_factor_bls(mlo: E12) -> tuple[E12, E12]:
    """
    Takes a miller loop output and returns root, shift such that
    root**lam = shift * mlo, if and only if mlo**h == 1.
    """
    x = mlo**h3
    shift = x**s
    root = (shift * mlo) ** e
    return root, shift
