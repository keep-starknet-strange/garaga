import dataclasses
import json
import os
from pathlib import Path
from typing import Any, Dict, List

from hydra.definitions import CurveID, G1G2Pair, G1Point, G2Point
from hydra.hints import io
from hydra.modulo_circuit_structs import (
    E12D,
    G1PointCircuit,
    G2PointCircuit,
    StructArray,
)
from hydra.precompiled_circuits.multi_miller_loop import MultiMillerLoopCircuit


def find_item_from_key_patterns(data: dict, key_patterns: List[str]) -> Any:
    best_match = None
    best_score = -1
    for key, value in data.items():
        for pattern in key_patterns:
            if key.lower() == pattern.lower():
                # Exact match
                return value
            elif pattern.lower() in key.lower():
                # Partial match
                score = key.lower().count(pattern.lower())
                if score > best_score:
                    best_match = value
                    best_score = score

    if best_match is not None:
        return best_match
    else:
        raise ValueError(f"No key found with patterns {key_patterns}")


def try_parse_g1_point_from_key(
    data: dict, key_patterns: List[str], curve_id: CurveID = None
) -> G1Point:
    point = find_item_from_key_patterns(data, key_patterns)
    # print(point)
    return try_parse_g1_point(point, curve_id)


def try_parse_g1_point(point: Any, curve_id: CurveID = None) -> G1Point:
    if isinstance(point, dict):
        return G1Point(
            x=io.to_int(point["x"]),
            y=io.to_int(point["y"]),
            curve_id=curve_id,
        )
    elif isinstance(point, (tuple, list)):
        if len(point) == 2:
            return G1Point(
                x=io.to_int(point[0]),
                y=io.to_int(point[1]),
                curve_id=curve_id,
            )
        elif len(point) == 3:
            assert io.to_int(point[2]) == 1, f"Non standard projective coordinates"
            return G1Point(
                x=io.to_int(point[0]),
                y=io.to_int(point[1]),
                curve_id=curve_id,
            )
        else:
            raise ValueError(f"Invalid point: {point}")
    else:
        raise ValueError(f"Invalid point: {point}")


def try_parse_g2_point_from_key(
    data: dict, key_patterns: List[str], curve_id: CurveID = None
) -> G2Point:
    point = find_item_from_key_patterns(data, key_patterns)
    return try_parse_g2_point(point, curve_id)


def try_parse_g2_point(point: Any, curve_id: CurveID = None) -> G2Point:
    if isinstance(point, dict):
        return G2Point(
            x=(io.to_int(point["x"][0]), io.to_int(point["x"][1])),
            y=(io.to_int(point["y"][0]), io.to_int(point["y"][1])),
            curve_id=curve_id,
        )
    elif isinstance(point, (tuple, list)):
        if len(point) == 2:
            supposed_x = point[0]
            supposed_y = point[1]
        elif len(point) == 3:
            assert (io.to_int(point[2][0]), io.to_int(point[2][1])) == (
                1,
                0,
            ), f"Non standard projective coordinates"
            supposed_x = point[0]
            supposed_y = point[1]

        if isinstance(supposed_x, (tuple, list)):
            assert len(supposed_x) == 2, f"Invalid fp2 coordinates: {supposed_x}"
            supposed_x = (io.to_int(supposed_x[0]), io.to_int(supposed_x[1]))
        if isinstance(supposed_y, (tuple, list)):
            assert len(supposed_y) == 2, f"Invalid fp2 coordinates: {supposed_y}"
            supposed_y = (io.to_int(supposed_y[0]), io.to_int(supposed_y[1]))
        return G2Point(x=supposed_x, y=supposed_y, curve_id=curve_id)
    else:
        raise ValueError(f"Invalid point: {point}")


