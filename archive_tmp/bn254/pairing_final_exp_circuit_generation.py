from algebra import Polynomial
from algebra import FieldElement, BaseField
from tools.extension_trick import (
    gnark_to_v,
    flatten,
    neg_e6,
    v_to_gnark,
    pack_e6,
    flatten,
    div_e6,
    mul_e6,
    mul_e2,
    inv_e12,
    mul_e12,
    pack_e12,
)
from src.extension_field_modulo_circuit import (
    ExtensionFieldModuloCircuit,
    ModuloElement,
    EuclideanPolyAccumulator,
)
from src.hints.extf_mul import nondeterministic_extension_field_mul_divmod
from definitions import BN254_ID
from hints.io import bigint_split
from poseidon_transcript import CairoPoseidonTranscript
from dataclasses import dataclass

p = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47
BASE = 2**96
DEGREE = 3
N_LIMBS = 4
STARK = 3618502788666131213697322783095070105623107215331596699973092056135872020481
field = BaseField(p)


def to_fp6(x: list) -> Polynomial:
    return Polynomial([FieldElement(xi, field) for xi in x])


def mul_torus(
    y1: list, y2: list, continuable_hash: int, y1_bigint3=None, y2_bigint3=None
):
    num_min_v, continuable_hash = mul_trick_e6(
        y1, y2, continuable_hash, x_bigint3=y1_bigint3, y_bigint3=y2_bigint3
    )
    num_min_v[1] = num_min_v[1] + 1

    num = num_min_v
    den = [y1i + y2i for y1i, y2i in zip(y1, y2)]
    if y1_bigint3 is None:
        y1_bigint3 = [split(x) for x in y1]
    if y2_bigint3 is None:
        y2_bigint3 = [split(x) for x in y2]

    den_bigint3 = [
        (y1i[0] + y2i[0], y1i[1] + y2i[1], y1i[2] + y2i[2])
        for y1i, y2i in zip(y1_bigint3, y2_bigint3)
    ]
    res, continuable_hash = div_trick_e6(
        num, den, continuable_hash, y_bigint3=den_bigint3
    )
    return res, continuable_hash


def div_trick_e6(
    x: list[ModuloElement],
    y: list[ModuloElement],
    continuable_hash: int,
) -> (list, int):
    x_gnark, y_gnark = pack_e6(v_to_gnark(x)), pack_e6(v_to_gnark(y))
    div = flatten(div_e6(x_gnark, y_gnark))
    div = gnark_to_v(div)
    check, h = mul_trick_e6(
        y,
        div,
        continuable_hash,
    )
    assert x == check, f"{x} != {check}"
    return div, h


def expt_torus(x: list, continuable_hash: int) -> (list, int):
    t3, continuable_hash = square_torus(x, continuable_hash)
    t5, continuable_hash = square_torus(t3, continuable_hash)
    result, continuable_hash = square_torus(t5, continuable_hash)
    t0, continuable_hash = square_torus(result, continuable_hash)
    t2, continuable_hash = mul_torus(x, t0, continuable_hash)
    t0, continuable_hash = mul_torus(t3, t2, continuable_hash)
    t1, continuable_hash = mul_torus(x, t0, continuable_hash)
    t4, continuable_hash = mul_torus(result, t2, continuable_hash)
    t6, continuable_hash = square_torus(t2, continuable_hash)
    t1, continuable_hash = mul_torus(t0, t1, continuable_hash)
    t0, continuable_hash = mul_torus(t3, t1, continuable_hash)
    t6, continuable_hash = n_square_torus(t6, 6, continuable_hash)
    t5, continuable_hash = mul_torus(t5, t6, continuable_hash)
    t5, continuable_hash = mul_torus(t4, t5, continuable_hash)
    t5, continuable_hash = n_square_torus(t5, 7, continuable_hash)
    t4, continuable_hash = mul_torus(t4, t5, continuable_hash)
    t4, continuable_hash = n_square_torus(t4, 8, continuable_hash)
    t4, continuable_hash = mul_torus(t0, t4, continuable_hash)
    t3, continuable_hash = mul_torus(t3, t4, continuable_hash)
    t3, continuable_hash = n_square_torus(t3, 6, continuable_hash)
    t2, continuable_hash = mul_torus(t2, t3, continuable_hash)
    t2, continuable_hash = n_square_torus(t2, 8, continuable_hash)
    t2, continuable_hash = mul_torus(t0, t2, continuable_hash)
    t2, continuable_hash = n_square_torus(t2, 6, continuable_hash)
    t2, continuable_hash = mul_torus(t0, t2, continuable_hash)
    t2, continuable_hash = n_square_torus(t2, 10, continuable_hash)
    t1, continuable_hash = mul_torus(t1, t2, continuable_hash)
    t1, continuable_hash = n_square_torus(t1, 6, continuable_hash)
    t0, continuable_hash = mul_torus(t0, t1, continuable_hash)
    z, continuable_hash = mul_torus(result, t0, continuable_hash)
    return z, continuable_hash


