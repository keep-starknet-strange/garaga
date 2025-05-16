import garaga.hints.io as io
from garaga import garaga_rs
from garaga.drand.client import (
    DrandNetwork,
    G2Point,
    digest_func,
    get_chain_info,
    get_randomness,
)
from garaga.signature import hash_to_curve
from garaga.starknet.tests_and_calldata_generators.map_to_curve import *
from garaga.starknet.tests_and_calldata_generators.mpcheck import (
    G1G2Pair,
    MPCheckCalldataBuilder,
)


def drand_round_to_calldata(round_number: int, use_rust=False) -> list[int]:
    if use_rust:
        return _drand_round_to_calldata_rust(round_number)

    message = digest_func(round_number)
    # print(f"round {round_number} message {message}")
    msg_point = hash_to_curve(message, CurveID.BLS12_381, "sha256")

    chain = get_chain_info(DrandNetwork.quicknet.value)

    round = get_randomness(chain.hash, round_number)

    sig_pt = round.signature_point
    ###################
    mpc_builder = MPCheckCalldataBuilder(
        curve_id=CurveID.BLS12_381,
        pairs=[
            G1G2Pair(p=sig_pt, q=G2Point.get_nG(CurveID.BLS12_381, 1)),
            G1G2Pair(p=msg_point, q=-chain.public_key),
        ],
        n_fixed_g2=2,
        public_pair=None,
    )

    cd = []
    sig_pt: G1Point
    cd.append(round_number)
    cd.extend(io.bigint_split(sig_pt.x))
    cd.extend(io.bigint_split(sig_pt.y))
    cd.extend(build_hash_to_curve_hint(message).to_calldata())
    cd.extend(mpc_builder.serialize_to_calldata())

    return [len(cd)] + cd


def _drand_round_to_calldata_rust(
    round_number: int,
) -> list[int]:
    chain = get_chain_info(DrandNetwork.quicknet.value)
    round = get_randomness(chain.hash, round_number)
    randomness = round.randomness
    signature = int(round.signature, 16)
    data = [
        round_number,
        randomness,
        signature,
    ]
    return garaga_rs.drand_calldata_builder(data)


if __name__ == "__main__":

    drand_round_to_calldata(1)
    drand_round_to_calldata(2)
    # drand_round_to_calldata(3)
