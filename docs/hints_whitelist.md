# src/bn254/fq.cairo
### fq_bigint3.add()  
#L202-L230
```python
%{
    P0, P1, P2, BASE = ids.P0, ids.P1, ids.P2, ids.BASE
    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

    sum_low=ids.a.d0 + ids.b.d0
    sum_mid=ids.a.d1 + ids.b.d1
    sum_high=ids.a.d2 + ids.b.d2

    sum_low_reduced =(sum_low-P0)
    sum_mid_reduced = (sum_mid-P1)
    sum_high_reduced = (sum_high-P2)

    has_carry_low = 1 if sum_low >= BASE else 0
    has_carry_mid = 1 if (sum_mid + has_carry_low) >= BASE else 0
    needs_reduction = 1 if (sum_low + sum_mid*2**86+sum_high*2**172) >= p else 0

    has_borrow_carry_reduced_low = -1 if sum_low_reduced < 0 else (1 if sum_low_reduced>=BASE else 0)

    has_borrow_reduced_low = 1 if sum_low_reduced < 0 else 0
    has_borrow_reduced_mid = 1 if (sum_mid_reduced + has_borrow_carry_reduced_low) < 0 else 0

    has_carry_reduced_low= 1 if sum_low_reduced>=BASE else 0 
    has_carry_reduced_mid= 1 if (sum_mid_reduced+has_borrow_carry_reduced_low) >= BASE else 0

    memory[ap] = has_carry_low if needs_reduction==0 else has_borrow_reduced_low # ap -5
    memory[ap+1] = has_carry_mid if needs_reduction==0 else has_borrow_reduced_mid # ap - 4 
    memory[ap+2] = needs_reduction # != 0 <=> sum >= P =>  needs to remove P # ap - 3
    memory[ap+3] = has_carry_reduced_low # ap-2
    memory[ap+4] = has_carry_reduced_mid # ap-1
%}
```

### fq_bigint3.sub()
#L364-L390
```python
%{
    P0, P1, P2, BASE = ids.P0, ids.P1, ids.P2, ids.BASE

    sub_low=ids.a.d0 - ids.b.d0
    sub_mid=ids.a.d1 - ids.b.d1
    sub_high=ids.a.d2 - ids.b.d2

    sub_low_reduced =(P0 + sub_low)
    sub_mid_reduced = (P1 + sub_mid)
    sub_high_reduced = (P2 + sub_high)

    has_borrow_low = 1 if sub_low < 0 else 0
    has_borrow_mid = 1 if (sub_mid - has_borrow_low) < 0 else 0
    has_borrow_high = 1 if (sub_high - has_borrow_mid) < 0 else 0

    has_borrow_carry_reduced_low = -1 if sub_low_reduced < 0 else (1 if sub_low_reduced>=ids.BASE else 0)

    has_borrow_reduced_low = 1 if sub_low_reduced < 0 else 0
    has_borrow_reduced_mid = 1 if (sub_mid_reduced + has_borrow_carry_reduced_low) < 0 else 0

    has_carry_reduced_low= 1 if sub_low_reduced>=ids.BASE else 0 
    has_carry_reduced_mid= 1 if (sub_mid_reduced+has_borrow_carry_reduced_low) >= ids.BASE else 0

    memory[ap] = has_borrow_low if has_borrow_high==0 else has_borrow_reduced_low # ap -5
    memory[ap+1] = has_borrow_mid if has_borrow_high==0 else has_borrow_reduced_mid # ap - 4 
    memory[ap+2] = has_borrow_high # != 0 <=> sub < 0 =>  needs to add P # ap - 3
    memory[ap+3] = has_carry_reduced_low # ap-2
    memory[ap+4] = has_carry_reduced_mid # ap-1
%}
```

### fq_bigint3.mul()    
#L524-L536  
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import split
    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * (ids.b.d0 + ids.b.d1*2**86 + ids.b.d2*2**172)

    q, r = mul//p, mul%p

    ids.r = segments.gen_arg(split(r))
    q_split = split(q)
    ids.q.d0 = q_split[0]
    ids.q.d1 = q_split[1]
    ids.q.d2 = q_split[2]
%}
```
### fq_bigint3.mul_by_9()  
#L587-L595  
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import split
    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * 9
    q, r = mul//p, mul%p

    ids.r = segments.gen_arg(split(r))
    ids.q = q
%}
```
### fq_bigint3.mul_by_10()  
#L621-L629  
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import split
    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    mul = (ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172) * 10
    q, r = mul//p, mul%p

    ids.r = segments.gen_arg(split(r))
    ids.q = q
