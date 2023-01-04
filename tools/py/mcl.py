import mclbn256 as mcl
from mclbn256 import GT, G2, G1
from bn254 import Fp2, Fp12, Fp4, Fp, ECp2, curve

P=curve.p

def xy(x):
    # Convert G2 point from mcl lib to python tuple of 4 coordinates 
    xcord=str(x.tostr()).replace("'",'').split(' ')[1:]
    print(xcord)
    return (int(xcord[0],16), int(xcord [1],16), int(xcord[2],16), int(xcord[3],16))

def xyGT(x):
    # Convert GT point from mcl lib to python tuple of 12 coordinates. 

    xcord=str(x.tostr().decode()).replace("'",'').split(' ')
    # print(xcord)
    return (int(xcord[0],16), int(xcord [1],16), int(xcord[2],16), int(xcord[3],16),
    int(xcord[4],16), int(xcord[5],16), int(xcord[6],16), int(xcord[7],16),
    int(xcord[8],16), int(xcord[9],16), int(xcord[10],16), int(xcord[11],16), 
    )


g2:G2=mcl.G2.base_point()
g1:G1=mcl.G1.base_point()

g22:G2=g2.dbl()


e_g1g2:GT=g2.pairing(g1)
mul_GT:GT=e_g1g2.mul(e_g1g2).mul(e_g1g2)
pow_GT:GT=e_g1g2.pow(mcl.Fr(3))

ee=xyGT(e_g1g2)
print('E(g1,g2)=', xyGT(e_g1g2))
print('E(g1,g2)**2=', xyGT(mul_GT))


e_g1g2_py = Fp12(
    Fp4(Fp2(Fp(ee[0]), Fp(ee[1])), Fp2(Fp(ee[2]), Fp(ee[3]))),
    Fp4(Fp2(Fp(ee[4]), Fp(ee[5])), Fp2(Fp(ee[6]), Fp(ee[7]))),
    Fp4(Fp2(Fp(ee[8]), Fp(ee[9])), Fp2(Fp(ee[10]), Fp(ee[11]))))
mul_fq12 = e_g1g2_py.pow(2)

xyg2=xy(g2)
r=xy(g22)

x0=Fp2(Fp(r[0]), Fp(r[1]))
y0=Fp2(Fp(r[2]), Fp(r[3]))

x1=Fp2(Fp(xyg2[0]), Fp(xyg2[1]))
y1=Fp2(Fp(xyg2[2]), Fp(xyg2[3]))


t=y0-y1
print("T=",t)
u=x0-x1
print("U=", u)
slope = t*u.inverse()
print("slope=", slope)
x_diff_slope=u*slope
print("x_diff_slope=", x_diff_slope)

res=x_diff_slope-y0
print(res)
print(y1)
res=res+y1
print(res)

slope_sqr=slope*slope
new_x=slope_sqr - x0 - x1
new_y=slope*(x0-new_x) - y0
print("new_x=",new_x)
print("new_y=",new_y)
pt0=ECp2()
pt0.set(x0,y0)
pt1=ECp2()
pt1.set(x1,y1)

pt2 = pt0.add(pt1)
print("PT2=", pt2)



def from_uint(a):
    return a[0] + (a[1] << 128)


def split_128(a):
    return (a & ((1 << 128) - 1), a >> 128)

    
def to_bigint(a):

    RC_BOUND = 2 ** 128
    BASE = 2**86
    low, high = split_128(a)
    D1_HIGH_BOUND = BASE ** 2 // RC_BOUND
    D1_LOW_BOUND = RC_BOUND // BASE
    d1_low, d0 = divmod(low, BASE)
    d2, d1_high = divmod(high, D1_HIGH_BOUND)
    d1 = d1_high * D1_LOW_BOUND + d1_low

    return (d0, d1, d2)

