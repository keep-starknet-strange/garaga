from math import gcd 
from hydra.definitions import CURVES, CurveID
from hydra.hints.tower_backup import E12

x = CURVES[CurveID.BLS12_381.value].x
k = 12
r = x**4 - x**2 + 1
q = ((x - 1) ** 2) // 3 * r + x
h = (q**k - 1) // r

lam = -x + q
m = lam // r

p = 5044125407647214251
h3 = h // (27 * p)
assert h % (27 * p) == 0
assert m == 3 * p**2

assert gcd(3, h3) == 1
assert gcd(p ^ 2, h3) == 1
assert gcd(3, h3) == 1
assert gcd(p, h3) == 1
assert gcd(p, 27 * h3) == 1
assert gcd(27, p * h3) == 1

ONE = E12.one(curve_id=1)

def is_pth_residue(x): 
    return x^(h3 * 27) == ONE

def get_pth_root_inverse(x): 
    if is_pth_residue(x): 
        return ONE 
    
    v = 27 * h3 
    wj = x^v 
    
    v_inv = pow(v, -1, p)
    s = (-1 * v_inv) % p
    
    return wj^s

def get_order_of_3rd_primitive_root(x): 
    # correct way is do do r * p * h3 but outputs of equal Tate pairings are always of the form c^r thus there is no rth root contribution
    y = x^(p * h3) 
    
    if y == ONE: 
        return 0 
    
    if y^3 == ONE: 
        return 1
    
    if y^9 == ONE: 
        return 2 
    
    if y^27 == ONE: 
        return 3
    

def get_any_27th_root_inverse(x): 
    pw = get_order_of_3rd_primitive_root(x)
    
    if pw == 0: 
        return ONE
    
    _ord = 3^pw
    
    v = p * h3 
    wj = x^v 
    
    v_inv = pow(v, -1, _ord)
    s = (-1 * v_inv) % _ord
    
    return wj^s

def h3_ord_element_lambda_root(x): 
    # after applying shifts we know that element is order just h3 
    
    e = pow(lam, -1, h3)
    return x^e

# assumes it's already of the form x^r
def get_hints(x): 
    wp_shift = get_pth_root_inverse(x)
    w27_shift = get_any_27th_root_inverse(x)

    x_shifted = x * wp_shift * w27_shift
    root = h3_ord_element_lambda_root(x_shifted)

    return [wp_shift, w27_shift, root]