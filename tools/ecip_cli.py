import json
import os
import subprocess
from src.definitions import CurveID, CURVES, get_base_field, G1Point
from src.algebra import (
    PyFelt,
    Polynomial,
    RationalFunction,
    FunctionFelt,
    ModuloCircuitElement,
)
from dotenv import load_dotenv

load_dotenv()


class EcipCLI:
    def __init__(
        self,
        curve_id: CurveID,
        use_docker=True,
        docker_tag="latest",
        deterministic=False,
        verbose=False,
    ):
        project_root = os.getenv("GARAGA_ROOT")
        if not project_root:
            raise EnvironmentError(
                "GARAGA_ROOT environment variable not set or .env file missing."
            )
        folder = os.path.join(project_root, "tools")
        self.field = get_base_field(curve_id.value)
        # allows invoking sage via docker
        if use_docker:
            self.executable_path = (
                "docker run --rm -v "
                + folder
                + "/../:/opt/garaga/ sagemath/sagemath:"
                + docker_tag
                + " sage"
            )
            self.script_path = "/opt/garaga/tools/ecip/main.sage"
            self.escape_args = True
        else:
            self.executable_path = "sage"
            self.script_path = folder + "/ecip/main.sage"
            self.escape_args = False
        self.curve_id = curve_id
        self.curve = CURVES[curve_id.value]
        # these are the curve parameters required by the ECIP sage script
        self.curve_args = json.dumps(
            {
                "p": str(self.curve.p),
                "r": str(self.curve.n),
                "h": str(self.curve.h),
                "a": str(self.curve.a),
                "b": str(self.curve.b),
            }
        )
        self.deterministic = json.dumps(deterministic)
        self.verbose = verbose  # Store verbose setting

    def run_command(self, args: list[str]):
        command = (self.executable_path + " " + self.script_path).split()
        command_args = [self.deterministic, self.curve_args] + args
        # escaping is necessary for docker parameters
        # this is safe because the ' char will never appear in the arguments
        if self.escape_args:
            command_args = ["'" + arg + "'" for arg in command_args]
        process = subprocess.Popen(
            command + command_args,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True,  # Ensures outputs are in string format
            bufsize=1,  # Line buffered
            universal_newlines=True,
        )
        stdout, stderr = [], []
        try:
            # Print stdout in real-time and capture it if verbose is True
            for line in process.stdout:
                if self.verbose:
                    print(line, end="")  # Print in real-time only if verbose
                stdout.append(line)  # Capture the output
            # Capture stderr
            stderr = process.stderr.read()
        finally:
            process.stdout.close()
            process.stderr.close()
            process.wait()
        if process.returncode != 0:
            raise Exception(f"Error executing ecip-cli: {stderr}")
        return "".join(stdout)

    # The functions below are implemented by invoking their coutnerpart in the sage script
    # curve/function parameters are encoded as JSON strings where int values are converted to/from str

    def construct_digit_vectors(
        self, es: list[int]
    ) -> tuple[list[tuple[int, int]], list[list[int]]]:
        # assert all(-(2**127) <= e and e < 2**127 for e in es)
        p0 = [str(e) for e in es]
        args = ["construct_digit_vectors", json.dumps([p0])]
        output = self.run_command(args)
        res = json.loads(output)
        assert isinstance(res, list) and len(res) == 2
        (r0, r1) = (res[0], res[1])
        assert isinstance(r0, list) and all(
            isinstance(l, list) and len(l) == 2 and all(isinstance(v, str) for v in l)
            for l in r0
        )
        assert isinstance(r1, list) and all(
            isinstance(l, list) and all(isinstance(v, str) for v in l) for l in r1
        )
        epns = [(int(l[0]), int(l[1])) for l in r0]
        dss = [[int(v) for v in l] for l in r1]
        return (epns, dss)

    def ecip_functions(
        self,
        Bs: list[
            tuple[int | ModuloCircuitElement, int | ModuloCircuitElement] | G1Point
        ],
        dss: list[list[int]],
        uses_dlog=False,
    ) -> tuple[tuple[int, int], list[list[list[int]]]]:
        if isinstance(Bs[0], G1Point):
            p0 = [[str(B.x), str(B.y)] for B in Bs]
        elif isinstance(Bs[0], tuple):
            if isinstance(Bs[0][0], int):
                p0 = [[str(B[0]), str(B[1])] for B in Bs]
            else:
                p0 = [[str(B[0].value), str(B[1].value)] for B in Bs]
        else:
            raise ValueError("Invalid Bs type")
        p1 = [[str(v) for v in l] for l in dss]
        p2 = uses_dlog
        args = ["ecip_functions", json.dumps([p0, p1, p2])]
        output = self.run_command(args)
        # print("SAGE OUTPUT RECEIVED : ", output)
        res = json.loads(output)
        assert isinstance(res, list) and len(res) == 3
        (r0, r1, r2) = (res[0], res[1], res[2])
        assert (
            isinstance(r0, list)
            and len(r0) == 2
            and all(isinstance(v, str) for v in r0)
        )

        Q = (int(r0[0]), int(r0[1]))
        # Ds = [[[int(v) for v in l2] for l2 in l1] for l1 in r1]
        # print(f"R1 PYTHON RES: {r1}")
        # print(f"R2 PYTHON RES: {r2}")
        a = RationalFunction(
            Polynomial([self.field(c) for c in r1[0][0]]),
            Polynomial([self.field(c) for c in r1[0][1]]),
        )
        b = RationalFunction(
            Polynomial([self.field(c) for c in r1[1][0]]),
            Polynomial([self.field(c) for c in r1[1][1]]),
        )
        f = FunctionFelt(a, b)
        return (Q, f)

    def prover(
        self, Bs: list[tuple[int, int]], es: list[int], uses_dlog=False
    ) -> tuple[list[tuple[int, int]], tuple[int, int], list[list[list[int]]]]:
        assert len(Bs) == len(es)
        assert all(-(2**127) <= e and e < 2**127 for e in es)
        p0 = [[str(B[0]), str(B[1])] for B in Bs]
        p1 = [str(e) for e in es]
        p2 = uses_dlog
        args = ["prover", json.dumps([p0, p1, p2])]
        output = self.run_command(args)
        res = json.loads(output)
        assert isinstance(res, list) and len(res) == 3
        (r0, r1, r2) = (res[0], res[1], res[2])
        assert isinstance(r0, list) and all(
            isinstance(l, list) and len(l) == 2 and all(isinstance(v, str) for v in l)
            for l in r0
        )
        assert (
            isinstance(r1, list)
            and len(r1) == 2
            and all(isinstance(v, str) for v in r1)
        )
        assert isinstance(r2, list) and all(
            isinstance(l1, list)
            and all(
                isinstance(l2, list) and all(isinstance(v, str) for v in l2)
                for l2 in l1
            )
            for l1 in r2
        )
        epns = [(int(l[0]), int(l[1])) for l in r0]
        Q = (int(r1[0]), int(r1[1]))
        Ds = [[[int(v) for v in l2] for l2 in l1] for l1 in r2]
        return (epns, Q, Ds)

    def verifier(
        self,
        Bs: list[tuple[int, int]],
        epns: list[tuple[int, int]],
        Q: tuple[int, int],
        Ds: list[list[list[int]]],
        uses_dlog=False,
    ) -> bool:
        p0 = [[str(B[0]), str(B[1])] for B in Bs]
        p1 = [[str(epn[0]), str(epn[1])] for epn in epns]
        p2 = [str(Q[0]), str(Q[1])]
        p3 = [[[str(v) for v in l2] for l2 in l1] for l1 in Ds]
        p4 = uses_dlog
        args = ["verifier", json.dumps([p0, p1, p2, p3, p4])]
        output = self.run_command(args)
        res = json.loads(output)
        assert isinstance(res, list) and len(res) == 1
        (r0) = res[0]
        assert isinstance(r0, bool)
        success = r0
        return success

    def tests(self, uses_dlog=False):
        p0 = uses_dlog
        args = ["tests", json.dumps([p0])]
        output = self.run_command(args)
        res = json.loads(output)
        assert isinstance(res, list) and len(res) == 0
        return


