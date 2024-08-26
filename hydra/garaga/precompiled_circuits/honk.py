import binascii
import json
import os
from dataclasses import dataclass
from enum import Enum

from web3 import Web3

from garaga.algebra import PyFelt
from garaga.definitions import CURVES, CurveID, G1G2Pair

## uint256/bytes32 conversion


# Converts 32-bytes to 256-bit integer (big endian)
def b2n(b: bytes) -> int:
    assert len(b) == 32
    return int.from_bytes(b, "big")


# Converts 256-bit integer to 32-bytes (big endian)
def n2b(n: int) -> bytes:
    assert 0 <= n and n < (1 << 256)
    return n.to_bytes(32, "big")


## abi encoding


def abi_encode_packed(data: list[int]) -> bytes:
    return b"".join(map(n2b, data))


## hashing


def keccak256(b: bytes) -> bytes:
    return Web3.keccak(b)


## bn256


def bn256_add(p1: tuple[int, int], p2: tuple[int, int]) -> tuple[int, int]:
    from garaga.definitions import G1Point  # shadowed locally

    a = G1Point(p1[0], p1[1], CurveID.BN254)
    b = G1Point(p2[0], p2[1], CurveID.BN254)
    c = a.add(b)
    return (c.x, c.y)


def bn256_scalar_mul(p1: tuple[int, int], scalar: int) -> tuple[int, int]:
    from garaga.definitions import G1Point  # shadowed locally

    a = G1Point(p1[0], p1[1], CurveID.BN254)
    b = a.scalar_mul(scalar)
    return (b.x, b.y)


def bn256_pairing(
    p1_list: list[tuple[int, int]], p2_list: list[tuple[int, int, int, int]]
) -> bool:
    from garaga.definitions import G1Point, G2Point  # shadowed locally

    assert len(p1_list) == len(p2_list)
    data = []
    for i in range(len(p1_list)):
        p1 = p1_list[i]
        p2 = p2_list[i]
        a = G1Point(p1[0], p1[1], CurveID.BN254)
        # important: fp2 coordinates of the G2 points need to be inverted
        b = G2Point((p2[1], p2[0]), (p2[3], p2[2]), CurveID.BN254)
        data.append(G1G2Pair(a, b))
    result = G1G2Pair.pair(data).value_coeffs
    success = result[0] == 1 and all(value == 0 for value in result[1:])
    return success


## honk verifier

## Fr.sol


def Fr(value: int) -> PyFelt:
    return PyFelt(value=value % P, p=P)


def Fr_from(value: bytes) -> PyFelt:
    return Fr(b2n(value))


def Fr_invert(value: PyFelt) -> PyFelt:
    return value.__inv__()


## HonkTypes.sol

# Temp only set here for testing, logn will be templated
LOG_N: int = 0x0000000000000000000000000000000000000000000000000000000000000010

NUMBER_OF_SUBRELATIONS: int = 18
BATCHED_RELATION_PARTIAL_LENGTH: int = 7
NUMBER_OF_ENTITIES: int = 43
NUMBER_OF_ALPHAS: int = 17

# Prime field order
Q: int = CURVES[CurveID.BN254.value].p  # EC group order
P: int = CURVES[CurveID.BN254.value].n  # Prime field order


class WIRE(Enum):
    Q_C = 0
    Q_L = 1
    Q_R = 2
    Q_O = 3
    Q_4 = 4
    Q_M = 5
    Q_ARITH = 6
    Q_SORT = 7
    Q_ELLIPTIC = 8
    Q_AUX = 9
    Q_LOOKUP = 10
    SIGMA_1 = 11
    SIGMA_2 = 12
    SIGMA_3 = 13
    SIGMA_4 = 14
    ID_1 = 15
    ID_2 = 16
    ID_3 = 17
    ID_4 = 18
    TABLE_1 = 19
    TABLE_2 = 20
    TABLE_3 = 21
    TABLE_4 = 22
    LAGRANGE_FIRST = 23
    LAGRANGE_LAST = 24
    W_L = 25
    W_R = 26
    W_O = 27
    W_4 = 28
    SORTED_ACCUM = 29
    Z_PERM = 30
    Z_LOOKUP = 31
    TABLE_1_SHIFT = 32
    TABLE_2_SHIFT = 33
    TABLE_3_SHIFT = 34
    TABLE_4_SHIFT = 35
    W_L_SHIFT = 36
    W_R_SHIFT = 37
    W_O_SHIFT = 38
    W_4_SHIFT = 39
    SORTED_ACCUM_SHIFT = 40
    Z_PERM_SHIFT = 41
    Z_LOOKUP_SHIFT = 42


@dataclass(slots=True, frozen=True)
class G1Point:
    x: int
    y: int


@dataclass(slots=True, frozen=True)
class G1ProofPoint:
    x_0: int
    x_1: int
    y_0: int
    y_1: int


@dataclass(slots=True, frozen=True)
class HonkVerificationKey:
    # Misc Params
    circuitSize: int
    logCircuitSize: int
    publicInputsSize: int
    # Selectors
    qm: G1Point
    qc: G1Point
    ql: G1Point
    qr: G1Point
    qo: G1Point
    q4: G1Point
    qArith: G1Point  # Arithmetic widget
    qSort: G1Point  # Gen perm sort
    qAux: G1Point  # Auxillary
    qElliptic: G1Point  # Auxillary
    qLookup: G1Point  # Lookup
    # Copy cnstraints
    s1: G1Point
    s2: G1Point
    s3: G1Point
    s4: G1Point
    # Copy identity
    id1: G1Point
    id2: G1Point
    id3: G1Point
    id4: G1Point
    # Precomputed lookup table
    t1: G1Point
    t2: G1Point
    t3: G1Point
    t4: G1Point
    # Fixed first and last
    lagrangeFirst: G1Point
    lagrangeLast: G1Point


@dataclass(slots=True, frozen=True)
class HonkProof:
    circuitSize: int
    publicInputsSize: int
    publicInputsOffset: int
    # Free wires
    w1: G1ProofPoint
    w2: G1ProofPoint
    w3: G1ProofPoint
    w4: G1ProofPoint
    # Lookup helpers - classic plookup
    sortedAccum: G1ProofPoint
    zPerm: G1ProofPoint
    zLookup: G1ProofPoint
    # Sumcheck
    sumcheckUnivariates: list[list[PyFelt]]  # [BATCHED_RELATION_PARTIAL_LENGTH][LOG_N]
    sumcheckEvaluations: list[PyFelt]  # [NUMBER_OF_ENTITIES]
    # Zero morph
    zmCqs: list[G1ProofPoint]  # [LOG_N]
    zmCq: G1ProofPoint
    zmPi: G1ProofPoint


## utils.sol


def convertProofPoint(point: G1ProofPoint) -> G1Point:
    return G1Point(x=point.x_0 | (point.x_1 << 136), y=point.y_0 | (point.y_1 << 136))


def ecMul(point: G1Point, scalar: PyFelt) -> G1Point:
    (x, y) = bn256_scalar_mul((point.x, point.y), scalar.value)
    return G1Point(x=x, y=y)


def ecAdd(point0: G1Point, point1: G1Point) -> G1Point:
    (x, y) = bn256_add((point0.x, point0.y), (point1.x, point1.y))
    return G1Point(x=x, y=y)


def ecNeg(point: G1Point) -> G1Point:
    return G1Point(x=point.x, y=(Q - point.y) % Q)


def ecSub(point0: G1Point, point1: G1Point) -> G1Point:
    return ecAdd(point0, ecNeg(point1))


## EcdsaHonkVerificationKey.sol

N: int = 0x0000000000000000000000000000000000000000000000000000000000010000
NUMBER_OF_PUBLIC_INPUTS: int = (
    0x0000000000000000000000000000000000000000000000000000000000000006
)


