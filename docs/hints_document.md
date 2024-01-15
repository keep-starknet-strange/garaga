## File: [src/bn254/curve.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/curve.cairo)

## File: [src/bn254/g1.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo)

### func: compute_doubling_slope

- **[Lines 64-81](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L64-L81)**

```python
from starkware.python.math_utils import div_mod
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
x,y,p=0,0,0
for i in range(ids.N_LIMBS):
    x+=getattr(ids.pt.x, 'd'+str(i)) * ids.BASE**i
    y+=getattr(ids.pt.y, 'd'+str(i)) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
slope = split(div_mod(3 * x ** 2, 2 * y, p))
for i in range(ids.N_LIMBS):
    setattr(ids.slope, 'd'+str(i), slope[i])

```

### func: compute_slope

- **[Lines 105-124](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L105-L124)**

```python
from starkware.python.math_utils import div_mod
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
x0,y0,x1,y1,p=0,0,0,0,0
for i in range(ids.N_LIMBS):
    x0+=getattr(ids.pt0.x, 'd'+str(i)) * ids.BASE**i
    y0+=getattr(ids.pt0.y, 'd'+str(i)) * ids.BASE**i
    x1+=getattr(ids.pt1.x, 'd'+str(i)) * ids.BASE**i
    y1+=getattr(ids.pt1.y, 'd'+str(i)) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
slope = split(div_mod(y0 - y1, x0 - x1, p))
for i in range(ids.N_LIMBS):
    setattr(ids.slope, 'd'+str(i), slope[i])

```

### func: double

- **[Lines 161-182](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L161-L182)**

```python
from starkware.python.math_utils import div_mod
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
x,y,slope,p=0,0,0,0
for i in range(ids.N_LIMBS):
    x+=getattr(ids.pt.x, 'd'+str(i)) * ids.BASE**i
    y+=getattr(ids.pt.y, 'd'+str(i)) * ids.BASE**i
    slope+=getattr(ids.slope, 'd'+str(i)) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
new_x = (pow(slope, 2, p) - 2 * x) % p
new_y = (slope * (x - new_x) - y) % p
new_xs, new_ys = split(new_x), split(new_y)
for i in range(ids.N_LIMBS):
    setattr(ids.new_x, 'd'+str(i), new_xs[i])
    setattr(ids.new_y, 'd'+str(i), new_ys[i])

```

### func: fast_ec_add

- **[Lines 238-259](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L238-L259)**

```python
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
x0,y0,x1,slope,p=0,0,0,0,0
for i in range(ids.N_LIMBS):
    x0+=getattr(ids.pt0.x, 'd'+str(i)) * ids.BASE**i
    y0+=getattr(ids.pt0.y, 'd'+str(i)) * ids.BASE**i
    x1+=getattr(ids.pt1.x, 'd'+str(i)) * ids.BASE**i
    slope+=getattr(ids.slope, 'd'+str(i)) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
new_x = (pow(slope, 2, p) - x0 - x1) % p
new_y = (slope * (x0 - new_x) - y0) % p
new_xs, new_ys = split(new_x), split(new_y)
for i in range(ids.N_LIMBS):
    setattr(ids.new_x, 'd'+str(i), new_xs[i])
    setattr(ids.new_y, 'd'+str(i), new_ys[i])

```

### func: ec_mul_inner

