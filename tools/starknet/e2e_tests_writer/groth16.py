import functools
from dataclasses import dataclass

from hydra import modulo_circuit_structs as structs
from hydra.algebra import Polynomial
from hydra.definitions import CurveID, G1G2Pair, get_irreducible_poly
from hydra.poseidon_transcript import CairoPoseidonTranscript
from hydra.precompiled_circuits.multi_miller_loop import precompute_lines
from hydra.precompiled_circuits.multi_pairing_check import (
    MultiMillerLoopCircuit,
    MultiPairingCheckCircuit,
    WriteOps,
    get_max_Q_degree,
)
from tools.starknet.e2e_tests_writer.pairing_check import MultiPairingCheck2PairsInput


@dataclass
class Groth16Input(MultiPairingCheck2PairsInput):
    pair2: structs.G1G2PairCircuit = None
    precomputed_miller_loop_result: structs.E12D = None
    small_Q: structs.E12DMulQuotient = None
    lines: structs.StructArray[structs.G2Line] = None

    def to_cairo1_test(self, test_name: str = None):
        n_pairs = 3

        input_code = ""
        struct_list = [
            self.pair0,
            self.pair1,
            self.pair2,
            self.lambda_root,
            self.lambda_root_inverse,
            self.w,
            self.Ris,
            self.lines,
            self.big_Q,
            self.precomputed_miller_loop_result,
            self.small_Q,
        ]
        if self.curve_id == CurveID.BLS12_381:
            struct_list.remove(self.lambda_root)

        struct_names = [
            struct.name + (".span()" if struct.name in ["Ris", "lines"] else "")
            for struct in struct_list
        ]
        for struct in struct_list:
            input_code += struct.serialize()

        test_name = (
            test_name if test_name else f"test_{CurveID(self.curve_id).name}_groth16"
        )

        code = f"""
        #[test]
        fn {test_name}() {{
            {input_code}
            let res = multi_pairing_check_groth16_{self.curve_id.name.lower()}({', '.join(struct_names)});
            assert!(res);
        }}
        """
        return code


