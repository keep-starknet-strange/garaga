import hades_binding
from starkware.cairo.common.poseidon_utils import PoseidonParams
from starkware.cairo.common.poseidon_utils import \
    hades_permutation as hades_permutation_slow  # #only for testing times

from hydra.algebra import ModuloCircuitElement, PyFelt
from hydra.definitions import BASE, N_LIMBS, STARK
from hydra.hints.io import bigint_split


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
    The CairoPoseidonTranscript class mimics the behaviour of the Cairo functions hashing
    an array of u384 elements.
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

    def update_sponge_state(self, x, y):
        self.s0, self.s1, self.s2 = hades_permutation(self.s0 + x, self.s1 + y, self.s2)

    def hash_element(self, x: PyFelt | ModuloCircuitElement, debug: bool = False):
        # print(f"Will Hash PYTHON {hex(x.value)}")
        limbs = bigint_split(x.value, N_LIMBS, BASE)
        if debug:
            print(f"limbs : {limbs}")
        self.s0, self.s1, self.s2 = hades_permutation(
            self.s0 + limbs[0] + (BASE) * limbs[1],
            self.s1 + limbs[2] + (BASE) * limbs[3],
            self.s2,
        )
        self.permutations_count += 1

        return self.s0, self.s1

    def hash_u256(self, x: PyFelt | int):
        assert isinstance(x, (PyFelt, int))
        if isinstance(x, PyFelt):
            x = x.value
        assert 0 <= x < 2**256
        low, high = bigint_split(x, 2, 2**128)
        self.s0, self.s1, self.s2 = hades_permutation(
            self.s0 + low, self.s1 + high, self.s2
        )
        self.permutations_count += 1
        return self.s0

    def hash_u256_multi(self, X: list[PyFelt | int]):
        for x in X:
            self.hash_u256(x)
        return self.s0

    def hash_limbs_multi(
        self,
        X: list[PyFelt | ModuloCircuitElement],
        sparsity: list[int] = None,
        debug: bool = False,
    ):
        if sparsity:
            X = [x for i, x in enumerate(X) if sparsity[i] != 0]
        for X_elem in X:
            if debug:
                print(f"\t s0 : {self.s0}")
            self.hash_element(X_elem, debug=debug)
        return None


if __name__ == "__main__":
    import random
    import time

    random.seed(0)

    def bench_hades_permutation():
        print("Running hades binding test against reference implementation")

        params = PoseidonParams.get_default_poseidon_params()

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

    def gen_cairo_test_vectors(n_elmts: int):
        elmts = [PyFelt(random.randint(0, 2**384 - 1), 2**384) for _ in range(n_elmts)]
        transcript = CairoPoseidonTranscript(init_hash=0)
        for elmt in elmts:
            transcript.hash_element(elmt)
        expected_res = transcript.continuable_hash

        code = f"""
    #[test]
    fn test_hash_u384_{n_elmts}() {{
    """
        code += "// Auto-generated from hydra/poseidon_transcript.py\n"
        code += "let transcript: Array<u384> = array!["
        for elmt in elmts:
            limbs = bigint_split(elmt.value, N_LIMBS, BASE)
            code += f"u384 {{ limb0: {limbs[0]}, limb1: {limbs[1]}, limb2: {limbs[2]}, limb3: {limbs[3]} }},"
        code += "];\n"
        code += f"let expected_res: felt252 = {expected_res};\n"
        code += "let res = hash_u384_transcript(transcript.span(), 0);\n"
        code += "assert_eq!(res, expected_res);\n"
        code += "}\n\n"
        return code

    print(gen_cairo_test_vectors(1))
    print(gen_cairo_test_vectors(2))
    print(gen_cairo_test_vectors(3))
