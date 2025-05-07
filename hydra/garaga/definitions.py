import functools
import random
from dataclasses import dataclass
from enum import Enum
from typing import TypeAlias

from fastecdsa import curvemath

from garaga import garaga_rs
from garaga.algebra import (
    BaseField,
    BaseFp2Field,
    Fp2,
    ModuloCircuitElement,
    Polynomial,
    PyFelt,
)
from garaga.hints.io import bigint_split, int_to_u256, int_to_u384

N_LIMBS = 4
BASE = 2**96
STARK = 0x800000000000011000000000000000000000000000000000000000000000001
BN254_ID = 0
BLS12_381_ID = 1
SECP256K1_ID = 2
SECP256R1_ID = 3
ED25519_ID = 4
GRUMPKIN_ID = 5


class ProofSystem(Enum):
    Groth16 = "groth16"
    Risc0Groth16 = "risc0_groth16"
    UltraKeccakHonk = "ultra_keccak_honk"
    UltraStarknetHonk = "ultra_starknet_honk"
    UltraKeccakZKHonk = "ultra_keccak_zk_honk"
    UltraStarknetZKHonk = "ultra_starknet_zk_honk"

    @property
    def supported_curves(self) -> set[int]:
        if self == ProofSystem.Groth16:
            return {BN254_ID, BLS12_381_ID}
        if self == ProofSystem.Risc0Groth16:
            return {BN254_ID}
        if self == ProofSystem.UltraKeccakHonk:
            return {BN254_ID}
        if self == ProofSystem.UltraStarknetHonk:
            return {BN254_ID}
        if self == ProofSystem.UltraKeccakZKHonk:
            return {BN254_ID}
        if self == ProofSystem.UltraStarknetZKHonk:
            return {BN254_ID}
        return set()


class CurveID(Enum):
    BN254 = 0
    BLS12_381 = 1
    SECP256K1 = 2
    SECP256R1 = 3
    ED25519 = 4
    GRUMPKIN = 5

    @staticmethod
    def from_str(s: str) -> "CurveID":
        return CurveID(CurveID.find_value_in_string(s))

    @property
    def p(self) -> int:
        return CURVES[self.value].p

    @staticmethod
    def find_value_in_string(s: str) -> int | None:
        """
        Find the value of the curve ID in the string.
        """
        if s.lower() == "bn128":
            return CurveID.BN254.value
        if s.lower() == "bls12381":
            return CurveID.BLS12_381.value
        for member in CurveID:
            if s.lower() in member.name.lower() or member.name.lower() in s.lower():
                return member.value
        return None

    @staticmethod
    def get_proving_system_curve(
        curve_id: int, proving_system: ProofSystem
    ) -> "CurveID":
        """
        Get the curve ID for proving systems. Only curves supported by the given proving system are valid.
        """
        if curve_id not in CurveID._value2member_map_:
            raise ValueError(
                f"Invalid curve ID: {curve_id}. Supported curves are: {', '.join([f'{c.name} (ID: {c.value})' for c in CurveID])}"
            )
        if curve_id not in proving_system.supported_curves:
            supported_curves = ", ".join(
                f"{CurveID(c).name} (ID: {c})" for c in proving_system.supported_curves
            )
            raise ValueError(
                f"Invalid curve ID for {proving_system.name}. Supported curves are: {supported_curves}"
            )
        return CurveID(curve_id)


@dataclass
class SWUParams:
    A: int
    B: int
    Z: int


@dataclass(slots=True, frozen=True)
class WeierstrassCurve:
    cairo_zero_namespace_name: str
    id: int
    p: int
    n: int  # order
    h: int  # cofactor
    a: int  # y^2 = x^3 + ax + b
    b: int
    fp_generator: int  # A generator of the field of the curve. To verify it, use is_generator function.
    Gx: int  # x-coordinate of the generator point
    Gy: int  # y-coordinate of the generator point
    swu_params: SWUParams
    eigen_value: int | None  # Endomorphism eigenvalue
    third_root_of_unity: int | None  # Endomorphism image

    def is_endomorphism_available(self) -> bool:
        return self.eigen_value is not None and self.third_root_of_unity is not None

    def to_cairo_zero(self) -> str:
        code = f"namespace {self.cairo_zero_namespace_name} {{\n"
        code += f"const CURVE_ID = {self.id};\n"
        p = bigint_split(self.p, N_LIMBS, BASE)
        n = bigint_split(self.n, N_LIMBS, BASE)
        a = bigint_split(self.a, N_LIMBS, BASE)
        b = bigint_split(self.b, N_LIMBS, BASE)
        g = bigint_split(self.fp_generator, N_LIMBS, BASE)
        min_one = bigint_split(-1 % self.p, N_LIMBS, BASE)
        for i, limb in enumerate(p):
            code += f"const P{i} = {hex(limb)};\n"
        for i, limb in enumerate(n):
            code += f"const N{i} = {hex(limb)};\n"
        for i, limb in enumerate(a):
            code += f"const A{i} = {hex(limb)};\n"
        for i, limb in enumerate(b):
            code += f"const B{i} = {hex(limb)};\n"
        for i, limb in enumerate(g):
            code += f"const G{i} = {hex(limb)};\n"
        for i, limb in enumerate(min_one):
            code += f"const MIN_ONE_D{i} = {hex(limb)};\n"
        code += "}\n"
        return code

    def to_cairo_one(self) -> str:
        code = f"const {self.cairo_zero_namespace_name.upper()}:Curve = \n"
        code += "Curve {\n"
        code += f"p:{int_to_u384(self.p)},\n"
        code += f"n:{int_to_u256(self.n)},\n"
        code += f"a:{int_to_u384(self.a)},\n"
        code += f"b:{int_to_u384(self.b)},\n"
        code += f"g:{int_to_u384(self.fp_generator)},\n"
        code += f"min_one:{int_to_u384(-1%self.p)},\n"
        code += f"G: {G1Point(self.Gx, self.Gy, CurveID(self.id)).to_cairo_1()},\n"
        code += "};\n"
        return code


