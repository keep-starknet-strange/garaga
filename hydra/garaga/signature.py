"""
Various tools for bls signatures or other signature schemes.
"""

from __future__ import annotations

import hashlib
from typing import Protocol, TypeVar

from garaga.algebra import Polynomial, PyFelt, RationalFunction
from garaga.definitions import CURVES, CurveID, G1Point, get_base_field

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
            # print(f"dst len is < {MAX_DST_LENGTH}")
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
        # print(f"dst prime {dst_prime}")
        # print(f"block size {self.block_size}")
        z_pad = bytes([0] * self.block_size)
        # print(f"z pad {z_pad.hex()}")
        # print(f"len(z_pad) (bytes) {len(z_pad)}")
        assert n < (1 << 16), "Length should be smaller than 2^16"
        lib_str = n.to_bytes(2, "big")

        self.hasher.update(z_pad)
        self.hasher.update(msg)
        # Print separately lib_str+bytes([0])+dst_prime, in one bytes object
        lib_str_dst_prime = lib_str + bytes([0]) + dst_prime
        # print(
        #     f"lib_str_dst_prime {lib_str_dst_prime}, len : {len(lib_str_dst_prime)}\n {bytes_to_u32_array(lib_str_dst_prime, 'lib_str_dst_prime')}"
        # )
        self.hasher.update(lib_str_dst_prime)
        # self.hasher.update(bytes([0]))
        # self.hasher.update(dst_prime)
        b0 = self.hasher.digest()
        # print(f"b0 {b0.hex()}")
        hasher = hashlib.new(self.hash_name)
        hasher.update(b0)
        one_dst_prime = bytes([1]) + dst_prime
        hasher.update(one_dst_prime)
        bi = hasher.digest()

        uniform_bytes = bi

        for i in range(2, ell + 1):
            # print(f"loop: step {i}/{ell}")
            # print(f"zip {list(zip(b0, bi))}")

            b0_xor_bi = bytes(x ^ y for x, y in zip(b0, bi))
            # print(f"b0_xor_bi {b0_xor_bi.hex()}")
            # print(
            #     f"direct xor : {hex(int.from_bytes(b0, 'big') ^ int.from_bytes(bi, 'big'))}"
            # )
            hasher = hashlib.new(self.hash_name)
            hasher.update(b0_xor_bi)
            bytes_i_dst_prime = bytes([i]) + dst_prime
            # print(
            #     f"bytes_i_dst_prime {bytes_to_u32_array(bytes_i_dst_prime, f'bytes_{i}_dst_prime')}"
            # )
            hasher.update(bytes_i_dst_prime)
            bi = hasher.digest()
            uniform_bytes += bi

        # print(f"len(uniform_bytes) {len(uniform_bytes)}")
        # print(f"len(uniform_bytes[:n]) {len(uniform_bytes[:n])}")
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
) -> list[int]:
    field = get_base_field(curve_id)

    expander = ExpanderXmd(hash_name, dst=DST, curve_id=curve_id)

    len_per_elem = get_len_per_elem(field.p)
    len_in_bytes = count * len_per_elem
    # print(f"len per elem {len_per_elem}")
    # print(f"len in bytes: {len_in_bytes}")
    # print(f"message {message.hex()}")
    uniform_bytes = expander.expand_message_xmd(message, len_in_bytes)
    # print(f"uniform bytes {uniform_bytes.hex()}")
    output = []

    for i in range(0, len_in_bytes, len_per_elem):
        element = int.from_bytes(uniform_bytes[i : i + len_per_elem], "big")
        # print(f"element {element.bit_length()}")
        output.append(element)

    return [field(x) for x in output]


