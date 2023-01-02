#!/usr/bin/env python3

#
# Copyright (c) 2012-2020 MIRACL UK Ltd.
#
# This file is part of MIRACL Core
# (see https://github.com/miracl/core).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU Affero General Public License as
#    published by the Free Software Foundation, either version 3 of the
#    License, or (at your option) any later version.


#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Affero General Public License for more details.

#     https://www.gnu.org/licenses/agpl-3.0.en.html

#    You should have received a copy of the GNU Affero General Public License
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#   You can be released from the requirements of the license by purchasing     
#   a commercial license. Buying such a license is mandatory as soon as you
#   develop commercial activities involving the MIRACL Core Crypto SDK
#   without disclosing the source code of your own applications, or shipping
#   the MIRACL Core Crypto SDK with a closed source product.     

#
# Optimal Ate Pairing
# M.Scott August 2018
#

from bn254_py.constants import *
from bn254_py import curve
from bn254_py import big
from bn254_py.fp2 import Fp2
from bn254_py.fp4 import Fp4
from bn254_py.fp12 import Fp12
from bn254_py.fp12 import one

# line function

def dbl(A) :
    CC, YY, BB = A.getxyz()
    AA = YY * BB
    CC.sqr()
    YY.sqr()
    BB.sqr()

    AA += AA
    AA = -AA
    AA = AA.mulQNR()
    BB = BB.muli(3 * curve.B)
    CC = CC.muli(3)
    if curve.SexticTwist == D_TYPE:
        YY = YY.mulQNR()
        CC = CC.mulQNR()
    if curve.SexticTwist == M_TYPE:    
        BB = BB.mulQNR()
    BB=BB-YY
    A.dbl()
    return (AA,BB,CC)

def add(A,B) :
    X1, Y1, Z1 = A.getxyz()
    X2, Y2 = B.getxy()
    T1 = (X1 - Z1 * X2)
    T2 = (Y1 - Z1 * Y2)

    AA = T1
    BB = T2*X2-T1*Y2
    CC = -T2

    if curve.SexticTwist == M_TYPE:
        AA=AA.mulQNR()

    A.add(B)
    return (AA,BB,CC)

def g(A, B, Qx, Qy):
    if A == B:
        AA,BB,CC=dbl(A)
    else:
        AA,BB,CC=add(A,B)

    CC=CC.muls(Qx)
    AA=AA.muls(Qy)

    a=Fp4(AA,BB)
    if curve.SexticTwist == D_TYPE:
        b=Fp4(CC)
        c=Fp4()
    else :
        b=Fp4()
        c=Fp4(CC).times_i()

    return Fp12(a, b, c)

def lbits() :
    x = curve.x
    if curve.PairingFriendly == BN:
        n = 6 * x
        if curve.SignOfX == POSITIVEX:
            n += 2
        else:
            n -= 2
    else:
        n = x
    n3 = 3 * n
    return n3.bit_length(),n3,n

def initmp() :
    nb,n3,n=lbits()
    r=[]
    for i in range (nb-1,-1,-1) :
        r.append(one())
    return r

def miller(r) :
    nb,n3,n=lbits()
    res=one()
    for i in range (nb-1,0,-1) :
        res.sqr()
        res *= r[i]
    if curve.SignOfX == NEGATIVEX:
        res.conj()
    res *= r[0]
    return res
	
def pack(AA,BB,CC) :
    i=CC.inverse()
    return Fp4(AA*i,BB*i)

def unpack(T,Qx,Qy) :
    aa,bb=T.get()
    aa=aa.muls(Qy)
    a=Fp4(aa,bb)
  
    t=Fp2(Qx)
    if curve.SexticTwist == D_TYPE:
        b=Fp4(t)
        c=Fp4()
    else :
        b=Fp4()
        c=Fp4(t).times_i()
    return Fp12(a,b,c)

def precomp(GV) :
    nb,n3,n=lbits()
    P=GV.copy()
    A=P.copy()
    MP=-P
    T=[]
    for i in range(nb - 2, 0, -1):
        AA,BB,CC = dbl(A)
        T.append(pack(AA,BB,CC))
        if big.bit(n3, i) == 1 and big.bit(n, i) == 0:
            AA,BB,CC= add(A,P)
            T.append(pack(AA,BB,CC))
        if big.bit(n3, i) == 0 and big.bit(n, i) == 1:
            AA,BB,CC=add(A,MP)
            T.append(pack(AA,BB,CC))
    
    if curve.PairingFriendly == BN:
        KA = P.copy()
        KA.frobenius()
        if curve.SignOfX == NEGATIVEX:
            A = -A
        AA,BB,CC=add(A,KA)
        T.append(pack(AA,BB,CC))
        KA.frobenius()
        KA = -KA
        AA,BB,CC=add(A,KA)
        T.append(pack(AA,BB,CC))
    return T