@dataclass(slots=True, frozen=True)
class TwistedEdwardsCurve(WeierstrassCurve):
    """
    Twisted Edwards curve is a curve of the form ax^2 + y^2 = 1 + dx^2y^2.
    Equivalent to a Weierstrass curve of the form y^2 = x^3 + ax + b.
    Automatic conversion of parameters is done in the constructor.
    """

    a_twisted: int  # Twisted Edwards curve parameter
    d_twisted: int  # Twisted Edwards curve parameter

    def __init__(
        self,
        cairo_zero_namespace_name: str,
        id: int,
        p: int,
        n: int,
        h: int,
        d_twisted: int,
        a_twisted: int,
        fp_generator: int,
        Gx: int,
        Gy: int,
        swu_params: SWUParams,
        eigen_value: int | None = None,
        third_root_of_unity: int | None = None,
    ):
        assert a_twisted != 0 and d_twisted != 0 and a_twisted != d_twisted
        # Set attributes
        object.__setattr__(self, "d_twisted", d_twisted)
        object.__setattr__(self, "a_twisted", a_twisted)
        object.__setattr__(self, "p", p)
        object.__setattr__(self, "swu_params", swu_params)
        object.__setattr__(self, "eigen_value", eigen_value)
        object.__setattr__(self, "third_root_of_unity", third_root_of_unity)
        # Calculate Weierstrass parameters
        a = (
            -1
            * pow(48, -1, p)
            * (a_twisted**2 + 14 * a_twisted * d_twisted + d_twisted**2)
            % p
        )
        b = (
            pow(864, -1, p)
            * (a_twisted + d_twisted)
            * (-(a_twisted**2) + 34 * a_twisted * d_twisted - d_twisted**2)
            % p
        )

        WeierstrassCurve.__init__(
            self,
            cairo_zero_namespace_name,
            id,
            p,
            n,
            h,
            a,
            b,
            fp_generator,
            *(self.to_weierstrass(Gx, Gy)),
            swu_params,
            eigen_value,
            third_root_of_unity,
        )

    def to_weierstrass(self, x_twisted, y_twisted):
        a = self.a_twisted
        d = self.d_twisted
        return (
            (5 * a + a * y_twisted - 5 * d * y_twisted - d)
            * pow(12 - 12 * y_twisted, -1, self.p)
            % self.p,
            (a + a * y_twisted - d * y_twisted - d)
            * pow(4 * x_twisted - 4 * x_twisted * y_twisted, -1, self.p)
            % self.p,
        )

    def to_twistededwards(self, x_weirstrass: int, y_weirstrass: int):
        a = self.a_twisted
        d = self.d_twisted
        y = (
            (5 * a - 12 * x_weirstrass - d)
            * pow(-12 * x_weirstrass - a + 5 * d, -1, self.p)
            % self.p
        )
        x = (
            (a + a * y - d * y - d)
            * pow(4 * y_weirstrass - 4 * y_weirstrass * y, -1, self.p)
            % self.p
        )
        return (x, y)


@dataclass(slots=True, frozen=True)
class PairingCurve(WeierstrassCurve):
    x: int  # curve x parameter
    irreducible_polys: dict[int, list[int]]
    nr_a0: int  # E2 non residue
    nr_a1: int
    b20: int
    b21: int  # E2: b is (b20, b21)
    loop_counter: list[int]
    line_function_sparsity: list[
        int
    ]  # 0: ==0, 1: !=0, 2: ==1.. L(x) = Σ(sparsity[i] * coeff[i] * x^i )
    final_exp_cofactor: int
    G2x: tuple[int, int]
    G2y: tuple[int, int]


