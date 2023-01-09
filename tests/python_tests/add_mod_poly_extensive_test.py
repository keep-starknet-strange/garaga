import sys
import time

print(sys.path)

from tools.py.add_mod_poly_c import test_full_field
from tools.py.polynome import evaluate_poly, load_coeff

m, t, s, P = load_coeff(3)
p=evaluate_poly(P, t)


print(t)
print(p, p.bit_length())


t0=time.time()
test_full_field(n_cores=20)
t1=time.time()

print(t1-t0)

