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
# Elliptic Curve Points over Fp^2
# Projective Weierstrass coordinates
# M.Scott August 2013
#

import copy
from bn254_py.constants import *
from bn254_py import big
from bn254_py import curve
from bn254_py.fp2 import Fp2
from bn254_py.fp import Fp
from bn254_py.ecp import ECp


class ECp2:

    def __init__(self):
        self.x = Fp2()
        self.y = Fp2(Fp(1))
        self.z = Fp2()

    def copy(self):
        return copy.deepcopy(self)

# convert to affine coordinates
    def affine(self):
        if self.isinf() or self.z.isone():
            return self
        iz = self.z.inverse()
        self.x *= iz
        self.y *= iz
        self.z = Fp2(Fp(1))
        return self

# check if point-at-infinity
    def isinf(self):
        if self.x.iszero() and self.z.iszero():
            return True
        return False

# set point to (x,y)
    def set(self, x, y):
        mx = x.copy()
        my = y.copy()
        if my * my != RHS(mx):
            return False
        self.x = mx
        self.y = my
        self.z = Fp2(Fp(1))
        return True

    def setx(self,x,s):
        mx = x.copy()
        rhs = RHS(mx)
        if rhs.qr() != 1:
            return False
        rhs.sqrt()
        if rhs.sign() != s:
            rhs = - rhs
        self.x = mx
        self.y = rhs
        self.z = Fp2(Fp(1))
        return True

    def get(self):				# return tuple Fp2 x and Fp2 y
        W = self.copy()
        if (W.isinf()):
            return (Fp2(), Fp2())
        W.affine()
        return(W.x, W.y)

    def getZ(self):
        return self.z.copy()

    def getxyz(self):
        return (self.x.copy(), self.y.copy(), self.z.copy())

    def getxy(self):
        return (self.x.copy(), self.y.copy())

    def __eq__(self, other):
        zs = self.z
        zo = other.z
        if self.x * zo != other.x * zs:
            return False
        if self.y * zo != other.y * zs:
            return False
        return True

    def __ne__(self, other):
        return not(self == other)

    def __neg__(self):
        s = self.copy()
        s.y = -s.y
        return s

# use exeption free formulae
    def dbl(self):
        iy = self.y.copy()
        if curve.SexticTwist == D_TYPE:
            iy = iy.mulQNR()
        t0 = self.y.copy()
        t0.sqr()
        if curve.SexticTwist == D_TYPE:
            t0 = t0.mulQNR()

        t1 = iy.copy()
        t1 = t1 * self.z
        t2 = self.z.copy()
        t2.sqr()

        self.z = t0 + t0
        self.z += self.z
        self.z += self.z

        t2 = t2.muli(3 * curve.B)
        if curve.SexticTwist == M_TYPE:
            t2 = t2.mulQNR()
        x3 = t2 * self.z

        y3 = t0 + t2
        self.z *= t1
        t1 = t2 + t2
        t2 += t1
        t0 -= t2
        y3 *= t0
        y3 += x3
        t1 = self.x * iy
        self.x = t0
        self.x *= t1
        self.x += self.x
        self.y = y3
        return self

    def add(self, other):
        t0 = self.x.copy()
        t0 *= other.x
        t1 = self.y.copy()
        t1 *= other.y
        t2 = self.z.copy()
        t2 = t2 * other.z
        t3 = self.x.copy()
        t3 += self.y
        t4 = other.x + other.y
        t3 *= t4
        t4 = t0 + t1

        t3 -= t4
        if curve.SexticTwist == D_TYPE:
            t3 = t3.mulQNR()
        t4 = self.y + self.z
        x3 = other.y + other.z

        t4 *= x3
        x3 = t1 + t2

        t4 -= x3
        if curve.SexticTwist == D_TYPE:
            t4 = t4.mulQNR()

        x3 = self.x + self.z
        y3 = other.x + other.z
        x3 *= y3
        y3 = t0 + t2
        y3 = x3 - y3

        if curve.SexticTwist == D_TYPE:
            t0 = t0.mulQNR()
            t1 = t1.mulQNR()

        x3 = t0 + t0
        t0 += x3
        t2 = t2.muli(3 * curve.B)
        if curve.SexticTwist == M_TYPE:
            t2 = t2.mulQNR()
        z3 = t1 + t2
        t1 -= t2
        y3 = y3.muli(3 * curve.B)
        if curve.SexticTwist == M_TYPE:
            y3 = y3.mulQNR()
        x3 = y3 * t4
        t2 = t3 * t1
        x3 = t2 - x3
        y3 *= t0
        t1 *= z3
        y3 += t1
        t0 *= t3
        z3 *= t4
        z3 += t0

        self.x = x3
        self.y = y3
        self.z = z3
        return self

    def __rmul__(self, other):   # use NAF
        b = other
        b3 = 3 * b
        k = b3.bit_length()
        #k = curve.r.bit_length()+2
        # self.affine()
        mself = -self
        R = ECp2()
        for i in range(k - 1, 0, -1):
            R.dbl()
            if big.bit(b3, i) == 1 and big.bit(b, i) == 0:
                R.add(self)
            if big.bit(b3, i) == 0 and big.bit(b, i) == 1:
                R.add(mself)
        return R

