from hydra.hints.io import bigint_split
from hydra.definitions import N_LIMBS, BASE, STARK
from hydra.algebra import PyFelt, ModuloCircuitElement

from starkware.cairo.common.poseidon_utils import (
    PoseidonParams,
    hades_permutation as hades_permutation_slow,
)  ##only for testing times

import hades_binding


def hades_permutation(s0: int, s1: int, s2: int) -> tuple[int, int, int]:
    r0, r1, r2 = hades_binding.hades_permutation(
        (s0 % STARK).to_bytes(32, "big"),
        (s1 % STARK).to_bytes(32, "big"),
        (s2 % STARK).to_bytes(32, "big"),
    )
    return (
        int.from_bytes(r0, "big"),
        int.from_bytes(r1, "big"),
        int.from_bytes(r2, "big"),
    )


class CairoPoseidonTranscript:
    """
    The CairoPoseidonTranscript class facilitates the emulation of Cairo's sequential hashing mechanism.
    Specifically, it sequentially computes hashes in the form of H = Poseidon(0, Poseidon(1, Poseidon(2, ...))).
    """

    def __init__(self, init_hash: int) -> None:
        self.init_hash = init_hash
        self.s0, self.s1, self.s2 = hades_permutation(
            init_hash,
            0,
            1,
        )
        self.permutations_count = 1
        self.poseidon_ptr_indexes = []
        self.z = None

    @property
    def continuable_hash(self) -> int:
        return self.s0

    @property
    def RLC_coeff(self):
        """
        A function to retrieve the random linear combination coefficient after a permutation.
        Stores the index of the last permutation in the poseidon_ptr_indexes list, to be used to retrieve RLC coefficients later.
        """
        self.poseidon_ptr_indexes.append(self.permutations_count - 1)
        return self.s1

    def hash_element(self, x: PyFelt | ModuloCircuitElement):
        # print(f"Will Hash PYTHON {hex(x.value)}")
        limbs = bigint_split(x.value, N_LIMBS, BASE)
        self.s0, self.s1, self.s2 = hades_permutation(
            self.s0 + limbs[0] + (BASE) * limbs[1],
            self.s1 + limbs[2] + (BASE) * limbs[3],
            self.s2,
        )
        self.permutations_count += 1

        return self.s0, self.s1

    def hash_limbs_multi(
        self, X: list[PyFelt | ModuloCircuitElement], sparsity: list[int] = None
    ):
        if sparsity:
            X = [x for i, x in enumerate(X) if sparsity[i] != 0]
        for X_elem in X:
            self.hash_element(X_elem)
        return None


if __name__ == "__main__":
    import time
    import random

    print("Running hades binding test against reference implementation")

    params = PoseidonParams.get_default_poseidon_params()

    random.seed(0)
    n_tests = 10000
    for i in range(n_tests):
        x0, x1, x2 = (
            random.randint(0, STARK - 1),
            random.randint(0, STARK - 1),
            random.randint(0, STARK - 1),
        )
        ref0, ref1, ref2 = hades_permutation_slow([x0, x1, x2], params)
        test0, test1, test2 = hades_permutation(x0, x1, x2)
        assert ref0 == test0 and ref1 == test1 and ref2 == test2

    print(f"{n_tests} random tests passed!")

    print("Running performance test...")
    start_time = time.time()
    for i in range(0, 10000):
        x = hades_permutation_slow([1, 2, 3], params)
    end_time = time.time()
    execution_time1 = (end_time - start_time) / 10000

    start_time = time.time()
    for i in range(0, 10000):
        x = hades_permutation(1, 2, 3)
    end_time = time.time()
    execution_time2 = (end_time - start_time) / 10000

    print(f"hades_permutation execution time Python: {execution_time1:2f} seconds")
    print(f"hades_permutation execution time rust: {execution_time2:2f} seconds")
