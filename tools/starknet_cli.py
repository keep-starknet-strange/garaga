from hydra.definitions import (
    G1Point,
    G2Point,
    CURVES,
    G1G2Pair,
    CurveID,
    get_irreducible_poly,
    get_base_field,
    STARK,
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
from hydra.algebra import Polynomial, PyFelt
from hydra import modulo_circuit_structs as structs
from hydra.modulo_circuit_structs import Cairo1SerializableStruct
from hydra.hints import ecip
import functools
from hydra.hints.neg_3 import neg_3_base_le


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

    def to_cairo1_test(self, test_name: str = None):
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

        struct_names = [
            struct.name + (".span()" if struct.name == "Ris" else "")
            for struct in struct_list
        ]
        for struct in struct_list:
            input_code += struct.serialize()

        test_name = (
            test_name
            if test_name
            else f"{CurveID(self.curve_id).name}_mpcheck_{n_pairs}P"
        )
        code = f"""
        #[test]
        fn {test_name}() {{
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
            self.big_Q,
            self.precomputed_miller_loop_result,
            self.small_Q,
        ]
        if self.curve_id == CurveID.BLS12_381:
            struct_list.remove(self.lambda_root)

        struct_names = [
            struct.name + (".span()" if struct.name == "Ris" else "")
            for struct in struct_list
        ]
        for struct in struct_list:
            if struct.name in ["precomputed_miller_loop_result", "small_Q"]:
                input_code += struct.serialize(is_option=True)
            else:
                input_code += struct.serialize()

        test_name = (
            test_name
            if test_name
            else f"{CurveID(self.curve_id).name}_mpcheck_{n_pairs}P"
        )

        code = f"""
        #[test]
        fn {test_name}() {{
            {input_code}
            let res = multi_pairing_check_{self.curve_id.name.lower()}_{n_pairs}_pairs({', '.join(struct_names)});
            assert!(res);
        }}
        """
        return code


def multi_pairing_check_calldata(
    pairs: list[G1G2Pair],
    extra_pair: G1G2Pair | None = None,
) -> MultiPairingCheck2PairsInput | MultiPairingCheck3PairsInput:
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
        circuit.write_p_and_q_raw(extra_pair.to_pyfelt_list())
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
    mpcheck_circuit.write_p_and_q_raw(p_q_input)
    _, lambda_root, lambda_root_inverse, scaling_factor, scaling_factor_sparsity = (
        mpcheck_circuit.multi_pairing_check(len(pairs), M)
    )

    relations = mpcheck_circuit.accumulate_poly_instructions[0]
    # print(relations.n)
    # print(len(relations.Ris))

    init_hash = f"MPCHECK_{curve_id.name}_{len(pairs)}P"
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
    passed_Ris = (
        passed_Ris if extra_pair is None else passed_Ris[:-1]
    )  # Skip last Ri if extra pair is provided as it is known to be 1.
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
        # print(f"c_{i+1} : {io.int_to_u384(cis[-1])}")
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
        # print(f"lhs_{i} : {io.int_to_u384(lhs)}")

    P_irr = get_irreducible_poly(curve_id.value, 12)
    big_Q_of_z = big_Q.evaluate(z)
    P_of_z = P_irr.evaluate(z)
    # print(f"big_Q_of_z : {io.int_to_u384(big_Q_of_z)}")
    # print(f"P_of_z : {io.int_to_u384(P_of_z)}")
    assert lhs == big_Q_of_z * P_of_z
    # print(len(relations.Ris))
    if extra_pair is not None:
        small_Q = relations.Qis[-1].get_coeffs()
        small_Q = small_Q + [field.zero()] * (11 - len(small_Q))
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
                name="lambda_root_inverse", elmts=lambda_root_inverse
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
                    for i, Ri in enumerate(passed_Ris)
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
                name="lambda_root_inverse", elmts=lambda_root_inverse
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
                    for i, Ri in enumerate(passed_Ris)
                ],
            ),
            big_Q=structs.u384Array(name="big_Q", elmts=big_Q_coeffs),
            precomputed_miller_loop_result=structs.E12D(
                name="precomputed_miller_loop_result", elmts=M
            ),
            small_Q=structs.E12DMulQuotient(name="small_Q", elmts=small_Q),
        )


@dataclass
class MSMInput:
    curve_id: CurveID
    points: structs.StructSpan[structs.G1PointCircuit]
    scalars: structs.StructSpan[structs.u256]
    scalars_digits_decompositions: structs.StructSpan[
        structs.StructSpan[structs.StructSpan[structs.felt252]]
    ]
    Q_low: structs.G1PointCircuit
    Q_high: structs.G2PointCircuit
    Q_high_shifted: structs.G2PointCircuit
    SumDlogDivLow: structs.FunctionFeltCircuit
    SumDlogDivHigh: structs.FunctionFeltCircuit
    SumDlogDivHighShifted: structs.FunctionFeltCircuit
    y_last_attempt: structs.u384
    g_rhs_sqrt: structs.u384Array

    def to_cairo1_test(self, test_name: str = None):
        if test_name is None:
            test_name = f"test_msm_{self.curve_id.name}_{len(self.scalars)}_points"
        input_code = ""
        struct_list = [
            self.points,
            self.scalars,
            self.scalars_digits_decompositions,
            self.Q_low,
            self.Q_high,
            self.Q_high_shifted,
            self.SumDlogDivLow,
            self.SumDlogDivHigh,
            self.SumDlogDivHighShifted,
            self.y_last_attempt,
            self.g_rhs_sqrt,
        ]
        for struct in struct_list:
            if struct.name == "scalars_digits_decompositions":
                input_code += struct.serialize(is_option=True)
            else:
                input_code += struct.serialize()

        _Q = G1Point.msm(
            points=[
                G1Point(x.elmts[0].value, x.elmts[1].value, self.curve_id)
                for x in self.points.elmts
            ],
            scalars=[s.elmts[0].value for s in self.scalars.elmts],
        )
        Q = structs.G1PointCircuit.from_G1Point("Q", _Q)
        code = f"""
        #[test]
        fn {test_name}() {{
            {input_code}
            let res = msm_g1({', '.join([struct.name for struct in struct_list])}, {self.curve_id.value});
            assert!(res == {Q.serialize(raw=True)});
        }}
        """

        return code


def msm_calldata(points: list[G1Point], scalars: list[int]) -> MSMInput:
    assert all(point.curve_id == points[0].curve_id for point in points)
    assert len(points) == len(scalars)
    msm_size = len(scalars)
    curve_id = points[0].curve_id
    field = get_base_field(curve_id)
    scalars_split = [io.split_128(s) for s in scalars]
    scalars_low, scalars_high = zip(*scalars_split)
    scalars_low_decompositions, scalars_high_decompositions = [
        neg_3_base_le(s) for s in scalars_low
    ], [neg_3_base_le(s) for s in scalars_high]

    _Q_low, _SumDlogDivLow = ecip.zk_ecip_hint(points, scalars_low)
    _Q_high, _SumDlogDivHigh = ecip.zk_ecip_hint(points, scalars_high)
    _Q_high_shifted, _SumDlogDivHighShifted = ecip.zk_ecip_hint([_Q_high], [2**128])

    Q_low, SumDlogDivLow = structs.G1PointCircuit.from_G1Point(
        "Q_low", _Q_low
    ), structs.FunctionFeltCircuit.from_FunctionFelt(
        name="SumDlogDivLow", f=_SumDlogDivLow, msm_size=msm_size
    )

    Q_high, SumDlogDivHigh = structs.G1PointCircuit.from_G1Point(
        "Q_high", _Q_high
    ), structs.FunctionFeltCircuit.from_FunctionFelt(
        name="SumDlogDivHigh", f=_SumDlogDivHigh, msm_size=msm_size
    )
    Q_high_shifted, SumDlogDivHighShifted = structs.G1PointCircuit.from_G1Point(
        "Q_high_shifted", _Q_high_shifted
    ), structs.FunctionFeltCircuit.from_FunctionFelt(
        name="SumDlogDivHighShifted", f=_SumDlogDivHighShifted, msm_size=1
    )
    hasher = CairoPoseidonTranscript(init_hash=int.from_bytes(b"MSM_G1", "big"))
    hasher.update_sponge_state(curve_id.value, msm_size)

    for SumDlogDiv in [SumDlogDivLow, SumDlogDivHigh, SumDlogDivHighShifted]:
        hasher.hash_limbs_multi(SumDlogDiv.a_num)
        hasher.hash_limbs_multi(SumDlogDiv.a_den)
        hasher.hash_limbs_multi(SumDlogDiv.b_num)
        hasher.hash_limbs_multi(SumDlogDiv.b_den)

    for point in points:
        hasher.hash_element(field(point.x))
        hasher.hash_element(field(point.y))

    for result_point in [_Q_low, _Q_high, _Q_high_shifted]:
        hasher.hash_element(field(result_point.x))
        hasher.hash_element(field(result_point.y))

    for scalar in scalars:
        hasher.hash_u256(scalar)

    random_x_coordinate = hasher.s0

    _, y, roots = ecip.derive_ec_point_from_X(random_x_coordinate, curve_id)

    return MSMInput(
        curve_id=points[0].curve_id,
        points=structs.StructSpan(
            name="points",
            elmts=[
                structs.G1PointCircuit.from_G1Point(f"point{i}", point)
                for i, point in enumerate(points)
            ],
        ),
        scalars=structs.StructSpan(
            name="scalars",
            elmts=[
                structs.u256(name=f"scalar{i}", elmts=[PyFelt(s, 2**256)])
                for i, s in enumerate(scalars)
            ],
        ),
        scalars_digits_decompositions=structs.StructSpan(
            name="scalars_digits_decompositions",
            elmts=[
                structs.Tuple(
                    name="_",
                    elmts=[
                        structs.StructSpan(
                            name=f"scalar_low_digits_{i}",
                            elmts=[
                                structs.felt252(
                                    name=f"digit{k}", elmts=[PyFelt(digit, STARK)]
                                )
                                for k, digit in enumerate(scalars_low_decompositions[i])
                            ],
                        ),
                        structs.StructSpan(
                            name=f"scalar_high_digits_{i}",
                            elmts=[
                                structs.felt252(
                                    name=f"digit{k}", elmts=[PyFelt(digit, STARK)]
                                )
                                for k, digit in enumerate(
                                    scalars_high_decompositions[i]
                                )
                            ],
                        ),
                    ],
                )
                for i in range(len(scalars))
            ],
        ),
        Q_low=Q_low,
        Q_high=Q_high,
        Q_high_shifted=Q_high_shifted,
        SumDlogDivLow=SumDlogDivLow,
        SumDlogDivHigh=SumDlogDivHigh,
        SumDlogDivHighShifted=SumDlogDivHighShifted,
        y_last_attempt=structs.u384(name="y_last_attempt", elmts=[y]),
        g_rhs_sqrt=structs.u384Array(name="g_rhs_sqrt", elmts=roots),
    )


if __name__ == "__main__":
    import random
    import subprocess

    random.seed(0)
    pairing_curve_ids = [CurveID.BN254, CurveID.BLS12_381]
    params = [(2, False), (3, False), (3, True)]
    include_m = False

    pairing_test_header = """
    #[cfg(test)]
    mod pairing_tests {
        use garaga::pairing::{
            G1G2Pair, G1Point, G2Point, E12D, MillerLoopResultScalingFactor, E12DDefinitions,
            multi_pairing_check_bn254_2_pairs, multi_pairing_check_bn254_3_pairs,
            multi_pairing_check_bls12_381_3_pairs, multi_pairing_check_bls12_381_2_pairs, u384, Option,
            E12DMulQuotient
        };
    """
    with open("src/cairo/src/tests/pairing_tests.cairo", "w") as f:
        f.write(pairing_test_header)
        for curve_id in pairing_curve_ids:
            for n_pairs, include_m in params:
                print(
                    f"\n Generating pairing test for curve_id: {curve_id}, n_pairs: {n_pairs} with extra m: {include_m}"
                )
                pairs, extra_pair = get_pairing_check_input(
                    curve_id, n_pairs, include_m=include_m, return_pairs=True
                )
                input = multi_pairing_check_calldata(pairs, extra_pair)
                f.write(
                    input.to_cairo1_test(
                        test_name=f"{curve_id.name}_mpcheck_{n_pairs}P_{'with_extra_m' if include_m else ''}"
                    )
                )
                f.write("\n")  # Add some spacing between tests
        f.write("}")
    subprocess.run(["scarb", "fmt"], check=True, cwd="src/cairo/src/tests")

    msm_curve_ids = [
        CurveID.BN254,
        CurveID.BLS12_381,
        CurveID.SECP256R1,
        CurveID.SECP256K1,
        CurveID.X25519,
    ]

    msm_sizes = [1, 2, 3, 4, 5, 6, 7, 8]

    msm_test_header = """
#[cfg(test)]
mod msm_tests {
    use garaga::ec_ops::{G1Point, FunctionFelt, u384, msm_g1};

"""
    with open("src/cairo/src/tests/msm_tests.cairo", "w") as f:
        f.write(msm_test_header)
        for curve_id in msm_curve_ids:
            for n_points in msm_sizes:
                print(
                    f"\nGenerating msm test for curve_id: {curve_id}, n_points: {n_points}"
                )
                input = msm_calldata(
                    points=[G1Point.gen_random_point(curve_id)] * n_points,
                    scalars=[
                        random.randint(0, CURVES[curve_id.value].n - 1)
                        for _ in range(n_points)
                    ],
                )
                f.write(
                    input.to_cairo1_test(
                        test_name=f"test_msm_{curve_id.name}_{n_points}_points"
                    )
                )
                f.write("\n")
        f.write("}")

    subprocess.run(["scarb", "fmt"], check=True, cwd="src/cairo/src/tests")
