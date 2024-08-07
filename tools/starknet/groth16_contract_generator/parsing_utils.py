import dataclasses
import json
import os
from pathlib import Path
from typing import Any, Dict, List

from hydra.definitions import CurveID, G1G2Pair, G1Point, G2Point
from hydra.hints.io import to_int
from hydra.modulo_circuit_structs import (
    E12D,
    G1PointCircuit,
    G2PointCircuit,
    StructArray,
)
from hydra.precompiled_circuits.multi_miller_loop import MultiMillerLoopCircuit


@dataclasses.dataclass(slots=True)
class Groth16VerifyingKey:
    alpha: G1Point
    beta: G2Point
    gamma: G2Point
    delta: G2Point
    ic: List[G1Point]

    @property
    def curve_id(self) -> CurveID:
        return self.alpha.curve_id

    def from_json(file_path: str | Path) -> "Groth16VerifyingKey":
        path = Path(file_path)
        try:
            with path.open("r") as f:
                data = json.load(f)

            curve_id = CurveID.from_str(data["eliptic_curve_id"])
            verifying_key = data["verifying_key"]
            return Groth16VerifyingKey(
                alpha=G1Point(
                    x=to_int(verifying_key["alpha_g1"]["x"]),
                    y=to_int(verifying_key["alpha_g1"]["y"]),
                    curve_id=curve_id,
                ),
                beta=G2Point(
                    x=(
                        to_int(verifying_key["beta_g2"]["x"][0]),
                        to_int(verifying_key["beta_g2"]["x"][1]),
                    ),
                    y=(
                        to_int(verifying_key["beta_g2"]["y"][0]),
                        to_int(verifying_key["beta_g2"]["y"][1]),
                    ),
                    curve_id=curve_id,
                ),
                gamma=G2Point(
                    x=(
                        to_int(verifying_key["gamma_g2"]["x"][0]),
                        to_int(verifying_key["gamma_g2"]["x"][1]),
                    ),
                    y=(
                        to_int(verifying_key["gamma_g2"]["y"][0]),
                        to_int(verifying_key["gamma_g2"]["y"][1]),
                    ),
                    curve_id=curve_id,
                ),
                delta=G2Point(
                    x=(
                        to_int(verifying_key["delta_g2"]["x"][0]),
                        to_int(verifying_key["delta_g2"]["x"][1]),
                    ),
                    y=(
                        to_int(verifying_key["delta_g2"]["y"][0]),
                        to_int(verifying_key["delta_g2"]["y"][1]),
                    ),
                    curve_id=curve_id,
                ),
                ic=[
                    G1Point(
                        x=to_int(point["x"]), y=to_int(point["y"]), curve_id=curve_id
                    )
                    for point in verifying_key["ic"]
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

    def from_json(file_path: str | Path) -> "Groth16Proof":
        path = Path(file_path)
        try:
            with path.open("r") as f:
                data = json.load(f)
            curve_id = CurveID(data["curve_id"])
            proof = data["proof"]
            return Groth16Proof(
                a=G1Point(
                    x=to_int(proof["a"]["x"]),
                    y=to_int(proof["a"]["y"]),
                    curve_id=curve_id,
                ),
                b=G2Point(
                    x=(
                        to_int(proof["b"]["x"][0]),
                        to_int(proof["b"]["x"][1]),
                    ),
                    y=(
                        to_int(proof["b"]["y"][0]),
                        to_int(proof["b"]["y"][1]),
                    ),
                    curve_id=curve_id,
                ),
                c=G1Point(
                    x=to_int(proof["c"]["x"]),
                    y=to_int(proof["c"]["y"]),
                    curve_id=curve_id,
                ),
            )
        except FileNotFoundError:
            raise FileNotFoundError(f"The file {file_path} was not found.")
        except json.JSONDecodeError:
            raise ValueError(f"The file {file_path} does not contain valid JSON.")
