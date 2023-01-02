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
# Fp^12 CLass -  towered over Fp^4
# M.Scott August 2018
#

import copy
from bn254_py.constants import *
from bn254_py import big
from bn254_py import curve
from bn254_py.fp4 import Fp4
from bn254_py.fp2 import Fp2
from bn254_py.fp import Fp

class Fp12:

    def __init__(self, a=None, b=None, c=None):
        if b is None:
            if a is None:
                self.a = Fp4()
                self.b = Fp4()
                self.c = Fp4()
            else:
                self.a = a.copy()
                self.b = Fp4()
                self.c = Fp4()
        else:
            self.a = a.copy()
            self.b = b.copy()
            self.c = c.copy()

    def copy(self):
        return copy.deepcopy(self)

    def get(self):
        return(self.a, self.b, self.c)

    def set(self, a, b, c):
        self.a = a
        self.b = b
        self.c = c
        return self

    def __add__(self, other):
        R = Fp12(self.a + other.a, self.b + other.b, self.c + other.c)
        return R

    def __iadd__(self, other):
        self.a += other.a
        self.b += other.b
        self.c += other.c
        return self

    def __sub__(self, other):
        R = Fp12(self.a - other.a, self.b - other.b, self.c - other.c)
        return R

    def __isub__(self, other):
        self.a -= other.a
        self.b -= other.b
        self.c -= other.c
        return self

    def __eq__(self, other):
        return (self.a == other.a and self.b == other.b and self.c == other.c)

    def __ne__(self, other):
        return (self.a != other.a or self.b != other.b or self.c != other.c)

    def conj(self):
        self.a = self.a.conj()
        self.b = -self.b.conj()
        self.c = self.c.conj()
        return self

# unitary squaring
    def usqr(self):
        A = self.a.copy()
        self.a.sqr()
        D = self.a.copy()
        self.a += self.a
        self.a += D
        A = A.conj()
        A += A
        self.a -= A
        B = self.c.copy()
        B.sqr()
        B = B.mulQNR()
        D = B.copy()
        B += B
        B += D
        C = self.b.copy()
        C.sqr()
        D = C.copy()
        C += C
        C += D
        self.b = self.b.conj()
        self.b += self.b
        self.c = self.c.conj()
        self.c += self.c
        self.c = -self.c
        self.b += B
        self.c += C
        return self

# regular squaring
    def sqr(self):  # mutable
        if self.isone() :
            return
        A = self.a.copy()
        A.sqr()
        B = self.b * self.c
        B += B
        C = self.c.copy()
        C.sqr()
        D = self.a * self.b
        D += D
        self.c += (self.a + self.b)
        self.c.sqr()
        self.a = A + B.mulQNR()
        self.b = D + C.mulQNR()
        self.c -= (A + B + C + D)
        return self

# optimized to take advantage of sparse multiplier
    def __imul__(self, other):
        zero_c = other.c.iszero()
        zero_b = other.b.iszero()
        Z0 = self.a * other.a
        if not zero_b:
            Z2 = self.b * other.b
        T0 = self.a + self.b
        T1 = other.a + other.b
        Z1 = T0 * T1
        Z1 -= Z0
        if not zero_b:
            Z1 -= Z2
        T0 = self.b + self.c
        T1 = other.b + other.c
        Z3 = T0 * T1
        if not zero_b:
            Z3 -= Z2
        T0 = self.a + self.c
        T1 = other.a + other.c
        T0 *= T1
        if not zero_b:
            Z2 += T0
        else:
            Z2 = T0.copy()
        Z2 -= Z0
        self.b = Z1.copy()
        if not zero_c:
            T0 = self.c * other.c
            Z2 -= T0
            Z3 -= T0
            self.b += T0.mulQNR()
        self.a = Z0 + Z3.mulQNR()
        self.c = Z2.copy()

        return self

    def __mul__(self, other):
        R = self.copy()
        if R == other:
            R.sqr()
        else:
            R *= other
        return R