- **[Lines 381-381](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g1.cairo#L381-L381)**

```python
memory[ap] = (ids.scalar % PRIME) % 2
```

## File: [src/bn254/fq.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo)

### func: add

- **[Lines 128-156](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L128-L156)**

```python
from src.bn254.hints import p, base as BASE, p_limbs
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

- **[Lines 222-250](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L222-L250)**

```python
from src.bn254.hints import p, base as BASE, p_limbs
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

### func: neg_full

- **[Lines 313-341](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L313-L341)**

```python
from src.bn254.hints import p, base as BASE, p_limbs
sub_limbs = [0 - getattr(getattr(ids, 'b'), 'd'+str(i)) for i in range(ids.N_LIMBS)]
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

- **[Lines 413-485](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L413-L485)**

```python
from starkware.cairo.common.math_utils import as_int
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
a,b,p=0,0,0
a_limbs, b_limbs, p_limbs = ids.N_LIMBS*[0], ids.N_LIMBS*[0], ids.N_LIMBS*[0]
def poly_mul(a:list, b:list,n=ids.N_LIMBS) -> list:
    assert len(a) == len(b) == n
    result = [0] * ids.N_LIMBS_UNREDUCED
    for i in range(n):
        for j in range(n):
            result[i+j] += a[i]*b[j]
    return result
def poly_mul_plus_c(a:list, b:list, c:list, n=ids.N_LIMBS) -> list:
    assert len(a) == len(b) == n
    result = [0] * ids.N_LIMBS_UNREDUCED
    for i in range(n):
        for j in range(n):
            result[i+j] += a[i]*b[j]
    for i in range(n):
        result[i] += c[i]
    return result
def poly_sub(a:list, b:list, n=ids.N_LIMBS_UNREDUCED) -> list:
    assert len(a) == len(b) == n
    result = [0] * n
    for i in range(n):
        result[i] = a[i] - b[i]
    return result
def abs_poly(x:list):
    result = [0] * len(x)
    for i in range(len(x)):
        result[i] = abs(x[i])
    return result
def reduce_zero_poly(x:list):
    x = x.copy()
    carries = [0] * (len(x)-1)
    for i in range(0, len(x)-1):
        carries[i] = x[i] // ids.BASE
        x[i] = x[i] % ids.BASE
        assert x[i] == 0
        x[i+1] += carries[i]
    assert x[-1] == 0
    return x, carries
for i in range(ids.N_LIMBS):
    a+=as_int(getattr(ids.a, 'd'+str(i)),PRIME) * ids.BASE**i
    b+=as_int(getattr(ids.b, 'd'+str(i)),PRIME) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
    a_limbs[i]=as_int(getattr(ids.a, 'd'+str(i)),PRIME)
    b_limbs[i]=as_int(getattr(ids.b, 'd'+str(i)),PRIME)
    p_limbs[i]=getattr(ids, 'P'+str(i))
mul = a*b
q, r = divmod(mul, p)
qs, rs = split(q), split(r)
for i in range(ids.N_LIMBS):
    setattr(ids.r, 'd'+str(i), rs[i])
    setattr(ids.q, 'd'+str(i), qs[i])
val_limbs = poly_mul(a_limbs, b_limbs)
q_P_plus_r_limbs = poly_mul_plus_c(qs, p_limbs, rs)
diff_limbs = poly_sub(q_P_plus_r_limbs, val_limbs)
_, carries = reduce_zero_poly(diff_limbs)
carries = abs_poly(carries)
for i in range(ids.N_LIMBS_UNREDUCED-1):
    setattr(ids, 'flag'+str(i), 1 if diff_limbs[i] >= 0 else 0)
    setattr(ids, 'q'+str(i), carries[i])

```

### func: mulf

- **[Lines 597-669](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L597-L669)**

```python
from starkware.cairo.common.math_utils import as_int
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
a,b,p=0,0,0
a_limbs, b_limbs, p_limbs = ids.N_LIMBS*[0], ids.N_LIMBS*[0], ids.N_LIMBS*[0]
def poly_mul(a:list, b:list,n=ids.N_LIMBS) -> list:
    assert len(a) == len(b) == n
    result = [0] * ids.N_LIMBS_UNREDUCED
    for i in range(n):
        for j in range(n):
            result[i+j] += a[i]*b[j]
    return result
def poly_mul_plus_c(a:list, b:list, c:list, n=ids.N_LIMBS) -> list:
    assert len(a) == len(b) == n
    result = [0] * ids.N_LIMBS_UNREDUCED
    for i in range(n):
        for j in range(n):
            result[i+j] += a[i]*b[j]
    for i in range(n):
        result[i] += c[i]
    return result
def poly_sub(a:list, b:list, n=ids.N_LIMBS_UNREDUCED) -> list:
    assert len(a) == len(b) == n
    result = [0] * n
    for i in range(n):
        result[i] = a[i] - b[i]
    return result
def abs_poly(x:list):
    result = [0] * len(x)
    for i in range(len(x)):
        result[i] = abs(x[i])
    return result
def reduce_zero_poly(x:list):
    x = x.copy()
    carries = [0] * (len(x)-1)
    for i in range(0, len(x)-1):
        carries[i] = x[i] // ids.BASE
        x[i] = x[i] % ids.BASE
        assert x[i] == 0
        x[i+1] += carries[i]
    assert x[-1] == 0
    return x, carries
for i in range(ids.N_LIMBS):
    a+=as_int(getattr(ids.a, 'd'+str(i)),PRIME) * ids.BASE**i
    b+=as_int(getattr(ids.b, 'd'+str(i)),PRIME) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
    a_limbs[i]=as_int(getattr(ids.a, 'd'+str(i)),PRIME)
    b_limbs[i]=as_int(getattr(ids.b, 'd'+str(i)),PRIME)
    p_limbs[i]=getattr(ids, 'P'+str(i))
mul = a*b
q, r = divmod(mul, p)
qs, rs = split(q), split(r)
for i in range(ids.N_LIMBS):
    setattr(ids.r, 'd'+str(i), rs[i])
    setattr(ids.q, 'd'+str(i), qs[i])
val_limbs = poly_mul(a_limbs, b_limbs)
q_P_plus_r_limbs = poly_mul_plus_c(qs, p_limbs, rs)
diff_limbs = poly_sub(q_P_plus_r_limbs, val_limbs)
_, carries = reduce_zero_poly(diff_limbs)
carries = abs_poly(carries)
for i in range(ids.N_LIMBS_UNREDUCED-1):
    setattr(ids, 'flag'+str(i), 1 if diff_limbs[i] >= 0 else 0)
    setattr(ids, 'q'+str(i), carries[i])

```

### func: inv

- **[Lines 851-868](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L851-L868)**

```python
from starkware.cairo.common.math_utils import as_int 
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
a,p=0,0
for i in range(ids.N_LIMBS):
    a+=as_int(getattr(ids.a, 'd'+str(i)), PRIME) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
inv = pow(a, -1, p)
invs = split(inv)
for i in range(ids.N_LIMBS):
    setattr(ids.inv, 'd'+str(i), invs[i])

```

### func: verify_zero3

- **[Lines 908-960](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L908-L960)**

```python
from starkware.cairo.common.math_utils import as_int
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
val, p=0,0
val_limbs, p_limbs = ids.N_LIMBS*[0], ids.N_LIMBS*[0]
def poly_sub(a:list, b:list, n=ids.N_LIMBS) -> list:
    assert len(a) == len(b) == n
    result = [0] * n
    for i in range(n):
        result[i] = a[i] - b[i]
    return result
def abs_poly(x:list):
    result = [0] * len(x)
    for i in range(len(x)):
        result[i] = abs(x[i])
    return result
def reduce_zero_poly(x:list):
    x = x.copy()
    carries = [0] * (len(x)-1)
    for i in range(0, len(x)-1):
        carries[i] = x[i] // ids.BASE
        x[i] = x[i] % ids.BASE
        assert x[i] == 0
        x[i+1] += carries[i]
    assert x[-1] == 0
    return x, carries
for i in range(ids.N_LIMBS):
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
    p_limbs[i]=getattr(ids, 'P'+str(i))
    val_limbs[i]+=as_int(getattr(ids.val, 'd'+str(i)), PRIME)
    val+=as_int(getattr(ids.val, 'd'+str(i)), PRIME) * ids.BASE**i
mul = val
q, r = divmod(mul, p)
assert r == 0, f"verify_zero: Invalid input."
ids.q = q
q_P_limbs = [q*P for P in p_limbs]
diff_limbs = poly_sub(q_P_limbs, val_limbs)
_, carries = reduce_zero_poly(diff_limbs)
carries = abs_poly(carries)
for i in range(ids.N_LIMBS-1):
    setattr(ids, 'flag'+str(i), 1 if diff_limbs[i] >= 0 else 0)
    setattr(ids, 'q'+str(i), carries[i])

```

### func: verify_zero5

- **[Lines 1000-1064](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L1000-L1064)**

```python
from starkware.cairo.common.math_utils import as_int
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
val, p=0,0
val_limbs, p_limbs = ids.N_LIMBS_UNREDUCED*[0], ids.N_LIMBS*[0]
def poly_mul(a:list, b:list,n=ids.N_LIMBS) -> list:
    assert len(a) == len(b) == n
    result = [0] * ids.N_LIMBS_UNREDUCED
    for i in range(n):
        for j in range(n):
            result[i+j] += a[i]*b[j]
    return result
def poly_sub(a:list, b:list, n=ids.N_LIMBS_UNREDUCED) -> list:
    assert len(a) == len(b) == n
    result = [0] * n
    for i in range(n):
        result[i] = a[i] - b[i]
    return result
def abs_poly(x:list):
    result = [0] * len(x)
    for i in range(len(x)):
        result[i] = abs(x[i])
    return result
def reduce_zero_poly(x:list):
    x = x.copy()
    carries = [0] * (len(x)-1)
    for i in range(0, len(x)-1):
        carries[i] = x[i] // ids.BASE
        x[i] = x[i] % ids.BASE
        assert x[i] == 0
        x[i+1] += carries[i]
    assert x[-1] == 0
    return x, carries
for i in range(ids.N_LIMBS_UNREDUCED):
    val_limbs[i]+=as_int(getattr(ids.val, 'd'+str(i)), PRIME)
    val+=as_int(getattr(ids.val, 'd'+str(i)), PRIME) * ids.BASE**i
for i in range(ids.N_LIMBS):
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
    p_limbs[i]=getattr(ids, 'P'+str(i))
mul = val
q, r = divmod(mul, p)
assert r == 0, f"verify_zero: Invalid input."
qs = split(q)
for i in range(ids.N_LIMBS):
    setattr(ids.q, 'd'+str(i), qs[i])
q_P_limbs = poly_mul(qs, p_limbs)
diff_limbs = poly_sub(q_P_limbs, val_limbs)
_, carries = reduce_zero_poly(diff_limbs)
carries = abs_poly(carries)
for i in range(ids.N_LIMBS_UNREDUCED-1):
    setattr(ids, 'flag'+str(i), 1 if diff_limbs[i] >= 0 else 0)
    setattr(ids, 'q'+str(i), carries[i])

```

### func: reduce_5

- **[Lines 1222-1240](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L1222-L1240)**

```python
from starkware.cairo.common.math_utils import as_int
from src.bn254.hints import reduce_hint
val_limbs = ids.N_LIMBS_UNREDUCED*[0]
for i in range(ids.N_LIMBS_UNREDUCED):
    val_limbs[i]=as_int(getattr(ids.val, 'd'+str(i)), PRIME)
qs, rs, flags, carries = reduce_hint(val_limbs)
for i in range(ids.N_LIMBS):
    setattr(ids.r, 'd'+str(i), rs[i])
    setattr(ids.q, 'd'+str(i), qs[i])
for i in range(ids.N_LIMBS_UNREDUCED-1):
    setattr(ids, 'flag'+str(i), flags[i])
    setattr(ids, 'q'+str(i), carries[i])

```

### func: reduce_5_full

- **[Lines 1426-1444](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L1426-L1444)**

```python
from starkware.cairo.common.math_utils import as_int
from src.bn254.hints import reduce_hint
val_limbs = ids.N_LIMBS_UNREDUCED*[0]
for i in range(ids.N_LIMBS_UNREDUCED):
    val_limbs[i]=as_int(getattr(ids.val, 'd'+str(i)), PRIME)
qs, rs, flags, carries = reduce_hint(val_limbs)
for i in range(ids.N_LIMBS):
    setattr(ids, 'r_d'+str(i), rs[i])
    setattr(ids, 'q_d'+str(i), qs[i])
for i in range(ids.N_LIMBS_UNREDUCED-1):
    setattr(ids, 'flag'+str(i), flags[i])
    setattr(ids, 'q'+str(i), carries[i])

```

### func: reduce_3

- **[Lines 1602-1620](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L1602-L1620)**

```python
from starkware.cairo.common.math_utils import as_int
from src.bn254.hints import reduce3_hint
val_limbs = ids.N_LIMBS*[0]
for i in range(ids.N_LIMBS):
    val_limbs[i]+=as_int(getattr(ids.val, 'd'+str(i)), PRIME)
q, rs, flags, carries = reduce3_hint(val_limbs)
ids.q = q
for i in range(ids.N_LIMBS):
    setattr(ids.r, 'd'+str(i), rs[i])
for i in range(ids.N_LIMBS-1):
    setattr(ids, 'flag'+str(i), flags[i])
    setattr(ids, 'q'+str(i), carries[i])

```

### func: reduce_3_full

- **[Lines 1701-1719](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/fq.cairo#L1701-L1719)**

```python
from starkware.cairo.common.math_utils import as_int
from src.bn254.hints import reduce3_hint
val_limbs = ids.N_LIMBS*[0]
for i in range(ids.N_LIMBS):
    val_limbs[i]+=as_int(getattr(ids.val, 'd'+str(i)), PRIME)
q, rs, flags, carries = reduce3_hint(val_limbs)
ids.q = q
for i in range(ids.N_LIMBS):
    setattr(ids.r, 'd'+str(i), rs[i])
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

- **[Lines 70-104](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo#L70-L104)**

```python
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
x,y,p=[0,0],[0,0],0
for i in range(ids.N_LIMBS):
    x[0]+=getattr(ids.pt.x.a0, 'd'+str(i)) * ids.BASE**i
    x[1]+=getattr(ids.pt.x.a1, 'd'+str(i)) * ids.BASE**i
    y[0]+=getattr(ids.pt.y.a0, 'd'+str(i)) * ids.BASE**i
    y[1]+=getattr(ids.pt.y.a1, 'd'+str(i)) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
def mul_e2(x:(int,int), y:(int,int)):
    a = (x[0] + x[1]) * (y[0] + y[1]) % p
    b, c  = x[0]*y[0] % p, x[1]*y[1] % p
    return (b - c) % p, (a - b - c) % p
def scalar_mul_e2(n:int, y:(int, int)):
    return (n*y[0]%p, n*y[1] % p)
def inv_e2(a:(int, int)):
    t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
    t0 = (t0 + t1) % p
    t1 = pow(t0, -1, p)
    return a[0] * t1 % p, -(a[1] * t1) % p
num=scalar_mul_e2(3, mul_e2(x,x))
sub=scalar_mul_e2(2,y)
sub_inv= inv_e2(sub)
value = mul_e2(num, sub_inv)
value_split = [split(value[0]), split(value[1])]
for i in range(ids.N_LIMBS):
    setattr(ids.slope_a0, 'd'+str(i), value_split[0][i])
    setattr(ids.slope_a1, 'd'+str(i), value_split[1][i])

```

### func: compute_slope

- **[Lines 152-191](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo#L152-L191)**

```python
from src.hints import split
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
x0,y0,x1,y1,p=[0,0],[0,0],[0,0],[0,0],0
for i in range(ids.N_LIMBS):
    x0[0]+=getattr(ids.pt0.x.a0,'d'+str(i)) * ids.BASE**i
    x0[1]+=getattr(ids.pt0.x.a1,'d'+str(i)) * ids.BASE**i
    y0[0]+=getattr(ids.pt0.y.a0,'d'+str(i)) * ids.BASE**i
    y0[1]+=getattr(ids.pt0.y.a1,'d'+str(i)) * ids.BASE**i
    x1[0]+=getattr(ids.pt1.x.a0,'d'+str(i)) * ids.BASE**i
    x1[1]+=getattr(ids.pt1.x.a1,'d'+str(i)) * ids.BASE**i
    y1[0]+=getattr(ids.pt1.y.a0,'d'+str(i)) * ids.BASE**i
    y1[1]+=getattr(ids.pt1.y.a1,'d'+str(i)) * ids.BASE**i
    p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
def mul_e2(x:(int,int), y:(int,int)):
    a = (x[0] + x[1]) * (y[0] + y[1]) % p
    b, c  = x[0]*y[0] % p, x[1]*y[1] % p
    return (b - c) % p, (a - b - c) % p
def sub_e2(x:(int,int), y:(int,int)):
    return (x[0]-y[0]) % p, (x[1]-y[1]) % p
def inv_e2(a:(int, int)):
    t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
    t0 = (t0 + t1) % p
    t1 = pow(t0, -1, p)
    return a[0] * t1 % p, -(a[1] * t1) % p
sub = sub_e2(x0,x1)
sub_inv = inv_e2(sub)
numerator = sub_e2(y0,y1)
value=mul_e2(numerator,sub_inv)
value_split = [split(value[0]), split(value[1])]
for i in range(ids.N_LIMBS):
    setattr(ids.slope_a0, 'd'+str(i), value_split[0][i])
    setattr(ids.slope_a1, 'd'+str(i), value_split[1][i])

```

### func: get_g2_generator

- **[Lines 426-447](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo#L426-L447)**

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

- **[Lines 460-492](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/g2.cairo#L460-L492)**

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

- **[Lines 111-152](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L111-L152)**

```python
import numpy as np
from tools.py.extension_trick import w_to_gnark
def print_e4(id):
    le=[]
    le+=[id.r0.a0.d0 + id.r0.a0.d1 * 2**86 + id.r0.a0.d2 * 2**172]
    le+=[id.r0.a1.d0 + id.r0.a1.d1 * 2**86 + id.r0.a1.d2 * 2**172]
    le+=[id.r1.a0.d0 + id.r1.a0.d1 * 2**86 + id.r1.a0.d2 * 2**172]
    le+=[id.r1.a1.d0 + id.r1.a1.d1 * 2**86 + id.r1.a1.d2 * 2**172]
    [print('e'+str(i), np.base_repr(le[i],36)) for i in range(4)]
def print_e12(id):
    le=[]
    le+=[id.c0.b0.a0.d0 + id.c0.b0.a0.d1 * 2**86 + id.c0.b0.a0.d2 * 2**172]
    le+=[id.c0.b0.a1.d0 + id.c0.b0.a1.d1 * 2**86 + id.c0.b0.a1.d2 * 2**172]
    le+=[id.c0.b1.a0.d0 + id.c0.b1.a0.d1 * 2**86 + id.c0.b1.a0.d2 * 2**172]
    le+=[id.c0.b1.a1.d0 + id.c0.b1.a1.d1 * 2**86 + id.c0.b1.a1.d2 * 2**172]
    le+=[id.c0.b2.a0.d0 + id.c0.b2.a0.d1 * 2**86 + id.c0.b2.a0.d2 * 2**172]
    le+=[id.c0.b2.a1.d0 + id.c0.b2.a1.d1 * 2**86 + id.c0.b2.a1.d2 * 2**172]
    le+=[id.c1.b0.a0.d0 + id.c1.b0.a0.d1 * 2**86 + id.c1.b0.a0.d2 * 2**172]
    le+=[id.c1.b0.a1.d0 + id.c1.b0.a1.d1 * 2**86 + id.c1.b0.a1.d2 * 2**172]
    le+=[id.c1.b1.a0.d0 + id.c1.b1.a0.d1 * 2**86 + id.c1.b1.a0.d2 * 2**172]
    le+=[id.c1.b1.a1.d0 + id.c1.b1.a1.d1 * 2**86 + id.c1.b1.a1.d2 * 2**172]
    le+=[id.c1.b2.a0.d0 + id.c1.b2.a0.d1 * 2**86 + id.c1.b2.a0.d2 * 2**172]
    le+=[id.c1.b2.a1.d0 + id.c1.b2.a1.d1 * 2**86 + id.c1.b2.a1.d2 * 2**172]
    [print('e'+str(i), np.base_repr(le[i],36)) for i in range(12)]
def print_G2(id):
    x0 = id.x.a0.d0 + id.x.a0.d1 * 2**86 + id.x.a0.d2 * 2**172
    x1 = id.x.a1.d0 + id.x.a1.d1 * 2**86 + id.x.a1.d2 * 2**172
    y0 = id.y.a0.d0 + id.y.a0.d1 * 2**86 + id.y.a0.d2 * 2**172
    y1 = id.y.a1.d0 + id.y.a1.d1 * 2**86 + id.y.a1.d2 * 2**172
    print(f"X={np.base_repr(x0,36).lower()} + {np.base_repr(x1,36).lower()}*u")
    print(f"Y={np.base_repr(y0,36).lower()} + {np.base_repr(y1,36).lower()}*u")
def print_e12f_to_gnark(id, name):
    val = 12*[0]
    refs=[id.w0, id.w1, id.w2, id.w3, id.w4, id.w5, id.w6, id.w7, id.w8, id.w9, id.w10, id.w11]
    for i in range(ids.N_LIMBS):
        for k in range(12):
            val[k]+=as_int(getattr(refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
    print(name, w_to_gnark(val))

```

- **[Lines 184-217](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L184-L217)**

```python
from tools.py.pairing_curves.bn254.multi_miller import multi_miller_loop, G1Point, G2Point, E2
n_points = ids.n_points
P_arr = [[0, 0] for _ in range(n_points)]
Q_arr = [([0, 0], [0, 0]) for _ in range(n_points)]
for i in range(n_points):
    P_pt_ptr = memory[ids.P+i]
    Q_pt_ptr = memory[ids.Q+i]
    P_x_ptr = memory[P_pt_ptr]
    P_y_ptr = memory[P_pt_ptr+1]
    Q_x_ptr = memory[Q_pt_ptr]
    Q_y_ptr = memory[Q_pt_ptr+1]
    Q_x_a0_ptr = memory[Q_x_ptr]
    Q_x_a1_ptr = memory[Q_x_ptr+1]
    Q_y_a0_ptr = memory[Q_y_ptr]
    Q_y_a1_ptr = memory[Q_y_ptr+1]
    for k in range(ids.N_LIMBS):
        P_arr[i][0] = P_arr[i][0] + as_int(memory[P_x_ptr+k], PRIME) * ids.BASE**k
        P_arr[i][1] = P_arr[i][1] + as_int(memory[P_y_ptr+k], PRIME) * ids.BASE**k
        Q_arr[i][0][0] = Q_arr[i][0][0] + as_int(memory[Q_x_a0_ptr+k], PRIME) * ids.BASE**k
        Q_arr[i][0][1] = Q_arr[i][0][1] + as_int(memory[Q_x_a1_ptr+k], PRIME) * ids.BASE**k
        Q_arr[i][1][0] = Q_arr[i][1][0] + as_int(memory[Q_y_a0_ptr+k], PRIME) * ids.BASE**k
        Q_arr[i][1][1] = Q_arr[i][1][1] + as_int(memory[Q_y_a1_ptr+k], PRIME) * ids.BASE**k
P_arr = [G1Point(*P) for P in P_arr]
Q_arr = [G2Point(E2(*Q[0]), E2(*Q[1])) for Q in Q_arr]
#print(P_arr)
#print(Q_arr)
print("Pre-computing miller loop hash commitment Z = poseidon('GaragaBN254MillerLoop', [(A1, B1, Q1, R1), ..., (An, Bn, Qn, Rn)])")
x, Z = multi_miller_loop(P_arr, Q_arr, ids.n_points, ids.continuable_hash)
Z_bigint3 = split(Z)
ids.Z.d0, ids.Z.d1, ids.Z.d2 = Z_bigint3[0], Z_bigint3[1], Z_bigint3[2]

```

- **[Lines 246-246](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L246-L246)**

```python
print(f"HASH : {ids.continuable_hash}")
```

- **[Lines 248-248](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L248-L248)**

```python
print("Verifying Miller Loop hash commitment Z = continuable_hash ... ")
```

- **[Lines 252-252](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L252-L252)**

```python
print("Verifying Σc_i*A_i(z)*B_i(z) == P(z)Σc_i*Q_i(z) + Σc_i*R_i(z)")
```

- **[Lines 378-378](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L378-L378)**

```python
print("Ok! \n")
```

- **[Lines 381-384](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L381-L384)**

```python
//     print("RESFINALMILLERLOOP:")
//     print_e12(ids.res_gnark)

```

### func: multi_miller_loop_inner

- **[Lines 460-460](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L460-L460)**

```python
print(f"index = {ids.bit_index}, bit = {ids.bit_index}, offset = {ids.offset}")
```

- **[Lines 474-474](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L474-L474)**

```python
print(f"index = {ids.bit_index}, bit = {ids.bit}, offset = {ids.offset}")
```

### func: final_exponentiation

- **[Lines 827-843](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L827-L843)**

```python
from tools.py.pairing_curves.bn254.final_exp import final_exponentiation
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

- **[Lines 976-976](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L976-L976)**

```python
print(f"hash={ids.continuable_hash}")
```

- **[Lines 979-979](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L979-L979)**

```python
print(f"Verifying final exponentiation hash commitment Z = continuable_hash")
```

- **[Lines 983-983](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L983-L983)**

```python
print(f"Verifying Σc_i*A_i(z)*B_i(z) == P(z)Σc_i*Q_i(z) + Σc_i*R_i(z)")
```

- **[Lines 1024-1024](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/pairing.cairo#L1024-L1024)**

```python
print(f"Ok!")
```

## File: [src/bn254/towers/e6.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo)

### func: mul_trick_e6

- **[Lines 115-158](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo#L115-L158)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
from starkware.cairo.common.cairo_secp.secp_utils import split
from tools.make.utils import split_128
from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v, mul_e6, pack_e6
p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
field = BaseField(p)
x=[0]*6
y=[0]*6
x_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
y_refs = [ids.y.v0, ids.y.v1, ids.y.v2, ids.y.v3, ids.y.v4, ids.y.v5]
for i in range(ids.N_LIMBS):
    for k in range(6):
        x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        y[k] += as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
x_poly = Polynomial([BaseFieldElement(x[i], field) for i in range(6)])
y_poly = Polynomial([BaseFieldElement(y[i], field) for i in range(6)])
z_poly = x_poly * y_poly
# v^6 - 18v^3 + 82 
coeffs = [BaseFieldElement(82, field), field.zero(), field.zero(), BaseFieldElement(-18%p, field), field.zero(), field.zero(), field.one()]
unreducible_poly=Polynomial(coeffs)
z_polyr=z_poly % unreducible_poly
z_polyq=z_poly // unreducible_poly
z_polyr_coeffs = z_polyr.get_coeffs()
z_polyq_coeffs = z_polyq.get_coeffs()
assert len(z_polyq_coeffs) <= 5, f"len z_polyq_coeffs={len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
assert len(z_polyr_coeffs) <= 6, f"len z_polyr_coeffs={len(z_polyr_coeffs)}, degree: {z_polyr.degree()}"
z_polyq_coeffs = z_polyq_coeffs + [0] * (5 - len(z_polyq_coeffs))
z_polyr_coeffs = z_polyr_coeffs + [0] * (6 - len(z_polyr_coeffs))
x_gnark = pack_e6(v_to_gnark(x))
y_gnark = pack_e6(v_to_gnark(y))
xy_gnark = flatten(mul_e6(x_gnark, y_gnark))
assert z_polyr_coeffs == gnark_to_v(xy_gnark), f"z_polyr_coeffs: {z_polyr_coeffs}, xy_gnark: {xy_gnark}"
for i in range(6):
    val = split(z_polyr_coeffs[i]%p)
    for k in range(ids.N_LIMBS):
        rsetattr(ids.r_v, f'v{i}.d{k}', val[k])
for i in range(5):
    val = split_128(z_polyq_coeffs[i]%p)
    rsetattr(ids.q_v, f'v{i}.low', val[0])
    rsetattr(ids.q_v, f'v{i}.high', val[1])

```

### func: div_trick_e6

- **[Lines 508-528](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo#L508-L528)**

```python
from starkware.cairo.common.math_utils import as_int
from src.bn254.hints import split
from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v, div_e6, pack_e6
x, y=6*[0], 6*[0]
x_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
y_refs = [ids.y.v0, ids.y.v1, ids.y.v2, ids.y.v3, ids.y.v4, ids.y.v5]
for i in range(ids.N_LIMBS):
    for k in range(6):
        x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        y[k] += as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
x_gnark, y_gnark = pack_e6(v_to_gnark(x)), pack_e6(v_to_gnark(y))
z = flatten(div_e6(x_gnark, y_gnark))
z = gnark_to_v(z)
e = [split(x) for x in z]
                                              
for i in range(6):
    for k in range(ids.N_LIMBS):
        setattr(ids, f'div_v{i}d{k}', e[i][k])

```

### func: square_torus

- **[Lines 1056-1072](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo#L1056-L1072)**

```python
from starkware.cairo.common.math_utils import as_int
from src.bn254.hints import square_torus_e6, split
from tools.py.extension_trick import flatten, v_to_gnark, gnark_to_v
x=6*[0]
x_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
for i in range(ids.N_LIMBS):
    for k in range(6):
        x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
x_gnark = v_to_gnark(x)
z = flatten(square_torus_e6(x_gnark))
e = [split(x) for x in gnark_to_v(z)]
for i in range(6):
    for k in range(ids.N_LIMBS):
        rsetattr(ids.sq, f'v{i}.d{k}', e[i][k])

```

- **[Lines 1081-1114](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e6.cairo#L1081-L1114)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
from starkware.cairo.common.cairo_secp.secp_utils import split
from tools.make.utils import split_128
p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
field = BaseField(p)
x=[0]*6
y=[0]*6
x_refs = [ids.v_tmp.v0, ids.v_tmp.v1, ids.v_tmp.v2, ids.v_tmp.v3, ids.v_tmp.v4, ids.v_tmp.v5]
y_refs = [ids.x.v0, ids.x.v1, ids.x.v2, ids.x.v3, ids.x.v4, ids.x.v5]
for i in range(ids.N_LIMBS):
    for k in range(6):
        x[k] += as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        y[k] += as_int(getattr(y_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
x_poly = Polynomial([BaseFieldElement(x[i], field) for i in range(6)])
y_poly = Polynomial([BaseFieldElement(y[i], field) for i in range(6)])
z_poly = x_poly * y_poly
# v^6 - 18v^3 + 82 
coeffs = [BaseFieldElement(82, field), field.zero(), field.zero(), BaseFieldElement(-18%p, field), field.zero(), field.zero(), field.one()]
unreducible_poly=Polynomial(coeffs)
z_polyr=z_poly % unreducible_poly
z_polyq=z_poly // unreducible_poly
z_polyr_coeffs = z_polyr.get_coeffs()
z_polyq_coeffs = z_polyq.get_coeffs()
assert len(z_polyq_coeffs) <= 5, f"len z_polyq_coeffs={len(z_polyq_coeffs)}, degree: {z_polyq.degree()}"
assert len(z_polyr_coeffs) <= 6, f"len z_polyr_coeffs={len(z_polyr_coeffs)}, degree: {z_polyr.degree()}"
z_polyq_coeffs = z_polyq_coeffs + [0] * (5 - len(z_polyq_coeffs))
z_polyr_coeffs = z_polyr_coeffs + [0] * (6 - len(z_polyr_coeffs))
for i in range(5):
    val = split_128(z_polyq_coeffs[i]%p)
    rsetattr(ids.q_v, f'v{i}.low', val[0])
    rsetattr(ids.q_v, f'v{i}.high', val[1])

```

## File: [src/bn254/towers/e2.cairo](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e2.cairo)

### func: inv

- **[Lines 94-111](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e2.cairo#L94-L111)**

```python
from starkware.cairo.common.math_utils import as_int
from src.bn254.hints import split, inv_e2   
assert 1 < ids.N_LIMBS <= 12
assert ids.DEGREE == ids.N_LIMBS-1
a0,a1=0,0
for i in range(ids.N_LIMBS):
    a0+=as_int(getattr(ids.x.a0, 'd'+str(i)), PRIME) * ids.BASE**i
    a1+=as_int(getattr(ids.x.a1, 'd'+str(i)), PRIME) * ids.BASE**i
inverse0, inverse1 = inv_e2((a0, a1))
inv0, inv1 =split(inverse0), split(inverse1)
for i in range(ids.N_LIMBS):
    setattr(ids.inv0, 'd'+str(i),  inv0[i])
    setattr(ids.inv1, 'd'+str(i),  inv1[i])

```

### func: div

- **[Lines 127-161](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e2.cairo#L127-L161)**

```python
from starkware.cairo.common.math_utils import as_int    
from src.hints import split
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

- **[Lines 165-211](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L165-L211)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
from starkware.cairo.common.cairo_secp.secp_utils import split
from tools.make.utils import split_128
p=0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
field = BaseField(p)
x=12*[0]
x_refs=[ids.x.w0, ids.x.w1, ids.x.w2, ids.x.w3, ids.x.w4, ids.x.w5, ids.x.w6, ids.x.w7, ids.x.w8, ids.x.w9, ids.x.w10, ids.x.w11]
for i in range(ids.N_LIMBS):
    for k in range(12):
        x[k]+=as_int(getattr(x_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
x_poly=Polynomial([BaseFieldElement(x[i], field) for i in range(12)])
z_poly=x_poly*x_poly
coeffs = [
BaseFieldElement(82, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
BaseFieldElement(-18 % p, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.one(),]
unreducible_poly=Polynomial(coeffs)
z_polyr=z_poly % unreducible_poly
z_polyq=z_poly // unreducible_poly
z_polyr_coeffs = z_polyr.get_coeffs()
z_polyq_coeffs = z_polyq.get_coeffs()
assert len(z_polyq_coeffs)<=11
# extend z_polyq with 0 to make it len 11:
z_polyq_coeffs = z_polyq_coeffs + (11-len(z_polyq_coeffs))*[0]
# extend z_polyr with 0 to make it len 12:
z_polyr_coeffs = z_polyr_coeffs + (12-len(z_polyr_coeffs))*[0]
for i in range(12):
    val = split(z_polyr_coeffs[i]%p)
    for k in range(ids.N_LIMBS):
        rsetattr(ids.r_w, f'w{i}.d{k}', val[k])
for i in range(11):
    val = split_128(z_polyq_coeffs[i]%p)
    rsetattr(ids.q_w, f'w{i}.low', val[0])
    rsetattr(ids.q_w, f'w{i}.high', val[1])

```

### func: mul034

- **[Lines 717-771](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L717-L771)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
#from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
from starkware.cairo.common.cairo_secp.secp_utils import split
from tools.make.utils import split_128
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
coeffs = [
BaseFieldElement(82, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
BaseFieldElement(-18 % p, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.one(),]
unreducible_poly=Polynomial(coeffs)
z_polyr=z_poly % unreducible_poly
z_polyq=z_poly // unreducible_poly
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

- **[Lines 1320-1387](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L1320-L1387)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
from starkware.cairo.common.cairo_secp.secp_utils import split
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
#print(f"mul034034 res degree : {z_poly.degree()}")
#print(f"Z_Poly: {z_poly.get_coeffs()}")
coeffs = [
BaseFieldElement(82, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
BaseFieldElement(-18 % p, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.one(),]
unreducible_poly=Polynomial(coeffs)
z_polyr=z_poly % unreducible_poly
z_polyq=z_poly // unreducible_poly
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

- **[Lines 1799-1860](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L1799-L1860)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
#from tools.py.extension_trick import w_to_gnark, gnark_to_w, flatten, pack_e12, mul_e12_gnark
from starkware.cairo.common.cairo_secp.secp_utils import split
from tools.make.utils import split_128
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
coeffs = [
BaseFieldElement(82, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
BaseFieldElement(-18 % p, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.one(),]
unreducible_poly=Polynomial(coeffs)
z_polyr=z_poly % unreducible_poly
z_polyq=z_poly // unreducible_poly
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
    val = split_128(z_polyq_coeffs[i]%p)
    rsetattr(ids.q_w, f'w{i}.low', val[0])
    rsetattr(ids.q_w, f'w{i}.high', val[1])

```

### func: mul_trick_pure

- **[Lines 2503-2562](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L2503-L2562)**

```python
from tools.py.polynomial import Polynomial
from tools.py.field import BaseFieldElement, BaseField
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
coeffs = [
BaseFieldElement(82, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
BaseFieldElement(-18 % p, field),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.zero(),
field.one(),]
unreducible_poly=Polynomial(coeffs)
z_polyr=z_poly % unreducible_poly
z_polyq=z_poly // unreducible_poly
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

- **[Lines 3424-3447](https://github.com/keep-starknet-strange/garaga/blob/main/src/bn254/towers/e12.cairo#L3424-L3447)**

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

