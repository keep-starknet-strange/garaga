##*************************************************************************************/
##/* Copyright (C) 2022 - Renaud Dubois - This file is part of cairo_musig2 project	 */
##/* License: This software is licensed under a dual BSD and GPL v2 license. 	 */
##/* See LICENSE file at the root folder of the project.				 */
##/* FILE: altbn128.py							             	  */
##/* 											  */
##/* 											  */
##/* DESCRIPTION: altbn_128 Ethereum curve*/
##/* https://ethereum.github.io/yellowpaper/paper.pdf
##/* This is a high level simulation for validation purpose				  */
##/* 
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
from external.Pairings.pairing_bn import final_exp_hard_bn
from external.Pairings.pairing import *
from external.Pairings.tests.test_pairing import *


curve_name="BN254 (Ethereum EIP 197)"

#
u0=0x44e992b44a6909f1
t=6*(u0**2)+1

#preparse("QQx.<x> = QQ[]")
QQx = QQ['x']; (x,) = QQx._first_ngens(1)

p=  21888242871839275222246405745257275088696311157297823662689037894645226208583;
#curve order
r= 21888242871839275222246405745257275088548364400416034343698204186575808495617;

#(p^12-1)/r
fexp=(p^12-1)/r;


b=3;

#defining group G1    
Fp = GF(p, proof=False);
Fpz = Fp['z']; (z,) = Fpz._first_ngens(1)
E1= EllipticCurve([Fp(0), Fp(b)]);

Gen1=E1([1,2]);


Gen1prime=E1([1,-2]);


#defining group G2    
Fp2 = Fp.extension(z**2 + 1, names=('i',));(i,) = Fp2._first_ngens(1)
Fp2s = Fp2['s']; (s,) = Fp2s._first_ngens(1)

xiD=i+9;
#alt bn uses a D-twist so b'=b/(xiD)
b_twist=266929791119991161246907387137283842545076965332900288569378510910307636690*i + 19485874751759354771024239261021720505790618469301721065564631296452457478373;

E2 = EllipticCurve([Fp2(0), Fp2(b_twist)]);

Gen2=E2([11559732032986387107991004021392285783925812861821192530917403151452391805634*i
+10857046999023057135944570762232829481370756359578518086990519993285655852781,
4082367875863433681332203403145435568316851327593401208105741076214120093531*i+
8495653923123431417604973247489272438418190587263600148770280649306958101930
]);
#G1 cofactor

c = 1
#G2 cofactor
c2 = 21888242871839275222246405745257275088844257914179612981679871602714643921549

 
Fq6D = Fp2.extension(s**6 - xiD, names=('wD',)); (wD,) = Fq6D._first_ngens(1)

Fp12D = Fp.extension((z**6 - 9)**2 +1, names=('SD',)); (SD,) = Fp12D._first_ngens(1)
i0D=9;i1D=1;
#This is the value of e(P1, P2)^-1, used to normalize the pairing to e(P1, P2)=1
GT_m1= 2022352245184093622585933928071041773908154497810021340769542779900465408465*SD**11 + 13457918839441801149636661064452586584035112924373040454015419057282722438755*SD**10 + 13548013608579537707697657347285314522053961834277294646656001245838374737667*SD**9 + 17825267360895837085451107995225635057867750528379226586267407742446165874144*SD**8 + 18802626282988020539438689440749692350833158231694366850413846278054266195880*SD**7 + 14314201653062210324735390383406751486918810772583160049675454556786452616376*SD**6 + 5139824347891456789875380810425795311589881545492661390714092973976287322213*SD**5 + 2482300653861500184440064741414678556260669908011530731124174562859179789679*SD**4 + 4682174067881898412784357245754362692360019011977070791057333186827241119302*SD**3 + 917254912024461371424638674294859181633141409274761568025215267498983960928*SD**2 + 18997689509578592230393697934932104181940939224220177620977816741887748145398*SD + 5712357954789893154981989579969852488540698669301181194985843921813279942042


#test vector for precompile 8 (should return true) from https://github.com/comitylabs/evm.codes/blob/main/docs/precompiled/0x08.mdx#example
list_G1=[E1([0x2cf44499d5d27bb186308b7af7af02ac5bc9eeb6a3d147c186b21fb1b76e18da,0x2c0f001f52110ccfe69108924926e45f0b0c868df0e7bde1fe16d3242dc715f6 ]),
 	 E1([0x0000000000000000000000000000000000000000000000000000000000000001, 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd45])
 ];
 