%}
```


### fq_bigint3.inv()  
#L662-L671  
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import split

    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    value = inv = pow(ids.a.d0 + ids.a.d1*2**86 + ids.a.d2*2**172, -1, p)
    s = split(inv)
    ids.inv.d0 = s[0]
    ids.inv.d1 = s[1]
    ids.inv.d2 = s[2]
%}
```


### verify_zero3()  
#L726-L736  
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack
    from starkware.cairo.common.math_utils import as_int

    P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

    v = pack(ids.val, PRIME) 
    q, r = divmod(v, P)
    assert r == 0, f"verify_zero: Invalid input {ids.val.d0, ids.val.d1, ids.val.d2}."
    ids.q = q
%}

```

### verify_zero5()  
#L756-L768  
```python
%{
    from starkware.cairo.common.math_utils import as_int

    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    val = as_int(ids.val.d0, PRIME) + as_int(ids.val.d1, PRIME)*2**86 + as_int(ids.val.d2,PRIME)*2**172 + as_int(ids.val.d3, PRIME)*2**258 + as_int(ids.val.d4, PRIME)*2**344

    q, r = val//p,val%p
    assert r == 0, f"verify_zero: Invalid input {ids.val.d0, ids.val.d1, ids.val.d2, ids.val.d3, ids.val.d4}."

    ids.q.d2 = q//2**172
    ids.q.d1 = (q%2**172)//2**86
    ids.q.d0 = (q%2**172)%2**86
%}

```
### is_zero()  
#L851-L855

```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack
    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    x = pack(ids.x, PRIME) % p
%}
```

```python
%{
    from starkware.python.math_utils import div_mod
    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    value = x_inv = div_mod(1, x, p)
%}

```


# src/bn254/g1.cairo

### g1.compute_doubling_slope()
#L55-L64

```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack
    from starkware.python.math_utils import div_mod

    P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

    x = pack(ids.pt.x, PRIME)
    y = pack(ids.pt.y, PRIME)
    value = slope = div_mod(3 * x ** 2, 2 * y, P)
%}
```

### g1.compute_slope()
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack
    from starkware.python.math_utils import div_mod

    P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    x0 = pack(ids.pt0.x, PRIME)
    y0 = pack(ids.pt0.y, PRIME)
    x1 = pack(ids.pt1.x, PRIME)
    y1 = pack(ids.pt1.y, PRIME)
    value = slope = div_mod(y0 - y1, x0 - x1, P)
%}
```
### g1.double()
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack

    P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    slope = pack(ids.slope, PRIME)
    x = pack(ids.pt.x, PRIME)
    y = pack(ids.pt.y, PRIME)

    value = new_x = (pow(slope, 2, P) - 2 * x) % P
%}
```

```python
%{ value = new_y = (slope * (x - new_x) - y) % P %}
```

### g1.fast_ec_add()
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack

    P = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    slope = pack(ids.slope, PRIME)
    x0 = pack(ids.pt0.x, PRIME)
    x1 = pack(ids.pt1.x, PRIME)
    y0 = pack(ids.pt0.y, PRIME)

    value = new_x = (pow(slope, 2, P) - x0 - x1) % P
%}
```

```python
%{ value = new_y = (slope * (x0 - new_x) - y0) % P %}
```


# src/bn254/g2.cairo

### g2.assert_on_curve()
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import split
    ids.b20 = segments.gen_arg(split(19485874751759354771024239261021720505790618469301721065564631296452457478373))
    ids.b21 = segments.gen_arg(split(266929791119991161246907387137283842545076965332900288569378510910307636690))
%}
```
### g2.compute_doubling_slope()
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack, split

    p= 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    def parse_e2(x):
        return [pack(x.a0, PRIME), pack(x.a1, PRIME)]

    x = parse_e2(ids.pt.x)
    y = parse_e2(ids.pt.y)

    def mul_e2(x:(int,int), y:(int,int)):
        a = (x[0] + x[1]) * (y[0] + y[1]) % p
        b, c  = x[0]*y[0] % p, x[1]*y[1] % p
        return (b - c) % p, (a - b - c) % p
    def scalar_mul_e2(n:int, y:(int, int)):
        a = (y[0] + y[1]) * n % p
        b = y[0]*n % p
        return (b, (a - b) % p)
    def inv_e2(a:(int, int)):
        t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
        t0 = (t0 + t1) % p
        t1 = pow(t0, -1, p)
        return a[0] * t1 % p, -(a[1] * t1) % p
    num=scalar_mul_e2(3, mul_e2(x,x))
    sub=scalar_mul_e2(2,y)
    sub_inv= inv_e2(sub)
    value = mul_e2(num, sub_inv)
    value_e2_bigint3 = [split(value[0]), split(value[1])]
    ids.slope_a0.d0 = value_e2_bigint3[0][0]
    ids.slope_a0.d1 = value_e2_bigint3[0][1]
    ids.slope_a0.d2 = value_e2_bigint3[0][2]
    ids.slope_a1.d0 = value_e2_bigint3[1][0]
    ids.slope_a1.d1 = value_e2_bigint3[1][1]
    ids.slope_a1.d2 = value_e2_bigint3[1][2]
%}
```