def hash_to_curve(
    message: bytes, curve_id: CurveID, hash_name: str = "sha256"
) -> G1Point:
    felt0, felt1 = hash_to_field(message, 2, curve_id, hash_name)

    pt0 = map_to_curve(felt0, curve_id)
    # print(f"pt0 {pt0}\n\n")
    pt1 = map_to_curve(felt1, curve_id)
    # print(f"pt1 {pt1}")
    assert pt0.iso_point == True, f"Point {pt0} is not an iso point"
    assert pt1.iso_point == True, f"Point {pt1} is not an iso point"

    if curve_id == CurveID.BLS12_381:
        x = CURVES[curve_id.value].x
        n = CURVES[curve_id.value].n
        cofactor = (1 - (x % n)) % n
    else:
        cofactor = CURVES[curve_id.value].h

    # print(f"cofactor {cofactor}")
    sum = pt0.add(pt1)
    assert sum.iso_point == True, f"Point {sum} is not an iso point"

    return apply_isogeny(sum).scalar_mul(cofactor)


def map_to_curve(field_element: PyFelt, curve_id: CurveID) -> G1Point:
    field = get_base_field(curve_id)
    a = field(CURVES[curve_id.value].swu_params.A)
    b = field(CURVES[curve_id.value].swu_params.B)
    z = field(CURVES[curve_id.value].swu_params.Z)

    u = field_element
    zeta_u2 = z * u**2
    ta = zeta_u2**2 + zeta_u2
    num_x1 = b * (ta + field.one())

    if ta.value == 0:
        div = a * z
    else:
        div = a * -ta

    num2_x1 = num_x1**2
    div2 = div**2
    div3 = div2 * div
    assert div3.value != 0

    num_gx1 = (num2_x1 + a * div2) * num_x1 + b * div3

    num_x2 = zeta_u2 * num_x1

    gx1 = num_gx1 / div3
    gx1_square = gx1.is_quad_residue()
    if gx1_square:
        y1 = gx1.sqrt(min_root=False)
        assert y1 * y1 == gx1
    else:
        y1 = (z * gx1).sqrt(min_root=False)
        assert y1 * y1 == z * gx1

    y2 = zeta_u2 * u * y1
    num_x = num_x1 if gx1_square else num_x2
    y = y1 if gx1_square else y2
    x_affine = num_x / div
    y_affine = -y if y.value % 2 != u.value % 2 else y

    point_on_curve = G1Point(x_affine.value, y_affine.value, curve_id, iso_point=True)
    return point_on_curve