# multiply line functions
    def smul(self,other) :
        if curve.SexticTwist == D_TYPE :
            w1=self.a.a*other.a.a
            w2=self.a.b*other.a.b
            w3=self.b.a*other.b.a

            ta=self.a.a+self.a.b
            tb=other.a.a+other.a.b
            tc=ta*tb
            tc-=(w1+w2)

            ta=self.a.a+self.b.a
            tb=other.a.a+other.b.a
            td=ta*tb
            td-=(w1+w3)

            ta=self.a.b+self.b.a
            tb=other.a.b+other.b.a
            te=ta*tb
            te-=(w2+w3)

            w1+=w2.mulQNR()
            self.a=Fp4(w1,tc)
            self.b=Fp4(td,te)
            self.c=Fp4(w3)
        else :
            w1=self.a.a*other.a.a
            w2=self.a.b*other.a.b
            w3=self.c.b*other.c.b

            ta=self.a.a+self.a.b
            tb=other.a.a+other.a.b
            tc=ta*tb
            tc-=(w1+w2)
			
            ta=self.a.a+self.c.b
            tb=other.a.a+other.c.b
            td=ta*tb
            td-=(w1+w3)

            ta=self.a.b+self.c.b
            tb=other.a.b+other.c.b
            te=ta*tb
            te-=(w2+w3)

            w1+=w2.mulQNR()
            self.a=Fp4(w1,tc)

            self.b=Fp4(w3.mulQNR())
            self.b.times_i()

            self.c=Fp4(te.mulQNR(),td)

        return self

    def muls(self, other):  # multiple Fp12 by Fp4
        R = Fp12(self.a * other, self.b * other, self.c * other)
        return R

    def __neg__(self):
        R = Fp12(-self.a, -self.b, -self.c)
        return R

    def iszero(self):
        if self.a.iszero() and self.b.iszero() and self.c.iszero():
            return True
        return False

    def isone(self):
        if self.a.isone() and self.b.iszero() and self.c.iszero():
            return True
        return False

    def rand(self):  # mutable
        r = Fp4()
        r.rand()
        self.a = r.copy()
        r.rand()
        self.b = r.copy()
        r.rand()
        self.c = r.copy()
        return self

    def pow(self, other):  # unitary only
        e = other
        e3 = e * 3
        k = e3.bit_length()
        x = self.copy()
        r = self.copy()

        for i in range(k - 2, 0, -1):
            r.usqr()
            if big.bit(e3, i) == 1 and big.bit(e, i) == 0:
                r *= x
            if big.bit(e3, i) == 0 and big.bit(e, i) == 1:
                x.conj()
                r *= x
                x.conj()
        return r

    def __str__(self):			# pretty print
        return "[%s,%s,%s]" % (self.a, self.b, self.c)

    def mulQNR(self):				# assume p=3 mod 8, QNR=1+i
        return Fp12(self.c.mulQNR(), self.a, self.b)

    def inverse(self):
        wa = self.a * self.a - (self.b * self.c).mulQNR()
        wb = (self.c * self.c).mulQNR() - self.a * self.b
        wc = self.b * self.b - self.a * self.c
        f = ((self.b * wc).mulQNR() + self.a *
             wa + (self.c * wb).mulQNR()).inverse()
        return Fp12(wa * f, wb * f, wc * f)

    def powq(self):
        X = Fp2(Fp(curve.Fra), Fp(curve.Frb))
        X2 = Fp2(Fp(curve.Fra), Fp(curve.Frb))
        X2.sqr()
        self.a = self.a.powq()
        self.b = self.b.powq().muls(X)
        self.c = self.c.powq().muls(X2)
        return self

    def trace(self):
        R = self.a.copy()
        R += R
        R += self.a
        return R

    def fromBytes(self, E):
        FS = curve.EFS
        a = Fp4(Fp2(Fp(big.from_bytes(E[0:FS])),
                    Fp(big.from_bytes(E[FS:2 * FS]))),
                Fp2(Fp(big.from_bytes(E[2 * FS:3 * FS])),
                    Fp(big.from_bytes(E[3 * FS:4 * FS]))))
        b = Fp4(Fp2(Fp(big.from_bytes(E[4 * FS:5 * FS])),
                    Fp(big.from_bytes(E[5 * FS:6 * FS]))),
                Fp2(Fp(big.from_bytes(E[6 * FS:7 * FS])),
                    Fp(big.from_bytes(E[7 * FS:8 * FS]))))
        c = Fp4(Fp2(Fp(big.from_bytes(E[8 * FS:9 * FS])),
                    Fp(big.from_bytes(E[9 * FS:10 * FS]))),
                Fp2(Fp(big.from_bytes(E[10 * FS:11 * FS])),
                    Fp(big.from_bytes(E[11 * FS:12 * FS]))))

        self.set(a, b, c)

    def toBytes(self):
        FS = curve.EFS
        a, b, c = self.get()

        aa, ab = a.get()
        aaa, aab = aa.get()
        aba, abb = ab.get()

        ba, bb = b.get()
        baa, bab = ba.get()
        bba, bbb = bb.get()

        ca, cb = c.get()
        caa, cab = ca.get()
        cba, cbb = cb.get()

        E = bytearray(12 * FS)

        W = big.to_bytes(aaa)
        for i in range(0, FS):
            E[i] = W[i]
        W = big.to_bytes(aab)
        for i in range(0, FS):
            E[FS + i] = W[i]
        W = big.to_bytes(aba)
        for i in range(0, FS):
            E[2 * FS + i] = W[i]
        W = big.to_bytes(abb)
        for i in range(0, FS):
            E[3 * FS + i] = W[i]
        W = big.to_bytes(baa)
        for i in range(0, FS):
            E[4 * FS + i] = W[i]
        W = big.to_bytes(bab)
        for i in range(0, FS):
            E[5 * FS + i] = W[i]
        W = big.to_bytes(bba)
        for i in range(0, FS):
            E[6 * FS + i] = W[i]
        W = big.to_bytes(bbb)
        for i in range(0, FS):
            E[7 * FS + i] = W[i]
        W = big.to_bytes(caa)
        for i in range(0, FS):
            E[8 * FS + i] = W[i]
        W = big.to_bytes(cab)
        for i in range(0, FS):
            E[9 * FS + i] = W[i]
        W = big.to_bytes(cba)
        for i in range(0, FS):
            E[10 * FS + i] = W[i]
        W = big.to_bytes(cbb)
        for i in range(0, FS):
            E[11 * FS + i] = W[i]

        return E

def one():
    return Fp12(Fp4(Fp2(Fp(1))))

def zero():
    return Fp12(Fp4(Fp2(Fp(0))))
