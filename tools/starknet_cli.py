from hydra.definitions import (
    G1Point,
    G2Point,
    CURVES,
    G1G2Pair,
    CurveID,
    get_irreducible_poly,
)
from hydra.poseidon_transcript import CairoPoseidonTranscript
from dataclasses import dataclass, field
from hydra.hints.tower_backup import E12
from hydra.hints import io
from hydra.precompiled_circuits.multi_pairing_check import (
    MultiPairingCheckCircuit,
    get_root_and_scaling_factor,
    MultiMillerLoopCircuit,
    get_pairing_check_input,
    get_max_Q_degree,
)
from hydra.extension_field_modulo_circuit import AccumulatePolyInstructions
from hydra.algebra import Polynomial
from hydra import modulo_circuit_structs as structs
from hydra.modulo_circuit_structs import Cairo1SerializableStruct
import functools


@dataclass(slots=True)
class MultiPairingCheck2PairsInput:
    curve_id: CurveID
    pair0: structs.G1G2PairCircuit = None
    pair1: structs.G1G2PairCircuit = None
    pair2: structs.G1G2PairCircuit = None
    lambda_root: structs.E12D = None
    lambda_root_inverse: structs.E12D = None
    w: structs.MillerLoopResultScalingFactor = None
    Ris: list[structs.E12D] = None
    big_Q: structs.u384Array = None

    def to_cairo1_test(self):
        n_pairs = 2

        input_code = ""
        struct_list = [
            self.pair0,
            self.pair1,
            self.lambda_root,
            self.lambda_root_inverse,
            self.w,
            self.Ris,
            self.big_Q,
        ]
        if self.curve_id == CurveID.BLS12_381:
            struct_list.remove(self.lambda_root)

        struct_names = [struct.name + ('.span()' if struct.name == "Ris" else '') for struct in struct_list]
        for struct in struct_list:
            input_code += struct.serialize()
        code = f"""
        #[test]
        fn test_{CurveID(self.curve_id).name}_mpcheck_{n_pairs}P() {{
            {input_code}
            let res = multi_pairing_check_{self.curve_id.name.lower()}_{n_pairs}_pairs({', '.join(struct_names)});
            assert!(res);
        }}
        """
        return code


@dataclass
class MultiPairingCheck3PairsInput(MultiPairingCheck2PairsInput):
    pair2: structs.G1G2PairCircuit = None
    precomputed_miller_loop_result: structs.E12D | None = None
    small_Q: structs.E12DMulQuotient | None = None

    def to_cairo1_test(self):
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
            self.big_Q,
            self.precomputed_miller_loop_result,
            self.small_Q,
        ]
        if self.curve_id == CurveID.BLS12_381:
            struct_list.remove(self.lambda_root)

        struct_names = [struct.name + ('.span()' if struct.name == "Ris" else '') for struct in struct_list]
        for struct in struct_list:
            input_code += struct.serialize()
        code = f"""
        #[test]
        fn test_{CurveID(self.curve_id).name}_mpcheck_{n_pairs}P() {{
            {input_code}
            let res = multi_pairing_check_{self.curve_id.name.lower()}_{n_pairs}_pairs({', '.join(struct_names)});
            assert!(res);
        }}
        """
        return code


