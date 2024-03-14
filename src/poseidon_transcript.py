from starkware.cairo.common.poseidon_utils import (
    PoseidonParams,
    hades_permutation,
)  ##only for testing times
from src.hints.io import bigint_split
from src.definitions import N_LIMBS, BASE
from src.algebra import PyFelt, ModuloCircuitElement
import hades_binding


class CairoPoseidonTranscript:
    """
    The CairoPoseidonTranscript class facilitates the emulation of Cairo's sequential hashing mechanism.
    Specifically, it sequentially computes hashes in the form of H = Poseidon(0, Poseidon(1, Poseidon(2, ...))).
    """

    def __init__(self, init_hash: int) -> None:
        self.params = (
            PoseidonParams.get_default_poseidon_params()
        )  # to remove after testing time
        self.continuable_hash = init_hash
        self.s1 = None
        self.permutations_count = 0
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

    def hash_value(self, x: int):
        s0, s1 = hades_binding.hades_permutation([str(x), str(self.continuable_hash)])
        self.continuable_hash = s0
        self.s1 = s1
        self.permutations_count += 1

        return self.s0, self.s1

    def hash_limbs_multi(
        self, X: list[PyFelt | ModuloCircuitElement], sparsity: list[int] = None
    ) -> tuple[int, int]:
        if sparsity:
            X = [x for i, x in enumerate(X) if sparsity[i] != 0]
        for X_elem in X:
            # print(f"Will Hash PYTHON {hex(X_elem.value)}")
            limbs = bigint_split(X_elem.value, N_LIMBS, BASE)
            for i in range(0, N_LIMBS, 2):
                combined_limbs = limbs[i] * limbs[i + 1]
                self.hash_value(combined_limbs)
        return self.continuable_hash, self.s1

    def test(self):
        return hades_permutation([1, 2, 3], self.params)

    # def generate_poseidon_assertions(
    #     self,
    #     continuable_hash_name: str,
    #     num_pairs: int,
    # ) -> str:
    #     cairo_code = ""
    #     for i in range(num_pairs):
    #         s0_index = i * 2
    #         s1_index = s0_index + 1
    #         if i == 0:
    #             s1_previous_output = continuable_hash_name
    #         else:
    #             s1_previous_output = f"poseidon_ptr[{i-1}].output.s0"
    #         cairo_code += (
    #             f"    assert poseidon_ptr[{i}].input = PoseidonBuiltinState(\n"
    #             f"        s0=range_check96_ptr[{s0_index}] * range_check96_ptr[{s1_index}], "
    #             f"s1={s1_previous_output}, s2=two\n"
    #             "    );\n"
    #         )
    #     return cairo_code


import time
from timeit import default_timer as timer

if __name__ == "__main__":
    print("done")
    transcript = CairoPoseidonTranscript(init_hash=0)

    start_time = time.time()
    for i in range(0, 10000):
        transcript.test()
    end_time = time.time()
    execution_time1 = (end_time - start_time) / 10000

    start_time = time.time()
    for i in range(0, 10000):
        hades_binding.hades_permutation(["1", "2"])
    end_time = time.time()
    execution_time2 = (end_time - start_time) / 10000

    print(f"hades_permutation execution time Python: {execution_time1} seconds")
    print(f"hades_permutation execution time rust: {execution_time2} seconds")