def n_square_torus(x: list, n: int, continuable_hash: int):
    if n == 0:
        return x, continuable_hash
    else:
        x, continuable_hash = square_torus(x, continuable_hash)
        return n_square_torus(x, n - 1, continuable_hash)


def square_torus(x: list[ModuloElement], circuit: ExtensionFieldModuloCircuit):
    # x_gnark = pack_e6(v_to_gnark(x))
    # sq = [int(x) for x in gnark_to_v(flatten(square_torus_e6(x_gnark)))]
    v_tmp = [(2 * sq_i - x_i) % p for sq_i, x_i in zip(sq, x)]

    x_poly = to_fp6(v_tmp)
    y_poly = to_fp6(x)
    z_poly = x_poly * y_poly

    z_polyq = z_poly // irreducible_poly
    z_polyr = z_poly % irreducible_poly
    z_polyq_coeffs = z_polyq.get_coeffs()
    # print(f"z_polyq_coeffs={z_polyq_coeffs}")
    z_polyr_coeffs = z_polyr.get_coeffs()
    # print(f"z_polyr_coeffs={z_polyr_coeffs}")

    return sq, h


def frobenius_square_torus(x: list):
    x_fr2 = [
        x[0] * 2203960485148121921418603742825762020974279258880205651967 % p,
        x[1]
        * 21888242871839275220042445260109153167277707414472061641714758635765020556617
        % p,
        x[2]
        * 21888242871839275222246405745257275088696311157297823662689037894645226208582
        % p,
        x[3] * 2203960485148121921418603742825762020974279258880205651967 % p,
        x[4]
        * 21888242871839275220042445260109153167277707414472061641714758635765020556617
        % p,
        x[5]
        * 21888242871839275222246405745257275088696311157297823662689037894645226208582
        % p,
    ]
    return x_fr2


def frobenius_torus(x: list):
    x_gnark = pack_e6(v_to_gnark(x))
    t0 = (x_gnark[0][0], -x_gnark[0][1] % p)
    t1 = (x_gnark[1][0], -x_gnark[1][1] % p)
    t2 = (x_gnark[2][0], -x_gnark[2][1] % p)
    t1 = mul_e2(
        t1,
        (
            21575463638280843010398324269430826099269044274347216827212613867836435027261,
            10307601595873709700152284273816112264069230130616436755625194854815875713954,
        ),  # (1,9)^(2*(p-1)/6)
    )
    t2 = mul_e2(
        t2,
        (
            2581911344467009335267311115468803099551665605076196740867805258568234346338,
            19937756971775647987995932169929341994314640652964949448313374472400716661030,
        ),  # (1,9)^(4*(p-1)/6)
    )
    v0 = (
        18566938241244942414004596690298913868373833782006617400804628704885040364344,
        5722266937896532885780051958958348231143373700109372999374820235121374419868,
    )  # 1 / v^((p-1)/2)
    res = flatten(mul_e6((t0, t1, t2), (v0, (0, 0), (0, 0))))
    res_bigint3 = gnark_to_v_bigint3([split(x) for x in res])

    res = gnark_to_v(res)
    return res, res_bigint3


def frobenius_cube_torus(x: list):
    x_gnark = pack_e6(v_to_gnark(x))
    t0 = (x_gnark[0][0], -x_gnark[0][1] % p)
    t1 = (x_gnark[1][0], -x_gnark[1][1] % p)
    t2 = (x_gnark[2][0], -x_gnark[2][1] % p)
    t1 = mul_e2(
        t1,
        (
            3772000881919853776433695186713858239009073593817195771773381919316419345261,
            2236595495967245188281701248203181795121068902605861227855261137820944008926,
        ),  # (1,9)^(2*(p^3-1)/6)
    )
    t2 = mul_e2(
        t2,
        (
            5324479202449903542726783395506214481928257762400643279780343368557297135718,
            16208900380737693084919495127334387981393726419856888799917914180988844123039,
        ),  # (1,9)^(4*(p^3-1)/6)
    )
    v0 = (
        10190819375481120917420622822672549775783927716138318623895010788866272024264,
        303847389135065887422783454877609941456349188919719272345083954437860409601,
    )  # 1 / v^((p^3-1)/2)
    res = flatten(mul_e6((t0, t1, t2), (v0, (0, 0), (0, 0))))
    res_bigint3 = gnark_to_v_bigint3([split(x) for x in res])
    res = gnark_to_v(res)
    return res, res_bigint3


def inverse_torus(x: list):
    return [-xi % p for xi in x]