# https://github.com/arkworks-rs/algebra/blob/master/curves/bls12_381/src/curves/g1_swu_iso.rs
def get_isogeny_to_g1_map(
    curve_id: CurveID,
) -> tuple[RationalFunction, RationalFunction]:
    field = get_base_field(curve_id)
    match curve_id.value:
        case CurveID.BLS12_381.value:
            return RationalFunction(
                numerator=Polynomial(
                    [
                        field(x)
                        for x in [
                            0x11A05F2B1E833340B809101DD99815856B303E88A2D7005FF2627B56CDB4E2C85610C2D5F2E62D6EAEAC1662734649B7,
                            0x17294ED3E943AB2F0588BAB22147A81C7C17E75B2F6A8417F565E33C70D1E86B4838F2A6F318C356E834EEF1B3CB83BB,
                            0xD54005DB97678EC1D1048C5D10A9A1BCE032473295983E56878E501EC68E25C958C3E3D2A09729FE0179F9DAC9EDCB0,
                            0x1778E7166FCC6DB74E0609D307E55412D7F5E4656A8DBF25F1B33289F1B330835336E25CE3107193C5B388641D9B6861,
                            0xE99726A3199F4436642B4B3E4118E5499DB995A1257FB3F086EEB65982FAC18985A286F301E77C451154CE9AC8895D9,
                            0x1630C3250D7313FF01D1201BF7A74AB5DB3CB17DD952799B9ED3AB9097E68F90A0870D2DCAE73D19CD13C1C66F652983,
                            0xD6ED6553FE44D296A3726C38AE652BFB11586264F0F8CE19008E218F9C86B2A8DA25128C1052ECADDD7F225A139ED84,
                            0x17B81E7701ABDBE2E8743884D1117E53356DE5AB275B4DB1A682C62EF0F2753339B7C8F8C8F475AF9CCB5618E3F0C88E,
                            0x80D3CF1F9A78FC47B90B33563BE990DC43B756CE79F5574A2C596C928C5D1DE4FA295F296B74E956D71986A8497E317,
                            0x169B1F8E1BCFA7C42E0C37515D138F22DD2ECB803A0C5C99676314BAF4BB1B7FA3190B2EDC0327797F241067BE390C9E,
                            0x10321DA079CE07E272D8EC09D2565B0DFA7DCCDDE6787F96D50AF36003B14866F69B771F8C285DECCA67DF3F1605FB7B,
                            0x6E08C248E260E70BD1E962381EDEE3D31D79D7E22C837BC23C0BF1BC24C6B68C24B1B80B64D391FA9C8BA2E8BA2D229,
                        ]
                    ]
                ),
                denominator=Polynomial(
                    [
                        field(x)
                        for x in [
                            0x8CA8D548CFF19AE18B2E62F4BD3FA6F01D5EF4BA35B48BA9C9588617FC8AC62B558D681BE343DF8993CF9FA40D21B1C,
                            0x12561A5DEB559C4348B4711298E536367041E8CA0CF0800C0126C2588C48BF5713DAA8846CB026E9E5C8276EC82B3BFF,
                            0xB2962FE57A3225E8137E629BFF2991F6F89416F5A718CD1FCA64E00B11ACEACD6A3D0967C94FEDCFCC239BA5CB83E19,
                            0x3425581A58AE2FEC83AAFEF7C40EB545B08243F16B1655154CCA8ABC28D6FD04976D5243EECF5C4130DE8938DC62CD8,
                            0x13A8E162022914A80A6F1D5F43E7A07DFFDFC759A12062BB8D6B44E833B306DA9BD29BA81F35781D539D395B3532A21E,
                            0xE7355F8E4E667B955390F7F0506C6E9395735E9CE9CAD4D0A43BCEF24B8982F7400D24BC4228F11C02DF9A29F6304A5,
                            0x772CAACF16936190F3E0C63E0596721570F5799AF53A1894E2E073062AEDE9CEA73B3538F0DE06CEC2574496EE84A3A,
                            0x14A7AC2A9D64A8B230B3F5B074CF01996E7F63C21BCA68A81996E1CDF9822C580FA5B9489D11E2D311F7D99BBDCC5A5E,
                            0xA10ECF6ADA54F825E920B3DAFC7A3CCE07F8D1D7161366B74100DA67F39883503826692ABBA43704776EC3A79A1D641,
                            0x95FC13AB9E92AD4476D6E3EB3A56680F682B4EE96F7D03776DF533978F31C1593174E4B4B7865002D6384D168ECDD0A,
                            0x1,
                        ]
                    ]
                ),
            ), RationalFunction(
                numerator=Polynomial(
                    [
                        field(x)
                        for x in [
                            1393399195776646641963150658816615410692049723305861307490980409834842911816308830479576739332720113414154429643571,
                            2968610969752762946134106091152102846225411740689724909058016729455736597929366401532929068084731548131227395540630,
                            122933100683284845219599644396874530871261396084070222155796123161881094323788483360414289333111221370374027338230,
                            303251954782077855462083823228569901064301365507057490567314302006681283228886645653148231378803311079384246777035,
                            1353972356724735644398279028378555627591260676383150667237975415318226973994509601413730187583692624416197017403099,
                            3443977503653895028417260979421240655844034880950251104724609885224259484262346958661845148165419691583810082940400,
                            718493410301850496156792713845282235942975872282052335612908458061560958159410402177452633054233549648465863759602,
                            1466864076415884313141727877156167508644960317046160398342634861648153052436926062434809922037623519108138661903145,
                            1536886493137106337339531461344158973554574987550750910027365237255347020572858445054025958480906372033954157667719,
                            2171468288973248519912068884667133903101171670397991979582205855298465414047741472281361964966463442016062407908400,
                            3915937073730221072189646057898966011292434045388986394373682715266664498392389619761133407846638689998746172899634,
                            3802409194827407598156407709510350851173404795262202653149767739163117554648574333789388883640862266596657730112910,
                            1707589313757812493102695021134258021969283151093981498394095062397393499601961942449581422761005023512037430861560,
                            349697005987545415860583335313370109325490073856352967581197273584891698473628451945217286148025358795756956811571,
                            885704436476567581377743161796735879083481447641210566405057346859953524538988296201011389016649354976986251207243,
                            3370924952219000111210625390420697640496067348723987858345031683392215988129398381698161406651860675722373763741188,
                        ]
                    ]
                ),
                denominator=Polynomial(
                    [
                        field(x)
                        for x in [
                            3396434800020507717552209507749485772788165484415495716688989613875369612529138640646200921379825018840894888371137,
                            3907278185868397906991868466757978732688957419873771881240086730384895060595583602347317992689443299391009456758845,
                            854914566454823955479427412036002165304466268547334760894270240966182605542146252771872707010378658178126128834546,
                            3496628876382137961119423566187258795236027183112131017519536056628828830323846696121917502443333849318934945158166,
                            1828256966233331991927609917644344011503610008134915752990581590799656305331275863706710232159635159092657073225757,
                            1362317127649143894542621413133849052553333099883364300946623208643344298804722863920546222860227051989127113848748,
                            3443845896188810583748698342858554856823966611538932245284665132724280883115455093457486044009395063504744802318172,
                            3484671274283470572728732863557945897902920439975203610275006103818288159899345245633896492713412187296754791689945,
                            3755735109429418587065437067067640634211015783636675372165599470771975919172394156249639331555277748466603540045130,
                            3459661102222301807083870307127272890283709299202626530836335779816726101522661683404130556379097384249447658110805,
                            742483168411032072323733249644347333168432665415341249073150659015707795549260947228694495111018381111866512337576,
                            1662231279858095762833829698537304807741442669992646287950513237989158777254081548205552083108208170765474149568658,
                            1668238650112823419388205992952852912407572045257706138925379268508860023191233729074751042562151098884528280913356,
                            369162719928976119195087327055926326601627748362769544198813069133429557026740823593067700396825489145575282378487,
                            2164195715141237148945939585099633032390257748382945597506236650132835917087090097395995817229686247227784224263055,
                            1,
                        ]
                    ]
                ),
            )

        case _:
            raise NotImplementedError(
                f"Isogeny for curve {curve_id} is not implemented"
            )


