## File: [src/bn254/curve.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/curve.cairo)

## File: [src/bn254/g1.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo)

### func: compute_doubling_slope

- **[Lines 57-70](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L57-L70)**

```python
from starkware.python.math_utils import div_mod
from src.hints.fq import bigint_pack, bigint_fill, get_p
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
x = bigint_pack(ids.pt.x, ids.N_LIMBS, ids.BASE)
y = bigint_pack(ids.pt.y, ids.N_LIMBS, ids.BASE)
p = get_p(ids)
slope = div_mod(3 * x ** 2, 2 * y, p)
bigint_fill(slope, ids.slope, ids.N_LIMBS, ids.BASE)

```

### func: compute_slope

- **[Lines 94-107](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L94-L107)**

```python
from starkware.python.math_utils import div_mod
from src.hints.fq import bigint_pack, bigint_fill, get_p
assert 1 < ids.N_LIMBS <= 12
p = get_p(ids)
x0 = bigint_pack(ids.pt0.x, ids.N_LIMBS, ids.BASE)
y0 = bigint_pack(ids.pt0.y, ids.N_LIMBS, ids.BASE)
x1 = bigint_pack(ids.pt1.x, ids.N_LIMBS, ids.BASE)
y1 = bigint_pack(ids.pt1.y, ids.N_LIMBS, ids.BASE)
slope = div_mod(y0 - y1, x0 - x1, p)
bigint_fill(slope, ids.slope, ids.N_LIMBS, ids.BASE)

```

### func: double

- **[Lines 144-158](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L144-L158)**

```python
from src.hints.fq import bigint_pack, bigint_fill, get_p
assert 1 < ids.N_LIMBS <= 12
p = get_p(ids)
x = bigint_pack(ids.pt.x, ids.N_LIMBS, ids.BASE)
y = bigint_pack(ids.pt.y, ids.N_LIMBS, ids.BASE)
slope = bigint_pack(ids.slope, ids.N_LIMBS, ids.BASE)
new_x = (pow(slope, 2, p) - 2 * x) % p
new_y = (slope * (x - new_x) - y) % p
bigint_fill(new_x, ids.new_x, ids.N_LIMBS, ids.BASE)
bigint_fill(new_y, ids.new_y, ids.N_LIMBS, ids.BASE)

```

### func: fast_ec_add

- **[Lines 214-229](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L214-L229)**

```python
from src.hints.fq import bigint_pack, bigint_fill, get_p
assert 1 < ids.N_LIMBS <= 12
p = get_p(ids)
x0 = bigint_pack(ids.pt0.x, ids.N_LIMBS, ids.BASE)
y0 = bigint_pack(ids.pt0.y, ids.N_LIMBS, ids.BASE)
x1 = bigint_pack(ids.pt1.x, ids.N_LIMBS, ids.BASE)
slope = bigint_pack(ids.slope, ids.N_LIMBS, ids.BASE)
new_x = (pow(slope, 2, p) - x0 - x1) % p
new_y = (slope * (x0 - new_x) - y0) % p
bigint_fill(new_x, ids.new_x, ids.N_LIMBS, ids.BASE)
bigint_fill(new_y, ids.new_y, ids.N_LIMBS, ids.BASE)

```

### func: ec_mul_inner

- **[Lines 301-301](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L301-L301)**

```python
memory[ap] = (ids.scalar % PRIME) % 2
```

## File: [src/bn254/fq.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo)

### func: add

- **[Lines 125-156](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L125-L156)**

```python
from src.hints.fq import get_p, bigint_split, get_p_limbs
BASE = ids.BASE
p = get_p(ids)
p_limbs = get_p_limbs(ids)
sum_limbs = [getattr(getattr(ids, 'a'), 'd'+str(i)) + getattr(getattr(ids, 'b'), 'd'+str(i)) for i in range(ids.N_LIMBS)]
sum_unreduced = sum([sum_limbs[i] * BASE**i for i in range(ids.N_LIMBS)])
sum_reduced = [sum_limbs[i] - p_limbs[i] for i in range(ids.N_LIMBS)]
has_carry = [1 if sum_limbs[0] >= BASE else 0]
for i in range(1,ids.N_LIMBS):
    if sum_limbs[i] + has_carry[i-1] >= BASE:
        has_carry.append(1)
    else:
        has_carry.append(0)
needs_reduction = 1 if sum_unreduced >= p else 0
has_borrow_carry_reduced = [-1 if sum_reduced[0] < 0 else (1 if sum_reduced[0]>=BASE else 0)]
for i in range(1,ids.N_LIMBS):
    if (sum_reduced[i] + has_borrow_carry_reduced[i-1]) < 0:
        has_borrow_carry_reduced.append(-1)
    elif (sum_reduced[i] + has_borrow_carry_reduced[i-1]) >= BASE:
        has_borrow_carry_reduced.append(1)
    else:
        has_borrow_carry_reduced.append(0)
memory[ap] = needs_reduction
for i in range(ids.N_LIMBS-1):
    if needs_reduction:
        memory[ap+1+i] = has_borrow_carry_reduced[i]
    else:
        memory[ap+1+i] = has_carry[i]

```

