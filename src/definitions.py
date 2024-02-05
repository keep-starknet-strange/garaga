from src.algebra import Polynomial
from src.algebra import FieldElement, BaseField
from dataclasses import dataclass

STARK = 0x800000000000011000000000000000000000000000000000000000000000001

BN254 = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47
BLS12_381 = 0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB

BN254_ID = int.from_bytes(b"bn254", "big")
BLS12_381_ID = int.from_bytes(b"bls12_381", "big")

N_LIMBS = 4
BASE = 2**96

field_bn254 = BaseField(BN254)
field_bls12 = BaseField(BLS12_381)


@dataclass(slots=True, frozen=True)
class Curve:
    id: int
    base_field: BaseField
    p: int
    irreducible_poly_6: Polynomial
    irreducible_poly_12: Polynomial
    nr_a0: int
    nr_a1: int


def get_base_field(curve_id: int):
    if curve_id == BN254_ID:
        return field_bn254
    elif curve_id == BLS12_381_ID:
        return field_bls12


CURVES = {
    BN254_ID: Curve(
        id=BN254_ID,
        base_field=field_bn254,
        p=BN254,
        irreducible_poly_6=Polynomial(
            [
                FieldElement(82, BN254),
                field_bn254.zero(),
                field_bn254.zero(),
                FieldElement(-18 % BN254, BN254),
                field_bn254.zero(),
                field_bn254.zero(),
                field_bn254.one(),
            ]  # v^6 - 18v^3 + 82
        ),
        irreducible_poly_12=Polynomial(
            [
                FieldElement(82, BN254),
                field_bn254.zero(),
                field_bn254.zero(),
                field_bn254.zero(),
                field_bn254.zero(),
                field_bn254.zero(),
                FieldElement(-18 % BN254, field_bn254),
                field_bn254.zero(),
                field_bn254.zero(),
                field_bn254.zero(),
                field_bn254.zero(),
                field_bn254.zero(),
                field_bn254.one(),
            ]  # w^12 - 18w^6 + 82
        ),
        nr_a0=9,
        nr_a1=1,
    ),
    BLS12_381_ID: Curve(
        id=BLS12_381_ID,
        base_field=field_bls12,
        p=BLS12_381,
        irreducible_poly_6=Polynomial(
            [
                FieldElement(2, BLS12_381),
                field_bls12.zero(),
                field_bls12.zero(),
                FieldElement(-2, BLS12_381),
                field_bls12.zero(),
                field_bls12.zero(),
                field_bls12.one(),
            ]  # v^6 - 2v^3 + 2
        ),
        irreducible_poly_12=Polynomial(
            [
                FieldElement(2, BLS12_381),
                field_bls12.zero(),
                field_bls12.zero(),
                field_bls12.zero(),
                field_bls12.zero(),
                field_bls12.zero(),
                FieldElement(-2, BLS12_381),
                field_bls12.zero(),
                field_bls12.zero(),
                field_bls12.zero(),
                field_bls12.zero(),
                field_bls12.zero(),
                field_bls12.zero(),
            ]  # w^12 - 2w^6 + 2
        ),
        nr_a0=1,
        nr_a1=1,
    ),
}


def get_irreducible_poly6(curve: int) -> Polynomial:
    return CURVES[curve].irreducible_poly_6


def get_irreducible_poly12(curve: int) -> Polynomial:
    return CURVES[curve].irreducible_poly_12


def get_irreducible_poly(curve: int, extension_degree: int) -> Polynomial:
    if extension_degree == 6:
        return get_irreducible_poly6(curve)
    elif extension_degree == 12:
        return get_irreducible_poly12(curve)
    else:
        raise ValueError(
            f"Unsupported extension degree {extension_degree}. Must be 6 or 12"
        )