def loadVerificationKey() -> HonkVerificationKey:
    return HonkVerificationKey(
        circuitSize=0x0000000000000000000000000000000000000000000000000000000000010000,
        logCircuitSize=0x0000000000000000000000000000000000000000000000000000000000000010,
        publicInputsSize=0x0000000000000000000000000000000000000000000000000000000000000006,
        ql=G1Point(
            x=0x2AA1E5D9538920238FBD3438B27E069C1EDB9C2807E75C5CCB78102D502717A5,
            y=0x2C2CEE219FA2DCFC815CF63A3F6519C8EF3A048BB668FCE2136EF09A3F1ED12E,
        ),
        qr=G1Point(
            x=0x001E152CC12C0B54DC2D3BD1D7D017BF7491477D42620B73A0440AADE3618C2E,
            y=0x2315ED9F374367C436DD9C6F429813FAC22057DE80F4C3370FA123D5F78AEF2E,
        ),
        qo=G1Point(
            x=0x1E03C43F995F5A063F6D9A629585B91A77A49190E6A76DB92FA1B679EBBBB694,
            y=0x062C61A0E3454D8ED5DD8198C1DB15612ED49C28685EFE35A353F9C44E0C42FD,
        ),
        q4=G1Point(
            x=0x1C919D8B75B3D41E260EFF3B817F7A5A1BCD1387B8C5269B7F7CD7610F687A1A,
            y=0x266DFB8160F9492AE89282D7301A6252A5FC86B785A055959A85559FA7FE313B,
        ),
        qm=G1Point(
            x=0x22B152101522EA0DEC8AFD61C48B2A406EABC0D39B46016AF995A0D1B3260A16,
            y=0x22A67ABA4DA604029085DB563B8C5F60CA0F9B4F12E7E845EB308B38D323D282,
        ),
        qc=G1Point(
            x=0x0847B07BB1B03ED20243D7B8ABF78300F7065713FB9F3753DFDCCA3D25244507,
            y=0x07FF6FD445F7381B12A90A300E97CAABB6FC23935C9EA235E4A837FDF341DE40,
        ),
        qArith=G1Point(
            x=0x01E6B4DB22F35DD68007F699E1543653F270632F143D7E4164C6DCC4852540D3,
            y=0x25D7DE890F88C904B900AE61E3D6EBA8C2601793E0EF05EB25222CEAC9C79AE6,
        ),
        qSort=G1Point(
            x=0x0276B7BE1FD261EFF8381E6E8FFDB3725940AF81118DF85D7D8C608A4C90B298,
            y=0x19E04B6E50057551BC37FAC5761C75B624913895785B28B8394543CE0E2AF753,
        ),
        qElliptic=G1Point(
            x=0x246D59A16C1352A8873E7F8A58B87BCCFD189FC78D27F956F026236FC7D16162,
            y=0x156D472D90596472EB771C56F370E92CBC22282D7C7A01F7057C1D3EA70C92F2,
        ),
        qAux=G1Point(
            x=0x048D8152D6204D873A42E7E86EDCA5A880ECFB96C18B2294098019DE390755B2,
            y=0x2D36E390F7FEDE4CD8FC187EE4ED1B39F59CA26DE94E6F5CA9813DFE4A786381,
        ),
        qLookup=G1Point(
            x=0x1E7E7CCAD6262D34FC92F0CC0ABA7F07427B97099FD6B3C21EB0BB5AE781E9B2,
            y=0x25A590063AB4AC8254CAC9A4FAA08BB921038BB3B3F87FAA0E04B9470E197BE5,
        ),
        s1=G1Point(
            x=0x2A471E6E6E9AA115123375F50BAFDD03F799672C26E577E1BEB7F903DE2B96C6,
            y=0x28989BB0E1F9A69BDE57D64557A24BEAB02921B2CC9DE388D9963825705B6FAE,
        ),
        s2=G1Point(
            x=0x15C2A00E86AE04173083E75E79B479290879258C68143447FE20418C3E322D15,
            y=0x181DE2E886B42DAA1F3349DA50775ABD7FC4E467D8B026D20118E046CC31DF2B,
        ),
        s3=G1Point(
            x=0x2B4610081743E2C3E199358F8CDD959399B8210873E0F173BFEDE3E191A76372,
            y=0x0269F731FC4BA4DF8B824A794D39692452E911450C261BD7C0EE421A187F3D70,
        ),
        s4=G1Point(
            x=0x2599EF03B93CFA8E3DFC50A671F95AEED1FD6BCC137DDD18E8408F2B46C8A074,
            y=0x304CB90DBBE026323E92FE385F2E2EC108C524CBB7BB0F858429AF8EC9B80EA1,
        ),
        t1=G1Point(
            x=0x1DDC9EF86584375E5998D9F6FC16A4E646DC315AB86B477ABC2F18A723DC24F6,
            y=0x03A3B132CA6590C4FFDF35E1ACD932DA680A4247A55C88DD2284AF78CB047906,
        ),
        t2=G1Point(
            x=0x1E4CDE3E410660193BACDF1DB498FFB6BF1618C4D7B355415858D7D996E8BD03,
            y=0x18D7F0300F961521EAD0CB3C81A2A43A2DEA0FDCB17BD772AEF6C7B908BE4273,
        ),
        t3=G1Point(
            x=0x0E77F28B07AF551FEA1AD81B304FD41013850E8B3539309C20BB2FA115289642,
            y=0x15F92FDE2F0D7A77C27DAEB397336220FFC07B99F710980253E84F8AE94AFD4D,
        ),
        t4=G1Point(
            x=0x2285EA4116CA00B673B2DAADF596052B6D9BA6D231A4BEA8AF5A3C0F28C44AA4,
            y=0x076BF1E1F682BADEBFCA083E25D808E8DAE96372631C0721A7EE238C333A862A,
        ),
        id1=G1Point(
            x=0x24EC1E72FBAF9EE95DBC8A2ABFBF8858799576FB9B8F5E7E63D8E0B1DA32E692,
            y=0x28B7122F8E5A7397BF78E8BF8731A285F89516D3627C2C6B4C170B30B82FAAF3,
        ),
        id2=G1Point(
            x=0x206857EF4F7CC72A455C9C61A74FDAD900A581F85A3001ABAC02E6F9BDD57243,
            y=0x1F3F454B77A5F607614B625059F2EE804AF5C5B65BEED4C61B48FA1BFCF1A819,
        ),
        id3=G1Point(
            x=0x0946AF4969C7508BE03D0216CAF93913DC178FE870C8C2C80958B3C492F383E2,
            y=0x0E1B3D5BF9B9152109D937399F9963626F38734734ECE5F71D49F986A8FE2C1B,
        ),
        id4=G1Point(
            x=0x195028EFCA7E54F5CC0B50BEA74815F18C572A6B1EA833E885E0AF3E5F0701FD,
            y=0x100E2DA82D3E2C3157F190DB75110B11F18C317945577F865EF830860921D737,
        ),
        lagrangeFirst=G1Point(
            x=0x0000000000000000000000000000000000000000000000000000000000000001,
            y=0x0000000000000000000000000000000000000000000000000000000000000002,
        ),
        lagrangeLast=G1Point(
            x=0x28BF8C9EEAE6946902EE08351768A3E4F67D812E6465F55F16BF69FAD16CF46D,
            y=0x12DAB1C326B33EA63EC6651324077C0EA2CB0DDFAFD63FB8F9FBCC70BD53D7E0,
        ),
    )


## Transcript.sol


@dataclass(slots=True)
class Transcript:
    eta: PyFelt
    beta: PyFelt
    gamma: PyFelt
    alphas: list[PyFelt]  # [NUMBER_OF_ALPHAS]
    gateChallenges: list[PyFelt]  # [LOG_N]
    sumCheckUChallenges: list[PyFelt]  # [LOG_N]
    rho: PyFelt
    # Zero morph
    zmX: PyFelt
    zmY: PyFelt
    zmZ: PyFelt
    zmQuotient: PyFelt
    # Derived
    publicInputsDelta: PyFelt
    lookupGrandProductDelta: PyFelt


def generateTranscript(proof: HonkProof, publicInputs: list[int]) -> Transcript:
    eta = generateEtaChallenge(proof, publicInputs)
    (beta, gamma) = generateBetaAndGammaChallenges(eta, proof)
    alphas = generateAlphaChallenges(gamma, proof)
    gateChallenges = generateGateChallenges(alphas[NUMBER_OF_ALPHAS - 1])
    sumCheckUChallenges = generateSumcheckChallenges(proof, gateChallenges[LOG_N - 1])
    rho = generateRhoChallenge(proof, sumCheckUChallenges[LOG_N - 1])
    zmY = generateZMYChallenge(rho, proof)
    (zmX, zmZ) = generateZMXZChallenges(zmY, proof)
    return Transcript(
        eta=eta,
        beta=beta,
        gamma=gamma,
        alphas=alphas,
        gateChallenges=gateChallenges,
        sumCheckUChallenges=sumCheckUChallenges,
        rho=rho,
        zmX=zmX,
        zmY=zmY,
        zmZ=zmZ,
        zmQuotient=Fr(0),
        publicInputsDelta=Fr(0),
        lookupGrandProductDelta=Fr(0),
    )


def generateEtaChallenge(proof: HonkProof, publicInputs: list[int]) -> PyFelt:
    # TODO(md): the 12 here will need to be halved when we fix the transcript to not be over field elements
    round0: list[int] = (3 + NUMBER_OF_PUBLIC_INPUTS + 12) * [0]
    round0[0] = proof.circuitSize
    round0[1] = proof.publicInputsSize
    round0[2] = proof.publicInputsOffset
    for i in range(NUMBER_OF_PUBLIC_INPUTS):
        round0[3 + i] = publicInputs[i]
    # Create the first challenge
    # Note: w4 is added to the challenge later on
    # TODO: UPDATE ALL VALUES IN HERE
    round0[3 + NUMBER_OF_PUBLIC_INPUTS] = proof.w1.x_0
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 1] = proof.w1.x_1
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 2] = proof.w1.y_0
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 3] = proof.w1.y_1
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 4] = proof.w2.x_0
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 5] = proof.w2.x_1
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 6] = proof.w2.y_0
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 7] = proof.w2.y_1
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 8] = proof.w3.x_0
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 9] = proof.w3.x_1
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 10] = proof.w3.y_0
    round0[3 + NUMBER_OF_PUBLIC_INPUTS + 11] = proof.w3.y_1
    eta = Fr_from(keccak256(abi_encode_packed(round0)))
    return eta


def generateBetaAndGammaChallenges(
    previousChallenge: PyFelt, proof: HonkProof
) -> tuple[PyFelt, PyFelt]:
    # TODO(md): adjust round size when the proof points are generated correctly - 5
    round1: list[int] = (9) * [0]
    round1[0] = previousChallenge.value
    round1[1] = proof.sortedAccum.x_0
    round1[2] = proof.sortedAccum.x_1
    round1[3] = proof.sortedAccum.y_0
    round1[4] = proof.sortedAccum.y_1
    round1[5] = proof.w4.x_0
    round1[6] = proof.w4.x_1
    round1[7] = proof.w4.y_0
    round1[8] = proof.w4.y_1
    beta = Fr_from(keccak256(abi_encode_packed(round1)))
    gamma = Fr_from(keccak256(abi_encode_packed([beta.value])))
    return (beta, gamma)


# Alpha challenges non-linearise the gate contributions
def generateAlphaChallenges(
    previousChallenge: PyFelt, proof: HonkProof
) -> list[PyFelt]:
    # Generate the original sumcheck alpha 0 by hashing zPerm and zLookup
    # TODO(md): 5 post correct proof size fix
    alphas: list[PyFelt] = (NUMBER_OF_ALPHAS) * [Fr(0)]
    alpha0: list[int] = (9) * [0]
    alpha0[0] = previousChallenge.value
    alpha0[1] = proof.zPerm.x_0
    alpha0[2] = proof.zPerm.x_1
    alpha0[3] = proof.zPerm.y_0
    alpha0[4] = proof.zPerm.y_1
    alpha0[5] = proof.zLookup.x_0
    alpha0[6] = proof.zLookup.x_1
    alpha0[7] = proof.zLookup.y_0
    alpha0[8] = proof.zLookup.y_1
    prevChallenge = Fr_from(keccak256(abi_encode_packed(alpha0)))
    alphas[0] = prevChallenge
    for i in range(1, NUMBER_OF_ALPHAS):
        prevChallenge = Fr_from(keccak256(abi_encode_packed([prevChallenge.value])))
        alphas[i] = prevChallenge
    return alphas


