from dataclasses import dataclass

from hydra import modulo_circuit_structs as structs
from hydra.algebra import PyFelt
from hydra.definitions import STARK, CurveID, G1Point, get_base_field
from hydra.hints import ecip, io
from hydra.hints.neg_3 import neg_3_base_le
from hydra.poseidon_transcript import CairoPoseidonTranscript


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
