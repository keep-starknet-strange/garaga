from dataclasses import dataclass

from garaga.algebra import PyFelt
from garaga.definitions import CURVES, CurveID, G1Point, get_base_field
from garaga.hints.io import bigint_split, int_to_u384
from garaga.signature import apply_isogeny, hash_to_field


@dataclass(slots=True)
class MapToCurveHint:
    gx1_is_square: bool
    y1: PyFelt
    y_flag: bool

    def to_cairo(self) -> str:
        return f"MapToCurveHint {{ gx1_is_square: {str(self.gx1_is_square).lower()}, y1: {int_to_u384(self.y1.value, as_hex=True)}, y_flag: {str(self.y_flag).lower()} }}"

    def to_calldata(self) -> list[int]:
        cd = []
        cd.append(int(self.gx1_is_square))
        cd.extend(bigint_split(self.y1.value))
        cd.append(int(self.y_flag))
        return cd


@dataclass(slots=True)
class HashToCurveHint:
    f0_hint: MapToCurveHint
    f1_hint: MapToCurveHint

    def to_cairo(self) -> str:
        return f"""HashToCurveHint {{ f0_hint: {self.f0_hint.to_cairo()},
        f1_hint: {self.f1_hint.to_cairo()} }}"""

    def to_calldata(self) -> list[int]:
        cd = []
        cd.extend(self.f0_hint.to_calldata())
        cd.extend(self.f1_hint.to_calldata())
        return cd


def build_map_to_curve_hint(u: PyFelt) -> tuple[G1Point, MapToCurveHint]:
    field = get_base_field(CurveID.BLS12_381)
    a = field(CURVES[CurveID.BLS12_381.value].swu_params.A)
    b = field(CURVES[CurveID.BLS12_381.value].swu_params.B)
    z = field(CURVES[CurveID.BLS12_381.value].swu_params.Z)

    zeta_u2 = z * u**2
    ta = zeta_u2**2 + zeta_u2
    num_x1 = b * (ta + field.one())

    if ta.value == 0:
        div = a * z
    else:
        div = a * -ta

    num2_x1 = num_x1**2
    div2 = div**2
    div3 = div2 * div
    assert div3.value != 0

    num_gx1 = (num2_x1 + a * div2) * num_x1 + b * div3
    num_x2 = zeta_u2 * num_x1

    gx1 = num_gx1 / div3
    gx1_square = gx1.is_quad_residue()
    if gx1_square:
        y1 = gx1.sqrt(min_root=False)
        assert y1 * y1 == gx1
    else:
        y1 = (z * gx1).sqrt(min_root=False)
        assert y1 * y1 == z * gx1

    y2 = zeta_u2 * u * y1
    y = y1 if gx1_square else y2
    y_flag = y.value % 2 == u.value % 2

    num_x = num_x1 if gx1_square else num_x2
    x_affine = num_x / div
    y_affine = -y if y.value % 2 != u.value % 2 else y

    point_on_curve = G1Point(
        x_affine.value, y_affine.value, CurveID.BLS12_381, iso_point=True
    )
    return point_on_curve, MapToCurveHint(
        gx1_is_square=gx1_square, y1=y1, y_flag=y_flag
    )


def build_hash_to_curve_hint(message: bytes) -> HashToCurveHint:
    felt0, felt1 = hash_to_field(message, 2, CurveID.BLS12_381.value, "sha256")
    pt0, f0_hint = build_map_to_curve_hint(felt0)
    pt1, f1_hint = build_map_to_curve_hint(felt1)
    sum_pt = pt0.add(pt1)
    # print(
    #     f"sum_pt: {int_to_u384(sum_pt.x, as_hex=False)} {int_to_u384(sum_pt.y, as_hex=False)}"
    # )
    sum_pt = apply_isogeny(sum_pt)
    # print(
    #     f"sum_pt: {int_to_u384(sum_pt.x, as_hex=False)} {int_to_u384(sum_pt.y, as_hex=False)}"
    # )
    x = CURVES[CurveID.BLS12_381.value].x
    n = CURVES[CurveID.BLS12_381.value].n
    cofactor = (1 - (x % n)) % n  # 15132376222941642753
    # print(f"cofactor: {cofactor}, hex :{hex(cofactor)}")

    return HashToCurveHint(
        f0_hint=f0_hint,
        f1_hint=f1_hint,
    )


if __name__ == "__main__":
    field = get_base_field(CurveID.BLS12_381)

    import hashlib

    hint = build_hash_to_curve_hint(hashlib.sha256(b"Hello, World!").digest())
    print(hint.to_cairo())
    # print(hint.to_calldata())