def generateGateChallenges(previousChallenge: PyFelt) -> list[PyFelt]:  # [LOG_N]
    gateChallenges: list[PyFelt] = (LOG_N) * [Fr(0)]
    for i in range(LOG_N):
        previousChallenge = Fr_from(
            keccak256(abi_encode_packed([previousChallenge.value]))
        )
        gateChallenges[i] = previousChallenge
    return gateChallenges


def generateSumcheckChallenges(
    proof: HonkProof, prevChallenge: PyFelt
) -> list[PyFelt]:  # [LOG_N]
    sumcheckChallenges: list[PyFelt] = (LOG_N) * [Fr(0)]
    for i in range(LOG_N):
        univariateChal: list[int] = (BATCHED_RELATION_PARTIAL_LENGTH + 1) * [0]
        univariateChal[0] = prevChallenge.value
        for j in range(BATCHED_RELATION_PARTIAL_LENGTH):
            univariateChal[j + 1] = proof.sumcheckUnivariates[i][j].value
        sumcheckChallenges[i] = Fr_from(keccak256(abi_encode_packed(univariateChal)))
        prevChallenge = sumcheckChallenges[i]
    return sumcheckChallenges


def generateRhoChallenge(proof: HonkProof, prevChallenge: PyFelt) -> PyFelt:
    rhoChallengeElements: list[int] = (NUMBER_OF_ENTITIES + 1) * [0]
    rhoChallengeElements[0] = prevChallenge.value
    for i in range(NUMBER_OF_ENTITIES):
        rhoChallengeElements[i + 1] = proof.sumcheckEvaluations[i].value
    rho = Fr_from(keccak256(abi_encode_packed(rhoChallengeElements)))
    return rho


def generateZMYChallenge(previousChallenge: PyFelt, proof: HonkProof) -> PyFelt:
    zmY: list[int] = (LOG_N * 4 + 1) * [0]
    zmY[0] = previousChallenge.value
    for i in range(LOG_N):
        zmY[1 + i * 4] = proof.zmCqs[i].x_0
        zmY[2 + i * 4] = proof.zmCqs[i].x_1
        zmY[3 + i * 4] = proof.zmCqs[i].y_0
        zmY[4 + i * 4] = proof.zmCqs[i].y_1
    zeromorphY = Fr_from(keccak256(abi_encode_packed(zmY)))
    return zeromorphY


def generateZMXZChallenges(
    previousChallenge: PyFelt, proof: HonkProof
) -> tuple[PyFelt, PyFelt]:
    buf: list[int] = (4 + 1) * [0]
    buf[0] = previousChallenge.value
    buf[1] = proof.zmCq.x_0
    buf[2] = proof.zmCq.x_1
    buf[3] = proof.zmCq.y_0
    buf[4] = proof.zmCq.y_1
    zeromorphX = Fr_from(keccak256(abi_encode_packed(buf)))
    zeromorphZ = Fr_from(keccak256(abi_encode_packed([zeromorphX.value])))
    return (zeromorphX, zeromorphZ)


## EcdsaHonkVerifier.sol

GRUMPKIN_CURVE_B_PARAMETER_NEGATED: PyFelt = Fr(17)  # -(-17)


def verify(proof: bytes, publicInputs: list[int]) -> bool:
    vk = loadVerificationKey()
    p = loadProof(proof)
    if vk.publicInputsSize != len(publicInputs):
        raise ValueError("PublicInputsLengthWrong")
    # Generate the fiat shamir challenges for the whole protocol
    t = generateTranscript(p, publicInputs)
    # Compute the public input delta
    t.publicInputsDelta = computePublicInputDelta(
        publicInputs, t.beta, t.gamma, vk.circuitSize, p.publicInputsOffset
    )
    t.lookupGrandProductDelta = computeLookupGrandProductDelta(
        t.beta, t.gamma, vk.circuitSize
    )
    # Sumcheck
    sumcheckVerified = verifySumcheck(p, t)
    if not sumcheckVerified:
        raise ValueError("SumcheckFailed")
    # Zeromorph
    zeromorphVerified = verifyZeroMorph(p, vk, t)
    if not zeromorphVerified:
        raise ValueError("ZeromorphFailed")
    return (
        sumcheckVerified and zeromorphVerified
    )  # Boolean condition not required - nice for vanity :)


# TODO: mod q proof points
# TODO: Preprocess all of the memory locations
# TODO: Adjust proof point serde away from poseidon forced field elements
def loadProof(proof: bytes) -> HonkProof:
    # Metadata
    circuitSize = b2n(proof[0x00:0x20])
    publicInputsSize = b2n(proof[0x20:0x40])
    publicInputsOffset = b2n(proof[0x40:0x60])
    # Commitments
    w1 = G1ProofPoint(
        x_0=b2n(proof[0x60:0x80]),
        x_1=b2n(proof[0x80:0xA0]),
        y_0=b2n(proof[0xA0:0xC0]),
        y_1=b2n(proof[0xC0:0xE0]),
    )
    w2 = G1ProofPoint(
        x_0=b2n(proof[0xE0:0x100]),
        x_1=b2n(proof[0x100:0x120]),
        y_0=b2n(proof[0x120:0x140]),
        y_1=b2n(proof[0x140:0x160]),
    )
    w3 = G1ProofPoint(
        x_0=b2n(proof[0x160:0x180]),
        x_1=b2n(proof[0x180:0x1A0]),
        y_0=b2n(proof[0x1A0:0x1C0]),
        y_1=b2n(proof[0x1C0:0x1E0]),
    )
    # Lookup / Permutation Helper Commitments
    sortedAccum = G1ProofPoint(
        x_0=b2n(proof[0x1E0:0x200]),
        x_1=b2n(proof[0x200:0x220]),
        y_0=b2n(proof[0x220:0x240]),
        y_1=b2n(proof[0x240:0x260]),
    )
    w4 = G1ProofPoint(
        x_0=b2n(proof[0x260:0x280]),
        x_1=b2n(proof[0x280:0x2A0]),
        y_0=b2n(proof[0x2A0:0x2C0]),
        y_1=b2n(proof[0x2C0:0x2E0]),
    )
    zPerm = G1ProofPoint(
        x_0=b2n(proof[0x2E0:0x300]),
        x_1=b2n(proof[0x300:0x320]),
        y_0=b2n(proof[0x320:0x340]),
        y_1=b2n(proof[0x340:0x360]),
    )
    zLookup = G1ProofPoint(
        x_0=b2n(proof[0x360:0x380]),
        x_1=b2n(proof[0x380:0x3A0]),
        y_0=b2n(proof[0x3A0:0x3C0]),
        y_1=b2n(proof[0x3C0:0x3E0]),
    )
    # TEMP the boundary of what has already been read
    boundary = 0x3E0
    # Sumcheck univariates
    # TODO: in this case we know what log_n is - so we hard code it, we would want this to be included in
    # a cpp template for different circuit sizes
    sumcheckUnivariates: list[list[PyFelt]] = (LOG_N) * [
        (BATCHED_RELATION_PARTIAL_LENGTH) * [Fr(0)]
    ]
    for i in range(LOG_N):
        sumcheckUnivariates[i] = (BATCHED_RELATION_PARTIAL_LENGTH) * [Fr(0)]
        # The loop boundary of i, this will shift forward on each evaluation
        loop_boundary = boundary + (i * 0x20 * BATCHED_RELATION_PARTIAL_LENGTH)
        for j in range(BATCHED_RELATION_PARTIAL_LENGTH):
            start = loop_boundary + (j * 0x20)
            end = start + 0x20
            sumcheckUnivariates[i][j] = Fr_from(proof[start:end])
    boundary = boundary + (LOG_N * BATCHED_RELATION_PARTIAL_LENGTH * 0x20)
    # Sumcheck evaluations
    sumcheckEvaluations: list[PyFelt] = (NUMBER_OF_ENTITIES) * [Fr(0)]
    for i in range(NUMBER_OF_ENTITIES):
        start = boundary + (i * 0x20)
        end = start + 0x20
        sumcheckEvaluations[i] = Fr_from(proof[start:end])
    boundary = boundary + (NUMBER_OF_ENTITIES * 0x20)
    # Zero morph Commitments
    zmCqs: list[G1ProofPoint] = (LOG_N) * [G1ProofPoint(x_0=0, x_1=0, y_0=0, y_1=0)]
    for i in range(LOG_N):
        # Explicitly stating the x0, x1, y0, y1 start and end boundaries to make the calldata slicing bearable
        xStart = boundary + (i * 0x80)
        xEnd = xStart + 0x20
        x1Start = xEnd
        x1End = x1Start + 0x20
        yStart = x1End
        yEnd = yStart + 0x20
        y1Start = yEnd
        y1End = y1Start + 0x20
        zmCqs[i] = G1ProofPoint(
            x_0=b2n(proof[xStart:xEnd]),
            x_1=b2n(proof[x1Start:x1End]),
            y_0=b2n(proof[yStart:yEnd]),
            y_1=b2n(proof[y1Start:y1End]),
        )
    boundary = boundary + (LOG_N * 0x80)
    zmCq = G1ProofPoint(
        x_0=b2n(proof[boundary : boundary + 0x20]),
        x_1=b2n(proof[boundary + 0x20 : boundary + 0x40]),
        y_0=b2n(proof[boundary + 0x40 : boundary + 0x60]),
        y_1=b2n(proof[boundary + 0x60 : boundary + 0x80]),
    )
    zmPi = G1ProofPoint(
        x_0=b2n(proof[boundary + 0x80 : boundary + 0xA0]),
        x_1=b2n(proof[boundary + 0xA0 : boundary + 0xC0]),
        y_0=b2n(proof[boundary + 0xC0 : boundary + 0xE0]),
        y_1=b2n(proof[boundary + 0xE0 : boundary + 0x100]),
    )
    return HonkProof(
        circuitSize=circuitSize,
        publicInputsSize=publicInputsSize,
        publicInputsOffset=publicInputsOffset,
        w1=w1,
        w2=w2,
        w3=w3,
        sortedAccum=sortedAccum,
        w4=w4,
        zPerm=zPerm,
        zLookup=zLookup,
        sumcheckUnivariates=sumcheckUnivariates,
        sumcheckEvaluations=sumcheckEvaluations,
        zmCqs=zmCqs,
        zmCq=zmCq,
        zmPi=zmPi,
    )


