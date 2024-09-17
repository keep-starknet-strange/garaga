"""
Various tools for bls signatures or other signature schemes.
"""

from __future__ import annotations

import hashlib
from typing import Protocol, TypeVar

from garaga.algebra import PyFelt
from garaga.definitions import CurveID, get_base_field

T = TypeVar("T", bound="HashProtocol")


class HashProtocol(Protocol):
    # Attributes
    block_size: int  #
    digest_size: int  # in bytes
    name: str

    # Methods
    def update(self, data: bytes) -> None: ...
    def digest(self) -> bytes: ...
    def hexdigest(self) -> str: ...
    def copy(self: T) -> T: ...


import math

G1_DOMAIN = DST = b"BLS_SIG_BLS12381G1_XMD:SHA-256_SSWU_RO_NUL_"


MAX_DST_LENGTH = 255
LONG_DST_PREFIX = b"H2C-OVERSIZE-DST-"


class ExpanderXmd:
    def __init__(
        self,
        hash_name: str,
        dst: bytes = DST,
        curve_id: CurveID = CurveID.BLS12_381,
    ):
        self.hash_name = hash_name
        self.hasher = hashlib.new(hash_name)
        self.dst = dst
        self.curve_id = curve_id
        self.block_size = get_len_per_elem(get_base_field(curve_id).p)

    def construct_dst_prime(self) -> bytes:
        if len(self.dst) > MAX_DST_LENGTH:
            hasher_copy = self.hasher.copy()
            hasher_copy.update(LONG_DST_PREFIX)
            hasher_copy.update(self.dst)
            dst_prime = hasher_copy.digest()
        else:
            print(f"dst len is < {MAX_DST_LENGTH}")
            dst_prime = self.dst

        dst_prime += bytes([len(dst_prime)])
        return dst_prime

    def expand_message_xmd(self, msg: bytes, n: int) -> bytes:
        b_len = self.hasher.digest_size
        ell = (n + (b_len - 1)) // b_len
        assert (
            ell <= 255
        ), "The ratio of desired output to the output size of hash function is too large!"

        dst_prime = self.construct_dst_prime()
        print(f"dst prime {dst_prime.hex()}")
        z_pad = bytes([0] * self.block_size)
        assert n < (1 << 16), "Length should be smaller than 2^16"
        lib_str = n.to_bytes(2, "big")

        self.hasher.update(z_pad)
        self.hasher.update(msg)
        self.hasher.update(lib_str)
        self.hasher.update(bytes([0]))
        self.hasher.update(dst_prime)
        b0 = self.hasher.digest()

        hasher = hashlib.new(self.hash_name)
        hasher.update(b0)
        hasher.update(bytes([1]))
        hasher.update(dst_prime)
        bi = hasher.digest()

        uniform_bytes = bi

        for i in range(2, ell + 1):
            b0_xor_bi = bytes(x ^ y for x, y in zip(b0, bi))
            hasher = hashlib.new(self.hash_name)
            hasher.update(b0_xor_bi)
            hasher.update(bytes([i]))
            hasher.update(dst_prime)
            bi = hasher.digest()
            uniform_bytes += bi

        return uniform_bytes[:n]


def get_len_per_elem(p: int, sec_param: int = 128) -> int:
    """
    This function computes the length in bytes that a hash function should output
    for hashing an element of type `Field`.

    :param p: The prime modulus of the base field.
    :param sec_param: The security parameter.
    :return: The length in bytes.
    """
    # ceil(log2(p))
    base_field_size_in_bits = p.bit_length()
    # ceil(log2(p)) + security_parameter
    base_field_size_with_security_padding_in_bits = base_field_size_in_bits + sec_param
    # ceil((ceil(log2(p)) + security_parameter) / 8)
    bytes_per_base_field_elem = math.ceil(
        base_field_size_with_security_padding_in_bits / 8
    )
    return bytes_per_base_field_elem


def hash_to_field(
    message: bytes, count: int, curve_id: int, hash_name: str
) -> list[PyFelt]:
    field = get_base_field(curve_id)

    expander = ExpanderXmd(hash_name, dst=DST, curve_id=curve_id)

    len_per_elem = get_len_per_elem(field.p)
    len_in_bytes = count * len_per_elem
    print(f"len in bytes: {len_in_bytes}")
    print(f"message {message.hex()}")
    uniform_bytes = expander.expand_message_xmd(message, len_in_bytes)
    print(f"uniform bytes {uniform_bytes.hex()}")
    output = []

    for i in range(0, len_in_bytes, len_per_elem):
        element = int.from_bytes(uniform_bytes[i : i + len_per_elem], "big")
        output.append(element)

    return [field(x) for x in output]


if __name__ == "__main__":

    def test_hash_to_field():
        res = hash_to_field(
            message=b"Hello, World!",
            count=2,
            curve_id=CurveID.BLS12_381,
            hash_name="sha256",
        )

        field = get_base_field(CurveID.BLS12_381)

        assert [x.value for x in res] == [
            2162792105491427725912070356725320455528056118179305300106498860235975843802512462082887053454085287130500476441750,
            40368511435268498384669958495624628965655407346873103876018487738713032717501957266398124814691972213333393099218,
        ]

    test_hash_to_field()
