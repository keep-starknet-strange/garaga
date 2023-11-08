from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
from tools.py.extension_trick import (
    gnark_to_v,
    gnark_to_v_bigint3,
    flatten,
    neg_e6,
    v_to_gnark,
    pack_e6,
    flatten,
    div_e6,
    exp_e6,
    mul_e6,
    mul_e2,
    inv_e12,
    mul_e12,
    pack_e12,
)
from src.bn254.hints import square_torus_e6, split, split_128
from starkware.cairo.common.poseidon_hash import poseidon_hash


p = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47
STARK = 3618502788666131213697322783095070105623107215331596699973092056135872020481
field = BaseField(p)


coeffs = [
    BaseFieldElement(82, field),
    field.zero(),
    field.zero(),
    BaseFieldElement(-18 % p, field),
    field.zero(),
    field.zero(),
    field.one(),
]
unreducible_poly = Polynomial(coeffs)


def to_fp6(x: list) -> Polynomial:
    return Polynomial([BaseFieldElement(xi, field) for xi in x])


def mul_torus(
    y1: list, y2: list, continuable_hash: int, y1_bigint3=None, y2_bigint3=None
):
    num_min_v, continuable_hash = mul_trick_e6(
        y1, y2, continuable_hash, x_bigint3=y1_bigint3, y_bigint3=y2_bigint3
    )
    num_min_v[1] = num_min_v[1] + 1
    v1_bigint3 = split(num_min_v[1] - 1)
    v1_bigint3 = (v1_bigint3[0] + 1, v1_bigint3[1], v1_bigint3[2])

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
    x: list, y: list, continuable_hash: int, x_bigint3=None, y_bigint3=None
) -> (list, int):
    x_gnark, y_gnark = pack_e6(v_to_gnark(x)), pack_e6(v_to_gnark(y))
    div = flatten(div_e6(x_gnark, y_gnark))
    div = gnark_to_v(div)
    check, h = mul_trick_e6(
        y, div, continuable_hash, x_bigint3=y_bigint3, y_bigint3=None
    )
    assert x == check, f"{x} != {check}"
    return div, h


def mul_trick_e6(
    x: list, y: list, continuable_hash: int, x_bigint3=None, y_bigint3=None
) -> (list, int):
    x_poly, y_poly = to_fp6(x), to_fp6(y)
    z_poly = x_poly * y_poly
    z_polyq = z_poly // unreducible_poly
    z_polyr = z_poly % unreducible_poly
    z_polyq_coeffs = z_polyq.get_coeffs()
    z_polyr_coeffs = z_polyr.get_coeffs()
    z_polyq_coeffs = z_polyq_coeffs + [0] * (5 - len(z_polyq_coeffs))
    z_polyr_coeffs = z_polyr_coeffs + [0] * (6 - len(z_polyr_coeffs))
    if x_bigint3 is None:
        x3 = [split(e) for e in x]
    else:
        x3 = x_bigint3
    if y_bigint3 is None:
        y3 = [split(e) for e in y]
    else:
        y3 = y_bigint3
    # print("multrick x", x3)
    # print("multrick y", y3)
    q2 = [split_128(e) for e in z_polyq_coeffs]
    r3 = [split(e) for e in z_polyr_coeffs]
    h = poseidon_hash(x3[0][0] * x3[0][1], continuable_hash)
    h = poseidon_hash(x3[0][2] * x3[1][0], h)
    h = poseidon_hash(x3[1][1] * x3[1][2], h)
    h = poseidon_hash(x3[2][0] * x3[2][1], h)
    h = poseidon_hash(x3[2][2] * x3[3][0], h)
    h = poseidon_hash(x3[3][1] * x3[3][2], h)
    h = poseidon_hash(x3[4][0] * x3[4][1], h)
    h = poseidon_hash(x3[4][2] * x3[5][0], h)
    h = poseidon_hash(x3[5][1] * x3[5][2], h)
    # print(f"ch={h}")
    h = poseidon_hash(y3[0][0] * y3[0][1], h)
    h = poseidon_hash(y3[0][2] * y3[1][0], h)
    h = poseidon_hash(y3[1][1] * y3[1][2], h)
    h = poseidon_hash(y3[2][0] * y3[2][1], h)
    h = poseidon_hash(y3[2][2] * y3[3][0], h)
    h = poseidon_hash(y3[3][1] * y3[3][2], h)
    h = poseidon_hash(y3[4][0] * y3[4][1], h)
    h = poseidon_hash(y3[4][2] * y3[5][0], h)
    h = poseidon_hash(y3[5][1] * y3[5][2], h)
    # print(f"ch={h}")
    # print(f"lq2={len(q2)}")

    h = poseidon_hash(q2[0][0] * r3[0][0], h)
    h = poseidon_hash(q2[0][1] * r3[0][1], h)
    h = poseidon_hash(q2[1][0] * r3[0][2], h)
    h = poseidon_hash(q2[1][1] * r3[1][0], h)
    h = poseidon_hash(q2[2][0] * r3[1][1], h)
    h = poseidon_hash(q2[2][1] * r3[1][2], h)
    h = poseidon_hash(q2[3][0] * r3[2][0], h)
    h = poseidon_hash(q2[3][1] * r3[2][1], h)
    h = poseidon_hash(q2[4][0] * r3[2][2], h)
    h = poseidon_hash(q2[4][1] * r3[3][0], h)

    h = poseidon_hash(r3[3][1] * r3[3][2], h)
    h = poseidon_hash(r3[4][0] * r3[4][1], h)
    h = poseidon_hash(r3[4][2] * r3[5][0], h)
    h = poseidon_hash(r3[5][1] * r3[5][2], h)
    # print(f"ch={h}")

    return z_polyr_coeffs, h


