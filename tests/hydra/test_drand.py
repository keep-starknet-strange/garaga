import hashlib

from garaga.definitions import CurveID, G2Point
from garaga.drand.client import (
    DrandNetwork,
    digest_func,
    get_randomness,
    print_all_chain_info,
)
from garaga.signature import hash_to_curve


def test_drand_sig_verification():
    chain_infos = print_all_chain_info()

    network = DrandNetwork.quicknet
    chain = chain_infos[network]

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
    )