def computePublicInputDelta(
    publicInputs: list[int], beta: PyFelt, gamma: PyFelt, domainSize: int, offset: int
) -> PyFelt:
    numerator = Fr(1)
    denominator = Fr(1)
    numeratorAcc = gamma + (beta * Fr(domainSize + offset))
    denominatorAcc = gamma - (beta * Fr(offset + 1))
    for publicInput in publicInputs:
        pubInput = Fr(publicInput)
        numerator = numerator * (numeratorAcc + pubInput)
        denominator = denominator * (denominatorAcc + pubInput)
        numeratorAcc = numeratorAcc + beta
        denominatorAcc = denominatorAcc - beta
    # Fr delta = numerator / denominator; // TOOO: batch invert later?
    publicInputDelta = numerator / denominator
    return publicInputDelta


# Incorportate the original plookup construction into honk
def computeLookupGrandProductDelta(
    beta: PyFelt, gamma: PyFelt, domainSize: int
) -> PyFelt:
    gammaByOnePlusBeta = gamma * (beta + 1)
    # TODO: dont like using ^ for exponent - might just make a function
    lookupGrandProductDelta = gammaByOnePlusBeta**domainSize
    return lookupGrandProductDelta


ROUND_TARGET: int = 0


def verifySumcheck(proof: HonkProof, tp: Transcript) -> bool:
    roundTarget = Fr(0)
    powPartialEvaluation = Fr(1)
    # We perform sumcheck reductions over log n rounds ( the multivariate degree )
    for rnd in range(LOG_N):
        roundUnivariate = proof.sumcheckUnivariates[rnd]
        valid = checkSum(roundUnivariate, roundTarget)
        if not valid:
            return False
        roundChallenge = tp.sumCheckUChallenges[rnd]
        # Update the round target for the next rounf
        roundTarget = computeNextTargetSum(roundUnivariate, roundChallenge)
        powPartialEvaluation = partiallyEvaluatePOW(
            tp, powPartialEvaluation, roundChallenge, rnd
        )
    # Last round
    grandHonkRelationSum = accumulateRelationEvaluations(
        proof, tp, powPartialEvaluation
    )
    verified = grandHonkRelationSum == roundTarget
    return verified


def checkSum(roundUnivariate: list[PyFelt], roundTarget: PyFelt) -> bool:
    totalSum = roundUnivariate[0] + roundUnivariate[1]
    checked = totalSum == roundTarget
    return checked


# Return the new target sum for the next sumcheck round
def computeNextTargetSum(
    roundUnivariates: list[PyFelt], roundChallenge: PyFelt
) -> PyFelt:
    # TODO: inline
    BARYCENTRIC_LAGRANGE_DENOMINATORS: list[PyFelt] = [
        Fr(0x00000000000000000000000000000000000000000000000000000000000002D0),
        Fr(0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFF89),
        Fr(0x0000000000000000000000000000000000000000000000000000000000000030),
        Fr(0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFFDD),
        Fr(0x0000000000000000000000000000000000000000000000000000000000000030),
        Fr(0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593EFFFFF89),
        Fr(0x00000000000000000000000000000000000000000000000000000000000002D0),
    ]
    BARYCENTRIC_DOMAIN: list[PyFelt] = [
        Fr(0x00),
        Fr(0x01),
        Fr(0x02),
        Fr(0x03),
        Fr(0x04),
        Fr(0x05),
        Fr(0x06),
    ]
    # To compute the next target sum, we evaluate the given univariate at a point u (challenge).
    # Performing Barycentric evaluations
    # Compute B(x)
    numeratorValue = Fr(1)
    for i in range(BATCHED_RELATION_PARTIAL_LENGTH):
        numeratorValue = numeratorValue * (roundChallenge - Fr(i))
    # Calculate domain size N of inverses -- TODO: montgomery's trick
    denominatorInverses: list[PyFelt] = (BATCHED_RELATION_PARTIAL_LENGTH) * [Fr(0)]
    for i in range(BATCHED_RELATION_PARTIAL_LENGTH):
        inv = BARYCENTRIC_LAGRANGE_DENOMINATORS[i]
        inv = inv * (roundChallenge - BARYCENTRIC_DOMAIN[i])
        inv = Fr_invert(inv)
        denominatorInverses[i] = inv
    targetSum = Fr(0)
    for i in range(BATCHED_RELATION_PARTIAL_LENGTH):
        term = roundUnivariates[i]
        term = term * denominatorInverses[i]
        targetSum = targetSum + term
    # Scale the sum by the value of B(x)
    targetSum = targetSum * numeratorValue
    return targetSum


# Univariate evaluation of the monomial ((1-X_l) + X_l.B_l) at the challenge point X_l=u_l
def partiallyEvaluatePOW(
    tp: Transcript, currentEvaluation: PyFelt, roundChallenge: PyFelt, rnd: int
) -> PyFelt:
    univariateEval = Fr(1) + (roundChallenge * (tp.gateChallenges[rnd] - 1))
    newEvaluation = currentEvaluation * univariateEval
    return newEvaluation


# Calculate the contributions of each relation to the expected value of the full honk relation
#
# For each relation, we use the purported values ( the ones provided by the prover ) of the multivariates to
# calculate a contribution to the purported value of the full Honk relation.
# These are stored in the evaluations part of the proof object.
# We add these together, with the appropiate scaling factor ( the alphas calculated in challenges )
# This value is checked against the final value of the target total sum - et voila!
def accumulateRelationEvaluations(
    proof: HonkProof, tp: Transcript, powPartialEval: PyFelt
) -> PyFelt:
    purportedEvaluations = proof.sumcheckEvaluations
    evaluations: list[PyFelt] = (NUMBER_OF_SUBRELATIONS) * [Fr(0)]
    # Accumulate all 6 custom gates - each with varying number of subrelations
    # TODO: annotate how many subrealtions each has
    accumulateArithmeticRelation(purportedEvaluations, evaluations, powPartialEval)
    accumulatePermutationRelation(purportedEvaluations, tp, evaluations, powPartialEval)
    accumulateLookupRelation(purportedEvaluations, tp, evaluations, powPartialEval)
    accumulateGenPermRelation(purportedEvaluations, evaluations, powPartialEval)
    accumulateEllipticRelation(purportedEvaluations, evaluations, powPartialEval)
    accumulateAuxillaryRelation(purportedEvaluations, tp, evaluations, powPartialEval)
    # Apply alpha challenges to challenge evaluations
    # Returns grand honk realtion evaluation
    accumulator = scaleAndBatchSubrelations(evaluations, tp.alphas)
    return accumulator


# WIRE
#
# Wire is an aesthetic helper function that is used to index by enum into proof.sumcheckEvaluations, it avoids
# the relation checking code being cluttered with uint256 type casting, which is often a different colour in code
# editors, and thus is noisy.
def wire(p: list[PyFelt], wire: WIRE) -> PyFelt:
    return p[wire.value]


# Ultra Arithmetic Relation
def accumulateArithmeticRelation(
    p: list[PyFelt], evals: list[PyFelt], powPartialEval: PyFelt
):
    # Relation 0
    q_arith = wire(p, WIRE.Q_ARITH)
    neg_half = Fr(0) - Fr_invert(Fr(2))
    accum = (
        (q_arith - 3)
        * (wire(p, WIRE.Q_M) * wire(p, WIRE.W_R) * wire(p, WIRE.W_L))
        * neg_half
    )
    accum = (
        accum
        + (wire(p, WIRE.Q_L) * wire(p, WIRE.W_L))
        + (wire(p, WIRE.Q_R) * wire(p, WIRE.W_R))
        + (wire(p, WIRE.Q_O) * wire(p, WIRE.W_O))
        + (wire(p, WIRE.Q_4) * wire(p, WIRE.W_4))
        + wire(p, WIRE.Q_C)
    )
    accum = accum + (q_arith - 1) * wire(p, WIRE.W_4_SHIFT)
    accum = accum * q_arith
    accum = accum * powPartialEval
    evals[0] = accum
    # Relation 1
    accum = (
        wire(p, WIRE.W_L)
        + wire(p, WIRE.W_4)
        - wire(p, WIRE.W_L_SHIFT)
        + wire(p, WIRE.Q_M)
    )
    accum = accum * (q_arith - 2)
    accum = accum * (q_arith - 1)
    accum = accum * q_arith
    accum = accum * powPartialEval
    evals[1] = accum


def accumulatePermutationRelation(
    p: list[PyFelt], tp: Transcript, evals: list[PyFelt], domainSep: PyFelt
):
    num = wire(p, WIRE.W_L) + wire(p, WIRE.ID_1) * tp.beta + tp.gamma
    num = num * (wire(p, WIRE.W_R) + wire(p, WIRE.ID_2) * tp.beta + tp.gamma)
    num = num * (wire(p, WIRE.W_O) + wire(p, WIRE.ID_3) * tp.beta + tp.gamma)
    num = num * (wire(p, WIRE.W_4) + wire(p, WIRE.ID_4) * tp.beta + tp.gamma)
    grand_product_numerator = num
    den = wire(p, WIRE.W_L) + wire(p, WIRE.SIGMA_1) * tp.beta + tp.gamma
    den = den * (wire(p, WIRE.W_R) + wire(p, WIRE.SIGMA_2) * tp.beta + tp.gamma)
    den = den * (wire(p, WIRE.W_O) + wire(p, WIRE.SIGMA_3) * tp.beta + tp.gamma)
    den = den * (wire(p, WIRE.W_4) + wire(p, WIRE.SIGMA_4) * tp.beta + tp.gamma)
    grand_product_denominator = den
    # Contribution 2
    acc = (
        wire(p, WIRE.Z_PERM) + wire(p, WIRE.LAGRANGE_FIRST)
    ) * grand_product_numerator
    acc = acc - (
        (
            wire(p, WIRE.Z_PERM_SHIFT)
            + (wire(p, WIRE.LAGRANGE_LAST) * tp.publicInputsDelta)
        )
        * grand_product_denominator
    )
    acc = acc * domainSep
    evals[2] = acc
    # Contribution 3
    acc = (wire(p, WIRE.LAGRANGE_LAST) * wire(p, WIRE.Z_PERM_SHIFT)) * domainSep
    evals[3] = acc