# Accumulate another set of line functions for n-pairing, assuming precomputation on G2 
def another_pc(r,T,QV) :
    if QV.isinf() :
        return
    nb,n3,n=lbits()
    Q=QV.copy()
    Q.affine()
    Qx, Qy = Q.getxy()	
    j=0
    for i in range(nb - 2, 0, -1):
        lv=unpack(T[j],Qx,Qy)
        j+=1
        if big.bit(n3, i) == 1 and big.bit(n, i) == 0:
            lv2=unpack(T[j],Qx,Qy)
            j+=1
            lv.smul(lv2)
        if big.bit(n3, i) == 0 and big.bit(n, i) == 1:        
            lv2=unpack(T[j],Qx,Qy)
            j+=1
            lv.smul(lv2)
        r[i] *= lv

    if curve.PairingFriendly == BN:
        lv=unpack(T[j],Qx,Qy)
        j+=1
        lv2=unpack(T[j],Qx,Qy)
        lv.smul(lv2)
        r[0] *= lv

# Accumulate another set of line functions for n-pairing 
def another(r,P1,Q1) :
    if Q1.isinf() :
        return
    nb,n3,n=lbits()
    P = P1.copy()
    Q = Q1.copy()

    P.affine()
    Q.affine()
    A = P.copy()
    Qx, Qy = Q.getxy()	
    for i in range(nb - 2, 0, -1):
        lv=g(A, A, Qx, Qy)

        if big.bit(n3, i) == 1 and big.bit(n, i) == 0:
            lv2 =  g(A, P, Qx, Qy)
            lv.smul(lv2)
        if big.bit(n3, i) == 0 and big.bit(n, i) == 1:
            lv2 = g(A, -P, Qx, Qy)
            lv.smul(lv2)
        r[i] *= lv
    
    if curve.PairingFriendly == BN:
        KA = P.copy()
        KA.frobenius()
        if curve.SignOfX == NEGATIVEX:
            A = -A
        lv = g(A, KA, Qx, Qy)
        KA.frobenius()
        KA = -KA
        lv2 = g(A, KA, Qx, Qy)
        lv.smul(lv2)
        r[0] *= lv

# full pairing - miller loop followed by final exponentiation

def e(P, Q):
    r = ate(P, Q)
    return fexp(r)


def ate(P1, Q1):
    if Q1.isinf() :
        return one();
    nb,n3,n=lbits()
    
    P = P1.copy()
    Q = Q1.copy()

    P.affine()
    Q.affine()
    A = P.copy()
    Qx, Qy = Q.getxy()
    r = one()
# miller loop
    for i in range(nb - 2, 0, -1):
        r.sqr()
        lv=g(A, A, Qx, Qy)

        if big.bit(n3, i) == 1 and big.bit(n, i) == 0:
            lv2 =  g(A, P, Qx, Qy)
            lv.smul(lv2)
        if big.bit(n3, i) == 0 and big.bit(n, i) == 1:
            lv2 = g(A, -P, Qx, Qy)
            lv.smul(lv2)
        r *= lv

# adjustment
    if curve.SignOfX == NEGATIVEX:
        r.conj()

    if curve.PairingFriendly == BN:
        KA = P.copy()
        KA.frobenius()
        if curve.SignOfX == NEGATIVEX:
            A = -A
        lv = g(A, KA, Qx, Qy)
        KA.frobenius()
        KA = -KA
        lv2 = g(A, KA, Qx, Qy)
        lv.smul(lv2)
        r *= lv

    return r


def double_ate(P1, Q1, U1, V1):

    if Q1.isinf() :
        return ate(U1,V1)
    if V1.isinf() :
        return ate(P1,Q1)
    nb,n3,n=lbits()

    P = P1.copy()
    Q = Q1.copy()
    U = U1.copy()
    V = V1.copy()

    P.affine()
    Q.affine()
    U.affine()
    V.affine()
    A = P.copy()
    Qx, Qy = Q.getxy()
    B = U.copy()
    Wx, Wy = V.getxy()
    r = one()