def multi_pairing_check_calldata(
    pairs: list[G1G2Pair],
    extra_pair: G1G2Pair | None = None,
) -> list[structs.Cairo1SerializableStruct]:
    # Validate input
    assert isinstance(pairs, (list, tuple))
    assert all(
        isinstance(pair, G1G2Pair) for pair in pairs
    ), f"All pairs must be G1G2Pair, got {[type(pair) for pair in pairs]}"
    assert all(
        pair.curve_id == pairs[0].curve_id for pair in pairs
    ), f"All pairs must be on the same curve, got {[pair.curve_id for pair in pairs]}"
    assert (
        isinstance(extra_pair, G1G2Pair) or extra_pair is None
    ), f"Extra pair must be G1G2Pair or None, got {extra_pair}"
    if extra_pair is not None:
        assert (
            len(pairs) == 3
        ), f"Multi pairing check with extra pair must have 3 pairs, got {len(pairs)}"
    else:
        assert (
            2 <= len(pairs) <= 3
        ), f"Multi pairing check without extra pair must have 2 or 3 pairs, got {len(pairs)}"

    curve_id = pairs[0].curve_id

    # Precompute M if extra pair is provided
    if extra_pair is not None:
        circuit = MultiMillerLoopCircuit(
            name="precompute M", curve_id=curve_id.value, n_pairs=1
        )
        circuit.write_p_and_q(extra_pair.to_pyfelt_list())
        M = circuit.miller_loop(n_pairs=1)
        M = [mi.felt for mi in M]
    else:
        M = None

    mpcheck_circuit = MultiPairingCheckCircuit(
        name="mpcheck",
        curve_id=curve_id.value,
        n_pairs=len(pairs),
    )

    p_q_input = []
    for pair in pairs:
        p_q_input.extend(pair.to_pyfelt_list())
    mpcheck_circuit.write_p_and_q(p_q_input)
    _, lambda_root, scaling_factor, scaling_factor_sparsity = (
        mpcheck_circuit.multi_pairing_check(len(pairs), M)
    )

    relations = mpcheck_circuit.accumulate_poly_instructions[0]
    print(relations.n)
    print(len(relations.Ris))
    n_relations_with_ci = relations.n - 1 if extra_pair is not None else relations.n

    init_hash = f"MPCHECK_{curve_id.name}_{len(pairs)}P"
    print(f"init_hash : {init_hash}")
    hasher = CairoPoseidonTranscript(
        init_hash=int.from_bytes(init_hash.encode(), byteorder="big")
    )
    print(f"s0 init : {hasher.s0}")
    # Hash Inputs
    for i, pair in enumerate(pairs):
        hasher.hash_limbs_multi(pair.to_pyfelt_list())
        print(f"s0 after pair {i} : {hasher.s0}")
    hasher.hash_limbs_multi(lambda_root)
    print(f"s0 after lambda root : {hasher.s0}")
    hasher.hash_limbs_multi(scaling_factor, sparsity=scaling_factor_sparsity)
    print(f"s0 after scaling factor : {hasher.s0}")
    # Hash Ri's to derive c0
    for i, Ri in enumerate(relations.Ris):
        # assert Ri_sparsity == None, f"R{i} is not sparse, got {Ri_sparsity}"
        hasher.hash_limbs_multi(Ri)
    c0 = hasher.s1
    print(f"c0 : {c0}")

    # Compute ci's where ci = c0^(2^i)
    field = mpcheck_circuit.field
    cis = [field(c0)]

    print(f"n_relations_with_ci : {n_relations_with_ci}")
    for i in range(n_relations_with_ci - 1):
        cis.append(cis[-1] * cis[-1])
        print(f"c_{i+1} : {io.int_to_u384(cis[-1])}")

    assert len(cis) == n_relations_with_ci, f"Wrong number of cis, got {len(cis)}"
    print(f"len(cis) : {len(cis)}, last ci : {cis[-1].value} {io.int_to_u384(cis[-1])}")
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
    print(f"big_Q_coeffs : {io.int_to_u384(big_Q_coeffs[0])}")
    hasher.hash_limbs_multi(big_Q_coeffs)
    z = hasher.s0
    print(f"z : {z}")
    z = field(z)

    lhs = field.zero()

    for i, ci in enumerate(cis):
        Pis = relations.Pis[i]
        Prod_Pis_of_z = functools.reduce(
            lambda x, y: x * y, [Polynomial(pi).evaluate(z) for pi in Pis]
        )
        Ri_of_z = Polynomial(relations.Ris[i]).evaluate(z)
        lhs += ci * (Prod_Pis_of_z - Ri_of_z)
        print(f"lhs_{i} : {io.int_to_u384(lhs)}")

    P_irr = get_irreducible_poly(curve_id.value, 12)
    big_Q_of_z = big_Q.evaluate(z)
    P_of_z = P_irr.evaluate(z)
    print(f"big_Q_of_z : {io.int_to_u384(big_Q_of_z)}")
    print(f"P_of_z : {io.int_to_u384(P_of_z)}")
    assert lhs == big_Q_of_z * P_of_z
    print(len(relations.Ris))
    if extra_pair is not None:
        small_Q = relations.Qis[-1]
    else:
        small_Q = None

    pairs_structs = [None, None, None]
    for i, pair in enumerate(pairs):
        pairs_structs[i] = structs.G1G2PairCircuit(
            name=f"pair{i}", elmts=pair.to_pyfelt_list()
        )

    if len(pairs) == 2:
        return MultiPairingCheck2PairsInput(
            curve_id=curve_id,
            pair0=pairs_structs[0],
            pair1=pairs_structs[1],
            lambda_root=structs.E12D(name="lambda_root", elmts=lambda_root),
            lambda_root_inverse=structs.E12D(
                name="lambda_root_inverse", elmts=lambda_root
            ),
            w=structs.MillerLoopResultScalingFactor(
                name="w",
                elmts=[
                    wi
                    for wi, si in zip(scaling_factor, scaling_factor_sparsity)
                    if si != 0
                ],
            ),
            Ris=structs.StructArray(
                name="Ris",
                elmts=[
                    structs.E12D(name=f"R{i}", elmts=[ri.felt for ri in Ri])
                    for i, Ri in enumerate(relations.Ris)
                ],
            ),
            big_Q=structs.u384Array(name="big_Q", elmts=big_Q_coeffs),
        )
    else:
        return MultiPairingCheck3PairsInput(
            curve_id=curve_id,
            pair0=pairs_structs[0],
            pair1=pairs_structs[1],
            pair2=pairs_structs[2],
            lambda_root=structs.E12D(name="lambda_root", elmts=lambda_root),
            lambda_root_inverse=structs.E12D(
                name="lambda_root_inverse", elmts=lambda_root
            ),
            w=structs.MillerLoopResultScalingFactor(
                name="w",
                elmts=[
                    wi
                    for wi, si in zip(scaling_factor, scaling_factor_sparsity)
                    if si != 0
                ],
            ),
            Ris=structs.StructArray(
                name="Ris",
                elmts=[
                    structs.E12D(name=f"R{i}", elmts=[ri.felt for ri in Ri])
                    for i, Ri in enumerate(relations.Ris)
                ],
            ),
            big_Q=structs.u384Array(name="big_Q", elmts=big_Q_coeffs),
            precomputed_miller_loop_result=structs.E12D(
                name="precomputed_miller_loop_result", elmts=M
            ),
            small_Q=structs.E12DMulQuotient(name="small_Q", elmts=small_Q),
        )


if __name__ == "__main__":
    import random

    random.seed(0)
    pairs, extra_pair = get_pairing_check_input(
        CurveID.BLS12_381, 2, include_m=False, return_pairs=True
    )
    input = multi_pairing_check_calldata(pairs, extra_pair)
    # print(input.to_cairo1_test())

    with open("output.txt", "w") as f:
        f.write(input.to_cairo1_test())
