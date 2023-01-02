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
# Elliptic Curve Points
# Projective Weierstrass coordinates
# M.Scott August 2013
#
import copy
from bn254_py.constants import *

from bn254_py import big
from bn254_py import curve
from bn254_py.fp import Fp


class ECp:
    A = Fp(curve.A)
    B = Fp(curve.B)

    def __init__(self):
        self.x = Fp(0)
        self.y = Fp(1)
        if curve.CurveType == EDWARDS:
            self.z = Fp(1)
        else:
            self.z = Fp(0)

    def copy(self):
        return copy.deepcopy(self)

# convert to affine coordinates
    def affine(self):
        if self.isinf() or self.z.isone():
            return
        iz = self.z.inverse()  # iz / self.z
        self.x *= iz
        if curve.CurveType != MONTGOMERY:
            self.y *= iz
        self.z = Fp(1)
        return self

# check if point-at-infinity
    def isinf(self):
        if curve.CurveType == WEIERSTRASS:
            if self.x.iszero() and self.z.iszero():
                return True
        if curve.CurveType == EDWARDS:
            if self.x.iszero() and self.y == self.z:
                return True
        if curve.CurveType == MONTGOMERY:
            if self.z.iszero():
                return True
        return False

# set to point-at-infinity
    def inf(self):
        self.x = Fp(0)
        self.y = Fp(1)
        if curve.CurveType == EDWARDS:
            self.z = Fp(1)
        else:
            self.z = Fp(0)
        return self

    def set(self, x, s=0):			# set point from x and LSB of y
        mx = Fp(x)
        rhs = RHS(mx)
        if rhs.qr() != 1:
            return False
        self.x = mx
        self.z = Fp(1)

        if curve.CurveType != MONTGOMERY:
            self.y = rhs.sqrt()
            if big.bit(self.y.int(), 0) != s:
                self.y = -self.y
        return True

    def setxy(self, x, y):
        mx = Fp(x)
        my = Fp(y)
        if my * my != RHS(mx):
            return False
        self.x = mx
        self.y = my
        self.z = Fp(1)
        return True

    def get(self):				# return tuple Fp x and Fp y
        W = self.copy()
        if W.isinf():
            return (0, 0)
        W.affine()
        if curve.CurveType == MONTGOMERY:
            return W.x.int()
        return(W.x.int(), W.y.int())

    def getxs(self):				# return tuple integer x and LSB of y
        W = self.copy()
        if W.isinf():
            return (0, 0)
        W.affine()
        if curve.CurveType == MONTGOMERY:
            return (W.x.int(), 0)
        return (W.x.int(), big.bit(W.y.int(), 0))

    def getx(self):				# return just integer x
        W = self.copy()
        if W.isinf():
            return 0
        W.affine()
        return W.x.int()

# Return as Fps
    def getxy(self):
        W = self.copy()
        if (W.isinf()):
            return (Fp(0), Fp(0))
        W.affine()
        if curve.CurveType == MONTGOMERY:
            return W.x.copy()
        return (W.x.copy(), W.y.copy())

    def __eq__(self, other):
        zs = self.z
        zo = other.z
        if self.x * zo != other.x * zs:
            return False
        if curve.CurveType != MONTGOMERY:
            if self.y * zo != other.y * zs:
                return False
        return True

    def __ne__(self, other):
        return not(self == other)

    def __neg__(self):
        s = self.copy()
        if not s.isinf():
            if curve.CurveType == WEIERSTRASS:
                s.y = -s.y
            if curve.CurveType == EDWARDS:
                s.x = -s.x
        return s