# miller loop
    for i in range(nb - 2, 0, -1):
        r.sqr()
        lv = g(A, A, Qx, Qy)
        lv2 = g(B, B, Wx, Wy)
        lv.smul(lv2)
        r *= lv
        if big.bit(n3, i) == 1 and big.bit(n, i) == 0:
            lv = g(A, P, Qx, Qy)
            lv2 = g(B, U, Wx, Wy)
            lv.smul(lv2)
            r *= lv
        if big.bit(n3, i) == 0 and big.bit(n, i) == 1:
            lv = g(A, -P, Qx, Qy)
            lv2 = g(B, -U, Wx, Wy)
            lv.smul(lv2)
            r *= lv
# adjustment
    if curve.SignOfX == NEGATIVEX:
        r.conj()

    if curve.PairingFriendly == BN:
        KA = P.copy()
        KA.frobenius()
        if curve.SignOfX == NEGATIVEX:
            A = -A
            B = -B
        lv = g(A, KA, Qx, Qy)
        KA.frobenius()
        KA = -KA
        lv2 = g(A, KA, Qx, Qy)
        lv.smul(lv2)
        r *= lv

        KB = U.copy()
        KB.frobenius()

        lv = g(B, KB, Wx, Wy)
        KB.frobenius()
        KB = -KB
        lv2 = g(B, KB, Wx, Wy)
        lv.smul(lv2)
        r *= lv

    return r


def fexp(r):
    # final exp - easy part
    t0 = r.copy()
    r.conj()
    r *= t0.inverse()

    t0 = r.copy()
    r.powq()
    r.powq()
    r *= t0

# final exp - hard part
    x = curve.x

    if curve.PairingFriendly == BN:

        res = r.copy()

        t0 = res.copy()
        t0.powq()
        x0 = t0.copy()
        x0.powq()

        x0 *= (res * t0)
        x0.powq()

        x1 = res.copy()
        x1.conj()
        x4 = res.pow(x)
        if curve.SignOfX == POSITIVEX:
            x4.conj()
        x3 = x4.copy()
        x3.powq()

        x2 = x4.pow(x)
        if curve.SignOfX == POSITIVEX:
            x2.conj()

        x5 = x2.copy()
        x5.conj()
        t0 = x2.pow(x)
        if curve.SignOfX == POSITIVEX:
            t0.conj()

        x2.powq()
        res = x2.copy()
        res.conj()
        x4 = x4 * res
        x2.powq()

        res = t0.copy()
        res.powq()
        t0 *= res

        t0.usqr()
        t0 *= x4
        t0 *= x5
        res = x3 * x5
        res *= t0
        t0 *= x2
        res.usqr()
        res *= t0
        res.usqr()
        t0 = res * x1
        res *= x0
        t0.usqr()
        res *= t0

    else:  # its a BLS curve

        # Ghamman & Fouotsa Method
        y0 = r.copy()
        y0.usqr()
        y1 = y0.pow(x)
        if curve.SignOfX == NEGATIVEX:
            y1.conj()
        x //= 2
        y2 = y1.pow(x)
        if curve.SignOfX == NEGATIVEX:
            y2.conj()
        x *= 2

        y3 = r.copy()
        y3.conj()
        y1 *= y3
        y1.conj()
        y1 *= y2

        y2 = y1.pow(x)
        if curve.SignOfX == NEGATIVEX:
            y2.conj()
        y3 = y2.pow(x)
        if curve.SignOfX == NEGATIVEX:
            y3.conj()
        y1.conj()
        y3 *= y1

        y1.conj()
        y1.powq()
        y1.powq()
        y1.powq()

        y2.powq()
        y2.powq()

        y1 *= y2

        y2 = y3.pow(x)
        if curve.SignOfX == NEGATIVEX:
            y2.conj()
        y2 *= y0
        y2 *= r
        y1 *= y2
        y3.powq()
        y1 *= y3
        res = y1

    return res

# G=ecp.generator()
# P=ecp2.generator()
# pr=e(P,G)
# print(pr)

# print(pr.pow(curve.r))

# P7=7*P
# pr=e(P7,G)
# print(pr)

# G7=7*G
# pr=e(P,G7)
# print(pr)
