# Adapted and optimized from https://gist.github.com/Liam-Eagen/666d0771f4968adccd6087465b8c5bd4
# This demonstrates some of the computations of https://eprint.iacr.org/2022/596.
# First, that the logarithmic derivative of the Weil reciprocity equality holds
# over random principal divisors using both mixed and duplicate challenge points.
# Then, that by taking linear combinations of divisor proofs, can check an ECIP
# and combine multiplicities for the same basis points. Example ECIP uses base
# -3 and no CM.

proof.arithmetic(False)


def init(_p, _r, _h, _A, _B):
    global p, r, h, Fp, Fr, A, B, E, K, x, L, y, eqn

    ## STEP 1
    # Initialize an elliptic curve
    p = _p
    r = _r
    h = _h
    Fp = GF(p, proof=False)  # Base Field
    Fr = GF(r, proof=False)  # Scalar Field
    A = _A
    B = _B
    E = EllipticCurve(Fp, [A, B])
    E.set_order(r * h)

    ## STEP 2
    K.<x> = Fp[]
    L.<y> = K[]
    eqn = y^2 - x^3 - A * x - B

## STEP 3
# Returns line passing through points, works for all points and returns 1 for O + O = O
def line(P, Q):
    # [a, b, c] = Matrix([P, Q, -(P + Q)]).transpose().kernel().basis()[0]
    # return a * x + b * y + c
    if P == 0:
        return 1 if Q == 0 else x - Q.xy()[0]
    if Q == 0:
        return x - P.xy()[0]

    px, py = P.xy()
    if P == Q:
        m = (3 * px**2 + A) / (2 * py)
        b = py - m * px
        return -m * x + y - b
    if P == -Q:
        return x - px

    qx, qy = Q.xy()
    m = (py - qy) / (px - qx)
    b = qy - m * qx
    return -m * x + y - b

## STEP 4
# Works for A == B but not A == -A, as the line has no slope or intercept
def slope_intercept(P, Q):
    #     [a, b, c] = Matrix([P, Q, -(P + Q)]).transpose().kernel().basis()[0]
    #     return (-a / b, -c / b)
    if P == Q:
        px, py = P.xy()
        m = (3 * px**2 + A) / (2 * py)
        b = py - m * px
        return (m, b)
    else:
        px, py = P.xy()
        qx, qy = Q.xy()
        m = (py - qy) / (px - qx)
        b = qy - m * qx
        return (m, b)



## STEP 5
# Fails at 0
def eval_point(f, P):
    (x, y) = P.xy()
    return f(x=x, y=y)

## STEP 6
# f(x) + y g(x) -> (f(x), g(x)), should reduce mod eqn first
def get_polys(D):
    return ( K(D(y=0)), K(D(y=1) - D(y=0)) )

