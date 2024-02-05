from sage.all import *

K = GF(21888242871839275222246405745257275088696311157297823662689037894645226208583)
R.<x> = PolynomialRing(K)  

f12 = x^12 - 18*x^6 + 82  
f6 = x^6 - 18*x^3 + 82
f2 = x^2 +1

def check_irreducibility(polynomial, field):
    is_irred = "is" if polynomial.is_irreducible() else "is NOT"
    print(f"The polynomial {polynomial} {is_irred} irreducible over {field}.")

check_irreducibility(f12, K)
check_irreducibility(f6, K)
check_irreducibility(f2, K)


