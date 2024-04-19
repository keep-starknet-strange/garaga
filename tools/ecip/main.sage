# This demonstrates some of the computations of https://eprint.iacr.org/2022/596.
# First, that the logarithmic derivative of the Weil reciprocity equality holds
# over random principal divisors using both mixed and duplicate challenge points.
# Then, that by taking linear combinations of divisor proofs, can check an ECIP
# and combine multiplicities for the same basis points. Example ECIP uses base
# -3 and no CM.

## STEP 1
# Initialize an elliptic curve
p = 21888242871839275222246405745257275088696311157297823662689037894645226208583
r = 21888242871839275222246405745257275088548364400416034343698204186575808495617
Fp = GF(p)  # Base Field
Fr = GF(r)  # Scalar Field
A = 0
B = 3
E = EllipticCurve(GF(p), [A,B])
assert(E.cardinality() == r)

## STEP 2
K.<x> = Fp[]
L.<y> = K[]
eqn = y^2 - x^3 - A * x - B

## STEP 3
# Returns line passing through points, works for all points and returns 1 for O + O = O
def line(A, B):
    if A == 0 and B == 0:
        return 1
    else:
        [a, b, c] = Matrix([A, B, -(A+B)]).transpose().kernel().basis()[0]
        return a*x + b*y + c

## STEP 4
# Works for A == B but not A == -A, as the line has no slope or intercept
def slope_intercept(A, B):
    [a, b, c] = Matrix([A, B, -(A+B)]).transpose().kernel().basis()[0]
    return (-a/b, -c/b)

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
        assert(sum(P for (P, _) in xs) == 0)
        xs2 = []

        # Carry extra point forward
        if mod(len(xs), 2) == 1:
            x0 = xs[0]
            xs = xs[1:]
        else:
            x0 = None

        # Combine the functions for all pairs
        for n in range(0, floor(len(xs)/2)):
            (A, aNum) = xs[2*n]
            (B, bNum) = xs[2*n+1]

            # Divide out intermediate (P, -P) factors
            num = L((aNum * bNum * line(A, B)).mod(eqn))
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
    return D / D(x=0, y=0)

## STEP 8
# Random principal divisor with n points
def random_principal(n):
    # For general elliptic curves, might want to clear cofactor depending on application
    # Works for arbitrary curve groups
    Ps = [E.random_element() for _ in range(0, n-1)]
    Ps.append(-sum(Ps))
    return Ps

## STEP 9
# Random principal divisor with points with given multiplicities
def random_principal_mults(ms):
    # Need to invert the last multiplicity to find the correct final value
    m0 = ms[-1]
    m0Inv = ZZ(Fr(m0)^(-1))
    
    Ps = [E.random_element() for _ in range(0, len(ms)-1)]
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
    [A0, A1] = [E.random_element() for _ in range(0, 2)]
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
    [A0, A1] = [E.random_element() for _ in range(0, 2)]
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
    Dy = D.differentiate(y)
    Dz = Dx + Dy * ((3*x^2 + A) / (2*y))
    
    # This is necessary because Sage fails when diving by D
    U = L(2*y * Dz)
    V = L(2*y * D)

    Den = K((V * V(y=-y)).mod(eqn))
    Num = L((U * V(y=-y)).mod(eqn))
    
    # Must clear the denonimator so mod(eqn) well defined
    assert(L(y * (Num * D - Den * Dz)).mod(eqn) == 0)
    
    return Num/Den # == Dz/D

## STEP 13
# Given a pair of distinct challenge points/line evaluate the function field element
def eval_function_challenge_mixed(A0, A1, D):
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
def eval_function_challenge_dupl(A0, D):
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
    Q2 = -3*Q + sum(d * P for (d, P) in zip(ds, Ps))
    div_ = [-Q, -Q, -Q, -Q2] + [d * P for (d, P) in zip(ds, Ps)]
    div = [P for P in div_ if P != 0]
    assert(sum(div) == 0)
    
    # Check that polynomial for row is correct
    D = construct_function(div)
    LHS = eval_function_challenge_dupl(A0, D)
    RHS = sum(eval_point_challenge(A0, A0, P) for P in div)
    assert(LHS == RHS)
    
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

## STEP 24
# Takes two mults and evaluates both P and -P
def eval_point_challenge_signed(A0, A1, P, mp, mn):
    return eval_point_challenge(A0, A1, P, mult=mp) + eval_point_challenge(A0, A1, -P, mult=mn)

## STEP 21
# Construct digit vectors, note scalars are smaller than characteristic by construction
def construct_digit_vectors(es):
    dss_ = [base_neg3(e, 81) for e in es]                                # Base -3 digits
    epns = list(map(pos_neg_mults, dss_))                                # list of P and -P mults per e
    dss = Matrix(dss_).transpose()

    return (epns, dss)

def prover(A0, Bs, es):
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

def verifier(A0, Bs, epns, Q, Ds):
    ## STEP 26
    # Sides should equal, remember to account for result point (-Q)
    LHS = sum((-3)^i * eval_function_challenge_dupl(A0, D) for (i, D) in enumerate(Ds))
    basisSum = sum(eval_point_challenge_signed(A0, A0, B, ep, en) for ((ep, en), B) in zip(epns, Bs))
    RHS = basisSum + eval_point_challenge(A0, A0, -Q)
    assert(LHS == RHS)

def test_prover_and_verifier():
    A0 = E.random_element()
    Bs = [E.random_element() for _ in range(0, 20)]                      # Basis Points
    es = [ZZ.random_element(-2^127, 2^127) for _ in range(0, len(Bs))]   # Linear combination
    (epns, Q, Ds) = prover(A0, Bs, es)
    verifier(A0, Bs, epns, Q, Ds)

def run_tests(deterministic=False) -> None:
    if deterministic: set_random_seed(0)
    test_at_random_principal_divisor()
    test_at_random_principal_divisor_with_multiplicity()
    test_prover_and_verifier()

def run_prover(_A0: tuple[int, int], _Bs: list[tuple[int, int]], _es: list[int]) -> tuple[list[tuple[int, int]], tuple[int, int], list[list[list[int]]]]:
    A0 = E.point([_A0[0], _A0[1]])
    Bs = [E.point([x, y]) for (x,y) in _Bs]
    assert all(-2^127 <= _e and _e < 2^127 for _e in _es)
    es = [ZZ(_e) for _e in _es]
    (epns, Q, Ds) = prover(A0, Bs, es)
    (Qx, Qy) = Q.xy()
    _epns = [(int(x), int(y)) for (x, y) in epns]
    _Q = (int(Qx), int(Qy))
    _Ds = [[[int(c) for c in x.numerator().coefficients()] for x in y.coefficients()] for y in Ds]
    assert all(all(x.denominator() == 1 for x in y.coefficients()) for y in Ds)
    return (_epns, _Q, _Ds)

## main

import sys

def main(args: list[str]) -> None:
    run_tests()

if __name__ == "__main__":
    main(sys.argv[1:])