### func: sub

- **[Lines 222-253](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L222-L253)**

```python
from src.hints.fq import get_p, bigint_split, get_p_limbs
BASE = ids.BASE
p = get_p(ids)
p_limbs = get_p_limbs(ids)
sub_limbs = [getattr(getattr(ids, 'a'), 'd'+str(i)) - getattr(getattr(ids, 'b'), 'd'+str(i)) for i in range(ids.N_LIMBS)]
sub_unreduced = sum([sub_limbs[i] * BASE**i for i in range(ids.N_LIMBS)])
sub_reduced = [sub_limbs[i] + p_limbs[i] for i in range(ids.N_LIMBS)]
has_borrow = [-1 if sub_limbs[0] < 0 else 0]
for i in range(1,ids.N_LIMBS):
    if sub_limbs[i] + has_borrow[i-1] < 0:
        has_borrow.append(-1)
    else:
        has_borrow.append(0)
needs_reduction = 1 if sub_unreduced < 0 else 0
has_borrow_carry_reduced = [-1 if sub_reduced[0] < 0 else (1 if sub_reduced[0]>=BASE else 0)]
for i in range(1,ids.N_LIMBS):
    if (sub_reduced[i] + has_borrow_carry_reduced[i-1]) < 0:
        has_borrow_carry_reduced.append(-1)
    elif (sub_reduced[i] + has_borrow_carry_reduced[i-1]) >= BASE:
        has_borrow_carry_reduced.append(1)
    else:
        has_borrow_carry_reduced.append(0)
        
memory[ap] = needs_reduction
for i in range(ids.N_LIMBS-1):
    if needs_reduction:
        memory[ap+1+i] = has_borrow_carry_reduced[i]
    else:
        memory[ap+1+i] = has_borrow[i]

```

### func: mul

- **[Lines 317-326](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L317-L326)**

```python
from src.hints.fq import bigint_pack, bigint_fill, get_p
assert 1 < ids.N_LIMBS <= 12
a=bigint_pack(ids.a, ids.N_LIMBS, ids.BASE)
b=bigint_pack(ids.b, ids.N_LIMBS, ids.BASE)
p = get_p(ids)
q, r = divmod(a*b, p)
bigint_fill(q, ids.q, ids.N_LIMBS, ids.BASE)
bigint_fill(r, ids.r, ids.N_LIMBS, ids.BASE)

```

### func: inv

- **[Lines 382-391](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L382-L391)**

```python
from src.hints.fq import bigint_fill, bigint_pack, get_p
assert 1 < ids.N_LIMBS <= 12
a = bigint_pack(ids.a, ids.N_LIMBS, ids.BASE)
p = get_p(ids)
inv = pow(a, -1, p)
bigint_fill(inv, ids.inv, ids.N_LIMBS, ids.BASE)

```

### func: verify_zero5

- **[Lines 426-433](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L426-L433)**

```python
from src.hints.fq import bigint_pack, bigint_fill, get_p
val = bigint_pack(ids.val, ids.N_LIMBS_UNREDUCED, ids.BASE)
p = get_p(ids)
q, r = divmod(val, p)
assert r == 0, f"val is not a multiple of p: {val} % {p} = {r}"
bigint_fill(q, ids.q, ids.N_LIMBS, ids.BASE)

```

### func: reduce_5

- **[Lines 479-486](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L479-L486)**

```python
from src.hints.fq import bigint_pack, bigint_fill, get_p
val = bigint_pack(ids.val, ids.N_LIMBS_UNREDUCED, ids.BASE)
p = get_p(ids)
q, r = divmod(val, p)
bigint_fill(q, ids.q, ids.N_LIMBS, ids.BASE)
bigint_fill(r, ids.r, ids.N_LIMBS, ids.BASE)

```

### func: reduce_3

- **[Lines 542-574](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L542-L574)**

