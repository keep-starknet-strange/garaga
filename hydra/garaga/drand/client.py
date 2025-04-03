import binascii
import functools
import hashlib
import random
from dataclasses import dataclass
from enum import Enum
from typing import List, Optional, Union

import requests
from requests.exceptions import RequestException

from garaga.definitions import CurveID, Fp2, G1Point, G2Point, get_base_field
from garaga.hints import io


class DrandNetwork(Enum):
    default = "8990e7a9aaed2ffed73dbd7092123d6f289930540d7651336225dc172e51b2ce"
    quicknet = "52db9ba70e0cc0f6eaf7803dd07447a1f5477735fd3f661792ba94600c84e971"


def digest_func(round_number: int) -> bytes:
    assert isinstance(round_number, int)
    assert 0 <= round_number < 2**64
    h = hashlib.sha256()
    h.update(round_number.to_bytes(8, byteorder="big"))
    return h.digest()


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
    round_number: int
    randomness: int
    signature: str
    previous_signature: Optional[str] = None

    @property
    def signature_point(self) -> G1Point | G2Point:
        return deserialize_bls_point(bytes.fromhex(self.signature))


BASE_URLS = [
    "https://drand.cloudflare.com",
    "https://api.drand.sh",
    "https://api2.drand.sh",
    "https://api3.drand.sh",
]


def make_request(endpoint: str) -> requests.Response:
    # Create a copy and shuffle instead of random.choice for better distribution
    base_urls = BASE_URLS.copy()
    random.shuffle(base_urls)

    last_error = None
    for url in base_urls:
        try:
            response = requests.get(f"{url}{endpoint}", timeout=5)  # Add timeout
            response.raise_for_status()
            return response
        except Exception as e:
            print(f"Request to {url} failed: {str(e)}")
            last_error = e
            continue

    raise RequestException(f"All URLs failed. Last error: {last_error}")


def deserialize_bls_point(s_string: bytes) -> Union[G1Point, G2Point]:
    m_byte = s_string[0] & 0xE0
    if m_byte in (0x20, 0x60, 0xE0):
        raise ValueError("Invalid encoding")

    C_bit = (m_byte & 0x80) >> 7  # Compression bit
    I_bit = (m_byte & 0x40) >> 6  # Infinity bit
    S_bit = (m_byte & 0x20) >> 5  # Sign bit

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
            if S_bit == 1:
                y = y2.sqrt(min_root=False)
            else:
                y = y2.sqrt(min_root=True)
            return G1Point(x, y.value, CurveID.BLS12_381)
        elif len(s_string) == 96:  # G2 point (compressed)
            field = get_base_field(CurveID.BLS12_381, Fp2)
            x = field((x & ((1 << 384) - 1), x >> 384))
            y2 = x**3 + field((4, 4))
            y = y2.sqrt()

            if S_bit == 1:
                # Choose largest root
                # print("choose largest")
                if not y.lexicographically_largest():
                    # print("root was not largest, negating")
                    y = -y
            else:
                # Choose smallest root
                # print("choose smallest")
                if y.lexicographically_largest():
                    # print("root was largest, negating")
                    y = -y

            return G2Point(
                (x.a0.value, x.a1.value),
                (y.a0.value, y.a1.value),
                CurveID.BLS12_381,
            )
        else:
            raise ValueError(f"Invalid length for compressed point: {len(s_string)}")


def get_chains() -> List[str]:
    response = make_request("/chains")
    all_chains = response.json()
    # only keep chains present in DrandNetwork enum
    chains = [
        chain
        for chain in all_chains
        if chain in [network.value for network in DrandNetwork]
    ]
    return chains


def get_chain_info(chain_hash: str) -> NetworkInfo:
    response = make_request(f"/{chain_hash}/info")
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
    response = make_request(f"/{chain_hash}/public/latest")
    return _parse_randomness_beacon(response.json())