# https://github.com/arkworks-rs/algebra/blob/master/curves/bls12_381/src/curves/g2_swu_iso.rs
def get_isogeny_to_g2_map(
    curve_id: CurveID,
) -> tuple[RationalFunction, RationalFunction]:
    field = get_base_field(curve_id)
    match curve_id.value:
        case CurveID.BLS12_381.value:
            return RationalFunction(
                numerator=Polynomial(
                    [
                        field(x)
                        for x in [
                            889424345604814976315064405719089812568196182208668418962679585805340366775741747653930584250892369786198727235542,
                            889424345604814976315064405719089812568196182208668418962679585805340366775741747653930584250892369786198727235542,
                            0,
                            2668273036814444928945193217157269437704588546626005256888038757416021100327225242961791752752677109358596181706522,
                            2668273036814444928945193217157269437704588546626005256888038757416021100327225242961791752752677109358596181706526,
                            1334136518407222464472596608578634718852294273313002628444019378708010550163612621480895876376338554679298090853261,
                            3557697382419259905260257622876359250272784728834673675850718343221361467102966990615722337003569479144794908942033,
                            0,
                        ]
                    ]
                ),
                denominator=Polynomial(
                    [
                        field(x)
                        for x in [
                            0,
                            4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559715,
                            12,
                            4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559775,
                            1,
                            0,
                        ]
                    ]
                ),
            ), RationalFunction(
                numerator=Polynomial(
                    [
                        field(x)
                        for x in [
                            3261222600550988246488569487636662646083386001431784202863158481286248011511053074731078808919938689216061999863558,
                            3261222600550988246488569487636662646083386001431784202863158481286248011511053074731078808919938689216061999863558,
                            0,
                            889424345604814976315064405719089812568196182208668418962679585805340366775741747653930584250892369786198727235518,
                            2668273036814444928945193217157269437704588546626005256888038757416021100327225242961791752752677109358596181706524,
                            1334136518407222464472596608578634718852294273313002628444019378708010550163612621480895876376338554679298090853263,
                            2816510427748580758331037284777117739799287910327449993381818688383577828123182200904113516794492504322962636245776,
                            0,
                        ]
                    ]
                ),
                denominator=Polynomial(
                    [
                        field(x)
                        for x in [
                            4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559355,
                            4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559355,
                            0,
                            4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559571,
                            18,
                            4002409555221667393417789825735904156556882819939007885332058136124031650490837864442687629129015664037894272559769,
                            1,
                            0,
                        ]
                    ]
                ),
            )
        case _:
            raise NotImplementedError(
                f"Isogeny for curve {curve_id} is not implemented"
            )


