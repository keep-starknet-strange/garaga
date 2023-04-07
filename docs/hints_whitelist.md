# src/bn254/fq.cairo
### fq_bigint3.add()  
```python
%{
    BASE = ids.BASE
    assert 1 < ids.N_LIMBS <= 12

    p, sub_limbs = 0, []
    for i in range(ids.N_LIMBS):
        p+=getattr(ids, 'P'+str(i)) * BASE**i

    sum_limbs=[]
    p_limbs = [getattr(ids, 'P'+str(i)) for i in range(ids.N_LIMBS)]
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
%}
```

### fq_bigint3.sub()

```python
%{
    BASE = ids.BASE
    assert 1 < ids.N_LIMBS <= 12

    p, sub_limbs = 0, []
    for i in range(ids.N_LIMBS):
        p+=getattr(ids, 'P'+str(i)) * BASE**i

    p_limbs = [getattr(ids, 'P'+str(i)) for i in range(ids.N_LIMBS)]
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
%}
```

### fq_bigint3.mul()    
#L524-L536  
```python
%{
    from starkware.cairo.common.math_utils import as_int
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    a,b,p=0,0,0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

    for i in range(ids.N_LIMBS):
        a+=as_int(getattr(ids.a, 'd'+str(i)),PRIME) * ids.BASE**i
        b+=as_int(getattr(ids.b, 'd'+str(i)),PRIME) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
    mul = a*b
    q, r = divmod(mul, p)
    qs, rs = split(q), split(r)
    for i in range(ids.N_LIMBS):
        setattr(ids.r, 'd'+str(i), rs[i])
        setattr(ids.q, 'd'+str(i), qs[i])
%}
```
### fq_bigint3.mul_by_9()  
#L587-L595  
```python
%{
    from starkware.cairo.common.math_utils import as_int    
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    a,p=0,0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

    for i in range(ids.N_LIMBS):
        a+=as_int(getattr(ids.a, 'd'+str(i)), PRIME) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    mul = a*9
    q, r = divmod(mul, p)
    ids.q=q%PRIME
    rs = split(r)
    for i in range(ids.N_LIMBS):
        setattr(ids.r, 'd'+str(i), rs[i])
%}
```
### fq_bigint3.mul_by_10()  
#L621-L629  
```python
%{
    from starkware.cairo.common.math_utils import as_int    
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    a,p=0,0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

    for i in range(ids.N_LIMBS):
        a+=as_int(getattr(ids.a, 'd'+str(i)), PRIME) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    mul = a*10
    q, r = divmod(mul, p)
    ids.q=q%PRIME
    rs = split(r)
    for i in range(ids.N_LIMBS):
        setattr(ids.r, 'd'+str(i), rs[i])
%}
```


### fq_bigint3.inv()  
#L662-L671  
```python
%{
    from starkware.cairo.common.math_utils import as_int    
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    a,p=0,0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

    for i in range(ids.N_LIMBS):
        a+=as_int(getattr(ids.a, 'd'+str(i)), PRIME) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    inv = pow(a, -1, p)
    invs = split(inv)
    for i in range(ids.N_LIMBS):
        setattr(ids.inv, 'd'+str(i), invs[i])
%}
```


### verify_zero3()  
#L726-L736  
```python
%{
    from starkware.cairo.common.math_utils import as_int
    assert 1 < ids.N_LIMBS <= 12
    a,p=0,0

    for i in range(ids.N_LIMBS):
        a+=as_int(getattr(ids.val, 'd'+str(i)), PRIME) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    q, r = divmod(a, p)
    assert r == 0, f"verify_zero: Invalid input."
    ids.q=q%PRIME
%}

```

### verify_zero5()  
#L756-L768  
```python
%{
    from starkware.cairo.common.math_utils import as_int    
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS - 1
    N_LIMBS_UNREDUCED=ids.DEGREE*2+1
    a,p=0,0
    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]
    for i in range(ids.N_LIMBS):
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
    for i in range(N_LIMBS_UNREDUCED):
        a+=as_int(getattr(ids.val, 'd'+str(i)), PRIME) * ids.BASE**i

    q, r = divmod(a, p)
    assert r == 0, f"verify_zero: Invalid input {a}, {a.bit_length()}."
    q_split = split(q)
    for i in range(ids.N_LIMBS):
        setattr(ids.q, 'd'+str(i), q_split[i])
%}

```
### is_zero()  
#L851-L855

