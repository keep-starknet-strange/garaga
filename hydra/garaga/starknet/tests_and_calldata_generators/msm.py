from dataclasses import dataclass
from functools import lru_cache

from garaga import modulo_circuit_structs as structs
from garaga.algebra import FunctionFelt, PyFelt
from garaga.definitions import CURVES, STARK, CurveID, G1Point, get_base_field
from garaga.hints import ecip, io
from garaga.hints.neg_3 import neg_3_base_le
from garaga.poseidon_transcript import CairoPoseidonTranscript


@dataclass(slots=True)
class MSMCalldataBuilder:
    curve_id: CurveID
    points: list[G1Point]
    scalars: list[int]

    def __post_init__(self):
        assert all(
            point.curve_id == self.curve_id for point in self.points
        ), "All points must be on the same curve."
        assert len(self.points) == len(
            self.scalars
        ), "Number of points and scalars must be equal."
        assert all(
            0 <= s <= CURVES[self.curve_id.value].n for s in self.scalars
        ), f"Scalars must be in [0, {self.curve_id.name}'s order] == [0, {CURVES[self.curve_id.value].n}]."

    def __hash__(self) -> int:
        return hash((self.curve_id, tuple(self.points), tuple(self.scalars)))

    @property
    def field(self):
        return get_base_field(self.curve_id)

    @property
    def msm_size(self):
        return len(self.scalars)

    @lru_cache(maxsize=2)
    def scalars_split(self) -> tuple[list[int], list[int]]:
        """
        Split the scalars into low 128 bits and high 128 bits parts
        """
        scalars_split = [io.split_128(s) for s in self.scalars]
        scalars_low, scalars_high = zip(*scalars_split)
        return scalars_low, scalars_high

    @lru_cache(maxsize=2)
    def scalars_digits_decompositions(self):
        scalars_low, scalars_high = self.scalars_split()

        scalars_low_decompositions, scalars_high_decompositions = [
            neg_3_base_le(s) for s in scalars_low
        ], [neg_3_base_le(s) for s in scalars_high]
        return scalars_low_decompositions, scalars_high_decompositions

    def _retrieve_random_x_coordinate(
        self,
        Q_low: G1Point,
        Q_high: G1Point,
        Q_high_shifted: G1Point,
        SumDlogDivLow: FunctionFelt,
        SumDlogDivHigh: FunctionFelt,
        SumDlogDivHighShifted: FunctionFelt,
    ):
        transcript = CairoPoseidonTranscript(init_hash=int.from_bytes(b"MSM_G1", "big"))
        transcript.update_sponge_state(self.curve_id.value, self.msm_size)

        for SumDlogDiv in [SumDlogDivLow, SumDlogDivHigh]:
            _a_num, _a_den, _b_num, _b_den = io.padd_function_felt(
                SumDlogDiv, self.msm_size, py_felt=True
            )
            transcript.hash_limbs_multi(_a_num)
            transcript.hash_limbs_multi(_a_den)
            transcript.hash_limbs_multi(_b_num)
            transcript.hash_limbs_multi(_b_den)

        for SumDlogDiv in [SumDlogDivHighShifted]:
            _a_num, _a_den, _b_num, _b_den = io.padd_function_felt(
                SumDlogDiv, 1, py_felt=True
            )
            transcript.hash_limbs_multi(_a_num)
            transcript.hash_limbs_multi(_a_den)
            transcript.hash_limbs_multi(_b_num)
            transcript.hash_limbs_multi(_b_den)

        for point in self.points:
            transcript.hash_element(self.field(point.x))
            transcript.hash_element(self.field(point.y))

        for result_point in [Q_low, Q_high, Q_high_shifted]:
            transcript.hash_element(self.field(result_point.x))
            transcript.hash_element(self.field(result_point.y))

        for scalar in self.scalars:
            transcript.hash_u256(scalar)

        return transcript.s0

    def build_derive_point_from_x_hint(
        self, random_x_coordinate: int
    ) -> structs.Struct:
        _x, y, roots = ecip.derive_ec_point_from_X(random_x_coordinate, self.curve_id)
        return structs.Struct(
            struct_name="DerivePointFromXHint",
            name="derive_point_from_x_hint",
            elmts=[
                structs.u384(name="y_last_attempt", elmts=[y]),
                structs.u384Array(name="g_rhs_sqrt", elmts=roots),
            ],
        )

    @lru_cache(maxsize=2)
    def build_msm_hints(self) -> tuple[structs.Struct, structs.Struct]:
        """
        Returns the MSMHint and the DerivePointFromXHint
        """
        scalars_low, scalars_high = self.scalars_split()

        _Q_low, _SumDlogDivLow = ecip.zk_ecip_hint(self.points, scalars_low)
        _Q_high, _SumDlogDivHigh = ecip.zk_ecip_hint(self.points, scalars_high)
        _Q_high_shifted, _SumDlogDivHighShifted = ecip.zk_ecip_hint([_Q_high], [2**128])
        _x_coordinate = self._retrieve_random_x_coordinate(
            _Q_low,
            _Q_high,
            _Q_high_shifted,
            _SumDlogDivLow,
            _SumDlogDivHigh,
            _SumDlogDivHighShifted,
        )

        derive_point_from_x_hint = self.build_derive_point_from_x_hint(_x_coordinate)

        #############################
        ######## Sanity check #######
        _x, _y, _ = ecip.derive_ec_point_from_X(_x_coordinate, self.curve_id)
        _A0 = G1Point(curve_id=self.curve_id, x=_x.value, y=_y.value)
        ecip.verify_ecip(
            self.points,
            self.scalars_split()[0],
            Q=_Q_low,
            sum_dlog=_SumDlogDivLow,
            A0=_A0,
        )
        ecip.verify_ecip(
            self.points,
            self.scalars_split()[1],
            Q=_Q_high,
            sum_dlog=_SumDlogDivHigh,
            A0=_A0,
        )
        ecip.verify_ecip(
            [_Q_high],
            [2**128],
            Q=_Q_high_shifted,
            sum_dlog=_SumDlogDivHighShifted,
            A0=_A0,
        )
        #############################
        return (
            structs.Struct(
                struct_name="MSMHint",
                name="msm_hint",
                elmts=[
                    structs.G1PointCircuit.from_G1Point("Q_low", _Q_low),
                    structs.G1PointCircuit.from_G1Point("Q_high", _Q_high),
                    structs.G1PointCircuit.from_G1Point(
                        "Q_high_shifted", _Q_high_shifted
                    ),
                    structs.FunctionFeltCircuit.from_FunctionFelt(
                        name="SumDlogDivLow", f=_SumDlogDivLow, msm_size=self.msm_size
                    ),
                    structs.FunctionFeltCircuit.from_FunctionFelt(
                        name="SumDlogDivHigh", f=_SumDlogDivHigh, msm_size=self.msm_size
                    ),
                    structs.FunctionFeltCircuit.from_FunctionFelt(
                        name="SumDlogDivHighShifted",
                        f=_SumDlogDivHighShifted,
                        msm_size=1,
                    ),
                ],
            ),
            derive_point_from_x_hint,
        )

    def _get_input_structs(self) -> list[structs.Cairo1SerializableStruct]:
        """
        Returns all the inputs used in the msm_g1 function :
        fn msm_g1(
            points: Span<G1Point>,
            scalars: Span<u256>,
            scalars_digits_decompositions: Option<Span<(Span<felt252>, Span<felt252>)>>,
            hint: MSMHint,
            derive_point_from_x_hint: DerivePointFromXHint,
        """
        inputs = []
        inputs.append(
            structs.StructSpan(
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
                                    for k, digit in enumerate(
                                        self.scalars_digits_decompositions()[0][i]
                                    )
                                ],
                            ),
                            structs.StructSpan(
                                name=f"scalar_high_digits_{i}",
                                elmts=[
                                    structs.felt252(
                                        name=f"digit{k}", elmts=[PyFelt(digit, STARK)]
                                    )
                                    for k, digit in enumerate(
                                        self.scalars_digits_decompositions()[1][i]
                                    )
                                ],
                            ),
                        ],
                    )
                    for i in range(len(self.scalars))
                ],
            )
        )
        inputs.append(self.build_msm_hints()[0])
        inputs.append(self.build_msm_hints()[1])
        inputs.append(
            structs.StructSpan(
                name="points",
                elmts=[
                    structs.G1PointCircuit.from_G1Point(f"point{i}", point)
                    for i, point in enumerate(self.points)
                ],
            )
        )
        inputs.append(
            structs.StructSpan(
                name="scalars",
                elmts=[
                    structs.u256(name=f"scalar{i}", elmts=[PyFelt(s, 2**256)])
                    for i, s in enumerate(self.scalars)
                ],
            )
        )
        return inputs

    def to_cairo_1_test(self, test_name: str = None):
        print(
            f"Generating MSM test for {self.curve_id.name} with {len(self.scalars)} points"
        )
        test_name = test_name or f"test_msm_{self.curve_id.name}_{len(self.scalars)}P"
        inputs = self._get_input_structs()

        input_code = ""
        for struct in inputs:
            if struct.name == "scalars_digits_decompositions":
                input_code += struct.serialize(is_option=True)
            else:
                input_code += struct.serialize()

        _Q = G1Point.msm(points=self.points, scalars=self.scalars)

        Q = structs.G1PointCircuit.from_G1Point("Q", _Q)
        code = f"""
        #[test]
        fn {test_name}() {{
            {input_code}
            let res = msm_g1({', '.join([struct.name for struct in inputs])}, {self.curve_id.value});
            assert!(res == {Q.serialize(raw=True)});
        }}
        """
        return code

    def serialize_to_calldata(
        self,
        include_digits_decomposition=True,
        include_points_and_scalars=True,
        serialize_as_pure_felt252_array=False,
    ) -> list[int]:
        inputs = self._get_input_structs()
        option = (
            structs.CairoOption.SOME
            if include_digits_decomposition
            else structs.CairoOption.NONE
        )

        call_data: list[int] = []
        for e in inputs:
            # print(e.name)
            if e.name == "scalars_digits_decompositions":
                data = e.serialize_to_calldata(option)
            elif e.name == "points" and not include_points_and_scalars:
                continue
            elif e.name == "scalars" and not include_points_and_scalars:
                continue
            else:
                data = e.serialize_to_calldata()

            call_data.extend(data)

        if include_points_and_scalars:
            call_data.append(self.curve_id.value)

        if serialize_as_pure_felt252_array:
            return [len(call_data)] + call_data
        else:
            return call_data


if __name__ == "__main__":
    import random

    c = CurveID.SECP256K1
    order = CURVES[c.value].n
    msm = MSMCalldataBuilder(
        curve_id=c,
        points=[G1Point.gen_random_point(c) for _ in range(1)],
        scalars=[random.randint(0, order) for _ in range(1)],
    )
    cd = msm.serialize_to_calldata(
        include_digits_decomposition=True,
        include_points_and_scalars=True,
        serialize_as_pure_felt252_array=False,
    )
    print(cd)
    print(len(cd))