list_G2=[
 	E2([0x22606845ff186793914e03e21df544c34ffe2f2f3504de8a79d9159eca2d98d9+ i* 0x1fb19bb476f6b9e44e2a32234da8212f61cd63919354bc06aef31e3cfaff3ebc,
 	 0x2fe02e47887507adf0ff1743cbac6ba291e66f59be6bd763950bb16041a0a85e+i*0x2bd368e28381e8eccb5fa81fc26cf3f048eea9abfdd85d7ed3ab3698d63e4f90]),
 	E2([0x091058a3141822985733cbdddfed0fd8d6c104e9e9eff40bf5abfef9ab163bc7+i*0x1971ff0471b09fa93caaf13cbf443c1aede09cc4328f5a62aad45f40ec133eb4,
 	 0x23a8eb0b0996252cb548a4487da97b02422ebc0e834613f954de6c7e0afdc1fc+i*0x2a23af9a5ce2ba2796c1f4e453a370eb0af8c212d9dc9acd8fc02c2e907baea2])
 ];

def map_Fp2_Fp12D(x):
   # evaluate elements of Fq=Fp[i] at i=s^6-1 = S^6-1
 return x.polynomial()((SD**6-i0D)/i1D)

def map_Fq6D_Fp12D(x):
 return sum([xi.polynomial()((SD**6-i0D)/i1D) * SD**e for e,xi in enumerate(x.list())])
    

def final_exp_bn(m, u):
 g = final_exp_easy_k12(m)
 h = final_exp_hard_bn(g, u)
 return h
 
def ate_pairing_bn_aklgl(Q,P,b_t,u0,Fq6,map_Fq6D_Fp12D,D_twist=True):
    m,S = miller_function_ate_2naf_aklgl(Q,P,b_t,t-1,Fq6,D_twist=True,m0=1)
    # convert m from tower field to absolute field
    m = map_Fq6D_Fp12D(m)
    f = final_exp_bn(m,u0)
    #f=f*GT_m1;
    return f


#this is the function you want:
def _e(P,Q):
 f= ate_pairing_bn_aklgl(Q, P, E2.a6(), u0, Fq6D, map_Fq6D_Fp12D, True)
   
 return f

#a long name cause the import fail for mysterious reason with short one
def long_pairing(P,Q):
 f= ate_pairing_bn_aklgl(Q, P, E2.a6(), u0, Fq6D, map_Fq6D_Fp12D, True)   
 return f


#the solidity precompile number 8: test if prod(e(G1_i, G2_i)==1) ?
def Precompile8(listG1, listG2):
 bool=false;
 produit=Fp12D(1);
 Gt=_e(Gen1, Gen2);
 l=len(listG1)
 for i in range(l):
   print("i=",i, "produit=",produit);
   produit=produit*_e(listG1[i],listG2[i]);

   
 bool= (produit==1);
 print("bool=", bool);
 
 return bool

def precompute_gtm1():
 gtm1=  (_e(Gen1, Gen2))**(-1);
 print("gtm1=", gtm1);
 return gtm1;
 
 
def local2_test_ate_pairing_bn254_aklgl():
    set_random_seed(0)
    P = c*E1.random_element()
    while P == E1(0) or r*P != E1(0):
        P = c * E2.random_element()
    Q = c2*E2.random_element()
    while Q == E2(0) or r*Q != E2(0):
        Q = c2 * E2.random_element()
    f = _e(P,Q);
    
    print("P, Q, f",P, Q, f);
    
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
    print("test_ate_pairing_bn_aklgl (bilinear): {} ({} tests)".format(ok, (aa-1)*(bb-1)))
    return ok

if __name__ == "__main__":
    arithmetic(False)
    
    print("test Precompiled contract 8 (ecPairing)");
    print("len",len(list_G1));
    
    Precompile8(list_G1, list_G2); 
    precompute_gtm1();
    
    
    print("\ntest pairing")
#    print(" E, E2, Fq6D, xiD, r, c, c2, t-1",E1, E2, Fq6D, xiD, r, c, c2, t-1);
   
#    test_miller_function_ate_aklgl(E1,E2,Fq6D,xiD,r,c,c2,t-1,D_twist=True)
  
    local2_test_ate_pairing_bn254_aklgl()
   




    
    