def apply_isogeny(pt: G1Point) -> G1Point:
    assert pt.iso_point == True, f"Point {pt} is not an iso point"
    field = get_base_field(pt.curve_id)
    x_rational, y_rational = get_isogeny_to_g1_map(pt.curve_id)
    x_affine = x_rational.evaluate(field(pt.x))
    y_affine = y_rational.evaluate(field(pt.x)) * field(pt.y)

    return G1Point(x_affine.value, y_affine.value, pt.curve_id, iso_point=False)


if __name__ == "__main__":
    from garaga.hints.io import int_to_u384

    field = get_base_field(CurveID.BLS12_381)
    message = b"Hello, World!"
    sha_message = hashlib.sha256(message).digest()
    # print(f"sha_message {sha_message.hex()}")
    message = sha_message

    def test_hash_to_field(message: bytes):
        res = hash_to_field(
            message=message,
            count=2,
            curve_id=CurveID.BLS12_381,
            hash_name="sha256",
        )
        print(f"res {[int_to_u384(x) for x in res]}")
        expected = [
            2162792105491427725912070356725320455528056118179305300106498860235975843802512462082887053454085287130500476441750,
            40368511435268498384669958495624628965655407346873103876018487738713032717501957266398124814691972213333393099218,
        ]
        # assert res == expected, f"Expected {expected}, got {res}"

    def test_map_to_curve():
        u = field(42)
        res = map_to_curve(field_element=u, curve_id=CurveID.BLS12_381)
        print(f"res {int_to_u384(res.x)} {int_to_u384(res.y)}")

    def test_isogeny():
        pt = G1Point(
            x=215777581081472667122506794895079133292851844364726904952688478479828790890150439604857229658591641382171852677524,
            y=1379746801043875097750009912574703067223644203712602673826050484796337984730238282465201134827010880864260517139932,
            curve_id=CurveID.BLS12_381,
            iso_point=True,
        )
        expected = G1Point(
            x=2417697449117523569926871462160078790628278460141221111171958173864939056722835940739506331591809461977867457921129,
            y=2054645981348311902541581243120273427071170397909163934255295587636136055038499048700096920528935972380584458489355,
            curve_id=CurveID.BLS12_381,
            iso_point=False,
        )
        res = apply_isogeny(pt=pt)
        assert res == expected, f"Expected {expected}, got {res}"

    # test_isogeny()

    def test_hash_to_curve(message: bytes):
        expected = G1Point(
            x=1427986885250946460144481685485785737438296207533779678983559530346613679756132883977754715392336662418069603153756,
            y=2665645453955482249178808933038784408956625041285885055194161860684118145927032784752731507519078519455031562783679,
            curve_id=CurveID.BLS12_381,
        )
        res = hash_to_curve(
            message=message, curve_id=CurveID.BLS12_381, hash_name="sha256"
        )

        # assert res == expected, f"Expected {expected}, got {res}"
        print(f"res {int_to_u384(res.x)} {int_to_u384(res.y)}")

    # test_hash_to_field(message=message)

    test_map_to_curve()
    test_hash_to_curve(message=message)