def NAF(x):
    if x == 0:
        return []
    z = 0 if x % 2 == 0 else 2 - (x % 4)
    return NAF((x - z) // 2) + [z]


def jy00(value: int) -> list[int]:
    """
    This is a minimum-Hamming-Weight left-to-right recoding.
    It outputs signed {-1, 0, 1} bits from MSB to LSB
    with minimal Hamming Weight to minimize operations
    in Miller Loops and vartime scalar multiplications

    - Optimal Left-to-Right Binary Signed-Digit Recoding
      Joye, Yen, 2000
      https://marcjoye.github.io/papers/JY00sd2r.pdf
    """

    def bit(value, index):
        return (value >> index) & 1

    bi, bi1, ri, ri1, ri2 = 0, 0, 0, 0, 0
    bits = value.bit_length()
    recoded = []

    for i in range(bits, -1, -1):
        if i == bits:
            ri1, ri2 = bit(value, bits - 1), bit(value, bits - 2)
        else:
            bi, ri = bi1, ri1
            ri1, ri2 = ri2, bit(value, i - 2) if i >= 2 else 0

        bi1 = (bi + ri1 + ri2) >> 1
        recoded.append(-2 * bi + ri + bi1)

    return recoded


GARAGA_RS_SUPPORTED_CURVES = {BN254_ID, BLS12_381_ID}

Curve: TypeAlias = WeierstrassCurve

CURVES: dict[int, WeierstrassCurve] = {
    BN254_ID: PairingCurve(
        cairo_zero_namespace_name="bn",
        id=BN254_ID,
        p=0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47,
        n=0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001,
        x=0x44E992B44A6909F1,
        h=1,
        irreducible_polys={
            6: [82, 0, 0, -18, 0, 0, 1],
            12: [82, 0, 0, 0, 0, 0, -18, 0, 0, 0, 0, 0, 1],
        },
        nr_a0=9,
        nr_a1=1,
        a=0,
        b=3,
        b20=0x2B149D40CEB8AAAE81BE18991BE06AC3B5B4C5E559DBEFA33267E6DC24A138E5,
        b21=0x9713B03AF0FED4CD2CAFADEED8FDF4A74FA084E52D1852E4A2BD0685C315D2,
        loop_counter=jy00(6 * 0x44E992B44A6909F1 + 2)[::-1],
        line_function_sparsity=[
            2,
            1,
            0,
            1,
            0,
            0,
            0,
            1,
            0,
            1,
            0,
            0,
        ],
        final_exp_cofactor=1469306990098747947464455738335385361638823152381947992820,  # cofactor = 2 * x0 * (6 * x0**2 + 3 * x0 + 1)
        fp_generator=3,
        Gx=0x1,
        Gy=0x2,
        G2x=(
            0x1800DEEF121F1E76426A00665E5C4479674322D4F75EDADD46DEBD5CD992F6ED,
            0x198E9393920D483A7260BFB731FB5D25F1AA493335A9E71297E485B7AEF312C2,
        ),
        G2y=(
            0x12C85EA5DB8C6DEB4AAB71808DCB408FE3D1E7690C43D37B4CE6CC0166FA7DAA,
            0x90689D0585FF075EC9E99AD690C3395BC4B313370B38EF355ACDADCD122975B,
        ),
        swu_params=None,
        eigen_value=0xB3C4D79D41A917585BFC41088D8DAAA78B17EA66B99C90DD,
        third_root_of_unity=0x59E26BCEA0D48BACD4F263F1ACDB5C4F5763473177FFFFFE,
    ),
    BLS12_381_ID: PairingCurve(
        cairo_zero_namespace_name="bls",
        id=BLS12_381_ID,
        p=0x1A0111EA397FE69A4B1BA7B6434BACD764774B84F38512BF6730D2A0F6B0F6241EABFFFEB153FFFFB9FEFFFFFFFFAAAB,
        n=0x73EDA753299D7D483339D80809A1D80553BDA402FFFE5BFEFFFFFFFF00000001,
        x=-0xD201000000010000,
        h=0x396C8C005555E1568C00AAAB0000AAAB,
        irreducible_polys={
            6: [2, 0, 0, -2, 0, 0, 1],
            12: [2, 0, 0, 0, 0, 0, -2, 0, 0, 0, 0, 0, 1],
        },
        nr_a0=1,
        nr_a1=1,
        a=0,
        b=4,
        b20=4,
        b21=4,
        loop_counter=[int(x) for x in bin(0xD201000000010000)[2:][::-1]],
        line_function_sparsity=[
            1,
            0,
            1,
            2,
            0,
            0,
            1,
            0,
            1,
            0,
            0,
            0,
        ],
        final_exp_cofactor=3,
        fp_generator=3,
        Gx=0x17F1D3A73197D7942695638C4FA9AC0FC3688C4F9774B905A14E3A3F171BAC586C55E83FF97A1AEFFB3AF00ADB22C6BB,
        Gy=0x08B3F481E3AAA0F1A09E30ED741D8AE4FCF5E095D5D00AF600DB18CB2C04B3EDD03CC744A2888AE40CAA232946C5E7E1,
        G2x=(
            0x24AA2B2F08F0A91260805272DC51051C6E47AD4FA403B02B4510B647AE3D1770BAC0326A805BBEFD48056C8C121BDB8,
            0x13E02B6052719F607DACD3A088274F65596BD0D09920B61AB5DA61BBDC7F5049334CF11213945D57E5AC7D055D042B7E,
        ),
        G2y=(
            0xCE5D527727D6E118CC9CDC6DA2E351AADFD9BAA8CBDD3A76D429A695160D12C923AC9CC3BACA289E193548608B82801,
            0x606C4A02EA734CC32ACD2B02BC28B99CB3E287E85A763AF267492AB572E99AB3F370D275CEC1DA1AAA9075FF05F79BE,
        ),
        swu_params=SWUParams(
            A=0x144698A3B8E9433D693A02C96D4982B0EA985383EE66A8D8E8981AEFD881AC98936F8DA0E0F97F5CF428082D584C1D,
            B=0x12E2908D11688030018B12E8753EEE3B2016C1F0F24F4070A0B9C14FCEF35EF55A23215A316CEAA5D1CC48E98E172BE0,
            Z=11,
        ),
        eigen_value=0xAC45A4010001A40200000000FFFFFFFF,
        third_root_of_unity=0x1A0111EA397FE699EC02408663D4DE85AA0D857D89759AD4897D29650FB85F9B409427EB4F49FFFD8BFD00000000AAAC,
    ),
    SECP256K1_ID: WeierstrassCurve(
        cairo_zero_namespace_name="secp256k1",
        id=SECP256K1_ID,
        p=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEFFFFFC2F,
        n=0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141,
        h=1,
        a=0,
        b=7,
        fp_generator=3,
        Gx=0x79BE667EF9DCBBAC55A06295CE870B07029BFCDB2DCE28D959F2815B16F81798,
        Gy=0x483ADA7726A3C4655DA4FBFC0E1108A8FD17B448A68554199C47D08FFB10D4B8,
        swu_params=None,
        eigen_value=0x5363AD4CC05C30E0A5261C028812645A122E22EA20816678DF02967C1B23BD72,
        third_root_of_unity=0x7AE96A2B657C07106E64479EAC3434E99CF0497512F58995C1396C28719501EE,
    ),
    SECP256R1_ID: WeierstrassCurve(
        cairo_zero_namespace_name="secp256r1",
        id=SECP256R1_ID,
        p=0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFF,
        n=0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551,
        h=1,
        a=0xFFFFFFFF00000001000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFC,
        b=0x5AC635D8AA3A93E7B3EBBD55769886BC651D06B0CC53B0F63BCE3C3E27D2604B,
        fp_generator=6,
        Gx=0x6B17D1F2E12C4247F8BCE6E563A440F277037D812DEB33A0F4A13945D898C296,
        Gy=0x4FE342E2FE1A7F9B8EE7EB4A7C0F9E162BCE33576B315ECECBB6406837BF51F5,
        swu_params=None,
        eigen_value=None,
        third_root_of_unity=None,
    ),
    ED25519_ID: TwistedEdwardsCurve(
        cairo_zero_namespace_name="ED25519",  # See https://neuromancer.sk/std/other/Ed25519
        id=ED25519_ID,
        p=0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFED,
        n=0x1000000000000000000000000000000014DEF9DEA2F79CD65812631A5CF5D3ED,
        h=8,
        d_twisted=0x52036CEE2B6FFE738CC740797779E89800700A4D4141D8AB75EB4DCA135978A3,
        a_twisted=0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEC,
        fp_generator=6,
        Gx=0x216936D3CD6E53FEC0A4E231FDD6DC5C692CC7609525A7B2C9562D608F25D51A,
        Gy=0x6666666666666666666666666666666666666666666666666666666666666658,
        swu_params=None,
        eigen_value=None,
        third_root_of_unity=None,
    ),
    GRUMPKIN_ID: WeierstrassCurve(
        cairo_zero_namespace_name="grumpkin",
        id=GRUMPKIN_ID,
        p=0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001,
        n=0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47,
        h=1,
        a=0,
        b=-17 % 0x30644E72E131A029B85045B68181585D2833E84879B9709143E1F593F0000001,
        fp_generator=5,
        Gx=0x1,
        Gy=0x2CF135E7506A45D632D270D45F1181294833FC48D823F272C,
        swu_params=None,
        eigen_value=None,
        third_root_of_unity=None,
    ),
}


def is_generator(g: int, p: int) -> bool:
    """
    Checks if a given integer g is a generator of the multiplicative group of integers modulo p.

    Parameters:
    g (int): The integer to check.
    p (int): The prime number defining the finite field Fp.

    Returns:
    bool: True if g is a generator, False otherwise.

    Raises:
    ValueError: If p is not a prime number.

    Detailed Explanation:
    1. The order of an element g in the multiplicative group Fp* must divide p-1.
       - The multiplicative group Fp* consists of all non-zero elements of the finite field Fp.
       - The group has p-1 elements because there are p-1 non-zero elements in Fp.
       - By Lagrange's theorem, the order of any element in a finite group must divide the order of the group.
       - Therefore, the order of any element g in Fp* must divide p-1.
    2. If g is a generator, its order must be exactly p-1.
    3. To verify that g has order p-1, we need to ensure that g does not have any smaller order that divides p-1.
    4. The prime factorization of p-1 gives us all the possible divisors of p-1.
    5. By checking g^((p-1)/q) for each prime factor q of p-1, we ensure that g does not have an order that is a proper divisor of p-1.
    6. If g passes all these checks, it must have the full order p-1, making it a generator.
    7. This method is efficient because it reduces the problem to checking a few exponentiations rather than testing all possible orders.

    Example:
    - Let p = 7, then p-1 = 6.
    - The prime factors of 6 are 2 and 3.
    - To check if g is a generator, we test:
      - g^(6/2) = g^3
      - g^(6/3) = g^2
    - If neither g^3 ≡ 1 (mod 7) nor g^2 ≡ 1 (mod 7), then g is a generator.
    - This ensures that g has the full order 6, covering all elements of F7*.
    """
    import sympy

    # Ensure that p is a prime number
    if not sympy.isprime(p):
        raise ValueError("p must be a prime number.")

    # Calculate p - 1, which is the order of the multiplicative group of integers modulo p
    p_minus_1 = p - 1

    # Factorize p - 1 to get its prime factors and their exponents
    # This is necessary because we will use these factors to test if g is a generator
    factors = sympy.factorint(p_minus_1)

    # Check if g is a generator
    for q in factors.keys():
        # For each prime factor q of p - 1, check if g^((p-1)/q) ≡ 1 (mod p)
        # If g^((p-1)/q) ≡ 1 (mod p), then g is not a generator because it does not have the full order p-1
        # This is based on the fact that if g is a generator, its order must be exactly p-1
        # If g^((p-1)/q) ≡ 1 (mod p), it means the order of g divides (p-1)/q, which is less than p-1
        if pow(g, p_minus_1 // q, p) == 1:
            return False

    # If g^((p-1)/q) ≠ 1 (mod p) for all prime factors q, then g is a generator
    # This means g has the full order p-1 and can generate all elements of the multiplicative group
    return True


def get_base_field(
    curve_id: int | CurveID, field_type: type[PyFelt] | type[Fp2] = PyFelt
) -> BaseField | BaseFp2Field:
    """
    Returns the base field for a given elliptic curve.

    Parameters:
    curve_id (int | CurveID): The ID of the elliptic curve.
    field_type (PyFelt | Fp2): The type of the field (default is PyFelt).

    Returns:
    BaseField | BaseFp2Field: The base field corresponding to the curve and field type.

    Raises:
    ValueError: If the field_type is invalid.
    """
    if isinstance(curve_id, CurveID):
        curve_id = curve_id.value

    curve = CURVES[curve_id]
    if field_type == PyFelt:
        return BaseField(curve.p)
    elif field_type == Fp2:
        assert isinstance(curve, PairingCurve)
        return BaseFp2Field(curve.p)
    else:
        raise ValueError(f"Invalid field type: {field_type}. Expected PyFelt or Fp2.")


def get_irreducible_poly(curve_id: int | CurveID, extension_degree: int) -> Polynomial:
    if isinstance(curve_id, CurveID):
        curve_id = curve_id.value
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    field = get_base_field(curve_id)
    return Polynomial(
        coefficients=[field(x) for x in curve.irreducible_polys[extension_degree]]
    )


@dataclass(slots=True)
class G1Point:
    """
    Represents a point on G1, the group of rational points on an elliptic curve over the base field.

    Attributes:
        x (int): The x-coordinate of the point.
        y (int): The y-coordinate of the point.
        curve_id (CurveID): The identifier of the elliptic curve.
    """

    x: int
    y: int
    curve_id: CurveID
    iso_point: bool = False

    def __repr__(self) -> str:
        return f"G1Point({hex(self.x)}, {hex(self.y)}) on {self.curve_id.value}"

    def __str__(self) -> str:
        return f"G1Point({self.x}, {self.y}) on curve {self.curve_id}"

    def __hash__(self):
        return hash((self.x, self.y, self.curve_id, self.iso_point))

    def __eq__(self, other: object) -> bool:
        """
        Checks if two G1Point instances are equal.

        Args:
            other (G1Point): The other point to compare.

        Returns:
            bool: True if the points are equal, False otherwise.
        """
        if not isinstance(other, G1Point):
            raise ValueError(f"Cannot compare G1Point with {type(other)}")
        return (
            self.x == other.x
            and self.y == other.y
            and self.curve_id.value == other.curve_id.value
            and self.iso_point == other.iso_point
        )

    def __post_init__(self):
        """
        Post-initialization checks to ensure the point is valid.
        """
        if self.is_infinity():
            return
        if not self.is_on_curve():
            raise ValueError(f"Point {self} is not on the curve {self.curve_id}")

    @staticmethod
    def infinity(curve_id: CurveID) -> "G1Point":
        """
        Returns the point at infinity for the given curve.

        Args:
            curve_id (CurveID): The identifier of the elliptic curve.

        Returns:
            G1Point: The point at infinity.
        """
        return G1Point(0, 0, curve_id)

    def is_infinity(self) -> bool:
        """
        Checks if the point is the point at infinity.

        Returns:
            bool: True if the point is at infinity, False otherwise.
        """
        return self.x == 0 and self.y == 0

    def to_cairo_1(self, as_hex: bool = True) -> str:
        """
        Converts the point to a Cairo 1 representation.

        Returns:
            str: The Cairo 1 representation of the point.
        """
        return f"G1Point{{x: {int_to_u384(self.x, as_hex)}, y: {int_to_u384(self.y, as_hex)}}}"

    @staticmethod
    def gen_random_point_not_in_subgroup(
        curve_id: CurveID, force_gen: bool = False
    ) -> "G1Point":
        """
        Generates a random point not in the prime order subgroup.

        Args:
            curve_id (CurveID): The identifier of the elliptic curve.
            force_gen (bool): Force generation even if the cofactor is 1.

        Returns:
            G1Point: A random point not in the prime order subgroup.

        Raises:
            ValueError: If the cofactor is 1 and force_gen is False.
        """
        curve_idx = curve_id.value
        if CURVES[curve_idx].h == 1:
            if force_gen:
                return G1Point.gen_random_point(curve_id)
            else:
                raise ValueError(
                    "Cofactor is 1, cannot generate a point not in the subgroup"
                )
        else:
            field: BaseField = get_base_field(curve_idx)
            while True:
                x = field.random()
                y2 = x**3 + CURVES[curve_idx].a * x + CURVES[curve_idx].b
                try:
                    tentative_point = G1Point(x.value, y2.sqrt().value, curve_id)
                except ValueError:
                    continue
                if not tentative_point.is_in_prime_order_subgroup():
                    return tentative_point

    def is_in_prime_order_subgroup(self) -> bool:
        """
        Checks if the point is in the prime order subgroup.

        Returns:
            bool: True if the point is in the prime order subgroup, False otherwise.
        """
        return self.scalar_mul(CURVES[self.curve_id.value].n).is_infinity()

    def is_on_curve(self) -> bool:
        """
        Checks if the point is on the curve using the curve equation y^2 = x^3 + ax + b.

        Returns:
            bool: True if the point is on the curve, False otherwise.
        """
        if self.iso_point:
            a = CURVES[self.curve_id.value].swu_params.A
            b = CURVES[self.curve_id.value].swu_params.B
        else:
            a = CURVES[self.curve_id.value].a
            b = CURVES[self.curve_id.value].b

        p = CURVES[self.curve_id.value].p
        lhs = self.y**2 % p
        rhs = (self.x**3 + a * self.x + b) % p
        return lhs == rhs

    @staticmethod
    def gen_random_point(curve_id: CurveID) -> "G1Point":
        """
        Generates a random point on a given curve.

        Args:
            curve_id (CurveID): The identifier of the elliptic curve.

        Returns:
            G1Point: A random point on the curve.
        """
        scalar = random.randint(1, CURVES[curve_id.value].n - 1)

        return G1Point.get_nG(curve_id, scalar)

    @staticmethod
    def get_nG(curve_id: CurveID, n: int) -> "G1Point":
        """
        Returns the scalar multiplication of the generator point on a given curve by the scalar n.

        Args:
            curve_id (CurveID): The identifier of the elliptic curve.
            n (int): The scalar to multiply by.

        Returns:
            G1Point: The resulting point after scalar multiplication.

        Raises:
            AssertionError: If n is not less than the order of the curve.
        """
        assert (
            n < CURVES[curve_id.value].n
        ), "n must be less than the order of the curve"

        gen = G1Point(CURVES[curve_id.value].Gx, CURVES[curve_id.value].Gy, curve_id)
        return gen.scalar_mul(n)

    @staticmethod
    def msm(points: list["G1Point"], scalars: list[int]) -> "G1Point":
        """
        Performs multi-scalar multiplication (MSM) on a list of points and scalars.

        Args:
            points (list[G1Point]): The list of points.
            scalars (list[int]): The list of scalars.

        Returns:
            G1Point: The resulting point after MSM.
        """
        assert len(points) == len(
            scalars
        ), f"Points and scalar length mismatch: {len(points)} points and {len(scalars)} scalars"
        muls = [P.scalar_mul(s) for P, s in zip(points, scalars)]
        scalar_mul = functools.reduce(lambda acc, p: acc.add(p), muls)
        return scalar_mul

    def scalar_mul(self, scalar: int) -> "G1Point":
        """
        Performs scalar multiplication on the point.

        Args:
            scalar (int): The scalar to multiply by. abs(scalar) should be less than the order of the curve.

        Returns:
            G1Point: The resulting point after scalar multiplication.
        """
        if self.is_infinity():
            return self
        if scalar == 0:
            return G1Point(0, 0, self.curve_id, self.iso_point)
        if self.iso_point:
            a = CURVES[self.curve_id.value].swu_params.A
            b = CURVES[self.curve_id.value].swu_params.B
        else:
            a = CURVES[self.curve_id.value].a
            b = CURVES[self.curve_id.value].b
        # Fastecdsa C binding.
        x, y = curvemath.mul(
            str(self.x),
            str(self.y),
            str(abs(scalar)),
            str(CURVES[self.curve_id.value].p),
            str(a),
            str(b),
            str(CURVES[self.curve_id.value].n),
            str(CURVES[self.curve_id.value].Gx),
            str(CURVES[self.curve_id.value].Gy),
        )
        # Fastecdsa already returns (0, 0) for the identity element.
        if scalar < 0:
            return -G1Point(int(x), int(y), self.curve_id, self.iso_point)
        else:
            return G1Point(int(x), int(y), self.curve_id, self.iso_point)

    def add(self, other: "G1Point") -> "G1Point":
        """
        Adds two points on the elliptic curve.

        Args:
            other (G1Point): The other point to add.

        Returns:
            G1Point: The resulting point after addition.

        Raises:
            ValueError: If the points are not on the same curve.
        """
        if self.is_infinity():
            return other
        if other.is_infinity():
            return self
        if self.curve_id != other.curve_id:
            raise ValueError("Points are not on the same curve")
        if self.iso_point != other.iso_point:
            raise ValueError("Points are not on the same curve")
        if self.iso_point:
            a = CURVES[self.curve_id.value].swu_params.A
            b = CURVES[self.curve_id.value].swu_params.B
        else:
            a = CURVES[self.curve_id.value].a
            b = CURVES[self.curve_id.value].b

        x, y = curvemath.add(
            str(self.x),
            str(self.y),
            str(other.x),
            str(other.y),
            str(CURVES[self.curve_id.value].p),
            str(a),
            str(b),
            str(CURVES[self.curve_id.value].n),
            str(CURVES[self.curve_id.value].Gx),
            str(CURVES[self.curve_id.value].Gy),
        )
        # NB : Fastecdsa returns (0, 0) for the identity element.
        return G1Point(int(x), int(y), self.curve_id, self.iso_point)

    def __neg__(self) -> "G1Point":
        """
        Negates the point on the elliptic curve.

        Returns:
            G1Point: The negated point.
        """
        return G1Point(
            self.x,
            -self.y % CURVES[self.curve_id.value].p,
            self.curve_id,
            self.iso_point,
        )

    def to_pyfelt_list(self) -> list[PyFelt]:
        field = get_base_field(self.curve_id.value)
        return [field(self.x), field(self.y)]

    def serialize_to_cairo(self, name: str, raw: bool = False) -> str:
        import garaga.modulo_circuit_structs as structs

        return structs.G1PointCircuit(name=name, elmts=self.to_pyfelt_list()).serialize(
            raw
        )


@dataclass(frozen=True)
class G2Point:
    """
    Represents a point on G2, the group of rational points on an elliptic curve over an extension field.
    """

    x: tuple[int, int]
    y: tuple[int, int]
    curve_id: CurveID

    def __repr__(self):
        return f"G2Point({hex(self.x[0])}, {hex(self.x[1])}, {hex(self.y[0])}, {hex(self.y[1])}, {self.curve_id})"

    def __post_init__(self):
        assert isinstance(CURVES[self.curve_id.value], PairingCurve)
        if self.is_infinity():
            return
        if not self.is_on_curve():
            raise ValueError(f"G2 Point is not on the curve {self.curve_id}")

    @staticmethod
    def infinity(curve_id: CurveID) -> "G2Point":
        return G2Point((0, 0), (0, 0), curve_id)

    def __eq__(self, other: "G2Point") -> bool:
        return (
            self.x[0] == other.x[0]
            and self.x[1] == other.x[1]
            and self.y[0] == other.y[0]
            and self.y[1] == other.y[1]
            and self.curve_id == other.curve_id
        )

    def is_infinity(self) -> bool:
        return self.x == (0, 0) and self.y == (0, 0)

    def is_on_curve(self) -> bool:
        """
        Check if the point is on the curve using the curve equation y^2 = x^3 + ax + b in the extension field.
        """
        from garaga.hints.tower_backup import E2

        curve = CURVES[self.curve_id.value]
        assert isinstance(curve, PairingCurve)
        a = curve.a
        p = curve.p
        b = E2(curve.b20, curve.b21, p)
        y = E2(*self.y, p)
        x = E2(*self.x, p)
        return y**2 == x**3 + a * x + b

    @staticmethod
    def gen_random_point(curve_id: CurveID) -> "G2Point":
        """
        Generates a random point on a given curve.
        """
        curve = CURVES[curve_id.value]
        assert isinstance(curve, PairingCurve)
        scalar = random.randint(1, curve.n - 1)
        a = (curve.G2x[0], curve.G2x[1], curve.G2y[0], curve.G2y[1])
        b = garaga_rs.g2_scalar_mul(curve_id.value, a, scalar)
        return G2Point((b[0], b[1]), (b[2], b[3]), curve_id)

    @staticmethod
    def get_nG(curve_id: CurveID, n: int) -> "G2Point":
        """
        Returns the scalar multiplication of the generator point on a given curve by the scalar n.
        """
        assert (
            n < CURVES[curve_id.value].n
        ), "n must be less than the order of the curve"

        if curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            curve = CURVES[curve_id.value]
            a = (curve.G2x[0], curve.G2x[1], curve.G2y[0], curve.G2y[1])
            b = garaga_rs.g2_scalar_mul(curve_id.value, a, n)
            return G2Point((b[0], b[1]), (b[2], b[3]), curve_id)
        else:
            raise NotImplementedError(
                "G2Point.get_nG is not implemented for this curve"
            )

    def scalar_mul(self, scalar: int) -> "G2Point":
        if self.is_infinity():
            return self
        if scalar == 0:
            return G2Point((0, 0), (0, 0), self.curve_id)
        if scalar < 0:
            return -self.scalar_mul(-scalar)
        if self.curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            a = (self.x[0], self.x[1], self.y[0], self.y[1])
            b = garaga_rs.g2_scalar_mul(self.curve_id.value, a, scalar)
            return G2Point((b[0], b[1]), (b[2], b[3]), self.curve_id)
        else:
            raise NotImplementedError(
                "G2Point.scalar_mul is not implemented for this curve"
            )

    def add(self, other: "G2Point") -> "G2Point":
        if self.is_infinity():
            return other
        if other.is_infinity():
            return self
        if self.curve_id != other.curve_id:
            raise ValueError("Points are not on the same curve")
        if self.curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            a = (self.x[0], self.x[1], self.y[0], self.y[1])
            b = (other.x[0], other.x[1], other.y[0], other.y[1])
            c = garaga_rs.g2_add(self.curve_id.value, a, b)
            return G2Point((c[0], c[1]), (c[2], c[3]), self.curve_id)
        else:
            raise NotImplementedError("G2Point.add is not implemented for this curve")

    def __neg__(self) -> "G2Point":
        p = CURVES[self.curve_id.value].p
        return G2Point(
            (self.x[0], self.x[1]), (-self.y[0] % p, -self.y[1] % p), self.curve_id
        )

    @staticmethod
    def msm(points: list["G2Point"], scalars: list[int]) -> "G2Point":
        assert all(isinstance(p, G2Point) for p in points)
        assert len(points) == len(scalars)
        muls = [P.scalar_mul(s) for P, s in zip(points, scalars)]
        scalar_mul = functools.reduce(lambda acc, p: acc.add(p), muls)
        return scalar_mul

    def to_pyfelt_list(self) -> list[PyFelt]:
        field = get_base_field(self.curve_id.value)
        return [field(x) for x in self.x + self.y]

    def serialize_to_cairo(self, name: str, raw: bool = False) -> str:
        import garaga.modulo_circuit_structs as structs

        return structs.G2PointCircuit(name=name, elmts=self.to_pyfelt_list()).serialize(
            raw
        )


@dataclass(slots=True)
class G1G2Pair:
    p: G1Point
    q: G2Point
    curve_id: CurveID = None

    def __hash__(self):
        return hash((self.p, self.q, self.curve_id))

    def __post_init__(self):
        if self.p.curve_id != self.q.curve_id:
            raise ValueError("Points are not on the same curve")
        self.curve_id = self.p.curve_id

    def to_pyfelt_list(self) -> list[PyFelt]:
        field = get_base_field(self.curve_id.value)
        return [
            field(x)
            for x in [
                self.p.x,
                self.p.y,
                self.q.x[0],
                self.q.x[1],
                self.q.y[0],
                self.q.y[1],
            ]
        ]

    @staticmethod
    def pair(pairs: list["G1G2Pair"], curve_id: CurveID = None) -> "E12":
        from garaga.hints.tower_backup import E12  # avoids cycle

        if curve_id is None:
            if len(pairs) == 0:
                raise ValueError("Unspecified curve")
            curve_id = pairs[0].curve_id
        if curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            args = []
            for pair in pairs:
                if pair.curve_id != curve_id:
                    raise ValueError("Pairs are not on the same curve")
                args.append(pair.p.x)
                args.append(pair.p.y)
                args.append(pair.q.x[0])
                args.append(pair.q.x[1])
                args.append(pair.q.y[0])
                args.append(pair.q.y[1])
            res = garaga_rs.multi_pairing(curve_id.value, args)
            return E12(res, curve_id.value)
        else:
            raise NotImplementedError("G1G2Pair.pair is not implemented for this curve")

    @staticmethod
    def miller(pairs: list["G1G2Pair"], curve_id: CurveID = None):
        from garaga.hints.tower_backup import E12  # avoids cycle

        if curve_id is None:
            if len(pairs) == 0:
                raise ValueError("Unspecified curve")
            curve_id = pairs[0].curve_id
        if curve_id.value in GARAGA_RS_SUPPORTED_CURVES:
            args = []
            for pair in pairs:
                if pair.curve_id != curve_id:
                    raise ValueError("Pairs are not on the same curve")
                args.append(pair.p.x)
                args.append(pair.p.y)
                args.append(pair.q.x[0])
                args.append(pair.q.x[1])
                args.append(pair.q.y[0])
                args.append(pair.q.y[1])
            res = garaga_rs.multi_miller_loop(curve_id.value, args)
            return E12(res, curve_id.value)
        else:
            raise NotImplementedError(
                "G1G2Pair.miller is not implemented for this curve"
            )


# v^6 - 18v^3 + 82
# w^12 - 18w^6 + 82
# v^6 - 2v^3 + 2
# w^12 - 2w^6 + 2


def get_sparsity(X: list[PyFelt | ModuloCircuitElement]) -> list[int]:
    """
    Determines the sparsity of polynomial coefficients.

    This function evaluates a list of polynomial coefficients (`X`) and categorizes each based on its value:
    - 2: The coefficient is 1, indicating a direct representation of a polynomial power.
    - 1: The coefficient is non-zero but not 1, indicating a contributing non-zero coefficient.
    - 0: The coefficient is 0, indicating no contribution to the polynomial.

    Parameters:
    - X (list[PyFelt | ModuloCircuitElement]): Coefficients to evaluate.

    Returns:
    - list[int]: Sparsity categories for each coefficient in `X`.
    """
    return [2 if x.value == 1 else 1 if x.value != 0 else 0 for x in X]


def tower_to_direct(
    X: list[PyFelt], curve_id: int, extension_degree: int
) -> list[PyFelt]:
    """
    Convert Tower to Direct extension field representation:
    T(u,v) = t0+t1u + (t2+t3u)v + (t4+t5u)v^2
    D(v) = d0+d1v+d2v^2+d3v^3+d4v^4+d5v^5

    Only tested with BN254 and BLS12_381 6th and 12th towers defined in this file.
    They were computed by hand then abstracted away with no guarantee of genericity under different tower constructions.
    """
    assert len(X) == extension_degree and isinstance(
        X[0], PyFelt
    ), f"len(X)={len(X)}, type(X[0])={type(X[0])}"
    if extension_degree == 2:
        return X
    if extension_degree == 6:
        return TD6(X, curve_id)
    elif extension_degree == 12:
        return TD12(X, curve_id)
    else:
        raise ValueError(f"Unsupported extension degree {extension_degree}")


def direct_to_tower(
    X: list[PyFelt | ModuloCircuitElement], curve_id: int, extension_degree: int
) -> list[PyFelt]:
    """
    Convert Direct to Tower extension field representation:
    Input : D(v) = d0+d1v+d2v^2+d3v^3+d4v^4+d5v^5
    Output: T(u,v) = t0+t1u + (t2+t3u)v + (t4+t5u)v^2

    Only tested with BN254 and BLS12_381 6th and 12th towers defined in this file.
    They were computed by hand then abstracted away with no guarantee of genericity under different tower constructions.
    """
    assert len(X) == extension_degree and isinstance(
        X[0], (PyFelt, ModuloCircuitElement)
    ), f"{type(X[0])}, len(X)={len(X)}"
    X = [x.felt for x in X]
    if extension_degree == 2:
        return X
    if extension_degree == 6:
        return DT6(X, curve_id)
    elif extension_degree == 12:
        return DT12(X, curve_id)
    else:
        raise ValueError(f"Unsupported extension degree {extension_degree}")


def TD6(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] - nr_a0 * X[1],
        X[2] - nr_a0 * X[3],
        X[4] - nr_a0 * X[5],
        X[1],
        X[3],
        X[5],
    ]


def DT6(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] + nr_a0 * X[3],
        X[3],
        X[1] + nr_a0 * X[4],
        X[4],
        X[2] + nr_a0 * X[5],
        X[5],
    ]


