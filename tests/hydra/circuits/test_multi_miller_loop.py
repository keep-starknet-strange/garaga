import copy

import pytest

from garaga.curves import CurveID
from garaga.hints.extf_mul import nondeterministic_extension_field_mul_divmod
from garaga.modulo_circuit import WriteOps
from garaga.points import G1Point, G2Point
from garaga.precompiled_circuits.multi_miller_loop import (
    MultiMillerLoopCircuit,
    precompute_lines,
)


@pytest.fixture(
    params=[
        (CurveID.BN254, 1),
        (CurveID.BLS12_381, 1),
        (CurveID.BN254, 2),
        (CurveID.BLS12_381, 2),
        (CurveID.BN254, 3),
        (CurveID.BLS12_381, 3),
        (CurveID.BN254, 4),
        (CurveID.BLS12_381, 4),
    ]
)
def circuit_and_points(
    request,
) -> tuple[MultiMillerLoopCircuit, list[G1Point], list[G2Point]]:
    curve_id, n_pairs = request.param

    def init_miller_loop_circuit() -> (
        tuple[MultiMillerLoopCircuit, list[G1Point], list[G2Point]]
    ):
        circuit = MultiMillerLoopCircuit(
            name="test", curve_id=curve_id.value, n_pairs=n_pairs, hash_input=False
        )
        Ps = [G1Point.gen_random_point(curve_id) for _ in range(n_pairs)]
        Qs = [G2Point.gen_random_point(curve_id) for _ in range(n_pairs)]
        circuit.write_p_and_q(Ps, Qs)
        return circuit, Ps, Qs

    return init_miller_loop_circuit()


def test_precomputed_and_without_precompute_gives_same_output(
    circuit_and_points: tuple[MultiMillerLoopCircuit, list[G1Point], list[G2Point]]
):
    circuit0, Ps, Qs = circuit_and_points
    n_pairs = len(Ps)

    f0 = circuit0.miller_loop(n_pairs)
    f0 = [fi.felt for fi in f0]

    circuit1 = copy.deepcopy(circuit0)
    circuit1.precompute_lines = True
    circuit1.precomputed_lines = circuit1.write_elements(
        precompute_lines(Qs), WriteOps.INPUT
    )
    circuit1._precomputed_lines_generator = (
        circuit1._create_precomputed_lines_generator()
    )
    circuit1.n_points_precomputed_lines = n_pairs

    f1 = circuit1.miller_loop(n_pairs)
    f1 = [fi.felt for fi in f1]

    assert f0 == f1


def test_partially_precomputed_and_without_precompute_gives_same_output(
    circuit_and_points: tuple[MultiMillerLoopCircuit, list[G1Point], list[G2Point]]
):
    circuit0, Ps, Qs = circuit_and_points
    n_pairs = len(Ps)
    f0 = circuit0.miller_loop(n_pairs)
    f0 = [fi.felt for fi in f0]

    circuit1 = copy.deepcopy(circuit0)
    circuit1.precompute_lines = True
    circuit1.precomputed_lines = circuit1.write_elements(
        precompute_lines(Qs[: n_pairs // 2]), WriteOps.INPUT
    )
    circuit1._precomputed_lines_generator = (
        circuit1._create_precomputed_lines_generator()
    )
    circuit1.n_points_precomputed_lines = n_pairs // 2

    f1 = circuit1.miller_loop(n_pairs)
    f1 = [fi.felt for fi in f1]

    assert f0 == f1


def test_prod_miller_loop_equals_multi_miller_loop(
    circuit_and_points: tuple[MultiMillerLoopCircuit, list[G1Point], list[G2Point]]
):
    circuit_multi, Ps, Qs = circuit_and_points
    curve_id = circuit_multi.curve_id
    n_pairs = len(Ps)
    f0 = circuit_multi.miller_loop(n_pairs)
    f0 = [fi.felt for fi in f0]

    fis = []
    for i in range(n_pairs):
        circuit_prod_i = MultiMillerLoopCircuit(
            name="test", curve_id=curve_id, n_pairs=1, hash_input=False
        )
        circuit_prod_i.write_p_and_q(Ps[i : i + 1], Qs[i : i + 1])
        f_i = circuit_prod_i.miller_loop(1)

        fis.append(f_i)

    _, R = nondeterministic_extension_field_mul_divmod(fis, curve_id, 12)

    assert f0 == R