def expt_torus(x: list, continuable_hash: int) -> (list, int):
    t3, continuable_hash = square_torus(x, continuable_hash)
    # print(f"hashsquaretorus={continuable_hash}")

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


def square_torus(x: list, continuable_hash: int):
    x_gnark = v_to_gnark(x)
    sq = [int(x) for x in gnark_to_v(flatten(square_torus_e6(x_gnark)))]
    v_tmp = [(2 * sq_i - x_i) % p for sq_i, x_i in zip(sq, x)]
    x_bigint3 = [split(e) for e in x]
    sq_bigint3 = [split(e) for e in sq]
    v_tmp_bigint3 = [
        [
            (2 * sq_i[0] - x_i[0]) % STARK,
            (2 * sq_i[1] - x_i[1]) % STARK,
            (2 * sq_i[2] - x_i[2]) % STARK,
        ]
        for sq_i, x_i in zip(sq_bigint3, x_bigint3)
    ]
    x_poly = to_fp6(v_tmp)
    y_poly = to_fp6(x)
    z_poly = x_poly * y_poly

    z_polyq = z_poly // unreducible_poly
    z_polyr = z_poly % unreducible_poly
    z_polyq_coeffs = z_polyq.get_coeffs()
    # print(f"z_polyq_coeffs={z_polyq_coeffs}")
    z_polyr_coeffs = z_polyr.get_coeffs()
    # print(f"z_polyr_coeffs={z_polyr_coeffs}")
    x3 = v_tmp_bigint3
    y3 = x_bigint3
    q2 = [split_128(e) for e in z_polyq_coeffs]
    # print(f"square_torus_x={x3}")
    # print(f"square_torus_y={y3}")
    # print(f"square_torus_q2={q2}")
    h = poseidon_hash(x3[0][0] * x3[0][1], continuable_hash)
    h = poseidon_hash(x3[0][2] * x3[1][0], h)
    h = poseidon_hash(x3[1][1] * x3[1][2], h)
    h = poseidon_hash(x3[2][0] * x3[2][1], h)
    h = poseidon_hash(x3[2][2] * x3[3][0], h)
    h = poseidon_hash(x3[3][1] * x3[3][2], h)
    h = poseidon_hash(x3[4][0] * x3[4][1], h)
    h = poseidon_hash(x3[4][2] * x3[5][0], h)
    h = poseidon_hash(x3[5][1] * x3[5][2], h)
    # print(f"ch={h}")
    h = poseidon_hash(y3[0][0] * q2[0][0], h)
    h = poseidon_hash(y3[0][1] * q2[0][1], h)
    h = poseidon_hash(y3[0][2] * q2[1][0], h)
    h = poseidon_hash(y3[1][0] * q2[1][1], h)
    h = poseidon_hash(y3[1][1] * q2[2][0], h)
    h = poseidon_hash(y3[1][2] * q2[2][1], h)
    h = poseidon_hash(y3[2][0] * q2[3][0], h)
    h = poseidon_hash(y3[2][1] * q2[3][1], h)
    h = poseidon_hash(y3[2][2] * q2[4][0], h)
    h = poseidon_hash(y3[3][0] * q2[4][1], h)
    h = poseidon_hash(y3[3][1] * y3[3][2], h)
    h = poseidon_hash(y3[4][0] * y3[4][1], h)
    h = poseidon_hash(y3[4][2] * y3[5][0], h)
    h = poseidon_hash(y3[5][1] * y3[5][2], h)
    # print(f"ch={h}")

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
    if unsafe:
        z_c1 = z[1]
    else:
        if z[1] == ((0, 0), (0, 0), (0, 0)):
            selector1 = 1
            z_c1 = ((1, 0), (0, 0), (0, 0))
        else:
            selector1 = 0
            z_c1 = z[1]

    c_num_full = gnark_to_v(flatten(neg_e6(z[0])))
    z_c1_full = gnark_to_v(flatten(z_c1))

    c, continuable_hash = div_trick_e6(c_num_full, z_c1_full, continuable_hash)
    # print(f"hash={continuable_hash}")
    t0 = frobenius_square_torus(c)
    c, continuable_hash = mul_torus(t0, c, continuable_hash)
    # print(f"hash={continuable_hash}")

    t0, continuable_hash = expt_torus(c, continuable_hash)
    # print(f"hashexpt={continuable_hash}")
    t0 = inverse_torus(t0)
    t0, continuable_hash = square_torus(t0, continuable_hash)
    t1, continuable_hash = square_torus(t0, continuable_hash)
    # print(f"hash1={continuable_hash}")
    t1, continuable_hash = mul_torus(t0, t1, continuable_hash)
    # print(f"hash2={continuable_hash}")
    t2, continuable_hash = expt_torus(t1, continuable_hash)
    # print(f"hash3={continuable_hash}")
    t2 = inverse_torus(t2)
    t3 = inverse_torus(t1)
    t1, continuable_hash = mul_torus(t2, t3, continuable_hash)
    # print(f"hash4={continuable_hash}")
    t3, continuable_hash = square_torus(t2, continuable_hash)
    # print(f"hash5={continuable_hash}")
    t4, continuable_hash = expt_torus(t3, continuable_hash)
    # print(f"hash6={continuable_hash}")
    t4, continuable_hash = mul_torus(t1, t4, continuable_hash)
    t3, continuable_hash = mul_torus(t0, t4, continuable_hash)
    t0, continuable_hash = mul_torus(t2, t4, continuable_hash)
    t0, continuable_hash = mul_torus(c, t0, continuable_hash)
    # print(f"hash7={continuable_hash}")
    t2, t2_bigint3 = frobenius_torus(t3)
    t0, continuable_hash = mul_torus(t2, t0, continuable_hash, y1_bigint3=t2_bigint3)
    # print(f"hash8={continuable_hash}")
    t2 = frobenius_square_torus(t4)
    t0, continuable_hash = mul_torus(t2, t0, continuable_hash)
    # print(f"hash9={continuable_hash}")
    t2 = inverse_torus(c)
    t2, continuable_hash = mul_torus(t2, t3, continuable_hash)
    # print(f"hash10={continuable_hash}")
    t2, t2_bigint3 = frobenius_cube_torus(t2)
    # print(f"hashf={continuable_hash}")
    if unsafe:
        rest, continuable_hash = mul_torus(
            t2, t0, continuable_hash, y1_bigint3=t2_bigint3
        )
        res = pack_e6(v_to_gnark(rest))
        res = decompress_torus(res)
        return res, continuable_hash
    else:
        _sum = [t0i + t2i % p for t0i, t2i in zip(t0, t2)]
        is_zero = all([e == 0 for e in _sum])
        if is_zero:
            t0t = Polynomial(
                [
                    BaseFieldElement(1, field),
                    field.zero(),
                    field.zero(),
                    field.zero(),
                    field.zero(),
                    field.zero(),
                ]
            )
        else:
            t0t = t0

        if selector1 == 0:
            if is_zero == 0:
                rest, continuable_hash = mul_torus(
                    t2, t0t, continuable_hash, y1_bigint3=t2_bigint3
                )
                res = v_to_gnark(rest)
                res = decompress_torus(res)
                return res, continuable_hash
            else:
                res = (((1, 0), (0, 0), (0, 0)), ((0, 0), (0, 0), (0, 0)))
                return res, continuable_hash
        else:
            res = (((1, 0), (0, 0), (0, 0)), ((0, 0), (0, 0), (0, 0)))
            return res, continuable_hash


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
    f, continuable_hash = final_exponentiation(x, True)
    print(f"f = {f}")
    print(f"z = {z}")
    print(f"hash={continuable_hash}")
    assert pack_e12(z) == f
