##*************************************************************************************/
##/* Copyright (C) 2022 - Renaud Dubois - This file is part of cairo_musig2 project	 */
##/* License: This software is licensed under a dual BSD and GPL v2 license. 	 */
##/* See LICENSE file at the root folder of the project.				 */
##/* FILE: bls12_381.py							             	  */
##/* 											  */
##/* 											  */
##/* DESCRIPTION: bls12_381 Ethereum curve*/
##/* This is a high level simulation for validation purpose				  */
#https://github.com/zcash/librustzcash/blob/6e0364cd42a2b3d2b958a54771ef51a8db79dd29/pairing/src/bls12_381/README.md
##**************************************************************************************/
from sage.all_cmdline import *   # import sage library

from sage.rings.integer_ring import ZZ
from sage.rings.rational_field import QQ
from sage.misc.functional import cyclotomic_polynomial
from sage.rings.finite_rings.finite_field_constructor import FiniteField, GF
from sage.schemes.elliptic_curves.constructor import EllipticCurve

# this is much much faster with this statement:
# proof.arithmetic(False)
from sage.structure.proof.all import arithmetic

from external.Pairings.pairing import *
############## Precomputed constants for BLS12_381


curve_name="BLS12_381 (Ethereum EIP 2537)"

#preparse("QQx.<x> = QQ[]")
QQx = QQ['x']; (x,) = QQx._first_ngens(1)
  
    
#BLS 12_381 seed
u0=ZZ(-(2**63+2**62+2**60+2**57+2**48+2**16))  
#curve characteristic
p=  0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab;
#curve order
r = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001
#G1 cofactor
c = 76329603384216526031706109802092473003
#G2 cofactor
c2 = 305502333931268344200999753193121504214466019254188142667664032982267604182971884026507427359259977847832272839041616661285803823378372096355777062779109
#curve coefficient b    
b=4;
#defining group G1    
Fp = GF(p, proof=False);
Fpz = Fp['z']; (z,) = Fpz._first_ngens(1)
E1= EllipticCurve([Fp(0), Fp(b)]);

# generators specification from
#https://github.com/zcash/librustzcash/blob/6e0364cd42a2b3d2b958a54771ef51a8db79dd29/pairing/src/bls12_381/README.md

Gen1=E1([0x17F1D3A73197D7942695638C4FA9AC0FC3688C4F9774B905A14E3A3F171BAC586C55E83FF97A1AEFFB3AF00ADB22C6BB, 0x08B3F481E3AAA0F1A09E30ED741D8AE4FCF5E095D5D00AF600DB18CB2C04B3EDD03CC744A2888AE40CAA232946C5E7E1]);

#defining group G2    
Fp2 = Fp.extension(z**2 + 1, names=('i',));(i,) = Fp2._first_ngens(1)
Fp2s = Fp2['s']; (s,) = Fp2s._first_ngens(1)
E2 = EllipticCurve([Fp2(0), Fp2(4*i+4)])
G2_x = 3059144344244213709971259814753781636986470325476647558659373206291635324768958432433509563104347017837885763365758*i + 352701069587466618187139116011060144890029952792775240219908644239793785735715026873347600343865175952761926303160
G2_y = 927553665492332455747201965776037880757740193453592970025027978793976877002675564980949289727957565575433344219582*i + 1985150602287291935568054521177171638300868978215655730859378665066344726373823718423869104263333984641494340347905

Gen2=E2([G2_x, G2_y]);



#defining Tower field Fp12    
Fp12M = Fp2.extension(s**6 - (i+1), names=('wM',)); (wM,) = Fp12M._first_ngens(1)
Fp12M_A = Fp.extension((z**6 - 1)**2 + 1, names=('SM',)); (SM,) = Fp12M_A._first_ngens(1)
    
  
def map_Fp12M_Fp12M_A(x):
        # evaluate elements of Fp12M = Fp[i]/(i^2+1)[s]/(s^6-(i+1)) at i=S^6-1 and s=S
        # i <-> wM^6-1 = SM^6-1 and wM <-> SM
        #return sum([sum([yj*(SM**6-1)**j for j,yj in enumerate(xi.polynomial())]) * SM**i for i,xi in enumerate(x.list())])
        return sum([xi.polynomial()((SM**6-1)) * SM**e for e,xi in enumerate(x.list())])


#this is the function you want for your protocol:  
def _e(P,Q):
  return ate_pairing_bls12_aklgl(Q, P, E2.a6(), u0, Fp12M, map_Fp12M_Fp12M_A, False)

def long_pairing(P,Q):
  return ate_pairing_bls12_aklgl(Q, P, E2.a6(), u0, Fp12M, map_Fp12M_Fp12M_A, False)


def local2_test_ate_pairing_bls12_aklgl():
    P = c*E1.random_element()
    while P == E1(0) or r*P != E1(0):
        P = c * E2.random_element()
    Q = c2*E2.random_element()
    while Q == E2(0) or r*Q != E2(0):
        Q = c2 * E2.random_element()
    f = _e(P,Q);
    
    ok = True
    bb = 1
    while ok and bb < 4:
        Qb = bb*Q
        aa = 1
        while ok and aa < 4:
            Pa = aa*P 
            fab = _e(Pa,Qb);
            fab_expected = f**(aa*bb)
            ok = fab == fab_expected
            aa += 1
        bb += 1
    print("test_ate_pairing_bls12_aklgl (bilinear): {} ({} tests)".format(ok, (aa-1)*(bb-1)))
    return ok

    
if __name__ == "__main__":
    arithmetic(False)
   
    print("\ntest pairing")
    local2_test_ate_pairing_bls12_aklgl()
   
    
    
    

   