def TD12(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] - nr_a0 * X[1],
        X[6] - nr_a0 * X[7],
        X[2] - nr_a0 * X[3],
        X[8] - nr_a0 * X[9],
        X[4] - nr_a0 * X[5],
        X[10] - nr_a0 * X[11],
        X[1],
        X[7],
        X[3],
        X[9],
        X[5],
        X[11],
    ]


def DT12(X: list[PyFelt], curve_id: int) -> list[PyFelt]:
    X += (12 - len(X)) * [0]
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    nr_a0 = curve.nr_a0
    return [
        X[0] + nr_a0 * X[6],
        X[6],
        X[2] + nr_a0 * X[8],
        X[8],
        X[4] + nr_a0 * X[10],
        X[10],
        X[1] + nr_a0 * X[7],
        X[7],
        X[3] + nr_a0 * X[9],
        X[9],
        X[5] + nr_a0 * X[11],
        X[11],
    ]


def precompute_lineline_sparsity(curve_id: int):
    curve = CURVES[curve_id]
    assert isinstance(curve, PairingCurve)
    field = get_base_field(curve_id)
    line_sparsity = curve.line_function_sparsity
    line = Polynomial([field(x) for x in line_sparsity])
    ll = line * line % get_irreducible_poly(curve_id, 12)
    ll_sparsity = get_sparsity(ll.coefficients)
    return ll_sparsity[0:12]