# Lookup parameters have been yoinked into memory to avoid stack too deep
@dataclass(slots=True)
class LookupParams:
    eta_sqr: PyFelt
    eta_cube: PyFelt
    one_plus_beta: PyFelt
    gamma_by_one_plus_beta: PyFelt
    wire_accum: PyFelt
    table_accum: PyFelt
    table_accum_shift: PyFelt


def accumulateLookupRelation(
    p: list[PyFelt], tp: Transcript, evals: list[PyFelt], domainSep: PyFelt
):
    lp = LookupParams(
        eta_sqr=Fr(0),
        eta_cube=Fr(0),
        one_plus_beta=Fr(0),
        gamma_by_one_plus_beta=Fr(0),
        wire_accum=Fr(0),
        table_accum=Fr(0),
        table_accum_shift=Fr(0),
    )
    # TODO: note, eta square and eta cubed domain seperators will be replaced with further challenges in the future to reduce the
    # algebraic degree of the lookup relations
    lp.eta_sqr = tp.eta * tp.eta
    lp.eta_cube = lp.eta_sqr * tp.eta
    lp.one_plus_beta = tp.beta + 1
    lp.gamma_by_one_plus_beta = tp.gamma * lp.one_plus_beta
    # (wire(p,WIRE.W_L)] + q_2*wire(p,WIRE.W_1_SHIFT)]) + η(wire(p,WIRE.W_R)] + q_m*wire(p,WIRE.W_2_SHIFT)]) + η²(wire(p,WIRE.W_O)] + q_c*wire(p,WIRE.W_3_SHIFT)]) + η³q_index.
    # deg 2 or 4
    wire_accum = wire(p, WIRE.W_L) + wire(p, WIRE.Q_R) * wire(p, WIRE.W_L_SHIFT)
    wire_accum = (
        wire_accum
        + (wire(p, WIRE.W_R) + wire(p, WIRE.Q_M) * wire(p, WIRE.W_R_SHIFT)) * tp.eta
    )
    wire_accum = (
        wire_accum
        + (wire(p, WIRE.W_O) + wire(p, WIRE.Q_C) * wire(p, WIRE.W_O_SHIFT)) * lp.eta_sqr
    )
    wire_accum = wire_accum + wire(p, WIRE.Q_O) * lp.eta_cube
    lp.wire_accum = wire_accum
    # t_1 + ηt_2 + η²t_3 + η³t_4
    # deg 1 or 4
    table_accum = wire(p, WIRE.TABLE_1) + wire(p, WIRE.TABLE_2) * tp.eta
    table_accum = table_accum + wire(p, WIRE.TABLE_3) * lp.eta_sqr
    table_accum = table_accum + wire(p, WIRE.TABLE_4) * lp.eta_cube
    lp.table_accum = table_accum
    # t_1_shift + ηt_2_shift + η²t_3_shift + η³t_4_shift
    # deg 4
    lp.table_accum_shift = (
        wire(p, WIRE.TABLE_1_SHIFT)
        + wire(p, WIRE.TABLE_2_SHIFT) * tp.eta
        + wire(p, WIRE.TABLE_3_SHIFT) * lp.eta_sqr
        + wire(p, WIRE.TABLE_4_SHIFT) * lp.eta_cube
    )
    acc = wire(p, WIRE.Q_LOOKUP) * lp.wire_accum + tp.gamma
    acc = acc * (
        lp.table_accum + lp.table_accum_shift * tp.beta + lp.gamma_by_one_plus_beta
    )
    acc = acc * lp.one_plus_beta
    grand_product_numerator = acc
    acc = (
        wire(p, WIRE.SORTED_ACCUM)
        + wire(p, WIRE.SORTED_ACCUM_SHIFT) * tp.beta
        + lp.gamma_by_one_plus_beta
    )
    grand_product_denominator = acc
    # Contribution 4
    acc = grand_product_numerator * (
        wire(p, WIRE.Z_LOOKUP) + wire(p, WIRE.LAGRANGE_FIRST)
    ) - grand_product_denominator * (
        wire(p, WIRE.Z_LOOKUP_SHIFT)
        + wire(p, WIRE.LAGRANGE_LAST) * tp.lookupGrandProductDelta
    )
    acc = acc * domainSep
    evals[4] = acc
    # Contribution 5
    acc = wire(p, WIRE.LAGRANGE_LAST) * wire(p, WIRE.Z_LOOKUP_SHIFT) * domainSep
    evals[5] = acc


def accumulateGenPermRelation(p: list[PyFelt], evals: list[PyFelt], domainSep: PyFelt):
    minus_one = Fr(0) - 1
    minus_two = Fr(0) - 2
    minus_three = Fr(0) - 3
    # Compute wire differences
    delta_1 = wire(p, WIRE.W_R) - wire(p, WIRE.W_L)
    delta_2 = wire(p, WIRE.W_O) - wire(p, WIRE.W_R)
    delta_3 = wire(p, WIRE.W_4) - wire(p, WIRE.W_O)
    delta_4 = wire(p, WIRE.W_L_SHIFT) - wire(p, WIRE.W_4)
    # Contribution 6
    acc = delta_1
    acc = acc * (delta_1 + minus_one)
    acc = acc * (delta_1 + minus_two)
    acc = acc * (delta_1 + minus_three)
    acc = acc * wire(p, WIRE.Q_SORT)
    acc = acc * domainSep
    evals[6] = acc
    # Contribution 7
    acc = delta_2
    acc = acc * (delta_2 + minus_one)
    acc = acc * (delta_2 + minus_two)
    acc = acc * (delta_2 + minus_three)
    acc = acc * wire(p, WIRE.Q_SORT)
    acc = acc * domainSep
    evals[7] = acc
    # Contribution 8
    acc = delta_3
    acc = acc * (delta_3 + minus_one)
    acc = acc * (delta_3 + minus_two)
    acc = acc * (delta_3 + minus_three)
    acc = acc * wire(p, WIRE.Q_SORT)
    acc = acc * domainSep
    evals[8] = acc
    # Contribution 9
    acc = delta_4
    acc = acc * (delta_4 + minus_one)
    acc = acc * (delta_4 + minus_two)
    acc = acc * (delta_4 + minus_three)
    acc = acc * wire(p, WIRE.Q_SORT)
    acc = acc * domainSep
    evals[9] = acc


@dataclass(slots=True)
class EllipticParams:
    # Points
    x_1: PyFelt
    y_1: PyFelt
    x_2: PyFelt
    y_2: PyFelt
    y_3: PyFelt
    x_3: PyFelt
    # push accumulators into memory
    x_double_identity: PyFelt


def accumulateEllipticRelation(p: list[PyFelt], evals: list[PyFelt], domainSep: PyFelt):
    ep = EllipticParams(
        x_1=Fr(0),
        y_1=Fr(0),
        x_2=Fr(0),
        y_2=Fr(0),
        y_3=Fr(0),
        x_3=Fr(0),
        x_double_identity=Fr(0),
    )
    ep.x_1 = wire(p, WIRE.W_R)
    ep.y_1 = wire(p, WIRE.W_O)
    ep.x_2 = wire(p, WIRE.W_L_SHIFT)
    ep.y_2 = wire(p, WIRE.W_4_SHIFT)
    ep.y_3 = wire(p, WIRE.W_O_SHIFT)
    ep.x_3 = wire(p, WIRE.W_R_SHIFT)
    q_sign = wire(p, WIRE.Q_L)
    q_is_double = wire(p, WIRE.Q_M)
    # Contribution 10 point addition, x-coordinate check
    # q_elliptic * (x3 + x2 + x1)(x2 - x1)(x2 - x1) - y2^2 - y1^2 + 2(y2y1)*q_sign = 0
    x_diff = ep.x_2 - ep.x_1
    y1_sqr = ep.y_1 * ep.y_1
    # Move to top
    partialEval = domainSep
    y2_sqr = ep.y_2 * ep.y_2
    y1y2 = ep.y_1 * ep.y_2 * q_sign
    x_add_identity = ep.x_3 + ep.x_2 + ep.x_1
    x_add_identity = x_add_identity * x_diff * x_diff
    x_add_identity = x_add_identity - y2_sqr - y1_sqr + y1y2 + y1y2
    evals[10] = (
        x_add_identity * partialEval * wire(p, WIRE.Q_ELLIPTIC) * (Fr(1) - q_is_double)
    )
    # Contribution 11 point addition, x-coordinate check
    # q_elliptic * (q_sign * y1 + y3)(x2 - x1) + (x3 - x1)(y2 - q_sign * y1) = 0
    y1_plus_y3 = ep.y_1 + ep.y_3
    y_diff = ep.y_2 * q_sign - ep.y_1
    y_add_identity = y1_plus_y3 * x_diff + (ep.x_3 - ep.x_1) * y_diff
    evals[11] = (
        y_add_identity * domainSep * wire(p, WIRE.Q_ELLIPTIC) * (Fr(1) - q_is_double)
    )
    # Contribution 10 point doubling, x-coordinate check
    # (x3 + x1 + x1) (4y1*y1) - 9 * x1 * x1 * x1 * x1 = 0
    # N.B. we're using the equivalence x1*x1*x1 === y1*y1 - curve_b to reduce degree by 1
    x_pow_4 = (y1_sqr + GRUMPKIN_CURVE_B_PARAMETER_NEGATED) * ep.x_1
    y1_sqr_mul_4 = y1_sqr + y1_sqr
    y1_sqr_mul_4 = y1_sqr_mul_4 + y1_sqr_mul_4
    x1_pow_4_mul_9 = x_pow_4 * 9
    # NOTE: pushed into memory (stack >:'( )
    ep.x_double_identity = (ep.x_3 + ep.x_1 + ep.x_1) * y1_sqr_mul_4 - x1_pow_4_mul_9
    acc = ep.x_double_identity * domainSep * wire(p, WIRE.Q_ELLIPTIC) * q_is_double
    evals[10] = evals[10] + acc
    # Contribution 11 point doubling, y-coordinate check
    # (y1 + y1) (2y1) - (3 * x1 * x1)(x1 - x3) = 0
    x1_sqr_mul_3 = (ep.x_1 + ep.x_1 + ep.x_1) * ep.x_1
    y_double_identity = x1_sqr_mul_3 * (ep.x_1 - ep.x_3) - (ep.y_1 + ep.y_1) * (
        ep.y_1 + ep.y_3
    )
    evals[11] = (
        evals[11]
        + y_double_identity * domainSep * wire(p, WIRE.Q_ELLIPTIC) * q_is_double
    )