def get_randomness(chain_hash: str, round_number: int) -> RandomnessBeacon:
    response = make_request(f"/{chain_hash}/public/{round_number}")
    return _parse_randomness_beacon(response.json())


def _parse_randomness_beacon(data: dict) -> RandomnessBeacon:
    return RandomnessBeacon(
        round_number=io.to_int(data["round"]),
        randomness=int(data["randomness"], 16),
        signature=data["signature"],
        previous_signature=data.get("previous_signature"),
    )


@functools.lru_cache(maxsize=None)
def print_all_chain_info() -> dict[DrandNetwork, NetworkInfo]:
    # Try multiple times to get chains
    max_retries = 3
    for attempt in range(max_retries):
        try:
            chains = get_chains()
            if not chains:
                raise ValueError("No chains returned")

            print(f"Found {len(chains)} chains: {chains}")
            print("-" * 40)

            chain_infos = {}
            expected_networks = set(DrandNetwork)

            for chain_hash in chains:
                try:
                    info = get_chain_info(chain_hash)
                    try:
                        network = DrandNetwork(chain_hash)
                        chain_infos[network] = info
                        expected_networks.remove(network)

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
                    except ValueError:
                        print(f"Unknown chain hash: {chain_hash}")
                        continue
                except Exception as e:
                    print(f"Error fetching info for chain {chain_hash}: {str(e)}")
                    continue

            # If we found all expected networks, return the results
            if not expected_networks:
                return chain_infos

            print(f"Missing networks: {[n.name for n in expected_networks]}")

        except Exception as e:
            print(f"Attempt {attempt + 1}/{max_retries} failed: {str(e)}")
            if attempt < max_retries - 1:
                print("Retrying...")
                continue

    raise RuntimeError(
        f"Failed to get complete chain info after {max_retries} attempts"
    )


# Example usage
if __name__ == "__main__":
    chain_infos = print_all_chain_info()
    from garaga.modulo_circuit_structs import StructArray
    from garaga.signature import hash_to_curve

    # latest_randomness = get_latest_randomness(chain_infos[DrandNetwork.default].hash)
    # print("Latest randomness:", latest_randomness)
    network = DrandNetwork.quicknet
    chain = chain_infos[network]
    print(chain.public_key)
    print(-chain.public_key)

    round = get_randomness(chain.hash, 1000)
    print("Randomness for round 1000:", round)
    sha256 = hashlib.sha256()
    sha256.update(bytes.fromhex(round.signature))
    print("randomness", sha256.hexdigest())
    print("random beacon", hex(round.randomness))

    msg_point = hash_to_curve(
        digest_func(round.round_number), CurveID.BLS12_381, "sha256"
    )
    print("message", msg_point)

    from garaga.definitions import G1G2Pair
    from garaga.modulo_circuit_structs import G2Line, StructArray
    from garaga.precompiled_circuits.multi_miller_loop import precompute_lines

    print(
        "pairing",
        G1G2Pair.pair(
            [
                G1G2Pair(
                    p=round.signature_point, q=G2Point.get_nG(CurveID.BLS12_381, 1)
                ),
                G1G2Pair(p=msg_point, q=-chain.public_key),
            ],
            curve_id=CurveID.BLS12_381,
        ).value_coeffs,
    )

    lines = precompute_lines([G2Point.get_nG(CurveID.BLS12_381, 1), -chain.public_key])
    precomputed_lines = StructArray(
        name="lines",
        elmts=[
            G2Line(name=f"line{i}", elmts=lines[i : i + 4])
            for i in range(0, len(lines), 4)
        ],
    )

    def generate_precomputed_lines_code(precomputed_lines: StructArray) -> str:
        return f"pub const precomputed_lines: [G2Line; {len(precomputed_lines)//4}] = {precomputed_lines.serialize(raw=True, const=True)};"

    # print(generate_precomputed_lines_code(precomputed_lines))