def decompress_torus(x: ((int, int), (int, int), (int, int))):
    num = (x, ((1, 0), (0, 0), (0, 0)))
    den = (x, ((-1 % p, 0), (0, 0), (0, 0)))
    res = pack_e12(inv_e12(den[0], den[1]))
    res = mul_e12(num, res)
    return res


def final_exponentiation(
    z: (((int, int), (int, int), (int, int)), ((int, int), (int, int), (int, int))),
    unsafe: bool,
    continuable_hash: int = int.from_bytes(b"GaragaBN254FinalExp", "big"),
):
    circuit = ExtensionFieldModuloCircuit("BN254_final_exp", BN254_ID, 6, field)

    MIN_9 = circuit.write_element(field(-9 % p))
    MIN_ONE = circuit.write_element(field(-1 % p))

    Z_fake = FieldElement(42)
    Z_fake = circuit.write_element(Z_fake)

    c_num = circuit.write_elements(
        [FieldElement(z[0][i][j], field) for i in range(3) for j in range(2)]
    )
    if unsafe:
        z_c1 = circuit.write_elements(
            [FieldElement(z[1][i][j], field) for i in range(3) for j in range(2)]
        )
    else:
        if z[1] == ((0, 0), (0, 0), (0, 0)):
            selector1 = 1
            z_c1 = circuit.write_elements(
                [
                    field.one(),
                    field.zero(),
                    field.zero(),
                    field.zero(),
                    field.zero(),
                    field.zero(),
                ]
            )
        else:
            selector1 = 0
            z_c1 = circuit.write_elements(
                [FieldElement(z[1][i][j], field) for i in range(3) for j in range(2)]
            )

    c_num_full = [
        circuit.mul(MIN_ONE, circuit.add(c_num[0], circuit.mul(MIN_9, c_num[1]))),
        circuit.mul(MIN_ONE, circuit.add(c_num[2], circuit.mul(MIN_9, c_num[3]))),
        circuit.mul(MIN_ONE, circuit.add(c_num[4], circuit.mul(MIN_9, c_num[5]))),
        circuit.mul(MIN_ONE, c_num[1]),
        circuit.mul(MIN_ONE, c_num[3]),
        circuit.mul(MIN_ONE, c_num[5]),
    ]
    z_c1_full = [
        circuit.add(z_c1[0], circuit.mul(MIN_9, z_c1[1])),
        circuit.add(z_c1[2], circuit.mul(MIN_9, z_c1[3])),
        circuit.add(z_c1[4], circuit.mul(MIN_9, z_c1[5])),
        z_c1[1],
        z_c1[3],
        z_c1[5],
    ]

    return circuit, continuable_hash


if __name__ == "__main__":
    x = [
        15631577932152315104652445523700417040601500707877284609546312920354446056447,
        1274881022144191920838043222130710344172476924365725732436425248566978625605,
        14374765490310691286872600100687989211994071432725749506715026469291207213364,
        19232683452852686150799946178434694116955802884971349389480427332156028484678,
        4711060662209480322403082802390043737109415216436721343938907246739585294619,
        12628528420035269572171509623830053865991813551619118245630623189571187704212,
        6132046658265970172317265843030970288646178101127187503319861429480398294166,
        696877141756131447795834834192003128716698847022516178077777960435426094082,
        19968037526512504126402565293093453753511856148614571257107664150629413134903,
        19711115225256248898674588007895864056457997172157519591556283079102178159639,
        4264731731400846354398198898948247059528185839861404225131520284631392266215,
        3153660797904284033741194851243498835351306539671786555576214661552094399141,
    ]
    z = [
        17264119758069723980713015158403419364912226240334615592005620718956030922389,
        1300711225518851207585954685848229181392358478699795190245709208408267917898,
        8894217292938489450175280157304813535227569267786222825147475294561798790624,
        1829859855596098509359522796979920150769875799037311140071969971193843357227,
        4968700049505451466697923764727215585075098085662966862137174841375779106779,
        12814315002058128940449527172080950701976819591738376253772993495204862218736,
        4233474252585134102088637248223601499779641130562251948384759786370563844606,
        9420544134055737381096389798327244442442230840902787283326002357297404128074,
        13457906610892676317612909831857663099224588803620954529514857102808143524905,
        5122435115068592725432309312491733755581898052459744089947319066829791570839,
        8891987925005301465158626530377582234132838601606565363865129986128301774627,
        440796048150724096437130979851431985500142692666486515369083499585648077975,
    ]
    x = pack_e12(x)
    c, continuable_hash = final_exponentiation(x, True)
    # print(f"f = {f}")
    # print(f"z = {z}")
    # print(f"hash={continuable_hash}")
    # assert pack_e12(z) == f
