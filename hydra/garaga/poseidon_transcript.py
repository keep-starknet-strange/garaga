from typing import Iterable

from garaga import garaga_rs
from garaga.algebra import ModuloCircuitElement, PyFelt
from garaga.curves import BASE, N_LIMBS, STARK
from garaga.hints.io import bigint_split


def hades_permutation(s0: int, s1: int, s2: int) -> tuple[int, int, int]:
    r0, r1, r2 = garaga_rs.hades_permutation(
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

    def __init__(self, init_hash: int, three_limbs_only: bool = False) -> None:
        self.init_hash = init_hash
        self.s0, self.s1, self.s2 = hades_permutation(
            0,
            0,
            init_hash,
        )
        self.permutations_count = 1
        self.poseidon_ptr_indexes = []
        self.z = None
        self.three_limbs_only = three_limbs_only

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
        limbs = bigint_split(x, N_LIMBS, BASE)
        if debug:
            print(f"limbs : {limbs}")
        self.s0, self.s1, self.s2 = hades_permutation(
            self.s0 + limbs[0] + (BASE) * limbs[1],
            self.s1 + limbs[2] + (BASE) * limbs[3],
            self.s2,
        )
        self.permutations_count += 1

        return self.s0, self.s1

    def hash_quadruple_u288(
        self, x: Iterable[PyFelt | ModuloCircuitElement], debug: bool = False
    ):
        assert len(x) == 4
        x = [bigint_split(xi, 3, BASE) for xi in x]
        self.s0, self.s1, self.s2 = hades_permutation(
            self.s0 + x[0][0] + (BASE) * x[0][1],
            self.s1 + x[0][2] + (BASE) * x[1][0],
            self.s2,
        )
        self.s0, self.s1, self.s2 = hades_permutation(
            self.s0 + x[1][1] + (BASE) * x[1][2],
            self.s1 + x[2][0] + (BASE) * x[2][1],
            self.s2,
        )

        self.s0, self.s1, self.s2 = hades_permutation(
            self.s0 + x[2][2] + (BASE) * x[3][0],
            self.s1 + x[3][1] + (BASE) * x[3][2],
            self.s2,
        )

        self.permutations_count += 3
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

    def hash_u128(self, x: PyFelt | int):
        assert isinstance(x, (PyFelt, int))
        if isinstance(x, PyFelt):
            x = x.value
        assert 0 <= x < 2**128
        self.s0, self.s1, self.s2 = hades_permutation(self.s0 + x, self.s1, self.s2)
        self.permutations_count += 1
        return self.s0

    def hash_u256_multi(self, X: list[PyFelt | int]):
        for x in X:
            self.hash_u256(x)
        return self.s0

    def hash_limbs_multi(
        self,
        X: list[PyFelt | ModuloCircuitElement],
        sparsity: list[int] | None = None,
        debug: bool = False,
        three_limbs_only: bool = None,
    ):
        if three_limbs_only in [True, False]:
            three_limbs_only = three_limbs_only
        else:
            three_limbs_only = self.three_limbs_only
        if sparsity:
            X = [x for i, x in enumerate(X) if sparsity[i] != 0]
        if not three_limbs_only:
            for X_elem in X:
                if debug:
                    print(f"\t s0 : {self.s0}")
                self.hash_element(X_elem, debug=debug)
        else:
            n_quadruples, rest = divmod(len(X), 4)
            for i in range(n_quadruples):
                self.hash_quadruple_u288(X[i * 4 : (i + 1) * 4], debug=debug)
            for i in range(rest):
                self.hash_element(X[n_quadruples * 4 + i], debug=debug)
        return None


if __name__ == "__main__":
    import random

    random.seed(0)

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
        code += "// Auto-generated from garaga/poseidon_transcript.py\n"
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