```python
%{
    from starkware.cairo.common.math_utils import as_int
    assert 1 < ids.N_LIMBS <= 12
    x,p=0,0
    for i in range(ids.N_LIMBS):
        x+=as_int(getattr(ids.x, 'd'+str(i)), PRIME) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
    ids.is_zero = 1 if x%p == 0 else 0
%}
```


# src/bn254/g1.cairo

### g1.compute_doubling_slope()
#L55-L64

```python
%{
    from starkware.python.math_utils import div_mod

    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    x,y,p=0,0,0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

    for i in range(ids.N_LIMBS):
        x+=getattr(ids.pt.x, 'd'+str(i)) * ids.BASE**i
        y+=getattr(ids.pt.y, 'd'+str(i)) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    slope = split(div_mod(3 * x ** 2, 2 * y, p))

    for i in range(ids.N_LIMBS):
        setattr(ids.slope, 'd'+str(i), slope[i])
%}
```

### g1.compute_slope()
```python
%{
    from starkware.python.math_utils import div_mod

    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    x0,y0,x1,y1,p=0,0,0,0,0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

    for i in range(ids.N_LIMBS):
        x0+=getattr(ids.pt0.x, 'd'+str(i)) * ids.BASE**i
        y0+=getattr(ids.pt0.y, 'd'+str(i)) * ids.BASE**i
        x1+=getattr(ids.pt1.x, 'd'+str(i)) * ids.BASE**i
        y1+=getattr(ids.pt1.y, 'd'+str(i)) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    slope = split(div_mod(y0 - y1, x0 - x1, p))

    for i in range(ids.N_LIMBS):
        setattr(ids.slope, 'd'+str(i), slope[i])
%}
```
### g1.double()
```python
%{
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    x,y,slope,p=0,0,0,0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

    for i in range(ids.N_LIMBS):
        x+=getattr(ids.pt.x, 'd'+str(i)) * ids.BASE**i
        y+=getattr(ids.pt.y, 'd'+str(i)) * ids.BASE**i
        slope+=getattr(ids.slope, 'd'+str(i)) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    new_x = (pow(slope, 2, P) - 2 * x) % p
    new_y = (slope * (x - new_x) - y) % p
    new_xs, new_ys = split(new_x), split(new_y)

    for i in range(ids.N_LIMBS):
        setattr(ids.new_x, 'd'+str(i), new_xs[i])
        setattr(ids.new_y, 'd'+str(i), new_ys[i])
%}
```

### g1.fast_ec_add()
```python
%{
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    x0,y0,x1,slope,p=0,0,0,0,0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

    for i in range(ids.N_LIMBS):
        x0+=getattr(ids.pt0.x, 'd'+str(i)) * ids.BASE**i
        y0+=getattr(ids.pt0.y, 'd'+str(i)) * ids.BASE**i
        x1+=getattr(ids.pt1.x, 'd'+str(i)) * ids.BASE**i
        slope+=getattr(ids.slope, 'd'+str(i)) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i


    new_x = (pow(slope, 2, P) - x0 - x1) % p
    new_y = (slope * (x0 - new_x) - y0) % p
    new_xs, new_ys = split(new_x), split(new_y)

    for i in range(ids.N_LIMBS):
        setattr(ids.new_x, 'd'+str(i), new_xs[i])
        setattr(ids.new_y, 'd'+str(i), new_ys[i])
%}
```


# src/bn254/g2.cairo

### g2.compute_doubling_slope()
```python
%{
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    x,y,p=[0,0],[0,0],0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

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

    value_split = [split(value[0]), split(value[1])]
    for i in range(ids.N_LIMBS):
        setattr(ids.slope_a0, 'd'+str(i), value_split[0][i])
        setattr(ids.slope_a1, 'd'+str(i), value_split[1][i])
%}
```