## STEP 7
# Accepts arbitrary list of points, including duplicates and inverses, and constructs function
# intersecting exactly those points if they form a principal divisor (i.e. sum to zero).
def construct_function(Ps):
    # List of intermediate sums/principal divisors, removes 0
    xs = [(P, line(P, -P)) for P in Ps if P != 0]

    while len(xs) != 1:
        # assert(sum(P for (P, _) in xs) == 0) # Sanity check
        xs2 = []

        # Carry extra point forward
        if len(xs) & 1:  # len(xs) is odd
            x0 = xs[0]
            xs = xs[1:]
        else:
            x0 = None

        # Combine the functions for all pairs
        for n in range(0, len(xs) // 2):
            (A, aNum) = xs[2*n]
            (B, bNum) = xs[2*n+1]

            # Divide out intermediate (P, -P) factors
            num = L((aNum * bNum * line(A, B))%eqn)
            den = line(A, -A) * line(B, -B)
            D = num / K(den)

            # Add new element
            xs2.append((A+B, D))

        if x0 != None:
            xs2.append(x0)

        xs = xs2

    assert(xs[0][0] == 0)

    # Normalize, might fail but negl probability for random points. Must be done for zkps
    # although free to use any coefficient
    D = D / D(x=0, y=0)

    return D

def random_element():
    # For general elliptic curves, we want to clear cofactor depending on application
    # Works for arbitrary curve groups
    return E.random_element() * h

## STEP 8
# Random principal divisor with n points
def random_principal(n):
    Ps = [random_element() for _ in range(0, n-1)]
    Ps.append(-sum(Ps))
    return Ps

## STEP 9
# Random principal divisor with points with given multiplicities
def random_principal_mults(ms):
    # Need to invert the last multiplicity to find the correct final value
    m0 = ms[-1]
    m0Inv = ZZ(Fr(m0)^(-1))

    Ps = [random_element() for _ in range(0, len(ms)-1)]
    Q = -m0Inv * sum(m * P for (m, P) in zip(ms[:-1], Ps))
    Ps.append(Q)

    assert(sum(m * P for (m, P) in zip(ms, Ps)) == 0)
    return sum(( m * [P] for (m, P) in zip(ms, Ps) ), [])

## STEP 10
# Test at a random principal divisor
def test_at_random_principal_divisor():
    Ps = random_principal(33)
    D = construct_function(Ps)
    (f, g) = get_polys(D)

    # Should be the same up to constant
    assert((f^2 - (x^3 + A * x + B) * g^2) / product(x - P.xy()[0] for P in Ps) in Fp)
    assert(all(eval_point(D, P) == 0 for P in Ps))

    ## STEP 16
    # Both should be true (uses same points as higher mult test)
    [A0, A1] = [random_element() for _ in range(0, 2)]
    assert(eval_function_challenge_mixed(A0, A1, D) == sum(eval_point_challenge(A0, A1, P) for P in Ps))
    assert(eval_function_challenge_dupl(A0, D) == sum(eval_point_challenge(A0, A0, P) for P in Ps))

## STEP 11
# Test at random principal divisor with multiplicity. For a divisor that does not contain
# both P and -P for any P, it is sufficient to check the previous conditions and that
# gcd(f, g) = 1
def test_at_random_principal_divisor_with_multiplicity():
    Ps = random_principal_mults([1,2,3,4,5,6])
    D = construct_function(Ps)
    (f, g) = get_polys(D)

    assert((f^2 - (x^3 + A * x + B) * g^2) / product(x - P.xy()[0] for P in Ps) in Fp)
    assert(all(eval_point(D, P) == 0 for P in Ps))
    assert(gcd(f, g) == 1)

    ## STEP 16
    # Both should be true (uses same points as higher mult test)
    [A0, A1] = [random_element() for _ in range(0, 2)]
    assert(eval_function_challenge_mixed(A0, A1, D) == sum(eval_point_challenge(A0, A1, P) for P in Ps))
    assert(eval_function_challenge_dupl(A0, D) == sum(eval_point_challenge(A0, A0, P) for P in Ps))

# The test to check that a function hits exactly a certain set of points uses
# Weil reciprocity to check that the product of one function over the points of
# the divisor of the other is the same quantity, up to leading coefficients.
# Taking the logarithmic derivative wrt a coordinate of one divisor gives a sum
# of rational functions. That is what is being checked here. While the proof
# will evaluate the dlog function of at the points, it is important to note
# that this is also a rational function in the coefficients of the other
# function.

## STEP 12
# Return logarithmic derivative wrt x
def dlog(D):
    # Derivative via partials
    Dx = D.differentiate(x)
    Dy = D.differentiate(y) # b(x)
    Dz = Dx + Dy * ((3*x^2 + A) / (2*y))

    # This is necessary because Sage fails when diving by D
    U = L(2*y * Dz)
    V = L(2*y * D)

    Den = K((V * V(y=-y))%eqn)
    Num = L((U * V(y=-y))%eqn)

    # Must clear the denonimator so mod(eqn) well defined
    # assert(L(y * (Num * D - Den * Dz))%eqn == 0) # Sanity Check. 

    return Num/Den # == Dz/D

def dlog2(D):
    a,b=get_polys(D)
    Da=a.differentiate(x)
    Db=b.differentiate(x)
    res = Da + b*((3*x^2 + A) / (2*y))  - y*Db
    res = res/D
    return res

## STEP 13
# Given a pair of distinct challenge points/line evaluate the function field element
def eval_function_challenge_mixed(A0, A1, D, ):
    assert(A0 != A1)
    A2 = -(A0 + A1)
    (m, b) = slope_intercept(A0, A1)
    DLog = dlog(D)

    # Coefficient per point
    coeff = 1/((3 * x^2 + A) / (2 * y) - m)
    expr = DLog * coeff

    # From paper, check that expr sum is 0, equals slope derivative wrt intercept
    assert(sum(eval_point(coeff, P) for P in [A0, A1, A2]) == 0)

    # Evaluate
    return sum(eval_point(expr, P) for P in [A0, A1, A2])

## STEP 14
# Given a duplicated challenge point/line evaluate the function field element
def eval_function_challenge_dupl(A0, D, ):
    A2 = -(2*A0)
    (m, b) = slope_intercept(A0, A2)
    DLog = dlog(D)

    # Coefficient for A2
    (xA0, yA0) = A0.xy()
    (xA2, yA2) = A2.xy()
    coeff2 = (2 * yA2) * (xA0 - xA2) / (3 * xA2^2 + A - 2 * m * yA2)
    coeff0 = (coeff2 + 2 * m)

    return eval_point(DLog * coeff0, A0) - eval_point(DLog * coeff2, A2)

## STEP 15
# Given a pair of challenge points, detect if duplicate/mixed and modify numerator
def eval_point_challenge(A0, A1, P, mult=1):
    (m, b) = slope_intercept(A0, A1)
    (xP, yP) = P.xy()

    if A0 == A1:
        (xA, _) = A0.xy()
        num = (xA - xP)
    else:
        num = -1

    den = yP - m * xP - b
    return mult*num/den

# The ECIP takes advantage of the linearity of the right hand sides of the
# equations to sum multiplicities of the same point in different functions.
# The following shows how this works in base with scalars that are half the
# length of the field. Note this is important; if the scalars can exceed field
# length protocol can fail to be sound. Also works for random linear
# combinations.

## STEP 17
# return base -3 digits from {-1, 0, 1} from starting with least signficant
def base_neg3(n,k):
    ds = []
    for i in range(0, k):
        q = -floor(n/3)
        r = ZZ(mod(n, 3))
        if r == 2:
            q = q - 1
            r = -1
        ds.append(r)
        n = q

    assert(n == 0)
    assert(sum(d * (-3)^i for (i, d) in enumerate(ds)))

    return ds


def neg_3_base_le(scalar):
    """
    Decomposes a scalar into base -3 representation.
    :param scalar: The integer to be decomposed.
    :return: A list of coefficients in base -3 representation. (Least significant bit first),
    with digits [-1, 0, 1]
    """
    if scalar == 0:
        return [0]
    digits = []
    while scalar != 0:
        remainder = scalar % 3
        if (
            remainder == 2
        ):  # if the remainder is 2, we set it to -1 and add 1 to the next digit
            remainder = -1
            scalar += 1
        # For remainder 1 and 0, no change is required
        digits.append(remainder)
        scalar = -(scalar // 3)  # divide by -3 for the next digit

    return digits

## STEP 18
# P and -P are counted separately in basis
def pos_neg_mults(ds):
    a = sum((-3)^i for (i, d) in enumerate(ds) if d == 1)
    b = sum((-3)^i for (i, d) in enumerate(ds) if d == -1)
    return (a, b)

## STEP 19
# Construct the principal divisor for each row given sum from previous row
def row_function(A0, ds, Ps, Q):
    # Construct divisor for row
    digits_points = [P if d == 1 else -P if d == -1 else 0 for d, P in zip(ds, Ps)]
    Q2 = -3*Q + sum(digits_points)
    Q_neg = -Q
    div_ = [Q_neg, Q_neg, Q_neg, -Q2] + digits_points
    div = [P for P in div_ if P != 0]

    # Sanity check :
    # assert(sum(div) == 0)

    D = construct_function(div)
    
    # Check that polynomial for row is correct (sanity check):

    # LHS = eval_function_challenge_dupl(A0, D)
    # RHS = sum(eval_point_challenge(A0, A0, P) for P in div)
    # assert(LHS == RHS)

    return (D, Q2, div)

## STEP 20
# Compute the function for each row using Shamir's trick and -3
def ecip_functions(A0, Bs, dss):
    rows = list(dss)
    rows.reverse()

    Q = 0
    Ds = []
    for ds in rows:
        (p, Q, _) = row_function(A0, ds, Bs, Q)
        Ds.append(p)

    # Want lowest order first
    Ds.reverse()
    return (Q, Ds)

## STEP 21
# Construct digit vectors, note scalars are smaller than characteristic by construction
def construct_digit_vectors(es):
    dss_ = [neg_3_base_le(e) for e in es] # Base -3 digits
    max_len = max([len(ds) for ds in dss_])
    dss_ = [ds+[0]*(max_len-len(ds)) for ds in dss_]
    epns = list(map(pos_neg_mults, dss_))                                # list of P and -P mults per e
    dss = Matrix(dss_).transpose()
    return (epns, dss)

def prover(A0, Bs, es, ):
    assert len(Bs) == len(es)
    (epns, dss) = construct_digit_vectors(es)

    ## STEP 22
    # Kinda slow
    (Q, Ds) = ecip_functions(A0, Bs, dss)

    ## STEP 23
    # Q is the final sum
    assert(Q == sum(e * B for (e, B) in zip(es, Bs)))
    assert(Q == sum((ep - en) * B for ((ep, en), B) in zip(epns, Bs)))
    return (epns, Q, Ds)

## STEP 24
# Takes two mults and evaluates both P and -P
def eval_point_challenge_signed(A0, A1, P, mp, mn):
    return eval_point_challenge(A0, A1, P, mult=mp) + eval_point_challenge(A0, A1, -P, mult=mn)

## STEP 25
# Sides should equal, remember to account for result point (-Q)
def verifier(A0, Bs, epns, Q, Ds, ):
    LHS = sum((-3)^i * eval_function_challenge_dupl(A0, D) for (i, D) in enumerate(Ds))
    basisSum = sum(eval_point_challenge_signed(A0, A0, B, ep, en) for ((ep, en), B) in zip(epns, Bs))
    RHS = basisSum + eval_point_challenge(A0, A0, -Q)
    return LHS == RHS, LHS, RHS

def test_prover_and_verifier():
    A0 = random_element()
    Bs = [random_element() for _ in range(0, 20)]                        # Basis Points
    es = [ZZ.random_element(-2^127, 2^127) for _ in range(0, len(Bs))]   # Linear combination
    (epns, Q, Ds) = prover(A0, Bs, es)
    success = verifier(A0, Bs, epns, Q, Ds)
    assert success

def tests() -> None:
    test_at_random_principal_divisor()
    test_at_random_principal_divisor_with_multiplicity()
    test_prover_and_verifier()

## entrypoints

# These are the functions exposed to the ECIP CLI
# They take/return regular Python values and perform the marshalling/unmarshalling to/from sage values
# Their names start with the prefix run_ and call their respective sage function

def run_construct_digit_vectors(_es: list[int]) -> tuple[list[tuple[int, int]], list[list[int]]]:
    # assert all(-2**127 <= _e and _e < 2**127 for _e in _es)
    es = [ZZ(_e) for _e in _es]
    (epns, dss) = construct_digit_vectors(es)
    _epns = [(int(x), int(y)) for (x, y) in epns]
    _dss = [[int(v) for v in l] for l in dss]
    return (_epns, _dss)

def run_ecip_functions(_Bs: list[tuple[int, int]], _dss: list[list[int]]) -> tuple[tuple[int, int], list[list[list[int]]]]:
    A0 = random_element()
    Bs = [E.point([x, y]) for (x,y) in _Bs]
    dss = Matrix(_dss)
    dss_t = list(dss.transpose())
    es = [sum((-3)^i * d for (i, d) in enumerate(digits)) for digits in dss_t]

    epns, _ = construct_digit_vectors(es)
    (Q, Ds) = ecip_functions(A0, Bs, dss)
    if Q==0:
        Qx = 0
        Qy = 0
    else:
        (Qx, Qy) = Q.xy()

    _Q = (int(Qx), int(Qy))
    dlogs = [dlog(D) for D in Ds]
    sum_dlog = sum((-3)^i *dl for (i, dl) in enumerate(dlogs))
    # LHS = eval_function_challenge_dupl(A0, sum_dlog, True)
    # RHS = sum(eval_point_challenge_signed(A0, A0, B, ep, en) for ((ep, en), B) in zip(epns, Bs))
    # if Q!=0:
    #     RHS = RHS + eval_point_challenge(A0, A0, -Q)
    # assert LHS == RHS
    y_coeffs = sum_dlog.coefficients()
    assert len(y_coeffs) == 2

    def list_int(l):
        return [int(c) for c in l]
    res=[[list_int(y_coeffs[0].numerator().coefficients()), list_int(y_coeffs[0].denominator().coefficients())],
          [list_int(y_coeffs[1].numerator().coefficients()), list_int(y_coeffs[1].denominator().coefficients())]]
    # _Ds = [[[int(c) for c in px.numerator().coefficients()] for px in py.coefficients()] for py in Ds]
    # assert all(all(px.denominator() == 1 for px in y.coefficients()) for py in Ds)
    return (_Q, res, str(sum_dlog))

def run_prover(_Bs: list[tuple[int, int]], _es: list[int], ) -> tuple[list[tuple[int, int]], tuple[int, int], list[list[list[int]]]]:
    A0 = random_element()
    Bs = [E.point([x, y]) for (x,y) in _Bs]
    assert all(-2**127 <= _e and _e < 2**127 for _e in _es)
    es = [ZZ(_e) for _e in _es]
    (epns, Q, Ds) = prover(A0, Bs, es)
    (Qx, Qy) = Q.xy()
    _epns = [(int(x), int(y)) for (x, y) in epns]
    _Q = (int(Qx), int(Qy))
    _Ds = [[[int(c) for c in px.numerator().coefficients()] for px in py.coefficients()] for py in Ds]
    assert all(all(px.denominator() == 1 for px in y.coefficients()) for py in Ds)
    return (_epns, _Q, _Ds)

def run_verifier(_Bs: list[tuple[int, int]], _epns: list[tuple[int, int]], _Q: tuple[int, int], _Ds: list[list[list[int]]], ) -> bool:
    A0 = random_element()
    Bs = [E.point([x, y]) for (x,y) in _Bs]
    epns = [(Integer(_x), Integer(_y)) for (_x, _y) in _epns]
    Q = E.point([_Q[0], _Q[1]])
    Ds = []
    for k in range(len(_Ds)):
        _D = _Ds[k]
        D = 0
        for j in range(len(_D)):
            cs = _D[j]
            p = sum(Integer(cs[i]) * x^i for i in range(len(cs)))
            D += p * y^j
        Ds.append(D)
    return verifier(A0, Bs, epns, Q, Ds)

def run_tests() -> None:
    tests()

## main

import json
import sys

# This is the script entrypoint
# It takes 3 arguments:
# - curve parameters (p, r, h, a, and b) encoded in JSON
# - sage function name to be executed
# - a list of parametes to the function encoded in JSON
# In the JSON encoding, Python's int values are encoded as strings

def main(args: list[str]) -> None:
    assert len(args) == 4
    deterministic = json.loads(args[0])
    curve = json.loads(args[1])
    name = args[2]
    params = json.loads(args[3])
    assert isinstance(deterministic, bool)
    assert set(curve.keys()) == set(['p', 'r', 'h', 'a', 'b'])
    assert all(isinstance(value, str) for value in curve.values())
    if deterministic: set_random_seed(0)
    init(_p=int(curve['p']), _r=int(curve['r']), _h=int(curve['h']), _A=int(curve['a']), _B=int(curve['b']))
    if name == 'construct_digit_vectors':
        assert isinstance(params, list) and len(params) == 1
        (p0) = (params[0])
        assert isinstance(p0, list) and all(isinstance(v, str) for v in p0)
        _es = [int(v) for v in p0]
        (_epns, _dss) = run_construct_digit_vectors(_es)
        r0 = [[str(l[0]), str(l[1])] for l in _epns]
        r1 = [[str(v) for v in l] for l in _dss]
        print(json.dumps([r0, r1]))
        return
    if name == 'ecip_functions':
        assert isinstance(params, list) and len(params) == 2
        (p0, p1) = (params[0], params[1])
        assert isinstance(p0, list) and all(isinstance(l, list) and len(l) == 2 and all(isinstance(v, str) for v in l) for l in p0)
        assert isinstance(p1, list) and all(isinstance(l, list) and all(isinstance(v, str) for v in l) for l in p1)
        _Bs = [(int(l[0]), int(l[1])) for l in p0]
        _dss = [[int(v) for v in l] for l in p1]
        (_Q, _Ds, sum_dlog_str) = run_ecip_functions(_Bs, _dss)
        r0 = [str(_Q[0]), str(_Q[1])]
        r1 =  _Ds #[[[str(v) for v in l2] for l2 in l1] for l1 in _Ds]
        print(json.dumps([r0, r1, sum_dlog_str]))
        return
    if name == 'prover':
        assert isinstance(params, list) and len(params) == 2
        (p0, p1) = (params[0], params[1])
        assert isinstance(p0, list) and all(isinstance(l, list) and len(l) == 2 and all(isinstance(v, str) for v in l) for l in p0)
        assert isinstance(p1, list) and all(isinstance(v, str) for v in p1)
        assert isinstance(p2, bool)
        _Bs = [(int(l[0]), int(l[1])) for l in p0]
        _es = [int(v) for v in p1]
        (_epns, _Q, _Ds) = run_prover(_Bs, _es)
        r0 = [[str(l[0]), str(l[1])] for l in _epns]
        r1 = [str(_Q[0]), str(_Q[1])]
        r2 = [[[str(v) for v in l2] for l2 in l1] for l1 in _Ds]
        print(json.dumps([r0, r1, r2]))
        return
    if name == 'verifier':
        assert isinstance(params, list)and len(params) == 5
        (p0, p1, p2, p3) = (params[0], params[1], params[2], params[3])
        assert isinstance(p0, list) and all(isinstance(l, list) and len(l) == 2 and all(isinstance(v, str) for v in l) for l in p0)
        assert isinstance(p1, list) and all(isinstance(l, list) and len(l) == 2 and all(isinstance(v, str) for v in l) for l in p1)
        assert isinstance(p2, list) and len(p2) == 2 and all(isinstance(v, str) for v in p2)
        assert isinstance(p3, list) and all(isinstance(l1, list) and all(isinstance(l2, list) and all(isinstance(v, str) for v in l2) for l2 in l1) for l1 in p3)
        assert isinstance(p4, bool)
        _Bs = [(int(l[0]), int(l[1])) for l in p0]
        _epns = [(int(l[0]), int(l[1])) for l in p1]
        _Q = (int(p2[0]), int(p2[1]))
        _Ds = [[[int(v) for v in l2] for l2 in l1] for l1 in p3]
        success = run_verifier(_Bs, _epns, _Q, _Ds)
        print(json.dumps([success]))
        return
    if name == 'tests':
        run_tests()
        print(json.dumps([]))
        return
    assert False

if __name__ == '__main__':
    # skips the script path itself
    # import cProfile
    # import pstats
    # import io
    # import os

    # def get_unique_filename(base_name: str, extension: str) -> str:
    #     counter = 1
    #     file_name = f"{base_name}{extension}"
    #     while os.path.exists(file_name):
    #         file_name = f"{base_name}_{counter}{extension}"
    #         counter += 1
    #     return file_name

    # # Create a profile object
    # pr = cProfile.Profile()

    # # Start profiling
    # pr.enable()

    # # Run the main function
    main(sys.argv[1:])

    # # Stop profiling
    # pr.disable()

    # # Create a stream to hold the profiling stats
    # s = io.StringIO()

    # # Create a Stats object and sort the results by cumulative time
    # ps = pstats.Stats(pr, stream=s).sort_stats("cumulative")
    # ps.print_stats()
    # # Save the profiling results to a file
    # file_name = get_unique_filename("msm", ".txt")
    # with open(file_name, "w") as f:
    #     f.write(s.getvalue())

    # # Create another stream to hold the filtered profiling stats
    # s_filtered = io.StringIO()

    # # Create another Stats object for filtered results
    # ps_filtered = pstats.Stats(pr, stream=s_filtered).sort_stats("cumulative")

    # # Print stats for row_function and its children to the filtered stream
    # ps_filtered.print_callees("dlog")

    # # Print the filtered profiling results to the console
    # # print(s_filtered.getvalue())

    # # Optionally, save the filtered profiling results to a separate file
    # with open("profile_stats_filtered.txt", "w") as f:
    #     f.write(s_filtered.getvalue())