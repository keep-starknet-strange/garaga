import hashlib
from dataclasses import dataclass

from garaga.definitions import CURVES, CurveID, G1G2Pair, G1Point, G2Point
from garaga.hints.tower_backup import E12
from garaga.signature import hash_to_curve


@dataclass
class CipherText:
    U: G2Point
    V: bytes
    W: bytes

    def __post_init__(self):
        assert len(self.V) == len(self.W) == 16


def encrypt_for_round(
    drand_public_key: G2Point, round: int, message: bytes
) -> CipherText:
    assert len(message) == 16, f"Message should be 16 bytes: {len(message)}"

    msg_at_round = hashlib.sha256(int.to_bytes(round, 8, "big")).digest()
    # print(f"msg_at_round list of ints: {list(msg_at_round)}")
    pt_at_round = hash_to_curve(msg_at_round, CurveID.BLS12_381)

    gid: E12 = G1G2Pair.pair([G1G2Pair(p=pt_at_round, q=drand_public_key)])

    # sigma: bytes = secrets.token_bytes(16)
    # Use constant for debugging
    sigma = b"0000000000000000"
    assert len(sigma) == 16

    hasher = hashlib.sha256()
    hasher.update(b"IBE-H3")
    hasher.update(sigma)
    hasher.update(message)
    r = int.from_bytes(expand_message_drand(hasher.digest(), 32), "little")
    # print(f"r list of ints: {r}")
    r = r % CURVES[CurveID.BLS12_381.value].n

    # U = r * G2
    U = G2Point.get_nG(CurveID.BLS12_381, r)

    # print(f"U: {U}")
    # V = sigma XOR H (rGid)
    rGid: E12 = gid**r

    # print(f"rGid: {rGid.value_coeffs}")

    rgid_serialized = rGid.serialize()
    # Print bytes as hex strings:
    # print(f"rGid hex : {rgid_serialized.hex()}")
    # print(f"rGid serialized: {list(rgid_serialized)} len: {len(rgid_serialized)}")
    rgid_hash = hashlib.sha256()
    rgid_hash.update(b"IBE-H2")
    rgid_hash.update(rgid_serialized)
    rgid_hash = rgid_hash.digest()
    # Take first 16 bytes only :
    rgid_hash = rgid_hash[:16]
    # print(f"rgid_hash hex: {rgid_hash.hex()}")

    V = bytes([a ^ b for a, b in zip(sigma, rgid_hash)])
    # print(f"V hex: {V.hex()}")

    # 6. Compute W = M XOR H(sigma)
    W = bytes([a ^ b for a, b in zip(message, rgid_hash)])
    sigma_hash = hashlib.sha256()
    sigma_hash.update(b"IBE-H4")
    sigma_hash.update(sigma)
    sigma_hash = sigma_hash.digest()[:16]  # First 16 bytes only
    # print(f"sigma_hash hex: {sigma_hash.hex()}")
    W = bytes([a ^ b for a, b in zip(message, sigma_hash)])
    # print(f"W hex: {W.hex()}")

    return CipherText(U, V, W)


def decrypt_at_round(signature_at_round: G1Point, c: CipherText):
    # 1. Compute sigma = V XOR H2(e(rP,Sig))

    r_gid = G1G2Pair.pair([G1G2Pair(p=signature_at_round, q=c.U)])
    r_gid_serialized = r_gid.serialize()
    rgid_hash = hashlib.sha256()
    rgid_hash.update(b"IBE-H2")
    rgid_hash.update(r_gid_serialized)
    rgid_hash = rgid_hash.digest()
    rgid_hash = rgid_hash[:16]  # First 16 bytes only

    sigma = bytes([a ^ b for a, b in zip(c.V, rgid_hash)])

    # print(f"sigma hex: {sigma.hex()}")

    # 2. Compute Msg = W XOR H4(sigma)
    sigma_hash = hashlib.sha256()
    sigma_hash.update(b"IBE-H4")
    sigma_hash.update(sigma)
    sigma_hash = sigma_hash.digest()[:16]  # First 16 bytes only
    message = bytes([a ^ b for a, b in zip(c.W, sigma_hash)])
    # print(f"message utf-8: {message.decode('utf-8')}")

    # 3. Check U = G^r

    rh = hashlib.sha256()
    rh.update(b"IBE-H3")
    rh.update(sigma)
    rh.update(message)
    rh = rh.digest()
    rh = expand_message_drand(rh, 32)
    r = int.from_bytes(rh, "little") % CURVES[CurveID.BLS12_381.value].n
    U = G2Point.get_nG(CurveID.BLS12_381, r)
    assert U == c.U
    return message


def expand_message_drand(msg: bytes, buf_size: int) -> bytes:
    BITS_TO_MASK_FOR_BLS12381 = 1
    order = CURVES[CurveID.BLS12_381.value].n
    for i in range(1, 65536):  # u16::MAX is 65535
        # Hash iteratively: H(i || msg)
        h = hashlib.sha256()
        h.update(i.to_bytes(2, byteorder="little"))
        h.update(msg)
        hash_result = bytearray(h.digest())

        # Mask the first byte
        hash_result[0] >>= BITS_TO_MASK_FOR_BLS12381
        reversed_hash = hash_result[::-1]
        scalar = int.from_bytes(reversed_hash, "little") % order
        if scalar != 0:
            return reversed_hash[:buf_size]

    raise ValueError("Failed to generate a valid scalar after 65535 iterations")


if __name__ == "__main__":
    from garaga.drand.client import DrandNetwork, get_randomness, print_all_chain_info

    chain_infos = print_all_chain_info()
    network = DrandNetwork.quicknet
    chain = chain_infos[network]

    master = chain.public_key

    round = 128

    msg = b"hello\x00\x00\x00\x00\x00\x00\x00\x00abc"
    ciph = encrypt_for_round(master, round, msg)

    # print(f"CipherText: {ciph}")

    # print(f"V : {list(ciph.V)}")
    # print(f"W : {list(ciph.W)}")

    chain = chain_infos[network]
    beacon = get_randomness(chain.hash, round)
    signature_at_round = beacon.signature_point

    print(f"signature_at_round: {signature_at_round}")
    msg_decrypted = decrypt_at_round(signature_at_round, ciph)
    assert msg_decrypted == msg

    print(f"msg utf-8: {msg.decode('utf-8')}")
    print(f"msg_decrypted utf-8: {msg_decrypted.decode('utf-8')}")
