import binascii
from dataclasses import dataclass
from enum import Enum
from typing import List, Optional, Union

import requests

from garaga.definitions import CurveID, Fp2, G1Point, G2Point, get_base_field


class DrandNetwork(Enum):
    default = "8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce"
    quicknet = "52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971"


@dataclass
class NetworkInfo:
    public_key: Union[G1Point, G2Point]
    period: int
    genesis_time: int
    hash: str
    group_hash: str
    scheme_id: str
    beacon_id: Optional[str] = None


@dataclass
class RandomnessBeacon:
    round: int
    randomness: str
    signature: str
    previous_signature: Optional[str] = None


BASE_URL = "https://api.drand.sh"


def deserialize_bls_point(s_string: bytes) -> Union[G1Point, G2Point]:
    m_byte = s_string[0] & 0xE0
    if m_byte in (0x20, 0x60, 0xE0):
        raise ValueError("Invalid encoding")

    C_bit = (m_byte & 0x80) >> 7
    I_bit = (m_byte & 0x40) >> 6
    S_bit = (m_byte & 0x20) >> 5

    s_string = bytes([s_string[0] & 0x1F]) + s_string[1:]

    if I_bit == 1:
        if any(b != 0 for b in s_string):
            raise ValueError("Invalid encoding for point at infinity")
        return (
            G1Point.infinity(CurveID.BLS12_381)
            if len(s_string) in (48, 96)
            else G2Point.infinity(CurveID.BLS12_381)
        )

    if C_bit == 0:
        if len(s_string) == 96:  # G1 point (uncompressed)
            x = int.from_bytes(s_string[:48], "big")
            y = int.from_bytes(s_string[48:], "big")
            return G1Point(x, y, CurveID.BLS12_381)
        elif len(s_string) == 192:  # G2 point (uncompressed)
            x0 = int.from_bytes(s_string[:48], "big")
            x1 = int.from_bytes(s_string[48:96], "big")
            y0 = int.from_bytes(s_string[96:144], "big")
            y1 = int.from_bytes(s_string[144:], "big")
            return G2Point((x0, x1), (y0, y1), CurveID.BLS12_381)
        else:
            raise ValueError(f"Invalid length for uncompressed point: {len(s_string)}")
    else:  # C_bit == 1
        x = int.from_bytes(s_string, "big")
        if len(s_string) == 48:  # G1 point (compressed)
            field = get_base_field(CurveID.BLS12_381)
            y2 = field(x**3 + 4)
            y = y2.sqrt()
            Y_bit = y.value & 1
            if S_bit != Y_bit:
                y = -y
            return G1Point(x, y.value, CurveID.BLS12_381)
        elif len(s_string) == 96:  # G2 point (compressed)
            field = get_base_field(CurveID.BLS12_381, Fp2)
            x = field((x >> 384, x & ((1 << 384) - 1)))
            y2 = x**3 + field((4, 4))
            y = y2.sqrt()
            Y_bit = y.a1.value & 1
            if S_bit != Y_bit:
                y = -y
            return G2Point(
                (x.a0.value, x.a1.value),
                (y.a0.value, y.a1.value),
                CurveID.BLS12_381,
            )
        else:
            raise ValueError(f"Invalid length for compressed point: {len(s_string)}")


def get_chains() -> List[str]:
    response = requests.get(f"{BASE_URL}/chains")
    chains = response.json()
    # remove deprecated fastner
    fastnet = "dbd506d6ef76e5f386f41c651dcb808c5bcbd75471cc4eafa3f4df7ad4e4c493"
    chains.remove(fastnet)
    return chains


def get_chain_info(chain_hash: str) -> NetworkInfo:
    response = requests.get(f"{BASE_URL}/{chain_hash}/info")
    data = response.json()

    # Parse the public key
    public_key_hex = data["public_key"]
    public_key_bytes = binascii.unhexlify(public_key_hex)

    try:
        public_key = deserialize_bls_point(public_key_bytes)
    except Exception as e:
        public_key = G2Point.infinity(CurveID.BLS12_381)

    return NetworkInfo(
        public_key=public_key,
        period=data["period"],
        genesis_time=data["genesis_time"],
        hash=data["hash"],
        group_hash=data["groupHash"],
        scheme_id=data["schemeID"],
        beacon_id=data.get("metadata", {}).get("beaconID"),
    )


def get_latest_randomness(chain_hash: str) -> RandomnessBeacon:
    response = requests.get(f"{BASE_URL}/{chain_hash}/public/latest")
    return _parse_randomness_beacon(response.json())


def get_randomness(chain_hash: str, round_number: int) -> RandomnessBeacon:
    response = requests.get(f"{BASE_URL}/{chain_hash}/public/{round_number}")
    return _parse_randomness_beacon(response.json())


def _parse_randomness_beacon(data: dict) -> RandomnessBeacon:
    return RandomnessBeacon(
        round=data["round"],
        randomness=data["randomness"],
        signature=data["signature"],
        previous_signature=data.get("previous_signature"),
    )


def print_all_chain_info() -> dict[DrandNetwork, NetworkInfo]:
    chains = get_chains()
    print(f"Found {len(chains)} chains:")
    print("-" * 40)

    chain_infos = {}

    for chain_hash in chains:
        try:
            info = get_chain_info(chain_hash)
            chain_infos[DrandNetwork(chain_hash)] = info
            print(f"Chain: {chain_hash}")
            print(f"  Public Key: {info.public_key}")
            print(f"  Period: {info.period} seconds")
            print(f"  Genesis Time: {info.genesis_time}")
            print(f"  Hash: {info.hash}")
            print(f"  Group Hash: {info.group_hash}")
            print(f"  Scheme ID: {info.scheme_id}")
            if info.beacon_id:
                print(f"  Beacon ID: {info.beacon_id}")
            print("-" * 40)
        except Exception as e:
            print(f"Error fetching info for chain {chain_hash}: {str(e)}")
            print("-" * 40)
            raise e

    return chain_infos


# Example usage
if __name__ == "__main__":
    chain_infos = print_all_chain_info()

    latest_randomness = get_latest_randomness(chain_infos[DrandNetwork.default].hash)
    print("Latest randomness:", latest_randomness)

    specific_round = get_randomness(chain_infos[DrandNetwork.quicknet].hash, 1000)
    print("Randomness for round 1000:", specific_round)