# Constants for the auxiliary relation
LIMB_SIZE: PyFelt = Fr(1 << 68)
SUBLIMB_SHIFT: PyFelt = Fr(1 << 14)
MINUS_ONE: PyFelt = Fr(P - 1)


# Parameters used within the Auxiliary Relation
# A struct is used to work around stack too deep. This relation has alot of variables
@dataclass(slots=True)
class AuxParams:
    limb_subproduct: PyFelt
    non_native_field_gate_1: PyFelt
    non_native_field_gate_2: PyFelt
    non_native_field_gate_3: PyFelt
    limb_accumulator_1: PyFelt
    limb_accumulator_2: PyFelt
    memory_record_check: PyFelt
    partial_record_check: PyFelt
    next_gate_access_type: PyFelt
    record_delta: PyFelt
    index_delta: PyFelt
    adjacent_values_match_if_adjacent_indices_match: PyFelt
    adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation: (
        PyFelt
    )
    access_check: PyFelt
    next_gate_access_type_is_boolean: PyFelt
    ROM_consistency_check_identity: PyFelt
    RAM_consistency_check_identity: PyFelt
    timestamp_delta: PyFelt
    RAM_timestamp_check_identity: PyFelt
    memory_identity: PyFelt
    index_is_monotonically_increasing: PyFelt
    auxiliary_identity: PyFelt