def replace_consecutive_zeros(lst):
    result = []
    i = 0
    while i < len(lst):
        if i < len(lst) - 1 and lst[i] == 0 and lst[i + 1] == 0:
            result.append(3)  # Replace consecutive zeros with 3
            i += 2
        elif lst[i] == -1:
            result.append(2)  # Replace -1 with 2
            i += 1
        else:
            result.append(lst[i])
            i += 1
    return result


def recode_naf_bits(lst):
    result = []
    i = 0
    while i < len(lst):
        if i < len(lst) - 1 and lst[i] == 0 and (lst[i + 1] == 1 or lst[i + 1] == -1):
            # "01" or "0-1"
            if lst[i + 1] == 1:
                result.append(3)  # Replace "01" with 3
            else:
                result.append(4)  # Replace "0-1" with 4
            i += 2
        elif i < len(lst) - 1 and (lst[i] == 1 or lst[i] == -1) and lst[i + 1] == 0:
            # "10" or "-10"
            if lst[i] == 1:
                result.append(1)  # Replace 10 with 6
            else:
                result.append(2)  # Replace -10 with 7
            i += 2
        elif i < len(lst) - 1 and lst[i] == 0 and lst[i + 1] == 0:
            result.append(0)  # Replace consecutive zeros with 0
            i += 2
        else:
            raise ValueError(f"Unexpected bit sequence at index {i}")
    return result