# use exception-free formulae
    def dbl(self):
        if curve.CurveType == WEIERSTRASS:
            if ECp.A.iszero():
                t0 = self.y.copy()
                t0 = t0 * t0
                t1 = self.y.copy()
                t1 = t1 * self.z
                t2 = self.z.copy()
                t2 = t2 * t2
                self.z = t0 + t0

                self.z += self.z
                self.z += self.z
                t2 *= (ECp.B + ECp.B + ECp.B)
                x3 = t2 * self.z
                y3 = t0 + t2
                self.z *= t1
                t1 = t2 + t2
                t2 += t1
                t0 -= t2
                y3 *= t0
                y3 += x3
                t1 = self.x * self.y
                self.x = t0
                self.x *= t1
                self.x += self.x
                self.y = y3
            else:
                t0 = self.x.copy()
                t1 = self.y.copy()
                t2 = self.z.copy()
                t3 = self.x.copy()
                z3 = self.z.copy()
                #y3 = Fp(0)
                #x3 = Fp(0)
                b = ECp.B

                t0 *= t0
                t1 *= t1
                t2 *= t2

                t3 *= self.y
                t3 += t3

                z3 *= self.x
                z3 += z3

                y3 = t2 * b

                y3 -= z3
                x3 = y3 + y3

                y3 += x3
                x3 = t1 - y3
                y3 += t1
                y3 *= x3
                x3 *= t3
                t3 = t2 + t2
                t2 += t3
                z3 *= b

                z3 -= t2
                z3 -= t0
                t3 = z3 + z3

                z3 += t3
                t3 = t0 + t0
                t0 += t3
                t0 -= t2

                t0 *= z3
                y3 += t0
                t0 = self.y * self.z
                t0 += t0
                z3 *= t0
                x3 -= z3
                t0 += t0
                t1 += t1
                z3 = t0 * t1

                self.x = x3
                self.y = y3
                self.z = z3

        if curve.CurveType == EDWARDS:
            C = self.x.copy()
            D = self.y.copy()
            H = self.z.copy()
            #J = Fp(0)

            self.x *= self.y
            self.x += self.x
            C *= C
            D *= D

            if ECp.A == Fp(-1):
                C = -C

            self.y = C + D
            H *= H
            H += H

            self.z = self.y.copy()
            J = self.y.copy()

            J -= H
            self.x *= J

            C -= D
            self.y *= C
            self.z *= J

        if curve.CurveType == MONTGOMERY:
            A = self.x.copy()
            B = self.x.copy()
            #AA = Fp(0)
            #BB = Fp(0)
            #C = Fp(0)

            A += self.z
            AA = A * A
            B -= self.z
            BB = B * B
            #C = AA
            C = AA - BB
            self.x = AA * BB

            A = C * ((ECp.A + Fp(2)).div2().div2())

            BB += A
            self.z = BB * C

        return self

    def add(self, other):
        if curve.CurveType == WEIERSTRASS:
            if ECp.A.iszero():
                b = (ECp.B + ECp.B + ECp.B)
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
                t4 = self.y + self.z
                x3 = other.y + other.z

                t4 *= x3
                x3 = t1 + t2

                t4 -= x3
                x3 = self.x + self.z
                y3 = other.x + other.z
                x3 *= y3
                y3 = t0 + t2
                y3 = x3 - y3
                x3 = t0 + t0
                t0 += x3
                t2 *= b

                z3 = t1 + t2
                t1 -= t2
                y3 *= b

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

            else:

                t0 = self.x.copy()
                t1 = self.y.copy()
                t2 = self.z.copy()
                t3 = self.x.copy()
                t4 = other.x.copy()
                #z3 = Fp(0)
                y3 = other.x.copy()
                x3 = other.y.copy()
                b = ECp.B

                t0 *= other.x
                t1 *= other.y
                t2 *= other.z

                t3 += self.y
                t4 += other.y
                t3 *= t4
                t4 = t0 + t1
                t3 -= t4

                t4 = self.y + self.z
                x3 += other.z
                t4 *= x3
                x3 = t1 + t2

                t4 -= x3
                x3 = self.x + self.z
                y3 += other.z

                x3 *= y3
                y3 = t0 + t2

                y3 = x3 - y3
                z3 = t2 * b

                x3 = y3 - z3
                z3 = x3 + x3

                x3 += z3
                z3 = t1 - x3
                x3 += t1

                y3 *= b

                t1 = t2 + t2
                t2 += t1

                y3 -= t2

                y3 -= t0
                t1 = y3 + y3
                y3 += t1

                t1 = t0 + t0
                t0 += t1
                t0 -= t2
                t1 = t4 * y3
                t2 = t0 * y3
                y3 = x3 * z3
                y3 += t2
                x3 *= t3
                x3 -= t1
                z3 *= t4
                t1 = t3 * t0
                z3 += t1
                self.x = x3
                self.y = y3
                self.z = z3

        if curve.CurveType == EDWARDS:
            A = self.z.copy()
            #B = Fp(0)
            C = self.x.copy()
            D = self.y.copy()
            #E = Fp(0)
            #F = Fp(0)
            #G = Fp(0)
            b = ECp.B

            # print(self.z.int())

            A *= (other.z)
            B = A * A
            C *= (other.x)
            D *= (other.y)
            # print(other.z.int())
            E = C * D
            E *= b

            F = B - E
            G = B + E

            if (ECp.A == Fp(1)):
                E = D - C

            C += D

            B = self.x + self.y
            D = other.x + other.y
            B *= D
            B -= C
            B *= F
            self.x = A * B

            if ECp.A == Fp(1):
                C = E * G
            if ECp.A == Fp(-1):
                C *= G

            self.y = A * C

            self.z = F
            self.z *= G

        return self

