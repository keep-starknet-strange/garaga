import binascii

h2b = lambda s: binascii.unhexlify(('0' if len(s) % 2 != 0 else '') + s)
b2h = lambda b: binascii.hexlify(b).decode()

h2n = lambda s: 0 if s == '' else int(s, 16)
n2h = lambda n, l=0: '%%0%dx' % (2*l) % n if n > 0 or l > 0 else ''

b2n = lambda b: h2n(b2h(b))
n2b = lambda n, l=0: h2b(n2h(n, l))

def addmod(a: int, b: int, m: int): return (a + b) % m
def mulmod(a: int, b: int, m: int): return (a * b) % m

## honk verifier

from dataclasses import dataclass
from enum import Enum

## Fr.sol

MODULUS = 21888242871839275222246405745257275088548364400416034343698204186575808495617 # Prime field order

@dataclass
class Fr:
    value: int
    def __add__(self, other): return Fr_add(self, other)
    def __sub__(self, other): return Fr_sub(self, other)
    def __mul__(self, other): return Fr_mul(self, other)
    def __pow__(self, other): return Fr_exp(self, other)
    def __ne__(self, other): return Fr_notEqual(self, other)
    def __eq__(self, other): return Fr_equal(self, other)

# Free functions
def Fr_add(a: Fr, b: Fr) -> Fr:
    return Fr(value=addmod(a.value, b.value, MODULUS))

def Fr_mul(a: Fr, b: Fr) -> Fr:
    return Fr(value=mulmod(a.value, b.value, MODULUS))

def Fr_sub(a: Fr, b: Fr) -> Fr:
    return Fr(value=addmod(a.value, MODULUS - b.value, MODULUS))

# TODO: double check this!
def Fr_exp(base: Fr, exponent: Fr) -> Fr:
    if exponent.value == 0: return Fr(value=1)
    # Implement exponent with a loop as we will overflow otherwise
    i = 1
    while i < exponent.value:
        base = base * base
        i += i
    return base

def Fr_notEqual(a: Fr, b: Fr) -> bool:
    return a.value != b.value

def Fr_equal(a: Fr, b: Fr) -> bool:
    return a.value == b.value

## HonkTypes.sol

# Temp only set here for testing, logn will be templated
LOG_N: int = 0x0000000000000000000000000000000000000000000000000000000000000010

NUMBER_OF_SUBRELATIONS: int = 18
BATCHED_RELATION_PARTIAL_LENGTH: int = 7
NUMBER_OF_ENTITIES: int = 43
NUMBER_OF_ALPHAS: int = 17

# Prime field order
Q: int = 21888242871839275222246405745257275088696311157297823662689037894645226208583 # EC group order
P = 21888242871839275222246405745257275088548364400416034343698204186575808495617 # Prime field order

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
class VerificationKey:
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
class Proof:
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
    sumcheckUnivariates: list[Fr]#[BATCHED_RELATION_PARTIAL_LENGTH][LOG_N]
    sumcheckEvaluations: list[Fr]#[NUMBER_OF_ENTITIES]
    # Zero morph
    zmCqs: list[G1ProofPoint]#[LOG_N]
    zmCq: G1ProofPoint
    zmPi: G1ProofPoint

def loadVerificationKey() -> VerificationKey:
    return VerificationKey(
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

def verify(proof: bytes, public_inputs: list[bytes]) -> bool:
    vk = loadVerificationKey()
    return True

# main tests

import json

def test(name: str) -> None:
    with open('./' + name + '.json', 'r') as f:
        record = json.load(f)
    proof = h2b(record['proof'])
    public_inputs = [h2b(public_input) for public_input in record['publicInputs']] 
    success = verify(proof, public_inputs)
    print(name, '=', success)

def main() -> None:
    test('testFuzzProof')
    test('testValidProof')

if __name__ == "__main__":
    main()