@dataclasses.dataclass(slots=True)
class Groth16VerifyingKey:
    alpha: G1Point
    beta: G2Point
    gamma: G2Point
    delta: G2Point
    ic: List[G1Point]

    def __post_init__(self):
        assert (
            len(self.ic) > 1
        ), "The verifying key must have at least two points in the ic array (one public input and one private input)"
        assert len(self.ic) == len(
            set(self.ic)
        ), "The ic array must not contain duplicate points."
        assert (
            self.alpha.curve_id
            == self.beta.curve_id
            == self.gamma.curve_id
            == self.delta.curve_id
        ), "All points must be on the same curve."
        assert all(point.curve_id == self.alpha.curve_id for point in self.ic)

    @property
    def curve_id(self) -> CurveID:
        return self.alpha.curve_id

    def from_json(file_path: str | Path) -> "Groth16VerifyingKey":
        path = Path(file_path)
        try:
            with path.open("r") as f:
                data = json.load(f)
            curve_id = CurveID.from_str(find_item_from_key_patterns(data, ["curve"]))
            try:
                verifying_key = find_item_from_key_patterns(data, ["verifying_key"])
            except ValueError:
                verifying_key = data

            return Groth16VerifyingKey(
                alpha=try_parse_g1_point_from_key(verifying_key, ["alpha"], curve_id),
                beta=try_parse_g2_point_from_key(verifying_key, ["beta"], curve_id),
                gamma=try_parse_g2_point_from_key(verifying_key, ["gamma"], curve_id),
                delta=try_parse_g2_point_from_key(verifying_key, ["delta"], curve_id),
                ic=[
                    try_parse_g1_point(point, curve_id)
                    for point in find_item_from_key_patterns(verifying_key, ["ic"])
                ],
            )
        except FileNotFoundError:
            cwd = os.getcwd()
            print(f"Current working directory: {cwd}")
            print(f"Attempted to access file: {os.path.abspath(file_path)}")
            raise FileNotFoundError(f"The file {file_path} was not found.")
        except json.JSONDecodeError:
            raise ValueError(f"The file {file_path} does not contain valid JSON.")
        except KeyError as e:
            raise KeyError(f"The key {e} is missing from the JSON data.")

    def serialize_to_cairo(self) -> str:
        # Precompute M = miller_loop(public_pair)
        circuit = MultiMillerLoopCircuit(
            name="precompute M", curve_id=self.curve_id.value, n_pairs=1
        )
        circuit.write_p_and_q(P=[self.alpha], Q=[self.beta])

        M = E12D("alpha_beta_miller_loop_result", circuit.miller_loop(n_pairs=1))
        gamma_g2 = G2PointCircuit.from_G2Point("gamma_g2", self.gamma)
        delta_g2 = G2PointCircuit.from_G2Point("delta_g2", self.delta)
        ic = StructArray(
            name="ic",
            elmts=[
                G1PointCircuit.from_G1Point(f"ic_{i}", point)
                for i, point in enumerate(self.ic)
            ],
        )
        code = f"""
        pub const vk:Groth16VerifyingKey = Groth16VerifyingKey{{
            alpha_beta_miller_loop_result: {M.serialize(raw=True)},
            gamma_g2: {gamma_g2.serialize(raw=True)},
            delta_g2: {delta_g2.serialize(raw=True)}
        }};

        pub const ic: [G1Point; {len(self.ic)}] = {ic.serialize(raw=True, const=True)};

        """
        return code


@dataclasses.dataclass(slots=True)
class Groth16Proof:
    a: G1Point
    b: G2Point
    c: G1Point
    public_inputs: List[int] = dataclasses.field(default_factory=list)
    curve_id: CurveID = None

    def __post_init__(self):
        assert (
            self.a.curve_id == self.b.curve_id == self.c.curve_id
        ), f"All points must be on the same curve, got {self.a.curve_id}, {self.b.curve_id}, {self.c.curve_id}"
        self.curve_id = self.a.curve_id

    def from_json(
        proof_path: str | Path, public_inputs_path: str | Path = None
    ) -> "Groth16Proof":
        path = Path(proof_path)
        try:
            with path.open("r") as f:
                data = json.load(f)
            print(data, "\n")
            print(data.keys())
            curve_id = CurveID.from_str(find_item_from_key_patterns(data, ["curve"]))
            try:
                proof = find_item_from_key_patterns(data, ["proof"])
            except ValueError:
                proof = data

            if public_inputs_path is not None:
                with Path(public_inputs_path).open("r") as f:
                    public_inputs = json.load(f)
            else:
                public_inputs = find_item_from_key_patterns(data, ["public"])

            return Groth16Proof(
                a=try_parse_g1_point_from_key(proof, ["a"], curve_id),
                b=try_parse_g2_point_from_key(proof, ["b"], curve_id),
                c=try_parse_g1_point_from_key(proof, ["c"], curve_id),
                public_inputs=[io.to_int(pub) for pub in public_inputs],
            )
        except FileNotFoundError:
            raise FileNotFoundError(f"The file {proof_path} was not found.")
        except json.JSONDecodeError:
            raise ValueError(f"The file {proof_path} does not contain valid JSON.")

    def serialize_to_calldata(self) -> list[int]:
        cd = []
        cd.extend(io.bigint_split(self.a.x))
        cd.extend(io.bigint_split(self.a.y))
        cd.extend(io.bigint_split(self.b.x[0]))
        cd.extend(io.bigint_split(self.b.x[1]))
        cd.extend(io.bigint_split(self.b.y[0]))
        cd.extend(io.bigint_split(self.b.y[1]))
        cd.extend(io.bigint_split(self.c.x))
        cd.extend(io.bigint_split(self.c.y))
        cd.append(len(self.public_inputs))
        for pub in self.public_inputs:
            cd.extend(io.bigint_split(pub, 2, 2**128))
        return cd