if __name__ == "__main__":
    from tools.gnark_cli import GnarkCLI

    g1_gen = GnarkCLI(CurveID.BN254).nG1nG2_operation(1, 1, True)

    # this portion of the test, with explicit values, tests marshalling/unmarshalling parameters
    Bs = [
        (
            g1_gen[0],
            g1_gen[1],
        ),
        (
            12250102893037584251779309227643068964429482273831683484150646260670625578919,
            9191774223203416103848704454328429050505975794672003463355101752384490250423,
        ),
        (
            18366788045815599474863815028413424812466230308812861556270074624392605791761,
            11786653732850133541116305448533627920826997455482976374314994712888968403308,
        ),
        (
            6837650850588217837323560195462222252029520678279142278058962844652233321796,
            12872923453351525375017131997911693777333555175006532157508394255270587552317,
        ),
        (
            18980423977759095296430753687890972867855745045780029273110681276919905684421,
            14879169671806280346845216275022959030859256620522734713775362014264661566955,
        ),
        (
            2179133718144280544293186885852330633125405927968306128845478857051593498101,
            6396828696768182362713893021940440981875890441262909548355281380546884889076,
        ),
        (
            13034217815496484635523925107078407416528204058017865701965517788992999340096,
            12101519175933236840766670671093750425857243284280287827016658579678243750678,
        ),
        (
            12621098755108463930953623404895746827919001589551765642509889703967562897797,
            2378811243753766129725314190589553773495304585599278581460206079419437205817,
        ),
        (
            15148730926892121505567832467427916986919158163918880085549618298033494117396,
            12492443026734006113968428181695131514230955959360299258157610809696464925499,
        ),
        (
            12759275019908477097712960288687676521039730657656621918359534453257883905476,
            16210916902197662832468731066927488819286225647287509278212386611976946050844,
        ),
        (
            10360238590361263295427253849600278490488984653960594924765447163252432498852,
            17550082717214889555718032742151902863229684770549584131003740196987725169425,
        ),
        (
            14224611297180523534229203155227979073594306574079030049347157903482818098286,
            15644910325177345283377847607507022484185682312428605039324778297037312539473,
        ),
        (
            18573104298072065510450746589269954677716506374477899852900503519751171966981,
            1478033425729747891942557367898265791660738232588717972248400743235414154293,
        ),
        (
            6109061117334504685794028396961951347365065608027190546690486811621845055433,
            20419960999743868372511037112749042098011705165801205927971572336353673451883,
        ),
        (
            20924932386967887706596156383773279368864995452032766249891620089536690781901,
            5690398652013237605853919730436084214726942075469754330126460964335575963388,
        ),
        (
            14693919454903949552286291536156804562622070674811649051773030914846089804489,
            15015698599011393662544400732485790124031648928322567359952223023523117422454,
        ),
        (
            3275791082206066462383505080893982748476587214390837201086305972709557985817,
            14269000716079331936314492778666787745151924573455587499189342872859656849531,
        ),
        (
            21217023920782202965075594160814310764648139257632138816768971276346312926311,
            184766081671315504659811321244523600738023179685964243991353889095054449620,
        ),
        (
            21621453745296673302401909379818354232682857415141546266683472234431217135781,
            9712088930197890501224519701416284917724947171748271004868375617216123588721,
        ),
        (
            4437975242413760356449180196000967287119740158123783424888994313136545798923,
            12428909460355224597805565930061377904292526548700187633465924764046002188879,
        ),
    ]
    es = [
        CURVES[CurveID.BN254.value].n,
        -113239147526861370123239602414667686328,
        -73054363070339504179935982958784194797,
        -110579142376613569668553432075675018684,
        -40749527249131475516693679743397007965,
        -121229816481544455636715776697984563326,
        151098686459785931414463974808663188196,
        -141896404217117896816478595484649814394,
        40005548702367546656083210970619363920,
        151326560377364971094448757529436391871,
        116838366855615308519594716056293995778,
        62929568461617805853090622237651905395,
        53337808030039306389955688379742920166,
        82237184077514675307025357567238276672,
        46004367250059164567094809381315043006,
        95842284144697782315024352450641016067,
        59411603378440755610791352754802599265,
        119418230586087993035459416284699157178,
        169074888062571497383436258343463175440,
        27827152908074547741934219177150744509,
    ]

    cli = EcipCLI(CurveID.BN254, deterministic=True)

    # (Q1, Ds1) = cli.ecip_functions(Bs, dss)

    # print("Ds1", Ds1)

    # (epns2, Q2, Ds2) = cli.prover(Bs, es)

    res = []
    for i in range(1, 2):
        print(i)
        (epns1, dss) = cli.construct_digit_vectors(es[0:i])
        points = Bs[0:i]
        res.append((len(points), cli.ecip_functions(points, dss)))

    for i, (n, (Q, f)) in enumerate(res):
        degrees = f.degrees_infos()
        print(
            f"Msm {n} points: f = a(x) + y*b(x) rational functions degrees: ",
            f"{degrees['a']['numerator']}/{degrees['a']['denominator']} + y * {degrees['b']['numerator']}/{degrees['b']['denominator']}",
        )

    # # (epns2, Q2, Ds2) = cli.prover(A0, Bs, es)

    # # cli.verifier(Bs, epns1, Q1, Ds1)

    # # run sage tests for every curve
    # for curve_id in [CurveID.BN254, CurveID.BLS12_381]:
    #     print("\n\n", curve_id)
    # # assert epns1 == epns2 and Q1 == Q2 and Ds1 == Ds2
    # cli.verifier(A0, Bs, epns1, Q1, Ds1)

    # for curve_id in [CurveID.BN254, CurveID.BLS12_381]:
    #     print("\n\n", curve_id)

    #     cli = EcipCLI(curve_id)

    #     cli.tests()