def accumulateAuxillaryRelation(
    p: list[PyFelt], tp: Transcript, evals: list[PyFelt], domainSep: PyFelt
):
    ap = AuxParams(
        limb_subproduct=Fr(0),
        non_native_field_gate_1=Fr(0),
        non_native_field_gate_2=Fr(0),
        non_native_field_gate_3=Fr(0),
        limb_accumulator_1=Fr(0),
        limb_accumulator_2=Fr(0),
        memory_record_check=Fr(0),
        partial_record_check=Fr(0),
        next_gate_access_type=Fr(0),
        record_delta=Fr(0),
        index_delta=Fr(0),
        adjacent_values_match_if_adjacent_indices_match=Fr(0),
        adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation=Fr(
            0
        ),
        access_check=Fr(0),
        next_gate_access_type_is_boolean=Fr(0),
        ROM_consistency_check_identity=Fr(0),
        RAM_consistency_check_identity=Fr(0),
        timestamp_delta=Fr(0),
        RAM_timestamp_check_identity=Fr(0),
        memory_identity=Fr(0),
        index_is_monotonically_increasing=Fr(0),
        auxiliary_identity=Fr(0),
    )
    # Contribution 12
    # Non native field arithmetic gate 2
    # deg 4
    #             _                                                                               _
    #            /   _                   _                               _       14                \
    # q_2 . q_4 |   (w_1 . w_2) + (w_1 . w_2) + (w_1 . w_4 + w_2 . w_3 - w_3) . 2    - w_3 - w_4   |
    #            \_                                                                               _/
    ap.limb_subproduct = wire(p, WIRE.W_L) * wire(p, WIRE.W_R_SHIFT) + wire(
        p, WIRE.W_L_SHIFT
    ) * wire(p, WIRE.W_R)
    ap.non_native_field_gate_2 = (
        wire(p, WIRE.W_L) * wire(p, WIRE.W_4)
        + wire(p, WIRE.W_R) * wire(p, WIRE.W_O)
        - wire(p, WIRE.W_O_SHIFT)
    )
    ap.non_native_field_gate_2 = ap.non_native_field_gate_2 * LIMB_SIZE
    ap.non_native_field_gate_2 = ap.non_native_field_gate_2 - wire(p, WIRE.W_4_SHIFT)
    ap.non_native_field_gate_2 = ap.non_native_field_gate_2 + ap.limb_subproduct
    ap.non_native_field_gate_2 = ap.non_native_field_gate_2 * wire(p, WIRE.Q_4)
    ap.limb_subproduct = ap.limb_subproduct * LIMB_SIZE
    ap.limb_subproduct = ap.limb_subproduct + (
        wire(p, WIRE.W_L_SHIFT) * wire(p, WIRE.W_R_SHIFT)
    )
    ap.non_native_field_gate_1 = ap.limb_subproduct
    ap.non_native_field_gate_1 = ap.non_native_field_gate_1 - (
        wire(p, WIRE.W_O) + wire(p, WIRE.W_4)
    )
    ap.non_native_field_gate_1 = ap.non_native_field_gate_1 * wire(p, WIRE.Q_O)
    ap.non_native_field_gate_3 = ap.limb_subproduct
    ap.non_native_field_gate_3 = ap.non_native_field_gate_3 + wire(p, WIRE.W_4)
    ap.non_native_field_gate_3 = ap.non_native_field_gate_3 - (
        wire(p, WIRE.W_O_SHIFT) + wire(p, WIRE.W_4_SHIFT)
    )
    ap.non_native_field_gate_3 = ap.non_native_field_gate_3 * wire(p, WIRE.Q_M)
    non_native_field_identity = (
        ap.non_native_field_gate_1
        + ap.non_native_field_gate_2
        + ap.non_native_field_gate_3
    )
    non_native_field_identity = non_native_field_identity * wire(p, WIRE.Q_R)
    # ((((w2' * 2^14 + w1') * 2^14 + w3) * 2^14 + w2) * 2^14 + w1 - w4) * qm
    # deg 2
    ap.limb_accumulator_1 = wire(p, WIRE.W_R_SHIFT) * SUBLIMB_SHIFT
    ap.limb_accumulator_1 = ap.limb_accumulator_1 + wire(p, WIRE.W_L_SHIFT)
    ap.limb_accumulator_1 = ap.limb_accumulator_1 * SUBLIMB_SHIFT
    ap.limb_accumulator_1 = ap.limb_accumulator_1 + wire(p, WIRE.W_O)
    ap.limb_accumulator_1 = ap.limb_accumulator_1 * SUBLIMB_SHIFT
    ap.limb_accumulator_1 = ap.limb_accumulator_1 + wire(p, WIRE.W_R)
    ap.limb_accumulator_1 = ap.limb_accumulator_1 * SUBLIMB_SHIFT
    ap.limb_accumulator_1 = ap.limb_accumulator_1 + wire(p, WIRE.W_L)
    ap.limb_accumulator_1 = ap.limb_accumulator_1 - wire(p, WIRE.W_4)
    ap.limb_accumulator_1 = ap.limb_accumulator_1 * wire(p, WIRE.Q_4)
    # ((((w3' * 2^14 + w2') * 2^14 + w1') * 2^14 + w4) * 2^14 + w3 - w4') * qm
    # deg 2
    ap.limb_accumulator_2 = wire(p, WIRE.W_O_SHIFT) * SUBLIMB_SHIFT
    ap.limb_accumulator_2 = ap.limb_accumulator_2 + wire(p, WIRE.W_R_SHIFT)
    ap.limb_accumulator_2 = ap.limb_accumulator_2 * SUBLIMB_SHIFT
    ap.limb_accumulator_2 = ap.limb_accumulator_2 + wire(p, WIRE.W_L_SHIFT)
    ap.limb_accumulator_2 = ap.limb_accumulator_2 * SUBLIMB_SHIFT
    ap.limb_accumulator_2 = ap.limb_accumulator_2 + wire(p, WIRE.W_4)
    ap.limb_accumulator_2 = ap.limb_accumulator_2 * SUBLIMB_SHIFT
    ap.limb_accumulator_2 = ap.limb_accumulator_2 + wire(p, WIRE.W_O)
    ap.limb_accumulator_2 = ap.limb_accumulator_2 - wire(p, WIRE.W_4_SHIFT)
    ap.limb_accumulator_2 = ap.limb_accumulator_2 * wire(p, WIRE.Q_M)
    limb_accumulator_identity = ap.limb_accumulator_1 + ap.limb_accumulator_2
    limb_accumulator_identity = limb_accumulator_identity * wire(p, WIRE.Q_O)  #  deg 3
    # MEMORY
    #
    # A RAM memory record contains a tuple of the following fields:
    #  * i: `index` of memory cell being accessed
    #  * t: `timestamp` of memory cell being accessed (used for RAM, set to 0 for ROM)
    #  * v: `value` of memory cell being accessed
    #  * a: `access` type of record. read: 0 = read, 1 = write
    #  * r: `record` of memory cell. record = access + index * eta + timestamp * eta^2 + value * eta^3
    #
    # A ROM memory record contains a tuple of the following fields:
    #  * i: `index` of memory cell being accessed
    #  * v: `value1` of memory cell being accessed (ROM tables can store up to 2 values per index)
    #  * v2:`value2` of memory cell being accessed (ROM tables can store up to 2 values per index)
    #  * r: `record` of memory cell. record = index * eta + value2 * eta^2 + value1 * eta^3
    #
    #  When performing a read/write access, the values of i, t, v, v2, a, r are stored in the following wires +
    # selectors, depending on whether the gate is a RAM read/write or a ROM read
    #
    #  | gate type | i  | v2/t  |  v | a  | r  |
    #  | --------- | -- | ----- | -- | -- | -- |
    #  | ROM       | w1 | w2    | w3 | -- | w4 |
    #  | RAM       | w1 | w2    | w3 | qc | w4 |
    #
    # (for accesses where `index` is a circuit constant, it is assumed the circuit will apply a copy constraint on
    # `w2` to fix its value)
    #
    # Memory Record Check
    # Partial degree: 1
    # Total degree: 4
    #
    # A ROM/ROM access gate can be evaluated with the identity:
    #
    # qc + w1 \eta + w2 \eta^2 + w3 \eta^3 - w4 = 0
    #
    # For ROM gates, qc = 0
    ap.memory_record_check = wire(p, WIRE.W_O) * tp.eta
    ap.memory_record_check = ap.memory_record_check + wire(p, WIRE.W_R)
    ap.memory_record_check = ap.memory_record_check * tp.eta
    ap.memory_record_check = ap.memory_record_check + wire(p, WIRE.W_L)
    ap.memory_record_check = ap.memory_record_check * tp.eta
    ap.memory_record_check = ap.memory_record_check + wire(p, WIRE.Q_C)
    ap.partial_record_check = (
        ap.memory_record_check
    )  # used in RAM consistency check; deg 1 or 4
    ap.memory_record_check = ap.memory_record_check - wire(p, WIRE.W_4)
    # Contribution 13 & 14
    # ROM Consistency Check
    # Partial degree: 1
    # Total degree: 4
    #
    # For every ROM read, a set equivalence check is applied between the record witnesses, and a second set of
    # records that are sorted.
    #
    # We apply the following checks for the sorted records:
    #
    # 1. w1, w2, w3 correctly map to 'index', 'v1, 'v2' for a given record value at w4
    # 2. index values for adjacent records are monotonically increasing
    # 3. if, at gate i, index_i == index_{i + 1}, then value1_i == value1_{i + 1} and value2_i == value2_{i + 1}
    ap.index_delta = wire(p, WIRE.W_L_SHIFT) - wire(p, WIRE.W_L)
    ap.record_delta = wire(p, WIRE.W_4_SHIFT) - wire(p, WIRE.W_4)
    ap.index_is_monotonically_increasing = (
        ap.index_delta * ap.index_delta - ap.index_delta
    )  # deg 2
    ap.adjacent_values_match_if_adjacent_indices_match = (
        ap.index_delta * MINUS_ONE + 1
    ) * ap.record_delta  # deg 2
    evals[13] = (
        ap.adjacent_values_match_if_adjacent_indices_match
        * (wire(p, WIRE.Q_L) * wire(p, WIRE.Q_R))
        * (wire(p, WIRE.Q_AUX) * domainSep)
    )  # deg 5
    evals[14] = (
        ap.index_is_monotonically_increasing
        * (wire(p, WIRE.Q_L) * wire(p, WIRE.Q_R))
        * (wire(p, WIRE.Q_AUX) * domainSep)
    )  # deg 5
    ap.ROM_consistency_check_identity = ap.memory_record_check * (
        wire(p, WIRE.Q_L) * wire(p, WIRE.Q_R)
    )  # deg 3 or 7
    # Contributions 15,16,17
    # RAM Consistency Check
    #
    # The 'access' type of the record is extracted with the expression `w_4 - ap.partial_record_check`
    # (i.e. for an honest Prover `w1 * eta + w2 * eta^2 + w3 * eta^3 - w4 = access`.
    # This is validated by requiring `access` to be boolean
    #
    # For two adjacent entries in the sorted list if _both_
    #  A) index values match
    #  B) adjacent access value is 0 (i.e. next gate is a READ)
    # then
    #  C) both values must match.
    # The gate boolean check is
    # (A && B) => C  === !(A && B) || C ===  !A || !B || C
    #
    # N.B. it is the responsibility of the circuit writer to ensure that every RAM cell is initialized
    # with a WRITE operation.
    access_type = (
        wire(p, WIRE.W_4) - ap.partial_record_check
    )  # will be 0 or 1 for honest Prover; deg 1 or 4
    ap.access_check = (
        access_type * access_type - access_type
    )  # check value is 0 or 1; deg 2 or 8
    # TODO(https://github.com/AztecProtocol/barretenberg/issues/757): If we sorted in
    # reverse order we could re-use `ap.partial_record_check`  1 -  ((w3' * eta + w2') * eta + w1') * eta
    # deg 1 or 4
    ap.next_gate_access_type = wire(p, WIRE.W_O_SHIFT) * tp.eta
    ap.next_gate_access_type = ap.next_gate_access_type + wire(p, WIRE.W_R_SHIFT)
    ap.next_gate_access_type = ap.next_gate_access_type * tp.eta
    ap.next_gate_access_type = ap.next_gate_access_type + wire(p, WIRE.W_L_SHIFT)
    ap.next_gate_access_type = ap.next_gate_access_type * tp.eta
    ap.next_gate_access_type = wire(p, WIRE.W_4_SHIFT) - ap.next_gate_access_type
    value_delta = wire(p, WIRE.W_O_SHIFT) - wire(p, WIRE.W_O)
    ap.adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation = (
        (ap.index_delta * MINUS_ONE + 1)
        * value_delta
        * (ap.next_gate_access_type * MINUS_ONE + 1)
    )  # deg 3 or 6
    # We can't apply the RAM consistency check identity on the final entry in the sorted list (the wires in the
    # next gate would make the identity fail).  We need to validate that its 'access type' bool is correct. Can't
    # do  with an arithmetic gate because of the  `eta` factors. We need to check that the *next* gate's access
    # type is  correct, to cover this edge case
    # deg 2 or 4
    ap.next_gate_access_type_is_boolean = (
        ap.next_gate_access_type * ap.next_gate_access_type - ap.next_gate_access_type
    )
    # Putting it all together...
    evals[15] = (
        ap.adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation
        * wire(p, WIRE.Q_ARITH)
        * (wire(p, WIRE.Q_AUX) * domainSep)
    )  # deg 5 or 8
    evals[16] = (
        ap.index_is_monotonically_increasing
        * wire(p, WIRE.Q_ARITH)
        * (wire(p, WIRE.Q_AUX) * domainSep)
    )  # deg 4
    evals[17] = (
        ap.next_gate_access_type_is_boolean
        * wire(p, WIRE.Q_ARITH)
        * (wire(p, WIRE.Q_AUX) * domainSep)
    )  # deg 4 or 6
    ap.RAM_consistency_check_identity = ap.access_check * wire(
        p, WIRE.Q_ARITH
    )  # deg 3 or 9
    # RAM Timestamp Consistency Check
    #
    # | w1 | w2 | w3 | w4 |
    # | index | timestamp | timestamp_check | -- |
    #
    # Let delta_index = index_{i + 1} - index_{i}
    #
    # Iff delta_index == 0, timestamp_check = timestamp_{i + 1} - timestamp_i
    # Else timestamp_check = 0
    ap.timestamp_delta = wire(p, WIRE.W_R_SHIFT) - wire(p, WIRE.W_R)
    ap.RAM_timestamp_check_identity = (
        ap.index_delta * MINUS_ONE + 1
    ) * ap.timestamp_delta - wire(
        p, WIRE.W_O
    )  # deg 3
    # Complete Contribution 12
    # The complete RAM/ROM memory identity
    # Partial degree:
    ap.memory_identity = ap.ROM_consistency_check_identity  # deg 3 or 6
    ap.memory_identity = ap.memory_identity + ap.RAM_timestamp_check_identity * (
        wire(p, WIRE.Q_4) * wire(p, WIRE.Q_L)
    )  # deg 4
    ap.memory_identity = ap.memory_identity + ap.memory_record_check * (
        wire(p, WIRE.Q_M) * wire(p, WIRE.Q_L)
    )  # deg 3 or 6
    ap.memory_identity = (
        ap.memory_identity + ap.RAM_consistency_check_identity
    )  # deg 3 or 9
    # (deg 3 or 9) + (deg 4) + (deg 3)
    ap.auxiliary_identity = (
        ap.memory_identity + non_native_field_identity + limb_accumulator_identity
    )
    ap.auxiliary_identity = ap.auxiliary_identity * (
        wire(p, WIRE.Q_AUX) * domainSep
    )  # deg 4 or 10
    evals[12] = ap.auxiliary_identity


def scaleAndBatchSubrelations(
    evaluations: list[PyFelt], subrelationChallenges: list[PyFelt]
) -> PyFelt:
    accumulator = evaluations[0]
    for i in range(1, NUMBER_OF_SUBRELATIONS):
        accumulator = accumulator + evaluations[i] * subrelationChallenges[i - 1]
    return accumulator


def verifyZeroMorph(proof: HonkProof, vk: HonkVerificationKey, tp: Transcript) -> bool:
    # Construct batched evaluation v = sum_{i=0}^{m-1}\rho^i*f_i(u) + sum_{i=0}^{l-1}\rho^{m+i}*h_i(u)
    batchedEval = Fr(0)
    batchedScalar = Fr(1)
    # We linearly combine all evaluations (unshifted first, then shifted)
    # TODO: Odd ordering is a workaround work out why cpp has odd ordering over entities
    batchedEval = batchedEval + proof.sumcheckEvaluations[5] * batchedScalar
    batchedScalar = batchedScalar * tp.rho
    for i in range(5):
        batchedEval = batchedEval + proof.sumcheckEvaluations[i] * batchedScalar
        batchedScalar = batchedScalar * tp.rho
    for i in range(6, NUMBER_OF_ENTITIES):
        batchedEval = batchedEval + proof.sumcheckEvaluations[i] * batchedScalar
        batchedScalar = batchedScalar * tp.rho
    # Get k commitments
    c_zeta = computeCZeta(proof, tp)
    c_zeta_x = computeCZetaX(proof, vk, tp, batchedEval)
    c_zeta_Z = ecAdd(c_zeta, ecMul(c_zeta_x, tp.zmZ))
    # KZG pairing accumulator
    # TODO: concerned that this is zero - it is multiplied by a point later on
    evaluation = Fr(0)
    verified = zkgReduceVerify(proof, tp, evaluation, c_zeta_Z)
    return verified