```python
from src.hints.fq import bigint_limbs, bigint_pack, bigint_split, get_p, get_p_limbs, fill_limbs
val_limbs = bigint_limbs(ids.val, ids.N_LIMBS)
val = bigint_pack(ids.val, ids.N_LIMBS, ids.BASE)
p = get_p(ids)
p_limbs = get_p_limbs(ids)
def reduce_zero_poly(x:list):
    x = x.copy()
    carries = [0] * (len(x)-1)
    for i in range(0, len(x)-1):
        carries[i] = x[i] // ids.BASE
        x[i] = x[i] % ids.BASE
        assert x[i] == 0
        x[i+1] += carries[i]
    assert x[-1] == 0
    return carries
q, r = divmod(val, p)
r_limbs = bigint_split(r, ids.N_LIMBS, ids.BASE)
q_P_plus_r_limbs = [q*Pi + ri for Pi, ri in zip(p_limbs, r_limbs)]
diff_limbs = [q_P_plus_r_limbs[i] - val_limbs[i] for i in range(ids.N_LIMBS)]
carries = reduce_zero_poly(diff_limbs)
carries = [abs(x) for x in carries]
flags = [1 if diff_limbs[i] >= 0 else 0 for i in range(len(diff_limbs) - 1)]
ids.q = q
fill_limbs(r_limbs, ids.r)
for i in range(ids.N_LIMBS-1):
    setattr(ids, 'flag'+str(i), flags[i])
    setattr(ids, 'q'+str(i), carries[i])

```

## File: [src/bn254/g2.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo)

### func: assert_on_curve

