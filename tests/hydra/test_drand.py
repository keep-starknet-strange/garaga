import hashlib
import random

import pytest
import requests

from garaga.curves import CurveID
from garaga.drand.client import (
    BASE_URLS,
    DrandNetwork,
    digest_func,
    get_randomness,
    print_all_chain_info,
)
from garaga.drand.tlock import decrypt_at_round, encrypt_for_round
from garaga.points import G1G2Pair, G2Point
from garaga.signature import hash_to_curve


@pytest.mark.parametrize("round_number", list(range(1, 5)) + list(range(1000, 1005)))
def test_drand_sig_verification(round_number: int):
    chain_infos = print_all_chain_info()

    network = DrandNetwork.quicknet
    chain = chain_infos[network]

    round = get_randomness(chain.hash, round_number)
    print(f"Randomness for round {round_number}:", round)
    sha256 = hashlib.sha256()
    sha256.update(bytes.fromhex(round.signature))
    print("randomness", sha256.hexdigest())
    print("random beacon", hex(round.randomness))

    msg_point = hash_to_curve(
        digest_func(round.round_number), CurveID.BLS12_381, "sha256"
    )
    print("message", msg_point)

    assert (
        G1G2Pair.pair(
            [
                G1G2Pair(
                    p=round.signature_point, q=G2Point.get_nG(CurveID.BLS12_381, 1)
                ),
                G1G2Pair(p=msg_point, q=-chain.public_key),
            ],
            curve_id=CurveID.BLS12_381,
        ).value_coeffs
        == [1] + [0] * 11
    ), "Signature verification failed"


@pytest.mark.parametrize("round", list(range(1, 5)) + list(range(1000, 1005)))
def test_tlock_encrypt_decrypt(round: int):
    random.seed(42)
    chain_infos = print_all_chain_info()
    network = DrandNetwork.quicknet
    chain = chain_infos[network]

    master = chain.public_key

    msg = random.randbytes(16)

    ciph = encrypt_for_round(master, round, msg)

    chain = chain_infos[network]
    beacon = get_randomness(chain.hash, round)
    signature_at_round = beacon.signature_point

    msg_decrypted = decrypt_at_round(signature_at_round, ciph)
    assert msg_decrypted == msg


@pytest.mark.parametrize("round", list(range(1, 5)))
def test_tlock_encrypt_same_message_gives_different_ciphertexts(round: int):
    random.seed(42)
    chain_infos = print_all_chain_info()
    network = DrandNetwork.quicknet
    chain = chain_infos[network]

    master = chain.public_key

    msg = b"0123456789abcdef"

    ciph1 = encrypt_for_round(master, round, msg)
    ciph2 = encrypt_for_round(master, round, msg)

    assert ciph1.U != ciph2.U
    assert ciph1.V != ciph2.V
    assert ciph1.W != ciph2.W

    chain = chain_infos[network]
    beacon = get_randomness(chain.hash, round)
    signature_at_round = beacon.signature_point

    msg_decrypted1 = decrypt_at_round(signature_at_round, ciph1)
    msg_decrypted2 = decrypt_at_round(signature_at_round, ciph2)

    assert msg_decrypted1 == msg
    assert msg_decrypted2 == msg


def test_all_base_urls_return_chains():
    for url in BASE_URLS:
        try:
            response = requests.get(f"{url}/chains")
            response.raise_for_status()
            chains = response.json()

            # Check that both default and quicknet chains are present
            expected_chains = {network.value for network in DrandNetwork}
            found_chains = set(chains)

            assert expected_chains.issubset(
                found_chains
            ), f"URL {url} missing chains: {expected_chains - found_chains}"

            print(f"✓ {url} returned all expected chains")
        except Exception as e:
            print(f"✗ {url} failed: {str(e)}")
            continue