# For Montgomery use only
    def dadd(self, Q, W):
        A = self.x.copy()
        B = self.x.copy()
        C = Q.x.copy()
        D = Q.x.copy()
        #DA = Fp(0)
        #CB = Fp(0)

        A += self.z
        B -= self.z

        C += Q.z
        D -= Q.z

        DA = D * A

        CB = C * B

        A = DA + CB
        A *= A
        B = DA - CB
        B *= B

        self.x = A
        self.z = W.x * B

        return self

    def __rmul__(self, other):   # use NAF
        R = ECp()
        if curve.CurveType == MONTGOMERY:
            e = other
            #D = ECp()
            R0 = self.copy()
            R1 = self.copy()
            R1.dbl()

            D = self.copy()
            nb = e.bit_length()
            # nb=curve.r.bit_length()
            for i in range(nb - 2, -1, -1):
                b = big.bit(e, i)
                R = R1.copy()

                R.dadd(R0, D)
                if b == 1:
                    R0, R1 = R1, R0
                R1 = R.copy()
                R0.dbl()
                if b == 1:
                    R0, R1 = R1, R0
            R = R0.copy()

        else:
            b = other
            b3 = 3 * b
            k = b3.bit_length()
            # k=curve.r.bit_length()+2;

            mself = -self
            for i in range(k - 1, 0, -1):
                R.dbl()
                if big.bit(b3, i) == 1 and big.bit(b, i) == 0:
                    R.add(self)
                if big.bit(b3, i) == 0 and big.bit(b, i) == 1:
                    R.add(mself)
        return R

    def __str__(self):			# pretty print
        W = self.copy()
        if W.isinf():
            return "infinity"
        W.affine()
        if curve.CurveType == MONTGOMERY:
            return "(%x)" % (W.x.int())
        return "(%x,%x)" % (W.x.int(), W.y.int())

# convert from and to an array of bytes
    def fromBytes(self, W):
        if curve.CurveType == MONTGOMERY:
            x = big.from_bytes(W[0:curve.EFS])
            return self.set(x)

        t = W[0]  # ord(W[0])
        sp1 = curve.EFS + 1	  # splits
        sp2 = sp1 + curve.EFS

        x = big.from_bytes(W[1:sp1])
        if t == 4:
            y = big.from_bytes(W[sp1:sp2])
            return self.setxy(x, y)
        else:
            if t == 2:
                return self.set(x, 0)
            if t == 3:
                return self.set(x, 1)
        self.inf()
        return False

# Can be compressed to just x
    def toBytes(self, compress):
        FS = curve.EFS
        if curve.CurveType == MONTGOMERY:
            PK = bytearray(FS)
            #PK[0] = 6
            x = self.get()
            W = big.to_bytes(x)
            for i in range(0, FS):
                PK[i] = W[i]
            return PK
        if compress:
            PK = bytearray(FS + 1)
            x, b = self.getxs()
            if b == 0:
                PK[0] = 2
            else:
                PK[0] = 3
            W = big.to_bytes(x)
            for i in range(0, FS):
                PK[1 + i] = W[i]
        else:
            PK = bytearray(2 * FS + 1)
            x, y = self.get()
            PK[0] = 4
            W = big.to_bytes(x)
            for i in range(0, FS):
                PK[1 + i] = W[i]
            W = big.to_bytes(y)
            for i in range(0, FS):
                PK[1 + i + FS] = W[i]

        return PK

def mul(P, a, Q, b):  # double multiplication a*P+b*Q
    # P.affine()
    # Q.affine()
    if a < 0:
        a = -a
        P = -P
    if b < 0:
        b = -b
        Q = -Q
    R = ECp()
    k = curve.r.bit_length()
    W = P.copy()
    W.add(Q)
    # W.affine()
    for i in range(k - 1, -1, -1):
        R.dbl()
        if (big.bit(a, i) == 1):
            if (big.bit(b, i) == 1):
                R.add(W)
            else:
                R.add(P)
        else:
            if (big.bit(b, i) == 1):
                R.add(Q)
    return R


# calculate Right Hand Side of elliptic curve equation y^2=RHS(x)

def RHS(x):
    if curve.CurveType == WEIERSTRASS:
        return x * x * x + ECp.A * x + ECp.B
    if curve.CurveType == EDWARDS:
        return (ECp.A * x * x - Fp(1)) * ((ECp.B * x * x - Fp(1)).inverse())
    if curve.CurveType == MONTGOMERY:
        return x * x * x + ECp.A * x * x + x

# get group generator point


def generator():
    G = ECp()
    if curve.CurveType == MONTGOMERY:
        G.set(curve.Gx)
    else:
        G.setxy(curve.Gx, curve.Gy)

    return G