### g2.compute_slope()
```python
%{
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    x0,y0,x1,y1,p=[0,0],[0,0],[0,0],[0,0],0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

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
%}
```
### g2.double()
```python
%{
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    x0,x1,y0,y1,slope,p=0,0,0,0,[0,0],0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]
    def inv_e2(a0:int, a1:int):
        t0, t1 = (a0 * a0 % p, a1 * a1 % p)
        t0 = (t0 + t1) % p
        t1 = pow(t0, -1, p)
        return (a0 * t1 % p, -(a1 * t1) % p)
    def mul_e2(x:(int,int), y:(int,int)):
        a = (x[0] + x[1]) * (y[0] + y[1]) % p
        b, c  = x[0]*y[0] % p, x[1]*y[1] % p
        return (b - c) % p, (a - b - c) % p
    def sub_e2(x:(int,int), y:(int,int)):
        return (x[0]-y[0]) % p, (x[1]-y[1]) % p

    for i in range(ids.N_LIMBS):
        x0+=getattr(ids.pt.x.a0, 'd'+str(i)) * ids.BASE**i
        x1+=getattr(ids.pt.x.a1, 'd'+str(i)) * ids.BASE**i
        y0+=getattr(ids.pt.y.a0, 'd'+str(i)) * ids.BASE**i
        y1+=getattr(ids.pt.y.a1, 'd'+str(i)) * ids.BASE**i
        slope[0]+=getattr(ids.slope.a0, 'd'+str(i)) * ids.BASE**i
        slope[1]+=getattr(ids.slope.a1, 'd'+str(i)) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    new_x = sub_e2(mul_e2(slope, slope), mul_e2((2,0), (x0,x1)))
    new_y = sub_e2(mul_e2(slope, sub_e2((x0,x1), new_x)), (y0,y1))
    new_xs, new_ys = [split(new_x[0]), split(new_x[1])], [split(new_y[0]), split(new_y[1])]

    for i in range(ids.N_LIMBS):
        setattr(ids.new_x_a0, 'd'+str(i), new_xs[0][i])
        setattr(ids.new_x_a1, 'd'+str(i), new_xs[1][i])
        setattr(ids.new_y_a0, 'd'+str(i), new_ys[0][i])
        setattr(ids.new_y_a1, 'd'+str(i), new_ys[1][i])
    %}
```

### g2.fast_ec_add()
```python
%{
    from starkware.python.math_utils import div_mod

    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    pt0x0,pt0x1,pt0y0,pt0y1,pt1x0,pt1x1,slope,p=0,0,0,0,0,0,[0,0],0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]
    def inv_e2(a0:int, a1:int):
        t0, t1 = (a0 * a0 % p, a1 * a1 % p)
        t0 = (t0 + t1) % p
        t1 = pow(t0, -1, p)
        return (a0 * t1 % p, -(a1 * t1) % p)
    def mul_e2(x:(int,int), y:(int,int)):
        a = (x[0] + x[1]) * (y[0] + y[1]) % p
        b, c  = x[0]*y[0] % p, x[1]*y[1] % p
        return (b - c) % p, (a - b - c) % p
    def sub_e2(x:(int,int), y:(int,int)):
        return (x[0]-y[0]) % p, (x[1]-y[1]) % p

    for i in range(ids.N_LIMBS):
        pt0x0+=getattr(ids.pt0.x.a0, 'd'+str(i)) * ids.BASE**i
        pt0x1+=getattr(ids.pt0.x.a1, 'd'+str(i)) * ids.BASE**i
        pt0y0+=getattr(ids.pt0.y.a0, 'd'+str(i)) * ids.BASE**i
        pt0y1+=getattr(ids.pt0.y.a1, 'd'+str(i)) * ids.BASE**i
        pt1x0+=getattr(ids.pt1.x.a0, 'd'+str(i)) * ids.BASE**i
        pt1x1+=getattr(ids.pt1.x.a1, 'd'+str(i)) * ids.BASE**i
        slope[0]+=getattr(ids.slope.a0, 'd'+str(i)) * ids.BASE**i
        slope[1]+=getattr(ids.slope.a1, 'd'+str(i)) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    new_x = sub_e2(sub_e2(mul_e2(slope, slope), (pt0x0,pt0x1)), (pt1x0,pt1x1))
    new_y = sub_e2(mul_e2(slope, sub_e2((pt0x0,pt0x1), new_x)), (pt0y0,pt0y1))

    new_xs, new_ys = [split(new_x[0]), split(new_x[1])], [split(new_y[0]), split(new_y[1])]

    for i in range(ids.N_LIMBS):
        setattr(ids.new_x_a0, 'd'+str(i), new_xs[0][i])
        setattr(ids.new_x_a1, 'd'+str(i), new_xs[1][i])
        setattr(ids.new_y_a0, 'd'+str(i), new_ys[0][i])
        setattr(ids.new_y_a1, 'd'+str(i), new_ys[1][i])
%}
```
# src/bn254/towers/e2.cairo