# calculate p.P(x,y) using frobenius
    def frobenius(self):
        X = Fp2(Fp(curve.Fra), Fp(curve.Frb))
        if curve.SexticTwist == M_TYPE:
            X = X.inverse()
        X2 = X.copy()
        X2.sqr()
        # self.affine()
        self.x = self.x.conj()
        self.y = self.y.conj()
        self.z = self.z.conj()
        self.x *= X2
        self.y *= X2
        self.y *= X
        return self

    def __str__(self):			# pretty print
        W = self.copy()
        if W.isinf():
            return "infinity"
        W.affine()
        return "[%s,%s]" % (W.x, W.y)

# convert from and to an array of bytes
    def fromBytes(self, W):
        FS = curve.EFS
        typ = W[0]
        xa = big.from_bytes(W[1:FS+1])
        xb = big.from_bytes(W[FS+1:2 * FS+1])
        x = Fp2(Fp(xa), Fp(xb))
        if typ == 0x04:
            ya = big.from_bytes(W[2 * FS+1:3 * FS+1])
            yb = big.from_bytes(W[3 * FS+1:4 * FS+1])
            y = Fp2(Fp(ya), Fp(yb))
            return self.set(x, y)
        else :
            return self.setx(x,typ&1)

    def toBytes(self,compress):
        FS = curve.EFS
        if compress:
            PK = bytearray(2 * FS + 1)
        else :
            PK = bytearray(4 * FS + 1)
        x, y = self.get()
        xa, xb = x.get()
        ya, yb = y.get()
        W = big.to_bytes(xa)
        for i in range(0, FS):
            PK[i+1] = W[i]
        W = big.to_bytes(xb)
        for i in range(0, FS):
            PK[FS + i + 1] = W[i]
        if not compress:
            PK[0]=0x04
            W = big.to_bytes(ya)
            for i in range(0, FS):
                PK[2 * FS + i + 1] = W[i]
            W = big.to_bytes(yb)
            for i in range(0, FS):
                PK[3 * FS + i + 1] = W[i]
        else :
            PK[0]=0x02
            if y.sign() == 1:
                PK[0]=0x03
        return PK

# calculate Right Hand Side of elliptic curve equation y^2=RHS(x)


def RHS(x):
    if curve.SexticTwist == D_TYPE:
        return x * x * x + Fp2(ECp.B).divQNR()  # on the sextic twist
    else:
        return x * x * x + Fp2(ECp.B).mulQNR()  # on the sextic twist

# get group generator point


def generator():
    P = ECp2()
    P.set(Fp2(Fp(curve.Pxa), Fp(curve.Pxb)), Fp2(Fp(curve.Pya), Fp(curve.Pyb)))
    return P

# P=generator()
# print(curve.r*P)
# P.dbl()
# XX,YY,ZZ=P.getxyz()
#print("P= ",XX,YY,ZZ)

# XX,YY,ZZ=P.getxyz()
#print("P= ",XX,YY,ZZ)
# P.dbl()
# XX,YY,ZZ=P.getxyz()
#print("P= ",XX,YY,ZZ)


# print(P.frobenius())

#X=Fp2(Fp(curve.Fra), Fp(curve.Frb))
# X2=X*X
# X3=X*X*X
# print(X3)