### g2.compute_slope()
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack, split

    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    def parse_e2(x):
        return [pack(x.a0, PRIME), pack(x.a1, PRIME)]

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

    x0 = parse_e2(ids.pt0.x)
    y0 = parse_e2(ids.pt0.y)
    x1 = parse_e2(ids.pt1.x)
    y1 = parse_e2(ids.pt1.y)

    sub = sub_e2(x0,x1)
    sub_inv = inv_e2(sub)
    numerator = sub_e2(y0,y1)
    value=mul_e2(numerator,sub_inv)

    value_e2_bigint3 = [split(value[0]), split(value[1])]
    ids.slope_a0.d0 = value_e2_bigint3[0][0]
    ids.slope_a0.d1 = value_e2_bigint3[0][1]
    ids.slope_a0.d2 = value_e2_bigint3[0][2]
    ids.slope_a1.d0 = value_e2_bigint3[1][0]
    ids.slope_a1.d1 = value_e2_bigint3[1][1]
    ids.slope_a1.d2 = value_e2_bigint3[1][2]
%}
```

# src/bn254/towers/e2.cairo

### e2.inv()
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack, split
    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    def inv_e2(a0:int, a1:int):
        t0, t1 = (a0 * a0 % p, a1 * a1 % p)
        t0 = (t0 + t1) % p
        t1 = pow(t0, -1, p)
        return (a0 * t1 % p, -(a1 * t1) % p)
    inverse0, inverse1 = inv_e2(pack(ids.x.a0, PRIME), pack(ids.x.a1, PRIME))
    inv0=split(inverse0)
    inv1=split(inverse1)
    ids.inv0 = segments.gen_arg(inv0)
    ids.inv1 = segments.gen_arg(inv1)
%}
```

# src/bn254/towers/e12.cairo