# Compute commitment to lifted degree quotient identity
def computeCZeta(proof: HonkProof, tp: Transcript) -> G1Point:
    scalars: list[PyFelt] = (LOG_N + 1) * [Fr(0)]
    commitments: list[G1ProofPoint] = (LOG_N + 1) * [
        G1ProofPoint(x_0=0, x_1=0, y_0=0, y_1=0)
    ]
    # Initial contribution
    commitments[0] = proof.zmCq
    scalars[0] = Fr(1)
    # TODO: optimize pow operations here ? batch mulable
    for k in range(LOG_N):
        degree = Fr((1 << k) - 1)
        scalar = tp.zmY**k
        scalar = scalar * tp.zmX ** ((1 << LOG_N) - degree.value - 1)
        scalar = scalar * MINUS_ONE
        scalars[k + 1] = scalar
        commitments[k + 1] = proof.zmCqs[k]
    # Convert all commitments for batch mul
    comms = convertPoints(commitments)
    return batchMul(comms, scalars)


@dataclass(slots=True)
class CZetaXParams:
    phi_numerator: PyFelt
    phi_n_x: PyFelt
    rho_pow: PyFelt
    phi_1: PyFelt
    phi_2: PyFelt
    x_pow_2k: PyFelt
    x_pow_2kp1: PyFelt


def computeCZetaX(
    proof: HonkProof, vk: HonkVerificationKey, tp: Transcript, batchedEval: PyFelt
) -> G1Point:
    scalars: list[PyFelt] = (NUMBER_OF_ENTITIES + LOG_N + 1) * [Fr(0)]
    commitments: list[G1Point] = (NUMBER_OF_ENTITIES + LOG_N + 1) * [G1Point(x=0, y=0)]
    cp = CZetaXParams(
        phi_numerator=Fr(0),
        phi_n_x=Fr(0),
        rho_pow=Fr(0),
        phi_1=Fr(0),
        phi_2=Fr(0),
        x_pow_2k=Fr(0),
        x_pow_2kp1=Fr(0),
    )
    # Phi_n(x) = (x^N - 1) / (x - 1)
    cp.phi_numerator = tp.zmX ** (1 << LOG_N) - 1
    cp.phi_n_x = cp.phi_numerator / (tp.zmX - 1)
    # Add contribution: -v * x * \Phi_n(x) * [1]_1
    # Add base
    scalars[0] = MINUS_ONE * batchedEval * tp.zmX * cp.phi_n_x
    commitments[0] = G1Point(x=1, y=2)  # One
    # f - Add all unshifted commitments
    # g - Add add to be shifted commitments
    # f commitments are accumulated at (zm_x * r)
    cp.rho_pow = Fr(1)
    for i in range(1, 33):
        scalars[i] = tp.zmX * cp.rho_pow
        cp.rho_pow = cp.rho_pow * tp.rho
    # g commitments are accumulated at r
    for i in range(33, NUMBER_OF_ENTITIES + 1):
        scalars[i] = cp.rho_pow
        cp.rho_pow = cp.rho_pow * tp.rho
    # TODO: dont accumulate these into the comms array, just accumulate directly
    commitments[1] = vk.qm
    commitments[2] = vk.qc
    commitments[3] = vk.ql
    commitments[4] = vk.qr
    commitments[5] = vk.qo
    commitments[6] = vk.q4
    commitments[7] = vk.qArith
    commitments[8] = vk.qSort
    commitments[9] = vk.qElliptic
    commitments[10] = vk.qAux
    commitments[11] = vk.qLookup
    commitments[12] = vk.s1
    commitments[13] = vk.s2
    commitments[14] = vk.s3
    commitments[15] = vk.s4
    commitments[16] = vk.id1
    commitments[17] = vk.id2
    commitments[18] = vk.id3
    commitments[19] = vk.id4
    commitments[20] = vk.t1
    commitments[21] = vk.t2
    commitments[22] = vk.t3
    commitments[23] = vk.t4
    commitments[24] = vk.lagrangeFirst
    commitments[25] = vk.lagrangeLast
    # Accumulate proof points
    commitments[26] = convertProofPoint(proof.w1)
    commitments[27] = convertProofPoint(proof.w2)
    commitments[28] = convertProofPoint(proof.w3)
    commitments[29] = convertProofPoint(proof.w4)
    commitments[30] = convertProofPoint(proof.sortedAccum)
    commitments[31] = convertProofPoint(proof.zPerm)
    commitments[32] = convertProofPoint(proof.zLookup)
    # to be Shifted
    commitments[33] = vk.t1
    commitments[34] = vk.t2
    commitments[35] = vk.t3
    commitments[36] = vk.t4
    commitments[37] = convertProofPoint(proof.w1)
    commitments[38] = convertProofPoint(proof.w2)
    commitments[39] = convertProofPoint(proof.w3)
    commitments[40] = convertProofPoint(proof.w4)
    commitments[41] = convertProofPoint(proof.sortedAccum)
    commitments[42] = convertProofPoint(proof.zPerm)
    commitments[43] = convertProofPoint(proof.zLookup)
    # Add scalar contributions
    # Add contributions: scalar * [q_k],  k = 0,...,log_N, where
    # scalar = -x * (x^{2^k} * \Phi_{n-k-1}(x^{2^{k+1}}) - u_k * \Phi_{n-k}(x^{2^k}))
    cp.x_pow_2k = tp.zmX
    cp.x_pow_2kp1 = tp.zmX * tp.zmX
    for k in range(LOG_N):
        cp.phi_1 = cp.phi_numerator / (cp.x_pow_2kp1 - 1)
        cp.phi_2 = cp.phi_numerator / (cp.x_pow_2k - 1)
        scalar = cp.x_pow_2k * cp.phi_1
        scalar = scalar - (tp.sumCheckUChallenges[k] * cp.phi_2)
        scalar = scalar * tp.zmX
        scalar = scalar * MINUS_ONE
        scalars[NUMBER_OF_ENTITIES + 1 + k] = scalar
        commitments[NUMBER_OF_ENTITIES + 1 + k] = convertProofPoint(proof.zmCqs[k])
        cp.x_pow_2k = cp.x_pow_2kp1
        cp.x_pow_2kp1 = cp.x_pow_2kp1 * cp.x_pow_2kp1
    return batchMul2(commitments, scalars)


# Scalar Mul and acumulate into total
def batchMul(base: list[G1Point], scalars: list[PyFelt]) -> G1Point:
    result = ecMul(base[0], scalars[0])
    for i in range(1, LOG_N + 1):
        result = ecAdd(result, ecMul(base[i], scalars[i]))
    return result


# This implementation is the same as above with different constants
def batchMul2(base: list[G1Point], scalars: list[PyFelt]) -> G1Point:
    result = ecMul(base[0], scalars[0])
    for i in range(1, NUMBER_OF_ENTITIES + LOG_N + 1):
        result = ecAdd(result, ecMul(base[i], scalars[i]))
    return result


def zkgReduceVerify(
    proof: HonkProof, tp: Transcript, evaluation: PyFelt, commitment: G1Point
) -> bool:
    quotient_commitment = convertProofPoint(proof.zmPi)
    ONE = G1Point(x=1, y=2)
    P0 = commitment
    P0 = ecAdd(P0, ecMul(quotient_commitment, tp.zmX))
    evalAsPoint = ecMul(ONE, evaluation)
    P0 = ecSub(P0, evalAsPoint)
    P1 = ecNeg(quotient_commitment)
    # Perform pairing check
    return pairing(P0, P1)


def pairing(rhs: G1Point, lhs: G1Point) -> bool:
    return bn256_pairing(
        [
            (rhs.x, rhs.y),
            (lhs.x, lhs.y),
        ],
        [
            # Fixed G1 point
            (
                0x198E9393920D483A7260BFB731FB5D25F1AA493335A9E71297E485B7AEF312C2,
                0x1800DEEF121F1E76426A00665E5C4479674322D4F75EDADD46DEBD5CD992F6ED,
                0x090689D0585FF075EC9E99AD690C3395BC4B313370B38EF355ACDADCD122975B,
                0x12C85EA5DB8C6DEB4AAB71808DCB408FE3D1E7690C43D37B4CE6CC0166FA7DAA,
            ),
            # G1 point from VK
            (
                0x260E01B251F6F1C7E7FF4E580791DEE8EA51D87A358E038B4EFE30FAC09383C1,
                0x0118C4D5B837BCC2BC89B5B398B5974E9F5944073B32078B7E231FEC938883B0,
                0x04FC6369F7110FE3D25156C1BB9A72859CF2A04641F99BA4EE413C80DA6A5FE4,
                0x22FEBDA3C0C0632A56475B4214E5615E11E6DD3F96E6CEA2854A87D4DACC5E55,
            ),
        ],
    )


def convertPoints(commitments: list[G1ProofPoint]) -> list[G1Point]:
    converted: list[G1Point] = (LOG_N + 1) * [G1Point(x=0, y=0)]
    for i in range(LOG_N + 1):
        converted[i] = convertProofPoint(commitments[i])
    return converted


def test(name: str) -> None:
    folder = os.path.dirname(os.path.abspath(__file__))
    with open(folder + "/honk_tests/" + name + ".json", "r") as f:
        record = json.load(f)
    proof = binascii.unhexlify(record["proof"])
    publicInputs = [int(publicInput, 16) for publicInput in record["publicInputs"]]
    success = verify(proof, publicInputs)
    print(name + "=" + ("true" if success else "false"))


def main() -> None:
    test("testFuzzProof")
    test("testValidProof")


if __name__ == "__main__":
    main()
