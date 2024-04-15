## value conversion

import binascii

def h2b(s: str) -> bytes: return binascii.unhexlify(('0' if len(s) % 2 != 0 else '') + s)
def b2h(b: bytes) -> str: return binascii.hexlify(b).decode()
def h2n(s: str) -> int: return 0 if s == '' else int(s, 16)
def n2h(n: int, l=0) -> str: return '%%0%dx' % (2*l) % n if n > 0 or l > 0 else ''
def b2n(b: bytes) -> int: return h2n(b2h(b))
def n2b(n: int, l=0) -> bytes: return h2b(n2h(n, l))

## modular arithmetic

def addmod(a: int, b: int, m: int): return (a + b) % m
def mulmod(a: int, b: int, m: int): return (a * b) % m
def expmod(a: int, b: int, m: int): return pow(a, b, m)

## abi packing

def abi_encodePacked(data: list[int]) -> bytes: return b''.join(map(lambda n: n2b(n, 32), data))

## bn256

def bn256_add(p1: tuple[int, int], p2: tuple[int, int]) -> tuple[int, int]: raise ValueError('Unimplemented')
def bn256_scalar_mul(p: tuple[int, int], s: int) -> tuple[int, int]: raise ValueError('Unimplemented')
def bn256_pairing(p1: tuple[int, int], t1: tuple[int, int, int, int], p2: tuple[int, int], t2: tuple[int, int, int, int]): raise ValueError('Unimplemented')

'''
import subprocess
import json

def bn256_add(v1: tuple[int, int], v2: tuple[int, int]) -> tuple[int, int]:
    (x1, y1) = v1
    (x2, y2) = v2
    command = ['./bn256', str(x1), str(y1), str(x2), str(y2)]
    result = subprocess.run(command, capture_output=True, text=True, check=True)
    data = json.loads(result.stdout.strip())
    if not data['success']: raise ValueError('panic')
    x3 = h2n(data['x'])
    y3 = h2n(data['y'])
    return (x3, y3)

def bn256_scalar_mul(v: tuple[int, int], s: int) -> tuple[int, int]:
    (x1, y1) = v
    command = ['./bn256', str(x1), str(y1), str(s)]
    result = subprocess.run(command, capture_output=True, text=True, check=True)
    data = json.loads(result.stdout.strip())
    if not data['success']: raise ValueError('panic')
    x2 = h2n(data['x'])
    y2 = h2n(data['y'])
    return (x2, y2)

def bn256_pairing(v1: tuple[int, int], v2: tuple[int, int, int, int], v3: tuple[int, int], v4: tuple[int, int, int, int]) -> bool:
    (x1, y1) = v1
    (x2, y2, z2, t2) = v2
    (x3, y3) = v3
    (x4, y4, z4, t4) = v4
    command = ['./bn256', str(x1), str(y1), str(x2), str(y2), str(z2), str(t2), str(x3), str(y3), str(x4), str(y4), str(z4), str(t4)]
    result = subprocess.run(command, capture_output=True, text=True, check=True)
    data = json.loads(result.stdout.strip())
    success = data['success']
    return success
'''

## hashing

import math