def groth16_calldata(
    pairs: list[G1G2Pair],
    public_pair: G1G2Pair,
) -> Groth16Input:
    # Validate input
    assert isinstance(pairs, (list, tuple))
    assert all(
        isinstance(pair, G1G2Pair) for pair in pairs
    ), f"All pairs must be G1G2Pair, got {[type(pair) for pair in pairs]}"
    assert all(
        pair.curve_id == pairs[0].curve_id for pair in pairs
    ), f"All pairs must be on the same curve, got {[pair.curve_id for pair in pairs]}"
    assert (
        isinstance(public_pair, G1G2Pair) or public_pair is None
    ), f"Extra pair must be G1G2Pair or None, got {public_pair}"

    assert len(pairs) == 3, f"Groth16 must have 3 pairs, got {len(pairs)}"

    curve_id = pairs[0].curve_id

    # Precompute M = miller_loop(public_pair)
    circuit = MultiMillerLoopCircuit(
        name="precompute M", curve_id=curve_id.value, n_pairs=1
    )
    circuit.write_p_and_q_raw(public_pair.to_pyfelt_list())
    M = circuit.miller_loop(n_pairs=1)
    M = [mi.felt for mi in M]

    # Precompute lines :
    lines = precompute_lines([pair.q for pair in pairs[0:2]])
    assert len(lines) % 4 == 0, f"Lines must be a multiple of 4, got {len(lines)}"

    mpcheck_circuit = MultiPairingCheckCircuit(
        name="mpcheck",
        curve_id=curve_id.value,
        n_pairs=len(pairs),
        precompute_lines=True,
        n_points_precomputed_lines=2,
    )

    mpcheck_circuit.precomputed_lines = mpcheck_circuit.write_elements(
        lines, WriteOps.INPUT
    )
    mpcheck_circuit._precomputed_lines_generator = (
        mpcheck_circuit._create_precomputed_lines_generator()
    )

    p_q_input = []
    for pair in pairs:
        p_q_input.extend(pair.to_pyfelt_list())

    mpcheck_circuit.write_p_and_q_raw(p_q_input)

    _, lambda_root, lambda_root_inverse, scaling_factor, scaling_factor_sparsity = (
        mpcheck_circuit.multi_pairing_check(len(pairs), M)
    )

    relations = mpcheck_circuit.accumulate_poly_instructions[0]
    # print(relations.n)
    # print(len(relations.Ris))

    init_hash = f"GROTH16_{curve_id.name}"
    # print(f"init_hash : {init_hash}")
    hasher = CairoPoseidonTranscript(
        init_hash=int.from_bytes(init_hash.encode(), byteorder="big")
    )
    # print(f"s0 init : {hasher.s0}")
    # Hash Inputs
    for i, pair in enumerate(pairs):
        hasher.hash_limbs_multi(pair.to_pyfelt_list())
        # print(f"s0 after pair {i} : {hasher.s0}")
    if curve_id == CurveID.BN254:
        hasher.hash_limbs_multi(lambda_root)

    hasher.hash_limbs_multi(lambda_root_inverse)
    # print(f"s0 after lambda root : {hasher.s0}")
    hasher.hash_limbs_multi(scaling_factor, sparsity=scaling_factor_sparsity)
    # print(f"s0 after scaling factor : {hasher.s0}")
    # Hash Ri's to derive c0
    passed_Ris = (
        relations.Ris if curve_id == CurveID.BLS12_381 else relations.Ris[1:]
    )  # Skip first Ri for BN254 as it known to be one (lambda_root*lambda_root_inverse) result
    passed_Ris = passed_Ris[:-1]  # Skip last Ri as it is known to be 1.
    n_relations_with_ci = len(passed_Ris) + (1 if curve_id == CurveID.BN254 else 0)
    # print(f"len(passed_Ris) : {len(passed_Ris)}")
    for i, Ri in enumerate(passed_Ris):
        # assert Ri_sparsity == None, f"R{i} is not sparse, got {Ri_sparsity}"
        hasher.hash_limbs_multi(Ri)
    c0 = hasher.s1
    # print(f"c0 : {c0}")

    # Compute ci's where ci = c0^(2^i)
    field = mpcheck_circuit.field
    cis = [field(c0)]

    for i in range(n_relations_with_ci - 1):
        cis.append(cis[-1] * cis[-1])
        # print(f"c_{i+1} : {io.int_to_u384(cis[-1], as_hex=False)}")
    assert len(cis) == n_relations_with_ci, f"Wrong number of cis, got {len(cis)}"

    # print(f"len(cis) : {len(cis)}, last ci : {cis[-1].value} {io.int_to_u384(cis[-1])}")
    # Compute Big Q : sum(ci*Qi) for i in [0, n - 2]
    big_Q_expected_len = get_max_Q_degree(curve_id.value, len(pairs)) + 1
    big_Q = Polynomial([field.zero()])
    for i, ci in enumerate(cis):
        big_Q += relations.Qis[i] * ci
    big_Q_coeffs = big_Q.get_coeffs()
    big_Q_coeffs = big_Q_coeffs + [field.zero()] * (
        big_Q_expected_len - len(big_Q_coeffs)
    )
    assert len(big_Q_coeffs) == big_Q_expected_len
    # print(f"big_Q_coeffs : {io.int_to_u384(big_Q_coeffs[0])}")
    hasher.hash_limbs_multi(big_Q_coeffs)
    z = hasher.s0
    # print(f"z : {z}")
    z = field(z)

    lhs = field.zero()

    for i, ci in enumerate(cis):
        Pis = relations.Pis[i]
        Prod_Pis_of_z = functools.reduce(
            lambda x, y: x * y, [Polynomial(pi).evaluate(z) for pi in Pis]
        )
        Ri_of_z = Polynomial(relations.Ris[i]).evaluate(z)
        lhs += ci * (Prod_Pis_of_z - Ri_of_z)
        # print(f"lhs_{i} : {io.int_to_u384(lhs, as_hex=False)}")

    P_irr = get_irreducible_poly(curve_id.value, 12)
    big_Q_of_z = big_Q.evaluate(z)
    P_of_z = P_irr.evaluate(z)
    # print(f"big_Q_of_z : {io.int_to_u384(big_Q_of_z)}")
    # print(f"P_of_z : {io.int_to_u384(P_of_z)}")
    assert lhs == big_Q_of_z * P_of_z
    # print(len(relations.Ris))
    small_Q = relations.Qis[-1].get_coeffs()
    small_Q = small_Q + [field.zero()] * (11 - len(small_Q))

    pairs_structs = [None, None, None]
    for i, pair in enumerate(pairs):
        pairs_structs[i] = structs.G1G2PairCircuit(
            name=f"pair{i}", elmts=pair.to_pyfelt_list()
        )

    return Groth16Input(
        curve_id=curve_id,
        pair0=pairs_structs[0],
        pair1=pairs_structs[1],
        pair2=pairs_structs[2],
        lambda_root=structs.E12D(name="lambda_root", elmts=lambda_root),
        lambda_root_inverse=structs.E12D(
            name="lambda_root_inverse", elmts=lambda_root_inverse
        ),
        w=structs.MillerLoopResultScalingFactor(
            name="w",
            elmts=[
                wi for wi, si in zip(scaling_factor, scaling_factor_sparsity) if si != 0
            ],
        ),
        Ris=structs.StructArray(
            name="Ris",
            elmts=[
                structs.E12D(name=f"R{i}", elmts=[ri.felt for ri in Ri])
                for i, Ri in enumerate(passed_Ris)
            ],
        ),
        lines=structs.StructArray(
            name="lines",
            elmts=[
                structs.G2Line(name=f"line{i}", elmts=lines[i : i + 4])
                for i in range(0, len(lines), 4)
            ],
        ),
        big_Q=structs.u384Array(name="big_Q", elmts=big_Q_coeffs),
        precomputed_miller_loop_result=structs.E12D(
            name="precomputed_miller_loop_result", elmts=M
        ),
        small_Q=structs.E12DMulQuotient(name="small_Q", elmts=small_Q),
    )
