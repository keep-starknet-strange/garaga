import time
from tools.py.add_mod_poly import *

# Test Cython functions from add_mod_poly files.
# Used for research purposes.


# SystemError is used to catch C errors when cdef functions with except -1 in their signatures are called.


def log(x, *args):
    print("\n ============", x, *args)

try:
    log("Testing polyadd using evaluated polynomials in x < t:")
    test_full_field_add_mod_reduced_t(t_case=5)
except SystemError:
    log("Test failed (as expected).")
    

## Test the full field 
try:
    log("Test polyadd parallel:")
    t0=time.time()
    test_full_field_polyadd(n_cores=20, t_case = 5, subfield=True)
    t1=time.time()
    log("Test succeeded in ", time.time()-t0, "sec.")
except SystemError:
    t1=time.time()
    log("Test Failed in ", t1-t0, "sec")
    log("/!\ Test failed in test add_mod_poly_full_field (unexpected).")

try:
    log("Test polyadd_3 parallel:")
    t0=time.time()
    test_polyadd_3(t_case = 5, n_cores=20)
    t1=time.time()
    log("Test succeeded in ", time.time()-t0, "sec.")
except SystemError:
    t1=time.time()
    log("Test Failed in ", t1-t0, "sec")
    log("/!\ Test failed in test garagadd_3 (unexpected).")


log("Test full field polynomial decomposition with euclidean division:")
test_full_field_decomposition(t_case=5)

log("Test if A(x) > P(x) => A(t) > P(t) for x < t:")
test_assertion(t_case=5)