- **[Lines 41-45](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo#L41-L45)**

```python
from starkware.cairo.common.cairo_secp.secp_utils import split
ids.b20 = segments.gen_arg(split(19485874751759354771024239261021720505790618469301721065564631296452457478373))
ids.b21 = segments.gen_arg(split(266929791119991161246907387137283842545076965332900288569378510910307636690))

```

### func: compute_doubling_slope

- **[Lines 70-80](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo#L70-L80)**

```python
from src.hints.fq import bigint_pack, bigint_fill
from src.hints.e2 import E2
assert 1 < ids.N_LIMBS <= 12
p = get_p(ids)
x = E2(bigint_pack(ids.pt.x.a0, ids.N_LIMBS, ids.BASE), bigint_pack(ids.pt.x.a1, ids.N_LIMBS, ids.BASE), p)
y = E2(bigint_pack(ids.pt.y.a0, ids.N_LIMBS, ids.BASE), bigint_pack(ids.pt.y.a1, ids.N_LIMBS, ids.BASE), p)
value = (3 * x * x) / (2 * y)
bigint_fill(value.a0, ids.slope_a0, ids.N_LIMBS, ids.BASE)
bigint_fill(value.a1, ids.slope_a1, ids.N_LIMBS, ids.BASE)

```

### func: compute_slope

- **[Lines 130-145](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo#L130-L145)**

```python
from src.hints.fq import bigint_pack, bigint_fill
from src.hints.e2 import E2
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
p = get_p(ids)
x0 = E2(bigint_pack(ids.pt0.x.a0, ids.N_LIMBS, ids.BASE), bigint_pack(ids.pt0.x.a1, ids.N_LIMBS, ids.BASE), p)
y0 = E2(bigint_pack(ids.pt0.y.a0, ids.N_LIMBS, ids.BASE), bigint_pack(ids.pt0.y.a1, ids.N_LIMBS, ids.BASE), p)
x1 = E2(bigint_pack(ids.pt1.x.a0, ids.N_LIMBS, ids.BASE), bigint_pack(ids.pt1.x.a1, ids.N_LIMBS, ids.BASE), p)
y1 = E2(bigint_pack(ids.pt1.y.a0, ids.N_LIMBS, ids.BASE), bigint_pack(ids.pt1.y.a1, ids.N_LIMBS, ids.BASE), p)
value = (y0 - y1) / (x0 - x1)
bigint_fill(value.a0, ids.slope_a0, ids.N_LIMBS, ids.BASE)
bigint_fill(value.a1, ids.slope_a1, ids.N_LIMBS, ids.BASE)

```

### func: get_g2_generator

- **[Lines 391-412](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo#L391-L412)**

```python
import subprocess
import functools
import re
from starkware.cairo.common.cairo_secp.secp_utils import split
def rgetattr(obj, attr, *args):
    def _getattr(obj, attr):
        return getattr(obj, attr, *args)
    return functools.reduce(_getattr, [obj] + attr.split('.'))
def rsetattr(obj, attr, val):
    pre, _, post = attr.rpartition('.')
    return setattr(rgetattr(obj, pre) if pre else obj, post, val)
def fill_element(element:str, value:int):
    s = split(value)
    for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])
fill_element('g2x0', 10857046999023057135944570762232829481370756359578518086990519993285655852781)
fill_element('g2x1', 11559732032986387107991004021392285783925812861821192530917403151452391805634)
fill_element('g2y0', 8495653923123431417604973247489272438418190587263600148770280649306958101930)
fill_element('g2y1', 4082367875863433681332203403145435568316851327593401208105741076214120093531)

```

### func: get_n_g2_generator

- **[Lines 424-456](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo#L424-L456)**

```python
from starkware.cairo.common.cairo_secp.secp_utils import split
import subprocess
import functools
import re
def rgetattr(obj, attr, *args):
    def _getattr(obj, attr):
        return getattr(obj, attr, *args)
    return functools.reduce(_getattr, [obj] + attr.split('.'))
def rsetattr(obj, attr, val):
    pre, _, post = attr.rpartition('.')
    return setattr(rgetattr(obj, pre) if pre else obj, post, val)
def parse_fp_elements(input_string:str):
    pattern = re.compile(r'\[([^\[\]]+)\]')
    substrings = pattern.findall(input_string)
    sublists = [substring.split(' ') for substring in substrings]
    sublists = [[int(x) for x in sublist] for sublist in sublists]
    fp_elements = [x[0] + x[1]*2**64 + x[2]*2**128 + x[3]*2**192 for x in sublists]
    return fp_elements
def fill_element(element:str, value:int):
    s = split(value)
    for i in range(3): rsetattr(ids,element+'.d'+str(i),s[i])
cmd = ['./tools/gnark/main', 'nG1nG2', '1', str(ids.n)]
out = subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')
fp_elements = parse_fp_elements(out)
assert len(fp_elements) == 6
fill_element('g2x0', fp_elements[2])
fill_element('g2x1', fp_elements[3])
fill_element('g2y0', fp_elements[4])
fill_element('g2y1', fp_elements[5])

```

## File: [src/bn254/pairing.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo)

### func: multi_miller_loop

- **[Lines 143-171](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L143-L171)**

```python
from src.bn254.pairing_multi_miller import multi_miller_loop, G1Point, G2Point, E2
from starkware.cairo.common.math_utils import as_int
from src.hints.fq import get_p
n_points = ids.n_points
P_arr = [[0, 0] for _ in range(n_points)]
Q_arr = [([0, 0], [0, 0]) for _ in range(n_points)]
p = get_p(ids)
for i in range(n_points):
    P_pt_ptr = memory[ids.P+i]
    Q_pt_ptr = memory[ids.Q+i]
    Q_x_ptr = memory[Q_pt_ptr]
    Q_y_ptr = memory[Q_pt_ptr+1]
    for k in range(ids.N_LIMBS):
        P_arr[i][0] = P_arr[i][0] + as_int(memory[P_pt_ptr+k], PRIME) * ids.BASE**k
        P_arr[i][1] = P_arr[i][1] + as_int(memory[P_pt_ptr+ids.N_LIMBS+k], PRIME) * ids.BASE**k
        Q_arr[i][0][0] = Q_arr[i][0][0] + as_int(memory[Q_x_ptr+k], PRIME) * ids.BASE**k
        Q_arr[i][0][1] = Q_arr[i][0][1] + as_int(memory[Q_x_ptr+ids.N_LIMBS+k], PRIME) * ids.BASE**k
        Q_arr[i][1][0] = Q_arr[i][1][0] + as_int(memory[Q_y_ptr+k], PRIME) * ids.BASE**k
        Q_arr[i][1][1] = Q_arr[i][1][1] + as_int(memory[Q_y_ptr+ids.N_LIMBS+k], PRIME) * ids.BASE**k
P_arr = [G1Point(*P) for P in P_arr]
Q_arr = [G2Point(E2(*Q[0], p), E2(*Q[1], p)) for Q in Q_arr]
print("Pre-computing miller loop hash commitment Z = poseidon('GaragaBN254MillerLoop', [(A1, B1, Q1, R1), ..., (An, Bn, Qn, Rn)])")
x, Z = multi_miller_loop(P_arr, Q_arr, ids.n_points, ids.continuable_hash)
Z_bigint3 = split(Z)
ids.Z.d0, ids.Z.d1, ids.Z.d2 = Z_bigint3[0], Z_bigint3[1], Z_bigint3[2]

```

- **[Lines 200-200](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L200-L200)**

```python
print(f"HASH : {ids.continuable_hash}")
```

- **[Lines 202-202](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L202-L202)**

```python
print("Verifying Miller Loop hash commitment Z = continuable_hash ... ")
```

- **[Lines 206-206](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L206-L206)**

```python
print("Verifying Σc_i*A_i(z)*B_i(z) == P(z)Σc_i*Q_i(z) + Σc_i*R_i(z)")
```

- **[Lines 332-332](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L332-L332)**

```python
print("Ok! \n")
```

- **[Lines 335-338](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L335-L338)**

```python
//     print("RESFINALMILLERLOOP:")
//     print_e12(ids.res_gnark)

```

### func: multi_miller_loop_inner

- **[Lines 414-414](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L414-L414)**

```python
print(f"index = {ids.bit_index}, bit = {ids.bit_index}, offset = {ids.offset}")
```

- **[Lines 428-428](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L428-L428)**

```python
print(f"index = {ids.bit_index}, bit = {ids.bit}, offset = {ids.offset}")
```

### func: final_exponentiation

- **[Lines 754-770](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L754-L770)**

```python
from src.bn254.pairing_final_exp import final_exponentiation
from starkware.cairo.common.math_utils import as_int
from tools.py.extension_trick import pack_e12
f_input = 12*[0]
input_refs =[ids.z.c0.b0.a0, ids.z.c0.b0.a1, ids.z.c0.b1.a0, ids.z.c0.b1.a1, ids.z.c0.b2.a0, ids.z.c0.b2.a1,
ids.z.c1.b0.a0, ids.z.c1.b0.a1, ids.z.c1.b1.a0, ids.z.c1.b1.a1, ids.z.c1.b2.a0, ids.z.c1.b2.a1]
for i in range(ids.N_LIMBS):
    for k in range(12):
        f_input[k] += as_int(getattr(input_refs[k], "d" + str(i)), PRIME) * ids.BASE**i
f_input = pack_e12(f_input)
print("Pre-computing final exp hash commitment Z = poseidon('GaragaBN254FinalExp', [(A1, B1, Q1, R1), ..., (An, Bn, Qn, Rn)])")
_, Z = final_exponentiation(f_input, unsafe=ids.unsafe, continuable_hash=ids.continuable_hash)
Z_bigint3 = split(Z)
ids.Z.d0, ids.Z.d1, ids.Z.d2 = Z_bigint3[0], Z_bigint3[1], Z_bigint3[2]

```

- **[Lines 901-901](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L901-L901)**

```python
print(f"hash={ids.continuable_hash}")
```

- **[Lines 904-904](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L904-L904)**

```python
print(f"Verifying final exponentiation hash commitment Z = continuable_hash")
```

- **[Lines 908-908](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L908-L908)**

```python
print(f"Verifying Σc_i*A_i(z)*B_i(z) == P(z)Σc_i*Q_i(z) + Σc_i*R_i(z)")
```

- **[Lines 949-949](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L949-L949)**

```python
print(f"Ok!")
```

## File: [src/bn254/towers/e6.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo)

### func: mul_trick_e6

- **[Lines 116-130](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo#L116-L130)**

```python
from src.hints.e6 import mul_trick
from src.hints.fq import pack_e6d, fill_e6d
from tools.make.utils import split_128
x = pack_e6d(ids.x, ids.N_LIMBS, ids.BASE)
y = pack_e6d(ids.y, ids.N_LIMBS, ids.BASE)
q, r = mul_trick(x, y, ids.CURVE)
fill_e6d(r, ids.r_v, ids.N_LIMBS, ids.BASE)
for i in range(5):
    val = split_128(q[i])
    rsetattr(ids.q_v, f'v{i}.low', val[0])
    rsetattr(ids.q_v, f'v{i}.high', val[1])

```

### func: div_trick_e6

- **[Lines 480-498](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo#L480-L498)**

```python
from starkware.cairo.common.math_utils import as_int
from src.hints.fq import bigint_split, bigint_pack
from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v, div_e6, pack_e6
x, y = [], []
for i in range(6):
    x.append(bigint_pack(getattr(ids.x, 'v'+str(i)), ids.N_LIMBS, ids.BASE))
    y.append(bigint_pack(getattr(ids.y, 'v'+str(i)), ids.N_LIMBS, ids.BASE))
x_gnark, y_gnark = pack_e6(v_to_gnark(x)), pack_e6(v_to_gnark(y))
z = flatten(div_e6(x_gnark, y_gnark))
z = gnark_to_v(z)
e = [bigint_split(x, ids.N_LIMBS, ids.BASE) for x in z]
                                              
for i in range(6):
    for k in range(ids.N_LIMBS):
        setattr(ids, f'div_v{i}d{k}', e[i][k])

```

### func: square_torus

- **[Lines 1016-1029](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo#L1016-L1029)**

```python
from starkware.cairo.common.math_utils import as_int
from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v, square_torus_e6
x=6*[0]
x_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
for i in range(ids.N_LIMBS):
    for k in range(6):
        x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
x_gnark = pack_e6(v_to_gnark(x))
z = gnark_to_v(flatten(square_torus_e6(x_gnark)))
for i, e in enumerate(z):
    bigint_fill(e, getattr(ids.sq, 'v'+str(i)), ids.N_LIMBS, ids.BASE)

```

- **[Lines 1038-1051](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo#L1038-L1051)**

```python
from src.hints.e6 import mul_trick
from src.hints.fq import pack_e6d
from tools.make.utils import split_128
x = pack_e6d(ids.v_tmp, ids.N_LIMBS, ids.BASE)
y = pack_e6d(ids.x, ids.N_LIMBS, ids.BASE)
q, r = mul_trick(x, y, ids.CURVE)
for i in range(5):
    val = split_128(q[i])
    rsetattr(ids.q_v, f'v{i}.low', val[0])
    rsetattr(ids.q_v, f'v{i}.high', val[1])

```

## File: [src/bn254/towers/e2.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e2.cairo)

### func: inv

- **[Lines 79-89](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e2.cairo#L79-L89)**

```python
from src.hints.fq import bigint_pack, bigint_fill, get_p
from src.hints.e2 import E2
p = get_p(ids)
a0 = bigint_pack(ids.x.a0, ids.N_LIMBS, ids.BASE)
a1 = bigint_pack(ids.x.a1, ids.N_LIMBS, ids.BASE)
x = E2(a0, a1, p)
x_inv = 1/x
bigint_fill(x_inv.a0,ids.inv0, ids.N_LIMBS, ids.BASE)
bigint_fill(x_inv.a1,ids.inv1, ids.N_LIMBS, ids.BASE)

```

### func: div

- **[Lines 105-139](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e2.cairo#L105-L139)**

```python
from starkware.cairo.common.math_utils import as_int    
from src.hints.fq import bigint_split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
p,x,y=0, 2*[0], 2*[0]
x_refs = [ids.x.a0, ids.x.a1]
y_refs = [ids.y.a0, ids.y.a1]
for i in range(ids.N_LIMBS):
    for k in range(2):
        x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        y[k]+=as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
def inv_e2(a:(int, int)):
    t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
    t0 = (t0 + t1) % p
    t1 = pow(t0, -1, p)
    return a[0] * t1 % p, -(a[1] * t1) % p
def mul_e2(x:(int,int), y:(int,int)):   
    a = (x[0] + x[1]) * (y[0] + y[1]) % p
    b, c  = x[0]*y[0] % p, x[1]*y[1] % p
    return (b - c) % p, (a - b - c) % p
x=(x[0], x[1])
y=(y[0], y[1])
y_inv = inv_e2(y)
div = mul_e2(x, y_inv)
div0, div1 = split(div[0]), split(div[1])
for i in range(ids.N_LIMBS):
    setattr(ids.div0, 'd'+str(i),  div0[i])
    setattr(ids.div1, 'd'+str(i),  div1[i])

```

## File: [src/bn254/towers/e12.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo)

### func: square

- **[Lines 177-203](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L177-L203)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement
from src.hints.fq import pack_e12d, fill_e12d, fill_uint256
from starkware.cairo.common.cairo_secp.secp_utils import split
from tools.make.utils import split_128
from src.bn254.curve import IRREDUCIBLE_POLY_12, field
x=pack_e12d(ids.x, ids.N_LIMBS, ids.BASE)
x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
z_poly=x_poly*x_poly
z_polyr=z_poly % IRREDUCIBLE_POLY_12
z_polyq=z_poly // IRREDUCIBLE_POLY_12
z_polyr_coeffs = z_polyr.get_coeffs()
z_polyq_coeffs = z_polyq.get_coeffs()
assert len(z_polyq_coeffs)<=11
# extend z_polyq with 0 to make it len 11:
z_polyq_coeffs = z_polyq_coeffs + (11-len(z_polyq_coeffs))*[0]
# extend z_polyr with 0 to make it len 12:
z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
for i in range(11):
    fill_uint256(z_polyq_coeffs[i], getattr(ids.q_w, f'w{i}'))
fill_e12d(z_polyr_coeffs, ids.r_w, ids.N_LIMBS, ids.BASE)

```

### func: mul034

- **[Lines 709-750](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L709-L750)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
from starkware.cairo.common.cairo_secp.secp_utils import split
from tools.make.utils import split_128
from src.hints.fq import pack_e12d, fill_e12d
from src.bn254.curve import IRREDUCIBLE_POLY_12
p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
field = BaseField(p)
x=12*[0]
y=[1]+11*[0]
x_refs=[ids.x.w0, ids.x.w1, ids.x.w2, ids.x.w3, ids.x.w4, ids.x.w5, ids.x.w6, ids.x.w7, ids.x.w8, ids.x.w9, ids.x.w10, ids.x.w11]
y_refs=[(1,ids.y.w1), (3,ids.y.w3), (7,ids.y.w7), (9,ids.y.w9)]
for i in range(ids.N_LIMBS):
    for index, ref in y_refs:
        y[index]+=as_int(getattr(ref, 'd'+str(i)), PRIME) * ids.BASE**i
    for k in range(12):
        x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
y_poly=Polynomial([BaseFieldElement(y[i], field) for i in range(12)])
z_poly=x_poly*y_poly
z_polyr=z_poly % IRREDUCIBLE_POLY_12
z_polyq=z_poly // IRREDUCIBLE_POLY_12
z_polyr_coeffs = z_polyr.get_coeffs()
z_polyq_coeffs = z_polyq.get_coeffs()
assert len(z_polyq_coeffs)<=9, f"len z_polyq_coeffs: {len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
assert len(z_polyr_coeffs)<=12, f"len z_polyr_coeffs: {z_polyr_coeffs}, degree: {z_polyr.degree()}"
# extend z_polyq with 0 to make it len 9:
z_polyq_coeffs = z_polyq_coeffs + (9-len(z_polyq_coeffs))*[0]
# extend z_polyr with 0 to make it len 12:
z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
for i in range(12):
    val = split(z_polyr_coeffs[i]%p)
    for k in range(ids.N_LIMBS):
        rsetattr(ids.r_w, f'w{i}.d{k}', val[k])
for i in range(9):
    val = split_128(z_polyq_coeffs[i]%p)
    rsetattr(ids.q_w, f'w{i}.low', val[0])
    rsetattr(ids.q_w, f'w{i}.high', val[1])

```

### func: mul034_034

- **[Lines 1299-1350](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L1299-L1350)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
from starkware.cairo.common.cairo_secp.secp_utils import split
from src.bn254.curve import IRREDUCIBLE_POLY_12
from tools.make.utils import split_128
p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
field = BaseField(p)
x=[1]+11*[0]
y=[1]+11*[0]
x_refs=[(1,ids.x.w1), (3,ids.x.w3), (7,ids.x.w7), (9,ids.x.w9)]
y_refs=[(1,ids.y.w1), (3,ids.y.w3), (7,ids.y.w7), (9,ids.y.w9)]
for i in range(ids.N_LIMBS):
    for index, ref in y_refs:
        y[index]+=as_int(getattr(ref, 'd'+str(i)), PRIME) * ids.BASE**i
    for index, ref in x_refs:
        x[index]+=as_int(getattr(ref, 'd'+str(i)), PRIME) * ids.BASE**i
x_gnark=w_to_gnark(x)
y_gnark=w_to_gnark(y)
#print(f"Y_Gnark: {y_gnark}")
#print(f"Y_034034: {y}")
x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
y_poly=Polynomial([BaseFieldElement(y[i], field) for i in range(12)])
z_poly=x_poly*y_poly
z_polyr=z_poly % IRREDUCIBLE_POLY_12
z_polyq=z_poly // IRREDUCIBLE_POLY_12
z_polyr_coeffs = z_polyr.get_coeffs()
z_polyq_coeffs = z_polyq.get_coeffs()
assert len(z_polyq_coeffs)<=7, f"len z_polyq_coeffs: {len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
assert len(z_polyr_coeffs)<=12, f"len z_polyr_coeffs: {z_polyr_coeffs}, degree: {z_polyr.degree()}"
assert z_polyr_coeffs[5]==0, f"Not a 01234"
# extend z_polyq with 0 to make it len 9:
z_polyq_coeffs = z_polyq_coeffs + (7-len(z_polyq_coeffs))*[0]
# extend z_polyr with 0 to make it len 12:
z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(y_gnark)))
assert expected==w_to_gnark(z_polyr_coeffs), f"expected: {expected}, got: {w_to_gnark(z_polyr_coeffs)}"
#print(f"Z_PolyR: {z_polyr_coeffs}")
#print(f"Z_PolyR_to_gnark: {w_to_gnark(z_polyr_coeffs)}")
for i in range(12):
    if i==5:
        continue
    val = split(z_polyr_coeffs[i]%p)
    for k in range(3):
        rsetattr(ids.r_w, f'w{i}.d{k}', val[k])
for i in range(7):
    val = split_128(z_polyq_coeffs[i]%p)
    rsetattr(ids.q_w, f'w{i}.low', val[0])
    rsetattr(ids.q_w, f'w{i}.high', val[1])

```

### func: mul01234

- **[Lines 1762-1803](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L1762-L1803)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
from starkware.cairo.common.cairo_secp.secp_utils import split
from tools.make.utils import split_128
from src.bn254.curve import IRREDUCIBLE_POLY_12
p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
field = BaseField(p)
x=12*[0]
y=12*[0]
x_refs = [ids.x.w0, ids.x.w1, ids.x.w2, ids.x.w3, ids.x.w4, ids.x.w5, ids.x.w6, ids.x.w7, ids.x.w8, ids.x.w9, ids.x.w10, ids.x.w11]
y_refs = [ids.y.w0, ids.y.w1, ids.y.w2, ids.y.w3, ids.y.w4, None, ids.y.w6, ids.y.w7, ids.y.w8, ids.y.w9, ids.y.w10, ids.y.w11]
for i in range(ids.N_LIMBS):
    for k in range(12):
        x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
    for k in range(12):
        if k==5:
            continue
        y[k]+=as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
y_poly=Polynomial([BaseFieldElement(y[i], field) for i in range(12)])
z_poly=x_poly*y_poly
z_polyr=z_poly % IRREDUCIBLE_POLY_12
z_polyq=z_poly // IRREDUCIBLE_POLY_12
z_polyr_coeffs = z_polyr.get_coeffs()
z_polyq_coeffs = z_polyq.get_coeffs()
assert len(z_polyq_coeffs)<=11, f"len z_polyq_coeffs: {len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
assert len(z_polyr_coeffs)<=12, f"len z_polyr_coeffs: {z_polyr_coeffs}, degree: {z_polyr.degree()}"
#print(f"Z_PolyR034034: {z_polyr_coeffs}")
# extend z_polyq with 0 to make it len 9:
z_polyq_coeffs = z_polyq_coeffs + (11-len(z_polyq_coeffs))*[0]
# extend z_polyr with 0 to make it len 12:
z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
#expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(y_gnark)))
#assert expected==w_to_gnark(z_polyr_coeffs)
#print(f"Z_PolyR: {z_polyr_coeffs}")
#print(f"Z_PolyR_to_gnark: {w_to_gnark(z_polyr_coeffs)}")
fill_e12d(z_polyr_coeffs, ids.r_w, ids.N_LIMBS, ids.BASE)
for i in range(11):
    fill_uint256(z_polyq_coeffs[i], getattr(ids.q_w, 'w'+str(i)))

```

### func: mul_trick_pure

- **[Lines 2446-2491](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L2446-L2491)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
from src.bn254.curve import IRREDUCIBLE_POLY_12
from starkware.cairo.common.cairo_secp.secp_utils import split
from starkware.cairo.common.math_utils import as_int
from tools.make.utils import split_128
p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
field = BaseField(p)
x=12*[0]
y=12*[0]
x_refs = [ids.x.w0, ids.x.w1, ids.x.w2, ids.x.w3, ids.x.w4, ids.x.w5, ids.x.w6, ids.x.w7, ids.x.w8, ids.x.w9, ids.x.w10, ids.x.w11]
y_refs = [ids.y.w0, ids.y.w1, ids.y.w2, ids.y.w3, ids.y.w4, ids.y.w5, ids.y.w6, ids.y.w7, ids.y.w8, ids.y.w9, ids.y.w10, ids.y.w11]
for i in range(ids.N_LIMBS):
    for k in range(12):
        x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
    for k in range(12):
        y[k]+=as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
y_poly=Polynomial([BaseFieldElement(y[i], field) for i in range(12)])
z_poly=x_poly*y_poly
z_polyr=z_poly % IRREDUCIBLE_POLY_12
z_polyq=z_poly // IRREDUCIBLE_POLY_12
z_polyr_coeffs = z_polyr.get_coeffs()
z_polyq_coeffs = z_polyq.get_coeffs()
assert len(z_polyq_coeffs)<=11, f"len z_polyq_coeffs: {len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
assert len(z_polyr_coeffs)<=12, f"len z_polyr_coeffs: {z_polyr_coeffs}, degree: {z_polyr.degree()}"
#print(f"Z_PolyR034034: {z_polyr_coeffs}")
# extend z_polyq with 0 to make it len 9:
z_polyq_coeffs = z_polyq_coeffs + (11-len(z_polyq_coeffs))*[0]
# extend z_polyr with 0 to make it len 12:
z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
#expected = flatten(mul_e12_gnark(pack_e12(x_gnark), pack_e12(y_gnark)))
#assert expected==w_to_gnark(z_polyr_coeffs)
#print(f"Z_PolyR: {z_polyr_coeffs}")
#print(f"Z_PolyR_to_gnark: {w_to_gnark(z_polyr_coeffs)}")
for i in range(12):
    val = split(z_polyr_coeffs[i]%p)
    for k in range(3):
        rsetattr(ids.r_w, f'w{i}.d{k}', val[k])
for i in range(11):
    val = split(z_polyq_coeffs[i]%p)
    for k in range(3):
        rsetattr(ids.q_w, f'w{i}.d{k}', val[k])

```

### func: div_full

- **[Lines 3351-3374](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L3351-L3374)**

```python
from starkware.cairo.common.math_utils import as_int
from tools.py.extension_trick import inv_e12, mul_e12, pack_e12, flatten, w_to_gnark, gnark_to_w
assert 1 < ids.N_LIMBS <= 12
p, x, y=0, 12*[0], 12*[0] 
for i in range(ids.N_LIMBS):
    for k in range(12):
        x[k]+=as_int(getattr(getattr(ids.x, f'w{k}'), f'd{i}'), PRIME) * ids.BASE**i
        y[k]+=as_int(getattr(getattr(ids.y, f'w{k}'), f'd{i}'), PRIME) * ids.BASE**i
        
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
x = w_to_gnark(x)
y = w_to_gnark(y)
y_inv = inv_e12(*pack_e12(y))
x_over_y = mul_e12(pack_e12(x), pack_e12(y_inv))
assert x == flatten(mul_e12(pack_e12(y), x_over_y))
x_over_y_full = gnark_to_w(flatten(x_over_y))
div = [split(wi) for wi in x_over_y_full]
for i in range(12):
    for l in range(ids.N_LIMBS):
        setattr(getattr(ids.div,f'w{i}'),f'd{l}',div[i][l])

```

