import random

import pytest

from garaga.algebra import PyFelt
from garaga.curves import CurveID
from garaga.extension_field_modulo_circuit import ExtensionFieldModuloCircuit
from garaga.modulo_circuit import ModuloCircuitElement, WriteOps


@pytest.fixture(
    params=[
        (CurveID.BN254, 6),
        (CurveID.BLS12_381, 6),
        (CurveID.BN254, 12),
        (CurveID.BLS12_381, 12),
    ]
)
def circuit(request) -> tuple[ExtensionFieldModuloCircuit, list[ModuloCircuitElement]]:
    curve_id, extension_degree = request.param

    def init_z_circuit(
        z: int = 2,
    ) -> tuple[ExtensionFieldModuloCircuit, list[ModuloCircuitElement]]:
        c = ExtensionFieldModuloCircuit(
            name="test", curve_id=curve_id.value, extension_degree=extension_degree
        )
        c.create_powers_of_Z(c.field(z))
        X = c.write_elements(
            [PyFelt(i + 1, c.field.p) for i in range(extension_degree)],
            operation=WriteOps.INPUT,
        )
        return c, X

    return init_z_circuit()


def test_eval(circuit: tuple[ExtensionFieldModuloCircuit, list[ModuloCircuitElement]]):
    c, X = circuit

    X_of_z = c.eval_poly_in_precomputed_Z(X)
    assert (
        X_of_z.value
        == sum((i + 1) * 2**i for i in range(c.extension_degree)) % c.field.p
    )
    assert len(c.z_powers) == c.extension_degree


def generate_random_sparsity(
    extension_degree: int, num_cases: int = 32
) -> list[list[int]]:
    sparsities = [
        [random.choice([0, 1, 2]) for _ in range(extension_degree)]
        for _ in range(num_cases)
    ]
    for sparsity in sparsities:
        if all(x == 0 for x in sparsity):
            # Make sure there is at least one non-zero element somewhere
            sparsity[random.randint(0, extension_degree - 1)] = random.choice([1, 2])
    return sparsities


def test_eval_sparse(
    circuit: tuple[ExtensionFieldModuloCircuit, list[ModuloCircuitElement]]
):
    c, X = circuit

    sparsities = generate_random_sparsity(c.extension_degree)
    for sparsity in sparsities:
        X_of_z = c.eval_poly_in_precomputed_Z(X, sparsity=sparsity)
        assert (
            X_of_z.value
            == (
                sum((i + 1) * 2**i for i, s in enumerate(sparsity) if s == 1)
                + sum(2**i for i, s in enumerate(sparsity) if s == 2)
            )
            % c.field.p
        )


if __name__ == "__main__":
    pytest.main()