### e12.inv()
```python
%{
    from starkware.cairo.common.cairo_secp.secp_utils import pack
    p = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    def parse_e12(x):
        return (((pack(x.c0.b0.a0, PRIME), pack(x.c0.b0.a1, PRIME)), (pack(x.c0.b1.a0, PRIME), pack(x.c0.b1.a1, PRIME)), 
        (pack(x.c0.b2.a0, PRIME), pack(x.c0.b2.a1, PRIME))), ((pack(x.c1.b0.a0, PRIME), pack(x.c1.b0.a1, PRIME)),
        (pack(x.c1.b1.a0, PRIME), pack(x.c1.b1.a1, PRIME)), (pack(x.c1.b2.a0, PRIME), pack(x.c1.b2.a1, PRIME))))

    # E2 Tower // DONE:
    def mul_e2(x:(int,int), y:(int,int)):
        a = (x[0] + x[1]) * (y[0] + y[1]) % p
        b, c  = x[0]*y[0] % p, x[1]*y[1] % p
        return (b - c) % p, (a - b - c) % p
    def square_e2(x:(int,int)):
        return mul_e2(x,x)
    def double_e2(x:(int,int)):
        return 2*x[0]%p, 2*x[1]%p
    def sub_e2(x:(int,int), y:(int,int)):
        return (x[0]-y[0]) % p, (x[1]-y[1]) % p
    def neg_e2(x:(int,int)):
        return -x[0] % p, -x[1] % p
    def mul_by_non_residue_e2(x:(int, int)):
        a,b = 10*(x[0] + x[1]) % p, 9 * x[0] % p
        return (b - x[1]) % p, (a - b - x[1]) % p 
    def add_e2(x:(int,int), y:(int,int)):
        return (x[0]+y[0]) % p, (x[1]+y[1]) % p
    def inv_e2(a:(int, int)):
        t0, t1 = (a[0] * a[0] % p, a[1] * a[1] % p)
        t0 = (t0 + t1) % p
        t1 = pow(t0, -1, p)
        return a[0] * t1 % p, -(a[1] * t1) % p

    # E6 Tower:
    def mul_by_non_residue_e6(x:((int,int),(int,int),(int,int))):
        return mul_by_non_residue_e2(x[2]), x[0], x[1]
    def sub_e6(x:((int,int), (int,int), (int,int)),y:((int,int), (int,int), (int,int))):
        return (sub_e2(x[0], y[0]), sub_e2(x[1], y[1]), sub_e2(x[2], y[2]))
    def neg_e6(x:((int,int), (int,int), (int,int))):
        return neg_e2(x[0]), neg_e2(x[1]), neg_e2(x[2])
    def inv_e6(x:((int,int),(int,int),(int,int))):
        t0, t1, t2 = square_e2(x[0]), square_e2(x[1]), square_e2(x[2])
        t3, t4, t5 = mul_e2(x[0], x[1]), mul_e2(x[0], x[2]), mul_e2(x[1], x[2]) 
        c0 = add_e2(neg_e2(mul_by_non_residue_e2(t5)), t0)
        c1 = sub_e2(mul_by_non_residue_e2(t2), t3)
        c2 = sub_e2(t1, t4)
        t6 = mul_e2(x[0], c0)
        d1 = mul_e2(x[2], c1)
        d2 = mul_e2(x[1], c2)
        d1 = mul_by_non_residue_e2(add_e2(d1, d2))
        t6 = add_e2(t6, d1)
        t6 = inv_e2(t6)
        return mul_e2(c0, t6), mul_e2(c1, t6), mul_e2(c2, t6)


    def mul_e6(x:((int,int),(int,int),(int,int)), y:((int,int),(int,int),(int,int))):
        assert len(x) == 3 and len(y) == 3 and len(x[0]) == 2 and len(x[1]) == 2 and len(x[2]) == 2 and len(y[0]) == 2 and len(y[1]) == 2 and len(y[2]) == 2
        t0, t1, t2 = mul_e2(x[0], y[0]), mul_e2(x[1], y[1]), mul_e2(x[2], y[2])
        c0 = add_e2(x[1], x[2])
        tmp = add_e2(y[1], y[2])
        c0 = mul_e2(c0, tmp)
        c0 = sub_e2(c0, t1)
        c0 = sub_e2(c0, t2)
        c0 = mul_by_non_residue_e2(c0)
        c0 = add_e2(c0, t0)
        c1 = add_e2(x[0], x[1])
        tmp = add_e2(y[0], y[1])
        c1 = mul_e2(c1, tmp)
        c1 = sub_e2(c1, t0)
        c1 = sub_e2(c1, t1)
        tmp = mul_by_non_residue_e2(t2)
        c1 = add_e2(c1, tmp)
        tmp = add_e2(x[0], x[2])
        c2 = add_e2(y[0], y[2])
        c2 = mul_e2(c2, tmp)
        c2 = sub_e2(c2, t0)
        c2 = sub_e2(c2, t2)
        c2 = add_e2(c2, t1)
        return c0, c1, c2
    def square_e6(x:((int,int),(int,int),(int,int))):
        return mul_e6(x,x)

    def inv_e12(c0:((int,int),(int,int),(int,int)), c1:((int,int),(int,int),(int,int))):
        t0, t1 = square_e6(c0), square_e6(c1)
        tmp = mul_by_non_residue_e6(t1)
        t0 = sub_e6(t0, tmp)
        t1 = inv_e6(t0)
        c0 = mul_e6(c0, t1)
        c1 = mul_e6(c1, t1)
        c1 = neg_e6(c1)
        return [c0[0][0], c0[0][1], c0[1][0], c0[1][1], c0[2][0], c0[2][1], c1[0][0], c1[0][1], c1[1][0], c1[1][1], c1[2][0], c1[2][1]]

    c0,c1=parse_e12(ids.x)
    x_inv = inv_e12(c0,c1)
    e = [split(x) for x in x_inv]
    ids.inv0, ids.inv1, ids.inv2, ids.inv3 = segments.gen_arg(e[0]), segments.gen_arg(e[1]), segments.gen_arg(e[2]), segments.gen_arg(e[3])
    ids.inv4, ids.inv5, ids.inv6, ids.inv7 = segments.gen_arg(e[4]), segments.gen_arg(e[5]), segments.gen_arg(e[6]), segments.gen_arg(e[7])
    ids.inv8, ids.inv9, ids.inv10, ids.inv11 = segments.gen_arg(e[8]), segments.gen_arg(e[9]), segments.gen_arg(e[10]), segments.gen_arg(e[11])
%}
```