if __name__ == "__main__":
    r = recode_naf_bits(jy00(6 * 0x44E992B44A6909F1 + 2)[2:])
    print(r, len(r))
    from garaga.hints.io import int_to_u384

    # bls = [int(x) for x in bin(0xD201000000010000)[2:]][2:]
    # recode_naf_bits(bls)

    def print_nbits_and_nG_glv_fake_glv():
        for curve_id in CURVES:
            curve: WeierstrassCurve = CURVES[curve_id]
            if curve.is_endomorphism_available():
                nbits = curve.n.bit_length() // 4 + 9
                print(
                    f"Curve {curve_id}: {nbits}, {G1Point.get_nG(CurveID(curve_id), 2 ** (nbits - 1)).to_cairo_1()}"
                )

    print_nbits_and_nG_glv_fake_glv()

    def print_min_one_order():
        for curve_id in CURVES:
            curve: WeierstrassCurve = CURVES[curve_id]
            print(f"Curve {curve_id}: min_one_order: {int_to_u384(-1 % curve.n)}")

    print_min_one_order()

    print()

    def print_third_root_of_unity():
        for curve_id in CURVES:
            curve: WeierstrassCurve = CURVES[curve_id]
            if curve.is_endomorphism_available():
                print(
                    f"Curve {curve_id}: third_root_of_unity: {int_to_u384(curve.third_root_of_unity)}"
                )

    print_third_root_of_unity()