### e2.inv()
```python
%{
    from starkware.cairo.common.math_utils import as_int    
    assert 1 < ids.N_LIMBS <= 12
    assert ids.DEGREE == ids.N_LIMBS-1
    a0,a1,p=0,0,0

    def split(x, degree=ids.DEGREE, base=ids.BASE):
        coeffs = []
        for n in range(degree, 0, -1):
            q, r = divmod(x, base ** n)
            coeffs.append(q)
            x = r
        coeffs.append(x)
        return coeffs[::-1]

    for i in range(ids.N_LIMBS):
        a0+=as_int(getattr(ids.x.a0, 'd'+str(i)), PRIME) * ids.BASE**i
        a1+=as_int(getattr(ids.x.a1, 'd'+str(i)), PRIME) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i

    def inv_e2(a0:int, a1:int):
        t0, t1 = (a0 * a0 % p, a1 * a1 % p)
        t0 = (t0 + t1) % p
        t1 = pow(t0, -1, p)
        return (a0 * t1 % p, -(a1 * t1) % p)

    inverse0, inverse1 = inv_e2(a0, a1)
    inv0, inv1 =split(inverse0), split(inverse1)
    for i in range(ids.N_LIMBS):
        setattr(ids.inv0, 'd'+str(i),  inv0[i])
        setattr(ids.inv1, 'd'+str(i),  inv1[i])
%}
```

# src/bn254/towers/e12.cairo

### e12.inv()
```python
%{
    from starkware.cairo.common.math_utils import as_int
    assert 1 < ids.N_LIMBS <= 12
    p, c0, c1=0, 6*[0], 6*[0]
    c0_refs =[ids.x.c0.b0.a0, ids.x.c0.b0.a1, ids.x.c0.b1.a0, ids.x.c0.b1.a1, ids.x.c0.b2.a0, ids.x.c0.b2.a1]
    c1_refs =[ids.x.c1.b0.a0, ids.x.c1.b0.a1, ids.x.c1.b1.a0, ids.x.c1.b1.a1, ids.x.c1.b2.a0, ids.x.c1.b2.a1]

    # E2 Tower:
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
        return mul_e2(x, (ids.NON_RESIDUE_E2_a0, ids.NON_RESIDUE_E2_a1))
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
    for i in range(ids.N_LIMBS):
        for k in range(6):
            c0[k]+=as_int(getattr(c0_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
            c1[k]+=as_int(getattr(c1_refs[k], 'd'+str(i)), PRIME) * ids.BASE**i
        p+=getattr(ids, 'P'+str(i)) * ids.BASE**i
    c0 = ((c0[0],c0[1]),(c0[2],c0[3]),(c0[4],c0[5]))
    c1 = ((c1[0],c1[1]),(c1[2],c1[3]),(c1[4],c1[5]))
    x_inv = inv_e12(c0,c1)
    e = [split(x) for x in x_inv]
    for i in range(12):
        for l in range(ids.N_LIMBS):
            setattr(getattr(ids,f"inv{i}"),f"d{l}",e[i][l])
%}
```
