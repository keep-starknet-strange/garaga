from dataclasses import dataclass
from functools import lru_cache

from garaga import garaga_rs
from garaga import modulo_circuit_structs as structs
from garaga.algebra import PyFelt
from garaga.definitions import (
    CURVES,
    STARK,
    CurveID,
    G1Point,
    WeierstrassCurve,
    get_base_field,
)
from garaga.hints import fake_glv


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
        ), f"Number of points and scalars must be equal, got {len(self.points)} points and {len(self.scalars)} scalars"
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

    @property
    def curve(self) -> WeierstrassCurve:
        return CURVES[self.curve_id.value]

    @lru_cache(maxsize=2)
    def build_msm_hint(self) -> structs.StructArray:
        """
        Returns the MSMHint
        """
        hints_structs = []
        for i, (point, scalar) in enumerate(zip(self.points, self.scalars)):
            if self.curve.is_endomorphism_available():
                Q, u1, u2, v1, v2 = fake_glv.get_glv_fake_glv_hint(point, scalar)
                hints_structs.append(
                    structs.Struct(
                        struct_name=f"GlvFakeGlvHint",
                        name=f"glv_fake_glv_hint_{i}",
                        elmts=[
                            structs.G1PointCircuit.from_G1Point("Q", Q),
                            structs.felt252(name=f"u1_{i}", elmts=[PyFelt(u1, STARK)]),
                            structs.felt252(name=f"u2_{i}", elmts=[PyFelt(u2, STARK)]),
                            structs.felt252(name=f"v1_{i}", elmts=[PyFelt(v1, STARK)]),
                            structs.felt252(name=f"v2_{i}", elmts=[PyFelt(v2, STARK)]),
                        ],
                    )
                )
            else:
                Q, s1, s2 = fake_glv.get_fake_glv_hint(point, scalar)
                hints_structs.append(
                    structs.Struct(
                        struct_name=f"FakeGlvHint",
                        name=f"fake_glv_hint_{i}",
                        elmts=[
                            structs.G1PointCircuit.from_G1Point("Q", Q),
                            structs.felt252(name=f"s1_{i}", elmts=[PyFelt(s1, STARK)]),
                            structs.felt252(name=f"s2_{i}", elmts=[PyFelt(s2, STARK)]),
                        ],
                    )
                )

        return structs.StructSpan(name="msm_hint", elmts=hints_structs)

    def _get_input_structs(
        self,
    ) -> list[structs.Cairo1SerializableStruct]:
        """ """
        inputs = []
        inputs.append(self.build_msm_hint())  # msm_hint
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

    def to_cairo_1_test(
        self, test_name: str = None, include_digits_decomposition=False
    ):
        # print(
        #     f"Generating MSM test for {self.curve_id.name} with {len(self.scalars)} points"
        # )
        test_name = test_name or f"test_msm_{self.curve_id.name}_{len(self.scalars)}P"
        inputs = garaga_rs.msm_calldata_builder(
            [value for point in self.points for value in [point.x, point.y]],
            self.scalars,
            self.curve_id.value,
            True,
            False,
        )
        Q = structs.G1PointCircuit.from_G1Point(
            "Q", G1Point.msm(self.points, self.scalars)
        )

        T = "u384" if self.curve_id == CurveID.BLS12_381 else "u288"
        code = f"""
        #[test]
        fn {test_name}() {{
            let mut data = array![{','.join([hex(value) for value in inputs])}].span();
            let points = Serde::deserialize(ref data).unwrap();
            let scalars = Serde::deserialize(ref data).unwrap();
            let curve_id = Serde::deserialize(ref data).unwrap();
            let res = msm_g1(points, scalars, curve_id, data);
            assert!(res == {Q.serialize(raw=True)});
        }}
        """
        return code

    def _serialize_to_calldata_rust(
        self,
        include_points_and_scalars=True,
        serialize_as_pure_felt252_array=False,
    ) -> list[int]:
        return garaga_rs.msm_calldata_builder(
            [value for point in self.points for value in [point.x, point.y]],
            self.scalars,
            self.curve_id.value,
            include_points_and_scalars,
            serialize_as_pure_felt252_array,
        )

    def serialize_to_calldata(
        self,
        include_points_and_scalars=True,
        serialize_as_pure_felt252_array=False,
        use_rust=False,
    ) -> list[int]:
        if use_rust:
            return self._serialize_to_calldata_rust(
                include_points_and_scalars,
                serialize_as_pure_felt252_array,
            )

        msm_hint, points, scalars = self._get_input_structs()

        call_data: list[int] = []

        if include_points_and_scalars:
            call_data.extend(points.serialize_to_calldata())
            call_data.extend(scalars.serialize_to_calldata())
            call_data.append(self.curve_id.value)

        call_data.extend(msm_hint.serialize_to_calldata()[1:])

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
        include_points_and_scalars=True,
        serialize_as_pure_felt252_array=False,
    )
    print(cd)
    print(len(cd))