def keccak(message: bytes, r: int, c: int, n: int) -> bytes:
    b = r + c
    k = b // 25
    l = int(math.log(k, 2))
    assert r % 8 == 0
    assert c % 8 == 0
    assert n % 8 == 0
    assert b % 25 == 0
    assert k % 8 == 0
    chunks = lambda l, n: [l[i:i+n] for i in range(0, len(l), n)]
    ROT = lambda x, y, k: ((x >> (k - y % k)) ^ (x << y % k)) % (1 << k)
    bytesize = len(message)
    bitsize = 8 * bytesize
    padding = (r - bitsize % r) // 8
    message += b'\x01' + (padding - 2) * b'\0' + b'\x80' if padding > 1 else b'\x81'
    assert len(message) % (r // 8) == 0
    ws = list(map(lambda b: b2n(b[::-1]), chunks(message, k // 8)))
    s = [5 * [0], 5 * [0], 5 * [0], 5 * [0], 5 * [0]]
    RC = [
        0x0000000000000001, 0x0000000000008082, 0x800000000000808a,
        0x8000000080008000, 0x000000000000808b, 0x0000000080000001,
        0x8000000080008081, 0x8000000000008009, 0x000000000000008a,
        0x0000000000000088, 0x0000000080008009, 0x000000008000000a,
        0x000000008000808b, 0x800000000000008b, 0x8000000000008089,
        0x8000000000008003, 0x8000000000008002, 0x8000000000000080,
        0x000000000000800a, 0x800000008000000a, 0x8000000080008081,
        0x8000000000008080, 0x0000000080000001, 0x8000000080008008,
    ]
    R = [
        [ 0, 36,  3, 41, 18],
        [ 1, 44, 10, 45,  2],
        [62,  6, 43, 15, 61],
        [28, 55, 25, 21, 56],
        [27, 20, 39,  8, 14],
    ]
    rounds = 12 + 2 * l
    for w in chunks(ws, r // k):
        w += (c // k) * [0]
        for y in range(0, 5):
            for x in range(0, 5):
                s[x][y] ^= w[5 * y + x]
        for j in range(0, rounds):
            C = 5 * [0]
            for x in range(0, 5):
                C[x] = s[x][0] ^ s[x][1] ^ s[x][2] ^ s[x][3] ^ s[x][4]
            D = 5 * [0]
            for x in range(0, 5):
                D[x] = C[(x - 1) % 5] ^ ROT(C[(x + 1) % 5], 1, k)
            for x in range(0, 5):
                for y in range(0, 5):
                    s[x][y] ^= D[x]
            B = [5 * [0], 5 * [0], 5 * [0], 5 * [0], 5 * [0]]
            for x in range(0, 5):
                for y in range(0, 5):
                    B[y][(2 * x + 3 * y) % 5] = ROT(s[x][y], R[x][y], k)
            for x in range(0, 5):
                for y in range(0, 5):
                    s[x][y] = B[x][y] ^ (~B[(x + 1) % 5][y] & B[(x + 2) % 5][y])
            s[0][0] ^= RC[j]
    Z = b''
    while len(Z) < n // 8:
        for y in range(0, 5):
            for x in range(0, 5):
                Z += n2b(s[x][y], k // 8)[::-1]
    return Z[:n // 8]

def keccak256(message: bytes) -> bytes: return keccak(message, r=1088, c=512, n=256)

## honk verifier

from dataclasses import dataclass
from enum import Enum

## Fr.sol

@dataclass
class Fr:
    value: int
    def __add__(self, other): return Fr_add(self, other)
    def __sub__(self, other): return Fr_sub(self, other)
    def __mul__(self, other): return Fr_mul(self, other)
    def __pow__(self, other): return Fr_exp(self, other)
    def __ne__(self, other): return Fr_notEqual(self, other)
    def __eq__(self, other): return Fr_equal(self, other)

MODULUS = 21888242871839275222246405745257275088548364400416034343698204186575808495617 # Prime field order

# Instantiation
def Fr_from(value: int) -> Fr: return Fr(value=value % MODULUS)
def Fr_fromBytes32(value: bytes) -> Fr: return Fr(value=b2n(value) % MODULUS)
def Fr_toBytes32(value: Fr) -> bytes: return n2b(value.value)
def Fr_invert(value: Fr) -> Fr: return Fr(value=expmod(value.value, MODULUS - 2, MODULUS))
# TODO: edit other pow, it only works for powers of two
def Fr_pow(base: Fr, v: int) -> Fr: return Fr(value=expmod(base.value, v, MODULUS))
def Fr_div(numerator: Fr, denominator: Fr) -> Fr: return numerator * Fr_invert(denominator)

# Free functions
def Fr_add(a: Fr, b: Fr) -> Fr: return Fr(value=addmod(a.value, b.value, MODULUS))
def Fr_mul(a: Fr, b: Fr) -> Fr: return Fr(value=mulmod(a.value, b.value, MODULUS))
def Fr_sub(a: Fr, b: Fr) -> Fr: return Fr(value=addmod(a.value, MODULUS - b.value, MODULUS))

# TODO: double check this!
def Fr_exp(base: Fr, exponent: Fr) -> Fr:
    if exponent.value == 0: return Fr(value=1)
    # Implement exponent with a loop as we will overflow otherwise
    i = 1
    while i < exponent.value:
        base = base * base
        i += i
    return base

def Fr_notEqual(a: Fr, b: Fr) -> bool: return a.value != b.value
def Fr_equal(a: Fr, b: Fr) -> bool: return a.value == b.value

## HonkTypes.sol

# Temp only set here for testing, logn will be templated
LOG_N: int = 0x0000000000000000000000000000000000000000000000000000000000000010

NUMBER_OF_SUBRELATIONS: int = 18
BATCHED_RELATION_PARTIAL_LENGTH: int = 7
NUMBER_OF_ENTITIES: int = 43
NUMBER_OF_ALPHAS: int = 17

# Prime field order
Q: int = 21888242871839275222246405745257275088696311157297823662689037894645226208583 # EC group order
P: int = 21888242871839275222246405745257275088548364400416034343698204186575808495617 # Prime field order

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

@dataclass
class G1Point:
    x: int
    y: int

@dataclass
class G1ProofPoint:
    x_0: int
    x_1: int
    y_0: int
    y_1: int

@dataclass
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
    qArith: G1Point # Arithmetic widget
    qSort: G1Point # Gen perm sort
    qAux: G1Point # Auxillary
    qElliptic: G1Point # Auxillary
    qLookup: G1Point # Lookup
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

@dataclass
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
    sumcheckUnivariates: list[list[Fr]]#[BATCHED_RELATION_PARTIAL_LENGTH][LOG_N]
    sumcheckEvaluations: list[Fr]#[NUMBER_OF_ENTITIES]
    # Zero morph
    zmCqs: list[G1ProofPoint]#[LOG_N]
    zmCq: G1ProofPoint
    zmPi: G1ProofPoint

'''
def dump_int(name: str, value: int):
    print(name, value)

def dump_Fr(name: str, fr: Fr):
    dump_int(name, fr.value)

def dump_G1Point(name: str, p: G1Point):
    dump_int(name + '.x', p.x)
    dump_int(name + '.y', p.y)

def dump_G1ProofPoint(name: str, pp: G1ProofPoint):
    dump_int(name + '.x_0', pp.x_0)
    dump_int(name + '.x_1', pp.x_1)
    dump_int(name + '.y_0', pp.y_0)
    dump_int(name + '.y_1', pp.y_1)

def dump_HonkVerificationKey(name: str, vk: HonkVerificationKey):
    dump_int(name + '.circuitSize', vk.circuitSize)
    dump_int(name + '.logCircuitSize', vk.logCircuitSize)
    dump_int(name + '.publicInputsSize', vk.publicInputsSize)
    dump_G1Point(name + '.qm', vk.qm)
    dump_G1Point(name + '.qc', vk.qc)
    dump_G1Point(name + '.ql', vk.ql)
    dump_G1Point(name + '.qr', vk.qr)
    dump_G1Point(name + '.qo', vk.qo)
    dump_G1Point(name + '.q4', vk.q4)
    dump_G1Point(name + '.qArith', vk.qArith)
    dump_G1Point(name + '.qSort', vk.qSort)
    dump_G1Point(name + '.qAux', vk.qAux)
    dump_G1Point(name + '.qElliptic', vk.qElliptic)
    dump_G1Point(name + '.qLookup', vk.qLookup)
    dump_G1Point(name + '.s1', vk.s1)
    dump_G1Point(name + '.s2', vk.s2)
    dump_G1Point(name + '.s3', vk.s3)
    dump_G1Point(name + '.s4', vk.s4)
    dump_G1Point(name + '.id1', vk.id1)
    dump_G1Point(name + '.id2', vk.id2)
    dump_G1Point(name + '.id3', vk.id3)
    dump_G1Point(name + '.id4', vk.id4)
    dump_G1Point(name + '.t1', vk.t1)
    dump_G1Point(name + '.t2', vk.t2)
    dump_G1Point(name + '.t3', vk.t3)
    dump_G1Point(name + '.t4', vk.t4)
    dump_G1Point(name + '.lagrangeFirst', vk.lagrangeFirst)
    dump_G1Point(name + '.lagrangeLast', vk.lagrangeLast)

def dump_HonkProof(name: str, p: HonkProof):
    dump_int(name + '.circuitSize', p.circuitSize)
    dump_int(name + '.publicInputsSize', p.publicInputsSize)
    dump_int(name + '.publicInputsOffset', p.publicInputsOffset)
    dump_G1ProofPoint(name + '.w1', p.w1)
    dump_G1ProofPoint(name + '.w2', p.w2)
    dump_G1ProofPoint(name + '.w3', p.w3)
    dump_G1ProofPoint(name + '.w4', p.w4)
    dump_G1ProofPoint(name + '.sortedAccum', p.sortedAccum)
    dump_G1ProofPoint(name + '.zPerm', p.zPerm)
    dump_G1ProofPoint(name + '.zLookup', p.zLookup)
    for i in range(LOG_N):
        for j in range(BATCHED_RELATION_PARTIAL_LENGTH):
            dump_Fr(name + '.sumcheckUnivariates[i][j]', p.sumcheckUnivariates[i][j])
    for i in range(NUMBER_OF_ENTITIES):
        dump_Fr(name + '.sumcheckEvaluations[i]', p.sumcheckEvaluations[i])
    for i in range(LOG_N):
        dump_G1ProofPoint(name + '.zmCqs[i]', p.zmCqs[i])
    dump_G1ProofPoint(name + '.zmCq', p.zmCq)
    dump_G1ProofPoint(name + '.zmPi', p.zmPi)
'''

## utils.sol

def convertProofPoint(point: G1ProofPoint) -> G1Point:
    return G1Point(x=point.x_0 | (point.x_1 << 136), y=point.y_0 | (point.y_1 << 136))

def ecMul(point: G1Point, scalar: Fr) -> G1Point:
    (x, y) = bn256_scalar_mul((point.x, point.y), scalar.value)
    return G1Point(x=x, y=y)

def ecAdd(point0: G1Point, point1: G1Point) -> G1Point:
    (x, y) = bn256_add((point0.x, point0.y), (point1.x, point1.y))
    return G1Point(x=x, y=y)

def ecSub(point0: G1Point, point1: G1Point) -> G1Point:
    negativePoint1Y = (Q - point1.y) % Q
    (x, y) = bn256_add((point0.x, point0.y), (point1.x, negativePoint1Y))
    return G1Point(x=x, y=y)

def negateInplace(point: G1Point) -> G1Point:
    point.y = (Q - point.y) % Q
    return point

## EcdsaHonkVerificationKey.sol

N: int = 0x0000000000000000000000000000000000000000000000000000000000010000
NUMBER_OF_PUBLIC_INPUTS: int = 0x0000000000000000000000000000000000000000000000000000000000000006

def loadVerificationKey() -> HonkVerificationKey:
    return HonkVerificationKey(
        circuitSize=0x0000000000000000000000000000000000000000000000000000000000010000,
        logCircuitSize=0x0000000000000000000000000000000000000000000000000000000000000010,
        publicInputsSize=0x0000000000000000000000000000000000000000000000000000000000000006,
        ql=G1Point(
            x=0x2aa1e5d9538920238fbd3438b27e069c1edb9c2807e75c5ccb78102d502717a5,
            y=0x2c2cee219fa2dcfc815cf63a3f6519c8ef3a048bb668fce2136ef09a3f1ed12e
        ),
        qr=G1Point(
            x=0x001e152cc12c0b54dc2d3bd1d7d017bf7491477d42620b73a0440aade3618c2e,
            y=0x2315ed9f374367c436dd9c6f429813fac22057de80f4c3370fa123d5f78aef2e
        ),
        qo=G1Point(
            x=0x1e03c43f995f5a063f6d9a629585b91a77a49190e6a76db92fa1b679ebbbb694,
            y=0x062c61a0e3454d8ed5dd8198c1db15612ed49c28685efe35a353f9c44e0c42fd
        ),
        q4=G1Point(
            x=0x1c919d8b75b3d41e260eff3b817f7a5a1bcd1387b8c5269b7f7cd7610f687a1a,
            y=0x266dfb8160f9492ae89282d7301a6252a5fc86b785a055959a85559fa7fe313b
        ),
        qm=G1Point(
            x=0x22b152101522ea0dec8afd61c48b2a406eabc0d39b46016af995a0d1b3260a16,
            y=0x22a67aba4da604029085db563b8c5f60ca0f9b4f12e7e845eb308b38d323d282
        ),
        qc=G1Point(
            x=0x0847b07bb1b03ed20243d7b8abf78300f7065713fb9f3753dfdcca3d25244507,
            y=0x07ff6fd445f7381b12a90a300e97caabb6fc23935c9ea235e4a837fdf341de40
        ),
        qArith=G1Point(
            x=0x01e6b4db22f35dd68007f699e1543653f270632f143d7e4164c6dcc4852540d3,
            y=0x25d7de890f88c904b900ae61e3d6eba8c2601793e0ef05eb25222ceac9c79ae6
        ),
        qSort=G1Point(
            x=0x0276b7be1fd261eff8381e6e8ffdb3725940af81118df85d7d8c608a4c90b298,
            y=0x19e04b6e50057551bc37fac5761c75b624913895785b28b8394543ce0e2af753
        ),
        qElliptic=G1Point(
            x=0x246d59a16c1352a8873e7f8a58b87bccfd189fc78d27f956f026236fc7d16162,
            y=0x156d472d90596472eb771c56f370e92cbc22282d7c7a01f7057c1d3ea70c92f2
        ),
        qAux=G1Point(
            x=0x048d8152d6204d873a42e7e86edca5a880ecfb96c18b2294098019de390755b2,
            y=0x2d36e390f7fede4cd8fc187ee4ed1b39f59ca26de94e6f5ca9813dfe4a786381
        ),
        qLookup=G1Point(
            x=0x1e7e7ccad6262d34fc92f0cc0aba7f07427b97099fd6b3c21eb0bb5ae781e9b2,
            y=0x25a590063ab4ac8254cac9a4faa08bb921038bb3b3f87faa0e04b9470e197be5
        ),
        s1=G1Point(
            x=0x2a471e6e6e9aa115123375f50bafdd03f799672c26e577e1beb7f903de2b96c6,
            y=0x28989bb0e1f9a69bde57d64557a24beab02921b2cc9de388d9963825705b6fae
        ),
        s2=G1Point(
            x=0x15c2a00e86ae04173083e75e79b479290879258c68143447fe20418c3e322d15,
            y=0x181de2e886b42daa1f3349da50775abd7fc4e467d8b026d20118e046cc31df2b
        ),
        s3=G1Point(
            x=0x2b4610081743e2c3e199358f8cdd959399b8210873e0f173bfede3e191a76372,
            y=0x0269f731fc4ba4df8b824a794d39692452e911450c261bd7c0ee421a187f3d70
        ),
        s4=G1Point(
            x=0x2599ef03b93cfa8e3dfc50a671f95aeed1fd6bcc137ddd18e8408f2b46c8a074,
            y=0x304cb90dbbe026323e92fe385f2e2ec108c524cbb7bb0f858429af8ec9b80ea1
        ),
        t1=G1Point(
            x=0x1ddc9ef86584375e5998d9f6fc16a4e646dc315ab86b477abc2f18a723dc24f6,
            y=0x03a3b132ca6590c4ffdf35e1acd932da680a4247a55c88dd2284af78cb047906
        ),
        t2=G1Point(
            x=0x1e4cde3e410660193bacdf1db498ffb6bf1618c4d7b355415858d7d996e8bd03,
            y=0x18d7f0300f961521ead0cb3c81a2a43a2dea0fdcb17bd772aef6c7b908be4273
        ),
        t3=G1Point(
            x=0x0e77f28b07af551fea1ad81b304fd41013850e8b3539309c20bb2fa115289642,
            y=0x15f92fde2f0d7a77c27daeb397336220ffc07b99f710980253e84f8ae94afd4d
        ),
        t4=G1Point(
            x=0x2285ea4116ca00b673b2daadf596052b6d9ba6d231a4bea8af5a3c0f28c44aa4,
            y=0x076bf1e1f682badebfca083e25d808e8dae96372631c0721a7ee238c333a862a
        ),
        id1=G1Point(
            x=0x24ec1e72fbaf9ee95dbc8a2abfbf8858799576fb9b8f5e7e63d8e0b1da32e692,
            y=0x28b7122f8e5a7397bf78e8bf8731a285f89516d3627c2c6b4c170b30b82faaf3
        ),
        id2=G1Point(
            x=0x206857ef4f7cc72a455c9c61a74fdad900a581f85a3001abac02e6f9bdd57243,
            y=0x1f3f454b77a5f607614b625059f2ee804af5c5b65beed4c61b48fa1bfcf1a819
        ),
        id3=G1Point(
            x=0x0946af4969c7508be03d0216caf93913dc178fe870c8c2c80958b3c492f383e2,
            y=0x0e1b3d5bf9b9152109d937399f9963626f38734734ece5f71d49f986a8fe2c1b
        ),
        id4=G1Point(
            x=0x195028efca7e54f5cc0b50bea74815f18c572a6b1ea833e885e0af3e5f0701fd,
            y=0x100e2da82d3e2c3157f190db75110b11f18c317945577f865ef830860921d737
        ),
        lagrangeFirst=G1Point(
            x=0x0000000000000000000000000000000000000000000000000000000000000001,
            y=0x0000000000000000000000000000000000000000000000000000000000000002
        ),
        lagrangeLast=G1Point(
            x=0x28bf8c9eeae6946902ee08351768a3e4f67d812e6465f55f16bf69fad16cf46d,
            y=0x12dab1c326b33ea63ec6651324077c0ea2cb0ddfafd63fb8f9fbcc70bd53d7e0
        )
    )

## Transcript.sol

@dataclass
class Transcript:
    eta: Fr
    beta: Fr
    gamma: Fr
    alphas: list[Fr]#[NUMBER_OF_ALPHAS]
    gateChallenges: list[Fr]#[LOG_N]
    sumCheckUChallenges: list[Fr]#[LOG_N]
    rho: Fr
    # Zero morph
    zmX: Fr
    zmY: Fr
    zmZ: Fr
    zmQuotient: Fr
    # Derived
    publicInputsDelta: Fr
    lookupGrandProductDelta: Fr

'''
def dump_Transcript(name: str, t: Transcript):
    dump_Fr(name + '.eta', t.eta)
    dump_Fr(name + '.beta', t.beta)
    dump_Fr(name + '.gamma', t.gamma)
    for i in range(NUMBER_OF_ALPHAS):
        dump_Fr(name + '.alphas[i]', t.alphas[i]);
    for i in range(LOG_N):
        dump_Fr(name + '.gateChallenges[i]', t.gateChallenges[i])
    for i in range(LOG_N):
        dump_Fr(name + '.sumCheckUChallenges[i]', t.sumCheckUChallenges[i])
    dump_Fr(name + '.rho', t.rho)
    dump_Fr(name + '.zmX', t.zmX)
    dump_Fr(name + '.zmY', t.zmY)
    dump_Fr(name + '.zmZ', t.zmZ)
    dump_Fr(name + '.zmQuotient', t.zmQuotient)
    dump_Fr(name + '.publicInputsDelta', t.publicInputsDelta)
    dump_Fr(name + '.lookupGrandProductDelta', t.lookupGrandProductDelta)
'''

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
        rho = rho,
        zmX=zmX,
        zmY=zmY,
        zmZ=zmZ,
        zmQuotient=Fr(value=0),
        publicInputsDelta=Fr(value=0),
        lookupGrandProductDelta=Fr(value=0)
    )

def generateEtaChallenge(proof: HonkProof, publicInputs: list[int]) -> Fr:
    # TODO(md): the 12 here will need to be halved when we fix the transcript to not be over field elements
    # TODO: use assembly
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
    eta = Fr_fromBytes32(keccak256(abi_encodePacked(round0)))
    return eta

def generateBetaAndGammaChallenges(previousChallenge: Fr, proof: HonkProof) -> tuple[Fr, Fr]:
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
    beta = Fr_fromBytes32(keccak256(abi_encodePacked(round1)))
    gamma = Fr_fromBytes32(keccak256(abi_encodePacked([beta.value])))
    return (beta, gamma)

# Alpha challenges non-linearise the gate contributions
def generateAlphaChallenges(previousChallenge: Fr, proof: HonkProof) -> list[Fr]:
    # Generate the original sumcheck alpha 0 by hashing zPerm and zLookup
    # TODO(md): 5 post correct proof size fix
    alphas: list[Fr] = (NUMBER_OF_ALPHAS) * [Fr(value=0)]
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
    prevChallenge = Fr_fromBytes32(keccak256(abi_encodePacked(alpha0)))
    alphas[0] = prevChallenge
    for i in range(1, NUMBER_OF_ALPHAS):
        prevChallenge = Fr_fromBytes32(keccak256(abi_encodePacked([prevChallenge.value])))
        alphas[i] = prevChallenge
    return alphas

def generateGateChallenges(previousChallenge: Fr) -> list[Fr]:#[LOG_N]
    gateChallenges: list[Fr] = (LOG_N) * [Fr(value=0)]
    for i in range(LOG_N):
        previousChallenge = Fr_fromBytes32(keccak256(abi_encodePacked([previousChallenge.value])))
        gateChallenges[i] = previousChallenge
    return gateChallenges

def generateSumcheckChallenges(proof: HonkProof, prevChallenge: Fr) -> list[Fr]:#[LOG_N]
    sumcheckChallenges: list[Fr] = (LOG_N) * [Fr(value=0)]
    for i in range(LOG_N):
        univariateChal: list[int] = (BATCHED_RELATION_PARTIAL_LENGTH + 1) * [0]
        univariateChal[0] = prevChallenge.value
        # TODO(opt): memcpy
        for j in range(BATCHED_RELATION_PARTIAL_LENGTH):
            univariateChal[j + 1] = proof.sumcheckUnivariates[i][j].value
        sumcheckChallenges[i] = Fr_fromBytes32(keccak256(abi_encodePacked(univariateChal)))
        prevChallenge = sumcheckChallenges[i]
    return sumcheckChallenges

def generateRhoChallenge(proof: HonkProof, prevChallenge: Fr) -> Fr:
    rhoChallengeElements: list[int] = (NUMBER_OF_ENTITIES + 1) * [0]
    rhoChallengeElements[0] = prevChallenge.value
    # TODO: memcpy
    for i in range(NUMBER_OF_ENTITIES):
        rhoChallengeElements[i + 1] = proof.sumcheckEvaluations[i].value
    rho = Fr_fromBytes32(keccak256(abi_encodePacked(rhoChallengeElements)))
    return rho

def generateZMYChallenge(previousChallenge: Fr, proof: HonkProof) -> Fr:
    zmY: list[int] = (LOG_N * 4 + 1) * [0]
    zmY[0] = previousChallenge.value
    for i in range(LOG_N):
        zmY[1 + i * 4] = proof.zmCqs[i].x_0
        zmY[2 + i * 4] = proof.zmCqs[i].x_1
        zmY[3 + i * 4] = proof.zmCqs[i].y_0
        zmY[4 + i * 4] = proof.zmCqs[i].y_1
    zeromorphY = Fr_fromBytes32(keccak256(abi_encodePacked(zmY)))
    return zeromorphY

def generateZMXZChallenges(previousChallenge: Fr, proof: HonkProof) ->  tuple[Fr, Fr]:
    buf: list[int] = (4 + 1) * [0]
    buf[0] = previousChallenge.value
    buf[1] = proof.zmCq.x_0
    buf[2] = proof.zmCq.x_1
    buf[3] = proof.zmCq.y_0
    buf[4] = proof.zmCq.y_1
    zeromorphX = Fr_fromBytes32(keccak256(abi_encodePacked(buf)))
    zeromorphZ = Fr_fromBytes32(keccak256(abi_encodePacked([zeromorphX.value])))
    return (zeromorphX, zeromorphZ)

## EcdsaHonkVerifier.sol

GRUMPKIN_CURVE_B_PARAMETER_NEGATED: Fr = Fr(value=17) # -(-17)

def verify(proof: bytes, publicInputs: list[int]) -> bool:
    vk = loadVerificationKey()
    p = loadProof(proof)
    if vk.publicInputsSize != len(publicInputs):
        raise ValueError('PublicInputsLengthWrong')
    # Generate the fiat shamir challenges for the whole protocol
    t = generateTranscript(p, publicInputs)
    # Compute the public input delta
    t.publicInputsDelta = computePublicInputDelta(publicInputs, t.beta, t.gamma, vk.circuitSize, p.publicInputsOffset)
    t.lookupGrandProductDelta = computeLookupGrandProductDelta(t.beta, t.gamma, vk.circuitSize)
    # Sumcheck
    sumcheckVerified = verifySumcheck(p, t)
    if not sumcheckVerified: raise ValueError('SumcheckFailed')
    # Zeromorph
    zeromorphVerified = verifyZeroMorph(p, vk, t)
    if not zeromorphVerified: raise ValueError('ZeromorphFailed')
    return sumcheckVerified and zeromorphVerified # Boolean condition not required - nice for vanity :)

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
        x_1=b2n(proof[0x80:0xa0]),
        y_0=b2n(proof[0xa0:0xc0]),
        y_1=b2n(proof[0xc0:0xe0])
    )
    w2 = G1ProofPoint(
        x_0=b2n(proof[0xe0:0x100]),
        x_1=b2n(proof[0x100:0x120]),
        y_0=b2n(proof[0x120:0x140]),
        y_1=b2n(proof[0x140:0x160])
    )
    w3 = G1ProofPoint(
        x_0=b2n(proof[0x160:0x180]),
        x_1=b2n(proof[0x180:0x1a0]),
        y_0=b2n(proof[0x1a0:0x1c0]),
        y_1=b2n(proof[0x1c0:0x1e0])
    )
    # Lookup / Permutation Helper Commitments
    sortedAccum = G1ProofPoint(
        x_0=b2n(proof[0x1e0:0x200]),
        x_1=b2n(proof[0x200:0x220]),
        y_0=b2n(proof[0x220:0x240]),
        y_1=b2n(proof[0x240:0x260])
    )
    w4 = G1ProofPoint(
        x_0=b2n(proof[0x260:0x280]),
        x_1=b2n(proof[0x280:0x2a0]),
        y_0=b2n(proof[0x2a0:0x2c0]),
        y_1=b2n(proof[0x2c0:0x2e0])
    )
    zPerm = G1ProofPoint(
        x_0=b2n(proof[0x2e0:0x300]),
        x_1=b2n(proof[0x300:0x320]),
        y_0=b2n(proof[0x320:0x340]),
        y_1=b2n(proof[0x340:0x360])
    )
    zLookup = G1ProofPoint(
        x_0=b2n(proof[0x360:0x380]),
        x_1=b2n(proof[0x380:0x3a0]),
        y_0=b2n(proof[0x3a0:0x3c0]),
        y_1=b2n(proof[0x3c0:0x3e0])
    )
    # TEMP the boundary of what has already been read
    boundary = 0x3e0
    # Sumcheck univariates
    # TODO: in this case we know what log_n is - so we hard code it, we would want this to be included in
    # a cpp template for different circuit sizes
    sumcheckUnivariates: list[list[Fr]] = (LOG_N) * [(BATCHED_RELATION_PARTIAL_LENGTH) * [Fr(value=0)]]
    for i in range(LOG_N):
        sumcheckUnivariates[i] = (BATCHED_RELATION_PARTIAL_LENGTH) * [Fr(value=0)]
        # The loop boundary of i, this will shift forward on each evaluation
        loop_boundary = boundary + (i * 0x20 * BATCHED_RELATION_PARTIAL_LENGTH)
        for j in range(BATCHED_RELATION_PARTIAL_LENGTH):
            start = loop_boundary + (j * 0x20)
            end = start + 0x20
            sumcheckUnivariates[i][j] = Fr_fromBytes32(proof[start:end])
    boundary = boundary + (LOG_N * BATCHED_RELATION_PARTIAL_LENGTH * 0x20)
    # Sumcheck evaluations
    sumcheckEvaluations: list[Fr] = (NUMBER_OF_ENTITIES) * [Fr(value=0)]
    for i in range(NUMBER_OF_ENTITIES):
        start = boundary + (i * 0x20)
        end = start + 0x20
        sumcheckEvaluations[i] = Fr_fromBytes32(proof[start:end])
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
            y_1=b2n(proof[y1Start:y1End])
        )
    boundary = boundary + (LOG_N * 0x80)
    zmCq = G1ProofPoint(
        x_0=b2n(proof[boundary:boundary + 0x20]),
        x_1=b2n(proof[boundary + 0x20:boundary + 0x40]),
        y_0=b2n(proof[boundary + 0x40:boundary + 0x60]),
        y_1=b2n(proof[boundary + 0x60:boundary + 0x80])
    )
    zmPi = G1ProofPoint(
        x_0=b2n(proof[boundary + 0x80:boundary + 0xa0]),
        x_1=b2n(proof[boundary + 0xa0:boundary + 0xc0]),
        y_0=b2n(proof[boundary + 0xc0:boundary + 0xe0]),
        y_1=b2n(proof[boundary + 0xe0:boundary + 0x100])
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
        zmPi=zmPi
    )

def computePublicInputDelta(publicInputs: list[int], beta: Fr, gamma: Fr, domainSize: int, offset: int) -> Fr:
    numerator = Fr(value=1)
    denominator = Fr(value=1)
    numeratorAcc = gamma + (beta * Fr_from(domainSize + offset))
    denominatorAcc = gamma - (beta * Fr_from(offset + 1))
    for publicInput in publicInputs:
        pubInput = Fr_from(publicInput)
        numerator = numerator * (numeratorAcc + pubInput)
        denominator = denominator * (denominatorAcc + pubInput)
        numeratorAcc = numeratorAcc + beta
        denominatorAcc = denominatorAcc - beta
    # Fr delta = numerator / denominator; // TOOO: batch invert later?
    publicInputDelta = Fr_div(numerator, denominator)
    return publicInputDelta

# Incorportate the original plookup construction into honk
def computeLookupGrandProductDelta(beta: Fr, gamma: Fr, domainSize: int) -> Fr:
    gammaByOnePlusBeta = gamma * (beta + Fr(value=1))
    # TODO: dont like using ^ for exponent - might just make a function
    lookupGrandProductDelta = gammaByOnePlusBeta ** Fr(value=domainSize)
    return  lookupGrandProductDelta

ROUND_TARGET: int = 0

def verifySumcheck(proof: HonkProof, tp: Transcript) -> bool:
    roundTarget = Fr(value=0)
    powPartialEvaluation = Fr(value=1)
    # We perform sumcheck reductions over log n rounds ( the multivariate degree )
    for rnd in range(LOG_N):
        roundUnivariate = proof.sumcheckUnivariates[rnd]
        valid = checkSum(roundUnivariate, roundTarget)
        roundChallenge = tp.sumCheckUChallenges[rnd]
        # Update the round target for the next rounf
        roundTarget = computeNextTargetSum(roundUnivariate, roundChallenge)
        powPartialEvaluation = partiallyEvaluatePOW(tp, powPartialEvaluation, roundChallenge, rnd)
    # Last round
    grandHonkRelationSum = accumulateRelationEvaluations(proof, tp, powPartialEvaluation)
    verified = grandHonkRelationSum == roundTarget
    return verified

def checkSum(roundUnivariate: list[Fr], roundTarget: Fr) -> bool:
    totalSum = roundUnivariate[0] + roundUnivariate[1]
    checked = totalSum != roundTarget
    return checked

# Return the new target sum for the next sumcheck round
def computeNextTargetSum(roundUnivariates: list[Fr], roundChallenge: Fr) -> Fr:
    # TODO: inline
    BARYCENTRIC_LAGRANGE_DENOMINATORS: list[Fr] = [
        Fr(value=0x00000000000000000000000000000000000000000000000000000000000002d0),
        Fr(value=0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffff89),
        Fr(value=0x0000000000000000000000000000000000000000000000000000000000000030),
        Fr(value=0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffffdd),
        Fr(value=0x0000000000000000000000000000000000000000000000000000000000000030),
        Fr(value=0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593efffff89),
        Fr(value=0x00000000000000000000000000000000000000000000000000000000000002d0)
    ]
    BARYCENTRIC_DOMAIN: list[Fr] = [Fr(value=0x00), Fr(value=0x01), Fr(value=0x02), Fr(value=0x03), Fr(value=0x04), Fr(value=0x05), Fr(value=0x06)]
    # To compute the next target sum, we evaluate the given univariate at a point u (challenge).
    # TODO: opt: use same array mem for each iteratioon
    # Performing Barycentric evaluations
    # Compute B(x)
    numeratorValue = Fr(value=1)
    for i in range(BATCHED_RELATION_PARTIAL_LENGTH):
        numeratorValue = numeratorValue * (roundChallenge - Fr(value=i))
    # Calculate domain size N of inverses -- TODO: montgomery's trick
    denominatorInverses: list[Fr] = (BATCHED_RELATION_PARTIAL_LENGTH) * [Fr(value=0)]
    for i in range(BATCHED_RELATION_PARTIAL_LENGTH):
        inv = BARYCENTRIC_LAGRANGE_DENOMINATORS[i]
        inv = inv * (roundChallenge - BARYCENTRIC_DOMAIN[i])
        inv = Fr_invert(inv)
        denominatorInverses[i] = inv
    targetSum = Fr(value=0)
    for i in range(BATCHED_RELATION_PARTIAL_LENGTH):
        term = roundUnivariates[i]
        term = term * denominatorInverses[i]
        targetSum = targetSum + term
    # Scale the sum by the value of B(x)
    targetSum = targetSum * numeratorValue
    return targetSum

# Univariate evaluation of the monomial ((1-X_l) + X_l.B_l) at the challenge point X_l=u_l
def partiallyEvaluatePOW(tp: Transcript, currentEvaluation: Fr, roundChallenge: Fr, rnd: int) -> Fr:
    univariateEval = Fr(value=1) + (roundChallenge * (tp.gateChallenges[rnd] - Fr(value=1)))
    newEvaluation = currentEvaluation * univariateEval
    return newEvaluation

# Calculate the contributions of each relation to the expected value of the full honk relation
#
# For each relation, we use the purported values ( the ones provided by the prover ) of the multivariates to
# calculate a contribution to the purported value of the full Honk relation.
# These are stored in the evaluations part of the proof object.
# We add these together, with the appropiate scaling factor ( the alphas calculated in challenges )
# This value is checked against the final value of the target total sum - et voila!
def accumulateRelationEvaluations(proof: HonkProof, tp: Transcript, powPartialEval: Fr) -> Fr:
    purportedEvaluations = proof.sumcheckEvaluations
    evaluations: list[Fr] = (NUMBER_OF_SUBRELATIONS) * [Fr(value=0)]
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
def wire(p: list[Fr], wire: WIRE) -> Fr: return p[wire.value]

# Ultra Arithmetic Relation
def accumulateArithmeticRelation(p: list[Fr], evals: list[Fr], powPartialEval: Fr):
    # Relation 0
    q_arith = wire(p, WIRE.Q_ARITH)
    neg_half = Fr(value=0) - Fr_invert(Fr(value=2))
    accum = (q_arith - Fr(value=3)) * (wire(p, WIRE.Q_M) * wire(p, WIRE.W_R) * wire(p, WIRE.W_L)) * neg_half
    accum = accum + (wire(p, WIRE.Q_L) * wire(p, WIRE.W_L)) + (wire(p, WIRE.Q_R) * wire(p, WIRE.W_R)) + (wire(p, WIRE.Q_O) * wire(p, WIRE.W_O)) + (wire(p, WIRE.Q_4) * wire(p, WIRE.W_4)) + wire(p, WIRE.Q_C)
    accum = accum + (q_arith - Fr(value=1)) * wire(p, WIRE.W_4_SHIFT)
    accum = accum * q_arith
    accum = accum * powPartialEval
    evals[0] = accum
    # Relation 1
    accum = wire(p, WIRE.W_L) + wire(p, WIRE.W_4) - wire(p, WIRE.W_L_SHIFT) + wire(p, WIRE.Q_M)
    accum = accum * (q_arith - Fr(value=2))
    accum = accum * (q_arith - Fr(value=1))
    accum = accum * q_arith
    accum = accum * powPartialEval
    evals[1] = accum

def accumulatePermutationRelation(p: list[Fr], tp: Transcript, evals: list[Fr], domainSep: Fr):
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
    acc = (wire(p, WIRE.Z_PERM) + wire(p, WIRE.LAGRANGE_FIRST)) * grand_product_numerator
    acc = acc - ((wire(p, WIRE.Z_PERM_SHIFT) + (wire(p, WIRE.LAGRANGE_LAST) * tp.publicInputsDelta)) * grand_product_denominator)
    acc = acc * domainSep
    evals[2] = acc
    # Contribution 3
    acc = (wire(p, WIRE.LAGRANGE_LAST) * wire(p, WIRE.Z_PERM_SHIFT)) * domainSep
    evals[3] = acc

# Lookup parameters have been yoinked into memory to avoid stack too deep
@dataclass
class LookupParams:
    eta_sqr: Fr
    eta_cube: Fr
    one_plus_beta: Fr
    gamma_by_one_plus_beta: Fr
    wire_accum: Fr
    table_accum: Fr
    table_accum_shift: Fr

def accumulateLookupRelation(p: list[Fr], tp: Transcript, evals: list[Fr], domainSep: Fr):
    lp = LookupParams(
        eta_sqr=Fr(value=0),
        eta_cube=Fr(value=0),
        one_plus_beta=Fr(value=0),
        gamma_by_one_plus_beta=Fr(value=0),
        wire_accum=Fr(value=0),
        table_accum=Fr(value=0),
        table_accum_shift=Fr(value=0)
    )
    # TODO: note, eta square and eta cubed domain seperators will be replaced with further challenges in the future to reduce the
    # algebraic degree of the lookup relations
    lp.eta_sqr = tp.eta * tp.eta
    lp.eta_cube = lp.eta_sqr * tp.eta
    lp.one_plus_beta = tp.beta + Fr(value=1)
    lp.gamma_by_one_plus_beta = tp.gamma * lp.one_plus_beta
    # (wire(p,WIRE.W_L)] + q_2*wire(p,WIRE.W_1_SHIFT)]) + η(wire(p,WIRE.W_R)] + q_m*wire(p,WIRE.W_2_SHIFT)]) + η²(wire(p,WIRE.W_O)] + q_c*wire(p,WIRE.W_3_SHIFT)]) + η³q_index.
    # deg 2 or 4
    wire_accum = wire(p, WIRE.W_L) + wire(p, WIRE.Q_R) * wire(p, WIRE.W_L_SHIFT)
    wire_accum = wire_accum + (wire(p, WIRE.W_R) + wire(p, WIRE.Q_M) * wire(p, WIRE.W_R_SHIFT)) * tp.eta
    wire_accum = wire_accum + (wire(p, WIRE.W_O) + wire(p, WIRE.Q_C) * wire(p, WIRE.W_O_SHIFT)) * lp.eta_sqr
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
    lp.table_accum_shift = wire(p, WIRE.TABLE_1_SHIFT) + wire(p, WIRE.TABLE_2_SHIFT) * tp.eta + wire(p, WIRE.TABLE_3_SHIFT) * lp.eta_sqr + wire(p, WIRE.TABLE_4_SHIFT) * lp.eta_cube
    acc = wire(p, WIRE.Q_LOOKUP) * lp.wire_accum + tp.gamma
    acc = acc * (lp.table_accum + lp.table_accum_shift * tp.beta + lp.gamma_by_one_plus_beta)
    acc = acc * lp.one_plus_beta
    grand_product_numerator = acc
    acc = wire(p, WIRE.SORTED_ACCUM) + wire(p, WIRE.SORTED_ACCUM_SHIFT) * tp.beta + lp.gamma_by_one_plus_beta
    grand_product_denominator = acc
    # Contribution 4
    acc = grand_product_numerator * (wire(p, WIRE.Z_LOOKUP) + wire(p, WIRE.LAGRANGE_FIRST)) - grand_product_denominator * (wire(p, WIRE.Z_LOOKUP_SHIFT) + wire(p, WIRE.LAGRANGE_LAST) * tp.lookupGrandProductDelta)
    acc = acc * domainSep
    evals[4] = acc
    # Contribution 5
    acc = wire(p, WIRE.LAGRANGE_LAST) * wire(p, WIRE.Z_LOOKUP_SHIFT) * domainSep
    evals[5] = acc

def accumulateGenPermRelation(p: list[Fr], evals: list[Fr], domainSep: Fr):
    minus_one = Fr(value=0) - Fr(value=1)
    minus_two = Fr(value=0) - Fr(value=2)
    minus_three = Fr(value=0) - Fr(value=3)
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

@dataclass
class EllipticParams:
    # Points
    x_1: Fr
    y_1: Fr
    x_2: Fr
    y_2: Fr
    y_3: Fr
    x_3: Fr
    # push accumulators into memory
    x_double_identity: Fr

def accumulateEllipticRelation(p: list[Fr], evals: list[Fr], domainSep: Fr):
    ep = EllipticParams(
        x_1=Fr(value=0),
        y_1=Fr(value=0),
        x_2=Fr(value=0),
        y_2=Fr(value=0),
        y_3=Fr(value=0),
        x_3=Fr(value=0),
        x_double_identity=Fr(value=0)
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
    evals[10] = x_add_identity * partialEval * wire(p, WIRE.Q_ELLIPTIC) * (Fr(value=1) - q_is_double)
    # Contribution 11 point addition, x-coordinate check
    # q_elliptic * (q_sign * y1 + y3)(x2 - x1) + (x3 - x1)(y2 - q_sign * y1) = 0
    y1_plus_y3 = ep.y_1 + ep.y_3
    y_diff = ep.y_2 * q_sign - ep.y_1
    y_add_identity = y1_plus_y3 * x_diff + (ep.x_3 - ep.x_1) * y_diff
    evals[11] = y_add_identity * domainSep * wire(p, WIRE.Q_ELLIPTIC) * (Fr(value=1) - q_is_double)
    # Contribution 10 point doubling, x-coordinate check
    # (x3 + x1 + x1) (4y1*y1) - 9 * x1 * x1 * x1 * x1 = 0
    # N.B. we're using the equivalence x1*x1*x1 === y1*y1 - curve_b to reduce degree by 1
    x_pow_4 = (y1_sqr + GRUMPKIN_CURVE_B_PARAMETER_NEGATED) * ep.x_1
    y1_sqr_mul_4 = y1_sqr + y1_sqr
    y1_sqr_mul_4 = y1_sqr_mul_4 + y1_sqr_mul_4
    x1_pow_4_mul_9 = x_pow_4 * Fr(value=9)
    # NOTE: pushed into memory (stack >:'( )
    ep.x_double_identity = (ep.x_3 + ep.x_1 + ep.x_1) * y1_sqr_mul_4 - x1_pow_4_mul_9
    acc = ep.x_double_identity * domainSep * wire(p, WIRE.Q_ELLIPTIC) * q_is_double
    evals[10] = evals[10] + acc
    # Contribution 11 point doubling, y-coordinate check
    # (y1 + y1) (2y1) - (3 * x1 * x1)(x1 - x3) = 0
    x1_sqr_mul_3 = (ep.x_1 + ep.x_1 + ep.x_1) * ep.x_1
    y_double_identity = x1_sqr_mul_3 * (ep.x_1 - ep.x_3) - (ep.y_1 + ep.y_1) * (ep.y_1 + ep.y_3)
    evals[11] = evals[11] + y_double_identity * domainSep * wire(p, WIRE.Q_ELLIPTIC) * q_is_double

# Constants for the auxiliary relation
LIMB_SIZE: Fr = Fr(value=1 << 68)
SUBLIMB_SHIFT: Fr = Fr(value=1 << 14)
MINUS_ONE: Fr = Fr(value=P - 1)

# Parameters used within the Auxiliary Relation
# A struct is used to work around stack too deep. This relation has alot of variables
@dataclass
class AuxParams:
    limb_subproduct: Fr
    non_native_field_gate_1: Fr
    non_native_field_gate_2: Fr
    non_native_field_gate_3: Fr
    limb_accumulator_1: Fr
    limb_accumulator_2: Fr
    memory_record_check: Fr
    partial_record_check: Fr
    next_gate_access_type: Fr
    record_delta: Fr
    index_delta: Fr
    adjacent_values_match_if_adjacent_indices_match: Fr
    adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation: Fr
    access_check: Fr
    next_gate_access_type_is_boolean: Fr
    ROM_consistency_check_identity: Fr
    RAM_consistency_check_identity: Fr
    timestamp_delta: Fr
    RAM_timestamp_check_identity: Fr
    memory_identity: Fr
    index_is_monotonically_increasing: Fr
    auxiliary_identity: Fr

def accumulateAuxillaryRelation(p: list[Fr], tp: Transcript, evals: list[Fr], domainSep: Fr):
    ap = AuxParams(
        limb_subproduct=Fr(value=0),
        non_native_field_gate_1=Fr(value=0),
        non_native_field_gate_2=Fr(value=0),
        non_native_field_gate_3=Fr(value=0),
        limb_accumulator_1=Fr(value=0),
        limb_accumulator_2=Fr(value=0),
        memory_record_check=Fr(value=0),
        partial_record_check=Fr(value=0),
        next_gate_access_type=Fr(value=0),
        record_delta=Fr(value=0),
        index_delta=Fr(value=0),
        adjacent_values_match_if_adjacent_indices_match=Fr(value=0),
        adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation=Fr(value=0),
        access_check=Fr(value=0),
        next_gate_access_type_is_boolean=Fr(value=0),
        ROM_consistency_check_identity=Fr(value=0),
        RAM_consistency_check_identity=Fr(value=0),
        timestamp_delta=Fr(value=0),
        RAM_timestamp_check_identity=Fr(value=0),
        memory_identity=Fr(value=0),
        index_is_monotonically_increasing=Fr(value=0),
        auxiliary_identity=Fr(value=0)
    )
    # Contribution 12
    # Non native field arithmetic gate 2
    # deg 4
    #             _                                                                               _
    #            /   _                   _                               _       14                \
    # q_2 . q_4 |   (w_1 . w_2) + (w_1 . w_2) + (w_1 . w_4 + w_2 . w_3 - w_3) . 2    - w_3 - w_4   |
    #            \_                                                                               _/
    ap.limb_subproduct = wire(p, WIRE.W_L) * wire(p, WIRE.W_R_SHIFT) + wire(p, WIRE.W_L_SHIFT) * wire(p, WIRE.W_R)
    ap.non_native_field_gate_2 = wire(p, WIRE.W_L) * wire(p, WIRE.W_4) + wire(p, WIRE.W_R) * wire(p, WIRE.W_O) - wire(p, WIRE.W_O_SHIFT)
    ap.non_native_field_gate_2 = ap.non_native_field_gate_2 * LIMB_SIZE
    ap.non_native_field_gate_2 = ap.non_native_field_gate_2 - wire(p, WIRE.W_4_SHIFT)
    ap.non_native_field_gate_2 = ap.non_native_field_gate_2 + ap.limb_subproduct
    ap.non_native_field_gate_2 = ap.non_native_field_gate_2 * wire(p, WIRE.Q_4)
    ap.limb_subproduct = ap.limb_subproduct * LIMB_SIZE
    ap.limb_subproduct = ap.limb_subproduct + (wire(p, WIRE.W_L_SHIFT) * wire(p, WIRE.W_R_SHIFT))
    ap.non_native_field_gate_1 = ap.limb_subproduct
    ap.non_native_field_gate_1 = ap.non_native_field_gate_1 - (wire(p, WIRE.W_O) + wire(p, WIRE.W_4))
    ap.non_native_field_gate_1 = ap.non_native_field_gate_1 * wire(p, WIRE.Q_O)
    ap.non_native_field_gate_3 = ap.limb_subproduct
    ap.non_native_field_gate_3 = ap.non_native_field_gate_3 + wire(p, WIRE.W_4)
    ap.non_native_field_gate_3 = ap.non_native_field_gate_3 - (wire(p, WIRE.W_O_SHIFT) + wire(p, WIRE.W_4_SHIFT))
    ap.non_native_field_gate_3 = ap.non_native_field_gate_3 * wire(p, WIRE.Q_M)
    non_native_field_identity = ap.non_native_field_gate_1 + ap.non_native_field_gate_2 + ap.non_native_field_gate_3
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
    limb_accumulator_identity = limb_accumulator_identity * wire(p, WIRE.Q_O) #  deg 3
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
    ap.partial_record_check = ap.memory_record_check # used in RAM consistency check; deg 1 or 4
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
    ap.index_is_monotonically_increasing = ap.index_delta * ap.index_delta - ap.index_delta # deg 2
    ap.adjacent_values_match_if_adjacent_indices_match = (ap.index_delta * MINUS_ONE + Fr(value=1)) * ap.record_delta # deg 2
    evals[13] = ap.adjacent_values_match_if_adjacent_indices_match * (wire(p, WIRE.Q_L) * wire(p, WIRE.Q_R)) * (wire(p, WIRE.Q_AUX) * domainSep) # deg 5
    evals[14] = ap.index_is_monotonically_increasing * (wire(p, WIRE.Q_L) * wire(p, WIRE.Q_R)) * (wire(p, WIRE.Q_AUX) * domainSep) # deg 5
    ap.ROM_consistency_check_identity = ap.memory_record_check * (wire(p, WIRE.Q_L) * wire(p, WIRE.Q_R)) # deg 3 or 7
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
    access_type = wire(p, WIRE.W_4) - ap.partial_record_check # will be 0 or 1 for honest Prover; deg 1 or 4
    ap.access_check = access_type * access_type - access_type # check value is 0 or 1; deg 2 or 8
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
    ap.adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation = (ap.index_delta * MINUS_ONE + Fr(value=1)) * value_delta * (ap.next_gate_access_type * MINUS_ONE + Fr(value=1)) # deg 3 or 6
    # We can't apply the RAM consistency check identity on the final entry in the sorted list (the wires in the
    # next gate would make the identity fail).  We need to validate that its 'access type' bool is correct. Can't
    # do  with an arithmetic gate because of the  `eta` factors. We need to check that the *next* gate's access
    # type is  correct, to cover this edge case
    # deg 2 or 4
    ap.next_gate_access_type_is_boolean = ap.next_gate_access_type * ap.next_gate_access_type - ap.next_gate_access_type
    # Putting it all together...
    evals[15] = ap.adjacent_values_match_if_adjacent_indices_match_and_next_access_is_a_read_operation * wire(p, WIRE.Q_ARITH) * (wire(p, WIRE.Q_AUX) * domainSep) # deg 5 or 8
    evals[16] = ap.index_is_monotonically_increasing * wire(p, WIRE.Q_ARITH) * (wire(p, WIRE.Q_AUX) * domainSep) # deg 4
    evals[17] = ap.next_gate_access_type_is_boolean * wire(p, WIRE.Q_ARITH) * (wire(p, WIRE.Q_AUX) * domainSep) # deg 4 or 6
    ap.RAM_consistency_check_identity = ap.access_check * wire(p, WIRE.Q_ARITH) # deg 3 or 9
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
    ap.RAM_timestamp_check_identity = (ap.index_delta * MINUS_ONE + Fr(value=1)) * ap.timestamp_delta - wire(p, WIRE.W_O) # deg 3
    # Complete Contribution 12
    # The complete RAM/ROM memory identity
    # Partial degree:
    ap.memory_identity = ap.ROM_consistency_check_identity # deg 3 or 6
    ap.memory_identity = ap.memory_identity + ap.RAM_timestamp_check_identity * (wire(p, WIRE.Q_4) * wire(p, WIRE.Q_L)) # deg 4
    ap.memory_identity = ap.memory_identity + ap.memory_record_check * (wire(p, WIRE.Q_M) * wire(p, WIRE.Q_L)) # deg 3 or 6
    ap.memory_identity = ap.memory_identity + ap.RAM_consistency_check_identity # deg 3 or 9
    # (deg 3 or 9) + (deg 4) + (deg 3)
    ap.auxiliary_identity = ap.memory_identity + non_native_field_identity + limb_accumulator_identity
    ap.auxiliary_identity = ap.auxiliary_identity * (wire(p, WIRE.Q_AUX) * domainSep) # deg 4 or 10
    evals[12] = ap.auxiliary_identity

def scaleAndBatchSubrelations(evaluations: list[Fr], subrelationChallenges: list[Fr]) -> Fr:
    accumulator = evaluations[0]
    for i in range(1, NUMBER_OF_SUBRELATIONS):
        accumulator = accumulator + evaluations[i] * subrelationChallenges[i - 1]
    return accumulator

def verifyZeroMorph(proof: HonkProof, vk: HonkVerificationKey, tp: Transcript) -> bool:
    # Construct batched evaluation v = sum_{i=0}^{m-1}\rho^i*f_i(u) + sum_{i=0}^{l-1}\rho^{m+i}*h_i(u)
    batchedEval = Fr(value=0)
    batchedScalar = Fr(value=1)
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
    # WORKTODO: concerned that this is zero - it is multiplied by a point later on
    evaluation = Fr(value=0)
    verified = zkgReduceVerify(proof, tp, evaluation, c_zeta_Z)
    return verified

# Compute commitment to lifted degree quotient identity
def computeCZeta(proof: HonkProof, tp: Transcript) -> G1Point:
    scalars: list[Fr] = (LOG_N + 1) * [Fr(value=0)]
    commitments: list[G1ProofPoint] = (LOG_N + 1) * [G1ProofPoint(x_0=0, x_1=0, y_0=0, y_1=0)]
    # Initial contribution
    commitments[0] = proof.zmCq
    scalars[0] = Fr(value=1)
    # TODO: optimize pow operations here ? batch mulable
    for k in range(LOG_N):
        degree = Fr(value=(1 << k) - 1)
        scalar = Fr_pow(tp.zmY, k)
        scalar = scalar * Fr_pow(tp.zmX, (1 << LOG_N) - degree.value - 1)
        scalar = scalar * MINUS_ONE
        scalars[k + 1] = scalar
        commitments[k + 1] = proof.zmCqs[k]
    # Convert all commitments for batch mul
    comms = convertPoints(commitments)
    return batchMul(comms, scalars)

@dataclass
class CZetaXParams:
    phi_numerator: Fr
    phi_n_x: Fr
    rho_pow: Fr
    phi_1: Fr
    phi_2: Fr
    x_pow_2k: Fr
    x_pow_2kp1: Fr

def computeCZetaX(proof: HonkProof, vk: HonkVerificationKey, tp: Transcript, batchedEval: Fr) -> G1Point:
    scalars: list[Fr] = (NUMBER_OF_ENTITIES + LOG_N + 1) * [Fr(value=0)]
    commitments: list[G1Point] = (NUMBER_OF_ENTITIES + LOG_N + 1) * [G1Point(x=0, y=0)]
    cp = CZetaXParams(
        phi_numerator=Fr(value=0),
        phi_n_x=Fr(value=0),
        rho_pow=Fr(value=0),
        phi_1=Fr(value=0),
        phi_2=Fr(value=0),
        x_pow_2k=Fr(value=0),
        x_pow_2kp1=Fr(value=0)
    )
    # Phi_n(x) = (x^N - 1) / (x - 1)
    cp.phi_numerator = Fr_pow(tp.zmX, (1 << LOG_N)) - Fr(value=1)
    cp.phi_n_x = Fr_div(cp.phi_numerator, tp.zmX - Fr(value=1))
    # Add contribution: -v * x * \Phi_n(x) * [1]_1
    # Add base
    scalars[0] = MINUS_ONE * batchedEval * tp.zmX * cp.phi_n_x
    commitments[0] = G1Point(x=1, y=2) # One
    # f - Add all unshifted commitments
    # g - Add add to be shifted commitments
    # f commitments are accumulated at (zm_x * r)
    cp.rho_pow = Fr(value=1)
    for i in range(1, 33):
        scalars[i] = tp.zmX * cp.rho_pow
        cp.rho_pow = cp.rho_pow * tp.rho
    # g commitments are accumulated at r
    for i in range(33, 44):
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
        cp.phi_1 = Fr_div(cp.phi_numerator, cp.x_pow_2kp1 - Fr(value=1))
        cp.phi_2 = Fr_div(cp.phi_numerator, cp.x_pow_2k - Fr(value=1))
        scalar = cp.x_pow_2k * cp.phi_1
        scalar = scalar - (tp.sumCheckUChallenges[k] * cp.phi_2)
        scalar = scalar * tp.zmX
        scalar = scalar * MINUS_ONE
        scalars[44 + k] = scalar
        commitments[44 + k] = convertProofPoint(proof.zmCqs[k])
        cp.x_pow_2k = cp.x_pow_2kp1
        cp.x_pow_2kp1 = cp.x_pow_2kp1 * cp.x_pow_2kp1
    return batchMul2(commitments, scalars)

# TODO: TODO: TODO: optimize
# Scalar Mul and acumulate into total
def batchMul(base: list[G1Point], scalars: list[Fr]) -> G1Point:
    result = bn256_scalar_mul((base[0].x, base[0].y), scalars[0].value)
    for i in range(1, LOG_N + 1):
        result = bn256_add(result, bn256_scalar_mul((base[i].x, base[i].y), scalars[i].value))
    (x, y) = result
    return G1Point(x=x, y=y)

# This implementation is the same as above with different constants
def batchMul2(base: list[G1Point], scalars: list[Fr]) -> G1Point:
    result = bn256_scalar_mul((base[0].x, base[0].y), scalars[0].value)
    for i in range(1, NUMBER_OF_ENTITIES + LOG_N + 1):
        result = bn256_add(result, bn256_scalar_mul((base[i].x, base[i].y), scalars[i].value))
    (x, y) = result
    return G1Point(x=x, y=y)

def zkgReduceVerify(proof: HonkProof, tp: Transcript, evaluation: Fr, commitment: G1Point) -> bool:
    quotient_commitment = convertProofPoint(proof.zmPi)
    ONE = G1Point(x=1, y=2)
    P0 = commitment
    P0 = ecAdd(P0, ecMul(quotient_commitment, tp.zmX))
    evalAsPoint = ecMul(ONE, evaluation)
    P0 = ecSub(P0, evalAsPoint)
    P1 = negateInplace(quotient_commitment)
    # Perform pairing check
    return pairing(P0, P1)

def pairing(rhs: G1Point, lhs: G1Point) -> bool:
    return bn256_pairing(
        (rhs.x, rhs.y),
        # Fixed G1 point
        (
            0x198e9393920d483a7260bfb731fb5d25f1aa493335a9e71297e485b7aef312c2,
            0x1800deef121f1e76426a00665e5c4479674322d4f75edadd46debd5cd992f6ed,
            0x090689d0585ff075ec9e99ad690c3395bc4b313370b38ef355acdadcd122975b,
            0x12c85ea5db8c6deb4aab71808dcb408fe3d1e7690c43d37b4ce6cc0166fa7daa,
        ),
        (lhs.x, lhs.y),
        # G1 point from VK
        (
            0x260e01b251f6f1c7e7ff4e580791dee8ea51d87a358e038b4efe30fac09383c1,
            0x0118c4d5b837bcc2bc89b5b398b5974e9f5944073b32078b7e231fec938883b0,
            0x04fc6369f7110fe3d25156c1bb9a72859cf2a04641f99ba4ee413c80da6a5fe4,
            0x22febda3c0c0632a56475b4214e5615e11e6dd3f96e6cea2854a87d4dacc5e55
        )
    )

def convertPoints(commitments: list[G1ProofPoint]) -> list[G1Point]:
    converted: list[G1Point] = (LOG_N + 1) * [G1Point(x=0, y=0)]
    for i in range(LOG_N + 1):
        converted[i] = convertProofPoint(commitments[i])
    return converted

# main tests

import json

def test(name: str) -> None:
    with open('./' + name + '.json', 'r') as f:
        record = json.load(f)
    proof = h2b(record['proof'])
    publicInputs = [h2n(publicInput) for publicInput in record['publicInputs']] 
    success = verify(proof, publicInputs)
    print(name + '=' + ('true' if success else 'false'))

def main() -> None:
    test('testFuzzProof')
    test('testValidProof')

if __name__ == "__main__":
    main()
