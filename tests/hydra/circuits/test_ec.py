import pytest

from garaga.curves import CURVES, CurveID, get_base_field
from garaga.modulo_circuit import WriteOps
from garaga.points import G1Point, G2Point
from garaga.precompiled_circuits.ec import BasicEC, BasicECG2


@pytest.mark.parametrize("curve_id", [CurveID.BLS12_381])
def test_double_point_g1(curve_id: CurveID):
    g = G1Point.get_nG(curve_id, 1)
    circuit = BasicEC("test", 1)
    gxys = circuit.write_elements(g.to_pyfelt_list(), WriteOps.INPUT)
    field = get_base_field(CurveID.BLS12_381)
    A = CURVES[CurveID.BLS12_381.value].a
    a = circuit.write_element(field(A))

    resx, resy = circuit.double_point(gxys, a)

    got = G1Point(
        resx.value,
        resy.value,
        curve_id,
    )

    expected = G1Point.get_nG(CurveID.BLS12_381, 2)
    assert got == expected, f"{got} != {expected}"


@pytest.mark.parametrize("curve_id", [CurveID.BLS12_381])
def test_add_point_g1(curve_id: CurveID):
    g = G1Point.get_nG(curve_id, 1)
    h = G1Point.get_nG(curve_id, 2)
    circuit = BasicEC("test", 1)
    gxys = circuit.write_elements(g.to_pyfelt_list(), WriteOps.INPUT)
    hxys = circuit.write_elements(h.to_pyfelt_list(), WriteOps.INPUT)

    resx, resy = circuit.add_points(gxys, hxys)

    got = G1Point(
        resx.value,
        resy.value,
        curve_id,
    )

    expected = G1Point.get_nG(curve_id, 3)
    assert got == expected, f"{got} != {expected}"


@pytest.mark.parametrize("curve_id", [CurveID.BLS12_381])
def test_double_point_g2(curve_id: CurveID):
    # Arrange
    g = G2Point.get_nG(CurveID.BLS12_381, 1)
    circuit = BasicECG2("test", 1)
    gxys = circuit.write_elements(g.to_pyfelt_list(), WriteOps.INPUT)

    # Act
    resx, resy = circuit.double_point_a_eq_0((gxys[0:2], gxys[2:4]))

    # Assert
    got = G2Point(
        (resx[0].value, resx[1].value),
        (resy[0].value, resy[1].value),
        CurveID.BLS12_381,
    )
    expected = G2Point.get_nG(CurveID.BLS12_381, 2)
    assert got == expected, f"{got} != {expected}"


@pytest.mark.parametrize("curve_id", [CurveID.BLS12_381])
def test_add_point_g2(curve_id: CurveID):
    # Arrange
    g = G2Point.get_nG(curve_id, 1)
    h = G2Point.get_nG(curve_id, 2)
    circuit = BasicECG2("test", 1)
    gxys = circuit.write_elements(g.to_pyfelt_list(), WriteOps.INPUT)
    hxys = circuit.write_elements(h.to_pyfelt_list(), WriteOps.INPUT)

    # Act
    resx, resy = circuit.add_points((gxys[0:2], gxys[2:4]), (hxys[0:2], hxys[2:4]))

    # Assert
    got = G2Point(
        (resx[0].value, resx[1].value),
        (resy[0].value, resy[1].value),
        CurveID.BLS12_381,
    )

    expected = G2Point.get_nG(curve_id, 3)
    assert got == expected, f"{got} != {expected}"
