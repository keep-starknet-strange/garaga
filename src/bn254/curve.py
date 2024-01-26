from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField


p = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47
STARK = 3618502788666131213697322783095070105623107215331596699973092056135872020481

field = BaseField(p)
N_LIMBS = 3
BASE = 2**86


IRREDUCIBLE_POLY_12 = Polynomial(
    [
        BaseFieldElement(82, field),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        BaseFieldElement(-18 % p, field),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        field.zero(),
        field.one(),
    ]
)

# v^6 - 18v^3 + 82
IRREDUCIBLE_POLY_6 = Polynomial(
    [
        BaseFieldElement(82, field),
        field.zero(),
        field.zero(),
        BaseFieldElement(-18 % p, field),
        field.zero(),
        field.zero(),
        field.one(),
    ]
)
