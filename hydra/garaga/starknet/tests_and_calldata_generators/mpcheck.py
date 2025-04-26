import functools
from dataclasses import dataclass
from functools import lru_cache

from garaga import garaga_rs
from garaga import modulo_circuit_structs as structs
from garaga.algebra import Polynomial, PyFelt
from garaga.definitions import CurveID, G1G2Pair, get_base_field, get_irreducible_poly
from garaga.poseidon_transcript import CairoPoseidonTranscript
from garaga.precompiled_circuits.multi_miller_loop import precompute_lines
from garaga.precompiled_circuits.multi_pairing_check import (
    MultiMillerLoopCircuit,
    MultiPairingCheckCircuit,
    WriteOps,
    get_max_Q_degree,
)


@dataclass(slots=True)
class MPCheckCalldataBuilder:
    curve_id: CurveID
    pairs: list[G1G2Pair]
    n_fixed_g2: int
    public_pair: G1G2Pair | None

    def __hash__(self):
        return hash(
            (self.curve_id, tuple(self.pairs), self.n_fixed_g2, self.public_pair)
        )

    def __post_init__(self):
        # Validate input
        assert isinstance(self.pairs, (list, tuple))
        assert all(
            isinstance(pair, G1G2Pair) for pair in self.pairs
        ), f"All pairs must be G1G2Pair, got {[type(pair) for pair in self.pairs]}"
        assert all(
            self.curve_id == pair.curve_id == self.pairs[0].curve_id
            for pair in self.pairs
        ), f"All pairs must be on the same curve, got {[pair.curve_id for pair in self.pairs]}"
        assert (
            isinstance(self.public_pair, G1G2Pair) or self.public_pair is None
        ), f"Extra pair must be G1G2Pair or None, got {self.public_pair}"
        assert len(self.pairs) >= 2
        assert 0 <= self.n_fixed_g2 <= len(self.pairs)

    @property
    def include_miller_loop_result(self):
        return self.public_pair is not None

    @property
    def field(self):
        return get_base_field(self.curve_id)

    @property
    def big_Q_expected_len(self):
        return get_max_Q_degree(self.curve_id.value, len(self.pairs)) + 1

    @lru_cache(maxsize=1)
    def extra_miller_loop_result(self) -> list[PyFelt] | None:
        if self.include_miller_loop_result:
            circuit = MultiMillerLoopCircuit(
                name="precompute M", curve_id=self.curve_id.value, n_pairs=1
            )
            circuit.write_p_and_q_raw(self.public_pair.to_pyfelt_list())
            M = circuit.miller_loop(n_pairs=1)
            return [mi.felt for mi in M]
        else:
            return None

    @lru_cache(maxsize=1)
    def lines(self) -> list[PyFelt]:
        lines = precompute_lines([pair.q for pair in self.pairs[0 : self.n_fixed_g2]])
        assert len(lines) % 4 == 0, f"Lines must be a multiple of 4, got {len(lines)}"
        return lines

    def _init_circuit(self) -> MultiPairingCheckCircuit:
        mpcheck_circuit = MultiPairingCheckCircuit(
            name="mpcheck",
            curve_id=self.curve_id.value,
            n_pairs=len(self.pairs),
            precompute_lines=bool(self.n_fixed_g2),
            n_points_precomputed_lines=self.n_fixed_g2,
        )

        mpcheck_circuit.precomputed_lines = mpcheck_circuit.write_elements(
            self.lines(), WriteOps.INPUT
        )
        mpcheck_circuit._precomputed_lines_generator = (
            mpcheck_circuit._create_precomputed_lines_generator()
        )

        p_q_input = []
        for pair in self.pairs:
            p_q_input.extend(pair.to_pyfelt_list())
        mpcheck_circuit.write_p_and_q_raw(p_q_input)
        return mpcheck_circuit

    def _retrieve_Pis_Qis_and_Ris_from_circuit(
        self, mpcheck_circuit: MultiPairingCheckCircuit
    ) -> tuple[list[list[PyFelt]], list[list[PyFelt]], list[list[PyFelt]]]:
        relations = mpcheck_circuit.accumulate_poly_instructions[0]
        Qis = relations.Qis
        Pis = relations.Pis
        Ris = relations.Ris
        return Pis, Qis, Ris

    def _get_passed_Ris_from_Ris(self, Ris: list[list[PyFelt]]) -> list[list[PyFelt]]:
        passed_Ris = (
            Ris if self.curve_id == CurveID.BLS12_381 else Ris[1:]
        )  # Skip first Ri for BN254 as it known to be one (lambda_root*lambda_root_inverse) result

        if self.public_pair is not None:
            passed_Ris = passed_Ris[
                :-1
            ]  # Skip last Ri as it is known to be 1 and we use FP12Mul_AssertOne circuit

        return passed_Ris

    def _init_transcript(self) -> CairoPoseidonTranscript:
        init_hash = (
            f"MPCHECK_{self.curve_id.name}_{len(self.pairs)}P_{self.n_fixed_g2}F"
        )
        transcript = CairoPoseidonTranscript(
            init_hash=int.from_bytes(init_hash.encode(), byteorder="big")
        )
        # Hash inputs.
        for pair in self.pairs:
            transcript.hash_limbs_multi(pair.to_pyfelt_list())
        return transcript

    def _hash_hints_and_get_base_random_rlc_coeff(
        self,
        transcript: CairoPoseidonTranscript,
        lambda_root: list[PyFelt],
        lambda_root_inverse: list[PyFelt],
        scaling_factor: list[PyFelt],
        scaling_factor_sparsity: list[PyFelt],
        Ris: list[list[PyFelt]],
    ):
        if self.curve_id == CurveID.BN254:
            transcript.hash_limbs_multi(lambda_root)

        transcript.hash_limbs_multi(lambda_root_inverse)
        transcript.hash_limbs_multi(scaling_factor, sparsity=scaling_factor_sparsity)

        for Ri in Ris:
            assert len(Ri) == 12
            transcript.hash_limbs_multi(Ri)

        return self.field(transcript.s1)

    def _hash_big_Q_and_get_z(
        self, transcript: CairoPoseidonTranscript, big_Q: list[PyFelt]
    ):
        transcript.hash_limbs_multi(big_Q)
        return self.field(transcript.s0)

    def _sanity_check_verify_rlc_equation(
        self,
        z: PyFelt,
        cis: list[PyFelt],
        Pis: list[list[PyFelt]],
        big_Q: Polynomial,
        Ris: list[list[PyFelt]],
    ):
        lhs = self.field.zero()
        for i, ci in enumerate(cis):
            Prod_Pis_of_z = functools.reduce(
                lambda x, y: x * y, [Polynomial(pi).evaluate(z) for pi in Pis[i]]
            )
            Ri_of_z = Polynomial(Ris[i]).evaluate(z)
            lhs += ci * (Prod_Pis_of_z - Ri_of_z)
            # print(f"lhs_{i} : {io.int_to_u384(lhs)}")

        P_irr = get_irreducible_poly(curve_id=self.curve_id, extension_degree=12)
        big_Q_of_z = big_Q.evaluate(z)
        P_of_z = P_irr.evaluate(z)
        # print(f"big_Q_of_z : {io.int_to_u384(big_Q_of_z)}")
        # print(f"P_of_z : {io.int_to_u384(P_of_z)}")
        assert lhs == big_Q_of_z * P_of_z, "Check failed."

    @lru_cache(maxsize=1)
    def build_mpcheck_hint(
        self,
    ) -> tuple[
        structs.Cairo1SerializableStruct, structs.Cairo1SerializableStruct | None
    ]:
        """
        Return MPCheckHint struct and small_Q struct if extra_miller_loop_result is True
        """
        mpcheck_circuit = self._init_circuit()
        transcript = self._init_transcript()

        _, lambda_root, lambda_root_inverse, scaling_factor, scaling_factor_sparsity = (
            mpcheck_circuit.multi_pairing_check(
                len(self.pairs), self.extra_miller_loop_result()
            )
        )
        Pis, Qis, Ris = self._retrieve_Pis_Qis_and_Ris_from_circuit(mpcheck_circuit)
        passed_Ris = self._get_passed_Ris_from_Ris(Ris)

        c0 = self._hash_hints_and_get_base_random_rlc_coeff(
            transcript,
            lambda_root,
            lambda_root_inverse,
            scaling_factor,
            scaling_factor_sparsity,
            passed_Ris,
        )

        n_relations_with_ci = len(passed_Ris) + (
            1 if self.curve_id == CurveID.BN254 else 0
        )

        ci, cis, big_Q = c0, [], Polynomial.zero(self.field.p)
        for i in range(n_relations_with_ci):
            # print(f"c_{i} : {io.int_to_u384(ci)}")
            cis.append(ci)
            big_Q += Qis[i] * ci
            ci *= ci

        big_Q_coeffs = big_Q.get_coeffs()
        big_Q_coeffs.extend(
            [self.field.zero()] * (self.big_Q_expected_len - len(big_Q_coeffs))
        )

        z = self._hash_big_Q_and_get_z(transcript, big_Q_coeffs)
        self._sanity_check_verify_rlc_equation(z, cis, Pis, big_Q, Ris)

        if self.public_pair is None:
            assert [x.value for x in passed_Ris[-1]] == [
                1,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
                0,
            ], f"Last Ri must be 1_Fp12, got {[x.value for x in passed_Ris[-1]]}"
            passed_Ris = passed_Ris[:-1]  # Skip last Ri as it is known to be 1

        if self.curve_id == CurveID.BN254:
            hint_struct_list_init = [
                structs.E12D(name="lambda_root", elmts=lambda_root)
            ]
        else:
            hint_struct_list_init = []

        if self.include_miller_loop_result:
            small_Q = Qis[-1].get_coeffs()
            small_Q = small_Q + [self.field.zero()] * (11 - len(small_Q))
            small_Q_struct = structs.E12DMulQuotient(name="small_Q", elmts=small_Q)
        else:
            small_Q_struct = None

        return (
            structs.Struct(
                struct_name=f"MPCheckHint{self.curve_id.name}",
                name="hint",
                elmts=hint_struct_list_init
                + [
                    structs.E12D(name="lambda_root_inverse", elmts=lambda_root_inverse),
                    structs.MillerLoopResultScalingFactor(
                        name="w",
                        elmts=[
                            wi
                            for wi, si in zip(scaling_factor, scaling_factor_sparsity)
                            if si != 0
                        ],
                    ),
                    structs.StructSpan(
                        name="Ris",
                        elmts=[
                            structs.E12D(name=f"R{i}", elmts=[ri.felt for ri in Ri])
                            for i, Ri in enumerate(passed_Ris)
                        ],
                    ),
                    structs.u384Array(name="big_Q", elmts=big_Q_coeffs),
                ]
                + [structs.felt252(name="z", elmts=[z])],
            ),
            small_Q_struct,
        )

    def _get_input_structs(self) -> list[structs.Cairo1SerializableStruct]:
        inputs = []
        for i, pair in enumerate(self.pairs):
            inputs.append(
                structs.G1G2PairCircuit(name=f"pair{i}", elmts=pair.to_pyfelt_list())
            )
        if self.include_miller_loop_result:
            inputs.append(
                structs.E12D(
                    name="precomputed_miller_loop_result",
                    elmts=self.extra_miller_loop_result(),
                )
            )
        if self.n_fixed_g2 > 0:
            lines = self.lines()
            inputs.append(
                structs.StructSpan(
                    name="lines",
                    elmts=[
                        structs.G2Line(name=f"line{i}", elmts=lines[i : i + 4])
                        for i in range(0, len(lines), 4)
                    ],
                )
            )
        mpcheck_hint, small_Q = self.build_mpcheck_hint()
        inputs.append(mpcheck_hint)
        if small_Q is not None:
            inputs.append(small_Q)
        return inputs

    def to_cairo_1_test(self):
        # print(
        #     f"Generating MPCheck test for {self.curve_id.name} with {len(self.pairs)} pairs and {self.n_fixed_g2} fixed G2 points, using extra Miller loop result: {self.include_miller_loop_result}"
        # )
        with_extra = (
            "_with_extra_miller_loop_result" if self.include_miller_loop_result else ""
        )
        fn_name = f"multi_pairing_check_{self.curve_id.name.lower()}_{len(self.pairs)}P_{self.n_fixed_g2}F{with_extra}"
        inputs = self._get_input_structs()

        test_name = f"test_{self.curve_id.name}_mpcheck_{len(self.pairs)}P_{self.n_fixed_g2}F{with_extra}"

        input_code = ""
        for struct in inputs:
            input_code += struct.serialize()

        code = f"""
        #[test]
        fn {test_name}() {{
            {input_code}
            let res = {fn_name}({', '.join([struct.name for struct in inputs])});
            assert!(res);
        }}
        """
        return code

    def _serialize_to_calldata_rust(self) -> list[int]:
        return garaga_rs.mpc_calldata_builder(
            self.curve_id.value,
            [element.value for pair in self.pairs for element in pair.to_pyfelt_list()],
            self.n_fixed_g2,
            (
                [element.value for element in self.public_pair.to_pyfelt_list()]
                if self.public_pair is not None
                else []
            ),
        )

    def serialize_to_calldata(
        self,
        use_rust=False,
    ) -> list[int]:
        if use_rust:
            return self._serialize_to_calldata_rust()

        mpcheck_hint, small_Q = self.build_mpcheck_hint()

        call_data: list[int] = []
        call_data.extend(mpcheck_hint.serialize_to_calldata())
        if small_Q is not None:
            call_data.extend(small_Q.serialize_to_calldata())

        return call_data
